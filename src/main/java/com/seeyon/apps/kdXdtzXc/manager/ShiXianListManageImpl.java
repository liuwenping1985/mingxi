package com.seeyon.apps.kdXdtzXc.manager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.v3x.common.web.login.CurrentUser;

public class ShiXianListManageImpl implements ShiXianListManage {
    JdbcTemplate kimdeJdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");

    @Override
    public FlipInfo getAllDaiBan(FlipInfo paramFlipInfo, Map<String, Object> params) throws BusinessException {
        User user = CurrentUser.get();

        String hql = "from  CtpAffair  t left JOIN FormDefinition t1 on t.formAppId=t1.id where  t.state=3 and memberId= :memberId";
        params.put("memberId", user.getId());
        List find = DBAgent.find(hql, params, paramFlipInfo);
        paramFlipInfo.setData(find);
        return paramFlipInfo;
    }

    @Override// 待办
    public List<Map<String, Object>> getAllDaiBanShiXian() {
        User user = CurrentUser.get();
        String sql = "SELECT t1.NAME AS form_name,t2.NAME AS name, t.* FROM ctp_affair  t LEFT JOIN form_definition t1 " +
                "                                      ON t.form_app_id=t1.id  " +
                "                                      LEFT JOIN CTP_TEMPLATE_CATEGORY t2 " +
                "                                      ON t1.CATEGORY_ID=t2.ID " +
                "                                      WHERE  t.STATE=3 and member_id= ? ORDER BY t.receive_time DESC";
        List<Map<String, Object>> queryForList = kimdeJdbcTemplate.queryForList(sql, new Object[]{user.getId()});
        return queryForList;
    }

    @Override//已办
    public List<Map<String, Object>> getAllYiBanShiXian() {
        User user = CurrentUser.get();
        String sql = "SELECT t1.NAME AS form_name,t2.NAME AS name, t.* FROM ctp_affair  t LEFT JOIN form_definition t1 " +
                "                                      ON t.form_app_id=t1.id  " +
                "                                      LEFT JOIN CTP_TEMPLATE_CATEGORY t2 " +
                "                                      ON t1.CATEGORY_ID=t2.ID " +
                "                                      WHERE  t.STATE=4 and member_id= ? ORDER BY t.receive_time DESC";
        List<Map<String, Object>> queryForList = kimdeJdbcTemplate.queryForList(sql, new Object[]{user.getId()});
        return queryForList;
    }

    @Override//已发
    public List<Map<String, Object>> getAllYiFaShiXian() {
        User user = CurrentUser.get();
        String sql = "SELECT t1.NAME AS form_name,t2.NAME AS name, t.* FROM ctp_affair  t LEFT JOIN form_definition t1 " +
                "                                      ON t.form_app_id=t1.id  " +
                "                                      LEFT JOIN CTP_TEMPLATE_CATEGORY t2 " +
                "                                      ON t1.CATEGORY_ID=t2.ID " +
                "                                      WHERE  t.STATE=2 and member_id= ? ORDER BY t.receive_time DESC";
        List<Map<String, Object>> queryForList = kimdeJdbcTemplate.queryForList(sql, new Object[]{user.getId()});
        return queryForList;
    }

}
