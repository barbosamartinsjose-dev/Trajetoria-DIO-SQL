-- Criar o DB 
create database Oficina;

-- Entrar no DB
use Oficina;

-- Criar tabela da Oficina 
-- Fornecedor

create table Fornecedor(
	idFornecedor int auto_increment primary Key,
    RazaoSocial varchar(100) NOT NULL,
    CNPJ char(14) Unique NOT NULL,
    Contato char(11) NOT NULL
);

-- Peças 
create table Peca (
	idPeca int auto_increment primary key,
    Descricao varchar(100) NOT NULL,
    categoria enum('Motor','Suspensão','Freios','Elétrica','Pneus') NOT NULL,
    ValorCusto decimal(10.2) NOT NULL,
    ValorVenda decimal(10,2) NOT NULL,
    EstoqueAtual int default 0,
    idFornecedor int,
    constraint FK_Fornecedor foreign key (idFornecedor) references Fornecedor(idFornecedor)
);

-- Serviço
create table Servico(
	idServico int auto_increment primary key,
    Descricao varchar(100) NOT NULL,
    ValorMaoDeObra decimal(10,2) NOT NULL,
    TempoEstimado_horas int
);

-- Garantia das Peças
-- setar 1 para com garantia (ok) // setar 0 para sem garantia (Garantia expirada)
create table HistoricoGarantia(
	idGarantia int auto_increment primary key,
    DataInstalacao date NOT NULL,
    DataExpiracao date NOT NULL,
    StatusGarantia bit default 1,
    idPeca int,
    constraint fk_garantia_peca foreign key (idPeca) references Peca(idPeca)
);

show tables;

select * from Servico;

-- #########################
-- Iniciar inserção de Dados
-- #########################
-- Datos Retirados do Gemini

-- Fornecedores
INSERT INTO Fornecedor (RazaoSocial, CNPJ, Contato) 
VALUES 
('Auto Peças Brasil LTDA', '12345678000199', '11984051722'),
('Distribuidora Veloz', '98765432000188', '21984051722');

-- Peças com margem de lucro
INSERT INTO Peca (Descricao, Categoria, ValorCusto, ValorVenda, EstoqueAtual, idFornecedor) 
VALUES 
('Amortecedor Dianteiro', 'Suspensão', 150.00, 280.00, 15, 1),
('Jogo de Velas', 'Motor', 40.00, 85.00, 30, 2),
('Pastilha de Freio ABS', 'Freios', 60.00, 130.00, 10, 1);


-- Serviços
INSERT INTO Servico (Descricao, ValorMaoDeObra, TempoEstimado_Horas) 
VALUES 
('Troca de Suspensão', 200.00, 4),
('Revisão de Motor', 450.00, 8);


-- ###############################
-- Perguntas e Respostas com Query
-- ###############################

-- Qual o lucro bruto por peça vendida, ordenada do maior para o menor?
select
	Descricao,
    ValorVenda,
    ValorCusto,
    (ValorVenda - ValorCusto) AS LucroUnitario
From Peca
Order BY LucroUnitario DESC;

-- Qual o lucro bruto por peça vendida, ordenada da menor para maior?
select
	Descricao,
    ValorVenda,
    ValorCusto,
    (ValorVenda - ValorCusto) AS LucroUnitario
From Peca
Order BY LucroUnitario ASC;

-- Quais peças de "Suspensão" ou "Motor" estão com estoque abaixo de 20 unidades?
Select * From Peca
Where Categoria IN ('Suspensão', 'Motor')
AND EstoqueAtual <20;

-- Qual o valor total investido em estoque por fornecedor, mas apenas para aqueles onde o investimento total supera R$ 1.000,00?
Select f.RazaoSOcial,
	SUM(p.ValorCusto * p.EstoqueAtual) AS InvestimentoTotal
From Fornecedor f
JOIN Peca p ON f.idFornecedor = p.idFornecedor
GROUP BY f.RazaoSocial
Having InvestimentoTotal >1000.00;


-- Quais peças foram instaladas e ainda estão dentro do prazo de garantia?
Select p.Descricao, g.DataInstalacao, g.DataExpiracao
FROM Peca p
JOIN HistoricoGarantia g ON p.idPeca = g.idPeca
WHERE g.DataExpiracao >= CURDATE();