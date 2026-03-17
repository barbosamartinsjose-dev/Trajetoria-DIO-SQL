--                                                            ###########################
--                                                            # Criando Banco e Tabelas #
--                                                            ###########################

CREATE DATABASE IF NOT EXISTS ecommerce_transacoes;
USE ecommerce_transacoes;

-- Tabela de Produtos (Estoque)
CREATE TABLE IF NOT EXISTS produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    quantidade_estoque INT NOT NULL,
    preco DECIMAL(10, 2) NOT NULL
);

-- Tabela de Vendas
CREATE TABLE IF NOT EXISTS venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    quantidade_vendida INT NOT NULL,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

-- Inserindo um produto para testarmos
INSERT INTO produto (nome, quantidade_estoque, preco) VALUES ('Notebook Gamer', 10, 4500.00);


--                                                            ################
--                                                            #  TRANSAÇÕES  #
--                                                            ################

-- 1. Desabilitar o autocommit 
SET @@autocommit = 0;

-- 2. Iniciar a transação manualmente
START TRANSACTION;

-- 3. Executando as modificações 
-- Ação 1: Registrar a venda
INSERT INTO venda (id_produto, quantidade_vendida) VALUES (1, 2);

-- Ação 2: Descontar do estoque (Eram 10, devem sobrar 8)
UPDATE produto SET quantidade_estoque = quantidade_estoque - 2 WHERE id_produto = 1;

-- 4. Confirmar e persistir as alterações de forma definitiva
COMMIT;

-- Reabilitar o autocommit após o teste, que é o padrão do banco
SET @@autocommit = 1;


--                                                            ###############################
--                                                            # PARTE 2 || COM PROCEDURE    #
--                                                            ###############################

DELIMITER //

-- Criando uma procedure que processa a compra de forma segura
CREATE PROCEDURE sp_processa_compra_segura(
    IN p_id_produto INT,
    IN p_qtd_comprada INT
)
BEGIN
    -- Declaração do tratamento de erro: Se o banco de dados der erro, ele faz ROLLBACK automático
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK TO SAVEPOINT ponto_inicio;
        SELECT 'Erro na transação! Ação desfeita por segurança.' AS Resultado;
    END;

    -- Inicia a transação
    START TRANSACTION;
    
    -- Criação do SAVEPOINT 
    SAVEPOINT ponto_inicio;

    -- Ação 1: Registra a nova venda
    INSERT INTO venda (id_produto, quantidade_vendida) VALUES (p_id_produto, p_qtd_comprada);
    
    -- Ação 2: Atualiza o estoque
    UPDATE produto SET quantidade_estoque = quantidade_estoque - p_qtd_comprada WHERE id_produto = p_id_produto;

    -- Confirmação
    COMMIT;
    SELECT 'Compra processada com sucesso!' AS Resultado;

END //

DELIMITER ;

-- Testando a Procedure 
CALL sp_processa_compra_segura(1, 3);

-- Conferindo o resultado final 
SELECT * FROM produto;
SELECT * FROM venda;