package com.seeyon.ctp.organization.controller;

import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.web.util.WebUtil;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.manager.OrgIndexManager;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;

public class OrgIndexController extends BaseController{

    private static final Log  logger = LogFactory.getLog(OrgIndexController.class);

    protected OrgIndexManager orgIndexManager;
    protected OrgManager orgManager;

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setOrgIndexManager(OrgIndexManager orgIndexManager) {
        this.orgIndexManager = orgIndexManager;
    }

    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception  {
        User user = AppContext.getCurrentUser();
        response.setContentType("text/plain;charset=UTF-8");
        String ETag = "W_" + user.getEtagRandom();
        if(WebUtil.checkEtag(request, response, ETag)){
            return null; 
        }
        WebUtil.writeETag(request, response, ETag);
        PrintWriter out = response.getWriter();
        out.print("var orgIndexData = " + orgIndexManager.getOrgIndexDatas());
        //out.print("var orgIndexData = {};");
        return null;
    }
    
    public ModelAndView getFastSelectAccount(HttpServletRequest request, HttpServletResponse response) throws Exception  {
        User user = AppContext.getCurrentUser();
        response.setContentType("text/plain;charset=UTF-8");
        String ETag = "W_" + user.getEtagRandom();
        if(WebUtil.checkEtag(request, response, ETag)){
            return null; 
        }
        String param = request.getParameter("q");
        WebUtil.writeETag(request, response, ETag);
        PrintWriter out = response.getWriter();
        String data =  orgIndexManager.getAllAccounts(param);
        out.print(data);
        return null;
    }
    public ModelAndView getFastSelectDepartment(HttpServletRequest request, HttpServletResponse response) throws Exception  {
    	User user = AppContext.getCurrentUser();
    	response.setContentType("text/plain;charset=UTF-8");
    	String ETag = "W_" + user.getEtagRandom();
    	if(WebUtil.checkEtag(request, response, ETag)){
    		return null; 
    	}
    	String param = request.getParameter("q");
    	WebUtil.writeETag(request, response, ETag);
    	PrintWriter out = response.getWriter();
    	String data =  orgIndexManager.getAllDepartments(user.getAccountId(),param);
    	out.print(data);
    	return null;
    }
    public ModelAndView getFastSelectTeam(HttpServletRequest request, HttpServletResponse response) throws Exception  {
    	User user = AppContext.getCurrentUser();
    	response.setContentType("text/plain;charset=UTF-8");
    	String ETag = "W_" + user.getEtagRandom();
    	if(WebUtil.checkEtag(request, response, ETag)){
    		return null; 
    	}
    	String param = request.getParameter("q");
    	WebUtil.writeETag(request, response, ETag);
    	PrintWriter out = response.getWriter();
    	String data =  orgIndexManager.getAllTeams(user.getAccountId(),param);
    	out.print(data);
    	return null;
    }
    public ModelAndView getFastSelectPost(HttpServletRequest request, HttpServletResponse response) throws Exception  {
    	User user = AppContext.getCurrentUser();
    	response.setContentType("text/plain;charset=UTF-8");
    	String ETag = "W_" + user.getEtagRandom();
    	if(WebUtil.checkEtag(request, response, ETag)){
    		return null; 
    	}
    	String param = request.getParameter("q");
    	WebUtil.writeETag(request, response, ETag);
    	PrintWriter out = response.getWriter();
    	String data =  orgIndexManager.getAllPosts(user.getAccountId(),param);
    	out.print(data);
    	return null;
    }
    public ModelAndView getFastSelectLevel(HttpServletRequest request, HttpServletResponse response) throws Exception  {
    	User user = AppContext.getCurrentUser();
    	response.setContentType("text/plain;charset=UTF-8");
    	String ETag = "W_" + user.getEtagRandom();
    	if(WebUtil.checkEtag(request, response, ETag)){
    		return null; 
    	}
    	WebUtil.writeETag(request, response, ETag);
    	PrintWriter out = response.getWriter();
    	String param = request.getParameter("q");
    	String data =  orgIndexManager.getAllLevels(user.getAccountId(),param);
    	out.print(data);
    	return null;
    }
    public ModelAndView getFastSelectMember(HttpServletRequest request, HttpServletResponse response) throws Exception  {
    	User user = AppContext.getCurrentUser();
    	 String data = "";
    	response.setContentType("text/plain;charset=UTF-8");
    	String ETag = "W_" + user.getEtagRandom();
    	if(WebUtil.checkEtag(request, response, ETag)){
    		return null; 
    	}
    	WebUtil.writeETag(request, response, ETag);
    	PrintWriter out = response.getWriter();
        String param = request.getParameter("q");
        if("".equals(param)|| null == param){
        	data = orgIndexManager.getFastRecentDataMember(user.getId(), null);
        }else{
        	 data = orgIndexManager.getFastSearchDataStr(param);
        }
    	out.print(data);
    	return null;
    }
    
    /**
     * 最近联系Ajax，返回JSON串
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView getRecentData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(orgIndexManager.getRecentDataStr(user.getId(), null));//TODO 参数
        return null;
    }
    
    /**
     * 用于Ajax调用保存用于检索的最近联系人等数据
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
//    @CheckRoleAccess(roleTypes = { Role_NAME.EdocManagement,Role_NAME.AccountAdministrator,Role_NAME.SendEdoc,Role_NAME.RecEdoc,Role_NAME.SignEdoc,Role_NAME.PerformanceAdmin,Role_NAME.DepAdmin,Role_NAME.GroupAdmin,Role_NAME.TtempletManager})
    public ModelAndView saveRecentData4OrgIndex(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String rData = request.getParameter("rData");
        rData = URLDecoder.decode(rData, "UTF-8");  
        orgIndexManager.saveCustomOrgRecent(AppContext.currentUserId(), rData);//选人界面最近50人
        return null;
    }
    
    /**
     * 检查通过复制粘贴的内容，并返回检验后的数据
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView checkFromCopy(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String beforeCheckStr = request.getParameter("cData");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(orgIndexManager.checkFromCopy(beforeCheckStr));
        return null;
    }
    
    /**
     * 获取全部集团职级
     */   
    public ModelAndView getGroupLevels(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	if ((Boolean) SysFlag.selectPeople_showAccounts.getFlag()) {
    		V3xOrgAccount rootAccount = this.orgManager.getRootAccount();
    		List<V3xOrgLevel> groupLevels = this.orgManager.getAllLevels(rootAccount.getId());
    		int i=0;
    		String groupLevelsStr = "";
    		for(V3xOrgLevel level : groupLevels){
    			if(i==0){
    				groupLevelsStr = String.valueOf(level.getId());
    			}else{
    				groupLevelsStr = groupLevelsStr +","+String.valueOf(level.getId());
    			}
    			i++;
    		}
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(groupLevelsStr);
    	}
    	return null;
    }
    public ModelAndView searchMember(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String key = request.getParameter("key");
    	String searchData = "";
    	if(Strings.isNotBlank(key)){
    		searchData = orgIndexManager.getSearchDataStr(key);
    	}
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(searchData);
    	return null;
    }
    
}
