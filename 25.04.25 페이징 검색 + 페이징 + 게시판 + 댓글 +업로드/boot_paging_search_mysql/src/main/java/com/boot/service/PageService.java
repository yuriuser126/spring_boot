package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.dto.*;

public interface PageService {
	public ArrayList<BoardDTO> listWithPaging(Criteria cri);
//	public int getTotalCount();
	public int getTotalCount(Criteria cri);
}
