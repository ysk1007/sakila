<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	System.out.println("액션");
	//로그인 되었는지 아닌지?
	Integer thisStaffId = (Integer)session.getAttribute("loginStaff");

	if(thisStaffId == null){ // 로그아웃 상태라면
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}
	
	/*
    `rental_id` INT NOT NULL AUTO_INCREMENT,
    `rental_date` DATETIME NOT NULL, curdate() or now() or sysdate...
    `inventory_id` MEDIUMINT UNSIGNED NOT NULL, request
    `customer_id` SMALLINT UNSIGNED NOT NULL, 직접입력
    `return_date` DATETIME NULL DEFAULT NULL, null
    `staff_id` TINYINT UNSIGNED NOT NULL, session
 	*/

	// 변수
	int row = 0;					// 쿼리에 영향 받은 행의 개수
 	Integer customerId = null;
 	Integer inventoryId = null;
 	Integer filmId = null;
	Integer storeId = null;
	Integer staffId = null;
	
	String title = request.getParameter("title");
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	// 변수 받기
	if(request.getParameter("customerId") != null){
		customerId = Integer.parseInt(request.getParameter("customerId"));
	}	
	if(request.getParameter("inventoryId") != null){
		inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	}
	if(request.getParameter("storeId") != null){
		storeId = Integer.parseInt(request.getParameter("storeId"));
	}
	if(request.getParameter("staffId") != null){
		staffId = Integer.parseInt(request.getParameter("staffId"));
	}
	
	// SQL 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	// 쿼리
	String sql = "INSERT INTO"
				+" rental(inventory_id,customer_id,staff_id)"
				+" VALUES(?,?,?)";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, inventoryId);
	stmt.setInt(2, customerId);
	stmt.setInt(3, staffId);
	System.out.println(stmt);
	
	row = stmt.executeUpdate();
	
	if(row == 1){
		System.out.println("정상 대여");
		response.sendRedirect("/sakila/d0325/rentalList.jsp");
	}
	else{
		System.out.println("비정상 대여");
		response.sendRedirect("/sakila/d0327/inventoryList.jsp");
	}
	
	
	
%>