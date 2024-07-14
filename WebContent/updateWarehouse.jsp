
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
    <div style="margin:0 auto;text-align:center;display:inline">
        <h3>Update Product</h3>
    
        <br>
            <form name="MyForm" method=get action="updateWarehouse.jsp">
    
            <table style="display:inline">
    
                <tr>
                    <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Warehouse Id:</font></div></td>
                    <td><input type="text" name="warehouseId"  size=10 ></td>
                </tr>
            <tr>
                <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Warehouse Name:</font></div></td>
                <td><input type="text" name="warehouseName"  size=10 ></td>
            </tr>

            
            </table>
    
            <br/>
    
            <input class="submit" type="submit" name="Submit" value="Submit">
    
            </form>

            <% 

            String warehouseId = request.getParameter("warehouseId");
            String warehouseName = request.getParameter("warehouseName");
            
            try ( Connection con = DriverManager.getConnection(url, uid, pw);
	        Statement stmt = con.createStatement();) {

                if(warehouseName != null) {
                    String sql = "UPDATE warehouse SET warehouseName = ? WHERE warehouseId = ?";
                    PreparedStatement pstmt = con.prepareStatement(sql);
                    pstmt.setString(2, warehouseId);
                    pstmt.setString(1, warehouseName);
                
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
    
           
            
        </div>


</body>
</html>