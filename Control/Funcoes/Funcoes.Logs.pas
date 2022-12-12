unit Funcoes.Logs;

interface

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils;

const
  PASTA_LOG = '\log\';

procedure GeraLog(sMensagem, sTitulo: string);

implementation

procedure GeraLog(sMensagem, sTitulo: string);
var
  Log: TStringList;
  PastaLog, ArquivoLog, NomeExecutavel: string;
begin
  Log := TStringList.Create;
  Log.Clear;

  PastaLog := ExtractFileDir(ParamStr(0)) + PASTA_LOG;
  ArquivoLog := PastaLog + ExtractFileName(ParamStr(0)) + '.log';

  if not DirectoryExists(PastaLog) then
    CreateDir(PastaLog);

  if FileExists(ArquivoLog) then
    Log.LoadFromFile(ArquivoLog);

  with Log do
  begin
    Add('');
    Add(' ------------ Log gerado às ' + Now.ToString + ' <Inicio> ------------ ');
    Add(sTitulo);
    Add(' ');
    Add(sMensagem);
    Add(' ');
    Add(' ------------- Log gerado às ' + Now.ToString + ' <Fim> ------------- ');

    SaveToFile(ArquivoLog);
  end;

  FreeAndNil(Log);
end;

end.
