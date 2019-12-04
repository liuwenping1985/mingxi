package com.seeyon.apps.duban.listener;

import com.seeyon.apps.collaboration.event.*;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.po.SlaveDubanTask;
import com.seeyon.apps.duban.service.ConfigFileService;
import com.seeyon.apps.duban.service.DubanMainService;
import com.seeyon.apps.duban.service.MappingService;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.service.CommonServiceTrigger;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.duban.wrapper.DataTransferStrategy;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.ListenEvent;
import org.apache.log4j.Logger;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 主要的流转逻辑
 * Created by liuwenping on 2019/11/5.
 */
public class DubanTaskListener {

    private static final Logger LOGGER = Logger.getLogger(DubanTaskListener.class);

    private ColManager colManager;

    private OrgManager orgManager;

    public ColManager getColManager() {
        if (colManager == null) {
            colManager = (ColManager) AppContext.getBean("colManager");
        }
        return colManager;
    }

    public OrgManager getOrgManager() {
        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;
    }

    /**
     * 结束
     *
     * @param event
     */
    @ListenEvent(event = CollaborationFinishEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onFinish(CollaborationFinishEvent event) {
        Long summaryId = event.getSummaryId();
        Long affairId = event.getAffairId();
        Long memberId = null;
        V3xOrgMember member = null;
        //往台账表插入数据
        ColSummary colSummary = null;
        Long deptId = null;
        try {
            colSummary = getColManager().getSummaryById(summaryId);
            memberId = colSummary.getStartMemberId();
            member = this.getOrgManager().getMemberById(memberId);
            deptId = member.getOrgDepartmentId();
        } catch (BusinessException e) {
            e.printStackTrace();
        }

        /**
         * field0016 领导信息
         *
         * field0093 汇报信息
         *
         * field0007 办结时限
         *
         */
        if (CommonServiceTrigger.needProcess(summaryId)) {

            FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
            try {

                Long templateId = colSummary.getTempleteId();
                String val = ConfigFileService.getPropertyByName("ctp.template." + templateId);
                System.out.println("I AM IN IN IN:" + val);
                if ("DB_FEEDBACK".equals(val)) {
                    String tableName = ConfigFileService.getPropertyByName("ctp.table.DB_FEEDBACK");
                    String sql = "select * from " + tableName + " where id = " + colSummary.getFormRecordid();
                    //本次信息
                    Map data = DataBaseUtils.querySingleDataBySQL(sql);
                    if (CommonUtils.isEmpty(data)) {
                        System.out.println("找不到数据:" + sql);
                        return;
                    }
                    //判断是承办还是协办
                    //field0001 申请办结
                    //field0002 taskID
                    //field0014 完成率
                    //field0015 汇报内容

                    String taskId = (String) data.get("field0002");
                    Object field0001 = data.get("field0001");
                    Object field0014 = data.get("field0014");
                    if (taskId == null) {
                        System.out.println("数据有问题:" + data);
                        return;
                    }
                    String cont = (String) data.get("field0015");
                    if (CommonUtils.isEmpty(cont)) {
                        cont = "";
                    }else{
                        V3xOrgDepartment dept = this.getOrgManager().getDepartmentById(member.getOrgDepartmentId());
                        String cont_= ("\n【"+dept.getName()+"】"+member.getName()+":"+cont+" "+CommonUtils.formatDateSimple(colSummary.getStartDate()));
                        cont = cont_;
                    }

                    Map dibiao = DubanMainService.getInstance().getOringinalDubanData(taskId);

                    DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, dibiao, ftd);

                    /**
                     * field0013 进度
                     */
                    String memo = (String) dibiao.get("field0093");
                    if (CommonUtils.isEmpty(memo)) {
                        memo = cont;
                    } else {
                        memo = memo + "\n" + cont;
                    }

                    //先看是不是承办
                    //field0017 承办bumen
                    Object cb = dibiao.get("field0017");
                    String andSetSQL = "";
                    if (cb != null && String.valueOf(cb).equals(String.valueOf(deptId))) {
                        //field0021 承办部门进度
                        //field0022 完成时间
                        //field0018 权重
                        andSetSQL += ",field0021=" + field0014;
                        if ("1".equals(String.valueOf(field0001))) {
                            andSetSQL += ",field0022='" + CommonUtils.formatDate(colSummary.getFinishDate()) + "'";
                        }

                    } else {
                        //看是不是协办
                        //field0023-field0092
                        //每个7个字段
                        List<SlaveDubanTask> slaveDubanTaskList = task.getSlaveDubanTaskList();
                        if (!CommonUtils.isEmpty(slaveDubanTaskList)) {
                            String no = "";
                            for (SlaveDubanTask stask : slaveDubanTaskList) {
                                if (stask.getDeptName() != null && stask.getDeptName().equals(deptId)) {
                                    //找到承办部门了
                                    no = stask.getNo();
                                    break;
                                }

                            }
                            if (!CommonUtils.isEmpty(no)) {
                                Integer index = Integer.parseInt(no);
                                String processField = "field00" + (28 + 7 * (index - 1));

                                andSetSQL += ("," + processField + "=" + field0014);
                                if ("1".equals(String.valueOf(field0001))) {
                                    String finishDateField = "field00" + (29 + 7 * (index - 1));
                                    andSetSQL += ("," + finishDateField + "='" + CommonUtils.formatDate(colSummary.getFinishDate()) + "'");
                                }
                            }

                        }


                    }

                    //todo 计算总的进度（根据权重算）还没写


                    String updatesql = "update " + ftd.getFormTable().getName() + " set field0093='" + memo + "'" + andSetSQL + " where id=" + dibiao.get("id");


                    DataBaseUtils.executeUpdate(updatesql);


                } else if ("DB_DONE_APPLY".equals(val)) {

                    //field0014 实际办结时间
                    //field0001 任务id
                    //memberId  任务id
                    String tableName = ConfigFileService.getPropertyByName("ctp.table.DB_DONE_APPLY");
                    String sql = "select * from " + tableName + " where id = " + colSummary.getFormRecordid();

                    Map data = DataBaseUtils.querySingleDataBySQL(sql);
                    String taskId = (String) data.get("field0001");
                    Map dibiao = DubanMainService.getInstance().getOringinalDubanData(taskId);
                    DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, dibiao, ftd);
                    Object cb = dibiao.get("field0017");
                    String andSetSQL = "";
                    if (cb != null && String.valueOf(cb).equals(String.valueOf(deptId))) {
                        //field0021 承办部门进度
                        //field0022 完成时间
                        //field0018 权重
                        andSetSQL += ",field0021=100";
                        andSetSQL += ",field0022='" + CommonUtils.formatDate(colSummary.getFinishDate()) + "'";

                    } else {
                        //看是不是协办
                        //field0023-field0092
                        //每个7个字段
                        List<SlaveDubanTask> slaveDubanTaskList = task.getSlaveDubanTaskList();
                        if (!CommonUtils.isEmpty(slaveDubanTaskList)) {
                            String no = "";
                            for (SlaveDubanTask stask : slaveDubanTaskList) {
                                if (stask.getDeptName() != null && stask.getDeptName().equals(deptId)) {
                                    //找到承办部门了
                                    no = stask.getNo();
                                    break;
                                }

                            }
                            if (!CommonUtils.isEmpty(no)) {
                                Integer index = Integer.parseInt(no);
                                String processField = "field00" + (28 + 7 * (index - 1));
                                andSetSQL += ("," + processField + "=" + 100);
                                String finishDateField = "field00" + (29 + 7 * (index - 1));
                                andSetSQL += ("," + finishDateField + "='" + CommonUtils.formatDate(colSummary.getFinishDate()) + "'");

                            }

                        }


                    }


                    String updateSQL = "update " + ftd.getFormTable().getName() + " set finishedflag=1"+andSetSQL+" where field0001='" + taskId + "'";

                    DataBaseUtils.executeUpdate(updateSQL);


                } else if ("DB_DELAY_APPLY".equals(val)) {
                    //field0001 任务id

                    String tableName = ConfigFileService.getPropertyByName("ctp.table.DB_DELAY_APPLY");
                    String sql = "select * from " + tableName + " where id = " + colSummary.getFormRecordid();
                    Map data = DataBaseUtils.querySingleDataBySQL(sql);
                    //field0014
                    String taskId = (String) data.get("field0001");
                    Date date = (Date) data.get("field0014");
                    if (date != null) {
                        String updateSQL = "update " + ftd.getFormTable().getName() + " set field0007='" + CommonUtils.formatDate(date) + "' where field0001='" + taskId + "'";
                        DataBaseUtils.executeUpdate(updateSQL);
                    } else {
                        System.out.println("延期个冒险:" + data);
                    }


                }
            } catch (Exception e) {
                e.printStackTrace();
            }


        } else {
            System.out.println("I AM out out out:" + summaryId);
        }

    }

    /**
     * 开始
     *
     * @param event
     */
    @ListenEvent(event = CollaborationStartEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onStart(CollaborationStartEvent event) {
//        Long summaryId = event.getSummaryId();
//
//        if(CommonServiceTrigger.needProcess(summaryId)){
//            LOGGER.info("need process onStart");
//
//        }


    }

    /**
     * 取消
     *
     * @param event
     */
    @ListenEvent(event = CollaborationCancelEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onCancel(CollaborationCancelEvent event) {
//        Long summaryId = event.getSummaryId();
//
//        if(CommonServiceTrigger.needProcess(summaryId)){
//            LOGGER.info("need process onCancel");
//
//        }


    }

    /**
     * 取回
     *
     * @param event
     */
    @ListenEvent(event = CollaborationStepBackEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onStepBack(CollaborationStepBackEvent event) {

//        Long summaryId = event.getSummaryId();
//        Long affairId = (Long)event.getSource();
//        try {
//            CtpAffair affair = colManager.getAffairById(affairId);
//
//           String sql="insert into ctp_hd(id,affairId) values(\'"+ UUIDLong.longUUID()+"\',"+affair.getId()+")";
//        } catch (BusinessException e) {
//            e.printStackTrace();
//        }
//        if(CommonServiceTrigger.needProcess(summaryId)){
//            LOGGER.info("need process onStepBack");
//
//        }
    }

    /**
     * 终止
     *
     * @param event
     */
    @ListenEvent(event = CollaborationStopEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onStop(CollaborationStopEvent event) {


//        Long summaryId = event.getSummaryId();
//
//        if(CommonServiceTrigger.needProcess(summaryId)){
//            LOGGER.info("need process onStop");
//
//        }
    }

    /**
     * 处理
     *
     * @param event
     */
    @ListenEvent(event = CollaborationProcessEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onProcess(CollaborationProcessEvent event) {
//        Long summaryId = event.getSummaryId();
//
//
//        List<CtpAffair> affairList = DBAgent.find("from CtpAffair where state=3 and objectId="+summaryId);
//
//        if(CommonServiceTrigger.needProcess(summaryId)){
//            LOGGER.info("need process onProcess");
//
//        }

    }

}
