package com.seeyon.apps.duban.service.impl;

import com.alibaba.fastjson.JSON;
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
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import org.springframework.util.CollectionUtils;

import java.text.DecimalFormat;
import java.util.*;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class DubanScoreManagerImpl implements DubanScoreManager {

    private DecimalFormat decimalFormat = new DecimalFormat("#.00");

    private DubanMainService mainService = DubanMainService.getInstance();

    private ColManager colManager;

    private OrgManager orgManager;

    private  ScheduledExecutorService executorPoolService = Executors.newScheduledThreadPool(3);


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

    public void caculateScoreWhenStartOrProcess(final String templateCode,final ColSummary colSummary,final V3xOrgMember member){
        executorPoolService.schedule(new Runnable() {
            public void run() {

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
                        Object taskStatus = data.get("field0031");

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
                            record.setCreateDate(new Date());
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
                        record.setExtVal(String.valueOf(taskStatus));
                        DBAgent.update(record);

                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        },6, TimeUnit.SECONDS);




    }

    public void onFeedBackFinish(final String templateCode, final ColSummary colSummary,final V3xOrgMember member) throws BusinessException {
        executorPoolService.schedule(new Runnable() {
            public void run() {
                FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
                FormTableDefinition tableFtd = mainService.getFormTableDefinitionByCode(templateCode);
                Long deptId = member.getOrgDepartmentId();
                if (tableFtd == null) {
                    System.out.println("找不到表：" + templateCode);
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
                    OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
                    V3xOrgDepartment dept = null;
                    try {
                        dept = orgManager.getDepartmentById(member.getOrgDepartmentId());
                    } catch (BusinessException e) {
                        e.printStackTrace();
                    }
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
                calculateDone(taskId);
                DataBaseUtils.executeUpdate(updateSQL);
            }
        },6,TimeUnit.SECONDS);


    }


    public void onDoneApplyFinish(final String templateCode,final ColSummary colSummary,final V3xOrgMember member) throws BusinessException {

        executorPoolService.schedule(new Runnable() {
            public void run() {
                FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);

                FormTableDefinition tableFtd = mainService.getFormTableDefinitionByCode(templateCode);
                if (tableFtd == null) {
                    System.out.println("找不到表：" + templateCode);
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
                if (cb != null && String.valueOf(cb).equals(String.valueOf(member.getOrgDepartmentId()))) {
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
                            if (stask.getDeptName() != null && stask.getDeptName().equals(("" + member.getOrgDepartmentId()))) {
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


            }
        },6,TimeUnit.SECONDS);


    }

        public void onDelayApplyFinish(final String templateCode, final ColSummary colSummary, final V3xOrgMember member) throws BusinessException {

            executorPoolService.schedule(new Runnable() {

                public void run() {
                    FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
                    String tableName = ConfigFileService.getPropertyByName("ctp.table.DB_DELAY_APPLY");
                    FormTableDefinition tableFtd = mainService.getFormTableDefinitionByCode(templateCode);
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
            },6,TimeUnit.SECONDS);

        }

    public void onDoneApplyProcess(final String templateCode,final ColSummary colSummary,final V3xOrgMember member) throws BusinessException {
        executorPoolService.schedule(new Runnable(){

            public void run() {
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
                String taskId = (String) data.get("field0001");
                //field0001 taskId0000000000000000000000000000000000000
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
        },6,TimeUnit.SECONDS);

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

    private void calculateDone(String taskId) {

        String sql = "from DubanScoreRecord where taskId = '" + taskId + "'";
        List<DubanScoreRecord> dsrList = DBAgent.find(sql);
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
//        Map dibiao = DubanMainService.getInstance().getOringinalDubanData(taskId);
//        DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, dibiao, ftd);
        Double rw = 0d, hb = 0d, wc = 0d,total=0d;
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
        total=(rw+hb+wc);
        String sql2 = "update " + ftd.getFormTable().getName() + " set field0146=" + (rw==0?0:decimalFormat.format(rw))+ ",field0144=" + (hb==0?0:decimalFormat.format(hb)) + ",field0145="+(total==0?0:decimalFormat.format(total)) +",field0147=" + (wc==0?0:decimalFormat.format(wc)) + " where field0001='" + taskId + "'";
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

    private boolean isCengban(V3xOrgMember member, Map dibiao) {
        Object cb = dibiao.get("field0017");
        if (cb != null && String.valueOf(cb).equals(String.valueOf(member.getOrgDepartmentId()))) {
            return true;
        }
        return false;

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





}
