import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/submitTaxRegime")
public class SubmitTaxRegimeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pno = request.getParameter("pno");
        String name = request.getParameter("name");
        String level = request.getParameter("level");
        String dateStr = request.getParameter("Date");
        String switchOption = request.getParameter("switch");

        // JDBC URL, username, and password of MySQL server
        String jdbcURL = "jdbc:mysql://localhost:3306/tax";
        String jdbcUsername = "root";
        String jdbcPassword = "anku@123";

        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Connect to the MySQL database
            try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
                String sql = "INSERT INTO tuser (pno, name, level, date, switch_option) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement statement = connection.prepareStatement(sql)) {
                    statement.setString(1, pno);
                    statement.setString(2, name);
                    statement.setString(3, level);
                    
                    // Parse the date string to java.sql.Date
                    java.sql.Date sqlDate = null;
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    try {
                        java.util.Date utilDate = sdf.parse(dateStr);
                        sqlDate = new java.sql.Date(utilDate.getTime());
                    } catch (ParseException e) {
                        e.printStackTrace(); // Handle parsing exception
                    }
                    
                    statement.setDate(4, sqlDate);
                    statement.setString(5, switchOption);

                    // Execute the insert query
                    int rowsInserted = statement.executeUpdate();
                    if (rowsInserted > 0) {
                        System.out.println("A new user was inserted successfully!");
                        // Optionally, redirect to a success page or set a success message
                        response.sendRedirect("success.jsp");
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace(); // Handle exceptions appropriately
            // Optionally, forward to an error page or set an error message
            request.setAttribute("errorMessage", "Error occurred: " + ex.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
