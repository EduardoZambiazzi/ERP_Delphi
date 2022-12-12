program Pedidos;

uses
  Vcl.Forms,
  Principal in 'View\Principal.pas' {FrmPrincipal},
  Clientes in 'Control\Classes\Clientes.pas',
  Pedido in 'Control\Classes\Pedido.pas',
  Produtos in 'Control\Classes\Produtos.pas',
  Constantes in 'Control\Constantes\Constantes.pas',
  ConstantesSQL in 'Control\Constantes\ConstantesSQL.pas',
  Funcoes.Logs in 'Control\Funcoes\Funcoes.Logs.pas',
  DadosIniciais in 'Model\DadosIniciais.pas',
  Conexao in 'Model\Conexao.pas',
  udmIcones in 'Control\udmIcones.pas' {dmIcones: TDataModule},
  EditarPedido in 'View\EditarPedido.pas' {frmEditarPedido};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  ConexaoDB := TConexaoBanco.Create;

  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TdmIcones, dmIcones);
  Application.Run;
end.
