package com.seeyon.apps.kdXdtzXc.manager;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.kdXdtzXc.base.util.StringUtilsExt;
import com.seeyon.apps.kdXdtzXc.dao.CwDepartmentDao;
import com.seeyon.apps.kdXdtzXc.po.CwDepartment;
import com.seeyon.apps.kdXdtzXc.util.XMLUtil;
import com.seeyon.apps.kdXdtzXc.vo.XmlResult;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public class CwDepartmentManagerImpl implements CwDepartmentManager {
    private static Log log = LogFactory.getLog(CwDepartmentManagerImpl.class);
    private CwDepartmentDao cwDepartmentDao;

    public CwDepartmentDao getCwDepartmentDao() {
        return cwDepartmentDao;
    }

    public void setCwDepartmentDao(CwDepartmentDao cwDepartmentDao) {
        this.cwDepartmentDao = cwDepartmentDao;
    }

    /**
     * 保存财务部门信息
     * @param xml
     * @throws Exception
     */
    @Override
    public List<XmlResult> saveFrom(String xml) {
        List<XmlResult> xmlResults = new ArrayList<XmlResult>();
        List<CwDepartment> list = new ArrayList<CwDepartment>();
        try {
            list = (List<CwDepartment>) XMLUtil.getItemObjs(CwDepartment.class, xml);
        } catch (Exception e) {
            e.printStackTrace();
            xmlResults.add(new XmlResult(false, "xml转换对象失败:" + e.getMessage(), null));
        }
        Boolean bool = true;
        String message = "";
        for (CwDepartment department : list) {
            String id = null;
            try {
                id = cwDepartmentDao.getCwDepartment(department.getDepCode());
                if (StringUtilsExt.isNullOrNone(id)) {
                    id = cwDepartmentDao.insertCwDepartment(department) + "";
                    bool = true;
                    message = "保存成功！";
                } else {
                    bool = true;
                    message = "[" +department.getDepCode() + "]数据存在，跳过！";
                }
            } catch (Exception e) {
                e.printStackTrace();
                bool = false;
                message = "出错：" + e.getMessage();
            }
            xmlResults.add(new XmlResult(bool, message, id));
        }
        return xmlResults;
    }
}
