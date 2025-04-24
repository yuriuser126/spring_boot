package com.boot.service;

import java.util.List;

import com.boot.dto.BoardAttachDTO;

public interface UploadService {

	//boardattachdao 추가 파일 정보가지고오는거 이거임
	public List<BoardAttachDTO> getFileList(int boardNo);
	//파일 리스트를 받아와서 지우겠다. 여러개 삭제하기위해 리스트 사용
	public void deleteFiles(List<BoardAttachDTO> filList);
}
