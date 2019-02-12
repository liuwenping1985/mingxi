package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.base.dao.KimTeBaseDao;
import com.seeyon.apps.kdXdtzXc.base.util.SqlUtil;
import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;
import com.seeyon.apps.kdXdtzXc.po.TravelExpense;
import com.seeyon.apps.kdXdtzXc.po.TravelExpenseJiChu;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public class TravelExpenseDaoImpl extends KimTeBaseDao implements TravelExpenseDao {
    @Override
    public List<TravelExpense> getTravelExpenseJiChu(Long id) throws Exception {
        String sqlStr = SqlUtil.getFilterSql("travelExpense", "TravelExpense", TravelExpense.className);
        List<TravelExpense> list = jdbcTemplate.query(sqlStr, new Object[]{id}, new RowMapper<TravelExpense>() {
            @Override
            public TravelExpense mapRow(ResultSet resultSet, int i) throws SQLException {
                TravelExpense jiChu = new TravelExpense();
                jiChu.setId(ToolkitUtil.parseLong(resultSet.getObject("id") + ""));
                jiChu.setSqr(resultSet.getObject("sqr")+"");
                jiChu.setSqdbh(resultSet.getObject("sqrbm")+"");
                jiChu.setSybm(resultSet.getObject("sybm")+"");
                jiChu.setXmbm(resultSet.getObject("xmbh")+"");
                jiChu.setXmmc(resultSet.getObject("xmmc")+"");
                return jiChu;
            }
        });
        return list;
    }
}
