<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
	//로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");

	if(staffId == null){ // 로그아웃 상태라면
		response.sendRedirect("/sakila/loginForm.jsp");
		return;
	}

	String title = "";
	String sql = "";

	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;	
	
	// 변수 받기
	if(request.getParameter("title") != null)		// 제목 검색
		title = request.getParameter("title");
	
	//DB 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	// 영화의 출연진들 검색
	sql = "SELECT"
			+" CONCAT(ac.first_name,' ',ac.last_name) AS actorName,"
			+" ac.first_name AS firstName,"
			+" ac.last_name AS lastName"
			+" FROM film f"
		+" INNER JOIN film_actor fa ON f.film_id = fa.film_id"
		+" INNER JOIN actor ac ON fa.actor_id = ac.actor_id"
		+" WHERE f.title = ?";
	
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	
	stmt.setString(1,title);
	rs = stmt.executeQuery();
	
	// 출연진 리스트
	ArrayList<HashMap<String,Object>> actorList = new ArrayList<HashMap<String,Object>>();
	while(rs.next()){
		HashMap<String,Object> actor = new HashMap<String,Object>();
		actor.put("actorName", rs.getString("actorName"));
		actorList.add(actor);
	}
	
	// 영화의 상세 데이터
	sql = "SELECT "
			+" film_id AS filmId,"
			+" title,"
			+" DESCRIPTION,"
			+" release_year AS releaseYear,"
			+" rental_duration AS rentalDuration,"
			+" rental_rate AS rentalRate,"
			+" LENGTH,"
			+" rating,"
			+" special_features AS specialFeatures,"
			+" last_update AS lastUpdate"
		+" FROM film "
		+" WHERE title = ?";
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	
	stmt.setString(1,title);
	rs = stmt.executeQuery();
	rs.next();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 상세 정보</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
</head>
<body>
	<h1><a href="/sakila/index.jsp">Sakila &#127968;</a></h1>
	
	<br>

	<h1>영화 상세 정보 &#127916;</h1>
	<!-- 상세 정보 출력 -->
	<table border="1" class="clean-table">
		<tr>
			<th>영화 번호</th>
			<td><%=rs.getObject("filmId")%></td>
		</tr>
		<tr>
			<th>영화 제목</th>
			<td><%=rs.getObject("title")%></td>
		</tr>
		<tr>
			<th>설명</th>
			<td><%=rs.getObject("DESCRIPTION")%></td>
		</tr>
		<tr>
			<th>개봉 년도</th>
			<td><%=rs.getObject("releaseYear")%></td>
		</tr>
		<tr>
			<th>대여 기간</th>
			<td><%=rs.getObject("rentalDuration")%> 일</td>
		</tr>
		<tr>
			<th>대여 비용</th>
			<td><%=rs.getObject("rentalRate")%> $</td>
		</tr>
		<tr>
			<th>상영 시간</th>
			<td><%=rs.getObject("LENGTH")%> 분</td>
		</tr>
		<tr>
			<th>평점</th>
			<td><%=rs.getObject("rating")%></td>
		</tr>
		<tr>
			<th>특징</th>
			<td><%=rs.getObject("specialFeatures")%></td>
		</tr>
		<tr>
			<th>마지막 업데이트</th>
			<td><%=rs.getObject("lastUpdate")%></td>
		</tr>
	</table>
	
	<br>
	
	<h1>출연진 &#128587;</h1>
	<!-- 출연진 출력 -->
	<table border="1" class="clean-table">
		<tr>
			<th>출연진</th>
			<th>이미지</th>
		</tr>
		<%
			for(var actor : actorList){
				%>	
					<tr>
					<td><a href="/sakila/d0326/actorOne.jsp?actor=<%=actor.get("actorName")%>"><%=actor.get("actorName")%></a></td>
					<td>이미지</td>
					</tr>
				<%
			}
		%>
	</table>
</body>
</html>