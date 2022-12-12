program PedidosTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  TestConexao in 'TestConexao.pas',
  Clientes in '..\Control\Classes\Clientes.pas',
  Pedido in '..\Control\Classes\Pedido.pas',
  Produtos in '..\Control\Classes\Produtos.pas',
  Constantes in '..\Control\Constantes\Constantes.pas',
  ConstantesSQL in '..\Control\Constantes\ConstantesSQL.pas',
  Funcoes.Logs in '..\Control\Funcoes\Funcoes.Logs.pas',
  Conexao in '..\Model\Conexao.pas',
  DadosIniciais in '..\Model\DadosIniciais.pas',
  TestClientes in 'TestClientes.pas',
  TestProdutos in 'TestProdutos.pas',
  TestPedido in 'TestPedido.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

