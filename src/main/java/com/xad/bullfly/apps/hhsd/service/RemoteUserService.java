package com.xad.bullfly.apps.hhsd.service;

import com.xad.bullfly.organization.domain.UserDomain;
import com.xad.bullfly.organization.repository.UserDomainRepository;
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
@Service("remoteUserService")
public class RemoteUserService {

    @Autowired
    @Qualifier("secondaryJdbcTemplate")
    private JdbcTemplate secondaryTemplate;

    @Autowired
    private UserDomainRepository userDomainRepository;


    public WebJsonResponse getUser(String userId) throws Exception {

        if (StringUtils.isEmpty(userId)) {
            return WebJsonResponse.fail("找不到用户id");
        }
        List<Map<String, Object>> resultList = secondaryTemplate.queryForList("SELECT * FROM ORG_MEMBER WHERE id="+userId);
        if(CollectionUtils.isEmpty(resultList)){
            return WebJsonResponse.fail("用"+userId+"找不到用户");
        }
        return WebJsonResponse.successWithData(resultList.get(0));
    }

    public UserDomain getRemoteUserAutoTrans(String userId) throws Exception {
        WebJsonResponse response= getUser(userId);
        UserDomain user = new UserDomain();
        Map data = (Map)response.getData();
        user.setId(Long.parseLong(userId));
        user.setUserName(String.valueOf(data.get("NAME")));
        user.setUserCode(String.valueOf(data.get("CODE")));
        user.setTenant(String.valueOf(data.get("ORG_ACCOUNT_ID")));
        user.setUnitId(user.getTenant());
        user.setUserDepartmentId(String.valueOf(data.get("ORG_DEPARTMENT_ID")));
        return user;
    }
}
