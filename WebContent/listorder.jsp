

<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
			
try ( Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();) {		
	String sql = "SELECT orderId, orderDate, customer.customerId, firstName, lastName, totalAmount FROM customer JOIN ordersummary on customer.customerId = ordersummary.customerId";
	// WHERE orderId = ?

	String sql2 = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?";
	// on orderproduct.orderId = ordersummary.orderId WHERE orderproduct.orderId = ?";

	PreparedStatement pstmt = con.prepareStatement(sql);
	PreparedStatement pstmt2 = con.prepareStatement(sql2);
	
	out.println("<table border = '1'> <tr><th> Order Id </th> <th> Order Date </th> <th> Customer Id </th> <th> Customer Name </th> <th> Total Amount </th></tr>");

	//pstmt.setString(1, "1");
	
	ResultSet rst = pstmt.executeQuery();
	
	//rst2.next();
	//out.println(rst2.getString(1) + rst2.getString(2) + rst2.getDouble(3));

	while (rst.next()) {	
		String getOrderId = rst.getString(1);
		pstmt2.setString(1, getOrderId);

		ResultSet rst2 = pstmt2.executeQuery();
		
		out.println("<tr>");
		out.println("<td>" + rst.getString(1) + "</td>");
		out.println("<td>" + rst.getString(2) + "</td>");
		out.println("<td>" + rst.getString(3) + "</td>");
		out.println("<td>" + rst.getString(4) + " " + rst.getString(5) + "</td>");
		out.println("<td>" + currFormat.format(Double.parseDouble(rst.getString(6))));
		out.println("</tr>");

		out.println("<tr align='right'>");
		out.println("<td colspan='4'>");

		out.println("<table border = '1'>");

		out.println("<th> Product Id </th> <th> Quantity </th> <th> Price </th>");
		while(rst2.next()) {
			out.println("<tr>");
			out.println("<td>" + rst2.getString(1) + "</td>");
			out.println("<td>" + rst2.getString(2) + "</td>");
			out.println("<td>" + currFormat.format(Double.parseDouble(rst2.getString(3))));
			out.println("</tr>");
		}
		
		out.println("</table>");
	
		out.println("</td>");
		out.println("</tr>");

	}
	
	out.println("</table>");

}

catch (SQLException ex) {
	out.println("SQLException: " + ex);
}

// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection
%>

</body>

</html>


