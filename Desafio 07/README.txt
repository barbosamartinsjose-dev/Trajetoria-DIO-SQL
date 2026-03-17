=============================================================================================================================================================
DESAFIO 07: TRANSACOES, TRATAMENTO DE ERROS E BACKUP
Este diretorio contem a solucao do desafio pratico focado em garantir a integridade dos dados atraves de Transacoes ACID, Stored Procedures com Savepoints e rotinas de Backup e Recovery em um ambiente simulado de E-commerce.

ESTRUTURA DOS ARQUIVOS
Script.sql: Script principal contendo:

Criacao do banco de dados "ecommerce_transacoes" e tabelas de estoque/vendas.

Execucao de transacoes manuais com controle de COMMIT e ROLLBACK.

Criacao da Stored Procedure "sp_processa_compra_segura", que utiliza DECLARE EXIT HANDLER FOR SQLEXCEPTION e SAVEPOINT para reverter a transacao automaticamente em caso de falha.

backup_ecommerce_transacoes.sql: Arquivo de dump gerado via linha de comando (mysqldump), contendo o backup completo da estrutura, dos dados e das rotinas (procedures) do banco.

1.png a 7.png: Evidencias visuais (prints) da execucao dos scripts no SGBD, testes das transacoes e da geracao do backup no terminal (CMD).

COMANDOS DE BACKUP E RESTAURACAO (CLI)
Para realizar o backup incluindo as logicas de negocio (Procedures), utilizei o prompt de comando do Windows com os parametros --routines e --events:

Comando de Backup (Dump):
mysqldump -u root -p --routines --events ecommerce_transacoes > backup_ecommerce_transacoes.sql

Comando de Restauracao (Recovery):
mysql -u root -p ecommerce_transacoes < backup_ecommerce_transacoes.sql

CONCEITOS APLICADOS
Transacoes: Garantia de que operacoes criticas (ex: registrar venda e baixar estoque) ocorram de forma atomica.

Tratamento de Excecoes: Prevencao de inconsistencias no banco de dados usando EXIT HANDLER.

Administracao de BD: Operacao do utilitario nativo do MySQL para salvaguarda de dados fisicos e logicos.

=============================================================================================================================================================