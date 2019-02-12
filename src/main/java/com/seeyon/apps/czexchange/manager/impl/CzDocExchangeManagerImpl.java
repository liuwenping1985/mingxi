/**
 * 太原市睿思特科技有限公司  张力 2013/09/22
 */
package com.seeyon.apps.czexchange.manager.impl;


import java.io.File;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.CollectionUtils;

import com.seeyon.apps.agent.bo.MemberAgentBean;
import com.seeyon.apps.czexchange.bo.Elecdocument;
import com.seeyon.apps.czexchange.common.EdocUtil;
import com.seeyon.apps.czexchange.dao.EdocSummaryAndDataRelationDAO;
import com.seeyon.apps.czexchange.enums.EdocSendOrReceiveStatusEnum;
import com.seeyon.apps.czexchange.manager.CzDocExchangeManager;
import com.seeyon.apps.czexchange.po.EdocSummaryAndDataRelation;
import com.seeyon.apps.czexchange.util.CzVisualUser;
import com.seeyon.apps.dev.doc.enums.EdocTypeEnum;
import com.seeyon.apps.dev.doc.manager.ExportDocManager;
import com.seeyon.apps.edoc.enums.EdocEnum;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.config.manager.ConfigManager;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.dao.AttachmentDAO;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.operationlog.manager.OperationlogManager;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.organization.bo.MemberRole;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.oainterface.common.OAInterfaceException;
import com.seeyon.oainterface.exportData.document.DocumentExport;
import com.seeyon.oainterface.impl.exportdata.EdocImporter;
import com.seeyon.v3x.common.exceptions.MessageException;
import com.seeyon.v3x.edoc.dao.EdocBodyDao;
import com.seeyon.v3x.edoc.domain.EdocBody;
import com.seeyon.v3x.edoc.domain.EdocForm;
import com.seeyon.v3x.edoc.domain.EdocRegister;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.enums.EdocMessageFilterParamEnum;
import com.seeyon.v3x.edoc.exception.EdocException;
import com.seeyon.v3x.edoc.manager.EdocFormManager;
import com.seeyon.v3x.edoc.manager.EdocHelper;
import com.seeyon.v3x.edoc.manager.EdocLockManager;
import com.seeyon.v3x.edoc.manager.EdocManager;
import com.seeyon.v3x.edoc.manager.EdocMarkDefinitionManager;
import com.seeyon.v3x.edoc.manager.EdocRegisterManager;
import com.seeyon.v3x.edoc.manager.EdocRoleHelper;
import com.seeyon.v3x.edoc.manager.EdocSummaryManager;
import com.seeyon.v3x.edoc.manager.EdocSummaryRelationManager;
import com.seeyon.v3x.edoc.manager.EdocSwitchHelper;
import com.seeyon.v3x.edoc.util.EactionType;
import com.seeyon.v3x.exchange.dao.EdocSendDetailDao;
import com.seeyon.v3x.exchange.dao.EdocSendRecordDao;
import com.seeyon.v3x.exchange.domain.EdocRecieveRecord;
import com.seeyon.v3x.exchange.domain.EdocSendDetail;
import com.seeyon.v3x.exchange.domain.EdocSendRecord;
import com.seeyon.v3x.exchange.manager.EdocExchangeManager;
import com.seeyon.v3x.exchange.manager.ExchangeAccountManager;
import com.seeyon.v3x.exchange.manager.RecieveEdocManager;
import com.seeyon.v3x.exchange.manager.SendEdocManager;
import com.seeyon.v3x.exchange.util.ExchangeUtil;

public class CzDocExchangeManagerImpl implements CzDocExchangeManager {
	private static final transient Log log = LogFactory.getLog(CzDocExchangeManagerImpl.class);
	private ExportDocManager exportDocManager;
	private EdocBodyDao edocBodyDao;
	private ExchangeAccountManager exchangeAccountManager;
	private EdocExchangeManager edocExchangeManager;
	private SendEdocManager sendEdocManager;
	private EnumManager enumManager;
	private EdocSummaryManager edocSummaryManager;

	private UserMessageManager userMessageManager;
	private OperationlogManager operationlogManager;
	private AppLogManager appLogManager;
	private EdocSummaryRelationManager edocSummaryRelationManager;
	private ConfigManager configManager;
	private EdocLockManager edocLockManager;
	private EdocRegisterManager edocRegisterManager;
	private EdocMarkDefinitionManager edocMarkDefinitionManager;
	
	public ExchangeAccountManager getExchangeAccountManager() {
		return exchangeAccountManager;
	}

	public void setExchangeAccountManager(
			ExchangeAccountManager exchangeAccountManager) {
		this.exchangeAccountManager = exchangeAccountManager;
	}

	public EdocExchangeManager getEdocExchangeManager() {
		return edocExchangeManager;
	}

	public void setEdocExchangeManager(EdocExchangeManager edocExchangeManager) {
		this.edocExchangeManager = edocExchangeManager;
	}

	public SendEdocManager getSendEdocManager() {
		return sendEdocManager;
	}

	public void setSendEdocManager(SendEdocManager sendEdocManager) {
		this.sendEdocManager = sendEdocManager;
	}

	public EnumManager getEnumManager() {
		return enumManager;
	}

	public void setEnumManager(EnumManager enumManager) {
		this.enumManager = enumManager;
	}

	public EdocSummaryManager getEdocSummaryManager() {
		return edocSummaryManager;
	}

	public void setEdocSummaryManager(EdocSummaryManager edocSummaryManager) {
		this.edocSummaryManager = edocSummaryManager;
	}

	public UserMessageManager getUserMessageManager() {
		return userMessageManager;
	}

	public void setUserMessageManager(UserMessageManager userMessageManager) {
		this.userMessageManager = userMessageManager;
	}

	public OperationlogManager getOperationlogManager() {
		return operationlogManager;
	}

	public void setOperationlogManager(OperationlogManager operationlogManager) {
		this.operationlogManager = operationlogManager;
	}

	public AppLogManager getAppLogManager() {
		return appLogManager;
	}

	public void setAppLogManager(AppLogManager appLogManager) {
		this.appLogManager = appLogManager;
	}

	public EdocSummaryRelationManager getEdocSummaryRelationManager() {
		return edocSummaryRelationManager;
	}

	public void setEdocSummaryRelationManager(
			EdocSummaryRelationManager edocSummaryRelationManager) {
		this.edocSummaryRelationManager = edocSummaryRelationManager;
	}

	public ConfigManager getConfigManager() {
		return configManager;
	}

	public void setConfigManager(ConfigManager configManager) {
		this.configManager = configManager;
	}

	public EdocLockManager getEdocLockManager() {
		return edocLockManager;
	}

	public void setEdocLockManager(EdocLockManager edocLockManager) {
		this.edocLockManager = edocLockManager;
	}

	public EdocRegisterManager getEdocRegisterManager() {
		return edocRegisterManager;
	}

	public void setEdocRegisterManager(EdocRegisterManager edocRegisterManager) {
		this.edocRegisterManager = edocRegisterManager;
	}

	public EdocMarkDefinitionManager getEdocMarkDefinitionManager() {
		return edocMarkDefinitionManager;
	}

	public void setEdocMarkDefinitionManager(
			EdocMarkDefinitionManager edocMarkDefinitionManager) {
		this.edocMarkDefinitionManager = edocMarkDefinitionManager;
	}

	public ExportDocManager getExportDocManager() {
		return exportDocManager;
	}

	public EdocBodyDao getEdocBodyDao() {
		return edocBodyDao;
	}

	public AffairManager getAffairManager() {
		return affairManager;
	}
	// 注入
	private OrgManager orgManager;
	public OrgManager getOrgManager() {
		return orgManager;
	}
	
	public void setEdocBodyDao(EdocBodyDao edocBodyDao) {
		this.edocBodyDao = edocBodyDao;
	}

	public void setExportDocManager(ExportDocManager exportDocManager) {
		this.exportDocManager = exportDocManager;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	private EdocFormManager edocFormManager;
	public EdocFormManager getEdocFormManager() {
		return edocFormManager;
	}

	public void setEdocFormManager(EdocFormManager edocFormManager) {
		this.edocFormManager = edocFormManager;
	}
	
	private EdocSummaryAndDataRelationDAO edocSummaryAndMeetingRelationDAO;

	// 注入结束
	


	public EdocSummaryAndDataRelationDAO getEdocSummaryAndMeetingRelationDAO() {
		return edocSummaryAndMeetingRelationDAO;
	}
	public void setEdocSummaryAndMeetingRelationDAO(
			EdocSummaryAndDataRelationDAO edocSummaryAndMeetingRelationDAO) {
		this.edocSummaryAndMeetingRelationDAO = edocSummaryAndMeetingRelationDAO;
	}
	private String oaUrl = AppContext.getSystemProperty("internet.site.url");
//	public static String tempFilePath = AppContext.getSystemProperty("edocexchange.fileUploadTempFolder");//.getSystemTempFolder();

	private FileManager fileManager;
	private AttachmentDAO attachmentDAO;
	private AffairManager affairManager;
	
	public void setAffairManager(AffairManager affairManager) {
		this.affairManager = affairManager;
	}


	public AttachmentDAO getAttachmentDAO() {
		return attachmentDAO;
	}

	public void setAttachmentDAO(AttachmentDAO attachmentDAO) {
		this.attachmentDAO = attachmentDAO;
	}

	public FileManager getFileManager() {
		return fileManager;
	}

	public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}

	/**
	 * 获得当前系统配置的公文收发员，配置的人可以不是收发员，程序自动检测当前单位的收发员，以免造成错误
	 * @return
	 * @throws BusinessException
	 */
	private V3xOrgMember getreceiveEdocMember() throws BusinessException{
		String loginName = AppContext.getSystemProperty("czexchange.dataExchageUser");
		String roleName = "Accountexchange";
		V3xOrgMember member = orgManager.getMemberByLoginName(loginName);
		if(member==null){
			String errorMessage = "公文交换插件信息输出: 根据登录名称在系统中没有找到人员, 请检查登录名称的配置。czexchange.meetingExchageUser";
			log.error(errorMessage);
			throw new BusinessException(errorMessage);
		}
		Long accountId = member.getOrgAccountId();
		List<MemberRole> list = orgManager.getMemberRoles(member.getId(), member.getOrgDepartmentId());
		for (MemberRole memberRole : list) {
			if(memberRole.getRole().getName().equalsIgnoreCase(roleName)){
				return member;
			}
		}
		List<V3xOrgMember> listmembr = orgManager.getMembersByRole(accountId, roleName);
		
		if(listmembr!=null && listmembr.size()>0){
			member = listmembr.get(0);
		}
		log.info("当前接收公文的人员系统设定为："+member.getLoginName());
		return member;
	
	}
	@Override
	public void autoSign(EdocSendRecord edocSendRecord){
		String roleName = "Accountexchange";
		try {
			V3xOrgMember member = null;
			List<V3xOrgEntity> orgens = OrgHelper.getOrgManager().getEntities(edocSendRecord.getSendedTypeIds());
			if(orgens!=null && orgens.size()>0){
				for (V3xOrgEntity orgen : orgens) {
					if(orgen.getEntityType().equals(orgen.ORGENT_TYPE_ACCOUNT)){
						List<V3xOrgMember> listmembr = OrgHelper.getOrgManager().getMembersByRole(orgen.getId(), roleName);
						
						if(listmembr!=null && listmembr.size()>0){
							for (V3xOrgMember m : listmembr) {
								if(m.getOrgAccountId().longValue()==orgen.getId()){
									member = m;
									break;
								}
							}
						}
					}else if(orgen.getEntityType().endsWith(orgen.ORGENT_TYPE_DEPARTMENT)){
						List<V3xOrgMember> listmembr = OrgHelper.getOrgManager().getMembersByRole(orgen.getOrgAccountId(), roleName);
						
						if(listmembr!=null && listmembr.size()>0){
							for (V3xOrgMember m : listmembr) {
								if(m.getOrgDepartmentId().longValue()==orgen.getId()){
									member = m;
									break;
								}
							}
						}
					}
					if(member!=null){
						CzVisualUser.visualUser(member);
						this.autoReceiveEdoc(edocSendRecord.getEdocId());
					}
				}
			}

		} catch (Exception e) {
			log.error("自动签收异常",e);
		}
	}
	@Override
	public String receiveEdoc(Elecdocument elecdocument) throws BusinessException, OAInterfaceException {
		log.info("从公文交换系统接收到了公文, " + elecdocument.getGwelement().getTitle());
		EdocImporter  importer=new EdocImporter();
		EdocSummaryManager edocSummaryManager = (EdocSummaryManager)AppContext.getBean("edocSummaryManager");
		String zipFilePath = exportDocManager.getTempFilepath("receiveEdoc"+File.separator+elecdocument.getMsgId());
			
			// 下面的程序把收到的相关信息转换成公文的相关信息
			// 如果是企业版， 可以通过下面的方法获得单位的 ID
			// Long accountId = orgManager.getRootAccount().getId();
			// 如果是集团版， 现在的设计思路是：  通过 element.xml 中， 接收单位的名称来获得接收单位的 ID
//			String umorgid = elecdocument.getExchange().getReceivecode();
//			V3xOrgEntity v3xOrgEntitry = CzOrgUtil.getV3xOrgEntityByUmOrgId(umorgid);
//			Long accountId = v3xOrgEntitry.getId();

		V3xOrgMember member = this.getreceiveEdocMember();
		Long accountId = member.getOrgAccountId();

			// 下面这行设置接收公文的单位 ID
			elecdocument.setAccountId(String.valueOf(accountId));
			CzVisualUser.visualUser(member);
			// 下面这个方法是获得缺省的 公文文单
			EdocForm edocForm = edocFormManager.getDefaultEdocForm(accountId, 1);
//			EdocForm edocForm = null;
//			// 下面这个方法是根据文单的 Id 获得文单
//			String meetingEdocIdStr = AppContext.getSystemProperty("czexchange.meetingEdocId");
//			edocForm = edocFormManager.getEdocForm(Long.valueOf(meetingEdocIdStr));

			elecdocument.setFormId(edocForm.getId());
			// 产生对应关系
			EdocSummaryAndDataRelation relation = new EdocSummaryAndDataRelation();
			relation.setIdIfNew();
			elecdocument.setRelationId(relation.getId());
			
			DocumentExport export = EdocUtil.getDocumentExport(elecdocument);
			Long edocId = importer.importEdocDocument(export);
			EdocSummary summary = edocSummaryManager.findById(edocId);
			summary.setDocMark(elecdocument.getGwelement().getWenhao());
			summary.setOrgAccountId(accountId);
			
			// 增加联系人和联系方式的赋值
			
//			summary.setVarchar3(record.getMeeting_contact());
//			summary.setPhone(record.getMeeting_contactPhone());
			
			/**
			 * 目前看程序根本没有完成正文的导入工作，这里专门处理公文的正文
			 */
			String fileName = elecdocument.getText().getFile().getFileName();
			log.info("添加正文-->"+fileName);
			if(Strings.isNotBlank(fileName)){
				String zwpathName = zipFilePath+File.separator+fileName;
				String showName = elecdocument.getText().getFile().getAttachname();
				showName = showName.indexOf(".")==-1?showName+fileName.substring(fileName.lastIndexOf(".")-1,fileName.length()):showName;
				File file =new File(zwpathName);
				if(!file.exists()){
					log.error(" 正文不存在：" + elecdocument.getText().getFile().getAttachname() + " " + file.getAbsolutePath());
					throw new BusinessException(" 正文不存在：" + elecdocument.getText().getFile().getAttachname() + " " + file.getAbsolutePath());
				}
				
				V3XFile v3xfile = fileManager.save(file, ApplicationCategoryEnum.edoc,showName, new Date(), true);
				updataNewBody(summary, v3xfile);
			}
			edocSummaryManager.saveOrUpdateEdocSummary(summary, true);
			relation.setAccountId(accountId);
			relation.setApp(EdocTypeEnum.recEdoc.ordinal());
			relation.setEdocId(edocId);
			relation.setMsgId(elecdocument.getMsgId());
			relation.setStatus(EdocSendOrReceiveStatusEnum.Received.getKey());
			DBAgent.save(relation);
			

			
			// 在收文管理， 待登记事项中， 回退一个已经签收的公文， 会报  edoc_exchange_send_detail 这个表中没有记录
			// 解决方案是：  在收到公文的时候， 生成一条这个表中的记录放进去
			
			// 处理 EdocSendRecord 表
			EdocSendRecord edocSendRecord = elecdocument.toEdocSendRecord(edocId);
			DBAgent.saveOrUpdate(edocSendRecord);
			
			// 处理 EdocSendDetail 表
			EdocSendDetail detail = elecdocument.toEdocSendDetail(edocSendRecord.getId(), relation.getId());
			DBAgent.saveOrUpdate(detail);
/*
			log.info("开始自动签收！");
			 try {
				EdocRecieveRecord record = edocExchangeManager.getReceivedRecordByEdocId(summary.getId());
				CzVisualUser.visualUser(member);
				this.autoReceiveEdoc(summary.getId());
				log.info("自动签收完成！");
			} catch (Exception e) {
				log.error("自动签收失败！",e);
			}
			*/
			return "true";   // edocId;  // 这是成功返回的标识
	}
	/**
	 * 保存正文关系
	 * @param summary
	 * @param fileId
	 * @throws BusinessException 
	 */
	public void updataNewBody(EdocSummary summary ,V3XFile v3xfile) throws BusinessException{
		if(summary==null){
			throw new BusinessException("suuary 不能为空！");
		}else{

			EdocBody body=null;
			Set<EdocBody> bodys=summary.getEdocBodies();
			if(bodys!=null){
				
				Iterator ite=(Iterator) bodys.iterator();
				while(ite.hasNext()){
					body=(EdocBody)ite.next();
				}
			}
			if(body==null){
				body= new EdocBody();
				body.setIdIfNew();
				body.setEdocSummary(summary);
				body.setCreateTime(new Timestamp(System.currentTimeMillis()));
				body.setContentNo(0);
				summary.getEdocBodies().add(body);
			}
			//此处省略了，公文其他类型的不在这里处理请在			DocumentExport export = EdocUtil.getDocumentExport(elecdocument);中进行处理
			String contentType = "Pdf";
			body.setContentType(contentType);
			body.setLastUpdate(new Timestamp(System.currentTimeMillis()));
			body.setContent(v3xfile.getId()+"");
			try {
				edocBodyDao.update(body);
			} catch (Exception e) {
				throw new BusinessException(e);
			}
			log.info("正文设置成功。summary="+summary.getId());
		
		}
	}
	private void updateAffair(Long affairId) {
		try {
			CtpAffair affair = affairManager.get(affairId);
			if(affair != null) {
				affair.setState(4);
				affairManager.updateAffair(affair);
			}
		} catch (Exception e) {
			log.error(e);
		}
	}

	/**
	 * 建立附件与公文的关联关系
	 * @param fileId
	 * @param summaryId
	 */
	private void setAttachmentAndSummaryRelation(Long fileId, Long refId) {

		try {
			V3XFile file = fileManager.getV3XFile(fileId);
			if(file == null) {
				log.error("上传文件ID不正确，文件不存在");
			} else {
				Attachment attachment = new Attachment();
				attachment.setIdIfNew();
				attachment.setCategory(ApplicationCategoryEnum.edocRec.getKey());
				attachment.setReference(refId);
				attachment.setSubReference(refId);
				attachment.setType(file.getType());
				attachment.setFilename(file.getFilename());
				attachment.setFileUrl(fileId);
				attachment.setMimeType(file.getMimeType());
				attachment.setSize(file.getSize());
				attachment.setCreatedate(new java.util.Date());
				
				attachmentDAO.save(attachment);
				log.error("文件关联设置成功。");
			}
		} catch (Exception e) {
			log.error("文件关联失败。" + e.getMessage(), e);
		}
	}
	

//    private void toSend(Long docId ,String typeAndIds,String sendedNames,String reSend){
//
//		String sendKey = "exchange.sent";
//		String userName = "";
//		//公文交换时候,发送公文,给发送的detail表插入数据,同时给待签收表插入数据
//		//String sendUserId = request.getParameter("sendUserId");
//		//String sender = request.getParameter("sender");
//		//读取发送时重新选择的发送单位
////		String typeAndIds=request.getParameter("grantedDepartId");
////		String sendedNames = request.getParameter("depart");
//		User user = AppContext.getCurrentUser();
//		EdocSendRecord record = edocExchangeManager.getSendRecordById(docId);
//		
//		/**
//		 * 1. 补发的数据不做验证
//		 * 2. 待发的数据，如果发文被取消，不让发送成功
//		 */
////		if(!"true".equals(reSend) && !checkEdocSendRecord(response, record)) {
////			return null;
////		}
//		
//		/*****
//                                 这段代码保留，怕需求又变动回来：OA-78471
//
//		EdocExchangeTurnRec turnRec = null;
//		if(null != record.getIsTurnRec() &&  record.getIsTurnRec() == 1){
//			turnRec = edocExchangeTurnRecManager.findEdocExchangeTurnRecByEdocId(record.getEdocId());
//		}
//		
//		******************/
//		
//		//分发人员点击公文被退回的提示消息打开被退回的公文，在页面上点击'发送'再次发送给相同单位，这个单位下的其他人员或者上一次的签收人员回退，
//		//分发人员在已分发里打开公文查看交换信息里回退附言还是第一次回退时的附言，新的附言没有被记录 
//
//		if(!"true".equals(reSend)){
//			record.setStepBackInfo("");
//			//OA-22284  在公文交换中将带发送的公文发送出去，然后去发文登记簿去查询，在结果中看不到在交换时才选择的主送单位  
//			//在发文登记簿中查询时，是按照该字段查询主送单位的
//			record.setSendedTypeIds(typeAndIds);
//			record.setSendedNames(sendedNames);
//			
//			/*****
//			 这段代码保留，怕需求又变动回来：OA-78471
//			
//			//需要修改转收文信息中的 主送单位（因为在发送时，只有有交换员的单位才能发送）
//			if(turnRec != null){
//				turnRec.setTypeAndIds(typeAndIds);
//				edocExchangeTurnRecManager.updateTurnRec(turnRec);
//			}
//			
//			******/
//		}
//		Boolean isResend = false;
//		if("true".equals(reSend)){
//			isResend = true;
//			EdocSendRecord reRecord = new EdocSendRecord();
//			reRecord.setIdIfNew();
//			reRecord.setContentNo(record.getContentNo());
//			reRecord.setCopies(record.getCopies());
//			reRecord.setCreateTime(new Timestamp(new Date().getTime()));
//			reRecord.setDocMark(record.getDocMark());
//			reRecord.setDocType(record.getDocType());
//			reRecord.setEdocId(record.getEdocId());
//			reRecord.setExchangeOrgId(record.getExchangeOrgId());
//			reRecord.setExchangeAccountId(record.getExchangeAccountId());
//			reRecord.setExchangeOrgName(record.getExchangeOrgName());
//			reRecord.setExchangeType(record.getExchangeType());
//			reRecord.setIssueDate(record.getIssueDate());
//			reRecord.setIssuer(record.getIssuer());
//			reRecord.setSecretLevel(record.getSecretLevel());
//			reRecord.setSendDetailList(new ArrayList());
//			reRecord.setSendDetails(new HashSet());
//			reRecord.setSendNames(user.getName());
//			reRecord.setSendTime(new Timestamp(System.currentTimeMillis()));
//			reRecord.setSendUnit(record.getSendUnit());
//			reRecord.setSendUserId(user.getId());
//			reRecord.setAssignType(EdocSendRecord.Exchange_Assign_To_Member);//补发表示，指定交换，交换人为user.getId()
//			reRecord.setIsBase(EdocSendRecord.Exchange_Base_NO);//补发表示：非原发文
//			reRecord.setSendUserNames(user.getName());
//			reRecord.setStatus(record.getStatus());
//			reRecord.setSubject(record.getSubject());
//			reRecord.setUrgentLevel(record.getUrgentLevel());
//			reRecord.setSendedTypeIds(typeAndIds);
//			reRecord.setSendedNames(sendedNames);
//			//设置是否为转收文类型
//			reRecord.setIsTurnRec(record.getIsTurnRec());
//			
//			/*****
//                                             这段代码保留，怕需求又变动回来：OA-78471
//			
//			//修改转收文信息的 主送单位
//			if(turnRec != null){
//				if(Strings.isNotBlank(turnRec.getTypeAndIds())){
//					turnRec.setTypeAndIds(turnRec.getTypeAndIds()+","+typeAndIds);
//				}else{
//					turnRec.setTypeAndIds(typeAndIds);
//				}
//				edocExchangeTurnRecManager.updateTurnRec(turnRec);
//			}
//			
//			**************/
//			
//
//			record = reRecord; //对象指向新对象
//			sendKey = "exchange.resend";
//			String modelType = "sent";
//		}
//		
//		boolean hasPlugin = AppContext.hasPlugin("sursenExchange");
//		//没有书生插件的时候、有书生插件并且选择了内部交互 需要记录内部交换应用日志。
//		if(!hasPlugin || (hasPlugin && String.valueOf(EdocExchangeModeEnum.internal.getKey()).equals(internalExchange))){
//			//内部交换应用日志记录
//			appLogManager.insertLog(AppContext.getCurrentUser(), AppLogAction.Edoc_Send_Exchange, AppContext.getCurrentUser().getName(),record.getSubject());
//		}
//		List <EdocSendDetail> details=edocExchangeManager.createSendRecord(record.getId(), typeAndIds);
//		
//		// 如果是回退的公文再次发送，设置此公文的发文记录的状态为未发送
//		if (ExchangeUtil.isEdocExchangeSentStepBacked(record.getStatus())) {
//			record.setStatus(EdocSendRecord.Exchange_iStatus_Tosend);
//		}
//		
//		Set<EdocSendDetail> sendDetails = new HashSet<EdocSendDetail>(details);
//		record.setSendDetails(sendDetails);
//		// 在已发中和待签收产生数据
//		Map<String, String> sendEdoc = edocExchangeManager.sendEdoc(record, user.getId() ,user.getName(),agentToId,isResend,exchangeModeValues);
//		String sendFailed = sendEdoc.get("sendFailed");
//		// 书生交换失败，弹出提示框
//		String  send = ResourceUtil.getString("edoc.exchangeMode.sursenfailed"); // 书生公文交换发送失败，请重新发送
//		if("failed".equals(sendFailed)){
//			throw new BusinessException("error");
//		}
//		//affair = affairManager.getBySubObject(ApplicationCategoryEnum.exSend, record.getId());
//
//		Map conditions = new HashMap();
//		conditions.put("app", ApplicationCategoryEnum.exSend.key());
//        conditions.put("objectId", record.getEdocId());
//        conditions.put("subObjectId", record.getId());
//        //OA-51995客户bug：重要A8-V5BUG_V5.0sp2_工银安盛人寿保险有限公司 _公文已经签收后，待办事项中仍显示待发送的公文_20140110022392
//        List<CtpAffair> affairList =affairManager.getByConditions(null,conditions);//(5.0sprint3)
//    	List<MessageReceiver> receivers = new ArrayList<MessageReceiver>();
//    	long memberId = agentToId==null ? user.getId() : agentToId;
//    	CtpAffair currentAffair = null;
//    	CtpAffair cloneAffair = null;
//		if(null!=affairList && affairList.size()>0){
//			for(CtpAffair af : affairList) {
//				if(memberId == af.getMemberId()) {
//					currentAffair = af;
//				}
//        		if(af.getMemberId().longValue() != user.getId() && (af.isDelete()!= true)){
//        			receivers.add(new MessageReceiver(af.getId(), af.getMemberId()));
//        		}
//				af.setState(StateEnum.edoc_exchange_sent.getKey());
//				af.setDelete(true);
//				af.setFinish(true);
//				cloneAffair = (CtpAffair)af.clone();
//				affairManager.updateAffair(af);
//			}
//		}
//		if(currentAffair==null && cloneAffair!=null) {
//			currentAffair = cloneAffair;
//			currentAffair.setId(UUIDLong.longUUID());
//			currentAffair.setMemberId(memberId);
//			currentAffair.setState(StateEnum.edoc_exchange_sent.getKey());
//			currentAffair.setSubState(SubStateEnum.col_pending_unRead.getKey());
//			currentAffair.setDelete(true);
//			currentAffair.setFinish(true);
//			affairManager.save(currentAffair);
//		}
//    	if(null!=receivers && receivers.size()>0){
//    		if(agentToId!=null){
//    			userMessageManager.sendSystemMessage(new MessageContent(sendKey, affairList.get(0).getSubject(), agentToName,affairList.get(0).getApp()).add("edoc.agent.deal", user.getName()), ApplicationCategoryEnum.edocSend,agentToId, receivers,EdocMessageFilterParamEnum.exchange.key);
//    		}else{
//    			userMessageManager.sendSystemMessage(new MessageContent(sendKey, affairList.get(0).getSubject(), userName,affairList.get(0).getApp()), ApplicationCategoryEnum.edocSend, user.getId(), receivers,EdocMessageFilterParamEnum.exchange.key);
//    		}
//    	}
//    	if(isResend){
//    		operationlogManager.insertOplog(record.getId(), ApplicationCategoryEnum.exchange, EactionType.LOG_EXCHANGE_RDSEND, EactionType.LOG_EXCHANGE_RDSENDD_DESCRIPTION,user.getName(), record.getSubject());
//    	}else{
//    		operationlogManager.insertOplog(record.getId(), ApplicationCategoryEnum.exchange, EactionType.LOG_EXCHANGE_SEND, EactionType.LOG_EXCHANGE_SEND_DESCRIPTION,user.getName(), record.getSubject());        		
//    	}
//    	
//
//	
//    }

		@Override
	  public void updateEdocState(long edocSendId, String accountId, String accountName, int state)
			    throws OAInterfaceException
			  {
			    SendEdocManager sendEdocManager = (SendEdocManager)AppContext.getBean("sendEdocManager");
			    
			    EdocSendDetailDao edocSendDetailDao = (EdocSendDetailDao)AppContext.getBean("edocSendDetailDao");
			    
			    EdocSendRecordDao edocSendRecordDao = (EdocSendRecordDao)AppContext.getBean("edocSendRecordDao");
			    long current = edocSendId;
			    EdocSendRecord sendRecord = sendEdocManager.getEdocSendRecord(edocSendId);
			    if (sendRecord == null)
			    {
			      sendRecord = sendEdocManager.getEdocSendRecordByDetailId(edocSendId);
			      if (sendRecord == null)
			      {
			        RecieveEdocManager recieveEdocManager = (RecieveEdocManager)AppContext.getBean("recieveEdocManager");
			        EdocRecieveRecord recieveRecord = recieveEdocManager.getEdocRecieveRecord(edocSendId);
			        if (recieveRecord != null) {
			          sendRecord = sendEdocManager.getEdocSendRecordByDetailId(Long.parseLong(recieveRecord.getReplyId()));
			        }
			        if (sendRecord == null) {
			          throw new OAInterfaceException(-1, "没有找到此公文待发送记录");
			        }
			      }
			    }
//			    EdocSendRecord newRecord = null;
			    //为什么要新建？毛意思啊？删掉
//			    if (sendRecord.getStatus() == 1) {
//			      try
//			      {
//			        newRecord = (EdocSendRecord)sendRecord.clone();
//			        newRecord.setIdIfNew();
//			        current = newRecord.getId().longValue();
//			        edocSendRecordDao.save(newRecord);
//			      }
//			      catch (CloneNotSupportedException localCloneNotSupportedException) {}
//			    }
			    try
			    {
			      if (Strings.isBlank(accountId)) {
			        throw new OAInterfaceException(-1, "传入单位参数错误:" + accountId);
			      }
			      List<EdocSendDetail> details = sendEdocManager.getDetailBySendId(edocSendId);
			      DBAgent.deleteAll(details);
			      EdocSendDetail detail = null;
			      log.info("accountId: " + accountId);
			      log.info("accountName: " + accountName);
			      String[] accoutIdArr = accountId.split(",");
			      String[] accountNameArr = accountName.split(",");
			      a:for (int i = 0; i < accoutIdArr.length; i++) {
			        if (Strings.isBlank(accoutIdArr[i]))
			        {
			          log.error("传入单位参数解析错误:" + accoutIdArr[i]);
			        }
			        else
			        {
			        	String recAccountId =  accoutIdArr[i].indexOf("\\|")==-1?accoutIdArr[i]:accoutIdArr[i].split("\\|")[1];
			        if(details!=null && details.size()>0){
			        	
			        	b:for (EdocSendDetail detailt : details) {
			        		if(recAccountId.equals(detailt.getRecOrgId())){
			        			detailt.setRecOrgType(1);
			        			detailt.setStatus(state);
			        			detailt.setRecTime(new Timestamp(System.currentTimeMillis()));
			        			detailt.setSendType(0);
			        			detailt.setContent("信达交换中心返回信息");
			        			detailt.setRecUserName("交换中心回执");
			        			edocSendDetailDao.save(detailt);
			        			continue a;
			        		}
			        	}
			        }
			          detail = new EdocSendDetail();
			          detail.setIdIfNew();
			          detail.setStatus(state);
			          detail.setSendRecordId(Long.valueOf(current));
			          detail.setRecOrgId(recAccountId);
			          detail.setRecOrgType(1);
			          detail.setRecOrgName(accountNameArr[i]);
			          detail.setRecTime(new Timestamp(System.currentTimeMillis()));
			          detail.setSendType(0);
			          detail.setContent("信达交换中心返回信息");
			          detail.setRecUserName("交换中心回执");
			          edocSendDetailDao.save(detail);
			        }
			      }
			      //显示签收信息啊？不更新怎么显示啊？
			      sendRecord.setExchangeMode(0);
			      edocSendRecordDao.save(sendRecord);
			    }
			    catch (Throwable e1)
			    {
			      log.error("回写公文已发送状态或已签收状态异常", e1);
			      throw new OAInterfaceException(-1, "回写公文已发送状态或已签收状态异常", e1);
			    }
			    try
			    {
			      AffairManager affairManager = (AffairManager)AppContext.getBean("affairManager");
			      if (sendRecord.getStatus() == 1) {
			        return;
			      }
			      sendRecord.setStatus(1);
			      sendEdocManager.update(sendRecord);
			      
			      Map<String, Object> mapColums = new HashMap();
			      mapColums
			        .put("state", 
			        
			        Integer.valueOf(StateEnum.edoc_exchange_sent
			        .key()));
			      
			      affairManager.update(Long.valueOf(current), mapColums);
			      
			    }
			    catch (Exception e)
			    {
			      log.error("回写公文发送状态异常", e);
			      throw new OAInterfaceException(-1, "回写公文发送状态异常", e);
			    }
			  }

    /**
     * 自动签收
     * @param edocid
     * @throws Exception
     */
		@Override
    public void autoReceiveEdoc(Long edocid) throws Exception {
//		String recNo = request.getParameter("recNo");
		String remark = "系统自动签收";
		String keepperiod = "0";
		EdocRecieveRecord record = edocExchangeManager.getReceivedRecordByEdocId(edocid);
		Long exchangeAccountId = record.getExchangeOrgId();
		User user = AppContext.getCurrentUser();
		Long recUserId = user.getId(); 
		Long registerUserId = user.getId(); 
		Long agentToId = null;
		String agentToName ="";
		//处理是否代理人
		List<Long> agentIdList = MemberAgentBean.getInstance().getAgentToMemberId(ApplicationCategoryEnum.edoc.key(), user.getId());
		if(!CollectionUtils.isEmpty(agentIdList)) {
			boolean agentIsExchangeRole = false;
			for(int i=0; i<agentIdList.size(); i++) {
				V3xOrgMember agentMember=orgManager.getMemberById(agentIdList.get(i).longValue());
				if(agentMember==null){
					continue;
				}
				Long accountIdOfagentId = agentMember.getOrgAccountId();
				agentIsExchangeRole = EdocRoleHelper.isExchangeRole(agentIdList.get(i).longValue(),accountIdOfagentId);
				if(agentIsExchangeRole) {
					agentToId = agentMember.getId();
					agentToName = agentMember.getName();
					break;
				}
			}
		}
		
	    //真实的签收单位收单位
	    boolean isOpenRegister = true;
	    if(exchangeAccountId!=null){
	        isOpenRegister = EdocSwitchHelper.isOpenRegister(exchangeAccountId);
	    }else {
	        isOpenRegister = EdocSwitchHelper.isOpenRegister(user.getAccountId());
        }
	    


		//G6 V1.0 SP1后续功能_自定义签收编号start
		String mark = Datetimes.format(new Date(), "yyyyMMddHHmmss")+"";
//		if(Strings.isNotBlank(recNo)){
//			EdocMarkModel em=EdocMarkModel.parse(recNo);
//			Long markDefinitionId = em.getMarkDefinitionId();
//			if(em.getDocMarkCreateMode()==com.seeyon.v3x.edoc.util.Constants.EDOC_MARK_EDIT_SELECT_NEW){
//				edocMarkDefinitionManager.setEdocMarkCategoryIncrement(markDefinitionId);
//			}
//			mark = em.getMark();
//		}
		
		//G6 V1.0 SP1后续功能_自定义签收编号end
		edocExchangeManager.recEdoc(record.getId(), recUserId, registerUserId, mark, remark,keepperiod,agentToId);
		//affair = affairManager.getBySubObject(ApplicationCategoryEnum.exSign, record.getId());
		
		Map conditions = new HashMap();
		conditions.put("app", ApplicationCategoryEnum.exSign.key());
        conditions.put("objectId", record.getEdocId());
        conditions.put("subObjectId", record.getId());
        List<CtpAffair> affairList =affairManager.getByConditions(null,conditions);   
        
        if(null!=affairList && affairList.size()>0){
        	List<MessageReceiver> receivers = new ArrayList<MessageReceiver>();
        	for(CtpAffair af: affairList){
        		if(af.getMemberId().longValue() != user.getId() && af.isDelete()!= true){
        			receivers.add(new MessageReceiver(af.getId(), af.getMemberId()));
        		}
        		af.setState(StateEnum.edoc_exchange_received.getKey());
        		//af.setSubObjectId(Long.valueOf(id));
        		af.setFinish(true);
        		af.setDelete(true);
        		affairManager.updateAffair(af);
        	}
	        /*
	         *发消息给其他公文收发员，公文已签收 
	         */
        	if(null!=receivers && receivers.size()>0){
        		if(agentToId != null){
        			userMessageManager.sendSystemMessage(new MessageContent("exchange.signed", affairList.get(0).getSubject(), agentToName,affairList.get(0).getApp()).add("edoc.agent.deal", user.getName()), ApplicationCategoryEnum.edocRec, agentToId, receivers,EdocMessageFilterParamEnum.exchange.key);
        		}else{
        			userMessageManager.sendSystemMessage(new MessageContent("exchange.signed", affairList.get(0).getSubject(), user.getName(),affairList.get(0).getApp()), ApplicationCategoryEnum.edocRec, user.getId(), receivers,EdocMessageFilterParamEnum.exchange.key);
        		}
        	}
        }
        //修改了record对象后，再次获得最新的,不然从record中取登记人id就不对了
        record = edocExchangeManager.getReceivedRecord(record.getId());
		
        
      //每个版本都需要录入登记日志
		operationlogManager.insertOplog(record.getId(), ApplicationCategoryEnum.exchange, EactionType.LOG_EXCHANGE_REC, 
				EactionType.LOG_EXCHANGE_RECD_DESCRIPTION, user.getName(), record.getSubject());	        
		//xiangfan 添加日志GOV-1206
        appLogManager.insertLog(user, AppLogAction.Edoc_Sing_Exchange, user.getName(), record.getSubject());
        
        RecieveEdocManager recieveEdocManager = (RecieveEdocManager)AppContext.getBean("recieveEdocManager");
        //当是V5-A8版本或G6开启登记开关时，那么签收时就按照以前逻辑，生成待登记affair
		if(!EdocHelper.isG6Version()||isOpenRegister){
            CtpAffair reAffair = new CtpAffair();  // 登记人代办事项
            EdocSummary summary = edocSummaryManager.findById(record.getEdocId());
            ExchangeUtil.createRegisterAffair(reAffair, user, record, summary,StateEnum.edoc_exchange_register.getKey());
            affairManager.save(reAffair);
	        
            /*
	         * 发消息给待登记人
	         */
	        sendMessageToRegister(user, agentToId, reAffair);
            
	        //A8签收时也生成登记数据 
	        if(!EdocHelper.isG6Version()){
	        	EdocRegister register = ExchangeUtil.createAutoRegisterData(record, summary, record.getRegisterUserId(), orgManager);
		        edocRegisterManager.createEdocRegister(register);
		    }
		}
		//当G6版本关闭登记开关时，那么签收时，还要生成登记数据，并生成待分发affair
		else{
			CtpAffair reAffair = new CtpAffair();  // 登记人已办事项
			EdocSummary summary = edocSummaryManager.findById(record.getEdocId());
			ExchangeUtil.createRegisterAffair(reAffair, user, record,summary, StateEnum.edoc_exchange_registered.getKey());
	        affairManager.save(reAffair);
	        
	        //原来G6自动登记中有这个
	        appLogManager.insertLog(user, AppLogAction.Edoc_RegEdoc, user.getName(),record.getSubject());
	        
	        //分发人(当登记开关关闭时，在签收时就可直接选择分发人了)
	        long distributerId = registerUserId;
	        
	        //生成登记数据 
	        EdocRegister register = ExchangeUtil.createAutoRegisterData(record, summary, distributerId, orgManager);
	        edocRegisterManager.createEdocRegister(register);
	        
	        if(record!=null) {
	        	record.setStatus(EdocRecieveRecord.Exchange_iStatus_Registered);
	        	record.setRegisterName(register.getRegisterUserName());
	        	recieveEdocManager.update(record);
		    }
	        
	        Integer urgentLevel = null;
	        if(Strings.isNotBlank(register.getUrgentLevel()) && NumberUtils.isNumber(register.getUrgentLevel())){
	        	urgentLevel = Integer.parseInt(register.getUrgentLevel());
	        }
	      //v3x_affair表中增加待分发事项
	        distributeAffair(register.getSubject(),register.getRegisterUserId(),register.getDistributerId(),register.getId(),
	        		register.getDistributeEdocId(),"create",urgentLevel,register.getRegisterBody().getContentType());
	        
//	        String key = "edoc.registered"; //成功登记 (这个消息是  已成功登记，请分发，需要改为下面这个)
	        String key = "edoc.auto.registered"; //这个消息是  已成功签收，请分发
			long registerId = register.getId();
			distributerId = register.getDistributerId();
			String subject = register.getSubject();
			String url = "message.link.exchange.distribute"; 
			com.seeyon.ctp.common.usermessage.Constants.LinkOpenType linkOpenType = com.seeyon.ctp.common.usermessage.Constants.LinkOpenType.href;
			String agentApp = "agent";
			
			agentToName = "";
//			String registerName = member.getName();//登记人
			//
			String recieverName = orgManager.getMemberById(record.getRecUserId()).getName();

			//给分发人的代理人发消息
			sendRegisterMessage(key , subject, recieverName, agentToName, register.getRegisterUserId(), registerId, distributerId,
	        			"", "", url, linkOpenType, registerId, "");
			
			Long agentMemberId =  MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.edoc.key(), register.getDistributerId()); 
			if(agentMemberId != null){
				sendRegisterMessage(key , subject, recieverName, agentToName, register.getRegisterUserId(), registerId, agentMemberId, 
						"col.agent", "", url, linkOpenType, registerId, agentApp);
			}
	        
	    }
    
    }
	 private void distributeAffair(String subject, long senderId, long memberId, Long objectId, Long subObjectId, String comm, Integer importantLevel, String...bodyType) throws BusinessException {
	    	CtpAffair reAffair = null;
	    	if("delete".equals(comm)) {
	    		 affairManager.deleteByObjectId(ApplicationCategoryEnum.edocRegister, objectId);
	    	} else if("create".equals(comm)) {//这里注意，登记ojbectId, subState  分发：subObjectId, state
	    		reAffair = new CtpAffair();
	    		reAffair.setIdIfNew();
	    		reAffair.setDelete(false);
	    		reAffair.setSubject(subject);
	    		reAffair.setMemberId(memberId);
	    		reAffair.setSenderId(senderId);    		
	    		reAffair.setCreateDate(new Timestamp(System.currentTimeMillis()));
	    		reAffair.setReceiveTime(new Timestamp(System.currentTimeMillis()));
	    		reAffair.setObjectId(objectId);//登记的id
	    		reAffair.setSubObjectId(subObjectId);//分发的id
	    		// wangjingjing begin 发文分发 等于 交换中心的 待发送，所以这里的分发一定是 收文分发
	    		reAffair.setApp(ApplicationCategoryEnum.edocRecDistribute.getKey());
	    		//reAffair.setApp(31);
	    		// wangjingjing end
	        	reAffair.setState(3);//分发的状态
	        	
	        	//-------------待分发列表没有显示word图标bug 修复  changyi add
	        	if(bodyType !=null && bodyType.length == 1)
	        		reAffair.setBodyType(bodyType[0]);
	        	reAffair.setImportantLevel(importantLevel);
	    		affairManager.save(reAffair);
	    	}
	    }
	
	 /**
	  * G6 V1.0 SP1后续功能_签收时自动登记功能  --- 向待分发人员发送消息
	  * @param key
	  * @param subject
	  * @param userName
	  * @param agentName
	  * @param fromUserId
	  * @param registerId
	  * @param toUserId
	  * @param colAgent
	  * @param agentDeal
	  * @param url
	  * @param linkType
	  * @param param
	  * @param agentApp
	  * @throws Exception
	  */
	 private void sendRegisterMessage(String key, String subject, String userName, String agentName, long fromUserId, long registerId,
			 long toUserId, String colAgent, String agentDeal, String url, com.seeyon.ctp.common.usermessage.Constants.LinkOpenType linkType, 
			 long param, String agentApp) throws Exception { 
			MessageReceiver receiver = new MessageReceiver(registerId, toUserId, url, linkType, EdocEnum.edocType.recEdoc.ordinal(),
					String.valueOf(registerId), agentApp);
			MessageContent messageContent = new MessageContent(key, subject, userName);
			messageContent.setResource("com.seeyon.v3x.edoc.resources.i18n.EdocResource");
			messageContent.add(colAgent);
			messageContent.add(agentDeal, agentName);
			userMessageManager.sendSystemMessage(messageContent, ApplicationCategoryEnum.edocRecDistribute, fromUserId, receiver,EdocMessageFilterParamEnum.exchange.key);
			//XX已成功登记公文《XX》，请速进行分发处理’点击消息提醒链接到收文分发页面（用户在个人设置-消息提示设置里关闭收文的提示消息后不弹出该消息）
//			userMessageManager.sendSystemMessage(messageContent, ApplicationCategoryEnum.edocRec, fromUserId, receiver);
	    }
	
	
	private void sendMessageToRegister(User user, Long agentToId, CtpAffair reAffair) throws MessageException {
		String url = "message.link.exchange.register.pending"+Functions.suffix();
		List<String> messageParam = new ArrayList<String>();
		if(EdocHelper.isG6Version()){
			url = "message.link.exchange.register.govpending";
			/**
			 * G6点登记消息，转到登记页面地址
			 * http://localhost:8088/seeyon/edocController.do?method=newEdocRegister&comm=create&edocType=1&registerType=1
			 * &recieveId=179946784204145713&edocId=6526010927409218030&sendUnitId=8958087796226541112&listType=registerPending
			 */
			
			messageParam.add(reAffair.getSubObjectId().toString());
			messageParam.add(reAffair.getObjectId().toString());
			EdocManager edocManager = (EdocManager)AppContext.getBean("edocManager");
			try {
				EdocSummary summary = edocManager.getEdocSummaryById(reAffair.getObjectId(), false);
				//设置来文单位id
				messageParam.add(String.valueOf(summary.getOrgAccountId()));
			} catch (EdocException e) {
				log.error("根据id获取公文summary对象报错",e);
			}
			
		}else{
			/**
			 * A8点登记消息，转到收文新建页面地址
			 * /edocController.do?method=entryManager&amp;entry=recManager&amp;listType=newEdoc&amp;comm=register&amp;
			 * edocType={0}&amp;recieveId={1}&amp;edocId={2}
			 * 
			 */
			messageParam.add(String.valueOf(EdocEnum.edocType.recEdoc.ordinal()));
			messageParam.add(reAffair.getSubObjectId().toString());
			messageParam.add(reAffair.getObjectId().toString());
		}
		
		String key = "edoc.register";
		String userName = user.getName();
		//代理
		com.seeyon.ctp.common.usermessage.Constants.LinkOpenType linkOpenType = com.seeyon.ctp.common.usermessage.Constants.LinkOpenType.href;
		if(agentToId!=null){
			String agentToName= "";
			try{
				agentToName = orgManager.getMemberById(agentToId).getName();
			}catch(Exception e){
				log.error("获取代理人名字抛出异常", e);
			}
			MessageReceiver receiver = new MessageReceiver(reAffair.getId(), reAffair.getMemberId(),url, linkOpenType, messageParam.get(0),messageParam.get(1),messageParam.get(2), "" , reAffair.getAddition());
			try {
             userMessageManager.sendSystemMessage(new MessageContent(key,reAffair.getSubject(),agentToName).add("edoc.agent.deal", user.getName()), 
             		ApplicationCategoryEnum.edocRegister, agentToId, receiver,EdocMessageFilterParamEnum.exchange.key);
         } catch (BusinessException e) {
            
         }
			
			Long agentMemberId =  MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.edoc.key(), reAffair.getMemberId()); 
			if(agentMemberId != null){
				MessageReceiver agentReceiver = new MessageReceiver(reAffair.getId(), agentMemberId,url, linkOpenType, messageParam.get(0),messageParam.get(1),messageParam.get(2), "agent", reAffair.getAddition());
				try {
                 userMessageManager.sendSystemMessage(new MessageContent(key,reAffair.getSubject(),agentToName).add("edoc.agent.deal", user.getName()).add("col.agent")
                 		, ApplicationCategoryEnum.edocRegister, agentToId, agentReceiver,EdocMessageFilterParamEnum.exchange.key);
             } catch (BusinessException e) {
             }
			}
		}else{
			//非代理
			MessageReceiver receiver = new MessageReceiver(reAffair.getId(), reAffair.getMemberId(),url, linkOpenType, messageParam.get(0),messageParam.get(1),messageParam.get(2), "", reAffair.getAddition());
			try {
             userMessageManager.sendSystemMessage(new MessageContent(key,reAffair.getSubject(),userName)
             	, ApplicationCategoryEnum.edocRegister, user.getId(), receiver,EdocMessageFilterParamEnum.exchange.key);
         } catch (BusinessException e) {
         }
			
			Long agentMemberId =  MemberAgentBean.getInstance().getAgentMemberId(ApplicationCategoryEnum.edoc.key(), reAffair.getMemberId()); 
			if(agentMemberId != null){
				MessageReceiver agentReceiver = new MessageReceiver(reAffair.getId(), agentMemberId,url, linkOpenType, messageParam.get(0),messageParam.get(1),messageParam.get(2), "agent", reAffair.getAddition());
				try {
                 userMessageManager.sendSystemMessage(new MessageContent(key,reAffair.getSubject(),userName).add("col.agent")
                 		, ApplicationCategoryEnum.edocRegister, user.getId(), agentReceiver,EdocMessageFilterParamEnum.exchange.key);
             } catch (BusinessException e) {
             }
			}
		}
		
	}
}