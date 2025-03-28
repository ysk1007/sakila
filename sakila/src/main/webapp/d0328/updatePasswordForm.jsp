<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	// 로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");

	if(staffId == null){ // 로그아웃 상태라면
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
</head>
<body>
	<h1>비밀번호 변경</h1>
	<form action="/sakila/d0328/updatePasswordAction.jsp">
		<table class="clean-table">
		<tr>
			<th>현재 비밀번호</th>
			<td><input type="password" name="prePassword"></td>
		</tr>
		<tr>
			<th>새로운 비밀번호</th>
			<td><input type="password" name="newPassword"></td>
		</tr>
		<tr>
			<td colspan="2"><button type="submit">수정</button></td>
		</tr>
	</table>
	</form>
	<br>
	<a href="/sakila/index.jsp">이전</a>
</body>
</html>