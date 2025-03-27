<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
	//변수
	int currentPage = 1;							// 현재 페이지
	int lastPage;									// 마지막 페이지
	int startRow;									// 데이터가 시작할 위치
	int rowDataCount = 11;							// 보여줄 데이터 수
	int totalDataCount = 0;							// 전체 데이터 수
	int pageDiv = 10;								// [1][2]...[10] 네비 개수
	int storeId = 0;
	
	String jsp = "/sakila/d0327/inventoryList.jsp";
	String sql = "";
	String where = "";
	String searchWord = "";
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;	
	
	// 변수 받기
	if(request.getParameter("currentPage") != null)	// 현재 페이지
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	
	if(request.getParameter("title") != null)		// 제목 검색
		searchWord = request.getParameter("title");
	
	if(request.getParameter("storeId") != null)		// 지점 번호
		storeId = Integer.parseInt(request.getParameter("storeId"));
	
	if(storeId != 0) where = "AND i.store_id =" + storeId;
	
	// DB 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	// 전체 데이터 수 구하는 쿼리
	sql = "SELECT COUNT(*) AS count"
			+" FROM inventory i"
			+" LEFT JOIN"
				+" (SELECT inventory_id, rental_date, return_date"
				+" FROM rental"
				 +" WHERE (inventory_id,rental_date)"
				 	+" IN (SELECT"
							+" inventory_id,"
							+" MAX(rental_date)"
						+" FROM rental"
						+" GROUP BY inventory_id)) t"
			+" ON i.inventory_id = t.inventory_id"
			+" INNER JOIN film f ON i.film_id = f.film_id"
			+" WHERE title LIKE ?" + where;
	
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
	
	// RS 초기화
	rs.beforeFirst();
	
	// 인벤토리 리스트 출력
	sql = "SELECT i.inventory_id AS inventoryId,"
			+" f.title AS title," 
			+" t.isRental AS isRental,"
			+" i.store_id AS storeId"
			+" FROM inventory i"
			+" LEFT JOIN"
				+" (SELECT inventory_id, rental_date," 
				+"	CASE WHEN return_date IS NULL THEN '대여중'"
				+"  ELSE '대여가능' END isRental"
				+" FROM rental"
				 +" WHERE (inventory_id,rental_date)"
				 	+" IN (SELECT"
							+" inventory_id,"
							+" MAX(rental_date)"
						+" FROM rental"
						+" GROUP BY inventory_id)) t"
			+" ON i.inventory_id = t.inventory_id"
			+" INNER JOIN film f ON i.film_id = f.film_id"
			+" WHERE title LIKE ?" + where
			+" ORDER BY i.inventory_id"
			+" LIMIT ?,?";
	
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	stmt.setString(1,"%"+searchWord+"%");
	stmt.setInt(2, startRow);
	stmt.setInt(3, rowDataCount);
	rs = stmt.executeQuery();
	
	ArrayList<HashMap<String,Object>> invenList = new ArrayList<HashMap<String,Object>>();
	
	while(rs.next()){
		HashMap<String,Object> inven = new HashMap<String,Object>();
		
		inven.put("inventoryId",rs.getObject("inventoryId"));
		inven.put("title",rs.getObject("title"));
		inven.put("storeId",rs.getObject("storeId"));
		inven.put("isRental",rs.getObject("isRental"));
		
		invenList.add(inven);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<title>인벤토리 리스트 &#129530;</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
</head>
<body>
	<h1><a href="/sakila/index.jsp">Sakila &#127968;</a></h1>
	
	<br>

	<h1>인벤토리 리스트 &#129530;</h1>
	
	<!-- 리스트 출력 -->
	<table border="1" class="clean-table">
		<tr>
			<th>인벤토리 아이디</th>
			<th>영화 제목</th>
			<th>지점</th>
			<th>대여하기</th>
		</tr>
		<%
			// 컬럼명 리스트로 테이블 행 출력 축약
			for(HashMap<String,Object> i : invenList){
				%>
					<tr>
						<td><%=i.get("inventoryId") %></td>
						<td><%=i.get("title") %></td>
						<td><%=i.get("storeId") %></td>
						<%
							String isAble = String.valueOf(i.get("isRental"));
							if(isAble.equals("대여가능")){
								%><td><a href="<%=jsp%>"><%=isAble%></a></td><%
							}
							else{
								%><td>대여중</td><%
							}
						%>
					</tr>
				<%
			}
		%>
	</table>
	
	<!-- 네비게이션 -->
	<h3><%=currentPage%> / <%=lastPage%> 페이지</h3>
	
	<div>
		<!-- [처음] -->
		<a href="<%=jsp%>?currentPage=1&title=<%=searchWord%>&storeId=<%=storeId%>">처음</a>
		
		<!-- [이전 10] -->
		<a href="<%=jsp%>?currentPage=<%=currentPage - 10%>&title=<%=searchWord%>&storeId=<%=storeId%>">이전 10</a>
		
		<%
			// [1][2][3][4]...[9][10]
			for(int i = 1 ; i <= pageDiv ; i++){
				// 페이지 번호
				int p = (((currentPage - 1) / 10) * 10) + i;
				if(p > lastPage) continue; // 마지막 페이지 크기보다 크면 생략
					%><a href="<%=jsp%>?currentPage=<%=p%>&title=<%=searchWord%>&storeId=<%=storeId%>" class="<%=currentPage == i ? "selected" : "" %>"><%=p%></a><%
			}
		%>
		
		<!-- [다음 10] -->
		<a href="<%=jsp%>?currentPage=<%=currentPage + 10%>&title=<%=searchWord%>&storeId=<%=storeId%>">다음 10</a>
		
		<!-- [마지막] -->
		<a href="<%=jsp%>?currentPage=<%=lastPage%>&title=<%=searchWord%>&storeId=<%=storeId%>">마지막</a>
	</div>
	<br>
	<!-- 검색 -->
	<form action="<%=jsp%>">
		지점 :
		<select name="storeId">
			<option value="0" <%=storeId == 0 ? "selected" : "" %>>전체</option>
			<option value="1" <%=storeId == 1 ? "selected" : "" %>>1지점</option>
			<option value="2" <%=storeId == 2 ? "selected" : "" %>>2지점</option>
		</select>
	
		영화 제목 : <input type="text" name="title" value="<%=searchWord%>">
		<button type="submit">검색</button>
	</form>
</body>
</html>