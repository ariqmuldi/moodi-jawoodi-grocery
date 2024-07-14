<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>

	<!--
	<title>MoodiJawoodi Grocery</title>
	<link rel="stylesheet" href="style.css"/>
	</head>
	<body>
	
	<font face="Cursive" size="5">
	<div class="centerDivAndText"><h1 class="mainTitle">MoodiJawoodi Grocery </h1></div>
	</font>
	
	<font face="Monospace" size="4">
	<table><tr> <th class="col4"> <a href = listprod.jsp> Product Page</a></th> <th class="col4"> <a href=listorder.jsp>List Order </a> </th> <th class="col4"> <a href=showcart.jsp>Shopping Cart</a></th></tr></table>
	<hr>
	</font>
	
	<font face="Monospace" size="3">
	<h1 style="color:#427D9D" >Search for the products you want to buy:</h1>
	</font>
	-->
<%@ include file="header.jsp" %>

<body>

	
	<font face="Monospace" size="3">
	<h1 style="color:#427D9D" >Search for the products you want to buy:</h1>
	</font>

	<form method="get" action="listprod.jsp">
	<select size="1" name="categoryName">
		<option>All</option>
		<option>Spices and Seasonings</option>
		<option>Grains and Pulses</option>
		<option>Oils and Sauces</option>
		<option>Dried Fruits and Nuts</option>
		<option>Sweets and Desserts</option>
		<option>Breads and Pastries</option>
		<option>Teas and Beverages</option>
		<option>Dairy and Cheese</option>
	</select>
	<input type="text" name="productName" size="50">
	<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
	</form>

<% // Get product name to search for
String name = request.getParameter("productName");
String categoryName = request.getParameter("categoryName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered

// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

// Make the connection
try ( Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();) {		
	
	PreparedStatement pstmt;
	String sql;
	String productsShown = "<tr> <th class=col0>  </th> <th class=col0> Product Name </th> <th class=col0> Price </th> </tr>";
	
	
	out.println("<h2 style=color:Purple> Top Products Sold! </h2>");
	String sqlTopProduct = "SELECT productName, price, product.productId FROM product JOIN orderproduct ON product.productId = orderproduct.productId JOIN ordersummary on orderproduct.orderId = ordersummary.orderId GROUP BY productName, price, product.productId ORDER BY SUM(quantity) DESC";
	pstmt = con.prepareStatement(sqlTopProduct);
	
	out.println("<table class=table");
	for(int i = 0; i < 2; i++) {
		ResultSet rstTopProduct = pstmt.executeQuery();
		out.print("<tr>");
		for(int j = 0; j < 3; j++) {	
			rstTopProduct.next();
			//if (i == 0){
				//if(!(rstTopProduct.getString(1) == "null"))
        			//out.print("height=\"100px\"><td class=col3><img height=5 width=5 src=\"" + rstTopProduct.getString(3) + "\">");
					//break;
			//}

			if(i == 1) {
				out.print("<td class=col3>"+ currFormat.format(Double.parseDouble(rstTopProduct.getString(i+1)))+"</td>"); 
			}
			else {
				
				String forLink = "product.jsp?id=" + rstTopProduct.getString(3);
				out.print("<td class=col3><a class=colorATopProduct href=" + forLink + "> <p style=\"font-size: 20px;\">" + rstTopProduct.getString(i+1) +  "</p></a></td>");
			}
			
		}
		out.println("</tr>");
	}
	out.println("</table>");

	if((name == null || name.strip().equals("")) && (categoryName == null || categoryName.equals("All"))) {
		out.println("<h2 style=color:#CE5A67> All Products </h2>");
		out.println("<table class=table border=1>");
		out.println(productsShown);
		sql = "SELECT productName, productPrice, productId FROM product";
		pstmt = con.prepareStatement(sql);
	}
	else if(categoryName == null || categoryName.equals("All")){
		out.println("<h2> All products containing '" + name + "' </h2>");
		out.println("<table class=table border=1>");
		out.println(productsShown);
		
		sql = "SELECT productName, productPrice, productId FROM product WHERE productName LIKE ?"; //WHERE productName LIKE '%?%'
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, "%" + name + "%");
		//out.println("<table> <tr> <th>  </th> <th> Products containing </th> <th>'" + name + "'</th> </tr>");
	
	}
	else if(name == null || name.strip().equals("")) {
		out.println("<h2> " + categoryName + "</h2>");
		out.println("<table class=table border=1>");
		out.println(productsShown);
		
		sql = "SELECT productName, productPrice, productId, categoryName FROM product JOIN category ON product.categoryId = category.categoryId WHERE productName LIKE ? AND categoryName = ?"; //WHERE productName LIKE '%?%'
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, "%" + name + "%");
		pstmt.setString(2, categoryName);
	}
	else{

		out.println("<h2> " + categoryName + " containing '" + name + "' </h2>");
		out.println("<table class=table border=1>");
		out.println(productsShown);
		
		sql = "SELECT productName, productPrice, productId, categoryName FROM product JOIN category ON product.categoryId = category.categoryId WHERE productName LIKE ? AND categoryName = ?"; //WHERE productName LIKE '%?%'
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, "%" + name + "%");
		pstmt.setString(2, categoryName);
	}
	//out.println("</")

	ResultSet rst = pstmt.executeQuery();
	while(rst.next()) {
		String productId = rst.getString(3);
		String productName = rst.getString(1);
		double productPrice = rst.getDouble(2);
		String productNamePlus = "";

		String[] arr = productName.split(" ");
		for(String s : arr) {
			productNamePlus += s + "+";
		}
		productNamePlus = productNamePlus.substring(0, productNamePlus.length() - 1);

		String forLink = "addcart.jsp?id=" + productId + "&name=" + productNamePlus + "&price=" + productPrice;
		String forLink2 = "product.jsp?id=" + productId;

		out.println("<tr>");
		out.println("<td class=col3><a href=" + forLink + "> Add to Cart </a></td>");
		out.println("<td class=col2><a class=colorA1 href=" + forLink2 + ">" + rst.getString(1) + "</td>");
		out.println("<td class=col3>" + currFormat.format(Double.parseDouble(rst.getString(2))) + "</td>");
		out.println("</tr>");
	}
	

	out.println("</table>");
	out.println("</font>");

}
catch (SQLException ex) {
	out.println("SQLException: " + ex);
}

%>

</body>
</html>