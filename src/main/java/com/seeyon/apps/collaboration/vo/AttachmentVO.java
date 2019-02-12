package com.seeyon.apps.collaboration.vo;

import java.util.Comparator;
import java.util.Date;

public class AttachmentVO implements Comparator<AttachmentVO>{
	/**
	 * fileType 为文件后缀
	 */
	private String fileType;
	private String fileName;
	
	private String fileFullName;
	
	public String getFileFullName() {
		return fileFullName;
	}
	public void setFileFullName(String fileFullName) {
		this.fileFullName = fileFullName;
	}
	private String fileSize;
	private String userName;
	/**
	 * fromType 来源[发起人上传、处理人回复、表单控件、附言补充]
	 */
	private String fromType;
	private Date uploadTime;
	private String fileUrl;
	/**
	 * canLook 是否可查看(只有office格式才有查看功能)
	 */
	private boolean canLook;
	
	private String v;
	
	//客开 start
	private int sort;
	private int attType;
	private String mimeType;
	private Long reference;
	private Integer category;
	private String description;
	
  	public int getSort() {
  	  return sort;
  	}
  	public void setSort(int sort) {
  	  this.sort = sort;
  	}
  	
  	public int getAttType() {
  	  return attType;
  	}
  	public void setAttType(int attType) {
  	  this.attType = attType;
  	}
  	
  	public String getMimeType() {
  	  return mimeType;
  	}
  	public void setMimeType(String mimeType) {
  	  this.mimeType = mimeType;
  	}
  	
  	public Long getReference() {
  	  return reference;
  	}
  	public void setReference(Long reference) {
  	  this.reference = reference;
  	}
  	
  	public Integer getCategory() {
  	  return category;
  	}
  	public void setCategory(Integer category) {
  	  this.category = category;
  	}
  	
  	public String getDescription() {
  	  return description;
  	}
  	public void setDescription(String description) {
  	  this.description = description;
  	}
  	
	//客开 end
	
  /**
	 * 是否被当前用户收藏
	 */
	private boolean isCollect;
	
	
	public boolean isCollect() {
        return isCollect;
    }
    public void setCollect(boolean isCollect) {
        this.isCollect = isCollect;
    }
    public String getV() {
        return v;
    }
    public void setV(String v) {
        this.v = v;
    }
    public boolean isCanLook() {
		return canLook;
	}
	public void setCanLook(boolean canLook) {
		this.canLook = canLook;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFileSize() {
		return fileSize;
	}
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getFromType() {
		return fromType;
	}
	public void setFromType(String fromType) {
		this.fromType = fromType;
	}
	public Date getUploadTime() {
		return uploadTime;
	}
	public void setUploadTime(Date uploadTime) {
		this.uploadTime = uploadTime;
	}
	public String getFileUrl() {
		return fileUrl;
	}
	public void setFileUrl(String fileUrl) {
		this.fileUrl = fileUrl;
	}
	@Override
	public int compare(AttachmentVO vo1, AttachmentVO vo2) {
	    //客开 start
		/*//附件列表需倒序
		Date d1=vo1.getUploadTime();
		Date d2=vo2.getUploadTime();
		int res=0;
		if(d1!=null&&d2!=null){
			res=d1.compareTo(d2);
		}else if(d1 == null&&d2!=null){
			res=-1;
		}else if(d1!=null&&d2 == null){
			res=1;
		}
		return res==0?0:res>0?-1:1;*/
  	    int v1 = vo1.getSort();
        int v2 = vo2.getSort();
        return v2 > v1 ? 1 : -1;
        //客开 end
	}
	
}
