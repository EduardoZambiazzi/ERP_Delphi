unit Clientes;

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
  TTipoBusca = (tbCodigo, tbNome);

  TCliente = class
  private
    FCodigo: integer;
    FNome: string;
    FCidade: string;
    FUF: string;
    FListaCliente : TObjectList<TCliente>;
  public
    constructor Create;
    destructor Destroy;

    property ListaCliente: TObjectList<TCliente> read FListaCliente write FListaCliente;
    property Codigo: integer read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;

    procedure Adiciona(pCliente: TCliente);
    procedure Salvar(pCliente: TCliente);
    procedure Alterar(pCliente: TCliente);
    procedure Deletar(pCliente: TCliente);
    procedure CarregarTodosClientes;
    procedure Buscar(var pCliente: TCLiente; TipoBusca: TTipoBusca);
    procedure CarregarUltimoCliente(var pCliente: TCLiente);
  end;

  var Cliente : TCliente;

implementation

{ TListaCliente }


procedure TCliente.Adiciona(pCliente: TCliente);
begin
  Cliente.ListaCliente.Add(pCliente);
end;

procedure TCliente.Salvar(pCliente: TCliente);
begin
  var Query := ConexaoDB.CriaQuery;

  Query.SQL.Text := sqlInsertClientes;
  Query.ParamByName('nome').AsString := pCliente.Nome;
  Query.ParamByName('cidade').AsString := pCliente.Cidade;
  Query.ParamByName('uf').AsString := pCliente.UF;

  ConexaoDB.PostSQL(Query);

  FreeAndNil(Query);
end;

procedure TCliente.Alterar(pCliente: TCliente);
begin
  var Query := ConexaoDB.CriaQuery;

  Query.SQL.Text := sqlUpdateClientes;
  Query.ParamByName('nome').AsString := pCliente.FNome;
  Query.ParamByName('cidade').AsString := pCliente.FCidade;
  Query.ParamByName('uf').AsString := pCliente.FUF;
  Query.ParamByName('codigo').Asinteger := pCliente.FCodigo;

  ConexaoDB.PostSQL(Query);

  FreeAndNil(Query);
end;

procedure TCliente.Deletar(pCliente: TCliente);
begin
  var Query := ConexaoDB.CriaQuery;

  Query.ConnectionName := NomeConexao;
  Query.SQL.Text := sqlDeleteClientes;
  Query.ParamByName('codigo').AsInteger := pCliente.Codigo;

  ConexaoDB.PostSQL(Query);

  FreeAndNil(Query);
end;

destructor TCliente.Destroy;
begin
  inherited;
  FListaCliente.Destroy;
end;

procedure TCliente.Buscar(var pCliente: TCLiente; TipoBusca: TTipoBusca);
begin
  var Query := ConexaoDB.CriaQuery;
  var SQL := sqlSelectClientes;

  case TipoBusca of
    tbCodigo: SQL := SQL + ' where codigo = ' + pCliente.Codigo.ToString ;
    tbNome: SQL := SQL + ' where nome = ' + QuotedStr(pCliente.Nome.DeQuotedString);
  end;

  Query.Open(SQL);

  pCliente.Codigo := Query.FieldByName('codigo').AsInteger;
  pCliente.Nome := Query.FieldByName('nome').AsString;
  pCliente.Cidade := Query.FieldByName('cidade').AsString;
  pCliente.UF := Query.FieldByName('uf').AsString;

  FreeAndNil(Query);
end;

procedure TCliente.CarregarTodosClientes;
begin
  var Query := ConexaoDB.CriaQuery;

  Query.Open(sqlSelectClientes);
  Query.First;

  while not Query.Eof do
  begin
    var ClienteAdd := TCliente.Create;

    ClienteAdd.Codigo := Query.FieldByName('codigo').AsInteger;
    ClienteAdd.Nome := Query.FieldByName('nome').AsString;
    ClienteAdd.Cidade := Query.FieldByName('cidade').AsString;
    ClienteAdd.UF := Query.FieldByName('uf').AsString;

    Adiciona(ClienteAdd);
    Query.Next;
  end;

  FreeAndNil(Query);
end;

procedure TCliente.CarregarUltimoCliente(var pCliente: TCLiente);
begin
  CarregarTodosClientes;
  pCliente := Cliente.ListaCliente.Items[Cliente.FListaCliente.Count-1];
end;

constructor TCliente.Create;
begin
  inherited;
  ListaCliente := TObjectList<TCliente>.Create;
end;

initialization
  Cliente := TCliente.Create;

finalization
  Cliente.Free;

end.
