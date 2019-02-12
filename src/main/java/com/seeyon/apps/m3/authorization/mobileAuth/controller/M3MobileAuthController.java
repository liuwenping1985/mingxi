package com.seeyon.apps.m3.authorization.mobileAuth.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.seeyon.apps.m3.authorization.mobileAuth.service.M3MobileAuthService;
import com.seeyon.apps.m3.authorization.mobileAuth.service.M3XiaoZhiAuthManager;
import com.seeyon.apps.m3.authorization.mobileAuth.vo.M3XiaoZhiAuthVo;
import com.seeyon.apps.m3.authorization.mobileAuth.vo.OrgXiaoZhiAuthInfo;
import com.seeyon.apps.m3.authorization.util.ErrorMessageI18N;
import com.seeyon.apps.m3.product.manager.M3ProductManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.manager.ConcurrentPostManager;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgConcurrentPost;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
/**
 * 移动授权Controller
 *
 * @author xuzg mobileTeam 2011-06-24
 */
public class M3MobileAuthController extends BaseController {
   
	private static Log log = LogFactory.getLog(M3MobileAuthController.class);
    private static final String C_dateFormat_Shortdate  = "yyyy-MM-dd";
    private M3MobileAuthService m3MobileAuthService;
    private ConcurrentPostManager  conPostManager;
    private M3ProductManager m3ProductManager;
    private M3XiaoZhiAuthManager m3XiaoZhiAuthManager;
    /**
     * 构造器
     */
    public M3MobileAuthController() {
    
    }
    @Override
    public ModelAndView index(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        log.debug("--------------index--------------------");
        return null;
    }
    //客开 @CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin,Role_NAME.AccountAdministrator,Role_NAME.GroupAdmin})
    public ModelAndView toOrgAuth(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
    	 Map<String, Object> model = new HashMap<String, Object>();
    	Map<String,String> i18nMapper = new HashMap<String, String>();
    	String has = m3ProductManager.hasXiaozhi() ?"1":"0";
    	Date vdEnd = m3ProductManager.getVDEndDate() ;
    	if(vdEnd == null ||vdEnd.before(new Date())){
    		has = "0";
    	}
    	model.put("hasxiaozhi",has);
        i18nMapper.put("m3_auth_type_login_label_i18n", ResourceUtil.getString("m3.mobile.auth.label"));
        i18nMapper.put("m3_auth_type_xiaozhi_label_i18n", ResourceUtil.getString("m3.xiaozhi.auth.label"));
        model.put("i18nMapper", i18nMapper);
        
        return new ModelAndView("cip/m3/auth/orgAuth", model);
    }
   /**
    * 初始化单位授权页面
    * @param request 请求
    * @param response 相应
    * @return  返回结果
    * @throws Exception  异常
    */
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin,Role_NAME.AccountAdministrator,Role_NAME.GroupAdmin})
    public ModelAndView toOrgLoginAuth(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        
        long orgId = AppContext.getCurrentUser().getAccountId();
        boolean hasM3 =  m3ProductManager.hasM3();
        log.info("has m3 !!!" + hasM3);
        Integer m1Type = m3ProductManager.getType();
        List<String> result = null;
        Map<String, Object> model = new HashMap<String, Object>();
        //是否是集团版
        boolean groupFlag ="true".equals(SystemProperties.getInstance().getProperty("org.isGroupVer"));
        
        Long groupCount = m3ProductManager.getAvailableCount("");
        //判断M1是否购买 ，  
        boolean available = groupCount > 0 ? true : false;
        int m1PermissionType = m3ProductManager.getPermissionType();
        Long orgCount = 0L;
        if (!groupFlag && groupCount > 0) {
			orgCount = groupCount;
		} else if(m1PermissionType == 1) {
            orgCount = m3ProductManager.getAvailableCount("");
        } else {
            orgCount = m3ProductManager.getAvailableCount(AppContext.currentAccountId() + "");
        }
        model.put("orgCount", orgCount);
        model.put("m1PermissionType", available ? m1PermissionType : 3); //主要是界面显示需要进行显示值的选取的判定  3 表示M1没有购买
        
        switch (m1Type) {
            case 1 : //并发
                model.put("authedType", m1Type);
                if (!groupFlag) {
                	model.put("m1PermissionType", available ? 2 : 3);
                }
                break;
            case 2 ://注册数：
                List<Map<String, String>> orgAuthList = m3MobileAuthService.getAuthedUserList(orgId);
                result = this.getStrBuff(m1PermissionType, orgAuthList);
                model.put("authedStr", result.get(0));
                model.put("authedIds", result.get(1));
                model.put("authedIdNames", result.get(2));
                model.put("authedCount", new Integer(result.get(3)));
                if (1 == m1PermissionType && groupFlag) {
                    //获取加密狗中的M1总许可数   
                    int authed = m3MobileAuthService.getAllAuthedCount();
                    model.put("allauthed", authed);
                    model.put("authedType", 23);
                }  else {
                    model.put("authedType", 22);
                    
                }
                break;
            default:
                break;
        }
        String	version = m3ProductManager.getM3Version(); 
        String date = m3ProductManager.getDueDate();
        if (Strings.isBlank(date)) {
        	date = ResourceUtil.getString("m3.auth.orgauth.noscope");
        }
        List<Long> userIdList = getConcurrentMembers();
        String authedconcurrentMembers = m3MobileAuthService.authedConurrentMembers(userIdList);
       
     
        model.put("groupCount", groupCount);
        model.put("success", request.getParameter("success"));
        model.put("overdueDate",date);
        model.put("m1Version", version);
        model.put("available", available);
        model.put("serverusable", true); //判断M1服务是否可以用（是否正确安装 ）。假数据
        model.put("concurrentMembers", authedconcurrentMembers);
        return new ModelAndView("cip/m3/auth/orgLoginAuth", model);
    }
    /**
     * 获得兼职人员，包括兼职到本单位以及兼职到外单位的人员ID
     * @return
     * @throws BusinessException
     */
    private List<Long> getConcurrentMembers() throws BusinessException {
        List<Long>  result = new ArrayList<Long>();
        List<WebV3xOrgConcurrentPost> concurrentMemList = new ArrayList<WebV3xOrgConcurrentPost>();
        FlipInfo in = new FlipInfo();
        Map<String, String> map = new HashMap<String, String>();
        FlipInfo out = new FlipInfo();
        in = conPostManager.list4in(in, map);
        out = conPostManager.list4out(out, map);
        concurrentMemList.addAll(in.getData());
        concurrentMemList.addAll(out.getData());
        for (WebV3xOrgConcurrentPost  temp : concurrentMemList) {
            result.add(temp.getConcurrentRel().getSourceId());
        }
        return result;
    }
    private List<String> getStrBuff(int authType, List<Map<String, String>> orgAuthList) {
        List<String> result = new ArrayList<String>();
        StringBuffer authedStrBuff = new StringBuffer();
        StringBuffer authedIdsBuff = new StringBuffer();
        StringBuffer authedIdNamesBuff = new StringBuffer();
        int authedCount = 0;
        if (orgAuthList != null && orgAuthList.size() > 0) {
            authedCount = orgAuthList.size();
            for (int i = 0; i < orgAuthList.size(); i++) {
                Map<String, String> map = orgAuthList.get(i);
                String id = map.get("id");
                String name = map.get("name");

                if (i > 0) {
                    authedStrBuff.append(",");
                    authedIdsBuff.append(",");
                    authedIdNamesBuff.append(",");
                }
                authedStrBuff.append("Member|").append(id);
                authedIdsBuff.append(id);
                authedIdNamesBuff.append(id).append("|");
                authedIdNamesBuff.append(name);
            }
        }
        result.add(authedStrBuff.toString());
        result.add(authedIdsBuff.toString());
        result.add(authedIdNamesBuff.toString());
        result.add(authedCount + "");
        return result;
    }
    /**
     * 单位授权给用户
     * @param request 请求
     * @param response 相应
     * @return  ModelAndView
     * @throws Exception  异常信息
     */
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin,Role_NAME.AccountAdministrator})
    public ModelAndView orgAuth(HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        log.debug("--------------orgAuth--------------------");

        long orgId = AppContext.getCurrentUser().getAccountId();
        String m1Version = request.getParameter("m1Version");
        String orgCountStr = request.getParameter("orgCount");
        String authedCountStr = request.getParameter("authedCount");
        String authStr = request.getParameter("authStr");
        String authedIds = request.getParameter("authedIds");
        String authedIdNames = request.getParameter("authedIdNames");
        String authedType = request.getParameter("authedType");
        String groupCount = request.getParameter("groupCount");
        String overdueDate = request.getParameter("overdueDate");
        String availableS = request.getParameter("available");
        boolean available = false;
        if (!StringUtils.isBlank(availableS)) {
        	available = Boolean.valueOf(availableS);
        }
//        int m1PermissionType = m3ProductManager.getPermissionType();
        long count = Long.valueOf(orgCountStr);
//        if(m1PermissionType == 1) {
//        	count = m3ProductManager.getAvailableCount("");
//        } else {
//        	count = m3ProductManager.getAvailableCount(AppContext.currentAccountId() + "");
//        }
        ErrorMessageI18N errMsg = m3MobileAuthService.saveAuthedUserList(authedType, orgId,count, authStr);
        
        if (errMsg != null) {
            Map<String, Object> model = new HashMap<String, Object>();
            int authed = m3MobileAuthService.getAllAuthedCount();
            model.put("allauthed", authed);
            model.put("m1Version", m1Version);
            model.put("orgCount", new Integer(orgCountStr));
            model.put("authedCount", new Integer(authedCountStr));
            model.put("authedStr", authStr);
            model.put("authedIds", authedIds);
            model.put("authedIdNames", authedIdNames);
            model.put("groupCount", groupCount);
            model.put("errMsg", errMsg);
            model.put("authedType", new Integer(authedType));
            model.put("overdueDate", overdueDate);
            model.put("available", available);
            model.put("serverusable", true);
            return new ModelAndView("cip/m3/auth/orgLoginAuth", model);
        }
        String url = request.getRequestURL().toString();
        String root = request.getContextPath();
        String path = url.split(root)[0];

        return new ModelAndView(new RedirectView(path + root 
                + "/m3/mobileAuthController.do?method=toOrgLoginAuth&success=yes"));
    }
    /**
    * 初始化单位授权页面
    * @param request 请求
    * @param response 相应
    * @return  返回结果
    * @throws Exception  异常
    */
  //客开 @CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin,Role_NAME.AccountAdministrator,Role_NAME.GroupAdmin})
    public ModelAndView toOrgXiaoZhiAuth(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
    	HashMap<String,Object> model = new HashMap<String, Object>();
    	OrgXiaoZhiAuthInfo info =m3XiaoZhiAuthManager.getOrgAuthInfo();
    	SystemProperties systemP = SystemProperties.getInstance();

    	model.put("orgAuthInfo", info);
    //	model.put("loginAuthType", type);
    	model.put("maxandroid", systemP.getProperty("VoiceDistinguish.config.android.max"));
    	model.put("maxiphone", systemP.getProperty("VoiceDistinguish.config.iPhone.max"));
    	Map<String,String> i18nMapper = getI18nInfo();
    	model.put("i18nMapper",i18nMapper);
    	ModelAndView result = new ModelAndView("cip/m3/auth/orgXiaoZhiAuth",model);
    	return result;
    }
    /**
    @CheckRoleAccess(roleTypes={Role_NAME.SystemAdmin,Role_NAME.AccountAdministrator,Role_NAME.GroupAdmin})
    public ModelAndView showSelectPeopleFrame(HttpServletRequest request,
            HttpServletResponse response) throws Exception{
        List<Map<String, String>> orgAuthList = m3MobileAuthService.getAuthedUserList(AppContext.currentAccountId());
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("memberList", orgAuthList);
		ModelAndView result = new ModelAndView("cip/m3/auth/xiaozhiAuthSelectPeople", model );

        return result;
    }
    **/
    private static Map<String,String> getI18nInfo(){
    	Map<String,String> i18nMapper = new HashMap<String, String>();
    	return i18nMapper;
    }
	public M3MobileAuthService getM3MobileAuthService() {
		return m3MobileAuthService;
	}
	public void setM3MobileAuthService(M3MobileAuthService m3MobileAuthService) {
		this.m3MobileAuthService = m3MobileAuthService;
	}
	public ConcurrentPostManager getConPostManager() {
		return conPostManager;
	}
	public void setConPostManager(ConcurrentPostManager conPostManager) {
		this.conPostManager = conPostManager;
	}
	public M3ProductManager getM3ProductManager() {
		return m3ProductManager;
	}
	public void setM3ProductManager(M3ProductManager m3ProductManager) {
		this.m3ProductManager = m3ProductManager;
	}
	public M3XiaoZhiAuthManager getM3XiaoZhiAuthManager() {
		return m3XiaoZhiAuthManager;
	}
	public void setM3XiaoZhiAuthManager(M3XiaoZhiAuthManager m3XiaoZhiAuthManager) {
		this.m3XiaoZhiAuthManager = m3XiaoZhiAuthManager;
	}
    
}
