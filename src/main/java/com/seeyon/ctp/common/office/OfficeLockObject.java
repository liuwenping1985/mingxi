package com.seeyon.ctp.common.office;

import java.io.Serializable;
import java.util.Date;

public class OfficeLockObject extends com.seeyon.ctp.util.ObjectToXMLBase implements Serializable
{	
	private static final long serialVersionUID = -8323204904970624986L;
	private String objId="";
	private String userName="";
	private Long userId=0L;
	private Date lastUpdateTime;
	private Boolean curEditState=false;	
	private String from ;
	
	
	
	public String getFrom() {
		return from;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public Long getUserId()
	{
		return this.userId;
	}
	
	public void setUserId(Long userId)
	{
		this.userId=userId;
	}
	
	public Boolean getCurEditState()
	{
		return this.curEditState;
	}
	
	public void setCurEditState(Boolean curEditState)
	{
		this.curEditState=curEditState;
	}
	
	public String getObjId()
	{
		return this.objId;
	}
	public String getUserName()
	{
		return this.userName;
	}
	public Date getLastUpdateTime()
	{
		return this.lastUpdateTime;
	}
	
	public void setObjId(String objId)
	{
		this.objId=objId;
	}
	public void setUserName(String userName)
	{
		this.userName=userName;
	}
	public void setLastUpdateTime(Date lastUpdateTime)
	{
		this.lastUpdateTime=lastUpdateTime;
	}
}