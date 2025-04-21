package com.boot.controller;

import java.net.http.HttpRequest;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

//import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.MemDTO;
import com.boot.service.MemService;
import com.mysql.cj.Session;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class MemController {
	@Autowired
	private MemService service;
	
	@RequestMapping("/login")
	public String login(Model model) {
		log.info("@# login()");
		
		return "login";
	}
	
	@RequestMapping("/login_yn")
//	public String loginYn(@RequestParam HashMap<String, String> param) {
	//세션 사용을 위해서 HttpServletRequest request - 세션 추가 할것임
		public String loginYn(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
		log.info("@# loginYn()");
		log.info("@# param=>"+param);
		
		//로그인 정보를 세션에 담음
		MemDTO dto = new MemDTO(param.get("mem_uid"), param.get("mem_pwd"), param.get("mem_name"));
		//저장이 안되면 null값이 오겠지요
		MemDTO mdto = null;
		log.info("@# mdto01=>"+mdto);
		
		HttpSession session = request.getSession();
		ArrayList<MemDTO> dtos = service.loginYn(param);
		
		log.info("@# mdto011=>"+mdto);
		if (dtos.isEmpty()) {
			log.info("@# mdto021=>"+mdto);
			return "redirect:login";
		} else {
			log.info("@# mdto022=>"+mdto);
			if (param.get("mem_pwd").equals(dtos.get(0).getMem_pwd())) {
				session.setAttribute("LOGIN_MEMBER", dto);
				//이름을 로그인 멤버로하고 뒤에 dto로그인정보로 
				//로그인성공시 사용자 정보를 세션에 저장한다.
				mdto = (MemDTO) session.getAttribute("LOGIN_MEMBER");
				log.info("@# mdto02=>"+mdto);
				//확인하기위해  mdto 생성
				
			
				
				return "redirect:login_ok";
			}
			return "redirect:login";
		}
	}
	
	@RequestMapping("/login_ok")
	public String login_ok() {
		log.info("@# login_ok()");
		
		return "login_ok";
	}
	
	@RequestMapping("/register")
	public String register() {
		log.info("@# register()");
		
		return "register";
	}
	
	@RequestMapping("/registerOk")
	public String registerOk(@RequestParam HashMap<String, String> param) {
		log.info("@# registerOk()");

		service.write(param);
		
		return "redirect:login";
	}
	
}









