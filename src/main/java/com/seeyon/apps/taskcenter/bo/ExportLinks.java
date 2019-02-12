package com.seeyon.apps.taskcenter.bo;

import java.io.Serializable;
import java.util.List;

import com.seeyon.apps.taskcenter.po.ProSenderUrl;

public class ExportLinks implements Serializable{
	private List<ProSenderUrl> linkList;

	public List<ProSenderUrl> getLinkList() {
		return linkList;
	}

	public void setLinkList(List<ProSenderUrl> linkList) {
		this.linkList = linkList;
	}
	
}
