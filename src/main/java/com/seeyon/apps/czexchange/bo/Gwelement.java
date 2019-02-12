package com.seeyon.apps.czexchange.bo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamOmitField;

public class Gwelement {
	
	@XStreamOmitField //隐藏属性
	private static final Log log = LogFactory.getLog(Gwelement.class);

    private String title;
    private String wenhao;
    private String jinji;
    private String miji;
    private String baosonguser;
    private String baosongname;
    private String nianxian;
    private String person_liable;
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getWenhao() {
		return wenhao;
	}
	public void setWenhao(String wenhao) {
		this.wenhao = wenhao;
	}
	public String getJinji() {
		return jinji;
	}
	public void setJinji(String jinji) {
		this.jinji = jinji;
	}
	public String getMiji() {
		return miji;
	}
	public void setMiji(String miji) {
		this.miji = miji;
	}
	public String getBaosonguser() {
		return baosonguser;
	}
	public void setBaosonguser(String baosonguser) {
		this.baosonguser = baosonguser;
	}
	public String getBaosongname() {
		return baosongname;
	}
	public void setBaosongname(String baosongname) {
		this.baosongname = baosongname;
	}
	public String getNianxian() {
		return nianxian;
	}
	public void setNianxian(String nianxian) {
		this.nianxian = nianxian;
	}
	public String getPerson_liable() {
		return person_liable;
	}
	public void setPerson_liable(String person_liable) {
		this.person_liable = person_liable;
	}
    
    
    
}
