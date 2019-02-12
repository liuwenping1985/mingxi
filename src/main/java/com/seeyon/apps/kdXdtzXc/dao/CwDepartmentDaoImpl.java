package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.base.dao.KimTeBaseDao;
import com.seeyon.apps.kdXdtzXc.base.util.SqlUtil;
import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;
import com.seeyon.apps.kdXdtzXc.po.CwDepartment;

import java.util.List;
import java.util.Map;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public class CwDepartmentDaoImpl extends KimTeBaseDao implements CwDepartmentDao {


	/**
	 * ��Ӳ�������Ϣ
	 */
    @Override
    public Long insertCwDepartment(CwDepartment department) throws Exception {
        Long id = ToolkitUtil.getNewId();
        String sqlStr = SqlUtil.getFilterSql("cwDepartment", "insertCwDepartment", CwDepartment.className);
        jdbcTemplate.update(sqlStr, new Object[]{
                id,
                department.getDepCode(),
                department.getDepDesc(),
                department.getDepCodeOa(),
                department.getDepDescOa()
        });
        return id;
    }

    /**
	 * �޸Ĳ�������Ϣ
	 */
    @Override
    public void updateCwDepartment(CwDepartment department, Long id) throws Exception {
        String sqlStr = SqlUtil.getFilterSql("cwDepartment", "updateCwDepartment", CwDepartment.className);
        jdbcTemplate.update(sqlStr, new Object[]{
        		department.getDepCode(),
                department.getDepDesc(),
                department.getDepCodeOa(),
                department.getDepDescOa(),
                id
        });
    }


    /**
     * ���ݲ�����code��ѯ�Ƿ����
     */
    @Override
    public String getCwDepartment(String deprCode) throws Exception {
        String sqlStr = SqlUtil.getFilterSql("cwDepartment", "getCwDepartment", CwDepartment.className);
        List<Map<String, Object>> list = jdbcTemplate.queryForList(sqlStr, new Object[]{ deprCode});
        if (list != null && list.size() > 0) {
            return list.get(0).get("id") + "";
        }
        return null;
    }
}
