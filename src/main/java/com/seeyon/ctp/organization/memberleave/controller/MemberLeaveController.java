/**
 * 
 */
package com.seeyon.ctp.organization.memberleave.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.inexportutil.DataUtil;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.memberleave.bo.MemberLeaveDetail;
import com.seeyon.ctp.organization.memberleave.bo.MemberLeavePending;
import com.seeyon.ctp.organization.memberleave.manager.MemberLeaveManager;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;

/**
 * @author tanmf
 *
 */
//客开 @CheckRoleAccess(roleTypes = { Role_NAME.GroupAdmin, Role_NAME.AccountAdministrator, Role_NAME.DepAdmin, Role_NAME.HrAdmin })
public class MemberLeaveController extends BaseController {

    private static final Log log = LogFactory.getLog(MemberLeaveController.class);

    /**
     * 离职办理接口
     */
    private MemberLeaveManager memberLeaveManager;
    
    private OrgManager  orgManager;
    
    protected OrgCache  orgCache;
    
    private FileToExcelManager fileToExcelManager;
    
    /**
     * @param memberLeaveManager the memberLeaveManager to set
     */
    public void setMemberLeaveManager(MemberLeaveManager memberLeaveManager) {
        this.memberLeaveManager = memberLeaveManager;
    }
    
    public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
    
	public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
		this.fileToExcelManager = fileToExcelManager;
	}

	public OrgCache getOrgCache() {
		return orgCache;
	}

	public void setOrgCache(OrgCache orgCache) {
		this.orgCache = orgCache;
	}

	/**
     * 显示离职人员协同相关交接页面
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView showLeavePage(HttpServletRequest request,HttpServletResponse response) throws Exception{
        ModelAndView mav = new ModelAndView("apps/organization/memberLeave/showLeavePage");
        
        long memberId = Long.parseLong(request.getParameter("memberId"));
        
        List<MemberLeavePending> pendings = this.memberLeaveManager.getMemberLeavePending(memberId);
        
/*        //根据userid获得用户所在的所有流程模板列表 (V)
        //根据userid获得该用户审核的公告板块列表 (V)
        //根据userid获得该用户管理的调查板块列表 (V)
        //根据userid获得该用户审核的新闻板块列表 (V)
        //根据userid获得该用户是否为综合办公的管理员
        //根据userid获得该用户还没有归还的综合办公物品列表
        List<String> handItems = this.memberLeaveManager.getMemberLeaveHandItem(MemberLeaveClearItemInterface.Type.HandItem, memberId);
        
        //根据userid获得用户的所有角色关系列表 (V)
        //根据userid获得该用户负责的项目列表
        //根据userid获得该用户的表单模板列表 
        //根据userid获得该用户管理的空间列表 
        //根据userid获得该用户管理的讨论板块列表 (V)
        //根据userid获得该用户管理的新闻板块列表 (V)
        //根据userid获得该用户管理的公告板块列表 (V)
        //根据userid获得该用户审核的调查板块列表 (V)
        List<String> roles = this.memberLeaveManager.getMemberLeaveHandItem(MemberLeaveClearItemInterface.Type.Role, memberId);
*/        
        mav.addObject("pendings", pendings);
/*        mav.addObject("handItems", handItems);
        mav.addObject("roles", roles);*/
        
        return mav;
    }

   /**
    * 显示离职交接待办列表
    * @param request
    * @param response
    * @return
    * @throws Exception
    */
   public ModelAndView showList4Leave(HttpServletRequest request,HttpServletResponse response) throws Exception{
        return new ModelAndView("apps/organization/memberLeave/showList4Leave");
   }

   /**
    * 保存离职交接信息
    * @param request
    * @param response
    * @return
    * @throws Exception
    */
    public ModelAndView save4Leave(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map params = ParamUtil.getJsonParams();

        Long memberId = Long.parseLong(String.valueOf(params.get("memberId")));
        Long noupdateState = "".equals(params.get("noupdateState"))?0L:Long.parseLong(String.valueOf(params.get("noupdateState")));
        Map<String, Long> agentMember = new HashMap<String, Long>();
        agentMember.put("noupdateState", noupdateState);
        for (Object key : params.keySet()) {
            if(String.valueOf(key).startsWith("AgentId_")){
                String value = String.valueOf(params.get(key));
                
                if(Strings.isNotBlank(value)){
                    agentMember.put(String.valueOf(key).substring(8), Long.parseLong(value));
                }
            }
        }
        
        this.memberLeaveManager.save4Leave(memberId, agentMember);

        return null;
    }
    
    
    
    
    /**
     * 导出离职人员未完成信息
     * @param request
     * @param response
     * @return
     * @throws Exception 
     */
    public ModelAndView exportMemberLeaveList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        orgCache.setOrgExportFlag(true);
        if (user == null) {
            return null;
        }
        if (DataUtil.doingImpExp(user.getId())) {
            return null;
        }
        Long memberId=Long.valueOf(request.getParameter("memberId"));
        int category = Integer.valueOf(request.getParameter("category"));
        String condition=request.getParameter("condition").replace("\"", "");
        String value=request.getParameter("value").replace("\"", "");
        V3xOrgMember member=orgManager.getMemberById(memberId);
        String name="";
        if(null!=member){
        	name=member.getName();
        }
        Map paraMap = new HashMap();
        paraMap.put("condition", condition);
        paraMap.put("value", value);
        paraMap.put("memberId", memberId.toString());
        paraMap.put("category", category);
        String listname = "MemberLeaveList_";
        listname += name;

        String key = null;
        DataUtil.putImpExpAction(user.getId(), "export");
        DataRecord dataRecord = null;
        try {
            dataRecord = exportMember(request, fileToExcelManager, paraMap);
            key = DataUtil.createTempSaveKey4Sheet(dataRecord);
        } catch (Exception e) {
            DataUtil.removeImpExpAction(user.getId());
            log.error(e);
            orgCache.setOrgExportFlag(false);
            throw new BusinessException("导出失败！");
        }
        DataUtil.removeImpExpAction(user.getId());

        String url = DataUtil.getOrgDownloadExpToExcelUrl(key, listname);
        log.info("url=" + url);
        DataUtil.removeImpExpAction(user.getId());
        try {
            OrgHelper.exportToExcel(request, response, fileToExcelManager, listname, dataRecord);
        } catch (Exception e) {
            log.error(e);
            throw e;
        } finally {
            orgCache.setOrgExportFlag(false);
        }
        return null;

    }
    
    /**
     * 将导出人员数据整理excel的数据对象
     * @param fileToExcelManager
     * @param orgManagerDirect
     * @return
     * @throws Exception
     */
    private DataRecord exportMember(HttpServletRequest request, FileToExcelManager fileToExcelManager, Map paraMap) throws Exception {
        FlipInfo fi=new FlipInfo();
        fi.setSize(10000);
        fi=memberLeaveManager.showLeaveInfo(fi, paraMap);
        List<MemberLeaveDetail> list=fi.getData();
        DataRecord dataRecord = new DataRecord();

        //导出excel文件的国际化
        String account = ResourceUtil.getString("member.leave.account");
        String type = ResourceUtil.getString("member.leave.type");
        String content = ResourceUtil.getString("member.leave.content");
        String title = ResourceUtil.getString("member.leave.title");
        String member_list = ResourceUtil.getString("member.leave.list");
        
        if (null != list && list.size() > 0) {
        	 DataRow[] datarow = new DataRow[list.size()];
        	 for (int i=0;i<list.size();i++) {
        		 MemberLeaveDetail m=list.get(i);
        		 DataRow row = new DataRow();
        		 row.addDataCell(m.getAccountName(), 1);
        		 row.addDataCell(m.getType(), 2);
        		 row.addDataCell(m.getContent(), 3);
        		 row.addDataCell(m.getTitle(), 4);
        		 datarow[i] = row;
             }
                 dataRecord.addDataRow(datarow);
        }
        String[] columnName={account,type,content,title};
        dataRecord.setColumnName(columnName);
        dataRecord.setTitle(member_list);
        dataRecord.setTitle(member_list);
        dataRecord.setSheetName(member_list);
        return dataRecord;
    }

}
