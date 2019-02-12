package com.seeyon.apps.checkin.domain;

import java.io.Serializable;

import com.seeyon.v3x.common.domain.BaseModel;

public class NoStaticCheckinDept extends BaseModel implements Serializable{
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;



	private String deid ;
	
	
	
	private String departname;



	


	public String getDeid() {
		return deid;
	}



	public void setDeid(String deid) {
		this.deid = deid;
	}



	public String getDepartname() {
		return departname;
	}



	public void setDepartname(String departname) {
		this.departname = departname;
	}

		
	
}
