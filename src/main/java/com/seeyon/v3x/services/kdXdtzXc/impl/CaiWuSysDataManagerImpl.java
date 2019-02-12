package com.seeyon.v3x.services.kdXdtzXc.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.kdXdtzXc.manager.CwDepartmentManager;
import com.seeyon.apps.kdXdtzXc.manager.CwOrgInfoManager;
import com.seeyon.apps.kdXdtzXc.manager.CwProjectManager;
import com.seeyon.apps.kdXdtzXc.manager.ShiJiChuCaiXinXiManage;
import com.seeyon.apps.kdXdtzXc.vo.XmlResult;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.v3x.services.kdXdtzXc.CaiWuSysDataManager;

public class CaiWuSysDataManagerImpl implements CaiWuSysDataManager {
    private static final Log log = LogFactory.getLog(CaiWuSysDataManagerImpl.class);

    public CaiWuSysDataManagerImpl() {
        try {
            System.out.println("CaiWuSysDataManagerImpl 构造器  init  start ...");

            System.out.println("CaiWuSysDataManagerImpl 构造器  init  end ...");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void init() {
        System.out.println("web service...........................");
        System.out.println("CaiWuSysDataManagerImpl");
        System.out.println("web service...........................");
    }

    /**
     * 同步机构数据
     * @param xml 参考项目同步xml
     * @return
     */
    @Override
    public String sysOrgInfos(String xml) {
        CwOrgInfoManager cwOrgInfoManager = (CwOrgInfoManager) AppContext.getBean("cwOrgInfoManager");
        log.info("机构xml=" + xml);
        System.out.println("机构xml=" + xml);
        String retunxml = "";
        List<XmlResult> list = cwOrgInfoManager.saveFrom(xml);
        retunxml = XmlResult.toXML(list);
        return retunxml;
    }

    /**
     * 同步部门
     * @param xml 参考财务部门传输
     * @return
     */
    @Override
    public String sysDepartments(String xml) {
        CwDepartmentManager cwDepartmentManager = (CwDepartmentManager) AppContext.getBean("cwDepartmentManager");
        log.info("部门xml=" + xml);
        System.out.println("部门xml=" + xml);
        String retunxml = "";
        List<XmlResult> list = cwDepartmentManager.saveFrom(xml);
        retunxml = XmlResult.toXML(list);
        return retunxml;
    }
    
    /**
     * 同步项目
     * @param xml 参考项目同步xml
     * @return
     */
    @Override
    public String sysProjects(String xml) {
        CwProjectManager cwProjectManager = (CwProjectManager) AppContext.getBean("cwProjectManager");
        log.info("项目xml=" + xml);
        System.out.println("项目xml=" + xml);
        String retunxml = "";
        List<XmlResult> list = cwProjectManager.saveFrom(xml);
        retunxml = XmlResult.toXML(list);
        return retunxml;
    }


    /**
     * 查询oa补助信息
     * @param p_period 开始时间 yyyy-MM-dd hh:mm:ss"
     * @return
     */
    @Override
    public String sysnCwTravelAllowance(String p_period) {
    	String retunxml = "";
        ShiJiChuCaiXinXiManage shiJiChuCaiXinXiManage = (ShiJiChuCaiXinXiManage) AppContext.getBean("shiJiChuCaiXinXiManage");
        retunxml =  shiJiChuCaiXinXiManage.getBuZhuXinXis(p_period);
        return retunxml;
    }
}

















