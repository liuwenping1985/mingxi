package com.seeyon.apps.checkin.domain;

import java.io.Serializable;

import com.seeyon.v3x.common.domain.BaseModel;

/**
 * 部门
 * @author yangli
 *
 */
public class Department extends BaseModel implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	private String dmid;
	
	private String dmname;
	
	private String path;

	public String getDmid() {
		return dmid;
	}

	public void setDmid(String dmid) {
		this.dmid = dmid;
	}

	public String getDmname() {
		return dmname;
	}

	public void setDmname(String dmname) {
		this.dmname = dmname;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}
	
	

}
