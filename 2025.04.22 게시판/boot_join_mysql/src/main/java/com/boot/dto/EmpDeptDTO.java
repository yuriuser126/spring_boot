package com.boot.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EmpDeptDTO {
//	조인을 아래와 같은 형식으로 많이 사용한다.
//	xml 정보 뿐만 아니라 전체 테이블의 칼럼을 정의(개발시 유연성 : DTO 공유등)
//	pk 우선위주로
//	emp table
	private int empno;
	private String ename;
	private String job;
	private int mgr;
	private Timestamp hiredate;
	private int sal;
	private int comm;
	
//	dept table
	private int deptno;
	private String dname;
	private String loc;
}

