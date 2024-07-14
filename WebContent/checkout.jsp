<html>
<head>
<title>MoodiJawoodi Grocery</title>
</head>
<body>

<h1>Enter your customer id and password to complete the transaction:</h1>

<form method="get" action="order.jsp">
<table>
<tr><td>Customer ID:</td><td><input type="text" required name="customerId" size="20"></td></tr>
<tr><td>Password:</td><td ><input type="password" required name="password" size="20"></td></tr>
<tr><td>Payment Type:</td><td><input type="text" required name="paymentType" size="20"></td></tr>
<tr><td>Payment Number:</td><td><input type="text" required name="paymentNumber" size="20"></td></tr>
<tr><td>Payment Expiry Date (yyyy-MM-dd):</td><td><input type="text" required name="paymentExpiryDate" size="20"></td></tr>
<tr><td><input type="submit" value="Submit"></td><td><input type="reset" value="Reset"></td></tr>
</table>
</form>

</body>
</html>

