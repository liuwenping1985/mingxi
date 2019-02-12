package com.seeyon.apps.kdXdtzXc.base.manager.impl;


import com.seeyon.apps.kdXdtzXc.base.dao.FormTableDao;
import com.seeyon.apps.kdXdtzXc.base.manager.FormTableService;
import com.seeyon.apps.kdXdtzXc.base.util.SqlUtil;

import java.util.List;
import java.util.Map;

/**
 * Created by taoan on 2016-7-25.
 */

public class FormTableServiceImpl implements FormTableService {

    private FormTableDao formTableDao;


    public void setFormTableDao(FormTableDao formTableDao) {
        this.formTableDao = formTableDao;
    }

    public Long getFormRecordId(long affairId) throws Exception {
        System.out.println("sql affair id=" + affairId);
        String getFormRecordidStr = SqlUtil.getFilterSql("formTable", "getFormRecordId");
        List<Map<String, Object>> list = formTableDao.queryForList(getFormRecordidStr, new Object[]{new Long(affairId)});
        if (list != null && list.size() > 0) {
            return Long.parseLong(list.get(0).get("form_recordid") + "");
        }
        return null;
    }

    public Long getFormAppId(long flowid) throws Exception {
        String getFormRecordidStr = SqlUtil.getFilterSql("formTable", "getFormAppId");
        return formTableDao.queryForLong(getFormRecordidStr, new Object[]{new Long(flowid)});
    }

    public Long getFlowIdByFormAppid(long formappid) throws Exception {
        String getFormRecordidStr = SqlUtil.getFilterSql("formTable", "getFlowIdByFormAppid");
        return formTableDao.queryForLong(getFormRecordidStr, new Object[]{new Long(formappid)});
    }


    public Map<String, Object> getFormAppMainData(long formmain_id) throws Exception {
        String getFormRecordidStr = SqlUtil.getFilterSql("formTable", "getFormAppMainData");
        List<Map<String, Object>> list = formTableDao.queryForList(getFormRecordidStr, new Object[]{new Long(formmain_id)});
        if (list != null && list.size() > 0)
            return list.get(0);
        return null;
    }

    public Map<String, Object> getFormAppMainDataByAppName(String appName) throws Exception {
        String getFormRecordidStr = SqlUtil.getFilterSql("formTable", "getFormAppMainDataByAppName");
        List<Map<String, Object>> list = formTableDao.queryForList(getFormRecordidStr, new Object[]{appName});
        if (list != null && list.size() > 0)
            return list.get(0);
        return null;
    }


    public Map<String, Object> getCtpTemplate(String id) throws Exception {
        String getFormRecordidStr = SqlUtil.getFilterSql("formTable", "getCtpTemplate");
        List<Map<String, Object>> list = formTableDao.queryForList(getFormRecordidStr, new Object[]{id});
        if (list != null && list.size() > 0)
            return list.get(0);
        return null;
    }


}
