package com.seeyon.apps.duban.service;

import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.duban.wrapper.DataTransferStrategy;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
/**
 * Created by liuwenping on 2019/11/25.
 */
public class DubanMainService {

    private static DubanMainService dubanMainService = new DubanMainService();

    public static DubanMainService getInstance() {

        return dubanMainService;

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
        String sql = "select * from " + ftd.getFormTable().getName() + " where (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + "!=100 or "+MappingCodeConstant.FIELD_DUBAN_WANCHENGLV+" is null) and " + MappingCodeConstant.FIELD_DUBAN_RENYUAN + "=" + memberId;
        return translateDubanTask(sql, ftd);

    }

    /**
     * 我的督办(已完成)---督办人员filed0012
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getFinishedDubanTaskSupervisor(Long memberId) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + "=100 and " + MappingCodeConstant.FIELD_DUBAN_RENYUAN + "=" + memberId;
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
        String sql = "select * from " + ftd.getFormTable().getName() + " where (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + "!=100 or "+MappingCodeConstant.FIELD_DUBAN_WANCHENGLV+" is null) and  (field0010=" + memberId + " or field0011 like '%" + memberId + "%')";
        return translateDubanTask(sql, ftd);
    }

    /**
     * 领导已完成的列表---field0011可查看领导字段
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getFinishedLeaderDubanTaskList(Long memberId) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + "=100 and  (field0010=" + memberId + " or field0011 like '%" + memberId + "%')";
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
        String sql = "select * from " + ftd.getFormTable().getName() + " where (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + "!=100 or "+MappingCodeConstant.FIELD_DUBAN_WANCHENGLV+" is null) and" +
                " (field0094 =" + memberId + " or field0095 =" + memberId + " or field0096 =" + memberId
                + " or field0097 =" + memberId + " or field0098 =" + memberId + " or field0099 =" + memberId
                + " or field0100 =" + memberId + " or field0101 =" + memberId + " or field0102 =" + memberId
                + " or field0103 =" + memberId + " or field0104 =" + memberId + ")";


        return translateDubanTask(sql, ftd);
    }
    /**
     * 我的协办（已完成）---配合部门负责人签字的是我一共10个 94->104
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getFinishedColLeaderDubanTaskList(Long memberId) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + "=100 and" +
                " (field0094 =" + memberId + " or field0095 =" + memberId + " or field0096 =" + memberId
                + " or field0097 =" + memberId + " or field0098 =" + memberId + " or field0099 =" + memberId
                + " or field0100 =" + memberId + " or field0101 =" + memberId + " or field0102 =" + memberId
                + " or field0103 =" + memberId + " or field0104 =" + memberId + ")";


        return translateDubanTask(sql, ftd);
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
                " field0094 =" + memberId + " or field0095 =" + memberId + " or field0096 =" + memberId
                + " or field0097 =" + memberId + " or field0098 =" + memberId + " or field0099 =" + memberId
                + " or field0100 =" + memberId + " or field0101 =" + memberId + " or field0102 =" + memberId
                + " or field0103 =" + memberId + " or field0104 =" + memberId ;


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

        String sql = "select * from " + ftd.getFormTable().getName() + " where (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + "!=100 or "+MappingCodeConstant.FIELD_DUBAN_WANCHENGLV+" is null) and"+
        " (field0047 =" + memberId + " or field0051 =" + memberId + " or field0055 =" + memberId
                + " or field0059 =" + memberId + " or field0063 =" + memberId + " or field0067 =" + memberId
                + " or field0071 =" + memberId + " or field0075 =" + memberId + " or field0079 =" + memberId
                + " or field0083 =" + memberId + " or field0087 =" + memberId + ")";
        return translateDubanTask(sql, ftd);

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

        String sql = "select * from " + ftd.getFormTable().getName() + " where " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV + "=100 and"+
                " (field0047 =" + memberId + " or field0051 =" + memberId + " or field0055 =" + memberId
                + " or field0059 =" + memberId + " or field0063 =" + memberId + " or field0067 =" + memberId
                + " or field0071 =" + memberId + " or field0075 =" + memberId + " or field0079 =" + memberId
                + " or field0083 =" + memberId + " or field0087 =" + memberId + ")";
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

        String sql = "select * from " + ftd.getFormTable().getName() + " where " +
                " field0047 =" + memberId + " or field0051 =" + memberId + " or field0055 =" + memberId
                + " or field0059 =" + memberId + " or field0063 =" + memberId + " or field0067 =" + memberId
                + " or field0071 =" + memberId + " or field0075 =" + memberId + " or field0079 =" + memberId
                + " or field0083 =" + memberId + " or field0087 =" + memberId;
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




    public List<DubanTask> getAllDubanTask() {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName();
        return translateDubanTask(sql,ftd);

    }


    public static void main(String [] argfs){
        System.out.println("TEST");
    }


}
