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
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.addressbook.manager.AddressBookCustomerFieldInfoManager;
import com.seeyon.apps.addressbook.manager.AddressBookManager;
import com.seeyon.apps.addressbook.po.AddressBook;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ProductEditionEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.metadata.bo.MetadataColumnBO;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.CompareSortEntity;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.inexportutil.DataUtil;
import com.seeyon.ctp.organization.manager.DepartmentManager;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.organization.util.OrgTree;
import com.seeyon.ctp.organization.util.OrgTreeNode;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgDepartment;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgMember;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;


/**
 * <p>
 * Title: T2组织模型部门维护控制器
 * </p>
 * <p>
 * Description: 主要针对单位组织进行维护功能
 * </p>
 * <p>
 * Copyright: Copyright (c) 2012
 * </p>
 * <p>
 * Company: seeyon.com
 * </p>
 * 
 * @version CTP2.0
 */
//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
public class DepartmentController extends BaseController {
	private final static Log   log = LogFactory.getLog(DepartmentController.class);

	protected OrgManager orgManager;
	protected OrgManagerDirect orgManagerDirect;
	protected DepartmentManager departmentManager;

    protected FileToExcelManager fileToExcelManager;
	protected OrgCache           orgCache;
	protected AddressBookManager addressBookManager;
	protected EnumManager        enumManagerNew;
	protected AddressBookCustomerFieldInfoManager addressBookCustomerFieldInfoManager;
	
	public void setAddressBookCustomerFieldInfoManager(
			AddressBookCustomerFieldInfoManager addressBookCustomerFieldInfoManager) {
		this.addressBookCustomerFieldInfoManager = addressBookCustomerFieldInfoManager;
	}
	
    public void setEnumManagerNew(EnumManager enumManagerNew) {
        this.enumManagerNew = enumManagerNew;
    }

	public void setAddressBookManager(AddressBookManager addressBookManager) {
		this.addressBookManager = addressBookManager;
	}

	public DepartmentManager getDepartmentManager() {
	    return departmentManager;
	}
	
	public void setDepartmentManager(DepartmentManager departmentManager) {
	    this.departmentManager = departmentManager;
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
	public FileToExcelManager getFileToExcelManager() {
		return fileToExcelManager;
	}

	public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
		this.fileToExcelManager = fileToExcelManager;
	}

	public void setOrgCache(OrgCache orgCache) {
        this.orgCache = orgCache;
    }

    public ModelAndView showDepartmentFrame(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String style = request.getParameter("style");
		ModelAndView result = new ModelAndView();
		if ("tree".equals(style)) {
			result = new ModelAndView("apps/organization/department/treeIndex");
		} else if ("list".equals(style)) {
			result = new ModelAndView("apps/organization/department/listIndex");

		} else if ("external".equals(style)) {
			result = new ModelAndView("apps/organization/department/ExternallistIndex");

		}
        Integer productId = SystemProperties.getInstance().getIntegerProperty("system.ProductId");
        if(null != productId && productId.intValue() == ProductEditionEnum.a6s.ordinal()) {
            result.addObject("isA6s", true);
        } else {
            result.addObject("isA6s", false);
        }

        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        result.addObject("accountId", accountId);

		return result;
	}
    
	public ModelAndView exportDepartmentMember(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	    orgCache.setOrgExportFlag(true);
		User u=AppContext.getCurrentUser();
		if(u==null){
			return null;
		}
		if(DataUtil.doingImpExp(u.getId())){
			return null;
		}
		
		String deptId = request.getParameter("deptId");
		String listname = "MemberList_";
		listname+=u.getLoginName();
		
		DataUtil.putImpExpAction(u.getId(), "export");
		DataRecord dataRecord=null;
		try{
			dataRecord = exportDepartmentMember(request, 
					response, fileToExcelManager, deptId);
		}catch(Exception e){
			DataUtil.removeImpExpAction(u.getId());
			throw e;
		}
		DataUtil.removeImpExpAction(u.getId());
        try {
            OrgHelper.exportToExcel(request, response, fileToExcelManager, listname, dataRecord);
        } catch (Exception e) {
            log.error(e);
        } finally {
            orgCache.setOrgExportFlag(false);
        }
		return null;
	}
	
   public ModelAndView exportDepartments(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        orgCache.setOrgExportFlag(true);
        User u=AppContext.getCurrentUser();
        if(u==null){
            return null;
        }
        if(DataUtil.doingImpExp(u.getId())){
            return null;
        }
        
        String listname = "departments_";
        listname+=u.getLoginName();
        
        DataUtil.putImpExpAction(u.getId(), "export");
        DataRecord dataRecord=null;
        try{
            dataRecord = exportDepartments(request, 
                    response, fileToExcelManager, orgManagerDirect);
        }catch(Exception e){
            DataUtil.removeImpExpAction(u.getId());
            throw e;
        }
        DataUtil.removeImpExpAction(u.getId());
        try {
            OrgHelper.exportToExcel(request, response, fileToExcelManager, listname, dataRecord);
        } catch (Exception e) {
            log.error(e);
        } finally {
            orgCache.setOrgExportFlag(false);
        }
        return null;
    }
	//取得本部门下的副岗兼职人员
    private List<V3xOrgMember> getSecConMemberByDept(Long deptId) throws BusinessException {
        List<V3xOrgMember> result = new UniqueList<V3xOrgMember>();
        List<MemberPost> memberPosts = orgManager.getSecConMemberByDept(deptId);
        if (memberPosts != null && memberPosts.size() > 0) {
            for (MemberPost rel : memberPosts) {
                V3xOrgMember member = (V3xOrgMember) orgManager.getMemberById(rel.getMemberId());
                if (null != member && member.isValid()) {
                    result.add(member);
                }
            }
        }
        return result;
    }
	
	/**
	 * 导出部门下的所有人员信息
	 * @param request
	 * @param metadataManager
	 * @param response
	 * @param fileToExcelManager
	 * @param orgManagerDirect
	 * @param searchManager
	 * @param path
	 * @return
	 * @throws Exception
	 */
	public DataRecord exportDepartmentMember(HttpServletRequest request,
			HttpServletResponse response,FileToExcelManager fileToExcelManager
			,String deptId) throws Exception{
        //User user = AppContext.getCurrentUser();
        DataRecord dataRecord = new DataRecord();
        //String resource = "com.seeyon.v3x.organization.resources.i18n.OrganizationResources";
        List<V3xOrgMember> memberlist = new UniqueList<V3xOrgMember>();
        
        //包括主岗、副岗和兼职的部门下的人员
        memberlist = orgManager.getMembersByDepartment(Long.valueOf(deptId), true, null);
        //副岗和兼职人员列表
//        if(null != memberlist) {
//            memberlist.addAll(this.getSecConMemberByDept(Long.valueOf(deptId)));
//        }

        V3xOrgAccount account = null;
        V3xOrgMember member = null;
        V3xOrgDepartment dept = null;
		String deptName = "";
		V3xOrgPost post = null;
		V3xOrgLevel level = null;
		//Locale locale = LocaleContext.getLocale(request);
        //导出excel文件的国际化
		String member_name = ResourceUtil.getString("org.member_form.name.label");
		String member_loginName = ResourceUtil.getString("org.member_form.loginName.label");
		String member_code = ResourceUtil.getString("org.member_form.code");
		String member_deptName = ResourceUtil.getString("org.member_form.deptName.label");
		String member_primaryPost = ResourceUtil.getString("org.member_form.primaryPost.label");
		String member_levelName = ResourceUtil.getString("org.member_form.levelName.label");
		String member_tel = ResourceUtil.getString("org.member_form.tel");
		String member_account = ResourceUtil.getString("org.member_form.account");
		String member_email = ResourceUtil.getString("org.member.emailaddress");
		String member_gender= ResourceUtil.getString("org.memberext_form.base_fieldset.sexe");
		String member_birthday= ResourceUtil.getString("org.memberext_form.base_fieldset.birthday");
		String member_officeNumber= ResourceUtil.getString("member.office.number");
		String member_primaryLanguange = ResourceUtil.getString("org.member_form.primaryLanguange");
		String member_location = ResourceUtil.getString("member.location");
        String member_hiredate = ResourceUtil.getString("member.hiredate");
        String member_reporter = ResourceUtil.getString("member.report2");
		String member_list = ResourceUtil.getString("org.member_form.list");
		String[] customerAddressBookFields = null;
		
		if (null != memberlist && memberlist.size() > 0) {
			
			//自定义的通讯录字段
            List<MetadataColumnBO> metadataColumnList=addressBookManager.getCustomerAddressBookList();
            int size = metadataColumnList.size();
            if(metadataColumnList.size()>0){
            	customerAddressBookFields = new String[size];
            }
            for(int i = 0; i<size; i++){
            	customerAddressBookFields[i]=metadataColumnList.get(i).getLabel();
            }
			
			DataRow[] datarow = new DataRow[memberlist.size()];
			for (int i = 0; i < memberlist.size(); i++) {
				member = memberlist.get(i);
				if(log.isDebugEnabled())
					log.debug(member.getName());

				DataRow row = new DataRow();
				row.addDataCell(member.getName(), 1);
				row.addDataCell(member.getLoginName(), 1);
				row.addDataCell(member.getCode(), 1);

				account = orgManager.getAccountById(member.getOrgAccountId());
				row.addDataCell(account.getName(), 1);		//所属单位

				dept = orgManager.getDepartmentById(member.getOrgDepartmentId());
				String deptCode=null;
				if(dept!=null){
					deptName = dept.getName();
					deptCode=dept.getCode();
				}
				if(StringUtils.hasText(deptCode)){
					try{
						deptName+="("+deptCode+")";
					}catch(Exception e){
						
					}
				}
					row.addDataCell(deptName, 1);	//所属部门

				if(member.getOrgPostId()==-1){
					row.addDataCell(null, 1);	//主要岗位tanglh
				}else{
					post = orgManager.getPostById(member.getOrgPostId());
					
					if (null != post ) {
						String ppostName = post.getName();    //
						String ppostCode=post.getCode();
						if(StringUtils.hasText(ppostCode)){
							try{
								ppostName+="("+ppostCode+")";
							}catch(Exception e){
								
							}
						}
							row.addDataCell(ppostName, 1);	//主要岗位tanglh
					}else{
						row.addDataCell(null, 1);	//主要岗位tanglh
					}
				}

				if(member.getOrgLevelId()==-1){
					row.addDataCell(null, 1);	//职务级别
				}else{
					level = orgManager.getLevelById(member.getOrgLevelId());
					if (null != level ) {
						String levName = level.getName();
						String levelCode=level.getCode();
						if(StringUtils.hasText(levelCode)){
							try{
								levName+="("+levelCode+")";
							}catch(Exception e){
								
							}
						}
							row.addDataCell(levName, 1);	//职务级别
					}else{
						row.addDataCell(null, 1);	//职务级别
					}
				}

				row.addDataCell(member.getTelNumber(), 1);	//移动电话号码

				row.addDataCell(member.getEmailAddress(), 1);//email   
				String gender ="";
				if(member.getGender()!=null){
					if(V3xOrgEntity.MEMBER_GENDER_MALE==member.getGender())
					{
						gender="男";
					}
					else if(V3xOrgEntity.MEMBER_GENDER_FEMALE==member.getGender())
					{
						gender="女";
					}					
				}
				row.addDataCell(gender, 1);	// 性别
				
				String birthday = "";
				if(member.getBirthday()!=null)birthday=Datetimes.format(member.getBirthday(), "yyyy-MM-dd");
				row.addDataCell(birthday, 1);	// 生日
				V3xOrgMember memMember = orgManager.getMemberById(member.getId());
				String officeNum = "";
				if (memMember!=null) officeNum = memMember.getOfficeNum();
				row.addDataCell(officeNum, 1);	// 办公电话
				
                // 首选语言
                Locale orgLocale = orgManagerDirect.getMemberLocaleById(member.getId());
                String localStr = "localeselector.locale."+orgLocale;
                row.addDataCell(ResourceUtil.getString(localStr), 1);  
				
                // 工作地
                String location = "";
                if (memMember != null){
                	location = (String) memMember.getLocation();
                	if(location==null){
                		location ="";
                	}else{
                		location = enumManagerNew.parseToName(location);
                	}
                }
                row.addDataCell(location, 1); 
                
                // 入职时间
                String hiredate = "";
                if (memMember != null){
                	if (member.getHiredate() != null){
                		hiredate = Datetimes.format(memMember.getHiredate(), "yyyy-MM-dd");
                	}
                }
                row.addDataCell(hiredate, 1);
            
            // 汇报人
            	String report2 = "";
            	if (memMember != null){
            		V3xOrgMember reportTo = orgManager.getMemberById(memMember.getReporter());
            		if(reportTo!=null){
            			report2 = reportTo.getName()+"("+reportTo.getLoginName()+")";
            		}
            	}
            	row.addDataCell(report2, 1); 
            	
            	//自定义的通讯录字段
            	if(Strings.isNotEmpty(metadataColumnList)){
            		AddressBook addressBook = addressBookCustomerFieldInfoManager.getByMemberId(member.getId());
            		for(MetadataColumnBO metadataColumn : metadataColumnList){
            			String columnName=metadataColumn.getColumnName();
            			try {
            				Method method=addressBookManager.getGetMethod(columnName);
            				if(null==method){
            					throw new BusinessException("自定义通讯录字段: "+metadataColumn.getLabel()+"不存在！");
            				}
            				if(null!=addressBook){
            					Object custValue=method.invoke(addressBook, new Object[] {});
            					if(metadataColumn.getType()==0){
            						String showValue=null==custValue?"":String.valueOf(custValue);
            						row.addDataCell(showValue, 1); 
            					}
            					if(metadataColumn.getType()==1){
            						String showValue="";
            						if(custValue!=null){
            							DecimalFormat df = new DecimalFormat();
            							df.setMinimumFractionDigits(0);
            							df.setMaximumFractionDigits(4);
            							showValue = df.format(Double.valueOf(String.valueOf(custValue)));
            							showValue = showValue.replaceAll(",", "");
            						}
            						row.addDataCell(showValue, 1); 
            					}
            					if(metadataColumn.getType()==2){
            						String showValue=null==custValue?"":Datetimes.format((Date)custValue, "yyyy-MM-dd");
            						row.addDataCell(showValue, 1); 
            					}
            				}else{
            					row.addDataCell("", 1); 
            				}
            			} catch (Exception e) {
            				logger.error("查看人员通讯录信息失败！", e);
            			}
            		}
            	}
				
				datarow[i] = row;
			}

			try {
				dataRecord.addDataRow(datarow);
			} catch (Exception e) {
				log.error("eeror",e);
			}
		}
		String[] columnName = {member_name,member_loginName,member_code,member_account,member_deptName,member_primaryPost
				           ,member_levelName,member_tel,member_email,member_gender,member_birthday,member_officeNumber,member_primaryLanguange,member_location,member_hiredate,member_reporter};
		List<String> tempList = new ArrayList<String>(Arrays.asList(columnName));
		if(customerAddressBookFields!=null){
			tempList.addAll(new ArrayList<String>(Arrays.asList(customerAddressBookFields)));
		}
		columnName = tempList.toArray(new String[tempList.size()]);
		dataRecord.setColumnName(columnName);
		dataRecord.setTitle(member_list);
		dataRecord.setSheetName(member_list);
	
		return dataRecord;
	}
	/**
	 * 进入部门岗位管理编辑方法
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView editDeptPosts(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView result = new ModelAndView("apps/organization/department/deptPosts");
		String strid = request.getParameter("id");
		Long _id = Long.parseLong(strid);
		V3xOrgDepartment dept = orgManager.getDepartmentById(_id);
		WebV3xOrgDepartment webdept = new WebV3xOrgDepartment();
		webdept.setV3xOrgDepartment(dept);
		
		V3xOrgRole deptManager = orgManager.getRoleByName(OrgConstants.Role_NAME.DepManager.name(), dept.getOrgAccountId());
		List<V3xOrgMember> managerList = null;
		if(deptManager!=null){
		    managerList = orgManager.getMembersByRole(_id, deptManager.getId());			
		}
		List<WebV3xOrgMember> webMemberList = new UniqueList<WebV3xOrgMember>();
	    //List<Long> memberIdList = new UniqueList<Long>();
		//Locale local = LocaleContext.getLocale(request);
		//String resource = "com.seeyon.v3x.organization.resources.i18n.OrganizationResources";
		String cntStr = ResourceUtil.getString("department.cntPost");

		//取得本部门下的直属人员
		List<V3xOrgEntity> ents = orgManager.getEntityListNoRelation(V3xOrgMember.class.getSimpleName(), "orgDepartmentId", dept.getId(), dept.getOrgAccountId(), false);
		//为了提升性能这里将单位下的所有岗位缓存
//		Map postMap = organization.getAllEntity(V3xOrgPost.class, dept.getOrgAccountId());
		//去掉离职停用的人员
		for(V3xOrgEntity ent:ents){
			V3xOrgMember member = (V3xOrgMember)ent;
			if(member.getEnabled()){
				WebV3xOrgMember webMember = new WebV3xOrgMember();
				webMember.setV3xOrgMember(member);
				webMember.setTypeName(member.getName());
				V3xOrgPost post = orgManager.getPostById(member.getOrgPostId());
				if(post!=null)webMember.setPostName(post.getName());
				webMemberList.add(webMember);
				//memberIdList.add(member.getId());
			}
		}		
		
		//取得本部门下的副岗兼职人员
		List<WebV3xOrgMember> secondMemberList = new UniqueList<WebV3xOrgMember>();
		List<WebV3xOrgMember> currendMemberList = new UniqueList<WebV3xOrgMember>();
        List<MemberPost> memberPosts = orgManager.getSecConMemberByDept(dept.getId());
        if (memberPosts != null && memberPosts.size() > 0) {
            for (MemberPost rel : memberPosts) {
                V3xOrgMember member = (V3xOrgMember) orgManager.getMemberById(rel.getMemberId());
                if (null != member && member.isValid()) {
        			if(member.getEnabled()){
        				WebV3xOrgMember webMember = new WebV3xOrgMember();
        				webMember.setV3xOrgMember(member);
        				V3xOrgPost post = orgManager.getPostById(rel.getPostId());
        				if(post!=null)webMember.setPostName(post.getName());
        				if(Strings.equals(member.getOrgAccountId(), dept.getOrgAccountId())){
        					//副岗 
        					webMember.setTypeName(cntStr+member.getName());
        					secondMemberList.add(webMember);
        				}else{
        					//兼职
        					webMember.setTypeName(cntStr+member.getName());
        					currendMemberList.add(webMember);
        				}
        			}
                }
            }
        }

        webMemberList.addAll(secondMemberList);
        webMemberList.addAll(currendMemberList);
		// 获得部门岗位
		List<V3xOrgPost> listPost = orgManager.getDepartmentPost(dept.getId());
		Collections.sort(listPost,CompareSortEntity.getInstance());
		result.addObject("managerList", managerList);
		result.addObject("memberList", webMemberList);
		result.addObject("memberListLength", webMemberList.size());
		result.addObject("postList", listPost);
		result.addObject("postsSize", webMemberList.size());
		result.addObject("dept", webdept);		
		result.addObject("readOnly", request.getParameter("readOnly"));
		return result;
	}
	
	/**
     * 批量导出部门
     * @param request
     * @param metadataManager
     * @param response
     * @param fileToExcelManager
     * @param orgManagerDirect
     * @param searchManager
     * @param path
     * @return
     * @throws Exception
     */
    public DataRecord exportDepartments(HttpServletRequest request,
            HttpServletResponse response,FileToExcelManager fileToExcelManager
            ,OrgManagerDirect orgManagerDirect) throws Exception{
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        DataRecord dataRecord = new DataRecord();
        
        V3xOrgDepartment dept = null;
        String dep_list = ResourceUtil.getString("org.dept_role.list");
        List<V3xOrgDepartment> departmentlist = orgManagerDirect.getAllDepartments(accountId, true, true, null, null, null);
        
        List<OrgTreeNode> orgTreeNodes = OrgTree.changeEnititiesToOrgTreeNodes(departmentlist);
        V3xOrgAccount currentAccont =orgManager.getAccountById(accountId);
        String accountPath =currentAccont.getPath();
        String accountName =currentAccont.getName();
        //TODO：需注意是否是有效树
        OrgTree orgTree = new OrgTree(orgTreeNodes,accountPath);
        OrgTreeNode rootNode = orgTree.getRoot();
        List<OrgTreeNode> orgTreeMidList = new ArrayList<OrgTreeNode>();
        try {
            orgTreeMidList= rootNode.traversal();
        } catch (Exception e) {
            log.error("构造树error",e);
        }
        
        //导出excel文件的国际化
        String dep_Name = ResourceUtil.getString("org.dept.grade");
        String dep_Code = ResourceUtil.getString("org.dept_form.code.label");
        String dep_Level = ResourceUtil.getString("org.dept.level");
        String dep_SortId = ResourceUtil.getString("common.sort.label");
        String dep_desc = ResourceUtil.getString("common.description.label");
        
        String[] columnName = {};
        if (null != orgTreeMidList && orgTreeMidList.size() > 0) {
            DataRow[] datarow = new DataRow[orgTreeMidList.size()];
            //树深度
            int treeDeep = orgTree.getTreeDeep();
            //显示部门角色
            List<V3xOrgRole> rolelist = orgManager.getAllDepRoles(accountId);
            int columnsize = treeDeep+4+(rolelist.size());
            columnName = new String[columnsize];
            for (int i = 0; i < orgTreeMidList.size(); i++) {
                DataRow row = new DataRow();
                OrgTreeNode currentNode= orgTreeMidList.get(i);
                dept = (V3xOrgDepartment)currentNode.getObj();
                String deptCode ="";
                String deptName = "";
                if(log.isDebugEnabled())
                    log.debug(dept.getName());
                if(dept!=null){
                    deptName = dept.getName();
                    deptCode=dept.getCode();
                }else{
                	continue;
                }
                int deptDeep = (dept.getPath().length()-accountPath.length())/4;
                
                V3xOrgDepartment tempDept = dept;
                //部门名称(各级别)
                String[] deptsName = new String[treeDeep];
                for (int l =treeDeep; l>0; l--) {
                    columnName[l-1]=l+dep_Name;
                    if(l<deptDeep && tempDept!=null){
                        V3xOrgDepartment parentDept= orgManager.getDepartmentByPath(tempDept.getParentPath());
                        deptsName[l-1]=parentDept.getName();
                        tempDept=parentDept;
                    }else if(l>deptDeep){
                        deptsName[l-1]="";
                    }else{
                        deptsName[l-1]=deptName;
                    }
                }
                for(int l =0; l <treeDeep; l++){
                    row.addDataCell(deptsName[l], 1);
                }
                int index = treeDeep;
                columnName[index++]=dep_Code;
                columnName[index++]=dep_Level;
                columnName[index++]=dep_SortId;
                columnName[index++]=dep_desc;
                row.addDataCell(deptCode, 1);
                row.addDataCell(String.valueOf((deptDeep)), 1);
                row.addDataCell(String.valueOf((dept.getSortId())), 1);
                row.addDataCell(dept.getDescription(), 1);
                
                for (int j = 0; j < rolelist.size(); j++) {
                    V3xOrgRole tempRole = rolelist.get(j);
                    List<V3xOrgMember> memberlist = orgManager.getMembersByRole(dept.getId(), rolelist.get(j).getId());
                    columnName[index++]=tempRole.getShowName();
                    row.addDataCell(memberListToString(memberlist), 1);
                }
                datarow[i] = row;
            }

            try {
                dataRecord.addDataRow(datarow);
            } catch (Exception e) {
                log.error("eeror",e);
            }
        }
        dataRecord.setColumnName(columnName);
        dataRecord.setTitle(dep_list);
        dataRecord.setSheetName(dep_list);
        return dataRecord;
    }
    
    private String memberListToString(List<V3xOrgMember> memberlist){
        StringBuffer sb = new StringBuffer();
        String memberString = "";
        for(V3xOrgMember m : memberlist){
            sb.append(m.getName()).append('、');
        }
        memberString = sb.toString();
        if(memberString.length()>0){
            return memberString.substring(0, memberString.length()-1);
        }else{
            return "";
        }
    }
}
