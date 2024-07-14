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

        <h3>Add Warehouse</h3>
            
            <br>
            <form name="MyForm" method=get action="addToWarehouse.jsp">
    
            <table style="display:inline">
            <tr>
                <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Warehouse Name:</font></div></td>
                <td><input type="text" name="warehouseName"  size=10 ></td>
            </tr>
    

    
            </table>
            <br/>
    
            <input class="submit" type="submit" name="Submit" value="Submit">
    
            </form>
            
            </div>
            
            <%
    
                String warehouseName = request.getParameter("warehouseName");
               
    
                try ( Connection con = DriverManager.getConnection(url, uid, pw);
                Statement stmt = con.createStatement();) {
    
                    if(warehouseName != null) {
                        String sql = "INSERT warehouse VALUES (?)";
                        PreparedStatement pstmt = con.prepareStatement(sql);
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



</body>
</html>