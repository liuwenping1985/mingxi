/**
 * Author: wangchw
 * Rev: WorkflowApiManager.java
 * Date: 20122012-8-3上午08:46:03
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
*/
package com.seeyon.ctp.workflow.wapi;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumBean;
import com.seeyon.ctp.common.po.processlog.ProcessLogDetail;
import com.seeyon.ctp.common.template.vo.CtpTemplateVO;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.rest.resources.SeeyonBPMHandParam4Deal;
import com.seeyon.ctp.rest.resources.SeeyonBPMHandParam4SpecifyBack;
import com.seeyon.ctp.rest.resources.SeeyonBPMHandParam4Start;
import com.seeyon.ctp.rest.resources.SeeyonBPMHandParam4StepBack;
import com.seeyon.ctp.rest.resources.SeeyonBPMHandParam4Tackback;
import com.seeyon.ctp.rest.resources.SeeyonBPMHandResult;
import com.seeyon.ctp.workflow.exception.BPMException;
import com.seeyon.ctp.workflow.po.ProcessTemplete;
import com.seeyon.ctp.workflow.vo.CPMatchResultVO;
import com.seeyon.ctp.workflow.vo.ValidateResultVO;
import com.seeyon.ctp.workflow.vo.WFMoreSignSelectPerson;

import net.joinwork.bpm.definition.BPMAbstractNode;
import net.joinwork.bpm.definition.BPMActivity;
import net.joinwork.bpm.definition.BPMHumenActivity;
import net.joinwork.bpm.definition.BPMProcess;
import net.joinwork.bpm.engine.execute.BPMCase;
import net.joinwork.bpm.engine.wapi.WorkItem;
import net.joinwork.bpm.engine.wapi.WorkflowBpmContext;

/**
 * <p>Title: 工作流（V3XWorkflow）</p>
 * <p>Description: 工作流对外暴露的接口</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: 北京致远协创软件有限公司</p>
 * <p>Author: wangchw
 * <p>Time: 2012-8-3 上午08:46:03
*/
public interface WorkflowApiManager {
    
    /**
     * 根据模板ID，取得其流程结构
     * 
     * @param processTempleteId
     * @return
     * @throws BPMException
     */
    public BPMProcess getTemplateProcess(Long processTempleteId) throws BPMException;

    /**
     * 获取到模版中某一个节点的表单试图Id和操作权限Id（中间用逗号分隔开）
     * @param templateId 模版Id
     * @param nodeId nodeId==null的话，返回发起者节点的表单操作权限
     * @return 表单操作权限
     * @throws BPMException
     */
    public String getNodeFormViewAndOperationName(Long templateId, String nodeId) throws BPMException;
    public String getNodeFormViewAndOperationName(BPMProcess process, String nodeId) throws BPMException;

    /**
     * 获取到模版中某一个节点的表单操作权限
     * @param templateId 模版Id
     * @param nodeId nodeId==null的话，返回发起者节点的表单操作权限
     * @return 表单操作权限
     * @throws BPMException
     */
    public String getNodeFormOperationName(Long templateId, String nodeId) throws BPMException;
    
    /**
     * 获取到已发出流程中某一个节点的表单操作权限
     * @param processId
     * @param nodeId
     * @return
     * @throws BPMException
     */
    public String getNodeFormOperationNameFromRunning(String processId, String nodeId) throws BPMException;
    
    /**
     * 获取一个节点的poliCy相关的信息 [0]：表单操作权限，[1]：数据关联ID
     * @param processId
     * @param nodeId
     * @return
     * @throws BPMException
     */
    public String[] getNodePolicyInfos(String processId, String nodeId) throws BPMException;
    
    /**
     * 获取到模版中某一个节点的表单操作权限
     * @param templateId 模版Id
     * @param nodeId nodeId==null的话，返回发起者节点的表单操作权限
     * @return 表单操作权限
     * @throws BPMException
     */
    public String[] getNodePolicyInfosFromTemplate(Long templateId, String nodeId) throws BPMException;
    /**
     * 获取到已发出流程中某一个节点的表单操作权限
     * @param processId
     * @param nodeId
     * @return
     * @throws BPMException
     */
    @Deprecated
    public String getNodeMutilFormOperationNameFromRunning(String processId, String nodeId) throws BPMException;
    
    /**
     * 根据模版id和节点id获取到节点处理期限(返回代表处理期限的分钟数，0表示没有)
     * @param templateId
     * @param nodeId
     * @return
     * @throws BPMException
     */
    @Deprecated
    public int getDealTermFromTemplate(Long templateId, String nodeId) throws BPMException;
    
    /**
     * 根据已发起的流程id和节点id获取到节点处理期限(返回代表处理期限的分钟数，0表示没有)
     * @param templateId
     * @param nodeId
     * @return
     * @throws BPMException
     */
    @Deprecated
    public int getDealTermFromRunning(String processId, String nodeId) throws BPMException;

    /**
     * 保存协同/公文流程模版(含新增和更新)
     * @param processName
     * @param processTemplateId
     * @param processXml
     * @param createUser
     * @return
     * @throws BPMException
     */
    @Deprecated
    public long saveWorkflowTemplate(String moduleType, String processName, long processTemplateId, String processXml,
            String workflowRule, String createUser) throws BPMException;
    
    /**
     * 保存协同/公文流程模版(含新增和更新)
     * @param processName
     * @param processTemplateId
     * @param processXml
     * @param createUser
     * @param processEventJson 流程事件JSON格式数据
     * @return
     * @throws BPMException
     */
    public long saveWorkflowTemplate(String moduleType, String processName, long processTemplateId, String processXml,
            String workflowRule, String createUser, String processEventJson) throws BPMException;

    /**
     * 删除流程模版
     * @param processTemplateId 流程模版ID
     * @throws BPMException
     */
    public void deleteWorkflowTemplate(long processTemplateId) throws BPMException;

    /**
     * 保存草稿
     * @param processId 流程id
     * @param processXml 流程xml
     * @param moduleType 应用类型:例如协同collaboration,分区用
     * @param formId 表单记录Id（没有的话为0）
     * @return
     * @throws BPMException
     */
    public String saveProcessXmlDraf(String processId, String processXml, String moduleType) throws BPMException;

    /**
     * 通过工作流模版ID获得工作流模版定义xml内容
     * @param processId 模版ID
     * @return 流模版定义xml内容
     * @throws BPMException
     */
    public String selectWrokFlowTemplateXml(String processId) throws BPMException;
    
    /**
     * 
     * @param processId
     * @param isUpdateFormField 是否更新表单字段名称
     * @return
     * @throws BPMException
     */
    public String selectWrokFlowTemplateXml(String processId,boolean isUpdateFormFieldName) throws BPMException;

    /**
     * 通过工作流ID获得工作流定义xml内容
     * @param processId 流程ID
     * @return 流程定义xml内容
     * @throws BPMException
     */
    public String selectWrokFlowXml(String processId) throws BPMException;

    /**
     * 发送流程
     * @param context 工作流上下文对象
     * @return
     * @throws BPMException
     */
    public String[] transRunCase(WorkflowBpmContext context) throws BPMException;

    /**
     * 发送模版流程
     * @param context 工作流上下文对象
     * @return
     * @throws BPMException
     */
    public String[] transRunCaseFromTemplate(WorkflowBpmContext context) throws BPMException;

    /**
     * 处理任务事项
     * @param context
     * @throws BPMException
     */
    public String[] finishWorkItem(WorkflowBpmContext context) throws BPMException;
    
    /**
     * 处理任务事项
     * @param context
     * @throws BPMException
     */
    public String[] transFinishWorkItem(WorkflowBpmContext context) throws BPMException;

    /**
     * 流程回退:String[0]:状态标识;String[1]回退到的节点名称串：节点名称(权限名称)
     * @param context
     * @throws BPMException
     */
    public String[] stepBack(WorkflowBpmContext context) throws BPMException;
    
    /**
     * 撤销流程
     * @param context
     * @throws BPMException
     */
    public int cancelCase(WorkflowBpmContext context) throws BPMException;

    /**
     * 取回流程
     * @param context
     * @throws BPMException
     */
    public int takeBack(WorkflowBpmContext context) throws BPMException;

    /**
     * 终止流程
     * @param context
     * @throws BPMException
     */
    public void stopCase(WorkflowBpmContext context) throws BPMException;

    /**
     * 暂存待办
     * @param context
     * @throws BPMException
     */
    public void temporaryPending(WorkflowBpmContext context) throws BPMException;

    /**
     * 加签
     * @throws BPMException
     */
    @Deprecated
    public String[] addNode(String processId, String currentActivityId, String targetActivityId, String userId,
            int changeType, Map<Object, Object> message, String baseProcessXML, String baseReadyObjectJSON, String changeMessageJSON)
            throws BPMException;
    
    /**
     * 加签(含日志信息)
     * @param processId
     * @param currentActivityId
     * @param targetActivityId
     * @param userId
     * @param changeType
     * @param message
     * @param baseProcessXML
     * @param baseReadyObjectJSON
     * @param messageDataList
     * @param changeMessageJSON 同一次处理中，第一次加签时必须传递为null或者""
     * @return 返回值之前有五个元素，现在增加一个，变成六个。第六个是一个json，
     * 保存加签减签对流程修改的信息，第二次加签时需要将该json传递进来（最后一个参数changeMessageJSON）
     * @throws BPMException
     */
    public String[] addNode(String processId, String currentActivityId, String targetActivityId, String userId,
            int changeType, Map<Object, Object> message, String baseProcessXML, String baseReadyObjectJSON,String messageDataList, String changeMessageJSON)
            throws BPMException;

    /**
     * 加签(含日志信息)
     * @param processId
     * @param currentActivityId
     * @param targetActivityId
     * @param userId
     * @param changeType
     * @param message
     * @param baseProcessXML
     * @param baseReadyObjectJSON
     * @param messageDataList
     * @param changeMessageJSON 同一次处理中，第一次加签时必须传递为null或者""
     * @param addHumanNodes 新增节点列表，传入空列表， 自动填值
     * @return 返回值之前有五个元素，现在增加一个，变成六个。第六个是一个json，
     * 保存加签减签对流程修改的信息，第二次加签时需要将该json传递进来（最后一个参数changeMessageJSON）
     * @throws BPMException
     */
    public String[] addNode(String processId, String currentActivityId, String targetActivityId, String userId, int changeType,
            Map<Object, Object> message, String baseProcessXML, String baseReadyObjectJSON, String messageDataList,
            String changeMessageJSON, List<BPMHumenActivity> addHumanNodes) throws BPMException;
    
    /**
     * 减签
     * @throws BPMException
     */
    @Deprecated
    public String[] deleteNode(String processId, String currentActivityId, String userId, List<String> activityIdList,
            String baseProcessXML, String changeMessageJSON) throws BPMException;
    
    /**
     * 减签
     * @param processId
     * @param currentActivityId
     * @param userId
     * @param activityIdList
     * @param baseProcessXML
     * @param messageDataList
     * @param changeMessageJSON
     * @param summaryId
     * @param affairId
     * @return
     * @throws BPMException
     */
    public String[] deleteNode(String processId, String currentActivityId, String userId, List<String> activityIdList,
            String baseProcessXML, String messageDataList, String changeMessageJSON, String summaryId, String affairId) throws BPMException;

    /**
     * 标志任务事项为读取状态
     * @param itemId 任务事项ID
     * @throws BPMException
     */
    public void readWorkItem(Long workitemId) throws BPMException;

    /**
     * 流程预处理接口
     * @param context
     * @throws BPMException
     */
    public CPMatchResultVO transBeforeInvokeWorkFlow(WorkflowBpmContext context, CPMatchResultVO cpMatchResult)
            throws BPMException;

    /**
     * 唤醒流程
     * @param caseId 将要被唤醒的流程实例Id
     * @throws BPMException 抛出异常
     */
    @Deprecated
    public void awakeCase(WorkflowBpmContext context) throws BPMException;

    /**
     * 删除待发/草稿状态的流程
     * @param processId 流程ID
     * @param moduleType 应用ID
     * @param currentUserId 当前操作人员ID
     * @param currentUserName 当前操作人员姓名
     * @return
     * @throws BPMException
     */
    public void deleteProcessXmlDraf(String processId, String moduleType, Long currentUserId, String currentUserName)
            throws BPMException;

    /**
     * 
     * 获得指定节点的流程节点信息
     * @param processId 流程ID
     * @param moduleType 应用ID
     * @param nodePermissionPolicy 节点权限枚举对象
     * @return
     * @throws BPMException
     */
    public String getWorkflowNodesInfo(String processId, String moduleType, CtpEnumBean nodePermissionPolicy)
            throws BPMException;

    /**
     * 
     * 获得指定节点的流程节点信息
     * @param processId 流程ID
     * @param moduleType 应用ID
     * @param nodePermissionPolicy 节点权限枚举对象
     * @return
     * @throws BPMException
     */
    public String[] getWorkflowInfos(String processId, String moduleType, CtpEnumBean nodePermissionPolicy) throws BPMException;
    public String[] getWorkflowInfos(BPMProcess process, String moduleType, CtpEnumBean nodePermissionPolicy) throws BPMException;
    
    /**
     * 获取工作流引用的节点权限列表接口
     * @param moduleType 应用ID
     * @param processXml 流程xml
     * @param processId 流程ID
     * @param processTemplateId 流程模版ID
     * @return
     * @throws BPMException
     */
    public List<String> getWorkflowUsedPolicyIds(String moduleType, String processXml, String processId,
            String processTemplateId) throws BPMException;

    /**
     * 获取流程规则说明接口
     * @param moduleType
     * @param processTemplateId
     * @return
     * @throws BPMException
     */
    public String getWorkflowRuleInfo(String moduleType, String processTemplateId) throws BPMException;

    /**
     * 直接向表中新增一条草稿状态的记录(BATCH)，返回生成的ID给调用者。
     * @param processName 流程模版名称
     * @param processXml 流程模版内容
     * @param subProcessSetting 流程模版绑定的子流程信息
     * @param workflowRule 流程规则说明内容
     * @param createUser 创建人
     * @param formId 表单记录Id（没有的话为0）
     * @param batchId
     * @return
     * @throws BPMException
     */
    @Deprecated
    public long insertWorkflowTemplate(String moduleType, String processName, String processXml,
            String subProcessSetting, String workflowRule, String createUser, long formId, long batchId)
            throws BPMException;
    
    /**
     * 直接向表中新增一条草稿状态的记录(BATCH)，返回生成的ID给调用者。
     * @param processName 流程模版名称
     * @param processXml 流程模版内容
     * @param subProcessSetting 流程模版绑定的子流程信息
     * @param workflowRule 流程规则说明内容
     * @param createUser 创建人
     * @param formId 表单记录Id（没有的话为0）
     * @param batchId
     * @param processEventJson 流程事件JSON格式数据
     * @return
     * @throws BPMException
     */
    public long insertWorkflowTemplate(String moduleType, String processName, String processXml,
            String subProcessSetting, String workflowRule, String createUser, long formId, long batchId, String processEventJson)
            throws BPMException;

    /**
     * 
     * 先判断原始ID对应的记录状态，如果为草稿状态，则直接update原记录（BATCH），返回原始ID给调用者;
     * 如果为已发布状态，则根据原始ID查询old_template_Id，然后删除所有对应的记录，最后在表中新增一条草稿状态的记录(BATCH)，
     * 在old_template_Id中记录下原始ID值，返回原始ID给调用者。
     * @param batchId
     * @param id
     * @param fromId 表单记录Id（没有的话为0）
     * @param processName 流程模版名称
     * @param processXml 流程模版内容
     * @param subProcessSetting 流程模版绑定的子流程信息
     * @param workflowRule 流程规则说明内容
     * @param modifyUser 修改人
     * @throws BPMException
     */
    @Deprecated
    public long updateWorkflowTemplate(String moduleType, String processName, String processXml,
            String subProcessSetting, String workflowRule, String modifyUser, long formId, long batchId, long id)
            throws BPMException;

    /**
     * 
     * 先判断原始ID对应的记录状态，如果为草稿状态，则直接update原记录（BATCH），返回原始ID给调用者;
     * 如果为已发布状态，则根据原始ID查询old_template_Id，然后删除所有对应的记录，最后在表中新增一条草稿状态的记录(BATCH)，
     * 在old_template_Id中记录下原始ID值，返回原始ID给调用者。
     * @param batchId
     * @param id
     * @param fromId 表单记录Id（没有的话为0）
     * @param processName 流程模版名称
     * @param processXml 流程模版内容
     * @param subProcessSetting 流程模版绑定的子流程信息
     * @param workflowRule 流程规则说明内容
     * @param modifyUser 修改人
     * @param processEventJson 流程事件JSON格式数据
     * @throws BPMException
     */
    public long updateWorkflowTemplate(String moduleType, String processName, String processXml,
            String subProcessSetting, String workflowRule, String modifyUser, long formId, long batchId, long id, String processEventJson)
            throws BPMException;
    
    /**
     * 一、id为null时，表示直接向表中新增一条草稿状态的记录(BATCH)，返回生成的ID给调用者。
     * 二、id不为null时，表示如下含义：
     * 先判断原始ID对应的记录状态，如果为草稿状态，则直接update原记录（BATCH），返回原始ID给调用者;
     * 如果为已发布状态，则根据原始ID查询old_template_Id，然后删除所有对应的记录，最后在表中新增一条草稿状态的记录(BATCH)，
     * 在old_template_Id中记录下原始ID值，返回原始ID给调用者。
     * @param moduleType
     * @param processName 流程模版名称
     * @param processXml 流程模版内容
     * @param subProcessSetting 流程模版绑定的子流程信息
     * @param workflowRule 流程规则说明内容
     * @param createUser 创建人
     * @param formId 表单记录Id（没有的话为0）
     * @param batchId
     * @param id
     * @return
     * @throws BPMException
     */
    @Deprecated
    public long saveWorkflowTemplate(String moduleType, String processName, String processXml,
            String subProcessSetting, String workflowRule, String createUser, long formId, long batchId, long id)
            throws BPMException;

    /**
     * 先判断原始ID对应的记录状态，如果为草稿状态，则直接删除。如果为已发布状态，则记录该条记录为待删除状态(BATCH)，
     * 如果有对应的old_template_Id记录，则将该条记录直接删除，返回原始ID给调用者。
     * @param batchId
     * @param id
     * @throws BPMException
     */
    public void deleteWorkflowTemplate(long batchId, long id) throws BPMException;

    /**
     * 将信息模板信息同步到老的模板信息里面
     * @Author      : xuqw
     * @Date        : 2016年2月21日下午1:48:48
     * @param templateId
     * @throws BPMException
     */
    public void mergeWorkflowTemplate(long templateId) throws BPMException;
    
    /**
     * 根据原始ID和BATCH查询对应记录的状态:
     * 1.如果为草稿状态，则将状态直接改为已发布状态，将对应的子流程设置表中的记录标志为生效状态。
     * 2.如果为已发布状态，则根据原始ID、BATCH来查询old_template_Id对应的记录，如果有对应的记录，且记录状态为草稿状态，
     * 将这条记录的workflow等信息更新到已发布记录的对应字段中，然后删除old_template_Id对应的记录，
     * 将对应的子流程设置表中的记录标志为生效状态。
     * 3.如果为待删除状态，则直接将该条记录删除掉,根据ID将子流程设置表中为草稿状态的记录删除掉。
     * @param batchId
     * @throws BPMException
     */
    public  List<ProcessTemplete>  saveWorkflowTemplates(long batchId) throws BPMException;

    /**
     * 1.根据BATCH将所有草稿状态的记录删除
     * 2.根据ID将子流程设置表中为草稿状态的记录删除掉。
     * 3.根据BATCH和ID将待删除状态记录修改为已发布状态。
     * @param batchId
     * @throws BPMException
     */
    @Deprecated
    public void deleteWorkflowTemplates(long batchId) throws BPMException;

    /**
     * 根据workitemId获得节点权限id和name
     * @param subObjectId
     * @return
     * @throws BPMException
     */
    public String[] getNodePolicyIdAndName(String appName, String processId, String activityId) throws BPMException;
    
    /**
     * 克隆一个表单模版，除了表单id不相同之外，其他的全部相同
     * @param templateMap(key是老的模版id，value是新的标题)
     * @param newFormApp
     * @param state 模版状态（1发布 0草稿）
     * @return (key是老的模版id，value是新的模版id)
     * @throws BPMException
     */
    @Deprecated
    public Map<Long, Long> cloneWorkflowFormTemplateById(Map<Long, String> templateIdMap, Long newFormApp, Map<String, String> newViewOperationId, int state) throws BPMException;

    /**
     * 克隆一个表单模版，除了表单id不相同之外，其他的全部相同
     * @param templateMap(key是老的模版id，value是新的标题)
     * @param newFormApp
     * @param state 模版状态（1发布 0草稿）
     * @return (key是老的模版id，value是新的模版id)
     * @throws BPMException
     */
    public Map<Long, Long> cloneWorkflowFormTemplateById(Map<Long, String> templateIdMap, Long newFormApp, Map<String, String> newViewOperationId,Map<String,String> otherIdMaps, int state) throws BPMException;

    /**
     * 模版复制
     * @param templateId
     * @param state 模版状态（1发布 0草稿）
     * @return 新的模版Id
     * @throws BPMException
     */
    @Deprecated
    public Long cloneWorkflowTemplateById(Long templateId, int state) throws BPMException;

    /**
     * 导出接口（给定模版Id，将制定的模版查询出来）
     * @param workflowIds
     * @return
     * @throws BPMException
     */
    public Map<String, String> exportWorkFlow(List<String> workflowIds) throws BPMException;

    /**
     * 导入接口（给定文件，将指定的模版插入到数据库）
     * @param files
     * @return
     * @throws BPMException
     */
    @Deprecated
    public Map<String, String> importWorkFlow(File[] files) throws BPMException;
    
    /**
     * 导入接口（给定文件，将指定的模版插入到数据库）
     * @param files
     * @param workflowIdsMap
     * @return
     * @throws BPMException
     */
    public Map<String, String> importWorkFlow(File[] files,Map<String,String> workflowIdsMap) throws BPMException;

    /**
     * 设置模版状态
     * workflowIds为要导出的流程模板ID集合，flag：启用1,草稿0,删除-1
     * @param workflowIds
     * @param flag
     * @return
     * @throws BPMException
     */
    @Deprecated
    public Map<String, String> setWorkflowUseFlag(List<String> workflowIds, int flag) throws BPMException;

    /**
     * 对表单fromId的可能存在的垃圾数据进行清理
     * @param formId
     * @throws BPMException
     */
    public void deleteJunkDataOfWorkflowTemplates(long formId) throws BPMException;

    /**
     * 获得运行时流程图对象(该接口仅为M1提供)
     * @deprecated 废弃，建议使用 getBPMProcessForM1(String processId, Long caseId)这个方法
     * @param processId
     * @return
     * @throws BPMException
     */
    @Deprecated
    public BPMProcess getBPMProcessForM1(String processId) throws BPMException;
    
    /**
     * 获得运行时流程图对象(该接口仅为M1提供)，从历史库中查询
     * @param processId
     * @return
     * @throws BPMException
     */
    public BPMProcess getBPMProcessHis(String processId) throws BPMException ;
    /**
     * 获得运行时流程图对象(该接口仅为M1提供)
     * @param processId
     * @return
     * @throws BPMException
     */
    public BPMProcess getBPMProcessForM1(String processId, Long caseId) throws BPMException;

    /**
     * 获得运行时流程图中节点状态信息(该接口仅为M1提供)
     * @param caseId
     * @return
     * @throws BPMException
     */
    public Object[] getNodeStatusForM1(long caseId) throws BPMException;

    /**
     * 协同自动跳过定时任务接口：是否执行完成
     * @param processId
     * @param workitemId
     * @return
     * @throws BPMException
     */
    public boolean isExecuteFinished(String processId, long workitemId) throws BPMException;

    /**
     * 协同自动跳过定时任务接口：更新workitem的V3xOrgMember信息
     * @param processId
     * @param workitemId
     * @param activityId
     * @param nextMember
     * @return
     * @throws BPMException
     */
    public BPMActivity replaceWorkItemMember(String processId, long workitemId, String activityId,
            V3xOrgMember nextMember) throws BPMException;
    
    /**
     *  是否有未完成的子流程
     * @param processId
     * @param activityId
     * @return
     * @throws BPMException
     */
    public boolean hasUnFinishedNewflow(String processId,String activityId) throws BPMException;
    
    /**
     * 校验模版流程
     * @param formApp 表单Id
     * @param templateXML 模版xml
     * @return
     * @throws BPMException
     */
    public boolean validateTemplate(Long formApp, String templateXML) throws BPMException;
    
    /**
     * 获得开始节点绑定的表单信息
     * @param templateId
     * @return
     * @throws BPMException
     */
    public String[] getStartNodeFormPolicy(Long templateId)  throws BPMException;
    
    /**
     * 批处理工作流校验接口
     * @param appName
     * @param processId
     * @param caseId
     * @param currentNodeId
     * @param currentUserId
     * @param currentAccountId
     * @param currentWorkitemId
     * @param masterId
     * @param isForm
     * @return
     * @throws BPMException
     */
    @Deprecated
    public int checkWorkflowBatchOperation(String appName,
            String processId,
            long caseId,
            String currentNodeId,
            String currentUserId,
            String currentAccountId,
            long currentWorkitemId,
            String masterId
            ) throws BPMException;
    
    public String[] checkWorkflowBatchOperationWithMsg(
            String appName,
            String processId,
            long caseId,
            String currentNodeId,
            String currentUserId,
            String currentAccountId,
            long currentWorkitemId,
            String masterId
            ) throws BPMException;
    
    /**
     * 通过id查找到workitem对象
     * @param appName
     * @param id
     * @return
     * @throws BPMException
     */
    @Deprecated
    public WorkItem getWorkItemById(String appName,long id) throws BPMException;
    
    /**
     * 流程加锁接口
     * @param processId
     * @param userId
     * @return
     * @throws BPMException
     */
    public String[] lockWorkflowProcess(String processId, String userId,int action) throws BPMException;
    
    /**
     * 流程加锁接口
     * @param processId
     * @param userId
     * @param action
     * @param from
     * @return
     * @throws BPMException
     */
    public String[] lockWorkflowProcess(String processId, String userId,int action,String from) throws BPMException;  
    
    /**
     * 流程加锁
     * @param processId
     * @param userId
     * @param action
     * @param from
     * @param useNowexpirationTime
     * @return
     * @throws BPMException
     */
    public String[] lockWorkflowProcess(String processId, String userId,int action,String from,boolean useNowexpirationTime) throws BPMException ;
    /**
     * 流程解锁接口
     * @param processId
     * @param userId
     * @return
     * @throws BPMException
     */
    public String[] releaseWorkFlowProcessLock(String processId,String userId) throws BPMException;
    
    /**
     * 流程解锁接口
     * @param processId
     * @param userId
     * @param loginFrom
     * @return
     * @throws BPMException
     */
    public String[] releaseWorkFlowProcessLock(String processId,String userId,String loginFrom) throws BPMException;
    
    /**
     * 流程解锁接口，指定操作类型
     * @param processId
     * @param userId
     * @param action
     * @return
     * @throws BPMException
     */
    public String[] releaseWorkFlowProcessLock(String processId, String userId,int action) throws BPMException;
    
    /**
     * 检查锁
     * @param processId
     * @param userId
     * @return
     * @throws BPMException
     */
    public String[] checkWorkFlowProcessLock(String processId, String userId) throws BPMException;
    
    /**
     * 更新子流程绑定运行时信息
     * @param id
     * @param subProcessId
     * @param subCaseId
     * @param subStartUserId
     * @param subStartUserName
     * @throws BPMException
     */
    public void updateSubProcessRunning(long id,String subProcessId, long subCaseId,String subStartUserId,String subStartUserName) throws BPMException;
    
    /**
     * 判断工作流中是否包含指定field的表单控件节点
     * @param formFieldAttr
     * @param processXML
     * @return
     * @throws BPMException
     */
    public boolean isHaveFormFieldNodeByAttrAndProcessXML(String formFieldAttr, String processXML) throws BPMException;
    
    /**
     * 根据工作流模版id（协同或表单模版的workflow字段）获取用于克隆的流程以及校验消息
     * @param templateId
     * @param formApp
     * @return
     * @throws BPMException
     */
    public String[] selectProcessTemplateXMLForClone(String appName, String templateIdString, String formAppString,
            String oldWendanId, String newWendanId, String subProcessJson) throws BPMException;
    
    /**
     * 是否为交换类型的节点
     * @param appName
     * @param policyId
     * @param permissionAccount
     * @return
     */
    public boolean isExchangeNode(String appName, String policyId, long permissionAccount);
    
    /**
     * 
     * @param processId
     * @param relativeProcessId
     * @return
     * @throws BPMException
     */
    @Deprecated
    public boolean isRelateNewflow(String processId, String relativeProcessId) throws BPMException;
    
    @Deprecated
    public String[] canWorkflowCurrentNodeSubmit(String workitemId) throws BPMException;
    
    /**
     * 表单模版绑定的流程中是否包含列表中所包含的表单权限id
     * 返回一个List，如果包含则返回值对应的索引值为权限id，如果不包含对应的索引值为null
     * @param operationIdList
     * @param workTemplateId
     * @return
     * @throws BPMException
     */
    public List<String> isWorkflowTemplateHasOperationId(List<String> operationIdList, Long workTemplateId) throws BPMException;
    
    /**
     * 流程是否处于指定回退状态
     * @param caseId
     * @return
     * @throws BPMException
     */
    public boolean isInSpecialStepBackStatus(long caseId) throws BPMException;
    
    /**
     * 
     * @param caseId
     * @param isHistoryFlag
     * @return
     * @throws BPMException
     */
    public boolean isInSpecialStepBackStatus(long caseId, boolean isHistoryFlag) throws BPMException;
    
    /**
     * 根据子流程Id获取主流程Id，如果获取不到，那么返回null
     * @param caseId
     * @return
     * @throws BPMException
     */
    public Long getMainProcessIdBySubProcessId(Long subProcessId) throws BPMException;
    
    /**
     * 获得手动分支可选择数据
     * @param bpmProcess
     * @param currentNodeId
     * @param defaultHst
     * @return
     */
    @Deprecated
    public int getHandSelectOptionsNumber(BPMProcess bpmProcess,String currentNodeId, String defaultHst);
    
    /**
     * 新增模板
     * @param moduleType
     * @param processName
     * @param processXml
     * @param workflowRule
     * @param createUser
     * @return
     * @throws BPMException
     */
    @Deprecated
    public long insertWorkflowTemplate(String moduleType, String processName, String processXml,
            String workflowRule, String createUser) throws BPMException;
    
    /**
     * 修改模板
     * @param id
     * @param moduleType
     * @param processName
     * @param processXml
     * @param workflowRule
     * @param modifyUser
     * @return
     * @throws BPMException
     */
    @Deprecated
    public long updateWorkflowTemplate(long id,String moduleType, String processName, String processXml,
            String workflowRule, String modifyUser) throws BPMException;
    
    /**
     * 判断节点是否不满足分支条件
     * @param caseId
     * @param activityId
     * @return
     * @throws BPMException
     */
    public boolean isNodeDelete(long caseId,String activityId)  throws BPMException;
    public boolean isNodeDelete(long caseId, String activityId, boolean isHistoryFlag)  throws BPMException;

    /**
     * 自动跳过节点前的分支被选中时的校验：后面是否会有分支或选人的节点，如果有，则返回true，否则返回false
     * @param context
     * @param checkedNodeId
     * @param allSelectNodes
     * @param allNotSelectNodes
     * @param allSelectInformNodes
     * @return
     */
    public boolean transCheckBrachSelectedWorkFlow(WorkflowBpmContext context, String checkedNodeId,
            Set<String> allSelectNodes, Set<String> allNotSelectNodes,
            Set<String> allSelectInformNodes,Set<String> currentSelectInformNodes) throws BPMException;
    /**
     * 校验
     * @param process
     * @param theCase
     * @param workItem
     * @return
     * @throws BPMException
     */
    public String[] canWorkflowCurrentNodeSubmit(BPMProcess process,BPMCase theCase,WorkItem workItem) throws BPMException;

    /**
     * 根据fromAppId对该表单绑定的流程中的所有组织模型信息的有效信息进行校验：
     *  节点：含节点权限、表单视图、岗位的匹配范围
     *  分支：
     *  子流程触发信息：发起者、触发条件
     * @param formAppId
     * @return
     * @throws BPMException
     */
    @Deprecated
    public List<ValidateResultVO> validateWorkflowForBusinessGenerator(long formAppId) throws BPMException;
    
    /**
     * 获取流程事件信息
     * @param processId
     * @return
     */
    @Deprecated
    public String getWorkflowProcessEventValue(Long processId);
    
    /**
     * 是否有流程事件
     * @param processId 流程模版ID或者流程实例ID
     * @param isStart 是否为发起
     * @return
     */
    @Deprecated
    public boolean hasWorkflowProcessEventValue(Long processId, boolean isStart);

    /**
     * 业务生成器校验方法
     * @param appName
     * @param workflowId
     * @param formAppId
     * @param formId
     * @param startDefaultOperationId
     * @param normalDefaultOperationId
     * @return
     * @throws BPMException
     */
    @Deprecated
    public String[] validateProcessTemplateXMLForEgg(String appName, String workflowId, String myProcessXml,String formAppId,
            String formId, String startDefaultOperationId, String normalDefaultOperationId,String subProcessJson)throws BPMException;
    
    /**
     * 校验方法
     * @param appName
     * @param formAppId
     * @param workflowId
     * @return
     * @throws BPMException
     */
    public boolean isProcessTemplateOk(String appName,String formAppId,String workflowId) throws BPMException;
    
    /**
     * 校验方法
     * @param appName
     * @param formAppId
     * @param workflowId
     * @return
     * @throws BPMException
     */
    @Deprecated
    public String[] isProcessTemplatesOk(String appName,String formAppId,String[] workflowIds) throws BPMException;
    
    /**
     * 多级会签接口
     * @param typeAndIds
     * @return
     */
    public List<WFMoreSignSelectPerson> findMoreSignPersons(String typeAndIds);
    
    /**
     * 后台分支匹配：支持自动跳过
     * @param context
     * @return String[0]表示是否需要弹出选择界面：true需要，false不需要；String[1]表示经过哪些节点和不经过哪些节点
     */
    public String[] isPop(WorkflowBpmContext context) throws BPMException;
    
    /**
     * 获得超级节点状态:0表示为非超级节点;1表示超级节点待处理;2表示超级节点待触发;3表示超级节点待回退
     * @param process
     * @param nodeId
     * @return
     * @throws BPMException
     */
    public int getSuperNodeStatus(String process,String nodeId) throws BPMException;
    
    /**
     * 
     * @param processId
     * @param nodeId
     * @param isHistoryFlag
     * @return
     */
    public String getNodeFormOperationNameFromRunning(String processId, String nodeId,boolean isHistoryFlag) throws BPMException;

    /**
     * 
     * @param processId
     * @param activityId
     * @param id
     * @param id2
     * @return
     */
    public List<V3xOrgMember> getUserListForNodeReplace(String processId, String activityId, Long currentUserId, Long currentAccountId);
    
    /**
     * 
     * @param isUpdateProcess
     * @param memberId
     * @param processId
     * @param workitemId
     * @param activityId
     * @param nextMember
     * @param isDealTerm 是否是转办
     * @return
     * @throws BPMException
     */
    public Object[] replaceWorkItemMembers(boolean isUpdateProcess,Long memberId,String processId, long workitemId, 
            String activityId, List<V3xOrgMember> nextMember,boolean isTransfer) throws BPMException;

    /**
     * 
     * @param subObjectId
     * @throws BPMException
     */
    public void moveWorkitemHistoryToRun(Long workitemId) throws BPMException;
    
    /**
     * 
     * @param currentUserId
     * @param currentUserName
     * @param processId
     * @param currentNodeId
     * @return
     * @throws BPMException
     */
    public String getWorkflowNodeRelationInfoJsonForSass(String currentUserId,String currentUserName,String processId,
			String currentNodeId) throws BPMException;
    
    /**
     * @param isRunning 是否为运行中的流程
     * @param processId 流程ID
     * @param caseId 如果是模板则该参数为null
     * @return json格式的字符串，格式如下:
     * <br>
     <br>{
	<br>"nodes":[
	<br>	{
	<br>		"id":"节点ID",
	<br>		"name":"节点名称",
	<br>		"x":"x坐标",
	<br>		"y":"y坐标",
	<br>		"type":"节点类型:start/end/split/join/humen",
	<br>		"state":"节点状态",
	<br>		"read":"节点是否查看状态",
	<br>		"accountId":"节点所属单位ID",
	<br>		"accountName":"节点单位名称",
	<br>		"policyId":"节点权限ID",
	<br>		"policyName":"节点权限名称",
	<br>		"partyId":"参与者ID",
	<br>		"partyName":"参与者名称",
	<br>		"partyType":"参与者类型",
	<br>		"formAppId":"表单ID",
	<br>		"formId":"表单视图ID",
	<br>		"formOperationId":"表单操作权限ID",
	<br>		"nf":"是否有子流程",
	<br>		"condition":{
	<br>			"type":"分支类型",
	<br>			"base":"参照判断类型",
	<br>			"expression":"分支表达式",
	<br>			"title":"分支标题"
	<br>		},
	<br>		"members":[
	<br>			{
	<br>				"id":"人员ID",
	<br>				"name":"人员名称",
	<br>				"aname":"单位简称",
	<br>				"status":"人员状态:0删除,1离职,2未分配,3停用",
	<br>				"hstate":"处理状态",
	<br>				"read":"是否看过:true/false"
	<br>			},
	<br>			{
	<br>				"id":"人员ID",
	<br>				"name":"人员名称",
	<br>				"aname":"单位简称",
	<br>				"status":"人员状态:0删除,1离职,2未分配,3停用",
	<br>				"hstate":"处理状态",
	<br>				"read":"是否看过:true/false"
	<br>			},
	<br>			{
	<br>				"id":"人员ID",
	<br>				"name":"人员名称",
	<br>				"aname":"单位简称",
	<br>				"status":"人员状态:0删除,1离职,2未分配,3停用",
	<br>				"hstate":"处理状态",
	<br>				"read":"是否看过:true/false"
	<br>			}		
	<br>		],
	<br>		"pids":[
	<br>			"上节点1ID",
	<br>			"上节点2ID"
	<br>		],
	<br>		"cids":[
	<br>			"孩子点1ID",
	<br>			"孩子点2ID"
	<br>		]
	<br>	}
	<br>]
	<br>}
     * 
     */
    public String getWorkflowJsonForMobile(boolean isRunning,String processId,String caseId) throws BPMException;

    /**
     * 重载getWorkflowJsonForMobile， 复合节点不包含人员信息
     * 
     * @param isRunning
     * @param processId
     * @param caseId
     * @param 当前登录人名称
     * @return
     * @throws BPMException
     *
     * @Since A8-V5 6.1
     * @Author      : xuqw
     * @Date        : 2017年4月1日下午4:31:01
     *
     */
    public String getWorkflowJsonForMobileNoMembers(boolean isRunning,String processId,String caseId, String currentUserName) throws BPMException;
    
    
    /**
     * 
     * @param processXml
     * @return
     * @throws BPMException
     */
    public String getWorkflowJsonForMobile(String processXml, List<String> showNodes,String caseId) throws BPMException;
    
    
    /**
     * 获取流程实例的XML数据
     * @param isRunning
     * @param processId
     * @param caseId
     * @return
     * @throws BPMException
     */
    public String getWorkflowXMLForMobile(boolean isRunning,String processId,String caseId) throws BPMException;
    
    
    /**
     * 是否可以取回流程
     * @param appName
     * @param processId
     * @param activityId
     * @param workitemId
     * @return
     * @throws BPMException
     */
    public String canTakeBack(String appName, String processId, String activityId, String workitemId) throws BPMException ;

    /**
     * 添加节点
     * @param workflowXml
     * @param orgJson
     * @param currentNodeId
     * @param type
     * @return
     */
	public String freeAddNode(String workflowXml,String orgJson,String currentNodeId,String type,String currentUserId,String currentUserName, 
	        String currentAccountId,String currentAccountName,String defaultPolicyId,String defaultPolicyName,List<BPMHumenActivity> addHumanNodes) throws BPMException;

	/**
	 * 
	 * @param workflowXml
	 * @param currentNodeId
	 * @return
	 * @throws BPMException
	 */
	public String freeDeleteNode(String workflowXml, String currentNodeId) throws BPMException;

	/**
	 * 
	 * 替换节点，  节点替换会重新生成ID
	 * 
	 * @param workflowXml
	 * @param currentNodeId
	 * @param oneOrgJson
	 * @param defaultPolicyId
	 * @param defaultPolicyName
	 * @return ret[0] = processXML,  ret[1]=newID
	 * @throws BPMException
	 */
	public String[] freeReplaceNode(String workflowXml, String currentNodeId,String oneOrgJson,String defaultPolicyId,
			String defaultPolicyName,BPMCase theCase) throws BPMException;

	/**
	 * 
	 * @param workflowXml
	 * @param currentNodeId
	 * @param nodePropertyJson
	 * @param updateAll 是否更新全部节点
	 * @return
	 * @throws BPMException
	 */
	public String freeChangeNodeProperty(String workflowXml, String currentNodeId, String nodePropertyJson, boolean updateAll, List<String> updateNodesList,BPMCase theCase) throws BPMException;
	
	/**
	 * 获取流程图节点列表，有顺序的
	 * @param processId
	 * @return
	 * @throws BPMException
	 */
	public List<BPMAbstractNode> getHumenNodeInOrderFromId(String processId) throws BPMException;
	
	/**
	 * 获取流程图节点列表，有顺序的
	 * @param processId
	 * @return
	 * @throws BPMException
	 */
	public List<BPMAbstractNode> getHumenNodeInOrderFromProcess(BPMProcess process) throws BPMException;
	
	/**
	 * 获取流程图节点列表，有顺序的
	 * @param processXml
	 * @return
	 * @throws BPMException
	 */
	public List<BPMAbstractNode> getHumenNodeInOrderFromXml(String processXml) throws BPMException;

	
	/**
	 * 校验节点是否能指定回退
	 */
	public String[] validateCurrentSelectedNode(String caseId, String currentSelectedNodeId,
			String currentSelectedNodeName, String currentStepbackNodeId, String initialize_processXml,
			String permissionAccountId, String configCategory, String processId) throws BPMException;



	/**
	 * 节点是否是只读，用与加签的时候的表单权限的设置。（同当前节点还是只读）
	 * @param nodeId  节点Id
	 * @param processId 流程Id
	 * @return
	 * @throws BPMException
	 */
	public boolean isNodeFormReadonly(String nodeId, String processId) throws BPMException ;
	
	/**
	 * 
	 * @param memberId
	 * @param accountId
	 * @param ids
	 * @param blur
	 * @param types
	 * @return
	 * @throws BusinessException
	 */
	public List<CtpTemplateVO> getCtpTemplateByOrgIdsAndCategory(Long currentUserId,boolean isLeave,Long memberId,Long accountId, List<String> ids, boolean blur,ApplicationCategoryEnum... types) throws BusinessException;

	public List<CtpTemplateVO> getCtpTemplateByOrgIdsAndCategory(Long currentUserId, Long accountId, String orgId, ApplicationCategoryEnum... types) throws BusinessException;

	/**
	 * 获取节点名字
	 * @param processTemplateId 模板流程ID
	 * @param nodeId  节点Id
	 * @return
	 */
	public String getBPMActivityDesc(Long processTemplateId, String nodeId) ;
	
	/**
	 * 
	 * @param key
	 * @return
	 */
	public List<ProcessLogDetail> getAllWorkflowMatchLogAndRemoveCache();
	
	/**
	 * 
	 * @param conditionsOfNodes
	 * @return
	 */
	public List<ProcessLogDetail> getAllWorkflowMatchLogAndRemoveCache(String conditionsOfNodes);
	
	/**
	 * 
	 * @param matchRequestToken
	 * @return
	 */
	public List<ProcessLogDetail> getAllWorkflowMatchLogAndRemoveCache(String matchRequestToken,String conditionsOfNodes);
	
	
	/**
	 * @param matchRequestToken
	 * @param autoSkipNodeId
	 * @param autoSkipNodeName
	 * @param matchState
	 */
	public void putWorkflowMatchLogMatchStateToCache(String matchRequestToken, String autoSkipNodeId,String autoSkipNodeName, int matchState);
	
	/**
	 * 
	 * @param matchRequestToken
	 * @param autoSkipNodeId
	 * @param autoSkipNodeName
	 * @param processMode
	 */
	public void putWorkflowMatchLogProcessModeToCache(String matchRequestToken, String autoSkipNodeId,String autoSkipNodeName, List<String> processMode);

	/**
	 * 
	 * @param matchRequestToken
	 * @param autoSkipNodeId
	 * @param autoSkipNodeName
	 * @param nodeType
	 */
	public void putWorkflowMatchLogNodeTypeToCache(String matchRequestToken, String autoSkipNodeId,String autoSkipNodeName, String nodeType);
	
	/**
     * 
     * @param matchRequestToken
     * @param autoSkipNodeId
     * @param canNotSkipMsgList
     */
    public void putWorkflowMatchLogToCache(String stepIndex,String key, String autoSkipNodeId,String nodeName,List<String> canNotSkipMsgList);
	
	/**
	 * 
	 * @param matchRequestToken
	 * @param autoSkipNodeId
	 * @param canNotSkipMsg
	 */
    public void putWorkflowMatchLogMsgToCache(String stepIndex,String key, String autoSkipNodeId,String nodeName, String canNotSkipMsg);

	/**
	 * 
	 * @param matchRequestToken
	 * @param id
	 * @param canNotSkipMsgList
	 */
	public void putWorkflowMatchLogToCacheHead(String stepIndex,String key, String autoSkipNodeId, String nodeName,List<String> canNotSkipMsgList);
	
	/*
	 * 获取流程锁国际化提示信息
	 */
	public String getLockMsg(String action, String userName, String from,Long lockTime);

	/**
	 * 
	 * @param matchRequestToken
	 */
	public void removeAllWorkflowMatchLogCache(String matchRequestToken);

	/**
	 * 
	 * @param matchRequestToken
	 * @param id
	 * @param nodeName
	 */
	public void putWorkflowMatchLogMatchNodeNameToCache(String matchRequestToken, String id,String nodeName);

	/**
	 * 
	 * @param bpmActivity
	 * @return
	 */
	public String[] getNodeTypeName(BPMActivity bpmActivity, com.seeyon.ctp.common.authenticate.domain.User user);

	/**
	 * 记录匹配流程日志
	 * @param matchRequestToken
	 * @param processId
	 * @param bpmActivity
	 * @param user
	 * @param params
	 */
	public void saveMatchProcessLog(int state,String matchRequestToken,String processId,
			BPMActivity bpmActivity,com.seeyon.ctp.common.authenticate.domain.User user,String... params); 
	
	
	/**
     * 取回已办事项
     * 
     * @param takeBackParam
     * @return
     * @throws BusinessException
     *
     * @Since A8-V5 6.1SP1
     * @Author      : xuqw
     * @Date        : 2017年6月30日上午11:25:15
     *
     */
    public SeeyonBPMHandResult transTakeBack(SeeyonBPMHandParam4Tackback takeBackParam) throws BusinessException;
	
    
    /**
     * 指定回退待办事项
     * 
     * @param takeBackParam
     * @return
     * @throws BusinessException 事项不存在
     *
     * @Since A8-V5 6.1SP1
     * @Author      : xuqw
     * @Date        : 2017年6月30日上午11:25:15
     *
     */
    public SeeyonBPMHandResult transSpecifyBack(SeeyonBPMHandParam4SpecifyBack backParam) throws BusinessException;
    
    
    
    /**
     * 回退待办事项
     * 
     * @param stepBackParam
     * @return
     * @throws BusinessException
     *
     * @Since A8-V5 6.1SP1
     * @Author      : xuqw
     * @Date        : 2017年7月2日下午2:51:59
     *
     */
    public SeeyonBPMHandResult transStepBack(SeeyonBPMHandParam4StepBack stepBackParam) throws BusinessException;
    
    
    /**
     * 
     * 启动流程
     * 
     * @param startParam
     * @return
     * @throws BusinessException
     *
     * @Since A8-V5 6.1SP1
     * @Author      : xuqw
     * @Date        : 2017年7月4日下午1:15:09
     *
     */
    public SeeyonBPMHandResult transStartProcess(SeeyonBPMHandParam4Start startParam) throws BusinessException;
    
    
    /**
     * 
     * 处理或暂存待办流程
     * 
     * @param dealParam
     * @return
     * @throws BusinessException
     *
     * @Since A8-V5 6.1SP1
     * @Author      : xuqw
     * @Date        : 2017年7月4日下午8:02:42
     *
     */
    public  SeeyonBPMHandResult transFinishOrZcdb(SeeyonBPMHandParam4Deal dealParam) throws BusinessException;
    
    
	/**
	 * 导出流程图
	 * @param workflowId 流程图ID
	 * @param isZip 是否为一个压缩包
	 * @return
	 * @throws BPMException
	 */
	public List<File> exportWorkflowDiagram(Long workflowId,boolean isZip)  throws BPMException;
	
	/**
	 * 导出流程图
	 * @param processXml 流程图xml
	 * @param isZip是否为一个压缩包
	 * @return
	 * @throws BPMException
	 */
	public List<File> generateWorkflowDiagramFiles(String processXml, boolean isZip) throws BPMException;
	
	
	public void reAtiveFlow(String processId,String caseId) ;
	
	public String[] activeNextNode4SeDevelop(WorkflowBpmContext context) throws BPMException;
	   
}
