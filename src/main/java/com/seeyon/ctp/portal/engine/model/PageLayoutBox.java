/**
 * 
 */
package com.seeyon.ctp.portal.engine.model;

/**
 * @author wangchw
 *
 */
public class PageLayoutBox {

	private String id;
	
	private String width;
	
	private String height;
	
	private String widthUnit;
	
	private String heightUnit;
	
	private String align;
	
	private PageLayoutComponent component;
	
	private String col;
	
	private String row;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getWidth() {
		return width;
	}

	public void setWidth(String width) {
		this.width = width;
	}

	public String getHeight() {
		return height;
	}

	public void setHeight(String height) {
		this.height = height;
	}

	public String getWidthUnit() {
		return widthUnit;
	}

	public void setWidthUnit(String widthUnit) {
		this.widthUnit = widthUnit;
	}

	public String getHeightUnit() {
		return heightUnit;
	}

	public void setHeightUnit(String heightUnit) {
		this.heightUnit = heightUnit;
	}

	public PageLayoutComponent getComponent() {
		return component;
	}

	public void setComponent(PageLayoutComponent component) {
		this.component = component;
	}

	public String getCol() {
		return col;
	}

	public void setCol(String col) {
		this.col = col;
	}

	public String getRow() {
		return row;
	}

	public void setRow(String row) {
		this.row = row;
	}

	public String getAlign() {
		return align;
	}

	public void setAlign(String align) {
		this.align = align;
	}
}
