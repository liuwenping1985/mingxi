package com.seeyon.apps.taskcenter.Manager;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import cn.com.cinda.taskcenter.util.StringUtils;
import cn.com.cinda.taskclient.service.impl.OrgServiceImpl;
import cn.com.cinda.taskclient.service.impl.UserServiceImpl;
import cn.com.hkgt.bean.OptionVO;
import cn.com.hkgt.um.interfaces.exports.ExportService;

import com.caucho.hessian.client.HessianProxyFactory;
import com.seeyon.apps.taskcenter.bo.TaskCenterResource;
import com.seeyon.apps.taskcenter.constant.TaskCenterConstant;
import com.seeyon.apps.taskcenter.dao.TaskCenterOADao;
import com.seeyon.apps.taskcenter.po.ProRoleResource;
import com.seeyon.apps.taskcenter.po.ProSenderUrl;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.v3x.common.web.login.CurrentUser;

public class TaskCenterOAManagerImpl implements TaskCenterOAManager{

	private static final Log log = LogFactory.getLog(TaskCenterOAManagerImpl.class);
	private TaskCenterOADao taskCenterOADao;
	
	// SZP
	private static String[] sysmanager_dangan_prefix = AppContext.getSystemProperty("taskcenter.fengongsi_sysmanager_dangan").split(",");
	private static HashMap<String, String> sysmanager_dangan_prefix_map = new HashMap<String, String>();
	{
		for (String sysmanagerPrefix : sysmanager_dangan_prefix) {
			String[] str = sysmanagerPrefix.split("\\|");
			sysmanager_dangan_prefix_map.put(str[0], str[1]);//单位ID对应前缀
		}
	}
	
	
	public TaskCenterOADao getTaskCenterOADao() {
		return taskCenterOADao;
	}
	public void setTaskCenterOADao(TaskCenterOADao taskCenterOADao) {
		this.taskCenterOADao = taskCenterOADao;
	}
	
	// 根据当前用户所在公司返回URL前缀
	private String getUrlPrefix(){
		
		String accountId = String.valueOf(AppContext.currentAccountId());
		
		if (!sysmanager_dangan_prefix_map.containsKey(accountId)){
			return "";
		}
		
		String prefix = sysmanager_dangan_prefix_map.get(accountId);
		
		/*
		 * 3664162159175945848|黑龙江省分公司,3421399311787445171|山东省分公司,-9041150167127212005|辽宁省分公司,3074543492480519438|宁夏回族自治区分公司,-4058377350576844976|上海自贸试验区分公司,2662344410291130278|北京分公司,-186884716227510066|海南省分公司,-760181039509385580|江西省分公司,6622655769517115117|广西壮族自治区分公司,2834525107653790181|河北省分公司,3674408233290321902|新疆维吾尔自治区分公司,4498629552994928530|重庆分公司,7685034498061782501|安徽省分公司,-933361846426711257|云南省分公司,4538261120908608848|甘肃省分公司,-5358952287431081185|江苏省分公司,-5775279222203856230|上海分公司,-2253116709917929726|湖南省分公司,-6820179698828490815|广东省分公司,2918815885120916765|浙江省分公司,1615999057975788128|天津分公司,6385708607716213359|陕西省分公司,7036903945253766800|河南省分公司,-3365316383954745086|山西省分公司,814361513619050478|吉林省分公司,-6020108033365555254|四川省分公司,-2653794827601557270|福建省分公司,-2593247964549918808|贵州省分公司,8554224093722463471|内蒙古自治区分公司,4651911572204437887|深圳分公司,9139674887561694241|青海省分公司,1755267543710320898|湖北省分公司,7099810924049157974|合肥后援基地管理中心
		 */
		/*
		 * 3664162159175945848|zc451arch1,3421399311787445171|zc531arch1,-9041150167127212005|zc240arch1,3074543492480519438|zc951arch1,2662344410291130278|zc100arch1,-186884716227510066|zc898arch1,-760181039509385580|zc791arch1,6622655769517115117|zc771arch1,2834525107653790181|zc311arch1,3674408233290321902|zc991arch1,4498629552994928530|zc230arch1,7685034498061782501|zc551arch1,-933361846426711257|zc871arch1,4538261120908608848|zc931arch1,-5358952287431081185|zc250arch1,-5775279222203856230|zc210arch1,-2253116709917929726|zc731arch1,-6820179698828490815|zc200arch1,2918815885120916765|zc571arch1,1615999057975788128|zc220arch1,6385708607716213359|zc290arch1,7036903945253766800|zc371arch1,-3365316383954745086|zc351arch1,814361513619050478|zc431arch1,-6020108033365555254|zc280arch1,-2653794827601557270|zc591arch1,-2593247964549918808|zc851arch1,8554224093722463471|zc471arch1,4651911572204437887|zc755arch1,9139674887561694241|zc971arch1,1755267543710320898|zc270arch1
		 */
		
		return prefix;
	}

	/**
	 * 生成url参数
	 */
	@AjaxAccess
	@Override
	public String replaceUrlParams(String link,String loginName,String hkdepartId){
		if(Strings.isBlank(link)){
			return "";
		}
		String todayTime = Datetimes.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		String enString = StringUtils.encrypt(loginName + "," + todayTime);
		link = link.replaceAll("app_var_1_secret", enString);
		
		if(link.indexOf("dangan_var_1") > 0){
			String prefix = getUrlPrefix();
			if (prefix != ""){
				link = link.replaceAll("dangan_var_1", prefix);
			}
		}
		if(link.indexOf("dangan_var_2") > 0){
			//portalparm=     uid=jsbfkq&time=时间戳
			String uid = StringUtils.encrypt(String.format("uid=%s&time=%s", loginName,todayTime));
			link = link.replaceAll("dangan_var_2", uid);
		}
		
		if(link.indexOf("user_id=app_var_1") > 0 || link.indexOf("currUser=app_var_1") > 0){
			link = link.replaceAll("app_var_1", loginName);
		}
		if(link.indexOf("portalUser=app_var_1")>0){
			String usrIDSec = StringUtils.encrypt(loginName);
			link = link.replaceAll("app_var_1", usrIDSec);
		}
		
		if(link.indexOf("app_var_2") > 0 ){
			link = link.replaceAll("app_var_2", hkdepartId);
		}
		if(link.indexOf("app_var_1") > 0)
			link = link.replaceAll("app_var_1", loginName);
		
		if(link.indexOf("app_var_1")==-1 && link.indexOf("app_var_2")==-1 && link.indexOf("?")==-1){
            String portalparm = StringUtils.encrypt("portuid=" + loginName);
            link = link + "?portalparm=" + portalparm;
		}
/*		       if(link.indexOf("app_var_2") > 0)
		       {
	               
	               link = link.replaceAll("app_var_2", departId);
		       } 
		     //url_type标识链接类型
		       String url_type ="";
               if(url_type.equals("1"))
               {
                   String portalparm = StringUtils.encrypt("portuid=" + loginName);
                   link = link + "?portalparm=" + portalparm;
               }
               if(url_type.equals("2"))
               {
                   String usrIDSec = StringUtils.encrypt(loginName);
                   if(link != null)
                   {
                       if(link.indexOf("app_var_1") > 0)
                          link = link.replaceAll("app_var_1", usrIDSec);
                       if(link.indexOf("app_var_2") > 0)
                       {
                          link = link.replaceAll("app_var_2", departId);
                       }
                   }
               }
               if(link != null && link.length() > 0)
               {

                   if(link.indexOf("app_var_1") > 0)
                       link = link.replaceAll("app_var_1", loginName);
                   if(link.indexOf("app_var_2") > 0)
                   {
                       link = link.replaceAll("app_var_2", departId);
                   }
               } */
		log.info("replaceUrlParams: " + link + "  loginName:  " + loginName + "  hkdepartId: " + hkdepartId);
		return link;
		
	}
	
	public String getOrganizationByLoginName(String loginName){
		
		try {
			HessianProxyFactory factory = new HessianProxyFactory();
			factory.setOverloadEnabled(true);
			ExportService service = (ExportService) factory.create(ExportService.class, TaskCenterConstant.usermanagerProviderUrl);

			OptionVO ret2 = service.getOrganizationByLoginName(loginName);

			if (ret2 != null) {
				log.info(ret2.getKey() + "=" + ret2.getValue());
				return ret2.getKey();
			}

		} catch (Exception ex) {
			log.error("getOrganizationByLoginName ",ex);
		}
		return "";
	}
	/**
	 * 获得用户所在部门的父部门ID
	 * @param loginName  用户登录帐号
	 * @return
	 */
	public String getjtUserParentDeptId(String loginName){
		
		String parentDeptId = "";
		try {
			UserServiceImpl client = new UserServiceImpl();
			String userId = client.getUserIdByAccount(loginName);
			String deparmentId = "";
			if(Strings.isNotBlank(userId)){
				deparmentId = client.getUserDeptIdByjtuserId(userId);
			}
			if(Strings.isNotBlank(userId) && Strings.isNotBlank(deparmentId)){
				OrgServiceImpl orgClient = new OrgServiceImpl();
				parentDeptId = orgClient.getParentDepartmentId(deparmentId, userId);
			}
		} catch (Exception e) {
			log.error("getjtUserParentDeptId",e);
		}
		return parentDeptId;
	}
	/**
	 * 获得cinda的部门id
	 * @param loginName
	 * @return
	 */
	@Override
	public String getjtUserDeptId(String loginName){
		try {
			UserServiceImpl client = new UserServiceImpl();
			String userId = client.getUserIdByAccount(loginName);
			if(Strings.isNotBlank(userId)){
				return client.getUserDeptIdByjtuserId(userId);
			}
		} catch (Exception e) {
			log.error("",e);
		}
		return "";
	}
	/**
	 * 获得cinda系统的用户id
	 * @param loginName
	 * @return
	 */
	@Override
	public String getjtUserId(String loginName){
		String userId = "";
		try {
			UserServiceImpl client = new UserServiceImpl();
			userId = client.getUserIdByAccount(loginName);
		} catch (Exception e) {
			log.error("",e);
		}

		return userId;
	}
	@AjaxAccess
	@Override
	public String getPortalUser(String loginName){
		if(Strings.isBlank(loginName)){
			loginName = CurrentUser.get().getLoginName();
		}
		String nowDate = Datetimes.format(new Date(System.currentTimeMillis()),"yyyy-MM-dd HH:mm:ss");
		String incryPtUserId = StringUtils.encrypt(loginName + "," + nowDate);
//		String incryPtUserId = StringUtils.encrypt(loginName);
		return incryPtUserId;
	}
	@AjaxAccess
	@Override
	public String getOpenParamsUrl(String loginName){
		String url = "?otherIdp=1&portalUser="+getPortalUser(loginName)+"&type=sso";
		log.info("获取SSOparamsURL为："+url);
		return url;
	}
	/**
	 * 用户导出所有urllink信息
	 * @return
	 */
	@Override
	public List<ProSenderUrl> getAllLinksIndb(){
		return taskCenterOADao.findAll(ProSenderUrl.class);

	}
	/**
	 * 用户导出入所有
	 * @param list
	 */
	@Override
	public void inportLinks(List<ProSenderUrl> list){
		if(list!=null && list.size()>0){
			for (ProSenderUrl po : list) {
				taskCenterOADao.saveOrUpdate(po);
			}
		}
	}
	private List<Long> getAuthorizationListByUser(User user){
		try {
			List<MemberPost> list = OrgHelper.getOrgManager().getMemberPosts(user.getLoginAccount() ,user.getId());
			if(list!=null && list.size()>0){
				List<Long> ids = new ArrayList<Long>();
				for (MemberPost memberPost : list) {
					ids.add(memberPost.getPostId());
				}
				String hql = "select r.resourceId from "+ProRoleResource.class.getName() +" r where (r.roleType=:typepost and r.roleid in (:ids)) or (r.roleType=:typedept and r.roleid = :deptid ) or (r.roleType=:typemember and r.roleid =:memberid)";
				Map<String ,Object> param = new HashMap<String, Object>();
				param.put("typepost", V3xOrgPost.class.getSimpleName());
				param.put("ids", ids);
				param.put("typedept", V3xOrgDepartment.class.getSimpleName());
				param.put("deptid", user.getDepartmentId());
				param.put("typemember", V3xOrgMember.class.getSimpleName());
				param.put("memberid", user.getId());
				List<Long> resourceIds	= this.taskCenterOADao.find(hql, param);
				if(resourceIds!=null){
					return resourceIds;
				}
			}
		} catch (BusinessException e) {
			log.error("",e);
		}
		return new ArrayList<Long>();
		
	}
	private List<TaskCenterResource> getTaskCenterResourceOfAuthor(User user){
		List<TaskCenterResource> result = new ArrayList<TaskCenterResource>();
		List<TaskCenterResource> list = this.taskCenterOADao.listTaskCenterResource();
		List<Long> listroles = this.getAuthorizationListByUser(user);
		for (TaskCenterResource res : list) {
			if(listroles.contains(res.getId())){
				result.add(res);
			}
		}
//		return list;
		return result;
	}
	public List<TaskCenterResource> convertToTree(List<TaskCenterResource> listpo){
		List<TaskCenterResource>  result = new ArrayList<TaskCenterResource>();
		Map<String ,TaskCenterResource> temp = new HashMap<String, TaskCenterResource>();
		for (TaskCenterResource src : listpo) {
			temp.put(src.getCode(), src);
			if(src.getLevel()==0){
				result.add(src);
				continue;
			}else if(temp.get(src.getParentCode())!=null){
				temp.get(src.getParentCode()).getChilds().add(src);
			}
		}
		return result;
		
	}
	@AjaxAccess
	@Override
	public List<TaskCenterResource> findTreeNodes(Map params){
		Long roleid = ParamUtil.getLong(params, "roleId");
		String roletype = ParamUtil.getString(params, "roleType");
		List<TaskCenterResource> list = this.taskCenterOADao.listTaskCenterResource();
		List<Long> roles = this.taskCenterOADao.listResourceIdsByroleId(roleid, roletype);
		for (TaskCenterResource res : list) {
			if(roles.contains(res.getId())){
				res.setChecked(true);
			}
		}
		return list;
	}
	@AjaxAccess
	@Override
	public String addAuthorResource(List<Map> param){
		if(param!=null){
			try {
				List<ProRoleResource> list = new ArrayList<ProRoleResource>();
				Map<Long,String> delroleIds = new HashMap<Long,String>();;
				for (Map map : param) {
					Long roleid = ParamUtil.getLong(map, "roleid");
					Long resourceId = ParamUtil.getLong(map, "resourceId");
					String roleType = ParamUtil.getString(map, "roleType");
					delroleIds.put(roleid, roleType);
					if(resourceId!=null){
						ProRoleResource res = new ProRoleResource(roleid, roleType, resourceId);
						list.add(res);
					}
				}
				for (Entry<Long, String> role : delroleIds.entrySet()) {
					
					this.taskCenterOADao.deleteResourceRoleByRoleId(role.getKey(), role.getValue());
				}
				if(list.size()>0){
					this.taskCenterOADao.saveOrUpdateAll(list);
				}
			} catch (Exception e) {
				log.error("",e);
				return "{'msg':'保存失败','success':false}";
			}
			return "{'msg':'保存成功','success':true}";
		}else{
			return "{'msg':'传入参数为空！','success':false}";
		}
	}
	@Override
	public List<TaskCenterResource> getTaskCenterResource(User user){
		
		List<TaskCenterResource> list = getTaskCenterResourceOfAuthor(user);
		
		return convertToTree(list);
		
	}
	@Override
	public List<TaskCenterResource> getTaskList4Section(User user, int count) {
		List<TaskCenterResource>  result = new ArrayList<TaskCenterResource>();
		List<TaskCenterResource> list = getTaskCenterResourceOfAuthor(user);
		for (TaskCenterResource res : list) {
			if(res.getLevel()==2){
				result.add(res);
				if(result.size()>=count){
					break;
				}
			}
		}
		return result;
	}

public static void main(String[] args) {
	System.out.println(StringUtils.decrypt("F0301779C563A4E9FD46A718B9A9A816DA5DB61126AE84A33D401697EDD39838"));
}
}
