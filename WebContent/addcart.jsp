<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

try{
	getConnection();
	String sqlGetCart = "SELECT incart.productId, productName, price, quantity FROM incart JOIN product ON incart.productId = product.productId";
	PreparedStatement pstmt = con.prepareStatement(sqlGetCart);
	ResultSet rst = pstmt.executeQuery();
	if (productList == null)
	{	// No products currently in list.  Create a list.
		productList = new HashMap<String, ArrayList<Object>>();
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
	}
	


	// Add new product selected
	// Get product information
	String id = request.getParameter("id");
	String name = request.getParameter("name");
	String price = request.getParameter("price");
	Integer quantity = new Integer(1);

	// Store product information in an ArrayList
	ArrayList<Object> product = new ArrayList<Object>();
	product.add(id);
	product.add(name);
	product.add(Double.parseDouble(price));
	product.add(quantity);

	// Update quantity if add same item to order again
	if (productList.containsKey(id))
	{	product = (ArrayList<Object>) productList.get(id);
		int curAmount = ((Integer) product.get(3)).intValue();
		product.set(3, new Integer(curAmount+1));
		String sqlUpdate = "UPDATE incart SET quantity = quantity + 1 WHERE productId = ?";
		pstmt = con.prepareStatement(sqlUpdate);
		pstmt.setString(1, id);
		pstmt.executeUpdate();
	}
	else{
		productList.put(id,product);
		String sqlUpdate = "INSERT INTO incart VALUES(?, ?, ?)";
		pstmt = con.prepareStatement(sqlUpdate);
		pstmt.setString(1, id);
		pstmt.setInt(2, quantity);
		pstmt.setDouble(3, Double.parseDouble(price));
		pstmt.executeUpdate();
	}
} catch (Exception ex){

} finally {
	closeConnection();
}

session.setAttribute("productList", productList);
%>
<jsp:forward page="showcart.jsp" />