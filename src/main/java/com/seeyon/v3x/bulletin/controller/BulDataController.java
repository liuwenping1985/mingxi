//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.v3x.bulletin.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.agent.utils.AgentUtil;
import com.seeyon.apps.bulext.po.BulForceRead;
import com.seeyon.apps.bulletin.event.BulletinAddEvent;
import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.doc.api.DocApi;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.ApplicationSubCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.affair.AffairExtPropEnums;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.content.affair.constants.TrackEnum;
import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.Constants;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.login.auth.DefaultLoginAuthentication;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgTeam;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.principal.PrincipalManagerImpl;
import com.seeyon.ctp.portal.po.PortalSpaceFix;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.portal.util.Constants.SecurityType;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.util.*;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.bulletin.domain.BulBody;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.bulletin.domain.BulRead;
import com.seeyon.v3x.bulletin.domain.BulType;
import com.seeyon.v3x.bulletin.domain.BulTypeManagers;
import com.seeyon.v3x.bulletin.manager.BulDataManager;
import com.seeyon.v3x.bulletin.manager.BulIssueManager;
import com.seeyon.v3x.bulletin.manager.BulReadManager;
import com.seeyon.v3x.bulletin.manager.BulTypeManager;
import com.seeyon.v3x.bulletin.util.BulDataLock;
import com.seeyon.v3x.bulletin.util.BulReadCount;
import com.seeyon.v3x.bulletin.util.BulletinUtils;
import com.seeyon.v3x.bulletin.vo.BulTypeModel;
import com.seeyon.v3x.common.security.AccessControlBean;
import com.seeyon.v3x.common.security.SecurityCheck;
import com.seeyon.v3x.contentTemplate.domain.ContentTemplate;
import com.seeyon.v3x.contentTemplate.manager.ContentTemplateManager;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

public class BulDataController extends BaseController {
    private BulDataManager bulDataManager;
    private AttachmentManager attachmentManager;
    private OrgManager orgManager;
    private IndexManager indexManager;
    private BulReadManager bulReadManager;
    private AffairManager affairManager;
    private AppLogManager appLogManager;
    private DocApi docApi;
    private SpaceManager spaceManager;
    private ContentTemplateManager contentTemplateManager;
    private UserMessageManager userMessageManager;
    private BulTypeManager bulTypeManager;
    private BulletinUtils bulletinUtils;
    private static final Log log = LogFactory.getLog(BulDataController.class);
    private CollaborationApi collaborationApi;
    private MainbodyManager ctpMainbodyManager;
    private BulIssueManager bulIssueManager;
    private FileToExcelManager fileToExcelManager;
    private final Object readCountLock = new Object();

    public BulDataController() {

    }

    private String convertContent(String content) throws BusinessException {

        if (content == null) {
            return content;
        } else {
            int xslStart = content.indexOf("&&&&&&&  xsl_start  &&&&&&&&");
            int dataStart = content.indexOf("&&&&&&&&  data_start  &&&&&&&&");
            int inputStart = content.indexOf("&&&&&&&&  input_start  &&&&&&&&");
            if (xslStart != -1 && dataStart != -1 && inputStart != -1) {
                String data = content.substring(dataStart + 30, inputStart);
                String recordid = null;
                Pattern pRecordid = Pattern.compile("recordid=\\\\\"([-]{0,1}\\d+?)\\\\\"");
                Matcher matcherRecordid = pRecordid.matcher(data);
                if (matcherRecordid.find()) {
                    recordid = matcherRecordid.group(1);
                }

                if (recordid != null) {
                    ColSummary summary = this.collaborationApi.getColSummaryByFormRecordId(Long.parseLong(recordid));
                    List<CtpContentAll> contentList = this.ctpMainbodyManager.getContentListByModuleIdAndModuleType(ModuleType.collaboration, summary.getId());
                    if (Strings.isNotEmpty(contentList)) {
                        CtpContentAll body = (CtpContentAll)contentList.get(0);
                        String htmlContent = MainbodyService.getInstance().getContentHTML(body.getModuleType(), body.getModuleId());
                        htmlContent = this.bulIssueManager.replaceFileHtml("fileupload", htmlContent);
                        htmlContent = this.bulIssueManager.replaceFileHtml("assdoc", htmlContent);
                        return htmlContent;
                    }
                }

                return null;
            } else {
                return null;
            }
        }
    }

    private String convertContentV(String content) throws BusinessException {
        if (content == null) {
            return content;
        } else {
            StringBuffer sb = new StringBuffer();
            Pattern pDiv = Pattern.compile("method=download&fileId=(.+?)&v=fromForm");
            Matcher matcherDiv = pDiv.matcher(content);

            while(matcherDiv.find()) {
                String fileId = matcherDiv.group(1);
                String replace = "method=download&fileId=" + fileId + "&v=" + SecurityHelper.digest(new Object[]{fileId});
                matcherDiv.appendReplacement(sb, replace.toString());
            }

            matcherDiv.appendTail(sb);
            return sb.toString();
        }
    }

    public ModelAndView showReadList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("bulletin/user/data_read_view");
        Long dataId = NumberUtils.toLong(request.getParameter("id"));
        BulData bean = (BulData)this.bulDataManager.getBulDataCache().getDataCache().get(dataId);
        if (bean == null) {
            bean = this.bulDataManager.getById(dataId);
        }

        this.setBulDataReadInfo(bean, mav, (String)null);
        return mav;
    }

    public void recordBulRead(long dataId, BulData bean, boolean hasCache, User user) {
        this.bulReadManager.setReadState(bean, user.getId());
        if (hasCache) {
            this.bulDataManager.clickCache(dataId, AppContext.getCurrentUser().getId());
        } else {
            BulBody body = this.bulDataManager.getBody(bean.getId());
            bean.setContent(body.getContent());
            bean.setContentName(body.getContentName());
            Object var8 = this.readCountLock;
            int readCount;
            synchronized(this.readCountLock) {
                readCount = bean.getReadCount() == null ? 0 : bean.getReadCount();
                bean.setReadCount(readCount + 1);
            }

            this.bulDataManager.syncCache(bean, readCount + 1);
        }

    }

    public boolean check(Long spaceId, Long auditId) throws BusinessException {
        boolean flag = true;
        List<Object[]> entityObj = this.spaceManager.getSecuityOfSpace(spaceId);
        if (CollectionUtils.isEmpty(entityObj)) {
            entityObj = this.spaceManager.getSecuityOfDepartment(spaceId);
        }

        Set<Long> entityIds = new HashSet();
        String scopeStr = "";

        Object[] objects;
        for(Iterator var7 = entityObj.iterator(); var7.hasNext(); scopeStr = scopeStr + objects[0] + "|" + objects[1] + ",") {
            objects = (Object[])var7.next();
        }

        if (Strings.isNotBlank(scopeStr)) {
            scopeStr = scopeStr.substring(0, scopeStr.length() - 1);
        }

        Set<V3xOrgMember> members = this.orgManager.getMembersByTypeAndIds(scopeStr);
        Iterator var11 = members.iterator();

        while(var11.hasNext()) {
            V3xOrgMember org = (V3xOrgMember)var11.next();
            entityIds.add(org.getId());
        }

        if (entityIds.contains(auditId)) {
            flag = false;
        }

        return flag;
    }

    private void addAdmins2MsgReceivers(Collection<Long> receivers, BulData bulData) {
        BulType bulType = this.bulTypeManager.getById(bulData.getTypeId());
        this.addAdmins2MsgReceivers(receivers, bulType);
    }

    private void addAdmins2MsgReceivers(Collection<Long> receivers, BulType bulType) {
        String managerIds = bulType.getManagerUserIds();
        if (Strings.isNotBlank(managerIds)) {
            String[] ids = managerIds.split(",");
            String[] var5 = ids;
            int var6 = ids.length;

            for(int var7 = 0; var7 < var6; ++var7) {
                String id = var5[var7];
                Long addId = Long.parseLong(id);
                if (receivers != null && !receivers.contains(addId)) {
                    receivers.add(addId);
                }
            }
        }

    }

    private Set<Long> getAllMembersinPublishScope(BulData bean) throws BusinessException {
        String publishScope = bean.getPublishScope();
        Set<V3xOrgMember> membersInScope = this.orgManager.getMembersByTypeAndIds(publishScope);
        Set<Long> memberIdsInScope = new HashSet();
        if (membersInScope != null && membersInScope.size() > 0) {
            Iterator var5 = membersInScope.iterator();

            while(var5.hasNext()) {
                V3xOrgMember member = (V3xOrgMember)var5.next();
                if (member.isValid() && member.getIsInternal()) {
                    memberIdsInScope.add(member.getId());
                }
            }
        }

        Long loginAccountId = AppContext.getCurrentUser().getLoginAccount();
        String[][] bulAuditIds = Strings.getSelectPeopleElements(publishScope);
        String[][] var7 = bulAuditIds;
        int var8 = bulAuditIds.length;

        for(int var9 = 0; var9 < var8; ++var9) {
            String[] typeAndId = var7[var9];
            if (typeAndId[0].equals("Team")) {
                V3xOrgTeam team = this.orgManager.getTeamById(Long.valueOf(typeAndId[1]));
                boolean needFilterOthers = team != null && bean.getType().getSpaceType() == SpaceType.department.ordinal() && bean.getType().getSpaceType() == SpaceType.corporation.ordinal();
                if (needFilterOthers) {
                    List<V3xOrgMember> teamMember = this.orgManager.getMembersByTeam(team.getId());
                    Iterator var25 = teamMember.iterator();

                    while(var25.hasNext()) {
                        V3xOrgMember member = (V3xOrgMember)var25.next();
                        if (!member.getOrgAccountId().equals(loginAccountId) && this.orgManager.getConcurentPostsByMemberId(loginAccountId, member.getId()).isEmpty()) {
                            memberIdsInScope.remove(member.getId());
                        }
                    }
                }
            } else if (typeAndId[0].equals("Department")) {
                List<V3xOrgMember> listMember = this.orgManager.getMembersByDepartment(Long.valueOf(typeAndId[1]), false);
                Iterator var21 = listMember.iterator();

                while(var21.hasNext()) {
                    V3xOrgMember member = (V3xOrgMember)var21.next();
                    if (!memberIdsInScope.contains(member.getId())) {
                        memberIdsInScope.add(member.getId());
                    }
                }
            } else if (typeAndId[0].equals("Account")) {
                Map<Long, List<V3xOrgMember>> accJian = this.orgManager.getConcurentPostByAccount(Long.valueOf(typeAndId[1]));
                Set<Entry<Long, List<V3xOrgMember>>> accSet = accJian.entrySet();
                Iterator iter = accSet.iterator();

                while(iter.hasNext()) {
                    Entry<Long, List<V3xOrgMember>> ele = (Entry)iter.next();
                    Iterator iterator = ((List)ele.getValue()).iterator();

                    while(iterator.hasNext()) {
                        V3xOrgMember mem = (V3xOrgMember)iterator.next();
                        if (!memberIdsInScope.contains(mem.getId())) {
                            memberIdsInScope.add(mem.getId());
                        }
                    }
                }
            }
        }

        return memberIdsInScope;
    }

    private void addPendingAffair(BulType bulType, BulData bean) throws BusinessException {
        CtpAffair affair = new CtpAffair();
        affair.setIdIfNew();
        affair.setTrack(TrackEnum.no.ordinal());
        affair.setDelete(false);
        affair.setSubObjectId(Long.valueOf(bulType.getSpaceType().toString()));
        affair.setMemberId(bulType.getAuditUser());
        affair.setState(StateEnum.col_pending.key());
        affair.setSubState(SubStateEnum.col_pending_unRead.key());
        affair.setSenderId(bean.getCreateUser());
        affair.setSubject(bean.getTitle());
        affair.setObjectId(bean.getId());
        affair.setApp(ApplicationCategoryEnum.bulletin.key());
        affair.setSubApp(ApplicationSubCategoryEnum.bulletin_audit.key());
        affair.setCreateDate(new Timestamp(bean.getCreateDate().getTime()));
        affair.setReceiveTime(new Timestamp(System.currentTimeMillis()));
        AffairUtil.setHasAttachments(affair, bean.getAttachmentsFlag());
        AffairUtil.addExtProperty(affair, AffairExtPropEnums.spaceType, bulType.getSpaceType());
        AffairUtil.addExtProperty(affair, AffairExtPropEnums.spaceId, bulType.getAccountId());
        AffairUtil.addExtProperty(affair, AffairExtPropEnums.typeId, bulType.getId());
        this.affairManager.save(affair);
    }

    private void setBulDataReadInfo(BulData bean, ModelAndView mav, String deptId) throws Exception {
        List<BulRead> readList = this.bulDataManager.getReadListByData(bean.getId());
        if (readList != null) {
            List<BulReadCount> bulreadcount = new ArrayList();
            Set<Long> scopeList = this.getAllMembersinPublishScope(bean);
            Map<Long, Integer> map = new TreeMap();
            Map<Long, Integer> readCountMap = new TreeMap();
            Iterator var9 = scopeList.iterator();

            while(var9.hasNext()) {
                Long memberId = (Long)var9.next();
                V3xOrgMember member = this.orgManager.getMemberById(memberId);
                if (member != null && member.isValid()) {
                    Long departmentId = member.getOrgDepartmentId();
                    if (map.containsKey(departmentId)) {
                        map.put(departmentId, (Integer)map.get(departmentId) + 1);
                    } else {
                        map.put(departmentId, 1);
                    }
                }
            }

            boolean isCreatorInPublishScope = scopeList.contains(bean.getCreateUser());
            Iterator var15 = readList.iterator();

            while(true) {
                V3xOrgMember member;
                do {
                    do {
                        do {
                            if (!var15.hasNext()) {
                                var15 = map.keySet().iterator();

                                while(var15.hasNext()) {
                                    Long departmentId = (Long)var15.next();
                                    int readCount = readCountMap.get(departmentId) != null ? (Integer)readCountMap.get(departmentId) : 0;
                                    BulReadCount brcount = new BulReadCount();
                                    brcount.setMemberCount((Integer)map.get(departmentId));
                                    brcount.setDeptId(departmentId);
                                    brcount.setEndReadCount(readCount);
                                    if ((Integer)map.get(departmentId) - readCount < 0) {
                                        brcount.setNotReadCount(0);
                                    } else {
                                        brcount.setNotReadCount((Integer)map.get(departmentId) - readCount);
                                    }

                                    bulreadcount.add(brcount);
                                    if (departmentId.toString().equals(deptId)) {
                                        mav.addObject("brc", brcount);
                                    }
                                }

                                Collections.sort(bulreadcount);
                                mav.addObject("bulreadcount", CommonTools.pagenate(bulreadcount));
                                mav.addObject("bulreadcountAll", bulreadcount);
                                int bulendread = 0;

                                BulReadCount vv;
                                for(Iterator var19 = bulreadcount.iterator(); var19.hasNext(); bulendread += vv.getEndReadCount()) {
                                    vv = (BulReadCount)var19.next();
                                }

                                if (bean.getReadCount() < bulendread) {
                                    bean.setReadCount(bulendread);
                                }

                                mav.addObject("bulendread", bulendread);
                                return;
                            }

                            BulRead br = (BulRead)var15.next();
                            member = this.orgManager.getMemberById(br.getManagerId());
                        } while(member == null);
                    } while(!member.isValid());
                } while(member.getId().equals(bean.getCreateUser()) && !isCreatorInPublishScope);

                if (map.get(member.getOrgDepartmentId()) != null) {
                    if (readCountMap.containsKey(member.getOrgDepartmentId())) {
                        readCountMap.put(member.getOrgDepartmentId(), (Integer)readCountMap.get(member.getOrgDepartmentId()) + 1);
                    } else {
                        readCountMap.put(member.getOrgDepartmentId(), 1);
                    }
                }
            }
        }
    }

    public ModelAndView bulReadView(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("bulletin/user/bulReadView");
    }

    public ModelAndView bulReadIframe(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("bulletin/user/data_bulReadIframe");
        String deptId = request.getParameter("deptId");
        String beanId = request.getParameter("beanId");
        BulData bean = Strings.isBlank(beanId) ? new BulData() : this.bulDataManager.getById(Long.valueOf(beanId));
        mav.addObject("bean", bean);
        this.setBulDataReadInfo(bean, mav, deptId);
        mav.addObject("deptId", deptId);
        mav.addObject("beanId", beanId);
        mav.addObject("spaceType", bean.getType().getSpaceType());
        return mav;
    }

    public ModelAndView bulReadProperty(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("bulletin/user/data_bulReadProperties");
        String deptId = request.getParameter("deptId");
        String beanId = request.getParameter("beanId");
        String mode = request.getParameter("mode");
        BulData bean = Strings.isBlank(beanId) ? new BulData() : this.bulDataManager.getById(Long.valueOf(beanId));
        List<BulRead> readList = this.bulDataManager.getReadListByData(bean.getId());
        List<V3xOrgMember> memberList = new ArrayList();
        Set<BulReadCount> bulreadcount = new HashSet();
        Set<BulReadCount> bulnotreadcount = new HashSet();
        ArrayList<BulReadCount> noRead = new ArrayList();
        Long currentDepartmentId = Long.valueOf(deptId);
        Set<Long> PublishScopeList = this.getAllMembersinPublishScope(bean);
        Iterator var15 = PublishScopeList.iterator();

        while(var15.hasNext()) {
            Long v = (Long)var15.next();
            V3xOrgMember member = this.orgManager.getMemberById(v);
            if (member != null && member.isValid()) {
                Long departmentId = member.getOrgDepartmentId();
                if (departmentId.equals(currentDepartmentId)) {
                    memberList.add(member);
                }
            }
        }

        var15 = memberList.iterator();

        while(var15.hasNext()) {
            V3xOrgMember vm = (V3xOrgMember)var15.next();
            BulReadCount brcnot = new BulReadCount();
            BulReadCount brc = new BulReadCount();
            int readFlagNum = 0;
            Iterator var20 = readList.iterator();

            while(var20.hasNext()) {
                BulRead br = (BulRead)var20.next();
                V3xOrgMember member = this.orgManager.getMemberById(br.getManagerId());
                if (member != null && member.isValid() && member.getId().equals(vm.getId())) {
                    brc.setDeptId(currentDepartmentId);
                    brc.setUserId(member.getId());
                    brc.setReadDate(br.getReadDate());
                    bulreadcount.add(brc);
                    ++readFlagNum;
                }
            }

            if (readFlagNum == 0) {
                brcnot.setDeptId(currentDepartmentId);
                brcnot.setUserId(vm.getId());
                bulnotreadcount.add(brcnot);
                noRead.add(brcnot);
            }
        }

        mav.addObject("mode", mode);
        if ("normal".equals(mode)) {
            mav.addObject("bulreadcount", CommonTools.pagenate(this.convert2OrderedList(bulreadcount)));
        } else {
            mav.addObject("bulnotreadcount", CommonTools.pagenate(noRead));
        }

        return mav;
    }

    private List<BulReadCount> convert2OrderedList(Set<BulReadCount> bulreadcount) {
        List<BulReadCount> bulReadCountList = new ArrayList();
        if (bulreadcount != null && bulreadcount.size() > 0) {
            bulReadCountList.addAll(bulreadcount);
            Collections.sort(bulReadCountList);
        }

        return bulReadCountList;
    }

    public ModelAndView statisticsIframe(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("bulletin/manager/statisticsIframe");
    }

    public ModelAndView statistics(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String type = request.getParameter("type");
        String sbulTypeId = request.getParameter("bulTypeId");
        String listIframe = request.getParameter("listIframe");
        ModelAndView mav = new ModelAndView("bulletin/manager/statistics");
        if ("listIframe".equals(listIframe)) {
            mav = new ModelAndView("bulletin/manager/statisticsList");
            List<Object[]> list = new ArrayList();
            if (StringUtils.isNotBlank(sbulTypeId)) {
                this.bulDataManager.getBulDataCache().getDataCache().updateAll();
                long bulTypeId = Long.valueOf(sbulTypeId);
                list = this.bulDataManager.statistics(type, bulTypeId);
            }

            mav.addObject("list", list);
        }

        return mav;
    }

    public ModelAndView showList4QuoteFrame(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("bulletin/user/list4QuoteFrame");
        return modelAndView;
    }

    public ModelAndView list4QuoteFrame(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("collaboration/list4QuoteFrame");
    }

    public void destoryOperate(HttpServletRequest request) {
        request.getSession().removeAttribute("bulletin.typeId");
        request.getSession().removeAttribute("bulletin.type");
        request.getSession().removeAttribute("bulletin.isWriter");
        request.getSession().removeAttribute("bulletin.isAuditer");
        request.getSession().removeAttribute("bulletin.isManager");
        request.getSession().removeAttribute("bulletin.isShowPublish");
        request.getSession().removeAttribute("bulletin.isShowAudit");
        request.getSession().removeAttribute("bulletin.isShowManage");
        request.getSession().removeAttribute("bulletin.groupSign");
        request.getSession().removeAttribute("bulletin.deptSign");
        request.getSession().removeAttribute("bulletin.spaceType");
    }

    public void initOperate(HttpServletRequest request, String typeIdStr) {
        Long userId = AppContext.getCurrentUser().getId();
        if (typeIdStr != null && !"".equals(typeIdStr.trim())) {
            Long typeId = Long.valueOf(typeIdStr);
            boolean isShowPublish = false;
            boolean isShowAudit = false;
            boolean isShowManage = false;
            boolean isWriter = false;
            boolean isAuditer = false;
            boolean isManager = false;
            List<BulType> typeList = this.bulDataManager.getTypeListByWrite(AppContext.getCurrentUser().getId(), true);
            Iterator var12 = typeList.iterator();

            while(var12.hasNext()) {
                BulType type = (BulType)var12.next();
                if (type.getId() == typeId) {
                    isWriter = true;
                    break;
                }
            }

            BulType type = this.bulTypeManager.getById(typeId);
            if (type != null && type.isAuditFlag() && type.getAuditUser() == userId) {
                isAuditer = true;
            }

            String groupSign = (String)request.getSession().getAttribute("bulletin.groupSign");
            if (groupSign != null) {
                isShowAudit = !this.bulTypeManager.getAuditGroupBulType(userId).isEmpty();
            } else {
                isShowAudit = !this.bulTypeManager.getAuditUnitBulType(userId).isEmpty();
            }

            try {
                isShowManage = this.bulDataManager.getTypeList(userId, true).size() > 0;
            } catch (Exception var15) {
                log.error("", var15);
            }

            if (type != null && type.getManagerUserIds().indexOf(userId.toString()) > -1) {
                isManager = true;
            }

            isShowPublish = isWriter || isManager;
            request.getSession().setAttribute("bulletin.typeId", typeId);
            request.getSession().setAttribute("bulletin.type", type);
            request.getSession().setAttribute("bulletin.isWriter", isWriter);
            request.getSession().setAttribute("bulletin.isAuditer", isAuditer);
            request.getSession().setAttribute("bulletin.isManager", isManager);
            request.getSession().setAttribute("bulletin.isShowPublish", isShowPublish);
            request.getSession().setAttribute("bulletin.isShowAudit", isShowAudit);
            request.getSession().setAttribute("bulletin.isShowManage", isShowManage);
        }
    }

    public ModelAndView showDesignated(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("bulletin/user/showDesignated");
        List<BulType> typeList = null;
        String group = request.getParameter("group");
        String textfield = request.getParameter("textfield");
        if (Strings.isNotBlank(group)) {
            typeList = this.bulTypeManager.groupFindAll();
        } else {
            typeList = this.bulTypeManager.boardFindAll();
        }

        List<BulType> resultList = new ArrayList();
        if (Strings.isNotBlank(textfield)) {
            Iterator var8 = typeList.iterator();

            while(var8.hasNext()) {
                BulType type = (BulType)var8.next();
                if (type.getTypeName().contains(textfield)) {
                    ((List)resultList).add(type);
                }
            }
        } else {
            resultList = typeList;
        }

        mav.addObject("typeList", resultList);
        return mav;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    public void setContentTemplateManager(ContentTemplateManager contentTemplateManager) {
        this.contentTemplateManager = contentTemplateManager;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setUserMessageManager(UserMessageManager userMessageManager) {
        this.userMessageManager = userMessageManager;
    }

    public void setBulTypeManager(BulTypeManager bulTypeManager) {
        this.bulTypeManager = bulTypeManager;
    }

    public void setBulReadManager(BulReadManager bulReadManager) {
        this.bulReadManager = bulReadManager;
    }

    public void setIndexManager(IndexManager indexManager) {
        this.indexManager = indexManager;
    }

    public void setBulDataManager(BulDataManager bulDataManager) {
        this.bulDataManager = bulDataManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public void setSpaceManager(SpaceManager spaceManager) {
        this.spaceManager = spaceManager;
    }

    public ModelAndView listType(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String typeIdsStr = request.getParameter("typeIds");
        String ids = request.getParameter("ids");
        ModelAndView mav = new ModelAndView("bulletin/manager/moveTo");
        BulType type = null;
        List<BulType> typeList = new ArrayList();
        if (Strings.isNotEmpty(typeIdsStr)) {
            String[] str = typeIdsStr.split(",");

            for(int i = 0; i < str.length; ++i) {
                type = this.bulTypeManager.getById(Long.valueOf(str[i]));
                if (type != null) {
                    ((List)typeList).add(type);
                }
            }
        } else {
            String typeId = request.getParameter("typeId");
            User user = AppContext.getCurrentUser();
            BulType bulType = this.bulTypeManager.getById(Long.valueOf(typeId));
            typeList = this.getCanAdminTypes(user.getId(), bulType);
        }

        Collections.sort((List)typeList);
        mav.addObject("typeList", typeList);
        mav.addObject("ids", ids);
        return mav;
    }

    public ModelAndView moveToType(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idStr = request.getParameter("ids");
        String typeId = request.getParameter("typeId");
        BulData bean = null;
        if (StringUtils.isBlank(idStr)) {
            throw new Exception("bbs_not_exists");
        } else {
            String[] ids = idStr.split(",");
            Map<String, Object> summ = new HashMap();
            String[] var8 = ids;
            int var9 = ids.length;

            for(int var10 = 0; var10 < var9; ++var10) {
                String id = var8[var10];
                if (StringUtils.isNotBlank(id)) {
                    bean = (BulData)this.bulDataManager.getBulDataCache().getDataCache().get(Long.valueOf(id));
                    if (bean == null) {
                        bean = this.bulDataManager.getById(Long.valueOf(id));
                    }

                    this.bulTypeManager.updateTypeETagDate(String.valueOf(bean.getTypeId()));
                    bean.setTopOrder(Byte.valueOf("0"));
                    bean.setTypeId(Long.valueOf(typeId));
                    BulType type = this.bulTypeManager.getById(Long.valueOf(typeId));
                    bean.setType(type);
                    summ.put("typeId", bean.getTypeId());
                    summ.put("topOrder", Byte.valueOf("0"));
                    this.bulDataManager.update(bean.getId(), summ);
                    this.bulTypeManager.updateTypeETagDate(String.valueOf(bean.getTypeId()));
                }
            }

            super.rendJavaScript(response, "alert(\"" + ResourceUtil.getString("bbs.board.moved") + "\");parent.cloWithSuccess();");
            return null;
        }
    }

    public ModelAndView publishInfoStc(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("stc/publishInfoStc");
        int year = DateUtil.getYear();
        Map<String, Object> jval = new HashMap();
        jval.put("year", year);
        jval.put("publishDateStart", year + "-01-01");
        jval.put("publishDateEnd", DateUtil.format(new Date()));
        String mode = request.getParameter("mode");
        String spceTypeId = request.getParameter("typeId");
        Map<String, Object> modeType = this.bulDataManager.getTypeByMode(mode, spceTypeId);
        jval.put("isGroupStc", !(Boolean)modeType.get("hideAcc"));
        jval.put("isStcDeptHide", modeType.get("hideDept"));
        jval.put("isStcAccHide", modeType.get("hideAcc"));
        jval.put("mode", mode);
        jval.put("spaceType", request.getParameter("spaceType"));
        jval.put("spaceId", spceTypeId);
        jval.put("typeId", request.getParameter("typeId"));
        mav.addObject("today", DateUtil.format(new Date()));
        mav.addObject("jval", Strings.escapeJson(JSONUtil.toJSONString(jval)));
        return mav;
    }

    public ModelAndView stcExpToXls(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map<String, Object> param = ParamUtil.getJsonParams();
        DataRecord record = this.bulDataManager.expStcToXls(param);
        this.fileToExcelManager.save(response, record.getTitle(), new DataRecord[]{record});
        return null;
    }

    public void setDocApi(DocApi docApi) {
        this.docApi = docApi;
    }

    public BulletinUtils getBulletinUtils() {
        return this.bulletinUtils;
    }

    public void setBulletinUtils(BulletinUtils bulletinUtils) {
        this.bulletinUtils = bulletinUtils;
    }

    public void setCollaborationApi(CollaborationApi collaborationApi) {
        this.collaborationApi = collaborationApi;
    }

    public void setCtpMainbodyManager(MainbodyManager ctpMainbodyManager) {
        this.ctpMainbodyManager = ctpMainbodyManager;
    }

    public void setBulIssueManager(BulIssueManager bulIssueManager) {
        this.bulIssueManager = bulIssueManager;
    }

    public FileToExcelManager getFileToExcelManager() {
        return this.fileToExcelManager;
    }

    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }

    public ModelAndView bulIndex(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("bulletin/bulIndex");
        User user = AppContext.getCurrentUser();
        int spaceType = NumberUtils.toInt(request.getParameter("spaceType"));
        Long spaceId = NumberUtils.toLong(request.getParameter("spaceId"));
        String typeIds = request.getParameter("typeId");
        BulType bulType;
        List customBulTypeList;
        boolean flag;
        if (Strings.isNotBlank(typeIds)) {
            bulType = this.bulTypeManager.getById(Long.valueOf(typeIds));
            BulTypeModel bulTypeModel = new BulTypeModel(bulType, user.getId(), this.orgManager.getAllUserDomainIDs(user.getId()));
            bulTypeModel.setId(bulType.getId());
            bulTypeModel.setBulName(bulType.getTypeName());
            bulTypeModel.setTopNumber(String.valueOf(bulType.getTopCount()));
            if (bulType.getAuditUser() != 0L) {
                bulTypeModel.setAuditName(Functions.showMemberName(bulType.getAuditUser()));
            } else {
                bulTypeModel.setAuditName("");
            }

            StringBuilder typeAdmins = new StringBuilder();
            Set<Long> adminIds = new HashSet();
            Iterator var13;
            V3xOrgMember member;
            List canAdminTypes;
            if (spaceType != SpaceType.department.ordinal()) {
                if (bulType.getSpaceType() == SpaceType.custom.ordinal()) {
                    customBulTypeList = this.spaceManager.getSpaceMemberBySecurity(bulType.getId(), SecurityType.manager.ordinal());
                    var13 = customBulTypeList.iterator();

                    while(var13.hasNext()) {
                        member = (V3xOrgMember)var13.next();
                        if (member != null) {
                            adminIds.add(member.getId());
                        }
                    }
                } else {
                    Iterator var23 = bulType.getBulTypeManagers().iterator();

                    while(var23.hasNext()) {
                        BulTypeManagers tm = (BulTypeManagers)var23.next();
                        if (!"write".equals(tm.getExt1())) {
                            adminIds.add(tm.getManagerId());
                        }
                    }
                }
            } else {
                customBulTypeList = this.orgManager.getMembersByRole(bulType.getId(), Role_NAME.DepManager.name());
                if (Strings.isNotEmpty(customBulTypeList)) {
                    var13 = customBulTypeList.iterator();

                    while(var13.hasNext()) {
                        member = (V3xOrgMember)var13.next();
                        if (member != null) {
                            adminIds.add(member.getId());
                        }
                    }
                }

                canAdminTypes = this.spaceManager.getSecuityOfDepartment(bulType.getId(), SecurityType.manager.ordinal());
                if (Strings.isNotEmpty(canAdminTypes)) {
                    Iterator var27 = canAdminTypes.iterator();

                    while(var27.hasNext()) {
                        Object[] object = (Object[])var27.next();
                        adminIds.add((Long)object[1]);
                    }
                }
            }

            flag = false;
            Long adminId;
            if (Strings.isNotEmpty(adminIds)) {
                for(var13 = adminIds.iterator(); var13.hasNext(); typeAdmins.append(Functions.showMemberName(adminId))) {
                    adminId = (Long)var13.next();
                    if (adminId.equals(user.getId())) {
                        bulTypeModel.setCanAdminOfCurrent(true);
                        bulTypeModel.setCanNewOfCurrent(true);
                    }

                    if (flag) {
                        typeAdmins.append("、");
                    } else {
                        flag = true;
                    }
                }
            }

            bulTypeModel.setAdminsName(typeAdmins.toString());
            mav.addObject("bulTypeMessage", bulTypeModel);
            canAdminTypes = this.getCanAdminTypes(user.getId(), bulType);
            mav.addObject("canMove", Strings.isNotEmpty(canAdminTypes));
        }

        bulType = null;
        List myBulTypeIds;
        if (spaceType != SpaceType.group.ordinal() && spaceType != SpaceType.corporation.ordinal()) {
            myBulTypeIds = this.bulDataManager.getMyBulTypeIds(spaceType, spaceId);
        } else {
            myBulTypeIds = this.bulDataManager.getMyBulTypeIds(0, spaceId);
        }

        mav.addObject("myIssueCount", this.bulDataManager.getMyIssueCount(user.getId(), myBulTypeIds));
        if (AppContext.hasPlugin("doc")) {
            mav.addObject("myCollectCount", this.bulDataManager.getMyCollectCount(user.getId(), myBulTypeIds));
        }

        mav.addObject("myAuditCount", this.bulDataManager.getMyAuditCount(user.getId(), myBulTypeIds));
        boolean hasIssue = false;
        boolean auditManager = false;
        Map<String, List<BulTypeModel>> bulTypeModelMap = new LinkedHashMap();
        ArrayList customBulTypeModelList;
        boolean[] _per;
        if (spaceType == SpaceType.public_custom.ordinal()) {
            customBulTypeList = this.bulTypeManager.customAccBoardAllBySpaceId(spaceId, spaceType);
            customBulTypeModelList = new ArrayList();
            _per = this.toBulTypeModel(customBulTypeList, customBulTypeModelList);
            hasIssue = _per[0];
            auditManager = _per[1];
            bulTypeModelMap.put("bulletin.type.public.custom", customBulTypeModelList);
        } else if (spaceType == SpaceType.public_custom_group.ordinal()) {
            customBulTypeList = this.bulTypeManager.customAccBoardAllBySpaceId(spaceId, spaceType);
            customBulTypeModelList = new ArrayList();
            _per = this.toBulTypeModel(customBulTypeList, customBulTypeModelList);
            hasIssue = _per[0];
            auditManager = _per[1];
            bulTypeModelMap.put("bulletin.type.public.custom.group", customBulTypeModelList);
        } else if (spaceType == SpaceType.custom.ordinal()) {
            customBulTypeList = this.bulTypeManager.customAccBoardAllBySpaceId(spaceId, spaceType);
            customBulTypeModelList = new ArrayList();
            _per = this.toBulTypeModel(customBulTypeList, customBulTypeModelList);
            hasIssue = _per[0];
            auditManager = _per[1];
            bulTypeModelMap.put("bulletin.type.custom", customBulTypeModelList);
        } else if (spaceType == SpaceType.department.ordinal()) {
            List<PortalSpaceFix> deptSpaces = new ArrayList();
            PortalSpaceFix Spaces = this.spaceManager.getDeptSpaceIdByDeptId(spaceId);
            deptSpaces.add(Spaces);
            List<BulTypeModel> deptBoardModelList = new ArrayList();
             _per = this.getDeptBulModelList(deptSpaces, user.getId(), deptBoardModelList);
            hasIssue = _per[0];
            auditManager = _per[1];
            bulTypeModelMap.put("bulletin.type.department", deptBoardModelList);
        } else {
            flag = false;
            boolean hasGroupAudit = false;
            if ((Boolean)((Boolean)SysFlag.sys_isGroupVer.getFlag()) && user.isInternal()) {
                List<BulType> groupBulTypeList = this.bulTypeManager.groupFindAll();
                List<BulTypeModel> groupBulTypeModelList = new ArrayList();
                boolean[] _perGroup = this.toBulTypeModel(groupBulTypeList, groupBulTypeModelList);
                flag = _perGroup[0];
                hasGroupAudit = _perGroup[1];
                bulTypeModelMap.put("bulletin.type.group", groupBulTypeModelList);
            }

            boolean hasAccountIssue = false;
            boolean hasAccountAudit = false;
            List<BulType> accountBulTypeList = this.bulTypeManager.boardFindAllByAccountId(user.getLoginAccount());
            List<BulTypeModel> accountNewsTypeModelList = new ArrayList();
            boolean[] _perAccount = this.toBulTypeModel(accountBulTypeList, accountNewsTypeModelList);
            hasAccountIssue = _perAccount[0];
            hasAccountAudit = _perAccount[1];
            bulTypeModelMap.put("bulletin.type.corporation", accountNewsTypeModelList);
            hasIssue = flag || hasAccountIssue;
            auditManager = hasGroupAudit || hasAccountAudit;
        }

        mav.addObject("bulTypeModelMap", bulTypeModelMap);
        mav.addObject("hasIssue", hasIssue);
        mav.addObject("auditManager", auditManager);
        return mav;
    }

    public ModelAndView bulMyInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("bulletin/bulMyInfo");
        User user = AppContext.getCurrentUser();
        int spaceType = NumberUtils.toInt(request.getParameter("spaceType"));
        Long spaceId = NumberUtils.toLong(request.getParameter("spaceId"));
        List<Long> myBulTypeIds = null;
        if (spaceType != SpaceType.group.ordinal() && spaceType != SpaceType.corporation.ordinal()) {
            myBulTypeIds = this.bulDataManager.getMyBulTypeIds(spaceType, spaceId);
        } else {
            myBulTypeIds = this.bulDataManager.getMyBulTypeIds(0, spaceId);
        }

        mav.addObject("type", request.getParameter("type"));
        boolean hasIssue = this.bulDataManager.hasPermission(spaceType, spaceId, user)[0];
        mav.addObject("hasIssue", hasIssue);
        mav.addObject("auditManager", this.bulTypeManager.isAuditorOfBul(user.getId()));
        mav.addObject("myIssueCount", this.bulDataManager.getMyIssueCount(user.getId(), myBulTypeIds));
        if (AppContext.hasPlugin("doc")) {
            mav.addObject("myCollectCount", this.bulDataManager.getMyCollectCount(user.getId(), myBulTypeIds));
        }

        mav.addObject("myAuditCount", this.bulDataManager.getMyAuditCount(user.getId(), myBulTypeIds));
        return mav;
    }

    public ModelAndView bulSearch(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("bulletin/bulSearch");
        return mav;
    }

    public ModelAndView bulEdit(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        ModelAndView mav = new ModelAndView("bulletin/bulEdit");
        String bulTypeStr = request.getParameter("bulTypeId");
        String bulId = request.getParameter("bulId");
        String spaceTypeStr = request.getParameter("spaceType");
        String spaceId = request.getParameter("spaceId");
        mav.addObject("spaceType", spaceTypeStr);
        mav.addObject("spaceId", spaceId);
        System.out.println("-------------ok----------------");
        if(!StringUtils.isEmpty(bulId)){
            System.out.println("-------------ok1----------------");
            List<BulForceRead> reads = DBAgent.find("from BulForceRead where bulId="+bulId);
            System.out.println("-------------ok2:"+JSON.toJSONString(reads));
            if(!CollectionUtils.isEmpty(reads)){
                mav.addObject("forceRead", "1");
            }else{
                mav.addObject("forceRead", "0");
            }
        }else{
            mav.addObject("forceRead", "0");
        }
        String oper = request.getParameter("form_oper");
        BulData bean = new BulData();
        int spaceTypeInt = SpaceType.corporation.ordinal();
        if (Strings.isNotBlank(spaceTypeStr)) {
            spaceTypeInt = Integer.valueOf(spaceTypeStr);
        }

        List<Attachment> attachments = null;
        Long bulDataId;
        BulBody attRefId;
        String bulSyle;
        String templateId;
        Long publistDepartIdDef;
        if (Strings.isNotBlank(bulId)) {
            bulDataId = NumberUtils.toLong(bulId);
            bean = (BulData)this.bulDataManager.getBulDataCache().getDataCache().get(bulDataId);
            if (bean == null) {
                bean = this.bulDataManager.getById(bulDataId);
            }

            if (bean == null || bean.isDeletedFlag()) {
                super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString("com.seeyon.v3x.bulletin.resources.i18n.BulletinResource", "bul.data.noexist", new Object[0]) + "');window.close();");
                return null;
            }

            attRefId = this.bulDataManager.getBody(bean.getId());
            bean.setContent(attRefId.getContent());
            bean.setContentName(attRefId.getContentName());
            bulSyle = "bul.lockaction.edit";
            BulDataLock bullock = this.bulDataManager.lock(Long.valueOf(bulId), bulSyle);
            if (bullock != null && bullock.getUserid() != user.getId()) {
                V3xOrgMember orm = this.orgManager.getMemberById(bullock.getUserid());
                String lockmessage = bullock.getAction();
                super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString("com.seeyon.v3x.bulletin.resources.i18n.BulletinResource", lockmessage, new Object[]{orm.getName()}) + "');window.close();");
                return null;
            }

            bulTypeStr = bean.getTypeId().toString();
            BulType bulType = this.bulTypeManager.getById(Long.valueOf(bulTypeStr));
            spaceTypeStr = bulType.getSpaceType().toString();
            bean.setContent(this.bulDataManager.getBody(bulDataId).getContent());
            attachments = this.attachmentManager.getByReference(bean.getId(), bean.getId());
            boolean isAduit = false;
            if (null != bean.getAuditUserId() && 0L != bean.getAuditUserId()) {
                isAduit = true;
            }

            mav.addObject("isAduit", isAduit);
            String isAuditEdit = request.getParameter("isAuditEdit");
            if (isAuditEdit != null && "true".equals(isAuditEdit)) {
                Map<String, String> option = new HashMap();
                option.put("1", bulType.getId().toString());
                option.put("2", bulType.getTypeName());
                String spaceTypeName = "";
                if ("1".equals(bulType.getSpaceType().toString())) {
                    spaceTypeName = ResourceUtil.getString("bulletin.type.department");
                } else if ("2".equals(bulType.getSpaceType().toString())) {
                    spaceTypeName = ResourceUtil.getString("bulletin.type.corporation");
                } else if ("3".equals(bulType.getSpaceType().toString())) {
                    spaceTypeName = ResourceUtil.getString("bulletin.type.group");
                } else if ("4".equals(bulType.getSpaceType().toString())) {
                    spaceTypeName = ResourceUtil.getString("bulletin.type.custom");
                } else if ("17".equals(bulType.getSpaceType().toString())) {
                    spaceTypeName = ResourceUtil.getString("bulletin.type.public.custom");
                } else if ("18".equals(bulType.getSpaceType().toString())) {
                    spaceTypeName = ResourceUtil.getString("bulletin.type.public.custom.group");
                }

                option.put("3", bulType.getSpaceType().toString());
                option.put("4", spaceTypeName);
                mav.addObject("option", JSONUtil.toJSONString(option));
            }

            mav.addObject("DEPARTMENTissueArea", bean.getPublishScope());
            mav.addObject("spaceType", bulType.getSpaceType().toString());
        } else {
            bean.setCreateDate(new Timestamp(System.currentTimeMillis()));
            bean.setCreateUser(user.getId());
            bean.setState(0);
            bean.setDataFormat("HTML");
            bean.setReadCount(0);
            if (user.getLoginAccount() != user.getAccountId()) {
                List<MemberPost> memberPostList = this.orgManager.getMemberConcurrentPostsByAccountId(user.getId(), user.getLoginAccount());
                if (Strings.isNotEmpty(memberPostList)) {
                    bean.setPublishDepartmentId(((MemberPost)memberPostList.get(0)).getDepId());
                }
            } else {
                bean.setPublishDepartmentId(user.getDepartmentId());
            }

            bean.setContent((String)null);
            bulDataId = null;
            attRefId = null;
            bulSyle = request.getParameter("attFlag");
            boolean attFlag = true;
            if ("false".equalsIgnoreCase(bulSyle)) {
                attFlag = false;
            }

            String idStr = request.getParameter("id");
            if (Strings.isNotBlank(idStr)) {
                bean.setId(Long.valueOf(idStr));
                this.attachmentManager.deleteByReference(bean.getId(), bean.getId());
                templateId = this.attachmentManager.create(ApplicationCategoryEnum.bulletin, bean.getId(), bean.getId(), request);
                attFlag = false;
                mav.addObject("attRefId", attRefId);
                mav.addObject("attFlag", attFlag);
                attachments = this.attachmentManager.getByReference(bean.getId(), bean.getId());
                mav.addObject("attachments", attachments);
            } else {
                if (attFlag) {
                    Long newId = UUIDLong.longUUID();
                    templateId = this.attachmentManager.create(ApplicationCategoryEnum.bulletin, newId, newId, request);
                    publistDepartIdDef = newId;
                    attFlag = false;
                    mav.addObject("attRefId", newId);
                    mav.addObject("attFlag", attFlag);
                } else {
                    publistDepartIdDef = Long.valueOf(request.getParameter("attRefId"));
                    this.attachmentManager.deleteByReference(publistDepartIdDef, publistDepartIdDef);
                    templateId = this.attachmentManager.create(ApplicationCategoryEnum.bulletin, publistDepartIdDef, publistDepartIdDef, request);
                    attFlag = false;
                    mav.addObject("attRefId", publistDepartIdDef);
                    mav.addObject("attFlag", attFlag);
                }

                attachments = this.attachmentManager.getByReference(publistDepartIdDef, publistDepartIdDef);
                mav.addObject("attachments", attachments);
            }

            if (Constants.isUploadLocaleFile(templateId)) {
                bean.setAttachmentsFlag(true);
            }
        }

        mav.addObject("bulTypeId", bulTypeStr);
        mav.addObject("attachments", attachments);
        if (StringUtils.isNotBlank(oper) && "loadTemplate".equals(oper)) {
            super.bind(request, bean);
            bean.setShowPublishUserFlag("true".equals(request.getParameter("showPublish")));
            if (request.getParameterValues("noteCallInfo") != null && "1".equals(request.getParameterValues("noteCallInfo")[0])) {
                bean.setExt1("1");
            } else {
                bean.setExt1("0");
            }

            if (request.getParameterValues("printAllow") != null && "1".equals(request.getParameterValues("printAllow")[0])) {
                bean.setExt2("1");
            } else {
                bean.setExt2("0");
            }

            templateId = request.getParameter("templateId");
            if (StringUtils.isNotBlank(templateId)) {
                ContentTemplate template = this.contentTemplateManager.getById(Long.valueOf(templateId));
                if (template != null) {
                    bean.setDataFormat(template.getTemplateFormat());
                    bean.setContent(template.getContent());
                    bean.setCreateDate(new Timestamp(template.getCreateDate().getTime()));
                    mav.addObject("templateId", template.getId());
                }

                mav.addObject("originalNeedClone", true);
            } else {
                bean.setDataFormat("HTML");
                bean.setContent((String)null);
            }
        }

        if (bulTypeStr != null && StringUtils.isNotBlank(bulTypeStr)) {
            BulType type = this.bulTypeManager.getById(Long.valueOf(bulTypeStr));
            bean.setType(type);
            bean.setTypeId(Long.valueOf(bulTypeStr));
        }

        templateId = request.getParameter("spaceType_change");
        if (Strings.isNotBlank(templateId) && "1".equals(templateId)) {
            publistDepartIdDef = bean.getPublishDepartmentId();
            super.bind(request, bean);
            bean.setPublishDepartmentId(publistDepartIdDef);
            bean.setPublishScope((String)null);
            if (StringUtils.isNotBlank(request.getParameter("bulTempl"))) {
                bean.setDataFormat("HTML");
                bean.setContent((String)null);
            }
        }

        mav.addObject("bean", bean);
        mav.addObject("constants", new com.seeyon.v3x.bulletin.util.Constants());
        String bulPreview = request.getParameter("bulPreview");
        if (StringUtils.isNotBlank(bulPreview) && "bulPreview".equals(bulPreview)) {
            bulSyle = bean.getType().getExt1();
            ModelAndView mavPre = new ModelAndView("bulletin/bulView_detail" + Integer.valueOf(bulSyle));
            mavPre.addObject("bean", bean);
            mavPre.addObject("attachments", attachments);
            return mavPre;
        } else {
            Map<String, List<Map<String, String>>> boardListMap = new HashMap();
            List<BulType> bulTypeListGroup = new ArrayList();
            List<BulType> bulTypeListAcc = new ArrayList();
            List<BulType> bulTypeListCustom = new ArrayList();
            List<Map<String, String>> newBulTypeListGroup = new ArrayList();
            List<Map<String, String>> newBulTypeListAcc = new ArrayList();
            List<Map<String, String>> newBulTypeListCustom = new ArrayList();
            String groupKey = "";
            String accountkey = "";
            if (!Strings.isNotBlank(spaceId) || Integer.valueOf(spaceTypeStr) != SpaceType.public_custom_group.ordinal() && Integer.valueOf(spaceTypeStr) != SpaceType.public_custom.ordinal() && Integer.valueOf(spaceTypeStr) != SpaceType.custom.ordinal()) {
                if (spaceTypeInt == SpaceType.department.ordinal()) {
                    List<PortalSpaceFix> deptSpaceModels = new ArrayList();
                    PortalSpaceFix departSpace = this.spaceManager.getDeptSpaceIdByDeptId(Long.valueOf(spaceId));
                    deptSpaceModels.add(departSpace);
                    mav.addObject("deptSpaceModels", deptSpaceModels);
                    mav.addObject("deptSpaceModelsLength", deptSpaceModels.size());
                    mav.addObject("DEPARTMENTissueArea", "Department|" + bulTypeStr);
                    mav.addObject("ChildDeptissueArea", "Department|" + bulTypeStr);
                } else {
                    bulTypeListGroup = this.bulTypeManager.getTypesCanCreate(user.getId(), com.seeyon.v3x.bulletin.util.Constants.valueOfSpaceType(3), user.getLoginAccount());
                    groupKey = "bulletin.type.group";
                    bulTypeListAcc = this.bulTypeManager.getTypesCanCreate(user.getId(), com.seeyon.v3x.bulletin.util.Constants.valueOfSpaceType(2), user.getLoginAccount());
                    accountkey = "bulletin.type.corporation";
                }
            } else {
                StringBuilder publisthScopeSpace;
                List issueAreas;
                Iterator var26;
                Object[] arr;
                if (Integer.valueOf(spaceTypeStr) == SpaceType.public_custom_group.ordinal()) {
                    bulTypeListGroup = this.bulTypeManager.getTypesCanCreate(user.getId(), com.seeyon.v3x.bulletin.util.Constants.valueOfSpaceType(18), Long.valueOf(spaceId));
                    groupKey = "bulletin.type.public.custom.group";
                    publisthScopeSpace = new StringBuilder();
                    issueAreas = this.spaceManager.getSecuityOfSpace(Long.valueOf(spaceId));
                    var26 = issueAreas.iterator();

                    while(var26.hasNext()) {
                        arr = (Object[])var26.next();
                        publisthScopeSpace.append(StringUtils.join(arr, "|") + ",");
                    }

                    mav.addObject("entity", publisthScopeSpace.substring(0, publisthScopeSpace.length() - 1));
                    mav.addObject("DEPARTMENTissueArea", publisthScopeSpace.substring(0, publisthScopeSpace.length() - 1));
                } else if (Integer.valueOf(spaceTypeStr) == SpaceType.public_custom.ordinal()) {
                    bulTypeListAcc = this.bulTypeManager.getTypesCanCreate(user.getId(), com.seeyon.v3x.bulletin.util.Constants.valueOfSpaceType(17), Long.valueOf(spaceId));
                    accountkey = "bulletin.type.public.custom";
                    publisthScopeSpace = new StringBuilder();
                    issueAreas = this.spaceManager.getSecuityOfSpace(Long.valueOf(spaceId));
                    var26 = issueAreas.iterator();

                    while(var26.hasNext()) {
                        arr = (Object[])var26.next();
                        publisthScopeSpace.append(StringUtils.join(arr, "|") + ",");
                    }

                    mav.addObject("entity", publisthScopeSpace.substring(0, publisthScopeSpace.length() - 1));
                    mav.addObject("DEPARTMENTissueArea", publisthScopeSpace.substring(0, publisthScopeSpace.length() - 1));
                } else if (Integer.valueOf(spaceTypeStr) == SpaceType.custom.ordinal()) {
                    BulType bul = this.bulTypeManager.getById(Long.valueOf(spaceId));
                    bulTypeListCustom.add(bul);
                     publisthScopeSpace = new StringBuilder();
                     issueAreas = this.spaceManager.getSecuityOfSpace(Long.valueOf(spaceId));
                    Iterator var58 = issueAreas.iterator();

                    while(var58.hasNext()) {
                         arr = (Object[])var58.next();
                        publisthScopeSpace.append(StringUtils.join(arr, "|") + ",");
                    }

                    if (publisthScopeSpace.length() > 0) {
                        publisthScopeSpace.substring(0, publisthScopeSpace.length() - 1);
                    }

                    List<Object[]> entityObj = this.spaceManager.getSecuityOfSpace(Long.valueOf(spaceId));
                    String entity = "";

                    Object[] obj;
                    for(Iterator var29 = entityObj.iterator(); var29.hasNext(); entity = entity + obj[0] + "|" + obj[1] + ",") {
                        obj = (Object[])var29.next();
                    }

                    if (!"".equals(entity)) {
                        entity = entity.substring(0, entity.length() - 1);
                    }

                    mav.addObject("entity", entity);
                    mav.addObject("DEPARTMENTissueArea", publisthScopeSpace);
                }
            }

            Iterator var52;
            BulType bulType1;
            HashMap mapType;
            if (bulTypeListGroup != null && ((List)bulTypeListGroup).size() > 0) {
                mav.addObject("groupSize", "true");
                var52 = ((List)bulTypeListGroup).iterator();

                while(var52.hasNext()) {
                    bulType1 = (BulType)var52.next();
                    mapType = new HashMap();
                    mapType.put("id", String.valueOf(bulType1.getId()));
                    mapType.put("typeName", bulType1.getTypeName());
                    newBulTypeListGroup.add(mapType);
                }

                boardListMap.put(groupKey, newBulTypeListGroup);
            } else {
                mav.addObject("groupSize", "false");
            }

            if (bulTypeListAcc != null && ((List)bulTypeListAcc).size() > 0) {
                mav.addObject("corporationSize", "true");
                var52 = ((List)bulTypeListAcc).iterator();

                while(var52.hasNext()) {
                    bulType1 = (BulType)var52.next();
                    mapType = new HashMap();
                    mapType.put("id", String.valueOf(bulType1.getId()));
                    mapType.put("typeName", bulType1.getTypeName());
                    newBulTypeListAcc.add(mapType);
                }

                boardListMap.put(accountkey, newBulTypeListAcc);
            } else {
                mav.addObject("corporationSize", "false");
            }

            if (bulTypeListCustom != null && bulTypeListCustom.size() > 0) {
                mav.addObject("customSize", "true");
                var52 = bulTypeListCustom.iterator();

                while(var52.hasNext()) {
                    bulType1 = (BulType)var52.next();
                    mapType = new HashMap();
                    mapType.put("id", String.valueOf(bulType1.getId()));
                    mapType.put("typeName", bulType1.getTypeName());
                    newBulTypeListCustom.add(mapType);
                }

                boardListMap.put("bulletin.type.custom", newBulTypeListCustom);
            } else {
                mav.addObject("customSize", "false");
            }

            mav.addObject("boardListMap", boardListMap);
            mav.addObject("boardListMapJson", JSONUtil.toJSONString(boardListMap));
            return mav;
        }
    }

    public ModelAndView createBulContent(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("bulletin/bulContent");
        String idStr = request.getParameter("bulId");
        String content = request.getParameter("content");
        if (!Strings.isBlank(idStr)) {
            Long bulId = Long.parseLong(idStr);
            BulBody body = this.bulDataManager.getBody(bulId);
            if (body != null) {
                content = body.getContent();
                mav.addObject("body", body);
            }
        }

        mav.addObject("content", content);
        return mav;
    }

    public ModelAndView userView(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return super.redirectModelAndView("/bulData.do?method=bulView&bulId=" + request.getParameter("id"));
    }

    public ModelAndView bulView(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("bulletin/bulView");
        String idStr = request.getParameter("bulId");
        String from = request.getParameter("from");
        User user = AppContext.getCurrentUser();
        Long bulId = Long.valueOf(idStr);
        BulData bean = (BulData)this.bulDataManager.getBulDataCache().getDataCache().get(bulId);
        boolean hasCache = false;
        if (bean == null) {
            bean = this.bulDataManager.getById(bulId);
        } else {
            hasCache = true;
        }

        String alertInfo = ResourceUtil.getString("bulletin.dataStateError");
        if (bean != null && bean.getType().isUsedFlag() && !bean.isDeletedFlag()) {
            BulBody body = this.bulDataManager.getBody(bean.getId());
            bean.setContent(body.getContent());
            bean.setContentName(body.getContentName());
            this.getBulletinUtils().initData(bean);
            mav.addObject("bean", bean);
            String bulStyle;
            if (bean.getAttachmentsFlag()) {
                List<Attachment> attachments = this.attachmentManager.getByReference(bean.getId(), bean.getId());
                bulStyle = this.attachmentManager.getAttListJSON(attachments);
                mav.addObject("attListJSON", bulStyle);
            } else {
                mav.addObject("attListJSON", "");
            }

            boolean state_noPublish = false;
            if (bean.getState() != 30 && bean.getState() != 100) {
                state_noPublish = true;
            }

            bulStyle = bean.getType().getExt1();
            Long userId;
            String collectFlag;
            if (state_noPublish) {
                mav.setViewName("bulletin/bulView_detail" + Integer.valueOf(bulStyle));
                if ("list".equals(from) || "myCollect".equals(from) || "message".equals(from) && !bean.getType().isAuditFlag()) {
                    super.rendJavaScript(response, "alert('" + alertInfo + "');window.close();");
                    return mav.addObject("dataExist", Boolean.FALSE);
                }

                mav.addObject("dataExist", Boolean.TRUE);
                userId = bean.getType().getAuditUser();
                Long agentId = AgentUtil.getAgentByApp(userId, ApplicationCategoryEnum.bulletin.getKey());
                if ("myAudit".equals(from) || "message".equals(from) && (user.getId().equals(userId) || user.getId().equals(agentId))) {
                    if (bean.getState() == 10) {
                        collectFlag = "bul.lockaction.audit";
                        BulDataLock bullock = this.bulDataManager.lock(bulId, collectFlag);
                        if (bullock != null && bullock.getUserid() != AppContext.currentUserId()) {
                            String lockaction = bullock.getAction();
                            V3xOrgMember orm = this.orgManager.getMemberById(bullock.getUserid());
                            super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString("com.seeyon.v3x.bulletin.resources.i18n.BulletinResource", lockaction, new Object[]{orm.getName(), 2}) + "');window.close();");
                            return null;
                        }

                        List<CtpAffair> updateaffs = this.affairManager.getAffairs(ApplicationCategoryEnum.bulletin, Long.valueOf(idStr));
                        if (!updateaffs.isEmpty() && ((CtpAffair)updateaffs.get(0)).getSubState() != SubStateEnum.col_pending_read.key()) {
                            CtpAffair updateaff = (CtpAffair)updateaffs.get(0);
                            updateaff.setSubState(SubStateEnum.col_pending_read.key());
                            this.affairManager.updateAffair(updateaff);
                        }

                        mav.addObject("lockAuditFlag", true);
                    } else if (bean.getState() == 20) {
                        mav.addObject("lockAuditFlag", false);
                    }
                }

                boolean auditerFlag = "message".equals(from) && bean.getState() == 10 && (user.getId().equals(bean.getType().getAuditUser()) || user.getId().equals(agentId));
                boolean createrFlag = "message".equals(from) && bean.getCreateUser().equals(user.getId());
                boolean already_audit_myCreate;
                boolean noPass_audit;
                if (!"myAudit".equals(from) && !auditerFlag) {
                    if ("myCreate".equals(from) || createrFlag) {
                        already_audit_myCreate = false;
                        noPass_audit = false;
                        if (bean.getState() == 20) {
                            already_audit_myCreate = true;
                            mav.addObject("already_audit_myCreate", already_audit_myCreate);
                        } else if (bean.getState() == 40) {
                            noPass_audit = true;
                            mav.addObject("noPass_audit", noPass_audit);
                        }
                    }
                } else {
                    already_audit_myCreate = false;
                    noPass_audit = false;
                    if (bean.getState() == 20) {
                        already_audit_myCreate = true;
                        mav.addObject("already_audit", already_audit_myCreate);
                    } else if (bean.getState() == 10) {
                        noPass_audit = true;
                        mav.addObject("already_create", noPass_audit);
                    }
                }
            } else {
                mav.addObject("bulStyle", bulStyle);
                if (from != null) {
                    if (bean.getState() == 100 && !"pigeonhole".equals(from)) {
                        if ("colCube".equals(from)) {
                            super.rendJavaScript(response, "alert('" + alertInfo + "');window.close();parent.window.parentDialogObj.url.closeParam.handler();");
                        } else {
                            super.rendJavaScript(response, "alert('" + alertInfo + "');window.close();");
                        }

                        return mav.addObject("dataExist", Boolean.FALSE);
                    }

                    mav.addObject("dataExist", Boolean.TRUE);
                }

                if (!SecurityCheck.isLicit(request, response, ApplicationCategoryEnum.bulletin, user, bulId, (CtpAffair)null, (Long)null)) {
                    return null;
                }

                if (bean.getState() != 100) {
                    this.recordBulRead(bulId, bean, hasCache, user);
                }

                String content;
                if ("FORM".equals(bean.getDataFormat())) {
                    content = this.convertContent(bean.getContent());
                    if (content != null) {
                        bean.setDataFormat("HTML");
                        bean.setContent(content);
                    }
                }

                if ("HTML".equals(bean.getDataFormat())) {
                    content = this.convertContentV(bean.getContent());
                    if (content != null) {
                        bean.setContent(content);
                    }
                }

                userId = AppContext.getCurrentUser().getId();
                boolean isManager = false;
                if (Integer.parseInt(bean.getExt1()) == 1) {
                    if (userId == bean.getCreateUser()) {
                        isManager = true;
                    } else {
                        isManager = this.bulTypeManager.isManagerOfType(bean.getTypeId(), userId);
                    }
                }

                mav.addObject("isManager", isManager);
                if (AppContext.hasPlugin("doc")) {
                    collectFlag = SystemProperties.getInstance().getProperty("doc.collectFlag");
                    if ("true".equals(collectFlag)) {
                        List<Map<String, Long>> collectMap = this.docApi.findFavorites(userId, CommonTools.newArrayList(new Long[]{bean.getId()}));
                        if (!collectMap.isEmpty()) {
                            mav.addObject("isCollect", true);
                            mav.addObject("collectDocId", ((Map)collectMap.get(0)).get("id"));
                        }
                    }

                    mav.addObject("docCollectFlag", collectFlag);
                }
            }

            AccessControlBean.getInstance().addAccessControl(ApplicationCategoryEnum.bulletin, String.valueOf(bean.getId()), AppContext.currentUserId());
            return mav;
        } else {
            super.rendJavaScript(response, "alert('" + alertInfo + "');window.close();");
            return mav.addObject("dataExist", Boolean.FALSE);
        }
    }

    public ModelAndView bulPreview(HttpServletRequest request, HttpServletResponse response) throws Exception {
        BulData bean = new BulData();
        String title = request.getParameter("previewTitle");
        String createUserId = request.getParameter("createUser");
        super.bind(request, bean);
        String showPublishUserFlag = request.getParameter("showPublish");
        bean.setShowPublishUserFlag(Boolean.valueOf(showPublishUserFlag));
        Long typeId = bean.getTypeId();
        BulType type = this.bulTypeManager.getById(typeId);
        bean.setType(type);
        bean.setTitle(title);
        String bulStyle = bean.getType().getExt1();
        ModelAndView mav = new ModelAndView("bulletin/bulView_detail" + Integer.valueOf(bulStyle));
        Long newId = UUIDLong.longUUID();
        List<Attachment> attachments = this.attachmentManager.getByReference(newId, newId);
        bean.setReadCount(0);
        bean.setId(newId);
        if (Strings.isNotBlank(createUserId)) {
            bean.setCreateUser(Long.valueOf(createUserId));
        } else {
            bean.setCreateUser(AppContext.currentUserId());
        }

        bean.setPublishDeptName(request.getParameter("publishDepartmentName"));
        mav.addObject("bean", bean);
        mav.addObject("attachments", attachments);
        return mav;
    }

    private boolean[] toBulTypeModel(List<BulType> bulTypeList, List<BulTypeModel> bulTypeModelList) throws Exception {
        User user = AppContext.getCurrentUser();
        boolean hasIssue = false;
        boolean hasAudit = false;
        Iterator var6 = bulTypeList.iterator();

        while(var6.hasNext()) {
            BulType bulType = (BulType)var6.next();
            BulTypeModel bulTypeModel = new BulTypeModel(bulType, user.getId(), this.orgManager.getAllUserDomainIDs(user.getId()));
            bulTypeModel.setId(bulType.getId());
            bulTypeModel.setBulName(bulType.getTypeName());
            if (bulTypeModel.getCanNewOfCurrent()) {
                hasIssue = true;
            }

            if (bulTypeModel.isCanAuditOfCurrent()) {
                hasAudit = true;
            }

            bulTypeModel.setFlag(true);
            bulTypeModelList.add(bulTypeModel);
        }

        return new boolean[]{hasIssue, hasAudit};
    }

    private boolean[] getDeptBulModelList(List<PortalSpaceFix> spaces, Long userId, List<BulTypeModel> bulModelList) throws Exception {
        boolean hasIssue = false;
        boolean hasAudit = false;

        BulTypeModel bulModel;
        for(Iterator var6 = spaces.iterator(); var6.hasNext(); bulModelList.add(bulModel)) {
            PortalSpaceFix portalSpaceFix = (PortalSpaceFix)var6.next();
            bulModel = new BulTypeModel();
            bulModel.setId(portalSpaceFix.getEntityId());
            bulModel.setBulName(portalSpaceFix.getSpacename());
            bulModel.setFlag(false);
            bulModel.setSpaceId(portalSpaceFix.getId());
            bulModel.setSpaceType(portalSpaceFix.getType());
            bulModel.setCanAuditOfCurrent(false);
            if (this.spaceManager.isManagerOfThisSpace(userId, portalSpaceFix.getId())) {
                bulModel.setCanAdminOfCurrent(true);
                bulModel.setCanNewOfCurrent(true);
                hasIssue = true;
            } else {
                bulModel.setCanAdminOfCurrent(false);
                bulModel.setCanNewOfCurrent(false);
            }
        }

        return new boolean[]{hasIssue, hasAudit};
    }

    public List<BulType> getCanAdminTypes(Long memberId, BulType bulType) {
        Integer spaceType = bulType.getSpaceType();
        Long accountId = bulType.getAccountId();
        List<BulType> bulTypeList = new ArrayList();
        if (spaceType == SpaceType.public_custom.ordinal()) {
            bulTypeList = this.bulTypeManager.getManagerTypeByMember(memberId, SpaceType.public_custom, accountId);
        } else if (spaceType == SpaceType.public_custom_group.ordinal()) {
            bulTypeList = this.bulTypeManager.getManagerTypeByMember(memberId, SpaceType.public_custom_group, accountId);
        } else if (spaceType == SpaceType.group.ordinal()) {
            bulTypeList = this.bulTypeManager.getManagerTypeByMember(memberId, SpaceType.group, accountId);
        } else if (spaceType == SpaceType.corporation.ordinal()) {
            bulTypeList = this.bulTypeManager.getManagerTypeByMember(memberId, SpaceType.corporation, accountId);
        }

        if (Strings.isNotEmpty((Collection)bulTypeList)) {
            ((List)bulTypeList).remove(bulType);
        }

        return (List)bulTypeList;
    }

    public ModelAndView bulSave(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String dataformat = request.getParameter("dataFormat");
        String ext5 = request.getParameter("ext5");
        String spaceId = request.getParameter("spaceId");
        boolean isAuditEdit = "true".equals(request.getParameter("isAuditEdit"));
        BulData bean = null;
        User user = AppContext.getCurrentUser();
        Long userId = user.getId();
        String userName = user.getName();
        String title = request.getParameter("title");
        boolean isPublish = false;
        String idStr = request.getParameter("id");
        int oldState = 0;
        Boolean oldTypeAudit = false;

        if (StringUtils.isBlank(idStr)) {
            bean = new BulData();

        } else {
            //DBAgent.find("from BulForceRead where bulId="+idStr);
            bean = (BulData)this.bulDataManager.getBulDataCache().getDataCache().get(Long.valueOf(idStr));
            if (bean == null) {
                bean = this.bulDataManager.getById(Long.valueOf(idStr));
            }

            if (bean == null) {
                super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString("com.seeyon.v3x.bulletin.resources.i18n.BulletinResource", "bul.data.noexist", new Object[0]) + "');" + "window.close();");
                return null;
            }

            oldTypeAudit = bean.getType().isAuditFlag();
            if (bean.getState() == 10) {
                oldState = 10;
            } else if (bean.getState() == 40) {
                oldState = 40;
            } else if (bean.getState() == 30) {
                oldState = 30;
            }
        }

        Long oldTypeId = bean.getTypeId();
        super.bind(request, bean);
        Long typeId = bean.getTypeId();
        boolean flag = Strings.isNotBlank(spaceId) && bean.getAccountId() == null;
        BulType type = this.bulTypeManager.getById(typeId);
        bean.setType(type);
        bean.setSpaceType(type.getSpaceType());
        bean.setAccountId(type.getAccountId());
        bean.setTitle(title);
        String form_oper = request.getParameter("form_oper");
        if (StringUtils.isNotBlank(form_oper)) {
            if ("draft".equals(form_oper)) {
                bean.setState(0);
                bean.setState(0);
                bean.setAuditAdvice((String)null);
                bean.setPublishDate((Timestamp)null);
                bean.setPublishUserId((Long)null);
                bean.setReadCount(0);
                bean.setUpdateDate((Date)null);
                bean.setUpdateUser((Long)null);
            } else if ("submit".equals(form_oper)) {
                if (type.isAuditFlag()) {
                    bean.setState(10);
                } else {
                    bean.setExt3(String.valueOf(0));
                    bean.setState(30);
                    if (bean.getPublishDate() == null) {
                        bean.setPublishDate(new Timestamp((new Date()).getTime()));
                    }

                    bean.setPublishUserId(AppContext.getCurrentUser().getId());
                    isPublish = true;
                }
            }
        } else {
            bean.setState(0);
            bean.setState(0);
            bean.setAuditAdvice((String)null);
            bean.setPublishDate((Timestamp)null);
            bean.setPublishUserId((Long)null);
            bean.setReadCount(0);
            bean.setUpdateDate((Date)null);
            bean.setUpdateUser((Long)null);
        }

        Boolean firstIndexFlag = false;
        if (bean.isNew()) {
            bean.setCreateUser(AppContext.getCurrentUser().getId());
            bean.setTopOrder(Byte.valueOf("0"));
            bean.setCreateDate(new Timestamp(System.currentTimeMillis()));
            firstIndexFlag = true;
        } else if (!oldTypeId.equals(typeId)) {
            bean.setTopOrder(Byte.valueOf("0"));
        }

        if ("1".equals(request.getParameterValues("noteCallInfo")[0])) {
            bean.setExt1("1");
        } else {
            bean.setExt1("0");
        }

        if ("1".equals(request.getParameterValues("printAllow")[0])) {
            bean.setExt2("1");
        } else {
            bean.setExt2("0");
        }

        String showPublishUserFlag = request.getParameter("showPublish");
        bean.setShowPublishUserFlag(Boolean.valueOf(showPublishUserFlag));
        bean.setUpdateDate(new Date());
        bean.setUpdateUser(userId);
        if (bean.getReadCount() == null) {
            bean.setReadCount(0);
        }

        bean.setDataFormat(dataformat);
        bean.setExt5(ext5);
        boolean noAuditEdit;
        if (type.isAuditFlag() && (type.getSpaceType() == SpaceType.public_custom.ordinal() || type.getSortNum() == SpaceType.public_custom_group.ordinal())) {
            Long auditId = bean.getType().getAuditUser();
            if (auditId != -1L && Strings.isNotBlank(spaceId)) {
                noAuditEdit = this.check(Long.parseLong(spaceId), auditId);
                if (noAuditEdit) {
                    response.setContentType("text/html;charset=UTF-8");
                    response.setCharacterEncoding("UTF-8");
                    PrintWriter out = response.getWriter();
                    out.println("<script type='text/javascript'>");
                    out.println("alert('该公告无法审核，请联系管理员重新设置审核员!')");
                    out.println("</script>");
                    out.flush();
                    return null;
                }
            }
        }

        boolean editAfterAudit = oldState == 10;
        noAuditEdit = oldState == 40;
        boolean noAuditPublishEdit = oldState == 30;
        boolean isNew = false;
        String attaFlag = null;
        if (bean.isNew()) {
            bean.setIdIfNew();
            isNew = true;
            long attRefId = Long.valueOf(request.getParameter("attRefId"));
            this.attachmentManager.deleteByReference(attRefId, attRefId);
            bean.setAttachmentsFlag(false);
            attaFlag = this.attachmentManager.create(ApplicationCategoryEnum.bulletin, bean.getId(), bean.getId(), request);

        } else {
            this.attachmentManager.deleteByReference(bean.getId(), bean.getId());
            bean.setAttachmentsFlag(false);
            attaFlag = this.attachmentManager.create(ApplicationCategoryEnum.bulletin, bean.getId(), bean.getId(), request);
        }
        String isForce = request.getParameter("forceRead");
        BulForceRead forceRead = null;
        System.out.println("save force read start");
        System.out.println("forceRead:"+isForce);
        if("1".equals(isForce)){
            BulForceRead read = new BulForceRead();
            read.setIdIfNew();
            read.setBulId(bean.getId());
            if(!isNew){
                //看看以前有没有，没有就加上
               List<BulForceRead> bulForceReadList =  DBAgent.find("from BulForceRead where bulId="+read.getBulId());
               if(CollectionUtils.isEmpty(bulForceReadList)){
                   DBAgent.save(read);
                   System.out.println("saved new:"+ JSON.toJSONString(read));
               }else{
                   System.out.println("not saved bcz is exist:"+ JSON.toJSONString(bulForceReadList.get(0)));
               }
            }else{
                DBAgent.save(read);
                System.out.println("saved new:"+ JSON.toJSONString(read));
            }
        }else{
            if(!isNew){
                List<BulForceRead> bulForceReadList =  DBAgent.find("from BulForceRead where bulId="+bean.getId());
                if(!CollectionUtils.isEmpty(bulForceReadList)){
                    System.out.println("deleted:"+ JSON.toJSONString(bulForceReadList.get(0)));
                    DBAgent.deleteAll(bulForceReadList);
                }
            }
        }
        if (Constants.isUploadLocaleFile(attaFlag)) {
            bean.setAttachmentsFlag(true);
        }
        System.out.println("end of save force read start");
        if (flag) {
            this.bulDataManager.saveCustomBul(bean, isNew);
        } else {
            this.bulDataManager.save(bean, isNew);
            if (bean.getState() == 30) {
                BulletinAddEvent bulletinAddEvent = new BulletinAddEvent(this);
                bulletinAddEvent.setBulDataBO(BulletinUtils.bulDataPOToBO(bean));
                EventDispatcher.fireEvent(bulletinAddEvent);
            }
        }

        if (!isNew && this.bulDataManager.getBulDataCache().getDataCache().get(bean.getId()) != null) {
            this.bulDataManager.getBulDataCache().getDataCache().save(bean.getId(), bean, bean.getPublishDate().getTime(), bean.getReadCount() == null ? 0 : bean.getReadCount());
        }

        if (isPublish && bean.getState() == 30) {
            this.bulReadManager.deleteReadByData(bean);
        }

        try {
            if (bean.getState() == 30 && AppContext.hasPlugin("index")) {
                if (firstIndexFlag) {
                    this.indexManager.add(bean.getId(), ApplicationCategoryEnum.bulletin.getKey());
                } else {
                    this.indexManager.update(bean.getId(), ApplicationCategoryEnum.bulletin.getKey());
                }
            }
        } catch (Exception var30) {
            log.error("全文检索：", var30);
        }

        if (bean.getState().equals(30)) {
            Set<Long> msgReceiverIds = this.getAllMembersinPublishScope(bean);
            this.addAdmins2MsgReceivers(msgReceiverIds, (BulData)bean);
            this.getBulletinUtils().initDataFlag(bean, true);
            String deptName = bean.getPublishDeptName();
            this.userMessageManager.sendSystemMessage(MessageContent.get(noAuditPublishEdit ? "bul.publishEdit" : "bul.auditing", new Object[]{bean.getTitle(), deptName}).setBody(bean.getContent(), bean.getDataFormat(), bean.getCreateDate()), ApplicationCategoryEnum.bulletin, userId, MessageReceiver.getReceivers(bean.getId(), msgReceiverIds, "message.link.bul.alreadyauditing", new Object[]{String.valueOf(bean.getId())}), new Object[]{bean.getTypeId()});
            this.appLogManager.insertLog(user, noAuditPublishEdit ? AppLogAction.Bulletin_Modify : AppLogAction.Bulletin_Publish, new String[]{userName, bean.getTitle()});
            if (oldTypeAudit) {
                this.affairManager.deleteByObjectId(ApplicationCategoryEnum.bulletin, bean.getId());
            }

            if (!isNew && !oldTypeId.equals(typeId)) {
                this.bulTypeManager.updateTypeETagDate(String.valueOf(oldTypeId));
            }

            this.bulTypeManager.updateTypeETagDate(String.valueOf(bean.getTypeId()));
        }

        Long agentId;
        if (bean.getState().equals(10) && !isAuditEdit) {
            agentId = AgentUtil.getAgentByApp(type.getAuditUser(), ApplicationCategoryEnum.bulletin.getKey());
            if (editAfterAudit) {
                this.userMessageManager.sendSystemMessage(MessageContent.get("bul.edit", new Object[]{bean.getTitle(), userName}), ApplicationCategoryEnum.bulletin, userId, MessageReceiver.get(bean.getId(), type.getAuditUser(), "message.link.bul.auditing", new Object[]{String.valueOf(bean.getId())}), new Object[]{type.getId()});
                if (agentId != null) {
                    this.userMessageManager.sendSystemMessage(MessageContent.get("bul.edit", new Object[]{bean.getTitle(), userName}).add("col.agent", new Object[0]), ApplicationCategoryEnum.bulletin, userId, MessageReceiver.get(bean.getId(), agentId, "message.link.bul.auditing", new Object[]{String.valueOf(bean.getId())}), new Object[]{type.getId()});
                }

                this.appLogManager.insertLog(user, AppLogAction.Bulletin_Modify, new String[]{userName, bean.getTitle()});
                this.affairManager.deleteByObjectId(ApplicationCategoryEnum.bulletin, bean.getId());
                if (bean.getType().isAuditFlag()) {
                    this.addPendingAffair(type, bean);
                }
            } else if (noAuditEdit) {
                this.userMessageManager.sendSystemMessage(MessageContent.get("bul.send", new Object[]{bean.getTitle(), userName}), ApplicationCategoryEnum.bulletin, userId, MessageReceiver.get(bean.getId(), type.getAuditUser(), "message.link.bul.auditing", new Object[]{String.valueOf(bean.getId())}), new Object[]{type.getId()});
                if (agentId != null) {
                    this.userMessageManager.sendSystemMessage(MessageContent.get("bul.send", new Object[]{bean.getTitle(), userName}).add("col.agent", new Object[0]), ApplicationCategoryEnum.bulletin, userId, MessageReceiver.get(bean.getId(), agentId, "message.link.bul.auditing", new Object[]{String.valueOf(bean.getId())}), new Object[]{type.getId()});
                }

                this.appLogManager.insertLog(user, AppLogAction.Bulletin_Modify, new String[]{userName, bean.getTitle()});
                if (bean.getType().isAuditFlag()) {
                    this.addPendingAffair(type, bean);
                }
            } else {
                this.addPendingAffair(type, bean);
                this.userMessageManager.sendSystemMessage(MessageContent.get("bul.send", new Object[]{bean.getTitle(), userName}), ApplicationCategoryEnum.bulletin, userId, MessageReceiver.get(bean.getId(), type.getAuditUser(), "message.link.bul.auditing", new Object[]{String.valueOf(bean.getId())}), new Object[]{type.getId()});
                if (agentId != null) {
                    this.userMessageManager.sendSystemMessage(MessageContent.get("bul.send", new Object[]{bean.getTitle(), userName}).add("col.agent", new Object[0]), ApplicationCategoryEnum.bulletin, userId, MessageReceiver.get(bean.getId(), agentId, "message.link.bul.auditing", new Object[]{String.valueOf(bean.getId())}), new Object[]{type.getId()});
                }

                this.appLogManager.insertLog(user, AppLogAction.Bulletin_New, new String[]{userName, bean.getTitle()});
            }
        } else if (bean.getState().equals(0)) {
            this.appLogManager.insertLog(user, AppLogAction.Bulletin_Modify, new String[]{userName, bean.getTitle()});
        } else if (isAuditEdit && !bean.getCreateUser().equals(AppContext.currentUserId())) {
            this.userMessageManager.sendSystemMessage(MessageContent.get("bul.edit", new Object[]{bean.getTitle(), userName}), ApplicationCategoryEnum.bulletin, user.getId(), MessageReceiver.get(bean.getId(), bean.getCreateUser(), "message.link.bul.writedetail", new Object[]{String.valueOf(bean.getId())}), new Object[0]);
            agentId = AgentUtil.getAgentByApp(bean.getCreateUser(), ApplicationCategoryEnum.bulletin.getKey());
            if (agentId != null) {
                MessageReceiver receiver = MessageReceiver.get(bean.getId(), agentId, "message.link.bul.writedetail", new Object[]{String.valueOf(bean.getId())});
                this.userMessageManager.sendSystemMessage(MessageContent.get("bul.edit", new Object[]{bean.getTitle(), userName}).add("col.agent", new Object[0]), ApplicationCategoryEnum.bulletin, user.getId(), receiver, new Object[0]);
            }
        }

        String alertSuccess = isAuditEdit ? "alert('" + ResourceBundleUtil.getString("com.seeyon.v3x.bulletin.resources.i18n.BulletinResource", "bul.modify.succces", new Object[0]) + "');" : "";
        super.rendJavaScript(response, alertSuccess + "try{if(window.opener){if (window.opener.getCtpTop().isCtpTop) {window.opener.getCtpTop().reFlesh();} else {window.opener.location.reload();}}}catch(e){}window.close();");
        return null;
    }
}
