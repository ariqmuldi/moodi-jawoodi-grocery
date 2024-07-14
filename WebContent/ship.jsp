<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>MoodiJawoodi Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// TODO: Get order id
    String orderId = request.getParameter("orderId");
	// TODO: Check if valid order id in database
	try{
		getConnection();
		String sql = "SELECT orderId FROM ordersummary WHERE orderId = ?";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, orderId);
		ResultSet rst2 = pstmt.executeQuery();
		if(rst2.next())
		{
			// TODO: Start a transaction (turn-off auto-commit)
			con.setAutoCommit(false);
			// TODO: Retrieve all items in order with given id
			Statement stmt = con.createStatement();
			Statement stmt2 = con.createStatement();
			ResultSet rst = stmt2.executeQuery("SELECT orderproduct.productId, orderproduct.quantity, productinventory.quantity, warehouseId FROM orderproduct JOIN productinventory ON orderproduct.productId = productinventory.productId WHERE orderId = " + orderId);
			// TODO: Create a new shipment record.
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");  
   			LocalDateTime now = LocalDateTime.now();  
			String currDate = dtf.format(now);
			boolean success = true;
			PreparedStatement pstmt2 = con.prepareStatement("INSERT INTO shipment VALUES(?, ?, ?)");
			pstmt2.setString(1, currDate);
			pstmt2.setString(2, "Shipment of " + orderId);
			pstmt2.setInt(3, 1);
			pstmt2.executeUpdate();
			// TODO: For each item verify sufficient quantity available in warehouse 1.
			while(rst.next()){
				if (rst.getInt(3) >= rst.getInt(2)) {
					out.println("<h2>Ordered Product: " + rst.getInt(1) + " Qty: " + rst.getInt(2) + " Previous Inventory: " + rst.getInt(3) + " New Inventory: " + (rst.getInt(3) - rst.getInt(2)) + "</h2>");
					stmt.executeUpdate("UPDATE productinventory SET quantity = quantity - " + rst.getInt(2) + "WHERE productId =" + rst.getInt(1));
				} else{
					success = false;
					out.println("<h1>Shipment not done. Insufficient inventory for product id: " + rst.getInt(1));
					con.rollback();
				}
			}
			// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
			if (success) con.commit();
			// TODO: Auto-commit should be turned back on
			con.setAutoCommit(true);
		} else {out.println("Invalid OrderId.");}
	} catch (SQLException ex){
		out.println("SQLException: " + ex.getMessage());
		con.rollback();
	} finally {
		closeConnection();
	}
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
