package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.BoardAttachDTO;

//실행시 매퍼파일을 읽어 들이도록 지정
@Mapper
public interface BoardAttachDAO {
	//파일업로드는 파라미터를 DTO를 사용
	public void insertFile(BoardAttachDTO vo);
	public List<BoardAttachDTO> getFileList(int boardNo);
	//미리 추가해봄-정답
	public void deleteFile(String boardNo);
	
}















