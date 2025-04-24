package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.BoardAttachDAO;
import com.boot.dao.BoardDAO;
import com.boot.dto.BoardDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("BoardService")
public class BoardServiceImpl implements BoardService{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public ArrayList<BoardDTO> list() {
		BoardDAO dao=sqlSession.getMapper(BoardDAO.class);
		ArrayList<BoardDTO> list = dao.list();
		return list;
	}

	@Override
//	public void write(HashMap<String, String> param) {
//	파일 업로드는 파라미터 DTO를 사용한다.
		public void write(BoardDTO boardDTO) {
		log.info("BoardServiceImpl-boardDTO"+boardDTO);
		
		BoardDAO dao=sqlSession.getMapper(BoardDAO.class);
		BoardAttachDAO adao=sqlSession.getMapper(BoardAttachDAO.class);
		
//		dao.write(param);
		dao.write(boardDTO);
		
		//첨부파일 있는지 체크
		log.info("첨부파일 있는지 체크 serviceimpl write method");
		log.info("BoardServiceImpl-boardDTO"+boardDTO.getAttachList());
		if (boardDTO.getAttachList() == null || boardDTO.getAttachList().size()==0) {
			log.info("@# null");
			return;
		}
		
//		첨부파일 있으면 탄다 / 반복할거다 람다식으로
//		첨부파일이 있는경우 처리
		//DAO쪽 처리를 잘해야한다.
		boardDTO.getAttachList().forEach(attach -> {
		log.info("@# 첨부파일이 있는경우 처리");
//		글번호가 없음 , attach로 넣어준다.
		attach.setBoardNo(boardDTO.getBoardNo());
//		파일을 넣어줄건데 attach를 가져가야한다.
		adao.insertFile(attach);
			
		});
	}
	
	@Override
	public BoardDTO contentView(HashMap<String, String> param) {
		BoardDAO dao=sqlSession.getMapper(BoardDAO.class);
		BoardDTO dto = dao.contentView(param);
		
		return dto;
	}

	@Override
	public void modify(HashMap<String, String> param) {
		BoardDAO dao=sqlSession.getMapper(BoardDAO.class);
		dao.modify(param);
	}

	@Override
	public void delete(HashMap<String, String> param) {
		log.info("delete-param"+param);
		BoardDAO dao=sqlSession.getMapper(BoardDAO.class);
		BoardAttachDAO attachDAO =sqlSession.getMapper(BoardAttachDAO.class);
		
		//게시글 삭제
		dao.delete(param);
		// 댓글 테이블 삭제
		log.info("첨부파일 테이블 삭제");
		attachDAO.deleteFile(param.get("boardNo"));
	}

}




