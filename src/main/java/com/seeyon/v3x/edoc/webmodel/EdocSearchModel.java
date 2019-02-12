package com.seeyon.v3x.edoc.webmodel;

import java.util.Date;

public class EdocSearchModel  extends com.seeyon.ctp.util.ObjectToXMLBase{
	
	private int edocType;	//公文类型,收文,发文,签报
	private String subject;	//公文标题
	private String keywords;
	private String docMark;
	private String serialNo;	//内部文号 (收文编号)
	private String docType;		//公文种类
	private String sendType;	//行文类型
	private String createPerson;	//建文人
	private Date createTimeB;	//建文日期
	private Date createTimeE;	//建文日期
	private String sendUnit;	//发文单位
	private String sendUnitId;	//发文单位Id
	private String sendDepartment;//发文部门
	private String sendDepartmentId;//发文部门ID
	private String sendTo;	//主送单位
	private String sendToId;	//主送单位
	private String issuer;	//签发人
	private Date signingDateA;	//签发日期
	private Date signingDateB;	//签发日期

	private String nodePolicy; //节点权限
	private Date createDateB;	//发文日期
	private Date createDateE;	//发文日期
	private String edocUnit; //成文单位
	private Date recieveDateB; //收文  签收时间
	private Date recieveDateE;
	private Date registerDateB;//收文 登记时间
	private Date registerDateE;
	private Date receiveTimeB; //到达时间
	private Date receiveTimeE;
	private String secretLevel; //文件密级
	private String urgentLevel; //紧急程度
	private String startMemberName; //发起人
	private Date expectprocesstimeB;
	private Date expectprocesstimeE;
	private Integer summaryState;//公文流程状态 未结束、已结束、已终止
	private Date workflowDateB;//流程期限
	private Date workflowDateE;
	private String isCombSearchFlag;//是否组合查询
	//项目  信达资产   公司  kimde  修改人  马盛国   修改时间    2017-12-03  行文类型   start 
	private Long templeteId;
	
	//客开 gxy 核稿人 20180802 start
	private String registrantName;
	//客开 gxy 核稿人 20180802 end
	//客开 发文条件 新增条件 20180907  wfj start
	private Date hgTimeB;//核稿起始时间
	private Date hgTimeE;//核稿结束时间
	public Date getHgTimeB() {
		return hgTimeB;
	}
	public void setHgTimeB(Date hgTimeB) {
		this.hgTimeB = hgTimeB;
	}
	public Date getHgTimeE() {
		return hgTimeE;
	}
	public void setHgTimeE(Date hgTimeE) {
		this.hgTimeE = hgTimeE;
	}
	public String getFwtype() {
		return fwtype;
	}
	public void setFwtype(String fwtype) {
		this.fwtype = fwtype;
	}
	public String getJbPerson() {
		return jbPerson;
	}
	public void setJbPerson(String jbPerson) {
		this.jbPerson = jbPerson;
	}
	private String fwtype;//发文类型
	private String jbPerson;//经办人
	public String getUndertaker() {
		return undertaker;
	}
	public void setUndertaker(String undertaker) {
		this.undertaker = undertaker;
	}
	private String undertaker;//承办人
	private String nbPerson;//拟办人
	private Date nbTimeB;//拟办起始时间
	private Date nbTimeE;//拟办结束时间
	public String getNbPerson() {
		return nbPerson;
	}
	public void setNbPerson(String nbPerson) {
		this.nbPerson = nbPerson;
	}
	public Date getNbTimeB() {
		return nbTimeB;
	}
	public void setNbTimeB(Date nbTimeB) {
		this.nbTimeB = nbTimeB;
	}
	public Date getNbTimeE() {
		return nbTimeE;
	}
	public void setNbTimeE(Date nbTimeE) {
		this.nbTimeE = nbTimeE;
	}
	public String getPsPerson() {
		return psPerson;
	}
	public void setPsPerson(String psPerson) {
		this.psPerson = psPerson;
	}
	public Date getPsTimeB() {
		return psTimeB;
	}
	public void setPsTimeB(Date psTimeB) {
		this.psTimeB = psTimeB;
	}
	public Date getPsTimeE() {
		return psTimeE;
	}
	public void setPsTimeE(Date psTimeE) {
		this.psTimeE = psTimeE;
	}
	public String getCyPerson() {
		return cyPerson;
	}
	public void setCyPerson(String cyPerson) {
		this.cyPerson = cyPerson;
	}
	private String psPerson;//批示人
	private Date psTimeB;//批示起始时间
	private Date psTimeE;//批示结束时间
	private String cyPerson;//传阅人
	public String getSwtype() {
		return swtype;
	}
	public void setSwtype(String swtype) {
		this.swtype = swtype;
	}
	private String swtype;//收文类型

	//客开发文条件 新增条件 20180907  wfj end
	public String getRegistrantName() {
		return registrantName;
	}
	public void setRegistrantName(String registrantName) {
		this.registrantName = registrantName;
	}
	public Long getTempleteId() {
		return templeteId;
	}
	public void setTempleteId(Long templeteId) {
		this.templeteId = templeteId;
	}
	//项目  信达资产   公司  kimde  修改人  马盛国   修改时间    2017-12-03  行文类型   start 
	public Date getExpectprocesstimeB() {
		return expectprocesstimeB;
	}
	public void setExpectprocesstimeB(Date expectprocesstimeB) {
		this.expectprocesstimeB = expectprocesstimeB;
	}
	public Date getExpectprocesstimeE() {
		return expectprocesstimeE;
	}
	public void setExpectprocesstimeE(Date expectprocesstimeE) {
		this.expectprocesstimeE = expectprocesstimeE;
	}
	/**
	 * author wangwei  start
	 */
    private String party; //党务机关
    private String administrative; //政务机关
    //同一流程只显示最后一条
	private String isGourpBy;
	
	//发文登记簿——查询时间选择，原来的时间为交换日期，新增签发日期、拟文日期
    private int sendQueryTimeType;
    
    
//    /**
//	 * author cy  start
//	 */
//    private String registerDateA;	//页面查询 登记时间
//    private String registerDateB;
    
    
	public String isGourpBy() {
		return isGourpBy;
	}
	public int getSendQueryTimeType() {
		return sendQueryTimeType;
	}
	public void setSendQueryTimeType(int sendQueryTimeType) {
		this.sendQueryTimeType = sendQueryTimeType;
	}
	public void setGourpBy(String isGourpBy) {
		this.isGourpBy = isGourpBy;
	}
	public String getParty() {
	return party;
	}
	public void setParty(String party) {
		this.party = party;
	}
	
	public String getAdministrative() {
		return administrative;
	}
	public void setAdministrative(String administrative) {
		this.administrative = administrative;
    }
	/**
	 * wangwei end
	 */

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}


	public String getCreatePerson() {
		return createPerson;
	}


	public void setCreatePerson(String createPerson) {
		this.createPerson = createPerson;
	}


	public Date getCreateTimeB() {
		return createTimeB;
	}


	public void setCreateTimeB(Date createTimeB) {
		this.createTimeB = createTimeB;
	}


	public Date getCreateTimeE() {
		return createTimeE;
	}


	public void setCreateTimeE(Date createTimeE) {
		this.createTimeE = createTimeE;
	}


	public String getDocMark() {
		return docMark;
	}


	public void setDocMark(String docMark) {
		this.docMark = docMark;
	}


	public String getDocType() {
		return docType;
	}


	public void setDocType(String docType) {
		this.docType = docType;
	}


	public int getEdocType() {
		return edocType;
	}


	public void setEdocType(int edocType) {
		this.edocType = edocType;
	}


	public String getIssuer() {
		return issuer;
	}


	public void setIssuer(String issuer) {
		this.issuer = issuer;
	}


	public String getKeywords() {
		return keywords;
	}


	public void setKeywords(String keywords) {
		this.keywords = keywords;
	}


	public String getSendTo() {
		return sendTo;
	}


	public void setSendTo(String sendTo) {
		this.sendTo = sendTo;
	}


	public String getSendType() {
		return sendType;
	}


	public void setSendType(String sendType) {
		this.sendType = sendType;
	}


	public String getSendUnit() {
		return sendUnit;
	}


	public void setSendUnit(String sendUnit) {
		this.sendUnit = sendUnit;
	}


	public String getSerialNo() {
		return serialNo;
	}


	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}


	/**
	 * @return the signingDateA
	 */
	public Date getSigningDateA() {
		return signingDateA;
	}


	/**
	 * @param signingDateA the signingDateA to set
	 */
	public void setSigningDateA(Date signingDateA) {
		this.signingDateA = signingDateA;
	}


	/**
	 * @return the signingDateB
	 */
	public Date getSigningDateB() {
		return signingDateB;
	}


	/**
	 * @param signingDateB the signingDateB to set
	 */
	public void setSigningDateB(Date signingDateB) {
		this.signingDateB = signingDateB;
	}


	public String getSubject() {
		return subject;
	}


	public void setSubject(String subject) {
		this.subject = subject;
	}


	public String getSendToId() {
		return sendToId;
	}


	public void setSendToId(String sendToId) {
		this.sendToId = sendToId;
	}
	public String getNodePolicy() {
		return nodePolicy;
	}
	public void setNodePolicy(String nodePolicy) {
		this.nodePolicy = nodePolicy;
	}
	public Date getCreateDateB() {
		return createDateB;
	}
	public void setCreateDateB(Date createDateB) {
		this.createDateB = createDateB;
	}
	public Date getCreateDateE() {
		return createDateE;
	}
	public void setCreateDateE(Date createDateE) {
		this.createDateE = createDateE;
	}
	public String getEdocUnit() {
		return edocUnit;
	}
	public void setEdocUnit(String edocUnit) {
		this.edocUnit = edocUnit;
	}
	public Date getRecieveDateB() {
		return recieveDateB;
	}
	public void setRecieveDateB(Date recieveDateB) {
		this.recieveDateB = recieveDateB;
	}
	public Date getRecieveDateE() {
		return recieveDateE;
	}
	public void setRecieveDateE(Date recieveDateE) {
		this.recieveDateE = recieveDateE;
	}
	public Date getRegisterDateB() {
		return registerDateB;
	}
	public void setRegisterDateB(Date registerDateB) {
		this.registerDateB = registerDateB;
	}
	public Date getRegisterDateE() {
		return registerDateE;
	}
	public void setRegisterDateE(Date registerDateE) {
		this.registerDateE = registerDateE;
	}
	public Date getReceiveTimeB() {
		return receiveTimeB;
	}
	public void setReceiveTimeB(Date receiveTimeB) {
		this.receiveTimeB = receiveTimeB;
	}
	public Date getReceiveTimeE() {
		return receiveTimeE;
	}
	public void setReceiveTimeE(Date receiveTimeE) {
		this.receiveTimeE = receiveTimeE;
	}
	public String getSecretLevel() {
		return secretLevel;
	}
	public void setSecretLevel(String secretLevel) {
		this.secretLevel = secretLevel;
	}
	public String getUrgentLevel() {
		return urgentLevel;
	}
	public void setUrgentLevel(String urgentLevel) {
		this.urgentLevel = urgentLevel;
	}
	public String getStartMemberName() {
		return startMemberName;
	}
	public void setStartMemberName(String startMemberName) {
		this.startMemberName = startMemberName;
	}
	public String getSendDepartment() {
		return sendDepartment;
	}
	public void setSendDepartment(String sendDepartment) {
		this.sendDepartment = sendDepartment;
	}
	public String getSendDepartmentId() {
		return sendDepartmentId;
	}
	public void setSendDepartmentId(String sendDepartmentId) {
		this.sendDepartmentId = sendDepartmentId;
	}
	public String getSendUnitId() {
		return sendUnitId;
	}
	public void setSendUnitId(String sendUnitId) {
		this.sendUnitId = sendUnitId;
	}
	public Integer getSummaryState() {
		return summaryState;
	}
	public void setSummaryState(Integer summaryState) {
		this.summaryState = summaryState;
	}
	public Date getWorkflowDateB() {
		return workflowDateB;
	}
	public void setWorkflowDateB(Date workflowDateB) {
		this.workflowDateB = workflowDateB;
	}
	public Date getWorkflowDateE() {
		return workflowDateE;
	}
	public void setWorkflowDateE(Date workflowDateE) {
		this.workflowDateE = workflowDateE;
	}
	public String getIsCombSearchFlag() {
		return isCombSearchFlag;
	}
	public void setIsCombSearchFlag(String isCombSearchFlag) {
		this.isCombSearchFlag = isCombSearchFlag;
	}
}
