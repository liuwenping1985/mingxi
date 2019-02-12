package com.seeyon.apps.kdXdtzXc.manager;

import com.seeyon.apps.kdXdtzXc.base.util.StringUtilsExt;
import com.seeyon.apps.kdXdtzXc.dao.CwOrgInfoDao;
import com.seeyon.apps.kdXdtzXc.po.CwOrgInfo;
import com.seeyon.apps.kdXdtzXc.util.XMLUtil;
import com.seeyon.apps.kdXdtzXc.vo.XmlResult;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public class CwOrgInfoManagerImpl implements CwOrgInfoManager {
    private CwOrgInfoDao cwOrgInfoDao;

    public CwOrgInfoDao getCwOrgInfoDao() {
        return cwOrgInfoDao;
    }

    public void setCwOrgInfoDao(CwOrgInfoDao cwOrgInfoDao) {
        this.cwOrgInfoDao = cwOrgInfoDao;
    }

    /**
     * 功能：保存财务机构信息
     */
    public List<XmlResult> saveFrom(String xml) {
        List<XmlResult> xmlResults = new ArrayList<XmlResult>();
        List<CwOrgInfo> list = new ArrayList<CwOrgInfo>();
        try {
            list = (List<CwOrgInfo>) XMLUtil.getItemObjs(CwOrgInfo.class, xml);
        } catch (Exception e) {
            e.printStackTrace();
            xmlResults.add(new XmlResult(false, "xml转换对象失败:" + e.getMessage(), null));
        }
        Boolean bool = true;
        String message = "";
        for (CwOrgInfo com : list) {
            String id = null;
            try {
                id = cwOrgInfoDao.getCwOrgInfo(com.getComCode());
                if (StringUtilsExt.isNullOrNone(id)) {
                    id = cwOrgInfoDao.insertCwOrgInfo(com) + "";
                    bool = true;
                    message = "保存成功！";
                } else {
                    bool = true;
                    message = "[" +com.getComCode() + "]数据存在，跳过！";
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
