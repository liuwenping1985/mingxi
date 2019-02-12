package com.seeyon.apps.czexchange.bo;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamImplicit;
import com.thoughtworks.xstream.annotations.XStreamOmitField;

public class Attach {

	@XStreamOmitField //隐藏属性
	private static final Log log = LogFactory.getLog(Attach.class);
	
	// 隐式集合，加上这个注解可以去掉book集合最外面的<list></list>这样的标记
	@XStreamImplicit
    @XStreamAlias("attachfile")
	private List<Attachfile> attachfile = new ArrayList<Attachfile>();

	public List<Attachfile> getAttachfile() {
		return attachfile;
	}

	public void setAttachfile(List<Attachfile> attachfile) {
		this.attachfile = attachfile;
	}


	
}
