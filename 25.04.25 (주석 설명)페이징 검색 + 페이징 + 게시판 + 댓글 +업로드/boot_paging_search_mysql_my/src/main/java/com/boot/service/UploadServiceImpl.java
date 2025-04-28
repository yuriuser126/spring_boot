package com.boot.service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.stereotype.Service;

import com.boot.dao.BoardAttachDAO;
import com.boot.dto.BoardAttachDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("UploadService")
public class UploadServiceImpl implements UploadService{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<BoardAttachDTO> getFileList(int boardNo) {
		log.info("@# boardNo->"+boardNo);
		BoardAttachDAO dao=sqlSession.getMapper(BoardAttachDAO.class);
		
		
		return dao.getFileList(boardNo);
	}

	//폴더에 저장된 파일들 삭제
	@Override
	public void deleteFiles(List<BoardAttachDTO> filList) {
		log.info("@# deleteFile filList->"+filList);
		
		if (filList == null || filList.size() ==0) {
			return;
		}
//		fileList : ㅣList로 선택안하면 안됨
		filList.forEach(attach -> {
			try {//삭제처리 경로를 가지고옴 / 람다식 attach에서 게터로 가져옴
				//Path : java.nio로 임포트
				
				Path file = Paths.get("C:\\develop\\upload\\"+attach.getUploadPath()+"\\"
															+attach.getUuid()+"_"
															+attach.getFileName());
				//파일이 존재하면 삭제하겠다.
				Files.deleteIfExists(file);
				 
				//썸네일 삭제(이미지 인경우)- 조건을 걸어야함
				//startsWith :이게 참이면 이미지다.
				if (Files.probeContentType(file).startsWith("image")) {
					
					Path thumbNail = Paths.get("C:\\develop\\upload\\"+attach.getUploadPath()+"\\s_"
							+attach.getUuid()+"_"
							+attach.getFileName());
					
					//썸네일 삭제
					log.info("@# thumbNail 삭제->"+thumbNail);
					Files.delete(thumbNail);
					
				}
			} catch (Exception e) {
				log.error("delete file error"+ e.getMessage());
			}
			
		});
		
		
		}			
		
	}






