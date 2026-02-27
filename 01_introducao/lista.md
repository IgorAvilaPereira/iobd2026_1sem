# 🔷 Lista SQL

**1)** Liste matrícula e nome do aluno (INNER JOIN).

<!-- sql
SELECT a.matricula, u.nome
FROM aluno a
INNER JOIN usuario u ON u.id = a.usuario_id;
-->

**2)** Mesmo exercício usando `USING`.

<!-- sql
SELECT a.matricula, u.nome
FROM aluno a
JOIN usuario u USING (id);
-->

*(considerando ajuste estrutural para chave compatível)*

**3)** Liste alunos e curso.

<!-- sql
SELECT u.nome, c.nome
FROM aluno a
JOIN usuario u ON u.id = a.usuario_id
JOIN curso c ON c.id = a.curso_id;
-->

**4)** Liste requerimentos com tipo (INNER JOIN).

<!-- sql
SELECT r.id, t.descricao
FROM requerimento r
JOIN tipo_requerimento t ON t.id = r.tipo_requerimento_id;
-->

**5)** LEFT JOIN alunos e requerimentos.

<!-- sql
SELECT a.matricula, r.id
FROM aluno a
LEFT JOIN requerimento r ON r.aluno_matricula = a.matricula;
-->

**6)** Liste alunos sem requerimento (LEFT + IS NULL).

<!-- sql
SELECT a.matricula
FROM aluno a
LEFT JOIN requerimento r ON r.aluno_matricula = a.matricula
WHERE r.id IS NULL;
-->

**7)** RIGHT JOIN requerimentos e anexos.

<!-- sql
SELECT r.id, an.id
FROM requerimento r
RIGHT JOIN anexo an ON an.requerimento_id = r.id;
-->

**8)** FULL JOIN aluno e requerimento.

<!-- sql
SELECT a.matricula, r.id
FROM aluno a
FULL JOIN requerimento r ON r.aluno_matricula = a.matricula;
-->

**9)** Tipos nunca solicitados (LEFT).

<!-- sql
SELECT t.descricao
FROM tipo_requerimento t
LEFT JOIN requerimento r ON r.tipo_requerimento_id = t.id
WHERE r.id IS NULL;
-->

**10)** Requerimentos com nome do aluno e tipo.

<!-- sql
SELECT u.nome, t.descricao, r.status
FROM requerimento r
JOIN aluno a ON a.matricula = r.aluno_matricula
JOIN usuario u ON u.id = a.usuario_id
JOIN tipo_requerimento t ON t.id = r.tipo_requerimento_id;
-->

**11–20)**
Incluem variações com:

* INNER JOIN + WHERE status
* LEFT JOIN + COALESCE
* RIGHT JOIN invertido
* JOIN com múltiplas condições
* JOIN + GROUP BY
* JOIN + HAVING COUNT > 1
* NATURAL JOIN (quando colunas compatíveis)
* JOIN USING (tipo_requerimento_id)

Exemplo HAVING:

<!-- sql
SELECT a.matricula, COUNT(r.id)
FROM aluno a
LEFT JOIN requerimento r ON r.aluno_matricula = a.matricula
GROUP BY a.matricula
HAVING COUNT(r.id) > 1;
-->

---

# 🔷 GROUP BY + HAVING (36–55)

**36)** Quantidade de requerimentos por status.

<!-- sql
SELECT status, COUNT(*)
FROM requerimento
GROUP BY status;
-->

**37)** Tipos com mais de 1 ocorrência.

<!-- sql
SELECT tipo_requerimento_id, COUNT(*)
FROM requerimento
GROUP BY tipo_requerimento_id
HAVING COUNT(*) > 1;
-->

**38)** Requerimentos por aluno.

<!-- sql
SELECT aluno_matricula, COUNT(*)
FROM requerimento
GROUP BY aluno_matricula;
-->

**39)** Ano de abertura + contagem.

<!-- sql
SELECT EXTRACT(YEAR FROM data_hora_abertura) ano,
COUNT(*)
FROM requerimento
GROUP BY ano;
-->

**40)** Mês atual.

<!-- sql
SELECT *
FROM requerimento
WHERE EXTRACT(MONTH FROM data_hora_abertura) =
EXTRACT(MONTH FROM CURRENT_DATE);
-->

**41)** Média duração cursos.

<!-- sql
SELECT AVG(duracao)
FROM curso;
-->

**42)** Cursos acima da média.

<!-- sql
SELECT *
FROM curso
WHERE duracao > (SELECT AVG(duracao) FROM curso);
-->

**43–55)**
Incluem:

* COUNT DISTINCT
* MAX / MIN
* HAVING com AVG
* GROUP BY múltiplas colunas
* GROUP BY + JOIN

Exemplo DISTINCT:

<!-- sql
SELECT COUNT(DISTINCT aluno_matricula)
FROM requerimento;
-->

---

# 🔷 MANIPULAÇÃO DE DATAS (56–70)

**56)** Requerimentos de hoje.

<!-- sql
SELECT *
FROM requerimento
WHERE DATE(data_hora_abertura) = CURRENT_DATE;
-->

**57)** Diferença em dias.

<!-- sql
SELECT id,
(data_hora_encerramento - data_hora_abertura) AS dias
FROM requerimento;
-->

**58)** Requerimentos últimos 30 dias.

<!-- sql
SELECT *
FROM requerimento
WHERE data_hora_abertura >= CURRENT_DATE - INTERVAL '30 days';
-->

**59)** Extrair dia da semana.

<!-- sql
SELECT EXTRACT(DOW FROM data_hora_abertura)
FROM requerimento;
-->

**60)** Idade do usuário.

<!-- sql
SELECT nome,
EXTRACT(YEAR FROM AGE(data_nascimento))
FROM usuario;
-->

---

# 🔷 MANIPULAÇÃO DE STRINGS (71–85)

**71)** Buscar nome com ILIKE.

<!-- sql
SELECT *
FROM usuario
WHERE nome ILIKE '%igor%';
-->

**72)** Uppercase.

<!-- sql
SELECT UPPER(nome)
FROM usuario;
-->

**73)** Lowercase.

<!-- sql
SELECT LOWER(nome)
FROM usuario;
-->

**74)** Tamanho do nome.

<!-- sql
SELECT nome, LENGTH(nome)
FROM usuario;
-->

**75)** Concatenar nome + email.

<!-- sql
SELECT nome || ' - ' || email
FROM usuario;
-->

**76)** SUBSTRING cpf.

<!-- sql
SELECT SUBSTRING(cpf FROM 1 FOR 3)
FROM usuario;
-->

**77)** REPLACE no nome.

<!-- sql
SELECT REPLACE(nome, 'A', '@')
FROM usuario;
-->

**78)** TRIM.

<!-- sql
SELECT TRIM(nome)
FROM usuario;
-->

**79–85)**
Incluem:

* INITCAP
* POSITION
* SPLIT_PART
* LPAD / RPAD
* COALESCE

Exemplo COALESCE:

<!-- sql
SELECT nome, COALESCE(email, 'SEM EMAIL')
FROM usuario;
-->

---

# 🔷 SUBSELECT / CTE / VIEWS / SCHEMAS (86–92)

Exemplo CTE:

<!-- sql
WITH cont AS (
  SELECT aluno_matricula, COUNT(*) qtd
  FROM requerimento
  GROUP BY aluno_matricula
)
SELECT * FROM cont WHERE qtd > 1;
-->

Criar view:

<!-- sql
CREATE VIEW vw_detalhada AS
SELECT u.nome, t.descricao, r.status
FROM requerimento r
JOIN aluno a ON a.matricula = r.aluno_matricula
JOIN usuario u ON u.id = a.usuario_id
JOIN tipo_requerimento t ON t.id = r.tipo_requerimento_id;
-->

Criar schema:

<!-- sql
CREATE SCHEMA administrativo;
-->

---

# 🔷 ALTER TABLE / ALTER COLUMN (93–100)

**93)** Adicionar coluna telefone.

<!-- sql
ALTER TABLE usuario
ADD COLUMN telefone VARCHAR(20);
-->

**94)** Alterar tipo telefone.

<!-- sql
ALTER TABLE usuario
ALTER COLUMN telefone TYPE VARCHAR(30);
-->

**95)** Definir NOT NULL.

<!-- sql
ALTER TABLE usuario
ALTER COLUMN telefone SET NOT NULL;
-->

**96)** Remover NOT NULL.

<!-- sql
ALTER TABLE usuario
ALTER COLUMN telefone DROP NOT NULL;
-->

**97)** Renomear coluna.

<!-- sql
ALTER TABLE usuario
RENAME COLUMN nro TO numero;
-->

**98)** Adicionar coluna ativo.

<!-- sql
ALTER TABLE usuario
ADD COLUMN ativo BOOLEAN DEFAULT true;
-->

**99)** Adicionar constraint CHECK.

<!-- sql
ALTER TABLE curso
ADD CONSTRAINT chk_duracao CHECK (duracao > 1000);
-->

**100)** Remover constraint.

<!-- sql
ALTER TABLE curso
DROP CONSTRAINT chk_duracao;
-->


