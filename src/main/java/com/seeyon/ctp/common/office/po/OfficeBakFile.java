package com.seeyon.ctp.common.office.po;

import com.seeyon.ctp.common.po.BasePO;

/**
 * 性能优化--增加一个关系表
 * @author Administrator
 *
 */
public class OfficeBakFile extends BasePO{
	
	/**
	 * 备份数据的ID
	 */
	private java.lang.Long _fileId;
	/**
	 * 原文件ID
	 */
	private java.lang.Long _sourceId;
	
	
	public OfficeBakFile () {
	    initialize();
	  }

	/**
	 * Constructor for primary key
	 */
	public OfficeBakFile(java.lang.Long _id) {
		this.setId(_id);
		initialize();
	}

	protected void initialize() {
	}
	
	/**
	 * 备份文件的ID
	 */
	public java.lang.Long getFileId() {
		return _fileId;
	}
	
	/**
	 * 备份文件的ID
	 */
	public void setFileId(java.lang.Long _fileId) {
		this._fileId = _fileId;
	}
	
	/**
	 * 原文件ID
	 */
	public java.lang.Long getSourceId() {
		return _sourceId;
	}
	
	/**
	 * 原文件ID
	 */
	public void setSourceId(java.lang.Long _sourceId) {
		this._sourceId = _sourceId;
	}
	
	
}
