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
import com.seeyon.apps.duban.stat.FieldName2Field00xxUtils;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.duban.wrapper.DataTransferStrategy;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.exceptions.InfrastructureException;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import org.apache.commons.lang.StringUtils;
import org.lilystudio.smarty4j.statement.function.$else;
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

    private ScheduledExecutorService executorPoolService = Executors.newScheduledThreadPool(3);


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

    public DubanTask getKeGuanScoreByCurrentUser(String taskId) {
        //主表的相关信息
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);

        String sql = "select * from " + ftd.getFormTable().getName() + " where field0001='" + taskId + "'";

        List<DubanTask> taskList = mainService.translateDubanTask(sql, ftd);
        if (CollectionUtils.isEmpty(taskList)) {
            return null;
        }
        DubanTask dubanTask = taskList.get(0);
        //先算任务量
        Map dibiao = mainService.getOringinalDubanData(taskId);
        User user = AppContext.getCurrentUser();
        try {
            V3xOrgMember member = this.getOrgManager().getMemberById(user.getId());
            V3xOrgDepartment dept = this.getOrgManager().getDepartmentById(member.getOrgDepartmentId());
            Double score = calculateSocre(dibiao, dubanTask, dept.getName(), dept.getId());
            dubanTask.setKgScore(score.intValue());
        } catch (BusinessException e) {
            e.printStackTrace();
        }
        //再算汇报分
        Map params = new HashMap();
        params.put("taskId",dubanTask.getTaskId());
        params.put("memberId",user.getId());
        List<DubanScoreRecord> records = DBAgent.find("from DubanScoreRecord where taskId=:taskId and memberId=:memberId",params);
        if(!CollectionUtils.isEmpty(records)){
            double zgS = 0;
            int size=0;
            for(DubanScoreRecord rd:records){
                if("-999".equals(rd.getZhuGuanScore())){
                    continue;
                }
                Double sc = CommonUtils.getDouble(rd.getZhuGuanScore());
                if(sc!=null){
                    zgS+=sc;
                    size++;
                }

            }
            if(size>0){
                Double zgScore = zgS/size;
                dubanTask.setZgScore(zgScore.intValue());
            }else{
                dubanTask.setZgScore(0);
            }
        }else{
            dubanTask.setZgScore(0);
        }



        //calculateSocre

        return dubanTask;
    }

    public void caculateScoreWhenStartOrProcess(final String templateCode, final ColSummary colSummary, final V3xOrgMember member) {
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
                        String taskId = (String) data.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK_FEEDBACK, "任务ID")); //任务ID "field0002"
                        Object taskStatus = data.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK_FEEDBACK, "任务状态"));//任务状态 "field00029"


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
                                if (sdt == null) {
                                    record.setWeight(task.getMainWeight());
                                } else {
                                    record.setWeight(sdt.getWeight());
                                }

                            }
                            DBAgent.save(record);

                        }
                        //end of 打分记录
                        //主要逻辑
                        //1、看下任务量的分数有没有被算出来
//                        Double renwuliang = CommonUtils.getDouble(data.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK_FEEDBACK, "任务量")));//任务量 field0030
//                        if (renwuliang == null || renwuliang.intValue() <= 0) {
//                            //计算工作量
                        //tianxufeng 每次算最准确
                        V3xOrgDepartment dept = getOrgManager().getDepartmentById(member.getOrgDepartmentId());
                        Double rwScore = calculateSocre(dibiao, task, dept.getName(), dept.getId());
                        record.setKeGuanScore(decimalFormat.format(rwScore));
                        updateStringFieldByTableAndId(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK_FEEDBACK, "任务量"), record.getKeGuanScore(), tableFtd.getFormTable().getName(), colSummary.getFormRecordid());
//                        }else{
//                            record.setKeGuanScore(decimalFormat.format(renwuliang));//因为文平修改的前台有分了，所以要设置上。tianxufeng
//                        }

                        Double dafen = CommonUtils.getDouble(data.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK_FEEDBACK, "汇报分")));//汇报分 field0028
                        if (dafen != null) {
                            record.setZhuGuanScore(decimalFormat.format(dafen));
                        } else {
                            record.setZhuGuanScore("0");
                        }
                        record.setExtVal(String.valueOf(taskStatus));
                        if ("DB_FEEDBACK".equals(templateCode)) {

                            record.setZhuGuanScore("-999");

                        }
                        DBAgent.update(record);

                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }, 1, TimeUnit.SECONDS);


    }

    public void onFeedBackFinish(final String templateCode, final ColSummary colSummary, final V3xOrgMember member) throws BusinessException {
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
                String taskId = (String) data.get(FieldName2Field00xxUtils.getfield00xx(templateCode, "任务ID"));//任务ID field0002
                Object field0001 = data.get(FieldName2Field00xxUtils.getfield00xx(templateCode, "申请办结"));//申请办结 field0001
                Object field0014 = data.get(FieldName2Field00xxUtils.getfield00xx(templateCode, "完成率"));//完成率 field0014
                Object fieldStatus = data.get(FieldName2Field00xxUtils.getfield00xx(templateCode, "任务状态"));//完成率 field0029

                if (taskId == null) {
                    System.out.println("数据有问题:" + data);
                    return;
                }
                String cont = (String) data.get(FieldName2Field00xxUtils.getfield00xx(templateCode, "汇报内容"));//汇报内容 field0015
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
                    String cont_ = "\n" + dept.getName() + "-" + member.getName() + "(" + CommonUtils.formatDateHourMinute(colSummary.getStartDate()) + "):" + cont;

                    cont = cont_;
                }

                Map dibiao = DubanMainService.getInstance().getOringinalDubanData(taskId);

                DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, dibiao, ftd);

                /**
                 * field0013 进度
                 */
                String memo = (String) dibiao.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "汇报信息"));//汇报信息 field0093
                if (CommonUtils.isEmpty(memo)) {
                    memo = cont;
                } else {
                    memo = memo + "\n" + cont;
                    memo = sortByTime(memo);
                }

                //先看是不是承办
                //field0017 承办bumen
                Object cb = dibiao.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "承办部门名称")); //承办部门名称 field0017
                String andSetSQL = "";
                if (cb != null && String.valueOf(cb).equals(String.valueOf(deptId))) {
                    //field0021 主办完成率
                    //field0022 主办办结日期
                    //field0018 权重
                    //field0020 主办任务状态
                    andSetSQL += "," + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "主办完成率") + "=" + field0014;
                    andSetSQL += "," + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "任务状态") + "='" + CommonUtils.getEnumShowValue(fieldStatus) + "'";//直接存”低风险等枚举值“
//tianxufeng 汇报的时候办结取消掉了。
//                    if ("1".equals(String.valueOf(field0001))) //直接是办结
//                    {
//                        Date finishDate = (Date) data.get(FieldName2Field00xxUtils.getfield00xx(templateCode, "办结日期"));//办结日期 field0019
//                        andSetSQL += "," + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "实际办结日期") + "='" + CommonUtils.formatDateSimple(finishDate) + "'";
//                        andSetSQL += "," + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "主办办结日期") + "='" + CommonUtils.formatDateSimple(finishDate) + "'";
//                        andSetSQL += "," + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "主办任务状态") + "='已完成'";
//                    }
//                    else{
                    andSetSQL += "," + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "主办任务状态") + "='进行中'";
                    //}

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
//                            if ("1".equals(String.valueOf(field0001))) {
//                                Date finishDate = (Date) data.get(FieldName2Field00xxUtils.getfield00xx(templateCode, "办结日期"));//办结日期 field0019
//                                String finishDateField = "field00" + (29 + 7 * (index - 1));
//                                andSetSQL += ("," + finishDateField + "='" + CommonUtils.formatDateSimple(finishDate) + "'");
//                                String statusField = "field00" + (27 + 7 * (index - 1));
//                                andSetSQL += ("," + statusField + "='已完成'");
////                                calculateDone(taskId);
//                            }
//                            else{
                            String statusField = "field00" + (27 + 7 * (index - 1));
                            andSetSQL += ("," + statusField + "='进行中'");
                            //}
                        }

                    }
                }

                //汇报信息 field0093
                String updateSQL = "update " + ftd.getFormTable().getName() + " set " + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "汇报信息") + "='" + memo + "'" + andSetSQL + " where id=" + dibiao.get("id");
                System.out.println(updateSQL);
                calculateDone(taskId);
                DataBaseUtils.executeUpdate(updateSQL);
                caculateAllProcess(taskId);
            }
        }, 4, TimeUnit.SECONDS);


    }

    private static String sortByTime(String count) {
        if (CommonUtils.isEmpty(count)) {
            return "";
        }
        String[] vals = count.split("\n");
        List<String> list = new ArrayList<String>();
        for (String line : vals) {

            if (CommonUtils.isEmpty(line) || CommonUtils.isEmpty(line.trim())) {
                continue;
            }
            list.add(line);
        }
        Collections.sort(list, new Comparator<String>() {
            public int compare(String o1, String o2) {
                try {
                    String time1 = o1.split("\\(")[1].split("\\)")[0];
                    String time2 = o2.split("\\(")[1].split("\\)")[0];
                    return time2.compareTo(time1);

                } catch (Exception e) {
                    e.printStackTrace();
                }
                return o2.compareTo(o1);


            }
        });

        return CommonUtils.join(list, "\n\n\n");
    }

    private void caculateAllProcess(final String taskId) {
        executorPoolService.schedule(new Runnable() {
            public void run() {
                FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
                Map dibiao = DubanMainService.getInstance().getOringinalDubanData(taskId);

                DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, dibiao, ftd);

                Double p = 0d;
                String mainWeight = task.getMainWeight();
                Double weight = CommonUtils.getDouble(mainWeight);
                if (weight == null) {
                    return;
                } else {
                    weight = weight / 100f;
                }
                String mainProcess = task.getMainProcess();
                Double process = CommonUtils.getDouble(mainProcess);
                if (process == null) {
                    process = 0d;
                }
                p += (weight * process);
                List<SlaveDubanTask> slaveDubanTaskList = task.getSlaveDubanTaskList();
                if (!CommonUtils.isEmpty(slaveDubanTaskList)) {
                    for (SlaveDubanTask dubanTask : slaveDubanTaskList) {
                        String subweight = dubanTask.getWeight();
                        Double subW = CommonUtils.getDouble(subweight);
                        if (subW == null) {
                            continue;
                        } else {
                            subW = (subW / 100f);
                        }

                        String subProcess = dubanTask.getProcess();
                        Double subP = CommonUtils.getDouble(subProcess);
                        if (subP == null) {
                            subP = 0D;
                        }
                        p += (subW * subP);
                    }

                }

                //add by tianxufeng 如果算出＜100%，说明有的配合或主办还没完成
                String finishedflag = "1";
                if (p.intValue() < 100) {
                    finishedflag = "0";
                }

                // 完成进度 field0013,任务ID field0001
                String sql = "update " + ftd.getFormTable().getName() + " set finishedflag=" + finishedflag + "," + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "完成进度")
                        + "=" + p.intValue() + " where " + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "任务ID") + "='" + taskId + "'";

                DataBaseUtils.executeUpdate(sql);


            }
        }, 1, TimeUnit.SECONDS);

    }

    public void onDoneApplyFinish(final String templateCode, final ColSummary colSummary, final V3xOrgMember member) throws BusinessException {

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
                String taskId = (String) data.get(FieldName2Field00xxUtils.getfield00xx(templateCode, "任务ID"));//任务IDfield0001
                Date finishDate = (Date) data.get(FieldName2Field00xxUtils.getfield00xx(templateCode, "实际办结日期"));//field0014 add by tianxufeng
                Map dibiao = DubanMainService.getInstance().getOringinalDubanData(taskId);
                DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, dibiao, ftd);
                Object cb = dibiao.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "承办部门名称"));//承办部门名称 field0017
                String andSetSQL = "";
                if (cb != null && String.valueOf(cb).equals(String.valueOf(member.getOrgDepartmentId()))) {
                    //field0020 主办任务状态
                    //field0021 主办完成率
                    //field0022 主办办结日期
                    //field0018 权重

                    //主办说办完了，就应该是完了，所以要填写实际办结日期 tianxufeng,而且要写表单填写的日期
                    andSetSQL += "," + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "主办完成率") + "=100";
                    andSetSQL += "," + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "主办办结日期") + "='" + CommonUtils.formatDateSimple(finishDate) + "'";
                    andSetSQL += "," + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "实际办结日期") + "='" + CommonUtils.formatDateSimple(finishDate) + "'";
                    andSetSQL += "," + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "主办任务状态") + "='已完成'";
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
                            andSetSQL += ("," + processField + "=100");
                            String finishDateField = "field00" + (29 + 7 * (index - 1));
                            andSetSQL += ("," + finishDateField + "='" + CommonUtils.formatDateSimple(finishDate) + "'");
                            String statusField = "field00" + (27 + 7 * (index - 1));
                            andSetSQL += ("," + statusField + "='已完成'");
                        }

                    }
                }
                //现在设置的这个finishedflage暂时设置成1，后面如果算出来的完成进度不到100，就在设置成0  tianxufeng
                String updateSQL = "update " + ftd.getFormTable().getName() + " set finishedflag=1" + andSetSQL + " where "
                        + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "任务ID") + "='" + taskId + "'";
                System.out.println(updateSQL);
                DataBaseUtils.executeUpdate(updateSQL);
                calculateDone(taskId);
                caculateAllProcess(taskId);

            }
        }, 1, TimeUnit.SECONDS);


    }
    public void onApprovingFinish(final String formRecordId){
        executorPoolService.schedule(new Runnable() {
            public void run() {
                String tableName = ConfigFileService.getPropertyByName("ctp.table.DB_TASK_MAIN");
                String sql = "select field0001 from "+tableName+" where id="+formRecordId;
                System.out.println(sql);
                Map map = DataBaseUtils.querySingleDataBySQL(sql);
                Object taskId = map.get("field0001");
                if(taskId!=null&&!StringUtils.isEmpty(""+taskId)){
                    calculateDone(String.valueOf(taskId));
                }
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
                String taskId = (String) data.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK_DELAY_APPLY, "任务ID")); //任务ID field0001
                Date date = (Date) data.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK_DELAY_APPLY, "延期后办结日期"));//延期后办结日期 field0014
                if (date != null) {
                    //field0007 办理时限
                    String updateSQL = "update " + ftd.getFormTable().getName() +
                            " set " + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "办理时限") + "='" + CommonUtils.formatDate(date) +
                            "' where " + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "任务ID") + "='" + taskId + "'";
                    System.out.println(updateSQL);
                    DataBaseUtils.executeUpdate(updateSQL);

                } else {
                    System.out.println("延期个冒险:" + data);
                }
            }
        }, 1, TimeUnit.SECONDS);

    }

    public void onDoneApplyProcess(final String templateCode, final ColSummary colSummary, final V3xOrgMember member) throws BusinessException {
        executorPoolService.schedule(new Runnable() {

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
                String taskId = (String) data.get(FieldName2Field00xxUtils.getfield00xx(templateCode, "任务ID"));//任务ID
                //field0001 taskId0000000000000000000000000000000000000
                //这里也计算一下分数
                //field0028 任务量
                //field0026 汇报分
                //field0027 任务完成分
                Double rws = CommonUtils.getDouble(data.get(FieldName2Field00xxUtils.getfield00xx(templateCode, "任务量")));//任务量 "field0028"
                Double wancheng = CommonUtils.getDouble(data.get(FieldName2Field00xxUtils.getfield00xx(templateCode, "任务完成分")));//任务完成分 27
                if (rws == null || rws.intValue() <= 0) {
                    List<DubanScoreRecord> dsrList = DBAgent.find("from DubanScoreRecord where taskId='" + taskId + "' and memberId=" + member.getId());
                    if (!CollectionUtils.isEmpty(dsrList)) {
                        double kg = 0;
                        double zg = 0;
                        int kgSize = 0;
                        int zgSize = 0;
                        for (DubanScoreRecord dsr : dsrList) {

                            Double ss = CommonUtils.getDouble(dsr.getKeGuanScore());
                            if (ss != null) {
                                kg += ss;
                                kgSize++;
                            }
                            if ("-999".equals(dsr.getZhuGuanScore())) {
                                continue;
                            }
                            Double dd = CommonUtils.getDouble(dsr.getZhuGuanScore());
                            if (dd != null) {
                                zg += dd;
                                zgSize++;
                            }


                        }
                        double size = 1d * dsrList.size();
                        String kgUpdateval = kgSize == 0 ? "0" : decimalFormat.format(kg / kgSize);
                        String zgUpdateval = zgSize == 0 ? "0" : decimalFormat.format(zg / zgSize);
                        String sql2 = "update " + tableFtd.getFormTable().getName() +
                                " set " + FieldName2Field00xxUtils.getfield00xx(templateCode, "任务量") + "=" + kgUpdateval +
                                "," + FieldName2Field00xxUtils.getfield00xx(templateCode, "汇报分") + "=" + zgUpdateval + " where id=" + colSummary.getFormRecordid();
                        DataBaseUtils.executeUpdate(sql2);

                    }
                }
                if (wancheng != null && wancheng > 0) {
                    String uSql = "update duban_score_record set score='" + wancheng + "' where task_id = '" + taskId + "' and member_id=" + member.getId();
                    DataBaseUtils.executeUpdate(uSql);
                }
            }
        }, 1, TimeUnit.SECONDS);

    }


    private Double calculateSocre(Map dibiao, DubanTask task, String deptName, Long deptId) {
        //底表field0002 任务来源，field0003 任务分级
        String weight = "100";
        String xishu = "1";
        DataSetService dss = DataSetService.getInstance();
        if (isCengban(deptName, dibiao)) {
            //99999999
            weight = task.getMainWeight();
            xishu = dss.getDubanConfigItem("99999999").getItemValue();
        } else {
            //99999998
            SlaveDubanTask sdt = getSlaveTaskByTaskAndDeptId(task, deptId);
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

    public void calculateDone(String taskId) {
        try{
            System.out.println("===calculateDone===start===");
            String sql = "from DubanScoreRecord where taskId = '" + taskId + "'";
            List<DubanScoreRecord> dsrList = new ArrayList<DubanScoreRecord>();
            try {
                dsrList = DBAgent.find(sql);
            }catch(InfrastructureException e){
                sql="select * from duban_score_record where task_id='"+taskId+"'";
                List<Map> rtList = DataBaseUtils.queryDataListBySQL(sql);
                if(!CollectionUtils.isEmpty(rtList)){
                    if(dsrList==null){
                        dsrList = new ArrayList<DubanScoreRecord>();
                    }
                    for(Map data:rtList){
                        DubanScoreRecord rd = JSON.parseObject(JSON.toJSONString(data),DubanScoreRecord.class);
                        dsrList.add(rd);
                    }

                }

            }
            FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
            Map dibiao = DubanMainService.getInstance().getOringinalDubanData(taskId);
            DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, dibiao, ftd);
            Double rw = 0d, hb = 0d, wc = 0d, total = 0d;
            Map<Long, List<DubanScoreRecord>> deptDsr = new HashMap<Long, List<DubanScoreRecord>>();
            if(!CollectionUtils.isEmpty(dsrList)){
                for (DubanScoreRecord dsr : dsrList) {
                    List<DubanScoreRecord> dsrs = deptDsr.get(dsr.getDepartmentId());
                    if (dsrs == null) {
                        dsrs = new ArrayList<DubanScoreRecord>();
                        deptDsr.put(dsr.getDepartmentId(), dsrs);
                    }
                    dsrs.add(dsr);
                }
            }

            //先算任务分
            String mainDeptName = task.getMainDeptName();//部门中文名
            Object cbId = dibiao.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "承办部门名称"));
            Double cbScore = calculateSocre(dibiao, task, mainDeptName, Long.valueOf(cbId != null ? String.valueOf(cbId) : "0"));
            Map<String, Double> rwScoreMap = new HashMap<String, Double>();
            rwScoreMap.put(mainDeptName, cbScore);
            rw += cbScore;
            //slave的是id
            List<SlaveDubanTask> slaveDubanTasks = task.getSlaveDubanTaskList();
            //todo
            if (!CollectionUtils.isEmpty(slaveDubanTasks)) {
                for (SlaveDubanTask slaveDubanTask : slaveDubanTasks) {
                    //todo
                    try {
                        String sDeptName = slaveDubanTask.getDeptName();
                        if (StringUtils.isEmpty(sDeptName)) {
                            continue;
                        }
                        V3xOrgDepartment department = getOrgManager().getDepartmentById(Long.valueOf(slaveDubanTask.getDeptName()));
                        Double xbScore = calculateSocre(dibiao, task, department.getName(), Long.valueOf(slaveDubanTask.getDeptName()));
                        rwScoreMap.put(department.getName(), xbScore);
                        rw += xbScore;
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                }
            }
            // DubanTask task = mainService.translateDubanTask()
            for (Map.Entry<Long, List<DubanScoreRecord>> entry : deptDsr.entrySet()) {
                List<DubanScoreRecord> eList = entry.getValue();
                double hbs = 0d, wcs = 0d;
                double zhuguanSize = 0d;
                double wanchengSize = 0d;
                for (DubanScoreRecord dsr : eList) {
                    Double wcf = CommonUtils.getDouble(dsr.getScore());
                    if (wcf != null && wcf > 0) {
                        wcs += wcf;
                        wanchengSize++;
                    }

                    //汇报分应该最后算，否则如果都是主动汇报，直接办结就没有完成分了。tianxufeng
                    if ("-999".equals(dsr.getZhuGuanScore())) {
                        continue;
                    }
                    Double hbf = CommonUtils.getDouble(dsr.getZhuGuanScore());
                    if (hbf != null && hbf > 0) {
                        hbs += hbf;
                        zhuguanSize++;
                    }
                }
                //tianxufeng 客观分已经乘过权重了。 这里有问题，就1个部门汇报了，就把自己的任务量写进去了。
                Long deptId = entry.getKey();
                try {
                    V3xOrgDepartment dept = getOrgManager().getDepartmentById(deptId);
                    String deptName = dept.getName();
                    Double rwScore = rwScoreMap.get(deptName);

                    double hbAvg = zhuguanSize == 0d ? 0d : hbs / zhuguanSize;
                    double wcAvg = wanchengSize == 0d ? 0d : wcs / wanchengSize;//完成分就打了一次，其实随便一个就行
                    double hbFen_= (hbAvg * (rwScore / rw));
                    double wcFen_= (wcAvg * (rwScore / rw));
                    double yourlastFen_ = (rwScore * (hbAvg/100d) * (wcAvg / 100d));

                    hb    += hbFen_;
                    wc    += wcFen_;
                    System.out.println("["+deptName+"]的最总得分="+yourlastFen_);
                    total += yourlastFen_;

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }


            System.out.println("任务的最终得分="+total);
            // total = (rw * (hb / 100d) * (wc / 100d));
//这个直接把任务量写进去了，如果有配合的存在，配合的如27分直接就写进去了，应该写总量。
            //       所以要calculateSocre要有个只算任务的，直接写算出来的任务量
            //String sql2 = "update " + ftd.getFormTable().getName() + " set field0146=" + (rw == 0 ? 0 : decimalFormat.format(rw)) + ",field0144=" + (hb == 0 ? 0 : decimalFormat.format(hb)) + ",field0143=" + (total == 0 ? 0 : decimalFormat.format(total)) + ",field0145=" + (wc == 0 ? 0 : decimalFormat.format(wc)) + " where field0001='" + taskId + "'";
            String sql2 = "update " + ftd.getFormTable().getName() + " set "
                    + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "任务量") + "=" + (rw == 0 ? 0 : decimalFormat.format(rw)) + ","
                    + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "汇报分") + "=" + (hb == 0 ? 0 : decimalFormat.format(hb)) + ","
                    + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "最终得分") + "=" + (total == 0 ? 0 : decimalFormat.format(total)) + ","
                    + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "任务完成分") + "=" + (wc == 0 ? 0 : decimalFormat.format(wc)) + " where "
                    + FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK, "任务ID") + "='" + taskId + "'";
            System.out.println("sql2=" + sql2);
            DataBaseUtils.executeUpdate(sql2);
        }catch (Exception e){
            e.printStackTrace();
        }

    }

    //    //add by tianxufeng,获某表的某个field00xx
//    private String getfield00xx(String formCode, String displayName) {
//        if (formCode.equals(MappingCodeConstant.DUBAN_TASK))//底表
//        {
//            FieldName2Field00xxUtils fieldTools = FieldName2Field00xxUtils.getInstance_db();
//            return fieldTools.getField00xx(displayName);
//        } else if (formCode.equals(MappingCodeConstant.DUBAN_TASK_FEEDBACK_AUTO)//反馈表
//                || formCode.equals(MappingCodeConstant.DUBAN_TASK_FEEDBACK)) {
//            FieldName2Field00xxUtils fieldTools = FieldName2Field00xxUtils.getInstance_feedback();
//            return fieldTools.getField00xx(displayName);
//        } else if (formCode.equals(MappingCodeConstant.DUBAN_TASK_DELAY_APPLY))//延期
//        {
//            FieldName2Field00xxUtils fieldTools = FieldName2Field00xxUtils.getInstance_delay();
//            return fieldTools.getField00xx(displayName);
//        } else if (formCode.equals(MappingCodeConstant.DUBAN_DONE_APPLY))//办结
//        {
//            FieldName2Field00xxUtils fieldTools = FieldName2Field00xxUtils.getInstance_done();
//            return fieldTools.getField00xx(displayName);
//        }
//        return "";
//    }
    private SlaveDubanTask getSlaveTaskByTaskAndDeptId(DubanTask task, Long deptId) {
        List<SlaveDubanTask> slaveDubanTaskList = task.getSlaveDubanTaskList();
        if (!CommonUtils.isEmpty(slaveDubanTaskList)) {
            for (SlaveDubanTask stask : slaveDubanTaskList) {
                if (stask.getDeptName() != null && stask.getDeptName().equals(("" + deptId))) {
                    return stask;
                }

            }
        }

        return null;

    }

    private SlaveDubanTask getSlaveTaskByTaskAndMember(DubanTask task, V3xOrgMember member) {
        List<SlaveDubanTask> slaveDubanTaskList = task.getSlaveDubanTaskList();
        try {
            V3xOrgDepartment department = getOrgManager().getDepartmentById(member.getOrgDepartmentId());
        } catch (BusinessException e) {
            e.printStackTrace();
        }
        if (!CommonUtils.isEmpty(slaveDubanTaskList)) {
            for (SlaveDubanTask stask : slaveDubanTaskList) {
                if (stask.getDeptName() != null && stask.getDeptName().equals(("" + member.getOrgDepartmentId()))) {
                    return stask;
                }

            }
        }

        return null;

    }

    public boolean isCengban(String name, Map dibiao) {
        Object cb = dibiao.get("field0017");
        try {
            V3xOrgDepartment department = this.getOrgManager().getDepartmentById(Long.valueOf(String.valueOf(cb)));
            if (name != null && name.equals(String.valueOf(department.getName()))) {
                return true;
            }
        } catch (BusinessException e) {
            e.printStackTrace();
        }

        return false;

    }

    public boolean isCengban(V3xOrgMember member, Map dibiao) {
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

    public static void main(String[] args) {
        String lkey = "博远售后服务-表单管理员(2020-07-31 16:30):第一次汇报\n" +
                "博远售后服务-表单管理员(2020-07-31 16:34):第三次汇报\n" +
                "博远售后服务-表单管理员(2020-07-31 16:31):第二次汇报";

        System.out.println(1 * 20 / 5 * 4);
        DubanScoreRecord record = new DubanScoreRecord();
        record.setKeGuanScore(""+100);
        record.setTaskId("20201101002");
        record.setWeight("90");
        Map t = JSON.parseObject(JSON.toJSONString(record),HashMap.class);
        System.out.println(t);
        System.out.println(JSON.toJSONString(JSON.parseObject(JSON.toJSONString(t),DubanScoreRecord.class)));


    }


}
