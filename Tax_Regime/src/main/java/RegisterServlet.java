

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
	String url = "jdbc:mysql://localhost:3306/tax";
    String user = "root";
    String passwords = "anku@123";
	
	private static final long serialVersionUID = 1L;


	
	
	

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		String userid = request.getParameter("user_id");
		String username= request.getParameter("user_name");
		String email= request.getParameter("email");
		String contactno= request.getParameter("contact_no");
		String password= request.getParameter("password");
		
		
		PrintWriter out= response.getWriter();
		response.setContentType("text/html");
		
		
		 try {
	          Class.forName("com.mysql.cj.jdbc.Driver");
	          Connection conn = DriverManager.getConnection(url, user, passwords);
	          String query = "insert into user values(?,?,?,?,?)";
	          PreparedStatement ps = conn.prepareStatement(query);
	          ps.setString(1, userid);
	          ps.setString(2, username);
	          ps.setString(3, email);
	          ps.setString(4, contactno);
	          ps.setString(5, password);
	          int count = ps.executeUpdate();
	          if(count>0) {
	        	  out.println("<h2> you have registered successfully!! </h2>");
	              RequestDispatcher rd = request.getRequestDispatcher("Login.html");
	          	  rd.include(request, response);
	          }
	          else
	        	  out.println("<h2> not inserted </h2>");
		 }
		 catch (Exception e) {
             out.println("<h2>Exception:" + e.getMessage()+"</h2>");
         }

      
	}

}