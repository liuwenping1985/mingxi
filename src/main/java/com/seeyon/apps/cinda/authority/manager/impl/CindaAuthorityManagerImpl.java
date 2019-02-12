package com.seeyon.apps.cinda.authority.manager.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import cn.com.hkgt.um.interfaces.OutServiceFactory;
import cn.com.hkgt.um.interfaces.exports.ExportService;
import cn.com.hkgt.um.vo.AuthorityVO;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.apps.cinda.authority.dao.CindaAuthorityDao;
import com.seeyon.apps.cinda.authority.domain.UmAuthority;
import com.seeyon.apps.cinda.authority.manager.CindaAuthorityManager;
import com.seeyon.apps.cinda.authority.util.CindaLinkUtils;
import com.seeyon.apps.taskcenter.bo.TaskCenterResource;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;

public class CindaAuthorityManagerImpl implements CindaAuthorityManager {
	public static final Log log = LogFactory.getLog(CindaAuthorityManagerImpl.class);
	public OrgManager orgManager;
	public CindaAuthorityDao cindaAuthorityDao;
	
	
	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	public void setCindaAuthorityDao(CindaAuthorityDao cindaAuthorityDao) {
		this.cindaAuthorityDao = cindaAuthorityDao;
	}

	public Map<String,TaskCenterResource> getlistInrole(String loginName,List<UmAuthority> list){
		Map<String,TaskCenterResource> resultMap = new HashMap<String,TaskCenterResource>();
		if(list!=null){
			List<String> listRoles = this.cindaAuthorityDao.listUmGroupRoleAuthority(loginName);
			log.info("listUmGroupRoleAuthority size =="+listRoles.size());
			for (UmAuthority au : list) {
				
				if(listRoles.contains(au.getAuthorityid()) || au.getAuthoritycode().length()<5){
					resultMap.put(au.getAuthoritycode(),new TaskCenterResource(au));
				}
			}
		}
		return resultMap;
	}
	
	@Override
	public List<TaskCenterResource> getTaskCenterResource(User user,String rootCode) {
		List<TaskCenterResource> result = new ArrayList<TaskCenterResource>();
		Map<String, TaskCenterResource> datamap = listUmAuthority(user, rootCode);
		if(datamap!=null && datamap.size()>0){
			for (Entry<String, TaskCenterResource> entry : datamap.entrySet()) {
				if(!entry.getKey().equals(rootCode)){
					String parentCode = entry.getValue().getParentCode();
					if(Strings.isNotBlank(parentCode) && !"0".equals(parentCode)){
						TaskCenterResource parent = datamap.get(parentCode);
						if(parent!=null){
							parent.getChilds().add(entry.getValue());
						}else{
							log.info("当前资源没有找到父级节点对象！=="+JSONObject.toJSONString(entry.getValue()));
						}
					}else{
						log.info("当前资源没有找到父级节点！=="+JSONObject.toJSONString(entry.getValue()));
					}
				}else{
					log.warn("当前资源为父级：="+JSONObject.toJSONString(entry.getValue()));
				}

			}
		}
//		List<TaskCenterResource> tmp = datamap.get(rootCode).getChilds();
//		for (int i = tmp.size()-1;i>=0;i--) {
//			if(tmp.get(i).getChilds().size()==0){
//				tmp.remove(i);
//			}
//		}
		result.add(datamap.get(rootCode));
		return result;
	}
//	private Map<String, TaskCenterResource>  listUmAuthority(User user,
//			String rootCode){
//		String listkey = "user_cinda_links_cache"+rootCode;
//		List<UmAuthority>  list = (List<UmAuthority> ) user.getProperty(listkey);
//		if(list==null){
//			list = this.cindaAuthorityDao.getUmAuthoritysByRootCode(rootCode);
//			log.info("本次通过数据库获取"+rootCode+"===="+list.size());
//			user.setProperty(listkey, list);
//		}
//		return this.getlistInrole(user.getLoginName(), list);
//	}
	private Map<String, TaskCenterResource>  listUmAuthority(User user,
			String rootCode){
		Map<String, TaskCenterResource> res = new HashMap<String, TaskCenterResource>();
			try {
				//拷贝dao方法
//				Map<String, UmAuthority> datas =  this.cindaAuthorityDao.getAuthListByRootcodeAndLoginName(rootCode, user.getLoginName());
				//直接调用webservice接口获得数据
//				for (Entry<String, UmAuthority> en : datas.entrySet()) {
//					res.put(en.getKey(), new TaskCenterResource(en.getValue()));
//				}
				Map<String, AuthorityVO> datas =  CindaLinkUtils.getAuthListByRootAndLoginName(rootCode, user.getLoginName());
				log.info("通过webservice获取到的数据"+rootCode+"列表为"+datas.size()+"个");
				for (Entry<String, AuthorityVO> ent : datas.entrySet()) {
					res.put(ent.getKey(), new TaskCenterResource(ent.getValue()));
				}
			} catch (Exception e) {
				log.error("",e);
			}
		return res;
	}
	@Override
	public List<TaskCenterResource> getTaskList4Section(User user,
			String rootCode, int count) {
		List<TaskCenterResource> result = new ArrayList<TaskCenterResource>();
		Map<String, TaskCenterResource> datamap = listUmAuthority(user, rootCode);
		for (Entry<String, TaskCenterResource> um : datamap.entrySet()) {
			if(Strings.isNotBlank(um.getValue().getUrl()) && um.getKey().length()>2){
				result.add(um.getValue());
			}
		}
		if(result.size()>count){
			
			result = result.subList(0, count);
		}
		return result;
	}
	private static List<AuthorityVO> getuserAuthor(){
		ExportService service =  OutServiceFactory.getExportService();
		List<AuthorityVO> list = service.getAuthorityListOfUser("jsbfkq");
		return list;
	}
	public static void main(String[] args) {
		System.out.println(getuserAuthor());
	}
}
