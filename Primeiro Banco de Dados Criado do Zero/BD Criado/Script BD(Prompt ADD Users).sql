-- =======================================================
-- INSERÇÃO DE DADOS PARA TESTE (POPULANDO AS TABELAS)
-- Utilizei o Gemini para pegar esses dados ficticios
-- =======================================================

-- 1. Inserindo Clientes (Testando PF e PJ)
INSERT INTO cliente (Fname, Minit, Lname, CPF, CNPJ, tipo_cliente, address) VALUES
('Maria', 'M', 'Silva', '12345678911', NULL, 'PF', 'Rua Silva, 29, Carangola - RJ'),
('TechCorp', 'T', 'SA', NULL, '12345678901234', 'PJ', 'Av Central, 100, São Paulo - SP'),
('João', 'J', 'Souza', '98765432100', NULL, 'PF', 'Rua das Flores, 12, Campinas - SP'),
('Ana', 'A', 'Dias', '45612378922', NULL, 'PF', 'Rua Ouro, 8, Carangola - RJ');

-- 2. Inserindo Formas de Pagamento
INSERT INTO pagamento (idCliente, tipoPagamento, limiteDisponivel) VALUES
(1, 'Cartão', 1500.00),
(2, 'Pix', NULL),
(3, 'Boleto', NULL),
(1, 'Dois cartões', 3000.00);

-- 3. Inserindo Produtos
INSERT INTO produto (Fname, classificação, categoria, avaliação, dimenções) VALUES
('Fone de Ouvido', false, 'Eletronico', 4.5, NULL),
('Barbie', true, 'Brinquedos', 4.8, NULL),
('Sofá 3 Lugares', false, 'Moveis', 4.0, '3x57x80'),
('Camiseta Básica', true, 'Vestimenta', 4.2, NULL),
('Chocolate', true, 'Alimentos', 5.0, NULL);

-- 4. Inserindo Pedidos (Maria terá 2 pedidos para testarmos a query com HAVING)
INSERT INTO pedido (idPedidoCliente, pedidoStatus, descrição, frete) VALUES
(1, 'Confirmado', 'Compra via App', 15.50), -- Pedido 1 (Maria)
(2, 'Em processamento', 'Compra B2B', 50.00), -- Pedido 2 (TechCorp)
(1, 'Confirmado', 'Compra Web', 10.00),     -- Pedido 3 (Maria - 2º pedido)
(3, 'Cancelado', 'Desistência', 0.00);      -- Pedido 4 (João)

-- 5. Inserindo Entregas
INSERT INTO entrega (idPedido, statusEntrega, codigoRastreio, dataPrevista) VALUES
(1, 'Em trânsito', 'BR123456789RJ', '2023-11-10'),
(2, 'Em separação', NULL, '2023-11-15'),
(3, 'Entregue', 'BR987654321RJ', '2023-10-05');

-- 6. Inserindo Estoque
INSERT INTO estoque (localização, quantidade) VALUES
('Galpão RJ', 1000),
('Galpão SP', 500);

-- 7. Inserindo Fornecedores
INSERT INTO fornecedor (nomesocial, CNPJ, contato) VALUES
('Eletrônicos do Futuro', '11111111111111', '11999999999'), -- CNPJ proposital
('Brinquedos Feliz', '88765432109876', '21988888888');

-- 8. Inserindo Vendedores Terceiros (O primeiro tem o mesmo CNPJ do Fornecedor acima!)
INSERT INTO vendedor (nomefantasia, CNPJ, CPF, contato, endereço) VALUES
('Tech Eletronics', '11111111111111', NULL, '21977777777', 'Rio de Janeiro'), 
('Boutique Durgas', NULL, '12312312345', '11966666666', 'São Paulo');

-- 9. Relacionando Produtos aos Vendedores (produtoVendedor)
INSERT INTO produtoVendedor (idPvendedor, idProduto, quantidade) VALUES
(1, 1, 50), -- Tech Eletronics vende Fone de Ouvido
(2, 4, 100); -- Boutique Durgas vende Camiseta

-- 10. Relacionando Produtos aos Pedidos (ordproduto)
-- Atenção: idOrdproduto = ID do Produto | idOrordem = ID do Pedido
INSERT INTO ordproduto (idOrdproduto, idOrordem, orQuantidade, ordStatus) VALUES
(1, 1, 2, 'Disponivel'), -- 2 Fones no Pedido 1
(3, 2, 1, 'Disponivel'), -- 1 Sofá no Pedido 2
(2, 3, 1, 'Disponivel'); -- 1 Barbie no Pedido 3