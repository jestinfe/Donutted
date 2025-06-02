package kr.co.sist.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DbConnection {
	private static DbConnection dbcon;
	private static Context ctx;

	private DbConnection() {
	}

	public static DbConnection getInstance() {
		if (dbcon == null) {
			dbcon = new DbConnection();
			try {
				ctx = new InitialContext();
			} catch (NamingException e) {
				e.printStackTrace();
			}
		}
		return dbcon;
	}

	public Connection getDbConn() {
		Connection con = null;
		try {
			// DBCP 객체를 JNDI 이름으로 찾는다
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/myoracle");
			con = ds.getConnection(); //
		} catch (NamingException | SQLException e) {
			e.printStackTrace();
		}
		return con;
	}

	public void dbClose(ResultSet rs, Statement stmt, Connection con) throws SQLException {
		try {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
		} finally {
			if (con != null) con.close();
		}
	}
}
