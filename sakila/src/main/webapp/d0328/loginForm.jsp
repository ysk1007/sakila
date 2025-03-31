<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	// 로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");

	if(staffId != null){ // 로그인 상태라면
		response.sendRedirect("/sakila/index.jsp");
		return;
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 로그인</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
</head>
<body>
	<h1>직원 로그인</h1>
	
	<form action ="/sakila/d0328/loginAction.jsp" method="post"> <!-- loginAction.jsp? -->
	<table class="clean-table" border="1">
		<tr>
			<th>스태프 ID</th>
			<td><input type="text" name="staffId"></td>
		</tr>
		<tr>
			<th>비밀번호</th>
			<td><input type="password" name="password"></td>
		</tr>
		<tr>
			<td colspan="2"><button type="submit">로그인</button></td>
		</tr>
	</table>
	</form>

</body>
</html>