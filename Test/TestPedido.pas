unit TestPedido;

interface

uses
  TestFramework, FireDAC.Comp.Client, Constantes, Pedido, Conexao, System.SysUtils,
  System.Generics.Collections, Clientes, System.DateUtils, Produtos, ConstantesSQL;

type
  TestTPedidoGeral = class(TTestCase)
  strict private
    FSUT: TPedidoGeral;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSalvarPedido;
    procedure TestAdicionaProduto;
    procedure TestRemoverProduto;
    procedure TestAlterarPedido;
    procedure TestDeletarPedido;
  end;

implementation

procedure TestTPedidoGeral.SetUp;
begin
  FSUT := TPedidoGeral.Create;
end;

procedure TestTPedidoGeral.TearDown;
begin
  FSUT.Free;
  FSUT := nil;
end;

procedure TestTPedidoGeral.TestAdicionaProduto;
begin
  var ProdutoPedido := TPedidoProdutos.Create;
  var Produto := TProduto.Create;

  Produto.CarregarTodosProdutos;
  Produto := Produto.ListaProdutos.Items[3];
  Produto.Buscar(Produto, tbpCodigo);

  ProdutoPedido.Produto := Produto;
  ProdutoPedido.Produto.Codigo := Produto.Codigo;
  ProdutoPedido.Produto.Descricao := Produto.Descricao;
  Produto.ValorUnitario := Produto.ValorUnitario;
  ProdutoPedido.Quantidade := 2;

  FSUT.AdicionaProduto(ProdutoPedido);

  CheckTrue(FSUT.Produtos.Count > 0);
end;

procedure TestTPedidoGeral.TestRemoverProduto;
begin
  FSUT.CarregarUltimoPedido(Pedidos);

  var QuantidadeAnterior := Pedidos.Produtos.Count;

  FSUT.RemoverProduto(Pedidos.Produtos.Count-1);
  CheckTrue(QuantidadeAnterior > Pedidos.Produtos.Count);
end;

procedure TestTPedidoGeral.TestSalvarPedido;
begin
  var Cliente := TCliente.Create;
  var Produtos := TProduto.Create;

  Pedidos.CarregarTodosPedidos;

  var QuantidadeAnterior := Pedidos.PedidosLista.Count;

  Pedidos.DataEmissao := Now;
  Pedidos.ValorTotal := 22.50;
  Pedidos.Cliente.CarregarUltimoCliente(Cliente);
  Pedidos.Cliente := Cliente;

  Produtos.CarregarTodosProdutos;

  for var I := 0 to Produtos.ListaProdutos.Count -1 do
  begin
    var PedidoProduto := TPedidoProdutos.Create;

    PedidoProduto.Quantidade := I + 1;
    PedidoProduto.ValorUnitario := Produtos.ListaProdutos.Items[i].ValorUnitario;
    PedidoProduto.Produto := Produtos.ListaProdutos.Items[i];

    Pedidos.Produtos.Add(PedidoProduto);
  end;

  FSUT.SalvarPedido(Pedidos);

  Pedidos.CarregarTodosPedidos;
  CheckTrue(Pedidos.PedidosLista.Count > QuantidadeAnterior);
end;

procedure TestTPedidoGeral.TestDeletarPedido;
begin
  var QuantidadeAnterior := Pedidos.PedidosLista.Count;

  FSUT.CarregarTodosPedidos;
  FSUT.CarregarUltimoPedido(Pedidos);
  FSUT.DeletarPedido(Pedidos);
  FSUT.CarregarTodosPedidos;
  
  CheckTrue(QuantidadeAnterior < Pedidos.PedidosLista.Count);
end;

procedure TestTPedidoGeral.TestAlterarPedido;
begin
  FSUT.CarregarUltimoPedido(Pedidos);
  Pedidos.DataEmissao := Tomorrow;

  FSUT.AlterarPedido(Pedidos);
  FSUT.CarregarUltimoPedido(Pedidos);

  CheckTrue(Pedidos.DataEmissao = Tomorrow);
end;

initialization
  RegisterTest('Pedidos', TestTPedidoGeral.Suite);
end.

