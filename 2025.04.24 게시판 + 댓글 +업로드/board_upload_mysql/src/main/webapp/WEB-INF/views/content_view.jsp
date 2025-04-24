<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>

<style>
	.uploadResult {
		width: 100%;
		background-color: gray;
	}

	.uploadResult ul {
		display: flex;
		flex-flow: row;
	}

	.uploadResult ul li {
		list-style: none;
		padding: 10px;
	}

	.uploadResult ul li img {
		width: 100px;
	}
</style>

<body>
	<table width="500" border="1">
		<form method="post" action="modify">
			<input type="hidden" name="boardNo" value="${content_view.boardNo}">
			<tr>
				<td>번호</td>
				<td>
					${content_view.boardNo}
				</td>
			</tr>
			<tr>
				<td>히트</td>
				<td>
					${content_view.boardHit}
				</td>
			</tr>
			<tr>
				<td>이름</td>
				<td>
<%-- 					${content_view.boardName} --%>
					<input type="text" name="boardName" value="${content_view.boardName}">
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
<%-- 					${content_view.boardTitle} --%>
					<input type="text" name="boardTitle" value="${content_view.boardTitle}">
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
<%-- 					${content_view.boardContent} --%>
					<input type="text" name="boardContent" value="${content_view.boardContent}">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="수정">
					&nbsp;&nbsp;<a href="list">목록보기</a>
					&nbsp;&nbsp;<a href="delete?boardNo=${content_view.boardNo}">삭제</a>
				</td>
			</tr>
		</form>
	</table>
	<!-- ----------------------------------------------------------------- -->
	
	
	<!-- 첨부파일 출력 -->
	Files
	<div class="bigPicture">
		<div class="bigPic">
			
		</div>
	</div>
	
	<!-- 이건 그대로 쓴다 -->
	<div class="uploadResult">
		<ul>
			
		</ul>
	</div>
	
	<!-- ----------------------------------------------------------------- -->

	<div>
		<input type="text" id="commentWriter" placeholder="작성자">
		<input type="text" id="commentContent" placeholder="내용">
		<button onclick="commentWrite()">댓글 작성</button>
	</div>

	<div id="comment-list">
				
		<table>
			<tr>
				<th>댓글번호</th>
				<th>작성자</th>
				<th>내용</th>
				<th>작성시간</th>
			</tr>
			<c:forEach items="${commentList}" var="comment">
				<tr>
					<td>${comment.commentNo}</td>
					<td>${comment.commentWriter}</td>
					<td>${comment.commentContent}</td>
					<td>${comment.commentCreatedTime}</td>
				</tr>
			</c:forEach>
		</table>
		


	</div>
	
</body>
	<script>
		const commentWrite = () =>{
			const writer = document.getElementById("commentWriter").value;
			const comment = document.getElementById("commentContent").value;
			const no = "${content_view.boardNo}";

			$.ajax({
				type:"post"
				,data:{
					commentWriter: writer
					,commentContent: comment
					,boardNo: no

				}
				,url:"/comment/save"
				,success: function(commentList){
					console.log("작성 성공");
					console.log(commentList);
					
					let output="<table>";
					    output+="<tr><th>댓글번호</th>";
					    output+="<th>작성자</th>";
					    output+="<th>내용</th>";
					    output+="<th>작성시간</th></tr>";
						for(let i in commentList){
							
							output+="<tr>";
							output+="<td>"+commentList[i].commentNo+"</td>";
							output+="<td>"+commentList[i].commentWriter+"</td>";
							output+="<td>"+commentList[i].commentContent+"</td>";
							output+="<td>"+commentList[i].commentCreatedTime+"</td>";
							// output+="<td>"+i.commentCreatedTime+"</td>";
							output+="</tr>";
						}
						output +="<table>";
						console.log("@# output=>"+output);	
						
						document.getElementById("comment-list").innerHTML = output;
						// document.getElementById("commentContent").value.innerHTML = output;
						
				} //end of success
				,error: function(){
					console.log("실패");

				} // end of error
				
			});// end of ajax
		} // end of script
	</script>
	<script>
		//테이블로딩되는 다음에 실행되는것.
		//첨부파일을 열기전 밑 작업
		$(document).ready(function(){
			//파라미터 없음. 즉시 실행함수
			console.log("@# (document).ready 111 ->");
			(function(){
				console.log("@# (document).ready 222->");
				//안뜸 ;;;;; 해결완료
				var boardNo = "<c:out value='${content_view.boardNo}'/>"
				console.log("@# boardNo ->"+boardNo);
			
			
			$.getJSON("/getFileList",{boardNo : boardNo}, function(arr) {
				// arr : 파일정보 여러개 없으면 없음
				console.log("@# getJSON arr ->"+arr);

				var str="";
				// 인덱스와 어태치를 받는다
				// $(arr).each(function(i,attach){
				$(arr).each(function(i,obj){

				// image type 인 경우에
				if(obj.image) {
					var fileCallPath = obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName;

					str+="<li data-path='"+obj.uploadPath+"'";
					str+="data-uuid='"+obj.uuid+"'";
					str+="data-filename='"+obj.fileName+"'";
					str+="data-type='"+obj.image+"'";
					str+="><div>";

					str+="<span>"+obj.fileName+"</span>";
					// 컨트롤러단에서 받을거다 fileName 으로 던질거다
					str+="<img src='/display?fileName="+fileCallPath+"'>";//이미지 출력처리(컨트롤러단)
					// x 버튼 눌렀을때 삭제할거다
					//str+="<span data-file=\'"+fileCallPath+"\'data-type='image'> x </span>";
					str+="</div></li>";

					
				}else {// image type 인 경우가 아닐때
				
					console.log("@# image type 인 경우가 아닐때");
					var fileCallPath = obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName;

						str+="<li data-path='"+obj.uploadPath+"'";
						str+="data-uuid='"+obj.uuid+"'";
						str+="data-filename='"+obj.fileName+"'";
						str+="data-type='"+obj.image+"'";
						str+="><div>";

						str+="<span>"+obj.fileName+"</span>";
						str+="<img src='./resources/images/attach.png'>";
						//str+="<span data-file=\'"+fileCallPath+"\'data-type='file'> x </span>";//이미지 출력처리(컨트롤러단)
						str+="</div></li>";
						console.log("@# content view 파일 이미지 아닐때");
					}
						
				}); // end of (arr).each
				// 업로드 ul에 추가하겠다 위에 만든 str을
				console.log("@# str->"+str);
				//uploadResult값을 html에 넣겠다.
				$(".uploadResult ul").html(str);


			});//end of getJSON
			// 제이슨 데이터 형태로 boardNo 를 boardNo 이름으로 가져가겠다.

			// 요소를 만들거다 uploadResult클래스 이미지 확대 파일 다운로드 e는 상관없다.
			$(".uploadResult").on("click","li",function (e) {
				console.log("@# uploadResult => click! 함수 이미지확대 ");
				
				// 목록객체 변수로 받을거다(콘솔로 확인인)
				var liObj = $(this)
				console.log("@# path 01=>",liObj.data("path"));
				console.log("@# uuid =>",liObj.data("uuid"));
				console.log("@# filename=>",liObj.data("filename"));
				console.log("@# type=>",liObj.data("type"));
				
				//경로를 찾아가야함
				var path = liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename");
				console.log("@# path 02 최종 경로로=>",path);
				
				
				//분기처리
				//이미지 일때- 확대
				if (liObj.data("type")) {
					console.log("@# 이미지 일때- 확대");
					//아래 쇼이미지 함수, 파라미터 위에 만든 path
					//호출을하면 컨트롤러로 갑니다.
					console.log("@# 호출되면 컨트롤러로 간다. showImage(path)");
					showImage(path);
					
				} else {//이미지가 아닐때 - 파일 다운로드
					console.log("@# 이미지가 아닐때 - 파일 다운로드");

					//파일네임을가져가면서 실제로는 path 가져감.
					self.location="/download?fileName="+path;
					
				}
				
				
			}); //end of uploadResult click 함수
			
			//이미지를 보여줄거다 파일 경로파라미터로
			function showImage(fileCallPath) {
				console.log("@# showImage 함수 - 이미지를 보여줄거다 파일 경로파라미터로");
				console.log("@# fileCallPath=>"+fileCallPath);

				//어디다 이미지를 복사할거냐. .bigPicture class
				$(".bigPicture").css("display","flex").show();
				//그림을 가져올거다 원본으로 경로+css
				$(".bigPic").html("<img src='/display?fileName="+fileCallPath+"'>")
				             .animate({width:"100%",height:"100%"},1000);
				
				
			}

			//이미지를 다시 없앨때
			$(".bigPicture").on("click",function (e) {
				$(".bigPic").animate({width:"0%",height:"0%"},1000);
				
				//1초 뒤에 작동하게끔 숨기기
				setTimeout(function () {
					
					$(".bigPicture").hide();
				},1000); //end of setTimeout
				
			}); // end of bigPicture 이미지 없앨때

		})();// end of function 즉시 실행함수


		}); //end of (document).ready

	</script>
</html>













