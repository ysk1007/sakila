<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	//로그인 되었는지 아닌지?
	Integer staffId = (Integer)session.getAttribute("loginStaff");

	if(staffId == null){ // 로그아웃 상태라면
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}

	// 변수
	int row = 0;					// 쿼리에 영향 받은 행의 개수
	Integer customerId = null;
	Integer active = 0;
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	// 변수 받기
	if(request.getParameter("customerId") != null){
		customerId = Integer.parseInt(request.getParameter("customerId"));
	}
	
	if(request.getParameter("active").equals("true")){	// 활성화 상태라면
		active = 0;										// 비활성화
	}
	else if(request.getParameter("active").equals("false")){	// 비활성화 상태라면
		active = 1;												// 활성화
	}
	
	// SQL 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	// 고객 휴면 수정 쿼리
	String sql = "UPDATE customer SET"
				+" ACTIVE = ?"
				+" WHERE customer_id = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, active);
	stmt.setInt(2, customerId);
	// 디버깅
	//System.out.println("휴면 상태 수정 쿼리 : "+stmt);
	row = stmt.executeUpdate();
	
	if(row == 1){
		System.out.println("정상 휴면 해지");
		response.sendRedirect("/sakila/index.jsp");
	}
	else{
		System.out.println("비정상 휴면 해지");
		response.sendRedirect("/sakila/index.jsp");
	}
	
%>