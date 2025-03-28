<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
	//로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");

	if(staffId == null){ // 로그아웃 상태라면
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}

	int currentPage = 1;		// 현재 페이지
	int lastPage = 0;			// 마지막 페이지
	int rowDataCount = 11;		// 한 페이지에 보여줄 데이터 수
	int totalDataCount = 0;		// 전체 데이터 수
	int startRow = 0;
	int pageDiv = 10;			
	
	String jsp = "/sakila/d0326/actorList.jsp";
	String sql = "";
	String searchWord = "";
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;	
	
	// 변수 받기
	if(request.getParameter("currentPage") != null)	// 현재 페이지
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	
	if(request.getParameter("actor") != null)		// 제목 검색
		searchWord = request.getParameter("actor");
	
	//DB 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	// 배우 리스트 전체 데이터 수 구하는 쿼리
	sql = "SELECT"
			+" COUNT(*) AS count"
			+" FROM actor"
			+" WHERE CONCAT(first_name,' ',last_name) LIKE ?";
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
	
	// 컬럼명 리스트
	String[] colList = {"actorId","name","lastUpdate"};
	
	// 배우 데이터 리스트
	sql = "SELECT"
			+" actor_id AS actorId,"
			+" CONCAT(first_name,' ',last_name) AS name,"
			+" last_update AS lastUpdate"
		+" FROM actor"
		+" WHERE CONCAT(first_name,' ',last_name) LIKE ?"
		+" ORDER BY actor_id ASC"
		+" LIMIT ?,?";
	
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	stmt.setString(1,"%"+searchWord+"%");
	stmt.setInt(2,startRow);
	stmt.setInt(3,rowDataCount);
	rs = stmt.executeQuery();
	
	// 배우 리스트
	ArrayList<HashMap<String,Object>> actorList = new ArrayList<HashMap<String,Object>>();
	while(rs.next()){
		HashMap<String,Object> actor = new HashMap<String,Object>();
		for(var col : colList){
			actor.put(col,rs.getObject(col));
		}
		actorList.add(actor);
	}
	
	rs.close();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배우 리스트 &#128526;</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
</head>
<body>
	<h1><a href="/sakila/index.jsp">Sakila &#127968;</a></h1>
	
	<br>
	
	<h1>배우 리스트 &#128526;</h1>
		<!-- 리스트 출력 -->
		<table border="1" class="clean-table">
		<tr>
			<th>배우 번호</th>
			<th>배우 이름</th>
			<th>마지막 업데이트</th>
		</tr>
		<%
			for(var actor : actorList){
				%>
				<tr>
					<td><%=actor.get("actorId")%></td>
					<td><a href="/sakila/d0326/actorOne.jsp?actor=<%=actor.get("name")%>"><%=actor.get("name")%></a></td>
					<td><%=actor.get("lastUpdate")%></td>
				</tr>
				<%
			}
		%>
		</table>
			
		<!-- 네비게이션 -->
		
		<h3><%=currentPage%> / <%=lastPage%> 페이지</h3>
		
		<div>
			<!-- [처음] -->
			<a href="<%=jsp%>?currentPage=1&actor=<%=searchWord%>">처음</a>
			
			<!-- [이전 10] -->
			<a href="<%=jsp%>?currentPage=<%=currentPage - 10%>&actor=<%=searchWord%>">이전 10</a>
			
			<%
				// [1][2][3][4]...[9][10]
				for(int i = 1 ; i <= pageDiv ; i++){
					// 페이지 번호
					int p = (((currentPage - 1) / 10) * 10) + i;
					if(p > lastPage) continue; // 마지막 페이지 크기보다 크면 생략
						%><a href="<%=jsp%>?currentPage=<%=p%>&actor=<%=searchWord%>" class="<%=currentPage == i ? "selected" : "" %>"><%=p%></a><%
				}
			%>
			
			<!-- [다음 10] -->
			<a href="<%=jsp%>?currentPage=<%=currentPage + 10%>&actor=<%=searchWord%>">다음 10</a>
			
			<!-- [마지막] -->
			<a href="<%=jsp%>?currentPage=<%=lastPage%>&actor=<%=searchWord%>">마지막</a>
		</div>
		<br>
		<!-- 검색 -->
		<form action="/sakila/d0326/actorList.jsp">
			배우 이름 : <input type="text" name="actor" value="<%=searchWord%>">
			<button type="submit">검색</button>
		</form>
</body>
</html>