/**
 * $Author$
 * $Rev$
 * $Date::                     $:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.organization.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.event.MoveDepartmentEvent;
import com.seeyon.ctp.organization.manager.MoveDeptManager;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgResult;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;

/**
 * <p>Title: T2组织模型职务级别维护控制器</p>
 * <p>Description: 主要针对单位组织进行维护功能</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @version CTP2.0
 */
//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin})
public class MoveDeptController extends BaseController {

    protected OrgManager       orgManager;
    protected OrgManagerDirect orgManagerDirect;
    protected AppLogManager    appLogManager;
    protected MoveDeptManager  moveDeptManager;

    public void setMoveDeptManager(MoveDeptManager moveDeptManager) {
        this.moveDeptManager = moveDeptManager;
    }
    public OrgManager getOrgManager() {
        return orgManager;
    }
    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }
    public OrgManagerDirect getOrgManagerDirect() {
        return orgManagerDirect;
    }
    public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
        this.orgManagerDirect = orgManagerDirect;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }


    public ModelAndView showMoveDeptframe(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("apps/organization/movedept/movedept");
    }

    public ModelAndView moveDepts(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView result = new ModelAndView("apps/organization/movedept/resultLogs");
        Map params = ParamUtil.getJsonParams();

        Long accountId = Long.valueOf(params.get("accountId").toString().split("\\|")[1]);
        // 获得调整部门
        List<V3xOrgEntity> deptents = orgManager.getEntities(params.get("deptIds").toString());

        // 记录原单位
        List<Long> accountIds = new ArrayList<Long>();
        // 记录调整部门信息
        List<V3xOrgDepartment> moveDepts = new ArrayList<V3xOrgDepartment>();
        // 校验并移动部门
        List<WebV3xOrgResult> resultList = new ArrayList<WebV3xOrgResult>();

        User user = AppContext.getCurrentUser();

        for (V3xOrgEntity strid : deptents) {
            WebV3xOrgResult resultModel = new WebV3xOrgResult();
            List<String[]> validateListStr = new ArrayList<String[]>();
            List<String[]> moveLogList = new ArrayList<String[]>();
            Long id = strid.getId();
            String str1 = "";
            if (id != null) {
                V3xOrgDepartment dept = orgManager.getDepartmentById(id);
                str1 = dept.getName();
                //部门调整前的校验
                List<String> validateList = moveDeptManager.validateMoveDept(id, accountId);
                //判断是否有调入的两个重名部门
                for (V3xOrgDepartment addDept : moveDepts) {
                    if (dept.getName().equals(addDept.getName())) {
                        validateList.add("1");
                    }
                }
                logger.info("validateList.size(): "+ validateList.size());
                if (validateList.size() > 0) {
                    for (String str : validateList) {
                        String[] strArray = str.split("[|]");
                        validateListStr.add(strArray);
                    }
                    logger.info("validateListStr: "+validateListStr);
                } else if (validateList.size() == 0) {
                    if (!accountIds.contains(dept.getOrgAccountId())) {
                        accountIds.add(dept.getOrgAccountId());
                    }
                    moveLogList = moveDeptManager.moveDept(id, accountId);
                    //重新设置部门空间的所属单位
                    V3xOrgAccount account = orgManager.getAccountById(accountId);
                    //记录调整部门
                    moveDepts.add(dept);
                    //记录日志
                    appLogManager.insertLog(user, AppLogAction.Organization_MoveDept, dept.getName(),
                            account.getName(), orgManager.getGroupAdmin().getName());

                    //触发部门调整事件
                    V3xOrgDepartment d = orgManager.getDepartmentById(dept.getId());
                    d.setOrgAccountId(accountId);
                    MoveDepartmentEvent moveDeptEvent = new MoveDepartmentEvent(this);
                    moveDeptEvent.setDepartment(d);
                    moveDeptEvent.setOldDepartment(dept);
                    EventDispatcher.fireEvent(moveDeptEvent);
                }
                V3xOrgAccount account = orgManager.getAccountById(dept.getOrgAccountId());
                if (account != null)
                    str1 += "(" + account.getShortName() + ")";
            }
            resultModel.setStr1(str1);
            resultModel.setStr2(OrgHelper.showOrgAccountName(accountId));
            resultModel.setValidateList(validateListStr);
            resultModel.setMoveLogList(moveLogList);
            resultList.add(resultModel);
        }

        result.addObject("resultList", resultList);

        return result;
    }
}
