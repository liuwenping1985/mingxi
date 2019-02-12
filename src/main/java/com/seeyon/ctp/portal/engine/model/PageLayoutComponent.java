/**
 * 
 */
package com.seeyon.ctp.portal.engine.model;

import java.util.List;

import com.seeyon.ctp.portal.engine.templete.PortalTplVar;

/**
 * 页面元件
 * @author wangchw
 *
 */
public class PageLayoutComponent {

	private String id;
	
	private String scid;
	
	private String name;
	
	private String beanId;
	
	private String tplName;
	
	private String defaultStyle;
	
	private String htmlContent;
	
	private List<PortalTplVar> tplVars;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getBeanId() {
		return beanId;
	}

	public void setBeanId(String beanId) {
		this.beanId = beanId;
	}

	public List<PortalTplVar> getTplVars() {
		return tplVars;
	}

	public void setTplVars(List<PortalTplVar> tplVars) {
		this.tplVars = tplVars;
	}

	public String getTplName() {
		return tplName;
	}

	public void setTplName(String tplName) {
		this.tplName = tplName;
	}

	public String getDefaultStyle() {
		return defaultStyle;
	}

	public void setDefaultStyle(String defaultStyle) {
		this.defaultStyle = defaultStyle;
	}

	public String getScid() {
		return scid;
	}

	public void setScid(String scid) {
		this.scid = scid;
	}

	public String getHtmlContent() {
		return htmlContent;
	}

	public void setHtmlContent(String htmlContent) {
		this.htmlContent = htmlContent;
	}
}
