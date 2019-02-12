package com.seeyon.apps.m3.bind.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.m3.bind.manager.M3BindApplyManager;
import com.seeyon.apps.m3.bind.service.M3ClientBindService;
import com.seeyon.apps.m3.bind.service.M3MobileManageService;
import com.seeyon.apps.m3.bind.vo.M3BindApplyResult;
import com.seeyon.apps.m3.login.utils.MDesUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.util.IOUtility;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.ctp.util.json.JSONUtil;

/**
 * 设备绑定Controller
 * 
 * @author xuzg mobileTeam 2011-08-04
 */
public class M3ClientBindController extends BaseController {
    private static Log           log = LogFactory.getLog(M3ClientBindController.class);
    private M3ClientBindService   m3ClientBindService;
    private M3MobileManageService m3MobileManageService;
    private M3BindApplyManager m3BindApplyManager;
   
    
    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.debug("--------------index--------------------");
        return null;
    }
    
    public M3ClientBindController() {
    }
    
    // 单位管理员，设备绑定首页
    //客开 @CheckRoleAccess(roleTypes = { Role_NAME.SystemAdmin, Role_NAME.AccountAdministrator, Role_NAME.GroupAdmin })
    public ModelAndView toOrgBind(HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.debug("--------------toOrgBind--------------------");
        return new ModelAndView("cip/m3/bind/orgBind");
    }
    
    // 单位管理员，设备绑定--设备绑定管理页面
  //客开 @CheckRoleAccess(roleTypes = { Role_NAME.SystemAdmin, Role_NAME.AccountAdministrator, Role_NAME.GroupAdmin })
    public ModelAndView toBindManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.debug("--------------toBindManage--------------------");
        // return toBindApply(request, response);
        return new ModelAndView("cip/m3/bind/orgBindManage");
    }
    
  //客开 @CheckRoleAccess(roleTypes = { Role_NAME.SystemAdmin, Role_NAME.AccountAdministrator, Role_NAME.GroupAdmin })
    public ModelAndView toBindApply(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("cip/m3/bind/bindApply");
    }
    
  //客开 @CheckRoleAccess(roleTypes = { Role_NAME.SystemAdmin, Role_NAME.AccountAdministrator })
    // 单位管理员，设备绑定--安全级别设置页面
    public ModelAndView toSetSafeLevel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.debug("--------------toSetSafeLevel--------------------");
        
        long orgId = AppContext.getCurrentUser().getAccountId();
        log.debug("orgId: " + orgId);
        
        Map<String, String> model = m3ClientBindService.getSafeLevel(orgId);
        return new ModelAndView("cip/m3/bind/orgBindSafeLevel", model);
    }
    
  //客开 @CheckRoleAccess(roleTypes = { Role_NAME.SystemAdmin, Role_NAME.AccountAdministrator })
    // 单位管理员，设置安全级别
    public ModelAndView setSafeLevel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.debug("--------------setSafeLevel--------------------");
        long orgId = AppContext.getCurrentUser().getAccountId();
        log.debug("orgId: " + orgId);
        String entityId = request.getParameter("entityId");
        Set<Long> ids = new HashSet<Long>();
        if (Strings.isNotBlank(entityId)) {
            for (String trmp : entityId.split(",")) {
                String[] tempArray = trmp.split("\\|");
                try {
                    ids.add(Long.parseLong(tempArray[1]));
                } catch (Exception e) {
                    continue;
                }
            }
        }
        
        m3ClientBindService.saveMSafeLevels(new ArrayList<Long>(ids));
        Map<String, String> model = m3ClientBindService.getSafeLevel(orgId);
        model.put("success", "true");
        model.put("mes", ResourceUtil.getString("m3.bind.modify.success"));
        return new ModelAndView("cip/m3/bind/orgBindSafeLevel", model);
    }
    
    // 单位管理员，设备绑定--绑定设备数设置页面
  //客开 @CheckRoleAccess(roleTypes = { Role_NAME.SystemAdmin, Role_NAME.AccountAdministrator })
    public ModelAndView toSetBindNum(HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.debug("--------------toSetBindNum--------------------");
        
        long orgId = AppContext.getCurrentUser().getAccountId();
        log.debug("orgId: " + orgId);
        
        int bindNum = m3ClientBindService.getBindNum(orgId);
        log.debug("bindNum: " + bindNum);
        
        return new ModelAndView("cip/m3/bind/orgBindNum", "bindNum", Integer.toString(bindNum));
    }
    
    // 单位管理员，设置绑定设备数
  //客开 @CheckRoleAccess(roleTypes = { Role_NAME.SystemAdmin, Role_NAME.AccountAdministrator })
    public ModelAndView setBindNum(HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.debug("--------------setBindNum--------------------");
        
        long orgId = AppContext.getCurrentUser().getAccountId();
        log.debug("orgId: " + orgId);
        
        String bindNumStr = request.getParameter("bindNum");
        log.debug("bindNumStr: " + bindNumStr);
        
        String errMsg = null;
        try {
            m3ClientBindService.setBindNum(orgId, Integer.parseInt(bindNumStr));
            
        } catch (Exception e) {
            errMsg = e.getMessage();
            log.error(e.getLocalizedMessage(), e);
        }
        int numx = m3ClientBindService.getBindNum(orgId);
        Map<String, Object> model = new HashMap<String, Object>();
        model.put("bindNum", numx);
        model.put("success", Boolean.toString(errMsg == null));
        model.put("errMsg", errMsg);
        
        return new ModelAndView("cip/m3/bind/orgBindNum", model);
    }
    
    /**
     * 设备绑定申请
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView bindApply(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String loginName=MDesUtil.decode(request.getParameter("loginName"));
    	String clientName=request.getParameter("clientName");
    	String clientNum=request.getParameter("clientNum");
    	String clientType=request.getParameter("clientType");
    	if("androidphone".equals(clientType)){
    		clientType="android";
    	}else{
    		clientType="iPhone";
    	}
    	M3BindApplyResult result=m3BindApplyManager.bindApplyByUser(loginName, clientName, clientNum, clientType);
    	try {
			ServletOutputStream sos = response.getOutputStream();
			IOUtility.copy(JSONUtil.toJSONString(result).getBytes("UTF-8"), sos);
		} catch (IOException e) {
			throw new BusinessException(e);
		}
        return null;
    }
    
	public M3ClientBindService getM3ClientBindService() {
		return m3ClientBindService;
	}

	public void setM3ClientBindService(M3ClientBindService m3ClientBindService) {
		this.m3ClientBindService = m3ClientBindService;
	}

	public M3MobileManageService getM3MobileManageService() {
		return m3MobileManageService;
	}

	public void setM3MobileManageService(M3MobileManageService m3MobileManageService) {
		this.m3MobileManageService = m3MobileManageService;
	}

	public M3BindApplyManager getM3BindApplyManager() {
		return m3BindApplyManager;
	}

	public void setM3BindApplyManager(M3BindApplyManager m3BindApplyManager) {
		this.m3BindApplyManager = m3BindApplyManager;
	}
    
   
    
}
