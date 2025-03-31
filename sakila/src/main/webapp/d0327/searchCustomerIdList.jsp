<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	//로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");

	if(staffId == null){ // 로그아웃 상태라면
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}

	// 변수
	Integer inventoryId = null;
	
	if(request.getParameter("inventoryId") != null){
		inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	}
	
	String searchName = request.getParameter("searchName");
	
	// FROM customer c WHERE first_name LIKE ? OR last_name like ?
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	// SQL 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	// 쿼리
	String sql = "SELECT customer_id AS customerId,"
					+" first_name AS firstName, "
					+" last_name AS lastName, "
					+" email,"
					+" active"
				+" FROM customer"
				+" WHERE CONCAT(first_name, last_name) LIKE ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, "%" + searchName + "%");
	System.out.println(stmt);
	rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객 이름 검색</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
</head>
<body>
	<h1>고객 이름 검색</h1>
	<table border="1" class="clean-table">
	<tr>
		<th>고객 아이디</th>
		<th>고객 이름</th>
		<th>이메일</th>
		<th>휴면 여부</th>
		<th>선택</th>
	</tr>
	<%
		while(rs.next()){
			%>
				<tr>
					<td><%=rs.getObject("customerId")%></td>
					<td><%=rs.getObject("firstName") + " " + rs.getObject("lastName")%></td>
					<td><%=rs.getObject("email")%></td>
					<td><%=rs.getObject("active")%></td>
					<td>
						<%
							if(rs.getInt("active") == 0){
								%><a href="/sakila/d0327/updateCustomerActive.jsp?customerId=<%=rs.getObject("customerId")%>&active=<%=rs.getObject("active")%>">휴면상태해지</a><%
							}
							else{
								%><a href="/sakila/d0327/insertRentalForm.jsp?customerId=<%=rs.getObject("customerId")%>&inventoryId=<%=inventoryId%>">선택</a><%
							}
						%>
					</td>
				</tr>
			<%
		}
	%>
	</table>
</body>
</html>