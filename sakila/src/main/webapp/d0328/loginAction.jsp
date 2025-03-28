<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<%
	// controller layer : staffId, password
	int staffId = Integer.parseInt(request.getParameter("staffId"));
	String password = request.getParameter("password");
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;	
	
	String sql = "SELECT staff_id staffId, first_name firstName FROM staff where staff_id=? and password=?";
	
	// DB 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1,staffId);
	stmt.setString(2,password);
	rs = stmt.executeQuery();
	
	boolean isLogin = false;
	if(rs.next()){
		// 현재 세션 영역에 loginStaff 변수를 생성(있으면 로그인된 상태, 없다면 로그아웃 상태)
		session.setAttribute("loginStaff", rs.getInt("staffId"));
		response.sendRedirect("/sakila/index.jsp");
	}
	else{
		// 로그인 실패
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
	}
%>