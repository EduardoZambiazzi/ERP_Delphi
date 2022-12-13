unit Conexao;

interface

uses
  system.classes,
  IniFiles,
  system.SysUtils,
  Vcl.Dialogs,
  Vcl.Forms,
  Data.DB,
  Funcoes.Logs,
  Constantes,
  ConstantesSQL,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.Stan.Def,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Phys.MySQLDef,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI;

type
  TConexaoBanco = class
  private
    FConexao: TFDConnection;
    FTransacao: TFDTransaction;
    FLink: TFDPhysMySQLDriverLink;
    FFDCursor: TFDGUIxWaitCursor;
    FPastaInstalacao: string;
    FIPServidor: string;
    FDatabase: string;
    FUsername: string;
    FPassword: string;
    FPort: string;
    FConectado: boolean;
    procedure CriaConexao(pConexao: TFDConnection);
    procedure LerArquivoIni;
    procedure CriaTabelasBanco;
    procedure ConfiguraConexao(var pConexao: TFDConnection);
    procedure TransacaoStart;
    procedure TransacaoCommit;
    procedure TransacaoRollBack;
    function CriaBancoDeDados(pConexao: TFDConnection): boolean;
  public
    constructor Create;
    function CriaQuery: TFDQuery;
    procedure ExecutaSQL(aSQL: string);
    procedure PostSQL(Query: TFDQuery);
    property Conectado: boolean read FConectado write FConectado;
  end;
var
  ConexaoDB: TConexaoBanco;

implementation

uses
  DadosIniciais;

{ TConexaoBanco }

constructor TConexaoBanco.Create;
begin
  FTransacao := TFDTransaction.Create(nil);
  CriaConexao(FConexao);
end;

procedure TConexaoBanco.ExecutaSQL(aSQL: string);
var
  Query: TFDQuery;
begin
  try
    Query := CriaQuery();

    Query.ConnectionName := NomeConexao;
    Query.Transaction := FTransacao;
    TransacaoStart;

    Query.Close;
    Query.SQL.Text := aSQL;
    Query.ExecSql;

    FreeAndNil(Query);
  except
    on e: exception do
    begin
      FreeAndNil(Query);
      TransacaoRollBack;
      GeraLog('SQL: ' + aSQL + NovaLinha +
              strErro + e.Message, strErroSQL);
    end;
  end;
end;

procedure TConexaoBanco.ConfiguraConexao(var pConexao: TFDConnection);
begin
  pConexao := TFDConnection.Create(nil);
  pConexao.Connected := False;
  pConexao.ConnectionName := NomeConexao;
  pConexao.LoginPrompt := False;
  pConexao.Transaction := FTransacao;
  pConexao.UpdateTransaction := FTransacao;
  pConexao.UpdateOptions.AutoCommitUpdates := True;
  pConexao.TxOptions.AutoCommit := True;
  pConexao.DriverName := DriverName;
  pConexao.Params.DriverID := DriverID;
  pConexao.Params.Values['Database'] := FDatabase;
  pConexao.Params.Values['User_name'] := FUsername;
  pConexao.Params.Values['Password'] := FPassword;
  pConexao.Params.Values['Server'] := FIPServidor;
  pConexao.Params.Values['Port'] := FPort;
end;

procedure TConexaoBanco.LerArquivoIni;
var
  Ini: TIniFile;
begin
  try
    Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'banco.ini');
    FIPServidor := Ini.ReadString('Banco', 'server', ServerPadrao);
    FPassword := Ini.ReadString('Banco', 'password', 'root');
    FUsername := Ini.ReadString('Banco', 'username', '');
    FDatabase := Ini.ReadString('Banco', 'database', '');
    FPort := Ini.ReadString('Banco', 'port', '3306');
  finally
    FreeAndNil(Ini);
  end;
end;

procedure TConexaoBanco.PostSQL(Query: TFDQuery);
begin
  try
    Query.ExecSQL;
  except
    on e: Exception do
    begin
      ShowMessage(strErroSQL + NovaLinha + e.Message);
      GeraLog(strErroSQL, strErro);
    end;
  end;
end;

procedure TConexaoBanco.CriaConexao(pConexao: TFDConnection);
begin
  LerArquivoIni;
  ConfiguraConexao(pConexao);

  try
    pConexao.Connected := True;
  except
    if not pConexao.Connected then
      CriaBancoDeDados(pConexao);
  end;

  Conectado := pConexao.Connected;
end;

function TConexaoBanco.CriaBancoDeDados(pConexao: TFDConnection): boolean;
begin
  var FDCommand := TFDCommand.Create(nil);

  pConexao.Params.Values['Database'] := '';
  FDCommand.Connection := pConexao;
  FDCommand.CommandText.Text := Format(sqlCriaBanco, [FDatabase]);

  try
    FDCommand.Active := True;
    pConexao.Params.Values['Database'] := FDatabase;
    pConexao.Connected := True;
    CriaTabelasBanco;
    Result := True;
  except
    on e:Exception do
    begin
      GeraLog(e.message, strErroCriarBanco);
      ShowMessage(strErroCriarBanco + NovaLinha + e.message);
      Result := False;
    end;
  end;

  FreeAndNIl(FDCommand);
end;

procedure TConexaoBanco.CriaTabelasBanco;
begin
  ExecutaSQL(sqlCriaTabelaProdutos);
  ExecutaSQL(sqlCriaTabelaClientes);
  ExecutaSQL(sqlCriaTabelaPedidosGeral);
  ExecutaSQL(sqlCriaTabelaPedidosProdutos);

  var Dados := TDadosIniciais.Create;

  Dados.AdicionaClientes;
  Dados.AdicionaProdutos;
end;

function TConexaoBanco.CriaQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.ConnectionName := NomeConexao;
end;

procedure TConexaoBanco.TransacaoCommit;
begin
  FTransacao.Commit;
end;

procedure TConexaoBanco.TransacaoRollBack;
begin
  FTransacao.Rollback;
end;

procedure TConexaoBanco.TransacaoStart;
begin
  if FTransacao.Active then
    TransacaoCommit();

  FTransacao.StartTransaction;
end;

end.
