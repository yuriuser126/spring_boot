package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.dto.*;

public interface ItemService {
	public void write(HashMap<String, String> param);
	public ArrayList<ItemDTO> list();
}
