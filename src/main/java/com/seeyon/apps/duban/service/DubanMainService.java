package com.seeyon.apps.duban.service;

import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.mapping.MappingService;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.duban.wrapper.DataTransferStrategy;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.util.DBAgent;

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
     * 督办员的列表
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getDubanTaskSupervisor(Long memberId) {


        return null;

    }

    /**
     * 承办领导的列表
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getDubanTaskMainLeader(Long memberId) {

        return null;
    }
    /**
     * 协办领导的列表
     *
     * @param memberId
     * @return
     */
    public List<DubanTask> getDubanTaskColLeader(Long memberId) {

        return null;
    }
    /**
     * 领导可查看的督办任务
     *
     * @param memberId
     * @return
     */
    public List<Map> getMyMainDubanTask(Long memberId) {

        return null;
    }

    /**
     * 协办
     *
     * @param memberId
     * @return
     */
    public List<Map> getCollDubanTask(Long memberId) {

        return null;
    }

    private static int SUMMARY_FINISH_STATE = 3;

    public List<DubanTask> getDubanTask() {
        List<DubanTask> retList = new ArrayList<DubanTask>();
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK_AFFIRM);
        String templateId = ConfigFileService.getPropertyByName("ctp.template.ids");
        String sql = "select * from " + ftd.getFormTable().getName() + " where id in (select FORM_RECORDID from col_summary where TEMPLETE_ID=" + templateId + " AND STATE=" + SUMMARY_FINISH_STATE + ")";
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


}
