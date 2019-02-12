/**
 * 
 */
package com.seeyon.ctp.portal.engine.model;

/**
 * @author wangchw
 *
 */
public class PageLayoutSpaceLink {

	
	private String id;
	
	private String name;
	
	private int sort;
	
	private String catagory;
	
	private String style;

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

	public int getSort() {
		return sort;
	}

	public void setSort(int sort) {
		this.sort = sort;
	}

	public String getCatagory() {
		return catagory;
	}

	public void setCatagory(String catagory) {
		this.catagory = catagory;
	}

	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}
}
