package apresentacao;

import java.sql.SQLException;

import io.javalin.Javalin;
import io.javalin.rendering.template.JavalinMustache;

import java.util.HashMap;
import java.util.Map;

import negocio.Curso;
import persistencia.CursoDAO;

public class Main {
    public static void main(String[] args) throws SQLException {
        // ------------------------------------
        // testes

        // testando conexao
        // new ConexaoPostgreSQL().getConexao();

        // testando metodo listar da classe cursodao
        // new CursoDAO().listar().forEach(p -> System.out.println(p.getNome()));
        // Curso curso = new Curso();
        // curso.setNome("curso do igor");
        // curso.setDuracao(1);
        // new CursoDAO().inserir(curso);
        //--------------------

        // var app = 
        Javalin.create(config -> {
            // define qual vai ser a minha engine de templates
            config.fileRenderer(new JavalinMustache());    

            // defino as minhas rotas

            // a unica rota que tenha eh a index
            config.routes.get("/", ctx -> {
                // crio um map <chave, valor> para que seja usado la no html
                Map<String, Object> map = new HashMap<>();
                // defino um apelido para a colecao de objetos de curso vindos do banco
                map.put("vetCurso", new CursoDAO().listar());
                // renderizo a pagina html encaminhando tb o map
                ctx.render("/templates/index.html", map);
            });

            config.routes.get("/curso/excluir/{id}", ctx -> {
                new CursoDAO().excluir(Integer.parseInt(ctx.pathParam("id")));
                ctx.redirect("/");
            });

            config.routes.get("/curso/tela_alterar/{id}", ctx -> {
                Curso curso = new CursoDAO().obter(Integer.parseInt(ctx.pathParam("id")));
                Map<String, Object> map = new HashMap<>();
                // defino um apelido para a colecao de objetos de curso vindos do banco
                map.put("curso", curso);
                ctx.render("/templates/curso/tela_alterar.html", map);
            });


            config.routes.get("/curso/tela_adicionar", ctx -> {
                ctx.render("/templates/curso/tela_adicionar.html");
            });

             config.routes.post("/curso/adicionar", ctx -> {
                String nome = ctx.formParam("nome");
                String site = ctx.formParam("site");
                String turno = ctx.formParam("turno");
                int duracao = Integer.parseInt(ctx.formParam("duracao"));
                Curso curso = new Curso();
                curso.setNome(nome);
                curso.setSite(site);
                curso.setTurno(turno);
                curso.setDuracao(duracao);
                if (new CursoDAO().adicionar(curso)) {
                    ctx.redirect("/");
                } else {
                    ctx.redirect("/templates/curso/tela_adicionar.html");
                }
                // ctx.render("/templates/curso/tela_adicionar.html");
            });

            config.routes.post("/curso/alterar", ctx -> {
                int id = Integer.parseInt(ctx.formParam("id"));
                String nome = ctx.formParam("nome");
                String site = ctx.formParam("site");
                String turno = ctx.formParam("turno");
                int duracao = Integer.parseInt(ctx.formParam("duracao"));
                Curso curso = new Curso();
                curso.setId(id);
                curso.setNome(nome);
                curso.setSite(site);
                curso.setTurno(turno);
                curso.setDuracao(duracao);
                Map<String, Object> map = new HashMap<>();

                if (new CursoDAO().alterar(curso)) {
                    ctx.redirect("/");
                } else {
                    // defino um apelido para a colecao de objetos de curso vindos do banco
                    map.put("curso", curso);
                    ctx.render("/templates/curso/tela_alterar.html", map);
                }
                // ctx.render("/templates/curso/tela_adicionar.html");
            });


            // defino que minha aplicacao rodara na porta 7070
        }).start(7070);
    }
}