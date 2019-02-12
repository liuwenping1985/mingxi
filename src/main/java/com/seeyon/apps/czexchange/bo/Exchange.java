package com.seeyon.apps.czexchange.bo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.thoughtworks.xstream.annotations.XStreamOmitField;

public class Exchange {

	@XStreamOmitField //隐藏属性
	private static final Log log = LogFactory.getLog(Exchange.class);
	
    private String sendcode;
    private String sender;
    private String sendtime;
    private String receivecode;
    private String receive;
    private String gwcode;
    private String flag;
	public String getSendcode() {
		return sendcode;
	}
	public void setSendcode(String sendcode) {
		this.sendcode = sendcode;
	}
	public String getSender() {
		return sender;
	}
	public void setSender(String sender) {
		this.sender = sender;
	}
	public String getSendtime() {
		return sendtime;
	}
	public void setSendtime(String sendtime) {
		this.sendtime = sendtime;
	}
	public String getReceivecode() {
		return receivecode;
	}
	public void setReceivecode(String receivecode) {
		this.receivecode = receivecode;
	}
	public String getReceive() {
		return receive;
	}
	public void setReceive(String receive) {
		this.receive = receive;
	}
	public String getGwcode() {
		return gwcode;
	}
	public void setGwcode(String gwcode) {
		this.gwcode = gwcode;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
    
    
}
