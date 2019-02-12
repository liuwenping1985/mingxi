package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.base.dao.KimTeBaseDao;
import com.seeyon.apps.kdXdtzXc.base.util.SqlUtil;
import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;
import com.seeyon.apps.kdXdtzXc.po.CwOrgInfo;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public class CwOrgInfoDaoImpl extends KimTeBaseDao implements CwOrgInfoDao {


	/**
	 * 添加机构信息
	 */
    @Override
    public Long insertCwOrgInfo(CwOrgInfo com) throws Exception {
        Long id = ToolkitUtil.getNewId();
        String sqlStr = SqlUtil.getFilterSql("cwOrgInfo", "insertCwOrgInfo", CwOrgInfo.className);
        jdbcTemplate.update(sqlStr, new Object[]{
                id,
                com.getComCode(),
                com.getComDesc(),
                com.getComCodeOa(),
                com.getComDescOa()
         });
        return id;
    }

    /**
	 * 修改机构信息
	 */
    @Override
    public void updateCwOrgInfo(CwOrgInfo com, Long id) throws Exception {
        String sqlStr = SqlUtil.getFilterSql("cwOrgInfo", "updateCwOrgInfo", CwOrgInfo.className);
        System.out.println(com);
        jdbcTemplate.update(sqlStr, new Object[]{
        		com.getComCode(),
        		com.getComDesc(),
        		com.getComCodeOa(),
        		com.getComDescOa(),
                id
        });
    }

    /**
     * @param jgbm
     * @return
     * @throws Exception
     */
    @Override
    public String getCwOrgInfo(String orgCode) throws Exception {
        String sqlStr = SqlUtil.getFilterSql("cwOrgInfo", "getCwOrgInfo", CwOrgInfo.className);
        List<Map<String, Object>> list = jdbcTemplate.queryForList(sqlStr, new Object[]{orgCode});
        if (list != null && list.size() > 0) {
            return list.get(0).get("id") + "";
        }
        return null;
    }

}
