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

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.excel.DataCell;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumBean;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.MemberPostType;
import com.seeyon.ctp.organization.OrgConstants.RelationshipObjectiveName;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgRelationship;
import com.seeyon.ctp.organization.bo.V3xOrgRole;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.ConcurrentPostManager;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.organization.manager.RoleManager;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgSecondPost;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.ctp.util.json.JSONUtil;

/**
 * <p>Title: T2组织模型兼职信息维护控制器</p>
 * <p>Description: 主要针对人员兼职进行维护功能</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 * @author lilong
 */
//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
public class ConcurrentPostController extends BaseController {

    protected OrgManagerDirect      orgManagerDirect;
    protected OrgManager            orgManager;
    protected FileToExcelManager    fileToExcelManager;
    protected AppLogManager         appLogManager;
    protected RoleManager           roleManager;
    protected ConcurrentPostManager conPostManager;


    public void setConPostManager(ConcurrentPostManager conPostManager) {
        this.conPostManager = conPostManager;
    }

    public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
        this.orgManagerDirect = orgManagerDirect;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    public void setRoleManager(RoleManager roleManager) {
        this.roleManager = roleManager;
    }

    /***************************/

    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
    	//客开 检查是否为虚拟组管理角色
    	Long accountId = AppContext.currentAccountId();
        String virtualGroupAdmin = request.getParameter("virtualGroupAdmin");
        if(Strings.isNotBlank(virtualGroupAdmin) 
           && "1".equals(virtualGroupAdmin)){
        	accountId = -1730833917365171641L; /** 集团版--常量集团ID */
        }

    	if (OrgConstants.GROUPID.equals(accountId)) {
            return this.list4Management(request, response);
        } else {
            return this.list4in(request, response);
        }
    }

    /**
     * 集团管理员管理兼职信息页面
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView list4Management(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
    	//客开 检查是否为虚拟组管理角色
    	Long accountId = AppContext.getCurrentUser().getAccountId();
        String virtualGroupAdmin = request.getParameter("virtualGroupAdmin");
        if(Strings.isNotBlank(virtualGroupAdmin) 
           && "1".equals(virtualGroupAdmin)){
        	accountId = -1730833917365171641L; /** 集团版--常量集团ID */
        }
    	
    	if (!OrgConstants.GROUPID.equals(accountId)) {
            return this.list4in(request, response);
        }

        ModelAndView m = new ModelAndView("apps/organization/concurrentPost/listConPost");
        boolean canSubunitMangeConPost = conPostManager.canSubunitManageConPost();
        m.addObject("virtualGroupAdmin", String.valueOf(accountId));//客开 虚拟组管理角色
        m.addObject("conPostSwitch", canSubunitMangeConPost);
        m.addObject("method", "list4Manager");
        return m;
    }

    /**
     * 外单位兼职到本单位的兼职列表
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView list4in(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
    	//客开 检查是否为虚拟组管理角色
    	Long accountId = AppContext.getCurrentUser().getAccountId(); // 主岗所在单位ID
        String virtualGroupAdmin = request.getParameter("virtualGroupAdmin");
        if(Strings.isNotBlank(virtualGroupAdmin) 
           && "1".equals(virtualGroupAdmin)){
        	accountId = -1730833917365171641L; /** 集团版--常量集团ID */
        }
        // END 
        
    	if (OrgConstants.GROUPID.equals(accountId)) {
            return this.list4Management(request, response);
        }

        ModelAndView m = new ModelAndView("apps/organization/concurrentPost/listConPost");
        boolean canSubunitMangeConPost = conPostManager.canSubunitManageConPost();
        m.addObject("conPostSwitch", canSubunitMangeConPost);
        if(canSubunitMangeConPost){
        	//是否有子单位
        	Long currentUnitId = AppContext.currentAccountId(); // 登录单位ID
        	//所有有权限访问的单位
        	List<V3xOrgAccount> childUnitList = orgManager.getChildAccount(currentUnitId, false);
        	if(childUnitList.size() > 0){
        		m.addObject("hasSubUnit", true);
        	}
        }
        m.addObject("virtualGroupAdmin", String.valueOf(accountId));//客开 虚拟组管理角色
        m.addObject("method", "list4in");
        return m;
    }

    /**
     * 本单位兼职到外单位的列表展现
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView list4out(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
    	//客开 检查是否为虚拟组管理角色
    	Long accountId = AppContext.getCurrentUser().getAccountId();
        String virtualGroupAdmin = request.getParameter("virtualGroupAdmin");
        if(Strings.isNotBlank(virtualGroupAdmin) 
           && "1".equals(virtualGroupAdmin)){
        	accountId = -1730833917365171641L; /** 集团版--常量集团ID */
        }
        // END 
    	
    	if (OrgConstants.GROUPID.equals(accountId)) {
            return this.list4Management(request, response);
        }

        ModelAndView m = new ModelAndView("apps/organization/concurrentPost/listConPost");
        boolean canSubunitMangeConPost = conPostManager.canSubunitManageConPost();
        m.addObject("conPostSwitch", canSubunitMangeConPost);
        if(canSubunitMangeConPost){
        	//是否有子单位
        	Long currentUnitId = AppContext.currentAccountId();
        	List<V3xOrgAccount> childUnitList = orgManager.getChildAccount(currentUnitId, false);
        	if(childUnitList.size() > 0){
        		m.addObject("hasSubUnit", true);
        	}
        }
        m.addObject("virtualGroupAdmin", String.valueOf(accountId));//客开 虚拟组管理角色
        m.addObject("method", "list4out");
        return m;
    }

    /**
     * 本单位所有副岗信息
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView list4SecondPost(HttpServletRequest request, HttpServletResponse response) throws Exception {

        ModelAndView m = new ModelAndView("apps/organization/concurrentPost/listSecondPost");
        boolean canSubunitMangeConPost = conPostManager.canSubunitManageConPost();
        m.addObject("conPostSwitch", canSubunitMangeConPost);
        if(canSubunitMangeConPost){
        	//是否有子单位
        	Long currentUnitId = AppContext.currentAccountId();
        	List<V3xOrgAccount> childUnitList = orgManager.getChildAccount(currentUnitId, false);
        	if(childUnitList.size() > 0){
        		m.addObject("hasSubUnit", true);
        	}
        }
        
        m.addObject("method", "list4SecondPost");
        return m;
    }
    
    /**
     * 子单位兼职管理
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView list4SubUnitManage(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	//客开 检查是否为虚拟组管理角色
    	Long accountId = AppContext.getCurrentUser().getAccountId();
        ModelAndView m = new ModelAndView("apps/organization/concurrentPost/listConPost");
        boolean canSubunitMangeConPost = conPostManager.canSubunitManageConPost();
        m.addObject("conPostSwitch", canSubunitMangeConPost);
        if(canSubunitMangeConPost){
        	//是否有子单位
        	Long currentUnitId = AppContext.currentAccountId();
        	List<V3xOrgAccount> childUnitList = orgManager.getChildAccount(currentUnitId, false);
        	if(childUnitList.size() > 0){
        		m.addObject("hasSubUnit", true);
        	}
        }
        m.addObject("virtualGroupAdmin", String.valueOf(accountId));//客开 虚拟组管理角色
        m.addObject("method", "list4SubUnitManage");
        return m;
    }

    /**
     * 打开批量新增的页面
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView bat4Add(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView m = new ModelAndView("apps/organization/concurrentPost/conPost4BatAdd");
        m.addObject("method", "list4out");
        return m;
    }

    /**
     * 批量新建兼职关系
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public ModelAndView batAddCon(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map<String, String> params = ParamUtil.getJsonParams();
        String cMemberBatIds = params.get("cMemberBatIds");
        String cAccountBatIds = params.get("cAccountBatIds");
        //批量增加多种情况，（1）选一个人兼职到多个单位；（2）多个人兼职到同一个单位
        String[] membersIds = cMemberBatIds.split(",");
        String[] accountIds = cAccountBatIds.split(",");

        //记录日志使用的List
        List<MemberPost> aLogList = new ArrayList<MemberPost>();

        //（1）选一个人兼职到多个单位；
        if (membersIds.length == 1 && accountIds.length > 0) {
            for (String aId : accountIds) {
                MemberPost m = new MemberPost();
                Long memberId = Long.valueOf(membersIds[0].split("[|]")[1]);
                Long cAccountId = Long.valueOf(aId.split("[|]")[1]);
                V3xOrgRole defaultRole = roleManager.getDefultRoleByAccount(cAccountId);
                int cSort = orgManager.getMaxMemberSortByAccountId(cAccountId)+1;
                if(OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() == defaultRole.getBond()) {
                    m = MemberPost.createConcurrentPost(memberId, null, null, null, cAccountId, cSort, null, null);
                } else {
                    m = MemberPost.createConcurrentPost(memberId, null, null, null, cAccountId, cSort, null, defaultRole.getId().toString());
                }
                orgManagerDirect.addConurrentPost(m);

                defaultBatRole(memberId, cAccountId);

                aLogList.add(m);
            }
        }

        //（2）多个人兼职到同一个单位
        if (membersIds.length > 1 && accountIds.length == 1) {
        	Long cAccountId = Long.valueOf(accountIds[0].split("[|]")[1]);
        	V3xOrgRole defaultRole = roleManager.getDefultRoleByAccount(cAccountId);
        	int cSort = orgManager.getMaxMemberSortByAccountId(cAccountId)+1;
            for (String mId : membersIds) {
                MemberPost m = new MemberPost();
                Long memberId = Long.valueOf(mId.split("[|]")[1]);
                if(OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() == defaultRole.getBond()) {
                    m = MemberPost.createConcurrentPost(memberId, null, null, null, cAccountId, cSort, null, null);
                } else {
                    m = MemberPost.createConcurrentPost(memberId, null, null, null, cAccountId, cSort, null, defaultRole.getId().toString());
                }
                orgManagerDirect.addConurrentPost(m);

                defaultBatRole(memberId, cAccountId);

                aLogList.add(m);
            }
        }

        //增加日志
        User user = AppContext.getCurrentUser();
        for (MemberPost m : aLogList) {
            V3xOrgMember member = orgManager.getMemberById(m.getMemberId());
            V3xOrgAccount account = orgManager.getAccountById(m.getOrgAccountId());
            appLogManager.insertLog(user, AppLogAction.Organization_GroupAdminAddCntPost, member.getName(),
                    account.getName(), user.getName());
        }

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("window.parent.location.reload();");
        out.println("window.parent.dialog.close();");
        out.println("</script>");
        out.flush();
        out.close();

        return null;
    }

    /**
     * 批量新建兼职，默认角色
     * @param memberId
     * @param cAccountId
     * @throws BusinessException
     */
    private void defaultBatRole(Long memberId, Long cAccountId) throws BusinessException {
        //批量兼职默认普通角色
        V3xOrgMember member = orgManager.getMemberById(memberId);
        V3xOrgRole defaultRole = roleManager.getDefultRoleByAccount(cAccountId);
        //Fix OA-25328 兼职角色不能选部门角色，如果默认角色时部门角色的话，批量新建的人则不给角色
        if (null != member && null != defaultRole
                && OrgConstants.ROLE_BOND.DEPARTMENT.ordinal() != defaultRole.getBond()) {
            orgManagerDirect.addRole2Entity(defaultRole.getId(), cAccountId, member);
        }
    }

    /**
     * 兼职信息导出方法<br>
     * 这里涉及三处导出:<br>
     * 1)集团管理员，兼职管理导出，全部兼职信息列表<br>
     * 2)单位管理员，兼职到本单位，导出兼职到本单位的信息列表<br>
     * 3)单位管理员，兼职到外单位，导出兼职到外单位的信息列表<br>
     * 4)单位管理员，副岗列表，本单位所有副岗信息列表<br>
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView exportCnt(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 判断是系统管理员还是单位管理员进入的页面
        User user = AppContext.getCurrentUser();
        List<V3xOrgRelationship> cntListOrg = new UniqueList<V3xOrgRelationship>();
        EnumMap<RelationshipObjectiveName, Object> enummap = new EnumMap<RelationshipObjectiveName, Object>(
                RelationshipObjectiveName.class);
        enummap.put(OrgConstants.RelationshipObjectiveName.objective5Id, MemberPostType.Concurrent.name());

        String isIn = request.getParameter("isIn");

        if ("list4in".equals(isIn)) {
            //兼职到本单位
            cntListOrg = orgManager.getMemberPostRelastionships(null, user
                    .getLoginAccount(), enummap);
        } else if ("list4out".equals(isIn)) {
            Long currentAccountId = AppContext.currentAccountId();
            List<V3xOrgRelationship> tempCntList = orgManager.getMemberPostRelastionships( null, null, enummap);
            for (V3xOrgRelationship bo : tempCntList) {
                V3xOrgMember m = orgManager.getMemberById(bo.getSourceId());
                if (null != m && currentAccountId.equals(m.getOrgAccountId())) {
                    cntListOrg.add(bo);
                }
            }
        } else if("list4SecondPost".equals(isIn)){//副岗
            return this.exportSecondPost(request, response);
        } else if("list4SubUnitManage".equals(isIn)){//子单位管理兼职信息
        	String includeUnitIds = conPostManager.getIncludeUnitIds();
            List<V3xOrgRelationship> tempCntList = orgManager.getMemberPostRelastionships( null, null, enummap);
            for (V3xOrgRelationship bo : tempCntList) {
                V3xOrgMember m = orgManager.getMemberById(bo.getSourceId());
                if (null != m && (includeUnitIds.indexOf(m.getOrgAccountId()+"") != -1 || includeUnitIds.indexOf(bo.getOrgAccountId()+"") != -1)) {
                    cntListOrg.add(bo);
                }
            }
        } else {
            //集团管理员全部导出
            cntListOrg = orgManager.getMemberPostRelastionships(null, null,
                    enummap);
        }

        List<DataRecord> records = new ArrayList<DataRecord>();
        
        //根据查询条件过滤
        String condition = request.getParameter("condition");
        Object value = null;
        if(Strings.isNotBlank(condition) && !"undefined".equals(condition)){
            Map paraMap = (Map) JSONUtil.parseJSONString(condition);
            if(paraMap.containsKey("condition")) {
                condition = paraMap.get("condition").toString();
            } else {
                condition = null;
            }
            if(paraMap.containsKey("value")) {
                if("selectPeople".equals(String.valueOf(paraMap.get("type")))) {
                    String _tempStr = paraMap.get("value").toString().replace("\"", "");
                    value = Long.valueOf(_tempStr.substring(_tempStr.indexOf("|")+1, _tempStr.length()-1));
                } else if("input".equals(String.valueOf(paraMap.get("type")))) {
                    value = paraMap.get("value");
                }
            }
        } else {
            condition = null;
        }
        
        List<V3xOrgRelationship> rels = new UniqueList<V3xOrgRelationship>();;
        if(Strings.isNotBlank(condition) && value != null){
            for(V3xOrgRelationship rel : cntListOrg){
                V3xOrgMember member = orgManager.getMemberById(rel.getSourceId());
                if("cMemberName".equals(condition)){//兼职人员名称
                    if(member.getName().indexOf(value.toString())<0){
                        continue;
                    }
                }else if("sAccount".equals(condition)){//兼职人员原单位
                    if(!member.getOrgAccountId().equals(value)){
                        continue;
                    }
                }else if("cAccount".equals(condition)){//兼职人员兼职单位
                    if(!rel.getOrgAccountId().equals(value)){
                        continue;
                    }
                }
                rels.add(rel);
            }
        }else{
            rels = cntListOrg;
        }

        if (rels.size() != 0) {
            DataRecord record = new DataRecord();
            String[] columnNames = new String[7];
            columnNames[0] = ResourceUtil.getString("cntPost.body.membername.label");
            columnNames[1] = ResourceUtil.getString("cntPost.body.number.label");
            columnNames[2] = ResourceUtil.getString("cntPost.body.account.label");
            columnNames[3] = ResourceUtil.getString("cntPost.body.post.label");
            columnNames[4] = ResourceUtil.getString("cntPost.body.cntaccount.label");
            columnNames[5] = ResourceUtil.getString("cntPost.body.cntdept.label");
            columnNames[6] = ResourceUtil.getString("cntPost.body.cntpost.label");
            record.setColumnName(columnNames);
            record.setSheetName(ResourceUtil.getString("cntPost.detail.label"));
            record.setTitle(ResourceUtil.getString("cntPost.detail.label"));
            
            for (V3xOrgRelationship rel : rels) {
                DataRow row = new DataRow();
                V3xOrgMember member = orgManager.getMemberById(rel.getSourceId());

                if (member != null) {
                    row.addDataCell(OrgHelper.showMemberName(member), DataCell.DATA_TYPE_TEXT);
                    row.addDataCell(rel.getObjective6Id()==null?"":rel.getObjective6Id(), DataCell.DATA_TYPE_TEXT);
                    String accountName = (member == null ? "" : OrgHelper.showOrgAccountName(member.getOrgAccountId()));
                    row.addDataCell(accountName, DataCell.DATA_TYPE_TEXT);
                    String postName = (member == null ? "" : orgManager.getPostById(member.getOrgPostId()).getName());
                    row.addDataCell(postName, DataCell.DATA_TYPE_TEXT);
                    row
                            .addDataCell(orgManager.getAccountById(rel.getOrgAccountId()).getName(),
                                    DataCell.DATA_TYPE_TEXT);
                    String cntDeptName = "";
                    if (rel.getObjective0Id() != null) {
                        V3xOrgDepartment dept = orgManager.getDepartmentById(rel.getObjective0Id());
                        if (dept == null) {
                            List<V3xOrgEntity> deptList = orgManager.getEntityListNoRelation(V3xOrgDepartment.class.getSimpleName(),
                                    "id", rel.getObjective0Id(), rel.getOrgAccountId());
                            if (deptList != null && deptList.size() > 0) {
                                dept = (V3xOrgDepartment) deptList.get(0);
                                cntDeptName = dept.getName();
                            }
                        } else {
                            cntDeptName = dept.getName();
                        }
                    }
                    row.addDataCell(cntDeptName, DataCell.DATA_TYPE_TEXT);
                    String cntPostName = "";
                    if (rel.getObjective1Id() != null) {
                        V3xOrgPost post = orgManager.getPostById(rel.getObjective1Id());
                        if (post == null) {
                            List<V3xOrgEntity> postList = orgManager.getEntityListNoRelation(V3xOrgPost.class.getSimpleName(), "id",
                                    rel.getObjective1Id(), rel.getOrgAccountId());
                            if (postList != null && postList.size() > 0) {
                                post = (V3xOrgPost) postList.get(0);
                                cntPostName = post.getName();
                            }
                        } else {
                            cntPostName = post.getName();
                        }
                    }
                    row.addDataCell(cntPostName, DataCell.DATA_TYPE_TEXT);
                    record.addDataRow(row);
                }
            }
            records.add(record);
            DataRecord[] dataRecords = new DataRecord[records.size()];
            int j = 0;
            for (DataRecord rec : records) {
                dataRecords[j] = rec;
                j++;
            }
            fileToExcelManager.save(response, "cntPost", dataRecords);
            return null;
        } else {
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Type", "text/html;charset=UTF-8");
            //没有数据不能导出
            PrintWriter out = response.getWriter();
            out.println("<script>");
            out.println("alert(\""+ResourceUtil.getString("export.excel.no.record")+"\");");
            out.println("</script>");
            out.flush();
            return null;
        }
    }

    public ModelAndView exportSecondPost(HttpServletRequest request, HttpServletResponse response) throws Exception {

        List<WebV3xOrgSecondPost> secondPosts = conPostManager.dealSecondPostInfo(conPostManager
                .getSecondPostMap(AppContext.currentAccountId(), null));


        if (secondPosts.size() != 0) {
            List<DataRecord> records = new ArrayList<DataRecord>();

            DataRecord record = new DataRecord();
            String[] columnNames = new String[8];
            columnNames[0] = ResourceUtil.getString("cntPost.body.membername.label");
            columnNames[1] = ResourceUtil.getString("common.sort.label");
            columnNames[2] = ResourceUtil.getString("org.member_form.deptName.label");
            columnNames[3] = ResourceUtil.getString("org.member_form.primaryPost.label");
            columnNames[4] = ResourceUtil.getString("department.parttime.to.second.0");
            columnNames[5] = ResourceUtil.getString("department.parttime.to.second.1");
            columnNames[6] = ResourceUtil.getString("department.parttime.to.second.2");
            columnNames[7] = ResourceUtil.getString("org.metadata.member_type.label");
            record.setColumnName(columnNames);
            record.setSheetName("Second Posts");
            record.setTitle(ResourceUtil.getString("department.parttime.to.second.dept"));

            for(WebV3xOrgSecondPost sec : secondPosts){
                DataRow row = new DataRow();
                row.addDataCell(sec.getMemberName(), DataCell.DATA_TYPE_TEXT);
                row.addDataCell(String.valueOf(sec.getSortId()), DataCell.DATA_TYPE_TEXT);
                row.addDataCell(sec.getDeptName(), DataCell.DATA_TYPE_TEXT);
                row.addDataCell(sec.getPostName(), DataCell.DATA_TYPE_TEXT);
                row.addDataCell(sec.getSecPost0(), DataCell.DATA_TYPE_TEXT);
                row.addDataCell(sec.getSecPost1(), DataCell.DATA_TYPE_TEXT);
                row.addDataCell(sec.getSecPost2(), DataCell.DATA_TYPE_TEXT);

                EnumManager manager = (EnumManager) AppContext.getBean("enumManagerNew");
                CtpEnumBean bean = manager.getEnumByProCode("org_property_member_type");
                row.addDataCell(ResourceUtil.getString(bean.getItem(sec.getTypeName()).getShowvalue()), DataCell.DATA_TYPE_TEXT);
                record.addDataRow(row);
            }
            records.add(record);

            DataRecord[] dataRecords = new DataRecord[records.size()];
            int j = 0;
            for (DataRecord rec : records) {
                dataRecords[j] = rec;
                j++;
            }


            fileToExcelManager.save(response, "secondPost", dataRecords);
            return null;

        } else {
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Type", "text/html;charset=UTF-8");
            //没有数据不能导出
            PrintWriter out = response.getWriter();
            out.println("<script>");
            out.println("alert(\""+ResourceUtil.getString("export.excel.no.record")+"\");");
            out.println("</script>");
            out.flush();
            return null;
        }
    }
    
    /**
     * 显示兼职信息删除结果
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView showResult(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("apps/organization/concurrentPost/showConPostDelResult");
		return mav;
	}
}
