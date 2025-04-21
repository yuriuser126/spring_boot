<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table border="1" align="center">
		<form method="post" action="registerOk">
			<tr height="50">
				<td colspan="2">
					<h1>회원 가입 신청</h1>
				</td>
			</tr>
			<tr height="30">
				<td width="80">
					User ID
				</td>
				<td>
					<input type="text" size="20" name="mem_uid">
				</td>
			</tr>
			<tr height="30">
				<td width="80">
					암호
				</td>
				<td>
					<input type="text" size="20" name="mem_pwd">
				</td>
			</tr>
			<tr height="30">
				<td width="80">
					이름
				</td>
				<td>
					<input type="text" size="20" name="mem_name">
				</td>
			</tr>
			<tr height="30">
				<td colspan="2">
					<input type="submit" value="등록">
				</td>
			</tr>
		</form>
	</table>
</body>
</html>