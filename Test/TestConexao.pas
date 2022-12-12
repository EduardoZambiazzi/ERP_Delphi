unit TestConexao;

interface

uses
  TestFramework,
  FireDAC.Stan.Option,
  FireDAC.Stan.Async,
  IniFiles,
  Vcl.Dialogs,
  system.SysUtils,
  FireDAC.Stan.Error,
  Data.DB,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Phys.MySQLDef,
  Funcoes.Logs,
  Constantes,
  FireDAC.UI.Intf,
  ConstantesSQL,
  FireDAC.Phys,
  FireDAC.Stan.Pool,
  FireDAC.VCLUI.Wait,
  FireDAC.Phys.MySQL,
  Vcl.Forms,
  Conexao,
  FireDAC.Stan.Intf,
  FireDAC.Comp.Client,
  system.classes,
  DadosIniciais;

type
  TestTConexaoBanco = class(TTestCase)
  strict private
    FConexaoBanco: TConexaoBanco;
    FDadosIniciais: TDadosIniciais;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure ConectaBanco;

  end;

implementation

procedure TestTConexaoBanco.ConectaBanco;
begin
  CheckTrue(FConexaoBanco.Conectado);
end;

procedure TestTConexaoBanco.SetUp;
begin
  FConexaoBanco := TConexaoBanco.Create;
end;

procedure TestTConexaoBanco.TearDown;
begin
  FConexaoBanco.Free;
  FConexaoBanco := nil;
end;


initialization
  RegisterTest(TestTConexaoBanco.Suite);
end.
