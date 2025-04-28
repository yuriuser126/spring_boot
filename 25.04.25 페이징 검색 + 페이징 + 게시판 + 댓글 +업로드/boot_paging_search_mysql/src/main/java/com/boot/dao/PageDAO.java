package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.*;

public interface PageDAO {
//	Criteria 객체를 이용해서 페이징 처리
	public ArrayList<BoardDTO> listWithPaging(Criteria cri);
//	public int getTotalCount();
	public int getTotalCount(Criteria cri);
}















