package persistencia;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexaoPostgreSQL {
    private String host;
    private String port;
    private String username;
    private String password;
    private String dbname;


    public Connection getConexao() throws SQLException{
        this.host = "localhost";
        this.port = "5432";
        this.username = "postgres";
        this.password = "postgres";
        this.dbname = "sistema_requerimento";
        String url = "jdbc:postgresql://"+this.host+":"+this.port+"/"+this.dbname;
        System.out.println(url);
        return DriverManager.getConnection(url, this.username, this.password);
    }


}
