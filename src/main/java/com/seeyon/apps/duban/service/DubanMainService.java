package com.seeyon.apps.duban.service;

import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.po.SlaveDubanTask;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.duban.wrapper.DataTransferStrategy;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import org.springframework.util.CollectionUtils;
import www.seeyon.com.utils.MD5Util;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2019/11/25.
 */
public class DubanMainService {

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

        List<DubanTask> taskList =  translateDubanTask(sql, ftd);
        if(!CollectionUtils.isEmpty(taskList)){
            for(DubanTask task:taskList){
                setTaskLight(task,memberId,"DB");
            }
        }

        return taskList;


    }

    public void setTaskLight(DubanTask task,Long memberId,String mode){

        Date ed = task.getEndDate();
        Date st = task.getStartDate();
        long all  = ed.getTime()-st.getTime();
        long now = System.currentTimeMillis();
        //周，半年度，双周，季度，月
        String zhouqi = task.getPeriod();
        Double section = 0D;
        if("周".equals(zhouqi)){
            section=7*24*3600*1000D;
        }else if ("双周".equals(zhouqi)){
            section=2*7*24*3600*1000D;
        }else if ("月".equals(zhouqi)){
            section=30*24*3600*1000D;
        }else if ("季度".equals(zhouqi)){
            section=4*30*24*3600*1000D;
        }else if ("半年度".equals(zhouqi)){
            section=6*30*24*3600*1000D;
        }else{
            section=6*30*24*3600*1000D;
        }
        String light="normal";
        String p = "0";

        if("CB".equals(mode)){
            p =  task.getMainProcess();
        }
        if("XB".equals(mode)){

            List<SlaveDubanTask> slaveDubanTaskList = task.getSlaveDubanTaskList();
            if(!CollectionUtils.isEmpty(slaveDubanTaskList)){
                for(SlaveDubanTask sdt:slaveDubanTaskList){
                    if(memberId!=null&&String.valueOf(memberId).equals(sdt.getLeader())){
                        p = sdt.getProcess();
                        break;
                    }
                }
            }

        }
        if("DB".equals(mode)){
            p = task.getProcess();
        }

        long used = now-st.getTime();//经过了多长时间

        double jigezhouqi = all/(section*1f);//有多少个周期

        double processPerSection = 100f/jigezhouqi;
        if(processPerSection>100f){
            processPerSection = 99f;//不能为100 不然超期判断不了
        }

        double nowShouldBeProcess = processPerSection*(used/(section*1f));
        if(p==null||CommonUtils.isEmpty(p)){
            p="0";

        }
        Double nowProcess = Double.parseDouble(p) ;
        if(nowProcess.intValue()==0){
            nowProcess = processPerSection;
        }

        try {
            if(nowProcess>=nowShouldBeProcess){
                if(nowProcess>1.25*nowShouldBeProcess){
                    light="blue";
                }else{
                    light = "green";
                }
            }else {

                if(nowProcess*1.25>nowShouldBeProcess){
                    light="orange";
                }else{
                    light="red";
                }
            }
            //fix 一些特殊值
            if(now>ed.getTime()){
                light="red";
            }
            if("blue".equals(light)){
                if("0".equals(p)){
                    light="green";
                }

            }


        }catch(Exception e){

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
        List<DubanTask> taskList =  translateDubanTask(sql, ftd);
        if(!CollectionUtils.isEmpty(taskList)){
            for(DubanTask task:taskList){
                setTaskLight(task,memberId,"DB");
            }
        }

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


        List<DubanTask> dubanTaskList = translateDubanTask(sql, ftd);

        if(!CollectionUtils.isEmpty(dubanTaskList)){
            for(DubanTask task:dubanTaskList){
                setTaskLight(task,memberId,"XB");
            }
        }


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
        List<DubanTask> taskList =  translateDubanTask(sql, ftd);
        if(!CollectionUtils.isEmpty(taskList)){
            for(DubanTask task:taskList){
                setTaskLight(task,memberId,"CB");
            }
        }

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
        return translateDubanTask(sql, ftd);

    }

    private List<DubanTask> translateDubanTask(String sql, FormTableDefinition ftd) {
        List<DubanTask> retList = new ArrayList<DubanTask>();
        List<Map> dataList = DataBaseUtils.queryDataListBySQL(sql);
        if (CommonUtils.isEmpty(dataList)) {
            return retList;
        }
        for (Map data : dataList) {
            DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, data, ftd);
            if (task != null) {

                retList.add(task);
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

    public static void main(String[] args){


    }



}
