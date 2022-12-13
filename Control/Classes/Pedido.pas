unit Pedido;

interface

uses
  Produtos,
  System.Generics.Collections,
  Clientes,
  System.DateUtils,
  System.SysUtils,
  Conexao,
  ConstantesSQL,
  Constantes,
  FireDAC.Comp.Client;

type
  TPedidoProdutos = class
  private
    FId: integer;
    FProduto: TProduto;
    FNumeroPedido: integer;
    FQuantidade: double;
    FValorUnitario: double;
    FValorTotal: double;
    procedure AtualizaValorTotal;
    function GetQuantidade: double;
    function GetValorUnitario: double;
    procedure SetQuantidade(const Value: double);
    procedure SetValorUnitario(const Value: double);
  public
    constructor Create;
    destructor Destroy;

    property ID: integer read FID write FID;
    property Produto: TProduto read FProduto write FProduto;
    property NumeroPedido: integer read FNumeroPedido write FNumeroPedido;
    property Quantidade: double read GetQuantidade write SetQuantidade;
    property ValorUnitario: double read GetValorUnitario write SetValorUnitario;
    property ValorTotal: double read FValorTotal write FValorTotal;
  end;

  TPedidoGeral = class
  private
    FNumero: integer;
    FDataEmissao: TDateTime;
    FCliente: TCliente;
    FValorTotal:  double;
    FProdutos: TObjectList<TPedidoProdutos>;
    FPedidosLista: TObjectList<TPedidoGeral>;
    procedure RecalculaTotalPedido;
  public
    property Numero: integer read FNumero write FNumero;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property ValorTotal: double read FValorTotal write FValorTotal;
    property Cliente: TCliente read FCliente write FCliente;
    property Produtos: TObjectList<TPedidoProdutos> read FProdutos write FProdutos;
    property PedidosLista: TObjectList<TPedidoGeral> read FPedidosLista write FPedidosLista;

    constructor Create;
    destructor Destroy;

    procedure AdicionaProduto(Produto: TPedidoProdutos);
    procedure DeletaProduto(Index: integer);
    procedure RemoverProduto(pProduto: TPedidoProdutos);
    procedure SalvarPedido(pPedido: TPedidoGeral);
    procedure DeletarPedido(pPedido: TPedidoGeral);
    procedure AlterarPedido(pPedido: TPedidoGeral);
    procedure CarregarTodosPedidos;
    procedure CarregarUltimoPedido(var pPedido: TPedidoGeral);
    function CarregarPedidoNumero(NumeroPedido: integer) : TPedidoGeral;
  end;

  var Pedidos : TPedidoGeral;

implementation

procedure TPedidoProdutos.AtualizaValorTotal;
begin
  ValorTotal := FQuantidade * FValorUnitario;
end;

{ TPedidoProdutos }

constructor TPedidoProdutos.Create;
begin
  inherited;
  Produto := TProduto.Create;
end;

destructor TPedidoProdutos.Destroy;
begin
  FreeAndNil(Produto);
  inherited;
end;

function TPedidoProdutos.GetQuantidade: double;
begin
  Result := FQuantidade;
end;

function TPedidoProdutos.GetValorUnitario: double;
begin
  Result := FValorUnitario;
end;

procedure TPedidoProdutos.SetQuantidade(const Value: double);
begin
  FQuantidade := Value;
  AtualizaValorTotal;
end;

procedure TPedidoProdutos.SetValorUnitario(const Value: double);
begin
  FValorUnitario := Value;
  AtualizaValorTotal;
end;

{ TPedidoGeral }

procedure TPedidoGeral.AdicionaProduto(Produto: TPedidoProdutos);
begin
  Pedidos.Produtos.Add(Produto);
end;

procedure TPedidoGeral.AlterarPedido(pPedido: TPedidoGeral);
begin
  var Query := ConexaoDB.CriaQuery;

  Query.SQL.Text := sqlUpdatePedidosGeral;
  Query.ParamByName('numero').AsInteger := pPedido.Numero;
  Query.ParamByName('data_emissao').AsDateTime := pPedido.DataEmissao;
  Query.ParamByName('cliente_codigo').AsInteger := pPedido.Cliente.Codigo;
  Query.ParamByName('valor_total').AsFloat := pPedido.ValorTotal;

  ConexaoDB.PostSQL(Query);

  Query.Close;
  Query.SQL.Text := sqlDeletePedidosProdutos;
  Query.ParamByName('pedido_numero').Asinteger := pPedido.Numero;
  ConexaoDB.PostSQL(Query);

  Query.Close;
  for var I := 0 to pPedido.FProdutos.Count-1 do
  begin
    var UltimoPedido := TPedidoGeral.Create;
    CarregarUltimoPedido(UltimoPedido);

    Query.SQL.Text := sqlInsertPedidosProdutos;
    Query.ParamByName('pedido_numero').Asinteger := UltimoPedido.Numero;
    Query.ParamByName('produto_codigo').AsInteger := pPedido.FProdutos[I].FProduto.Codigo;
    Query.ParamByName('quantidade').AsFloat := pPedido.FProdutos[I].FQuantidade;
    Query.ParamByName('vlr_unitario').AsFloat := pPedido.FProdutos[I].FValorUnitario;
    Query.ParamByName('vlr_total').AsFloat := pPedido.FProdutos[I].FValorTotal;

    ConexaoDB.PostSQL(Query);
  end;

  FreeAndNil(Query);
end;

function TPedidoGeral.CarregarPedidoNumero(NumeroPedido: integer): TPedidoGeral;
begin
  CarregarTodosPedidos;
  for var I := 0 to PedidosLista.Count-1 do
  begin
    if PedidosLista.Items[i].Numero = NumeroPedido then
    begin
      Result := PedidosLista.Items[i];
      break;
    end;
  end;
end;

procedure TPedidoGeral.CarregarTodosPedidos;
begin
  var Query := ConexaoDB.CriaQuery;
  var QueryProdutos := ConexaoDB.CriaQuery;

  Query.Open(sqlSelectPedidosGeral);
  Query.First;

  while not Query.Eof do
  begin
    var PedidoSalvar := TPedidoGeral.Create;

    PedidoSalvar.Numero := Query.FieldByName('numero').AsInteger;
    PedidoSalvar.FDataEmissao := Query.FieldByName('data_emissao').AsDateTime;
    PedidoSalvar.FValorTotal := Query.FieldByName('valor_total').AsFloat;
    PedidoSalvar.Cliente.Codigo := Query.FieldByName('cliente_codigo').AsInteger;
    PedidoSalvar.Cliente.Buscar(PedidoSalvar.FCliente, tbCodigo);

    QueryProdutos.SQL.Text := sqlSelectPedidosProdutos;
    QueryProdutos.ParamByName('pedido_numero').AsInteger := PedidoSalvar.Numero;
    QueryProdutos.Open();
    QueryProdutos.First;

    while not QueryProdutos.Eof do
    begin
      var PedidoProduto := TPedidoProdutos.Create;

      PedidoProduto.Id := QueryProdutos.FieldByName('id').AsInteger;
      PedidoProduto.NumeroPedido := PedidoSalvar.Numero;
      PedidoProduto.Quantidade := QueryProdutos.FieldByName('quantidade').AsFloat;
      PedidoProduto.ValorUnitario := QueryProdutos.FieldByName('vlr_unitario').AsFloat;
      PedidoProduto.ValorTotal := QueryProdutos.FieldByName('vlr_total').AsFloat;

      var BuscarProduto := TProduto.Create;
      PedidoProduto.Produto.Codigo := QueryProdutos.FieldByName('produto_codigo').AsInteger;
      PedidoProduto.Produto.Buscar(BuscarProduto, tbpCodigo);
      PedidoProduto.Produto := BuscarProduto;

      PedidoSalvar.Produtos.Add(PedidoProduto);

      QueryProdutos.Next;
    end;

    Pedidos.FPedidosLista.Add(PedidoSalvar);
    Query.Next;
  end;

  FreeAndNil(Query);
  FreeAndNil(QueryProdutos);
end;

procedure TPedidoGeral.CarregarUltimoPedido(var pPedido: TPedidoGeral);
begin
  CarregarTodosPedidos;
  pPedido := Pedidos.FPedidosLista.Items[Pedidos.PedidosLista.Count-1];
end;

constructor TPedidoGeral.Create;
begin
  inherited;
  FProdutos := TObjectList<TPedidoProdutos>.Create;
  FCliente := TCLiente.Create;
  FPedidosLista := TObjectList<TPedidoGeral>.Create;
end;

procedure TPedidoGeral.DeletarPedido(pPedido: TPedidoGeral);
begin
  var Query := ConexaoDB.CriaQuery;

  Query.ConnectionName := NomeConexao;
  Query.SQL.Text := sqlDeletePedidosProdutos;
  Query.ParamByName('pedido_numero').AsInteger := pPedido.Numero;
  ConexaoDB.PostSQL(Query);

  Query.Close;
  Query.SQL.Text := sqlDeletePedidosGeral;
  Query.ParamByName('numero').AsInteger := pPedido.Numero;
  ConexaoDB.PostSQL(Query);

  FreeAndNil(Query);
end;

destructor TPedidoGeral.Destroy;
begin
  FreeAndNil(FProdutos);
  FreeAndNil(FPedidosLista);
end;

procedure TPedidoGeral.RemoverProduto(pProduto: TPedidoProdutos);
begin
  Pedidos.Produtos.Extract(pProduto);
  RecalculaTotalPedido;
end;

procedure TPedidoGeral.DeletaProduto(Index: integer);
begin
  Pedidos.Produtos.Delete(Index);
  RecalculaTotalPedido;
end;

procedure TPedidoGeral.RecalculaTotalPedido;
begin
  Pedidos.ValorTotal := 0;
  for var I := 0 to Pedidos.Produtos.Count-1 do
    Pedidos.ValorTotal := Pedidos.ValorTotal + Pedidos.Produtos.Items[i].ValorTotal;
end;

procedure TPedidoGeral.SalvarPedido(pPedido: TPedidoGeral);
begin
  var Query := ConexaoDB.CriaQuery;

  Query.SQL.Text := sqlInsertPedidosGeral;
  Query.ParamByName('data_emissao').AsDateTime := pPedido.FDataEmissao;
  Query.ParamByName('cliente_codigo').AsInteger := pPedido.FCliente.Codigo;
  Query.ParamByName('valor_total').AsFloat := pPedido.FValorTotal;

  ConexaoDB.PostSQL(Query);

  Query.Close;
  for var I := 0 to pPedido.Produtos.Count-1 do
  begin
    var UltimoPedido := TPedidoGeral.Create;
    CarregarUltimoPedido(UltimoPedido);

    Query.SQL.Text := sqlInsertPedidosProdutos;
    Query.ParamByName('pedido_numero').Asinteger := UltimoPedido.Numero;
    Query.ParamByName('produto_codigo').AsInteger := pPedido.FProdutos[I].FProduto.Codigo;
    Query.ParamByName('quantidade').AsFloat := pPedido.FProdutos[I].FQuantidade;
    Query.ParamByName('vlr_unitario').AsFloat := pPedido.FProdutos[I].FValorUnitario;
    Query.ParamByName('vlr_total').AsFloat := pPedido.FProdutos[I].FValorTotal;

    ConexaoDB.PostSQL(Query);
  end;

  FreeAndNil(Query);
end;

initialization
  Pedidos := TPedidoGeral.Create;

finalization
  Pedidos.Free;

end.
