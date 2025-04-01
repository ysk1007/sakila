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
<title>Skila &#127968;</title>
	<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
</head>
<body>
	<div>
		<h3><%=staffId%>님 반갑습니다.</h3>
		<a href="/sakila/d0328/logout.jsp">로그아웃</a>
		<a href="/sakila/d0328/updatePasswordForm.jsp">비밀번호 수정</a>
	</div>
	<hr>
	<h1>Skila &#127968;</h1>
	<ol>
		<li><a href="/sakila/d0325/rentalList.jsp">대여 목록 &#128252;</a></li>
		<li><a href="/sakila/d0326/filmList.jsp">영화 목록 &#127916;</a></li>
		<li><a href="/sakila/d0326/actorList.jsp">배우 목록 &#128526;</a></li>
		<li><a href="/sakila/d0327/inventoryList.jsp">인벤토리 목록 &#129530;</a></li>
	</ol>
	<br>
	<h1>뷰</h1>
	<ol>
		<li><a href="/sakila/d0401/actorInfo.jsp">배우 정보 뷰</a></li>
		<li><a href="/sakila/d0401/customerList.jsp">고객 리스트 뷰</a></li>
		<li><a href="/sakila/d0401/filmList.jsp">영화 리스트 뷰</a></li>
		<li><a href="/sakila/d0401/nicerButSlowerFilmList.jsp">nicerButSlowerFilmList 뷰</a></li>
		<li><a href="/sakila/d0401/salesByFilmCategory.jsp">카테고리 별 수익 뷰</a></li>
		<li><a href="/sakila/d0401/salesByStore.jsp">지점 별 수익 뷰</a></li>
		<li><a href="/sakila/d0401/staffList.jsp">직원 별 수익 뷰</a></li>
	</ol>
</body>
</html>