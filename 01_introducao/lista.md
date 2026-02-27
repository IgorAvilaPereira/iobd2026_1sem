# 🔷 Lista SQL

**1)** Liste matrícula e nome do aluno (INNER JOIN).

<!-- <!-- ```sql
SELECT a.matricula, u.nome
FROM aluno a
INNER JOIN usuario u ON u.id = a.usuario_id;
-->

**2)** Mesmo exercício usando `USING`.

<!-- <!-- ```sql
SELECT a.matricula, u.nome
FROM aluno a
JOIN usuario u USING (id);
-->

*(considerando ajuste estrutural para chave compatível)*

**3)** Liste alunos e curso.

<!-- <!-- ```sql
SELECT u.nome, c.nome
FROM aluno a
JOIN usuario u ON u.id = a.usuario_id
JOIN curso c ON c.id = a.curso_id;
-->

**4)** Liste requerimentos com tipo (INNER JOIN).

<!-- <!-- ```sql
SELECT r.id, t.descricao
FROM requerimento r
JOIN tipo_requerimento t ON t.id = r.tipo_requerimento_id;
-->

**5)** LEFT JOIN alunos e requerimentos.

<!-- <!-- ```sql
SELECT a.matricula, r.id
FROM aluno a
LEFT JOIN requerimento r ON r.aluno_matricula = a.matricula;
-->

**6)** Liste alunos sem requerimento (LEFT + IS NULL).

<!-- <!-- ```sql
SELECT a.matricula
FROM aluno a
LEFT JOIN requerimento r ON r.aluno_matricula = a.matricula
WHERE r.id IS NULL;
-->

**7)** RIGHT JOIN requerimentos e anexos.

<!-- <!-- ```sql
SELECT r.id, an.id
FROM requerimento r
RIGHT JOIN anexo an ON an.requerimento_id = r.id;
-->

**8)** FULL JOIN aluno e requerimento.

<!-- <!-- ```sql
SELECT a.matricula, r.id
FROM aluno a
FULL JOIN requerimento r ON r.aluno_matricula = a.matricula;
-->

**9)** Tipos nunca solicitados (LEFT).

<!-- <!-- ```sql
SELECT t.descricao
FROM tipo_requerimento t
LEFT JOIN requerimento r ON r.tipo_requerimento_id = t.id
WHERE r.id IS NULL;
-->

**10)** Requerimentos com nome do aluno e tipo.

<!-- <!-- ```sql
SELECT u.nome, t.descricao, r.status
FROM requerimento r
JOIN aluno a ON a.matricula = r.aluno_matricula
JOIN usuario u ON u.id = a.usuario_id
JOIN tipo_requerimento t ON t.id = r.tipo_requerimento_id;
-->

# 🔷 JOINS AVANÇADOS (11–20)

**11)** Liste requerimentos deferidos com nome do aluno (INNER JOIN + WHERE).

<!-- sql
SELECT u.nome, r.id
FROM requerimento r
JOIN aluno a ON a.matricula = r.aluno_matricula
JOIN usuario u ON u.id = a.usuario_id
WHERE r.status = 'DEFERIDO';
-->

**12)** Liste requerimentos indeferidos com descrição do tipo.

<!-- sql
SELECT r.id, t.descricao
FROM requerimento r
JOIN tipo_requerimento t ON t.id = r.tipo_requerimento_id
WHERE r.status = 'INDEFERIDO';
-->

**13)** Liste alunos e quantidade de requerimentos (LEFT JOIN + GROUP BY).

<!-- sql
SELECT a.matricula, COUNT(r.id) qtd
FROM aluno a
LEFT JOIN requerimento r ON r.aluno_matricula = a.matricula
GROUP BY a.matricula;
-->

**14)** Liste apenas alunos com mais de 1 requerimento (HAVING).

<!-- sql
SELECT a.matricula, COUNT(r.id) qtd
FROM aluno a
JOIN requerimento r ON r.aluno_matricula = a.matricula
GROUP BY a.matricula
HAVING COUNT(r.id) > 1;
-->

**15)** Liste requerimentos com quantidade de anexos (LEFT + COALESCE).

<!-- sql
SELECT r.id,
COALESCE(COUNT(a.id),0) qtd_anexos
FROM requerimento r
LEFT JOIN anexo a ON a.requerimento_id = r.id
GROUP BY r.id;
-->

**16)** Liste todos os usuários e suas possíveis matrículas (LEFT JOIN).

<!-- sql
SELECT u.nome, a.matricula
FROM usuario u
LEFT JOIN aluno a ON a.usuario_id = u.id;
-->

**17)** Liste cursos e alunos (RIGHT JOIN).

<!-- sql
SELECT c.nome, a.matricula
FROM aluno a
RIGHT JOIN curso c ON c.id = a.curso_id;
-->

**18)** Liste requerimentos e anexos apenas quando houver anexo (INNER JOIN).

<!-- sql
SELECT r.id, a.id
FROM requerimento r
JOIN anexo a ON a.requerimento_id = r.id;
-->

**19)** Liste todos alunos e requerimentos inclusive sem correspondência (FULL JOIN).

<!-- sql
SELECT a.matricula, r.id
FROM aluno a
FULL JOIN requerimento r
ON r.aluno_matricula = a.matricula;
-->

**20)** Utilize JOIN ... USING para listar requerimentos e tipo.

<!-- sql
SELECT r.id, t.descricao
FROM requerimento r
JOIN tipo_requerimento t
USING (tipo_requerimento_id);
-->



# 🔷 GROUP BY + HAVING (36–55)

**36)** Quantidade de requerimentos por status.

<!-- <!-- ```sql
SELECT status, COUNT(*)
FROM requerimento
GROUP BY status;
-->

**37)** Tipos com mais de 1 ocorrência.

<!-- <!-- ```sql
SELECT tipo_requerimento_id, COUNT(*)
FROM requerimento
GROUP BY tipo_requerimento_id
HAVING COUNT(*) > 1;
-->

**38)** Requerimentos por aluno.

<!-- <!-- ```sql
SELECT aluno_matricula, COUNT(*)
FROM requerimento
GROUP BY aluno_matricula;
-->

**39)** Ano de abertura + contagem.

<!-- <!-- ```sql
SELECT EXTRACT(YEAR FROM data_hora_abertura) ano,
COUNT(*)
FROM requerimento
GROUP BY ano;
-->

**40)** Mês atual.

<!-- <!-- ```sql
SELECT *
FROM requerimento
WHERE EXTRACT(MONTH FROM data_hora_abertura) =
EXTRACT(MONTH FROM CURRENT_DATE);
-->

**41)** Média duração cursos.

<!-- <!-- ```sql
SELECT AVG(duracao)
FROM curso;
-->

**42)** Cursos acima da média.

<!-- <!-- ```sql
SELECT *
FROM curso
WHERE duracao > (SELECT AVG(duracao) FROM curso);
-->


# 🔷 GROUP BY / HAVING (43–55)

**43)** Conte quantidade distinta de alunos que abriram requerimento.

<!-- sql
SELECT COUNT(DISTINCT aluno_matricula)
FROM requerimento;
-->

**44)** Liste o aluno com maior número de requerimentos.

<!-- sql
SELECT aluno_matricula, COUNT(*) qtd
FROM requerimento
GROUP BY aluno_matricula
ORDER BY qtd DESC
LIMIT 1;
-->

**45)** Liste quantidade de requerimentos por ano.

<!-- sql
SELECT EXTRACT(YEAR FROM data_hora_abertura) ano,
COUNT(*)
FROM requerimento
GROUP BY ano;
-->

**46)** Liste quantidade por mês do ano atual.

<!-- sql
SELECT EXTRACT(MONTH FROM data_hora_abertura) mes,
COUNT(*)
FROM requerimento
WHERE EXTRACT(YEAR FROM data_hora_abertura) =
EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY mes;
-->

**47)** Média de requerimentos por aluno.

<!-- sql
SELECT AVG(qtd)
FROM (
  SELECT COUNT(*) qtd
  FROM requerimento
  GROUP BY aluno_matricula
) sub;
-->

**48)** Liste tipos ordenados pela quantidade.

<!-- sql
SELECT tipo_requerimento_id, COUNT(*) qtd
FROM requerimento
GROUP BY tipo_requerimento_id
ORDER BY qtd DESC;
-->

**49)** Liste tipos com pelo menos 2 solicitações.

<!-- sql
SELECT tipo_requerimento_id, COUNT(*) qtd
FROM requerimento
GROUP BY tipo_requerimento_id
HAVING COUNT(*) >= 2;
-->

**50)** Quantidade de anexos por requerimento com HAVING > 0.

<!-- sql
SELECT requerimento_id, COUNT(*) qtd
FROM anexo
GROUP BY requerimento_id
HAVING COUNT(*) > 0;
-->

**51)** Total de requerimentos encerrados por ano.

<!-- sql
SELECT EXTRACT(YEAR FROM data_hora_encerramento) ano,
COUNT(*)
FROM requerimento
WHERE data_hora_encerramento IS NOT NULL
GROUP BY ano;
-->

**52)** Requerimentos por status ordenados.

<!-- sql
SELECT status, COUNT(*) qtd
FROM requerimento
GROUP BY status
ORDER BY qtd DESC;
-->

**53)** Liste cursos e total de alunos (JOIN + GROUP).

<!-- sql
SELECT c.nome, COUNT(a.matricula)
FROM curso c
LEFT JOIN aluno a ON a.curso_id = c.id
GROUP BY c.nome;
-->

**54)** Liste cursos com mais de 10 alunos.

<!-- sql
SELECT c.nome, COUNT(a.matricula)
FROM curso c
JOIN aluno a ON a.curso_id = c.id
GROUP BY c.nome
HAVING COUNT(a.matricula) > 10;
-->

**55)** Liste alunos que abriram requerimento em mais de um ano.

<!-- sql
SELECT aluno_matricula
FROM requerimento
GROUP BY aluno_matricula
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM data_hora_abertura)) > 1;
-->




# 🔷 MANIPULAÇÃO DE DATAS (56–70)

**56)** Requerimentos de hoje.

<!-- <!-- ```sql
SELECT *
FROM requerimento
WHERE DATE(data_hora_abertura) = CURRENT_DATE;
-->

**57)** Diferença em dias.

<!-- <!-- ```sql
SELECT id,
(data_hora_encerramento - data_hora_abertura) AS dias
FROM requerimento;
-->

**58)** Requerimentos últimos 30 dias.

<!-- <!-- ```sql
SELECT *
FROM requerimento
WHERE data_hora_abertura >= CURRENT_DATE - INTERVAL '30 days';
-->

**59)** Extrair dia da semana.

<!-- <!-- ```sql
SELECT EXTRACT(DOW FROM data_hora_abertura)
FROM requerimento;
-->

**60)** Idade do usuário.

<!-- <!-- ```sql
SELECT nome,
EXTRACT(YEAR FROM AGE(data_nascimento))
FROM usuario;
-->


# 🔷 MANIPULAÇÃO DE DATAS (61–70)

**61)** Liste requerimentos abertos nos últimos 7 dias.

<!-- ```sql
SELECT *
FROM requerimento
WHERE data_hora_abertura >= CURRENT_DATE - INTERVAL '7 days';
-->

**62)** Liste requerimentos abertos no ano atual.

<!-- ```sql
SELECT *
FROM requerimento
WHERE EXTRACT(YEAR FROM data_hora_abertura) =
      EXTRACT(YEAR FROM CURRENT_DATE);
-->


**63)** Liste requerimentos abertos no mês atual.

<!-- ```sql
SELECT *
FROM requerimento
WHERE EXTRACT(MONTH FROM data_hora_abertura) =
      EXTRACT(MONTH FROM CURRENT_DATE)
AND EXTRACT(YEAR FROM data_hora_abertura) =
      EXTRACT(YEAR FROM CURRENT_DATE);
-->

 **64)** Liste requerimentos e mostre apenas a data (sem hora).

<!-- ```sql
SELECT id,
       DATE(data_hora_abertura) AS data_abertura
FROM requerimento;
-->

 **65)** Liste requerimentos e calcule o tempo em dias até o encerramento.

<!-- ```sql
SELECT id,
       (data_hora_encerramento::date - data_hora_abertura::date) AS dias
FROM requerimento
WHERE data_hora_encerramento IS NOT NULL;
-->



**66)** Liste requerimentos mostrando dia da semana da abertura.

<!-- ```sql
SELECT id,
       EXTRACT(DOW FROM data_hora_abertura) AS dia_semana
FROM requerimento;
-->

 **67)** Liste requerimentos formatando a data no padrão DD/MM/YYYY.

<!-- ```sql
SELECT id,
       TO_CHAR(data_hora_abertura, 'DD/MM/YYYY') AS data_formatada
FROM requerimento;
-->

 **68)** Liste usuários mostrando idade em anos completos.

<!-- ```sql
SELECT nome,
       EXTRACT(YEAR FROM AGE(data_nascimento)) AS idade
FROM usuario
WHERE data_nascimento IS NOT NULL;
```

--> **69)** Liste requerimentos abertos há mais de 30 dias e ainda “EM ANÁLISE”.

<!-- ```sql
SELECT *
FROM requerimento
WHERE status = 'EM ANÁLISE'
AND data_hora_abertura <= CURRENT_DATE - INTERVAL '30 days';
-->



**70)** Liste o primeiro e o último requerimento aberto (mais antigo e mais recente).

<!-- ```sql
SELECT *
FROM requerimento
ORDER BY data_hora_abertura ASC
LIMIT 1;

SELECT *
FROM requerimento
ORDER BY data_hora_abertura DESC
LIMIT 1;
```
-->

# 🔷 MANIPULAÇÃO DE STRINGS (71–85)

**71)** Buscar nome com ILIKE.

<!-- <!-- ```sql
SELECT *
FROM usuario
WHERE nome ILIKE '%igor%';
-->

**72)** Uppercase.

<!-- <!-- ```sql
SELECT UPPER(nome)
FROM usuario;
-->

**73)** Lowercase.

<!-- <!-- ```sql
SELECT LOWER(nome)
FROM usuario;
-->

**74)** Tamanho do nome.

<!-- <!-- ```sql
SELECT nome, LENGTH(nome)
FROM usuario;
-->

**75)** Concatenar nome + email.

<!-- <!-- ```sql
SELECT nome || ' - ' || email
FROM usuario;
-->

**76)** SUBSTRING cpf.

<!-- <!-- ```sql
SELECT SUBSTRING(cpf FROM 1 FOR 3)
FROM usuario;
-->

**77)** REPLACE no nome.

<!-- <!-- ```sql
SELECT REPLACE(nome, 'A', '@')
FROM usuario;
-->

**78)** TRIM.

<!-- <!-- ```sql
SELECT TRIM(nome)
FROM usuario;
-->

# 🔷 MANIPULAÇÃO DE STRINGS (79–85)

**79)** Formate nome em INITCAP.

<!-- sql
SELECT INITCAP(nome)
FROM usuario;
-->

**80)** Localize posição da letra “A” no nome.

<!-- sql
SELECT POSITION('A' IN nome)
FROM usuario;
-->

**81)** Divida email antes do “@”.

<!-- sql
SELECT SPLIT_PART(email,'@',1)
FROM usuario;
-->

**82)** Preencha CPF com zeros à esquerda (LPAD).

<!-- sql
SELECT LPAD(cpf, 11, '0')
FROM usuario;
-->

**83)** Complete nome com 30 caracteres (RPAD).

<!-- sql
SELECT RPAD(nome,30,' ')
FROM usuario;
-->

**84)** Substitua espaços por underline.

<!-- sql
SELECT REPLACE(nome,' ','_')
FROM usuario;
-->

**85)** Liste apenas os 3 primeiros caracteres do nome.

<!-- sql
SELECT LEFT(nome,3)
FROM usuario;
-->



# 🔷 SUBSELECT / CTE / VIEWS / SCHEMAS (86–92)



 **86)** Liste alunos que possuem pelo menos um requerimento (EXISTS).

<!-- sql
SELECT *
FROM aluno a
WHERE EXISTS (
    SELECT 1
    FROM requerimento r
    WHERE r.aluno_matricula = a.matricula
);
-->



 **87)** Liste alunos que não possuem requerimento (NOT EXISTS).

<!-- sql
SELECT *
FROM aluno a
WHERE NOT EXISTS (
    SELECT 1
    FROM requerimento r
    WHERE r.aluno_matricula = a.matricula
);
-->



 **88)** Liste requerimentos cujo tipo seja “Reingresso” (subselect para buscar o id).

<!-- sql
SELECT *
FROM requerimento
WHERE tipo_requerimento_id = (
    SELECT id
    FROM tipo_requerimento
    WHERE descricao ILIKE '%Reingresso%'
);
-->



 **89)** Utilize CTE para listar requerimentos com nome do aluno e filtrar apenas “EM ANÁLISE”.

<!-- sql
WITH dados AS (
    SELECT r.id,
           u.nome,
           r.status
    FROM requerimento r
    JOIN aluno a ON a.matricula = r.aluno_matricula
    JOIN usuario u ON u.id = a.usuario_id
)
SELECT *
FROM dados
WHERE status = 'EM ANÁLISE';
-->



 **90)** Utilize CTE para calcular quantidade de requerimentos por aluno e listar apenas os que possuem mais de 1.

<!-- sql
WITH contagem AS (
    SELECT aluno_matricula,
           COUNT(*) qtd
    FROM requerimento
    GROUP BY aluno_matricula
)
SELECT *
FROM contagem
WHERE qtd > 1;
-->



 **91)** Crie uma VIEW chamada `vw_requerimentos_detalhados` com nome do aluno, tipo e status.

<!-- sql
CREATE VIEW vw_requerimentos_detalhados AS
SELECT u.nome,
       t.descricao,
       r.status
FROM requerimento r
JOIN aluno a ON a.matricula = r.aluno_matricula
JOIN usuario u ON u.id = a.usuario_id
JOIN tipo_requerimento t ON t.id = r.tipo_requerimento_id;
-->



 **92)** Crie um schema chamado `administrativo` e mova a tabela `tipo_requerimento` para ele.

<!-- sql
CREATE SCHEMA administrativo;

ALTER TABLE tipo_requerimento
SET SCHEMA administrativo;
-->



**93)** Adicionar coluna telefone.

<!-- <!-- ```sql
ALTER TABLE usuario
ADD COLUMN telefone VARCHAR(20);
-->

**94)** Alterar tipo telefone.

<!-- <!-- ```sql
ALTER TABLE usuario
ALTER COLUMN telefone TYPE VARCHAR(30);
-->

**95)** Definir NOT NULL.

<!-- <!-- ```sql
ALTER TABLE usuario
ALTER COLUMN telefone SET NOT NULL;
-->

**96)** Remover NOT NULL.

<!-- <!-- ```sql
ALTER TABLE usuario
ALTER COLUMN telefone DROP NOT NULL;
-->

**97)** Renomear coluna.

<!-- <!-- ```sql
ALTER TABLE usuario
RENAME COLUMN nro TO numero;
-->

**98)** Adicionar coluna ativo.

<!-- <!-- ```sql
ALTER TABLE usuario
ADD COLUMN ativo BOOLEAN DEFAULT true;
-->

**99)** Adicionar constraint CHECK.

<!-- <!-- ```sql
ALTER TABLE curso
ADD CONSTRAINT chk_duracao CHECK (duracao > 1000);
-->

**100)** Remover constraint.

<!-- <!-- ```sql
ALTER TABLE curso
DROP CONSTRAINT chk_duracao;
-->


