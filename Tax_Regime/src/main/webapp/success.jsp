<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tax Regime - Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding-top: 60px;
        }
        header {
            position: fixed;
            top: 0;
            width: 100%;
            background-color:rgb(51, 51, 51); 
            border-bottom: 1px solid #fff;
            z-index: 1000;
            padding-left: 100px ;
            padding-top: 8px;
            text-align: left;
            justify-content: center;
            color: #fff;
            height: 80px;
        }
        .lbtn {
            background-color:rgb(51, 51, 51);
            color: #fff;
            font-size: large;
            cursor: pointer;
            padding-top: 15px;
            text-decoration: none;
        }
        .hdiv {
            display: flex;
        }
        h1 {
            width: 85%;
        }
        .new-user-header {
            width: calc(100% - 40px);
            height: 50px;
            background-color: #008cba;
            color: white;
            display: flex;
            align-items: center;
            justify-content: left;
            margin: 100px auto 20px auto;
            padding: 0 20px;
            box-sizing: border-box;
        }
        .new-user-header h2 {
            margin: 0;
        }
        .container {
            max-width: 800px;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #008cba;
            color: white;
        }
        .filter-container {
            margin-bottom: 20px;
        }
        .filter-container label {
            margin-right: 10px;
        }
        .filter-container input[type="date"] {
            padding: 5px;
        }
        .filter-container input[type="submit"] {
            padding: 5px 10px;
            cursor: pointer;
            background-color: #008cba;
            color: white;
            border: none;
        }
    </style>
</head>
<body>
    <header>
        <div class="hdiv">
            <h1>Tax Regime</h1>
            <a href='register.html' class="lbtn"><b>Log out</b></a>
        </div>
    </header>
    <div class="new-user-header">
        <h2>Report</h2>
    </div>
    <div class="container">
        <div class="filter-container">
            <center><form action="success.jsp" method="post">
                <label for="fromDate">From Date:</label>
                <input type="date" id="fromDate" name="fromDate">
                <label for="toDate">To Date:</label>
                <input type="date" id="toDate" name="toDate">
                <input type="submit" value="Filter">
            </form>
            </center>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Pno</th>
                    <th>Name</th>
                    <th>Level</th>
                    <th>Created on</th>
                    <th>Option</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        // Database connection parameters
                        String jdbcURL = "jdbc:mysql://localhost:3306/tax";
                        String jdbcUsername = "root";
                        String jdbcPassword = "anku@123";

                        // Load the MySQL JDBC driver
                        Class.forName("com.mysql.cj.jdbc.Driver");

                        // Establish the connection
                        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
                            String sql = "SELECT * FROM tuser";
                            
                            // Get the date range from request parameters
                            String fromDateStr = request.getParameter("fromDate");
                            String toDateStr = request.getParameter("toDate");
                            
                            // Prepare dates for SQL query
                            java.sql.Date fromDate = null;
                            java.sql.Date toDate = null;
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            if (fromDateStr != null && !fromDateStr.isEmpty()) {
                                fromDate = new java.sql.Date(sdf.parse(fromDateStr).getTime());
                            }
                            if (toDateStr != null && !toDateStr.isEmpty()) {
                                toDate = new java.sql.Date(sdf.parse(toDateStr).getTime());
                            }
                            
                            // Update SQL query if date range is specified
                            if (fromDate != null && toDate != null) {
                                sql = "SELECT * FROM tuser WHERE date BETWEEN ? AND ?";
                            }
                            
                            // Create a PreparedStatement
                            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                                // Set parameters
                                if (fromDate != null && toDate != null) {
                                    statement.setDate(1, fromDate);
                                    statement.setDate(2, toDate);
                                }
                                
                                // Execute the query
                                try (ResultSet resultSet = statement.executeQuery()) {
                                    // Iterate through the result set and create rows in the table
                                    while (resultSet.next()) {
                                        String pno = resultSet.getString("pno");
                                        String name = resultSet.getString("name");
                                        String level = resultSet.getString("level");
                                        Date createdOn = resultSet.getDate("date");
                                        String switchOption = resultSet.getString("switch_option");
                %>
                                        <tr>
                                            <td><%= pno %></td>
                                            <td><%= name %></td>
                                            <td><%= level %></td>
                                            <td><%= createdOn != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(createdOn) : "" %></td>
                                            <td><%= switchOption %></td>
                                        </tr>
                <% 
                                    }
                                }
                            }
                        } catch (SQLException e) {
                            e.printStackTrace(); // Handle errors appropriately
                        }
                    } catch (ClassNotFoundException e) {
                        e.printStackTrace(); // Handle errors appropriately
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>