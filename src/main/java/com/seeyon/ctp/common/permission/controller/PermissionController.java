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

package com.seeyon.ctp.common.permission.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.permission.bo.CustomAction;
import com.seeyon.ctp.common.permission.bo.NodePolicy;
import com.seeyon.ctp.common.permission.bo.Permission;
import com.seeyon.ctp.common.permission.bo.PermissionOperation;
import com.seeyon.ctp.common.permission.manager.PermissionManager;
import com.seeyon.ctp.common.permission.vo.PermissionVO;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.ReqUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;



/**
 * @author mujun
 *
 */
public class PermissionController extends BaseController{
    private PermissionManager permissionManager;
    private AppLogManager     appLogManager;
    public PermissionManager getPermissionManager() {
        return permissionManager;
    }
    public void setPermissionManager(PermissionManager permissionManager) {
        this.permissionManager = permissionManager;
    }
  
    
    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }
    /**
     * 节点权限列表
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    //客开 @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
    public ModelAndView list(HttpServletRequest request,
            HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView("common/permission/list");
        //类别 判断是否是协同节点权限
        //EnumNameEnum.col_flow_perm_policy.name()
        String category = request.getParameter("category");
        if("info".equals(category)){
        	//权限判断
    		boolean hasAuth=AppContext.hasResourceCode("F18_infoReport");
    		if(!hasAuth){
    			return null;
    		}
        }
        Map<String,String> args = new HashMap<String, String>();
        args.put("configCategory", category);
        FlipInfo fi = new FlipInfo();
        fi = permissionManager.getPermissions(fi,args);
        //缓存分页 传参
        fi.setParams(args);
        //V5.1-G6--V51-4-6 登记显示为分发
        if(isG6Version()){
            for(PermissionVO p:(List<PermissionVO>)fi.getData()){
            	if(p.getType()==0 && "edoc_rec_permission_policy".equals(p.getCategory()) && "登记".equals(p.getLabel())){
            		p.setLabel("分发");
            	}else if(p.getType()==0 && "edoc_rec_permission_policy".equals(p.getCategory()) && "Register".equals(p.getLabel())){
            		p.setLabel("Distribute");
            	}else if(p.getType()==0 && "edoc_rec_permission_policy".equals(p.getCategory()) && "登記".equals(p.getLabel())){
            		p.setLabel("分發");
            	}
            }
        }
        request.setAttribute("ffpermissionList", fi);
        mav.addObject("category",category); 
        return mav;
    }
    
    /**
     * 保存节点权限
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     * @throws IOException 
     */
    @SuppressWarnings("unchecked")
    @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
    public ModelAndView save(HttpServletRequest request,
            HttpServletResponse response) throws BusinessException, IOException {
        User user = AppContext.getCurrentUser();
        //当前用户登录的单位的id
        long orgAccountId = user.getLoginAccount();
        //获得页面的数据
        Map params = ParamUtil.getJsonParams();
        Permission permission = new Permission();
        //定义 NodePolicy类
        NodePolicy nodePolicy = new NodePolicy();
        ParamUtil.mapToBean(params, permission, true);
        ParamUtil.mapToBean(params, nodePolicy, true);
        //自定义节点权限  name和label的值是一样的
        if(Strings.isBlank(permission.getLabel())){
        	permission.setLabel(permission.getName());
        }
        //判断category是否为公文,如果是公文，则需要具体判断是发文、收文、签报
        String category = permission.getCategory();
        /** V51 F18 信息报送  start */
        if(EnumNameEnum.info_send_permission_policy.name().equals(category)) {
        	category = "info";
        } else if(!EnumNameEnum.col_flow_perm_policy.name().equals(category)) {
            category = "edoc";
        }
        /** V51 F18 信息报送  end */
        Object basicOperation =  params.get("basicOperation");
        String basic = "";
        if(basicOperation!=null){
            basic = basicOperation.toString().replace("[", "");
            basic = basic.replace("]", "").replace("\"", "");;
        }
        nodePolicy.setBaseAction(basic);
        Object commonOperation = params.get("commonOperation");
        String common = "";
        if(commonOperation!=null){
            common = commonOperation.toString().replace("[", "");
            common = common.replace("]", "").replace("\"", "");;
        }
        nodePolicy.setCommonAction(common);
        Object advancedOperation = params.get("advancedOperation");
        String advanced = "";
        if(advancedOperation!=null){
            advanced = advancedOperation.toString().replace("[", "");
            advanced = advanced.replace("]","").replace("\"", "");;
        }
        //不同意自定义
        if(EnumNameEnum.col_flow_perm_policy.name().equals(permission.getCategory())) {
        	CustomAction customAction = new CustomAction();
	        String isOptional = ParamUtil.getString(params, "isOptional","1");
	        String optionalAction = ParamUtil.getString(params,"optionalAction","Continue,Terminate,Return,Cancel");
	        String defaultAction = ParamUtil.getString(params,"defaultAction","Continue");
	        customAction.setIsOptional(isOptional);
	        customAction.setOptionalAction(optionalAction);
	        customAction.setDefaultAction(defaultAction);
	        nodePolicy.setCustomAction(customAction);
    	}
        
        nodePolicy.setAdvancedAction(advanced);
        permission.setOrgAccountId(orgAccountId);
        permission.setNodePolicy(nodePolicy);
        permissionManager.savePermission(permission);
        //记录日志
        if("edoc".equals(category)){
            appLogManager.insertLog(user, AppLogAction.Edoc_FlowPrem_Create,user.getName(),permission.getName());
        } else if("info".equals(category)) {
        	/** V51 F18 信息报送  start V51 TODO */
        	/** V51 F18 信息报送  end */
			appLogManager.insertLog(user, AppLogAction.Information_permission_Create, user.getName(),permission.getName());
        } else{
            appLogManager.insertLog(user, AppLogAction.Coll_FlowPrem_Create, user.getName(), permission.getName());
        }
        PrintWriter pw = response.getWriter();
        pw.write(category);
        pw.flush();
        return null;
    }
    /**
     * 节点权限操作说明
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
    public ModelAndView settingDesc(HttpServletRequest request,
            HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView("common/permission/settingDesc");
        mav.addObject("size", request.getParameter("size"));
        return mav;
    }
    
    /**
     * 更新
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     * @throws IOException 
     */
    @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
    public ModelAndView update(HttpServletRequest request,
            HttpServletResponse response) throws BusinessException, IOException {
        User user = AppContext.getCurrentUser();
        //当前用户登录的单位的id
        long orgAccountId = user.getLoginAccount();
        //获得页面的数据
        Map params = ParamUtil.getJsonParams();
        Permission permission = new Permission();
        //定义 NodePolicy类
        NodePolicy nodePolicy = new NodePolicy();
        ParamUtil.mapToBean(params, permission, true);
        ParamUtil.mapToBean(params, nodePolicy, true);
        Object basicOperation =  params.get("basicOperation");
        String basic = "";
        if(basicOperation!=null){
            basic = basicOperation.toString().replace("[", "");
            basic = basic.replace("]", "").replace("\"", "");
        }
        nodePolicy.setBaseAction(basic);
        Object commonOperation = params.get("commonOperation");
        String common = "";
        if(commonOperation!=null){
            common = commonOperation.toString().replace("[", "");
            common = common.replace("]", "").replace("\"", "");
        }
        nodePolicy.setCommonAction(common);
        Object advancedOperation = params.get("advancedOperation");
        String advanced = "";
        if(advancedOperation!=null){
            advanced = advancedOperation.toString().replace("[", "");
            advanced = advanced.replace("]","").replace("\"", "");
        }
        
        //不同意自定义
        if(EnumNameEnum.col_flow_perm_policy.name().equals(permission.getCategory())) {
        	CustomAction customAction = new CustomAction();
	        String isOptional = String.valueOf(params.get("isOptional"));
	        String optionalAction = String.valueOf(params.get("optionalAction"));
	        String defaultAction = String.valueOf(params.get("defaultAction"));
	        customAction.setIsOptional(isOptional);
	        customAction.setOptionalAction(optionalAction);
	        customAction.setDefaultAction(defaultAction);
	        nodePolicy.setCustomAction(customAction);
    	}
        
        nodePolicy.setAdvancedAction(advanced);
        permission.setOrgAccountId(orgAccountId);
        permission.setNodePolicy(nodePolicy);
        
        permissionManager.updatePermission(permission);
       
        if(EnumNameEnum.col_flow_perm_policy.name().equals(permission.getCategory())){//协同日志
            appLogManager.insertLog(user, AppLogAction.Coll_FlowPrem_Edit, user.getName(),permission.getLabel());
        } else if(EnumNameEnum.info_send_permission_policy.name().equals(permission.getCategory())) {//信息日志
        	/** V51 F18 信息报送  start V51 TODO */
        	/** V51 F18 信息报送  end */
			appLogManager.insertLog(user, AppLogAction.Information_permission_Modify, user.getName(),permission.getLabel());
        } else{//公文日志
            appLogManager.insertLog(user, AppLogAction.Edoc_FlowPermModify,user.getName(),permission.getLabel());
        }
       
    
        String category = permission.getCategory();
        /** V51 F18 信息报送  start */
        if(EnumNameEnum.info_send_permission_policy.name().equals(category)) {
        	category = "info";
        }
        /** V51 F18 信息报送  end */
        else if(!EnumNameEnum.col_flow_perm_policy.name().equals(category)){
            category = "edoc";
        }
        PrintWriter pw = response.getWriter();
        pw.write(category);
        pw.flush();
        return null;
    }
    /**
     * 删除
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    public ModelAndView delete(HttpServletRequest request,
            HttpServletResponse response) throws BusinessException {
        return null ;
    }
    /**
     * 节点权限说明
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    public ModelAndView desc(HttpServletRequest request,
            HttpServletResponse response) throws BusinessException {
        String category = request.getParameter("category");
        if("info_send_permission_policy".equals(category)){
        	//权限判断
    		boolean hasAuth=AppContext.hasResourceCode("F18_infoReport");
    		if(!hasAuth){
    			return null;
    		}
        }
        ModelAndView mav = new ModelAndView("common/permission/description");
        mav.addObject("category", category);
        return mav ;
    }
    /**
     * 节点权限选择操作
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
    public ModelAndView operationChoose(HttpServletRequest request,
            HttpServletResponse response) throws BusinessException {
    	ModelAndView mav = new ModelAndView("common/permission/operation_choose");
        String param = request.getParameter("param");
        String notInclude = request.getParameter("notInclude");
        String exists = request.getParameter("exists");
        String isEdoc = request.getParameter("isEdoc");
        if("info_send_permission_policy".equals(isEdoc)){
        	//权限判断
    		boolean hasAuth=AppContext.hasResourceCode("F18_infoReport");
    		if(!hasAuth){
    			return null;
    		}
        }
        String permissionName = request.getParameter("permissionName");
        //常用、高级操作
        List<PermissionOperation> metadata1 = null;
        //基本操作
        List<PermissionOperation> metadata2 = null;
        if(EnumNameEnum.col_flow_perm_policy.name().equals(isEdoc)){
            //协同节点权限操作
            metadata1 = permissionManager.getPermissionOperation(EnumNameEnum.node_control_action);
            metadata2 = permissionManager.getPermissionOperation(EnumNameEnum.col_basic_action);
            
         
            
            
            //去掉转办
            if ("inform".equals(permissionName) 
            		||	"read".equals(permissionName)
            		|| "newCol".equals(permissionName)
            		|| "formaudit".equals(permissionName)
            		|| "vouch".equals(permissionName)) {
            	this.removeItem(metadata1, "Transfer");
            }
            if("newCol".equals(permissionName)){
                metadata2.addAll(metadata1);
                PermissionVO permission = permissionManager.getPermission(Long.valueOf(2309L));
                String basic = permission.getBasicOperation();
                List<PermissionOperation> basicList = new ArrayList<PermissionOperation>(); 
                if(Strings.isNotBlank(basic)){
                    String[] basicOperation = basic.split(",");
                    for(int i=0;i<basicOperation.length;i++){
                        for(PermissionOperation cei:metadata2){
                            if(cei.getKey().equals(basicOperation[i].trim())){
                                basicList.add(cei);
                                break;
                            }
                        }
                    }
                }
                metadata2 = basicList;
                metadata1 = Collections.emptyList();
            } else {//基本操作里面不能有发起节点的东西。需要移除。xml里面没有区分
                List<PermissionOperation> removePermission = new ArrayList<PermissionOperation>();
                List<String> removeNames = CommonTools.newArrayList("EditWorkFlow", "Pigeonhole", "RepeatSend","ReMove");
                for (PermissionOperation po : metadata2) {
                    if (removeNames.contains(po.getKey())) {
                        removePermission.add(po);
                    }
                }
                metadata2.removeAll(removePermission);
            }

            //<中信达>客开:会商  start\\
            PermissionOperation e = new PermissionOperation();
            e.setKey("huiShang");
            e.setLabel("permission.operation.huiShang");
            metadata1.add(e);
            //<中信达>客开:会商  end\\

        } else if(EnumNameEnum.info_send_permission_policy.name().equals(isEdoc)) {
            //信息节点权限操作
            metadata1 = permissionManager.getPermissionOperation(EnumNameEnum.info_node_control_action);//高级操作
            metadata2 = permissionManager.getPermissionOperation(EnumNameEnum.info_basic_action);//基础操作
        } else {
            //公文节点权限操作
            //阅读权限特殊处理。
			if("yuedu".equals(permissionName) && ("edoc_send_permission_policy".equals(isEdoc)||"edoc_qianbao_permission_policy".equals(isEdoc))){
				metadata1 = new ArrayList<PermissionOperation>();
				//添加'知会'
				PermissionOperation infom = new PermissionOperation();
				infom.setKey("Infom");
				infom.setLabel("permission.operation.Infom");
				metadata1.add(infom);
				//添加'传阅'
				PermissionOperation passRead = new PermissionOperation();
				passRead.setKey("PassRead");
				passRead.setLabel("permission.operation.PassRead");
				metadata1.add(passRead);
				//添加'转公告'
				PermissionOperation transmitBulletin = new PermissionOperation();
				transmitBulletin.setKey("TransmitBulletin");
				transmitBulletin.setLabel("permission.operation.TransmitBulletin");
				metadata1.add(transmitBulletin);
				//添加'部门归档'
				PermissionOperation departPigeonhole = new PermissionOperation();
				departPigeonhole.setKey("DepartPigeonhole");
				departPigeonhole.setLabel("permission.operation.DepartPigeonhole");
				metadata1.add(departPigeonhole);
				//添加'终止'
				PermissionOperation terminate = new PermissionOperation();
				terminate.setKey("Terminate");
				terminate.setLabel("permission.operation.Terminate");
				metadata1.add(terminate);
				//添加'文单签批'
				PermissionOperation htmlSign = new PermissionOperation();
				htmlSign.setKey("HtmlSign");
				htmlSign.setLabel("permission.operation.HtmlSign");
				metadata1.add(htmlSign);
				//添加'文单签批'
				PermissionOperation zsj = new PermissionOperation();
				zsj.setKey("Transform");
				zsj.setLabel("permission.operation.Transform");
				metadata1.add(zsj);
				//<中信达>客开: 会商 start\\
                PermissionOperation e = new PermissionOperation();
                e.setKey("huiShang");
                e.setLabel("permission.operation.huiShang");
                metadata1.add(e);
                //<中信达>客开:会商 end\\
			}else{
				metadata1 = permissionManager.getPermissionOperation(EnumNameEnum.edoc_node_control_action);
				if("yuedu".equals(permissionName) && ("edoc_rec_permission_policy".equals(isEdoc))){
					//移除移交(收文阅读)
					this.removeItem(metadata1, "Transfer");
				}

				//<中信达>客开:会商  start\\
                PermissionOperation e = new PermissionOperation();
                e.setKey("huiShang");
                e.setLabel("permission.operation.huiShang");
                metadata1.add(e);
                //<中信达>客开:会商  end\\
			}
			//公文中基本操作当是收文、签报时，要去掉‘交换类型’
			metadata2 = permissionManager.getPermissionOperation(EnumNameEnum.edoc_basic_action);
			if("edoc_rec_permission_policy".equals(isEdoc)||"edoc_qianbao_permission_policy".equals(isEdoc)){
				this.removeItem(metadata2, "EdocExchangeType");
			}
			
			//收文节点权限 添加转收文操作
			if("edoc_send_permission_policy".equals(isEdoc)||"edoc_qianbao_permission_policy".equals(isEdoc)||"zhihui".equals(permissionName)){
				this.removeItem(metadata1, "TurnRecEdoc");
			}
        }
        
        
        
        removePartActionByPlugin(metadata2, metadata1, null);
        
       
        //如果没有安装office控件,屏蔽盖章,稿纸,套红,文单签批策略
        if(SystemEnvironment.hasPlugin("officeOcx")==false)
        {
//            metadata1 = this.removeItem(metadata1,2223L);//盖章
//            metadata1 = this.removeItem(metadata1,2304L);//套红
//            metadata1 = this.removeItem(metadata1,2307L);//稿纸
//            metadata1 = this.removeItem(metadata1,2306L);//文单签批
        }

        List<PermissionOperation> rightList = new ArrayList<PermissionOperation>();
        List<PermissionOperation> leftList = new ArrayList<PermissionOperation>();
        //当时常用操作编辑或者高级操作 编辑时 要相互排除
        if(!"".equals(param) && ("common".equals(param) || "advanced".equals(param))){ 
            String[] val = null;
            if(Strings.isNotBlank(notInclude)){
                val = notInclude.split(",");
                String[] exitsData = exists.split(","); 
                leftList = this.getItemList(metadata1,val,leftList,false);
                rightList = this.getItemList(metadata1,exitsData,rightList, true);
                mav.addObject("metadata", leftList);
                mav.addObject("existMetaData", rightList);
            }else{
                mav.addObject("metadata", metadata1);
            }
        }else if(!"".equals(param) && "basic".equals(param)){
            if(Strings.isNotBlank(notInclude)){
                String[] val = notInclude.split(",");
                String[] exitsData = exists.split(","); 
                leftList = this.getItemList(metadata2,val,leftList,false);
                rightList = this.getItemList(metadata2,exitsData,rightList, true);
                mav.addObject("metadata", leftList);
                mav.addObject("existMetaData", rightList);
            }else {
                mav.addObject("metadata", metadata2);
            }
            
        }
        // 指定回退再处理时流转的方式
        mav.addObject("submitStyle", ReqUtil.getString(request, "submitStyle", ""));
        return mav;
    }
    
    private List<PermissionOperation> removeItem(List<PermissionOperation> itemList,String key){
        if(itemList != null && itemList.size()>0){
			for(Iterator<PermissionOperation> item = itemList.iterator();item.hasNext();){
				PermissionOperation po = item.next();
				if(po.getKey().equals(key)){
					item.remove();
					break;
				}
			}
        }
        return itemList;
    }
    /**
     * 如果ifExists==true，则从itemList中取为ids值的数据
     * 如果ifExists==false，则从itemList中移除掉为ids值的数据
     * @param itemList
     * @param ids
     * @param ifExists
     * @return
     */
    private List<PermissionOperation> getItemList(List<PermissionOperation> source,String[] keys,
            List<PermissionOperation> target,boolean ifExists){
        if(keys==null||keys.length==0){
            return source;
        }
        if(source!=null&&source.size()>0){
                if(ifExists){
                    for(int i=0;i<keys.length;i++){
                        for (PermissionOperation item : source) {
                            if(item.getKey().equals(keys[i])){
                                target.add(item);
                                break;
                            }
                        }
                    }
                }else{
                    for (PermissionOperation item : source) {
                        int flag = 0;
                        for(int i=0;i<keys.length;i++){
                            if(item.getKey().equals(keys[i])){
                                flag = 0;
                                break;
                            }else{
                                flag++;
                            }
                        }
                        if(flag>0){
                            target.add(item);
                        }
                    }
                }
        }
        return target;
    }
    /**
     * 编辑节点权限
     * 页面链接 跳转
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
    public ModelAndView edit(HttpServletRequest request,
            HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView("common/permission/edit");
        String id = request.getParameter("id");
        PermissionVO permission = permissionManager.getPermission(Long.parseLong(id));
        String category = permission.getCategory();
        //常规节点(常用、高级)操作
        List<PermissionOperation> metadata1 = null;
        //基础节点
        List<PermissionOperation> metadata2 = null;
        if(EnumNameEnum.col_flow_perm_policy.name().equals(category)){
            //协同节点权限操作
            metadata1 = permissionManager.getPermissionOperation(EnumNameEnum.node_control_action);
            metadata2 = permissionManager.getPermissionOperation(EnumNameEnum.col_basic_action);
            //<中信达>客开:会商 start\\
            PermissionOperation e = new PermissionOperation();
            e.setKey("huiShang");
            e.setLabel("permission.operation.huiShang");
            metadata1.add(e);
            //<中信达>客开:会商 end\\
            CustomAction customAction = permission.getCustomAction();
            if (customAction != null) {
            	mav.addObject("isOptional", customAction.getIsOptional());
                mav.addObject("optionalAction",customAction.getOptionalAction());
                mav.addObject("defaultAction", customAction.getDefaultAction());
            }
            //如果选中的是协同新建，那么所有的都会在基本操作，其它为空
            if("newCol".equals(permission.getName())){
                metadata2.addAll(metadata1);
                metadata1 = Collections.emptyList();
                mav.addObject("isNewCol", Boolean.TRUE);
                mav.addObject("newColCss","hidden");
            }
        }
        /** V51 F18 信息报送  start */
        else if(EnumNameEnum.info_send_permission_policy.name().equals(category)) {
        	//信息报送节点权限操作
            metadata1 = permissionManager.getPermissionOperation(EnumNameEnum.info_node_control_action);//高级操作
            metadata2 = permissionManager.getPermissionOperation(EnumNameEnum.info_basic_action);//基础操作
        } 
        /** V51 F18 信息报送  end */
        else{
            //公文节点权限操作
            metadata1 = permissionManager.getPermissionOperation(EnumNameEnum.edoc_node_control_action);
            metadata2 = permissionManager.getPermissionOperation(EnumNameEnum.edoc_basic_action);
            //<中信达>客开:会商 start\\
            PermissionOperation e = new PermissionOperation();
            e.setKey("huiShang");
            e.setLabel("permission.operation.huiShang");
            metadata1.add(e);
            //<中信达>客开:会商 end\\
        }
        String submitStyleFrom = "";
        //已选中的基本操作
        String basic = permission.getBasicOperation();
        List<PermissionOperation> basicList = new ArrayList<PermissionOperation>(); 
        if(Strings.isNotBlank(basic)){
            String[] basicOperation = basic.split(",");
            for(int i=0;i<basicOperation.length;i++){
                for(PermissionOperation cei:metadata2){
                    if(cei.getKey().equals(basicOperation[i].trim())){
                        basicList.add(cei);
                        break;
                    }
                }
            }
        }
        
        //已选中的高级操作
        String advanced = permission.getAdvancedOperation();
        if(Strings.isNotBlank(advanced)) {
	        if(advanced.indexOf("SpecifiesReturn") != -1){
	            submitStyleFrom = "advanced";
	        }
        }
        List<PermissionOperation> advancedList = new ArrayList<PermissionOperation>(); 
        if(Strings.isNotBlank(advanced)){
            String[] advancedOperation = advanced.split(",");
            for(int i=0;i<advancedOperation.length;i++){
                for(PermissionOperation cei:metadata1){
                    if(cei.getKey().equals(advancedOperation[i].trim())){
                        advancedList.add(cei);
                        break;
                    }
                }
            }
        }
        
       //已选中的常用操作
        String common = permission.getCommonOperation();
        if(Strings.isNotBlank(common)) {
	        if(common.indexOf("SpecifiesReturn") != -1){
	            submitStyleFrom = "common";
	        }
        }
        List<PermissionOperation> commonList = new ArrayList<PermissionOperation>(); 
        if(Strings.isNotBlank(common)){
            String[] commonOperation = common.split(",");
            for(int i=0;i<commonOperation.length;i++){
                for(PermissionOperation cei:metadata1){
                    if(cei.getKey().equals(commonOperation[i].trim())){
                        commonList.add(cei);
                        break;
                    }
                }
            }
        }
        
        //V5.1-G6--V51-4-6 登记显示为分发
        if(isG6Version()){
        	if(permission.getType()==0 && "edoc_rec_permission_policy".equals(permission.getCategory()) && "登记".equals(permission.getLabel())){
        		permission.setLabel("分发");
        	}else if(permission.getType()==0 && "edoc_rec_permission_policy".equals(permission.getCategory()) && "Register".equals(permission.getLabel())){
        		permission.setLabel("Distribute");
        	}else if(permission.getType()==0 && "edoc_rec_permission_policy".equals(permission.getCategory()) && "登記".equals(permission.getLabel())){
        		permission.setLabel("分發");
        	}
            
        }
        
        removePartActionByPlugin(basicList,commonList,advancedList);
                
        mav.addObject("basicList",basicList);
        mav.addObject("advancedList",advancedList);
        mav.addObject("commonList",commonList);
        //操作类型，是添加节点还是编辑(修改、展示)节点
        mav.addObject("operType",request.getParameter("operType"));
        //判断是展示节点还是修改节点
        mav.addObject("flag", request.getParameter("flag"));
        mav.addObject("category", category);
        request.setAttribute("ffpermission_edit_form", permission);
        request.setAttribute("defaultAttitude", permission.getDefaultAttitude());
        mav.addObject("submitStyleFrom", submitStyleFrom);
        mav.addObject("opinionPolicy", permission.getOpinionPolicy());
        mav.addObject("submitStyle", permission.getSubmitStyle());
        return mav ;
    }
    private void remove(String key,List<PermissionOperation> list) {
    	if(Strings.isNotEmpty(list)){
    		for(Iterator<PermissionOperation> it = list.iterator();it.hasNext();){
    			PermissionOperation po = it.next();
    			if(key.equals(po.getKey())){
    				it.remove();
    			}
    		}
    	}
    }
    private void removePartActionByPlugin(List<PermissionOperation> basicList, List<PermissionOperation> commonList, List<PermissionOperation> advancedList) {
		if(!AppContext.hasPlugin("doc")){
			remove("Pigeonhole", basicList);
			remove("Archive", basicList);
			
			//公文部门归档
			remove("DepartPigeonhole", commonList);
			remove("DepartPigeonhole", advancedList);	
		}
		
		if(!AppContext.hasPlugin("calendar")){
			remove("Transform", commonList);
			remove("Transform", advancedList);
		}
		if(!AppContext.hasPlugin("bulletin")){//转公告-公文
			remove("TransmitBulletin", commonList);
			remove("TransmitBulletin", advancedList);
		}
	}
	/**
     * 新添加节点权限 
     * 页面链接 跳转
     * @param request
     * @param response
     * @return
     * @throws BusinessException
     */
    @CheckRoleAccess(roleTypes={Role_NAME.AccountAdministrator,Role_NAME.EdocManagement})
    public ModelAndView newPermission(HttpServletRequest request,
            HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView("common/permission/edit");
        String category = request.getParameter("category");
        if("info".equals(category)){
        	//权限判断
    		boolean hasAuth=AppContext.hasResourceCode("F18_infoReport");
    		if(!hasAuth){
    			return null;
    		}
        }
        mav.addObject("operType",request.getParameter("operType"));
        mav.addObject("category", category);
        return mav ;
    }
    
    /**
	 * 首页配置节点权限。
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView showPerom4Portal(HttpServletRequest request,HttpServletResponse response) throws Exception{
		String pageView = "common/permission/showPerm4Portal";
		/*if(com.seeyon.apps.doc.util.Constants.isGovVer()){
			pageView = "common/permission/showPerm4PortalGov";
		}*/
		ModelAndView modelAndView = new ModelAndView(pageView);
		String openFrom=request.getParameter("openFrom");
		//trackSection
		User user = AppContext.getCurrentUser();
		Long loginAccount = user.getLoginAccount();
		//查询协同节点
		List<Permission> listCol = permissionManager.getPermissionsByCategory(EnumNameEnum.col_flow_perm_policy.name(), loginAccount);
		modelAndView.addObject("listCol", listCol);
		if(SystemEnvironment.hasPlugin("edoc") && user.isInternal()){
			//发文
			List<Permission> listFa = permissionManager.getPermissionsByCategory(EnumNameEnum.edoc_send_permission_policy.name(), loginAccount);
			//收文
			List<Permission> listShou = permissionManager.getPermissionsByCategory(EnumNameEnum.edoc_rec_permission_policy.name(), loginAccount);
			//签报
			List<Permission> listQian = permissionManager.getPermissionsByCategory(EnumNameEnum.edoc_qianbao_permission_policy.name(), loginAccount);
			modelAndView.addObject("listFa", listFa);
			// TODO 解耦
			//是否开启区分办文、阅文开关
			boolean showBanwenYuewen=false;
//			boolean showBanwenYuewen=EdocSwitchHelper.showBanwenYuewen(loginAccount);
			List<Permission> listShouTemp=new ArrayList<Permission>();
			//非待办列表，不显示登记、分发
			if(!"pendingSection".equals(openFrom)){//
				//不包含登记
				for(Permission perm:listShou){
					if("dengji".equals(perm.getName())||"regist".equals(perm.getName())){
						listShouTemp.add(perm);
					}
				}
			}else{
				// TODO 解耦
/*				if(isG6Version()&&!EdocHelper.hasEdocRegister()){//G6 版本并且关闭了登记开关，不显示登记
					//不包含登记
					for(Permission perm:listShou){
						if("regist".equals(perm.getName())){
							listShouTemp.add(perm);
							break;
						}
					}
				}*/
			}
			listShou.removeAll(listShouTemp);
			listShouTemp.clear();//清空，下面还需要使用
			//区分阅文、办文
			if(showBanwenYuewen){
				//不包含登记
				for(Permission perm:listShou){
					if("dengji".equals(perm.getName())){
						modelAndView.addObject("dengjiPerm", perm);
					}else{
						listShouTemp.add(perm);
					}
				}
			}else{
				listShouTemp.addAll(listShou);
			}
			modelAndView.addObject("showBanwenYuewen",showBanwenYuewen);
			modelAndView.addObject("listShou", listShouTemp);
			modelAndView.addObject("shouSize", listShouTemp.size());
			modelAndView.addObject("listQian", listQian);
			// TODO 解耦
//			modelAndView.addObject("isOpenRegister",EdocSwitchHelper.isOpenRegister());
			modelAndView.addObject("isG6Version", isG6Version());
		}
		modelAndView.addObject("openFrom",openFrom);//来自哪个栏目
		if(SystemEnvironment.hasPlugin("infosend") && user.isInternal()){
			//信息报送
			List<Permission> listInfo = permissionManager.getPermissionsByCategory("info_send_permission_policy", loginAccount);
			modelAndView.addObject("listInfo", listInfo);
		}
		return modelAndView;
	}
	
	/**
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView settingSpecifiesReturn(HttpServletRequest request,HttpServletResponse response) throws Exception{
	    ModelAndView modelAndView = new ModelAndView("common/permission/settingSpecifiesReturn");
	    // 指定回退再处理时流转的方式
	    modelAndView.addObject("submitStyle", ReqUtil.getString(request, "submitStyle", ""));
	    return modelAndView;
	}
    private boolean isG6Version(){
    	return (Boolean)SysFlag.sys_isGovVer.getFlag();
    }	
}
