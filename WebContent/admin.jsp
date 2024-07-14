<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>
    <%@ include file="header.jsp"%>
<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.text.NumberFormat" %>

<%
	String username = (String) session.getAttribute("authenticatedUser");
%>
<h3>Administrator Sales Report by Day</h3>
<table border="1">
<tbody>
<tr>
<th>Order Date</th>
<th>Total Order Amount</th>
</tr>

<%
    // TODO: Write SQL query that prints out total order amount by day
    String sql = "SELECT YEAR(orderDate) AS year, MONTH(orderDate) AS month, DAY(orderDate) AS day, SUM(totalAmount) FROM ordersummary GROUP BY YEAR(orderDate),  MONTH(orderDate), DAY(orderDate)";
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    try{
        getConnection();
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rst = pstmt.executeQuery();
        while (rst.next()){
            out.println("<tr><td>" + rst.getString(1) + "-" + rst.getString(2) + "-" + rst.getString(3) + "</td><td>" + currFormat.format(Double.parseDouble(rst.getString(4))) + "</td></tr>");
        }

        out.println("</tr></tbody></table>");

        out.println("<h3> All Customers </h3>");
        String sql2 = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country FROM customer";
        PreparedStatement pstmt2 = con.prepareStatement(sql2);
        ResultSet rst2 = pstmt2.executeQuery();
        out.println("<table class=table border=1");
        while(rst2.next()) {
            out.println("<tr>");
            out.println("<td class=col1>" + rst2.getString(1) + "</td>");
            out.println("<td class=col2>" + rst2.getString(2) + "</td>");
            out.println("<td class=col3>" + rst2.getString(3) + "</td>");
            out.println("<td class=col4>" + rst2.getString(4) + "</td>");
            out.println("<td class=col5>" + rst2.getString(5) + "</td>");
            out.println("<td class=col6>" + rst2.getString(6) + "</td>");
            out.println("<td class=col1>" + rst2.getString(7) + "</td>");
            out.println("<td class=col2>" + rst2.getString(8) + "</td>");
            out.println("<td class=col3>" + rst2.getString(9) + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");

        out.println("<div class=centerDivAndText> <a href=addproduct.jsp><h1> Add New Product </a></h1></div>");
        out.println("<div class=centerDivAndText><h1> <a href=updateproduct.jsp> Update/Delete New Product  </a></h1></div>");

        out.println("<div class=centerDivAndText><h1> <a href=warehouseInventoryInformation.jsp> Warehouse/Inventory Information </a></h1></div>");

        out.println("<div class=centerDivAndText><h1> <a href=addToWarehouse.jsp> Add to Warehouse </a></h1></div>");
        out.println("<div class=centerDivAndText><h1> <a href=updateWarehouse.jsp> Update Warehouse </a></h1></div>");


    } catch (SQLException ex){
        out.println("SQL Exception: " + ex.getMessage());
    } finally {
        closeConnection();
    }

    

%>

</body>
</html>

