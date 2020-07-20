package com.seeyon.apps.duban.listener;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.collaboration.event.*;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.po.DubanConfigItem;
import com.seeyon.apps.duban.po.DubanScoreRecord;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.po.SlaveDubanTask;
import com.seeyon.apps.duban.service.*;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.duban.wrapper.DataTransferStrategy;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.exceptions.InfrastructureException;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.product.util.MessageEncoder;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.ListenEvent;
import com.seeyon.v3x.dbpool.util.PwdEncoder;
import org.apache.log4j.Logger;
import org.springframework.orm.hibernate3.support.CTPHibernateDaoSupport;
import org.springframework.util.CollectionUtils;

import java.text.DecimalFormat;
import java.util.*;

/**
 * 主要的流转逻辑
 * Created by liuwenping on 2019/11/5.
 */
public class DubanTaskListener {

    private static final Logger LOGGER = Logger.getLogger(DubanTaskListener.class);

    private DecimalFormat decimalFormat = new DecimalFormat("#.00");

    private DubanMainService mainService = DubanMainService.getInstance();
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

        public void main(String[] args) {
            try {
                System.out.println("---ACK_TO_LUBO----");
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
            //主表的结构
            FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
            FormTableDefinition ftddb = MappingService.getInstance().getCachedMainFtd();
            if (ftddb != null) {
                String name1 = ftd.getFormTable().getName();
                String name2 = ftddb.getFormTable().getName();
                if (name1.equals(name2)) {
                    ftd.getFormTable().setName(name2);
                }
            }
            try {

                Long templateId = colSummary.getTempleteId();

                String val = mainService.getFormTemplateCode(templateId);
                if ("DB_FEEDBACK".equals(val) || "DB_FEEDBACK_AUTO".equals(val)) {
                    FormTableDefinition tableFtd = mainService.getFormTableDefinitionByCode(val);
                    if (tableFtd == null) {
                        System.out.println("找不到表：" + val);
                        return;
                    }
                    String sql = "select * from " + tableFtd.getFormTable().getName() + " where id = " + colSummary.getFormRecordid();
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
                            calculateDone(taskId);
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
                                //这里是否办结的选择---
                                if ("1".equals(String.valueOf(field0001))) {
                                    String finishDateField = "field00" + (29 + 7 * (index - 1));
                                    andSetSQL += ("," + finishDateField + "='" + CommonUtils.formatDate(colSummary.getFinishDate()) + "'");
                                    String statusField = "field00" + (27 + 7 * (index - 1));
                                    andSetSQL += ("," + statusField + "='已完成'");
                                    calculateDone(taskId);
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
                    FormTableDefinition tableFtd = mainService.getFormTableDefinitionByCode(val);
                    if (tableFtd == null) {
                        System.out.println("找不到表：" + val);
                        return;
                    }
                    String tableName = tableFtd.getFormTable().getName();
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
                    calculateDone(taskId);
                    //todo 计算总的进度
                    freshData(task.getUuid());

                } else if ("DB_DELAY_APPLY".equals(val)) {
                    //field0001 任务id

                    String tableName = ConfigFileService.getPropertyByName("ctp.table.DB_DELAY_APPLY");
                    FormTableDefinition tableFtd = mainService.getFormTableDefinitionByCode(val);
                    if (tableFtd != null) {
                        tableName = tableFtd.getFormTable().getName();
                    }
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

//        boolean isMock = false;
//        if (!isMock) {
//            return;
//        }
        System.out.println("触发任务分数计算:");
        Long summaryId = event.getSummaryId();
        if (CommonServiceTrigger.needProcess(summaryId)) {
            ColSummary colSummary = null;
           //getAffair().getSenderId();
            V3xOrgMember member = null;
            try {
                Long memberId = getColManager().getAffairById(event.getAffairId()).getSenderId();
                member = getOrgManager().getMemberById(memberId);
            if (member == null) {
                LOGGER.error("can not find user!error-code：3478");
                return;
            }

                colSummary = getColManager().getSummaryById(summaryId);
            } catch (BusinessException e) {
                e.printStackTrace();
                return;
            }
            String val = mainService.getFormTemplateCode(colSummary.getTempleteId());
            if("DB_FEEDBACK_AUTO".equals(val)){

                caculateScoreWhenStartOrProcess( val,colSummary, member);


            }
//            if ("DB_TASK_MAIN".equals(val)) {
//
//                List<DubanConfigItem> itemList = DBAgent.find("from DubanConfigItem where 1=1");
//                /**
//                 * ctp.duban.feedback.TASK_SOURCE=field0003
//                 ctp.duban.feedback.TASK_LEVEL=field0004
//                 */
//                FormTableDefinition tableFtd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
//                if (tableFtd == null) {
//                    System.out.println("找不到表：" + val);
//                    return;
//                }
//                String tableName = tableFtd.getFormTable().getName();
//                String sql = "select * from " + tableName + " where id = " + colSummary.getFormRecordid();
//                Map data = DataBaseUtils.querySingleDataBySQL(sql);
//                String taskId = (String) data.get("field0001");
//                String enumSource = String.valueOf(data.get("field0002"));
//                DubanConfigItem sourceConfig = DataSetService.getInstance().getDubanConfigItem(enumSource);
//                String sourceValue = null;
//                if (sourceConfig != null) {
//                    sourceValue = sourceConfig.getItemValue();
//                } else {
//                    sourceValue = "100";
//                }
//                String enumLevel = String.valueOf(data.get("field0003"));
//                DubanConfigItem enumLevelConfig = DataSetService.getInstance().getDubanConfigItem(enumSource);
//                String levelValue = null;
//                if (enumLevelConfig != null) {
//                    levelValue = enumLevelConfig.getItemValue();
//                } else {
//                    levelValue = "0.9";
//                }
//
//
//            }

        }


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


    }

    private boolean isLogging = true;

    private void log(Object obj) {
        if (isLogging) {
            System.out.println(obj);
        }

    }

    /**
     * 处理
     *
     * @param event
     */
    @ListenEvent(event = CollaborationProcessEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onProcess(CollaborationProcessEvent event) {

        Long summaryId = event.getSummaryId();
        log("this way plz:" + summaryId);
        if (CommonServiceTrigger.needProcess(summaryId)) {
            log("i AM IN:" + summaryId);
            ColSummary colSummary = null;
            V3xOrgMember member = null;

            try {
                Long memberId = event.getAffair().getSenderId();
                member = getOrgManager().getMemberById(memberId);
                if (member == null) {
                    LOGGER.error("can not find user!error-code：3478");
                    return;
                }
                colSummary = getColManager().getSummaryById(summaryId);
            } catch (BusinessException e) {
                e.printStackTrace();
                return;
            }
            String templateCode = mainService.getFormTemplateCode(colSummary.getTempleteId());
            log("templateCode:" + summaryId);
            caculateScoreWhenStartOrProcess( templateCode,colSummary, member);
            //完成后
            if ("DB_DONE_APPLY".equals(templateCode)) {
                FormTableDefinition tableFtd = mainService.getFormTableDefinitionByCode(templateCode);
                if (tableFtd == null) {

                    System.out.println("can not found table[[[!.!]]]:" + templateCode);
                    return;
                }
                String sql = "select * from " + tableFtd.getFormTable().getName() + " where id = " + colSummary.getFormRecordid();
                //本次信息
                Map data = DataBaseUtils.querySingleDataBySQL(sql);
                if (CommonUtils.isEmpty(data)) {
                    ///root/Seeyon/A8/ApacheJetspeed/webapps/seeyon/WEB-INF/classes
                    System.out.println("not data :" + sql);
                    return;
                }
                String taskId = (String) data.get("field0002");
                //field0001 taskId
                //这里也计算一下分数
                //field0028 任务量
                //field0026 汇报
                //field0027 完成分
                Double rws = CommonUtils.getDouble(data.get("field0028"));
                Double wancheng = CommonUtils.getDouble(data.get("field0027"));
                if (rws == null || rws.intValue() <= 0) {
                    List<DubanScoreRecord> dsrList = DBAgent.find("from DubanScoreRecord where taskId='" + taskId + "' and memberId=" + member.getId());
                    if (!CollectionUtils.isEmpty(dsrList)) {
                        double kg = 0;
                        double zg = 0;
                        for (DubanScoreRecord dsr : dsrList) {

                            Double ss = CommonUtils.getDouble(dsr.getKeGuanScore());
                            if (ss != null) {
                                kg += ss;
                            }
                            Double dd = CommonUtils.getDouble(dsr.getZhuGuanScore());
                            if (dd != null) {
                                zg += dd;
                            }

                        }
                        double size = 1d * dsrList.size();
                        String kgUpdateval = kg == 0 ? "0" : decimalFormat.format(kg / size);
                        String zgUpdateval = zg == 0 ? "0" : decimalFormat.format(zg / size);
                        String sql2 = "update " + tableFtd.getFormTable().getName() + " set field0028=" + kgUpdateval + ",field0026=" + zgUpdateval + " where id=" + colSummary.getFormRecordid();
                        DataBaseUtils.executeUpdate(sql2);

                    }
                }
                if (wancheng != null && wancheng > 0) {
                    String uSql = "update duban_score_record set score='" + wancheng + "' where task_id = '" + taskId + "' and member_id=" + member.getId();
                    DataBaseUtils.executeUpdate(uSql);
                }


            }
        }
    }

    private void caculateScoreWhenStartOrProcess(String templateCode,ColSummary colSummary,V3xOrgMember member){

        if ("DB_FEEDBACK".equals(templateCode) || "DB_FEEDBACK_AUTO".equals(templateCode)) {

            try {

                FormTableDefinition tableFtd = mainService.getFormTableDefinitionByCode(templateCode);

                if (tableFtd == null) {

                    System.out.println("can not found table[[[!.!]]]:" + templateCode);
                    return;
                }
                String sql = "select * from " + tableFtd.getFormTable().getName() + " where id = " + colSummary.getFormRecordid();
                //本次信息
                Map data = DataBaseUtils.querySingleDataBySQL(sql);
                if (CommonUtils.isEmpty(data)) {
                    ///root/Seeyon/A8/ApacheJetspeed/webapps/seeyon/WEB-INF/classes
                    System.out.println("not data :" + sql);
                    return;
                }
                String taskId = (String) data.get("field0002");

                //主表的相关信息
                FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
                Map dibiao = DubanMainService.getInstance().getOringinalDubanData(taskId);
                DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, dibiao, ftd);
                //end of 主表信息

                //打分记录 startup
                List<DubanScoreRecord> retList = DBAgent.find("from DubanScoreRecord where summaryId=" + colSummary.getId());
                DubanScoreRecord record = new DubanScoreRecord();
                if (!CollectionUtils.isEmpty(retList)) {
                    record = retList.get(0);
                } else {
                    record.setIdIfNew();
                    record.setMemberId(member.getId());
                    record.setTaskId(taskId);
                    record.setSummaryId(colSummary.getId());
                    record.setDepartmentId(member.getOrgDepartmentId());
                    if (isCengban(member, dibiao)) {
                        record.setWeight(task.getMainWeight());
                    } else {
                        SlaveDubanTask sdt = getSlaveTaskByTaskAndMember(task, member);
                        record.setWeight(sdt.getWeight());
                    }
                    DBAgent.save(record);

                }
                //end of 打分记录
                //主要逻辑
                //1、看下任务量的分数有没有被算出来
                Double renwuliang = CommonUtils.getDouble(data.get("field0030"));
                if (renwuliang == null || renwuliang.intValue() <= 0) {
                    //计算
                    Double rwScore = calculateSocre(dibiao, task, member);
                    record.setKeGuanScore(decimalFormat.format(rwScore));
                    updateStringFieldByTableAndId("field0030", record.getKeGuanScore(), tableFtd.getFormTable().getName(), colSummary.getFormRecordid());
                }

                Double dafen = CommonUtils.getDouble(data.get("field0028"));
                if (dafen != null) {
                    record.setZhuGuanScore(decimalFormat.format(dafen));
                } else {
                    record.setZhuGuanScore("0");
                }
                DBAgent.update(record);
                currentHibernateDaoSupport().getHibernateTpl().flush();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }




    }

    private static CTPHibernateDaoSupport currentHibernateDaoSupport() {
        if (!"true".equals(AppContext.getThreadContext("SPRING_AOP_LOCK"))) {
            throw new InfrastructureException("当前BS方法未采用Spring管理数据库连接，请检查方法命名是否符合Spring设置！");
        } else {
            return (CTPHibernateDaoSupport) AppContext.getThreadContext("SPRING_HIBERNATE_DAO_SUPPORT");
        }
    }

    private Double calculateSocre(Map dibiao, DubanTask task, V3xOrgMember member) {
        //底表field0002 任务来源，field0003 任务分级
        String weight = "100";
        String xishu = "1";
        DataSetService dss = DataSetService.getInstance();
        if (isCengban(member, dibiao)) {
            //99999999
            weight = task.getMainWeight();
            xishu = dss.getDubanConfigItem("99999999").getItemValue();
        } else {
            //99999998
            SlaveDubanTask sdt = getSlaveTaskByTaskAndMember(task, member);
            if (sdt != null) {
                weight = sdt.getWeight();
                xishu = dss.getDubanConfigItem("99999998").getItemValue();
            }
        }
        String scoreMain = "100";
        DubanConfigItem sourceItem = dss.getDubanConfigItem(String.valueOf(dibiao.get("field0002")));
        if (sourceItem != null) {
            scoreMain = sourceItem.getItemValue();
        }
        String levelMain = "1";
        DubanConfigItem levelItem = dss.getDubanConfigItem(String.valueOf(dibiao.get("field0003")));
        if (levelItem != null) {
            levelMain = levelItem.getItemValue();
        }


        return CommonUtils.getDouble(scoreMain) * (CommonUtils.getDouble(weight) / 100d) * CommonUtils.getDouble(levelMain) * CommonUtils.getDouble(xishu);
    }

    private void updateStringFieldByTableAndId(String fieldName, String fieldValue, String tableName, Long recordId) {
        String sql = "update " + tableName + " set " + fieldName + "='" + fieldValue + "' where id = " + recordId;
        //本次信息
        DataBaseUtils.executeUpdate(sql);

    }

    private void updateFeedBackAllSocre(String field0028, String field0030, String tableName, Long recordId) {
        String sql = "update " + tableName + " set field0028=" + field0028 + ",field0030=" + field0030 + " where id = " + recordId;
        //本次信息
        DataBaseUtils.executeUpdate(sql);

    }

    private boolean isCengban(V3xOrgMember member, Map dibiao) {
        Object cb = dibiao.get("field0017");
        if (cb != null && String.valueOf(cb).equals(String.valueOf(member.getOrgDepartmentId()))) {
            return true;
        }
        return false;

    }

    private void calculateDone(String taskId) {

        String sql = "from DubanScoreRecord where taskId = '" + taskId + "'";
        List<DubanScoreRecord> dsrList = DBAgent.find(sql);
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
//        Map dibiao = DubanMainService.getInstance().getOringinalDubanData(taskId);
//        DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, dibiao, ftd);
        Double rw = 0d, hb = 0d, wc = 0d;
        Map<Long, List<DubanScoreRecord>> deptDsr = new HashMap<Long, List<DubanScoreRecord>>();
        for (DubanScoreRecord dsr : dsrList) {

            List<DubanScoreRecord> dsrs = deptDsr.get(dsr.getDepartmentId());
            if (dsrs == null) {
                dsrs = new ArrayList<DubanScoreRecord>();
                deptDsr.put(dsr.getDepartmentId(), dsrs);
            }
            dsrs.add(dsr);

        }
        for(Map.Entry<Long,List<DubanScoreRecord>>entry:deptDsr.entrySet()){


            List<DubanScoreRecord> eList = entry.getValue();

            double size = 1d*eList.size();
            double rws=0d,hbs=0d,wcs=0d;
            for(DubanScoreRecord dsr:eList){
                Double wcf = CommonUtils.getDouble(dsr.getScore());
                Double rwf = CommonUtils.getDouble(dsr.getKeGuanScore());
                Double hbf = CommonUtils.getDouble(dsr.getZhuGuanScore());
                if(wcf!=null){
                    wcs+=wcf;
                }
                if(rwf!=null){
                    rws+=rwf;
                }
                if(hbf!=null){
                    hbs+=hbf;
                }
            }
            rw+=(rws/size);
            hb+=(hbs/size);
            wc+=(wcs/size);

        }
        String sql2 = "update " + ftd.getFormTable().getName() + " set field0146=" + (rw==0?0:decimalFormat.format(rw))+ ",field0144=" + (hb==0?0:decimalFormat.format(hb)) + ",field0147=" + (wc==0?0:decimalFormat.format(wc)) + " where field0001='" + taskId + "'";
        DataBaseUtils.executeUpdate(sql2);

    }

    private SlaveDubanTask getSlaveTaskByTaskAndMember(DubanTask task, V3xOrgMember member) {
        List<SlaveDubanTask> slaveDubanTaskList = task.getSlaveDubanTaskList();
        if (!CommonUtils.isEmpty(slaveDubanTaskList)) {
            for (SlaveDubanTask stask : slaveDubanTaskList) {
                if (stask.getDeptName() != null && stask.getDeptName().equals(("" + member.getOrgDepartmentId()))) {
                    return stask;
                }

            }
        }

        return null;

    }

    public static void main(String[] args) {
        Long id = 1L;
        String ids = "/1.0/eWJlWUJFQTMxMjo=";

        System.out.println(PwdEncoder.decode(ids));
    }

}
