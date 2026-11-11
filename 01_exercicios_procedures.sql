-- 16 - PROCEDURES: exercícios adaptados para SQLite / DB Browser
--
-- IMPORTANTE:
-- SQLite NÃO suporta stored procedures reais (CREATE PROCEDURE / CALL).
-- Cada exercício abaixo apresenta a operação SQL equivalente e executável.
-- Parâmetros IN/OUT/INOUT do MySQL são representados por valores de exemplo,
-- resultados SELECT, CTEs e alterações diretas nas tabelas.
-- Leia os comentários antes de executar os UPDATEs/DELETEs.

PRAGMA foreign_keys = ON;

-- ============================================================
-- PREPARAÇÃO: tabelas e dados para os exercícios
-- ============================================================

DROP TABLE IF EXISTS Supermercado_Estoque;
DROP TABLE IF EXISTS Supermercado_Produto;
DROP TABLE IF EXISTS Supermercado_Setor;
DROP TABLE IF EXISTS Pacote_Reserva;
DROP TABLE IF EXISTS Pacote_Turistico;
DROP TABLE IF EXISTS Agencia_Cliente;
DROP TABLE IF EXISTS Farmacia_Lote;
DROP TABLE IF EXISTS Farmacia_Medicamento;
DROP TABLE IF EXISTS Padaria_Venda_Item;
DROP TABLE IF EXISTS Padaria_Venda;
DROP TABLE IF EXISTS Padaria_Ingrediente;
DROP TABLE IF EXISTS Padaria_Fornecedor;
DROP TABLE IF EXISTS Padaria_Pao;

CREATE TABLE Padaria_Pao (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    preco NUMERIC NOT NULL,
    disponivel INTEGER NOT NULL DEFAULT 1
);
INSERT INTO Padaria_Pao VALUES
(1, 'Pão francês', 0.80, 1),
(2, 'Pão integral', 1.50, 1),
(3, 'Pão de queijo', 2.50, 0);

CREATE TABLE Padaria_Fornecedor (
    codigo INTEGER PRIMARY KEY,
    nome TEXT NOT NULL
);
INSERT INTO Padaria_Fornecedor VALUES
(1, 'Moinho Minas'), (2, 'Distribuidora Doce');

CREATE TABLE Padaria_Ingrediente (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    codigo_fornecedor INTEGER NOT NULL,
    quantidade_estoque NUMERIC NOT NULL,
    FOREIGN KEY (codigo_fornecedor) REFERENCES Padaria_Fornecedor(codigo)
);
INSERT INTO Padaria_Ingrediente VALUES
(1, 'Farinha', 1, 30), (2, 'Açúcar', 2, 12), (3, 'Fermento', 1, 5);

CREATE TABLE Padaria_Venda (
    codigo INTEGER PRIMARY KEY,
    data_venda TEXT NOT NULL
);
INSERT INTO Padaria_Venda VALUES (100, '2026-11-10'), (101, '2026-11-11');

CREATE TABLE Padaria_Venda_Item (
    id INTEGER PRIMARY KEY,
    codigo_venda INTEGER NOT NULL,
    codigo_pao INTEGER NOT NULL,
    quantidade INTEGER NOT NULL,
    FOREIGN KEY (codigo_venda) REFERENCES Padaria_Venda(codigo),
    FOREIGN KEY (codigo_pao) REFERENCES Padaria_Pao(id)
);
INSERT INTO Padaria_Venda_Item VALUES
(1, 100, 1, 3), (2, 100, 2, 2), (3, 101, 1, 8);

CREATE TABLE Farmacia_Medicamento (
    codigo INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    preco NUMERIC NOT NULL,
    estoque INTEGER NOT NULL
);
INSERT INTO Farmacia_Medicamento VALUES
(1, 'Analgésico', 12.50, 20),
(2, 'Antialérgico', 18.00, 5),
(3, 'Vitamina', 25.00, 0);

CREATE TABLE Farmacia_Lote (
    id INTEGER PRIMARY KEY,
    codigo_medicamento INTEGER NOT NULL,
    validade TEXT NOT NULL,
    quantidade INTEGER NOT NULL,
    FOREIGN KEY (codigo_medicamento) REFERENCES Farmacia_Medicamento(codigo)
);
INSERT INTO Farmacia_Lote VALUES
(1, 1, '2027-05-10', 12),
(2, 1, '2025-03-01', 8),
(3, 2, '2027-08-20', 5);

CREATE TABLE Agencia_Cliente (
    codigo INTEGER PRIMARY KEY,
    nome TEXT NOT NULL
);
INSERT INTO Agencia_Cliente VALUES (1, 'Ana'), (2, 'Bruno');

CREATE TABLE Pacote_Turistico (
    codigo INTEGER PRIMARY KEY,
    destino TEXT NOT NULL,
    regiao TEXT NOT NULL,
    preco NUMERIC NOT NULL,
    vagas_disponiveis INTEGER NOT NULL
);
INSERT INTO Pacote_Turistico VALUES
(1, 'Porto Seguro', 'Nordeste', 1200, 8),
(2, 'Gramado', 'Sul', 1800, 0),
(3, 'Maceió', 'Nordeste', 1500, 5),
(4, 'Bonito', 'Centro-Oeste', 2100, 4);

CREATE TABLE Pacote_Reserva (
    id INTEGER PRIMARY KEY,
    codigo_cliente INTEGER NOT NULL,
    codigo_pacote INTEGER NOT NULL,
    FOREIGN KEY (codigo_cliente) REFERENCES Agencia_Cliente(codigo),
    FOREIGN KEY (codigo_pacote) REFERENCES Pacote_Turistico(codigo)
);
INSERT INTO Pacote_Reserva VALUES (1, 1, 1), (2, 1, 3), (3, 2, 2);

CREATE TABLE Supermercado_Setor (
    codigo INTEGER PRIMARY KEY,
    nome TEXT NOT NULL
);
INSERT INTO Supermercado_Setor VALUES (1, 'Mercearia'), (2, 'Limpeza');

CREATE TABLE Supermercado_Produto (
    codigo INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    codigo_setor INTEGER NOT NULL,
    FOREIGN KEY (codigo_setor) REFERENCES Supermercado_Setor(codigo)
);
INSERT INTO Supermercado_Produto VALUES
(1, 'Arroz', 1), (2, 'Feijão', 1), (3, 'Detergente', 2);

CREATE TABLE Supermercado_Estoque (
    codigo_produto INTEGER PRIMARY KEY,
    quantidade INTEGER NOT NULL,
    FOREIGN KEY (codigo_produto) REFERENCES Supermercado_Produto(codigo)
);
INSERT INTO Supermercado_Estoque VALUES (1, 50), (2, 30), (3, 20);

-- ============================================================
-- PADARIA
-- ============================================================

-- EXERCÍCIO 1
-- Listar nome e preço dos pães disponíveis.
-- Equivalente ao SELECT dentro de uma procedure sem parâmetros.
SELECT nome, preco
FROM Padaria_Pao
WHERE disponivel = 1
ORDER BY nome;

-- EXERCÍCIO 2
-- Ingredientes fornecidos por um código de fornecedor (IN = 1).
SELECT id, nome, quantidade_estoque
FROM Padaria_Ingrediente
WHERE codigo_fornecedor = 1;

-- EXERCÍCIO 3
-- Quantidade total de produtos de uma categoria (exemplo: pães).
-- Como o modelo preparado não possui categoria, usamos a tabela
-- Padaria_Pao como conjunto de produtos cadastrados.
SELECT COUNT(*) AS quantidade_total_produtos
FROM Padaria_Pao;

-- EXERCÍCIO 4
-- INOUT: aplicar acréscimo de 5% ao preço recebido.
-- Valor de entrada de exemplo: 10,00. Resultado: 10,50.
SELECT 10.00 AS preco_original,
       ROUND(10.00 * 1.05, 2) AS preco_com_acrescimo;

-- EXERCÍCIO 5
-- Classificar venda como pequena, média ou grande pela quantidade.
-- Critérios adotados para o exemplo: até 3 = pequena; até 7 = média;
-- acima de 7 = grande. A lista do professor não define os limites.
SELECT v.codigo AS codigo_venda,
       SUM(i.quantidade) AS quantidade_vendida,
       CASE
         WHEN SUM(i.quantidade) <= 3 THEN 'Pequeno'
         WHEN SUM(i.quantidade) <= 7 THEN 'Médio'
         ELSE 'Grande'
       END AS classificacao
FROM Padaria_Venda AS v
JOIN Padaria_Venda_Item AS i ON i.codigo_venda = v.codigo
WHERE v.codigo = 100
GROUP BY v.codigo;

-- ============================================================
-- FARMÁCIA
-- ============================================================

-- EXERCÍCIO 6
-- Lotes de um medicamento (código 1) com validade não vencida.
SELECT id, codigo_medicamento, validade, quantidade
FROM Farmacia_Lote
WHERE codigo_medicamento = 1
  AND date(validade) >= date('now');

-- EXERCÍCIO 7
-- Variável local equivalente: calcular valor total em estoque.
-- Considera quantidade geral do medicamento x preço unitário.
SELECT codigo,
       nome,
       estoque,
       preco,
       estoque * preco AS valor_total_estoque
FROM Farmacia_Medicamento
WHERE codigo = 1;

-- EXERCÍCIO 8
-- Atualizar preço por código e novo valor.
-- Exemplo: medicamento 1 passa a custar R$ 13,90.
UPDATE Farmacia_Medicamento
SET preco = 13.90
WHERE codigo = 1;

SELECT * FROM Farmacia_Medicamento WHERE codigo = 1;

-- EXERCÍCIO 9
-- OUT: verificar se quantidade vendida está dentro do estoque.
-- Exemplo: venda de 4 unidades do medicamento 1.
SELECT codigo,
       estoque AS estoque_disponivel,
       4 AS quantidade_solicitada,
       CASE
         WHEN 4 <= estoque THEN 'Dentro do estoque'
         ELSE 'Fora do estoque'
       END AS situacao
FROM Farmacia_Medicamento
WHERE codigo = 1;

-- EXERCÍCIO 10
-- Registrar retirada somente se houver quantidade suficiente.
-- Exemplo: retirar 3 unidades do medicamento 1.
-- O UPDATE condicional só altera quando estoque >= 3.
UPDATE Farmacia_Medicamento
SET estoque = estoque - 3
WHERE codigo = 1
  AND estoque >= 3;

SELECT * FROM Farmacia_Medicamento WHERE codigo = 1;

-- ============================================================
-- AGÊNCIA DE VIAGENS
-- ============================================================

-- EXERCÍCIO 11
-- Listar pacotes com vagas disponíveis.
SELECT codigo, destino, regiao, preco, vagas_disponiveis
FROM Pacote_Turistico
WHERE vagas_disponiveis > 0
ORDER BY destino;

-- EXERCÍCIO 12
-- Consultar reservas por código do cliente (IN = 1).
SELECT r.id, r.codigo_cliente, p.destino, p.preco
FROM Pacote_Reserva AS r
JOIN Pacote_Turistico AS p ON p.codigo = r.codigo_pacote
WHERE r.codigo_cliente = 1;

-- EXERCÍCIO 13
-- OUT: número de destinos cadastrados por região.
-- A lista não fornece uma tabela de destinos separada; usamos
-- os pacotes cadastrados e contamos destinos distintos por região.
SELECT regiao,
       COUNT(DISTINCT destino) AS quantidade_destinos
FROM Pacote_Turistico
GROUP BY regiao
ORDER BY regiao;

-- EXERCÍCIO 14
-- Atualizar preço de pacote usando código, preço atual e novo preço.
-- Exemplo: pacote 1, preço atual 1200, novo preço 1250.
-- O preço atual faz parte do WHERE para evitar atualização inesperada.
UPDATE Pacote_Turistico
SET preco = 1250
WHERE codigo = 1
  AND preco = 1200;

SELECT * FROM Pacote_Turistico WHERE codigo = 1;

-- EXERCÍCIO 15
-- Classificar pacote pelo valor recebido.
-- Critérios adotados para o exemplo: até 1000 = econômico;
-- até 2000 = padrão; acima de 2000 = premium.
SELECT codigo,
       destino,
       preco,
       CASE
         WHEN preco <= 1000 THEN 'Econômico'
         WHEN preco <= 2000 THEN 'Padrão'
         ELSE 'Premium'
       END AS classificacao
FROM Pacote_Turistico;

-- ============================================================
-- SUPERMERCADO
-- ============================================================

-- EXERCÍCIO 16
-- Produtos de um setor (IN = 1).
SELECT p.codigo, p.nome, s.nome AS setor
FROM Supermercado_Produto AS p
JOIN Supermercado_Setor AS s ON s.codigo = p.codigo_setor
WHERE p.codigo_setor = 1;

-- EXERCÍCIO 17
-- INOUT: converter unidades em pacotes de dez.
-- Exemplo de entrada: 37 unidades. Resultado: 3 pacotes completos
-- e 7 unidades restantes.
SELECT 37 AS quantidade_unidades,
       CAST(37 / 10 AS INTEGER) AS pacotes_dez,
       37 % 10 AS unidades_restantes;

-- EXERCÍCIO 18
-- Atualizar estoque somente se o novo valor não for negativo.
-- Exemplo: alterar quantidade do produto 1 para 45.
UPDATE Supermercado_Estoque
SET quantidade = 45
WHERE codigo_produto = 1
  AND 45 >= 0;

SELECT * FROM Supermercado_Estoque WHERE codigo_produto = 1;

-- EXERCÍCIO 19
-- O enunciado pede consultar uma procedure e exibir seu código SQL.
-- SQLite não armazena procedures. A consulta abaixo procura esse tipo
-- de objeto e, neste banco, não retornará registros.
SELECT name, sql
FROM sqlite_master
WHERE type = 'procedure';

-- EXERCÍCIO 20
-- Listar procedures armazenadas no banco atual.
-- SQLite não oferece stored procedures; por isso o resultado será vazio.
SELECT name, sql
FROM sqlite_master
WHERE type = 'procedure'
ORDER BY name;

-- Diferença conceitual solicitada:
-- EXECUTAR: chama uma rotina para realizar sua tarefa.
-- REMOVER: exclui a definição da rotina do banco.
-- No MySQL, a execução é feita com CALL nome_procedure(...).
-- A remoção é feita com DROP PROCEDURE nome_procedure.
-- No SQLite, não há procedures para executar ou remover.

-- ============================================================
-- CONFERÊNCIA FINAL
-- ============================================================
SELECT * FROM Padaria_Pao;
SELECT * FROM Padaria_Ingrediente;
SELECT * FROM Farmacia_Medicamento;
SELECT * FROM Farmacia_Lote;
SELECT * FROM Pacote_Turistico;
SELECT * FROM Supermercado_Produto;
SELECT * FROM Supermercado_Estoque;
