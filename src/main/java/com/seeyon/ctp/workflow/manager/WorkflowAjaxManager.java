package com.seeyon.ctp.workflow.manager;

import com.seeyon.ctp.workflow.exception.BPMException;
import com.seeyon.ctp.workflow.vo.CPMatchResultVO;
import com.seeyon.ctp.workflow.vo.FlashProcessNodePositionVO;
import com.seeyon.ctp.workflow.vo.WorkflowReplaceVO;
import java.util.List;
import java.util.Map;
import net.joinwork.bpm.engine.wapi.WorkflowBpmContext;

public abstract interface WorkflowAjaxManager
{
  public abstract boolean hasMainProcess(String paramString)
    throws BPMException;

  public abstract String[][] getMainProcessTitleList(List<String> paramList)
    throws BPMException;

  public abstract boolean hasSubProcess(String paramString)
    throws BPMException;

  public abstract boolean addMemberIdToCache(String paramString1, String paramString2);

  public abstract String hasten(String paramString1, String paramString2, String paramString3, List<String> paramList, String paramString4, String paramString5, boolean paramBoolean);

  public abstract boolean editWFCDiagram(String paramString1, String paramString2)
    throws BPMException;

  public abstract String canTakeBack(String paramString1, String paramString2, String paramString3, String paramString4)
    throws BPMException;

  public abstract String[] canRepeal(String paramString1, String paramString2, String paramString3)
    throws BPMException;

  public abstract long cloneWorkflowTemplateById(Long paramLong, int paramInt)
    throws BPMException;

  public abstract String validateFailReSelectPeople(String paramString, List<Map<String, String>> paramList)
    throws BPMException;

  public abstract String[] changeCaseProcess(String paramString1, String[] paramArrayOfString1, String[] paramArrayOfString2, String[] paramArrayOfString3, String[] paramArrayOfString4, String[] paramArrayOfString5, String[] paramArrayOfString6, String[] paramArrayOfString7, String[] paramArrayOfString8, String[] paramArrayOfString9, boolean paramBoolean, String[] paramArrayOfString10, String paramString2, String paramString3, String paramString4)
    throws BPMException;

  public abstract String[] changeCaseProcess(String paramString1, String[] paramArrayOfString1, String[] paramArrayOfString2, String[] paramArrayOfString3, String[] paramArrayOfString4, String[] paramArrayOfString5, String[] paramArrayOfString6, String[] paramArrayOfString7, String[] paramArrayOfString8, String[] paramArrayOfString9, boolean paramBoolean, String[] paramArrayOfString10, String paramString2, String paramString3, String paramString4, String paramString5, String paramString6)
    throws BPMException;

  public abstract String[] saveModifyWorkflowData(String paramString1, String paramString2, String paramString3, String paramString4, String paramString5, String paramString6)
    throws BPMException;

  public abstract String[] changeCaseProcessNodeProperty(String[] paramArrayOfString1, String[] paramArrayOfString2, String paramString1, boolean paramBoolean, String paramString2, String paramString3, String paramString4)
    throws BPMException;

  public abstract String templateExist(Long paramLong)
    throws BPMException;

  public abstract String[] validateCurrentSelectedNode(String paramString1, String paramString2, String paramString3, String paramString4, String paramString5, String paramString6, String paramString7, String paramString8)
    throws BPMException;

  public abstract String[] branchTranslateBranchExpression(String paramString1, String paramString2, String paramString3)
    throws BPMException;

  public abstract String[] validateWorkflowAutoCondition(String paramString1, String paramString2, String paramString3, boolean paramBoolean)
    throws BPMException;

  public abstract String[] getCaseState(String paramString)
    throws BPMException;

  public abstract String[] hasConditionAfterSelectNode(String paramString1, String paramString2)
    throws BPMException;

  public abstract String[] hasAutoSkipNodeBeforeSetCondition(String paramString1, String paramString2)
    throws BPMException;

  public abstract String[] isAutoSkipBeforeNewSetFlowOfNode(String paramString1, String paramString2)
    throws BPMException;

  public abstract CPMatchResultVO transBeforeInvokeWorkFlow(WorkflowBpmContext paramWorkflowBpmContext, CPMatchResultVO paramCPMatchResultVO)
    throws BPMException;

  public abstract boolean transCheckBrachSelectedWorkFlow(WorkflowBpmContext paramWorkflowBpmContext, String paramString, List<String> paramList1, List<String> paramList2, List<String> paramList3, List<String> paramList4)
    throws BPMException;

  public abstract String addNode(String paramString1, String paramString2, String paramString3, String paramString4, int paramInt, Map<Object, Object> paramMap, String paramString5, String paramString6, String paramString7, String paramString8)
    throws BPMException;

  public abstract String deleteNode(String paramString1, String paramString2, String paramString3, List<String> paramList, String paramString4, String paramString5, String paramString6, String paramString7, String paramString8)
    throws BPMException;

  public abstract String[] canStepBack(String paramString1, String paramString2, String paramString3, String paramString4, String paramString5, String paramString6)
    throws BPMException;

  public abstract String[] canStepBack(String paramString1, String paramString2, String paramString3, String paramString4, String paramString5, String paramString6, String paramString7)
    throws BPMException;

  public abstract String conditionToFieldName(String paramString1, String paramString2, String paramString3)
    throws BPMException;

  public abstract String conditionToFieldDisplay(String paramString1, String paramString2, String paramString3)
    throws BPMException;

  public abstract String[] lockWorkflow(String paramString1, String paramString2, int paramInt)
    throws BPMException;

  public abstract String[] lockWorkflow(String paramString1, String paramString2, int paramInt, String paramString3)
    throws BPMException;

  public abstract String[] lockWorkflowForStepBack(WorkflowBpmContext paramWorkflowBpmContext, int paramInt, String paramString1, String paramString2, String paramString3)
    throws BPMException;

  public abstract String[] releaseWorkflow(String paramString1, String paramString2)
    throws BPMException;

  public abstract String[] releaseWorkflow(String paramString1, String paramString2, int paramInt)
    throws BPMException;

  public abstract String[] checkWorkflowLock(String paramString1, String paramString2)
    throws BPMException;

  public abstract String[] checkWorkflowLock(String paramString1, String paramString2, int paramInt)
    throws BPMException;

  public abstract String[] canWorkflowCurrentNodeSubmit(String paramString)
    throws BPMException;

  public abstract String[] getProcessTitleByAppNameAndProcessId(String paramString1, String paramString2)
    throws BPMException;

  public abstract String[] canSpecialStepBack(String paramString)
    throws BPMException;

  public abstract String[] canTemporaryPending(String paramString)
    throws BPMException;

  public abstract String[] canStopFlow(String paramString)
    throws BPMException;

  public abstract String[] canChangeNode(String paramString)
    throws BPMException;

  public abstract String[] validateFormTemplate(String paramString1, String paramString2, String paramString3, String paramString4)
    throws BPMException;

  public abstract String[] selectProcessTemplateXMLForClone(String paramString1, String paramString2, String paramString3, String paramString4, String paramString5, String paramString6)
    throws BPMException;

  public abstract String[] getAcountExcludeElements()
    throws BPMException;

  public abstract String[] isExchangeNode(String paramString1, String paramString2, String paramString3)
    throws BPMException;

  public abstract String[] validateCanAddNode(String paramString1, String paramString2, String paramString3, String paramString4)
    throws BPMException;

  public abstract String[] getHandSelectOptions(String paramString1, String paramString2, String paramString3);

  public abstract boolean isCanPasteAndReplaceNode(String paramString1, String paramString2, String paramString3);

  public abstract String[] validateProcessTemplateXMLForEgg(String paramString1, String paramString2, String paramString3, String paramString4, String paramString5, String paramString6, String paramString7, String paramString8)
    throws BPMException;

  public abstract Map<String, List<? extends Object>> getNeedRepalceTemplateList(WorkflowReplaceVO paramWorkflowReplaceVO, String paramString)
    throws BPMException;

  public abstract int repalceTemplateList(List<String> paramList, WorkflowReplaceVO paramWorkflowReplaceVO, String paramString)
    throws BPMException;

  public abstract Map<String, Object> updateTemplateList(String paramString1, String paramString2, String paramString3)
    throws BPMException;

  public abstract Map<String, Object> updateTemplateList(String paramString1, String paramString2, String paramString3, String paramString4, String paramString5)
    throws BPMException;

  public abstract String getUnenabledEntity(String paramString)
    throws BPMException;

  public abstract String[] getEditTemplateParams(String paramString1, String paramString2, String paramString3, String paramString4, WorkflowReplaceVO paramWorkflowReplaceVO)
    throws BPMException;

  public abstract String getWendanIdByWorkflowId(String paramString, boolean paramBoolean)
    throws BPMException;

  public abstract String executeWorkflowBeforeEvent(String paramString, WorkflowBpmContext paramWorkflowBpmContext);

  public abstract String exeWorkflowBeforeEvent(String paramString1, String paramString2, String paramString3, String paramString4, String paramString5, String paramString6, String paramString7, String paramString8);

  public abstract FlashProcessNodePositionVO analysisProcessDataForFlash(String paramString1, String paramString2, boolean paramBoolean);

  public abstract String validateWFTemplete(String paramString)
    throws BPMException;

  public abstract void removeWorkflowMatchResultCache(String paramString)
    throws BPMException;
}
