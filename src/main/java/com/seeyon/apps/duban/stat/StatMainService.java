package com.seeyon.apps.duban.stat;

import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.service.DubanMainService;
import com.seeyon.apps.duban.service.MappingService;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;

import java.util.List;
import java.util.Map;

public class StatMainService extends DubanMainService {
    private static StatMainService statMainService = new StatMainService();

    public static StatMainService getInstance() {
        return statMainService;
    }

    public List<DubanTask> getDubanTaskBySql(String whereSql) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + whereSql;
        System.out.println("sql="+sql);
        return translateDubanTask(sql, ftd);
    }


    public List<Map> getDelayAppByTaskId(String taskIdSql) {
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK_DELAY_APPLY);
        String sql = "select * from " + ftd.getFormTable().getName() + taskIdSql;
        System.out.println("查找发过延期的申请的sql="+sql);

        List<Map> dataList = DataBaseUtils.queryDataListBySQL(sql);
        return  dataList;
        //return translateDubanTask(sql, ftd);
    }


}
