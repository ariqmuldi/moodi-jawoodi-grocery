
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

    <%@ include file="header.jsp" %>
    <%@ include file="jdbc.jsp" %>

    <% 
        String username = (String) session.getAttribute("authenticatedUser");

	    if (username == null) out.println("<h3 align=\"center\"> Please log in to write a review </h3>");
        else {
            
            String reviewRating = request.getParameter("reviewRating +productId");
            //out.println(reviewRating);
            String reviewComment = request.getParameter("reviewComment");

            if(Integer.parseInt(reviewRating) >= 6 || Integer.parseInt(reviewRating) < 0) { out.println("Enter a valid review rating"); return; }

            try {
                getConnection();
            
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
                pstmt.setString(4, request.getParameter("productId"));
                pstmt.setString(5, reviewComment);
                pstmt.executeUpdate();

            }
            catch(SQLException ex) {
                out.println("SQLException " + ex);
            }
            finally {
                closeConnection();
            }

        }
    
    
    %>

    
</body>
</html>