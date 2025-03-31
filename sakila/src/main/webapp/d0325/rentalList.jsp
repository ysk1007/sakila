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

	// 변수
	int currentPage = 1;							// 현재 페이지
	int lastPage;									// 마지막 페이지
	int startRow;									// 데이터가 시작할 위치
	int rowDataCount = 11;							// 보여줄 데이터 수
	int totalDataCount = 0;							// 전체 데이터 수
	int pageDiv = 10;								// [1][2]...[10] 네비 개수
	int storeId = 0;								// 지점 번호
	
	String jsp = "/sakila/d0325/rentalList.jsp";	// jsp 위치
	String sql = "";								// SQL 쿼리
	String searchWord = "";							// 검색 단어
	String where = " 1 ";							// WHERE 조건
	
	// 테이블 컬럼 명
	String[] colList = {"rental_id","title","inventory_id","store_id","name","rentalDate","returnDate"};
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;	

	// 변수 받기
	if(request.getParameter("currentPage") != null)	// 현재 페이지
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	
	if(request.getParameter("storeId") != null)		// 지점 번호
		storeId = Integer.parseInt(request.getParameter("storeId"));
	
	if(request.getParameter("title") != null)		// 제목
		searchWord = request.getParameter("title");
	
	// 제목 검색 & 지점 번호에 따라서 WHERE 절에 조건 추가
	if(!searchWord.equals(""))
		where += " AND title LIKE '%" + searchWord + "%' ";
	
	if(storeId != 0)
		where += " AND i.store_id =" + storeId;
	
	//DB 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	// 전체 데이터 구할 쿼리
	sql = " SELECT COUNT(*) count"
		+" FROM rental r"
		+" INNER JOIN customer c ON r.customer_id = c.customer_id"
		+" INNER JOIN inventory i ON r.inventory_id = i.inventory_id"
		+" INNER JOIN film f ON i.film_id = f.film_id"
		+" WHERE " + where;
	
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
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
	
	// 테이블 쿼리
	sql = " SELECT" 
		+"    r.inventory_id,"
		+"    r.rental_id,"
		+"    CONCAT(c.first_name, ' ', c.last_name,'(', c.customer_id, ')') AS NAME,"
		+"    DATE(r.rental_date) rentalDate,"
		+"    DATE(r.return_date) returnDate,"
		+"    i.film_id,"
		+"    i.store_id,"
		+"    f.title AS title"
		+" FROM rental r"
		+" INNER JOIN customer c ON r.customer_id = c.customer_id"
		+" INNER JOIN inventory i ON r.inventory_id = i.inventory_id"
		+" INNER JOIN film f ON i.film_id = f.film_id"
		+" WHERE " + where
		+" ORDER BY rental_date DESC"
		+" LIMIT ?,?;";
		
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	stmt.setInt(1,startRow);
	stmt.setInt(2,rowDataCount);
	rs = stmt.executeQuery();
	
	// HashMap에 데이터 담기
	ArrayList<HashMap<String,Object>> rentalList = new ArrayList<HashMap<String,Object>>();
	while(rs.next()){
		HashMap<String,Object> m = new HashMap<String,Object>();
		for(String col : colList){
			m.put(col,rs.getObject(col));
		}
		rentalList.add(m);
	}
	
	rs.close();
%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>대여 리스트</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
</head>
<body>
	<h1><a href="/sakila/index.jsp">Sakila &#127968;</a></h1>
	
	<br>

	<h1>대여 리스트 &#128252;</h1>
	
	<!-- 리스트 출력 -->
	<table border="1" class="clean-table">
		<tr>
			<th>대여 번호</a></th>
			<th>영화 제목</th>
			<th>비디오 위치</th>
			<th>지점</th>
			<th>이름(고객 아이디)</th><!-- name = first_name + last_name -->
			<th>대여일</th>
			<th>반납일</th>
		</tr>
		<%
			// 컬럼명 리스트로 테이블 행 출력 축약
			for(HashMap<String,Object> m : rentalList){
				%>
					<tr>
						<%
							for(String col : colList){
								%><td><%=m.get(col)%></td><%
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
	<form action="/sakila/d0325/rentalList.jsp">
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