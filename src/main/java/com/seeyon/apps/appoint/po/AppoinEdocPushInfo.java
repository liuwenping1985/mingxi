package com.seeyon.apps.appoint.po;


import java.text.SimpleDateFormat;
import java.util.Date;

import com.seeyon.ctp.common.po.BasePO;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.XMLCoder;
public class AppoinEdocPushInfo extends BasePO{

	private static final long serialVersionUID = -6066634288203134086L;
	private String templateNumber;
	private String title;
	private Long summaryId;
	private Long affairId;
	private String infoId;
	private String infoStr;
	private String infoName;
	private String remark;
	private Date createDate;
    private Date finishDate;
    private boolean successflag  = false;
    private String ds_sequence;
    private String apifun;
    private int maxRetries = -1;
    public AppoinEdocPushInfo(){
    	
    }
    
	public AppoinEdocPushInfo(Long summaryId ,String title ,String templateNumber ,Object info,String remark ,boolean successflag) {
		this.setIdIfNew();
		this.summaryId = summaryId;
		this.title = title;
		this.templateNumber = templateNumber;
    	this.createDate = new Date(System.currentTimeMillis());
    	this.remark = remark;
		if(info !=null){
			this.setInfo(info);
			this.infoName = info.getClass().getSimpleName();
		}
		if(successflag){
			this.successflag = successflag;
			this.setFinishDate(DateUtil.newDate());
		}

	}
	
    public Long getAffairId() {
		return affairId;
	}

	public void setAffairId(Long affairId) {
		this.affairId = affairId;
	}

	public int getMaxRetries() {
		return maxRetries;
	}

	public void setMaxRetries(int maxRetries) {
		this.maxRetries = maxRetries;
	}

	public String getApifun() {
		return apifun;
	}

	public void setApifun(String apifun) {
		this.apifun = apifun;
	}

	public String getDs_sequence() {
		return ds_sequence;
	}

	public void setDs_sequence(String ds_sequence) {
		this.ds_sequence = ds_sequence;
	}

	public void pushTransLogSuccess(){
		this.successflag = true;
		this.setFinishDate(DateUtil.newDate());
    }
    public Long getSummaryId() {
		return summaryId;
	}

	public void setSummaryId(Long summaryId) {
		this.summaryId = summaryId;
	}

	public String getRemark() {
    	return remark;
    }
    
    public void setRemark(String remark) {
    	this.remark = remark;
    }
    public String getTemplateNumber() {
		return templateNumber;
	}

	public void setTemplateNumber(String templateNumber) {
		this.templateNumber = templateNumber;
	}

	public String getInfoName() {
    	return infoName;
    }
    public void setInfoName(String infoName) {
    	this.infoName = infoName;
    }

	public String getInfoStr() {
		return infoStr;
	}
	public void setInfoStr(String infoStr) {
		this.infoStr = infoStr;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public Date getFinishDate() {
		return finishDate;
	}
	public void setFinishDate(Date finishDate) {
		this.finishDate = finishDate;
	}
	public boolean isSuccessflag() {
		return successflag;
	}
	public void setSuccessflag(boolean successflag) {
		this.successflag = successflag;
	}

	public String getInfoId() {
		return infoId;
	}

	public void setInfoId(String infoId) {
		this.infoId = infoId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Object getInfo () {
    		if(Strings.isNotBlank(this.getInfoStr())){
    		return 	XMLCoder.decoder(this.getInfoStr());
    			
    		}else{
    			return null;
    		}
    		
	}
    public void setInfo (Object info) {
			String xml = XMLCoder.encoder(info);
			this.setInfoStr(xml);
	}
    public static void main(String[] args) {
    	Date date = new Date();
    	SimpleDateFormat sdf = new SimpleDateFormat();
    	sdf.applyPattern("yyyy-MM-dd HH:mm:ss");
    	String tmp = sdf.format(date);
		System.out.println(tmp);
		System.out.println(Datetimes.format(date, "yyyy-MM-dd HH:mm:ss"));
	}
}
