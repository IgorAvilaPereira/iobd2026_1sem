package apresentacao;

import java.sql.SQLException;

import io.javalin.Javalin;
import io.javalin.rendering.template.JavalinMustache;

import java.util.HashMap;
import java.util.Map;

import negocio.Curso;
import persistencia.ConexaoPostgreSQL;
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

            // defino que minha aplicacao rodara na porta 7070
        }).start(7070);
    }
}