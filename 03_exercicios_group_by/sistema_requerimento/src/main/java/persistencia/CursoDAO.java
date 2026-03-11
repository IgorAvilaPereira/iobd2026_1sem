package persistencia;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import negocio.Curso;

public class CursoDAO {

    public void inserir(Curso curso) throws SQLException {
        String sql = "INSERT INTO curso (nome, site, turno, duracao) VALUES (?, ?, ?, ?);";
        Connection connection = new ConexaoPostgreSQL().getConexao();
        PreparedStatement instrucaoSQL = connection.prepareStatement(sql);
        instrucaoSQL.setString(1, curso.getNome());
        instrucaoSQL.setString(2, curso.getSite());
        instrucaoSQL.setString(3, curso.getTurno());
        instrucaoSQL.setInt(4, curso.getDuracao());
        instrucaoSQL.executeUpdate();
        connection.close();    
    }

    public List<Curso> listar() throws SQLException{
        // defini o tipo de dado/estrutura retornada
        List<Curso> vetCurso = new ArrayList<Curso>();
        // criei o sql
        String sql = "SELECT * FROM curso ORDER BY nome ASC";
        // abri conexao
        Connection connection = new ConexaoPostgreSQL().getConexao();
        // embrulhei a string com a consulta sql em verdadeiramente em um instrucao sql
        PreparedStatement instrucaoSQL = connection.prepareStatement(sql);
        // execute a consulta sql e atribui o resultado em um objeto de result set
        ResultSet rs = instrucaoSQL.executeQuery();
        while (rs.next()) {
            // enquanto ha resultados - crio instancias/objetos de curso
            Curso curso = new Curso();
            curso.setId(rs.getInt("id"));
            curso.setNome(rs.getString("nome"));
            curso.setSite(rs.getString("site"));
            curso.setDuracao(rs.getInt("duracao"));
            curso.setTurno(rs.getString("turno"));
            // e coloco/acrescento como um novo elemento da colecao 
            vetCurso.add(curso);
        }
        // fecho conexao
        connection.close();
        // retorno a colecao com as instancias necessarias
        return vetCurso;
    }

}
