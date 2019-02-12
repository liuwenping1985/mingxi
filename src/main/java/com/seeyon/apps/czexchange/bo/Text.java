package com.seeyon.apps.czexchange.bo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.thoughtworks.xstream.annotations.XStreamOmitField;

public class Text {
	
	@XStreamOmitField //隐藏属性
	private static final Log log = LogFactory.getLog(Text.class);

	private File file;

	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}
	
	
}
