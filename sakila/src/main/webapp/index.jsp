<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<style>
  html{
  	background-color:#030303;
  }
	
	body {
    margin: 1% auto;
    padding: 5px;
    width: 60%;
    text-align: center;
	}
	
   h1,h3{
   	color:white;
   }

   a {
    display: inline-block;
    padding: 4px 8px;
    margin: 0 5px;
    text-decoration: none;
    background-color:white;
    color: black;
    border: 1px solid black;
    border-radius: 4px;
	}

   form{
   	color:white;
   }

  table.clean-table {
    width: 100%;
    border-collapse: collapse;
    font-family: 'Pretendard', sans-serif;
    font-size: 14px;
    background-color: #1e1e1e; /* 테이블 배경 (딥 그레이) */
    color: #e0e0e0; /* 기본 글자색 (은은한 회색톤) */
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(255, 255, 255, 0.4); /* 다크톤에서 그림자는 깊게 */
  }

  /* 헤더 행 스타일 */
  .clean-table thead tr {
    background-color: #2c2c2c; /* 헤더 배경 (조금 더 밝은 그레이) */
    color: #ffd700; /* 헤더 텍스트 색 (고급스러운 골드톤) */
    text-transform: uppercase; /* 대문자 변환으로 느낌 강조 */
    letter-spacing: 0.5px;
  }

  .clean-table th {
    padding: 14px 18px;
    text-align: left;
    font-weight: 600;
    border-bottom: 1px solid #444; /* 헤더 하단 구분선 */
    background-color:#32386e;
    color:white;
  }

  .clean-table td {
    padding: 14px 18px;
    border-bottom: 1px solid #333; /* 셀 하단 구분선 */
  }

  /* 짝수 행 배경 */
  .clean-table tbody tr:nth-child(even) {
    background-color: #252525; /* 약간 밝은 회색 (딥한 계열 유지) */
  }

  /* 홀수 행 배경 */
  .clean-table tbody tr:nth-child(odd) {
    background-color: #1e1e1e; /* 테이블 기본 배경과 통일 */
  }

  /* 마우스 오버 효과 */
  .clean-table tbody tr:hover {
    background-color: #333333; /* 강조 효과 (은은한 대비) */
  }

  @media screen and (max-width: 768px) {
    .clean-table {
      font-size: 13px;
    }

    .clean-table th,
    .clean-table td {
      padding: 12px 14px;
    }
  }
</style>
<head>
<meta charset="UTF-8">
<title>인덱스</title>
</head>
<body>
	<h1>Skila</h1>
	<ol>
		<li><a href="/sakila/d0325/rentalList.jsp">대여 목록</a></li>
		<li><a href="/sakila/d0326/filmList.jsp">영화 목록</a></li>
		<li><a href="/sakila/d0326/actorList.jsp">배우 목록</a></li>
	</ol>
</body>
</html>