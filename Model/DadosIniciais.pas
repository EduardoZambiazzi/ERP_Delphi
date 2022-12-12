unit DadosIniciais;

interface

uses
  FireDAC.Comp.Client,
  Constantes,
  ConstantesSQL,
  Conexao, Vcl.Dialogs, Funcoes.Logs, System.SysUtils;

const
  dadosClienteNome: TArray<String> = [
    'Juan Gonçalves', 'Isabela Souza', 'Thiago da Cunha', 'Emilly Nogueira', 'Débora Martins',
    'Davi Aparício', 'Vinicius Almada', 'Mariah Farias', 'Nina Santos', 'Lívia Costa',
    'Juliana Fogaça', 'Fernanda Corte Real', 'Enrico das Neves', 'Nina da Mota', 'Catarina da Cruz',
    'Beatriz Brito', 'Alana Rezende', 'Regina Caldeira', 'Marcos Galvão', 'Alessandra Alves'];

  dadosClienteCidade: TArray<String> = [
    'Arapiraca', 'Porto Velho', 'São José do Rio Preto', 'Londrina', 'João Pessoa',
    'Ariquemes', 'Maracanaú', 'Manaus', 'Cachoeirinha', 'Sinop',
    'Blumenau', 'Ananindeua', 'Boa Vista', 'Goiânia', 'Teresina',
    'Macapá', 'Três Lagoas', 'Palmas', 'João Pessoa', 'Picos'];

  dadosClienteUF: TArray<String> = [
    'AL', 'RO', 'SP', 'PR', 'PB',
    'RO', 'CE', 'AM', 'RS', 'MT',
    'SC', 'PA', 'RR', 'GO', 'PI',
    'AP', 'MS', 'TO', 'PB', 'PI'];

  dadosProdutoDescricao: TArray<String> = [
    'Chocolate Ao Leite 92g',
    'Wafer Morango 140g',
    'Refresco Laranja 250g',
    'Ovos Caipira',
    'Cebola Branca E Roxa Kg',
    'Pimentao Amarelo Vermelho Kg',
    'Pão Integral 400g',
    'Torrada Multi Grãos 160g',
    'Biscoito Sortido 650g',
    'Cafe Moído Cerrado Mineiro',
    'Lava Roupa Líquido 3l',
    'Bom Ar Aerosol 360ml',
    'Shampoo Hialurônico 200ml',
    'Desodorante Roll-On 50ml',
    'Sorvete Napolitano 3l',
    'Big Chicken Queijo 1kg',
    'Granola Tradicional 250g',
    'Ketchup Picante 397g',
    'Costela Bovina Ripada Kg',
    'Chocolate Branco 100g'];

  dadosProdutoValorUnitario: TArray<Double> = [
    10.50, 2.55, 3.00, 2.95, 9.85,
    22.30, 10.60, 6.60, 12.50, 25.90,
    48.80, 12.10, 18.75, 9.80, 14.90,
    33.40, 10.30, 15.25, 100.70, 8.90];

type
  TDadosIniciais = class
    procedure AdicionaClientes;
    procedure AdicionaProdutos;
  end;

implementation


var DadosInciais: TDadosIniciais;

{ TDadosIniciais }

procedure TDadosIniciais.AdicionaClientes;
begin
  var Query := ConexaoDB.CriaQuery;

  for var I := 0 to Length(dadosClienteNome)-1 do
  begin
    Query.SQL.Text := sqlInsertClientes;

    Query.ParamByName('nome').AsString := dadosClienteNome[i];
    Query.ParamByName('cidade').AsString := dadosClienteCidade[i];
    Query.ParamByName('uf').AsString := dadosClienteUF[i];

    ConexaoDB.PostSQL(Query);
  end;

  FreeAndNil(Query);
end;

procedure TDadosIniciais.AdicionaProdutos;
begin
  var Query := ConexaoDB.CriaQuery;

  for var I := 0 to Length(dadosProdutoDescricao)-1 do
  begin
    Query.SQL.Text := sqlInsertProdutos;

    Query.ParamByName('descricao').AsString := dadosProdutoDescricao[i];
    Query.ParamByName('preco_venda').AsFloat := dadosProdutoValorUnitario[i];

    ConexaoDB.PostSQL(Query);
  end;

  FreeAndNil(Query);
end;

initialization
  DadosInciais := TDadosIniciais.Create;

end.
