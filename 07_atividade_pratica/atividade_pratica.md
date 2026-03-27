# 🧪 Atividade – Sistema de Biblioteca

## 🎯 Objetivo

Desenvolver consultas SQL e integrá-las com JDBC para análise de empréstimos de biblioteca.

---

# 🗄️ Modelo do Banco

## 📘 livro

```sql
id
titulo
autor
```

## 📗 exemplar

```sql
id
livro_id
codigo
disponivel
```

## 👤 usuario

```sql
id
nome
```

## 📚 emprestimo

```sql
id
usuario_id
exemplar_id
data_emprestimo
data_devolucao
```

---

# 🔷 PARTE 1 – SQL (2 pontos)

---

## 🔹 Nível 1 – Essencial

1. Exemplares atualmente emprestados
2. Usuários que nunca pegaram exemplar
3. Quantidade de empréstimos por usuário
4. Livros e quantidade total de empréstimos
5. Exemplares disponíveis

---

## 🔹 Nível 2 – Intermediário

6. Ranking de usuários
7. Livro mais emprestado
8. Empréstimos em atraso
9. Tempo médio de empréstimo
10. Empréstimos por ano

---

## 🔹 Nível 3 – Avançado

11. Usuários acima da média (CTE)
12. Último empréstimo de cada usuário
13. Livros nunca emprestados
14. Exemplares que mais atrasam
15. Usuário com maior tempo acumulado

---

# 🔥 EXERCÍCIOS AVANÇADOS (ATUALIZADOS)

---

## 🔹 16. Diferença para o líder

Para cada usuário, mostrar:

* nome
* quantidade de empréstimos
* diferença em relação ao usuário com maior quantidade

👉 força uso de:

* subquery ou window function

---

## 🔹 17. Tempo entre empréstimos (LAG)

Para cada usuário:

* data atual
* empréstimo anterior
* intervalo entre eles

---

## 🔹 18. Frequência de empréstimos por usuário

Classificar usuários como:

```text
ALTA   → mais de 1 empréstimo por mês (média)
MÉDIA  → entre 0.5 e 1
BAIXA  → abaixo de 0.5
```

👉 exige:

* cálculo de média temporal
* `CASE`
* agregação

---

## 🔹 19. Detectar picos de uso

Dias com quantidade de empréstimos acima da média

---

## 🔹 20. Usuários “fiéis”

Usuários que pegaram o mesmo livro mais de 2 vezes

---

## 🔹 21. Anti-join (NOT EXISTS)

Usuários que nunca pegaram livros de um determinado autor

---

## 🔹 22. CTE encadeada

* CTE 1: total por usuário
* CTE 2: média
* resultado: acima da média

---

## 🔹 23. Top 3 livros por ano

---

## 🔹 24. Classificação de usuários

```text
0-2 → iniciante
3-5 → intermediário
6+ → avançado
```

---

## 🔹 25. Detecção de inconsistência

Exemplares com:

* `disponivel = true`
* mas com empréstimo ativo

---

# 🔷 PARTE 2 – JDBC (2 pontos)

---

## 📁 Estrutura

```text
Conexao.java
RelatorioDAO.java
```

---

## 📌 Métodos obrigatórios

* listarEmprestimosAtivos()
* listarRankingUsuarios()
* listarAtrasados()
* listarLivrosNuncaEmprestados()
* listarUsuariosAcimaMedia()
* listarTopLivros()

---

## ⚠️ Regras

* usar `PreparedStatement`
* usar `ResultSet`
* não usar ORM
* SQL apenas no DAO

---

# 🔷 PARTE 3 – Execução (1 ponto)

---

## Menu (Main.java)

```text
1 - Empréstimos ativos
2 - Ranking usuários
3 - Atrasados
4 - Top livros
5 - Usuários acima da média
```

---

## Exemplo de saída

```text
📊 Ranking:
1º João - 10 empréstimos
2º Maria - 8 empréstimos
```

---

# ⏱️ Tempo de aula

| Tempo  | Atividade                |
| ------ | ------------------------ |
| 45 min | SQL básico/intermediário |
| 45 min | SQL avançado             |
| 60 min | JDBC                     |
| 30 min | testes                   |

---

# 🎓 Resultado

Essa versão:

* mantém **baixo acoplamento**
* aumenta **nível analítico**
* evita exercícios repetitivos da lista original
* força raciocínio real (não só copiar SQL)

---
<!--
Se quiser, posso montar também:

✅ gabarito completo
✅ versão com menos exercícios (caso a turma seja mais lenta)
✅ versão com dados fake para rodar direto

Essa aqui está **bem equilibrada para uma aula forte**.
-->
