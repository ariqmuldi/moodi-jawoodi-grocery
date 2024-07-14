<!DOCTYPE html>
<html lang="en">
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp" %>
<body>
    <% 
    try{
        getConnection();
        String sql1 = "SELECT * FROM warehouse";
        PreparedStatement pstmt = con.prepareStatement(sql1);
        ResultSet rst1 = pstmt.executeQuery();
        while (rst1.next()){
            out.println("<div class=centerDivAndText><h1>" + rst1.getString(2) + "</h1></div>");

            int warehouseId = rst1.getInt(1);
            String sql2 = "SELECT product.productId, productName, quantity FROM warehouse JOIN productinventory ON warehouse.warehouseId = productinventory.warehouseId JOIN product on productinventory.productId = product.productId WHERE warehouse.warehouseId = ?";
            PreparedStatement pstmt2 = con.prepareStatement(sql2);
            pstmt2.setInt(1, warehouseId);
            ResultSet rst2 = pstmt2.executeQuery();

            out.println("<table class=table");
            out.println("<tr><td class=col0> <h3> Product Id </h3></td> <td class=col0> <h3> Product Name </h3> </td> <td class=col0> <h3>Quantity</h3> </td></tr>");
            
            while (rst2.next()){
                out.println("<tr>");  

                out.println("<td class=col3>" + rst2.getString(1) + "</td>");
                out.println("<td class=col1>" + rst2.getString(2) + "</td>");
                out.println("<td class=col2>" + rst2.getString(3) + "</td>");

                out.println("</tr>");

            }
            
            out.println("</table>");

        }
    }catch (SQLException ex){
        out.println("SQLException: " + ex);

    }finally{
        closeConnection();
    }
     %>



</body>
</html>