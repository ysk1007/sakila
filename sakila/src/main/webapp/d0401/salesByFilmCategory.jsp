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
	String jsp = "/sakila/d0401/salesByFilmCategory.jsp";
	String[] col = {"category","totalSales"};
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	// DB 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	// 데이터 개수 구하는 쿼리
	String sql = "SELECT COUNT(*) count FROM category";
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	rs = stmt.executeQuery();
	rs.next();
	
	// RS 초기화
	rs.beforeFirst();
	
	// 테이블 출력 쿼리
	sql = "SELECT"
			+" ct.`name` AS 'category',"
			+" SUM(p.amount) AS totalSales"
		+" FROM category ct"
		+" INNER JOIN film_category fc ON ct.category_id = fc.category_id"
		+" INNER JOIN film f ON fc.film_id = f.film_id"
		+" INNER JOIN inventory i ON f.film_id = i.film_id"
		+" INNER JOIN rental r ON i.inventory_id = r.rental_id"
		+" INNER JOIN payment p ON r.rental_id = p.rental_id"
		+" GROUP BY ct.`name`"
		+" ORDER BY totalSales DESC";
	
	stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
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
<title>카테고리 별 수익</title>
<link rel="stylesheet" type="text/css" href="/sakila/css/sakila.css?after">
</head>
<body>
	<h1><a href="/sakila/index.jsp">Sakila &#127968;</a></h1>
	
	<br>

	<h1>카테고리 별 수익 뷰</h1>
	
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
</body>
</html>