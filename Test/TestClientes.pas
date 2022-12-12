unit TestClientes;

interface

uses
  TestFramework,
  FireDAC.Comp.Client,
  Funcoes.Logs,
  Constantes,
  System.Generics.Collections,
  System.SysUtils,
  Vcl.Dialogs,
  Clientes,
  Conexao,
  ConstantesSQL,
  System.Classes;

type

  TestTListaClientes = class(TTestCase)
  strict private
    FSUT: TCliente;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAdiciona;
    procedure TestSalvar;
    procedure TestAlterar;
    procedure TestDeletar;
  end;

implementation

procedure TestTListaClientes.SetUp;
begin
  FSUT := TCliente.Create;
end;

procedure TestTListaClientes.TearDown;
begin
  FSUT.Free;
  FSUT := nil;
end;

procedure TestTListaClientes.TestAdiciona;
begin
  var QuantidadeRegistros := FSUT.ListaCliente.Count;

  Cliente.Codigo := 999999;
  Cliente.Nome := 'Cliente Teste';
  Cliente.Cidade := 'Cidade Teste';
  Cliente.UF := 'SP';

  FSUT.Adiciona(Cliente);

  CheckTrue(QuantidadeRegistros < Cliente.ListaCliente.Count);
end;

procedure TestTListaClientes.TestSalvar;
begin
  Cliente.Nome := 'Cliente Teste';
  Cliente.Cidade := 'Cidade Teste';
  Cliente.UF := 'SP';

  FSUT.Salvar(Cliente);
  FSUT.CarregarTodosClientes;
  FSUT.Buscar(Cliente, tbNome);

  CheckTrue(Cliente.Codigo <> 0);
end;

procedure TestTListaClientes.TestAlterar;
begin
  var ClienteAlteracao := TCliente.Create;
  FSUT.CarregarUltimoCliente(ClienteAlteracao);
  var ClienteNomeOriginal := Cliente.Nome;

  Cliente.Nome := 'Cliente Teste Alterado';

  FSUT.Alterar(Cliente);
  FSUT.CarregarUltimoCliente(Cliente);
  CheckTrue(Cliente.Nome <> ClienteNomeOriginal);
end;

procedure TestTListaClientes.TestDeletar;
begin
  FSUT.CarregarUltimoCliente(Cliente);
  FSUT.Deletar(Cliente);
  FSUT.Buscar(Cliente, tbCodigo);
  CheckTrue(Cliente.Codigo = 0);
end;

initialization
  RegisterTest('Clientes', TestTListaClientes.Suite);

end.
