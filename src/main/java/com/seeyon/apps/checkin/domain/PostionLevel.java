package com.seeyon.apps.checkin.domain;

import java.io.Serializable;

import com.seeyon.v3x.common.domain.BaseModel;

public class PostionLevel extends BaseModel implements Serializable {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	//职务级别id
	private String lid;
	
	//职务级别名称
	private String levelname;

	public String getLid() {
		return lid;
	}

	public void setLid(String lid) {
		this.lid = lid;
	}

	public String getLevelname() {
		return levelname;
	}

	public void setLevelname(String levelname) {
		this.levelname = levelname;
	}
	
	
}
