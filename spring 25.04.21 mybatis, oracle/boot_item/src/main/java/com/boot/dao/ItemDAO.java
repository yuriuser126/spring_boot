package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.dto.*;

public interface ItemDAO {
	public void write(HashMap<String, String> param);
	public ArrayList<ItemDTO> list();
}
