package com.seeyon.apps.cindaedoc.po;

import com.seeyon.v3x.common.domain.BaseModel;

public class EdocFileInfo extends BaseModel {

	private static final long serialVersionUID = -783325073718075939L;
	
	private Long edocId;
	private Long fileId;
	public Long getEdocId() {
		return edocId;
	}
	public void setEdocId(Long edocId) {
		this.edocId = edocId;
	}
	public Long getFileId() {
		return fileId;
	}
	public void setFileId(Long fileId) {
		this.fileId = fileId;
	}
}