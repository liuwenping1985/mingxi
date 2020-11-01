package com.seeyon.apps.duban.service;

import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.po.DubanScoreRecord;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.po.SlaveDubanTask;
import com.seeyon.apps.duban.stat.FieldName2Field00xxUtils;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.duban.wrapper.DataTransferStrategy;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.MemberRole;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import org.springframework.util.CollectionUtils;

import java.util.*;

/**
 * Created by liuwenping on 2019/11/25.
 */
public class DubanMainService_BAK {

    private static DubanMainService dubanMainService = new DubanMainService();

    public static DubanMainService getInstance() {
//        String license  = ConfigFileService.getPropertyByName("ctp.duban.xad.license");
//        if(MD5Util.MD5("hhsd").equals(license)){
//            return null;
//        }
        return dubanMainService;

    }

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

    public FormTableDefinition getMainFtdFromTable() {

        return MappingService.getInstance().getCachedMainFtd();
    }

    private boolean isDeptManager(Long memberId) {
        System.out.println("判断memberId是不是领导--start:" + memberId);
        try {
            List<MemberRole> roles = this.getOrgManager().getMemberRoles(memberId, AppContext.currentAccountId());
            for (MemberRole role : roles) {
                if ("DepManager".equals(role.getRole().getCode())) {
                    System.out.println("判断memberId是不是领导--result:YES");
                    return true;
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("判断memberId是不是领导--result:NO");
        return false;

    }

    private List<String> getAllMembersIdStringListBySeedMemberId(Long memberId) {
        try {

            V3xOrgMember member = this.getOrgManager().getMemberById(memberId);
            System.out.println("通过部门去找人start:" + member.getName());
            List<V3xOrgMember> accountsMemberList = this.getOrgManager().getAllMembers(member.getOrgAccountId());
            List<V3xOrgMember> members = new ArrayList<V3xOrgMember>();
            for (V3xOrgMember memberTemp : accountsMemberList) {
                if (String.valueOf(memberTemp.getOrgDepartmentId()).equals(String.valueOf(member.getOrgDepartmentId()))) {
                    members.add(memberTemp);

                }
            }
            System.out.println("通过部门去找人end-->size:" + members.size());
            if (members != null && members.size() > 0) {
                List<String> ids = new ArrayList<String>();
                for (V3xOrgMember member1 : members) {

                    ids.add(String.valueOf(member1.getId()));

                }
                return ids;

            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    private String getInCauseByJoinDot(List<String> membersList) {
        StringBuilder stb = new StringBuilder();
        int tag = 0;
        stb.append("(");
        for (String member : membersList) {
            if (tag == 0) {

                stb.append("'" + member + "'");
                tag++;
            } else {
                stb.append(",").append("'" + member + "'");
            }
        }
        stb.append(")");
        return stb.toString();

    }


    /**
     * 我的督办(进行中)---督办人员filed0012
     * 进行中的
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getRunningDubanTaskSupervisor(Long memberId) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);

        String sql = "select * from " + ftd.getFormTable().getName() + " where (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + "!=100 or " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + " is null) and " + MappingCodeConstant.FIELD_DUBAN_RENYUAN + "=" + memberId;
//        if (isDeptManager(memberId)) {
//
//            List<String> ids = getAllMembersIdStringListBySeedMemberId(memberId);
//            if (ids != null && ids.size() > 0) {
//                String inCause = getInCauseByJoinDot(ids);
//                sql = "select * from " + ftd.getFormTable().getName() + " where (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + "!=100 or " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + " is null) and " + MappingCodeConstant.FIELD_DUBAN_RENYUAN + "in" + inCause;
//            }
//
//        }
        List<DubanTask> taskList = translateDubanTask(sql, ftd);
//        if (!CollectionUtils.isEmpty(taskList)) {
//            for (DubanTask task : taskList) {
//
//                setTaskLight(task, memberId, "DB");
//            }
//        }

        return taskList;


    }

    public List<DubanTask> getStatDubanList(String taskIds) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String[] ids = taskIds.split(",");

        String inString = "'" + CommonUtils.joinArray(ids, "','") + "'";
        if ("''".length() == inString.length()) {
            return new ArrayList<DubanTask>();
        }
        String sql = "select * from " + ftd.getFormTable().getName() + " where field0001 in(" + inString + ")";
        List<DubanTask> taskList = translateDubanTask(sql, ftd);
        return taskList;


    }

    public void setTaskLight2(DubanTask task, Long memberId, String mode) {

        Date ed = task.getEndDate();
        Date st = task.getStartDate();
        long all = ed.getTime() - st.getTime();
        long now = System.currentTimeMillis();
        //周，半年度，双周，季度，月
        String zhouqi = task.getPeriod();
        Double section = 0D;
        if ("周".equals(zhouqi)) {
            section = 7 * 24 * 3600 * 1000D;
        } else if ("双周".equals(zhouqi)) {
            section = 2 * 7 * 24 * 3600 * 1000D;
        } else if ("月".equals(zhouqi)) {
            section = 30 * 24 * 3600 * 1000D;
        } else if ("季度".equals(zhouqi)) {
            section = 4 * 30 * 24 * 3600 * 1000D;
        } else if ("半年度".equals(zhouqi)) {
            section = 6 * 30 * 24 * 3600 * 1000D;
        } else {
            section = 6 * 30 * 24 * 3600 * 1000D;
        }
        String light = "normal";
        String p = "0";

        if ("CB".equals(mode)) {
            p = task.getMainProcess();
        }
        if ("XB".equals(mode)) {

            List<SlaveDubanTask> slaveDubanTaskList = task.getSlaveDubanTaskList();
            if (!CollectionUtils.isEmpty(slaveDubanTaskList)) {
                for (SlaveDubanTask sdt : slaveDubanTaskList) {
                    if (memberId != null && String.valueOf(memberId).equals(sdt.getLeader())) {
                        p = sdt.getProcess();
                        break;
                    }
                }
            }

        }
        if ("DB".equals(mode)) {
            p = task.getProcess();
        }

        long used = now - st.getTime();//经过了多长时间

        double jigezhouqi = all / (section * 1f);//有多少个周期

        double processPerSection = 100f / jigezhouqi;
        if (processPerSection > 100f) {
            processPerSection = 99f;//不能为100 不然超期判断不了
        }

        double nowShouldBeProcess = processPerSection * (used / (section * 1f));
        if (p == null || CommonUtils.isEmpty(p)) {
            p = "0";

        }
        Double nowProcess = Double.parseDouble(p);
        if (nowProcess.intValue() == 0) {
            nowProcess = processPerSection;
        }

        try {
            if (nowProcess >= nowShouldBeProcess) {
                if (nowProcess > 1.25 * nowShouldBeProcess) {
                    light = "blue";
                } else {
                    light = "green";
                }
            } else {

                if (nowProcess * 1.25 > nowShouldBeProcess) {
                    light = "orange";
                } else {
                    light = "red";
                }
            }
            //fix 一些特殊值
            if (now > ed.getTime()) {
                light = "red";
            }
            if ("blue".equals(light)) {
                if ("0".equals(p)) {
                    light = "green";
                }

            }


        } catch (Exception e) {

        }
        task.setTaskLight(light);

    }

    /**
     * 我的督办(已完成)---督办人员filed0012
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getFinishedDubanTaskSupervisor(Long memberId) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + "=100 and " + MappingCodeConstant.FIELD_DUBAN_RENYUAN + "=" + memberId;

//        if (isDeptManager(memberId)) {
//
//            List<String> ids = getAllMembersIdStringListBySeedMemberId(memberId);
//            if (ids != null && ids.size() > 0) {
//                String inCause = getInCauseByJoinDot(ids);
//                sql = "select * from " + ftd.getFormTable().getName() + " where " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + "=100 and " + MappingCodeConstant.FIELD_DUBAN_RENYUAN + "in " + inCause;
//            }
//
//        }
        return translateDubanTask(sql, ftd);

    }

    /**
     * 督办人员全部督办任务---督办人员filed0012
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getAllDubanTaskSupervisor(Long memberId) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where " + MappingCodeConstant.FIELD_DUBAN_RENYUAN + "=" + memberId;

        return translateDubanTask(sql, ftd);

    }


    /**
     * 领导现在运行的列表---field0011可查看领导字段
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getRuuningLeaderDubanTaskList(Long memberId) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + "!=100 or " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + " is null) and  (field0010=" + memberId + " or field0011 like '%" + memberId + "%')";
        List<DubanTask> taskList = translateDubanTask(sql, ftd);
//        if (!CollectionUtils.isEmpty(taskList)) {
//            for (DubanTask task : taskList) {
//                setTaskLight(task, memberId, "DB");
//            }
//        }

        return taskList;
    }

    /**
     * 领导已完成的列表---field0011可查看领导字段
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getFinishedLeaderDubanTaskList(Long memberId) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + "=100 and  (field0010=" + memberId + " or field0011 like '%" + memberId + "%')";
        return translateDubanTask(sql, ftd);
    }

    /**
     * 领导全部
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getAllLeaderDubanTaskList(Long memberId) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where field0010=" + memberId + " or field0011 like '%" + memberId + "%'";
        return translateDubanTask(sql, ftd);
    }

    /**
     * 我的协办（惊醒中）---配合部门负责人签字的是我一共10个 94->104
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getRuuningColLeaderDubanTaskList(Long memberId) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + "!=100 or " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + " is null) and" +
                " (field0026 =" + memberId + " or field0033 =" + memberId + " or field0040 =" + memberId
                + " or field0047 =" + memberId + " or field0054 =" + memberId + " or field0061 =" + memberId
                + " or field0068 =" + memberId + " or field0075 =" + memberId + " or field0082 =" + memberId
                + " or field0089 =" + memberId + ")";

        if (isDeptManager(memberId)) {

            List<String> ids = getAllMembersIdStringListBySeedMemberId(memberId);
            if (ids != null && ids.size() > 0) {
                String inCause = getInCauseByJoinDot(ids);
                sql = "select * from " + ftd.getFormTable().getName() + " where (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + "!=100 or " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + " is null) and" +
                        " (field0026 in" + inCause + " or field0033 in" + inCause + " or field0040 in" + inCause
                        + " or field0047 in" + inCause + " or field0054 in" + inCause + " or field0061 in" + inCause
                        + " or field0068 in" + inCause + " or field0075 in" + inCause + " or field0082 in" + inCause
                        + " or field0089 in" + inCause + ")";
            }

        }
        List<DubanTask> dubanTaskList = translateDubanTask(sql, ftd);

//        if (!CollectionUtils.isEmpty(dubanTaskList)) {
//            for (DubanTask task : dubanTaskList) {
//                setTaskLight(task, memberId, "XB");
//            }
//        }


        try {
            List<DubanTask> retList = new ArrayList<DubanTask>();
            V3xOrgMember member = this.getOrgManager().getMemberById(memberId);
            if (member != null) {
                String deptId = String.valueOf(member.getOrgDepartmentId());
                for (DubanTask task : dubanTaskList) {
                    List<SlaveDubanTask> slaveDubanTaskList = task.getSlaveDubanTaskList();
                    for (SlaveDubanTask sTask : slaveDubanTaskList) {
                        if (deptId.equals(sTask.getDeptName())) {
                            if (!"100".equals(sTask.getProcess())) {
                                retList.add(task);
                                break;
                            }

                        }
                    }
                }
                return retList;
            }
        } catch (BusinessException e) {
            e.printStackTrace();
        }


        return dubanTaskList;
    }

    /**
     * 我的协办（已完成）---配合部门负责人签字的是我一共10个 94->104
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getFinishedColLeaderDubanTaskList(Long memberId) {
        List<DubanTask> dubanTaskList = getAllColLeaderDubanTaskList(memberId);
        try {
            List<DubanTask> retList = new ArrayList<DubanTask>();
            V3xOrgMember member = this.getOrgManager().getMemberById(memberId);
            if (member != null) {
                String deptId = String.valueOf(member.getOrgDepartmentId());
                for (DubanTask task : dubanTaskList) {
                    List<SlaveDubanTask> slaveDubanTaskList = task.getSlaveDubanTaskList();
                    for (SlaveDubanTask sTask : slaveDubanTaskList) {
                        if (deptId.equals(sTask.getDeptName())) {
                            if ("100".equals(sTask.getProcess())) {
                                retList.add(task);
                                break;
                            }

                        }
                    }
                }
                return retList;
            }
        } catch (BusinessException e) {
            e.printStackTrace();
        }
        return dubanTaskList;
    }

    /**
     * 我的协办全部---配合部门负责人签字的是我一共10个 94->104
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getAllColLeaderDubanTaskList(Long memberId) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where" +
                " (field0026 =" + memberId + " or field0033 =" + memberId + " or field0040 =" + memberId
                + " or field0047 =" + memberId + " or field0054 =" + memberId + " or field0061 =" + memberId
                + " or field0068 =" + memberId + " or field0075 =" + memberId + " or field0082 =" + memberId
                + " or field0089 =" + memberId + ")";
        if (isDeptManager(memberId)) {

            List<String> ids = getAllMembersIdStringListBySeedMemberId(memberId);
            if (ids != null && ids.size() > 0) {
                String inCause = getInCauseByJoinDot(ids);
                sql = "select * from " + ftd.getFormTable().getName() + " where" +
                        " (field0026 in" + inCause + " or field0033 in" + inCause + " or field0040 in" + inCause
                        + " or field0047 in" + inCause + " or field0054 in" + inCause + " or field0061 in" + inCause
                        + " or field0068 in" + inCause + " or field0075 in" + inCause + " or field0082 in" + inCause
                        + " or field0089 in" + inCause + ")";
            }

        }

        return translateDubanTask(sql, ftd);
    }

    /**
     * 我的承办(运行中)----承办人签字的是我一共10个
     * 47,51,55，59,63，67,71，75,79，83,87，
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getRunningMainDubanTask(Long memberId) {

        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);

        String sql = "select * from " + ftd.getFormTable().getName() + " where (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + "!=100 or " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + " is null) and" +
                " (field0019=" + memberId + ")";
        if (isDeptManager(memberId)) {

            List<String> ids = getAllMembersIdStringListBySeedMemberId(memberId);
            if (ids != null && ids.size() > 0) {
                String inCause = getInCauseByJoinDot(ids);
                sql = "select * from " + ftd.getFormTable().getName() + " where (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + "!=100 or " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + " is null) and" +
                        " (field0019 in" + inCause + ")";
            }

        }
        List<DubanTask> taskList = translateDubanTask(sql, ftd);
//        if (!CollectionUtils.isEmpty(taskList)) {
//            for (DubanTask task : taskList) {
//                setTaskLight(task, memberId, "CB");
//            }
//        }

        return taskList;

    }

    /**
     * 我的承办(已完成)----承办人签字的是我一共10个
     * 47,51,55，59,63，67,71，75,79，83,87，
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getFinishedMainDubanTask(Long memberId) {

        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);

        String sql = "select * from " + ftd.getFormTable().getName() + " where " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + "=100 and" +
                " (field0019=" + memberId + ")";
        if (isDeptManager(memberId)) {

            List<String> ids = getAllMembersIdStringListBySeedMemberId(memberId);
            if (ids != null && ids.size() > 0) {
                String inCause = getInCauseByJoinDot(ids);
                sql = "select * from " + ftd.getFormTable().getName() + " where " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + "=100 and" +
                        " (field0019 in" + inCause + ")";
            }

        }
        return translateDubanTask(sql, ftd);

    }

    /**
     * 我的承办(全部)----承办人签字的是我一共10个
     * 47,51,55，59,63，67,71，75,79，83,87，
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getAllMainDubanTask(Long memberId) {

        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);

        String sql = "select * from " + ftd.getFormTable().getName() + " where field0019=" + memberId;
        if (isDeptManager(memberId)) {

            List<String> ids = getAllMembersIdStringListBySeedMemberId(memberId);
            if (ids != null && ids.size() > 0) {
                String inCause = getInCauseByJoinDot(ids);
                sql = "select * from " + ftd.getFormTable().getName() + " where field0019 in" + inCause;
            }

        }
        return translateDubanTask(sql, ftd);

    }

    public List<DubanTask> translateDubanTask(String sql, FormTableDefinition ftd) {
        List<DubanTask> retList = new ArrayList<DubanTask>();
        List<Map> dataList = DataBaseUtils.queryDataListBySQL(sql);
        if (CommonUtils.isEmpty(dataList)) {
            return retList;
        }
        Map<String, Object> taskIdAndChengbanId = new HashMap<String, Object>();
        for (Map data : dataList) {
            DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, data, ftd);
            if (task != null) {
                //设置状态
                taskIdAndChengbanId.put(task.getTaskId(), data.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK,"承办部门名称")));   //承办部门名称 field0017
                Double dbKgScore = CommonUtils.getDouble(data.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK,"任务量")));//任务量
                if (dbKgScore != null) {
                    task.setKgScore(dbKgScore.intValue());
                }
                Double huibaoScore = CommonUtils.getDouble(data.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK,"汇报分")));//汇报分
                if (huibaoScore != null) {
                    task.setZgScore(huibaoScore.intValue());
                }
                Double wanchengScore = CommonUtils.getDouble(data.get(FieldName2Field00xxUtils.getfield00xx(MappingCodeConstant.DUBAN_TASK,"任务完成分"))); //任务完成分
                if (wanchengScore != null) {
                    task.setTotoalScore(wanchengScore.intValue());
                }
                retList.add(task);
            }
        }
        String sql3="select id from col_summary where id in(select summary_id from duban_score_record where task_id in ('" + CommonUtils.joinSet(taskIdAndChengbanId.keySet(), "','") + "')) and state=3";
        List<Map> maps = DataBaseUtils.queryDataListBySQL(sql3);
        List<Long> summaryStateIdList = new ArrayList<Long>();
        for(Map su:maps){
            summaryStateIdList.add((Long)su.get("id"));
        }
        if(CollectionUtils.isEmpty(summaryStateIdList)){
            return retList;
        }
        Map params = new HashMap();
        List<String> taskIdList = new ArrayList<String>();
        taskIdList.addAll(taskIdAndChengbanId.keySet());
        String sql2 = " from DubanScoreRecord where taskId in (:taskIdList) and summaryId in (:summaryStateIdList)";
        params.put("taskIdList",taskIdList);
        params.put("summaryStateIdList",summaryStateIdList);
        System.out.println(sql2);
        List<DubanScoreRecord> recordList = DBAgent.find(sql2,params);
        Map<String, DubanScoreRecord> recordMap = new HashMap<String, DubanScoreRecord>();
        for (DubanScoreRecord record : recordList) {

            Long deptId = CommonUtils.getLong(taskIdAndChengbanId.get(record.getTaskId()));
            if (deptId == null) {
                continue;
            }
            Long recordDeptId = record.getDepartmentId();
            if (recordDeptId != null && recordDeptId.equals(deptId)) {

                DubanScoreRecord oldRecord = recordMap.get(record.getTaskId());
                if (oldRecord != null) {
                    Date oldDate = oldRecord.getCreateDate();
                    Date newDate = record.getCreateDate();
                    if (oldDate != null && newDate != null) {
                        if (oldDate.getTime() < newDate.getTime()) {
                            recordMap.put(record.getTaskId(), record);
                        }

                    }
                } else {
                    recordMap.put(record.getTaskId(), record);
                }
            }
        }
        for (DubanTask task : retList) {

            DubanScoreRecord record = recordMap.get(task.getTaskId());
            if (record != null) {
                Long enumId = CommonUtils.getLong(record.getExtVal());
                if (enumId != null) {
                    Object showValue = CommonUtils.getEnumShowValue(enumId);
                    if (showValue != null) {
                        task.setTaskLight(String.valueOf(showValue));
                    }
                }

            }
        }

        return retList;
    }

    public Map getOringinalDubanData(String taskId) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);

        String sql = "select * from " + ftd.getFormTable().getName() + " where field0001='" + taskId + "'";

        return DataBaseUtils.querySingleDataBySQL(sql);

    }


    public List<DubanTask> getAllDubanTask() {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName();
        return translateDubanTask(sql, ftd);

    }

    public String getFormTemplateCode(Long templateId) {
        String sql = "select templete_number from ctp_template where id = " + templateId;
        Map map = DataBaseUtils.querySingleDataBySQL(sql);
        if (!CollectionUtils.isEmpty(map)) {

            Object tn = map.get("templete_number");
            if (tn != null) {
                return (String) tn;
            }
        }
        return "";
    }

    private boolean isLogging = true;

    private void log(Object obj) {
        if (isLogging) {
            System.out.println(obj);
        }

    }

    public FormTableDefinition getFormTableDefinitionByCode(String templateCode) {

//        String sql = "select field_info from form_definition where id = (select content_template_id from ctp_content_all where id =(select body from ctp_template where templete_number='" + templateCode + "'))";
//
//        Map map = DataBaseUtils.querySingleDataBySQL(sql);
//        log("map.size:"+sql);
//        log(map.get("field_info"));
//        if (!CollectionUtils.isEmpty(map)) {
//
//            Object xmlObject = map.get("field_info");
//            if (xmlObject != null) {
//
//                try {
//
//                    String jsonString = XmlUtils.xmlString2jsonString("" + xmlObject);
//
//                    Map data = JSONObject.parseObject(jsonString, HashMap.class);
//
//                    return MappingService.getInstance().parseFormTableMapping(data);
//
//                } catch (IOException e) {
//
//                    e.printStackTrace();
//                }
//            }
//        }

        return MappingService.getInstance().getFormTableDefinitionDByCode(templateCode);


    }

    public static void main(String[] args) {

        System.out.println("111");
    }



}
