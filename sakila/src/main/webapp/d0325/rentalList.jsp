<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>대여 리스트</h1>
	<form action="/sakila/d0325/rentalList.jsp">
		지점 :
		<select name="storeId">
			<option value="0">전체</option>
			<option value="1">1지점</option>
			<option value="2">2지점</option>
		</select>
		<button type="submit">검색</button>
	</form>
	
	<!-- 리스트 출력 -->
	<table border="1">
		<tr>
			<th>대여 번호</th>
			<th>영화 제목</th>
			<th>비디오 위치</th>
			<th>이름(고객 아이디)</th><!-- name = first_name + last_name -->
			<th>대여일</th>
			<th>반납일</th>
		</tr>
	</table>
	
	<form action="/sakila/d0325/rentalList.jsp">
		영화 제목 : <input type="text" name="title">
		<button type="submit">검색</button>
	</form>
</body>
</html>