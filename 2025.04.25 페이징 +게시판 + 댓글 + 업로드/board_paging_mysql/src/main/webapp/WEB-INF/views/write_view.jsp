<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
		.uploadResult{
		width: 100%;
		background-color: gray;
	}
	.uploadResult ul{
		display: flex;
		flex-flow: row;
	}
	.uploadResult ul li{
		list-style: none;
		padding: 10px;
	}
	.uploadResult ul li img{
		width: 20px;
	}
</style>
	<!-- <script src="../resources/js/jquery.js"></script> -->
	<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
	<script type="text/javascript">
		function fn_submit() {
			alert("01");
			var formData = $("#frm").serialize();//form 요소 자체
			alert("02");
			
			//비동기 전송방식의 jquery 함수
			$.ajax({
				 type:"post"
				,data:formData
				,url:"write"
				,success: function(data) {
					alert("저장완료");
					location.href="list";
				}
				,error: function() {
					alert("오류발생");
				}
			});
		}
	</script>
</head>
<body>
	<table width="500" border="1">
<!-- 		<form method="post" action="write"> -->
		<!-- <form id="frm"> -->
		<form id="frm" method="post" action="write" >
			<tr>
				<td>이름</td>
				<td>
					<input type="text" name="boardName" size="50">
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
					<input type="text" name="boardTitle" size="50">
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
					<textarea rows="10" name="boardContent"></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2">
<!-- 					<input type="submit" value="입력"> -->
					<!-- <input type="button" onclick="fn_submit()" value="입력"> -->
					<button type="submit">입력</button>
					&nbsp;&nbsp;
					<a href="list">목록보기</a>
				</td>
			</tr>
		</form>
	</table>

	FileAttach
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>

	<!-- 컨트롤러에서 리턴한 파일정보를 여기에 가지고 온다 -->
	<div class="uploadResult">
		<ul>

		</ul>
	</div>

</body>
</html>
<script>
	//파라미터 있음.
	$(document).ready(function(e){
		// 일단 요소 폼의 속성 아이디
		var formObj = $("form[id='frm']");

		$("button[type='submit']").on("click",function(e){
			// 이걸로 막는다
			e.preventDefault();
			console.log("submit button clicked");
			
			var str=""
		

			$(".uploadResult ul li").each(function(i,obj){
				console.log("@# obj=>"+$(obj));
				console.log("str에 누적시켜서 form obj에 담아서 submit 누르면 날아갈거임");
				console.log("@# data=>"+$(obj).data());
				console.log("@# fileName=>"+$(obj).data("filename"));
				
				var jobj = $(obj);
				console.log("=======================================");
				console.log("@# jobj=>"+jobj.data("filename"));
				// console.log("@# jobj=>"+$(jobj).data("filename"));
				console.log("@# uuid=>"+jobj.data("uuid"));
				console.log("@# path=>"+jobj.data("path"));
				console.log("@# type=>"+jobj.data("type"));
				
				console.log("str에 누적시켜서 form obj에 담아서 submit 누르면 날아갈거임");
				// each로 반복하면서 네개를 가져감
				
				str+="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str+="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str+="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str+="<input type='hidden' name='attachList["+i+"].image' value='"+jobj.data("type")+"'>";
				
				console.log("str 누적 데이터 가져갈때 hidden 사용, 첨부파일 여러개 배열형태");
				//str name은 DTO기준으로 .뒤에 붙인거임.ㅣ
				// str에 누적시켜서 form obj에 담아서 submit 누르면 날아갈거임

			});//end of uploadResult ul li

			console.log("@# uploadResult str=>"+str);
			//return;//안타게해서 콘솔을 찍어볼것임.
			
			// submit 해야함 + str을 더해서 타고 가게게 + 데이터가 없으면 오류남
			formObj.append(str).submit();

		});//end of button submit

		//확장자가 exe|sh|alz 업로드 금지하기 위한 정규식
		var regex = new RegExp("(.*?)\.(exe|sh|alz)$")
		// 파일크기(5mb)미만
		var maxSize = 5242880; //5mb

		function checkExtension(fileName, fileSize){
			if(fileSize >= maxSize) {
				alert("파일 사이즈 초과");
				return false;
			}
			if (regex.test(fileName)) {
				alert("해당종류의 파일은 업로드할 수 없습니다.")
				return false;
			}
			return true;
		}

		$("input[type='file']").change(function(e){
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			//파일정보 :files
			var files = inputFile[0].files;

			for(var i=0; i<files.length; i++){
				console.log("@# files=>"+files[i].name);

				//파일 크기와 종류중에서 거짓이면 리턴
				if (!checkExtension(files[i].name, files[i].size)) {
					return false;
				}
				console.log("01");
				// 파일정보를 formData에 추가
				formData.append("uploadFile",files[i]);
				console.log("02");
			}

			$.ajax({
				type:"post"
				,data:formData
				,url:"uploadAjaxAction"
				// processData : 기본은 key/value 를 Query String 으로 전송하는게 true
				// 파일 업로드는 false
				,processData : false
				// contentType: 기본값 :"application / x - www- form-urlencoded; charset = UTF-8"
				// 첨부파일은 false : multipart/form-Data 로전송됨
				,contentType:false
				,success: function(result){
					alert("Uploaded");
					console.log("@# => result"+result);
					//파일정보를 함수로 보냄
					showUploadResult(result); //업로드 결과 처리 함수수
					console.log("@# => result2 업로드 결과 처리 함수"+result);
				}
			});//end of ajax
			function showUploadResult(uploadResultArr){
				if (!uploadResultArr||uploadResultArr.length==0) { 
					return;
					console.log("@# => !uploadResultAr ");
				}
				
				var uploadUL = $(".uploadResult ul");
				var str="";
				//반복시키면서 함수를 실행한다. 인덱스랑 객체 i , obj
				$(uploadResultArr).each(function(i,obj){
					// image type 인 경우에

					
					

					if(obj.image) {
						console.log("@# image type 인 경우");
						console.log("@# => 반복시키면서 함수를 실행 uploadResultArr ");
						//파일 기본값이 정리되어있다. 
						console.log("@# obj.uploadPath=>"+obj.uploadPath);
						console.log("@# obj.uploadPath=>"+obj.uploadPath);
						console.log("@# obj.uploadPath=>"+obj.uploadPath);

						// var fileCallPath = obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName;
						//썸네일 올라오는지 확인
						var fileCallPath = obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName;
						// str+="<li><div>";


						str+="<li data-path='"+obj.uploadPath+"'";
						str+="data-uuid='"+obj.uuid+"'";
						str+="data-filename='"+obj.fileName+"'";
						str+="data-type='"+obj.image+"'";
						str+="><div>";

						str+="<span>"+obj.fileName+"</span>";
						// 컨트롤러단에서 받을거다 fileName 으로 던질거다
						str += "<img src='/display?fileName="+fileCallPath+"'>";
						//str+="<img src='/display?fileName="+fileCallPath+"'>";//이미지 출력처리(컨트롤러단)
						// x 버튼 눌렀을때 삭제할거다
						str+="<span data-file=\'"+fileCallPath+"\'data-type='image'> x </span>";
						str+="</div></li>";

						console.log("@# fileCallPath =>"+fileCallPath);
						console.log("@# fileCallPath =>"+fileCallPath);
						console.log("@# fileCallPath =>"+fileCallPath);
						
					}else {// image type 인 경우가 아닐때
						// 경로를 패스하고 uuid에 플러스해서 슬래시 들어감
						// var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
						// 기본으로 보기
						console.log("@# image type 인 경우가 아닐때");
						var fileCallPath = obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName;
						// str+="<li><div>";

							str+="<li data-path='"+obj.uploadPath+"'";
							str+="data-uuid='"+obj.uuid+"'";
							str+="data-filename='"+obj.fileName+"'";
							str+="data-type='"+obj.image+"'";
							str+="><div>";

							str+="<span>"+obj.fileName+"</span>";
							str+="<img src='./resources/images/attach.png'>";
							str+="<span data-file=\'"+fileCallPath+"\'data-type='file'> x </span>";//이미지 출력처리(컨트롤러단)
							str+="</div></li>";
							console.log("@# 경로를 패스하고 uuid에 플러스");
						}
						
					});//end of each
					
				// 업로드 ul에 추가하겠다 위에 만든 str을
				console.log("@# str->"+str);

				// div class에 파일 목록 추가

				
				uploadUL.append(str);

				$(".uploadResult").on("click","span",function(){
					var targetFile = $(this).data("file");
					var type = $(this).data("type");
					var uploadResultItem = $(this).closest("li");

					console.log("@# targetFile"+targetFile);
					console.log("@# type"+type);
					console.log("@# uploadResultItem"+uploadResultItem);

					// 컨트롤러단에서 업로드된 실제파일 삭제
					$.ajax({
						type : "post"
						,data: {fileName : targetFile, type : type}
						,url:"deleteFile"
						// 리턴하는거없이 result로 받을거다
						,success:function(result){
							alert("뭐가 나왔는지."+result);
							// 브라우저에서 해당 썸네일이나 첨부파일 이미지 제거
							uploadResultItem.remove();

						}
					}); //end of ajax
				});//end of click(uploadResult)
			}
		});//end of change
	});//end of ready

</script>









