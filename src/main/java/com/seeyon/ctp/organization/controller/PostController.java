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

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.dao.paginate.Pagination;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.inexportutil.DataUtil;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.ctp.util.json.JSONUtil;

/**
 * <p>Title: T2组织模型岗位维护控制器</p>
 * <p>Description: 主要针对单位组织进行维护功能</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @version CTP2.0
 */
//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
public class PostController extends BaseController {

    protected OrgManager       orgManager;
    protected OrgManagerDirect orgManagerDirect;
    protected FileToExcelManager fileToExcelManager;
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
	protected EnumManager  enumManagerNew;
    protected EnumManager getEnumManager(){
        if(enumManagerNew == null){
        	enumManagerNew = (EnumManager)AppContext.getBean("enumManagerNew");
        }
        
        return enumManagerNew;
    }

    public ModelAndView showPostframe(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/organization/post/listPost");
        Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        mav.addObject("accountId", accountId);
        mav.addObject("isGroup", OrgConstants.GROUPID.equals(accountId));
        return mav;
    }

    public ModelAndView exportPost1(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		User u=AppContext.getCurrentUser();
		if(u==null){
			//DataUtil.outNullUserAlertScript(out);
			return null;
		}
		if(DataUtil.doingImpExp(u.getId())){
			//DataUtil.outDoingImpExpAlertScript(out);
			return null;
		}
		
		Long accountId = AppContext.currentAccountId();
        String accountIdStr = request.getParameter("accountId");
        if (Strings.isNotBlank(accountIdStr)) {
            accountId = Long.valueOf(accountIdStr);
        }
        boolean isGroup = OrgConstants.GROUPID.equals(accountId);
        
        String listname = ResourceUtil.getString("org.post_form.list");
        listname += u.getLoginName();
        if (isGroup) {
            listname = ResourceUtil.getString("org.group_post_form.list");
        }
		DataUtil.putImpExpAction(u.getId(), "export");
		DataRecord dataRecord=null;
        try {
            dataRecord = exportPost(request, response, fileToExcelManager, orgManagerDirect, accountId, isGroup);
        } catch (Exception e) {
            DataUtil.removeImpExpAction(u.getId());
            throw e;
        }
		DataUtil.removeImpExpAction(u.getId());
		OrgHelper.exportToExcel(request, response, fileToExcelManager, listname, dataRecord);		
		return null;
	}

    private DataRecord exportPost(HttpServletRequest request, HttpServletResponse response, FileToExcelManager fileToExcelManager, OrgManagerDirect orgManagerDirect, Long accountId, boolean isGroup) throws Exception {
		DataRecord dataRecord = new DataRecord();
		Pagination.setNeedCount(false);
		String condition = request.getParameter("condition");
		//ParamUtil.
		if(!"".equals(condition)){
			JSONUtil.parseJSONString(condition);
		}
		List<V3xOrgPost> postlist = orgManagerDirect.getAllPosts(accountId,true);
		//Map orgMeta = metadataManager.getMetadataMap(ApplicationCategoryEnum.organization);
		//MetadataItem item = null;
		V3xOrgPost post = null;
		V3xOrgAccount account = null;
		// 导出excel文件的国际化
		String state_Enabled = ResourceUtil.getString("org.account_form.enable.use");
		String state_Disabled = ResourceUtil.getString("org.account_form.enable.unuse");
		String post_name = ResourceUtil.getString("org.post_form.name");
		String post_type = ResourceUtil.getString("org.post_form.type");
		String post_code = ResourceUtil.getString("org.post_form.type.code");
		/*String post_sortId = ResourceUtil.getString("org.post_form.type.sort");*/
		String post_state = ResourceUtil.getString("org.state.lable");
		String post_account = ResourceUtil.getString("org.account.lable");
		/*String post_description = ResourceUtil.getString("org.post_form.description");*/
		String post_list = ResourceUtil.getString("org.post_form.list");
		/*String post_deptName = ResourceUtil.getString("org.member_form.deptName.label");*/
		if (null != postlist && postlist.size() > 0) {
			DataRow[] datarow = new DataRow[postlist.size()];
			for (int i = 0; i < postlist.size(); i++) {
				String typeName = "";
				post = postlist.get(i);
				DataRow row = new DataRow();
				//获取岗位类别
				CtpEnumItem item = getEnumManager().getEnumItem(EnumNameEnum.organization_post_types, post.getTypeId().toString());
                if(item != null){
                    typeName = ResourceUtil.getString(item.getLabel());
                }else{
                    logger.info("岗位: "+post.getName()+" 对应的岗位类别不存在！");
                }
				
				
				row.addDataCell(post.getName(), 1);
				row.addDataCell(post.getCode(), 1);
				row.addDataCell(typeName, 1);
				
                if (!isGroup) {
                    account = orgManager.getAccountById(post.getOrgAccountId());
                    row.addDataCell(account.getName(), 1);
                }
				
				if (post.getEnabled()) {
					row.addDataCell(state_Enabled, 1);
				} else {
					row.addDataCell(state_Disabled, 1);
				}
				/*
				row.addDataCell(post.getSortId().toString(), 1);
				row.addDataCell(post.getDesciption(), 1);
				
						
				
				List<V3xOrgDepartment> deps=getDeptmentsByPost(post);
				String depStr=deptsToString(deps);
				row.addDataCell(depStr, 1);	
				*/
				datarow[i] = row;
			}

			try {
				dataRecord.addDataRow(datarow);
			} catch (Exception e) {
				//log.error("error", e);
			}
		}
        String[] columnName = null;
        if (isGroup) {
            columnName = new String[] { post_name, post_code, post_type, post_state };
        } else {
            columnName = new String[] { post_name, post_code, post_type, post_account, post_state };
        }
		//{   post_name ,post_code , post_type ,post_sortId , post_state ,post_description, post_account,post_deptName  };
		dataRecord.setColumnName(columnName);
		dataRecord.setTitle(post_list);
		dataRecord.setSheetName(post_list);
		return dataRecord;
	}
}
