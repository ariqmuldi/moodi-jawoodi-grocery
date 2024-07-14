
<title>MoodiJawoodi Grocery</title>
	 <link rel="stylesheet" href="./style.css"/>
	</head>
	<body>
	
	<font face="Cursive" size="5">
	<div class="centerDivAndText"><h1 class="mainTitle"><a class ="mainTitle" href = index.jsp> MoodiJawoodi Grocery</a> </h1></div>
	</font>
	

	<font face="Monospace" size="4">
	<table class="table"><tr> <th class="col4"> <a class=colorHeader href = listprod.jsp> Product Page</a></th> <th class="col4"> <a class=colorHeader href=listorder.jsp>List Order </a> </th> <th class="col4"> <a class=colorHeader href=showcart.jsp>Shopping Cart</a></th>
    <th class = "col6">
        <% 
        String userName = (String) session.getAttribute("authenticatedUser");
        if (userName != null) out.println("<h3 align=\"center\">User: "+userName+"</h3>");
        else {
            out.println("<a class=colorHeader href=login.jsp> Login </a>");
        }
        %>
    </th>
    </tr></table>
	<hr>
	</font>
	
	


</body>


