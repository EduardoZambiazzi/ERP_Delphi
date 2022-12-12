unit TestProdutos;

interface

uses
  TestFramework,
  FireDAC.Comp.Client,
  Funcoes.Logs,
  Constantes,
  System.Generics.Collections,
  System.SysUtils,
  Vcl.Dialogs,
  Conexao,
  Produtos,
  ConstantesSQL,
  System.Classes;

type
  TestTListaProdutos = class(TTestCase)
  strict private
    FProdutos: TProduto;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAdiciona;
    procedure TestSalvar; overload;
    procedure TestAlterar;
    procedure TestDeletar;
  end;

implementation

procedure TestTListaProdutos.SetUp;
begin
  FProdutos := TProduto.Create;
end;

procedure TestTListaProdutos.TearDown;
begin
  FProdutos.Free;
  FProdutos := nil;
end;

procedure TestTListaProdutos.TestAdiciona;
begin
  var QuantidadeRegistros := FProdutos.ListaProdutos.Count;
  var Produto := TProduto.Create;

  Produto.Codigo := 999999;
  Produto.Descricao := 'Cliente Teste';
  Produto.ValorUnitario := 23.50;

  FProdutos.Adiciona(Produto);

  CheckTrue(QuantidadeRegistros < FProdutos.ListaProdutos.Count);
end;

procedure TestTListaProdutos.TestSalvar;
begin
  var Produto := TProduto.Create;

  Produto.Descricao := 'Produto Teste';
  Produto.ValorUnitario := 22.90;

  FProdutos.Salvar(Produto);
  FProdutos.CarregarTodosProdutos;
  FProdutos.Buscar(Produto, tbpDescricao);

  CheckTrue(Produto.Codigo <> 0);
end;

procedure TestTListaProdutos.TestAlterar;
begin
  FProdutos.CarregarTodosProdutos;

  var Produto := FProdutos.ListaProdutos.Items[FProdutos.ListaProdutos.Count-1];
  var ProdutoDescricaoOriginal := Produto.Descricao;

  Produto.Descricao := 'Descrição Teste ' + Random(100).ToString;

  Produto.Alterar(Produto);
  FProdutos.Buscar(Produto, tbpDescricao);
  CheckTrue(Produto.Descricao <> ProdutoDescricaoOriginal);
end;

procedure TestTListaProdutos.TestDeletar;
begin
  FProdutos.CarregarTodosProdutos;
  var Produto := FProdutos.ListaProdutos.Items[FProdutos.ListaProdutos.Count-1];

  FProdutos.Deletar(Produto);

  FProdutos.Buscar(Produto, tbpDescricao);
  CheckTrue(Produto.Codigo = 0);
end;

initialization
  RegisterTest('Produtos', TestTListaProdutos.Suite);
end.
