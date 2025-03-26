<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
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
	
	
	ArrayList<HashMap<String,Object>> actorList = new ArrayList<HashMap<String,Object>>();
	while(rs.next()){
		HashMap<String,Object> actor = new HashMap<String,Object>();
		actor.put("actorName", rs.getString("actorName"));
		actorList.add(actor);
	}
	
	
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
<style>
  html{
  	background-color:#030303;
  }
	
	body {
    margin: 1% auto;
    padding: 5px;
    width: 80%;
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
<title>영화 상세 정보</title>
</head>
<body>
	<h1><a href="/sakila/index.jsp">Sakila</a></h1>
	
	<br>

	<h1>영화 상세 정보</h1>
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
			<td><%=rs.getObject("rentalDuration")%></td>
		</tr>
		<tr>
			<th>대여 비용</th>
			<td><%=rs.getObject("rentalRate")%></td>
		</tr>
		<tr>
			<th>상영 시간</th>
			<td><%=rs.getObject("LENGTH")%></td>
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
	
	<h1>출연진</h1>
	<!-- 출연진 출력 -->
	<table border="1" class="clean-table">
		<tr>
		<%
			for(var actor : actorList){
				%>
					<th><a href="/sakila/d0326/actorOne.jsp?actor=<%=actor.get("actorName")%>"><%=actor.get("actorName")%></a></th>
				<%
			}
		%>
		</tr>
		<tr>
		<%
			for(var actor : actorList){
				%>
					<td>이미지</td>
				<%
			}
		%>
		</tr>
	</table>
</body>
</html>