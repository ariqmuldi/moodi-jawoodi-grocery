<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.*" %>

<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
 
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>MoodiJawoodi Grocery Order Processing</title>
</head>
<body>
	<%@ include file="header.jsp" %>

<% 
// Get customer id
String custId = request.getParameter("customerId");
String paymentType = request.getParameter("paymentType");
String paymentNumber = request.getParameter("paymentNumber");
String paymentExpiryDate = request.getParameter("paymentExpiryDate");

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message

// Make connection



String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";

//out.println(paymentType);

try ( Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();) {	
	// This code block just determins if the customerId is valid
	String validCustIdSQL = "SELECT customerId FROM customer";
	boolean validCustIdFlag = false;
	ResultSet rst = stmt.executeQuery(validCustIdSQL);
	
		//out.println(paymentType);
	if(custId == null) {
		out.println("<h1> Invalid customer id. Go back to the previous page and try again. </h1>");
		return;
	}
	else {
		while(rst.next()) {
			if(Integer.parseInt(custId) == Integer.parseInt(rst.getString(1))) {
				validCustIdFlag = true;
			}
		}
		if(!validCustIdFlag) {
			out.println("<h1> Invalid customer id. Go back to the previous page and try again. </h1>");
			return;
		}
	}

	

	/*
	if(paymentType == null | paymentNumber == null | paymentExpiryDate == null) {
		out.println("<h1> Invalid payment info. Go back to the previous page and try again. </h1>");
		return;
	}
	*/

	String delCart = "DELETE FROM incart";
	stmt.executeUpdate(delCart);

	/*
	if(paymentType == null || paymentNumber == null || paymentExpiryDate == null) {
		out.println("<h1> Invalid payment info. Go back to the previous page and try again. </h1>");
		return;
	}
	*/

	

	/*
	boolean goodPayment = true;
	if(paymentType == null || paymentNumber == null || paymentExpiryDate == null) {
		out.println("<h1> Invalid payment info. Go back to the previous page and try again. </h1>");
		goodPayment = false;
	}
	else {
		String sqlPayment = "INSERT INTO paymentmethod VALUES (?, ?, ?, ?)";
		PreparedStatement pstmt = con.prepareStatement(sqlPayment);
		//LocalDate date = LocalDate.parse(paymentExpiryDate, DateTimeFormatter.ISO_DATE);
		pstmt.setString(1, paymentType);
		pstmt.setString(2, paymentNumber);
		pstmt.setString(3, paymentExpiryDate);
		pstmt.setString(4, custId);
	
	}

	if(!goodPayment) return;
	*/
	


	String getCustomerInfo = "SELECT address, city, state, postalCode, country, firstName, lastName FROM customer WHERE customerId = " + custId;

	DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");  
   	LocalDateTime now = LocalDateTime.now();  
	String currDate = dtf.format(now); // the time is hours ahead for some reason (not correct timezone)
	// we have customerId from custId

	ResultSet rst2 = stmt.executeQuery(getCustomerInfo);
	String address, city, state, postalCode, country, firstName, lastName;
	rst2.next();
	address = rst2.getString(1);
	city = rst2.getString(2);
	state = rst2.getString(3);
	postalCode = rst2.getString(4);
	country = rst2.getString(5);
	firstName = rst2.getString(6);
	lastName = rst2.getString(7);


	double totalAmount = 0.0; // this will be found from adding all the prices in the productList
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		while (iterator.hasNext())
		{ 
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			Double price = ((Double) product.get(2)).doubleValue(); // reduced from 2 lines to 1 line to convert to Double		
			int qty = ( (Integer)product.get(3)).intValue();
			totalAmount += price * qty; // total Amount, used to use pr now uses price
		}


	// I JUST REALIZED THAT ALL WE NEED IS all the attributes of ordersummary except orderId. 
	String sql = "INSERT INTO ordersummary VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
	pstmt.setString(1, currDate);
	pstmt.setDouble(2, totalAmount);
	pstmt.setString(3, address);
	pstmt.setString(4, city);
	pstmt.setString(5, state);
	pstmt.setString(6, postalCode);
	pstmt.setString(7, country);
	pstmt.setString(8, custId);
	pstmt.executeUpdate();
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);

	Iterator<Map.Entry<String, ArrayList<Object>>> iterator2 = productList.entrySet().iterator();
		while (iterator2.hasNext())
		{ 

			Map.Entry<String, ArrayList<Object>> entry = iterator2.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			String productId = (String) product.get(0);
			Double price = ((Double) product.get(2)).doubleValue(); // onnly need 1 line instead of 2 to convert to double
			int qty = ( (Integer)product.get(3)).intValue();

			String sql2 = "INSERT INTO orderproduct VALUES (?, ?, ?, ?)";
			PreparedStatement pstmt2 = con.prepareStatement(sql2);
			pstmt2.setInt(1, orderId);
			pstmt2.setString(2, productId);
			pstmt2.setInt(3, qty);
			pstmt2.setDouble(4, price);
			pstmt2.executeUpdate();
		}

	/*
	String test = "SELECT * FROM orderproduct";
	ResultSet testRST = stmt.executeQuery(test);
	while(testRST.next()) {
		out.println(testRST.getString(1) + " "); //+ " " + testRST.getString(2) + " " + testRST.getString(3) + " " + testRST.getString(4));
	}
	*/

	
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	out.println("<h1>Your Order Summary</h1>");
	out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th></tr>");

	double total =0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator3 = productList.entrySet().iterator();
	while (iterator3.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator3.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		
		out.print("<tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");

		out.print("<td align=\"center\">"+product.get(3)+"</td>");
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}		

		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td></tr>");
		out.println("</tr>");
		total = total +pr*qty;
	}
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
			+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");

	String asteriks = "";
	for(int i = 0; i < paymentNumber.length() - 2; i++) {
		asteriks +="*";
	}

	out.println("<h1> Order completed. Will be shipped soon... </h1>");
	out.println("<h1> Ordered using payment type: " + paymentType + ", payment number: " + paymentNumber.substring(0,2) + asteriks + ", payment expiry date: " + paymentExpiryDate.substring(0,4) + "</h1>");
	out.println("<h1> <a href=ship.jsp?orderId=" + orderId + "> Shipment Details </a></h1>");
	out.println("<h1> Your order reference number is: " + orderId + "</h1>");
	out.println("<h1> Shipping to customer: " + custId + " Name: " + firstName + " " + lastName + "</h1>");
	

	productList.clear();

	}

catch(SQLException ex) {
	out.println("SQLException: " + ex);

}

// Save order information to database


	/*
	// Use retrieval of auto-generated keys.
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	*/

// Insert each item into OrderProduct table using OrderId from previous INSERT

// Update total amount for order record

// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/

// Print out order summary

// Clear cart if order placed successfully
%>
</BODY>
</HTML>

