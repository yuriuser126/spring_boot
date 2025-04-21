package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.BoardDTO;
import com.boot.dto.MemDTO;
import com.boot.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class BoardController {
	@Autowired
	private BoardService service;
	
	@RequestMapping("/list")
//	public String list(Model model) {
		public String list(Model model,HttpServletRequest request) {
		log.info("@# list()");
		//세션, null일때 여기 넘어오는지
		//httpservlet request추가 아래 세줄 추가
		HttpSession session = request.getSession();
		MemDTO mdto = (MemDTO) session.getAttribute("LOGIN_MEMBER");
		log.info("@# list mdto=>"+mdto);
		
		//세션 정보 없으면 로그인 화면으로 이동하도록 추가
		if (mdto == null) {
			return "redirect:login";
		}
		
		ArrayList<BoardDTO> list = service.list();
		model.addAttribute("list", list);
		
		return "list";
	}
	
	@RequestMapping("/write")
	public String write(@RequestParam HashMap<String, String> param) {
		log.info("@# write()");
		
		service.write(param);
		
		return "redirect:list";
	}
	
	@RequestMapping("/write_view")
	public String write_view() {
		log.info("@# write_view()");
		
		return "write_view";
	}
	
	@RequestMapping("/content_view")
//	public String content_view(@RequestParam HashMap<String, String> param, Model model) {
		public String content_view(@RequestParam HashMap<String, String> param, Model model,HttpServletRequest request) {
		log.info("@# content_view()");
		
		HttpSession session = request.getSession();
		MemDTO mdto = (MemDTO) session.getAttribute("LOGIN_MEMBER");
		log.info("@# content mdto=>"+mdto);
		
		//세션 정보 없으면 로그인 화면으로 이동하도록 추가
		if (mdto == null) {
			return "redirect:login";
		}
		
		
		BoardDTO dto = service.contentView(param);
		model.addAttribute("content_view", dto);
		
		return "content_view";
	}
	
	@RequestMapping("/modify")
	public String modify(@RequestParam HashMap<String, String> param) {
		log.info("@# modify()");
		
		service.modify(param);
		
		return "redirect:list";
	}
	
	@RequestMapping("/delete")
	public String delete(@RequestParam HashMap<String, String> param) {
		log.info("@# delete()");
		
		service.delete(param);
		
		return "redirect:list";
	}
}







