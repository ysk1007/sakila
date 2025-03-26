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
	if(request.getParameter("actor") != null)		// 제목 검색
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
<style>
  html{
  	background-color:#030303;
  }
	
	body {
    margin: 1% auto;
    padding: 5px;
    width: 100%;
    text-align: center;
	}
	
   h1,h3{
   	color:white;
   }

   a {
    display: inline-block;
    padding: 4px 8px;
    margin: 0 5px;
    text-decoration: none;
    background-color:white;
    color: black;
    border: 1px solid black;
    border-radius: 4px;
	}

   form{
   	color:white;
   }

  table.clean-table {
    width: 100%;
    border-collapse: collapse;
    font-family: 'Pretendard', sans-serif;
    font-size: 14px;
    background-color: #1e1e1e; /* 테이블 배경 (딥 그레이) */
    color: #e0e0e0; /* 기본 글자색 (은은한 회색톤) */
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(255, 255, 255, 0.4); /* 다크톤에서 그림자는 깊게 */
  }

  /* 헤더 행 스타일 */
  .clean-table thead tr {
    background-color: #2c2c2c; /* 헤더 배경 (조금 더 밝은 그레이) */
    color: #ffd700; /* 헤더 텍스트 색 (고급스러운 골드톤) */
    text-transform: uppercase; /* 대문자 변환으로 느낌 강조 */
    letter-spacing: 0.5px;
  }

  .clean-table th {
    padding: 14px 18px;
    text-align: left;
    font-weight: 600;
    border-bottom: 1px solid #444; /* 헤더 하단 구분선 */
    background-color:#32386e;
    color:white;
  }

  .clean-table td {
    padding: 14px 18px;
    border-bottom: 1px solid #333; /* 셀 하단 구분선 */
  }

  /* 짝수 행 배경 */
  .clean-table tbody tr:nth-child(even) {
    background-color: #252525; /* 약간 밝은 회색 (딥한 계열 유지) */
  }

  /* 홀수 행 배경 */
  .clean-table tbody tr:nth-child(odd) {
    background-color: #1e1e1e; /* 테이블 기본 배경과 통일 */
  }

  /* 마우스 오버 효과 */
  .clean-table tbody tr:hover {
    background-color: #333333; /* 강조 효과 (은은한 대비) */
  }

  @media screen and (max-width: 768px) {
    .clean-table {
      font-size: 13px;
    }

    .clean-table th,
    .clean-table td {
      padding: 12px 14px;
    }
  }
</style>
<head>
<meta charset="UTF-8">
<title>배우 상세 정보</title>
</head>
<body>
	<h1><a href="/sakila/index.jsp">Sakila</a></h1>
	
	<br>

	<h1>배우 상세 정보</h1>
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
	
	<h1>출연작</h1>
	<!-- 출연작 출력 -->
	<table border="1" class="clean-table">
		<tr>
		<%
			for(var film : filmList){
				%>
					<th><a href="/sakila/d0326/filmOne.jsp?title=<%=film.get("title")%>"><%=film.get("title")%></a></th>
				<%
			}
		%>
		</tr>
		<tr>
		<%
			for(var film : filmList){
				%>
					<td>이미지</td>
				<%
			}
		%>
		</tr>
		<tr>
		<%
			for(var film : filmList){
				%>
					<td><%=film.get("releaseYear")%></td>
				<%
			}
		%>
		</tr>
	</table>
</body>
</html>