<%@ page import="java.sql.*,java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
</head>
<body>
    <%@ include file="header.jsp" %>

    <%

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
    String uid = "sa";
    String pw = "304#sa#pw";
	String username = (String) session.getAttribute("authenticatedUser");
	if (username == null) out.println("<h3 align=\"center\"> Log in to view all your orders </h3>");
    else {
        try ( Connection con = DriverManager.getConnection(url, uid, pw);
	    Statement stmt = con.createStatement();) {
            String sql = "SELECT orderId, orderDate, totalAmount, shipToAddress, shipToCity, shipToState, shipToPostalCode, shipToCountry FROM customer JOIN ordersummary on customer.customerId = ordersummary.customerId WHERE userid = ?";
            // , orderDate, totalAmount, shipToAddress, shipToCity, shipToState, shipToPostalCode, shipToCountry
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, username);
            ResultSet rst = pstmt.executeQuery();
            
            out.println("<div class=centerDivAndText> <h1> All Your Orders </h1></div>");
            out.println("<table class=table border=1");
            while(rst.next()) {
                out.println("<tr>");
                out.println("<td class=col1>" + rst.getString(1) + "</td>");
                out.println("<td class=col2>" + rst.getString(2) + "</td>");
                out.println("<td class=col3>" + rst.getString(3) + "</td>");
                out.println("<td class=col4>" + rst.getString(4) + "</td>");
                out.println("<td class=col5>" + rst.getString(5) + "</td>");
                out.println("<td class=col6>" + rst.getString(6) + "</td>");
                out.println("<td class=col1>" + rst.getString(7) + "</td>");
                out.println("<td class=col2>" + rst.getString(8) + "</td>");
                //out.println("<td class=col3>" + rst.getString(9) + "</td>");



                out.println("</tr>");
            }
            out.println("</table>");

        }
        catch (SQLException ex) {
            out.println("SQLException: " + ex);
        }


    }
    %>

</body>
</html>