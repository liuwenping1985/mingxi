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

import java.lang.reflect.Method;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.addressbook.constants.AddressbookConstants;
import com.seeyon.apps.addressbook.manager.AddressBookCustomerFieldInfoManager;
import com.seeyon.apps.addressbook.manager.AddressBookManager;
import com.seeyon.apps.addressbook.po.AddressBook;
import com.seeyon.apps.addressbook.po.AddressBookSet;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.peoplerelate.api.PeoplerelateApi;
import com.seeyon.apps.peoplerelate.bo.PeopleRelateBO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.metadata.bo.MetadataColumnBO;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgUnit;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;

/**
 * <p>Title: 人员卡片控制器</p>
 * <p>Description: 显示人员卡片</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @version CTP2.0
 */

public class PeopleCardController extends BaseController {

    protected OrgManager       orgManager;

    protected OrgManagerDirect orgManagerDirect;
    
    protected AddressBookManager addressBookManager;
    
    protected AddressBookCustomerFieldInfoManager addressBookCustomerFieldInfoManager;

    protected PeoplerelateApi peoplerelateApi;
    
    protected EnumManager        enumManagerNew;
    public void setEnumManagerNew(EnumManager enumManagerNew) {
        this.enumManagerNew = enumManagerNew;
    }

    public PeoplerelateApi getPeoplerelateApi() {
        return peoplerelateApi;
    }

    public void setPeoplerelateApi(PeoplerelateApi peoplerelateApi) {
        this.peoplerelateApi = peoplerelateApi;
    }
    
    public void setAddressBookManager(AddressBookManager addressBookManager) {
        this.addressBookManager = addressBookManager;
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

    public void setAddressBookCustomerFieldInfoManager(AddressBookCustomerFieldInfoManager addressBookCustomerFieldInfoManager) {
		this.addressBookCustomerFieldInfoManager = addressBookCustomerFieldInfoManager;
	}

	public ModelAndView showPeoPleCard(HttpServletRequest request,
			HttpServletResponse response) throws BusinessException {
    		String memberId = request.getParameter("memberId");
    		String type = request.getParameter("type");
    		ModelAndView result;
    		if("withoutbutton".equals(type)){
    			result = new ModelAndView("common/peopleCard/peopleCardWithOutButton_New");

    		}else{
    			result = new ModelAndView("common/peopleCard/peopleCard_New");

    		}

			V3xOrgMember member = orgManager.getMemberById(Long.valueOf(memberId));
			 //start mwl 通讯录中领导的信息需要有权限才可以查看
			 Long memberId1 = member.getId();
		     Long orgAccountId = member.getOrgAccountId(); 
			 //敏感信息隐藏角色
			 String tongxunlu_minganjuese = (String) PropertiesUtils.getInstance().get("tongxunlu_minganjuese");
			 boolean flag =orgManager.hasSpecificRole(memberId1, orgAccountId, tongxunlu_minganjuese);
			 member.setIsLeader(flag);
			 //end mwl 通讯录中领导的信息需要有权限才可以查看
			HashMap map = new HashMap();
			ParamUtil.beanToMap(member, map, false);
			Long deptId = member.getOrgDepartmentId();
			V3xOrgDepartment dept = orgManager.getDepartmentById(deptId);
			String str = "";
			str = makedeptlevelstr(deptId);
             if(member.getExternalType()==OrgConstants.ExternalType.Inner.ordinal()){
                    str = str + "/" + dept.getName();
                }
			map.put("orgDepartmentId", str);
			map.put("currentOrgDepartmentId", dept.getName());
			V3xOrgPost postById = orgManager.getPostById(Long.valueOf(map.get("orgPostId").toString()));
			map.put("name", OrgHelper.showMemberName(member.getId()));
			if(postById!=null){
				map.put("orgPostId", postById.getName());
			}else{
				map.put("orgPostId", OrgHelper.getExtMemberPriPost(member));
			}


			boolean isInternal = member.getIsInternal();
			map.put("isInternal",isInternal);
			map.put("externalType",member.getExternalType());
			map.put("address",member.getAddress());
			//工作地 ，汇报人
			map.put("worklocal",enumManagerNew.parseToName(member.getLocation()));
			V3xOrgMember report2 = orgManager.getMemberById(member.getReporter());
			if(report2!=null){
				map.put("reportTo",report2.getName());
			}else{
				map.put("reportTo","");
			}
			
			AddressBookSet addressBookSet = addressBookManager.getAddressbookSetByAccountId(member.getOrgAccountId());

        	if (!addressBookManager.checkLevel(AppContext.currentUserId(), member.getId(), AppContext.getCurrentUser().getLoginAccount(), addressBookSet)) {
                map.put("orgLevelId", AddressbookConstants.ADDRESSBOOK_INFO_REPLACE);
            } else {
                String isShowLevel = OrgHelper.getSystemSwitch("level_state_enable");
                if(Strings.equals("enable", isShowLevel)){
                    V3xOrgLevel levelById = orgManager.getLevelById(Long.valueOf(map.get("orgLevelId").toString()));
                    if(levelById!=null){
                        map.put("orgLevelId", levelById.getName());
                    }else{
                        map.put("orgLevelId", OrgHelper.getExtMemberLevel(member));
                    }
                }
                else{
                    map.put("orgLevelId", " - ");
                }
            }


			map.putAll(member.getProperties());

			if (!addressBookManager.checkPhone(AppContext.currentUserId(), member.getId(), AppContext.getCurrentUser().getLoginAccount(), addressBookSet)) {
			    map.put("telnumber", AddressbookConstants.ADDRESSBOOK_INFO_REPLACE);
            }

			//回写副岗信息
	        StringBuilder secondPost = new StringBuilder();
	        List<MemberPost> secondPostList = member.getSecond_post();
	        for (int i = 0; i < secondPostList.size(); i++) {
	            MemberPost m = secondPostList.get(i);
	            //拼接成[部门名称-岗位名称]前台显示
	            secondPost.append(orgManager.getDepartmentById(m.getDepId()).getName());
	            secondPost.append("-");
	            secondPost.append(OrgHelper.showOrgPostName(m.getPostId()));
	            if(i!=secondPostList.size()-1){
	            	secondPost.append(",");
	            }

	        }
	        map.put("secondPost", secondPost.toString());

	      //回写兼职信息
	        StringBuilder concurrentPost = new StringBuilder();

	        List<MemberPost> concurrentPostList = member.getConcurrent_post();
	        for (int i = 0; i < concurrentPostList.size(); i++) {
	            MemberPost m = concurrentPostList.get(i);
	            //拼接成[部门名称-岗位名称]前台显示
	            concurrentPost.append(orgManager.getUnitById(m.getOrgAccountId()).getName());
	            concurrentPost.append("-");
	            concurrentPost.append(OrgHelper.showOrgPostName(m.getPostId()));
	            if(i!=concurrentPostList.size()-1){
	            	concurrentPost.append(",");
	            }

	        }
	        map.put("concurrentPost", concurrentPost.toString());
	        // 政务版，政治面貌
	        Integer politics = (null == member.getProperty("politics") ||  ((Integer)member.getProperty("politics")).intValue() == 0)? null :(Integer)member.getProperty("politics");
	        if(null == politics) {
	            map.put("politics", "");
	        } else {
	            if(politics.intValue() == 1) {
	                map.put("politics", ResourceUtil.getString("member.form.politics.label.1.GOV"));
	            } else if(politics.intValue() == 2) {
	                map.put("politics", ResourceUtil.getString("member.form.politics.label.2.GOV"));
	            } else if(politics.intValue() == 3) {
	                map.put("politics", ResourceUtil.getString("member.form.politics.label.3.GOV"));
	            } else if(politics.intValue() == 4) {
	                map.put("politics", ResourceUtil.getString("member.form.politics.label.4.GOV"));
	            } else {
	                map.put("politics", "");
	            }
	        }
	        try {
	            PeopleRelateBO relate = peoplerelateApi.getPeopleRelate(member.getId(),AppContext.currentUserId());
	            String relateType = "";
	            if(relate!=null){
	                int tempType = relate.getRelateType();
	                switch(tempType){
	                    case 1:
	                        relateType = ResourceUtil.getString("relate.type.leader");
	                        break;
	                    case 2:
	                        relateType = ResourceUtil.getString("relate.type.junior");
	                        break;
	                    case 3:
	                        relateType = ResourceUtil.getString("relate.type.assistant");
	                        break;
	                    case 4:
	                        relateType = ResourceUtil.getString("relate.type.confrere");
	                        break;
	                }
	            }
	            map.put("relateType", relateType);
            } catch (Exception e) {

                logger.debug("get relate error：",e);
            }
			request.setAttribute("ffpeoplecardform", map);
			
	        //自定义的通讯录字段
	        AddressBook addressBook = addressBookCustomerFieldInfoManager.getByMemberId(Long.valueOf(memberId));
	        List<MetadataColumnBO> metadataColumnList = addressBookManager.getCustomerAddressBookList();
	        Map<String,String> valueMap = new HashMap<String,String>(); 
	        for(MetadataColumnBO metadataColumn : metadataColumnList){
        		String key=metadataColumn.getId().toString();
        		String columnName=metadataColumn.getColumnName();
        		try {
        			Method method=addressBookManager.getGetMethod(columnName);
        			if(null==method){
        				throw new BusinessException("自定义通讯录字段: "+metadataColumn.getLabel()+"不存在！");
        			}
        			if(null!=addressBook){
        				Object value=method.invoke(addressBook, new Object[] {});
        				if(metadataColumn.getType()==0){
        					String saveValue=null==value?"":String.valueOf(value);
        					valueMap.put(key,saveValue);
        				}
        				if(metadataColumn.getType()==1){
        					String saveValue="";
        					if(value!=null){
        						DecimalFormat df = new DecimalFormat();
        						df.setMinimumFractionDigits(0);
        						df.setMaximumFractionDigits(4);
        						saveValue = df.format(Double.valueOf(String.valueOf(value)));
        						saveValue = saveValue.replaceAll(",", "");
        					}
        					valueMap.put(key,saveValue);  
        					
        				}
        				if(metadataColumn.getType()==2){
        					String saveValue=null==value?"":Datetimes.formatDate((Date)value);
        					valueMap.put(key,saveValue);  
        				}
        			}else{
        				valueMap.put(key,"");  
        			}
        		} catch (Exception e) {
        			logger.error("查看人员通讯录信息失败！", e);
        		}
	        }
	        result.addObject("bean", metadataColumnList);
	        result.addObject("beanValue", valueMap);

			return result;
	}

    public ModelAndView showPeoPleCardMini(HttpServletRequest request,
			HttpServletResponse response) throws BusinessException {
			ModelAndView result = new ModelAndView("common/peopleCard/peopleCardMini");
//			String memberId = request.getParameter("memberId");
//			V3xOrgMember member = orgManager.getMemberById(Long.valueOf(memberId));
//			HashMap map = new HashMap();
//			ParamUtil.beanToMap(member, map, false);
//			map.put("orgDepartmentId", orgManager.getDepartmentById(Long.valueOf(map.get("orgDepartmentId").toString())).getName()+" " +orgManager.getPostById(Long.valueOf(map.get("orgPostId").toString())).getName());
//			//map.put("orgPostId", orgManager.getPostById(Long.valueOf(map.get("orgPostId").toString())).getName());
//			map.putAll(member.getProperties());
//
//			request.setAttribute("ffpeoplecardminiform", map);
			return result;
	}
    /**
     * 获取部门上级部门全路径
     * @param deptid
     * @return
     * @throws BusinessException
     */
    private String makedeptlevelstr(Long deptid) throws BusinessException{
    	V3xOrgUnit self = orgManager.getUnitById(deptid);
    	V3xOrgUnit paraent = orgManager.getUnitById(self.getSuperior());
    	String str=paraent.getName();
        if (null != paraent && OrgConstants.UnitType.Department.equals(paraent.getType())) {
            str = makedeptlevelstr(paraent.getId())+"/"+str;
        }
    	return str;
    }

}
