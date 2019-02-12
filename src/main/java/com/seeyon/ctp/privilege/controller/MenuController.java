/**
 * $Author: gaohang $
 * $Rev: 18735 $
 * $Date:: #$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.privilege.controller;

/**
 * <p>Title: 菜单controller类</p>
 * <p>Description: 本程序实现菜单操作请求的处理</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 */
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ProductVersionEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.privilege.bo.PrivMenuBO;
import com.seeyon.ctp.privilege.bo.PrivTreeNodeBO;
import com.seeyon.ctp.privilege.manager.PrivilegeMenuManager;
public class MenuController extends BaseController {

    /** */
	private PrivilegeMenuManager privilegeMenuManager;

    /** */
    FileManager     fileManager;
    /** */
    OrgManager orgManager;

    public ModelAndView create(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setAttribute("appResCategory", request.getParameter("appResCategory"));
        request.setAttribute("productVersion", request.getParameter("productVersion"));
        request.setAttribute("target", 1);
        return new ModelAndView("apps/privilege/menu/menuNew");
    }

    public ModelAndView showList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String[] canonicalVersions = getVersions(false);
        request.setAttribute("ffcanonicalVersions", canonicalVersions);
        return new ModelAndView("apps/privilege/menu/menuList");
    }

    public ModelAndView edit(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long menuId = Long.parseLong(request.getParameter("id"));
        PrivMenuBO menu = (PrivMenuBO) privilegeMenuManager.findById(menuId);
        Map<String, Object> resMap = new ConcurrentHashMap<String, Object>();
        resMap.put("id", String.valueOf(menu.getId()));
        resMap.put("name", menu.getName());
        resMap.put("icon", menu.getIcon());
//        resMap.put("sortid", menu.getSortid());
//        // 是否虚节点
//        boolean isVirtualNode = menu.getIsVirtualNode();
//        request.setAttribute("target", isVirtualNode ? 1 : 0);
//        if (!isVirtualNode) {
//            Long resourceId = menu.getEnterResourceId();
//            PrivResource res = privilegeManage.findResourceById(resourceId);
//            if (res != null) {
//                resMap.put("enterResourceId", resourceId);
//                resMap.put("enterResourceName", res.getResourceName());
//                resMap.put("enterResourceUrl", res.getNavurl());
//                resMap.put("opentype", menu.getTarget());
//            }
//            // 导航资源
//            @SuppressWarnings("rawtypes")
//            List naviResIds = menu.getNaviResourceIds();
//            if (naviResIds != null) {
//                StringBuilder naviResName = new StringBuilder();
//                StringBuilder naviResUrl = new StringBuilder();
//                StringBuilder naviResId = new StringBuilder();
//                for (int i = 0; i < naviResIds.size(); i++) {
//                    res = privilegeManage.findResourceById(Long.parseLong(String.valueOf(naviResIds.get(i))));
//                    if (res != null) {
//                        if (i != 0) {
//                            naviResName.append(",");
//                            naviResUrl.append("\n");
//                            naviResId.append(",");
//                        }
//                        naviResName.append(res.getResourceName());
//                        naviResUrl.append(res.getNavurl());
//                        naviResId.append(res.getId());
//                    }
//                }
//                resMap.put("naviResName", naviResName.toString());
//                resMap.put("naviResUrl", naviResUrl.toString());
//                resMap.put("naviResIds", naviResId.toString());
//            }
//            // 快捷资源
//            @SuppressWarnings("rawtypes")
//            List shortcutResIds = menu.getShortcutResourceIds();
//            if (shortcutResIds != null) {
//                StringBuilder shortcutResName = new StringBuilder();
//                StringBuilder shortcutResUrl = new StringBuilder();
//                StringBuilder shortcutResId = new StringBuilder();
//                for (int i = 0; i < shortcutResIds.size(); i++) {
//                    res = privilegeManage.findResourceById(Long.parseLong(String.valueOf(shortcutResIds.get(i))));
//                    if (res != null) {
//                        if (i != 0) {
//                            shortcutResName.append(",");
//                            shortcutResUrl.append("\n");
//                            shortcutResId.append(",");
//                        }
//                        shortcutResName.append(res.getResourceName());
//                        shortcutResUrl.append(res.getNavurl());
//                        shortcutResId.append(res.getId());
//                    }
//                }
//                resMap.put("shortCutResourceName", shortcutResName.toString());
//                resMap.put("shortCutResourceUrl", shortcutResUrl.toString());
//                resMap.put("shortCutResourceId", shortcutResId.toString());
//                resMap.put("shortcutdefult", menu.getExt20());
//            }
//        }
//        resMap.put("ext1", menu.getExt1());
//        request.setAttribute("appResCategory",
//                menu.getExt4() == null ? AppResourceCategoryEnums.ForegroundApplication.getKey() : menu.getExt4());
//        request.setAttribute("ffmyfrm", resMap);
        return new ModelAndView("apps/privilege/menu/menuNew");
    }

    public ModelAndView showVersion(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setAttribute("productVersion", request.getParameter("productVersion"));
        String[] canonicalVersions = getVersions(true);
        request.setAttribute("ffcanonicalVersions", canonicalVersions);
        return new ModelAndView("apps/privilege/menu/menuVersion");
    }

    private String[] getVersions(boolean isNeedExits) {
        ProductVersionEnum[] productVersions = ProductVersionEnum.values();
        String[] canonicalVersions = new String[productVersions.length];
        String canonicalVersion = null;
        PrivMenuBO menu = null;
        List<PrivMenuBO> result = null;
        for (int i = 0; i < productVersions.length; i++) {
            canonicalVersion = productVersions[i].getCanonicalVersion();
            if (isNeedExits) {
                menu = new PrivMenuBO();
                menu.setExt3(canonicalVersion);
                result = privilegeMenuManager.findMenus(menu);
                if (result == null || result.size() == 0) {
                    continue;
                }
            }
            canonicalVersions[i] = canonicalVersion;
        }
        return canonicalVersions;
    }

/*    public ModelAndView uploadMenuIcon(HttpServletRequest request, HttpServletResponse response) throws Exception {
        File file = fileManager.getFile(Long.parseLong(request.getParameter("fileid")), new Date());
        String filePath = AppContext.getSystemProperty("ApplicationRoot") + File.separator + "main" + File.separator
                + "menuIcon" + File.separator;
        File rootDirectory = new File(filePath);
        if (!(rootDirectory.exists())) {
            rootDirectory.mkdirs();
        }
        String fielName = request.getParameter("filename");
        File fileNew = new File(filePath + fielName);
        if (!fileNew.exists()) {
            fileNew.createNewFile();
        }
        InputStream in = new FileInputStream(file);
        OutputStream out = new FileOutputStream(fileNew);
        IOUtils.copy(in, out);
        IOUtils.closeQuietly(in);
        IOUtils.closeQuietly(out);
        file.delete();
        return null;
    }*/
    
    
    /**
	 * 资源树
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getTree(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// 查询条件
		String memberId = request.getParameter("memberId");
		String accountId = request.getParameter("accountId");
		String roleId = request.getParameter("roleId");
		//客开   赵培珅  2018-05-21 start
		request.setAttribute("ffroleId", roleId);
		//客开   赵培珅  2018-05-21 end
		// 所属产品线版本
		String version = request.getParameter("version");
		// 操作命令
		String cmd = request.getParameter("cmd");
		//客开  赵培珅  2018-05-22
	/*	if(cmd!=null&&"selectAll".equals(cmd)){
//			V3xOrgRole role=orgManager.getRoleById(Long.parseLong(roleId));
			if(roleId!=null&&orgManager.checkRolePrefabricated(Long.parseLong(roleId))){
				request.setAttribute("fftreefront", null);
				request.setAttribute("fftreefrontCheck", null);
				return new ModelAndView("apps/privilege/resource/resourceTree");
			}
		}
		*/
		//客开  赵培珅  2018-05-22
		// true 显示所有资源, false 只显示选择资源
		String showAll = request.getParameter("showAll");
		// true 允许拖拽, false 不允许拖拽
		String drag = request.getParameter("drag");
		// true 分配界面, false 资源管理界面
		String isAllocated = request.getParameter("isAllocated");
		// 过滤由于不可分配的菜单过滤后引起的没有子菜单且没有入口资源的菜单
		String appResCategory = request.getParameter("appResCategory");
		// 后台管理资源列表
		List<PrivTreeNodeBO> treeNodes4Back = new ArrayList<PrivTreeNodeBO>();
		// 前台应用资源列表
		List<PrivTreeNodeBO> treeNodes4Front = new ArrayList<PrivTreeNodeBO>();
		privilegeMenuManager.getTreeNodes(memberId, accountId, roleId, showAll, version,
				appResCategory, isAllocated, treeNodes4Back, treeNodes4Front,true);

		// 添加根节点
		PrivTreeNodeBO node = new PrivTreeNodeBO();
		node.setIdKey("menu_0");
		node.setNameKey(ResourceUtil.getString("org.menue.resource.tree"));
		node.setpIdKey("0");
		if (!CollectionUtils.isEmpty(treeNodes4Front)) {
			treeNodes4Front.add(node);
		}
		request.setAttribute("fftreefront", treeNodes4Front);
		if (showAll != null) {
			List<PrivTreeNodeBO> treeNodes4BackAll = new ArrayList<PrivTreeNodeBO>();
			List<PrivTreeNodeBO> treeNodes4FrontAll = new ArrayList<PrivTreeNodeBO>();
			privilegeMenuManager.getTreeNodes(null, null, null, showAll, version, appResCategory,
					isAllocated, treeNodes4BackAll, treeNodes4FrontAll,true);


			// 添加根节点
			treeNodes4FrontAll.add(node);
			request.setAttribute("fftreefront", treeNodes4FrontAll);
			request.setAttribute("fftreefrontCheck", treeNodes4Front);
			
//			request.setAttribute("fftreeback", treeNodes4BackAll);
//			request.setAttribute("fftreebackCheck", treeNodes4Back);
		}
		request.setAttribute("ffdrag", drag);
		request.setAttribute("ffcmd", cmd);
		//客开   赵培珅  2018-05-21 start
		/*request.setAttribute("ffroleId", roleId);*/
		//客开   赵培珅  2018-05-21 end
		return new ModelAndView("apps/privilege/resource/resourceTree");
	}    


	
    /**
     * @param fileManager the fileManager to set
     */
    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }


    
	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	public void setPrivilegeMenuManager(PrivilegeMenuManager privilegeMenuManager) {
		this.privilegeMenuManager = privilegeMenuManager;
	}
    
    
    
    
}
