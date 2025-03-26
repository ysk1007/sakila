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
<style>
  html{
  	background-color:#030303;
  }
	
	body {
    margin: 1% auto;
    padding: 5px;
    width: 60%;
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
<title>영화 리스트</title>
</head>
<body>
	<h1><a href="/sakila/index.jsp">Sakila</a></h1>
	
	<br>

	<h1>영화 리스트</h1>
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
				<td><%=film.get("rentalDuration")%></td>
				<td><%=film.get("rentalRate")%></td>
				<td><%=film.get("length")%></td>
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