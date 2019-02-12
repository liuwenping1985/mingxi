package com.seeyon.apps.dev.doc.menucheak;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.doc.manager.DocAclManager;
import com.seeyon.apps.doc.manager.DocHierarchyManager;
import com.seeyon.apps.doc.manager.DocLibManager;
import com.seeyon.apps.doc.po.DocLibPO;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.thirdparty.menu.MenuItemAccessCheck;

public class DocLibManagerCheck implements MenuItemAccessCheck {
	private static final Log log = LogFactory.getLog(DocLibManagerCheck.class);

	public boolean check(long memberId, Object[] params) {
		try {
			DocLibManager docLibManager = (DocLibManager)AppContext.getBean("docLibManager");
			if ((params.length <= 0) || 
					(!(params[0] instanceof HttpServletRequest))) 
				return false;
			HttpServletRequest req = (HttpServletRequest)params[0];
			String parameter = "docLibId";
			String resId = req.getParameter("resId");
			String sDocLibId = req.getParameter(parameter);
			if (sDocLibId == null) return false;
			long docLibId = Long.valueOf(sDocLibId).longValue();
			DocLibPO personalLib = docLibManager.getPersonalLibOfUser(memberId);
			if (docLibId == personalLib.getId().longValue()) return false;//我的文档不显示归档到档案系统菜单
			boolean isok = docLibManager.isOwnerOfLib(Long.valueOf(memberId), Long.valueOf(docLibId));//根据memberId判断用户是不是某类文档的管理员
			if(!isok){
				DocAclManager docAclManager = (DocAclManager) AppContext.getBean("docAclManager");
				DocHierarchyManager docHierarchyManager = (DocHierarchyManager) AppContext.getBean("docHierarchyManager");
				DocResourcePO  docResource = docHierarchyManager.getDocResourceById(Long.parseLong(resId));
				isok = docAclManager.canBeDelete(docResource,String.valueOf( memberId));
			}
			 return isok;
		}
		catch (Exception e) {
			log.error("检查权限出错"+e.getMessage(),e);
		}

		return false;
	}
}