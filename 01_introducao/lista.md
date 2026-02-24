# Exercícios SQL
---

## 🟢 PARTE 1 — SELECT + JOIN

---

### 1️⃣ Listar todos os requerimentos com nome do aluno

<!-- ```sql
SELECT r.id_requerimento, a.nome, r.status
FROM Requerimento r
INNER JOIN Aluno a ON r.id_aluno = a.id_aluno;
```-->

---

### 2️⃣ Listar requerimentos com descrição do tipo

<!-- ```sql
SELECT r.id_requerimento, t.descricao, r.status
FROM Requerimento r
INNER JOIN Tipo_Requerimento t ON r.id_tipo_requer = t.id_tipo_requer;
```-->

---

### 3️⃣ Listar requerimentos com nome do aluno e tipo

<!-- ```sql
SELECT r.id_requerimento, a.nome, t.descricao, r.status
FROM Requerimento r
INNER JOIN Aluno a ON r.id_aluno = a.id_aluno
INNER JOIN Tipo_Requerimento t ON r.id_tipo_requer = t.id_tipo_requer;
```-->

---

### 4️⃣ Listar histórico com nome do servidor

<!-- ```sql
SELECT h.id_requerimento, h.status_antigo, h.status_novo,
       s.nome, h.data_alteracao
FROM Historico_Status h
INNER JOIN Servidor s ON h.id_servidor = s.id_servidor;
```-->

---

### 5️⃣ Listar todos os alunos e seus requerimentos (inclusive sem requerimento)

<!-- ```sql
SELECT a.nome, r.id_requerimento
FROM Aluno a
LEFT JOIN Requerimento r ON a.id_aluno = r.id_aluno;
```-->

---

### 6️⃣ Listar todos os tipos e seus requerimentos

<!-- ```sql
SELECT t.descricao, r.id_requerimento
FROM Tipo_Requerimento t
LEFT JOIN Requerimento r ON t.id_tipo_requer = r.id_tipo_requer;
```-->

---

### 7️⃣ Listar requerimentos e anexos (inclusive sem anexo)

<!-- ```sql
SELECT r.id_requerimento, a.nome_arquivo
FROM Requerimento r
LEFT JOIN Anexo_Requerimento a
ON r.id_requerimento = a.id_requerimento;
```-->

---

### 8️⃣ Listar histórico mesmo quando não houver servidor vinculado

<!-- ```sql
SELECT h.id_historico, s.nome
FROM Historico_Status h
RIGHT JOIN Servidor s ON h.id_servidor = s.id_servidor;
```-->

---

# 🟡 PARTE 2 — WHERE + ORDER BY + LIMIT

---

### 9️⃣ Listar requerimentos aprovados

<!-- ```sql
SELECT * FROM Requerimento
WHERE status = 'Aprovado';
```-->

---

### 🔟 Listar requerimentos ordenados por data mais recente

<!-- ```sql
SELECT * FROM Requerimento
ORDER BY data_solicitacao DESC;
```-->

---

### 1️⃣1️⃣ Listar os 5 requerimentos mais antigos

<!-- ```sql
SELECT * FROM Requerimento
ORDER BY data_solicitacao
LIMIT 5;
```-->

---

### 1️⃣2️⃣ Listar alunos do curso ADS

<!-- ```sql
SELECT * FROM Aluno
WHERE curso = 'ADS';
```-->

---

### 1️⃣3️⃣ Requerimentos feitos nos últimos 7 dias

<!-- ```sql
SELECT * FROM Requerimento
WHERE data_solicitacao >= CURRENT_DATE - INTERVAL '7 days';
```-->

---

### 1️⃣4️⃣ Requerimentos ainda não finalizados

<!-- ```sql
SELECT * FROM Requerimento
WHERE data_finalizacao IS NULL;
```-->

---

# 🟠 PARTE 3 — GROUP BY + HAVING

---

### 1️⃣5️⃣ Quantidade de requerimentos por status

<!-- ```sql
SELECT status, COUNT(*)
FROM Requerimento
GROUP BY status;
```-->

---

### 1️⃣6️⃣ Quantidade de requerimentos por aluno

<!-- ```sql
SELECT a.nome, COUNT(r.id_requerimento)
FROM Aluno a
LEFT JOIN Requerimento r ON a.id_aluno = r.id_aluno
GROUP BY a.nome;
```-->

---

### 1️⃣7️⃣ Alunos com mais de 3 requerimentos

<!-- ```sql
SELECT a.nome, COUNT(r.id_requerimento)
FROM Aluno a
INNER JOIN Requerimento r ON a.id_aluno = r.id_aluno
GROUP BY a.nome
HAVING COUNT(r.id_requerimento) > 3;
```-->

---

### 1️⃣8️⃣ Quantidade de alterações por servidor

<!-- ```sql
SELECT s.nome, COUNT(h.id_historico)
FROM Servidor s
LEFT JOIN Historico_Status h
ON s.id_servidor = h.id_servidor
GROUP BY s.nome;
```-->

---

### 1️⃣9️⃣ Tipos com mais de 5 requerimentos

<!-- ```sql
SELECT t.descricao, COUNT(r.id_requerimento)
FROM Tipo_Requerimento t
INNER JOIN Requerimento r
ON t.id_tipo_requer = r.id_tipo_requer
GROUP BY t.descricao
HAVING COUNT(r.id_requerimento) > 5;
```-->

---

# 🔵 PARTE 4 — Funções (TO_CHAR, COALESCE, Datas)

---

### 2️⃣0️⃣ Formatar data

<!-- ```sql
SELECT id_requerimento,
       TO_CHAR(data_solicitacao, 'DD/MM/YYYY')
FROM Requerimento;
```-->

---

### 2️⃣1️⃣ Mostrar data finalização ou “Pendente”

<!-- ```sql
SELECT id_requerimento,
       COALESCE(TO_CHAR(data_finalizacao,'DD/MM/YYYY'),'Pendente')
FROM Requerimento;
```-->

---

### 2️⃣2️⃣ Calcular dias de atendimento

<!-- ```sql
SELECT id_requerimento,
       (data_finalizacao - data_solicitacao) AS dias
FROM Requerimento
WHERE data_finalizacao IS NOT NULL;
```-->

---

### 2️⃣3️⃣ Data prevista de conclusão

<!-- ```sql
SELECT r.id_requerimento,
       r.data_solicitacao + 
       (t.prazo_atendimento_dias || ' days')::INTERVAL
FROM Requerimento r
INNER JOIN Tipo_Requerimento t
ON r.id_tipo_requer = t.id_tipo_requer;
```-->

---

# 🟣 PARTE 5 — Subconsultas

---

### 2️⃣4️⃣ Aluno com mais requerimentos

<!-- ```sql
SELECT nome
FROM Aluno
WHERE id_aluno = (
    SELECT id_aluno
    FROM Requerimento
    GROUP BY id_aluno
    ORDER BY COUNT(*) DESC
    LIMIT 1
);
```-->

---

### 2️⃣5️⃣ Requerimentos acima da média de duração

<!-- ```sql
SELECT *
FROM Requerimento
WHERE (data_finalizacao - data_solicitacao) >
(
 SELECT AVG(data_finalizacao - data_solicitacao)
 FROM Requerimento
 WHERE data_finalizacao IS NOT NULL
);
```-->

---

### 2️⃣6️⃣ Alunos que nunca fizeram requerimento

<!-- ```sql
SELECT *
FROM Aluno a
WHERE NOT EXISTS (
  SELECT 1 FROM Requerimento r
  WHERE r.id_aluno = a.id_aluno
);
```-->

---

# 🔴 PARTE 6 — Manipulação de Dados

---

### 2️⃣7️⃣ Inserir novo tipo

<!-- ```sql
INSERT INTO Tipo_Requerimento
(descricao, prazo_atendimento_dias)
VALUES ('Aproveitamento de Disciplinas', 10);
```-->

---

### 2️⃣8️⃣ Atualizar status para “Em atraso”

<!-- ```sql
UPDATE Requerimento
SET status = 'Em atraso'
WHERE data_solicitacao < CURRENT_DATE - INTERVAL '30 days'
AND status <> 'Concluído';
```-->

---

### 2️⃣9️⃣ Excluir anexos antigos

<!-- ```sql
DELETE FROM Anexo_Requerimento
WHERE id_requerimento IN (
  SELECT id_requerimento
  FROM Requerimento
  WHERE data_finalizacao < CURRENT_DATE - INTERVAL '1 year'
);
```-->

---

### 3️⃣0️⃣ Atualizar email de um aluno

<!-- ```sql
UPDATE Aluno
SET email = 'novo@email.com'
WHERE id_aluno = 1;
```-->

---

# 🟤 PARTE 7 — Consultas Complexas

---

### 3️⃣1️⃣ Requerimentos com total de anexos

<!-- ```sql
SELECT r.id_requerimento, COUNT(a.id_anexo)
FROM Requerimento r
LEFT JOIN Anexo_Requerimento a
ON r.id_requerimento = a.id_requerimento
GROUP BY r.id_requerimento;
```-->

---

### 3️⃣2️⃣ Requerimentos com total de mudanças de status

<!-- ```sql
SELECT r.id_requerimento, COUNT(h.id_historico)
FROM Requerimento r
LEFT JOIN Historico_Status h
ON r.id_requerimento = h.id_requerimento
GROUP BY r.id_requerimento;
```-->

---

### 3️⃣3️⃣ Servidor que mais alterou status

<!-- ```sql
SELECT s.nome, COUNT(*) total
FROM Servidor s
INNER JOIN Historico_Status h
ON s.id_servidor = h.id_servidor
GROUP BY s.nome
ORDER BY total DESC
LIMIT 1;
```-->

---

### 3️⃣4️⃣ Requerimentos com mais de 3 mudanças

<!-- ```sql
SELECT id_requerimento
FROM Historico_Status
GROUP BY id_requerimento
HAVING COUNT(*) > 3;
```-->

---

### 3️⃣5️⃣ Listar requerimentos com prazo vencido

<!-- ```sql
SELECT r.*
FROM Requerimento r
INNER JOIN Tipo_Requerimento t
ON r.id_tipo_requer = t.id_tipo_requer
WHERE r.data_solicitacao +
(t.prazo_atendimento_dias || ' days')::INTERVAL
< CURRENT_DATE
AND r.status <> 'Concluído';
```-->

---

# ⚫ PARTE 8 — Desafio Avançado

---

### 3️⃣6️⃣ Relatório completo

<!-- ```sql
SELECT a.nome,
       a.curso,
       t.descricao,
       r.status,
       TO_CHAR(r.data_solicitacao,'DD/MM/YYYY') data,
       COUNT(DISTINCT an.id_anexo) anexos,
       COUNT(DISTINCT h.id_historico) alteracoes
FROM Requerimento r
INNER JOIN Aluno a ON r.id_aluno = a.id_aluno
INNER JOIN Tipo_Requerimento t ON r.id_tipo_requer = t.id_tipo_requer
LEFT JOIN Anexo_Requerimento an ON r.id_requerimento = an.id_requerimento
LEFT JOIN Historico_Status h ON r.id_requerimento = h.id_requerimento
GROUP BY a.nome, a.curso, t.descricao, r.status, r.data_solicitacao;
```-->

---

### 3️⃣7️⃣ Último status de cada requerimento

<!-- ```sql
SELECT DISTINCT ON (id_requerimento)
id_requerimento, status_novo
FROM Historico_Status
ORDER BY id_requerimento, data_alteracao DESC;
```-->

---

### 3️⃣8️⃣ Percentual de requerimentos concluídos

<!-- ```sql
SELECT 
ROUND(
100.0 * SUM(CASE WHEN status = 'Concluído' THEN 1 ELSE 0 END)
/ COUNT(*),2) AS percentual
FROM Requerimento;
```-->

---

### 3️⃣9️⃣ Curso com mais requerimentos

<!-- ```sql
SELECT a.curso, COUNT(*)
FROM Requerimento r
INNER JOIN Aluno a ON r.id_aluno = a.id_aluno
GROUP BY a.curso
ORDER BY COUNT(*) DESC
LIMIT 1;
```-->

---

### 4️⃣0️⃣ Tempo médio de atendimento por tipo

<!-- ```sql
SELECT t.descricao,
AVG(r.data_finalizacao - r.data_solicitacao) AS media_dias
FROM Requerimento r
INNER JOIN Tipo_Requerimento t
ON r.id_tipo_requer = t.id_tipo_requer
WHERE r.data_finalizacao IS NOT NULL
GROUP BY t.descricao;
```-->
