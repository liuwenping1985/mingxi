package com.seeyon.apps.collaboration.manager;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.NumberUtils;
import org.apache.commons.logging.Log;

import com.seeyon.apps.collaboration.batch.BatchState;
import com.seeyon.apps.collaboration.batch.FinishResult;
import com.seeyon.apps.collaboration.batch.exception.BatchException;
import com.seeyon.apps.collaboration.batch.manager.BatchAppHandler;
import com.seeyon.apps.collaboration.enums.ColHandleType;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.ContentUtil;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.comment.Comment;
import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.permission.bo.NodePolicy;
import com.seeyon.ctp.common.permission.bo.Permission;
import com.seeyon.ctp.common.permission.manager.PermissionManager;
import com.seeyon.ctp.common.po.DataContainer;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.form.bean.FormAuthViewBean;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.modules.event.CollaborationFormBindEventListener;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.form.util.Enums.FormAuthorizationType;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.json.JSONUtil;

public class BatchColHandler extends BatchAppHandler {
	private static Log LOG = CtpLogFactory.getLog(BatchColHandler.class);
	private ColManager colManager;
	private AffairManager affairManager;
	private FormManager formManager;
	private ColPubManager colPubManager;
	private OrgManager orgManager;
	private PermissionManager permissionManager;
	private CollaborationFormBindEventListener collaborationFormBindEventListener;
    private MainbodyManager              ctpMainbodyManager;
    private TemplateManager              templateManager;
    
	public TemplateManager getTemplateManager() {
		return templateManager;
	}


	public void setTemplateManager(TemplateManager templateManager) {
		this.templateManager = templateManager;
	}


	public void setCollaborationFormBindEventListener(
			CollaborationFormBindEventListener collaborationFormBindEventListener) {
		this.collaborationFormBindEventListener = collaborationFormBindEventListener;
	}
	
	
	public OrgManager getOrgManager() {
		return orgManager;
	}

	public MainbodyManager getCtpMainbodyManager() {
		return ctpMainbodyManager;
	}


	public void setCtpMainbodyManager(MainbodyManager ctpMainbodyManager) {
		this.ctpMainbodyManager = ctpMainbodyManager;
	}


	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	public PermissionManager getPermissionManager() {
		return permissionManager;
	}

	public void setPermissionManager(PermissionManager permissionManager) {
		this.permissionManager = permissionManager;
	}

	public ColPubManager getColPubManager() {
		return colPubManager;
	}

	public void setColPubManager(ColPubManager colPubManager) {
		this.colPubManager = colPubManager;
	}

	public ColManager getColManager() {
		return colManager;
	}

	public void setColManager(ColManager colManager) {
		this.colManager = colManager;
	}

	public AffairManager getAffairManager() {
		return affairManager;
	}

	public void setAffairManager(AffairManager affairManager) {
		this.affairManager = affairManager;
	}

	public FormManager getFormManager() {
		return formManager;
	}

	public void setFormManager(FormManager formManager) {
		this.formManager = formManager;
	}

	@Override
	public Object getComment(Integer attitude, String opinionContent, long affairId, long moduleId)
			throws BusinessException {
		Comment opinion = new Comment();
		opinion.setAffairId(affairId);
		opinion.setCtype(Comment.CommentType.comment.getKey());// 批处理的时候设置类型为评论
		opinion.setClevel(1);
		opinion.setPid(0L);
		opinion.setModuleType(1);
		opinion.setModuleId(moduleId);
		opinion.setRelateInfo("[]");
		if (attitude != null) {
			switch (attitude.intValue()) {
			case 1:
				opinion.setExtAtt1("collaboration.dealAttitude.haveRead");
				break;
			case 2:
				opinion.setExtAtt1("collaboration.dealAttitude.agree");
				break;
			case 3:
				opinion.setExtAtt1("collaboration.dealAttitude.disagree");
				break;
			default:
				break;
			}
		}

		opinion.setContent(opinionContent);
		return opinion;
	}

	@Override
	public ApplicationCategoryEnum getAppEnum() throws BusinessException {
		return ApplicationCategoryEnum.collaboration;
	}
	
	
	public FinishResult transFinishWorkItem(long affairId, long summaryId, Object comment, User user,Map<String,Object> param) throws BatchException {
		int code = -1;
		String msg = "";
		FinishResult finishResult = new FinishResult();
		
		try {
			
			ColSummary summary = (ColSummary)param.get("COL_SUMMARY_OBJ");
			if(summary == null){
				summary  = colManager.getColSummaryById(summaryId);
			}
			
			//设置结果内容
			finishResult.setSubject(summary.getSubject());
			
			//检查流程锁
			if(!checkProcess(summary.getProcessId(), user)){
			    return finishResult;
			}
			CtpAffair affair = affairManager.get(affairId);
			
			if(!affairManager.isAffairValid(affair,true)){
				return finishResult;
			}
			
			//对表单数据对象附上初始值 
			if (String.valueOf(MainbodyType.FORM.getKey()).equals(affair.getBodyType())) {

				// 更新表单初始值
				String rightId = ContentUtil.findRightIdbyAffairIdOrTemplateId(affair, affair.getTempleteId());
				if (Strings.isNotBlank(rightId)) {
					rightId = rightId.split("[_]")[0];
				}
				formManager.procDefaultValue(summary.getFormAppid(), summary.getFormRecordid(), Long.valueOf(rightId),summaryId);
				
				
				//V50_SP2_NC业务集成插件_001_表单开发高级
		        if(collaborationFormBindEventListener != null){
		        	Map<String,String> ret = collaborationFormBindEventListener.checkBindEventBatch(affair.getFormAppId(), affair.getFormOperationId(), summary.getId());
		        	if(!"true".equals(ret.get("success"))){
		        		code = BatchState.fromAdvanced.getCode();
			        	msg = ret.get("msg");
		        	}
		        }
		        if(null!= summary.getTempleteId()){
		        	CtpTemplate ctpTemplate = templateManager.getCtpTemplate(summary.getTempleteId());
			        if (ctpTemplate != null){
		            	//模板标题
			        	param.put("templateColSubject",ctpTemplate.getColSubject()); 
		            	//模板工作流ID
			        	param.put("templateWorkflowId",ctpTemplate.getWorkflowId()); 
		        	}
		        }
		     
			}
			if(code != BatchState.fromAdvanced.getCode()){
				Comment opinion = (Comment)comment;
				colManager.transFinishWorkItemPublic(affair,summary,opinion,ColHandleType.finish, param);
			}
		}
		catch (Exception e) {
		    LOG.error("批处理异常", e);
		    if(code != BatchState.fromAdvanced.getCode()){
		    	code = BatchState.Error.getCode();
		    	msg = ResourceUtil.getString("collaboration.batch.alert.notdeal.20");
		    }
			throw new BatchException(code,msg);
		}
		if(code == BatchState.fromAdvanced.getCode()){
			throw new BatchException(code,msg);
		}
		
		return finishResult;
	}
	
	public List<String> checkAppPolicy(CtpAffair affair,Object object) throws BatchException{
		ColSummary summary = (ColSummary)object;
		NodePolicy policy=null;
		try {
			V3xOrgMember sender = orgManager.getMemberById(affair.getSenderId());
			
			Long flowPermAccountId = ColUtil.getFlowPermAccountId(sender.getOrgAccountId(), summary);
			
			String nodePermissionPolicy = "collaboration";
			//nodePermissionPolicy = activity.getSeeyonPolicy().getId();
			nodePermissionPolicy = affair.getNodePolicy();
			
			Permission permission = permissionManager.getPermission(EnumNameEnum.col_flow_perm_policy.name(), nodePermissionPolicy, flowPermAccountId);
			policy = permission.getNodePolicy();
		} catch (BusinessException e) {
			throw new BatchException(BatchState.Error.ordinal(), ResourceUtil.getString("collaboration.batch.alert.notdeal.20"));
		}
       return checkPolicy(policy);
	}
	
	
	@Override
	public void checkFormMustWrite(CtpAffair affair,Object object) throws Exception{
		ColSummary summary = (ColSummary) object;
		FormBean bean =  formManager.getForm(summary.getFormAppid());
	    Long formRightId = Long.valueOf(ContentUtil.findRightIdbyAffairIdOrTemplateId(affair,null).split("[_]")[0]);
        boolean isFormCanBatchDeal = formManager.isFormCanBatchDeal(summary.getFormAppid(),formRightId);
        //知会节点不需要判断必填项
        if(!isFormCanBatchDeal && !"inform".equals(affair.getNodePolicy())){
        	LOG.error("批处理：判断表单是否能批处理: FALSE,传入参数：formRightId："+formRightId+", formAppID:"+summary.getFormAppid());
        	throw new BatchException(BatchState.FormNotNull.getCode(),ResourceUtil.getString("collaboration.batch.alert.notdeal.16"));
        }
    	FormDataMasterBean formMasterData = formManager.getDataMasterBeanById(summary.getFormRecordid(), bean, null);
    	FormAuthViewBean formAuthViewBean = bean.getAuthViewBeanById(formRightId);
    	formMasterData = formManager.procDefaultValueAsValidate(bean, formMasterData, formAuthViewBean, summary.getId());
    	
        boolean isFormReadOnly =  false; 
        if(formAuthViewBean != null){
            String auth = formAuthViewBean.getType();
            isFormReadOnly = FormAuthorizationType.show.getKey().equals(auth);
        }
        
        
    	boolean isAffairReadOnly = AffairUtil.isFormReadonly(affair);
    	if(!isFormReadOnly && !isAffairReadOnly && !"inform".equals(affair.getNodePolicy())){
    	    try {
                formManager.validate(summary.getFormAppid(), formMasterData);
            } catch (BusinessException e) {
                LOG.error("批处理：判断表单是否能批处理: FALSE,传入参数：formMasterDataId："+summary.getFormRecordid()+", formAppID:"+summary.getFormAppid());
                Object forceCheck = JSONUtil.parseJSONString(e.getMessage(), DataContainer.class).get("forceCheck");
                if(null != forceCheck && "1".equals(forceCheck.toString())){//强制校验
                    throw new BatchException(BatchState.fromForcecheck.getCode(),ResourceUtil.getString("collaboration.batch.alert.notdeal.31"));
                }
            }
    	}
            
        boolean isForm = String.valueOf(MainbodyType.FORM.getKey()).equals(affair.getBodyType());
        if(isForm){
        	 List<CtpContentAll>  content = ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, affair.getObjectId());
             if(Strings.isNotEmpty(content)){
            	 String s = content.get(0).getContent();
            	 if(Strings.isNotBlank(s) && NumberUtils.isNumber(s)){
            		 throw new BatchException(BatchState.formHasWord.getCode(),ResourceUtil.getString("collaboration.batch.alert.notdeal.27"));
            	 }
             }
        }
       
        //V50_SP2_NC业务集成插件_001_表单开发高级
        if(collaborationFormBindEventListener != null){
        	collaborationFormBindEventListener.checkBatch(affair.getFormAppId(), affair.getFormOperationId(), summary.getId());
        }
     
	}
}
