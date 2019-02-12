package com.seeyon.apps.czexchange.bo;

import javax.persistence.Convert;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamAsAttribute;
import com.thoughtworks.xstream.annotations.XStreamConverter;
import com.thoughtworks.xstream.annotations.XStreamOmitField;
import com.thoughtworks.xstream.converters.extended.ToAttributedValueConverter;


@XStreamConverter(value=ToAttributedValueConverter.class,strings={"fileName"})
public class File {
	
	@XStreamOmitField //隐藏属性
	private static final Log log = LogFactory.getLog(File.class);
    @XStreamAsAttribute()
    @XStreamAlias("attachname")
	private String attachname;

    private String fileName;
    

	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getAttachname() {
		return attachname;
	}
	public void setAttachname(String attachname) {
		this.attachname = attachname;
	}

}
