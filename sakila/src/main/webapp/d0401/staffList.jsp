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
	int currentPage = 1;
	int lastPage = 0;
	int rowDataCount = 7;
	int startRow = 0;
	int totalDataCount = 0;
	int pageDiv = 10;
	
	String searchWord= "";
	String jsp = "/sakila/d0401/staffList.jsp";
	String[] col = {"ID","name","address","zip code","phone","city","country","SID"};
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	// 변수 받기
	if(request.getParameter("currentPage") != null){// 현재 페이지
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	if(request.getParameter("searchWord") != null){
		searchWord = request.getParameter("searchWord");
	}
	
	// DB 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	// 데이터 개수 구하는 쿼리
	String sql = "SELECT COUNT(*) count FROM staff"
				+" WHERE CONCAT(staff.first_name,' ',staff.last_name) LIKE ?";
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	stmt.setString(1, "%"+searchWord+"%");
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
	
	// 테이블 출력 쿼리
	sql = "SELECT"
			+" sf.staff_id AS ID,"
			+" CONCAT(sf.first_name,' ',sf.last_name) AS name,"
			+" ad.address AS 'address',"
			+" ad.postal_code AS 'zip code',"
			+" ad.phone AS phone,"
			+" ct.city AS 'city',"
			+" cn.country AS 'country',"
			+" sf.store_id AS SID"
		+" FROM staff sf"
		+" INNER JOIN address ad ON sf.address_id = ad.address_id"
		+" INNER JOIN city ct ON ad.city_id = ct.city_id"
		+" INNER JOIN country cn ON ct.country_id = cn.country_id"
		+" WHERE CONCAT(sf.first_name,' ',sf.last_name) LIKE ?"
		+" LIMIT ?,?";
	
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	stmt.setString(1, "%"+searchWord+"%");
	stmt.setInt(2, startRow);
	stmt.setInt(3, rowDataCount);
	rs = stmt.executeQuery();
	
	ArrayList<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
	
	while(rs.next()){
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		for(String c : col){
			map.put(c,rs.getObject(c));
		}

		list.add(map);
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<title>직원 별 수익</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
</head>
<body>
	<h1><a href="/sakila/index.jsp">Sakila &#127968;</a></h1>
	
	<br>

	<h1>직원 별 수익 뷰</h1>
	
	<!-- 리스트 출력 -->
	<table border="1" class="clean-table">
		<tr>
			<%
				for(String c : col){
					%><th><%=c%></th><%
				}
			%>
		</tr>
		<%
			for(HashMap<String,Object> m : list){
				%>
					<tr>
						<%
							for(String c : col){
								%><td><%=m.get(c) %></td><%
							}
						%>
					</tr>
				<%
			}
		%>
	</table>
	<br>
	<!-- 네비게이션 -->
	<h3><%=currentPage%> / <%=lastPage%> 페이지</h3>
	
	<div>
		<!-- [처음] -->
		<a href="<%=jsp%>?currentPage=1&searchWord=<%=searchWord%>">처음</a>
		
		<!-- [이전 10] -->
		<a href="<%=jsp%>?currentPage=<%=currentPage - 10%>&searchWord=<%=searchWord%>">이전 10</a>
		
		<%
			// [1][2][3][4]...[9][10]
			for(int i = 1 ; i <= pageDiv ; i++){
				// 페이지 번호
				int p = (((currentPage - 1) / 10) * 10) + i;
				if(p > lastPage) continue; // 마지막 페이지 크기보다 크면 생략
					%><a href="<%=jsp%>?currentPage=<%=p%>&searchWord=<%=searchWord%>" class="<%=currentPage == i ? "selected" : "" %>"><%=p%></a><%
			}
		%>
		
		<!-- [다음 10] -->
		<a href="<%=jsp%>?currentPage=<%=currentPage + 10%>&searchWord=<%=searchWord%>">다음 10</a>
		
		<!-- [마지막] -->
		<a href="<%=jsp%>?currentPage=<%=lastPage%>&searchWord=<%=searchWord%>">마지막</a>
	</div>
	<br>
	<!-- 검색 -->
	<form action="<%=jsp%>">
		직원 이름 : <input type="text" name="searchWord" value="<%=searchWord%>">
		<button type="submit">검색</button>
	</form>
</body>
</html>