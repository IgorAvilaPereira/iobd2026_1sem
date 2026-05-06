# Trabalho 1 – Sistema de Requerimentos Acadêmicos Web (5 pontos)

## Objetivo

Criar uma **aplicação web em Java** para gerenciamento de **requerimentos acadêmicos**, utilizando o banco **PostgreSQL já fornecido**.

A aplicação deve utilizar:

* **Javalin** para criação do servidor web
* **JDBC** para comunicação com o banco
* **Padrão DAO** para acesso a dados
* **Arquitetura em camadas**

O sistema permitirá **visualizar, criar e gerenciar requerimentos de alunos**.

---

# Estrutura mínima do projeto

```
src/main/java/

apresentacao/
    Main.java

negocio/
    Aluno.java
    Requerimento.java
    Curso.java
    TipoRequerimento.java

persistencia/
    ConexaoPostgreSQL.java
    AlunoDAO.java
    RequerimentoDAO.java
    TipoRequerimentoDAO.java
```

---

# Parte 1 – Modelagem em Java (1 ponto)

Criar **classes Java (POJO)** representando as principais entidades do sistema.

Classes mínimas:

```
Curso
Usuario
Aluno
TipoRequerimento
Requerimento
Anexo
```

Cada classe deve conter:

* atributos
* getters
* setters
* construtores

Exemplo esperado:

```
Aluno
- matricula
- usuario
- curso
- status
```

---

# Parte 2 – Camada de Persistência (DAO) (2 pontos)

Implementar DAOs utilizando **JDBC**.

## 1 – Conexão com o banco (0,5)

Criar a classe:

```
ConexaoPostgreSQL
```

Responsável por:

* abrir conexão
* retornar objeto `Connection`

---

## 2 – DAO de alunos (0,5)

Criar a classe:

```
AlunoDAO
```

Métodos mínimos:

```
listarTodos()

buscarPorMatricula(String matricula)

listarPorCurso(int cursoId)
```

---

## 3 – DAO de requerimentos (0,5)

Criar a classe:

```
RequerimentoDAO
```

Métodos mínimos:

```
listarTodos()

buscarPorId(int id)

listarPorAluno(String matricula)
```

---

## 4 – Criar novo requerimento (0,5)

Implementar no `RequerimentoDAO`:

```
abrirRequerimento(String matricula, int tipoId, String observacao)
```

A operação deve:

1. inserir novo registro na tabela `requerimento`
2. respeitar os valores default do banco

---

# Parte 3 – Aplicação Web com Javalin (2 pontos)

Criar uma aplicação web utilizando **Javalin**.

Servidor deve rodar na porta:

```
7000
```

---

# Página 1 – Listagem de alunos (0,5)

Rota:

```
/alunos
```

Deve exibir:

| Matrícula | Nome | Curso | Status |

Os dados devem vir do **AlunoDAO**.

---

# Página 2 – Requerimentos de um aluno (0,5)

Rota:

```
/aluno/{matricula}/requerimentos
```

A página deve mostrar:

| ID | Tipo | Data de abertura | Status |

Dados obtidos via **RequerimentoDAO**.

---

# Página 3 – Abrir requerimento (0,5)

Criar um formulário HTML.

Rota:

```
/novo-requerimento
```

Campos:

```
matricula
tipo_requerimento
observacao
```

Ao enviar o formulário:

* chamar `RequerimentoDAO.abrirRequerimento()`
* redirecionar para lista de requerimentos do aluno.

---

# Página 4 – Consulta de requerimento (0,5)

Rota:

```
/requerimento/{id}
```

Deve mostrar:

* aluno
* tipo de requerimento
* data de abertura
* status
* observação

---

# Requisitos obrigatórios

A aplicação **deve utilizar**:

* **JDBC**
* **DAO Pattern**
* **Javalin**
* **PostgreSQL**

Não é permitido:

* usar ORM (Hibernate, JPA etc.)
* executar SQL diretamente nas rotas

Todo SQL deve estar **dentro das classes DAO**.

---

# Organização do projeto

Será avaliado:

* separação em pacotes
* uso correto de DAO
* código organizado
* nomes de classes adequados

---

# Critérios de avaliação

| Item                         | Pontos |
| ---------------------------- | ------ |
| Modelagem das classes        | 1,0    |
| Implementação dos DAOs       | 2,0    |
| Integração JDBC + PostgreSQL | 1,0    |
| Aplicação Web com Javalin    | 1,0    |

Total: **5 pontos**


