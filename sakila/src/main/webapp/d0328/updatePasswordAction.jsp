<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<%
	// 로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");

	if(staffId == null){ // 로그아웃 상태라면
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}
	
	// 변수
	int row = 0;
	
	String prePassword = "";
	String newPassword = "";
	
	Connection conn = null;
	PreparedStatement stmt = null;
	
	// 변수 받기
	prePassword = request.getParameter("prePassword");
	newPassword = request.getParameter("newPassword");
	
	//DB 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	String sql = "UPDATE staff"
				+" SET PASSWORD = ?"
				+" WHERE staff_id = ? AND PASSWORD = ?";
	
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,newPassword);
	stmt.setInt(2,staffId);
	stmt.setString(3,prePassword);
	
	row = stmt.executeUpdate();
	
	if(row == 1){
		// 정상 수정
		response.sendRedirect("/sakila/d0328/logout.jsp");
	}
	else{
		// 비정상 수정
		response.sendRedirect("/sakila/d0328/updatePasswordForm.jsp");
	}
%>