-- Criando DATABASE no Banco de Dados
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Tabela Produtos 
CREATE TABLE IF NOT EXISTS produto(
	id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL 
);

-- Apaga a procedure se ela já existir
DROP PROCEDURE IF EXISTS sp_manipula_produto;

-- Manipulação com delimiter
DELIMITER //
CREATE PROCEDURE sp_manipula_produto(
	IN p_acao INT,
    IN p_id_produto INT,
    IN p_nome_produto VARCHAR(100),
    IN p_valor DECIMAL(10, 2)
)
BEGIN
	CASE p_acao
		WHEN 1 THEN
			INSERT INTO produto (nome_produto, valor) VALUES (p_nome_produto, p_valor);
            SELECT 'Produto inserido com sucesso!' AS Resultado;
            
		WHEN 2 THEN
			UPDATE produto SET nome_produto = p_nome_produto, valor = p_valor WHERE id_produto = p_id_produto;
            SELECT 'Produto Atualizado com sucesso!' AS Resultado;
            
		WHEN 3 THEN
            -- Corrigido de 'produtos' para 'produto' para bater com o nome da tabela
			DELETE FROM produto WHERE id_produto = p_id_produto;
            SELECT 'Produto removido com sucesso!' AS Resultado;
            
		ELSE
			SELECT 'Ação invalida. Escolha 1 (Insert), 2 (Update) ou 3 (Delete).' AS Resultado;
		
        END CASE;
END //
DELIMITER ;


--		  				    ##############################
-- 							FAzendo Testes como solicitado
--		  				    ##############################



-- Testando primeira opção Inserção
CALL sp_manipula_produto(1, NULL, 'Monitor Ultrawide', 1500.00);
CALL sp_manipula_produto(1, NULL, 'Teclado Mecânico', 350.00);

-- Verificando os Dados que foram inseridos
SELECT * FROM produto;

-- Testando ATT opção numero 2
CALL sp_manipula_produto(2, 1, 'Monitor Ultrawide', 1400.00);

-- Verificando os Dados que foram inseridos
SELECT * FROM produto;

-- Testando Delete opção 3
CALL sp_manipula_produto(3, 2, NULL, NULL);

-- Verificando os Dados que foram inseridos
SELECT * FROM produto;