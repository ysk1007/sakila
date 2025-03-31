<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	//로그인 되었는지 아닌지?
	Integer thisStaffId = (Integer)session.getAttribute("loginStaff");

	if(thisStaffId == null){ // 로그아웃 상태라면
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}
	
	// 렌탈 테이블의 조건
	/*
    `rental_id` INT NOT NULL AUTO_INCREMENT,
    `rental_date` DATETIME NOT NULL, curdate() or now() or sysdate...
    `inventory_id` MEDIUMINT UNSIGNED NOT NULL, request
    `customer_id` SMALLINT UNSIGNED NOT NULL, 직접입력
    `return_date` DATETIME NULL DEFAULT NULL, null
    `staff_id` TINYINT UNSIGNED NOT NULL,
 	*/

	// 변수
	int row = 0;					// 쿼리에 영향 받은 행의 개수
 	Integer customerId = null;		// 고객 아이디
 	Integer inventoryId = null;		// 인벤토리 아이디
 	Integer filmId = null;			// 영화 아이디
	Integer storeId = null;			// 지점 아이디
	Integer staffId = null;			// 직원 아이디
	
	String title = request.getParameter("title");	// 영화 제목
	
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
	
	// 대여 데이터 추가 쿼리
	String sql = "INSERT INTO"
				+" rental(rental_date,inventory_id,customer_id,staff_id)"
				+" VALUES(now(),?,?,?)";
	stmt = conn.prepareStatement(sql);
	
	// ? 할당
	stmt.setInt(1, inventoryId);
	stmt.setInt(2, customerId);
	stmt.setInt(3, staffId);
	
	// 디버깅
	//System.out.println(stmt);
	
	// 쿼리 실행
	row = stmt.executeUpdate();
	
	if(row == 1){	// 정상 대여
		//System.out.println("정상 대여");
	
		// 대여 리스트 페이지로 이동
		response.sendRedirect("/sakila/d0325/rentalList.jsp");
	}
	else{	// 비정상 대여
		//System.out.println("비정상 대여");
	
		// 인벤토리 리스트 페이지로 이동
		response.sendRedirect("/sakila/d0327/inventoryList.jsp");
	}
	
	
	
%>