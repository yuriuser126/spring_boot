package com.boot.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.boot.dto.BoardAttachDTO;
import com.boot.service.UploadService;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Slf4j
//@RequestMapping("/comment")
public class UploadController {
	
	@Autowired
	private UploadService service;

	
	@PostMapping("/uploadAjaxAction")
//	uploadFile 이름으로 multipartfile 파라미터 사용
		public ResponseEntity<List<BoardAttachDTO>> uploadAjaxPost(MultipartFile[] uploadFile)  {
		log.info("@# uploadAjaxAction()");
		
		List<BoardAttachDTO> list = new ArrayList<BoardAttachDTO>();
		String uploadFolder = "C:\\develop\\upload";
//		날짜별 폴더 생성
		String uploadFolderPath = getFolder();
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		log.info("@# =>uploadPath"+uploadPath);
		
		if (uploadPath.exists()==false) {
			// make yyyy/MM/dd folder
			uploadPath.mkdirs();
		}
		
		for (MultipartFile multipartFile : uploadFile) {
			log.info("=============================");
			log.info("@# multipartFile(첨부파일) : uploadFile");
//			getOriginalFilename : 업로드 되는 파일 이름
			log.info("@# 업로드 되는 파일 이름=>"+multipartFile.getOriginalFilename());
//			getSize : 업로드 되는 파일 크기
			log.info("@# 업로드 되는 파일 크기=>"+multipartFile.getSize());
			
			String uploadFileName = multipartFile.getOriginalFilename();
			//중복방지 위해 만든 uuid
			UUID uuid = UUID.randomUUID();
			log.info("@# uuid =>"+uuid);
			
			BoardAttachDTO boardAttachDTO = new BoardAttachDTO();
			boardAttachDTO.setFileName(uploadFileName);
			boardAttachDTO.setUuid(uuid.toString());
			boardAttachDTO.setUploadPath(uploadFolderPath);
			log.info("@# boardAttachDTO 01=>"+boardAttachDTO);
			
			//썸네일 작업 / 판단을 해서 가지고 오기위해 언더바를 붙여서 가져옴
			uploadFileName = uuid.toString() + "_"+uploadFileName;
			log.info("@# uuid+ uploadFileName=>"+uploadFileName);
			
//			saveFile : 경로하고 파일이름
			File saveFile = new File(uploadPath, uploadFileName);
//			썸네일을 참조하기 위한 참조변수 : fis / 
			FileInputStream fis = null;
			
			//다운안될시 캐치문
			try {// 저장 시킨다 / 해당되는 경로에 업로드한다
//				transferTo : saveFile 내용을 저장
				multipartFile.transferTo(saveFile);
				
				//참이면 이미지 파일이다 / 이미지 일때 썸네일 나오도록
				if (checkImageType(saveFile)) {
					boardAttachDTO.setImage(true);
					log.info("@# boardAttachDTO 02=>"+boardAttachDTO);
					
					fis = new FileInputStream(saveFile);
					
//					썸네일 구성
//					썸네일 파일은 s_ 를 앞에 추가
					FileOutputStream thumnail = new FileOutputStream(new File(uploadPath , "s_"+uploadFileName));
//					썸네일 저장
//					가로 100/세로100 크기로 생성
					Thumbnailator.createThumbnail(fis, thumnail, 100,100);
					log.info("@# 썸네일 저장 ");
					
				}
//				리스트+상태코드 http
				list.add(boardAttachDTO);
				log.info("@# 파일정보 담음 리스트+상태코드 http boardAttachDTO 상태코드 다붙인거 "+boardAttachDTO);
				
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				try {
					if (fis != null)  fis.close();
				} catch (Exception e2) {
					e2.printStackTrace();
				}
				//이거 추가 안해놓으면 자원반납안되서 계속 열려있다.
			}
		}//end of for
//		return null;
//		파일정보들을 list 객체에 담고 , http 상태값은 정상으로 리턴
		log.info("@# 썸네일 저장된거 리턴 ");
		return new ResponseEntity<List<BoardAttachDTO>>(list, HttpStatus.OK);
		}
	
//	날짜별 폴더 생성
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		log.info( "@# str=>"+str);
		return str;
	}
	
//	이미지 여부체크
	public boolean checkImageType(File file) {
		try {
//			이미지 파일인지 체크하기위한 타입(probeContentType)
			String contentType = Files.probeContentType(file.toPath());
			log.info( "@# contentType=>"+contentType);
			
//			startsWith : 파일종류를 판단한다. 참이면 이미지가 된다.
//			return contentType.startsWith("images");
			return contentType.startsWith("image");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false; //거짓이면 이미지 파일이 아님
	}
	
//		이미지 파일을 받아서 화면에 출력하는 메소드 입니다.(byte 배열타입)
//	default니까 겟매핑 ?? fileName : vscode에서 들어옴
//	str+="<img src='/display?fileName"+fileCallPath+"'>";
	


	@GetMapping("/display")
	public ResponseEntity<byte[]> getFile(String fileName) {
		log.info( "@# display / fileName=>"+fileName);
		
		File file = new File("C:\\develop\\upload\\"+fileName);
		log.info( "@# 경로에 들어갔는지 file=>"+file);
		
		ResponseEntity<byte[]> result = null;
		HttpHeaders headers = new HttpHeaders();
		
		try {
			//파일 타입을 헤더에 추가 : probeContentType ->  file.toPath
			headers.add("Content-Type", Files.probeContentType(file.toPath()));
//			최종 이미지 파일 어떻게 출력할거냐면
			// 파일정보를 byte 배열로 복사 +헤더정보+http상태 정상을 결과에 저장
			// 파일정보,헤더,http
			log.info( "@# 파일 타입을 헤더에 추가 Content-Type header");
			log.info( "@# file"+file);
			log.info( "@# headers"+headers);
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), headers, HttpStatus.OK);
//			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), headers, HttpStatus.OK);
//			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), headers, HttpStatus.OK);
			log.info( "@# result"+result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
		
	}
	
	
	@PostMapping("/deleteFile")
//	삭제되었다고 메세지 처리할거라서 제네릭 타입 스트링
		public ResponseEntity<String> deleteFile(String fileName, String type)  {
		log.info( "@# deleteFile 메소드 -> fileName"+fileName);
//		참조변수 하나 만듬
		File file;
		
//		삭제 예외처리
		try {
//			URLDecoder.decode : 서버에 올라간 파일을 삭제하기 위해서 디코딩
			file = new File("C:\\develop\\upload\\"+URLDecoder.decode(fileName, "UTF-8"));
			log.info( "@# 경로에 들어갔는지 file=>"+file);
			file.delete();
			log.info( "@# file.delete() 파일 삭제 썸네일은 아님");
			
			//이미지 파일이면 썸네일도 삭제
			if (type.equals("image")) {
//				getAbsolutePath() : 절대경로(full path)에서 s언더바를 없앰
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				log.info( "@# 이미지 파일 썸네일 삭제 if문");
				log.info( "@# largeFileName=>"+largeFileName);
				
				file = new File(largeFileName);
				file.delete();
				log.info( "@# file.delete() 썸네일 삭제임");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
//			삭제를 못하겠다. 예외 오류 발생시 not found처리
			log.info( "@# deleteFile 메소드 HttpStatus.NOT_FOUND"+fileName);
			return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
		}
		//삭제되었으니 deleted 보내고 httpstatus ok로 답
		//deleted : success의 result로 전송한다.
		log.info( "@# deleted : success의 result로 전송");
		return new ResponseEntity<String>("deleted",HttpStatus.OK);
	}
	
	
	
	@GetMapping("/getFileList")
//		public ResponseEntity<List<BoardAttachDTO>> getFileList(int boardNo) {
	//파람에 글번호를 들고온다.
	public ResponseEntity<List<BoardAttachDTO>> getFileList(@RequestParam HashMap<String, String> param) {
		log.info( "@# getFileList / param=>"+param);
		
//		String vo = param.get("boardNo");
		param.get("boardNo");
		
//		log.info( "@# vo=>"+vo);
		log.info( "@# boardNo)=>"+param.get("boardNo"));
		
//		BoardDTO dto = service.contentView(param);
		
//		BoardAttachDTO dto = service.getFileList((Integer.parseInt(param.get("boardNo")));
		service.getFileList(Integer.parseInt(param.get("boardNo")));
		
		
		
//		return null;
		//new 객체로 만들어줘야 리턴이 된다.
		return new ResponseEntity<>(service.getFileList(Integer.parseInt(param.get("boardNo"))),HttpStatus.OK);
	}
	
	@GetMapping("/download")
	public ResponseEntity<Resource> download(String fileName) {
		log.info( "@# download / fileName=>"+fileName);
		
	//파라미터 하나짜리
	//	파일을 리소스(자원)으로 변경. 파일을 비트값으로 전환
		Resource resource =  new FileSystemResource("C:\\develop\\upload\\"+fileName);
		log.info( "@# download / resource=>"+resource);
		
//		리소스에서 파일명을 찾아서 변수에 저장
		String resourceName = resource.getFilename();
		
		//uuid처리 "_"기준 뒤로 substring 파라미터 string 타입 하나짜리
		
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);
		
		HttpHeaders headers = new HttpHeaders();
		
		//문제가 생길수 있으니 try catch문
		try {
			//파일 다운로드 정보를 추가한거다.
			//헤더에 
			//resourceOriginalName 요 파일네임에 받아올거다 getbyte 한글처리 , get charest선택
			headers.add("Content-Disposition"
					, "attachment; filename="
					+new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
//		윈도우 다운로드시 필요한 정보(리소스,헤더 , 상태 OK)
		return new ResponseEntity<Resource>(resource, headers,HttpStatus.OK);
		
	}
	
	
	
	}
	
	








