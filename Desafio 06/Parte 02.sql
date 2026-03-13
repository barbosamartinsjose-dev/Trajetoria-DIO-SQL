--                                                            ##########################
--                                                            # Criando Banco e Tabelas#
--                                                            ##########################

-- Criando DB Parte 2
CREATE DATABASE IF NOT EXISTS ecommerce_desafio;
USE ecommerce_desafio;

-- Tabela User
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL);
    
-- Tabela colaboradores
CREATE TABLE IF NOT EXISTS colaboradores (
    id_colaborador INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    salario_base DECIMAL(10, 2) NOT NULL);
    
-- Tabelas de BACKUP/Log (Onde as triggers vao guardar dados)
CREATE TABLE IF NOT EXISTS usuarios_backup(
    id_backup INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario_original INT,
    nome VARCHAR(100),
    email VARCHAR(100),
    data_exclusao DATETIME);
    
CREATE TABLE IF NOT EXISTS log_salario(
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_colaborador INT,
    salario_antigo DECIMAL(10,2),
    salario_novo DECIMAL(10,2), 
    data_alteracao DATETIME);  
    
--                                                            ##########################
--                                                            # Criando Triggers no BD #
--                                                            ##########################

-- BD
USE ecommerce_desafio;

DELIMITER //

-- Salva o user no BKP antes da exclusao
CREATE TRIGGER trg_before_delete_usuario
BEFORE DELETE ON usuarios
FOR EACH ROW
BEGIN
   
    INSERT INTO usuarios_backup (id_usuario_original, nome, email, data_exclusao)
    VALUES (OLD.id_usuario, OLD.nome, OLD.email, NOW());
END //

-- Registrar no log caso o salario mude
CREATE TRIGGER trg_before_update_salario
BEFORE UPDATE ON colaboradores
FOR EACH ROW
BEGIN
    -- Verifica se o salario mudou para nao usar memoria à toa
    IF OLD.salario_base <> NEW.salario_base THEN
        INSERT INTO log_salario(id_colaborador, salario_antigo, salario_novo, data_alteracao)
        VALUES(OLD.id_colaborador, OLD.salario_base, NEW.salario_base, NOW());
    END IF;
END //
DELIMITER ;

--                                                            #########################
--                                                            # Inserindo dados no BD #
--                                                            #########################

-- Inserindo dados
INSERT INTO usuarios(nome,email) VALUES ('Cliente 1', 'cliente@email.com');
INSERT INTO colaboradores(nome, salario_base) VALUES ('Analista de Dados', 4000.00);

-- Fazendo Delete de user ID 1 (Testando o funcionamento da primeira trigger)
DELETE FROM usuarios WHERE id_usuario = 1;

-- Atualizando o salario do colaborador ID 1 para 4500 (Testando a segunda trigger)
UPDATE colaboradores SET salario_base = 4500.00 WHERE id_colaborador = 1;

-- Verificando logs e backup para saber se as triggers funcionaram
SELECT * FROM usuarios_backup;
SELECT * FROM log_salario;