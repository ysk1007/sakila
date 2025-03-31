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
	Integer inventoryId = null;		// 인벤토리 아이디
	Integer customerId = null;		// 고객 아이디
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	// 변수 받기
	if(request.getParameter("customerId") != null){
		customerId = Integer.parseInt(request.getParameter("customerId"));
	}
	
	if(request.getParameter("inventoryId") != null){
		inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	}
	
	// SQL 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	// 인벤토리 데이터 추가 쿼리
	String sql = "SELECT i.inventory_id AS inventoryId,"
					+" i.film_id AS filmId, "
					+" i.store_id AS storeId, "
					+" f.title AS title"
				+" FROM inventory i"
				+" INNER JOIN film f ON i.film_id = f.film_id"
				+" WHERE inventory_id=?";
	stmt = conn.prepareStatement(sql);
	
	// ? 값 할당
	stmt.setInt(1, inventoryId);
	
	// 디버깅
	// System.out.println(stmt);
	
	// 쿼리 실행
	rs = stmt.executeQuery();
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>대여 페이지</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
</head>
<body>
	<h1>대여 페이지</h1>
	<%
		if(rs.next()){
			%>
				<!-- 고객 검색 폼 -->
				<form action="searchCustomerIdList.jsp" method="post">
					<input type="hidden" name="inventoryId" value="<%=inventoryId%>">
					<input type="text" name="searchName">
					<button type="submit">이름으로 고객 아이디 검색</button>
				</form>

				<!-- 대여 실행 폼 -->
				<form action="insertRentalAction.jsp" method="post">
				<table border="1" class="clean-table">
					<tr>
						<th>고객 아이디</th>
						<td><!-- 고객 아이디를 인풋에 출력 -->
							<input type="text" name="customerId" value="<%=customerId != null ? customerId : ""%>">
						</td>
					</tr>
					<tr>
						<th>인벤토리 아이디</th>
						<td><input type="text" name="inventoryId" value="<%=rs.getObject("inventoryId")%>" readonly></td>
					</tr>
					<tr>
						<th>영화 아이디</th>
						<td><input type="text" name="filmId" value="<%=rs.getObject("filmId")%>" readonly></td>
					</tr>
					<tr>
						<th>영화 제목</th>
						<td><input type="text" name="title" value="<%=rs.getObject("title")%>" readonly></td>
					</tr>
					<tr>
						<th>지점 아이디</th>
						<td><input type="text" name="storeId" value="<%=rs.getObject("storeId")%>" readonly></td>
					</tr>
					<tr>
						<th>직원 아이디</th>
						<td><input type="text" name="staffId" value="<%=staffId%>" readonly></td>
					</tr>
				</table>
				<button type="submit">대여하기</button>
				</form>
			<%
		}
	%>
</body>
</html>