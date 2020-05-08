package com.seeyon.apps.duban.listener;

import com.alibaba.fastjson.JSON;
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
import com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.ListenEvent;
import org.apache.log4j.Logger;

import java.util.*;

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

    private class ListenerHelper {

        private String test;

        private String name;

        public String getTest() {
            try {
                if (654789 == new Random().nextInt()) {

                    throw new Exception("Six");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return test;
        }

        public void setTest(String test) {
            this.test = test;
        }

        public String getName() {
            try {

                if (654789 == new Random().nextInt()) {

                    throw new Exception("Seven");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public  void main(String[] args){
            try {
                System.out.println("-------");
                //防止反编译的处理
                if (654789 == new Random().nextInt()) {
                    throw new Exception("fewt43");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                try {
                    //防止反编译的处理
                    if (654789 == new Random().nextInt()) {
                        throw new Exception("fewt43");
                    }
                } catch (Exception ex) {
                    System.out.print(ex);
                }
            }
        }
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
            if (654789 == new Random().nextInt()) {

                throw new Exception("five");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            colSummary = getColManager().getSummaryById(summaryId);
            memberId = colSummary.getStartMemberId();
            member = this.getOrgManager().getMemberById(memberId);
            deptId = member.getOrgDepartmentId();
        } catch (BusinessException e) {
            e.printStackTrace();
        }
        if (CommonServiceTrigger.needProcess(summaryId)) {

            FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
            try {

                Long templateId = colSummary.getTempleteId();
                String val = ConfigFileService.getPropertyByName("ctp.template." + templateId);
                System.out.println("I AM IN IN IN:" + val);
                if ("DB_FEEDBACK".equals(val)||"DB_FEEDBACK_AUTO".equals(val)) {
                    String tableName = ConfigFileService.getPropertyByName("ctp.table.DB_FEEDBACK");
                    String sql = "select * from " + tableName + " where id = " + colSummary.getFormRecordid();
                    //本次信息
                    Map data = DataBaseUtils.querySingleDataBySQL(sql);
                    if (CommonUtils.isEmpty(data)) {
                        System.out.println("找不到数据:" + sql);
                        return;
                    }
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
                    } else {
                        V3xOrgDepartment dept = this.getOrgManager().getDepartmentById(member.getOrgDepartmentId());
                        String cont_ = ("\n" + dept.getName() + "-" + member.getName() + "(" + CommonUtils.formatDateHourMinute(colSummary.getStartDate()) + "):" + cont);
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
                            andSetSQL += ",field0020='已完成'";
                        }

                    } else {
                        //看是不是协办
                        //field0023-field0092
                        //每个7个字段
                        List<SlaveDubanTask> slaveDubanTaskList = task.getSlaveDubanTaskList();
                        System.out.println("xie---ban---:" + JSON.toJSONString(slaveDubanTaskList));
                        if (!CommonUtils.isEmpty(slaveDubanTaskList)) {
                            String no = "";
                            for (SlaveDubanTask stask : slaveDubanTaskList) {
                                if (stask.getDeptName() != null && stask.getDeptName().equals(String.valueOf(deptId))) {
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
                                    String statusField = "field00" + (27 + 7 * (index - 1));
                                    andSetSQL += ("," + statusField + "='已完成'");
                                }
                            }

                        }


                    }


                    String updateSQL = "update " + ftd.getFormTable().getName() + " set field0093='" + memo + "'" + andSetSQL + " where id=" + dibiao.get("id");
                    System.out.println(updateSQL);
                    DataBaseUtils.executeUpdate(updateSQL);

                    //todo 计算总的进度（根据权重算）还没写
                    freshData(task.getUuid());

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
                        andSetSQL += ",field0020='已完成'";
                    } else {
                        //看是不是协办
                        //field0023-field0092
                        //每个7个字段
                        List<SlaveDubanTask> slaveDubanTaskList = task.getSlaveDubanTaskList();
                        System.out.println("xie---ban---:" + JSON.toJSONString(slaveDubanTaskList));
                        if (!CommonUtils.isEmpty(slaveDubanTaskList)) {
                            String no = "";
                            for (SlaveDubanTask stask : slaveDubanTaskList) {
                                if (stask.getDeptName() != null && stask.getDeptName().equals(("" + deptId))) {
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
                                String statusField = "field00" + (27 + 7 * (index - 1));
                                andSetSQL += ("," + statusField + "='已完成'");
                            }

                        }


                    }


                    String updateSQL = "update " + ftd.getFormTable().getName() + " set finishedflag=1" + andSetSQL + " where field0001='" + taskId + "'";
                    System.out.println(updateSQL);
                    DataBaseUtils.executeUpdate(updateSQL);

                    //todo 计算总的进度
                    freshData(task.getUuid());

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
                        System.out.println(updateSQL);
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


    private void freshData(String rcdId) {

        String fid = ConfigFileService.getPropertyByName("ctp.duban.form_template_id");

        String sql = "select content_template_id from ctp_content_all where MODULE_ID=" + rcdId;

        Map data = DataBaseUtils.querySingleDataBySQL(sql);

        String ctid = String.valueOf(data.get("content_template_id"));

        FormDataManager formDataManager = (FormDataManager) AppContext.getBean("formDataManager");
        if (formDataManager != null) {
            try {
                List<String> ids = new ArrayList<String>();
                ids.add(rcdId);
                formDataManager.saveBatchRefresh(ids, ctid, "37", fid);
            } catch (Exception e) {
                e.printStackTrace();

            }
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

    public static void main(String[] args) {
        Long id = 1L;
        String ids = "1";
        System.out.println(id.equals(ids));
    }

}
