unit ConstantesSQL;

interface

const
  sqlCriaBanco = 'create database pedidos;' ;

  sqlCriaTabelaClientes =
    ' create table clientes (  ' +
    '    codigo int(11) not null auto_increment,  ' +
    '    nome varchar(100) not null, ' +
    '    cidade varchar(50), ' +
    '    uf char(2), ' +
    '' +
    '    primary key (codigo), ' +
    '    key codigo (codigo)   ' +
    '  ) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci ';

  sqlCriaTabelaProdutos =
    ' create table produtos (  ' +
    '   codigo int(11) not null auto_increment, ' +
    '   descricao varchar(150) not null, ' +
    '   preco_venda decimal(18,2) not null, ' +
    '' +
    '    primary key (codigo), ' +
    '    key codigo (codigo)   ' +
    ' ) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci; ';

  sqlCriaTabelaPedidosGeral =
    ' create table pedidos_geral ( ' +
    '   numero int(11) not null auto_increment, ' +
    '   data_emissao datetime not null, ' +
    '   cliente_codigo int(11), ' +
    '   valor_total decimal(18,2) not null, ' +
    '' +
    '    primary key (numero), ' +
    '    key codigo (numero) ' +
    '  ' +
    ' ) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci; ';

  sqlCriaTabelaPedidosProdutos =
    ' create table pedidos_produtos ( ' +
    '   id int(11) not null auto_increment, ' +
    '   pedido_numero int(11) not null, ' +
    '   produto_codigo int(11) not null, ' +
    '   quantidade double(18,2) not null, ' +
    '   vlr_unitario double(18,2) not null, ' +
    '   vlr_total double(18,2) not null, ' +
    ' ' +
    '   primary key (id), ' +
    '   key id (id), ' +
    '   key fk_produtos_codigo (produto_codigo), ' +
    '   key fk_pedidos_geral_numero (pedido_numero), ' +
    '   constraint fk_pedidos_geral_numero foreign key (pedido_numero) references pedidos_geral (numero), ' +
    '   constraint fk_produtos_codigo foreign key (produto_codigo) references produtos (codigo) ' +
    ' ) engine=innodb default charset=utf8mb4 collate=utf8mb4_general_ci; ';

  sqlInsertClientes = 'insert into clientes(nome, cidade, uf) values (:nome, :cidade, :uf)';
  sqlInsertProdutos = 'insert into produtos(descricao, preco_venda) values (:descricao, :preco_venda)';
  sqlInsertPedidosGeral = 'insert into pedidos_geral(data_emissao, cliente_codigo, valor_total)  ' +
                          'values (:data_emissao, :cliente_codigo, :valor_total)';
  sqlInsertPedidosProdutos = 'insert into pedidos_produtos(pedido_numero, produto_codigo, quantidade, vlr_unitario, vlr_total) ' +
                             'values (:pedido_numero, :produto_codigo, :quantidade, :vlr_unitario, :vlr_total)';

  sqlUpdateClientes ='update clientes set nome = :nome, cidade = :cidade, uf = :uf where codigo = :codigo';
  sqlUpdateProdutos = 'update produtos set descricao = :descricao, preco_venda = :preco_venda where codigo = :codigo';
  sqlUpdatePedidosGeral = 'update pedidos_geral set ' +
                          '  data_emissao = :data_emissao, ' +
                          '  cliente_codigo = :cliente_codigo, ' +
                          '  valor_total = :valor_total ' +
                          'where numero = :numero ';
  sqlUpdatePedidosProdutos = 'update pedidos_produtos set ' +
                             '  pedido_numero = :pedido_numero, ' +
                             '  produto_codigo = :produto_codigo, ' +
                             '  quantidade = :quantidade, ' +
                             '  vlr_unitario = :vlr_unitario, ' +
                             '  vlr_total = :vlr_total ' +
                             'where id = :id';

  sqlDeleteClientes ='delete from clientes where codigo = :codigo';
  sqlDeleteProdutos = 'delete from produtos where codigo = :codigo';
  sqlDeletePedidosGeral = 'delete from pedidos_geral where numero = :numero';
  sqlDeletePedidosProdutos = 'delete from pedidos_produtos where pedido_numero = :pedido_numero';

  sqlSelectClientes ='select * from clientes';
  sqlSelectProdutos = 'select * from produtos';
  sqlSelectPedidosGeral = 'select * from pedidos_geral';
  sqlSelectPedidosProdutos = 'select * from pedidos_produtos where pedido_numero = :pedido_numero';

  sqlSelectPedidosGrid = 'select pedidos_geral.*, clientes.nome, cast('''' as char(1)) editar, cast('''' as char(1)) deletar ' +
                         'from pedidos_geral ' +
                         'left join clientes on clientes.codigo = pedidos_geral.cliente_codigo ';

implementation

end.
