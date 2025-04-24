<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table width="500" border="1">
		<tr>
			<td>사원번호</td>
			<td>이름</td>
			<td>부서번호</td>
			<td>부서명</td>
		</tr>
<!-- 		조회결과 -->
<!-- 		list : 모델객체에서 보낸 이름 controller -->
		<c:forEach var="dto" items="${list}">
			<tr>
				<td>${dto.empno}</td>
				<td>${dto.ename}</td>
				<td>${dto.deptno}</td>
				<td>${dto.dname}</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>