package com.seeyon.apps.czexchange.bo;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.czexchange.util.CzOrgUtil;
import com.seeyon.apps.czexchange.util.XMLUtil;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.v3x.common.web.login.CurrentUser;
import com.seeyon.v3x.exchange.domain.EdocSendDetail;
import com.seeyon.v3x.exchange.domain.EdocSendRecord;
import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamOmitField;

@XStreamAlias("elecdocument")
public class Elecdocument {

	
	@XStreamOmitField //隐藏属性
	private static final Log log = LogFactory.getLog(Elecdocument.class);
	@XStreamOmitField //隐藏属性
	private Long formId;
	@XStreamOmitField //隐藏属性
	private Long relationId;
	@XStreamOmitField //隐藏属性
	private String msgId;
	
	@XStreamOmitField //隐藏属性
	private String accountId;
	

	private Exchange exchange = new Exchange();
	private Gwelement gwelement =new Gwelement();;
	private Text text = new Text();
	private Attach attach = new Attach();
	
	
	public String getAccountId() {
		return accountId;
	}
	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}
	public String getMsgId() {
		return msgId;
	}
	public void setMsgId(String msgId) {
		this.msgId = msgId;
	}
	public Long getRelationId() {
		return relationId;
	}
	public void setRelationId(Long relationId) {
		this.relationId = relationId;
	}
	public Long getFormId() {
		return formId;
	}
	public void setFormId(Long formId) {
		this.formId = formId;
	}
	public Exchange getExchange() {
		return exchange;
	}
	public void setExchange(Exchange exchange) {
		this.exchange = exchange;
	}
	public Gwelement getGwelement() {
		return gwelement;
	}
	public void setGwelement(Gwelement gwelement) {
		this.gwelement = gwelement;
	}
	public Text getText() {
		return text;
	}
	public void setText(Text text) {
		this.text = text;
	}
	public Attach getAttach() {
		return attach;
	}
	public void setAttach(Attach attach) {
		this.attach = attach;
	}
	
	public String toXml(){
		return XMLUtil.toXml(this);
	}
	private String transToOAAccountTypeAndIds(){
		StringBuffer typeIds = new StringBuffer();
		String[] umOrgids = this.getExchange().getReceivecode().split(",");
		for (String string : umOrgids) {

			V3xOrgEntity en = CzOrgUtil.getV3xOrgEntityByUmOrgId(string);
			if(en!=null){
				if(typeIds.length()>0){
					typeIds.append(",");
				}
				typeIds.append(en.getEntityType()+"|"+en.getId());
			}
		}
		return typeIds.toString();
	}
	public EdocSendRecord toEdocSendRecord(long edocId){
		EdocSendRecord edocSendRecord = new EdocSendRecord();
		edocSendRecord.setAssignType(0);
		edocSendRecord.setContentNo(0);
		edocSendRecord.setCopies(1);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		edocSendRecord.setCreateTime(Timestamp.valueOf(sdf.format(new Date())));
		edocSendRecord.setDocMark(this.getGwelement().getWenhao());
		edocSendRecord.setDocType("");
		edocSendRecord.setEdocId(edocId);
		edocSendRecord.setExchangeAccountId(this.getExchange().getReceivecode()==null ? 0L : Long.valueOf(this.getExchange().getReceivecode()));
		edocSendRecord.setExchangeMode(0);
		edocSendRecord.setExchangeOrgId(this.getExchange().getSendcode()==null ? 0L : Long.valueOf(this.getExchange().getSendcode()));
		edocSendRecord.setExchangeOrgName(this.getExchange().getSender() == null ? "" : this.getExchange().getSender());
		edocSendRecord.setExchangeType(0);
		edocSendRecord.setIdIfNew();
		edocSendRecord.setIsBase(0);
		edocSendRecord.setIssueDate(new Date());
		edocSendRecord.setIssuer(this.getGwelement().getBaosongname());
		edocSendRecord.setIsTurnRec(0);
		edocSendRecord.setKeywords(this.getGwelement().getTitle());
		edocSendRecord.setSecretLevel(this.getGwelement().getMiji() == null ? "否" : this.getGwelement().getMiji());
		edocSendRecord.setSendDetailList(null);
		edocSendRecord.setSendDetails(null);
		edocSendRecord.setSendedNames(this.getExchange().getReceive());
		
		
		String sendedTypeIds = "";
		try{
			sendedTypeIds = transToOAAccountTypeAndIds();
		}catch(Exception e){
			log.error("transToOAAccountTypeAndIds "+e);
		}
		
		edocSendRecord.setSendedTypeIds(sendedTypeIds);
		edocSendRecord.setSendNames("");
		edocSendRecord.setSendTime(Timestamp.valueOf(sdf.format(new Date())));
		edocSendRecord.setSendUnit(this.getExchange().getSender() == null ? " " : this.getExchange().getSender());
		/*
		V3xOrgMember member = null;
		try {
			member = CzOrgUtil.getV3xOrgMemberByumuserId(this.getGwelement().getBaosonguser());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		if(member!=null){
			
			edocSendRecord.setSendUserId(member.getId());
		}
		*/
		edocSendRecord.setSendUserId(0);
		edocSendRecord.setSendUserNames(this.getGwelement().getBaosongname());
		edocSendRecord.setStatus(0);
		edocSendRecord.setStepBackInfo("");
		edocSendRecord.setSubject(this.getGwelement().getTitle());
		edocSendRecord.setUrgentLevel(this.getGwelement().getJinji() == null ? "" : this.getGwelement().getJinji());
		
		
		return edocSendRecord;
	}
	
	
	public EdocSendDetail toEdocSendDetail(Long sendRecordId, Long relationId){
		EdocSendDetail edocSendDetail = new EdocSendDetail();
		edocSendDetail.setContent(this.getGwelement().getTitle());
		edocSendDetail.setCuibanNum(0);
		edocSendDetail.setId(relationId);
		edocSendDetail.setRecNo("");
		edocSendDetail.setRecOrgId(accountId+"");
		try {
			V3xOrgEntity en =OrgHelper.getOrgManager().getEntityAnyType(Long.parseLong(accountId));
			edocSendDetail.setRecOrgName(en==null?"":en.getName());
		} catch (Exception e) {
			log.error("机构转换错误！"+e);
		}
		edocSendDetail.setRecOrgType(0);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		edocSendDetail.setRecTime(Timestamp.valueOf(sdf.format(new Date())));
		edocSendDetail.setRecUserName(CurrentUser.get().getName());
		edocSendDetail.setSendRecordId(sendRecordId);
		edocSendDetail.setSendType(0);
		edocSendDetail.setStatus(0);
		return edocSendDetail;
	}

	
	
}
