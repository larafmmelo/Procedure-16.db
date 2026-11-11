# SQL - Procedures (DB Browser for SQLite)

Pacote do conteúdo **16 - Procedures com CREATE PROCEDURE**, com os exemplos e os 20 exercícios adaptados para SQLite / DB Browser.

## Arquivos

- `00_exemplos_procedures.sql` — exemplos do material e equivalentes executáveis no SQLite.
- `01_exercicios_procedures.sql` — preparação das tabelas e resolução dos 20 exercícios.
- `README.md` — instruções e diferenças entre MySQL e SQLite.

## Atenção: diferença fundamental

O material do professor ensina **Stored Procedures do MySQL**. O SQLite, usado pelo DB Browser, **não possui suporte a `CREATE PROCEDURE` nem `CALL`**.

Por isso, os arquivos deste pacote não fingem criar procedures. Eles apresentam as operações equivalentes em SQL que o DB Browser consegue executar: `SELECT`, `CASE`, `UPDATE`, CTE recursiva e consultas de metadados.

Se o professor exigir especificamente `CREATE PROCEDURE`, `CALL`, parâmetros `IN`/`OUT`/`INOUT`, `DECLARE`, `WHILE`, `LOOP`, `HANDLER` ou `SIGNAL`, será necessário executar essa parte em um SGBD compatível, como MySQL, e não no DB Browser for SQLite.

## Como executar no DB Browser

1. Abra o DB Browser for SQLite.
2. Clique em **New Database**.
3. Crie um banco novo chamado, por exemplo, `procedures_exemplos.db`.
4. Abra a aba **Execute SQL**.
5. Abra `00_exemplos_procedures.sql`.
6. Clique em **Execute all** e depois em **Write Changes**.
7. Crie outro banco novo chamado `procedures_exercicios.db`.
8. Abra `01_exercicios_procedures.sql`.
9. Clique em **Execute all** e depois em **Write Changes**.

## Bancos separados

Use um banco `.db` novo para cada script. Não execute os arquivos no banco de outro projeto: o script de exercícios cria tabelas de demonstração e remove tabelas com os mesmos nomes.

## Como os conceitos foram adaptados

| Recurso do MySQL | Alternativa no SQLite |
|---|---|
| `CREATE PROCEDURE` / `CALL` | Não existe; executar a consulta ou comando diretamente |
| Parâmetro `IN` | Substituir pelo valor de exemplo no `WHERE` |
| Parâmetro `OUT` | Retornar o resultado com `SELECT` |
| Parâmetro `INOUT` | Calcular o valor de entrada com expressão `SELECT` |
| `DECLARE` variável local | Expressões, subconsultas ou CTEs |
| `IF` / `CASE` procedural | `CASE` dentro de `SELECT` |
| `WHILE` / `LOOP` | CTE recursiva para repetições compatíveis |
| `UPDATE` dentro da procedure | Executar `UPDATE` diretamente, com condição de segurança |
| `HANDLER NOT FOUND` | Verificar existência com `COUNT(*)` ou `EXISTS` |
| `SIGNAL` | Não há equivalente direto em SQL comum do SQLite |
| `SHOW PROCEDURE STATUS` | Não há procedures para listar no SQLite |
| `SHOW CREATE PROCEDURE` | Não há definição de procedure armazenada no SQLite |
| `information_schema.routines` | Não existe no SQLite; metadados ficam em `sqlite_master` |

## Critérios adotados em exercícios

Alguns enunciados não informam limites ou valores de exemplo. Para tornar os comandos executáveis, foram usados exemplos explícitos:
- Padaria, exercício 5: até 3 itens = pequeno; até 7 = médio; acima de 7 = grande.
- Agência, exercício 15: até R$ 1.000 = econômico; até R$ 2.000 = padrão; acima de R$ 2.000 = premium.
- Os exercícios com `IN`, `OUT` e `INOUT` usam valores de demonstração indicados nos comentários.

## Publicar no GitHub

1. Extraia o ZIP.
2. Crie uma pasta no repositório, por exemplo `16-procedures`.
3. Adicione os dois arquivos `.sql` e o `README.md`.
4. Faça commit e push ou envie pelo site do GitHub.
5. Se o professor pediu somente os scripts, não precisa enviar os bancos `.db`.

## Importante para a entrega

Se a atividade for avaliada pela sintaxe de Stored Procedures do MySQL, estes equivalentes SQLite ajudam a estudar a lógica, mas não substituem a implementação MySQL. Confirme qual SGBD o professor exige para esta aula.
