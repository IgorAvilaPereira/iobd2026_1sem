package persistencia;

import java.sql.*;

public class ConexaoPostgreSQL {


    private String dbname;
    private String password;
    private String username;
    private String host;
    private String port;

    public ConexaoPostgreSQL(){
        this.host = "localhost";
        this.port = "5432";
        this.username = "postgres";
        this.password = "postgres";
        this.dbname = "sistema_requerimento";
    }

    public Connection getConnection(){
        try {
            String url = "jdbc:postgresql://"+this.host+":"+this.port+"/"+this.dbname;
            return DriverManager.getConnection(url, this.username, this.password);
        } catch (Exception e) {
            System.out.println("Deu xabum! Deu ruim!");
        }
        return null;
    }

}
