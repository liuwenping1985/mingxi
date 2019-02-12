package com.seeyon.apps.kdXdtzXc.dao;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.base.dao.KimTeBaseDao;
import com.seeyon.apps.kdXdtzXc.base.util.SqlUtil;
import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;
import com.seeyon.apps.kdXdtzXc.po.CwProject;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public class CwProjectDaoImpl extends KimTeBaseDao implements CwProjectDao {

	/**
	 * 添加项目信息 
	 */
    @Override
    public Long insertCwProject(CwProject project) throws Exception {
        Long id = ToolkitUtil.getNewId();
        String sqlStr = SqlUtil.getFilterSql("cwProject", "insertCwProject", CwProject.className);
        jdbcTemplate.update(sqlStr, new Object[]{
        		id,
        		project.getProjectCode(),
        		project.getProjectName(),
        		project.getComCode(),
        		project.getComDesc()
        });
        return id;
    }

    /**
	 * 修改项目信息
	 */
    @Override
    public void updateCwProject(CwProject project, Long id) throws Exception {
        String sqlStr = SqlUtil.getFilterSql("cwProject", "updateCwProject", CwProject.className);
        jdbcTemplate.update(sqlStr, new Object[]{
        		project.getProjectCode(),
        		project.getProjectName(),
        		project.getComCode(),
        		project.getComDesc(),
                id
        });
    }

    /**
     * @param xmbm
     * @return
     * @throws Exception
     */
    @Override
    public String getCwProject(String projectCode) throws Exception {
        String sqlStr = SqlUtil.getFilterSql("cwProject", "getCwProject", CwProject.className);
        List<Map<String, Object>> list = jdbcTemplate.queryForList(sqlStr, new Object[]{projectCode});
        if (list != null && list.size() > 0) {
            return list.get(0).get("id") + "";
        }
        return null;
    }


}
