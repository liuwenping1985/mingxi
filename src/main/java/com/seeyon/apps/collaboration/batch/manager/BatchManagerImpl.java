/**
 *
 */
package com.seeyon.apps.collaboration.batch.manager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONException;
import com.alibaba.fastjson.JSONObject;
import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.batch.BatchData;
import com.seeyon.apps.collaboration.batch.BatchResult;
import com.seeyon.apps.collaboration.batch.BatchState;
import com.seeyon.apps.collaboration.batch.exception.BatchException;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.apps.edoc.bo.EdocSummaryBO;
import com.seeyon.apps.edoc.enums.EdocEnum;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.ctp.workflow.exception.BPMException;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;

public class BatchManagerImpl implements BatchManager {

    private static final Log LOGGER = LogFactory.getLog(BatchManagerImpl.class);

    private CollaborationApi collaborationApi;
    private Map<ApplicationCategoryEnum, BatchAppHandler> batchHandlerMap = new HashMap<ApplicationCategoryEnum, BatchAppHandler>();
    private EdocApi edocApi;

    private WorkflowApiManager wapi;

    private AffairManager affairManager;

    private TemplateManager templateManager;

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    public void setCollaborationApi(CollaborationApi collaborationApi) {
        this.collaborationApi = collaborationApi;
    }


    public void init() {
        Map<String, BatchAppHandler> superviseHandlers = AppContext.getBeansOfType(BatchAppHandler.class);
        for (String key : superviseHandlers.keySet()) {
            BatchAppHandler handler = superviseHandlers.get(key);
            try {
                batchHandlerMap.put(handler.getAppEnum(), handler);
            } catch (BusinessException e) {
                LOGGER.error("", e);
            }
        }
    }

    private BatchAppHandler getBatchHandler(ApplicationCategoryEnum appEnum) throws BusinessException {
        BatchAppHandler handler = batchHandlerMap.get(appEnum);
        if (handler == null) {
            throw new BusinessException("没有找到批处理处理器_" + appEnum.key());
        }
        return handler;
    }
    
    public Object transDoBatch1(Map<String, String> param) {

        String affairId = param.get("affairId");
        String summaryId = param.get("summaryId");
        String category = param.get("category");
        String parameter = String.valueOf(param.get("parameter"));
        String attitude = param.get("attitude");
        String content = param.get("content");
        String conditionsOfNodes = param.get("conditionsOfNodes");

        System.out.println("transDoBatch=start");
        System.out.println("affairId="+affairId);
        System.out.println("summaryId="+summaryId);
        System.out.println("category="+category);
        System.out.println("parameter="+parameter);
        System.out.println("attitude="+attitude);
        System.out.println("content="+content);
        System.out.println("conditionsOfNodes="+conditionsOfNodes);
        System.out.println("transDoBatch=end");


        Long affair = Long.parseLong(affairId);
        Long summary = Long.parseLong(summaryId);
        int cate = Integer.parseInt(category);
        try {
	        //同一个人PC端和移动端同时处理
	        CtpAffair a = affairManager.get(affair);
	        if (!Integer.valueOf(StateEnum.col_pending.getKey()).equals(a.getState())) {
	            BatchResult br = new BatchResult();
	            br.setAffairId(affair);
	            br.setResultCode(BatchState.hasFinished.getCode());
	            br.setSummaryId(summary);
	            br.addMessage(ResourceUtil.getString("collaboration.batch.alert.notdeal.25"));
	            br.setSubject(a.getSubject());
	            return resultToJson(br);
	        }
	        Object op = createOpinion(cate, parameter, attitude, content, summary, affair);
	        BatchData data = new BatchData(affair, summary, cate, op);
	        data.setConditionsOfNodes(conditionsOfNodes);
	        BatchResult ar = transDoBatchData(data);
	
	        return resultToJson(ar);
        } catch(BusinessException e){
        	LOGGER.error("", e);
        }
        return null;
    }
    

    @AjaxAccess
    public Object transDoBatch(Map<String, String> param) throws BusinessException {

        String affairId = param.get("affairId");
        String summaryId = param.get("summaryId");
        String category = param.get("category");
        String parameter = String.valueOf(param.get("parameter"));
        String attitude = param.get("attitude");
        String content = param.get("content");
        String conditionsOfNodes = param.get("conditionsOfNodes");

        System.out.println("transDoBatch=start");
        System.out.println("affairId="+affairId);
        System.out.println("summaryId="+summaryId);
        System.out.println("category="+category);
        System.out.println("parameter="+parameter);
        System.out.println("attitude="+attitude);
        System.out.println("content="+content);
        System.out.println("conditionsOfNodes="+conditionsOfNodes);
        System.out.println("transDoBatch=end");


        Long affair = Long.parseLong(affairId);
        Long summary = Long.parseLong(summaryId);
        int cate = Integer.parseInt(category);

        //同一个人PC端和移动端同时处理
        CtpAffair a = affairManager.get(affair);
        if (!Integer.valueOf(StateEnum.col_pending.getKey()).equals(a.getState())) {
            BatchResult br = new BatchResult();
            br.setAffairId(affair);
            br.setResultCode(BatchState.hasFinished.getCode());
            br.setSummaryId(summary);
            br.addMessage(ResourceUtil.getString("collaboration.batch.alert.notdeal.25"));
            br.setSubject(a.getSubject());
            return resultToJson(br);
        }
        Object op = createOpinion(cate, parameter, attitude, content, summary, affair);
        BatchData data = new BatchData(affair, summary, cate, op);
        data.setConditionsOfNodes(conditionsOfNodes);
        BatchResult ar = transDoBatchData(data);

        return resultToJson(ar);
    }


    private Object resultToJson(BatchResult batchResult) {
        if (batchResult.getResultCode() == BatchState.Normal.getCode()) {
            return "ok_success";
        }
        JSONObject json = new JSONObject();
        try {
            json.put("affairId", batchResult.getAffairId());
            json.put("summaryId", batchResult.getSummaryId());
            json.put("subject", batchResult.getSubject());
            json.put("resultCode", batchResult.getResultCode());
            if (batchResult.getMessage().length != 0) {
                JSONArray mL = new JSONArray();
                for (String message : batchResult.getMessage()) {
                    mL.add(message);
                }
                json.put("message", mL);
            }
        } catch (JSONException e) {
            LOGGER.error(e.getMessage(), e);
        }
        return json;
    }

    private Object createOpinion(int category, String parameter, String attitude, String opinionStr, Long moduleId,
                                 Long affair) throws BusinessException {
        if (Strings.isNotBlank(parameter)) {
            String[] pas = parameter.split(",");
            int att = -1;
            if (Strings.isNotBlank(attitude)) {
                att = Integer.parseInt(attitude);
            }
            Integer attit = getAttitude(Integer.parseInt(pas[0]), att);

            String opinionContent = opinionStr;
            if (pas.length > 1 && "2".equals(pas[1])) {// 没有意见框
                opinionContent = "";
            }
            ApplicationCategoryEnum catagory = ApplicationCategoryEnum.valueOf(category);
            BatchAppHandler handler = getBatchHandler(catagory);

            Object opinion = handler.getComment(attit, opinionContent, affair, moduleId);

            return opinion;
        }
        return null;
    }

    /**
     * 后台节点权限设置：
     * 1 -  显示已阅、同意和不同意
     * 2 -  显示同意和不同意
     * 3 -  不显示态度
     *
     * @param code - 后台意见设置
     * @param att
     * @return
     */
    private Integer getAttitude(int code, Integer att) {

        //后台节点权限设置：
        if (code != 3) {
            if (code == 2 && att == 1) {
                return 2;
            }
            return att;
        }
        return null;
    }

    private BatchResult transDoBatchData(BatchData d) throws BusinessException {
        User user = AppContext.getCurrentUser();
        BatchResult re = new BatchResult(d.getAffairId(), d.getSummaryId());
        ColSummary colSummary = null;
        try {
            BatchAppHandler handler = null;
            if (d.getCategory() == ApplicationCategoryEnum.collaboration.getKey()) {
                handler = getBatchHandler(ApplicationCategoryEnum.collaboration);
            } else if (d.getCategory() == ApplicationCategoryEnum.edoc.getKey()) {
                handler = getBatchHandler(ApplicationCategoryEnum.edoc);
            }
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("conditionsOfNodes", d.getConditionsOfNodes());

            colSummary = collaborationApi.getColSummary(d.getSummaryId());
            param.put("COL_SUMMARY_OBJ", colSummary);

            handler.transFinishWorkItem(d.getAffairId(), d.getSummaryId(), d.getOpinion(), user, param);
            re.setResultCode(BatchState.Normal.getCode());
        } catch (BatchException e) {
            re.setResultCode(e.getErrorCode());
            re.addMessage(e.getMessage());
        }
        if (colSummary != null) {
            re.setSubject(colSummary.getSubject());
        }
        return re;
    }

    /**
     * @param processId
     * @param user
     * @return true: 正常，可以处理，false，已经被加锁
     * @throws BatchException
     */
    private boolean checkProcess(String processId, User user) throws BatchException {
        if (Strings.isBlank(processId)) {
            return true;
        }

        try {
            String[] re = wapi.checkWorkFlowProcessLock(processId, String.valueOf(user.getId()));
            return "true".equals(re[0]);
        } catch (BPMException e) {
            throw new BatchException(BatchState.Error.getCode(), ResourceUtil.getString("collaboration.batch.alert.notdeal.20"));
        }
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    public BatchResult[] checkPreBatch(Map params) {
        User user = AppContext.getCurrentUser();
        List<String> _affairId = (List<String>) params.get("affairs");
        List<String> _summaryId = (List<String>) params.get("summarys");
        List<String> _category = (List<String>) params.get("categorys");
        System.out.print("_affairId=");
        for (String a : _affairId) {
            System.out.print(a + ",");
        }
        System.out.println();
        System.out.print("_summaryId=");
        for (String a : _summaryId) {
            System.out.print(a + ",");
        }
        System.out.println();
        System.out.print("_category=");
        for (String a : _category) {
            System.out.print(a + ",");
        }
        System.out.println();

        Long[] affairId = new Long[_affairId.size()];
        Long[] summaryId = new Long[_summaryId.size()];
        Integer[] category = new Integer[_category.size()];
        List<Long> summaryIdList = new ArrayList<Long>();
        for (int i = 0; i < _affairId.size(); i++) {
            affairId[i] = Long.parseLong(_affairId.get(i));
            summaryId[i] = Long.parseLong(_summaryId.get(i));
            category[i] = Integer.parseInt(_category.get(i));
        }

        WorkflowApiManager wapi = (WorkflowApiManager) AppContext.getBean("wapi");
        List<BatchResult> result = new ArrayList<BatchResult>();
        for (int i = 0; i < category.length; i++) {
            BatchResult batch = new BatchResult(affairId[i], summaryId[i]);
            try {
                List<String> parameter = new ArrayList<String>();
                isBatchSupport(category[i]);
                CtpAffair affair = affairManager.get(affairId[i]);
                if (!affairManager.isAffairValid(affair, true)) {
                    batch.setResultCode(BatchState.NoSuchSummary.getCode());
                    batch.addMessage(ResourceUtil.getString("collaboration.batch.alert.notdeal.14"));
                    result.add(batch);
                    continue;
                }
                if (!Integer.valueOf(StateEnum.col_pending.getKey()).equals(affair.getState())) {
                    batch.setResultCode(BatchState.hasFinished.getCode());
                    batch.addMessage(ResourceUtil.getString("collaboration.batch.alert.notdeal.25"));
                    result.add(batch);
                    continue;
                }
                String processId = null;
                Long caseId;
                String masterId = "";
                int code = -1;
                String[] codes = null;
                String appName = "";
                if (affair != null) {
                    //主动指定回退的节点和指定回退的中间节点不允许批处理
                    if (affair.getSubState() == SubStateEnum.col_pending_specialBack.key()
                            || affair.getSubState() == SubStateEnum.col_pending_specialBackCenter.key()) {
                        throw new BatchException(BatchState.SpecialBackNode.getCode(), ResourceUtil.getString("collaboration.batch.alert.notdeal.23"));
                    }
                    BatchAppHandler handler = null;
                    if (category[i].intValue() == 1) {
                        handler = getBatchHandler(ApplicationCategoryEnum.collaboration);

                        ColSummary summary = collaborationApi.getColSummary(summaryId[i]);
                        //判断节点权限
                        parameter.addAll(handler.checkAppPolicy(affair, summary));

                        batch.setProcessId(summary.getProcessId());
                        if (Integer.valueOf(summary.getBodyType()).equals(MainbodyType.FORM.getKey())) {
                            try {
                                handler.checkFormMustWrite(affair, summary);
                            } catch (BatchException e) {
                                batch.addMessage(parameter.get(0), parameter.get(1));
                                throw e;
                            }
                        }
                        appName = "collaboration";
                        processId = summary.getProcessId();
                        caseId = summary.getCaseId();
                        Long _masterId = summary.getFormRecordid();
                        masterId = _masterId == null ? "" : summary.getFormRecordid().toString();

                    } else {
                        EdocSummaryBO summary = edocApi.getEdocSummary(summaryId[i]);
                        processId = summary.getProcessId();

                        batch.setProcessId(summary.getProcessId());
                        //判断节点权限
                        handler = getBatchHandler(ApplicationCategoryEnum.edoc);
                        parameter.addAll(handler.checkAppPolicy(affair, summary));


                        appName = EdocEnum.getEdocAppName(summary.getEdocType());
                        processId = summary.getProcessId();
                        caseId = summary.getCaseId();
                        masterId = String.valueOf(summary.getId());

                    }
                    System.out.println("*****************appName="+appName+",processId="+processId+",caseId="+caseId+",affair.getActivityId()="+affair.getActivityId()+",user.getId()"
                            +user.getId()+", user.getLoginAccount()="+ user.getLoginAccount()+",+affair.getSubObjectId()="+affair.getSubObjectId()+",masterId="+masterId);
                    codes = wapi.checkWorkflowBatchOperationWithMsg(appName, processId, caseId, affair.getActivityId().toString(),
                            user.getId().toString(), user.getLoginAccount().toString(), affair.getSubObjectId(), masterId);
                    code = Integer.parseInt(codes[0]);
                    if (codes.length == 4) {
                        batch.setConditionsOfNodes(codes[3]);
                    }
                }
                if (summaryIdList.contains(summaryId[i])) {
                    throw new BatchException(BatchState.hasSameWorkFlow.getCode(), ResourceUtil.getString("collaboration.batch.alert.notdeal.24"));
                } else {
                    summaryIdList.add(summaryId[i]);
                }
                if (code == BatchState.Normal.getCode() && !checkProcess(processId, user)) {
                    code = BatchState.ProcessLocked.getCode();
                }

                if (code != -1) {
                    batch.setResultCode(code);
                } else {
                    batch.setResultCode(BatchState.Normal.getCode());
                }
                if (codes != null && codes.length > 1) {

                    batch.addMessage(parameter.get(0), parameter.get(1), codes[1]);
                    String msg = "";
                    if (Strings.isNotBlank(codes[1])) {
                        msg = codes[1];
                    } else if (batch.getResultCode() != BatchState.Normal.getCode()) {
                        msg = ResourceUtil.getString("collaboration.batch.alert.notdeal." + batch.getResultCode());
                    }
                    batch.addMessage(msg);
                } else {
                    batch.addMessage(parameter);
                }

            } catch (BatchException e) {
                //log.error("批量处理检查锁报错！",e);
                batch.setResultCode(e.getErrorCode());
                batch.addMessage(ResourceUtil.getString("collaboration.batch.alert.notdeal." + batch.getResultCode()));
            } catch (Exception e) {
                LOGGER.error("批量处理数据报错！", e);
                batch.setResultCode(BatchState.Error.getCode());
                batch.addMessage(ResourceUtil.getString("collaboration.batch.alert.notdeal.20"));
            }
            result.add(batch);
        }

        //对校验不通过的进行解锁操作 OA-128107
        if (Strings.isNotEmpty(result)) {

            String userIdStr = String.valueOf(user.getId());
            for (BatchResult item : result) {
                if (item.getResultCode() >= 10 && item.getProcessId() != null) {
                    //校验不通过的，直接解锁
                    try {
                        wapi.releaseWorkFlowProcessLock(item.getProcessId(), userIdStr, 14);
                    } catch (BPMException e) {
                        LOGGER.error("用户:" + user.getName() + "批处理解锁失败, processId=" + item.getProcessId(), e);
                    }
                }
            }
        }

        BatchResult[] rs= result.toArray(new BatchResult[0]);
        for(BatchResult r:rs){
            System.out.println("BatchResult="+r);
        }
        return rs;
    }

    /**
     * 应用是否支持批处理
     *
     * @param category
     * @return
     */
    private void isBatchSupport(int category) throws BatchException {
        //TODO supportCategory空
        /*if(!supportCategory.contains(String.valueOf(category))){
			throw new BatchException(BatchState.NotSupport.getCode());
		}*/
    }


    public void setWapi(WorkflowApiManager wapi) {
        this.wapi = wapi;
    }

    public void setEdocApi(EdocApi edocApi) {
        this.edocApi = edocApi;
    }

    public TemplateManager getTemplateManager() {
        return templateManager;
    }

    public void setTemplateManager(TemplateManager templateManager) {
        this.templateManager = templateManager;
    }


//    edit by taoanping start
public BatchResult[] checkPreBatch(Map params,User user) {
//    User user = AppContext.getCurrentUser();
    try {
        List<String> _affairId = (List<String>) params.get("affairs");
        List<String> _summaryId = (List<String>) params.get("summarys");
        List<String> _category = (List<String>) params.get("categorys");
        System.out.print("_affairId=");
        for (String a : _affairId) {
            System.out.print(a + ",");
        }
        System.out.println();
        System.out.print("_summaryId=");
        for (String a : _summaryId) {
            System.out.print(a + ",");
        }
        System.out.println();
        System.out.print("_category=");
        for (String a : _category) {
            System.out.print(a + ",");
        }
        System.out.println();

        Long[] affairId = new Long[_affairId.size()];
        Long[] summaryId = new Long[_summaryId.size()];
        Integer[] category = new Integer[_category.size()];
        List<Long> summaryIdList = new ArrayList<Long>();
        for (int i = 0; i < _affairId.size(); i++) {
            affairId[i] = Long.parseLong(_affairId.get(i));
            summaryId[i] = Long.parseLong(_summaryId.get(i));
            category[i] = Integer.parseInt(_category.get(i));
        }

        WorkflowApiManager wapi = (WorkflowApiManager) AppContext.getBean("wapi");
        List<BatchResult> result = new ArrayList<BatchResult>();
        for (int i = 0; i < category.length; i++) {
            BatchResult batch = new BatchResult(affairId[i], summaryId[i]);
            try {
                List<String> parameter = new ArrayList<String>();
                isBatchSupport(category[i]);
                CtpAffair affair = affairManager.get(affairId[i]);
                if (!affairManager.isAffairValid(affair, true)) {
                    batch.setResultCode(BatchState.NoSuchSummary.getCode());
                    batch.addMessage(ResourceUtil.getString("collaboration.batch.alert.notdeal.14"));
                    result.add(batch);
                    continue;
                }
                if (!Integer.valueOf(StateEnum.col_pending.getKey()).equals(affair.getState())) {
                    batch.setResultCode(BatchState.hasFinished.getCode());
                    batch.addMessage(ResourceUtil.getString("collaboration.batch.alert.notdeal.25"));
                    result.add(batch);
                    continue;
                }
                String processId = null;
                Long caseId;
                String masterId = "";
                int code = -1;
                String[] codes = null;
                String appName = "";
                if (affair != null) {
                    //主动指定回退的节点和指定回退的中间节点不允许批处理
                    if (affair.getSubState() == SubStateEnum.col_pending_specialBack.key()
                            || affair.getSubState() == SubStateEnum.col_pending_specialBackCenter.key()) {
                        throw new BatchException(BatchState.SpecialBackNode.getCode(), ResourceUtil.getString("collaboration.batch.alert.notdeal.23"));
                    }
                    BatchAppHandler handler = null;
                    if (category[i].intValue() == 1) {
                        handler = getBatchHandler(ApplicationCategoryEnum.collaboration);

                        ColSummary summary = collaborationApi.getColSummary(summaryId[i]);
                        //判断节点权限
                        parameter.addAll(handler.checkAppPolicy(affair, summary));

                        batch.setProcessId(summary.getProcessId());
                        if (Integer.valueOf(summary.getBodyType()).equals(MainbodyType.FORM.getKey())) {
                            try {
                                handler.checkFormMustWrite(affair, summary);
                            } catch (BatchException e) {
                                batch.addMessage(parameter.get(0), parameter.get(1));
                                throw e;
                            }
                        }
                        appName = "collaboration";
                        processId = summary.getProcessId();
                        caseId = summary.getCaseId();
                        Long _masterId = summary.getFormRecordid();
                        masterId = _masterId == null ? "" : summary.getFormRecordid().toString();

                    } else {
                        EdocSummaryBO summary = edocApi.getEdocSummary(summaryId[i]);
                        processId = summary.getProcessId();

                        batch.setProcessId(summary.getProcessId());
                        //判断节点权限
                        handler = getBatchHandler(ApplicationCategoryEnum.edoc);
                        parameter.addAll(handler.checkAppPolicy(affair, summary));


                        appName = EdocEnum.getEdocAppName(summary.getEdocType());
                        processId = summary.getProcessId();
                        caseId = summary.getCaseId();
                        masterId = String.valueOf(summary.getId());

                    }
                    System.out.println("定制==appName=" + appName + ",processId=" + processId + ",caseId=" + caseId + ",affair.getActivityId()=" + affair.getActivityId() + ",user.getId()" + user.getId() + ", user.getLoginAccount()=" + user.getLoginAccount() + ",+affair.getSubObjectId()=" + affair.getSubObjectId() + ",masterId=" + masterId);
                    codes = wapi.checkWorkflowBatchOperationWithMsg(appName, processId, caseId, affair.getActivityId().toString(), user.getId().toString(), user.getLoginAccount().toString(), affair.getSubObjectId(), masterId);
                    code = Integer.parseInt(codes[0]);
                    if (codes.length == 4) {
                        batch.setConditionsOfNodes(codes[3]);
                    }
                }
                if (summaryIdList.contains(summaryId[i])) {
                    throw new BatchException(BatchState.hasSameWorkFlow.getCode(), ResourceUtil.getString("collaboration.batch.alert.notdeal.24"));
                } else {
                    summaryIdList.add(summaryId[i]);
                }
                if (code == BatchState.Normal.getCode() && !checkProcess(processId, user)) {
                    code = BatchState.ProcessLocked.getCode();
                }

                if (code != -1) {
                    batch.setResultCode(code);
                } else {
                    batch.setResultCode(BatchState.Normal.getCode());
                }
                if (codes != null && codes.length > 1) {

                    batch.addMessage(parameter.get(0), parameter.get(1), codes[1]);
                    String msg = "";
                    if (Strings.isNotBlank(codes[1])) {
                        msg = codes[1];
                    } else if (batch.getResultCode() != BatchState.Normal.getCode()) {
                        msg = ResourceUtil.getString("collaboration.batch.alert.notdeal." + batch.getResultCode());
                    }
                    batch.addMessage(msg);
                } else {
                    batch.addMessage(parameter);
                }

            } catch (BatchException e) {
                //log.error("批量处理检查锁报错！",e);
                batch.setResultCode(e.getErrorCode());
                batch.addMessage(ResourceUtil.getString("collaboration.batch.alert.notdeal." + batch.getResultCode()));
            } catch (Exception e) {
                LOGGER.error("批量处理数据报错！", e);
                batch.setResultCode(BatchState.Error.getCode());
                batch.addMessage(ResourceUtil.getString("collaboration.batch.alert.notdeal.20"));
            }
            result.add(batch);
        }

        //对校验不通过的进行解锁操作 OA-128107
        if (Strings.isNotEmpty(result)) {

            String userIdStr = String.valueOf(user.getId());
            for (BatchResult item : result) {
                if (item.getResultCode() >= 10 && item.getProcessId() != null) {
                    //校验不通过的，直接解锁
                    try {
                        wapi.releaseWorkFlowProcessLock(item.getProcessId(), userIdStr, 14);
                    } catch (BPMException e) {
                        LOGGER.error("用户:" + user.getName() + "批处理解锁失败, processId=" + item.getProcessId(), e);
                    }
                }
            }
        }

        return result.toArray(new BatchResult[0]);
    }catch (Exception e){
        e.printStackTrace();
    }
    return  null;
}
//    edit by taoanping end

}
