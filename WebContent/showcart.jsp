<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
<link rel="stylesheet" href="./style.css"/>
</head>
<body>
	<%@ include file="header.jsp" %>

<!--
	<font face="Cursive" size="5">
		<div class="centerDivAndText"><h1 class="mainTitle">MoodiJawoodi Grocery </h1></div>
		</font>

		<font face="Monospace" size="4">
			<table><tr> <th class="col4"> <a href = listprod.jsp> Product Page</a></th> <th class="col4"> <a href=listorder.jsp>List Order </a> </th> <th class="col4"> <a href=showcart.jsp>Shopping Cart</a></th></tr></table>
			<hr>
	-->


<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	
	productList = new HashMap<String, ArrayList<Object>>();
	try {
		getConnection();
		String sqlGetCart = "SELECT incart.productId, productName, price, quantity FROM incart JOIN product ON incart.productId = product.productId";
		PreparedStatement pstmt = con.prepareStatement(sqlGetCart);
		ResultSet rst = pstmt.executeQuery();
		while (rst.next()){
			ArrayList<Object> product = new ArrayList<Object>();
			product.add(rst.getString(1));
			product.add(rst.getString(2));
			product.add(rst.getDouble(3));
			product.add(rst.getInt(4));
			if (productList.containsKey(rst.getString(1)))
			{	product = (ArrayList<Object>) productList.get(rst.getString(1));
				int curAmount = ((Integer) product.get(3)).intValue();
				product.set(3, new Integer(curAmount+1));
			}
			else
				productList.put(rst.getString(1),product);
	}

	} catch (Exception ex){

	} finally {
		closeConnection();
	}
}
if (productList.size() == 0){
	out.println("<H1>Your shopping cart is empty!</H1>");
	
	String delItem = request.getParameter("delete");
	String newQuantity = request.getParameter("newQuantity");

}
else
{
	String delItem = request.getParameter("delete");
	String newQuantity = request.getParameter("newQuantity");
	//String prodId = request.getParameter("prodId");
	//out.println(prodId);

	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	out.println("<h1>Your Shopping Cart</h1>");
	out.print("<table class=table><tr><th class=col5>Product Id</th><th class=col5>Product Name</th><th class=col5>Quantity</th>");
	out.println("<th class=col5>Price</th><th class=col5>Subtotal</th></tr>");

	double total = 0;

	Set<String> keys = productList.keySet();
	for (String key : keys) {
		if(delItem != null && delItem.equals(key)) {
			productList.remove(key);
			try{
				getConnection();
				String deleteSQL = "DELETE FROM incart WHERE productId = ?";
				PreparedStatement pstmt = con.prepareStatement(deleteSQL);
				pstmt.setString(1, key);
				pstmt.executeUpdate();
			}catch(SQLException ex){
				out.println("Error");
			}finally{
				closeConnection();
			}
			break;
		}
	}

	/*
	for(String key : keys) {
		if(newQuantity != null && newQuantity)
	}
	*/

	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		
		String productId = (String) product.get(0);
		String productName = (String) product.get(1);
		out.print("<tr><td class=col1>"+productId+"</td>");
		out.print("<td class=col2>"+productName+"</td>");
		//out.print("<td align=\"center\">"+product.get(3)+"</td>");

		out.println("<form method=\"get\" action=\"showcart.jsp\">");
		out.print("<td align=\"center\" class=col0>"+ "<input type=\"text\" name=\"newQuantity\" size=3 value =" + product.get(3) +"></td>");

		Object price = product.get(2);
		Object itemqty = product.get(3);

		//out.println(newQuantity);
		/*
		if(Integer.parseInt(newQuantity) != null && Integer.parseInt(newQuantity) != 1) {
			itemqty = newQuantity;
		}
		*/

		double pr = 0;
		int qty = 0;
		
		/*
		out.print("<tr><td>"+productId+"</td>");
		out.print("<td>"+product.get(1)+"</td>");

		out.print("<td align=\"center\">"+product.get(3)+"</td>");
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		*/

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

		out.print("<td align=\"right\" class=col3>"+currFormat.format(pr)+"</td>");

		String removeItemLink = "showcart.jsp?delete=" + product.get(0);
		out.print("<td align=\"right\" class=col3>"+currFormat.format(pr*qty)+"</td>" + "<td align=\"right\" class=col0> <a href=" + removeItemLink + ">Remove Item From Cart</a> </td>");

		//String updateOnClick = "update(" + product.get(0); + ", document.form1.newQty.value) value = Update Quantity>";
		//<form method="get" action="listprod.jsp">
			
		//out.println("<form method=\"get\" action=\"showcart.jsp\">");
		out.println("<td> <input type=\"submit\" value=\"Update Quantity\"> </td></tr>");
		out.println("</form>");

		out.println("</tr>");

		total = total +pr*qty;
		
	}
	out.println("<tr><td colspan=\"4\" align=\"right\" ><b>Order Total</b></td>"
			+"<td align=\"right\" class=col4>"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");

	/*
	out.println("testing");
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator3 = productList.entrySet().iterator();
		while (iterator3.hasNext())
		{ 
			Map.Entry<String, ArrayList<Object>> entry = iterator3.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			String productId = (String) product.get(0);
			String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			int qty = ( (Integer)product.get(3)).intValue();
			out.println(productId + " " + qty + price);
		}
	*/

	out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");

}
session.setAttribute("productList", productList);
%>

<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</font>
</body>
</html> 

