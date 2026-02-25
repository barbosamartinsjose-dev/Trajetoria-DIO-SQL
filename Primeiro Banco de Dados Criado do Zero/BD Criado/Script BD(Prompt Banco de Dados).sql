-- Criação do DB para o cenário de E-commerce
-- DROP DATABASE ECOMMERCE;
create database ecommerce;
use ecommerce;

-- Criar tabela cliente
create table cliente(
	idCliente int auto_increment primary key,
    Fname varchar(10) not null,
    Minit char(3),
    Lname varchar(20),
    CPF char(11),
    CNPJ char(15),
    tipo_cliente ENUM('PF','PJ') not null default 'PF',
    address varchar(255),
    constraint unique_cpf_client unique(CPF),
    constraint unique_CNPJ_client unique(CNPJ)
);
alter table cliente auto_increment=1;

-- Criar tabela de pagamento
create table pagamento(
    idPagamento int auto_increment primary key,
    idCliente int,
    tipoPagamento enum('Boleto', 'Cartão', 'Dois cartões', 'Pix') not null,
    limiteDisponivel float,
    constraint fk_pagamento_cliente foreign key (idCliente) references cliente(idCliente)
);


-- Criar tabela produto
create table produto(
	idProduto int auto_increment primary key,
    Fname varchar(40) not null,
    classificação bool default false,
	categoria enum('Eletronico','Vestimenta','Brinquedos','Alimentos','Moveis'),
    avaliação float default 0,
    dimenções varchar(10)
);


-- Criar tabela pedido
create table pedido(
	idPedido int auto_increment primary key,
    idPedidoCliente int,
    pedidoStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    descrição varchar(255),
    frete float default 10,
    constraint fk_pedido_cliente foreign key (idPedidoCliente) references cliente(idCliente)
);

-- Criar tabela Entrega
create table entrega(
    idEntrega int auto_increment primary key,
    idPedido int,
    statusEntrega enum('Em separação', 'Em trânsito', 'Entregue', 'Cancelado') default 'Em separação',
    codigoRastreio varchar(50),
    dataPrevista date,
    constraint fk_entrega_pedido foreign key (idPedido) references pedido(idPedido)
);


-- criar tabela estoque
create table estoque(
	idStoque int auto_increment primary key,
    localização varchar(130),
    quantidade int default 0
);



-- criar tabela fornecedor
create table fornecedor(
	idFornecedor int auto_increment primary key,
    nomesocial varchar(255) not null,
    CNPJ char(15) not null,
    contato varchar(11) not null,
    constraint unique_fornecedor unique (CNPJ)
);



-- criar tabela vendedor
create table vendedor(
	idvendedor int auto_increment primary key,
    nomefantasia varchar(255) not null,
    CNPJ char(15) default 0,
    CPF char(11) default 0,
    contato varchar(11) not null,
    endereço varchar(255) not null,
    constraint unique_CNPJ_vendedor unique (CNPJ),
    constraint unique_CPF_vendedor unique (CPF)
);



-- criar tabela produtos e vendedor 
create table produtoVendedor (
	idPvendedor int,
    idProduto int,
    quantidade int default 1,
    primary key (idPvendedor, idProduto),
    constraint fk_produto_vendedor foreign key (idPvendedor) references vendedor (idVendedor),
    constraint fk_produto_produto_vendedor foreign key (idProduto) references produto (idProduto)
);



-- criar tabela pedido e produto
create table ordproduto (
	idOrdproduto int,
    idOrordem int,
    orQuantidade int default 1,
    ordStatus enum('Disponivel','Sem estoque') default 'Disponivel',
    primary key (idOrdproduto, idOrordem),
    constraint fk_produto_pedido foreign key (idOrdproduto) references produto(idProduto),
    constraint fk_produto_produto foreign key (idOrordem) references pedido(idPedido)
);



-- criar tabela estoque e produto
create table proestoque(
	idproestoque int,
    idestpro int,
    localização varchar(255) not null,
    primary key(idproestoque, idestpro),
    constraint fk_produto_produtos foreign key (idproestoque) references produto(idProduto),
    constraint fk_produto_estoque foreign key (idestpro) references estoque(idStoque)
);



-- criar produto e estoque
create table prodestoque (
	idProdestoque int,
    idEstproduto int,
    quantity int not null,
    primary key (idProdestoque, idEstproduto),
    constraint fk_produto_estoquee foreign key (idProdestoque) references estoque(idStoque),
    constraint fk_estoque_produtoo foreign key (idEstproduto) references produto(idProduto)
);



show tables;


-- Recuperando o nome completo dos clientes e ordenando (Atributo derivado + ORDER BY)
SELECT 
    idCliente, 
    CONCAT(Fname, ' ', Lname) AS NomeCompleto, 
    CPF, 
    CNPJ, 
    tipo_cliente 
FROM cliente 
ORDER BY NomeCompleto;

-- Buscando apenas os pedidos que já estão confirmados
SELECT * FROM pedido 
WHERE pedidoStatus = 'Confirmado';

-- Relação de quantidade de pedidos por cliente
SELECT 
    c.idCliente, 
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente, 
    COUNT(p.idPedido) AS Quantidade_de_Pedidos
FROM cliente c
INNER JOIN pedido p ON c.idCliente = p.idPedidoCliente
GROUP BY c.idCliente, Cliente;

-- Clientes com mais de 1 pedido realizado (uso do HAVING)
SELECT 
    c.idCliente, 
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente, 
    COUNT(p.idPedido) AS Quantidade_de_Pedidos
FROM cliente c
INNER JOIN pedido p ON c.idCliente = p.idPedidoCliente
GROUP BY c.idCliente, Cliente
HAVING COUNT(p.idPedido) > 1;

-- Verificando se algum vendedor (terceiro) também está cadastrado como fornecedor pelo CNPJ
SELECT 
    v.nomefantasia AS Nome_Vendedor, 
    v.CNPJ, 
    f.nomesocial AS Nome_Fornecedor
FROM vendedor v
INNER JOIN fornecedor f ON v.CNPJ = f.CNPJ;

-- Relação de produtos ofertados por vendedores terceiros
SELECT 
    v.nomefantasia AS Vendedor, 
    p.Fname AS Produto, 
    pv.quantidade AS Quantidade_no_Estoque_do_Vendedor
FROM vendedor v
INNER JOIN produtoVendedor pv ON v.idvendedor = pv.idPvendedor
INNER JOIN produto p ON pv.idProduto = p.idProduto
ORDER BY Vendedor;