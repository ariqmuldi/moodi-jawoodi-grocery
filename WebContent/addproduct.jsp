<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
    <div style="margin:0 auto;text-align:center;display:inline">

    <h3>Add Product</h3>
        
        <br>
        <form name="MyForm" method=get action="addproduct.jsp">

        <table style="display:inline">
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Name:</font></div></td>
            <td><input type="text" name="productName"  size=10 ></td>
        </tr>

        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Price:</font></div></td>
            <td><input type="text" name="productPrice" size=10 ></td>
        </tr>

        <!-- 
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Image URL:</font></div></td>
            <td><input type="text" name="productImageURL" size=10 maxlength="10"></td>
        </tr>
        
        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Image:</font></div></td>
            <td><input type="text" name="productImage" size=10 maxlength="10"></td>
        </tr>
        -->

        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Description:</font></div></td>
            <td><input type="text" name="productDesc" size=10></td>
        </tr>

        <tr>
            <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Category Id:</font></div></td>
            <td><input type="text" name="categoryId" size=10></td>
        </tr>

        </table>
        <br/>

        <input class="submit" type="submit" name="Submit" value="Submit">

        </form>
        
        </div>
        
        <%

            String productName = request.getParameter("productName");
            String productPrice = request.getParameter("productPrice");
            String productImageURL = request.getParameter("productImageURL");
            String productImage = request.getParameter("productImage");
            String productDesc = request.getParameter("productDesc");
            String categoryId = request.getParameter("categoryId");

            try ( Connection con = DriverManager.getConnection(url, uid, pw);
	        Statement stmt = con.createStatement();) {

                if(productName != null) {
                    String sql = "INSERT product(productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";
                    PreparedStatement pstmt = con.prepareStatement(sql);
                    pstmt.setString(1, productName);

                    
                    pstmt.setString(2, productPrice);
                    //pstmt.setString(3,  null);
                    //pstmt.setString(4, null);
                    pstmt.setString(3, productDesc);
                    pstmt.setString(4, categoryId);
                    pstmt.executeUpdate();
                    out.println("<h3> Success! </h3>");
                }
                else {
                    return;
                }

                



            }
            catch (SQLException ex) {
                out.println("SQLException: " + ex);
            }

        %>

</body>
</html>