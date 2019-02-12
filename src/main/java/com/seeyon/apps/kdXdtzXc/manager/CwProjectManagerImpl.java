package com.seeyon.apps.kdXdtzXc.manager;

import com.seeyon.apps.kdXdtzXc.base.util.StringUtilsExt;
import com.seeyon.apps.kdXdtzXc.dao.CwProjectDao;
import com.seeyon.apps.kdXdtzXc.po.CwProject;
import com.seeyon.apps.kdXdtzXc.util.XMLUtil;
import com.seeyon.apps.kdXdtzXc.vo.XmlResult;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public class CwProjectManagerImpl implements CwProjectManager {
    private CwProjectDao cwProjectDao;

    public CwProjectDao getCwProjectDao() {
        return cwProjectDao;
    }

    public void setCwProjectDao(CwProjectDao cwProjectDao) {
        this.cwProjectDao = cwProjectDao;
    }

    /**
     * 添加项目信息
     */
    @Override
    public List<XmlResult> saveFrom(String xml) {
        List<XmlResult> xmlResults = new ArrayList<XmlResult>();
        List<CwProject> list = new ArrayList<CwProject>();

        try {
            list = (List<CwProject>) XMLUtil.getItemObjs(CwProject.class, xml);
        } catch (Exception e) {
            e.printStackTrace();
            xmlResults.add(new XmlResult(false, "xml转换对象失败:" + e.getMessage(), null));
        }
        Boolean bool = true;
        String message = "";
        for (CwProject project : list) {
            String id = null;
            try {
                id = cwProjectDao.getCwProject(project.getProjectCode());
                if (StringUtilsExt.isNullOrNone(id)) {
                    id = cwProjectDao.insertCwProject(project) + "";
                    bool = true;
                    message = "保存成功！";
                } else {
                    bool = true;
                    message = "[" + project.getProjectCode() + "]数据存在，跳过！";
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
