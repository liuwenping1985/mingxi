package com.seeyon.apps.kdXdtzXc.base.manager;


import java.util.Map;

/**
 * Created by taoan on 2016-7-25.
 */
public interface FormTableService {

    public Long getFormRecordId(long affairId) throws Exception;

    public Long getFormAppId(long flowid) throws Exception;

    public Map<String, Object> getFormAppMainData(long formmain_id) throws Exception;

    public Map<String, Object> getFormAppMainDataByAppName(String appName) throws Exception;

    public Long getFlowIdByFormAppid(long formappid) throws Exception;

    public Map<String, Object> getCtpTemplate(String id) throws Exception;
}
