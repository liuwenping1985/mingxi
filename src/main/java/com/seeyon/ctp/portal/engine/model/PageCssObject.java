/**
 * 
 */
package com.seeyon.ctp.portal.engine.model;

/**
 * @author wangchw
 *
 */
public class PageCssObject {

	private String type;
	
	private String path;
	
	private String content;
	
	private String custom;

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getCustom() {
		return custom;
	}

	public void setCustom(String custom) {
		this.custom = custom;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}
}
