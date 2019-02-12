/**
 * 
 */
package com.seeyon.ctp.portal.engine.model;

import java.util.List;

/**
 * 一个空间的组成
 * @author wangchw
 *
 */
public class PageLayoutSpace {

	private String id;
	
	private String name;
	
	private String description;
	
	private String theme;
	
	private String layoutType;
	
	private String htmlType;
	
	private String htmlContent;
	
	private String cssType;
	
	private String cssContent;
	
	private String customCss;
	
	private List<PageLayoutContainer> spaceData;

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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getTheme() {
		return theme;
	}

	public void setTheme(String theme) {
		this.theme = theme;
	}

	public String getLayoutType() {
		return layoutType;
	}

	public void setLayoutType(String layoutType) {
		this.layoutType = layoutType;
	}

	public String getHtmlType() {
		return htmlType;
	}

	public void setHtmlType(String htmlType) {
		this.htmlType = htmlType;
	}

	public String getHtmlContent() {
		return htmlContent;
	}

	public void setHtmlContent(String htmlContent) {
		this.htmlContent = htmlContent;
	}

	public String getCssType() {
		return cssType;
	}

	public void setCssType(String cssType) {
		this.cssType = cssType;
	}

	public String getCssContent() {
		return cssContent;
	}

	public void setCssContent(String cssContent) {
		this.cssContent = cssContent;
	}

	public String getCustomCss() {
		return customCss;
	}

	public void setCustomCss(String customCss) {
		this.customCss = customCss;
	}

	public List<PageLayoutContainer> getSpaceData() {
		return spaceData;
	}

	public void setSpaceData(List<PageLayoutContainer> spaceData) {
		this.spaceData = spaceData;
	} 
	
	
}
