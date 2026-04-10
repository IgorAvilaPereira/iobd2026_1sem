package persistencia;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import negocio.Usuario;

public class UsuarioDAO {

    public void excluir(int id) throws SQLException {
        String sql = "UPDATE usuario SET ativo = FALSE where id = ?;";
        Connection connection = new ConexaoPostgreSQL().getConexao();
        PreparedStatement instrucaoSQL = connection.prepareStatement(sql);
        instrucaoSQL.setInt(1, id);
        instrucaoSQL.executeUpdate();
        connection.close();    
    }

    public List<Usuario> listar() throws SQLException{
        // defini o tipo de dado/estrutura retornada
        List<Usuario> vetUsuario = new ArrayList<Usuario>();
        // criei o sql
        String sql = "SELECT * FROM usuario WHERE ativo IS TRUE ORDER BY id ASC";
        // abri conexao
        Connection connection = new ConexaoPostgreSQL().getConexao();
        // embrulhei a string com a consulta sql em verdadeiramente em um instrucao sql
        PreparedStatement instrucaoSQL = connection.prepareStatement(sql);
        // execute a consulta sql e atribui o resultado em um objeto de result set
        ResultSet rs = instrucaoSQL.executeQuery();
        while (rs.next()) {
            // enquanto ha resultados - crio instancias/objetos de usuario
            Usuario usuario = new Usuario();
            usuario.setId(rs.getInt("id"));
            usuario.setNome(rs.getString("nome"));
            usuario.setEmail(rs.getString("email"));
            usuario.setDataNascimento((rs.getDate("data_nascimento") == null ) ? null: rs.getDate("data_nascimento").toLocalDate());
            usuario.setCpf(rs.getString("cpf"));
            usuario.setCep(rs.getString("cep"));
            usuario.setRua(rs.getString("rua"));
            usuario.setComplemento(rs.getString("complemento"));
            usuario.setNro(rs.getString("nro"));            
            // e coloco/acrescento como um novo elemento da colecao 
            vetUsuario.add(usuario);
        }
        // fecho conexao
        connection.close();
        // retorno a colecao com as instancias necessarias
        return vetUsuario;
    }

    public boolean adicionar(Usuario usuario) throws SQLException {
        String sql = "INSERT INTO usuario (nome, email, cpf, data_nascimento, cep, rua, complemento, nro) VALUES (?, ?,?, ?, ?, ?, ?, ?) RETURNING id";
        Connection connection = new ConexaoPostgreSQL().getConexao();
        // embrulhei a string com a consulta sql em verdadeiramente em um instrucao sql
        PreparedStatement instrucaoSQL = connection.prepareStatement(sql);
        instrucaoSQL.setString(1, usuario.getNome());
        instrucaoSQL.setString(2, usuario.getEmail());
        instrucaoSQL.setString(3, usuario.getCpf());
        instrucaoSQL.setDate(4, (usuario.getDataNascimento() == null ) ? null: Date.valueOf(usuario.getDataNascimento()));
        instrucaoSQL.setString(5, usuario.getCep());
        instrucaoSQL.setString(6, usuario.getRua());
        instrucaoSQL.setString(7, usuario.getComplemento());
        instrucaoSQL.setString(8, usuario.getNro());
        // execute a consulta sql e atribui o resultado em um objeto de result set
        ResultSet rs = instrucaoSQL.executeQuery();
        if(rs.next()) {
            usuario.setId(rs.getInt("id"));
        }
        return usuario.getId() != 0;
    }

    public Usuario obter(int id) throws SQLException {
        Usuario usuario = new Usuario();
        // criei o sql
        String sql = "SELECT * FROM usuario WHERE ativo IS TRUE AND id = ? ORDER BY id ASC";
        // abri conexao
        Connection connection = new ConexaoPostgreSQL().getConexao();
        // embrulhei a string com a consulta sql em verdadeiramente em um instrucao sql
        PreparedStatement instrucaoSQL = connection.prepareStatement(sql);
        instrucaoSQL.setInt(1, id);
        // execute a consulta sql e atribui o resultado em um objeto de result set
        ResultSet rs = instrucaoSQL.executeQuery();
        if (rs.next()) {
            usuario.setId(rs.getInt("id"));
            usuario.setNome(rs.getString("nome"));
            usuario.setEmail(rs.getString("email"));
            usuario.setDataNascimento((rs.getDate("data_nascimento") == null ) ? null: rs.getDate("data_nascimento").toLocalDate());
            // System.out.println(usuario.getDataNascimento().toString());
            usuario.setCpf(rs.getString("cpf"));
            usuario.setCep(rs.getString("cep"));
            usuario.setRua(rs.getString("rua"));
            usuario.setComplemento(rs.getString("complemento"));
            usuario.setNro(rs.getString("nro")); 
        }
        // fecho conexao
        connection.close();
        // retorno a colecao com as instancias necessarias
        return usuario;
    }

    public boolean alterar(Usuario usuario) throws SQLException {
        String sql = "UPDATE usuario SET nome = ?, email = ?, cpf = ?, data_nascimento = ?, cep = ?, rua = ?, complemento = ?, nro = ? where id = ?";
        Connection connection = new ConexaoPostgreSQL().getConexao();
        PreparedStatement instrucaoSQL = connection.prepareStatement(sql);
        instrucaoSQL.setString(1, usuario.getNome());
        instrucaoSQL.setString(2, usuario.getEmail());
        instrucaoSQL.setString(3, usuario.getCpf());        
        instrucaoSQL.setDate(4, (usuario.getDataNascimento() == null ) ? null: Date.valueOf(usuario.getDataNascimento()));
        instrucaoSQL.setString(5, usuario.getCep());
        instrucaoSQL.setString(6, usuario.getRua());
        instrucaoSQL.setString(7, usuario.getComplemento());
        instrucaoSQL.setString(8, usuario.getNro());
        instrucaoSQL.setInt(9, usuario.getId());
        int num = instrucaoSQL.executeUpdate();
        return num != 0;
    }

}
