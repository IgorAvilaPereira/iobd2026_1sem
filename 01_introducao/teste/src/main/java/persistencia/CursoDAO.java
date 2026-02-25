package persistencia;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import negocio.Curso;

public class CursoDAO {

    public List<Curso> listar() throws SQLException{
        String sql = "SELECT * FROM curso ORDER BY curso.id;";
        ArrayList<Curso> vetCurso = new ArrayList<Curso>();
        Connection conexao = new ConexaoPostgreSQL().getConnection();
        PreparedStatement instrucaoSQL = conexao.prepareStatement(sql);
        ResultSet rs = instrucaoSQL.executeQuery();
        while (rs.next()) {
            Curso curso = new Curso();
            curso.setId(rs.getInt(("id")));
            curso.setNome(rs.getString("nome"));
            vetCurso.add(curso);
        }
        instrucaoSQL.close();
        conexao.close();
        return vetCurso;
    }
    
}
