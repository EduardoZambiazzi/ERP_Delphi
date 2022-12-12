unit EditarPedido;

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
  Vcl.Mask,
  Produtos,
  Clientes,
  Pedido,
  udmIcones,
  System.DateUtils,
  Vcl.Grids,
  Constantes;

type
  TTipoOperacao = (toIncluir, toAlterar);
  TfrmEditarPedido = class(TForm)
    pnCliente: TPanel;
    cbCliente: TComboBox;
    Label1: TLabel;
    Panel2: TPanel;
    Panel1: TPanel;
    Panel3: TPanel;
    lbNomeProduto: TLabel;
    editCodigo: TLabeledEdit;
    editQuantidade: TEdit;
    editValorUnitario: TEdit;
    lbTotal: TLabel;
    btnAdicionarItem: TButton;
    Panel4: TPanel;
    Panel5: TPanel;
    gridProdutos: TStringGrid;
    btSalvarPedido: TButton;
    Panel6: TPanel;
    lbTotalPedido: TLabel;
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure btSalvarPedidoClick(Sender: TObject);
    procedure cbClienteChange(Sender: TObject);
    procedure edCodigoProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure editQuantidadeExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure gridProdutosKeyDown(Sender: TObject; var Key: Word; Shift:
        TShiftState);
  private
    Produtos: TProduto;
    ProdutosPedido: TPedidoProdutos;
    IndexProdutoEditado: integer;
    Operacao: TTipoOperacao;
    procedure CarregaComboClientes;
    procedure CalculaTotal;
    procedure CarregarProduto;
    procedure NovoPedido;
    procedure AdicionaProdutoNaLista;
    procedure AdicionaProdutoNoGrid;
    procedure AlteraProdutoNaLista;
    procedure AlteraProdutoNoGrid;
    procedure ConfiguraGrid;
    procedure LimpaCampos;
    procedure EditaProduto;
    procedure ApagaProduto;
    procedure CarregaTodosProdutosNoGrid;
    function FormataValor(Value: double): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEditarPedido: TfrmEditarPedido;

implementation

{$R *.dfm}

procedure TfrmEditarPedido.AdicionaProdutoNoGrid;
begin
  if gridProdutos.RowCount >= 2 then
    if gridProdutos.Cells[0, gridProdutos.RowCount- 1] <> '' then
      gridProdutos.RowCount := gridProdutos.RowCount + 1;

  gridProdutos.Cells[0, gridProdutos.RowCount-1] := ProdutosPedido.Produto.Codigo.ToString;
  gridProdutos.Cells[1, gridProdutos.RowCount-1] := ProdutosPedido.Produto.Descricao;
  gridProdutos.Cells[2, gridProdutos.RowCount-1] := FormataValor(ProdutosPedido.Quantidade);
  gridProdutos.Cells[3, gridProdutos.RowCount-1] := FormataValor(ProdutosPedido.ValorUnitario);
  gridProdutos.Cells[4, gridProdutos.RowCount-1] := FormataValor(ProdutosPedido.ValorTotal);
end;

procedure TfrmEditarPedido.AlteraProdutoNaLista;
begin
  Pedidos.Produtos.Items[IndexProdutoEditado].Produto.Codigo := Produtos.Codigo;
  Pedidos.Produtos.Items[IndexProdutoEditado].Produto.Descricao := Produtos.Descricao;
  Pedidos.Produtos.Items[IndexProdutoEditado].Quantidade := StrToFloat(editQuantidade.Text);
  Pedidos.Produtos.Items[IndexProdutoEditado].ValorUnitario := StrToFloat(editValorUnitario.Text);
  Pedidos.ValorTotal := Pedidos.ValorTotal + Pedidos.Produtos.Items[IndexProdutoEditado].ValorTotal;

  CarregaTodosProdutosNoGrid;
end;

procedure TfrmEditarPedido.AlteraProdutoNoGrid;
begin
  gridProdutos.Cells[0, IndexProdutoEditado + 1] := Pedidos.Produtos.Items[IndexProdutoEditado].Produto.Codigo.ToString;
  gridProdutos.Cells[1, IndexProdutoEditado + 1] := Pedidos.Produtos.Items[IndexProdutoEditado].Produto.Descricao;
  gridProdutos.Cells[2, IndexProdutoEditado + 1] := FormataValor(Pedidos.Produtos.Items[IndexProdutoEditado].Quantidade);
  gridProdutos.Cells[3, IndexProdutoEditado + 1] := FormataValor(Pedidos.Produtos.Items[IndexProdutoEditado].ValorUnitario);
  gridProdutos.Cells[4, IndexProdutoEditado + 1] := FormataValor(Pedidos.Produtos.Items[IndexProdutoEditado].ValorTotal);
end;

procedure TfrmEditarPedido.ApagaProduto;
begin
  if Application.MessageBox(Pchar(strRemoverItem),'Confirmação',36) = 6 then
  begin
    var ProdutoRemover := TPedidoProdutos.Create;
    ProdutoRemover := Pedidos.Produtos.Items[gridProdutos.Row-1];

    Pedidos.RemoverProduto(ProdutoRemover);

    lbTotalPedido.Caption := FormataValor(Pedidos.ValorTotal);
    lbTotalPedido.Repaint;
    CarregaTodosProdutosNoGrid;
  end;
end;

procedure TfrmEditarPedido.btnAdicionarItemClick(Sender: TObject);
begin
  case Operacao of
    toIncluir: AdicionaProdutoNaLista;
    toAlterar: AlteraProdutoNaLista;
  end;

  LimpaCampos;
  btSalvarPedido.Enabled := True;
  lbTotalPedido.Caption := FormataValor(Pedidos.ValorTotal);
end;

procedure TfrmEditarPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Self := nil;
  Action := caFree;
end;

procedure TfrmEditarPedido.FormShow(Sender: TObject);
begin
  ConfiguraGrid;
  CarregaComboClientes;

  if Pedidos.Numero = 0 then
    NovoPedido
  else
  begin
    Pedidos.CarregarPedidoNumero(Pedidos.Numero);
    CarregaTodosProdutosNoGrid;
    lbTotalPedido.Caption := FormataValor(Pedidos.ValorTotal);
    btSalvarPedido.Enabled := True;
  end;

  Operacao := toIncluir;
  editCodigo.SetFocus;
end;

procedure TfrmEditarPedido.NovoPedido;
begin
  Pedidos.DataEmissao := Today;
  Pedidos.Cliente.Codigo := 0;
  Pedidos.ValorTotal := 0;
end;

procedure TfrmEditarPedido.AdicionaProdutoNaLista;
begin
  ProdutosPedido := TPedidoProdutos.Create;
  ProdutosPedido.Produto := Produtos;
  ProdutosPedido.Produto.Codigo := Produtos.Codigo;
  ProdutosPedido.Produto.Descricao := Produtos.Descricao;
  ProdutosPedido.Quantidade := StrToFloat(editQuantidade.Text);
  ProdutosPedido.ValorUnitario := StrToFloat(editValorUnitario.Text);
  Pedidos.ValorTotal := Pedidos.ValorTotal + ProdutosPedido.ValorTotal;

  Pedidos.AdicionaProduto(ProdutosPedido);
  AdicionaProdutoNoGrid;
end;

procedure TfrmEditarPedido.btSalvarPedidoClick(Sender: TObject);
begin
  btSalvarPedido.Enabled := False;
  if Pedidos.Numero = 0 then
    Pedidos.SalvarPedido(Pedidos)
  else
    Pedidos.AlterarPedido(Pedidos);

  ModalResult := mrOk;
end;

procedure TfrmEditarPedido.CalculaTotal;
begin
  var TotalProduto:= StrToFloat(editQuantidade.Text) * StrToFloat(editValorUnitario.Text);
  lbTotal.Caption := FormataValor(TotalProduto);
end;

procedure TfrmEditarPedido.CarregaComboClientes;
begin
  cbCliente.Items.Clear;
  cbCliente.Items.Add('');

  Cliente.CarregarTodosClientes;
  for var I := 0 to Cliente.ListaCliente.Count-1 do
    cbCliente.Items.Add(Cliente.ListaCliente[i].Codigo.ToString + ' - ' + Cliente.ListaCliente[i].Nome);

  cbCliente.ItemIndex := 0;
end;

procedure TfrmEditarPedido.CarregarProduto;
begin
  Produtos := TProduto.Create;
  Produtos.Codigo := StrToInt(editCodigo.Text);
  Produtos.Buscar(Produtos, tbpCodigo);

  if Produtos.Codigo = 0 then
  begin
    ShowMessage(strProdutoNaoEncontrado);
    editCodigo.SetFocus;
    Abort;
  end;

  lbNomeProduto.Caption := Produtos.Descricao;
  editQuantidade.Text := FormataValor(1);
  editValorUnitario.Text := FormataValor(Produtos.ValorUnitario);
  CalculaTotal;

  btnAdicionarItem.Enabled := True;
end;

procedure TfrmEditarPedido.CarregaTodosProdutosNoGrid;
begin
  ConfiguraGrid;

  for var I := 0 to Pedidos.Produtos.Count-1 do
  begin
    if gridProdutos.RowCount >= 2 then
      if gridProdutos.Cells[0, gridProdutos.RowCount- 1] <> '' then
        gridProdutos.RowCount := gridProdutos.RowCount + 1;

    gridProdutos.Cells[0, gridProdutos.RowCount-1] := Pedidos.Produtos.Items[i].Produto.Codigo.ToString;
    gridProdutos.Cells[1, gridProdutos.RowCount-1] := Pedidos.Produtos.Items[i].Produto.Descricao;
    gridProdutos.Cells[2, gridProdutos.RowCount-1] := FormataValor(Pedidos.Produtos.Items[i].Quantidade);
    gridProdutos.Cells[3, gridProdutos.RowCount-1] := FormataValor(Pedidos.Produtos.Items[i].ValorUnitario);
    gridProdutos.Cells[4, gridProdutos.RowCount-1] := FormataValor(Pedidos.Produtos.Items[i].ValorTotal);
  end;

  gridProdutos.Repaint;
end;

procedure TfrmEditarPedido.cbClienteChange(Sender: TObject);
begin
  if cbCliente.ItemIndex > 0 then
    Pedidos.Cliente := Cliente.ListaCliente.Items[cbCliente.ItemIndex -1];
end;

procedure TfrmEditarPedido.ConfiguraGrid;
begin
  gridProdutos.RowCount := 0;
  gridProdutos.ColCount := 0;

  gridProdutos.RowCount := 2;
  gridProdutos.ColCount := 5;

  gridProdutos.Cells[0, 0] := 'Código';
  gridProdutos.Cells[1, 0] := 'Descrição';
  gridProdutos.Cells[2, 0] := 'Quantidade';
  gridProdutos.Cells[3, 0] := 'Unitário';
  gridProdutos.Cells[4, 0] := 'Total';

  gridProdutos.ColWidths[0] := 60;
  gridProdutos.ColWidths[1] := 300;
  gridProdutos.ColWidths[2] := 100;
  gridProdutos.ColWidths[3] := 100;
  gridProdutos.ColWidths[4] := 100;

  gridProdutos.Cells[0, 1] := '';
  gridProdutos.Cells[1, 1] := '';
  gridProdutos.Cells[2, 1] := '';
  gridProdutos.Cells[3, 1] := '';
  gridProdutos.Cells[4, 1] := '';

  gridProdutos.FixedRows := 1;
end;

procedure TfrmEditarPedido.edCodigoProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    CarregarProduto;

  if not (Key in ['0'..'9', ',', '.', #8]) then
    key := #0;
end;

procedure TfrmEditarPedido.EditaProduto;
begin
  Operacao := toAlterar;
  btnAdicionarItem.Caption := 'Alterar Item';
  btnAdicionarItem.Enabled := True;

  IndexProdutoEditado := gridProdutos.Row -1;
  ProdutosPedido := Pedidos.Produtos.Items[IndexProdutoEditado];
  Produtos := ProdutosPedido.Produto;

  editCodigo.Text := ProdutosPedido.Produto.Codigo.ToString;
  lbNomeProduto.Caption := ProdutosPedido.Produto.Descricao;
  editQuantidade.Text := FormataValor(ProdutosPedido.Quantidade);
  editValorUnitario.Text := FormataValor(ProdutosPedido.ValorUnitario);
  lbTotal.Caption := FormataValor(ProdutosPedido.ValorTotal);
end;

procedure TfrmEditarPedido.editQuantidadeExit(Sender: TObject);
begin
  if (StrToFloat(editQuantidade.Text) = 0) or (Trim(editQuantidade.Text) = '') then
  begin
    ShowMessage(strQuantidadeZerada);
    editQuantidade.SetFocus;
    abort;
  end;

  editQuantidade.Text := FormataValor(StrToFloat(editQuantidade.Text));
  CalculaTotal;
end;

function TfrmEditarPedido.FormataValor(Value: double): string;
begin
  Result := FormatFloat('#,##0.00', Value);
end;

procedure TfrmEditarPedido.gridProdutosKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
begin
  if Pedidos.Produtos.Count = 0 then
    Key := 0;

  case key of
    VK_RETURN: EditaProduto;
    VK_DELETE: ApagaProduto;
  end;
end;

procedure TfrmEditarPedido.LimpaCampos;
begin
  Produtos := nil;
  btnAdicionarItem.Enabled := False;
  Operacao := toIncluir;
  btnAdicionarItem.Caption := 'Alterar Item';
  editCodigo.Clear;
  lbNomeProduto.Caption := '';
  editQuantidade.Text := FormatFloat('#,##0.00', 1);
  editValorUnitario.Text := FormatFloat('#,##0.00', 0);
  lbTotal.Caption := FormatFloat('#,##0.00', 0);
  editCodigo.SetFocus;
end;

end.
