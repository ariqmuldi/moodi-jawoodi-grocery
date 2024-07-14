<%@ page import="java.sql.*,java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
</head>
<body>

    <%@ include file="header.jsp" %>

    <%
	String username = (String) session.getAttribute("authenticatedUser");
	if (userName == null) out.println("<h3 align=\"center\"> Log in to edit account details </h3>");
    else { 
        out.println("<h3 align=\"center\">Signed in as: "+username+"</h3>");
        out.println("<h3 align=\"center\">Edit Account Details Below</h3>");
        
        out.println("<div class=divCenterForm>");
        out.println("<form method=get action=editaccount.jsp>");
        out.println("<table style=\"display:inline\">");

        out.println("<tr> <td><div align=right><font face=Arial, Helvetica, sans-serif size=2>First Name:</font></div></td> <td><input type=text required name=firstName  size=10></td> </tr>");
        out.println("<tr> <td><div align=right><font face=Arial, Helvetica, sans-serif size=2>Last Name:</font></div></td> <td><input type=text required name=lastName  size=10></td> </tr>");
        out.println("<tr> <td><div align=right><font face=Arial, Helvetica, sans-serif size=2>Email Address:</font></div></td> <td><input type=text required name=emailAddress  size=10></td> </tr>");
        out.println("<tr> <td><div align=right><font face=Arial, Helvetica, sans-serif size=2>Phone Number:</font></div></td> <td><input type=text required name=phoneNumber  size=10></td> </tr>");
        out.println("<tr> <td><div align=right><font face=Arial, Helvetica, sans-serif size=2>Address:</font></div></td> <td><input type=text required name=address  size=10></td> </tr>");
        out.println("<tr> <td><div align=right><font face=Arial, Helvetica, sans-serif size=2>City:</font></div></td> <td><input type=text required name=city size=10></td> </tr>");
        out.println("<tr> <td><div align=right><font face=Arial, Helvetica, sans-serif size=2>State:</font></div></td> <td><input type=text required name=state size=10></td> </tr>");
        out.println("<tr> <td><div align=right><font face=Arial, Helvetica, sans-serif size=2>Postal Code:</font></div></td> <td><input type=text required name=postalCode  size=10></td> </tr>");
        out.println("<tr> <td><div align=right><font face=Arial, Helvetica, sans-serif size=2>Country:</font></div></td> <td><input type=text required name=country size=10></td> </tr>");
        out.println("<tr> <td><div align=right><font face=Arial, Helvetica, sans-serif size=2>User Id:</font></div></td> <td><input type=text required name=userId  size=10></td> </tr>");
        out.println("<tr> <td><div align=right><font face=Arial, Helvetica, sans-serif size=2>Password:</font></div></td> <td><input type=password required name=password  size=10></td> </tr>");
        out.println("<tr> <td><input type=reset value=Reset></td> <td><input type=submit value=Submit></td></tr>");
        
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String emailAddress = request.getParameter("emailAddress");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
        String country = request.getParameter("country");
        String userId = request.getParameter("userId");
        String password = request.getParameter("password");
    
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
        String uid = "sa";
        String pw = "304#sa#pw";     

    try ( Connection con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();) {

        if( (firstName != null || lastName != null || emailAddress != null || phoneNumber != null || address != null || city != null || state != null || postalCode != null || country != null || userId != null || password != null) ) {
            String sql = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ?, userid = ?, password = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, emailAddress);
            pstmt.setString(4, phoneNumber);
            pstmt.setString(5, address);
            pstmt.setString(6, city);
            pstmt.setString(7, state);
            pstmt.setString(8, postalCode);
            pstmt.setString(9, country);
            pstmt.setString(10, userId);
            pstmt.setString(11, password);
            pstmt.executeUpdate();
            
            
           
        }
        
        if( (firstName != null || lastName != null || emailAddress != null || phoneNumber != null || address != null || city != null || state != null || postalCode != null || country != null || userId != null || password != null) &&
                (firstName.equals("") || lastName.equals("") || emailAddress.equals("") || phoneNumber.equals("") || address.equals("") || city.equals("") || state.equals("") || postalCode.equals("") || country.equals("") || userId.equals("") || password.equals("")) ) {
                out.println("An error has occured. Please try again.");
                return;
        }

    } catch (SQLException ex){
        out.println("SQLException: " + ex);
    }




    
        out.println("</table></form></div>");
        out.println("<div style=\"margin:0 auto;text-align:center;display:inline\">Success!</div>");

    }
    

    
    %>
    

</body>
</html>