<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
	String actor = "";
	String sql = "";

	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;	
	
	// 변수 받기
	if(request.getParameter("actor") != null)		// 배우 검색
		actor = request.getParameter("actor");
	
	// 주소창에 공백을 못 받아서 이렇게 치환해야 할 듯
	actor.replaceAll("%20", "");
	
	//DB 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
		
	// 배우의 출연작 조회
	sql = "SELECT"
			+" f.title title,"
			+" f.release_year AS releaseYear"
		+" FROM actor ac"
		+" INNER JOIN film_actor fa ON ac.actor_id = fa.actor_id"
		+" INNER JOIN film f ON fa.film_id = f.film_id"
		+" WHERE CONCAT(first_name,' ',last_name) = ?";
	
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	stmt.setString(1,actor);
	rs = stmt.executeQuery();
	
	// 커서 초기화
	rs.beforeFirst();
	
	// 출연작 리스트
	ArrayList<HashMap<String,Object>> filmList = new ArrayList<HashMap<String,Object>>();
	while(rs.next()){
		HashMap<String,Object> film = new HashMap<String,Object>();
		film.put("title", rs.getString("title"));
		film.put("releaseYear", rs.getString("releaseYear"));
		filmList.add(film);
	}
	
	// 배우 상세 정보 조회
	sql = "SELECT "
			+" actor_id AS actorId,"
			+" CONCAT(first_name,' ',last_name) AS name,"
			+" last_update AS lastUpdate"
		+" FROM actor"
		+" WHERE CONCAT(first_name,' ',last_name) = ?";
	
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	
	stmt.setString(1,actor);
	rs = stmt.executeQuery();
	rs.next();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배우 상세 정보</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css">
</head>
<body>
	<h1><a href="/sakila/index.jsp">Sakila &#127968;</a></h1>
	
	<br>

	<h1>배우 상세 정보 &#128587;</h1>
	<!-- 상세 정보 출력 -->
	<table border="1" class="clean-table">
		<tr>
			<th>배우 번호</th>
			<td><%=rs.getObject("actorId")%></td>
		</tr>
		<tr>
			<th>배우 이름</th>
			<td><%=rs.getObject("name")%></td>
		</tr>
		<tr>
			<th>마지막 정보 업데이트</th>
			<td><%=rs.getObject("lastUpdate")%></td>
		</tr>
	</table>
	
	<br>
	
	<h1>출연작 &#127909;</h1>
	<!-- 출연작 출력 -->
	<table border="1" class="clean-table">
		<tr>
			<th>출연작</th>
			<th>이미지</th>
			<th>개봉년도</th>
		</tr>
		<%
			for(var film : filmList){
			%>
				<tr>
					<td><a href="/sakila/d0326/filmOne.jsp?title=<%=film.get("title")%>"><%=film.get("title")%></a></td>
					<td>이미지</td>
					<td><%=film.get("releaseYear")%></td>
				</tr>
			<%
			}
		%>
	</table>
</body>
</html>