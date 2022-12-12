unit Produtos;

interface

uses
  System.Generics.Collections,
  System.Classes,
  FireDAC.Comp.Client,
  Constantes,
  ConstantesSQL,
  Conexao,
  Funcoes.Logs,
  Vcl.Dialogs,
  System.SysUtils;

type
  TTipoBuscaProduto = (tbpCodigo, tbpDescricao);

  TProduto = class
  private
    FListaProdutos: TObjectList<TProduto>;
    FCodigo: integer;
    FDescricao: string;
    FValorUnitario: double;
  public
    constructor Create;
    destructor Destroy;

    property ListaProdutos: TObjectList<TProduto> read FListaProdutos write FListaProdutos;
    property Codigo: integer read FCodigo write FCodigo;
    property Descricao: string read FDescricao write FDescricao;
    property ValorUnitario: double read FValorUnitario write FValorUnitario;

    procedure Adiciona(Produto: TProduto);
    procedure Salvar(Produto: TProduto);
    procedure Alterar(Produto: TProduto);
    procedure Deletar(Produto: TProduto);
    procedure CarregarTodosProdutos;
    procedure Buscar(var Produto: TProduto; TipoBusca: TTipoBuscaProduto);
  end;

implementation

{ TListaCliente }

procedure TProduto.Adiciona(Produto: TProduto);
begin
  ListaProdutos.Add(Produto);
end;

procedure TProduto.Salvar(Produto: TProduto);
begin
  var Query := ConexaoDB.CriaQuery;

  Query.ConnectionName := NomeConexao;
  Query.SQL.Text := sqlInsertProdutos;
  Query.ParamByName('descricao').AsString := Produto.FDescricao;
  Query.ParamByName('preco_venda').AsFloat := Produto.FValorUnitario;

  ConexaoDB.PostSQL(Query);
  FreeAndNil(Query);
end;

procedure TProduto.Alterar(Produto: TProduto);
begin
  var Query := ConexaoDB.CriaQuery;

  Query.ConnectionName := NomeConexao;
  Query.SQL.Text := sqlUpdateProdutos;
  Query.ParamByName('descricao').AsString := Produto.FDescricao;
  Query.ParamByName('preco_venda').AsFloat := Produto.FValorUnitario;
  Query.ParamByName('codigo').AsInteger := Produto.FCodigo;

  ConexaoDB.PostSQL(Query);
  FreeAndNil(Query);
end;

procedure TProduto.Deletar(Produto: TProduto);
begin
  var Query := ConexaoDB.CriaQuery;

  Query.ConnectionName := NomeConexao;
  Query.SQL.Text := sqlDeleteProdutos;
  Query.ParamByName('codigo').AsInteger := Produto.FCodigo;

  ConexaoDB.PostSQL(Query);

  FreeAndNil(Query);
end;

procedure TProduto.Buscar(var Produto: TProduto; TipoBusca: TTipoBuscaProduto);
begin
  var Query := ConexaoDB.CriaQuery;
  var SQL := sqlSelectProdutos;

  case TipoBusca of
    tbpCodigo: SQL := SQL + ' where codigo = ' + Codigo.ToString;
    tbpDescricao: SQL := SQL + ' where descricao = ' + QuotedStr(Produto.Descricao);
  end;

  Query.Open(SQL);

  Produto.FCodigo := Query.FieldByName('codigo').AsInteger;
  Produto.FDescricao := Query.FieldByName('descricao').AsString;
  Produto.FValorUnitario := Query.FieldByName('codigo').AsFloat;

  FreeAndNil(Query);
end;

procedure TProduto.CarregarTodosProdutos;
begin
  var Query := ConexaoDB.CriaQuery;

  Query.Open(sqlSelectProdutos);
  Query.First;
  while not Query.Eof do
  begin
    var Produto := TProduto.Create;

    Produto.FCodigo := Query.FieldByName('codigo').AsInteger;
    Produto.FDescricao := Query.FieldByName('descricao').AsString;
    Produto.FValorUnitario := Query.FieldByName('codigo').AsFloat;

    Adiciona(Produto);
    Query.Next;
  end;

  FreeAndNil(Query);
end;

constructor TProduto.Create;
begin
  inherited;
  ListaProdutos := TObjectList<TProduto>.Create;
end;

destructor TProduto.Destroy;
begin
  inherited;
  FListaProdutos.Destroy;
end;

end.
