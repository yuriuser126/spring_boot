<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	.div_page ul{
		display: flex;
		list-style: none;

	}


</style>
</head>
<body>
	<table width="500" border="1">
		<tr>
			<td>번호</td>
			<td>이름</td>
			<td>제목</td>
			<td>날짜</td>
			<td>히트</td>
		</tr>
<!-- 		조회결과 -->
<!-- 		list : 모델객체에서 보낸 이름 -->
		<c:forEach var="dto" items="${list}">
			<tr>
				<td>${dto.boardNo}</td>
				<td>${dto.boardName}</td>
				<td>
<%-- 					${dto.boardTitle} --%>
<!-- 			content_view : 컨트롤러단 호출 -->
					<!-- <a href="content_view?boardNo=${dto.boardNo}">${dto.boardTitle}</a> -->
					 <!-- 바로이동아니고 일단 값 : 글번호만 제목 클릭시-->
					<a class="move_link" href="${dto.boardNo}">${dto.boardTitle}</a>
				</td>
				<td>${dto.boardDate}</td>
				<td>${dto.boardHit}</td>
			</tr>
		</c:forEach>
		<tr>
			<td colspan="5">
			<!-- 			write_view : 컨트롤러단 호출 -->
				<a href="write_view">글작성</a>
			</td>
		</tr>
	</table>

<!-- el태그로 값 받는다 -->
	<h3>${PageMaker}</h3>
	<div class ="div_page">
		<ul>
			<c:if test="${PageMaker.prev}" >
			<!-- <li>[Previous]</li> -->
			 <li class="pagenate_button">
				<a href="${PageMaker.startpage-1}">
					[Previous]
				</a>
			 </li>
			</c:if>

			<!-- 첫페이지부터 마지막페이지까지 반복하겠다.  -->
			<c:forEach var="num" begin="${PageMaker.startpage}" end="${PageMaker.endpage}">
				<!-- <li>[${num}]</li> -->
				<!-- <li  ${PageMaker.cri.pageNum == num ?"style='color:red'":""}>[${num}]</li> -->
				<li class="pagenate_button" ${PageMaker.cri.pageNum == num ?"style='color:red'":""}>
					<!-- 숫자그대로받아서 값은 숫자 -->
					<a href="${num}">
						<!-- [Previous] -->
						[${num}]
					</a>
					<!-- [${num}] -->
				</li>


				<!-- console.log("@# files=>"+files[i].name); -->
			</c:forEach>

			<c:if test="${PageMaker.next}" >
				<!-- <li>[Next]</li> -->
				<li class="pagenate_button">
					<a href="${PageMaker.endpage+1}">
						[Next]
					</a>
				 </li>
				</c:if>

			
			
		</ul>
	</div>

	<form id="actionForm" action="list" method="get">
		<input type="hidden" name="pageNum" value="${PageMaker.cri.pageNum}">
		<input type="hidden" name="amount" value="${PageMaker.cri.amount}">
		<!-- 이름은 넘어갈때 사용되는거 값은 페이지 번호 : "${PageMaker.cri.pageNum}"  -->
		<!-- 히든으로 넘어오는거는 Criteria.java dto에서 가져오면됨 -->

	</form>

</body>
</html>
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
<script>
	// 변수로 사용할거다 아이디로 받아서
	var actionForm = $("#actionForm");


	//페이지 번호 처리리
	$(".pagenate_button a").on("click",function (e) {
		e.preventDefault();
		console.log("click!!~~~");
		// console.log("$(this)"+$(this));
		console.log("@# href -> "+$(this).attr("href"));
		// console.log("@# href -> "+$(this).data("href"));
		
		
		//input 안에 속성-이름 대괄호 사용 - 클릭한 값 찾는다. 이걸 액션폼으로 ~
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		
		//버그처리
		//이동하려면 서브밋 사용 - 경로 지정 갔다오면 컨텐트를 물고있음 리스트를 넣어줘야합니다.
		//게시글 클릭후 뒤로가기 누른후 다른페이지 클릭할때 contentview물고있는거 해결 contentview옴.
		actionForm.attr("action","list").submit();
		
	}); //end of pagenate_button click
	
	//게시글처리
	//클래스니까 + 게시글 처리를 하겠다 콘솔 : 이거 왜한거임?
	$(".move_link").on("click",function (e) {
		e.preventDefault();
		//게시글 번호가찍힌다 - 클릭했을때 번호를 들고갈수 있겠다.
		console.log("@# href -> "+$(this).attr("href"));
		
		console.log("move_link click!!~~~");
		
		//변수사용할거다 대상은 보드 넘버다.
		var targetBno = $(this).attr("href");
		//넘어가는거 액션폼 사용 게시글 찾아가야하니까 어펜드 사용-태그를 넣는다. 화면단보면됨
		// 유리언니 자리는 내가 접수했다 하하하 ❤️ ^-^ 
		//이름은 보드넘버 값은 위에만든 타겟보드넘버인데 작은따옴표안에 큰따옴표 ++ 사용해서 넣으면됨
		// content_view?boardNo=${dto.boardNo} 를 actionForm으로 정리

		//버그처리 값이 있으면 리무브 ! = 값이 있으면
		//버그처리 (게시글 클릭후 뒤로가기 누른후 다른 게시글 클릭할때 &boardNo=번호 계속 누적방지)
		var bno = actionForm.find("input[name='boardNo']").val();
		if (bno != "") {
			actionForm.find("input[name='boardNo']").remove();
			
		}


		actionForm.append("<input type='hidden' name='boardNo' value='"+targetBno+"'>");
		//왜 안가나했는데 페이지 이동이 필요함 서브밋 추가 위와 같음
		// actionForm.submit();
		// 속성이 필요하다. action
		//컨트롤러에 있는 content_view 찾아가겠다.
		//submit() 괄호안붙이면 이동안한다 유의하자.
		actionForm.attr("action","content_view").submit();
		// actionForm.attr("action","content_view?bno").submit();
		// actionForm.attr("action","content_view?boardNo=${dto.boardNo}").submit();
	})

	
</script>
