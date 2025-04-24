package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.BoardAttachDTO;
import com.boot.dto.BoardDTO;
import com.boot.dto.CommentDTO;
import com.boot.service.BoardService;
import com.boot.service.CommentService;
import com.boot.service.UploadService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class BoardController {
	@Autowired
	private BoardService service;
	
	@Autowired
	private CommentService commentService;
	
	@Autowired
	private UploadService uploadService;
	
	@RequestMapping("/list")
	public String list(Model model) {
		log.info("@# list()");
		
		ArrayList<BoardDTO> list = service.list();
		model.addAttribute("list", list);
		
		return "list";
	}
	
	@RequestMapping("/write")
//	public String write(@RequestParam HashMap<String, String> param) {
		public String write(BoardDTO boardDTO) {
		//왜 보드디티오로 바꿔놨지. 값을 가져오려고?
		log.info("@# write()");
		log.info("@# boardDTO()->"+boardDTO);
		
		if (boardDTO.getAttachList() != null) {
			//람다식으로 로그를 찍어봄
			boardDTO.getAttachList().forEach(attach -> log.info("@# attach=>"+attach));
		}
//		service.write(param);
		//파라미터 바꿨으니까 보드디티오로 받아온다. 변경. 게시글 테이블+파일 추가한것까지
		service.write(boardDTO);
		log.info("@# service board DTO=>");
		
		return "redirect:list";
	}
	
	@RequestMapping("/write_view")
	public String write_view() {
		log.info("@# write_view()");
		
		return "write_view";
	}
	
	@RequestMapping("/content_view")
	public String content_view(@RequestParam HashMap<String, String> param, Model model) {
		log.info("@# content_view()");
		
		BoardDTO dto = service.contentView(param);
		model.addAttribute("content_view", dto);
		
		ArrayList<CommentDTO> commentList = commentService.findAll(param);
		model.addAttribute("commentList",commentList);
		log.info("@# commentList()"+commentList);
		
		return "content_view";
	}
	
	@RequestMapping("/modify")
	public String modify(@RequestParam HashMap<String, String> param) {
		log.info("@# modify()");
		
		service.modify(param);
		
		return "redirect:list";
	}
	
	@RequestMapping("/delete")
	//파람에 보드넘버가 있음.
	public String delete(@RequestParam HashMap<String, String> param) {
		log.info("@# delete()");
		log.info("@# param()"+param);
		//service단에서 확인하면 된다. 파람에서 게터 가지고오는거
		log.info("@# param()"+param.get("boardNo"));
		
		List<BoardAttachDTO> fileList = uploadService.getFileList(Integer.parseInt(param.get("boardNo")));
		log.info("@# fileList"+fileList);
		
		//게시글 삭제
		service.delete(param);
		//서비스단 호출해서 폴더 삭제
		uploadService.deleteFiles(fileList);
		//댓글삭제
		//?
		
		return "redirect:list";
	}
}







