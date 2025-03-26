<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
	int currentPage = 1;		// 현재 페이지
	int lastPage = 0;			// 마지막 페이지
	int rowDataCount = 11;		// 한 페이지에 보여줄 데이터 수
	int totalDataCount = 0;		// 전체 데이터 수
	int startRow = 0;
	int pageDiv = 10;			
	
	String jsp = "/sakila/d0326/filmList.jsp";
	String sql = "";
	String searchWord = "";
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;	

	// 변수 받기
	if(request.getParameter("currentPage") != null)	// 현재 페이지
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	
	if(request.getParameter("title") != null)		// 제목 검색
		searchWord = request.getParameter("title");
	
	//DB 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	// 영화 데이터 개수 구하는 쿼리
	sql = "SELECT"
			+" COUNT(*) AS count"
			+" FROM film"
			+" WHERE title LIKE ?";
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	stmt.setString(1,"%"+searchWord+"%");
	rs = stmt.executeQuery();
	rs.next();
	
	// 페이징
	totalDataCount = rs.getInt("count");
	lastPage = totalDataCount /  rowDataCount;
	
	// 페이지 음수나 오버 되는거 막기
	currentPage = currentPage > lastPage ? lastPage + 1 : currentPage;
	currentPage = currentPage < 1 ? 1 : currentPage;
	
	if(totalDataCount % rowDataCount != 0)
		lastPage++;
	startRow = (currentPage - 1) * rowDataCount;
	
	// rs 초기화
	rs.beforeFirst();
	
	// 컬럼 리스트
	String[] colList = {"filmId","title","releaseYear","rentalDuration","rentalRate","length"};
	
	// 영화 리스트 쿼리
	sql = "SELECT"
			+" film_id AS filmId,"
			+" title,"
			+" release_year AS releaseYear,"
			+" rental_duration AS rentalDuration,"
			+" rental_rate AS rentalRate,"
			+" length"
		+" FROM film"
		+" WHERE title LIKE ?"
		+" ORDER BY film_id ASC"
		+" LIMIT ?,?;";
	
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	stmt.setString(1,"%"+searchWord+"%");
	stmt.setInt(2,startRow);
	stmt.setInt(3,rowDataCount);
	rs = stmt.executeQuery();

	// 영화 리스트
	ArrayList<HashMap<String,Object>> filmList = new ArrayList<HashMap<String,Object>>();
	while(rs.next()){
		HashMap<String,Object> film = new HashMap<String,Object>();
		for(var col : colList){
			film.put(col,rs.getObject(col));
		}
		filmList.add(film);
	}
	
	rs.close();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 리스트</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css">
</head>
<body>
	<h1><a href="/sakila/index.jsp">Sakila &#127968;</a></h1>
	
	<br>

	<h1>영화 리스트 &#127916;</h1>
	<!-- 리스트 출력 -->
	<table border="1" class="clean-table">
	<tr>
		<th>영화 번호</th>
		<th>영화 제목</th>
		<th>개봉 연도</th>
		<th>대여 기간</th>
		<th>대여 비용</th>
		<th>상영 시간</th>
	</tr>
	<%
		for(var film : filmList){
			%>
			<tr>
				<td><%=film.get("filmId")%></td>
				<td><a href="/sakila/d0326/filmOne.jsp?title=<%=film.get("title")%>"><%=film.get("title")%></a></td>
				<td><%=film.get("releaseYear")%></td>
				<td><%=film.get("rentalDuration")%>일</td>
				<td><%=film.get("rentalRate")%> $</td>
				<td><%=film.get("length")%> 분</td>
			</tr>
			<%
		}
	%>
	</table>
		
	<!-- 네비게이션 -->
	
	<h3><%=currentPage%> / <%=lastPage%> 페이지</h3>
	
	<div>
		<!-- [처음] -->
		<a href="<%=jsp%>?currentPage=1&title=<%=searchWord%>">처음</a>
		
		<!-- [이전 10] -->
		<a href="<%=jsp%>?currentPage=<%=currentPage - 10%>&title=<%=searchWord%>">이전 10</a>
		
		<%
			// [1][2][3][4]...[9][10]
			for(int i = 1 ; i <= pageDiv ; i++){
				// 페이지 번호
				int p = (((currentPage - 1) / 10) * 10) + i;
				if(p > lastPage) continue; // 마지막 페이지 크기보다 크면 생략
					%><a href="<%=jsp%>?currentPage=<%=p%>&title=<%=searchWord%>"><%=p%></a><%
			}
		%>
		
		<!-- [다음 10] -->
		<a href="<%=jsp%>?currentPage=<%=currentPage + 10%>&title=<%=searchWord%>">다음 10</a>
		
		<!-- [마지막] -->
		<a href="<%=jsp%>?currentPage=<%=lastPage%>&title=<%=searchWord%>">마지막</a>
	</div>
	<br>
	<!-- 검색 -->
	<form action="/sakila/d0326/filmList.jsp">
		영화 제목 : <input type="text" name="title" value="<%=searchWord%>">
		<button type="submit">검색</button>
	</form>
</body>
</html>