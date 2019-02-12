/**
 * 
 */
package com.seeyon.ctp.portal.engine.model;

import java.util.List;
import java.util.Map;

/**
 * 页面容器，可以包含多个元件
 * @author wangchw
 *
 */
public class PageLayoutContainer {

	private String id;
	
	private String name;
	
	private Map<String,List<PageLayoutBox>> boxes;

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

	public Map<String,List<PageLayoutBox>> getBoxes() {
		return boxes;
	} 

	public void setBoxes(Map<String,List<PageLayoutBox>> boxes) {
		this.boxes = boxes;
	}
	
}
