package com.seeyon.v3x.services.cindafundform.manager;

import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.seeyon.client.CTPRestClient;
import com.seeyon.client.CTPServiceClientManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.v3x.services.cindafundform.po.CindaFundForm;
import com.seeyon.v3x.services.cindafundform.po.CindaFundFormAttachment;
import com.seeyon.v3x.services.cindafundform.po.CindaFundFormSubRecycle;
import com.seeyon.v3x.services.cindafundform.utils.FtpUtilInterface;

public class FFSManagerImpl implements FFSManager{
	private static final Log log = LogFactory.getLog(FFSManagerImpl.class);

	private AttachmentManager attachmentManager;
	private FileManager fileManager;
	private OrgManager orgManager;

	public FileManager getFileManager() {
		return fileManager;
	}

	public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}

	public AttachmentManager getAttachmentManager() {
		return attachmentManager;
	}

	public void setAttachmentManager(AttachmentManager attachmentManager) {
		this.attachmentManager = attachmentManager;
	}

	public OrgManager getOrgManager() {
		return orgManager;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	@Override
	public Map<String,Object> conversionXml(String crmXml){
		try {
			Map<String,Object> map = new HashMap<String, Object>();

			CindaFundForm form = new CindaFundForm();
			List<CindaFundFormSubRecycle> subFormRecycles = new ArrayList<CindaFundFormSubRecycle>();
			List<CindaFundFormAttachment> subFormAttachents = new ArrayList<CindaFundFormAttachment>();

			Document doc = DocumentHelper.parseText(crmXml);
			Element rootElt = doc.getRootElement(); // 获取根节点
			Iterator<?> iterator = rootElt.elementIterator(); // 获取根节点下的子节点
			while (iterator.hasNext()){
		        	Element applicant=(Element) iterator.next();
		        	Iterator<?> elementIterator = applicant.elementIterator();

		        	while (elementIterator.hasNext()) {

						Element eleChild = (Element) elementIterator.next();

		        		//合计
						if("amountCount".equals(eleChild.getName())){
							form.setAmountCount(eleChild.getText());
		  	        	}
						//业务部门
						if("businessDepartment".equals(eleChild.getName())){
							form.setBusinessDepartment(eleChild.getText());
		  	        	}
						//项目名称
						if("projectName".equals(eleChild.getName())){
							form.setProjectName(eleChild.getText());
		  	        	}
						//业务审批权限
						if("businessPromise".equals(eleChild.getName())){
							form.setBusinessPromise(eleChild.getText());
		  	        	}
						//批复金额
						if("approvalAmount".equals(eleChild.getName())){
							form.setApprovalAmount(eleChild.getText());
		  	        	}
						//合同签订金额
						if("contractAmount".equals(eleChild.getName())){
							form.setContractAmount(eleChild.getText());
		  	        	}
						//业务类型
						if("businessType".equals(eleChild.getName())){
							form.setBusinessType(eleChild.getText());
		  	        	}
						//决策批复文号
						if("decisionApprovalNum".equals(eleChild.getName())){
							form.setDecisionApprovalNum(eleChild.getText());
		  	        	}
						//批复日期
						if("approvalDate".equals(eleChild.getName())){
							form.setApprovalDate(eleChild.getText());
		  	        	}
						//签订日期
						if("signDate".equals(eleChild.getName())){
							form.setSignDate(eleChild.getText());
		  	        	}
						//申领金额
						if("applyAmount".equals(eleChild.getName())){
							form.setApplyAmount(eleChild.getText());
		  	        	}
						//币种
						if("currency".equals(eleChild.getName())){
							form.setCurrency(eleChild.getText());
		  	        	}
						//预计支付日期
						if("prepaidDate".equals(eleChild.getName())){
							form.setPrepaidDate(eleChild.getText());
		  	        	}
						//使用期限
						if("userTime".equals(eleChild.getName())){
							form.setUserTime(eleChild.getText());
		  	        	}
						//是否
						if("isornot".equals(eleChild.getName())){
							form.setIsornot(eleChild.getText());
		  	        	}
						//业务部门意见
						if("bdOpinion".equals(eleChild.getName())){
							form.setBdOpinion(eleChild.getText());
		  	        	}
						//分公司审批意见
						if("baOpinion".equals(eleChild.getName())){
							form.setBaOpinion(eleChild.getText());
		  	        	}
						//资金市场部审批意见
						if("cmdaOpinion".equals(eleChild.getName())){
							form.setCmdaOpinion(eleChild.getText());
		  	        	}
						//资金市场部部门领导意见
						if("cmdaLeadOpinion".equals(eleChild.getName())){
							form.setCmdaLeadOpinion(eleChild.getText());
		  	        	}
						//资金市场部门分管领导意见
						if("cmdabLeadOpinion".equals(eleChild.getName())){
							form.setCmdabLeadOpinion(eleChild.getText());
		  	        	}
						//公司领导
						if("companyLead".equals(eleChild.getName())){
							form.setCompanyLead(eleChild.getText());
		  	        	}
						//申领单编号
						if("declarationNum".equals(eleChild.getName())){
							form.setDeclarationNum(eleChild.getText());
		  	        	}
						//OA审批者
						if("oaApprovaler".equals(eleChild.getName())){
							form.setOaApprovaler(eleChild.getText());
		  	        	}
						//OA发送者
						if("oaSender".equals(eleChild.getName())){
							form.setOaSender(eleChild.getText());
		  	        	}
						//主题名称
						if("subject".equals(eleChild.getName())){
							form.setSubject(eleChild.getText());
		  	        	}
						//内部收益率
						if("internalRateOfReturn".equals(eleChild.getName())){
							form.setInternalRateOfReturn(eleChild.getText());
		  	        	}
						//客开 新增字段 start
						//是否分期付款
						if("isPeriodization".equals(eleChild.getName())){
							form.setIsPeriodization(eleChild.getText());
		  	        	}
						//项目端收益率
						if("projectOfReturn".equals(eleChild.getName())){
							form.setProjectOfReturn(eleChild.getText());
		  	        	}
						//客开 新增字段 end
						//项目回收时间
						DecimalFormat   df   =   new   DecimalFormat("###,##0.00");
						if("projectRecoveries".equals(eleChild.getName())){
				        	Iterator<?> elemIterator = eleChild.elementIterator();

							while (elemIterator.hasNext()) {

								CindaFundFormSubRecycle subFormRecycle = new CindaFundFormSubRecycle();

								Element eleChildSubform = (Element) elemIterator.next();
								Iterator<?> elemsubformIterator = eleChildSubform.elementIterator();
								while (elemsubformIterator.hasNext()) {

									Element eleChildSubforms = (Element) elemsubformIterator.next();
									//计划回收日期
									if("ptrDate".equals(eleChildSubforms.getName())){
										subFormRecycle.setPtrDate(eleChildSubforms.getText());
					  	        	}
									//计划回收金额
					  	        	if("ptrAmount".equals(eleChildSubforms.getName())){
					  	        		
					  	        		//修改金额数字格式为20,000.00
					  	        		subFormRecycle.setPtrAmount(df.format(Double.valueOf(eleChildSubforms.getText())));
					  	        	}
								}
				  	        	subFormRecycles.add(subFormRecycle);
							}
				        	form.setSubFormRecycle(subFormRecycles);
		  	        	}

						//附件
						if("files".equals(eleChild.getName())){

				        	Iterator<?> fileelemIterator = eleChild.elementIterator();

							while (fileelemIterator.hasNext()) {

								CindaFundFormAttachment subFormAttachent = new CindaFundFormAttachment();
				  	        	// 文件附件id
					        	Long longUUID = UUIDLong.longUUID();
					        	subFormAttachent.setId(longUUID);

								Element eleChildSubform = (Element) fileelemIterator.next();
								Iterator<?> elemsubformIterator = eleChildSubform.elementIterator();
								while (elemsubformIterator.hasNext()) {

									Element eleChildSubforms = (Element) elemsubformIterator.next();
					  	        	//文件名称
					  	        	if("fileName".equals(eleChildSubforms.getName())){
					  	        		subFormAttachent.setFileName(eleChildSubforms.getText());
					  	        	}
					  	        	//提交日期
					  	        	if("submitDate".equals(eleChildSubforms.getName())){
					  	        		subFormAttachent.setSubmitDate(eleChildSubforms.getText());
					  	        	}
					  	        	//文件路径
					  	        	if("filePath".equals(eleChildSubforms.getName())){
					  	        		subFormAttachent.setFilePath(eleChildSubforms.getText());
					  	        	}
								}
				  	        	subFormAttachents.add(subFormAttachent);
							}
				        	form.setSubFormAttachent(subFormAttachents);
		  	        	}
		        }
			}

			map.put("fundForm", form);

			return map;
		} catch (Exception e) {
			log.error("",e);
		}
		return null;
	}

	@Override
	public String getFFSWS(CindaFundForm cindaFundForm){
		try {
			String ffsXml = getFSxml(cindaFundForm);
			log.info("资金流程表单Xml:"+ffsXml);

			String fundSendDeptCode = AppContext.getSystemProperty("cindafundform.fundSendDeptCode");
			List<V3xOrgMember> members = orgManager.getMemberByName(cindaFundForm.getOaSender());
			String senderId = "";
			for (V3xOrgMember member : members) {
				// gelb add 2017-8-2 14:27:36 按照资金市场部处理 取父id
				V3xOrgDepartment v3xOrgDepartment = orgManager.getParentDepartment(member.getOrgDepartmentId());
				if ( v3xOrgDepartment != null && fundSendDeptCode.equals(v3xOrgDepartment.getCode())) {
					senderId = member.getLoginName();
				}
			}

			// gelb add 2017-8-2 14:27:36 增加判断，如果没获取人员，返回错误。
			if (StringUtils.isEmpty(senderId)) {
				log.warn("OA发送者 获取为空！");
				return "ERROR";
			}

			String name = AppContext.getSystemProperty("cindafundform.restUserName");
			String password = AppContext.getSystemProperty("cindafundform.restUserPwd");
			String ip = AppContext.getSystemProperty("cindafundform.webServiceIp");
			String port = AppContext.getSystemProperty("cindafundform.webServicePort");
			String fundformid = AppContext.getSystemProperty("cindafundform.fundFormId");

			log.info("senderId:" + senderId);
			CTPServiceClientManager clientManager = CTPServiceClientManager.getInstance(ip+":"+port);
			CTPRestClient client = clientManager.getRestClient();
			// 一次性验证token
			client.authenticate(name, password);
			Map<String,Object> info = new HashMap<String,Object>();
			info.put("senderLoginName", senderId);
			info.put("subject", cindaFundForm.getSubject());
			info.put("param", "0");
			info.put("data", ffsXml);
			log.info("info:" + info);
			String sumarryId = client.post("flow/"+fundformid, info, String.class);
			log.info("sumarryId:" + sumarryId);
			String result = saveFile(sumarryId, cindaFundForm.getSubFormAttachent() ,senderId);//客开 gxy 20180731 添加senderId参数
			if ("ERROR".equals(result))
			{
				return "ERROR";
			}
		} catch (Exception e) {
			log.error("",e);
			return "ERROR";
		}
		return "OK";
	}

	// gelb add 2017-8-2 16:31:54 增加ftp处理
	private FtpUtilInterface ftpUtil;

	public FtpUtilInterface getFtpUtil() {
		return ftpUtil;
	}

	public void setFtpUtil(FtpUtilInterface ftpUtil) {
		this.ftpUtil = ftpUtil;
	}

	private String saveFile(String result, List<CindaFundFormAttachment> attachments,String senderId){//客开 gxy 20180731 添加参数senderID
		InputStream is = null;
		String oaUploadUrl = AppContext.getSystemProperty("cindafundform.oaUploadUrl");
		try {
			// 初始化ftp连接
			log.info("打开ftp连接");
			ftpUtil.connectServer("");
			Long summaryId = Long.valueOf(result);
			for (int i = 0; i < attachments.size(); i++) {

				String ftpFilename = attachments.get(i).getFilePath();
				
				//客开 gxy 20180801 屏蔽附件名称前边的时间戳 start
				//String newfilename = oaUploadUrl + File.separator + String.valueOf(System.currentTimeMillis()) + attachments.get(i).getFileName();
				String newfilename = oaUploadUrl + File.separator + attachments.get(i).getFileName();
				//客开 gxy 20180801 屏蔽附件名称前边的时间戳 end

				// 从ftp下载文件
				ftpUtil.downloadReport(ftpFilename, newfilename);

				Long fjId = Long.valueOf(attachments.get(i).getId());
				File file = new File(newfilename);
				is = new FileInputStream(file);
				V3XFile v3xfile= fileManager.save(is, ApplicationCategoryEnum.collaboration, file.getName(), new Date(), true,senderId);//客开 gxy 20180731 添加参数senderID
				Long [] v3xfileIds=new Long[1];
				v3xfileIds[0]=v3xfile.getId();
				attachmentManager.create(v3xfileIds, ApplicationCategoryEnum.collaboration,summaryId,fjId);
			}
		} catch (Exception e) {
			log.error("保存文件出错：",e);
			return "ERROR";
		} finally {
			close(is);
			try {
				ftpUtil.closeServer();
				log.info("关闭ftp连接");
			} catch (IOException e) {
				log.warn("关闭ftp连接时异常：" + e);
			}
		}
		return "OK";
	}

	private String getFSxml(CindaFundForm cindaFundForm) throws Exception{

		String fundApprovalerDeptCode = AppContext.getSystemProperty("cindafundform.fundApprovalerDeptCode");
		List<V3xOrgMember> members = orgManager.getMemberByName(cindaFundForm.getOaApprovaler());
		Long oaApprovaler = null;
		for (V3xOrgMember member : members) {
			// gelb add 2017-8-2 14:27:36 按照资金市场部处理 取父id
			V3xOrgDepartment v3xOrgDepartment = orgManager.getParentDepartment(member.getOrgDepartmentId());
			if (v3xOrgDepartment != null && fundApprovalerDeptCode.equals(v3xOrgDepartment.getCode())) {
				oaApprovaler = member.getId();
			}
		}

		// gelb add 2017-8-2 14:27:36 增加判断，如果没获取审批者，打印warn
		if (oaApprovaler == null) {
			log.warn("审批者 获取为空！");
		}

		StringBuilder sb = new StringBuilder();
		sb.append("<formExport version=\"2.0\">");
		sb.append("<summary id=\"-9045873089517040257\" name=\"formmain_1522\"/>");
		sb.append("<definitions />");
		sb.append("<values>");
		sb.append("<column name=\"合计\">");
		sb.append("<value>"+cindaFundForm.getAmountCount()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"业务部门\">");
		sb.append("<value>"+cindaFundForm.getBusinessDepartment()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"项目名称\">");
		sb.append("<value>"+cindaFundForm.getProjectName()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"业务审批权限\">");
		sb.append("<value>"+cindaFundForm.getBusinessPromise()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"批复金额\">");
		sb.append("<value>"+cindaFundForm.getApprovalAmount()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"合同签订金额\">");
		sb.append("<value>"+cindaFundForm.getContractAmount()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"业务类型\">");
		sb.append("<value>"+cindaFundForm.getBusinessType()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"决策批复文号\">");
		sb.append("<value>"+cindaFundForm.getDecisionApprovalNum()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"批复日期\">");
		sb.append("<value>"+cindaFundForm.getApprovalDate()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"签订日期\">");
		sb.append("<value>"+cindaFundForm.getSignDate()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"申领金额\">");
		sb.append("<value>"+cindaFundForm.getApplyAmount()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"币种\">");
		sb.append("<value>"+cindaFundForm.getCurrency()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"预计支付日期\">");
		sb.append("<value>"+cindaFundForm.getPrepaidDate()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"使用期限\">");
		sb.append("<value>"+cindaFundForm.getUserTime()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"是否\">");
		sb.append("<value>"+cindaFundForm.getIsornot()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"业务部门意见\">");
		sb.append("<value>"+cindaFundForm.getBdOpinion()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"分公司审批意见\">");
		sb.append("<value>"+cindaFundForm.getCmdaOpinion()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"资金市场部审批意见\">");
		sb.append("<value>"+cindaFundForm.getCmdaOpinion()+"\r\n"+cindaFundForm.getCmdaLeadOpinion()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"资金市场部部门领导意见\">");
		sb.append("<value>"+cindaFundForm.getCmdaLeadOpinion()+"</value>");
		sb.append("</column>");
		/*sb.append("<column name=\"资金市场部门分管领导意见\">");
		sb.append("<value>"+cindaFundForm.getCmdabLeadOpinion()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"公司领导\">");
		sb.append("<value>"+cindaFundForm.getCompanyLead()+"</value>");
		sb.append("</column>");*/
		sb.append("<column name=\"申领单编号\">");
		sb.append("<value>"+cindaFundForm.getDeclarationNum()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"复审审批人\">");
		sb.append("<value>"+oaApprovaler+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"内部收益率\">");
		sb.append("<value>"+cindaFundForm.getInternalRateOfReturn()+"</value>");
		sb.append("</column>");
		//后续添加  客开  start
		sb.append("<column name=\"是否分期付款\">");
		sb.append("<value>"+cindaFundForm.getIsPeriodization()+"</value>");
		sb.append("</column>");
		sb.append("<column name=\"项目端收益率\">");
		sb.append("<value>"+cindaFundForm.getProjectOfReturn()+"</value>");
		sb.append("</column>");
		//后续添加  客开 end
		sb.append("</values>");
		sb.append("<subForms>");
		sb.append("<subForm>");
		sb.append("<definitions>");
		if (CollectionUtils.isNotEmpty(cindaFundForm.getSubFormRecycle()))
		{
			for (int i = 0; i < cindaFundForm.getSubFormRecycle().size(); i++) {
				sb.append("<column id=\"field0023\" type=\"0\" name=\"计划回收日期\" length=\"255\"/>");
				sb.append("<column id=\"field0024\" type=\"0\" name=\"计划回收金额\" length=\"255\"/>");
			}
		}
		else
		{
			sb.append("<column id=\"field0023\" type=\"0\" name=\"计划回收日期\" length=\"255\"/>");
			sb.append("<column id=\"field0024\" type=\"0\" name=\"计划回收金额\" length=\"255\"/>");
		}
		sb.append("</definitions>");
		sb.append("<values>");
		if (CollectionUtils.isNotEmpty(cindaFundForm.getSubFormRecycle()))
		{
			for (CindaFundFormSubRecycle subRecycle : cindaFundForm.getSubFormRecycle())
			{
				sb.append("<row>");
				sb.append("<column name=\"计划回收日期\">");
				sb.append("<value>"+subRecycle.getPtrDate()+"</value>");
				sb.append("</column>");
				sb.append("<column name=\"计划回收金额\">");
				sb.append("<value>"+subRecycle.getPtrAmount()+"</value>");
				sb.append("</column>");
				sb.append("</row>");
			}
		}
		else
		{
			sb.append("<row>");
			sb.append("<column name=\"计划回收日期\">");
			sb.append("<value></value>");
			sb.append("</column>");
			sb.append("<column name=\"计划回收金额\">");
			sb.append("<value></value>");
			sb.append("</column>");
			sb.append("</row>");
		}
		sb.append("</values>");
		sb.append("</subForm>");
		sb.append("<subForm>");
		sb.append("<definitions>");
		if (CollectionUtils.isNotEmpty(cindaFundForm.getSubFormAttachent()))
		{
			for (int i = 0; i < cindaFundForm.getSubFormAttachent().size(); i++) {
				sb.append("<column id=\"field0025\" type=\"0\" name=\"文件名称\" length=\"255\"/>");
				sb.append("<column id=\"field0026\" type=\"0\" name=\"提交日期\" length=\"255\"/>");
			}
		}
		else
		{
			sb.append("<column id=\"field0025\" type=\"0\" name=\"文件名称\" length=\"255\"/>");
			sb.append("<column id=\"field0026\" type=\"0\" name=\"提交日期\" length=\"255\"/>");
		}
		sb.append("</definitions>");
		sb.append("<values>");
		if (CollectionUtils.isNotEmpty(cindaFundForm.getSubFormAttachent()))
		{
			for (CindaFundFormAttachment attachment : cindaFundForm.getSubFormAttachent())
			{
				sb.append("<row>");
				sb.append("<column name=\"文件名称\">");
				sb.append("<value>"+String.valueOf(attachment.getId())+"</value>");
				sb.append("</column>");
				sb.append("<column name=\"提交日期\">");
				sb.append("<value>"+attachment.getSubmitDate()+"</value>");
				sb.append("</column>");
				sb.append("</row>");
			}
		}
		else
		{
			sb.append("<row>");
			sb.append("<column name=\"文件名称\">");
			sb.append("<value></value>");
			sb.append("</column>");
			sb.append("<column name=\"提交日期\">");
			sb.append("<value></value>");
			sb.append("</column>");
			sb.append("</row>");
		}
		sb.append("</values>");
		sb.append("</subForm>");
		sb.append("</subForms>");
		sb.append("</formExport>");

		log.info("自动发起XML："+sb.toString());

		return sb.toString();
	}

	private void close(Closeable stream){
		try {
			if(stream != null) stream.close();
		} catch (IOException e) {
		}
	}
}
