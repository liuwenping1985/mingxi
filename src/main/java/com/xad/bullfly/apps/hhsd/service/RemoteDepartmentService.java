package com.xad.bullfly.apps.hhsd.service;

import com.xad.bullfly.web.common.vo.WebJsonResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2020/9/10.
 */
@Service
public class RemoteDepartmentService {


    @Autowired
    @Qualifier("secondaryJdbcTemplate")
    private JdbcTemplate secondaryTemplate;


    public WebJsonResponse getDepartment(String deptId) throws Exception {

        if (StringUtils.isEmpty(deptId)) {
            return WebJsonResponse.fail("找不到部门id");
        }
        List<Map<String, Object>> resultList = secondaryTemplate.queryForList("SELECT * FROM ORG_UNIT WHERE id="+deptId);
        if(CollectionUtils.isEmpty(resultList)){
            return WebJsonResponse.fail("用"+deptId+"找不到用户");
        }
        return WebJsonResponse.successWithData(resultList.get(0));
    }

    public WebJsonResponse getAllUnit() throws Exception {

        List<Map<String, Object>> resultList = secondaryTemplate.queryForList("SELECT * FROM ORG_UNIT WHERE IS_DELETED=0 AND IS_ENABLE=1");

        return WebJsonResponse.successWithData(resultList.get(0));
    }

}
