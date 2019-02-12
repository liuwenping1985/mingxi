package com.seeyon.apps.czexchange.bo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamAsAttribute;
import com.thoughtworks.xstream.annotations.XStreamConverter;
import com.thoughtworks.xstream.annotations.XStreamOmitField;
import com.thoughtworks.xstream.converters.extended.ToAttributedValueConverter;


@XStreamConverter(value=ToAttributedValueConverter.class,strings={"fileName"})
@XStreamAlias("attachfile")
public class Attachfile {

	
	@XStreamOmitField //隐藏属性
	private static final Log log = LogFactory.getLog(Attachfile.class);
	
	@XStreamOmitField //隐藏属性
	private Long fileId;
	
	
    public Long getFileId() {
		return fileId;
	}

	public void setFileId(Long fileId) {
		this.fileId = fileId;
	}

	// 属性注解，此price就是book的属性，在XML中显示为：<book price="108">
    @XStreamAsAttribute()
    @XStreamAlias("attachname")
	private String attachname;

	public String getAttachname() {
		return attachname;
	}

	public void setAttachname(String attachname) {
		this.attachname = attachname;
	}
	
	private String fileName;

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}


	
	
}
