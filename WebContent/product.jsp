<%@ page import="java.util.HashMap,java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>MoodiJawoodi Grocery - Product Information</title>

<link href="./style.css" rel="stylesheet"/>

</head>
<body>

    
<%@ include file="header.jsp" %>
<%
// Get product name to search for
// TODO: Retrieve and display info for the product
String productId = request.getParameter("id");
if (productId == null ) productId = (String) session.getAttribute("productId");

try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

// Make the connection
try ( Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();) {

        String username = (String) session.getAttribute("authenticatedUser");
        String reviewRating = request.getParameter("reviewRating");
            //out.println(reviewRating);
        String reviewComment = request.getParameter("reviewComment");
	   
        if (reviewRating != null && reviewComment != null)
        {
            if (username == null) out.println("<h2 align=\"center\"> Error! Please log in to write a review </h2>");

            else{
            

                if(Integer.parseInt(reviewRating) >= 6 || Integer.parseInt(reviewRating) < 0) { out.println("Enter a valid review rating"); return; }

         
                String getCustId = "SELECT customerId FROM customer WHERE userid = ?";
                PreparedStatement pstmt = con.prepareStatement(getCustId);
                pstmt.setString(1, username);
                ResultSet rst = pstmt.executeQuery();
                rst.next();
                String custId = rst.getString(1);
                DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");  
   	            LocalDateTime now = LocalDateTime.now();  
	            String currDate = dtf.format(now);

                String sql = "INSERT INTO review VALUES (?, ?, ?, ?, ?)";
                pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                pstmt.setString(1, reviewRating);
                pstmt.setString(2, currDate);
                pstmt.setString(3, custId);
                pstmt.setString(4, productId);
                pstmt.setString(5, reviewComment);
                pstmt.executeUpdate();
            }    
            
        }
    
    session.setAttribute("productId", productId);
    String sql3 = "SELECT productName, productPrice, productImageURL FROM product WHERE productId = ?";
    PreparedStatement pstmt3 = con.prepareStatement(sql3);
    pstmt3.setString(1, productId);
    ResultSet rst3 = pstmt3.executeQuery();
    rst3.next();
    out.println("<h2>" + rst3.getString(1) + "</h2>");
    String productName = rst3.getString(1);
    double productPrice = rst3.getDouble(2);

    // TODO: If there is a productImageURL, display using IMG tag
    if(!(rst3.getString(3) == "null"))
        out.println("<img height=300 width=300 src=\"" + rst3.getString(3) + "\">");

    // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
    out.println("<img src=\"displayImage.jsp?id=" + productId + "\"alt=>");
    out.println("<table><tbody>");
    out.println("<tr><th>Id</th><td>" + productId + "</td>");
    out.println("<tr><th>Price</th><td>" + currFormat.format(productPrice) + "</td>");
    out.println("</tbody></table>");


    
    out.println("<h3>Review Rating (0 to 5)</h3>");
    out.println("<form method=get action=product.jsp?id="+productId+">");
    out.println("<input type=text name=reviewRating size=10>");

    out.println("<h3>Review Comment</h3>");
    out.println("<input type=text name=reviewComment size=50>");
    out.println("<input type=submit value=Submit size=20>");

    out.println("</form>");

    
    
            
    // TODO: Add links to Add to Cart and Continue Shoppingng
    String productNamePlus = "";

    String[] arr = productName.split(" ");
    for(String s : arr) {
        productNamePlus += s + "+";
    }
    productNamePlus = productNamePlus.substring(0, productNamePlus.length() - 1);

    String forLink = "addcart.jsp?id=" + productId + "&name=" + productNamePlus + "&price=" + productPrice;
    out.println("<h3><a href=" + forLink + "> Add to Cart </a></h3>");

    out.println("<h3> Reviews From Customers </h3>");
    out.println("<table class=table border=1>");
    out.println("<tr> <td class=col0> Review Rating </td> <td class=col0> Review Date </td> <td class=col0> Review Comment </td> </tr>");
    String sql2 = "SELECT * FROM review WHERE productId =" + productId;
    ResultSet rst2 = stmt.executeQuery(sql2);
    
    
    while(rst2.next()) {
        out.println("<tr>");
        //out.println("<td class=col6>" + rst2.getString(1) + "</td>");
        out.println("<td class=col1>" + rst2.getString(2) + "</td>");
        out.println("<td class=col2>" + rst2.getString(3) + "</td>");
        //out.println("<td class=col3>" + rst2.getString(4) + "</td>");
        //out.println("<td class=col4>" + rst2.getString(5) + "</td>");
        out.println("<td class=col5>" + rst2.getString(6) + "</td>");
        //out.println(rst2.getString(1) + " " + rst2.getString(2) + " " + rst2.getString(3) + " " + rst2.getString(4)  + " " + rst2.getString(5) + rst2.getString(6));
        out.println("</tr>");
    }
    
    out.println("</table>");

    /*
    String sql2 = "SELECT * FROM review WHERE productId =" + productId;
    ResultSet rst2 = stmt.executeQuery(sql2);
    while(rst2.next()) {
        out.println(rst2.getString(1) + " " + rst2.getString(2) + " " + rst2.getString(3) + " " + rst2.getString(4)  + " " + rst2.getString(5) + rst2.getString(6));
    }
    */


    

    
} catch (SQLException ex){
    out.println("SQLException: " + ex);
}
%>
<h3><a href="listprod.jsp">Continue Shopping</a></h3>
</body>
</html>

