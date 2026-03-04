# 1️⃣ Criação do Banco de Dados

```sql
DROP DATABASE IF EXISTS sistema_requerimento;
CREATE DATABASE sistema_requerimento;
\c sistema_requerimento;
```

### 📌 Conceitos

* `DROP DATABASE IF EXISTS` → remove o banco caso exista.
* `CREATE DATABASE` → cria o banco.
* `\c` → conecta ao banco (comando do psql).

---

# 2️⃣ Tabela Curso

```sql
CREATE TABLE curso (
    id serial primary key,
    nome character varying(200) not null,
    site character varying(200),
    turno character varying(200) check(turno in('NOTURNO', 'DIURNO', 'VESPERTINO')),
    duracao integer check(duracao > 0)
);
```

## 🔎 Conceitos Importantes

| Conceito      | Explicação                 |
| ------------- | -------------------------- |
| `serial`      | Auto incremento            |
| `primary key` | Identificador único        |
| `not null`    | Campo obrigatório          |
| `check`       | Restrição de validação     |
| `varchar`     | Texto com tamanho variável |

### ✔ Inserção de dados

```sql
INSERT INTO curso (nome, site, turno, duracao) VALUES (...);
```

---

# 3️⃣ Tabela Usuário

```sql
CREATE TABLE usuario (
    id serial primary key,
    nome character varying(200) not null,
    email character varying(200) unique,
    cpf character(11) unique,
    data_nascimento date,
    cep character(8),
    rua text,
    complemento text,
    nro character varying(10)
);
```

## 🔎 Novos Conceitos

* `unique` → impede duplicidade
* `date` → tipo data
* `text` → texto ilimitado

---

# 4️⃣ Tabela Aluno (Relacionamentos)

```sql
CREATE TABLE aluno (
    matricula character(10) primary key,
    usuario_id integer references usuario (id),
    curso_id integer references curso (id)
);
```

## 🔑 Conceito de Chave Estrangeira (FK)

* `usuario_id` referencia `usuario(id)`
* `curso_id` referencia `curso(id)`

Isso garante **integridade referencial**.

---

# 5️⃣ ALTER TABLE

```sql
ALTER TABLE aluno 
ADD COLUMN status text 
check(status in('CURSANDO', 'ABANDONO', 'TRANCADO', 'FORMADO')) 
DEFAULT 'CURSANDO';
```

## 📌 Conceitos

* `ALTER TABLE` → modifica tabela existente
* `ADD COLUMN` → adiciona coluna
* `DEFAULT` → valor padrão automático

---

# 6️⃣ UPDATE

```sql
UPDATE aluno 
SET status = 'FORMADO' 
WHERE matricula = '1231231231';
```

⚠ Sempre usar `WHERE` para evitar atualizar todos os registros.

---

# 7️⃣ Tabela Tipo de Requerimento

Tabela de domínio (cadastro fixo).

```sql
CREATE TABLE tipo_requerimento (
    id serial primary key,
    descricao text not null
);
```

---

# 8️⃣ Tabela Requerimento

```sql
CREATE TABLE requerimento (
    id serial primary key,
    aluno_matricula character(10) references aluno (matricula),
    data_hora_abertura timestamp default current_timestamp,
    data_hora_encerramento timestamp,
    observacao text,
    status text check(status in ('EM ANÁLISE', 'INDEFERIDO', 'DEFERIDO')) DEFAULT 'EM ANÁLISE',
    tipo_requerimento_id integer references tipo_requerimento (id)
);
```

## 📌 Novos Conceitos

* `timestamp`
* `current_timestamp`
* múltiplas FKs

---

# 9️⃣ Tabela Anexo

```sql
CREATE TABLE anexo (
    id serial primary key,
    descricao text not null,
    arquivo bytea,
    requerimento_id integer references requerimento (id)
);
```

### 🔎 Conceito

* `bytea` → armazenamento binário (arquivos)

---

# 🔟 CONSULTAS SQL (SELECT)

---

## 🔹 INNER JOIN

Retorna apenas registros com correspondência.

```sql
SELECT matricula, usuario.nome, curso.nome
FROM aluno
INNER JOIN usuario ON aluno.usuario_id = usuario.id
INNER JOIN curso ON aluno.curso_id = curso.id;
```

---

## 🔹 LEFT JOIN

Retorna todos da esquerda, mesmo sem correspondência.

```sql
SELECT aluno.matricula, requerimento.id
FROM aluno
LEFT JOIN requerimento 
ON aluno.matricula = requerimento.aluno_matricula;
```

---

## 🔹 LEFT JOIN + IS NULL (Anti-Join)

Alunos sem requerimentos:

```sql
SELECT aluno.matricula
FROM aluno
LEFT JOIN requerimento 
ON aluno.matricula = requerimento.aluno_matricula
WHERE requerimento.id IS NULL;
```

Alternativas:

```sql
NOT IN
EXCEPT
```

---

## 🔹 FULL JOIN

```sql
SELECT aluno.matricula, requerimento.id
FROM aluno
FULL JOIN requerimento 
ON aluno.matricula = requerimento.aluno_matricula;
```

---

# 🔹 COALESCE

Substitui valores NULL.

```sql
SELECT requerimento.id,
COALESCE(anexo.descricao, 'sem descricao') as descricao
FROM requerimento
LEFT JOIN anexo 
ON requerimento.id = anexo.requerimento_id;
```

---

# 🔹 CASE

Estrutura condicional.

```sql
CASE
    WHEN anexo.descricao IS NULL THEN 'sem descricao'
    ELSE anexo.descricao
END
```

---

# 🔹 GROUP BY

Contagem de requerimentos por tipo:

```sql
SELECT tipo_requerimento.id,
       tipo_requerimento.descricao,
       COUNT(requerimento.tipo_requerimento_id)
FROM requerimento
INNER JOIN tipo_requerimento 
ON requerimento.tipo_requerimento_id = tipo_requerimento.id
GROUP BY tipo_requerimento.id, tipo_requerimento.descricao;
```

---

# 🔹 HAVING

Filtrar após agregação:

```sql
HAVING COUNT(tipo_requerimento_id) >= 2;
```

---

# 🔹 Contagem por aluno

```sql
SELECT aluno.matricula,
       COUNT(requerimento.aluno_matricula)
FROM aluno
INNER JOIN requerimento 
ON aluno.matricula = requerimento.aluno_matricula
GROUP BY aluno.matricula
HAVING COUNT(requerimento.aluno_matricula) > 1;
```

---

# 🔹 VIEW

```sql
CREATE VIEW qtde_requerimento_por_tipo AS
SELECT tipo_requerimento.id,
       tipo_requerimento.descricao,
       COUNT(requerimento.tipo_requerimento_id)
FROM requerimento
INNER JOIN tipo_requerimento 
ON requerimento.tipo_requerimento_id = tipo_requerimento.id
GROUP BY tipo_requerimento.id, tipo_requerimento.descricao;
```

## 📌 Conceito

* VIEW = tabela virtual
* Facilita consultas recorrentes
* Aumenta organização

