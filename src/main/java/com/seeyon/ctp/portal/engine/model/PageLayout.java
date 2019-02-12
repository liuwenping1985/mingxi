/**
 * 
 */
package com.seeyon.ctp.portal.engine.model;

import java.util.List;

/**
 * 页面布局
 * @author wangchw
 *
 */
public class PageLayout {

	private String id;
	
	private String name;
	
	private String description;
	
	/**
	 * 布局模板ID
	 */
	private String layoutTempleteId;
	
	private List<PageLayoutContainer> pageData; 
	
	private List<PageLayoutSpaceLink> spaceLinks;
	
	private String spaceStyle;

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

	public List<PageLayoutContainer> getPageData() {
		return pageData;
	}

	public void setPageData(List<PageLayoutContainer> pageData) {
		this.pageData = pageData;
	}

	public List<PageLayoutSpaceLink> getSpaceLinks() {
		return spaceLinks;
	}

	public void setSpaceLinks(List<PageLayoutSpaceLink> spaceLinks) {
		this.spaceLinks = spaceLinks;
	}

	public String getSpaceStyle() {
		return spaceStyle;
	}

	public void setSpaceStyle(String spaceStyle) {
		this.spaceStyle = spaceStyle;
	}

	public String getLayoutTempleteId() {
		return layoutTempleteId;
	}

	public void setLayoutTempleteId(String layoutTempleteId) {
		this.layoutTempleteId = layoutTempleteId;
	}

}
