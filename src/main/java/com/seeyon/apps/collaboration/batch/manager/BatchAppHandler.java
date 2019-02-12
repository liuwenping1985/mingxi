package com.seeyon.apps.collaboration.batch.manager;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.collaboration.batch.BatchState;
import com.seeyon.apps.collaboration.batch.FinishResult;
import com.seeyon.apps.collaboration.batch.exception.BatchException;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.permission.bo.NodePolicy;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.workflow.exception.BPMException;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;

public abstract class BatchAppHandler {
	
	public abstract Object getComment(Integer attitude,String opinionContent , long affairId , long moduleId) throws BusinessException;

	public abstract ApplicationCategoryEnum getAppEnum() throws BusinessException;
	
	/**
	 * 处理流程
	 * @param affairId
	 * @param summaryId
	 * @param comment 意见
	 * @param user 当前用户
	 * @throws BatchException
	 */
	public abstract FinishResult transFinishWorkItem(long affairId,long summaryId,Object comment,User user,Map<String,Object> param) throws BatchException;
	
	public boolean checkProcess(String processId,User user) throws BatchException{
	    if(Strings.isBlank(processId)){
	        return true;
	    }
	    WorkflowApiManager wapi = (WorkflowApiManager)AppContext.getBean("wapi");
	    try {
	        String[] re = wapi.checkWorkFlowProcessLock(processId, String.valueOf(user.getId()));
	        return "true".equals(re[0]); 
        }
	    catch (BPMException e) {
            throw new BatchException(BatchState.Error.getCode(), ResourceUtil.getString("collaboration.batch.alert.notdeal.20"));
        }
	}
	
	public abstract List<String> checkAppPolicy(CtpAffair affair,Object summary) throws Exception;
	
	public void checkFormMustWrite(CtpAffair affair,Object summary) throws Exception{}
	
	
	public List<String> checkPolicy(NodePolicy policy) throws BatchException{
		List<String> result = new ArrayList<String>(2);
		// SZP 需要放开
		/*
		if(policy.getBatch() == null){//不允许批量处理
			throw new BatchException(BatchState.PolicyNotOpe.getCode(),ResourceUtil.getString("collaboration.batch.alert.notdeal.12"));
		}else if(policy.getBatch() != 1){//不允许批量处理
			throw new BatchException(BatchState.PolicyNotOpe.getCode(),ResourceUtil.getString("collaboration.batch.alert.notdeal.12"));
		}*/
		if(policy.getAttitude() == null){
			result.add("1");
		}else{
			result.add(String.valueOf(policy.getAttitude()));
		}
		String baseAction = policy.getBaseAction();
		if(Strings.isNotBlank(baseAction)){
			if(baseAction.indexOf("Opinion") >=0){
				if(policy.getOpinionPolicy()!=null){
					result.add(String.valueOf(policy.getOpinionPolicy()));
				}else{
					result.add(String.valueOf(0));
				}
			}else{
				result.add(String.valueOf(2));
			}
		}
		return result;
	}
}
