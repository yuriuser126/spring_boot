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

	<form method="get" id="searchForm">
		<!-- ???????변셩했는데 오류남 -->
		<select name="type"> 
			<!-- 없으면 선택하라고 표시할거고 선택했으면 빈값 (스페이스 안해도됨)-->
			<option value="" <c:out value="${PageMaker.cri.type == null?'selected':''}"></c:out>>전체</option>
			<option value="T" <c:out value="${PageMaker.cri.type eq 'T'?'selected':''}"></c:out>>제목</option>
			<option value="C" <c:out value="${PageMaker.cri.type eq 'C'?'selected':''}"></c:out>>내용</option>
			<option value="W" <c:out value="${PageMaker.cri.type eq 'W'?'selected':''}"></c:out>>작성자</option>
			
			<option value="TC" <c:out value="${PageMaker.cri.type eq 'TC'?'selected':''}"></c:out>>제목or내용</option>
			<option value="TW" <c:out value="${PageMaker.cri.type eq 'TW'?'selected':''}"></c:out>>제목or작성자</option>

			<option value="TCW" <c:out value="${PageMaker.cri.type eq 'TCW'?'selected':''}"></c:out>>제목or내용or작성자</option>
			
		</select>

		<!-- Criteria 를 이용해서 키워드값을 넘길거다 텍스트 박스 검색창창-->
		<input type="text" name="keyword" value="${PageMaker.cri.keyword}">

		<!-- <input type="text" name="keyword" value="${PageMaker.cri.type.keyword}"> -->
		<!-- 전체로 검색했을때 값은 넘어가는데 검색 텍스트박스에 아무것도 남지않게 type.keyword -->
		<!-- <input type="hidden" name="pageNum" value="${PageMaker.cri.type}"> -->
		<!-- <input type="hidden" name="pageNum" value="${PageMaker.cri.pageNum}"> -->
		 <!-- 전체 검색중 4페이지에서 내용을 88키워드로 검색시 안나올때 처리 -->
		<input type="hidden" name="pageNum" value="1">
		<input type="hidden" name="amount" value="${PageMaker.cri.amount}">


		<!-- 서브밋 검색버튼 -->
		<button>Search</button>

	</form>



<!-- el태그로 값 받는다 -->
	<h3>${PageMaker}</h3>
	<div class ="div_page">
		<ul>
			<c:if test="${PageMaker.prev}" >
			<!-- <li>[Previous]</li> -->
			 <li class="pagenate_button">
				<a href="${PageMaker.startpage - 1}">
					[Previous]
				</a>
			 </li>
			</c:if>
			PageMaker

			<!-- 첫페이지부터 마지막페이지까지 반복하겠다.  -->
			<c:forEach var="num" begin="${PageMaker.startPage}" end="${PageMaker.endPage}">
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
					<a href="${PageMaker.endpage + 1}">
						[Next]
					</a>
				 </li>
				</c:if>

			
			
		</ul>
	</div>

	<form id="actionForm" action="list" method="get">
		<input type="hidden" name="pageNum" value="${PageMaker.cri.pageNum}">
		<input type="hidden" name="amount" value="${PageMaker.cri.amount}">
		<!-- 페이지 검색시 페이지 번호를 클릭핳때 필요한 파라미터 -->
		<input type="hidden" name="type" value="${PageMaker.cri.type}">
		<input type="hidden" name="keyword" value="${PageMaker.cri.keyword}">
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

	});//end of move_link click

	// 여기에 옵션태그 검색 로직
	//searchForm 이걸 변수로 받겠다.
	var searchForm = $("#searchForm");

	//Search 버튼 클릭 로직
	$("#searchForm button").on("click", function () {
		// alert("검색");

		// 값이 없는경우에 키워드를 입력을 받을거다 조건
		//키워드 입력 받을 조건- 옵션위치에 셀렉티드 된 값. 
		//선택된 값은 있는데 전체가 없는데 값이없음 안된다.??먼말이지이거거 실행하고 이해함
		//제목처럼 선택값 생겼는데 값없이 select 버튼 누르면 alert 뜨도록한다.
		if (searchForm.find("option:selected").val() != "" && !searchForm.find("input[name='keyword']").val()) {
			alert("키워드를 입력하세요.");
			return false;
		}
		//리스트로 보낸다.??????-> 이해함 윗단보면 그대로 보낼때 사용한거다.
		searchForm.attr("action","list").submit();
		// <form id="searchForm" action="list" method="get"></form>


	});//end of searchForm click

	//버튼이아니라 전체 변경하는곳으로 보낸다.
	//select 가 변경되었을때
	//type 콤보박스스 변경
	$("#searchForm select").on("change", function () {

		// 조건 건다 if에 전체가 나와야함함
		//searchForm.find("option:selected").val() == "" 이게 전체다 위쪽에 옵션태그가면 있음
		//전체일때때
		if (searchForm.find("option:selected").val() == "") {
			//키워드를 널값으로 변경경
			searchForm.find("input[name='keyword']").val("");
			// ""값에 공백넣어서 지운다
			
		}


	});//end of searchForm click


	
</script>
