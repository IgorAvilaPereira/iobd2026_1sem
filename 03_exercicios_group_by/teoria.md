# Aula 3

## Consultas com GROUP BY, STRING_AGG e HAVING + Integração com Java, JDBC e Web

Nesta aula iremos avançar na construção de sistemas que integram **banco de dados, backend em Java e interface web**. O objetivo é compreender como consultas SQL mais elaboradas podem ser utilizadas dentro de aplicações desenvolvidas em Java, utilizando tecnologias modernas para construção de aplicações web.

Serão abordados os seguintes tópicos:

* consultas SQL com **GROUP BY**
* agregações e concatenação de strings com **STRING_AGG**
* filtragem de agregações com **HAVING**
* acesso a banco de dados com **JDBC**
* construção de aplicações web com **Java**
* utilização do framework **Javalin**
* uso de templates com **Mustache**
* construção da interface com **HTML** e **CSS**

O objetivo final é mostrar como **consultas SQL podem alimentar páginas web dinâmicas**.

---

# 1. Consultas com GROUP BY

O comando **GROUP BY** é utilizado quando desejamos **agrupar registros que possuem valores em comum** em determinadas colunas.

Esse recurso é normalmente utilizado em conjunto com **funções de agregação**, como:

* `COUNT`
* `SUM`
* `AVG`
* `MAX`
* `MIN`

## Exemplo

Considere uma tabela `curso` contendo cursos de uma instituição.

```sql
SELECT area, COUNT(*) 
FROM curso
GROUP BY area;
```

Resultado esperado:

| area        | count |
| ----------- | ----- |
| informática | 5     |
| gestão      | 3     |
| educação    | 4     |

Neste caso:

* os registros são **agrupados pela coluna `area`**
* a função `COUNT` calcula **quantos cursos existem em cada área**

---

# 2. Agregação de texto com STRING_AGG

Em alguns casos, além de contar ou somar valores, pode ser útil **concatenar informações de um grupo em uma única string**.

Para isso utilizamos a função **STRING_AGG**, disponível no banco de dados **PostgreSQL**.

## Exemplo

```sql
SELECT area,
       STRING_AGG(nome, ', ')
FROM curso
GROUP BY area;
```

Resultado:

| area        | cursos                     |
| ----------- | -------------------------- |
| informática | ADS, Ciência da Computação |
| gestão      | Administração, Logística   |

Nesse caso:

* todos os nomes de cursos pertencentes à mesma área são **concatenados em uma única string**

---

# 3. Filtrando grupos com HAVING

Quando utilizamos **GROUP BY**, o comando `WHERE` não pode ser utilizado para filtrar **resultados agregados**.

Para isso existe o comando **HAVING**.

## Exemplo

```sql
SELECT area, COUNT(*)
FROM curso
GROUP BY area
HAVING COUNT(*) > 2;
```

Nesse caso:

* apenas áreas com **mais de dois cursos** serão exibidas.

Diferença conceitual:

| cláusula | função                           |
| -------- | -------------------------------- |
| WHERE    | filtra linhas antes da agregação |
| HAVING   | filtra grupos após a agregação   |

---

# 4. Acesso ao banco de dados com JDBC

Para que uma aplicação Java possa executar consultas SQL, utilizamos a tecnologia **Java Database Connectivity**, conhecida como **JDBC**.

O JDBC é a API padrão do Java para comunicação com bancos de dados relacionais.

Fluxo básico de acesso ao banco:

1. estabelecer conexão
2. criar comando SQL
3. executar consulta
4. processar resultados

## Exemplo simplificado

```java
Connection conexao = DriverManager.getConnection(
    "jdbc:postgresql://localhost:5432/banco",
    "usuario",
    "senha"
);

Statement stmt = conexao.createStatement();

ResultSet rs = stmt.executeQuery(
    "SELECT area, COUNT(*) FROM curso GROUP BY area"
);

while (rs.next()) {
    System.out.println(rs.getString("area"));
}
```

Nesse exemplo:

* é estabelecida uma conexão com o banco
* uma consulta SQL é executada
* os resultados são percorridos linha a linha.

---

# 5. Construção do backend com Java

No backend da aplicação utilizamos a linguagem **Java** para:

* conectar ao banco de dados
* executar consultas SQL
* estruturar os dados retornados
* enviar esses dados para a camada de apresentação.

Esse backend pode ser organizado em camadas, por exemplo:

```
apresentacao
negocio
persistencia
```

* **persistência** → acesso ao banco
* **negócio** → regras da aplicação
* **apresentação** → páginas web

---

# 6. Framework web com Javalin

Para construir a aplicação web utilizaremos o framework **Javalin**.

Esse framework permite criar aplicações web em Java de forma simples, semelhante ao funcionamento de frameworks modernos de outras linguagens.

Exemplo básico:

```java
Javalin app = Javalin.create().start(7000);

app.get("/cursos", ctx -> {
    ctx.result("Lista de cursos");
});
```

Nesse exemplo:

* o servidor web inicia na porta **7000**
* a rota `/cursos` retorna um texto simples.

---

# 7. Templates com Mustache

Para gerar páginas HTML dinâmicas utilizamos um mecanismo de templates. Nesta disciplina utilizaremos **Mustache**.

O Mustache permite **inserir dados dentro de páginas HTML** sem misturar muita lógica de programação.

Exemplo de template:

```html
<h1>Lista de cursos</h1>

<ul>
{{#cursos}}
  <li>{{nome}}</li>
{{/cursos}}
</ul>
```

Nesse template:

* `{{nome}}` será substituído pelo valor vindo do backend.

No Java:

```java
ctx.render("cursos.mustache", model);
```

---

# 8. Interface com HTML e CSS

A camada de interface será construída com:

* **HTML**
* **CSS**

O HTML define a **estrutura da página**, enquanto o CSS define sua **aparência visual**.

Exemplo simples:

```html
<h1>Cursos por área</h1>

<table>
<tr>
<th>Área</th>
<th>Cursos</th>
</tr>
</table>
```

CSS:

```css
table {
  border-collapse: collapse;
}

th, td {
  border: 1px solid black;
  padding: 5px;
}
```

---

# 9. Integração geral do sistema

O fluxo completo da aplicação será o seguinte:

```
Banco de Dados (PostgreSQL)
        ↓
Consultas SQL (GROUP BY, HAVING, STRING_AGG)
        ↓
JDBC
        ↓
Backend em Java
        ↓
Javalin
        ↓
Template Mustache
        ↓
HTML + CSS
        ↓
Navegador
```

Essa arquitetura permite desenvolver aplicações completas que:

* consultam dados no banco
* processam essas informações no backend
* apresentam resultados dinâmicos ao usuário.

---

# 10. Objetivos da aula

* utilizar **GROUP BY** para agrupar registros
* aplicar funções de agregação em consultas SQL
* utilizar **STRING_AGG** para concatenar resultados
* filtrar grupos com **HAVING**
* executar consultas SQL em Java usando **JDBC**
* criar rotas web utilizando **Javalin**
* gerar páginas dinâmicas com **Mustache**
* estruturar páginas utilizando **HTML** e **CSS**

Esses conhecimentos são fundamentais para o desenvolvimento de **aplicações web conectadas a bancos de dados**.

---

