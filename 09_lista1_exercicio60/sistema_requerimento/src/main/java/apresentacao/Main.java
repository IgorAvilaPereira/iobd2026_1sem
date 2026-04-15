package apresentacao;

import java.sql.SQLException;
import java.time.LocalDate;

import io.javalin.Javalin;
import io.javalin.rendering.template.JavalinMustache;

import java.util.HashMap;
import java.util.Map;

import negocio.Curso;
import negocio.Usuario;
import persistencia.CursoDAO;
import persistencia.UsuarioDAO;

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
                map.put("teste", "oi!! igor paraninfo!");
                // renderizo a pagina html encaminhando tb o map
                ctx.render("/templates/index.html", map);
            });

              config.routes.get("/usuarios", ctx -> {
                // crio um map <chave, valor> para que seja usado la no html
                Map<String, Object> map = new HashMap<>();
                // defino um apelido para a colecao de objetos de curso vindos do banco
                map.put("vetUsuario", new UsuarioDAO().listar());                
                // renderizo a pagina html encaminhando tb o map
                ctx.render("/templates/usuario/index.html", map);
            });

            config.routes.get("/curso/excluir/{id}", ctx -> {
                new CursoDAO().excluir(Integer.parseInt(ctx.pathParam("id")));
                ctx.redirect("/");
            });

             config.routes.get("/usuario/excluir/{id}", ctx -> {
                new UsuarioDAO().excluir(Integer.parseInt(ctx.pathParam("id")));
                ctx.redirect("/usuarios");
            });

             config.routes.get("/usuario/tela_alterar/{id}", ctx -> {
                Usuario usuario = new UsuarioDAO().obter(Integer.parseInt(ctx.pathParam("id")));
                Map<String, Object> map = new HashMap<>();
                // defino um apelido para a colecao de objetos de curso vindos do banco
                map.put("usuario", usuario);
                ctx.render("/templates/usuario/tela_alterar.html", map);
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

            config.routes.get("/usuario/tela_adicionar", ctx -> {
                ctx.render("/templates/usuario/tela_adicionar.html");
            });

            config.routes.post("/usuario/adicionar", ctx -> {
                String nome = ctx.formParam("nome");
                String email = ctx.formParam("email");
                String senha = ctx.formParam("senha");
                String cpf = ctx.formParam("cpf");
                String dataNascimento = ctx.formParam("data_nascimento");
                String rua = ctx.formParam("rua");
                String complemento = ctx.formParam("complemento");
                String nro = ctx.formParam("nro");                               

                Usuario usuario = new Usuario();
                usuario.setNome(nome);
                usuario.setEmail(email);
                usuario.setSenha(senha);
                System.out.println(dataNascimento);
                usuario.setDataNascimento(LocalDate.parse(dataNascimento));
                usuario.setCpf(cpf);
                usuario.setRua(rua);
                usuario.setNro(nro);
                usuario.setComplemento(complemento);

                if (new UsuarioDAO().adicionar(usuario)) {
                    ctx.redirect("/usuarios");
                } else {
                    ctx.redirect("/templates/usuario/tela_adicionar.html");
                }
                // ctx.render("/templates/curso/tela_adicionar.html");
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



            config.routes.post("/usuario/alterar", ctx -> {
                int id = Integer.parseInt(ctx.formParam("id"));
                String nome = ctx.formParam("nome");
                String cpf = ctx.formParam("cpf");
                String email = ctx.formParam("email");
                String cep = ctx.formParam("cep");
                String rua = ctx.formParam("rua");
                String complemento = ctx.formParam("complemento");  
                String nro = ctx.formParam("nro");
                String manter_senha = ctx.formParam("manter_senha");
                // System.out.println(manter_senha);
                String senha = ctx.formParam("senha");
                
                String dataNascimento = ctx.formParam("data_nascimento");
                LocalDate date = LocalDate.parse(dataNascimento); 

                Usuario usuario = new Usuario();
                boolean manter_senha_boolean = true;
                if (manter_senha != null && manter_senha.equals("manter")) {
                    usuario = new UsuarioDAO().obter(id);
                }
                else if (manter_senha == null){
                    manter_senha_boolean = false;
                    usuario.setSenha(senha);
                }
                usuario.setId(id);
                usuario.setNome(nome);
                usuario.setCpf(cpf);
                usuario.setEmail(email);
                usuario.setCep(cep);
                usuario.setComplemento(complemento);
                usuario.setRua(rua);
                usuario.setNro(nro);
                usuario.setDataNascimento(date);

                Map<String, Object> map = new HashMap<>();
                if (new UsuarioDAO().alterar(usuario, manter_senha_boolean)) {
                    ctx.redirect("/usuarios");
                } else {
                    // defino um apelido para a colecao de objetos de curso vindos do banco
                    map.put("usuario", usuario);
                    ctx.render("/templates/usuario/tela_alterar.html", map);
                }
                // ctx.render("/templates/curso/tela_adicionar.html");
            });


            // defino que minha aplicacao rodara na porta 7070
        }).start(7070);
    }
}