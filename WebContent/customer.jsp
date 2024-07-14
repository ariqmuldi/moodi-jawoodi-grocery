<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");

	out.println("<h3>Customer Profile</h3>");
	out.println("<table border=\"1\"><tbody>");
// TODO: Print Customer information
String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userId FROM customer WHERE userId = ?";
try{
	getConnection();
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1, userName);
	ResultSet rst = pstmt.executeQuery();
	rst.next();
	String[] tableHeaders = {"Id", "First Name", "Last Name", "Email", "Phone", "Address", "City", "State", "Postal Code", "Country", "User id"};
	for (int i = 1; i < 11; i++){
		out.println("<tr><th>" + tableHeaders[i-1] + "</th><td>" + rst.getString(i) + "</td></tr>");
	}
	out.println("</tbody></table>");
} catch (SQLException ex){
	out.println("SQLException: " + ex.getMessage());
} finally {
	closeConnection();
}

// Make sure to close connection
%>

</body>
</html>

