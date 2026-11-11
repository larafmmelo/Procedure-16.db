-- 16 - PROCEDURES: exemplos e equivalentes para SQLite / DB Browser
--
-- ATENÇÃO:
-- O conteúdo do professor é de STORED PROCEDURES do MySQL.
-- O SQLite NÃO oferece CREATE PROCEDURE, CALL, parâmetros IN/OUT/INOUT,
-- DECLARE de variáveis locais, WHILE/LOOP ou DELIMITER.
-- Portanto, este arquivo demonstra as consultas e alterações equivalentes
-- que podem ser executadas no DB Browser. Não são stored procedures reais.

PRAGMA foreign_keys = ON;

-- ------------------------------------------------------------
-- Preparação das tabelas Produto e Estoque usadas no material
-- ------------------------------------------------------------
DROP TABLE IF EXISTS Estoque;
DROP TABLE IF EXISTS Produto;

CREATE TABLE Produto (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    ativo INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE Estoque (
    id_produto INTEGER NOT NULL,
    cnpj_filial TEXT NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 0,
    preco NUMERIC NOT NULL DEFAULT 0,
    PRIMARY KEY (id_produto, cnpj_filial),
    FOREIGN KEY (id_produto) REFERENCES Produto(id)
);

INSERT INTO Produto VALUES
(1, 'Caderno', 1),
(2, 'Caneta', 1),
(3, 'Agenda', 0);

INSERT INTO Estoque VALUES
(1, '10101010000110', 10, 20.00),
(2, '10101010000110', 0, 3.50),
(1, '30303030000130', 5, 21.00);

-- ------------------------------------------------------------
-- Exemplo 1: equivalente à procedure listar_produtos()
-- No MySQL: CALL listar_produtos();
-- No SQLite: executar diretamente o SELECT.
-- ------------------------------------------------------------
SELECT id, nome
FROM Produto
ORDER BY nome;

-- ------------------------------------------------------------
-- Exemplo 2: equivalente a consultar_produto(IN codigo)
-- O valor 1 representa o parâmetro IN.
-- Troque 1 por outro código para consultar outro produto.
-- ------------------------------------------------------------
SELECT id, nome
FROM Produto
WHERE id = 1;

-- ------------------------------------------------------------
-- Exemplo 3: equivalente a contar_produtos(OUT quantidade)
-- O resultado da contagem é retornado diretamente pelo SELECT.
-- ------------------------------------------------------------
SELECT COUNT(*) AS quantidade_produtos
FROM Produto;

-- ------------------------------------------------------------
-- Exemplo 4: equivalente a aplicar_desconto(INOUT valor)
-- Use um valor literal de exemplo. 80,00 com 10% de desconto = 72,00.
-- ------------------------------------------------------------
SELECT 80.00 AS valor_original,
       ROUND(80.00 * 0.90, 2) AS valor_com_desconto;

-- ------------------------------------------------------------
-- Exemplo 5: equivalente a variável local + COALESCE
-- Calcula a quantidade total do produto de código 1.
-- ------------------------------------------------------------
SELECT 1 AS id_produto,
       COALESCE(SUM(quantidade), 0) AS quantidade_total
FROM Estoque
WHERE id_produto = 1;

-- ------------------------------------------------------------
-- Exemplo 6: equivalente a IF para verificar disponibilidade
-- ------------------------------------------------------------
SELECT CASE
         WHEN COALESCE(SUM(quantidade), 0) > 0
           THEN 'Produto disponível'
         ELSE 'Produto indisponível'
       END AS situacao,
       COALESCE(SUM(quantidade), 0) AS quantidade_total
FROM Estoque
WHERE id_produto = 1;

-- ------------------------------------------------------------
-- Exemplo 7: equivalente a CASE para classificar preço
-- ------------------------------------------------------------
SELECT CASE
         WHEN MIN(preco) IS NULL THEN 'Sem preço cadastrado'
         WHEN MIN(preco) < 10 THEN 'Preço baixo'
         WHEN MIN(preco) < 50 THEN 'Preço intermediário'
         ELSE 'Preço alto'
       END AS classificacao
FROM Estoque
WHERE id_produto = 1;

-- ------------------------------------------------------------
-- Exemplo 8: equivalente a WHILE / LOOP para somar de 1 até 5
-- Em SQLite, uma CTE recursiva substitui a repetição procedural.
-- ------------------------------------------------------------
WITH RECURSIVE numeros(contador, total) AS (
    SELECT 1, 1
    UNION ALL
    SELECT contador + 1, total + contador + 1
    FROM numeros
    WHERE contador < 5
)
SELECT MAX(total) AS resultado
FROM numeros;

-- ------------------------------------------------------------
-- Exemplo 9: equivalente a procedure que altera preço
-- Confira os valores e execute o UPDATE diretamente.
-- ------------------------------------------------------------
UPDATE Estoque
SET preco = 25.95
WHERE id_produto = 1
  AND cnpj_filial = '10101010000110';

SELECT *
FROM Estoque
WHERE id_produto = 1
  AND cnpj_filial = '10101010000110';

-- ------------------------------------------------------------
-- Exemplo 10: verificar ausência de registro
-- COUNT retorna 0 quando não há correspondência.
-- ------------------------------------------------------------
SELECT COUNT(*) AS registros_encontrados,
       CASE
         WHEN COUNT(*) > 0 THEN 'Registro encontrado'
         ELSE 'Registro não encontrado'
       END AS situacao
FROM Estoque
WHERE id_produto = 1
  AND cnpj_filial = '99999999000199';

-- ------------------------------------------------------------
-- Metadados:
-- SQLite não armazena stored procedures. A consulta abaixo lista
-- tabelas, views, índices e triggers, não procedures.
-- ------------------------------------------------------------
SELECT type, name, sql
FROM sqlite_master
WHERE type IN ('table', 'view', 'index', 'trigger')
ORDER BY type, name;
