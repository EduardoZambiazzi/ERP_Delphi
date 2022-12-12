unit Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Data.DB;

type
  TFrmPrincipal = class(TForm)
    pnTop: TPanel;
    btNovoPedido: TButton;
    editPesquisar: TButtonedEdit;
    GridPedidos: TDBGrid;
    qrPedidos: TFDQuery;
    dsPedidos: TDataSource;
    qrPedidosnumero: TFDAutoIncField;
    qrPedidosdata_emissao: TDateTimeField;
    qrPedidoscliente_codigo: TIntegerField;
    qrPedidosvalor_total: TFMTBCDField;
    qrPedidosnome: TStringField;
    qrPedidoseditar: TStringField;
    qrPedidosdeletar: TStringField;
    procedure btNovoPedidoClick(Sender: TObject);
    procedure editPesquisarKeyDown(Sender: TObject; var Key: Word; Shift:
        TShiftState);
    procedure editPesquisarRightButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridPedidosCellClick(Column: TColumn);
    procedure GridPedidosDrawColumnCell(Sender: TObject; const Rect: TRect;
        DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridPedidosMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
        Integer);
  private
    procedure CarregaTelaCadastro;
    procedure ConfiguraCursor(pHint: string);
    procedure PesquisarPedido;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  ConstantesSQL,
  udmIcones,
  Pedido,
  EditarPedido,
  Constantes;

{$R *.dfm}

procedure TFrmPrincipal.btNovoPedidoClick(Sender: TObject);
begin
  Pedidos.Numero := 0;
  CarregaTelaCadastro;
end;

procedure TFrmPrincipal.CarregaTelaCadastro;
begin
  var frm := TfrmEditarPedido.Create(self);
  frm.ShowModal;

  FreeAndNil(frm);
  qrPedidos.Refresh;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  qrPedidos.ConnectionName := NomeConexao;
  qrPedidos.Open(sqlSelectPedidosGrid);
end;

procedure TFrmPrincipal.GridPedidosDrawColumnCell(Sender: TObject; const Rect:
    TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  var Btm: TBitmap;
  if Column.FieldName = 'editar' then
  begin
    GridPedidos.Canvas.FillRect(Rect);
    Btm := TBitmap.Create;
    dmIcones.il_20px.GetBitmap(0, Btm);

    GridPedidos.Canvas.Draw(Rect.Left, Rect.Top, Btm);
    Btm.Free;
  end;

  if Column.FieldName = 'deletar' then
  begin
    GridPedidos.Canvas.FillRect(Rect);
    Btm := TBitmap.Create;
    dmIcones.il_20px.GetBitmap(1, Btm);

    GridPedidos.Canvas.Draw(Rect.Left, Rect.Top, Btm);
    Btm.Free;
  end;
end;

procedure TFrmPrincipal.GridPedidosMouseMove(Sender: TObject; Shift:
    TShiftState; X, Y: Integer);
const
  ColunaEditar = 6;
  ColunaDeletar = 7;
var
  Cell: TGridCoord;
begin
  Cell := GridPedidos.MouseCoord(X, Y);
  case Cell.X of
    ColunaEditar: ConfiguraCursor('Editar pedido');
    ColunaDeletar: ConfiguraCursor('Apagar pedido');
  else
    GridPedidos.Cursor := crDefault;
    GridPedidos.ShowHint := False;
  end;
end;

procedure TFrmPrincipal.ConfiguraCursor(pHint: string);
begin
  GridPedidos.Hint := pHint;
  GridPedidos.ShowHint := True;
  GridPedidos.Cursor := crHandPoint;
end;

procedure TFrmPrincipal.editPesquisarKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
begin
  case Key of
    VK_RETURN: PesquisarPedido;
    VK_CANCEL:
      begin
        editPesquisar.Clear;
        PesquisarPedido;
      end;
  end;
end;

procedure TFrmPrincipal.editPesquisarRightButtonClick(Sender: TObject);
begin
  PesquisarPedido;
end;

procedure TFrmPrincipal.GridPedidosCellClick(Column: TColumn);
begin
  if (qrPedidos.RecordCount = 0) or (qrPedidos.FieldByName('cliente_codigo').AsInteger > 0) then
    exit;

  if Column.FieldName = 'editar' then
  begin
    Pedidos := Pedidos.CarregarPedidoNumero(qrPedidos.FieldByName('numero').AsInteger);
    CarregaTelaCadastro;
  end;

  if Column.FieldName = 'deletar' then
  begin
    Pedidos := Pedidos.CarregarPedidoNumero(qrPedidos.FieldByName('numero').AsInteger);
    Pedidos.DeletarPedido(Pedidos);
  end;

  qrPedidos.Refresh;
end;

procedure TFrmPrincipal.PesquisarPedido;
begin
  if (qrPedidos.RecordCount = 0) and (qrPedidos.Filtered = False) then
    exit;

  if Trim(editPesquisar.Text) <> '' then
  begin
    qrPedidos.Filtered := False;
    qrPedidos.Filter := ' numero = ' + editPesquisar.Text;
    qrPedidos.Filtered := True;
  end
  else
  begin
    qrPedidos.Filtered := False;
    qrPedidos.Filter := '';
  end;
end;

end.
