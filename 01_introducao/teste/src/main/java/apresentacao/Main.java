package apresentacao;

import java.sql.SQLException;
import java.util.List;

import negocio.Curso;
import persistencia.CursoDAO;

public class Main {
    public static void main(String[] args) throws SQLException {

        List<Curso> vetCursosDisponiveis = new CursoDAO().listar();
        for (Curso curso : vetCursosDisponiveis) {
            System.out.println(curso.getId());
            System.out.println(curso.getNome());
        }
    }
}