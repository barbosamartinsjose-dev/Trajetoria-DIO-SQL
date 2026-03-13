--                                                            ###########################
--                                                            # Criando Banco e Tabelas #
--                                                            ###########################

-- Criando BD
CREATE DATABASE IF NOT EXISTS company_desafio;
USE company_desafio;

-- Tabela Localizacao
CREATE TABLE IF NOT EXISTS localizacao(
    id_localizacao INT AUTO_INCREMENT PRIMARY KEY,
    cidade VARCHAR(100) NOT NULL);
    
-- Tabela Departamento
CREATE TABLE IF NOT EXISTS departamento(
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nome_departamento VARCHAR(100) NOT NULL,
    id_localizacao INT,
    id_gerente INT,
    FOREIGN KEY (id_localizacao) REFERENCES localizacao(id_localizacao));
    
-- Tabela Empregado
CREATE TABLE IF NOT EXISTS empregado (
    id_empregado INT AUTO_INCREMENT PRIMARY KEY,
    nome_empregado VARCHAR(100) NOT NULL,
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento));

-- Gerente no departamento
ALTER TABLE departamento
ADD FOREIGN KEY (id_gerente) REFERENCES empregado(id_empregado);

-- Tabela Dependentes
CREATE TABLE IF NOT EXISTS dependente (
    id_dependente INT AUTO_INCREMENT PRIMARY KEY,
    nome_dependente VARCHAR(100) NOT NULL,
    id_empregado INT,
    FOREIGN KEY (id_empregado) REFERENCES empregado(id_empregado));
    
-- Tabela Projeto 
CREATE TABLE IF NOT EXISTS projeto(
    id_projeto INT AUTO_INCREMENT PRIMARY KEY,
    nome_projeto VARCHAR(100) NOT NULL,
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento));
    
-- Tabela Relacao empregado por projeto
CREATE TABLE IF NOT EXISTS empregado_projeto(
    id_empregado INT,
    id_projeto INT,
    PRIMARY KEY (id_empregado, id_projeto),
    FOREIGN KEY (id_empregado) REFERENCES empregado(id_empregado),
    FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto));
    
--                                                            ##########################
--                                                            # Inserindo Dados no BD  #
--                                                            ##########################

-- Inserir dados
INSERT INTO localizacao (cidade) VALUES('Goiania'), ('Sao Paulo');
INSERT INTO departamento(nome_departamento, id_localizacao) VALUES('TI', 1), ('RH', 2);
INSERT INTO empregado (nome_empregado, id_departamento) VALUES ('Carlos', 1), ('Ana', 1), ('Marcos', 2);

-- Definindo Gerentes 
UPDATE departamento SET id_gerente = 1 WHERE id_departamento = 1;
UPDATE departamento SET id_gerente = 3 WHERE id_departamento = 2;

-- Inserindo Dependentes 
INSERT INTO dependente(nome_dependente, id_empregado) VALUES ('Filho do Carlos', 1);

-- Inserindo Projeto
INSERT INTO projeto (nome_projeto, id_departamento) VALUES ('Migraçao Cloud', 1);

-- Inserindo Projeto por empregado
INSERT INTO empregado_projeto (id_empregado, id_projeto) VALUES (1,1), (2,1);
    
--                                                            #########################
--                                                            # Inserindo Views no BD #
--                                                            #########################

-- Empregados por departamento e localidade
CREATE OR REPLACE VIEW vw_qtd_empregados_dept_local AS
    SELECT d.nome_departamento, l.cidade, COUNT(e.id_empregado) AS total_empregados
    FROM departamento d
    INNER JOIN localizacao l ON d.id_localizacao = l.id_localizacao
    LEFT JOIN empregado e ON d.id_departamento = e.id_departamento
    GROUP BY d.nome_departamento, l.cidade;
    
-- Lista de departamentos e gerentes
CREATE OR REPLACE VIEW vw_dept_gerentes AS 
    SELECT d.nome_departamento, e.nome_empregado AS gerente 
    FROM departamento d
    INNER JOIN empregado e ON d.id_gerente = e.id_empregado;
    
-- Projetos com maior numero de empregados
CREATE OR REPLACE VIEW vw_projetos_mais_empregados AS
    SELECT p.nome_projeto, COUNT(ep.id_empregado) AS total_empregados
    FROM projeto p
    INNER JOIN empregado_projeto ep ON p.id_projeto = ep.id_projeto
    GROUP BY p.nome_projeto
    ORDER BY total_empregados DESC;

-- Lista de projetos, departamentos e gerentes
CREATE OR REPLACE VIEW vw_projetos_dept_gerentes AS 
    SELECT p.nome_projeto, d.nome_departamento, e.nome_empregado AS gerente
    FROM projeto p 
    INNER JOIN departamento d ON p.id_departamento = d.id_departamento
    INNER JOIN empregado e ON d.id_gerente = e.id_empregado;
    
-- Empregados com dependentes (informando se sao gerente)
CREATE OR REPLACE View vw_empregados_dependentes_gerencia AS 
    SELECT e.nome_empregado, COUNT(dep.id_dependente) AS total_dependentes,
        CASE WHEN d.id_gerente IS NOT NULL THEN 'Sim' 
        ELSE 'Nao' 
        END AS e_gerente
    FROM empregado e 
    INNER JOIN dependente dep ON e.id_empregado = dep.id_empregado
    LEFT JOIN departamento d ON e.id_empregado = d.id_gerente
    GROUP BY e.nome_empregado, d.id_gerente;

--                                                            ########################
--                                                            # Config Permissoes BD #
--                                                            ########################

-- Criando users 
CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'senha123';
CREATE USER 'empregado_comum'@'localhost' IDENTIFIED BY 'senha123';

-- Permissao do cargo Gerente (pode ver departamentos e projetos)
GRANT SELECT ON company_desafio.vw_dept_gerentes TO 'gerente'@'localhost';
GRANT SELECT ON company_desafio.vw_projetos_dept_gerentes TO 'gerente'@'localhost';

-- Permissao de empregado (Ve apenas projetos, nao ve departamentos)
GRANT SELECT ON company_desafio.vw_projetos_mais_empregados TO 'empregado_comum'@'localhost';