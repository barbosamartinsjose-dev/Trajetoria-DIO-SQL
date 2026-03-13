# 🗄️ Projeto: Otimização, Segurança e Automação em Banco de Dados Relacional

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Data_Base-blue?style=for-the-badge)

Este repositório contém a solução prática desenvolvida para o desafio de projeto focado em **Views, Controle de Acesso (DCL) e Triggers**, aplicando conceitos avançados de administração de banco de dados.

O projeto foi dividido em dois cenários corporativos reais para simular o dia a dia de um Administrador/Analista de Banco de Dados.

## 🏢 Cenário 1: Company (RH e Projetos)
O primeiro script (`parte1_company.sql`) lida com a estruturação de um sistema de Recursos Humanos, focando na proteção de dados sensíveis e facilitação de consultas analíticas.

* **Views Corporativas:** Criação de visões estratégicas (`vw_qtd_empregados_dept_local`, `vw_projetos_dept_gerentes`) para entregar métricas prontas sem expor a estrutura física das tabelas.
* **Segurança e Controle de Acesso (DCL):** Implementação do Princípio do Menor Privilégio.
  * Criação do usuário `gerente` com permissão de leitura sobre dados departamentais.
  * Criação do usuário `empregado_comum` com acesso restrito, utilizando os comandos `GRANT` e `REVOKE` para garantir que dados de outros departamentos fiquem inacessíveis.

## 🛒 Cenário 2: E-commerce (Automação de Logs)
O segundo script (`parte2_ecommerce.sql`) aborda a automação de processos e auditoria de dados, essenciais para a governança em ambientes de produção.

* **Trigger de Backup (`BEFORE DELETE`):** Gatilho que intercepta a exclusão de um usuário (`OLD`) e salva automaticamente seus dados e a data exata da exclusão em uma tabela de backup, prevenindo perdas acidentais.
* **Trigger de Auditoria (`BEFORE UPDATE`):** Gatilho na tabela de colaboradores que monitora o `salario_base`. Caso haja alteração, o sistema grava automaticamente o valor antigo, o valor novo e o timestamp em uma tabela de log (`log_salario`).

