-- Criando o Banco de Dados

CREATE DATABASE IF NOT EXISTS company;
USE company;

-- Tabela de localização

CREATE TABLE localizacao(
	id_localizacao INT AUTO_INCREMENT PRIMARY KEY,
    cidade VARCHAR(100) NOT NULL);
    
-- Tabela de Departamentos

CREATE TABLE departamento(
	id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nome_departamento VARCHAR(100) NOT NULL,
    id_localizacao INT,
    FOREIGN KEY (id_localizacao) REFERENCES localizacao(id_localizacao));
    
-- Tabela de Empregados
CREATE TABLE empregados(
	id_empregado INT AUTO_INCREMENT PRIMARY KEY,
    nome_empregado VARCHAR(100) NOT NULL,
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento));

-- Inserir dados no Banco de Dados

-- Referente a tabela localização

INSERT INTO localizacao(cidade) VALUES ('São Paulo'), ('Rio de Janeiro'), ('Belo Horizonte');

-- Referente a Departamentos

INSERT INTO departamento (nome_departamento, id_localizacao) VALUES ('TI', 1), ('RH', 2), ('Marketing', 1), ('Vendas', 3);

-- Referente a Empregados

INSERT INTO empregado (nome_empregado, id_departamento) VALUES ('João Silva', 1), ('Maria Souza', 1), ('Pedro Santos', 2), 
('Ana Costa', 3), ('Lucas Almeida', 1), ('Paula Lima', 4);

--		  				    #############################
-- 							Perguntas e Resposta Parte 01
--		  				    #############################

-- Pergunta 1 : Qual o departamento com maior número de pessoas?
SELECT d.nome_departamento, COUNT(e.id_empregado) AS total_empregados
FROM empregado e
INNER JOIN departamento d ON e.id_departamento = d.id_departamento
GROUP BY d.nome_departamento
ORDER BY total_empregados DESC
LIMIT 1;

-- Indice da pergunta 1
CREATE INDEX idx_emp_departamento ON empregado(id_departamento) USING BTREE;

-- Pergunta 2 : Quais são os departamentos por cidade?
SELECT ç.cidade, d.nome_departamento
FROM departamento d
INNER JOIN localizacao l ON d.id_localizacao = l.id_localizacao
ORDER BY l.cidade;

-- Indice da pergunta 2
CREATE INDEX idx_dep_localizacao ON departamento(id_localizacao) USING BTREE;

-- Pergunta 3: Relação de empregados por departamento
SELECT d.nome_departamento, e.nome_empregado
FROM empregado e
INNER JOIN departamento d ON e.id_departamento = d.id_departamento
ORDER BY d.nome_departamento, e.nome_empregado;

-- Indece da pergunta 3
CREATE INDEX idx_dep_nome ON departamento(nome_departamento) USING BTREE;
