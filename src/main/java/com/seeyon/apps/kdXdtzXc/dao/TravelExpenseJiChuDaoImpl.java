package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.base.dao.KimTeBaseDao;
import com.seeyon.apps.kdXdtzXc.base.util.SqlUtil;
import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;
import com.seeyon.apps.kdXdtzXc.po.CwDepartment;
import com.seeyon.apps.kdXdtzXc.po.TravelExpenseJiChu;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public class TravelExpenseJiChuDaoImpl extends KimTeBaseDao implements TravelExpenseJiChuDao {

    /**
     * @return
     * @throws Exception
     */
    @Override
    public List<TravelExpenseJiChu> getTravelExpenseJiChu(String formmain_id) throws Exception {
        String sqlStr = SqlUtil.getFilterSql("travelExpenseJiChu", "getTravelExpenseJiChu", TravelExpenseJiChu.className);
        List<TravelExpenseJiChu> list = jdbcTemplate.query(sqlStr, new Object[]{formmain_id}, new RowMapper<TravelExpenseJiChu>() {
            @Override
            public TravelExpenseJiChu mapRow(ResultSet resultSet, int i) throws SQLException {
                TravelExpenseJiChu jiChu = new TravelExpenseJiChu();
                jiChu.setId(ToolkitUtil.parseLong(resultSet.getObject("id") + ""));
                jiChu.setFormmain_id(ToolkitUtil.parseLong(resultSet.getObject("formmain_id") + ""));
                jiChu.setSort(ToolkitUtil.parseInt(resultSet.getObject("sort") + ""));
                jiChu.setXuHao(ToolkitUtil.parseInt(resultSet.getObject("xuHao") + ""));
                jiChu.setBuMeng(resultSet.getString("buMeng"));
                jiChu.setChuCaiRen(resultSet.getString("chuCaiRen"));
                jiChu.setYinWenName(resultSet.getString("yinWenName"));
                jiChu.setChuFaTime(ToolkitUtil.toDate(resultSet.getObject("chuFaTime")));
                jiChu.setFanHuiTime(ToolkitUtil.toDate(resultSet.getObject("fanHuiTime")));
                return jiChu;
            }
        });
        return list;
    }
}
