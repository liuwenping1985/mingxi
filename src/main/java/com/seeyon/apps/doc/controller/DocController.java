package com.seeyon.apps.doc.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.itrus.util.PathList;
import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.enums.TransNewColParam;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.common.projectphaseevent.manager.ProjectPhaseEventManager;
import com.seeyon.apps.common.projectphaseevent.po.ProjectPhaseEvent;
import com.seeyon.apps.doc.constants.DocConstants;
import com.seeyon.apps.doc.enums.DocActionEnum;
import com.seeyon.apps.doc.enums.EntranceTypeEnum;
import com.seeyon.apps.doc.event.DocDeleteEvent;
import com.seeyon.apps.doc.event.DocUpdateEvent;
import com.seeyon.apps.doc.exception.KnowledgeException;
import com.seeyon.apps.doc.manager.ContentTypeManager;
import com.seeyon.apps.doc.manager.DocAclManager;
import com.seeyon.apps.doc.manager.DocAclNewManager;
import com.seeyon.apps.doc.manager.DocActionManager;
import com.seeyon.apps.doc.manager.DocAlertLatestManager;
import com.seeyon.apps.doc.manager.DocAlertManager;
import com.seeyon.apps.doc.manager.DocFavoriteManager;
import com.seeyon.apps.doc.manager.DocFilingManager;
import com.seeyon.apps.doc.manager.DocForumManager;
import com.seeyon.apps.doc.manager.DocHierarchyManager;
import com.seeyon.apps.doc.manager.DocHierarchyManagerImpl;
import com.seeyon.apps.doc.manager.DocLearningManager;
import com.seeyon.apps.doc.manager.DocLibManager;
import com.seeyon.apps.doc.manager.DocMetadataManager;
import com.seeyon.apps.doc.manager.DocMimeTypeManager;
import com.seeyon.apps.doc.manager.DocVersionInfoManager;
import com.seeyon.apps.doc.manager.KnowledgeFavoriteManager;
import com.seeyon.apps.doc.manager.KnowledgeManager;
import com.seeyon.apps.doc.manager.MetadataDefManager;
import com.seeyon.apps.doc.po.DocAcl;
import com.seeyon.apps.doc.po.DocActionPO;
import com.seeyon.apps.doc.po.DocActionUserPO;
import com.seeyon.apps.doc.po.DocAlertLatestPO;
import com.seeyon.apps.doc.po.DocAlertPO;
import com.seeyon.apps.doc.po.DocBodyPO;
import com.seeyon.apps.doc.po.DocFavoritePO;
import com.seeyon.apps.doc.po.DocForumPO;
import com.seeyon.apps.doc.po.DocLearningHistoryPO;
import com.seeyon.apps.doc.po.DocLearningPO;
import com.seeyon.apps.doc.po.DocLibPO;
import com.seeyon.apps.doc.po.DocMetadataDefinitionPO;
import com.seeyon.apps.doc.po.DocMetadataOptionPO;
import com.seeyon.apps.doc.po.DocMimeTypePO;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.doc.po.DocTypePO;
import com.seeyon.apps.doc.po.DocVersionInfoPO;
import com.seeyon.apps.doc.po.Potent;
import com.seeyon.apps.doc.util.ActionType;
import com.seeyon.apps.doc.util.Constants;
import com.seeyon.apps.doc.util.Constants.LockStatus;
import com.seeyon.apps.doc.util.DocMVCUtils;
import com.seeyon.apps.doc.util.DocMgrUtils;
import com.seeyon.apps.doc.util.DocUtils;
import com.seeyon.apps.doc.util.HtmlUtil;
import com.seeyon.apps.doc.util.KnowledgeUtils;
import com.seeyon.apps.doc.util.SearchModel;
import com.seeyon.apps.doc.vo.DocAclVO;
import com.seeyon.apps.doc.vo.DocAlertAdminVO;
import com.seeyon.apps.doc.vo.DocAlertLatestVO;
import com.seeyon.apps.doc.vo.DocBorrowVO;
import com.seeyon.apps.doc.vo.DocCheckOutVO;
import com.seeyon.apps.doc.vo.DocEditVO;
import com.seeyon.apps.doc.vo.DocFavoriteVO;
import com.seeyon.apps.doc.vo.DocForumReplyVO;
import com.seeyon.apps.doc.vo.DocForumVO;
import com.seeyon.apps.doc.vo.DocLearningHistoryVO;
import com.seeyon.apps.doc.vo.DocLearningVO;
import com.seeyon.apps.doc.vo.DocLibTableVo;
import com.seeyon.apps.doc.vo.DocLinkVO;
import com.seeyon.apps.doc.vo.DocOpenBodyVO;
import com.seeyon.apps.doc.vo.DocPersonalShareVO;
import com.seeyon.apps.doc.vo.DocPropVO;
import com.seeyon.apps.doc.vo.DocSearchModel;
import com.seeyon.apps.doc.vo.DocSortProperty;
import com.seeyon.apps.doc.vo.DocTableVO;
import com.seeyon.apps.doc.vo.DocTreeVO;
import com.seeyon.apps.doc.vo.FolderItem;
import com.seeyon.apps.doc.vo.FolderItemDoc;
import com.seeyon.apps.doc.vo.FolderItemFolder;
import com.seeyon.apps.doc.vo.GridVO;
import com.seeyon.apps.doc.vo.ListDocLog;
import com.seeyon.apps.doc.vo.PotentModel;
import com.seeyon.apps.doc.vo.SimpleDocQueryModel;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.apps.edoc.bo.EdocSummaryBO;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.apps.project.api.ProjectApi;
import com.seeyon.apps.project.bo.ProjectBO;
import com.seeyon.apps.project.bo.ProjectTypeBO;
import com.seeyon.apps.storage.manager.DocSpaceManager;
import com.seeyon.apps.storage.po.DocStorageSpacePO;
import com.seeyon.apps.taskmanage.util.TaskConstants;
import com.seeyon.apps.webmail.api.WebmailApi;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.dao.paginate.Pagination;
import com.seeyon.ctp.common.encrypt.CoderFactory;
import com.seeyon.ctp.common.excel.DataCell;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.filemanager.manager.PartitionManager;
import com.seeyon.ctp.common.filemanager.manager.Util;
import com.seeyon.ctp.common.flag.BrowserEnum;
import com.seeyon.ctp.common.flag.BrowserFlag;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.office.trans.manager.OfficeTransManager;
import com.seeyon.ctp.common.office.trans.util.OfficeTransHelper;
import com.seeyon.ctp.common.operationlog.manager.OperationlogManager;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.po.operationlog.OperationLog;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.section.panel.SectionPanel;
import com.seeyon.ctp.portal.space.manager.PortletEntityPropertyManager;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FileUtil;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.SetContentType;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.common.security.SecurityCheck;

/**
 * 文档管理中权限、结构相关的controller
 */
@SuppressWarnings("deprecation")
public class DocController extends BaseController {
    private static final Log             log                          = LogFactory.getLog(DocController.class);
    private OfficeTransManager           officeTransManager;
    private IndexManager                 indexManager;
    private WebmailApi              	 webmailApi;
    private UserMessageManager           userMessageManager;
    private FileToExcelManager           fileToExcelManager;
    private DocHierarchyManager          docHierarchyManager;
    private DocFilingManager             docFilingManager;
    private OrgManager                   orgManager;
    private ContentTypeManager           contentTypeManager;
    private DocAclManager                docAclManager;
    private DocMimeTypeManager           docMimeTypeManager;
    private OperationlogManager          operationlogManager;
    private AttachmentManager            attachmentManager;
    private FileManager                  fileManager;
    private PartitionManager             partitionManager;
    private DocForumManager              docForumManager;
    private DocMetadataManager           docMetadataManager;
    private DocAlertManager              docAlertManager;
    private MetadataDefManager           metadataDefManager;
    private DocFavoriteManager           docFavoriteManager;
    private DocAlertLatestManager        docAlertLatestManager;
    private DocLearningManager           docLearningManager;
    private DocLibManager                docLibManager;
    private HtmlUtil                     htmlUtil;
    private String                       jsonView;
    private SpaceManager                 spaceManager;
    private EnumManager                  enumManagerNew;
    private AppLogManager                appLogManager;
    private DocVersionInfoManager        docVersionInfoManager;
    private PortletEntityPropertyManager portletEntityPropertyManager;
    private DocActionManager             docActionManager;
    private DocAclNewManager             docAclNewManager;
    private Set<String>                  typesShowContentDirectlyTEXT = new HashSet<String>();
    private Set<String>                  typesShowContentDirectlyHTML = new HashSet<String>();
    /** 上传后直接查看内容的TXT和HTML、HTM等格式文件的大小上限 */
    private int                          maxSize4ShowContent;
    private AffairManager				 affairManager;
    private CollaborationApi 			 collaborationApi;
    private EdocApi  				 	 edocApi;
    private KnowledgeFavoriteManager     knowledgeFavoriteManager;
    private DocSpaceManager              docSpaceManager;
    private ProjectApi               	 projectApi;
    private SystemConfig                 systemConfig;
    private KnowledgeManager 			 knowledgeManager;
    private ProjectPhaseEventManager 	 projectPhaseEventManager;
    
    /** 文档中心首页框架  
     * @throws BusinessException */
    public ModelAndView docIndex(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView ret = new ModelAndView("apps/doc/index");
        Long userId = AppContext.currentUserId();
        // 是否从文档夹的打开转过来，如果是，说明需要提醒用户，原来需要打开的文档夹不存在了
        boolean alertNotExist = request.getParameter("docResId") != null;
        //是否为企业版
        boolean isEnterpriseVer = (Boolean)(SysFlag.sys_isEnterpriseVer.getFlag());
        Byte docLibType = Constants.ACCOUNT_LIB_TYPE;
        if(Strings.isNotBlank(request.getParameter("openLibType"))){
        	docLibType = Byte.valueOf(request.getParameter("openLibType"));
        }
        boolean isV5Member = AppContext.getCurrentUser().getExternalType() == OrgConstants.ExternalType.Inner.ordinal();
        Long accountId = AppContext.currentAccountId();
        if (!isV5Member) {
            accountId = OrgHelper.getVJoinAllowAccount();
            docLibType = Constants.GROUP_LIB_TYPE;
            if(isEnterpriseVer){
                docLibType = Constants.ACCOUNT_LIB_TYPE;
            }
        }
        boolean isPersonalLib = Constants.PERSONAL_LIB_TYPE.equals(docLibType);
        DocLibPO lib = null;
        if (Constants.PERSONAL_LIB_TYPE.equals(docLibType)) {//私人
            lib = this.docLibManager.getPersonalLibOfUser(userId);
        } else if(Constants.EDOC_LIB_TYPE.equals(docLibType)){//公文
            lib = this.docLibManager.getLibsOfAccount(AppContext.currentAccountId(),docLibType).get(0);
        } else if(Constants.PROJECT_LIB_TYPE.equals(docLibType)){//项目
            lib = this.docLibManager.getProjectDocLib();
        } else if(Constants.GROUP_LIB_TYPE.equals(docLibType)){//集团
            lib = this.docLibManager.getGroupDocLib();
        } else{//单位
            lib = this.docLibManager.getDeptLibById(accountId);
        }
        Long openLibId = lib.getId();
        // 得到文档库下的根文件（夹）
        DocResourcePO dr = new DocResourcePO();
        if(request.getParameter("docId")!=null){
        	Long id = Long.parseLong(request.getParameter("docId"));
        	dr = docHierarchyManager.getDocResourceById(id);
        	isPersonalLib = true;
        }else{
        	dr = docHierarchyManager.getRootByLibId(lib.getId());
        }
        
        dr.setIsMyOwn(isPersonalLib);
        DocTreeVO vo = this.getDocTreeVO(userId, dr, isPersonalLib);
        ret.addObject("docLibId", openLibId).addObject("root", vo).addObject("alertNotExist", alertNotExist);
        ret.addObject("v", SecurityHelper.digest(vo.getDocResource().getId(),vo.getDocResource().getFrType(),openLibId,docLibType,Boolean.FALSE,vo.isAllAcl(),vo.isEditAcl() ,
    			vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl()));
        ret.addObject("docLibType", docLibType);
        return ret;
    }

    private DocTreeVO getDocTreeVO(Long userId, DocResourcePO dr, boolean isPersonalLib) throws BusinessException {
        return DocMVCUtils.getDocTreeVO(userId, dr, isPersonalLib, docMimeTypeManager, docAclManager);
    }

    /** 从首页进入框架  
     * @throws BusinessException */
    public ModelAndView docHomepageIndex(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        ModelAndView ret = new ModelAndView("apps/doc/index");

        Long userId = AppContext.currentUserId();
        String sdocId = request.getParameter("docResId");
        String frType = request.getParameter("frType");
        String projectTypeId = request.getParameter("projectTypeId");
        
        /**
         * start
         * Bug OA-51491  全文检索，检索出人员A借阅给我的文档，点击打开文档夹，进入的是人员A的文档中心-我的文档页面。  
         * 这里组件问题，opmessage.js里面的openDocument方法，传不过来FrType参数，只能在这里找
         * 
         */
        DocResourcePO dp = null;
        if (Strings.isNotBlank(sdocId)){
            dp = docHierarchyManager.getDocResourceById(Long.valueOf(sdocId));
        }
        DocLibPO dl = null;
        if(dp!=null){
        	dl = docLibManager.getDocLibById(dp.getDocLibId());
        	List<Long> ownerIds  = docLibManager.getOwnersByDocLibId(dl.getId());
        	if(dl.isPersonalLib() && !ownerIds.isEmpty()&& (!ownerIds.contains(userId))){
		        String logicalPath = "";
		        logicalPath = dp.getLogicalPath();
		        String[] strs = logicalPath.split("\\.");
		        boolean hasShareAcl = false;
		        List<Long> userDomainIds = orgManager.getAllUserDomainIDs(userId);
		        for(String str : strs){
		        	Long id = Long.valueOf(str);
		        	List<DocAcl> listAcl = docAclManager.getAclList(id, Constants.SHARETYPE_PERSSHARE);
		        	if(!listAcl.isEmpty()){
		        		for(DocAcl da : listAcl){
		        			if(userDomainIds.contains(da.getUserId()) && da.getSharetype() == Constants.SHARETYPE_PERSSHARE){
		        				hasShareAcl = true;
				        		break;
		        			}
		        		}
		        	}else{
		        		hasShareAcl = false;
		        	}
		        }
		        if(hasShareAcl){
		        	frType = Constants.PERSON_SHARE+"";
		        }else{
		        	frType = Constants.PERSON_BORROW+"";
		        }
	        	sdocId = ownerIds.get(0)+"";

         	}
        }
        
        
        /**
         * end
         */
        
    	if(Strings.isNotBlank(frType)){
        	//来自借阅文档下的人员、单位借阅；共享文档下的人员
    		Long ftype = Long.valueOf(frType);
        	if((Constants.DEPARTMENT_BORROW == ftype || Constants.PERSON_BORROW  == ftype 
        	            || Constants.PERSON_SHARE == ftype) && !"900".equals(sdocId)) {
        		DocLibPO lib = docLibManager.getPersonalLibOfUser(userId);
                ret.addObject("docLibId", lib.getId()).addObject("docLibType", lib.getType());
                ret.addObject("id", sdocId).addObject("frType", frType);
                ret.addObject("shareOrBorrowFlag", Boolean.TRUE);
                ret.addObject("v", SecurityHelper.digest(sdocId,frType,lib.getId(),lib.getType(),Boolean.TRUE,Boolean.FALSE,Boolean.FALSE,
                        Boolean.FALSE,Boolean.TRUE,Boolean.FALSE,Boolean.FALSE));
                return ret;
        	}
    	}
    	
        String sprojectId = request.getParameter("projectId");
        Long docResId = Long.valueOf(0L);
        if (Strings.isNotBlank(sdocId))
            docResId = Long.valueOf(sdocId);
        else if (Strings.isNotBlank(sprojectId)) {
            long projectId = Long.parseLong(sprojectId);
            DocResourcePO projectFolder = docHierarchyManager.getProjectFolderByProjectId(projectId);
            if (projectFolder != null)
                docResId = projectFolder.getId();
        }
        DocResourcePO parent = docHierarchyManager.getDocResourceById(docResId);
        // 源文档夹的是否存在判断
        if (parent == null) {
            String parentId = request.getParameter("parentId");
            if (Strings.isNotBlank(parentId)) {
                docResId = Long.valueOf(parentId);
                parent = docHierarchyManager.getDocResourceById(docResId);
            }
            ret.addObject("alertNotExist", Boolean.TRUE);
        }else{
        	//个人共享的文档夹
    		DocLibPO lib = docLibManager.getPersonalLibOfUser(parent.getCreateUserId());
        	if(parent.getDocLibId()==lib.getId() && !parent.getCreateUserId().equals(userId)){
        		lib = docLibManager.getPersonalLibOfUser(userId);
                ret.addObject("docLibId", lib.getId()).addObject("docLibType", lib.getType());
                ret.addObject("id", parent.getId());
                Long _frType = null;
                if(!Strings.isNotBlank(request.getParameter("frType"))) {
                	_frType = Constants.FOLDER_COMMON;
                	ret.addObject("frType", _frType);
                } else {
                	_frType = Long.valueOf(request.getParameter("frType"));
                	ret.addObject("frType", _frType);
                }                
                ret.addObject("shareOrBorrowFlag", Boolean.TRUE);
                ret.addObject("v", SecurityHelper.digest(sdocId,_frType,lib.getId(),lib.getType(),Boolean.TRUE,Boolean.FALSE,Boolean.FALSE,
                        Boolean.FALSE,Boolean.TRUE,Boolean.FALSE,Boolean.FALSE));
                return ret;
        	}
        }

        if (parent == null) {
            return super.redirectModelAndView("/doc.do?method=docIndex&docResId=" + sdocId);
        }

        DocLibPO lib = docLibManager.getDocLibById(parent.getDocLibId());
        if (lib == null || lib.isDisabled()) {
        	response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>" + "	alert('" + Constants.getDocI18nValue("doc.prompt.docLib.disabled") + "');"
                    + "</script>");
            out.flush();
            return this.docLibsConfig(request, response);
        }

        boolean isPersonalLib = lib.isPersonalLib();
        if (isPersonalLib) {
            boolean ownerOfLib = docLibManager.isOwnerOfLib(userId, lib.getId());
            if (ownerOfLib)
                parent.setIsMyOwn(true);
        }

        DocTreeVO vo = this.getDocTreeVO(userId, parent, isPersonalLib);
        
        if (Strings.isNotBlank(frType) && frType.equals(Constants.PERSON_SHARE + "") 
                && "900".equals(sdocId) && projectTypeId != null) {
            vo.getDocResource().setFrType(Constants.PERSON_SHARE);
        }

        ret.addObject("projectTypeId",projectTypeId).addObject("docLibId", lib.getId()).addObject("docLibType", lib.getType());
        ret.addObject("root", vo).addObject("id", parent.getId()).addObject("frType", parent.getFrType());
        boolean isShareAndBorrowRoot = BooleanUtils.toBoolean(request.getParameter("isShareAndBorrowRoot"));
        ret.addObject("shareOrBorrowFlag", isShareAndBorrowRoot);
        if(isShareAndBorrowRoot) {
        	ret.addObject("v", SecurityHelper.digest(sdocId,parent.getFrType(),lib.getId(),lib.getType(),Boolean.TRUE,Boolean.FALSE,Boolean.FALSE,
        			false,Boolean.TRUE,Boolean.FALSE,Boolean.FALSE));
        } else {
        	ret.addObject("v", SecurityHelper.digest(vo.getDocResource().getId(),vo.getDocResource().getFrType(),lib.getId(),lib.getType(),Boolean.FALSE,vo.isAllAcl(),vo.isEditAcl(),
        			vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl()));
        }
        
        return ret;
    }

    /** 从首页进入框架  */
    public ModelAndView docHomepageShareIndex(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView ret = new ModelAndView("apps/doc/index");
        Long userId = AppContext.currentUserId();
        Long ownerId = Long.valueOf(request.getParameter("ownerId"));
        DocLibPO lib = docLibManager.getOwnerDocLibByUserId(userId);
        String v= SecurityHelper.digest(ownerId,Constants.PERSON_SHARE,lib.getId(),Constants.PERSONAL_LIB_TYPE,true,Boolean.FALSE,Boolean.FALSE,
    			Boolean.FALSE,true,Boolean.FALSE,Boolean.FALSE);
        ret.addObject("id", ownerId);
        ret.addObject("frType", Constants.PERSON_SHARE);
        ret.addObject("docLibType", Constants.PERSONAL_LIB_TYPE);
        ret.addObject("docLibId", lib.getId());
        ret.addObject("shareOrBorrowFlag", true);
        ret.addObject("v", v);
        return ret;
    }

    /** 顶部菜单  */
    @Deprecated
    public ModelAndView docMenu(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView("apps/doc/docMenu");

        // 获得工具栏右上角查询条件的类型列表
        List<DocTypePO> types = contentTypeManager.getAllSearchContentType();
        mav.addObject("types", types);
        Long docLibId = Long.valueOf(request.getParameter("docLibId"));
        DocLibPO docLib = docLibManager.getDocLibById(docLibId);
        boolean folderEnabled = docLib.getFolderEnabled();
        boolean a6Enabled = docLib.getA6Enabled();
        boolean officeEnabled = docLib.getOfficeEnabled();
        boolean uploadEnabled = docLib.getUploadEnabled();
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        boolean isPrivateLib = docLibType.equals(Constants.PERSONAL_LIB_TYPE);
        mav.addObject("isGroupLib", (docLibType.byteValue() == Constants.GROUP_LIB_TYPE.byteValue()));
        mav.addObject("isPrivateLib", isPrivateLib);
        mav.addObject("isEdocLib", (docLibType.byteValue() == Constants.EDOC_LIB_TYPE.byteValue()));
        mav.addObject("folderEnabled", folderEnabled);
        mav.addObject("a6Enabled", a6Enabled);
        mav.addObject("officeEnabled", officeEnabled);
        mav.addObject("uploadEnabled", uploadEnabled);
        Long parentId = Long.valueOf(request.getParameter("resId"));
        DocResourcePO parent = docHierarchyManager.getDocResourceById(parentId);
        mav.addObject("parent", parent);

        return mav;
    }

    /** 左侧树框架  */
    public ModelAndView docTreeIframe(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/docTreeIframe");
    }

    /** 判断是否具有推送到集团首页的权限   */
    private boolean canAdminGroup() {
        DocLibPO lib = docLibManager.getGroupDocLib();
        if (lib == null)
            return false;
        return DocMVCUtils.isGroupSpaceManager(spaceManager, AppContext.currentUserId());
    }

    // 弹出树框架
    public ModelAndView docTreeMoveIframe(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/docTreeMoveIframe");
    }

    // 左侧树上的标签
    @Deprecated
    public ModelAndView docTreeLable(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/docTreeLable");
    }

    // 左侧树
    public ModelAndView docTree(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/docTree");
    }

    /** 弹出新建文件夹窗口  */
    public ModelAndView createF(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/createF");
    }

    /**
     * 在归档页面点击新建时弹出的新建文档夹窗口
     * @param request
     * @param response
     * @return
     */
    public ModelAndView createFOnPigeonhole(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView("apps/doc/createFOnPigeonhole");
        String idString = request.getParameter("parentId");
        mav.addObject("parentId", idString);
        return mav;
    }

    /** 左侧树  
     * @throws BusinessException */
    public ModelAndView xmlJsp(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        response.setContentType("text/xml");
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();

        Long userId = AppContext.currentUserId();
        Long parentId = Long.valueOf(request.getParameter("resId"));
        Long frType = Long.valueOf(request.getParameter("frType"));
        String projectTypeId = request.getParameter("projectTypeId");
        DocResourcePO docRes = docHierarchyManager.getDocResourceById(parentId);

        // 对于资源是否存在的判断
        if (frType != Constants.PERSON_BORROW && frType != Constants.PERSON_SHARE
                && frType != Constants.DEPARTMENT_BORROW && docRes == null) {
            out.println("<exist>no</exist>");
            return null;
        }

        Long docLibId = null;
        DocLibPO docLib = null;
        Byte docLibType = null;

        if ((frType == Constants.PERSON_BORROW || frType == Constants.PERSON_SHARE
                || frType == Constants.DEPARTMENT_BORROW) 
                && !Constants.DOC_LIB_ROOT_ID_PROJECT.equals(parentId)) {
            docLib = this.docLibManager.getPersonalLibOfUser(userId);
            docLibId = docLib.getId();
            docLibType = Constants.PERSONAL_LIB_TYPE;
        } else {
            docLibId = docRes.getDocLibId();
            docLib = docLibManager.getDocLibById(docLibId);
            docLibType = docLib.getType();
        }

        boolean isShareAndBorrowRoot = BooleanUtils.toBoolean(request.getParameter("isShareAndBorrowRoot"));

        List<DocResourcePO> drs = null;
        if (docLib.isPersonalLib()) {
            drs = docHierarchyManager.findFolders(parentId, frType, userId, "", true,null);
        } else {
            String orgIds = Constants.getOrgIdsOfUser(userId);
            //项目虚拟目录查询
            if (DocMVCUtils.isProjectVirtualCategory(frType, docRes.getId(), docLib,projectTypeId)) {
                drs = docHierarchyManager.findFolders(parentId, Constants.FOLDER_PROJECT_ROOT, userId, orgIds, false,new ArrayList<Long>());
//                //根据项目类型Id查询所有项目id
//                List<ProjectBO> psList = projectApi.findProjectsByTypeIdAndMemberId(userId,Long.parseLong(projectTypeId));
//                List<Long> sourceIds = new ArrayList<Long>();//项目id
//                for (ProjectBO pSummary : psList) {
//                    sourceIds.add(pSummary.getId());
//                }
                List<Long> sourceIds = projectApi.findProjectIdsByMemberAndType(userId, Long.parseLong(projectTypeId));
                
                List<DocResourcePO> removeDocList = new ArrayList<DocResourcePO>();
                for (DocResourcePO doc : drs) {
                    if (doc.getSourceId() != null && !sourceIds.contains(doc.getSourceId())) {
                        ProjectBO ps = projectApi.getProject(doc.getSourceId());
                        if (!(ps.getProjectTypeId() + "").equals(projectTypeId)) {
                            removeDocList.add(doc);
                        }
                    }
                }
                if(!removeDocList.isEmpty()){//删除不是指定项目类别的
                    drs.removeAll(removeDocList);
                }
            } else {
                drs = docHierarchyManager.findFolders(parentId, frType, userId, orgIds, false,null);
            }
        }

        if (CollectionUtils.isEmpty(drs))
            return null;
        
        if (docRes != null) {
            //项目文档根据项目文档类别构建
            drs = DocMVCUtils.projectRootCategory(frType, docRes.getId(), docLib, drs, projectApi,orgManager);
        }
       

        List<DocTreeVO> folders = new ArrayList<DocTreeVO>();
        for (DocResourcePO doc : drs) {
            long type = doc.getFrType();
            // 我的计划判断
            if (type == Constants.FOLDER_PLAN || type == Constants.FOLDER_PLAN_DAY
                    || type == Constants.FOLDER_PLAN_MONTH || type == Constants.FOLDER_PLAN_WEEK
                    || type == Constants.FOLDER_PLAN_WORK) {
            	//文档中心屏蔽我的计划
                boolean hasPlan = false;
                if (!hasPlan)
                    continue;
            }

            boolean isShareAndBorrowRoot_ = isShareAndBorrowRoot;

            if (type == Constants.FOLDER_BORROW || type == Constants.FOLDER_SHAREOUT
                    || type == Constants.FOLDER_BORROWOUT || type == Constants.FOLDER_SHARE
                    || type == Constants.PERSON_BORROW || type == Constants.PERSON_SHARE
                    || type == Constants.DEPARTMENT_BORROW || type == Constants.FOLDER_TEMPLET
                    || type == Constants.FOLDER_PLAN || type == Constants.FOLDER_PLAN_DAY
                    || type == Constants.FOLDER_PLAN_MONTH || type == Constants.FOLDER_PLAN_WEEK
                    || type == Constants.FOLDER_PLAN_WORK)
                isShareAndBorrowRoot_ = true;

            DocTreeVO vo = new DocTreeVO(doc);
            vo.setDocLibType(docLibType);
            // 设置是否需要国际化标记
            DocMVCUtils.setNeedI18nInVo(vo);
            if (docLibType.byteValue() == Constants.PERSONAL_LIB_TYPE.byteValue())
                doc.setIsMyOwn(true);
            this.setGottenAclsInVO(vo, userId, isShareAndBorrowRoot_);
            if (type == Constants.PERSON_BORROW || type == Constants.PERSON_SHARE
                    || type == Constants.DEPARTMENT_BORROW || type == Constants.FOLDER_SHAREOUT
                    || type == Constants.FOLDER_BORROWOUT) {
                if (Constants.PROJECT_LIB_TYPE.equals(docLibType)) {
                    vo.setOpenIcon("folder_open.gif");
                    vo.setCloseIcon("folder_close.gif");
                }else{
                    vo.setOpenIcon(Constants.PERSON_ICON);
                    vo.setCloseIcon(Constants.PERSON_ICON);
                }
            } else {
                String srcIcon = docMimeTypeManager.getDocMimeTypeById(doc.getMimeTypeId()).getIcon();
                int index = srcIcon.indexOf('|');
                vo.setOpenIcon(srcIcon.substring( index + 1, srcIcon.length()));
                vo.setCloseIcon(srcIcon.substring(0, index==-1?srcIcon.length():index));
            }
            String v = null;
            if(vo.getDocLibType() == (byte)1) {
            	v = SecurityHelper.digest(doc.getId(),doc.getFrType(),docLibId,
                		vo.getDocLibType(),vo.getIsBorrowOrShare(),vo.isAllAcl(),vo.isEditAcl(),
            			vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl());
            } else {
            	Potent potent = docAclManager.getAclVO(doc.getId());
            	boolean all = false;
            	boolean edit = false;
            	boolean add = false;
            	boolean readonly = false;
            	boolean browse = false;
            	boolean list = false;
            	// 是否有权限进行计算
            	boolean isHasAcl = false;
            	if(potent != null) {
            		isHasAcl = true;
            		all = potent.isAll();
                	edit = potent.isEdit();
                	add = potent.isCreate();
                	readonly = potent.isReadOnly();
                	browse = potent.isRead();
                	list = potent.isList();
            	}
            	isShareAndBorrowRoot = vo.getIsBorrowOrShare();
            	if(Long.valueOf(40).equals(doc.getFrType())) {
            		isHasAcl = true;
            		isShareAndBorrowRoot = false;
            		all = edit = add = list = true;
            		readonly = browse = false;
            	}
            	if(Long.valueOf(110).equals(doc.getFrType()) 
            	        || Long.valueOf(111).equals(doc.getFrType())
            	        ||DocMVCUtils.isProjectVirtualCategory(doc.getFrType(), docRes.getId(), docLib, doc.getProjectTypeId()+"")) {
            		isShareAndBorrowRoot = false;
            		vo.setIsBorrowOrShare(isShareAndBorrowRoot);
            	}
            	if(isHasAcl) {
            		v = SecurityHelper.digest(doc.getId(),doc.getFrType(),docLibId,
                    		vo.getDocLibType(),isShareAndBorrowRoot,all,edit,add,readonly,browse,list);
            	} else {
            		v = SecurityHelper.digest(doc.getId(),doc.getFrType(),docLibId,
                    		vo.getDocLibType(),isShareAndBorrowRoot);
            	}
            	
            }            
            vo.setV(v);
            folders.add(vo);
        }

        out.println("<tree text=\"loaded\">");
        String xmlstr = DocMVCUtils.getXmlStr4LoadNodeOfCommonTree(docLibId, folders);
        out.println(xmlstr);
        out.println("</tree>");
        out.close();
        return null;
    }

    /** 弹出树  
     * @throws BusinessException */
    public ModelAndView xmlJspMove(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        response.setContentType("text/xml");
        response.setCharacterEncoding("utf-8");
        String stype = request.getParameter("frType");
        Long frType = Long.valueOf(stype);

        String sparentId = request.getParameter("resId");
        Long parentId = Long.valueOf(sparentId);
        DocResourcePO parent = docHierarchyManager.getDocResourceById(parentId);
        String validAcls = request.getParameter("validAcl");
        String pigeonholeType = request.getParameter("pigeonholeType");
        String projectTypeId = request.getParameter("projectTypeId");
        if("templeteManage".equals(pigeonholeType)){
            validAcls = "true";
        }
        
        boolean isCreatePrjectCategory = false;
        if("fromTempleteManage".equals(pigeonholeType)){
            isCreatePrjectCategory =  true;
        }
        // 对于资源是否存在的判断
        PrintWriter out = response.getWriter();
        if (parent == null) {
            out.println("<exist>no</exist>");
            return null;
        }
        DocLibPO lib = docLibManager.getDocLibById(parent.getDocLibId());
        List<DocTreeVO> folders = docHierarchyManager.getTreeNode(frType, parentId, validAcls, lib,projectTypeId,isCreatePrjectCategory);
        String otherAccountShortName = DocMVCUtils.getOtherAccountShortName(lib, orgManager);
        String xmlstr = DocMVCUtils.getXmlStr4LoadNodeOfMoveTree(lib, folders, otherAccountShortName,validAcls);
        out.println("<tree text=\"loaded\">");
        out.println(xmlstr);
        out.println("</tree>");
        out.close();
        return null;
    }

    /**
     * 集中加载文档列表想要的权限数据
     */
    public void initRightAclData(HttpServletRequest request, ModelAndView mav) throws BusinessException {
        boolean isGroupAdmin = this.canAdminGroup();
        int depAdminSize = DocMVCUtils.getDeptsByManagerSpace(spaceManager, AppContext.currentUserId()).size();

        // 三级当前位置显示
        String slibid = request.getParameter("docLibId");
        boolean isLibOwner = false;
        if (Strings.isNotBlank(slibid)) {
            long libId = Long.parseLong(slibid);
            isLibOwner = docLibManager.isOwnerOfLib(AppContext.currentUserId(), libId);
        }

        mav.addObject("isLibOwner", isLibOwner);
        mav.addObject("depAdminSize", depAdminSize);
        mav.addObject("isAdministrator", DocMVCUtils.isAccountSpaceManager(spaceManager, 
        						AppContext.currentUserId(), AppContext.currentAccountId()));
        mav.addObject("isGroupAdmin", isGroupAdmin);
    }

    /**
     * 新的right界面，三个(navigation, menu, list)合并
     * @throws BusinessException 
     */
    public ModelAndView rightNew(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        // 文档查看的入口参数,此入口的权限取权限表中的权限
        int entranceType = 2;
        ModelAndView ret = new ModelAndView("apps/doc/rightNew");
        // 此frType为文档夹的类型,其类型借阅 共享 日计划等待
        Long frType = Long.valueOf(request.getParameter("frType"));
        // resId是文档库下根文档夹的Id
        Long folderId = Long.valueOf(request.getParameter("resId"));
        String libId = request.getParameter("docLibId");
        String projectTypeId = request.getParameter("projectTypeId");
        Long isNew = 0L;
        if(Strings.isNotBlank(request.getParameter("isNew"))){
        	isNew = Long.valueOf(request.getParameter("isNew"));
        }
        Long isFromSea = 0L;
        boolean isNewView = (isNew==1)?true:false;
        if(Strings.isNotBlank(request.getParameter("isFromSea"))){
        	isFromSea = Long.valueOf(request.getParameter("isFromSea"));
        }
        ret.addObject("isFromSea",isFromSea);
        
        // 根据文档夹Id获得文档夹对象
        DocResourcePO folder = this.getParenetDocResource(folderId, frType);
        boolean docOpenToZoneFlag = DocUtils.isOpenToZoneFlag();
        if (folder == null) {
            return super.redirectModelAndView("/doc.do?method=docIndex&openLibType=1&docLibAlert=doc_source_folder_no_exist", "parent");
        }
        Long docLibId = folder.getDocLibId();
        if (Strings.isNotBlank(libId)) {
            docLibId = Long.valueOf(libId);
        }
        DocLibPO docLib = docLibManager.getDocLibById(docLibId);
        if (docLib == null || docLib.isDisabled()) {
            String key = docLib == null ? "doc_source_folder_no_exist" : "doc_lib_disabled";
            return super.redirectModelAndView("/doc.do?method=docIndex&openLibType=1&docLibAlert=" + key, "parent");
        }

        Byte docLibType = docLib.getType();
        if (Strings.isNotBlank(request.getParameter("docLibType"))) {
            docLibType = Byte.valueOf(request.getParameter("docLibType"));
        }
        ret.addObject("parent", folder);

        // 获得工具栏右上角查询条件的类型列表
        this.initRightAclData(request, ret);

        Long userId = AppContext.currentUserId();
        boolean isShareAndBorrowRoot = BooleanUtils.toBoolean(request.getParameter("isShareAndBorrowRoot"));
        if ((frType == Constants.FOLDER_BORROW || frType == Constants.FOLDER_SHAREOUT
                || frType == Constants.FOLDER_BORROWOUT || frType == Constants.FOLDER_SHARE
                || frType == Constants.PERSON_BORROW || frType == Constants.PERSON_SHARE
                || frType == Constants.DEPARTMENT_BORROW || frType == Constants.FOLDER_TEMPLET
                || frType == Constants.FOLDER_PLAN || frType == Constants.FOLDER_PLAN_DAY
                || frType == Constants.FOLDER_PLAN_MONTH || frType == Constants.FOLDER_PLAN_WEEK
                || frType == Constants.FOLDER_PLAN_WORK) && !Constants.PROJECT_LIB_TYPE.equals(docLibType)) {
            isShareAndBorrowRoot = true;
        }
        // 在生成文档列表时，就把文档权限入口传入
        if(docLib.getType() == Constants.PERSONAL_LIB_TYPE) {      	
        	if(isShareAndBorrowRoot) {
        		if(frType == Constants.FOLDER_BORROWOUT) {
        			entranceType = 3;
        		} else if(userId.equals(folder.getCreateUserId())) {
        			entranceType = 4;
        		} else {
        			entranceType = 2;
        		}
        	} else {
        		entranceType = 1;
        	}
        //公文档案库入口参数
        }else if(docLib.getType() == Constants.EDOC_LIB_TYPE){
            entranceType = 9;
        } else {
           entranceType = 5;
        }
        
        // 取得本页应该显示的DocResource对象
        List<DocResourcePO> drs = new ArrayList<DocResourcePO>();
        if (frType == Constants.FOLDER_SHAREOUT || frType == Constants.FOLDER_BORROWOUT) {
            Long parentFrId = folder.getParentFrId();
            drs = docHierarchyManager.findAllDocsByPage(isNewView,parentFrId, frType, userId,null);
        } else {
            String queryFlag = request.getParameter("queryFlag");
            if (BooleanUtils.toBoolean(queryFlag)) {
                String pingHoleSelect = request.getParameter("pingHoleSelect");
                if (Strings.isNotBlank(pingHoleSelect)) {
                    int pingHoleSelectFlag = Integer.parseInt(pingHoleSelect);
                    drs = docHierarchyManager.findAllDocsByPage(isNewView,folderId, frType, userId, pingHoleSelectFlag);
                }
            } else {
                //项目虚拟目录查询
                if (DocMVCUtils.isProjectVirtualCategory(frType, folderId, docLib,projectTypeId)) {
                    //根据项目类型Id查询所有项目id
//                    List<ProjectBO> psList = projectApi.findProjectsByTypeIdAndMemberId(userId,Long.parseLong(projectTypeId));
//                    List<Long> sourceIds = new ArrayList<Long>();//项目id
//                    for (ProjectBO pSummary : psList) {
//                        sourceIds.add(pSummary.getId());
//                    }
                	List<Long> sourceIds = projectApi.findProjectIdsByMemberAndType(userId, Long.parseLong(projectTypeId));
                	if(Strings.isNotEmpty(sourceIds)){
                	    drs = docHierarchyManager.findAllDocsByPage(isNewView,folderId, Constants.FOLDER_PROJECT_ROOT, userId,sourceIds);
                	}
                } else {
                	drs = docHierarchyManager.findAllDocsByPage(isNewView,folderId, frType, userId,null);
                }
            }
        }
        int rowCount = Pagination.getRowCount();
        // 根据 docLibId 得到有序的栏目元数据列表
        List<DocMetadataDefinitionPO> dmds = docLibManager.getListColumnsByDocLibId(docLibId,Constants.All_EDOC_ELMENT);
        //项目状态的取值，在虚拟目录以下可以查询
        /*if (docLib.getType() == Constants.PROJECT_LIB_TYPE && !DocMVCUtils.isProjectRoot(frType, folderId, docLib)) {
            DocMVCUtils.parseProjectStatus(drs, projectManager, docHierarchyManager);
        }*/
        ret.addObject("resId", folderId);
        ret.addObject("frType", frType);
        ret.addObject("isShareAndBorrowRoot", isShareAndBorrowRoot);
        //项目文档根据项目文档类别构建
        drs = DocMVCUtils.projectRootCategory(frType, folderId, docLib, drs, projectApi, orgManager);
        ret.addObject("isNeedSort", Strings.isNotEmpty(drs));
        List<DocTableVO> docs = this.getTableVOs(drs, dmds, ret, userId, isShareAndBorrowRoot, docLibType, folder, false, request, entranceType);
        //查询父文档夹事发后有公开到广场，或者当前文档下有哪些文档公开到广场；
        handleOpenSquare(folder, docLib, drs, docs);
        List<Long> docIds = new ArrayList<Long>();
        for (DocTableVO doc : docs) {
            docIds.add(doc.getDocResource().getId());
        }
        //查询当前文档是否被收藏过
        List<Map<String, Long>> collectFlag = knowledgeFavoriteManager.getFavoriteSource(docIds, AppContext.currentUserId());
        DocMVCUtils.handleCollect(docs, collectFlag);
        ret.addObject("docs", docs);
        DocMVCUtils.returnVaule(ret, docLibType, docLib, request, this.contentTypeManager, this.docLibManager, true);
        // 正常进入列表标记，区别于查询进入
        ret.addObject("from", "listDocs");
        List<Long> ownerSet = DocMVCUtils.getLibOwners(folder);
        boolean isOwner = ownerSet != null && ownerSet.contains(userId);
        
        //区隔
        ret.addObject("onlyA6", DocMVCUtils.isOnlyA6());
        ret.addObject("onlyA6s", DocMVCUtils.isOnlyA6S());
        ret.addObject("isA6",DocMVCUtils.isOnlyA6()||DocMVCUtils.isOnlyA6S());//OA-74381  文档中心没有面包屑
        //G6
        boolean isG6 = DocMVCUtils.isGovVer()||DocMVCUtils.isG6Group();
        ret.addObject("isGovVer",isG6);
        ret.addObject("docCollectFlag",SystemProperties.getInstance().getProperty("doc.collectFlag"));
        ret.addObject("docRecommendFlag",SystemProperties.getInstance().getProperty("doc.recommendFlag"));
        ret.addObject("docOpenToZoneFlag",docOpenToZoneFlag);
        
        ret.addObject("v",request.getParameter("v"));
        ret.addObject("all",request.getParameter("all"));
        ret.addObject("edit",request.getParameter("edit"));
        ret.addObject("add",request.getParameter("add"));
        ret.addObject("readonly",request.getParameter("readonly"));
        ret.addObject("browse",request.getParameter("browse"));
        ret.addObject("list",request.getParameter("list"));
        ret.addObject("projectTypeId",request.getParameter("projectTypeId"));
        ret.addObject("docLibId",request.getParameter("docLibId"));
        ret.addObject("docLibType",request.getParameter("docLibType"));
        
        ret.addObject("isNewView",isNew);
        //不是个人，项目库，开启插件
        ret.addObject("isAllowArchivePigeonhole",(docLib.getType() != Constants.PERSONAL_LIB_TYPE && 
                SystemEnvironment.hasPlugin("archive") &&  docLib.getType() != Constants.PROJECT_LIB_TYPE && isOwner ));
        Pagination.setRowCount(rowCount);
        return ret.addObject("isOwner", isOwner).addObject("entranceType", entranceType);
    }

	private void handleOpenSquare(DocResourcePO parentFolder, DocLibPO docLib,List<DocResourcePO> drs, List<DocTableVO> docs) {
        if (DocUtils.isOpenToZoneFlag() && (docHierarchyManager.isPersonalLib(parentFolder.getDocLibId()) || docLib.isPersonalLib())) {//仅仅个人文档库才需要查询公开到广场的标记
            if (parentFolder.getLogicalPath() != null && docAclNewManager.isOpenToSquareOfLogicPath(parentFolder.getLogicalPath())) {//全部
                for (DocTableVO doc : docs) {
                    if (isDocument(doc.getFrType())) {
                        doc.setOpenSquare(true);
                    }
                }
            } else {
                //直接查询文档中哪些文档中，是公开到广场的
                Set<Long> openSquareIds = docAclNewManager.openToSquareOfDoc(drs);
                for (DocTableVO doc : docs) {
                    if (openSquareIds.contains(doc.getDocResource().getId())) {
                        //排除虚拟公共文档夹的(文档夹不等于部门部门借阅)
                        if (isDocument(doc.getFrType()) && parentFolder.getFrType() != Constants.DEPARTMENT_BORROW) {
                            doc.setOpenSquare(true);
                        }
                    }
                }
            }
        }
	}

    public ModelAndView sortPropertyIframe(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/sortPageIframe");
    }

    /**
     * 获得需要排序的文档
     * @throws BusinessException 
     */
    public ModelAndView sortProperty(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView view = new ModelAndView("apps/doc/sortPage");
        Long sortFolderId = Long.valueOf(request.getParameter("resId"));
        DocResourcePO parent = this.docHierarchyManager.getDocResourceById(sortFolderId);
        boolean openToZoneFlag = DocUtils.isOpenToZoneFlag();
        boolean isEodcLib = false;
        Long userId = AppContext.currentUserId();
        long frType = Long.parseLong(request.getParameter("frType"));

        /**
         * 此处取得isCurrentPage主要是为了前端复选框的选择
         * 用Fiddle监测HTTP的请求参数发现，docResId只要是出现一次，就不会去掉
         * 如果是排序号仍在当前页，那就把docResId屏蔽掉，防止checkbox的checked属性的判断异常
         */
        String isCurrentPage = request.getParameter("isCurrentPage");
        if (isCurrentPage != null && "true".equals(isCurrentPage)) {
            String[] docResIds = request.getParameterValues("docCheckedId");

            if (docResIds != null && docResIds.length > 0) {
                String docCheckedId = docResIds[docResIds.length - 1];

                view.addObject("docCheckedId", docCheckedId);
                view.addObject("docResId", null);
            }
        } else {
            String docResId = request.getParameter("docResId");
            view.addObject("docResId", docResId);
        }

        Long parentFrId = frType == Constants.FOLDER_SHAREOUT || frType == Constants.FOLDER_BORROWOUT ? parent
                .getParentFrId() : sortFolderId;
        DocLibPO docLibById = docLibManager.getDocLibById(parent.getDocLibId());
        isEodcLib = docLibById.getType() == Constants.EDOC_LIB_TYPE;
        List<DocResourcePO> docs = docHierarchyManager.findAllDocsByPage(false,parentFrId, frType, userId,null);
        List<DocSortProperty> sortProperty = this.docHierarchyManager.getDocSortTable(docs);
        //查询父文档夹事发后有公开到广场，或者当前文档下有哪些文档公开到广场；
        if(docHierarchyManager.isPersonalLib(parent.getDocLibId()) && openToZoneFlag){//仅仅个人文档库才需要查询公开到广场的标记
            //1.查询父文档夹
            if(docAclNewManager.isOpenToSquareOfLogicPath(parent.getLogicalPath())){//全部
                for (DocSortProperty doc : sortProperty) {
                    if(isDocument(doc.getFrType())){
                        doc.setOpenSquare(true);
                    }
                }
            }else{//直接查询文档中哪些文档中，是公开到广场的
               Set<Long> openSquareIds = docAclNewManager.openToSquareOfDoc(docs);
               for (DocSortProperty doc : sortProperty) {
                   if(openSquareIds.contains(doc.getId())){
                       if(isDocument(doc.getFrType())){
                           doc.setOpenSquare(true);
                       }
                   }
               }
            }
        }
        return view.addObject("docs", sortProperty).addObject("isEodcLib", isEodcLib);
    }
    
    private boolean isDocument(Long frType){
       return  frType==Constants.FOLDER_COMMON||frType==Constants.DOCUMENT;
    }

	private List<DocTableVO> getTableVOs(List<DocResourcePO> drs, List<DocMetadataDefinitionPO> dmds, ModelAndView ret,
            Long userId, boolean isBorrowOrShare, byte docLibType, DocResourcePO parent,HttpServletRequest request) throws BusinessException {
        return this.getTableVOs(drs, dmds, ret, userId, isBorrowOrShare, docLibType, parent, true,request,null);
    }
	
	//查询流程结束状态
	private void getWorkflowEndState(DocTableVO vo,DocResourcePO dr){
	    List<Integer> flowEndState = new ArrayList<Integer>();
	    flowEndState.add(1);
	    flowEndState.add(3);
	    //flowEndState.add(4);
		if (Constants.SYSTEM_COL == dr.getFrType()|| dr.getFrType() ==Constants.SYSTEM_FORM) {
			try {
                CtpAffair ca = affairManager.get(dr.getSourceId());
                if (ca != null) {
                    ColSummary colSummary = collaborationApi.getColSummary(ca.getObjectId());
                    if (flowEndState.contains(colSummary.getState())) {
                        vo.setWorkflowEndState(true);
                        vo.setWorkflowState(colSummary.getState());
                    }
                }
			} catch (Exception e) {
				log.error("查询协同结束状态异常：",e);
			}
		}
		if (Constants.SYSTEM_ARCHIVES == dr.getFrType()) {
			try {
				EdocSummaryBO es = edocApi.getEdocSummary(dr.getSourceId());
				if (es != null && flowEndState.contains(es.getState())) {
					vo.setWorkflowEndState(true);
					vo.setWorkflowState(es.getState());
				}
			} catch (Exception e) {
				log.error("查询公文结束状态异常：",e);
			}
		}
	}
	
    // 封装右边列表的数据
    private List<DocTableVO> getTableVOs(List<DocResourcePO> drs, List<DocMetadataDefinitionPO> dmds, ModelAndView ret,
            Long userId, boolean isBorrowOrShare, byte docLibType, DocResourcePO parent, boolean isQuery,HttpServletRequest request,Integer entrance)
            throws BusinessException {
        List<DocTableVO> docs = new ArrayList<DocTableVO>();
        List<Integer> widths = DocMVCUtils.getColumnWidthNew(dmds);
        // 没有数据时返回标题栏
        if (CollectionUtils.isEmpty(drs)) {
            ret.addObject("isNull", "true");
            DocTableVO vo = new DocTableVO();
            List<GridVO> grids = vo.getGrids();
            int index = 0;
            for (DocMetadataDefinitionPO dmd : dmds) {
                GridVO grid = new GridVO();
                grid.setTitle(DocMVCUtils.getDisplayName4MetadataDefinition(dmd.getName()));
                grid.setPercent(widths.get(index));
                grid.setAlign(Constants.getAlign(dmd.getType()));

                grids.add(grid);
                index++;
            }
            ret.addObject("vo", vo);
        } else {
            ret.addObject("isNull", "false");
            boolean isPersonal = docLibType == Constants.PERSONAL_LIB_TYPE.byteValue();
            Map<Long, Map> metadatas = null;
            if (!isPersonal && DocMVCUtils.needFetchMetadata(dmds)) {
                List<Long> drIds = new ArrayList<Long>();
                for (DocResourcePO doc : drs) {
                	if (Constants.LINK == doc.getFrType()) {
                		drIds.add(doc.getSourceId());
                	} else {
                		drIds.add(doc.getId());
                	}
                }
                metadatas = this.docMetadataManager.getDocMetadatas(drIds);
                if (docLibType == Constants.EDOC_LIB_TYPE.byteValue() && DocMVCUtils.needFetchEdocMetadata(dmds)) {//需要查询公文中的扩展属性
                    List<Long> edocIds = new ArrayList<Long>();
                    Map<Long, Long> docId2EdocId = new HashMap<Long, Long>();
                    for (DocResourcePO doc : drs) {
                        if (doc.getSourceId() != null) {
                            edocIds.add(doc.getSourceId());
                            docId2EdocId.put(doc.getSourceId(), doc.getId());
                        }
                    }
                    Map<Long, Map<String, Object>> edocMetadatas = this.docMetadataManager.getEDocMetadatas(edocIds, dmds);
                    for (Long edocId : edocMetadatas.keySet()) {
                        Long docId = docId2EdocId.get(edocId);
                        Map<String, Object> docMetadataMap = metadatas.get(docId);
                        docMetadataMap.putAll(edocMetadatas.get(edocId));
                    }
                }
            }

            List<Long> sourceIds = new ArrayList<Long>();
			for (DocResourcePO doc : drs) {
				long ct = doc.getFrType();
				boolean isPersonType = (ct == Constants.PERSON_BORROW)
						|| (ct == Constants.PERSON_SHARE)
						|| (ct == Constants.DEPARTMENT_BORROW)
						|| (ct == Constants.FOLDER_BORROWOUT)
						|| (ct == Constants.FOLDER_SHAREOUT);

				if (!isPersonType) {
					DocMimeTypePO mime = docMimeTypeManager
							.getDocMimeTypeById(doc.getMimeTypeId());
					if (mime.getFormatType() == Constants.FORMAT_TYPE_DOC_FILE
							&& doc.getSourceId() != null) {
						sourceIds.add(doc.getSourceId());
					}
				}
			}
            List<V3XFile> files = new ArrayList<V3XFile>();
            Map<Long, V3XFile> fileMap = new HashMap<Long, V3XFile>();
			if (Strings.isNotEmpty(sourceIds)) {
				if (sourceIds.size() > 999) {
					List<Long>[] splitList = Strings.splitList(sourceIds, 1000);
					for (int i = 0; i < splitList.length; i++) {
						files = fileManager.getV3XFile(splitList[i]
								.toArray(new Long[] {}));
						if (Strings.isNotEmpty(files)) {
							for (V3XFile v3xFile : files) {
								fileMap.put(v3xFile.getId(), v3xFile);
							}
						}
					}
				} else {
					files = fileManager.getV3XFile(sourceIds
							.toArray(new Long[] {}));
					if (Strings.isNotEmpty(files)) {
						for (V3XFile v3xFile : files) {
							fileMap.put(v3xFile.getId(), v3xFile);
						}
					}
				}
			}

            for (DocResourcePO dr : drs) {
                DocTableVO vo = new DocTableVO(dr);
                //显示\r\n的处理
                dr.setFrName(dr.getFrName().replaceAll("\r\n", ""));
                // 单位借阅从左边目录树点击进去正常，从列表里面点击、单位借阅错误，发现传递的参数readOnly参数不同，，单位借阅时这里特意修改
                if ("doc.contenttype.publicBorrow".equals(dr.getFrName()) && dr.getFrType() == 103
                        && dr.getCreateUserId() == 0 && dr.getDocLibId() == 0 && dr.getParentFrId() == 0
                        && dr.getIsFolder()) {
                    vo.setReadOnlyAcl(true);
                }
                if(Constants.DocSourceType.favorite.key().equals(dr.getSourceType())
                		|| Constants.DocSourceType.favoriteAtt.key().equals(dr.getSourceType())){
                	vo.setIsCollect(true);
                }
                vo.setFrType(dr.getFrType());
                getWorkflowEndState(vo, dr);
                vo.setUpdateTime(dr.getLastUpdate());
                vo.setIsOffice(Constants.isOffice(dr.getMimeTypeId()));
                boolean isImg = Constants.isImgFile(dr.getMimeTypeId());
                vo.setIsImg(isImg);
                // 设置其file属性
                if (isImg) {
                    vo.setFile(fileMap.get(dr.getSourceId()));
                }
                vo.setIsLink(dr.getFrType() == Constants.LINK);
                vo.setIsFolderLink(dr.getFrType() == Constants.LINK_FOLDER);
                DocMVCUtils.setNeedI18nInVo(vo);
                DocMVCUtils.setPigFlag(vo);
                // 设置personalLib标记
                long ct = dr.getFrType();
                DocMimeTypePO mime = null;
                boolean isPersonType = (ct == Constants.PERSON_BORROW) || (ct == Constants.PERSON_SHARE)
                        || (ct == Constants.DEPARTMENT_BORROW) || (ct == Constants.FOLDER_BORROWOUT)
                        || (ct == Constants.FOLDER_SHAREOUT);

                if (isPersonType) {
                    vo.setIsPersonalLib(false);
                    // 设置是否虚拟节点标记
                    vo.setIsPerson(true);
                } else {
                    vo.setIsPersonalLib(isPersonal);

                    mime = docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId());
                    // 设置可以下载标记
                    vo.setIsUploadFile(mime.getFormatType() == Constants.FORMAT_TYPE_DOC_FILE);
                    if (vo.getIsUploadFile()) {
                        V3XFile file = fileMap.get(dr.getSourceId());
                        if (file != null) {
                            vo.setCreateDate(Datetimes.formatDate(file.getCreateDate()));
                            vo.setvForDocDownload(file.getV());
                        } else {
                            vo.setCreateDate(Datetimes.formatDate(new Date()));
                            vo.setvForDocDownload("");
                        }
                    } else {
                        vo.setCreateDate(Datetimes.formatDate(dr.getCreateTime()));
                    }

                    // 设置权限标记
                    if(Integer.valueOf(3).equals(entrance)) {
                    	vo.setAllAcl(false);
                		vo.setEditAcl(false);
                		vo.setReadOnlyAcl(false);
                		vo.setBrowseAcl(false);
                		vo.setListAcl(true);
                		vo.setAddAcl(false);
                    } else {
                    	this.setGottenAclsInVO(vo, userId, isBorrowOrShare);
                    }             
                }
                List<GridVO> grids = vo.getGrids();
                int index = 0;
                Map metadataMap = null;
                if (Constants.LINK == dr.getFrType()) {
                	metadataMap = metadatas == null ? null : metadatas.get(dr.getSourceId());
                } else {
                	metadataMap = metadatas == null ? null : metadatas.get(dr.getId());
                }
                int totalPercent = 0;
                int nameIndex = 0;
                for (DocMetadataDefinitionPO dmd : dmds) {
                    GridVO grid = new GridVO();
                    grid.setType(Constants.getClazz4Ctrl(dmd.getType()));
                    grid.setTitle(DocMVCUtils.getDisplayName4MetadataDefinition(dmd.getName()));
                    String name = dmd.getPhysicalName();

                    boolean isName = DocResourcePO.PROP_FRNAME.equals(dmd.getPhysicalName());
                    if (isName) {
                        nameIndex = index;
                    }
                    grid.setIsName(isName);

                    grid.setIsSize(DocResourcePO.PROP_SIZE.equals(dmd.getPhysicalName()));
                    Object value = null;
                    if (dmd.getIsDefault()) {
                        try {
                            value = PropertyUtils.getSimpleProperty(dr, name);
                            if ((dr.getFrType() == Constants.FOLDER_PLAN || dr.getFrType() == Constants.SYSTEM_PLAN
                                    || dr.getFrType() == Constants.FOLDER_PLAN_DAY
                                    || dr.getFrType() == Constants.FOLDER_PLAN_MONTH
                                    || dr.getFrType() == Constants.FOLDER_PLAN_WEEK || dr.getFrType() == Constants.FOLDER_PLAN_WORK)
                                    && DocResourcePO.PROP_LAST_UPDATE.equals(name)) {
                                value = Datetimes.formatDate((Date) value);
                                grid.setType(String.class);
                            }
                        } catch (Exception e) {
                            log.error("getTableVos通过反射取得相应的栏目值时出现异常[属性名称：" + name + "]:", e);
                        }
                    } else {
                        value = metadataMap == null ? null : metadataMap.get(dmd.getPhysicalName());
                    }

                    String stringValue = String.valueOf(value);
                    //OA-53085 文档中心：建立一个名为null的文件（夹），显示结果为&nbsp;
                    /*if (stringValue.equals("null"))
                        value = "";*/

                    if ("0".equals(stringValue) && dmd.getType() == Constants.SIZE) {
                        grid.setType(StringBuffer.class);
                    }

                    if (!"".equals(value) && !"null".equals(value) && value != null) {
                        // 判断是否引用类型元数据，取得相应属性
                        byte mdType = dmd.getType();
                        if (mdType == Constants.BOOLEAN) {
                            if ("true".equals(stringValue))
                                value = "common.yes";
                            else
                                value = "common.no";
                        } else if (mdType == Constants.USER_ID) {
                            grid.setType(String.class);
                            value = Functions.showMemberName((Long) value);
                        } else if (mdType == Constants.DEPT_ID) {
                            grid.setType(String.class);
                            try {
                                value = orgManager.getDepartmentById((Long) value).getName();
                            } catch (BusinessException e) {
                                log.error("通过orgManager取得dept", e);
                            }
                        } else if (mdType == Constants.CONTENT_TYPE) {
                            if (isPersonType) {
                                value = "";
                            } else {
                                grid.setNeedI18n(true);
                                grid.setType(String.class);
                                DocTypePO docType = contentTypeManager.getContentTypeById(Long.valueOf(stringValue));
                                if(docType!=null)
                                	value = docType.getName();
                            }
                        } else if (mdType == Constants.SIZE) {
                            grid.setType(StringBuffer.class);
                            if (vo.getIsLink() || vo.getIsFolderLink() || vo.getIsPig()
                                    || vo.getDocResource().getIsFolder()) {
                                value = "";
                            } else {
                                value = Strings.formatFileSize((Long) value, true);
                            }
                        } else if (mdType == Constants.IMAGE_ID) {
                            grid.setType(null);
                            if (!isPersonType) {
                                if (dr.getIsFolder()) {
                                    String src = mime.getIcon();
                                    value = src.substring(0, src.indexOf("|"));
                                } else {
                                    value = mime.getIcon();
                                }
                                grid.setIsImg(true);
                            }
                        } else if (mdType == Constants.ENUM) {
                            Set<DocMetadataOptionPO> docMetadataOptions = dmd.getMetadataOption();
                            for (DocMetadataOptionPO dmo : docMetadataOptions) {
                                if (dmo.getId().toString().equals(value.toString())) {
                                    value = dmo.getOptionItem();
                                    break;
                                }
                            }
                        }
                    }

                    // icon
                    if (isPersonType){
                        if (dmd.getType() == Constants.IMAGE_ID && Constants.PROJECT_LIB_TYPE.equals(docLibType)) {
                            grid.setTitle("");
                            grid.setIsImg(false);
                        }else if(dmd.getType() == Constants.IMAGE_ID){
                            value = Constants.PERSON_ICON;
                            grid.setTitle("");
                            grid.setIsImg(true);
                        }
                    }
                        

                    // 需要调用元数据组件
                    if (value != null && Strings.isNotBlank(value.toString())) {
                        EnumNameEnum mne = Constants.getMetadataNameEnum(dmd.getName(), value.toString(),
                                dr.getFrType());
                        if (mne != null) {
                            value = enumManagerNew.getEnumItemLabel(mne, value.toString());
                            value = DocMVCUtils.getDisplayName4MetadataDefinition(String.valueOf(value),
                                    value.toString());
                        }
                    }

                    //对数据升级问题文档夹记录数进行过滤(文档夹记录数默认为0,其他不变)
                    if(dr.getIsFolder()&&("阅读").equals(DocMVCUtils.getDisplayName4MetadataDefinition(dmd.getName()))){
                    	grid.setValue(0);
                    }else{
                    	grid.setValue(value);
                    }
                    // 5. percent
                    Integer percent = widths.get(index);
                    grid.setPercent(percent);
                    totalPercent += percent;

                    // 6. align
                    grid.setAlign(Constants.getAlign(dmd.getType()));
                    if ((grid.getValue() == null || "".equals(grid.getValue()) && !grid.getType().equals(Date.class)
                            && !(dmd.getType() == Constants.SIZE) && !grid.getType().equals(Date.class))) {
                        grid.setValue("&nbsp;");
                        grid.setType(String.class);
                    }
                    grids.add(grid);
                    index++;
                }
                if (totalPercent < 95) {
                    grids.get(nameIndex).setPercent(grids.get(nameIndex).getPercent() + (95 - totalPercent));
                }              
                // 如果是文档夹，计算安全访问的v值
                if(dr.getIsFolder() && request != null) {
                	String v = SecurityHelper.digest(vo.getDocResource().getId(),vo.getDocResource().getFrType(),request.getParameter("docLibId"),
                    		request.getParameter("docLibType"),request.getParameter("isShareAndBorrowRoot"),vo.isAllAcl(),vo.isEditAcl(),
                			vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl());
                    vo.setV(v);
                }
                String parentCommentEnabled = request.getParameter("parentCommentEnabled") == null ? "" : request.getParameter("parentCommentEnabled");
                String parentRecommendEnable = request.getParameter("parentRecommendEnable") == null ? "" : request.getParameter("parentRecommendEnable");
                
                // 文档中心列表上的文档的属性操作安全性验证
                String vForDocPropertyIframe = SecurityHelper.digest(request.getParameter("resId"),vo.getDocResource().getId(),request.getParameter("frType"),request.getParameter("docLibId"),
                		request.getParameter("docLibType"),request.getParameter("isShareAndBorrowRoot"),vo.isAllAcl(),vo.isEditAcl(),
            			vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl(),parentCommentEnabled,parentRecommendEnable);
                vo.setvForDocPropertyIframe(vForDocPropertyIframe);
                // 文档中心列表上的借阅操作安全性验证
                String vForBorrow = SecurityHelper.digest(vo.getDocResource().getId(),request.getParameter("frType"),
                		docLibType,isBorrowOrShare,vo.isAllAcl(),vo.isEditAcl(),vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl());
                vo.setvForBorrow(vForBorrow);
                docs.add(vo);
            }
        }

        String docLoc = "";
        Long parentFrId = parent.getParentFrId();
        DocResourcePO par = docHierarchyManager.getDocResourceById(parentFrId);
        // 借阅共享的路径
        if (isBorrowOrShare && parent.getFrType() != Constants.FOLDER_BORROW
                && parent.getFrType() != Constants.FOLDER_SHARE && parent.getFrType() != Constants.FOLDER_SHAREOUT
                && parent.getFrType() != Constants.FOLDER_BORROWOUT) {

            if (parent.getFrType() == Constants.PERSON_SHARE || parent.getFrType() == Constants.PERSON_BORROW
                    || parent.getFrType() == Constants.DEPARTMENT_BORROW) {
                //项目文档的虚拟目录
                if(Constants.DOC_LIB_ROOT_ID_PROJECT.equals(parent.getId()) && Constants.PROJECT_LIB_TYPE.equals(docLibType)){
                    docLoc = parseLocationPath(parent, request , true);
                }else{
                    //我的文档下的 面包屑  中的 "我的文档" 固话为当前登陆者的“我的文档”
                    DocResourcePO mydoc = docHierarchyManager.getPersonalFolderOfUser(AppContext.currentUserId());
                    long mydocId = mydoc.getId();

                    docLoc = ResourceUtil.getString(parent.getFrName());
                    docLoc = this.convertToLink(docLoc, docLoc, parent.getId(), parent.getFrType(),request);

                    long folderId = parent.getFrType() == Constants.PERSON_SHARE ? Constants.FOLDER_SHARE
                            : Constants.FOLDER_BORROW;
                    DocResourcePO borrowOrShareDoc = docHierarchyManager.getDocByType(mydoc.getDocLibId(), folderId);
                    String name1 = ResourceUtil.getString(borrowOrShareDoc.getFrName());
                    String docLoc1 = this.convertToLink(name1, name1, borrowOrShareDoc.getId(),
                            borrowOrShareDoc.getFrType(),request);

                    String name2 = ResourceUtil.getString(mydoc.getFrName());
                    String docLoc2 = this.convertToLink(name2, name2, mydocId, mydoc.getFrType(),request);

                    docLoc = docLoc2 + Constants.NAV_SPLIT + docLoc1 + Constants.NAV_SPLIT + docLoc;
                }
            	
            } else if (parent.getFrType() == Constants.FOLDER_MINE) {
                docLoc = ResourceUtil.getString(parent.getFrName());
                docLoc = this.convertToLink(docLoc, docLoc, parent.getId(), parent.getFrType(),request);
            } else if (parent.getFrType() == Constants.FOLDER_PLAN || parent.getFrType() == Constants.FOLDER_PLAN_DAY
                    || parent.getFrType() == Constants.FOLDER_PLAN_MONTH
                    || parent.getFrType() == Constants.FOLDER_PLAN_WEEK
                    || parent.getFrType() == Constants.FOLDER_PLAN_WORK) {
                docLoc = this.getLocation(parent.getLogicalPath(),request);
            } else if (par != null
                    && (par.getFrType() == Constants.FOLDER_SHAREOUT || parent.getFrType() == Constants.FOLDER_BORROWOUT)) {
                DocResourcePO doc = docHierarchyManager.getPersonalFolderOfUser(AppContext.currentUserId());
                Long mydocId = doc.getParentFrId();
                DocResourcePO mydoc = docHierarchyManager.getDocResourceById(mydocId);
                String name = ResourceUtil.getString(mydoc.getFrName());
                docLoc = parent.getFrName();
                docLoc = this.convertToLink(docLoc, docLoc, parent.getId(), parent.getFrType(),request);
                docLoc = name + Constants.NAV_SPLIT + docLoc;

            } else {
                // 共享的文档夹被打开了
                DocResourcePO doc = docHierarchyManager.getPersonalFolderOfUser(AppContext.currentUserId());
                Long mydocId = doc.getId();
                DocResourcePO mydoc = docHierarchyManager.getDocResourceById(mydocId);
                DocResourcePO shareDoc = docHierarchyManager.getDocByType(mydoc.getDocLibId(), Constants.FOLDER_SHARE);
                String name1 = ResourceUtil.getString(shareDoc.getFrName());
                String name2 = ResourceUtil.getString(mydoc.getFrName());
                String docLoc1 = this.convertToLink(name1, name1, shareDoc.getId(), shareDoc.getFrType(),request);
                String docLoc2 = this.convertToLink(name2, name2, mydocId, mydoc.getFrType(),request);

                docLoc = parent.getFrName();
                docLoc = this.convertToLink(docLoc, docLoc, parent.getId(), parent.getFrType(),request);
                List<Long> owners = this.docLibManager.getOwnersByDocLibId(parent.getDocLibId());

                if (owners != null && owners.size() > 0) {
                    long ownerid = owners.iterator().next();
                    String name = Constants.getOrgEntityName(V3xOrgEntity.ORGENT_TYPE_MEMBER, ownerid, false);
                    name = this.convertToLink(name, name, ownerid, Constants.PERSON_SHARE,request);
                    docLoc = docLoc2 + Constants.NAV_SPLIT + docLoc1 + Constants.NAV_SPLIT + name + Constants.NAV_SPLIT + docLoc;
                }

            }
        } else if (parent != null && parent.getLogicalPath() != null){
            //项目文档路径的特殊处理
            if (Constants.DOC_LIB_ID_PROJECT.equals(parent.getDocLibId()) && parent.getParentFrId() != 0) {
                docLoc = parseLocationPath(parent, request,false);
            } else {
                docLoc = this.getLocation(parent.getLogicalPath(), request);
            }
        }
            

        if (Strings.isBlank(docLoc) && parent != null) {
            docLoc = parent.getFrName();
            docLoc = this.convertToLink(docLoc, docLoc, parent.getId(), parent.getFrType(),request);
        }
        //文档面包屑修改
        docLoc = docLoc.replaceAll("link-blue","firstA");
        ret.addObject("docLoc", docLoc);

        if (CollectionUtils.isNotEmpty(docs) && isQuery) {
            Collections.sort(docs);
        }

        return docs;
    }
    
    private String parseLocationPath(DocResourcePO parent, HttpServletRequest request,boolean isVirtual) throws BusinessException {
        List<Long> ids = CommonTools.parseStr2Ids(parent.getLogicalPath(), "[.]"); 
        Long projectTypeId = null;
        if(isVirtual){
            projectTypeId = Long.valueOf(request.getParameter("projectTypeId"));
        }else{
            Long docId = ids.get(1);//if条件排除根目录，取项目文档夹下的项目跟文档夹的sourceId
            DocResourcePO projectRootDoc = docHierarchyManager.getDocResourceById(docId);
            projectTypeId = projectApi.getProject(projectRootDoc.getSourceId()).getProjectTypeId();
        }
        
        ProjectTypeBO pt = projectApi.getProjectType(projectTypeId);
        String logicPath = "";
        if (ids.size() > 1) {
            logicPath = parent.getLogicalPath().substring((ids.get(0)+".").length());
            logicPath = Constants.NAV_SPLIT + this.getLocation(logicPath, request);
        }
        
        request.setAttribute("projectTypeId", projectTypeId);
        
        //虚拟目录
        String projectTypeName = pt.getName();
        if (!Long.valueOf(1l).equals(pt.getAccountId()) && !pt.getAccountId().equals(AppContext.currentAccountId())) {
            projectTypeName += "(" + orgManager.getAccountById(pt.getAccountId()).getName() + ")";
        }
        String docLoc = this.convertToLink(projectTypeName, projectTypeName,ids.get(0), 101l, request);
        
        docLoc = this.getLocation(ids.get(0) + "", request) + Constants.NAV_SPLIT + docLoc + logicPath;
        
        return docLoc;
    }

    /** 设置DocAclVO对象中的权限标记  
     * @throws BusinessException */
    private void setGottenAclsInVO(DocAclVO vo, Long userId, boolean isBorrowOrShare) throws BusinessException {
        DocMVCUtils.setGottenAclsInVO(vo, userId, isBorrowOrShare, docAclManager);
    }

    /**
     * 点击文档库，返回 
     * 1. 该库根文档夹下的所有下级文档夹（左边） List<DocResourcePO> folders
     * 2.其他所有的库的根文档夹列表
     * 页面应该传入 userId, List<Long> docLibIds 当前用户拥有权限的所有文档库 docLibId 用户点击的文档库
     */
    public ModelAndView listRoots(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView ret = null;
        String appName = request.getParameter("appName");
        String flag = request.getParameter("isrightworkspace");
        String spaceType = request.getParameter("spaceType");
        String pigeonholeType = request.getParameter("pigeonholeType");
        String validAcl = request.getParameter("validAcl");
        String id = request.getParameter("id");
        String docLibType = request.getParameter("docLibType");
        String frName = request.getParameter("frName");

        List<DocTreeVO> roots = new ArrayList<DocTreeVO>();
        List<DocTreeVO> temp = docHierarchyManager.getTreeRootNode(appName, flag, spaceType, pigeonholeType, validAcl, id, docLibType, frName);
        if ("bizMap".equals(request.getParameter("from"))) {
            for (DocTreeVO docTreeVO : temp) {
                if (docTreeVO.getDocLibType() != Constants.EDOC_LIB_TYPE) {
                    roots.add(docTreeVO);
                }
            }
        } else {
            roots.addAll(temp);
        }

        if ("move".equals(flag) || "link".equals(flag) || "pigeonhole".equals(flag)) {
            ret = new ModelAndView("apps/doc/docTreeMove");
        } else if ("quote".equals(flag)) {
            ret = new ModelAndView("apps/doc/quote/docQuoteTree");
        } else {
            ret = new ModelAndView("apps/doc/docTree");
        }
        ret.addObject("pigeonholeType",pigeonholeType);
        ret.addObject("frName", frName);
        ret.addObject("roots", roots);
        return ret;
    }
    
    
    // 客开  START
    /** 专题文档中心首页框架  
     * @throws BusinessException */
    public ModelAndView docZhuanTiIndex(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView ret = new ModelAndView("apps/doc/docZhuanTiIndex");
        String zhuantiType = request.getParameter("zhuantiType");
        if (zhuantiType == null){
        	zhuantiType = "0";
        }
        ret.addObject("zhuantiType", zhuantiType);
        
        Long userId = AppContext.currentUserId();
        // 是否从文档夹的打开转过来，如果是，说明需要提醒用户，原来需要打开的文档夹不存在了
        boolean alertNotExist = request.getParameter("docResId") != null;
        //是否为企业版
        boolean isEnterpriseVer = (Boolean)(SysFlag.sys_isEnterpriseVer.getFlag());
        Byte docLibType = Constants.ACCOUNT_LIB_TYPE;
        if(Strings.isNotBlank(request.getParameter("openLibType"))){
        	docLibType = Byte.valueOf(request.getParameter("openLibType"));
        }
        boolean isV5Member = AppContext.getCurrentUser().getExternalType() == OrgConstants.ExternalType.Inner.ordinal();
        Long accountId = AppContext.currentAccountId();
        if (!isV5Member) {
            accountId = OrgHelper.getVJoinAllowAccount();
            docLibType = Constants.GROUP_LIB_TYPE;
            if(isEnterpriseVer){
                docLibType = Constants.ACCOUNT_LIB_TYPE;
            }
        }
        boolean isPersonalLib = Constants.PERSONAL_LIB_TYPE.equals(docLibType);
        DocLibPO lib = null;
        if (Constants.PERSONAL_LIB_TYPE.equals(docLibType)) {//私人
            lib = this.docLibManager.getPersonalLibOfUser(userId);
        } else if(Constants.EDOC_LIB_TYPE.equals(docLibType)){//公文
            lib = this.docLibManager.getLibsOfAccount(AppContext.currentAccountId(),docLibType).get(0);
        } else if(Constants.PROJECT_LIB_TYPE.equals(docLibType)){//项目
            lib = this.docLibManager.getProjectDocLib();
        } else if(Constants.GROUP_LIB_TYPE.equals(docLibType)){//集团
            lib = this.docLibManager.getGroupDocLib();
        } else{//单位
            lib = this.docLibManager.getDeptLibById(accountId);
        }
        Long openLibId = lib.getId();
        // 得到文档库下的根文件（夹）
        DocResourcePO dr = new DocResourcePO();
        if(request.getParameter("docId")!=null){
        	Long id = Long.parseLong(request.getParameter("docId"));
        	dr = docHierarchyManager.getDocResourceById(id);
        	isPersonalLib = true;
        }else{
        	dr = docHierarchyManager.getRootByLibId(lib.getId());
        }
        
        dr.setIsMyOwn(isPersonalLib);
        DocTreeVO vo = this.getDocTreeVO(userId, dr, isPersonalLib);
        ret.addObject("docLibId", openLibId).addObject("root", vo).addObject("alertNotExist", alertNotExist);
        ret.addObject("v", SecurityHelper.digest(vo.getDocResource().getId(),vo.getDocResource().getFrType(),openLibId,docLibType,Boolean.FALSE,vo.isAllAcl(),vo.isEditAcl() ,
    			vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl()));
        ret.addObject("docLibType", docLibType);
        return ret;
    }
    /**
     * 首页专题引用文档中心 
     * 1. 该库根文档夹下的所有下级文档夹（左边） List<DocResourcePO> folders
     * 2.其他所有的库的根文档夹列表
     * 页面应该传入 userId, List<Long> docLibIds 当前用户拥有权限的所有文档库 docLibId 用户点击的文档库
     */
    public ModelAndView listZhuanTiRoots(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView ret = null;
        String appName = request.getParameter("appName");
        String flag = request.getParameter("isrightworkspace");
        String spaceType = request.getParameter("spaceType");
        String pigeonholeType = request.getParameter("pigeonholeType");
        String validAcl = request.getParameter("validAcl");
        String id = request.getParameter("id");
        String docLibType = request.getParameter("docLibType");
        String frName = request.getParameter("frName");
        String zhuantiType = request.getParameter("zhuantiType");

        List<DocTreeVO> roots = new ArrayList<DocTreeVO>();
        List<DocTreeVO> temp = docHierarchyManager.getTreeRootNode(appName, flag, spaceType, pigeonholeType, validAcl, id, docLibType, frName);
        if ("bizMap".equals(request.getParameter("from"))) {
            for (DocTreeVO docTreeVO : temp) {
                if (docTreeVO.getDocLibType() != Constants.EDOC_LIB_TYPE) {
                    roots.add(docTreeVO);
                }
            }
        } else {
            roots.addAll(temp);
        }

        if ("move".equals(flag) || "link".equals(flag) || "pigeonhole".equals(flag)) {
            ret = new ModelAndView("apps/doc/docTreeMove");
        } else if ("quote".equals(flag)) {
            ret = new ModelAndView("apps/doc/quote/docQuoteTree");
        } else {
            ret = new ModelAndView("apps/doc/docZhuanTiTree");
        }
        ret.addObject("pigeonholeType",pigeonholeType);
        ret.addObject("frName", frName);
        ret.addObject("roots", roots);
        ret.addObject("zhuantiType", zhuantiType == null ? "0" : zhuantiType);
        return ret;
    }
    
    /**
     * 新的down界面，三个(navigation, menu, list)合并
     * @throws BusinessException 
     */
    public ModelAndView downNew(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        // 文档查看的入口参数,此入口的权限取权限表中的权限
        int entranceType = 2;
        ModelAndView ret = new ModelAndView("apps/doc/downNew");
        // 此frType为文档夹的类型,其类型借阅 共享 日计划等待
        Long frType = Long.valueOf(request.getParameter("frType"));
        // resId是文档库下根文档夹的Id
        Long folderId = Long.valueOf(request.getParameter("resId"));
        String libId = request.getParameter("docLibId");
        String projectTypeId = request.getParameter("projectTypeId");
        String zhuantiType = request.getParameter("zhuantiType");
        ret.addObject("zhuantiType",zhuantiType == null ? "0" : zhuantiType);
        Long isNew = 0L;
        if(Strings.isNotBlank(request.getParameter("isNew"))){
        	isNew = Long.valueOf(request.getParameter("isNew"));
        }
        Long isFromSea = 0L;
        boolean isNewView = (isNew==1)?true:false;
        if(Strings.isNotBlank(request.getParameter("isFromSea"))){
        	isFromSea = Long.valueOf(request.getParameter("isFromSea"));
        }
        ret.addObject("isFromSea",isFromSea);
        
        // 根据文档夹Id获得文档夹对象
        DocResourcePO folder = this.getParenetDocResource(folderId, frType);
        boolean docOpenToZoneFlag = DocUtils.isOpenToZoneFlag();
        if (folder == null) {
            return super.redirectModelAndView("/doc.do?method=docZhuanTiIndex&openLibType=1&docLibAlert=doc_source_folder_no_exist", "parent");
        }
        Long docLibId = folder.getDocLibId();
        if (Strings.isNotBlank(libId)) {
            docLibId = Long.valueOf(libId);
        }
        DocLibPO docLib = docLibManager.getDocLibById(docLibId);
        if (docLib == null || docLib.isDisabled()) {
            String key = docLib == null ? "doc_source_folder_no_exist" : "doc_lib_disabled";
            return super.redirectModelAndView("/doc.do?method=docZhuanTiIndex&openLibType=1&docLibAlert=" + key, "parent");
        }

        Byte docLibType = docLib.getType();
        if (Strings.isNotBlank(request.getParameter("docLibType"))) {
            docLibType = Byte.valueOf(request.getParameter("docLibType"));
        }
        ret.addObject("parent", folder);

        // 获得工具栏右上角查询条件的类型列表
        this.initRightAclData(request, ret);

        Long userId = AppContext.currentUserId();
        boolean isShareAndBorrowRoot = BooleanUtils.toBoolean(request.getParameter("isShareAndBorrowRoot"));
        if ((frType == Constants.FOLDER_BORROW || frType == Constants.FOLDER_SHAREOUT
                || frType == Constants.FOLDER_BORROWOUT || frType == Constants.FOLDER_SHARE
                || frType == Constants.PERSON_BORROW || frType == Constants.PERSON_SHARE
                || frType == Constants.DEPARTMENT_BORROW || frType == Constants.FOLDER_TEMPLET
                || frType == Constants.FOLDER_PLAN || frType == Constants.FOLDER_PLAN_DAY
                || frType == Constants.FOLDER_PLAN_MONTH || frType == Constants.FOLDER_PLAN_WEEK
                || frType == Constants.FOLDER_PLAN_WORK) && !Constants.PROJECT_LIB_TYPE.equals(docLibType)) {
            isShareAndBorrowRoot = true;
        }
        // 在生成文档列表时，就把文档权限入口传入
        if(docLib.getType() == Constants.PERSONAL_LIB_TYPE) {      	
        	if(isShareAndBorrowRoot) {
        		if(frType == Constants.FOLDER_BORROWOUT) {
        			entranceType = 3;
        		} else if(userId.equals(folder.getCreateUserId())) {
        			entranceType = 4;
        		} else {
        			entranceType = 2;
        		}
        	} else {
        		entranceType = 1;
        	}
        //公文档案库入口参数
        }else if(docLib.getType() == Constants.EDOC_LIB_TYPE){
            entranceType = 9;
        } else {
           entranceType = 5;
        }
        
        // 取得本页应该显示的DocResource对象
        List<DocResourcePO> drs = new ArrayList<DocResourcePO>();
        if (frType == Constants.FOLDER_SHAREOUT || frType == Constants.FOLDER_BORROWOUT) {
            Long parentFrId = folder.getParentFrId();
            drs = docHierarchyManager.findAllDocsByPage(isNewView,parentFrId, frType, userId,null);
        } else {
            String queryFlag = request.getParameter("queryFlag");
            if (BooleanUtils.toBoolean(queryFlag)) {
                String pingHoleSelect = request.getParameter("pingHoleSelect");
                if (Strings.isNotBlank(pingHoleSelect)) {
                    int pingHoleSelectFlag = Integer.parseInt(pingHoleSelect);
                    drs = docHierarchyManager.findAllDocsByPage(isNewView,folderId, frType, userId, pingHoleSelectFlag);
                }
            } else {
                //项目虚拟目录查询
                if (DocMVCUtils.isProjectVirtualCategory(frType, folderId, docLib,projectTypeId)) {
                    //根据项目类型Id查询所有项目id
//                    List<ProjectBO> psList = projectApi.findProjectsByTypeIdAndMemberId(userId,Long.parseLong(projectTypeId));
//                    List<Long> sourceIds = new ArrayList<Long>();//项目id
//                    for (ProjectBO pSummary : psList) {
//                        sourceIds.add(pSummary.getId());
//                    }
                	List<Long> sourceIds = projectApi.findProjectIdsByMemberAndType(userId, Long.parseLong(projectTypeId));
                	if(Strings.isNotEmpty(sourceIds)){
                	    drs = docHierarchyManager.findAllDocsByPage(isNewView,folderId, Constants.FOLDER_PROJECT_ROOT, userId,sourceIds);
                	}
                } else {
                	drs = docHierarchyManager.findAllDocsByPage(isNewView,folderId, frType, userId,null);
                }
            }
        }
        int rowCount = Pagination.getRowCount();
        // 根据 docLibId 得到有序的栏目元数据列表
        List<DocMetadataDefinitionPO> dmds = docLibManager.getListColumnsByDocLibId(docLibId,Constants.All_EDOC_ELMENT);
        //项目状态的取值，在虚拟目录以下可以查询
        /*if (docLib.getType() == Constants.PROJECT_LIB_TYPE && !DocMVCUtils.isProjectRoot(frType, folderId, docLib)) {
            DocMVCUtils.parseProjectStatus(drs, projectManager, docHierarchyManager);
        }*/
        ret.addObject("resId", folderId);
        ret.addObject("frType", frType);
        ret.addObject("isShareAndBorrowRoot", isShareAndBorrowRoot);
        //项目文档根据项目文档类别构建
        drs = DocMVCUtils.projectRootCategory(frType, folderId, docLib, drs, projectApi, orgManager);
        ret.addObject("isNeedSort", Strings.isNotEmpty(drs));
        List<DocTableVO> docs = this.getTableVOs(drs, dmds, ret, userId, isShareAndBorrowRoot, docLibType, folder, false, request, entranceType);
        //查询父文档夹事发后有公开到广场，或者当前文档下有哪些文档公开到广场；
        handleOpenSquare(folder, docLib, drs, docs);
        List<Long> docIds = new ArrayList<Long>();
        for (DocTableVO doc : docs) {
            docIds.add(doc.getDocResource().getId());
        }
        //查询当前文档是否被收藏过
        List<Map<String, Long>> collectFlag = knowledgeFavoriteManager.getFavoriteSource(docIds, AppContext.currentUserId());
        DocMVCUtils.handleCollect(docs, collectFlag);
        ret.addObject("docs", docs);
        DocMVCUtils.returnVaule(ret, docLibType, docLib, request, this.contentTypeManager, this.docLibManager, true);
        // 正常进入列表标记，区别于查询进入
        ret.addObject("from", "listDocs");
        List<Long> ownerSet = DocMVCUtils.getLibOwners(folder);
        boolean isOwner = ownerSet != null && ownerSet.contains(userId);
        
        //区隔
        ret.addObject("onlyA6", DocMVCUtils.isOnlyA6());
        ret.addObject("onlyA6s", DocMVCUtils.isOnlyA6S());
        ret.addObject("isA6",DocMVCUtils.isOnlyA6()||DocMVCUtils.isOnlyA6S());//OA-74381  文档中心没有面包屑
        //G6
        boolean isG6 = DocMVCUtils.isGovVer()||DocMVCUtils.isG6Group();
        ret.addObject("isGovVer",isG6);
        ret.addObject("docCollectFlag",SystemProperties.getInstance().getProperty("doc.collectFlag"));
        ret.addObject("docRecommendFlag",SystemProperties.getInstance().getProperty("doc.recommendFlag"));
        ret.addObject("docOpenToZoneFlag",docOpenToZoneFlag);
        
        ret.addObject("v",request.getParameter("v"));
        ret.addObject("all",request.getParameter("all"));
        ret.addObject("edit",request.getParameter("edit"));
        ret.addObject("add",request.getParameter("add"));
        ret.addObject("readonly",request.getParameter("readonly"));
        ret.addObject("browse",request.getParameter("browse"));
        ret.addObject("list",request.getParameter("list"));
        ret.addObject("projectTypeId",request.getParameter("projectTypeId"));
        ret.addObject("docLibId",request.getParameter("docLibId"));
        ret.addObject("docLibType",request.getParameter("docLibType"));
        
        ret.addObject("isNewView",isNew);
        //不是个人，项目库，开启插件
        ret.addObject("isAllowArchivePigeonhole",(docLib.getType() != Constants.PERSONAL_LIB_TYPE && 
                SystemEnvironment.hasPlugin("archive") &&  docLib.getType() != Constants.PROJECT_LIB_TYPE && isOwner ));
        Pagination.setRowCount(rowCount);
        return ret.addObject("isOwner", isOwner).addObject("entranceType", entranceType);
    }
    
    
    /** 上侧树  
     * @throws BusinessException */
    public ModelAndView xmlTopJsp(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        response.setContentType("text/xml");
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();

        Long userId = AppContext.currentUserId();
        Long parentId = Long.valueOf(request.getParameter("resId"));
        Long frType = Long.valueOf(request.getParameter("frType"));
        String projectTypeId = request.getParameter("projectTypeId");
        DocResourcePO docRes = docHierarchyManager.getDocResourceById(parentId);

        // 对于资源是否存在的判断
        if (frType != Constants.PERSON_BORROW && frType != Constants.PERSON_SHARE
                && frType != Constants.DEPARTMENT_BORROW && docRes == null) {
            out.println("<exist>no</exist>");
            return null;
        }

        Long docLibId = null;
        DocLibPO docLib = null;
        Byte docLibType = null;

        if ((frType == Constants.PERSON_BORROW || frType == Constants.PERSON_SHARE
                || frType == Constants.DEPARTMENT_BORROW) 
                && !Constants.DOC_LIB_ROOT_ID_PROJECT.equals(parentId)) {
            docLib = this.docLibManager.getPersonalLibOfUser(userId);
            docLibId = docLib.getId();
            docLibType = Constants.PERSONAL_LIB_TYPE;
        } else {
            docLibId = docRes.getDocLibId();
            docLib = docLibManager.getDocLibById(docLibId);
            docLibType = docLib.getType();
        }

        boolean isShareAndBorrowRoot = BooleanUtils.toBoolean(request.getParameter("isShareAndBorrowRoot"));

        List<DocResourcePO> drs = null;
        if (docLib.isPersonalLib()) {
            drs = docHierarchyManager.findFolders(parentId, frType, userId, "", true,null);
        } else {
            String orgIds = Constants.getOrgIdsOfUser(userId);
            //项目虚拟目录查询
            if (DocMVCUtils.isProjectVirtualCategory(frType, docRes.getId(), docLib,projectTypeId)) {
                drs = docHierarchyManager.findFolders(parentId, Constants.FOLDER_PROJECT_ROOT, userId, orgIds, false,new ArrayList<Long>());
//                //根据项目类型Id查询所有项目id
//                List<ProjectBO> psList = projectApi.findProjectsByTypeIdAndMemberId(userId,Long.parseLong(projectTypeId));
//                List<Long> sourceIds = new ArrayList<Long>();//项目id
//                for (ProjectBO pSummary : psList) {
//                    sourceIds.add(pSummary.getId());
//                }
                List<Long> sourceIds = projectApi.findProjectIdsByMemberAndType(userId, Long.parseLong(projectTypeId));
                
                List<DocResourcePO> removeDocList = new ArrayList<DocResourcePO>();
                for (DocResourcePO doc : drs) {
                    if (doc.getSourceId() != null && !sourceIds.contains(doc.getSourceId())) {
                        ProjectBO ps = projectApi.getProject(doc.getSourceId());
                        if (!(ps.getProjectTypeId() + "").equals(projectTypeId)) {
                            removeDocList.add(doc);
                        }
                    }
                }
                if(!removeDocList.isEmpty()){//删除不是指定项目类别的
                    drs.removeAll(removeDocList);
                }
            } else {
                drs = docHierarchyManager.findFolders(parentId, frType, userId, orgIds, false,null);
            }
        }

        if (CollectionUtils.isEmpty(drs))
            return null;
        
        if (docRes != null) {
            //项目文档根据项目文档类别构建
            drs = DocMVCUtils.projectRootCategory(frType, docRes.getId(), docLib, drs, projectApi,orgManager);
        }
       

        List<DocTreeVO> folders = new ArrayList<DocTreeVO>();
        for (DocResourcePO doc : drs) {
            long type = doc.getFrType();
            // 我的计划判断
            if (type == Constants.FOLDER_PLAN || type == Constants.FOLDER_PLAN_DAY
                    || type == Constants.FOLDER_PLAN_MONTH || type == Constants.FOLDER_PLAN_WEEK
                    || type == Constants.FOLDER_PLAN_WORK) {
            	//文档中心屏蔽我的计划
                boolean hasPlan = false;
                if (!hasPlan)
                    continue;
            }

            boolean isShareAndBorrowRoot_ = isShareAndBorrowRoot;

            if (type == Constants.FOLDER_BORROW || type == Constants.FOLDER_SHAREOUT
                    || type == Constants.FOLDER_BORROWOUT || type == Constants.FOLDER_SHARE
                    || type == Constants.PERSON_BORROW || type == Constants.PERSON_SHARE
                    || type == Constants.DEPARTMENT_BORROW || type == Constants.FOLDER_TEMPLET
                    || type == Constants.FOLDER_PLAN || type == Constants.FOLDER_PLAN_DAY
                    || type == Constants.FOLDER_PLAN_MONTH || type == Constants.FOLDER_PLAN_WEEK
                    || type == Constants.FOLDER_PLAN_WORK)
                isShareAndBorrowRoot_ = true;

            DocTreeVO vo = new DocTreeVO(doc);
            vo.setDocLibType(docLibType);
            // 设置是否需要国际化标记
            DocMVCUtils.setNeedI18nInVo(vo);
            if (docLibType.byteValue() == Constants.PERSONAL_LIB_TYPE.byteValue())
                doc.setIsMyOwn(true);
            this.setGottenAclsInVO(vo, userId, isShareAndBorrowRoot_);
            if (type == Constants.PERSON_BORROW || type == Constants.PERSON_SHARE
                    || type == Constants.DEPARTMENT_BORROW || type == Constants.FOLDER_SHAREOUT
                    || type == Constants.FOLDER_BORROWOUT) {
                if (Constants.PROJECT_LIB_TYPE.equals(docLibType)) {
                    vo.setOpenIcon("folder_open.gif");
                    vo.setCloseIcon("folder_close.gif");
                }else{
                    vo.setOpenIcon(Constants.PERSON_ICON);
                    vo.setCloseIcon(Constants.PERSON_ICON);
                }
            } else {
                String srcIcon = docMimeTypeManager.getDocMimeTypeById(doc.getMimeTypeId()).getIcon();
                int index = srcIcon.indexOf('|');
                vo.setOpenIcon(srcIcon.substring( index + 1, srcIcon.length()));
                vo.setCloseIcon(srcIcon.substring(0, index==-1?srcIcon.length():index));
            }
            String v = null;
            if(vo.getDocLibType() == (byte)1) {
            	v = SecurityHelper.digest(doc.getId(),doc.getFrType(),docLibId,
                		vo.getDocLibType(),vo.getIsBorrowOrShare(),vo.isAllAcl(),vo.isEditAcl(),
            			vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl());
            } else {
            	Potent potent = docAclManager.getAclVO(doc.getId());
            	boolean all = false;
            	boolean edit = false;
            	boolean add = false;
            	boolean readonly = false;
            	boolean browse = false;
            	boolean list = false;
            	// 是否有权限进行计算
            	boolean isHasAcl = false;
            	if(potent != null) {
            		isHasAcl = true;
            		all = potent.isAll();
                	edit = potent.isEdit();
                	add = potent.isCreate();
                	readonly = potent.isReadOnly();
                	browse = potent.isRead();
                	list = potent.isList();
            	}
            	isShareAndBorrowRoot = vo.getIsBorrowOrShare();
            	if(Long.valueOf(40).equals(doc.getFrType())) {
            		isHasAcl = true;
            		isShareAndBorrowRoot = false;
            		all = edit = add = list = true;
            		readonly = browse = false;
            	}
            	if(Long.valueOf(110).equals(doc.getFrType()) 
            	        || Long.valueOf(111).equals(doc.getFrType())
            	        ||DocMVCUtils.isProjectVirtualCategory(doc.getFrType(), docRes.getId(), docLib, doc.getProjectTypeId()+"")) {
            		isShareAndBorrowRoot = false;
            		vo.setIsBorrowOrShare(isShareAndBorrowRoot);
            	}
            	if(isHasAcl) {
            		v = SecurityHelper.digest(doc.getId(),doc.getFrType(),docLibId,
                    		vo.getDocLibType(),isShareAndBorrowRoot,all,edit,add,readonly,browse,list);
            	} else {
            		v = SecurityHelper.digest(doc.getId(),doc.getFrType(),docLibId,
                    		vo.getDocLibType(),isShareAndBorrowRoot);
            	}
            	
            }            
            vo.setV(v);
            folders.add(vo);
        }

        out.println("<tree text=\"loaded\">");
        String xmlstr = DocMVCUtils.getXmlStr4LoadNodeOfCommonTopTree(docLibId, folders);
        out.println(xmlstr);
        out.println("</tree>");
        out.close();
        return null;
    }
    // 客开 END

    /** 弹出重命名文档夹、文档窗口  */
    public ModelAndView reName(HttpServletRequest request, HttpServletResponse response) {
        Long docResId = NumberUtils.toLong(request.getParameter("rowid"));
        DocResourcePO dr = docHierarchyManager.getDocResourceById(docResId);
        parseFrNameSuffix(dr.getFrName(), request);
        this.docHierarchyManager.lockWhenAct(docResId, AppContext.currentUserId());
        return new ModelAndView("apps/doc/reName", "dr", dr);
    }
    
    /**
     * 将后缀名去掉，只保留需要命名的前缀部分
     * @param frName
     * @param request
     */
    private void parseFrNameSuffix(String frName, HttpServletRequest request) {
        //docSuffix来源于doc_mime_types
        final String[] docSuffix = { ".doc", ".swf", ".docx", ".xls", ".xlsx", ".pdf", ".ppt", ".pptx", ".txt", ".bmp", ".html", ".htm", ".gif", ".mpg", ".pcx", ".png", ".rm", ".tga", ".tif", ".zip", ".jpg", ".jpeg", ".rar", ".et", ".wps", ".exe", ".gz",
                ".z", ".rtf", ".wav", ".aif", ".au", ".mp3", ".bak", ".bin", ".iso" };
        int lastIndex = frName.lastIndexOf('.');
        if (lastIndex != -1) {  
            String suffix = frName.substring(lastIndex);
            if (Arrays.asList(docSuffix).contains(suffix)) {
                request.setAttribute("docPrefix", frName.substring(0, lastIndex));
                request.setAttribute("docSuffix", suffix);
                return;
            }
        }
        request.setAttribute("docPrefix", frName);
        request.setAttribute("docSuffix", "");
    }

    /** 重命名文档夹、文档  
     * @throws BusinessException */
    public ModelAndView rename(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        Long userId = AppContext.currentUserId();
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        String sisFolder = request.getParameter("isFolder");
        String docSuffix = request.getParameter("docSuffix");
        String from = request.getParameter("from");
        DocResourcePO newFolder = docHierarchyManager.getDocResourceById(docResId);
        Boolean flag = (Boolean) (BrowserFlag.OpenWindow.getFlag(AppContext.getCurrentUser()));

        // 对于资源是否存在的判断
        if (newFolder == null) {
            String alertMsgKey = "true".equals(sisFolder) ? "doc_alert_source_deleted_folder"
                    : "doc_alert_source_deleted_doc";
            super.rendJavaScript(response, "alert(top.v3x.getMessage('DocLang." + alertMsgKey + "'));"
                    + "window.dialogArguments.parent.parent.location.reload(true);" + "parent.close();");
            return null;
        }

        boolean isfolder = newFolder.getIsFolder();
        String newName = request.getParameter("newName") + docSuffix;
        String oldName = newFolder.getFrName();
        if (newName.equals(oldName)) {//相等不更新
            String js ="parent.parent.winRename.close();";
            if(flag){
                js ="parent.close();"; 
            }
            super.rendJavaScript(response, js);
            return null;
        }
        // 记录操作日志
        operationlogManager.insertOplog(docResId, newFolder.getParentFrId(), ApplicationCategoryEnum.doc,
                isfolder ? ActionType.LOG_DOC_RENAME_FOLDER : ActionType.LOG_DOC_RENAME_DOCUMENT,
                isfolder ? ActionType.LOG_DOC_RENAME_FOLDER + ".desc" : ActionType.LOG_DOC_RENAME_DOCUMENT + ".desc",
                AppContext.currentUserName(), oldName, newName);

        docHierarchyManager.renameDocWithoutAcl(docResId, newName, userId);
        //触发修改事件
        DocUpdateEvent docUpdateEvent = new DocUpdateEvent(this);
        docUpdateEvent.setDocResourceBO(DocMgrUtils.docResourcePOToBO(newFolder));
        EventDispatcher.fireEvent(docUpdateEvent);
        
        //更新名称
        newFolder.setFrName(newName);

        if (!newFolder.getIsFolder()) {
            // 更新订阅文档
            docAlertLatestManager.addAlertLatest(newFolder, Constants.ALERT_OPR_TYPE_EDIT, userId,
                    new Date(System.currentTimeMillis()), Constants.DOC_MESSAGE_ALERT_MODIFY_RENAME_DOC, oldName);
            this.updateIndex(docResId);

            docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(),
                    DocActionEnum.reName.key(), docResId, "rename");

        } else {
            docAlertLatestManager.addAlertLatest(newFolder, Constants.ALERT_OPR_TYPE_EDIT, userId,
                    new Date(System.currentTimeMillis()), Constants.DOC_MESSAGE_ALERT_MODIFY_RENAME_FOLDER, oldName);
        }
        
        if (flag) {
            super.rendJavaScript(response, "var rv = [\"" + docResId + "\",\"" + newName + "\"];"
                    + "parent.window.returnValue = rv;" + "parent.close();");
        } else {//非window方式弹出
            String js = "var rv = [\"" + docResId + "\",\"" + newName + "\"];";
            if ("true".equals(sisFolder)) {
                js += "var obj = parent.parent.parent.treeFrame;"
                        + "if (obj.webFXTreeHandler.getIdByBusinessId(rv[0]) != undefined) {"
                        + "obj.webFXTreeHandler.all[obj.webFXTreeHandler.getIdByBusinessId(rv[0])].setText(rv[1]);"
                        + "}";
            }
            if(Strings.isNotEmpty(from)){
            	js += "parent.parent.winRename.close();";
            }else{
            	js += "parent.parent.window.location.reload(true);parent.parent.winRename.close();";
            }
            super.rendJavaScript(response, js);
        }
        return null;
    }

    /** 新建文档夹 
     * @throws BusinessException */
    public ModelAndView createFolder(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        return this.createFolder(request, response, false);
    }

    /**
     * 将创建普通文档夹和公文档案夹的代码进行合并，避免大段重复代码出现
     * @param isEdocFolder	是否创建公文档案夹
     * @throws BusinessException 
     */
    private ModelAndView createFolder(HttpServletRequest request, HttpServletResponse response, boolean isEdocFolder)
            throws IOException, BusinessException {
        Long newId = null;
        try {
            String name = request.getParameter("title");
            Long userId = AppContext.currentUserId();
            Long parentId = NumberUtils.toLong(request.getParameter("parentId"));

            DocResourcePO parent = docHierarchyManager.getDocResourceById(parentId);
            String key = null;
            if (parent == null) {
                key = "doc_alert_source_deleted_folder";
            } else if (this.docHierarchyManager.deeperThanLimit(parent)) {
                key = "doc_alert_level_too_deep";
            }

            if (key != null) {
                super.rendJavaScript(response,
                        "parent.closeAndRefresh('" + key + "', '" + this.docHierarchyManager.getFolderLevelLimit()
                                + "');");
                return null;
            }

            DocResourcePO dr = null;
            if (isEdocFolder) {
                if (docHierarchyManager.hasSameNameAndSameTypeDr(parentId, name, Constants.FOLDER_EDOC))
                    throw new BusinessException("doc_upload_dupli_name_failure_alert");

                boolean parentCommentEnabled = BooleanUtils.toBoolean(request.getParameter("parentCommentEnabled"));
                boolean parentRecommendEnable = BooleanUtils.toBoolean(request.getParameter("parentRecommendEnable"));
                Long docLibId = NumberUtils.toLong(request.getParameter("docLibId"));
                dr = docHierarchyManager.createFolderByTypeWithoutAcl(name, Constants.FOLDER_EDOC, docLibId, parentId,
                        userId, false, parentCommentEnabled, parentRecommendEnable);
                newId = dr.getId();
                // 扩展元数据
                this.handleMetadata(request, newId, true);
            } else {
                boolean parentVersionEnabled = BooleanUtils.toBoolean(request.getParameter("parentVersionEnabled"));
                boolean parentCommentEnabled = BooleanUtils.toBoolean(request.getParameter("parentCommentEnabled"));
                boolean parentRecommendEnable = BooleanUtils.toBoolean(request.getParameter("parentRecommendEnable"));
                dr = docHierarchyManager.createCommonFolderWithoutAcl(name, parentId, userId, parentVersionEnabled,
                        parentCommentEnabled, parentRecommendEnable);
                newId = dr.getId();
            }
			// 记录操作日志
			operationlogManager.insertOplog(newId, parentId,
					ApplicationCategoryEnum.doc, ActionType.LOG_DOC_ADD_FOLDER,
					ActionType.LOG_DOC_ADD_FOLDER + ".desc",
					AppContext.currentUserName(), name);

            // 更新订阅文档
            docAlertLatestManager.addAlertLatest(dr, Constants.ALERT_OPR_TYPE_ADD, userId,
                    new Date(System.currentTimeMillis()), Constants.DOC_MESSAGE_ALERT_ADD_FOLDER, null);

            if (!isEdocFolder) {
                //获取文档库管理员id
                Map<Long,List<Long>> lib2OwnerMap = docLibManager.getDocLibOwnersByIds(CommonTools.newArrayList(parent.getDocLibId()));
                List<Long> libOwenrIds = lib2OwnerMap.get(parent.getDocLibId());
                libOwenrIds.add(userId);//增加自己对当前文档夹的订阅，包括自己是管理员的情况
                List<DocAlertPO> alerts = docAlertManager.findPersonalAlertByDrId(parentId,libOwenrIds);
                //已经增加过的userId
                List<Long> alertOwenrIds = new ArrayList<Long>();
                if (CollectionUtils.isNotEmpty(alerts)) {
                    for (DocAlertPO alert : alerts) {
                        byte type = alert.getChangeType();
                        Long alertUserId = alert.getAlertUserId();
                        
                        if (type == 0 && alertOwenrIds.contains(alertUserId)){
                            continue;
                        }
                        
                        docAlertManager.addAlert(newId, true,type,V3xOrgEntity.ORGENT_TYPE_MEMBER, alertUserId, 
                                alertUserId, alert.getSendMessage(),
                                alert.getSetSubFolder(), true);
                        
                        if(type == 0){
                            alertOwenrIds.add(alertUserId);  
                        }
                       
                    }
                }
            }

            super.rendJavaScript(response, "parent.afterCreateFolder('" + parentId + "');");
        } catch (BusinessException e) {
            super.rendJavaScript(response,
                    "parent.enableButtonsAndAlertMsg('" + e.getMessage() + "','" + request.getParameter("title")
                            + "');");
        }
        if (request.getParameter("personalShare") != null) {
            request.setAttribute("returnString", "{'id':'" + newId + "'}");
            return new ModelAndView("apps/doc/personal/value");
        }
        return null;
    }

    public ModelAndView createFolderByPersonal(HttpServletRequest request, HttpServletResponse response)
            throws IOException, BusinessException {
        try {
            String name = request.getParameter("title");
            name = URLDecoder.decode(name, "utf-8");
            Long userId = AppContext.currentUserId();
            Long parentId = NumberUtils.toLong(request.getParameter("parentId"));
            boolean parentVersionEnabled = BooleanUtils.toBoolean(request.getParameter("parentVersionEnabled"));
            boolean parentCommentEnabled = BooleanUtils.toBoolean(request.getParameter("parentCommentEnabled"));
            boolean parentRecommendEnable = BooleanUtils.toBoolean(request.getParameter("parentCommentEnabled"));
            String docLibType = request.getParameter("docLibType");
            boolean isPersonalLib = String.valueOf(Constants.PERSONAL_LIB_TYPE).equals(docLibType);

            DocResourcePO parent = docHierarchyManager.getDocResourceById(parentId);
            if (parent == null) {
                return buildReturnData(ResourceUtil.getString("doc.forder.noexist"), null, request);
            } else if (this.docHierarchyManager.deeperThanLimit(parent)) {
                return buildReturnData(ResourceUtil.getString("doc.alert.level.too.deep"), null, request);
            } else if (docHierarchyManager.hasSameNameAndSameTypeDr(parentId, name, Constants.FOLDER_COMMON)) {
                return buildReturnData(ResourceUtil.getString("doc.folder.name.is.same"), null, request);
            }

            DocResourcePO dr = docHierarchyManager.createCommonFolderWithoutAcl(name, parentId, userId,
                    parentVersionEnabled, parentCommentEnabled, parentRecommendEnable);
            if (!isPersonalLib) { // 记录操作日志
                operationlogManager.insertOplog(dr.getId(), parentId, ApplicationCategoryEnum.doc,
                        ActionType.LOG_DOC_ADD_FOLDER, ActionType.LOG_DOC_ADD_FOLDER + ".desc",
                        AppContext.currentUserName(), name);
            }
            // 更新订阅文档
            docAlertLatestManager.addAlertLatest(dr, Constants.ALERT_OPR_TYPE_ADD, userId,
                    new Date(System.currentTimeMillis()), Constants.DOC_MESSAGE_ALERT_ADD_FOLDER, null);

            List<DocAlertPO> alerts = docAlertManager.findPersonalAlertByDrIdOfCurrentUser(parentId);
            if (CollectionUtils.isNotEmpty(alerts)) {
                for (DocAlertPO alert : alerts) {
                    byte type = alert.getChangeType();
                    docAlertManager.addAlert(dr.getId(), true, type == 0 ? Constants.ALERT_OPR_TYPE_ALL : type,
                            V3xOrgEntity.ORGENT_TYPE_MEMBER, userId, userId, alert.getSendMessage(),
                            alert.getSetSubFolder(), false);
                    if (type == 0)
                        break;
                }
            }
            return buildReturnData(ResourceUtil.getString("doc.document.clip.create.success"),
                    Strings.escapeJavascript(JSONUtil.toJSONString(dr)), request);
        } catch (BusinessException e) {
            log.error("", e);
        }
        return buildReturnData(ResourceUtil.getString("doc.document.clip.create.fial"), null, request);
    }

    private ModelAndView buildReturnData(String msg, String data, HttpServletRequest request) {
        StringBuilder returnVal = new StringBuilder();
        returnVal.append("{'msg':'").append(msg).append("','data':'").append(data);
        returnVal.append("'}");
        request.setAttribute("returnString", returnVal.toString());
        return new ModelAndView("apps/doc/personal/value");
    }

    /** 弹出新建公文档案夹窗口    */
    public ModelAndView createEdocFolder(HttpServletRequest request, HttpServletResponse response) {
        String html = htmlUtil.getNewHtml(Constants.FOLDER_EDOC);
        return new ModelAndView("apps/doc/createEdocFolder", "propHtml", html);
    }

    /** 新建公文档案夹 
     * @throws BusinessException */
    public ModelAndView doCreateEdocFolder(HttpServletRequest request, HttpServletResponse response)
            throws IOException, BusinessException {
        return this.createFolder(request, response, true);
    }

    /**
     * 文档创建或修改后，处理对应的元数据
     * @param docResId		创建后的文档ID
     * @param isNew		是否新建（或修改）
     */
    @SuppressWarnings("unchecked")
    private void handleMetadata(HttpServletRequest request, Long docResId, boolean isNew) {
        Map paramMap = request.getParameterMap();
        handleMetadata(paramMap, docResId, isNew);
    }
    
    private void handleMetadata(Map paramMap, Long docResId, boolean isNew) {
        Map<String, Comparable> paramap = this.getMetadataInfo(paramMap);
        if (!paramap.isEmpty()) {
            if (isNew)
                docMetadataManager.addMetadata(docResId, paramap);
            else
                docMetadataManager.updateMetadata(docResId, paramap);
        }
    }

    /** 处理、获取元数据信息键值Map */
    @SuppressWarnings("unchecked")
    private Map<String, Comparable> getMetadataInfo(HttpServletRequest request) {
        return getMetadataInfo(request.getParameterMap());
    }

    private Map<String, Comparable> getMetadataInfo(Map paramMap) {
        Map<String, Comparable> paramap = new HashMap<String, Comparable>();
        Map<String, String[]> srcParaMap = new HashMap<String, String[]>(paramMap);
        for (Iterator<Entry<String, String[]>> iter = srcParaMap.entrySet().iterator(); iter.hasNext();) {
            Entry<String, String[]> entry = iter.next();
            String sname = entry.getKey();
            if (this.needHandleMetadata(sname)) {
                Object ovalue=entry.getValue();
                String[] values=null;
                if(ovalue instanceof String){
                    values=new String[]{(String)ovalue};
                }else{
                    values = (String[])ovalue;
                }
                this.addMetadataKV(paramap, sname, values);
            }
        }
        return paramap;
    }

    /** 对元数据信息进行处理并放入键值Map中 */
    @SuppressWarnings("unchecked")
    private void addMetadataKV(Map paramap, String sname, String[] values) {
        if (values.length == 1) {
            try {
                paramap.put(sname, Constants.getTrueTypeValue(sname, values[0]));
            } catch (ParseException e) {
                log.error("扩展元数据类型转换过程中出现异常：", e);
            }
        } else {
            paramap.put(sname, StringUtils.join(values, ','));
        }
    }

    /**
     * 判定是否需要进行元数据处理
     * @param sname
     */
    private boolean needHandleMetadata(String sname) {
        return sname.startsWith("avarchar") || sname.startsWith("integer") || sname.startsWith("decimal")
                || sname.startsWith("date") || sname.startsWith("text") || sname.startsWith("boolean")
                || sname.startsWith("reference") || sname.startsWith("enum");
    }

    /**
     * 批量下载：文件
     * @throws BusinessException 
     */
    public ModelAndView checkFile(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        String userId = request.getParameter("userId");
        String docId = request.getParameter("docId");
        String isBorrow = request.getParameter("isBorrow");

        if (Strings.isBlank(userId) || !userId.equals(String.valueOf(AppContext.currentUserId()))) {
            PrintWriter out = response.getWriter();
            out.print("1");
            out.close();
            return null;
        }

        DocResourcePO docr = null;
        if (Strings.isNotBlank(docId)) {
            docr = docHierarchyManager.getDocResourceById(Long.valueOf(docId));
        }
        if (docr == null) {
            PrintWriter out = response.getWriter();
            out.print("2");
            out.close();
            return null;
        }

        if ("true".equals(isBorrow)) {
            boolean canDownload = false;
            String lentpotent = docAclManager.getBorrowPotent(docr.getId());
            if (lentpotent != null && "1".equals(lentpotent.substring(0, 1))) {
                canDownload = true;
            }
            if (!canDownload) {
                PrintWriter out = response.getWriter();
                out.print("3");
                out.close();
                return null;
            }
        }

        // 有权限
        String result = null;
        DocMimeTypePO mime = docMimeTypeManager.getDocMimeTypeById(docr.getMimeTypeId());
        String context = SystemEnvironment.getContextPath();
        if (mime.getFormatType() == Constants.FORMAT_TYPE_DOC_FILE) {
            String vForDocDownload = request.getParameter("v");
        	V3XFile vf = fileManager.getV3XFile(docr.getSourceId());
            result = "0#" + context + "/fileDownload.do?method=doDownload&viewMode=download&fileId=" + docr.getSourceId()
                    + "&filename=" + docr.getFrName().replaceAll(" ", "&nbsp;") + "&createDate=" + Datetimes.formatDate(vf.getCreateDate())+"&v="+vForDocDownload;
//                    +"&v="+ vf==null?"":vf.getV();
        } else {
            result = "0#" + context + "/doc.do?method=docDownloadNew4Multi&id=" + docr.getId();
        }

        docHierarchyManager.recoidopertionLog(String.valueOf(docr.getId()), "downLoadFile");
        PrintWriter out = response.getWriter();
        out.print(result);
        out.close();
        return null;
    }

    /**
     * 批量下载：文件夹
     * @throws BusinessException 
     * @throws NumberFormatException 
     */
    @SetContentType
    public ModelAndView getFilesFromFolder(HttpServletRequest request, HttpServletResponse response)
            throws IOException, NumberFormatException, BusinessException {
        response.setContentType("text/plain;charset=UTF-8");
        String userId = request.getParameter("userId");
        String folderId = request.getParameter("folderId");

        if (Strings.isBlank(userId) || !userId.equals(String.valueOf(AppContext.currentUserId()))) {
            PrintWriter out = response.getWriter();
            out.print("1");
            out.close();
            return null;
        }

        DocResourcePO doc1 = null;
        if (Strings.isNotBlank(folderId)) {
            doc1 = docHierarchyManager.getDocResourceById(Long.valueOf(folderId));
        }
        if (doc1 == null) {
            PrintWriter out = response.getWriter();
            out.print("2");
            out.close();
            return null;
        }

        boolean justHasAddPotent = false;
        DocLibPO lib = docLibManager.getDocLibById(doc1.getDocLibId());
        if (lib == null || lib.getType() != Constants.PERSONAL_LIB_TYPE) {
            String orgIds = Constants.getOrgIdsOfUser(Long.parseLong(userId));
            Set<Integer> sets = this.docAclManager.getDocResourceAclList(doc1, orgIds);
            boolean canDownload = sets.contains(Constants.ALLPOTENT) || sets.contains(Constants.EDITPOTENT)
                    || sets.contains(Constants.READONLYPOTENT) || sets.contains(Constants.ADDPOTENT);
            justHasAddPotent = ((sets.size() == 1 && sets.iterator().next() == Constants.ADDPOTENT) || (sets.size() == 2
                            && sets.contains(Constants.ADDPOTENT) && sets.contains(Constants.NOPOTENT)));
            if (!canDownload) {
                PrintWriter out = response.getWriter();
                out.print("3");
                out.close();
                return null;
            }
        }

        StringBuilder result = new StringBuilder();
        result.append("0#");
        Long userIdLong = Long.valueOf(userId);
        String aclIds = Constants.getOrgIdsOfUser(userIdLong);
        List<DocResourcePO> ret0 = docAclManager.findNextNodeOfTablePageByDate(false,doc1, aclIds, -1, -1);
        //循环下载文档夹下所有能下载的文档
        List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
        findNextNodeHasAclAllDoc(ret,ret0,aclIds);
        
        String context = SystemEnvironment.getContextPath();
        for (int i = 0; i < ret.size(); i++) {
            DocResourcePO dr = ret.get(i);
            // 映射文件不能下载，或者只有写入权限时只能下载自己新建的文档
            if (dr.getIsFolder() || Constants.isPigeonhole(dr) || dr.getFrType() == Constants.LINK
                    || dr.getFrType() == Constants.LINK_FOLDER
                    || (justHasAddPotent && !dr.getCreateUserId().equals(userIdLong))) {
                continue;
            }

            String frSize = (float) (Math.round((float) dr.getFrSize() / 1024 * 100)) / 100 + "";
            String frName = dr.getFrName();
            if (dr.getSourceId() == null) { // 复合文档
                frName += ".zip";
            }

            String url = null;
            if (dr.getSourceId() != null) {
            	String vForDocDownload = SecurityHelper.digest(dr.getSourceId());
                url = context + "/fileDownload.do?method=doDownload&viewMode=download&fileId=" + dr.getSourceId()
                        + "&filename=" + frName.replaceAll(" ", "&nbsp;") + "&createDate=" + Datetimes.formatDate(dr.getCreateTime())+"&v="+vForDocDownload;
            } else {
                url = context + "/doc.do?method=docDownloadNew4Multi&id=" + dr.getId();
            }
            docHierarchyManager.recoidopertionLog(String.valueOf(dr.getSourceId()), "downLoadFile");

            StringBuilder s = new StringBuilder();
            s.append("<file>" + "<userid>" + userId + "</userid>" + "<size>" + frSize + "</size>" + "<filename>"
                    + Strings.toXmlStr(frName) + "</filename>" + "<url>" + Strings.toXmlStr(url) + "</url>" + "</file>");

            byte[] bs = s.toString().getBytes("UTF-8");
            result.append(bs.length);
            result.append(s);
        }
        PrintWriter out = response.getWriter();
        out.print(result);
        out.close();
        return null;
    }
    
    /**
     * 查找当前目录下的所有有权限的文档
     */
    private void findNextNodeHasAclAllDoc(List<DocResourcePO> ret2, List<DocResourcePO> srcDocs,String aclIds) {
        if (!srcDocs.isEmpty()) {
            for (DocResourcePO doc : srcDocs) {
                if (doc.getIsFolder()) {
                    List<DocResourcePO> ret = docAclManager.findNextNodeOfTablePageByDate(false,doc, aclIds, -1, -1);
                    findNextNodeHasAclAllDoc(ret2, ret,aclIds);
                } else {
                    ret2.add(doc);
                }
            }
        }
    }

    /**
     * 下载文档、文档夹
     */
    public ModelAndView downloadFile(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        Long userId = AppContext.currentUserId();
        String[] drIds = request.getParameterValues("id");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        for (int i = 0; i < drIds.length; i++) {
            Map<String, Object> map = new HashMap<String, Object>();
            Long did = Long.valueOf(drIds[i]);
            DocResourcePO dr = docHierarchyManager.getDocResourceById(did);

            // 存在性驗證
            if (dr == null)
                continue;
            String[] msg_status = this.docHierarchyManager.getLockMsgAndStatus(dr, userId);
            if (!Constants.LOCK_MSG_NONE.equals(msg_status[0])
                    && !String.valueOf(LockStatus.None.key()).equals(msg_status[1])) {
                out.println("alert('" + msg_status[0] + Constants.getDocI18nValue("doc.lockstatus.msg.wontdelete")
                        + "');");
                continue;
            }
            map.put("did", did);
            map.put("Name", dr.getFrName());
            map.put("Size", dr.getFrSize());
            list.add(map);
            docHierarchyManager.recoidopertionLog(String.valueOf(dr.getSourceId()), "downLoadFile");
        }
        ModelAndView mav = new ModelAndView(request.getParameter("url"));
        mav.addObject("param", list);

        return mav;

    }

    /**
     * 删除文档、文档夹
     * @throws BusinessException 
     */
    public ModelAndView delete(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        Long userId = AppContext.currentUserId();
        
        String[] drIds = {};
        String[] isNewView = request.getParameterValues("isNewView");
		if (isNewView.length > 0 && Boolean.parseBoolean(isNewView[0])){
        	drIds = request.getParameterValues("newCheckBox");
        }else{
        	drIds = request.getParameterValues("id");
        }
        
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        boolean isFolder = false;
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        //过滤重复ID form提交里含有id，删除的location中含有id
        Set<Long> ids = new HashSet<Long>();
        String fname = "";
        
        Map<Long,DocResourcePO> id2DocMap = new HashMap<Long,DocResourcePO>();
        if (drIds.length > 0) {
            List<String> docIds = Arrays.asList(drIds);
            String sdocId = docIds.toString().substring(1, docIds.toString().length() - 1);
            List<DocResourcePO> docList = docHierarchyManager.getDocsByIds(sdocId);
            for (DocResourcePO doc : docList) {
                Potent potent = docAclManager.getAclVO(doc);
                if (!potent.isAll()) {
                    fname += doc.getFrName() + ",";
                }
                ids.add(doc.getId());
                id2DocMap.put(doc.getId(), doc);
            }
        }
        
        if (Strings.isNotBlank(fname)) {
            out.println("alert(parent.v3x.getMessage('DocLang.doc_no_acl_to_delete_cur','" + fname.toString().substring(0, fname.length() - 1) + "'));");
            out.println("</script>");
            return null;
        }
        
        boolean isNotPersonalLib = !docLibType.equals(Constants.PERSONAL_LIB_TYPE);
        Iterator<Long> it = ids.iterator();
        while (it.hasNext()) {
            Long did = it.next();
            DocResourcePO dr = id2DocMap.get(did);
            // 存在性驗證
            if (dr == null){
                continue; 
            }
            isFolder = dr.getIsFolder();
            
            String[] msg_status = this.docHierarchyManager.getLockMsgAndStatus(dr, userId);
            if (!Constants.LOCK_MSG_NONE.equals(msg_status[0])
                    && !String.valueOf(LockStatus.None.key()).equals(msg_status[1])) {
                out.println("alert('" + msg_status[0] + Constants.getDocI18nValue("doc.lockstatus.msg.wontdelete")
                        + "');");
                continue;
            }

            // 更新订阅文档
            if (!isFolder) {
                docAlertLatestManager.addAlertLatest(dr, Constants.ALERT_OPR_TYPE_DELETE, userId,
                        new Date(System.currentTimeMillis()), Constants.DOC_MESSAGE_ALERT_DELETE_DOC, null);
            } else {
                if (isNotPersonalLib) {
                    String names = docAclManager.hasAclToDeleteAll(dr, userId);
                    if (Strings.isNotBlank(names)) {
                        out.println("alert(parent.v3x.getMessage('DocLang.doc_no_acl_to_delete','"
                                + names.toString().substring(0, names.length() - 1) + "'));");
                        out.println("</script>");
                        return null;
                    }
                }
                docAlertLatestManager.addAlertLatest(dr, Constants.ALERT_OPR_TYPE_DELETE, userId,
                        new Date(System.currentTimeMillis()), Constants.DOC_MESSAGE_ALERT_DELETE_FOLDER, null);
            }

            long parentFrId = dr.getParentFrId();
            String frName = dr.getFrName();
            try {
                // 公文归档删除，对公文进行操作！公文类型的判断  事件通知
                if (dr.getFrType() == Constants.SYSTEM_ARCHIVES) {
                    DocDeleteEvent event = new DocDeleteEvent(this);
                    event.setAppKey(ApplicationCategoryEnum.edoc.getKey());
                    event.setSourcesID(dr.getSourceId());
                    EventDispatcher.fireEvent(event);
                }
                docHierarchyManager.removeDocWithoutAcl(dr, userId, true);
                //删除映射收藏的痕迹
                if(dr.getFrType() == Constants.LINK && dr.getSourceType() != null && dr.getSourceType()==3){
                    //删除操作痕迹
                    docActionManager.deleteDocActionBySubject(dr.getFavoriteSource(), DocActionEnum.collect.key());
                }
            } catch (BusinessException e) {
                log.error("删除文档[id=" + did + "]时出现异常：", e);
            }
            docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(),
                    DocActionEnum.delete.key(), dr.getId(), "delete");
			// 记录操作日志
			operationlogManager.insertOplog(did, parentFrId,
					ApplicationCategoryEnum.doc,
					isFolder ? ActionType.LOG_DOC_REMOVE_FOLDER
							: ActionType.LOG_DOC_REMOVE_DOCUMENT,
					isFolder ? ActionType.LOG_DOC_REMOVE_FOLDER + ".desc"
							: ActionType.LOG_DOC_REMOVE_DOCUMENT + ".desc",
					AppContext.currentUserName(), frName);
			//保存应用日志
	        appLogManager.insertLog(AppContext.getCurrentUser(),AppLogAction.Doc_Wd_Del,AppContext.currentUserName(),dr.getFrName());

            if (isFolder) {
                out.println("parent.removeTreeNode('" + did + "');");
            }
        }
        out.println("parent.window.location.href=parent.window.location;");
        out.println("</script>");
        return null;
    }

    /** 
     * 移动文档、文档夹 
     */
    public ModelAndView move(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        response.setContentType("text/html;charset=UTF-8");
        Long userId = AppContext.currentUserId();
        String[] drIds = request.getParameterValues("id");
        Long srcLibId = Long.valueOf(request.getParameter("srcLibId")); // 源文档库id
        Long destId = Long.valueOf(request.getParameter("destResId")); // 目标文档夹id
        Long destLibId = Long.valueOf(request.getParameter("destLibId")); // 目标库id
        String sdestType = request.getParameter("destLibType");
        String destName = request.getParameter("destName");
        destName = URLDecoder.decode(URLDecoder.decode(destName, "utf-8"),"utf-8");
        boolean commentEnabled = BooleanUtils.toBoolean(request.getParameter("commentEnabled"));
        byte destLibType = Strings.isNotBlank(sdestType) ? Byte.valueOf(sdestType) : Constants.PERSONAL_LIB_TYPE;
        PrintWriter out = response.getWriter();
        out.println("<script type=\"text/javascript\">"); 
        boolean isFolder = false;
        boolean folderMoved = false;
        DocResourcePO destFolder = this.docHierarchyManager.getDocResourceById(destId);
        //权限验证
        DocTreeVO vo = new DocTreeVO(destFolder);
        DocMVCUtils.setGottenAclsInVO(vo, userId, false, docAclManager);
        boolean destPersonal = destLibType == Constants.PERSONAL_LIB_TYPE.byteValue();
        if (!destPersonal && !vo.isAllAcl() && !vo.isEditAcl() && !vo.isAddAcl()) {
            out.println("alert(parent.parent.v3x.getMessage('DocLang.doc_move_dest_no_acl_failure_alert'));");
            out.println("</script>");
            return null;
        }
        int destFolderLevelDepth = destFolder.getLevelDepth();
        try {
            Date currentTime = new Date();
            boolean destFolderVersion = destFolder.isVersionEnabled();
            boolean destFolderRecommendEnable = destFolder.getRecommendEnable();
            for (int i = 0; i < drIds.length; i++) {
                Long oprId = Long.valueOf(drIds[i]);
                DocResourcePO oprDr = docHierarchyManager.getDocResourceById(oprId);
                if (oprDr == null) {
                    continue;
                }
                if (oprDr.getParentFrId() == destId.longValue()) {
                    throw new BusinessException("doc_alert_choose_different_dest");
                }
                isFolder = oprDr.getIsFolder();
                if (isFolder && this.docHierarchyManager.deeperThanLimit(destFolder)) {
                    throw new BusinessException("doc_alert_level_too_deep");
                }
                // 移动时先进行锁校验，暂只对选中的文档进行处理(文档夹下面的文档遍历处理代价较高)
                if (!isFolder) {
                    String[] ret = this.docHierarchyManager.getLockMsgAndStatus(oprDr, userId);
                    if (!Constants.LOCK_MSG_NONE.equals(ret[0])
                            && NumberUtils.toInt(ret[1]) != Constants.LockStatus.None.key()) {
                        out.println("parent.handleConcurrencyWhenMoveDocs('doc_alert_cannot_move', '"
                                + Strings.escapeJavascript(ret[0]) + "');");
                        out.println("</script>");
                        out.close();
                        return null;
                    }
                    //历史版本信息的变更（原文件无版本控制，目标文档夹有版本控制时 需要更改原文件的版本控制信息 ）
                    if (destFolderVersion && !oprDr.isVersionEnabled()) {
                        oprDr.setVersionEnabled(true);
                    }
                }
                DocResourcePO oldParent = docHierarchyManager.getDocResourceById(oprDr.getParentFrId());
                String oprName = oprDr.getFrName();
                long oprParentId = oprDr.getParentFrId();
                docHierarchyManager.moveDocWithoutAcl(oprDr, srcLibId, destLibId, destId, userId, destPersonal,
                        commentEnabled, destFolderRecommendEnable, destFolderLevelDepth);
                String oldParentName = Constants.getDocI18nValue(oldParent.getFrName());

                // 更新订阅文档
                docAlertLatestManager.addAlertLatest(oprDr, Constants.ALERT_OPR_TYPE_DELETE, userId, currentTime,
                        isFolder ? Constants.DOC_MESSAGE_ALERT_MOVE_FOLDER : Constants.DOC_MESSAGE_ALERT_MOVE_DOC,
                        oldParentName);

                // 移动完成之后，应该删除对被移动对象的订阅：删除订阅、删除最新订阅
                docAlertManager.deleteAlertByDocResourceId(oprDr);
                docAlertLatestManager.deleteAlertLatestsByDoc(oprDr);

                // 更新订阅文档
                docAlertLatestManager.addAlertLatest(oprDr, Constants.ALERT_OPR_TYPE_ADD, userId, currentTime,
                        isFolder ? Constants.DOC_MESSAGE_ALERT_ADD_FOLDER_1 : Constants.DOC_MESSAGE_ALERT_ADD_DOC_1,
                        destName);

                if (isFolder) {
                    folderMoved = true;
                    if ((Boolean) BrowserFlag.OpenWindow.getFlag(request)) {
                    	out.println("parent.refreshTreeAfterFolderMoved('" + drIds[i] + "');");
                    } else {                  	
                    	out.println("top.reFlesh();");
                    }

                    //历史版本信息的变更（原文件夹无版本控制，目标文档夹有版本控制时 需要更改原文件夹及其下的文档（夹）的版本控制信息 ）
                    if (destFolderVersion && !oprDr.isVersionEnabled()) {
                        docHierarchyManager.setFolderVersionEnabled(oprDr, true, 3, userId);
                    }
                }

                String moveAction = isFolder ? ActionType.LOG_DOC_MOVE_FOLDER_OUT
                        : ActionType.LOG_DOC_MOVE_DOCUMENT_OUT;
                operationlogManager.insertOplog(oprId, oprParentId, ApplicationCategoryEnum.doc, moveAction, moveAction
                        + ".desc", AppContext.currentUserName(), ResourceUtil.getString(oprName), oldParentName);

                moveAction = isFolder ? ActionType.LOG_DOC_MOVE_FOLDER_IN : ActionType.LOG_DOC_MOVE_DOCUMENT_IN;
                operationlogManager.insertOplog(oprId, destId, ApplicationCategoryEnum.doc, moveAction, moveAction
                        + ".desc", AppContext.currentUserName(), ResourceUtil.getString(oprName), destName);

                // 更新全文检索
                if (isFolder) {
                    if (AppContext.hasPlugin("index")) {
                        List<DocResourcePO> list = docHierarchyManager.getDocsInFolderByType(oprId, ""
                                + Constants.DOCUMENT);
                        for (DocResourcePO d : list) {
                            indexManager.update(d.getId(), ApplicationCategoryEnum.doc.getKey());
                          //更新该id的映射文件对应的全文检索
                            docHierarchyManager.updateLink(d.getId());
                        }
                    }
                } else {
                    this.updateIndex(oprId);
                    docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(),
                            DocActionEnum.edit.key(), oprId, "move");

                }
            }
            out.println("parent.afterMoveDocs('" + folderMoved + "', '" + destId + "');");
            out.println("parent.parent.afterMoveDocs('" + folderMoved + "', '" + destId + "');");
            out.println("</script>");
        } catch (BusinessException e) {
            out.println("parent.handleExceptionWhenMoveDocs('" + e.getMessage() + "', '"+ this.docHierarchyManager.getFolderLevelLimit() + "');");
            out.println("</script>");
        }
        out.close();
        return null;
    }
    
    // 公共文件夹授权iframe窗口
    public ModelAndView docGrantIframe(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/docGrantIframe");
    }

    // 得到公共授权数据
    private List<PotentModel> getGrantVO(HttpServletRequest request, boolean isGroupRes) {
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        return docAclManager.getGrantVOs(docResId, isGroupRes);
    }

    // 我的文件夹授权iframe窗口
    public ModelAndView myGrantIframe(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/myGrantIframe");
    }

    // 弹出我的文档授权窗口
    public ModelAndView myGrant(HttpServletRequest request, HttpServletResponse response) {
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        List<DocPersonalShareVO> objs = DocMVCUtils.getMyGrantVO(docResId, docAclManager);
        return new ModelAndView("apps/doc/myGrant", "objs", objs);
    }

    // 我的文档授权
    public ModelAndView toMyGrant(HttpServletRequest request, HttpServletResponse response) throws IOException {
        this.saveMyGrant(request);
        super.rendJavaScript(response, "parent.close();");
        return null;
    }

    // 保存我的文档的共享授权数据
    private void saveMyGrant(HttpServletRequest request) {
        Long docResId = Long.valueOf(request.getParameter("mygrantDocResId"));
        String username[] = request.getParameterValues("mygrantusername");
        DocResourcePO oprDr = docHierarchyManager.getDocResourceById(docResId);
        Long ownerId = AppContext.currentUserId();
        Map<Long, String> personmap = new HashMap<Long, String>();
        List<Long> userIds = null;
        List<String> userTypes = null;
        if (username != null) {
            int len = username.length;
            // 得到本次提交的所有的用户的ID
            userIds = new ArrayList<Long>();
            userTypes = new ArrayList<String>();
            for (int i = 0; i < len; i++) {
                String uid = request.getParameter("mygrantuid" + i);
                if (uid == null && i < len) {
                    len++;
                    continue;
                }
                if (uid == null && i == len) {
                    continue;
                }
                userIds.add(Long.valueOf(uid));
                userTypes.add(request.getParameter("mygrantutype" + i));
                // 判断此人是不是在数据库中有共享记录
                boolean hasAclShare = docAclManager.hasAclertShare(docResId, Long.valueOf(uid), true);
                personmap.put(Long.valueOf(uid), String.valueOf(hasAclShare));
            }
            docAclManager.deletePersonalShare(docResId);
            len = username.length;

            // 记录当前子文档夹的权限设置是否全部来源于继承
            boolean allIsInherit = true;
            for (int i = 0; i < len; i++) {
                String inherit = StringUtils.defaultIfEmpty(request.getParameter("mygrantinherit" + i), "false");
                if ("false".equals(inherit)) {
                    allIsInherit = false;
                    break;
                }
            }
            //清空该文档订阅,然后新增,上一版本逻辑错误,在三个人订阅,第一个人选择订阅,第二个人选择订阅,第三个人不选择订阅,提交时,第三次操作会清楚第1,2两个人的订阅记录
            docAlertManager.deleteShareAlertByDocResourceId(docResId);
            Set<Long> docAlerts = new HashSet<Long>();
            for (int i = 0; i < len; i++) {
                String uid = request.getParameter("mygrantuid" + i);
                String utype = request.getParameter("mygrantutype" + i);
                if (uid == null && i < len) {
                    len++;
                    continue;
                }
                if (uid == null && i == len) {
                    continue;
                }
                String inherit = request.getParameter("mygrantinherit" + i);
                if (inherit == null || "".equals(inherit)) {
                    inherit = "false";
                }
                // 子文档夹的单独设置(非继承) + 继承而来的权限设置
                if ("false".equals(inherit) || allIsInherit) {
                    boolean isFolder = Boolean.parseBoolean(request.getParameter("isFolder"));
                    String snew = request.getParameter("mygrantalertnew" + i);
                    boolean alertnew = Boolean.parseBoolean(snew);
                    // 是不是产生订阅的记录
                    if (alertnew) {
                        //该处代码删除,不需要查询,只需要新增.
                        Long alertId =  docAlertManager.addAlert(docResId, isFolder, Constants.ALERT_OPR_TYPE_ALL, utype,
                                Long.valueOf(uid), AppContext.currentUserId(), true, false, true);
                        docAclManager.setPersonalSharePotent(Long.valueOf(uid), utype, docResId, ownerId, alertId);
                    } else {
                        docAclManager.setPersonalSharePotent(Long.valueOf(uid), utype, docResId, ownerId, null);
                    }
                }
                if ("false".equals(personmap.get(Long.valueOf(uid)))) {
                    try {
                        docAlerts.addAll(this.getAlertMemberIds(uid, utype, true, null));
                    } catch (Exception e) {
                        log.error("", e);
                    }
                }
            }
            
            try {
                String key = "doc.share.to.label";
                List<Long> receiverIds = new ArrayList<Long>(docAlerts);
                MessageContent cont = MessageContent.get(key, oprDr.getFrName(), AppContext.currentUserName());
                Collection<MessageReceiver> receivers = MessageReceiver.get(docResId, receiverIds,"message.link.doc.folder.open",
                        com.seeyon.ctp.common.usermessage.Constants.LinkOpenType.href, docResId);
                userMessageManager.sendSystemMessage(cont, ApplicationCategoryEnum.doc,AppContext.currentUserId(), receivers);
            } catch (Exception e) {
                log.error("", e);
            }
        } else {
            docAclManager.deletePersonalShare(docResId);
            docAlertManager.deleteShareAlertByDocResourceId(docResId);
            //如果有继承来的属性权限,增加一条共享给自己的权限,屏蔽个人设置共享不上的问题,参考bug:OA-31474
            if(oprDr.getIsFolder()){
                List<DocPersonalShareVO> pvos = DocMVCUtils.getDocPersonalShareVOs(docResId,docAclManager,true);
                if(CollectionUtils.isNotEmpty(pvos)) {
                    docAclManager.setPersonalSharePotent(ownerId, "Member", docResId, ownerId, null);
                } 
            }
        }
        docFavoriteManager.updateOpenSquareTimeByParentForder(oprDr, new Timestamp(System.currentTimeMillis()));
        User user = AppContext.getCurrentUser();

        //文档夹共享全部权限的授权与变更
        this.appLogManager.insertLog(user, AppLogAction.DocFolder_ShareAuth_Update, user.getName(), oprDr.getFrName());
        try {
            docActionManager.insertDocAction(user.getId(), AppContext.currentAccountId(), new Date(),
                    DocActionEnum.share.key(), docResId, "", userIds, userTypes);
        } catch (KnowledgeException e) {
            log.error("", e);
        }
        
        // 全文检索, 更新所有影响到的文档
        List<DocResourcePO> list = docHierarchyManager.getDocsInFolderByType(docResId, "" + Constants.DOCUMENT);
        //映射文件
        List<DocResourcePO> mappingList = docHierarchyManager.getDocsInFolderByType(docResId, "" + Constants.LINK);
        list.addAll(mappingList);
        if (AppContext.hasPlugin("index")) {
            for (DocResourcePO d : list) {
                try {
                    indexManager.update(d.getId(), ApplicationCategoryEnum.doc.getKey());
                  //更新该id的映射文件对应的全文检索
                    docHierarchyManager.updateLink(d.getId());
                } catch (BusinessException e) {
                    log.error("", e);
                }
            }
        }
    }

    // 我的文件夹授权iframe窗口
    public ModelAndView borrowGrantIframe(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/borrowIframe");
    }

    // 弹出我的文档借阅授权窗口
    public ModelAndView borrow(HttpServletRequest request, HttpServletResponse response) {
        List<DocBorrowVO> objs = this.getBorrowVO(request);
        return new ModelAndView("apps/doc/borrow", "objs", objs);
    }

    // 取得借阅数据
    private List<DocBorrowVO> getBorrowVO(HttpServletRequest request) {
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        List<DocBorrowVO> my = new ArrayList<DocBorrowVO>();
        List<DocAcl> l = null;
        if (docLibType.equals(Constants.PERSONAL_LIB_TYPE)) {
            l = docAclManager.getPersonalBorrowList(docResId);
        } else {
            l = docAclManager.getDeptBorrowList(docResId);
        }
        boolean isGroupRes = false;
        if (docLibType.equals(Constants.GROUP_LIB_TYPE)) {
            isGroupRes = true;
        }
        if (CollectionUtils.isNotEmpty(l)) {
            for (DocAcl acl : l) {
                DocBorrowVO bvo = new DocBorrowVO();
                String userName = Constants.getOrgEntityName(acl.getUserType(), acl.getUserId(), isGroupRes);
                bvo.setEdate(acl.getEdate());
                bvo.setSdate(acl.getSdate());
                bvo.setUserId(acl.getUserId());
                bvo.setUserName(userName);
                bvo.setUserType(acl.getUserType());
                bvo.setLenPotent(acl.getLenPotent());
                bvo.setLenPotent2(acl.getMappingPotent().getLenPotent2());
                my.add(bvo);
            }
        }
        return my;
    }

    /** 保存借阅数据 */
    private void saveBorrow(HttpServletRequest request) throws BusinessException {
        String username[] = request.getParameterValues("borrowusername");
        Long docResId = Long.valueOf(request.getParameter("borrowDocResId"));
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        boolean isPersonalLib = docLibType.equals(Constants.PERSONAL_LIB_TYPE);
        DocResourcePO oprDr = this.docHierarchyManager.getDocResourceById(docResId);
        List<Long> userIds = null;
        List<String> userTypes = new ArrayList<String>();
        if (username != null) {
            int len = username.length;
            // 得到这次提交的所有的用户的ID
            userIds = new ArrayList<Long>();
            Map<Long, String> usermap = new HashMap<Long, String>();
            for (int i = 0; i < len; i++) {
                String uid = request.getParameter("borrowuid" + i);
                if (uid == null && i < len) {
                    len++;
                    continue;
                }
                userIds.add(Long.valueOf(uid));
                userTypes.add(request.getParameter("borrowutype" + i));
                boolean hasAclertBoorrow = docAclManager.hasAclertBoorrow(docResId, Long.valueOf(uid), isPersonalLib);
                usermap.put(Long.parseLong(uid), String.valueOf(hasAclertBoorrow));
            }
            len = username.length;
            // 个人文档的借阅
            if (isPersonalLib) {
                this.sendMsgAndDeleteBorrow(isPersonalLib, userIds, oprDr, docLibType);
                for (int i = 0; i < len; i++) {
                    String uid = request.getParameter("borrowuid" + i);
                    if (uid == null && i < len) {
                        len++;
                        continue;
                    }
                    if (uid == null && i == len) {
                        continue;
                    }
                    this.handleAlertTo(request, i, oprDr, isPersonalLib, usermap);
                }
            } else {
                this.sendMsgAndDeleteBorrow(isPersonalLib, userIds, oprDr, docLibType);
                for (int i = 0; i < len; i++) {
                    if (request.getParameter("borrowuid" + i) == null) {
                        len++;
                        continue;
                    }
                    this.handleAlertTo(request, i, oprDr, isPersonalLib, usermap);
                }
            }
        } else {
            List<DocAcl> oldPersons = this.getDocAclFromBorrow(docResId, isPersonalLib);
            if (oldPersons != null && !oldPersons.isEmpty()) {
                for (DocAcl docAcl : oldPersons) {
                    this.sendAlertDelMsg(oprDr, docAcl, docLibType);
                }
            }
            docAclManager.deleteBorrow(docResId, isPersonalLib);
        }
        docFavoriteManager.updateOpenSquareTimeByParentForder(oprDr, new Timestamp(System.currentTimeMillis()));
        docActionManager.insertDocAction(AppContext.currentUserId(), AppContext.currentAccountId(), new Date(),
                DocActionEnum.borrow.key(), docResId, "borrow", userIds, userTypes);
    }

    private void handleAlertTo(HttpServletRequest request, int i, DocResourcePO oprDr, boolean isPersonalLib,
            Map<Long, String> usermap) throws BusinessException {

        String uid = request.getParameter("borrowuid" + i);
        String utype = request.getParameter("borrowutype" + i);
        Byte lenPotent = -1;
        String lenPotentStr = request.getParameter("lenPotent" + i);
        if (lenPotentStr != null && !"".equals(lenPotentStr)) {
            lenPotent = Byte.valueOf(lenPotentStr);
        }
        String lenPotent2 = getLenPotentStr(request, i, oprDr);
        Date sdate = Datetimes.getTodayFirstTime(request.getParameter("begintime" + i));
        Date edate = Datetimes.getTodayLastTime(request.getParameter("endtime" + i));
        Date stime = new Date(sdate.getTime());
        Date etime = new Date(edate.getTime());
        this.sendAlertToMsgAndSetPotent(uid, utype, stime, etime, lenPotent, lenPotent2, oprDr, isPersonalLib, usermap,
                Byte.valueOf(request.getParameter("docLibType")));
    }

    private String getLenPotentStr(HttpServletRequest request, int i, DocResourcePO oprDr) {
        String lenPotent2 = request.getParameter("lenPotent2a" + i) == null ? "0" : "1";
        lenPotent2 += request.getParameter("lenPotent2b" + i) == null ? "0" : "1";
        if (oprDr.getFrType() != 2) {
            lenPotent2 = request.getParameter("bRead" + i) == null ? "0" : "1";
            lenPotent2 += request.getParameter("bBrowse" + i) == null ? "0" : "1";
        }
        return lenPotent2;
    }

    private void sendAlertToMsgAndSetPotent(String uid, String utype, Date stime, Date etime, Byte lenPotent,
            String lenPotent2, DocResourcePO oprDr, boolean isPersonalLib, Map<Long, String> usermap, Byte docLibType)
            throws BusinessException {
        // 发送借阅消息
        if ("false".equals(usermap.get(Long.parseLong(uid)))) {
            MessageContent cont = MessageContent.get("doc.alert.to.label", oprDr.getFrName(),
                    AppContext.currentUserName());
            Set<Long> docAlerts = this.getAlertMemberIds(uid, utype, isPersonalLib, docLibType);
            Collection<MessageReceiver> receivers = MessageReceiver.getReceivers(oprDr.getId(), docAlerts,
                    "message.link.doc.openfromborrow", oprDr.getId().toString());
            try {
                userMessageManager.sendSystemMessage(cont, ApplicationCategoryEnum.doc, AppContext.currentUserId(),
                        receivers);
            } catch (Exception e) {
                log.error("", e);
            }
        }
        // 设置借阅权限
        this.setBorrowPotent(uid, utype, stime, etime, lenPotent, lenPotent2, oprDr, isPersonalLib);

    }

    /**
     * 设置借阅权限
     */
    private void setBorrowPotent(String uid, String utype, Date stime, Date etime, Byte lenPotent, String lenPotent2,
            DocResourcePO oprDr, boolean isPersonalLib) {
        if (isPersonalLib) {
            docAclManager.setNewPersonalBorrowPotent(Long.parseLong(uid), utype, oprDr.getId(),
                    AppContext.currentUserId(), stime, etime, lenPotent, lenPotent2);
        } else {
            docAclManager.setNewDeptBorrowPotent(Long.parseLong(uid), utype, oprDr.getId(), stime, etime, lenPotent,
                    lenPotent2);            
        }
        // 记录操作日志
        operationlogManager.insertOplog(oprDr.getId(), oprDr.getParentFrId(), ApplicationCategoryEnum.doc,
                ActionType.LOG_DOC_LEND, ActionType.LOG_DOC_LEND + ".desc", AppContext.currentUserName(),
                oprDr.getFrName());
    }

    /**
     * 删除借阅记录并给相关人员发送消息通知
     */
    private void sendMsgAndDeleteBorrow(boolean isPersonalLib, List<Long> userids, DocResourcePO oprDr, Byte docLibType)
            throws BusinessException {
        List<DocAcl> oldPersons = this.getDocAclFromBorrow(oprDr.getId(), isPersonalLib);
        this.sendAlertDelMsg(userids, oprDr, oldPersons, docLibType);
        docAclManager.deleteBorrow(oprDr.getId(), isPersonalLib);
    }

    /**
     * 获取借阅权限列表
     */
    private List<DocAcl> getDocAclFromBorrow(Long docResId, boolean isPersonalLib) {
        List<DocAcl> oldPersons = null;
        if (isPersonalLib) {
            oldPersons = docAclManager.getPersonalBorrowList(docResId);
        } else {
            oldPersons = docAclManager.getDeptBorrowList(docResId);
        }
        return oldPersons;
    }

    /**
     * 取消借阅时，向相关人员发送消息
     */
    private void sendAlertDelMsg(List<Long> userids, DocResourcePO oprDr, List<DocAcl> oldPersons, Byte docLibType)
            throws BusinessException {
        if (CollectionUtils.isNotEmpty(oldPersons) && CollectionUtils.isNotEmpty(userids)) {
            for (DocAcl docAcl : oldPersons) {
                if (!userids.contains(docAcl.getUserId())) {
                    this.sendAlertDelMsg(oprDr, docAcl, docLibType);
                }
            }
        }
    }

    /**
     * 取消借阅时，向相关人员发送消息
     */
    private void sendAlertDelMsg(DocResourcePO oprDr, DocAcl docAcl, Byte docLibType) throws BusinessException {
        Set<Long> docAlerts = this.getAlertMemberIds(Long.toString(docAcl.getUserId()), docAcl.getUserType(), true,
                docLibType);
        MessageContent cont = MessageContent
                .get("doc.alert.del.label", oprDr.getFrName(), AppContext.currentUserName());
        Collection<MessageReceiver> receivers = MessageReceiver.get(AppContext.currentUserId(), docAlerts);
        try {
            userMessageManager.sendSystemMessage(cont, ApplicationCategoryEnum.doc, AppContext.currentUserId(),
                    receivers, oprDr.getId());
        } catch (Exception e) {
            log.error("", e);
        }
    }

    /** 获得所有借阅对象人员的Id */
    private Set<Long> getAlertMemberIds(String id, String usertype, boolean isPersonLib, Byte docLibType)
            throws BusinessException {
        Set<Long> memberIds = new HashSet<Long>();
        // 个人文档不能借阅给自己 ，单位文档可以
        if (V3xOrgEntity.ORGENT_TYPE_MEMBER.equals(usertype)) {
            if (Long.parseLong(id) != AppContext.currentUserId()) {
                memberIds.add(Long.valueOf(id));
            }
        } else {
            String idAndType = usertype + "|" + id;
            Set<V3xOrgMember> membersSet = orgManager.getMembersByTypeAndIds(idAndType);
            for (V3xOrgMember om : membersSet) {
                // 公文文档过滤外部人员
                if (docLibType != null && docLibType == Constants.EDOC_LIB_TYPE.byteValue() && !om.getIsInternal()) {
                    continue;
                }
                if (om.getId().longValue() != AppContext.currentUserId()) {
                    memberIds.add(om.getId());
                }
            }
        }
        if (isPersonLib) {
            memberIds.remove(AppContext.currentUserId());
        }
        return memberIds;
    }

    /**
     * 保存公共库的共享授权数据
     * 文件夹共享只更新全文检索权限即可，不解析
     */
    synchronized private void saveGrant(HttpServletRequest request) throws BusinessException {
        Long docResId = NumberUtils.toLong(request.getParameter("docResId"));
        DocResourcePO oprDr = docHierarchyManager.getDocResourceById(docResId);
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        DocResourcePO dr = docHierarchyManager.getDocResourceById(docResId);
        List<Long> owners = DocMVCUtils.getLibOwners(dr);
        boolean isGroupRes = docLibType == Constants.GROUP_LIB_TYPE.byteValue();
        Long userId = AppContext.currentUserId();
        String username[] = request.getParameterValues("username");

        List<Long> userIds = new ArrayList<Long>();
        List<String> userTypes = new ArrayList<String>();
        if (username != null) {
            // lihf 拿到页面传过来的所有权限记录
            int len = username.length;
            List<String> rows = new ArrayList<String>();
            Map<Long, String> newMap = new HashMap<Long, String>();
            for (int i = 0; i < len; i++) {
                String[] uids = request.getParameterValues("uid" + i);
                if (uids == null && i < len) {
                    len++;
                    continue;
                }
                String[] utypes = request.getParameterValues("utype" + i);
                String uid = uids[uids.length - 1];
                String utype = utypes[utypes.length - 1];
                if (uid == null && i < len) {
                    continue;
                }
                userIds.add(Long.valueOf(uid));
                userTypes.add(utype);
                String row = uid + "," + utype + "," + docResId + "," + this.getAclStr(request, i);
                rows.add(row);
                newMap.put(Long.valueOf(uid), row);
            }
            List<PotentModel> objs = new ArrayList<PotentModel>();
            // 继承  lihf 封装该DocResourcePO 继承过来的权限数据
            List<DocAcl> l = docAclManager.getDocAclListByInherit(docResId);
            Set<Long> set = new HashSet<Long>();
            if (CollectionUtils.isNotEmpty(l)) {
                for (DocAcl a : l) {
                    set.add(a.getUserId());
                }
                for (Long userid : set) {
                    PotentModel p = new PotentModel();
                    p.setUserId(userid);
                    if (owners.contains(userid)) {
                        p.setIsLibOwner(true);
                    }
                    for (DocAcl a : l) {
                        if (a.getUserId() == userid) {
                            if (p.getUserName() == null) {
                                String userName = Constants
                                        .getOrgEntityName(a.getUserType(), a.getUserId(), isGroupRes);
                                p.setUserName(userName);
                                p.setUserType(a.getUserType());
                            }
                            p.copyAcl(a);
                        }
                    }
                    if (!docAclManager.isNoInherit(p.getUserId(), p.getUserType(), docResId)) {
                        p.setInherit(true);
                        p.setAlert(false);
                        p.setAlertId(0L);
                        objs.add(p);
                    }
                }
            }

            // 非继承 lihf 本级权限记录
            List<List<DocAcl>> l2 = docAclManager.getDocAclListByNew(docResId);
            for (List<DocAcl> l3 : l2) {
                PotentModel p = null;
                boolean flag = false;
                if (objs != null && objs.size() > 0) {
                    for (PotentModel pm : objs) {
                        for (DocAcl temp : l3) {
                            if (temp.getUserId() == pm.getUserId()) {
                                flag = true;
                                p = pm;
                                break;
                            }
                        }
                        if (flag) {
                            break;
                        }
                    }
                }
                if (!flag) {
                    p = new PotentModel();
                } else {
                    p.setAllAcl(false);
                }
                boolean isAlert = false;
                long alertId = 0L;
                for (DocAcl acl2 : l3) {
                    if (p.getUserId() == null) {
                        p.setUserId(acl2.getUserId());
                        p.setUserType(acl2.getUserType());
                        String userName = Constants.getOrgEntityName(acl2.getUserType(), acl2.getUserId(), isGroupRes);
                        p.setUserName(userName);
                    }
                    p.copyAcl(acl2);
                    isAlert = acl2.getIsAlert();
                    if (isAlert) {
                        alertId = acl2.getDocAlertId();
                    }
                }
                p.setInherit(false);
                p.setAlert(isAlert);
                p.setAlertId(alertId);
                if (!flag) {
                    objs.add(p);
                }
            }
            List<String> oldlist = new ArrayList<String>();
            Map<Long, String> oldMap = new HashMap<Long, String>();
            for (PotentModel pmm : objs) {
                String dp = pmm.descPotent(docResId);
                oldlist.add(dp);
                oldMap.put(pmm.getUserId(), dp);
            }
            Set<Long> keySet = oldMap.keySet();
            int minOrder = docAclManager.getMaxOrder();
            for (long userIdmap : keySet) {
                if (owners.contains(userIdmap)) {
                    //文档库管理员能查看所有, 不用保存权限
                    continue;
                }
                if (newMap.containsKey(userIdmap)) {
                    String newStr = newMap.get(userIdmap);
                    String oldStr = oldMap.get(userIdmap);
                    String[] newarr = newStr.split(",");
                    String[] oldarr = oldStr.split(",");
                    // 继承
                    boolean isInherit = Boolean.parseBoolean(newarr[9]);
                    // 订阅
                    boolean isAlert = Boolean.parseBoolean(newarr[10]);
                    if (!newStr.equals(oldStr) || isInherit) {
                    	Long newalertId = null;
                        docAlertManager.deleteAlertByDocResourceIdAndOrgByAcl(docResId, newarr[1],
                                Long.parseLong(newarr[0]));
                        if (isAlert) {
                            newalertId = docAlertManager.addAlert(docResId, true, Constants.ALERT_OPR_TYPE_ALL,
                                    newarr[1], Long.valueOf(newarr[0]), userId, true, false, true);
                        }else{
                        	List<DocAlertPO> oldAlert = docAlertManager.findAlertsByUserIdAndDocResId(oldarr[1], userId, docResId);
                        	if(Strings.isNotEmpty(oldAlert)){
                                docAlertManager.deleteAlertById(oldAlert.get(0).getId());
                            }
                        }
                        boolean haspotent = false;
                        if (!isInherit) {
                            docAclManager.deletePotentByUser(Long.valueOf(newarr[2]), Long.valueOf(newarr[0]),
                                    newarr[1], docLibType, dr.getDocLibId());
                        }
                        for (int i = 3; i < 9; i++) {
                            int potent = this.getPotentType(i);
                            if ("true".equals(newarr[i])) {
                                haspotent = true;
                                docAclManager.setDeptSharePotent(Long.valueOf(newarr[0]), newarr[1],
                                        Long.valueOf(newarr[2]), potent, isAlert, newalertId, minOrder++);
                            } else if ("false".equals(newarr[9])) {
                                docAclManager.deletePotentByUser(Long.valueOf(newarr[2]), Long.valueOf(newarr[0]),
                                        newarr[1], potent);
                            }
                        }
                        if (!haspotent) {
                            if (isAlert) {
                                docAlertManager.deleteAlertById(newalertId);
                            }
                            // 删除权限实现继承,删除子文件夹同类型人、部门...的权限
                            DocResourcePO currenDr = docHierarchyManager.getDocResourceById(Long.valueOf(newarr[2]));
                            List<DocResourcePO> list = docAlertManager.getSubFolderIds(Long.valueOf(newarr[2]), currenDr);
                            if (list != null && !list.isEmpty()) {
                                for (DocResourcePO item : list) {
                                    docAlertManager.deleteAlertByDocResourceIdAndOrg(item.getId(), newarr[1],
                                            Long.parseLong(newarr[0]));
                                    if (!item.getId().toString().equals(newarr[2])) {
                                        docAclManager.deletePotentByUser(item.getId(), Long.valueOf(newarr[0]),
                                                newarr[1], docLibType, item.getDocLibId());
                                    }
                                }
                            }
                            docAclManager.deletePotentByUser(Long.valueOf(newarr[2]), Long.valueOf(newarr[0]),
                                    newarr[1], docLibType, dr.getDocLibId());

                            docAclManager.setDeptSharePotent(Long.valueOf(newarr[0]), newarr[1],
                                    Long.valueOf(newarr[2]), Constants.NOPOTENT, false, null, minOrder++);
                            //管理员订阅不可更改 
                            //							for (Long cat : owners) {
                            //								Long alertId = docAlertManager.addAlert(docResId, true, Constants.ALERT_OPR_TYPE_ALL,
                            //										V3xOrgEntity.ORGENT_TYPE_MEMBER, cat, userId, true, false, true);
                            //								docAclManager.setDeptSharePotent(cat, V3xOrgEntity.ORGENT_TYPE_MEMBER, Long.parseLong(newarr[2]), Constants.ALLPOTENT, true, alertId);
                            //							}
                        }
                    }

                } else {
                    String oldStr = oldMap.get(userIdmap);
                    String[] oldarr = oldStr.split(",");
                    docAlertManager.deleteAlertByDocResourceIdAndOrg(Long.parseLong(oldarr[2]), oldarr[1],
                            Long.parseLong(oldarr[0]));
                    docAlertManager.deleteAlertByDocResourceIdAndAllIds(Long.parseLong(oldarr[2]), oldarr[1],
                            Long.parseLong(oldarr[0]));
                    DocResourcePO currenDr = docHierarchyManager.getDocResourceById(Long.valueOf(oldarr[2]));
                    List<DocResourcePO> list = docAlertManager.getSubFolderIds(Long.valueOf(oldarr[2]), currenDr);
                    if (list != null && !list.isEmpty()) {
                        for (DocResourcePO item : list) {
                            docAlertManager.deleteAlertByDocResourceIdAndOrg(item.getId(), oldarr[1],
                                    Long.parseLong(oldarr[0]));
                            // 删除权限实现继承,删除子文件夹同类型人、部门...的权限
                            if(!item.getId().toString().equals(oldarr[2])){
                                docAclManager.deletePotentByUser(item.getId(), Long.valueOf(oldarr[0]), oldarr[1],
                                        docLibType, item.getDocLibId());
                            }
                        }
                    }
                    docAclManager.deletePotentByUser(Long.parseLong(oldarr[2]), Long.valueOf(oldarr[0]), oldarr[1],
                            docLibType, dr.getDocLibId());
                    docAclManager.setDeptSharePotent(Long.parseLong(oldarr[0]), oldarr[1], Long.valueOf(oldarr[2]),
                            Constants.NOPOTENT, false, null, minOrder++);
                    //管理员订阅不可更改 
                    //					for (Long cat : owners) {
                    //						Long alertId = docAlertManager.addAlert(docResId, true, Constants.ALERT_OPR_TYPE_ALL,
                    //								V3xOrgEntity.ORGENT_TYPE_MEMBER, cat, userId, true, false, true);
                    //						docAclManager.setDeptSharePotent(cat, V3xOrgEntity.ORGENT_TYPE_MEMBER, Long.parseLong(oldarr[2]), Constants.ALLPOTENT, true, alertId);
                    //					}
                }
            }

            Set<Long> receiverIds = new HashSet<Long>();
            Set<Long> newkeySet = newMap.keySet();
            for (long userIdnew : newkeySet) {
                if (owners.contains(userIdnew)) {
                    continue;
                }
                if (!oldMap.containsKey(userIdnew)) {
                    String newStr = newMap.get(userIdnew);
                    String[] newarr = newStr.split(",");

                    // 订阅
                    boolean isAlert = Boolean.parseBoolean(newarr[10]);
                    Long newalertId = null;
                    if (isAlert) {
                        newalertId = docAlertManager.addAlert(docResId, true, Constants.ALERT_OPR_TYPE_ALL, newarr[1],
                                Long.valueOf(newarr[0]), userId, true, false, true);
                    }
                    // 是否设置没有权限
                    boolean haspotent = false;
                    for (int i = 3; i < 9; i++) {
                        int potent = this.getPotentType(i);
                        if ("true".equals(newarr[i])) {
                            haspotent = true;
                            docAclManager.setDeptSharePotent(Long.valueOf(newarr[0]), newarr[1],
                                    Long.valueOf(newarr[2]), potent, isAlert, newalertId, minOrder++);
                        }
                    }

                    if (!haspotent) {
                        if (isAlert) {
                            docAlertManager.deleteAlertById(newalertId);
                        }
                        // 删除权限实现继承,删除子文件夹同类型人、部门...的权限
                        DocResourcePO currenDr = docHierarchyManager.getDocResourceById(Long.valueOf(newarr[2]));
                        List<DocResourcePO> list = docAlertManager.getSubFolderIds(Long.valueOf(newarr[2]), currenDr);
                        if (list != null && !list.isEmpty()) {
                            for (DocResourcePO item : list) {
                                docAlertManager.deleteAlertByDocResourceIdAndOrg(item.getId(), newarr[1], Long.parseLong(newarr[0]));
                                if(!item.getId().toString().equals(newarr[2])){
                                    docAclManager.deletePotentByUser(item.getId(), Long.valueOf(newarr[0]), newarr[1],
                                            docLibType, item.getDocLibId());
                                }
                            }
                        }
                        docAclManager.setDeptSharePotent(Long.valueOf(newarr[0]), newarr[1],
                                Long.valueOf(newarr[2]), Constants.NOPOTENT, false, null, minOrder++);
                    }
                    try {
                        Set<Long> docAlerts = this.getAlertMemberIds(String.valueOf(userIdnew), newarr[1], true,
                                docLibType);
                        receiverIds.addAll(docAlerts);
                    } catch (Exception e) {
                        log.error("", e);
                    }
                }
            }
            // 发送消息
            try {
                String key = "doc.share.to.label";
                MessageContent cont = MessageContent.get(key, ResourceUtil.getString(oprDr.getFrName()),
                        AppContext.currentUserName());
                Collection<MessageReceiver> receivers = MessageReceiver.get(docResId, receiverIds,
                        "message.link.doc.folder.open", com.seeyon.ctp.common.usermessage.Constants.LinkOpenType.href,
                        docResId);
                userMessageManager.sendSystemMessage(cont, ApplicationCategoryEnum.doc, AppContext.currentUserId(),
                        receivers);
            } catch (Exception e) {
                log.error("", e);
            }
        } else {
            docAclManager.deleteDeptShareByDoc(docResId);
            docAlertManager.deleteShareAlertByDocResourceId(docResId);
        }

        // 记录操作日志
        operationlogManager.insertOplog(docResId, oprDr.getParentFrId(), ApplicationCategoryEnum.doc,
                ActionType.LOG_DOC_SHARE, ActionType.LOG_DOC_SHARE + ".desc", AppContext.currentUserName(),
                ResourceUtil.getString(oprDr.getFrName()));

        // 全文检索, 更新所有影响到的文档 
        List<DocResourcePO> list = docHierarchyManager.getAllDocsInFolderByType(docResId, "1,2,3,4,5,6,7,8,9,10,15,21,51");
        if (AppContext.hasPlugin("index")) {
            for (DocResourcePO d : list) {
                indexManager.update(d.getId(), ApplicationCategoryEnum.doc.getKey());
                //更新该id的映射文件对应的全文检索
                docHierarchyManager.updateLink(d.getId());
            }
        }
        docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(), DocActionEnum.share.key(),
                docResId, "common share", userIds, userTypes);

    }

    /**
     * 在保存权限时，获取遍历顺序中某一次的权限记录，以","拼接起来
     * @param i	遍历顺序游标
     */
    private String getAclStr(HttpServletRequest request, int i) {
        // 权限表
        String call = StringUtils.defaultIfEmpty(request.getParameter("cAll" + i), "false");
        String cedit = StringUtils.defaultIfEmpty(request.getParameter("cEdit" + i), "false");
        String cadd = StringUtils.defaultIfEmpty(request.getParameter("cAdd" + i), "false");
        String cread = StringUtils.defaultIfEmpty(request.getParameter("cRead" + i), "false");
        String clist = StringUtils.defaultIfEmpty(request.getParameter("cList" + i), "false");
        String cbrowse = StringUtils.defaultIfEmpty(request.getParameter("cBrowse" + i), "false");
        String inherit = StringUtils.defaultIfEmpty(request.getParameter("inherit" + i), "false");
        String alert = StringUtils.defaultIfEmpty(request.getParameter("cAlert" + i), "false");
        String acl = call + "," + cedit + "," + cadd + "," + cread + "," + clist + "," + cbrowse + "," + inherit + ","
                + alert;
        return acl;
    }

    /**
     * 根据解析值获取权限类型
     */
    private int getPotentType(int i) {
        int potent = 0;
        switch (i) {
            case 3:
                potent = Constants.ALLPOTENT;
                break;
            case 4:
                potent = Constants.EDITPOTENT;
                break;
            case 5:
                potent = Constants.ADDPOTENT;
                break;
            case 6:
                potent = Constants.READONLYPOTENT;
                break;
            case 7:
                potent = Constants.LISTPOTENT;
                break;
            case 8:
                potent = Constants.BROWSEPOTENT;
                break;
        }
        return potent;
    }

    // 初始化继承
    public ModelAndView recovery(HttpServletRequest request, HttpServletResponse response) {
        String docResId = request.getParameter("docResId");
        byte docLibType = Byte.parseByte(request.getParameter("docLibType"));
        long docLibId = Long.parseLong(request.getParameter("docLibId"));
        docAclManager.setPotentInherit(Long.valueOf(docResId), docLibType, docLibId);
        return null;
    }

    /** 查看一个文档的日志记录  */
    public ModelAndView docLogView(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView modelView = new ModelAndView("apps/doc/log/docLogQuery");
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        boolean isFolder = Boolean.parseBoolean(request.getParameter("isFolder"));
        List<OperationLog> list = operationlogManager.queryByObjectId(docResId, true);
        V3xOrgMember member = null;
        V3xOrgAccount account = null;
        List<ListDocLog> the_list = new ArrayList<ListDocLog>();
        for (int i = 0; i < list.size(); i++) {
            ListDocLog listDocLog = new ListDocLog();
            OperationLog log_ = (OperationLog) list.get(i);
            listDocLog.setOperationLog(log_);
            try {
                member = orgManager.getMemberById(log_.getMemberId());
                account = orgManager.getAccountById(member.getOrgAccountId());
            } catch (BusinessException e) {
                log.error("从orgManager取得用户", e);
            }
            listDocLog.setMember(member);
            listDocLog.setAccount(account);
            the_list.add(listDocLog);
        }
        List<PotentModel> grantVO = this.getGrantVO(request, true);
        modelView.addObject("grantVO", grantVO);
        modelView.addObject("docLogVeiw", the_list);
        modelView.addObject("docResourceId", docResId);
        modelView.addObject("isFolder", isFolder);
        return modelView;
    }

    // 获取文档夹的日志记录
    public ModelAndView folderLogView(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView modelView = new ModelAndView("apps/doc/log/docLogQuery");
        boolean isFolder = Boolean.parseBoolean(request.getParameter("isFolder"));
        List<ListDocLog> the_list = new ArrayList<ListDocLog>();
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        Long docLibId = Long.valueOf(request.getParameter("docLibId"));
        DocLibPO docLib = this.docLibManager.getDocLibById(docLibId);
        boolean isGroupLib = (docLib.getType() == Constants.GROUP_LIB_TYPE.byteValue());
        modelView.addObject("isGroupLib", isGroupLib);
        List<OperationLog> list = operationlogManager.queryBySubObjectIdOrObjectId(docResId, docResId, true);
        for (int i = 0; i < list.size(); i++) {
            ListDocLog listDocLog = new ListDocLog();
            OperationLog log_ = (OperationLog) list.get(i);
            listDocLog.setOperationLog(log_);
            V3xOrgMember member = null;
            V3xOrgAccount account = null;
            try {
                member = orgManager.getMemberById(log_.getMemberId());
                account = orgManager.getAccountById(member.getOrgAccountId());
            } catch (BusinessException e) {
                log.error("从orgManager取得member", e);
            }
            listDocLog.setMember(member);
            listDocLog.setAccount(account);
            the_list.add(listDocLog);
        }
        modelView.addObject("docLogVeiw", the_list);
        modelView.addObject("docResourceId", docResId);
        modelView.addObject("isFolder", isFolder);
        return modelView;
    }

    /**
     * 查看文档日志的框架
     */
    public ModelAndView docLogViewIframe(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView modelView = new ModelAndView("apps/doc/log/docLogQueryIfram");
        Long docLibId = Long.valueOf(request.getParameter("docLibId"));
        boolean search = Boolean.valueOf(request.getParameter("search"));
        boolean isFolder = Boolean.valueOf(request.getParameter("isFolder"));
        if(Strings.isNotBlank(request.getParameter("docResId"))){
        	Long docResId = Long.valueOf(request.getParameter("docResId"));
        	DocResourcePO docRes = docHierarchyManager.getDocResourceById(docResId);
        	String frName = ResourceUtil.getString(docRes.getFrName());
        	modelView.addObject("docLibName", frName);
        }
        modelView.addObject("docResId", request.getParameter("docResId"));
        DocLibPO docLib = this.docLibManager.getDocLibById(docLibId);
        boolean isGroupLib = (docLib.getType() == Constants.GROUP_LIB_TYPE.byteValue());
        modelView.addObject("isGroupLib", isGroupLib);
        modelView.addObject("search", search);
        modelView.addObject("docLibId", docLibId);
        modelView.addObject("isFolder", isFolder);
        return modelView;
    }

    /** 判断是文档日志还是文档夹日志 */
    public ModelAndView logView(HttpServletRequest request, HttpServletResponse response) {
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        DocResourcePO docRes = docHierarchyManager.getDocResourceById(docResId);
        return docRes.getIsFolder() ? this.folderLogView(request, response) : this.docLogView(request, response);
    }
    /**
     * 新的进入新建文档界面
     * @param request
     * @param response
     * @return
     */
    public ModelAndView theNewAddDoc(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView("apps/doc/community/theNewDocAdd");
        Long bodyType = Long.valueOf(request.getParameter("bodyType"));
        Long mimeTypeId = Long.valueOf(request.getParameter("docMimeType"));
        Long parentId = Long.valueOf(request.getParameter("parentId"));
        DocResourcePO parentDr = this.docHierarchyManager.getDocResourceById(parentId);
        mav.addObject("parentDr", parentDr);
        DocLibPO docLib = docLibManager.getDocLibById(parentDr.getDocLibId());
        boolean contentTypeFlag = true;
        String html = "";
        if (!docLib.isPersonalLib()) {
            List<DocTypePO> contentTypes = docLibManager.getValidContentTypesForDoc(docLib.getId());
            mav.addObject("contentTypes", contentTypes);
            if (CollectionUtils.isEmpty(contentTypes)) {
                contentTypeFlag = false;
            } else {
                html = htmlUtil.getNewHtml(contentTypes.get(0).getId());
            }
        } else {
            contentTypeFlag = false;
        }
        Long docId = UUIDLong.absLongUUID();
        String name = Constants.getDocI18nValue(parentDr.getFrName());
        mav.addObject("onlyA6", DocMVCUtils.isOnlyA6S());
        mav.addObject("parentLocation",convertToLink(name,
        		name, parentId, parentDr.getFrType(),request)+" - <a>" + Constants.getDocI18nValue("doc.jsp.add.title")+"</a>");
        return mav.addObject("contentTypeFlag", contentTypeFlag).addObject("html", html).addObject("docLib", docLib)
        		.addObject("docLibType", docLib.getType()).addObject("docLibId", docLib.getId())
                .addObject("docId", docId).addObject("bodyType", bodyType).addObject("mimeTypeId", mimeTypeId);
        
    }
    /** 进入添加文档界面 */
    public ModelAndView addDoc(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView("apps/doc/docAdd");
        Long parentId = Long.valueOf(request.getParameter("resId"));
        DocResourcePO parentDr = this.docHierarchyManager.getDocResourceById(parentId);
        mav.addObject("parentDr", parentDr);
        DocLibPO docLib = docLibManager.getDocLibById(parentDr.getDocLibId());
        boolean contentTypeFlag = true;
        String html = "";
        if (!docLib.isPersonalLib()) {
            List<DocTypePO> contentTypes = docLibManager.getValidContentTypesForDoc(docLib.getId());
            mav.addObject("contentTypes", contentTypes);
            if (CollectionUtils.isEmpty(contentTypes)) {
                contentTypeFlag = false;
            } else {
                html = htmlUtil.getNewHtml(contentTypes.get(0).getId());
            }
        } else {
            contentTypeFlag = false;
        }
        return mav.addObject("contentTypeFlag", contentTypeFlag).addObject("html", html).addObject("docLib", docLib);
    }
    /**
     * 新的修改文档页面，获取该文档的对应信息
     * @param request
     * @param response
     * @return
     * @throws IOException
     * @throws BusinessException
     */
    public ModelAndView theNewEditDoc(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        String url = "apps/doc/community/knowledgeBrowseEdit";
        Long userId = AppContext.currentUserId();
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        DocResourcePO doc = docHierarchyManager.getDocResourceById(docResId);
        DocLibPO docLib = docLibManager.getDocLibById(doc.getDocLibId());
        Byte docLibType = docLib.getType();
        Long mimeTypeId = doc.getMimeTypeId();
        DocMimeTypePO mime = docMimeTypeManager.getDocMimeTypeById(mimeTypeId);
        boolean isUploadFile = "true".equals(request.getParameter("isUploadFile"));
        boolean isCanEditOnline = true;
        boolean isOffice = false;
        // 判定当前浏览器是否是IE
        BrowserEnum currentBrowser = BrowserEnum.valueOf(request);
        boolean isIE = DocMVCUtils.isOfficeSupport(currentBrowser);
        //如果是上传文件，而且类型是不可编辑的（非office），那么就跳转到上传文件替换界面
        if("true".equals(request.getParameter("isUploadFileMimeType"))) {
            isCanEditOnline = false;
            parseFrNameSuffix(doc.getFrName(), request);
            url = "apps/doc/community/knowledgeBrowseEditUpload";
        }
        ModelAndView modelView = new ModelAndView(url);
        // 后台重复判断是否有编辑的权限，避免前端漏洞导致越权操作(性能问题)
        DocLibPO lib = this.docLibManager.getDocLibById(doc.getDocLibId());
        if (lib != null) {
            boolean canEdit = false;
            if (lib.getType() != Constants.PERSONAL_LIB_TYPE) {
                String orgIds = Constants.getOrgIdsOfUser(userId);
                Set<Integer> sets = this.docAclManager.getDocResourceAclList(docHierarchyManager.getDocResourceById(doc.getParentFrId()), orgIds);
                canEdit = sets.contains(Constants.ALLPOTENT) || sets.contains(Constants.EDITPOTENT);
            } else {
                canEdit = doc.getCreateUserId() == userId.longValue();
            }
            if (!canEdit) {
                super.rendJavaScript(response, "alert('" + Constants.getDocI18nValue("doc.noauth.edit")
                        + "');window.close();");
                return null;
            }
        }
        if(mime.isMSOrWPS() || mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_DOC || mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_XLS 
        		|| mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_WPS_DOC || mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_WPS_XLS) {
        	isOffice = true;
        }
        if (mime.theNewIsOffice()) {
            // 正文主键 T5那边处理
        } else {
            String bodyType = Constants.getBodyType(doc.getMimeTypeId());
            V3XFile file = null;
            try {
                file = fileManager.getV3XFile(doc.getSourceId());
                Date createDate = file.getCreateDate();
                String createDateString = Datetimes.formatDatetime(createDate);
                modelView.addObject("uploadFile", file);
                modelView.addObject("uploadFileCreateDate", createDateString);
            } catch (BusinessException e) {
                log.error("从fileManager取得V3xFile", e);
            }
            // jpg格式文件后台保存为html格式，但是不允许在线编辑
            if (bodyType == null || doc.isImage()) {
                // 不可以在线编辑

            } else {
                // word excel 在线编辑
                modelView.addObject("uploadFileBodyType", bodyType);
                modelView.addObject("uploadFileContent",doc.getSourceId() + "");
            }
        }
        //本地文件+关联文档
        List<Attachment> attachments = attachmentManager.getByReference(docResId, docResId);
        modelView.addObject("attachments", attachments);
        int relevanceSize = 0;//关联文档个数
        for (Attachment attachment : attachments) {
            if (attachment.getType().equals(2)) {
                relevanceSize++;
            }
        }
        //非个人文档加锁
        if (!docLibType.equals(Constants.PERSONAL_LIB_TYPE)) {
            docHierarchyManager.lockWhenAct(docResId, userId);
        }
        // 读取该文档所在文档库对应的内容类型
        boolean contentTypeFlag = true;
        if (!docLibType.equals(Constants.PERSONAL_LIB_TYPE)) {
            long docLibId = doc.getDocLibId();
            List<DocTypePO> contentTypes = docLibManager.getValidContentTypesForDoc(docLibId);

            // 当返回的集合不包含当前文档的内容类型时（已删除类型），应该加上
            DocTypePO _type = contentTypeManager.getContentTypeById(doc.getFrType());
            DocTypePO type = null;
			try {
				type = (DocTypePO)_type.clone();
				type.setId(_type.getId());
	            type.setName(DocMVCUtils.getDisplayName4MetadataDefinition2(type.getName(),null));
			} catch (CloneNotSupportedException e) {
				// TODO Auto-generated catch block
				log.error("", e);
			}           
            // 使用新集合，不能修改系统的集合
            List<DocTypePO> atypes = new ArrayList<DocTypePO>();
            if (contentTypes == null) {
                atypes.add(type);
            } else if (!contentTypes.contains(type)) {
                atypes.add(type);
                atypes.addAll(contentTypes);
            } else {
                atypes.addAll(contentTypes);
            }
            modelView.addObject("contentTypes", atypes);
        } else {
            contentTypeFlag = false;
        }
        String htmlStr = "";
        if (contentTypeManager.hasExtendMetadata(doc.getFrType())) {
            htmlStr = htmlUtil.getEditHtml(docResId, false);
        }
        
        if (doc.isVersionEnabled() && isOffice) {
            List<CtpContentAll> contentAll = MainbodyService.getInstance().getContentList(ModuleType.doc, doc.getId());
            if (contentAll != null && !contentAll.isEmpty()) {
                CtpContentAll ctpContentAll = contentAll.get(0);
                V3XFile officeFile = fileManager.clone(ctpContentAll.getContentDataId());
                modelView.addObject("originalFileId", officeFile.getId()); 
            }else{
//                V3XFile officeFile = fileManager.getV3XFile(doc.getSourceId());
//                if (officeFile != null) {
//                    modelView.addObject("originalFileId", officeFile.getId()); 
//                } 
            }
        }
        modelView.addObject("onlyA6", DocMVCUtils.isOnlyA6());
        modelView.addObject("versionEnabled", doc.isVersionEnabled());
        modelView.addObject("isIE", isIE);
        modelView.addObject("isOffice",isOffice);
        modelView.addObject("isCanEditOnline", isCanEditOnline);
        modelView.addObject("doc", doc);
        modelView.addObject("docLib", docLib);
        modelView.addObject("relevanceSize",relevanceSize);
        modelView.addObject("attachmentsJSON", attachmentManager.getAttListJSON(docResId));
        modelView.addObject("mimeTypeId", mimeTypeId);
        modelView.addObject("contentTypeFlag", contentTypeFlag);
        modelView.addObject("html", htmlStr);
        modelView.addObject("docTypeDeletedStatus", Constants.CONTENT_TYPE_DELETED);
        modelView.addObject("isUploadFile", isUploadFile);
        return modelView;
    }
    /** 进入修改文档页面，获取该文档的对应信息   
     * @throws BusinessException */
    public ModelAndView editDoc(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        return this.theNewEditDoc(request, response);
    }

    
    /**
     * 新建、编辑文档页面动态修改内容类型
     */
    public ModelAndView changeContentType(HttpServletRequest request, HttpServletResponse response) {
        boolean isJsonSubmit=request.getParameter("isJsonSubmit")==null?false:true;
        Long contentTypeId = 0L;
        String oldCTypeIdStr ="";
        String isAjaxStr = "false";     
        String docResIdStr = "";
        if (isJsonSubmit) {
            Map<String, String> param = ParamUtil.getJsonParams();
            contentTypeId = Long.valueOf(param.get("contentTypeId"));
            oldCTypeIdStr = param.get("oldCTypeId");
            docResIdStr = param.get("docResId");
        } else {
            contentTypeId = Long.valueOf(request.getParameter("contentTypeId"));
            oldCTypeIdStr = request.getParameter("oldCTypeId");
            isAjaxStr = request.getParameter("ajax");
            docResIdStr = request.getParameter("docResId");
        }
         
       
        if (Strings.isBlank(oldCTypeIdStr) || "null".equals(oldCTypeIdStr)) {
            oldCTypeIdStr = "0";
        }
      
        if (Strings.isBlank(docResIdStr) || "null".equals(docResIdStr)) {
            docResIdStr = "0";
        }
        Long oldCTypeId = Long.valueOf(oldCTypeIdStr);
        Long docResId = Long.valueOf(docResIdStr);
        boolean isAjax = false;
      
        isAjax = Boolean.parseBoolean(isAjaxStr);
        String htmlStr = "";
        try {
            if (docResId != 0 && oldCTypeId.equals(contentTypeId)) {
                htmlStr = htmlUtil.getEditHtml(docResId, false);
            } else {
                htmlStr = htmlUtil.getNewHtml(contentTypeId);
            }
        } catch (Exception e) {
            log.error(e);
        }
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.putOpt("htmlStr", htmlStr);
        } catch (JSONException e) {
            log.error("controller中changeContentType中ajax添加数据", e);
        }
        String view = null;
        if (isAjax) {
            view = this.getJsonView();
        }
        if(isJsonSubmit){   
            request.setAttribute("returnString", htmlStr);
            return new ModelAndView("apps/doc/personal/value");
        }
        return new ModelAndView(view, Constants.AJAX_JSON, jsonObject);
    }

    /** 放弃编辑文档 */
    public ModelAndView cancelModifyDoc(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        Long userId = AppContext.currentUserId();
        docHierarchyManager.checkInDocResourceWithoutAcl(docResId, userId);
        super.rendJavaScript(response, "window.close();");
        return null;
    }
    /**
     * 保存编辑知识
     * @param request
     * @param response
     * @return
     * @throws Exception 
     */
    public ModelAndView theNewModifyDoc(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long userId = AppContext.currentUserId();
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        
        Map<String, String> docEditDomain = ParamUtil.getJsonDomain("contentDiv");
        docEditDomain.putAll(ParamUtil.getJsonDomain("frName"));
        docEditDomain.putAll(ParamUtil.getJsonDomain("contentTypeId"));
        Map<String, String> metaDataInfo = ParamUtil.getJsonDomain("extendDiv"); 

        Long docResId = Long.valueOf(docEditDomain.get("id"));
        String docName = docEditDomain.get("name"); 
        String keyword = docEditDomain.get("keyword");
        String description = docEditDomain.get("description");
        String originalFileId = docEditDomain.get("originalFileId");
        String versionComment = docEditDomain.get("versionComment");
        String fileId = docEditDomain.get("fileId") == null ? request.getParameter("fileId") : docEditDomain.get("fileId");

        DocResourcePO docRes = docHierarchyManager.getDocResourceById(docResId);
        // 有效性判断
        if (docRes == null) {
            super.rendJavaScript(response, "alert(parent.v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));"
                    + "parent.window.returnValue = \"false\";" + "parent.window.close();");
            return null;
        }
        Integer t5MimeType = null;
        String contentString = null;
        
        if (docRes.isVersionEnabled()) {
            this.docVersionInfoManager.saveDocVersionInfo(versionComment, originalFileId, docRes);
            if (Strings.isNotBlank(originalFileId) && docRes.isUploadOfficeOrWps()) {
                docRes.setSourceId(NumberUtils.toLong(fileId));
            }
        }
        
        long contentTypeId = NumberUtils.toLong(docEditDomain.get("contentTypeId"), Constants.DOCUMENT);
        long oldTypeId = NumberUtils.toLong(docEditDomain.get("oldCTypeId"));
        if (contentTypeId != oldTypeId) {
            docMetadataManager.deleteMetadata(docRes);
            // 設置DocType，DocMetadataDef標記
            DocTypePO contentType = contentTypeManager.getContentTypeById(contentTypeId);
            if (!contentType.getIsSystem() && contentType.getStatus() == Constants.CONTENT_TYPE_DRAFT) {
                contentType.setStatus(Constants.CONTENT_TYPE_PUBLISHED);
                contentTypeManager.updateContentType(contentType, false, null);
                this.metadataDefManager.updateMetadataDef4ContentType(contentType);
            }
        }
        this.handleMetadata(metaDataInfo, docResId, false);
        //上传文档  编辑后  转化为复合文档
        Long mimeTypeId = docRes.getMimeTypeId();
        boolean sampleToComFlag = false;
        if ("true".equals(request.getParameter("isUploadFile")) && "true".equals(request.getParameter("isCanEditOnline"))) {
            if (mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_DOC) {
                mimeTypeId = Constants.FORMAT_TYPE_DOC_WORD;
                t5MimeType = 41;
            } else if (mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_XLS) {
                mimeTypeId = Constants.FORMAT_TYPE_DOC_EXCEL;
                t5MimeType = 42;
            } else if (mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_WPS_DOC) {
                mimeTypeId = Constants.FORMAT_TYPE_DOC_WORD_WPS;
                t5MimeType = 43;
            } else if (mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_WPS_XLS) {
                mimeTypeId = Constants.FORMAT_TYPE_DOC_EXCEL_WPS;
                t5MimeType = 44;
            }
            docRes.setMimeTypeId(mimeTypeId);
            sampleToComFlag = true;
        }
        // 修改文档记录,记录日志,发布文档消息
        DocResourcePO newDoc = null;
        DocMimeTypePO mime = docMimeTypeManager.getDocMimeTypeById(docRes.getMimeTypeId());
        if (mime.getFormatType() != Constants.FORMAT_TYPE_DOC_FILE) {
            FolderItemDoc fi = new FolderItemDoc(docRes);
            fi.setName(docName);
            fi.setContentTypeId(contentTypeId);
            fi.setDesc(description);
            fi.setKeywords(keyword);
            fi.setVersionComment(versionComment);
            if(sampleToComFlag) {
                Date bodyCreateDate = Datetimes.parseDatetime(request.getParameter("bodyCreateDate"));
                //将正文内容保存在正文组件中,当前id传递错误，老控件为fileId而不是docContentId  myx
                String docContentString = fileId;//request.getParameter("docContent");
                Long docContent = Long.valueOf(docContentString);
                CtpContentAll contentAll = new CtpContentAll();
                contentAll.setCreateDate(bodyCreateDate);
                contentAll.setModuleId(docResId);
                contentAll.setModuleType(3);
                contentAll.setContentType(t5MimeType);
                contentAll.setContentDataId(docContent);
                contentAll.setContent(docContentString);
                contentAll.setIdIfNew();
                MainbodyService.getInstance().saveOrUpdateContentAll(contentAll);
                //将正文内容保存在DocBody中
                DocBodyPO docBody = new DocBodyPO();
                docBody.setCreateDate(bodyCreateDate);
                docBody.setContent(docContentString);
                //docBody中保存的bodyType为字符串类型，所以根据mimeType进行转换
                String bodyType = null;
                if (mimeTypeId == 23) {
                    bodyType = "OfficeWord" ;
                } else if (mimeTypeId == 24) {
                    bodyType = "OfficeExcel" ;
                } else if (mimeTypeId == 25) {
                    bodyType = "WpsWord" ;
                } else {
                    bodyType = "WpsExcel" ;
                }
                docBody.setBodyType(bodyType);
                docHierarchyManager.saveBody(docResId, docBody);
                fi.setBody(docContentString);
            } else {
                //正文组件在版本开启时,保存
                CtpContentAll contentAll = MainbodyService.getInstance().getContent(ModuleType.getEnumByKey(3), docResId);
                if(mimeTypeId == 22) {
                    contentString = contentAll.getContent();
                } else {
                    contentString = Long.toString(contentAll.getContentDataId());
                }
                docHierarchyManager.updateBody(docResId, contentString);
                fi.setBody(contentString);
            }
            
            String attFlag = null;
            try {
                attachmentManager.deleteByReference(docResId, docResId);
                attFlag = attachmentManager.create(ApplicationCategoryEnum.doc, docResId, docResId, request);
            } catch (Exception e) {
                log.error("更新附件", e);
            }
            boolean hasAtt = com.seeyon.ctp.common.filemanager.Constants.isUploadLocaleFile(attFlag);
            fi.setHasAtt(hasAtt);
            
            try {        
                newDoc = docHierarchyManager.updateDocWithoutAcl(fi, userId);
                docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(),
                        DocActionEnum.edit.key(), docResId, "");
            } catch (BusinessException e) {
                log.error("复合文档的更新", e);
            }
        } else { //上传的文档
            DocEditVO vo = new DocEditVO(docRes);
            boolean replace = Boolean.parseBoolean(request.getParameter("fileReplaceFlag"));

            if (replace) {
                V3XFile the_file = this.saveV3xFile(ApplicationCategoryEnum.doc, request);
                vo.setFile(the_file);
            } else {
                vo.setFile(null);
            }

            //因为office控件都是以2003格式保存，故把扩展名的s去掉
            /*if (Strings.isNotBlank(docName)) {
                String[] suffix = docName.split("[.]");
                if (suffix != null && suffix.length > 1) {
                    int len = suffix.length;
                    if ("docx".equalsIgnoreCase(suffix[len - 1])) {
                        docName = suffix[len - 2] + ".doc";
                    } else if ("xlsx".equalsIgnoreCase(suffix[len - 1])) {
                        docName = suffix[len - 2] + ".xls";
                    } else if ("pptx".equalsIgnoreCase(suffix[len - 1])) {
                        docName = suffix[len - 2] + ".ppt";
                    }
                }
            }*/
            vo.setName(docName);
            vo.setContentTypeId(mimeTypeId);
            vo.setDesc(description);
            vo.setKeywords(keyword);
            vo.setVersionComment(versionComment);

            // 附件和关联文档存储
            String attFlag = null;
            try {
                attachmentManager.deleteByReference(docResId, docResId);
                attFlag = attachmentManager.create(ApplicationCategoryEnum.doc, docResId, docResId, request);
            } catch (Exception e) {
                log.error("更新附件", e);
            }
            boolean hasAtt = com.seeyon.ctp.common.filemanager.Constants.isUploadLocaleFile(attFlag);
            vo.getDocResource().setHasAttachments(hasAtt);
            try {
                boolean remainOldFile = docRes.isVersionEnabled() && replace;
                newDoc = docHierarchyManager.updateFileWithoutAcl(vo, docLibType, remainOldFile);
            } catch (BusinessException e) {
                //更新上传的文档出现异常时，做如下操作：1，删除掉已经上传上去的文件，2删除file表中的记录   pxb
                Long theFileId = vo.getFile().getId();
                try {
                    fileManager.deleteFile(theFileId, true);
                } catch (BusinessException e1) {
                    log.error("", e1);
                }
                log.error("更新文件[id=" + docResId + "]时出现异常:", e);
                super.rendJavaScript(response, "alert('对不起，出错了！');" + "parent.returnValueAndClose('false');");
                return null;

            }

        }

        // 日志
        operationlogManager.insertOplog(docResId, docRes.getParentFrId(), ApplicationCategoryEnum.doc,
                ActionType.LOG_DOC_EDIT_DOCUMENT_BODY, ActionType.LOG_DOC_EDIT_DOCUMENT_BODY + ".desc",
                AppContext.currentUserName(), docName);    

        // 更新订阅文档
        docAlertLatestManager.addAlertLatest(newDoc, Constants.ALERT_OPR_TYPE_EDIT, userId, new Date(),
                Constants.DOC_MESSAGE_ALERT_MODIFY_EDIT, null);

        //触发修改事件
        DocUpdateEvent docUpdateEvent = new DocUpdateEvent(this);
        docUpdateEvent.setDocResourceBO(DocMgrUtils.docResourcePOToBO(newDoc));
        EventDispatcher.fireEvent(docUpdateEvent);

        this.updateIndex(docResId);
        return null;
   }
    
    /** 修改一个文档  
     * @throws BusinessException */
    public ModelAndView modifyDoc(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        DocResourcePO docRes = docHierarchyManager.getDocResourceById(docResId);

        // 有效性判断
        if (docRes == null) {
            super.rendJavaScript(response, "alert(parent.v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));"
                    + "parent.window.returnValue = \"false\";" + "parent.window.close();");
            return null;
        }

        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        String docName = request.getParameter("docName");
        if (Strings.isNotBlank(request.getParameter("docSuffix")) && !docName.endsWith(request.getParameter("docSuffix"))) {
            docName += request.getParameter("docSuffix");
        }
        
        long contentTypeId = NumberUtils.toLong(request.getParameter("contentTypeId"), Constants.DOCUMENT);
        Long oldTypeId = Long.valueOf(request.getParameter("oldCTypeId"));
        Long userId = AppContext.currentUserId();
        String description = request.getParameter("description");
        String keyword = request.getParameter("keyword");
        String versionComment = request.getParameter("versionComment");
        String originalFileId = request.getParameter("originalFileId");

        // 扩展元数据
        if (contentTypeId != oldTypeId) {
            docMetadataManager.deleteMetadata(docRes);

            // 設置DocType，DocMetadataDef標記
            DocTypePO contentType = contentTypeManager.getContentTypeById(contentTypeId);
            if (!contentType.getIsSystem() && contentType.getStatus() == Constants.CONTENT_TYPE_DRAFT) {
                contentType.setStatus(Constants.CONTENT_TYPE_PUBLISHED);
                contentTypeManager.updateContentType(contentType, false, null);
                this.metadataDefManager.updateMetadataDef4ContentType(contentType);
            }
        }
        this.handleMetadata(request, docResId, false);

        //上传文档  编辑后  转化为复合文档
        Long mimeTypeId = docRes.getMimeTypeId();
        boolean sampleToComFlag = false;
        if ("true".equals(request.getParameter("isFile")) && "true".equals(request.getParameter("canEditOnline"))) {
            if (mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_DOC) {
                mimeTypeId = Constants.FORMAT_TYPE_DOC_WORD;
            } else if (mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_XLS) {
                mimeTypeId = Constants.FORMAT_TYPE_DOC_EXCEL;
            } else if (mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_WPS_DOC) {
                mimeTypeId = Constants.FORMAT_TYPE_DOC_WORD_WPS;
            } else if (mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_WPS_XLS) {
                mimeTypeId = Constants.FORMAT_TYPE_DOC_EXCEL_WPS;
            }
            docRes.setMimeTypeId(mimeTypeId);
            sampleToComFlag = true;
        }
        // 修改文档记录,记录日志,发布文档消息
        DocResourcePO newDoc = null;
        DocMimeTypePO mime = docMimeTypeManager.getDocMimeTypeById(docRes.getMimeTypeId());
        if (mime.getFormatType() != Constants.FORMAT_TYPE_DOC_FILE) {
        	if (docRes.isVersionEnabled()) {
                String fileId = request.getParameter("fileId");
                this.docVersionInfoManager.saveDocVersionInfo(versionComment, originalFileId, docRes);
                if (Strings.isNotBlank(originalFileId) && docRes.isUploadOfficeOrWps()) {
                    docRes.setSourceId(NumberUtils.toLong(fileId));
                }
            }
        	
            FolderItemDoc fi = new FolderItemDoc(docRes);
            fi.setName(docName);
            fi.setContentTypeId(contentTypeId);
            fi.setDesc(description);
            fi.setKeywords(keyword);
            fi.setVersionComment(versionComment);

            DocBodyPO docBody = new DocBodyPO();
            Date bodyCreateDate = Datetimes.parseDatetime(request.getParameter("bodyCreateDate"));
            if (bodyCreateDate != null) {
                docBody.setCreateDate(new Date(bodyCreateDate.getTime()));
            }
            try {
                bind(request, docBody);
            } catch (Exception e) {
                log.error("编辑器页面绑定body对象", e);
            }
            //上传文档  编辑后  转化为复合文档
            if (sampleToComFlag) {
                docHierarchyManager.saveBody(docRes.getId(), docBody);
            }
            fi.setBody(docBody.getContent());
            String attFlag = null;
            try {
                attFlag = attachmentManager.update(ApplicationCategoryEnum.doc, docResId, docResId, request);
            } catch (Exception e) {
                log.error("更新附件", e);
            }
            boolean hasAtt = com.seeyon.ctp.common.filemanager.Constants.isUploadLocaleFile(attFlag);
            fi.setHasAtt(hasAtt);

            try {
                newDoc = docHierarchyManager.updateDocWithoutAcl(fi, userId);
                docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(),
                        DocActionEnum.edit.key(), docResId, "");
            } catch (BusinessException e) {
                log.error("复合文档的更新", e);
            }
            
            /***
             * 完善功能，启用历史版本时，会清理多余的附件     pxb
             */
            //从库中查出当前在库中记录的附件id。
            List<Attachment> attachments = attachmentManager.getByReference(docResId, docResId);
            if (attachments != null) {
                //从前台页面获得当前要上传的附件ids，
                String[] strJsps = request.getParameterValues("input_file_id");
                List<String> willDeleteUrls = this.calculationDiff(strJsps, attachments);

                if (willDeleteUrls != null) {
                    for (String url : willDeleteUrls) {
                        try {
                            fileManager.deleteFile(Long.valueOf(url), true);
                        } catch (BusinessException e) {
                            log.error("", e);
                        }

                    }
                }
            }

        } else { //上传的文档
        	docRes.setFavoriteSource(null);
        	if(docRes.getSourceType()==null||docRes.getSourceType()==0){
            	docRes.setSourceType(0);
        	}
            DocEditVO vo = new DocEditVO(docRes);
            boolean replace = Boolean.parseBoolean(request.getParameter("fileReplaceFlag"));

            if (replace) {
                V3XFile the_file = this.saveV3xFile(ApplicationCategoryEnum.doc, request);
                vo.setFile(the_file);
                try {
                    if (docRes.isVersionEnabled()) {
                        this.docVersionInfoManager.saveDocVersionInfo(versionComment, docRes);
                    }
                    if (docLibType != Constants.PERSONAL_LIB_TYPE.byteValue()) {
                        String orgIds = Constants.getOrgIdsOfUser(userId);
                        newDoc = docHierarchyManager.replaceDoc(docRes, the_file, userId, orgIds, docRes.isVersionEnabled());
                    } else {
                        newDoc = docHierarchyManager.replaceDocWithoutAcl(docRes, the_file, userId, docRes.isVersionEnabled());
                    }
                } catch (BusinessException e) {
                    log.error("替换文件", e);
                }
            } else {
                vo.setFile(null);
                //不是替换，就必须更新一次附件名称
                if (!replace) {
                    V3XFile v3xFile = fileManager.getV3XFile(docRes.getSourceId());
                    v3xFile.setFilename(docName);
                    fileManager.update(v3xFile);
                }
                

                //因为office控件都是以2003格式保存，故把扩展名的s去掉
                if (Strings.isNotBlank(docName)) {
                    String[] suffix = docName.split("[.]");
                    if (suffix != null && suffix.length > 1) {
                        int len = suffix.length;
                        if ("docx".equalsIgnoreCase(suffix[len - 1])) {
                            docName = suffix[len - 2] + ".doc";
                        } else if ("xlsx".equalsIgnoreCase(suffix[len - 1])) {
                            docName = suffix[len - 2] + ".xls";
                        } else if ("pptx".equalsIgnoreCase(suffix[len - 1])) {
                            docName = suffix[len - 2] + ".ppt";
                        }
                    }
                }
                vo.setName(docName);
                vo.setContentTypeId(contentTypeId);
                vo.setDesc(description);
                vo.setKeywords(keyword);
                vo.setVersionComment(versionComment);
                // 附件和关联文档存储
                String attFlag = null;
                try {
                    attachmentManager.deleteByReference(docResId, docResId);
                    attFlag = attachmentManager.create(ApplicationCategoryEnum.doc, docResId, docResId, request);
                } catch (Exception e) {
                    log.error("更新附件", e);
                }
                boolean hasAtt = com.seeyon.ctp.common.filemanager.Constants.isUploadLocaleFile(attFlag);
                vo.getDocResource().setHasAttachments(hasAtt);
                try {
                    boolean remainOldFile = docRes.isVersionEnabled() && replace;
                    newDoc = docHierarchyManager.updateFileWithoutAcl(vo, docLibType, remainOldFile);
                } catch (BusinessException e) {

                    //更新上传的文档出现异常时，做如下操作：1，删除掉已经上传上去的文件，2删除file表中的记录   pxb
                    Long theFileId = vo.getFile().getId();
                    try {
                        fileManager.deleteFile(theFileId, true);
                    } catch (BusinessException e1) {
                        log.error("", e1);
                    }
                    log.error("更新文件[id=" + docResId + "]时出现异常:", e);
                    super.rendJavaScript(response, "alert('对不起，出错了！');" + "parent.returnValueAndClose('false');");
                    return null;

                }
            }
        }

        // 日志
        if (!docLibType.equals(Constants.PERSONAL_LIB_TYPE)) {
            operationlogManager.insertOplog(docResId, docRes.getParentFrId(), ApplicationCategoryEnum.doc,
                    ActionType.LOG_DOC_EDIT_DOCUMENT_BODY, ActionType.LOG_DOC_EDIT_DOCUMENT_BODY + ".desc",
                    AppContext.currentUserName(), docName);
        }
      //保存应用日志
        appLogManager.insertLog(AppContext.getCurrentUser(),AppLogAction.Doc_Wd_Update,AppContext.currentUserName(),docRes.getFrName());


        // 更新订阅文档
        docAlertLatestManager.addAlertLatest(newDoc, Constants.ALERT_OPR_TYPE_EDIT, userId, new Date(),
                Constants.DOC_MESSAGE_ALERT_MODIFY_EDIT, null);

        this.updateIndex(docResId);
        return null;
    }

    /***
     * 计算需要删除掉的fileurl
     * @param jspParams
     * @param attachments
     * @return
     */
    private List<String> calculationDiff(String[] jspParams, List<Attachment> attachments) {
        //后台urls-前台urls = 要删除的urls
        List<String> attIds = new ArrayList<String>();

        List<String> attDelIds = new ArrayList<String>();
        for (Attachment att : attachments) {
            attIds.add(String.valueOf(att.getFileUrl()));
        }
        if (null != jspParams) {
            for (String id : jspParams) {
                if (!attIds.contains(id))
                    attDelIds.add(id);
            }

        }

        return attDelIds;
    }

    private void updateIndex(Long docResId) {
        // 更新全文检索
        try {
            if (AppContext.hasPlugin("index")) {
                indexManager.update(docResId, ApplicationCategoryEnum.doc.getKey());
                //更新该id的映射文件对应的全文检索
                docHierarchyManager.updateLink(docResId);
            }
        } catch (Exception e) {
            logger.error("更新文档[id=" + docResId + "]全文检索信息时出现异常：", e);
        }
    }

    /** 保存V3xFile对象，文件替换时候使用  */
    public V3XFile saveV3xFile(ApplicationCategoryEnum category, HttpServletRequest request) {
        String fileUrl = request.getParameter(Constants.FILEUPLOAD_INPUT_NAME_fileUrl);
        String mimeType = request.getParameter(Constants.FILEUPLOAD_INPUT_NAME_mimeType);
        String size = request.getParameter(Constants.FILEUPLOAD_INPUT_NAME_size);
        String createdate = request.getParameter(Constants.FILEUPLOAD_INPUT_NAME_createDate);
        String filename = request.getParameter(Constants.FILEUPLOAD_INPUT_NAME_filename);
        String type = request.getParameter(Constants.FILEUPLOAD_INPUT_NAME_type);
        String needClone = request.getParameter(Constants.FILEUPLOAD_INPUT_NAME_needClone);
        String description = request.getParameter(Constants.FILEUPLOAD_INPUT_NAME_description);

        if (fileUrl == null || mimeType == null || size == null || createdate == null || filename == null
                || type == null || needClone == null) {
            return null;
        }

        Date originalCreateDate = Datetimes.parseDatetime(createdate);
        V3XFile file = new V3XFile();
        file.setCategory(category.key());
        file.setType(new Integer(type));
        file.setFilename(filename);
        file.setMimeType(mimeType);
        file.setSize(Long.valueOf(size));
        file.setDescription(description);

        User user = AppContext.getCurrentUser();
        file.setCreateMember(user.getId());
        file.setAccountId(user.getAccountId());

        boolean _needClone = Boolean.parseBoolean(needClone);
        if (_needClone) {
            Long newFileId = UUIDLong.longUUID();
            Date newCreateDate = new Date();
            try {
                fileManager.clone(Long.valueOf(fileUrl), originalCreateDate, newFileId, newCreateDate);
            } catch (Exception e) {
                log.error("Clone 附件", e);
            }
            file.setId(newFileId);
            file.setCreateDate(newCreateDate);
        } else {
            file.setId(Long.valueOf(fileUrl));
            file.setCreateDate(originalCreateDate);
        }
        fileManager.save(file);
        return file;
    }

    /** 添加一个文档  */
    public ModelAndView addDocument(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return this.addVariousDocument(request, response, false);
    }

    /**个人分享     */
    public ModelAndView addShareDocument(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setAttribute("personalShare", Boolean.TRUE);
        return this.addVariousDocument(request, response, false);
    }
    /**
     * 新的新建文档
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView theNewAddVariousDocument(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	boolean isProject = false;
    	String openFrom = request.getParameter("openFrom");
    	if("project".equals(openFrom)) {
    		isProject = true;
    	}
        Long userId = AppContext.currentUserId();
        boolean parentCommentEnabled = BooleanUtils.toBoolean(request.getParameter("parentCommentEnabled"));
        boolean parentRecommendEnable = BooleanUtils.toBoolean(request.getParameter("parentRecommendEnable"));
        boolean parentVersionEnabled = BooleanUtils.toBoolean(request.getParameter("parentVersionEnabled"));
        long contentTypeId = NumberUtils.toLong(request.getParameter("contentTypeId"), Constants.DOCUMENT);
        Long docLibId = Long.valueOf(request.getParameter("docLibId"));
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        Long mimeTypeId = Long.valueOf(request.getParameter("mimeTypeId"));
        Long folderId = Long.valueOf(request.getParameter("resId"));

        Potent potent = docAclManager.getAclVO(folderId);
        if (!potent.isAll() && !potent.isEdit() && !potent.isCreate()) {
            log.warn(AppContext.currentUserName() + ",新建文档安全越权");
            return null;
        }

        Map<String, String> docEditDomain = ParamUtil.getJsonDomain("contentDiv");
        docEditDomain.putAll(ParamUtil.getJsonDomain("frName"));
        docEditDomain.putAll(ParamUtil.getJsonDomain("contentType"));
        Map metaDataInfo = ParamUtil.getJsonDomain("extendDiv");

        String docName = docEditDomain.get("name");
        Long docId = Long.valueOf(docEditDomain.get("id"));
        String description = docEditDomain.get("description");
        String keyword = docEditDomain.get("keyword");
        DocTypePO contentType = contentTypeManager.getContentTypeById(contentTypeId);
        String phaseIdStr = StringUtils.defaultString(request.getParameter("projectPhaseId"));
        Map<String, Comparable> paramap = this.getMetadataInfo(metaDataInfo);
        
        String bodyType = null;
        String contentString = null;
        
        // 将内容保存在DocBody中
        DocBodyPO docBody = new DocBodyPO();
        docBody.setCreateDate(new Date());
        CtpContentAll contentAll = MainbodyService.getInstance().getContent(ModuleType.getEnumByKey(3), docId);
        // 内容类型分为为html和非html
        if(mimeTypeId == 22) {
            contentString = contentAll.getContent();
            bodyType = "HTML";
        } else {
            Long contentId = contentAll.getContentDataId();
            contentString = contentId.toString();
            if(mimeTypeId == 23) {
                bodyType = "OfficeWord"; 
            } else if(mimeTypeId == 24) {
                bodyType = "OfficeExcel"; 
            } else if(mimeTypeId == 25) {
                bodyType = "WpsWord";
            } else {
                bodyType = "WpsExcel"; 
            }
        }
        docBody.setContent(contentString);
        docBody.setBodyType(bodyType);        
        DocResourcePO dr = docHierarchyManager.createDocWithoutAcl(docId,mimeTypeId,docName, description, keyword, docLibId,
                folderId, userId, parentCommentEnabled, parentVersionEnabled, parentRecommendEnable, contentTypeId,
                paramap);
        Long newId = dr.getId();
        docHierarchyManager.saveBody(newId, docBody);
        
        if (isProject) {
            if (!String.valueOf(TaskConstants.PROJECT_PHASE_ALL).equals(phaseIdStr) && Strings.isNotBlank(phaseIdStr)) {
                projectPhaseEventManager.save(new ProjectPhaseEvent(ApplicationCategoryEnum.doc.key(), docId,
                        NumberUtils.toLong(phaseIdStr)));
            }
        }
        if (!contentType.getIsSystem() && contentType.getStatus() == Constants.CONTENT_TYPE_DRAFT) {
            contentType.setStatus(Constants.CONTENT_TYPE_PUBLISHED);
            if (isProject) {
                contentTypeManager.updateContentType(contentType, false, null);
            } else {
                contentTypeManager.setContentTypePublished(contentType.getId());
            }
            this.metadataDefManager.updateMetadataDef4ContentType(contentType);
        }

        docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(), DocActionEnum.create.key(),
                docId, "create");
        String attFlag = null;
        try {
            attFlag = attachmentManager.create(ApplicationCategoryEnum.doc, docId, docId, request);
        } catch (Exception e) {
            log.error("保存附件", e);
        }

        //将内容保存在是否有附件
        boolean hasAtt = com.seeyon.ctp.common.filemanager.Constants.isUploadLocaleFile(attFlag);
         // 对文档大小的更新
        try {
            if (hasAtt) {
                docHierarchyManager.updateDocSize(docId, docBody, attachmentManager.getByReference(docId));
            } else {
                docHierarchyManager.updateDocSize(docId, docBody, new ArrayList<Attachment>());
            }
        } catch (BusinessException e) {
            log.error("更新文档大小", e);
        }

        // 更新订阅文档
        docAlertLatestManager.addAlertLatest(dr, Constants.ALERT_OPR_TYPE_ADD, userId, new Date(),
                Constants.DOC_MESSAGE_ALERT_ADD_DOC, null);

        // 全文检索
        try {
            if (AppContext.hasPlugin("index")) {
                indexManager.add(docId, ApplicationCategoryEnum.doc.getKey());
            }
        } catch (Exception e) {
            log.error("全文检索入库", e);
        }
        //个人分享页面
        if ("true".equals(request.getParameter("personalShare")) && !"section".equals(request.getParameter("from"))) {
        	DocResourcePO jsonDoc=new DocResourcePO(dr.getId());
        	jsonDoc.setFrName(Functions.toHTML(dr.getFrName()));
        	jsonDoc.setMimeTypeId(-1L);
        	String vForBorrowS = SecurityHelper.digest(request.getParameter("resId"),request.getParameter("docId"),21,
        			request.getParameter("docLibType"),Boolean.FALSE,request.getParameter("all"),request.getParameter("edit"),request.getParameter("add"),request.getParameter("readonly"),request.getParameter("browse"),request.getParameter("list"));
        	jsonDoc.setvForBorrowS(vForBorrowS);
            String script = "<script type='text/javascript'> top.frames['main'].fnCloseCreateDocDialog('" + Strings.escapeJavascript(JSONUtil.toJSONString(jsonDoc)) + "');</script>";
            request.setAttribute("returnString", script);
            return new ModelAndView("apps/doc/personal/value");
        }else if("section".equals(request.getParameter("from"))){
            super.rendJavaScript(response, "if(top.frames['main'] && top.frames['main'].frames['body'] && top.frames['main'].frames['body'].pTemp){top.frames['main'].frames['body'].refreshTaskPortlet('projectDocSetion');setTimeout(function(){if(top.frames['main'].frames['body'].pTemp){top.frames['main'].frames['body'].pTemp.dialog.close();}},200);}");
            return null;
        }

        if (isProject) {
            String pid = request.getParameter("projectId");
            return super.redirectModelAndView("/project.do?method=projectInfo&projectId=" + pid + "&phaseId="
                    + phaseIdStr);
        } else {
            return null;
        }
    }
    /**
     * 由于添加文档和添加项目文档两个方法重复代码过多，不利维护，进行简单抽取
     * @param isProject		是否在关联项目页面添加项目文档
     */
    @SuppressWarnings("unchecked")
    private ModelAndView addVariousDocument(HttpServletRequest request, HttpServletResponse response, boolean isProject)
            throws Exception {
        Long userId = AppContext.currentUserId();
        Long docLibId = Long.valueOf(request.getParameter("docLibId"));
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        String docName = request.getParameter("docName");
        boolean parentCommentEnabled = BooleanUtils.toBoolean(request.getParameter("parentCommentEnabled"));
        boolean parentRecommendEnable = BooleanUtils.toBoolean(request.getParameter("parentRecommendEnable"));
        boolean parentVersionEnabled = BooleanUtils.toBoolean(request.getParameter("parentVersionEnabled"));
        long contentTypeId = NumberUtils.toLong(request.getParameter("contentTypeId"), Constants.DOCUMENT);
        DocTypePO contentType = contentTypeManager.getContentTypeById(contentTypeId);
        String phaseIdStr = StringUtils.defaultString(request.getParameter("projectPhaseId"));

        Map<String, Comparable> paramap = this.getMetadataInfo(request);
        String description = request.getParameter("description");
        String keyword = request.getParameter("keyword");

        DocBodyPO docBody = new DocBodyPO();
        Date bodyCreateDate = Datetimes.parseDatetime(request.getParameter("bodyCreateDate"));
        if (bodyCreateDate != null)
            docBody.setCreateDate(new Date(bodyCreateDate.getTime()));
        try {
            bind(request, docBody);
        } catch (Exception e) {
            log.error("编辑器页面绑定body", e);
        }

        Long folderId = Long.valueOf(request.getParameter("resId"));
        DocResourcePO dr = docHierarchyManager.createDocWithoutAcl(docName, description, keyword, docBody, docLibId,
                folderId, userId, parentCommentEnabled, parentVersionEnabled, parentRecommendEnable, contentTypeId,
                paramap);
        Long id = dr.getId();
        if (isProject) {
            if (!String.valueOf(TaskConstants.PROJECT_PHASE_ALL).equals(phaseIdStr) && Strings.isNotBlank(phaseIdStr)) {
                projectPhaseEventManager.save(new ProjectPhaseEvent(ApplicationCategoryEnum.doc.key(), id,
                        NumberUtils.toLong(phaseIdStr)));
            }
        }
        if (!contentType.getIsSystem() && contentType.getStatus() == Constants.CONTENT_TYPE_DRAFT) {
            contentType.setStatus(Constants.CONTENT_TYPE_PUBLISHED);
            if (isProject) {
                contentTypeManager.updateContentType(contentType, false, null);
            } else {
                contentTypeManager.setContentTypePublished(contentType.getId());
            }
            this.metadataDefManager.updateMetadataDef4ContentType(contentType);
        }

        docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(), DocActionEnum.create.key(),
                id, "create");
        String attFlag = null;
        try {
            attFlag = attachmentManager.create(ApplicationCategoryEnum.doc, id, id, request);
        } catch (Exception e) {
            log.error("保存附件", e);
        }

        // 存储附件
        boolean hasAtt = com.seeyon.ctp.common.filemanager.Constants.isUploadLocaleFile(attFlag);
        try {
            if (hasAtt) {
                docHierarchyManager.updateDocSize(id, docBody, attachmentManager.getByReference(id));
            } else {
                docHierarchyManager.updateDocSize(id, docBody, new ArrayList<Attachment>());
            }
        } catch (BusinessException e) {
            log.error("更新文档大小", e);
        }

        // 更新订阅文档
        docAlertLatestManager.addAlertLatest(dr, Constants.ALERT_OPR_TYPE_ADD, userId, new Date(),
                Constants.DOC_MESSAGE_ALERT_ADD_DOC, null);

        // 全文检索
        try {
            if (AppContext.hasPlugin("index")) {
                indexManager.add(id, ApplicationCategoryEnum.doc.getKey());
            }
        } catch (Exception e) {
            log.error("全文检索入库", e);
        }
        //个人分享页面
        if (request.getAttribute("personalShare") != null) {
            String script = "<script type='text/javascript'>parent.fnCloseCreateDocDialog('" + Strings.escapeJavascript(JSONUtil.toJSONString(dr)) + "');</script>";
            request.setAttribute("returnString", script);
            return new ModelAndView("apps/doc/personal/value");
        }

        if (isProject) {
            String pid = request.getParameter("projectId");
            return super.redirectModelAndView("/project.do?method=projectInfo&projectId=" + pid + "&phaseId="
                    + phaseIdStr);
        } else {
            String flag = StringUtils.defaultIfEmpty(request.getParameter("flag"), "");
            return super.redirectModelAndView("/doc.do?method=rightNew&docLibId=" + docLibId + "&docLibType="
                    + docLibType + "&resId=" + folderId + "&frType=" + request.getParameter("frType")
                    + "&isShareAndBorrowRoot=false" + "&all=" + request.getParameter("all") + "&edit="
                    + request.getParameter("edit") + "&add=" + request.getParameter("add") + "&readonly="
                    + request.getParameter("readonly") + "&browse=" + request.getParameter("browse") + "&list="
                    + request.getParameter("list") + "&parentCommentEnabled=" + parentCommentEnabled
                    + "&parentRecommendEnable=" + parentRecommendEnable + "&parentVersionEnabled="
                    + parentVersionEnabled + "&flag=" + flag);
        }

    }

    /** 添加项目文档  */
    public ModelAndView addProDocument(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return this.addVariousDocument(request, response, true);
    }

    /** 文档上传  */
    public ModelAndView docUpload(HttpServletRequest request, HttpServletResponse response) throws Exception {
        StringBuilder _fileName = new StringBuilder();
        int dupSize = 0;
        try {
            Long docLibId = Long.valueOf(0);
            Byte docLibType = 0;
            Long docResourceId = Long.valueOf(0);
            boolean parentCommentEnabled = false;
            boolean parentVersionEnabled = false;
            boolean parentRecommendEnable = false;
            Long userId = AppContext.currentUserId();
            String projectId = request.getParameter("projectId");
            Long projectPhaseId = NumberUtils.toLong(request.getParameter("projectPhaseId"),
                    TaskConstants.PROJECT_PHASE_ALL);
            if (Strings.isNotBlank(projectId)) {
                //从首页上传文件
                boolean isPhase = projectPhaseId != TaskConstants.PROJECT_PHASE_ALL;
                Long folderId = isPhase ? projectPhaseId : Long.valueOf(projectId);
                DocResourcePO projectFolder = docHierarchyManager.getProjectFolderByProjectId(folderId, isPhase);
                if (projectFolder == null) {
                    super.printV3XJS(response);
                    StringBuilder sb = new StringBuilder();
                    sb.append(" alert('" + Constants.getDocI18nValue("doc.forder.project.noexist") + "');");
                    super.rendJavaScript(response, sb.toString());
                    return null;
                }

                docResourceId = projectFolder.getId().longValue();
                DocLibPO lib = docLibManager.getDocLibById(projectFolder.getDocLibId());
                docLibType = lib.getType();
                docLibId = projectFolder.getDocLibId();
                parentCommentEnabled = projectFolder.getCommentEnabled();
                parentVersionEnabled = projectFolder.isVersionEnabled();
                parentRecommendEnable = projectFolder.getRecommendEnable();
            } else {
                docLibId = Long.valueOf(request.getParameter("docLibId"));
                docLibType = Byte.valueOf(request.getParameter("docLibType"));
                docResourceId = Long.valueOf(request.getParameter("docResourceId"));

                // 目标文档夹有效性判断
                if (!docHierarchyManager.docResourceExist(docResourceId)) {
                    super.rendJavaScript(response, "window.location.reload(true);");
                    return null;
                }
                parentCommentEnabled = Boolean.parseBoolean(request.getParameter("parentCommentEnabled"));
                parentVersionEnabled = Boolean.parseBoolean(request.getParameter("parentVersionEnabled"));
                parentRecommendEnable = Boolean.parseBoolean(request.getParameter("parentRecommendEnable"));
            }
            List<V3XFile> list = null;
            try {
                list = fileManager.create(ApplicationCategoryEnum.doc, request);
            } catch (BusinessException e) {
                log.error("通过fileManager保存file", e);
            }
            if (CollectionUtils.isEmpty(list)) {
                return null;
            }
            String sysTemp = SystemEnvironment.getSystemTempFolder();
            String docTemp = sysTemp + "/doctemp/";
            File temp = new File(docTemp);
            temp.mkdir();
            for (V3XFile the_file : list) {
                DocResourcePO dr = null;
                try {
                    if (docLibType == Constants.PERSONAL_LIB_TYPE.byteValue()) {
                      DocStorageSpacePO space = docSpaceManager.getDocSpaceByUserId(userId);
                      if (space.getTotalSpaceSize() < (the_file.getSize() + space.getUsedSpaceSize()))
                          throw new BusinessException(ResourceUtil.getString("doc.personal.storage.not.enough"));
                    }
                    dr = docHierarchyManager.uploadFileWithoutAcl(the_file, docLibId, docLibType, docResourceId,
                            userId, parentCommentEnabled, parentVersionEnabled, parentRecommendEnable);
                    // 与项目阶段关联
                    if (Strings.isNotBlank(projectId) && projectPhaseId != TaskConstants.PROJECT_PHASE_ALL) {
                        projectPhaseEventManager.save(new ProjectPhaseEvent(ApplicationCategoryEnum.doc.key(),
                                dr.getId(), projectPhaseId));
                    }
                } catch (BusinessException e) {
                    //如果有异常，则需要执行恢复操作：1，将附件删除，2，将file表记录删除  一个方法即可实现：  pxb
                    fileManager.deleteFile(the_file.getId(), true);
                    if ("doc_upload_dupli_name_failure_alert".equals(e.getMessage())) {
                        _fileName.append(the_file.getFilename() + " ");
                        dupSize++;
                        continue;
                    } else {
                        super.rendJavaScript(response, "alert('" + e.getMessage()+ "');");
                        return null;
                    }

                }

                Long newId = dr.getId();
                // 记录操作日志
                operationlogManager.insertOplog(newId, docResourceId, ApplicationCategoryEnum.doc,
                        ActionType.LOG_DOC_UPLOAD, ActionType.LOG_DOC_UPLOAD + ".desc", AppContext.currentUserName(),
                        the_file.getFilename());
                // 更新订阅文档
                docAlertLatestManager.addAlertLatest(dr, Constants.ALERT_OPR_TYPE_ADD, userId, new Date(),
                        Constants.DOC_MESSAGE_ALERT_ADD_DOC, null);

                // 全文检索
                try {
                    if (AppContext.hasPlugin("index")) {
                        indexManager.add(dr.getId(), ApplicationCategoryEnum.doc.getKey());
                    }
                } catch (Exception e) {
                    log.error("全文检索入库", e);
                }

                // 上传图片类或PDF格式文件的处理：图片类转换成html格式存储，PDF保存对应正文
                if (dr.isImage() || dr.isPDF()) {
                    DocBodyPO body = new DocBodyPO();
                    body.setCreateDate(new Date());
                    body.setBodyType(dr.isImage() ? com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML
                            : com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_PDF);
                    body.setContent(dr.getSourceId().toString());
                    this.docHierarchyManager.saveBody(newId, body);
                }

                docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(),
                        DocActionEnum.upload.key(), newId, "upload");

            }
            StringBuilder js = new StringBuilder();
            if (Strings.isNotBlank(_fileName.toString())) {
                js.append("alert(parent.v3x.getMessage('DocLang.doc_upload_dupli_name_failure_alert','"
                        + _fileName.toString().replaceAll("'", "\\\\'").replaceAll("\"", "\\\"") + "'));");
            }
            if (list.size() > dupSize) {
                if (Strings.isNotBlank(projectId)) {
                    js.append("parent.location.reload(true);");
                } else {
                    js.append("parent.parent.rightFrame.location.reload(true);");
                }
            }
            if (Strings.isNotBlank(js.toString())) {
                super.rendJavaScript(response, js.toString());
            }
        } catch (BusinessException e) {
            super.rendJavaScript(response, "alert(parent.v3x.getMessage('DocLang." + e.getMessage() + "'));");
        }
        return null;
    }

    // 创建快捷方式
    public ModelAndView createLink(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        Long userId = AppContext.currentUserId();
        String[] docResIds = request.getParameterValues("id");
        Long destDocLibId = Long.valueOf(request.getParameter("destLibId"));
        Long destFolderId = Long.valueOf(request.getParameter("destResId"));
        String slibType = request.getParameter("destLibType");
        String destName = request.getParameter("destName");
        destName = URLDecoder.decode(URLDecoder.decode(destName, "utf-8"),"utf-8");
        byte destLibType = Constants.PERSONAL_LIB_TYPE;
        if (slibType != null) {
            destLibType = Byte.parseByte(slibType);
        }
        try {
            String orgIds = Constants.getOrgIdsOfUser(userId);
            for (String docResId : docResIds) {
                // 有效性判断
                if (!docHierarchyManager.docResourceExist(Long.valueOf(docResId))) {
                    continue;
                }
                DocResourcePO dr = null;
                if (destLibType == Constants.PERSONAL_LIB_TYPE.byteValue()) {
                    dr = docHierarchyManager.createLinkWithoutAcl(Long.valueOf(docResId), destDocLibId, destFolderId,
                            userId, "", "");
                } else {
                    dr = docHierarchyManager.createLink(Long.valueOf(docResId), destDocLibId, destFolderId, userId,
                            orgIds);
                }
                Long newId = dr.getId();
                DocResourcePO newLink = docHierarchyManager.getDocResourceById(newId);
				// 记录操作日志
				operationlogManager.insertOplog(newId, destFolderId,
						ApplicationCategoryEnum.doc,
						ActionType.LOG_DOC_ADD_SHORTCUT,
						ActionType.LOG_DOC_ADD_SHORTCUT + ".desc",
						AppContext.currentUserName(), newLink.getFrName(),
						destName);
                if (newLink.getFrType() != Constants.LINK_FOLDER) {
                    // 更新订阅文档
                    docAlertLatestManager.addAlertLatest(dr, Constants.ALERT_OPR_TYPE_ADD, userId, new Date(),
                            Constants.DOC_MESSAGE_ALERT_ADD_DOC, null);
                }
                //增加映射文件的全文检索
                try {
                    if (AppContext.hasPlugin("index")) {
                        indexManager.add(newId, ApplicationCategoryEnum.doc.getKey());
                    }
                } catch (Exception e) {
                    log.error("全文检索入库", e);
                }
            }
            String close = "";
            if ((Boolean) BrowserFlag.OpenWindow.getFlag(request)) {
                close = "parent.parent.window.close();";
            } else {
                close = "top.winMove.close();";
            }
            response.setContentType("text/html;charset=UTF-8");
            super.rendJavaScript(response, "alert(parent.v3x.getMessage('DocLang.doc_send_shortcut_success_alert', '"
                    + destName + "'));" + close);
        } catch (BusinessException e) {
            super.rendJavaScript(response, "parent.enableButtonsAndAlertMsg('" + e.getMessage() + "');");
        }
        return null;
    }

    // 文档替换
    public ModelAndView docReplace(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        V3XFile the_file = null;
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        Long docResId = NumberUtils.toLong(request.getParameter("docResId"));
        Long userId = AppContext.currentUserId();
        List<V3XFile> list;
        // 得到上传文件
        try {
            list = fileManager.create(ApplicationCategoryEnum.doc, request);
            if (CollectionUtils.isNotEmpty(list)) {
                the_file = list.get(0);
            }
        } catch (BusinessException e) {
            log.error("保存上传的文件时出现异常[id=" + docResId + "]：", e);
        }
        DocResourcePO oprDr = docHierarchyManager.getDocResourceById(docResId);
        if (oprDr == null) {
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("window.location.reload(true);");
            out.println("</script>");
            return super.refreshWorkspace();
        }
        String oldFrName = oprDr.getFrName();
        String newFrName = the_file.getFilename();

        boolean versionEnabled = oprDr.isVersionEnabled();
        DocResourcePO newDr = null;
        try {
            if (versionEnabled) {
                String versionComment = request.getParameter("versionComment");
                this.docVersionInfoManager.saveDocVersionInfo(versionComment, oprDr);
            }
            //删除附件收藏的标记
            oprDr.setFavoriteSource(null);
            oprDr.setSourceType(0);
            if (docLibType != Constants.PERSONAL_LIB_TYPE.byteValue()) {
                String orgIds = Constants.getOrgIdsOfUser(userId);
                newDr = docHierarchyManager.replaceDoc(oprDr, the_file, userId, orgIds, versionEnabled);
            } else {
                newDr = docHierarchyManager.replaceDocWithoutAcl(oprDr, the_file, userId, versionEnabled);
            }
        } catch (BusinessException e) {
            log.error("替换文件", e);
        }

        // 更新订阅文档
        docAlertLatestManager.addAlertLatest(newDr, Constants.ALERT_OPR_TYPE_EDIT, userId, new Date(),
                Constants.DOC_MESSAGE_ALERT_MODIFY_EDIT, null);

        this.updateIndex(docResId);

        // 替换文档记录日志
        this.operationlogManager.insertOplog(docResId, docResId, ApplicationCategoryEnum.doc,
                ActionType.LOG_DOC_REPLACE, ActionType.LOG_DOC_REPLACE + ".desc", AppContext.currentUserName(),
                oldFrName, newFrName);
            

        docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(),
                DocActionEnum.replace.key(), docResId, "replace");
        if ("true".equals(request.getParameter("isNew"))) {
            super.rendJavaScript(response, "top.fnRefresh();");
        } else {
            super.rendJavaScript(response, "parent.parent.rightFrame.location.reload(true);");
        }
        return null;
    }

    /** 进入归档界面  */
    public ModelAndView docPigeonhole(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/docPigeonhole")
        			.addObject("isNotAdmin", !AppContext.getCurrentUser().isAdmin());
    }

    /** 归档  
     * @throws BusinessException */
    public ModelAndView pigeonhole(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        try {
            Long userId = AppContext.currentUserId();
            String appEnumKey = request.getParameter("appName");
            String ids = request.getParameter("ids");
            String atts = request.getParameter("atts");
            Long destLibId = Long.valueOf(request.getParameter("destLibId"));
            Long destFolderId = Long.valueOf(request.getParameter("destResId"));
            String type = request.getParameter("pigeonhole");
            Integer pigeonholeType = null;
            if (Strings.isNotBlank(type)) {
                pigeonholeType = Integer.valueOf(type);
            }

            StringBuilder newIds = new StringBuilder();
            String[] idsarray = ids.split(",");
            String[] attsarray = null;
            int attsize = 0;
            boolean flag = false;
            if (atts != null) {
                attsarray = atts.split(",");
                attsize = attsarray.length;
            }
            for (int i = 0; i < idsarray.length; i++) {
                Long sourceId = Long.valueOf(idsarray[i]);
                boolean has = false;
                if (attsize > i) {
                    has = Boolean.parseBoolean(attsarray[i]);
                }

                Long newId = docFilingManager.pigeonholeAsLinkWithoutAcl(Integer.valueOf(appEnumKey), sourceId, has,
                        destLibId, destFolderId, userId, pigeonholeType);
                
                if(newId != null){
                	if(flag){
                		newIds.append(",");
                	}
                    newIds.append(newId);
                    flag = true;
                }
            }

            super.rendJavaScript(response, "parent.window.pigeonholeCollBacks(\"" + newIds.toString() + "\");");

        } catch (BusinessException ex) {
            log.error("", ex);
            super.rendJavaScript(response, "parent.parent.window.document.getElementById('b1').disabled = false;"
                    + "parent.parent.window.document.getElementById('b2').disabled = false;"
                    + "alert(parent.v3x.getMessage('DocLang." + ex.getMessage() + "'));"
                    + "parent.window.pigeonholeCollBacks(\"failure\");");
        }
        return null;
    }

    /** 文档查看框架 */

    public ModelAndView docOpenIframe(HttpServletRequest request, HttpServletResponse response) throws IOException {
        ModelAndView modelView = new ModelAndView("apps/doc/docOpenIframe");
        // 历史版本信息
        if (Constants.VERSION_FLAG.equals(request.getParameter("versionFlag"))) {
            Long id = NumberUtils.toLong(request.getParameter("docVersionId"));
            DocVersionInfoPO dvi = this.docVersionInfoManager.getDocVersion(id);
            if (dvi == null) {
                super.rendJavaScript(response,
                        "alert(window.dialogArguments.v3x.getMessage('DocLang.doc_history_not_exist'));"
                                + "parent.window.returnValue = \"true\";" + "parent.close();");
                return null;
            }
            return modelView.addObject("docRes", dvi);
        }

        Long id = Long.valueOf(request.getParameter("docResId"));
        DocResourcePO dr = docHierarchyManager.getDocResourceById(id);

        // 文档有效性判断
        if (dr == null) {
            super.rendJavaScript(response,
                    "alert(window.dialogArguments.v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));"
                            + "parent.window.returnValue = \"true\";" + "parent.close();");
            return null;
        }

        // 链接判断
        if (dr.getFrType() == Constants.LINK) {
            dr = docHierarchyManager.getDocResourceById(dr.getSourceId());
            if (dr == null) {
                super.rendJavaScript(response, "alert(parent.v3x.getMessage('DocLang.doc_source_doc_no_exist'));"
                        + "parent.window.returnValue = \"true\";" + "parent.close();");
                return null;
            }
        }
        //SECURITY 访问安全检查
        if (!SecurityCheck.isLicit(request, response, ApplicationCategoryEnum.doc, AppContext.getCurrentUser(), id,
                null, null)) {
            return null;
        }
        modelView.addObject("docRes", dr);
        return modelView;
    }

    /**
     * 以只有id的方式进入打开界面，比如全文检索
     * 因为传过来的只有docResourceId，所以这里需要判断文档的类型， 根据不同类型采取不同打开方式
     * 复合文档+文件 文档链接 系统归档类型
     * @throws BusinessException 
     * @throws IOException 
     * @throws NumberFormatException 
     */
    public ModelAndView docOpenIframeOnlyId(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException, NumberFormatException, IOException {
    	ModelAndView ret = new ModelAndView("apps/doc/docOpenIframeOnlyId");
    	String url = null;
    	boolean isExist = false;
    	boolean isAcl = false;
    	Long docId = Long.valueOf(request.getParameter("docResId"));
    	int entrance = 6;
    	if("glwd".equals(request.getParameter("openFrom"))) {
    		entrance = 8;
    	}
    	String url2="";
    	long userId = AppContext.currentUserId();
    	Long baseDocId = null;
    	String baseObjectId = request.getParameter("baseObjectId");
    	if(Strings.isNotBlank(baseObjectId)) {
    		baseDocId = Long.valueOf(baseObjectId);
    		url2+="&baseObjectId="+baseObjectId;
    	}
    	String baseApp = request.getParameter("baseApp");
    	if(Strings.isNotBlank(baseApp)) {
    		url2+="&baseApp="+baseApp;
    	}
    	String info = docHierarchyManager.getValidInfo(docId, entrance, userId, baseDocId);
    	if(info.charAt(0) == '0') {
    		isExist = true;
    		if(info.charAt(1) == '0') {
        		isAcl = true;
        		url = info.substring(3);
        	}
    	}
    	DocResourcePO doc = docHierarchyManager.getDocResourceById(docId);
    	
        StringBuilder _url = new StringBuilder();
        _url.append(url).append(url2);
        if (Strings.isNotBlank(url)&&Strings.isNotBlank(request.getParameter("openFrom")) && url.indexOf("openFrom")==-1) {
            _url.append("&openFrom=").append(request.getParameter("openFrom"));
        }
        ret.addObject("docExist", isExist);
        if(null != doc){
        	ret.addObject("title", doc.getFrName());
        }
        ret.addObject("hasPermission", isAcl);
        ret.addObject("_url", _url.toString());
    	return ret;
    }

    /** 文档查看iframe */
    public ModelAndView docOpenView(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/docOpenView");
    }

    /** 查看文档正文 */
    public ModelAndView docOpenBody(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView ret = new ModelAndView("apps/doc/docOpenBody");
        User user = AppContext.getCurrentUser();
        boolean isHistory = Constants.VERSION_FLAG.equals(request.getParameter("versionFlag"));
        String resIdStr = request.getParameter(isHistory ? "docVersionId" : "docResId");
        Long resId = Long.valueOf(resIdStr);
        boolean isLink = false;
        //文档入口
        String entranceTypes = request.getParameter("entranceType");
        EntranceTypeEnum entranceType = EntranceTypeEnum.parseEntranceType(entranceTypes);
        if(!EntranceTypeEnum.historyVersion.equals(entranceType)) {
        	isLink = Constants.LINK == docHierarchyManager.getDocResourceById(resId).getFrType();
        }        
        long validateDocId = resId;
        if(EntranceTypeEnum.otherLibs.equals(entranceType) && !isLink) {
        	validateDocId = docHierarchyManager.getDocResourceById(resId).getParentFrId();
        }
        //SECURITY 访问安全检查
        // TODO(duanyl) 如果从关联文档打开，无需做安全性验证。但用此方式可能有风险，后续要改成成:(关联文档下)在公共文档库打开，走文档夹权限。
        if (!isHistory && !"true".equals(request.getParameter("isLink")) && !EntranceTypeEnum.associatedDoc.equals(entranceType)) {

            if (!SecurityCheck.isLicit(request, response, ApplicationCategoryEnum.doc, user, validateDocId, null, null)) {
                return null;
            }
        }
        ret.addObject("baseObjectId",validateDocId);
        byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        boolean isPersonal = (docLibType == Constants.PERSONAL_LIB_TYPE.byteValue());
        boolean isGroupLib = (docLibType == Constants.GROUP_LIB_TYPE.byteValue());
        DocResourcePO dr = null;
        DocVersionInfoPO dvi = null;
        if (isHistory) {
            dvi = this.docVersionInfoManager.getDocVersion(resId);
            dr = dvi.getDocResourceFromXml();
        } else {
            dr = docHierarchyManager.getDocResourceById(resId);
        }
        DocOpenBodyVO vo = new DocOpenBodyVO(dr);
        this.setFolderItemRef(vo);
        long mimeTypeId = dr.getMimeTypeId();
        DocMimeTypePO docMimeType = docMimeTypeManager.getDocMimeTypeById(mimeTypeId);
        ret.addObject("isImage", dr.isImage());
        if (docMimeType.isOffice()) {
            if (isHistory) {
                this.setBodyContent2VO(dvi.getDocBodyFromXml(), vo);
            } else {
                this.setBodyContent2VO(resId, vo);
            }
        } else if (dr.isImage() || (dr.isPDF() && AppContext.hasPlugin("pdf"))) {
            DocBodyPO docBody = isHistory ? dvi.getDocBodyFromXml() : docHierarchyManager.getBody(resId);
            try {
            	V3XFile file = this.fileManager.getV3XFile(dr.getSourceId());
                vo.setCreateDate(file.getCreateDate());
                vo.setvForDocDownload(SecurityHelper.digest(file.getId()));
            } catch (BusinessException e) {
                log.error("获取文件时出现异常[文件ID= " + dr.getSourceId() + "]", e);
            }
            if (docBody != null) {
                vo.setIsFile(true);
                vo.setBodyType(docBody.getBodyType());
                //				vo.setCreateDate(docBody.getCreateDate());
                if (dr.isImage()) {
                    vo.setBodyOfImage(dr.getSourceId(), vo.getCreateDate());
                } else {
                    vo.setBody(docBody.getContent());
                }
            } else {// 以下代码似乎无用，应该不会出现这种情况，为了容错?
                if (dr.isImage()) {
                    vo.setBodyType(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML);
                    vo.setBodyOfImage(dr.getSourceId(), vo.getCreateDate());
                } else {
                    vo.setBodyType(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_PDF);
                    vo.setBody(String.valueOf(dr.getSourceId()));
                }
            }
        } else {
            String bodyType = Constants.getBodyType(dr.getMimeTypeId());
            vo.setIsFile(true);
            V3XFile file = null;
            try {
                file = fileManager.getV3XFile(dr.getSourceId());
                vo.setCreateDate(file.getCreateDate());
                vo.setCreateDateString(file.getCreateDate().toString().substring(0, 10));
                vo.setvForDocDownload(SecurityHelper.digest(file.getId()));
            } catch (BusinessException e) {
                log.error("获取文件时出现异常[文件ID= " + dr.getSourceId() + "]", e);
            }
            vo.setFile(file);
            
            // ppt文件（104）或rtf文件转为html正文查看
            if (docMimeType.getId() == 104 || "text/rtf".equals(file.getMimeType())) {
                if (OfficeTransHelper.allowTrans(file)) {
                    ret.addObject("requireTrans", OfficeTransHelper.isOfficeTran());
                    ret.addObject("transUrl", OfficeTransHelper.buildCacheUrl(file, false));
                }
            }
            DocMimeTypePO mime = docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId());
            Object value = mime.getIcon();
            vo.setValue(value);
            DocPropVO docPropVO = this.getPropVOByDr(dr);
            vo.setSize(docPropVO.getSize());
            // 不可以在线编辑
            if (bodyType == null || dr.isImage()) {
                //  文本文件显示其正文内容，为避免其体积过大导致读取显示时占用资源过多，限制只显示1MB以内的文本文件内容，1MB以上提示其下载到本地阅读
                if (file != null) {
                    String suffix = FilenameUtils.getExtension(file.getFilename()).toLowerCase();
                    boolean isText = this.typesShowContentDirectlyTEXT.contains(suffix);
                    boolean isHTML = this.typesShowContentDirectlyHTML.contains(suffix);
                    if (isText || isHTML) {
                        if (file.getSize() <= (this.maxSize4ShowContent * 1024 * 1024l)) {
                            long time1 = System.currentTimeMillis();
                            String content = this.docHierarchyManager.getTextContent(file.getId());
                            if (log.isDebugEnabled()) {
                                log.debug("获取文本文件正文耗时：" + (System.currentTimeMillis() - time1) + "MS");
                            }

                            // 上传的是文本输出时需要toHTML，使得页面显示与在Notepad中的显示一致.上传的是html文件(后续支持，需解决很容易很容易出现的js报错问题)则不需
                            vo.setBody(isHTML ? content : Strings.toHTML(content));
                        } else {
                            vo.setBody(ResourceUtil.getString("doc.txt.toolarge", this.maxSize4ShowContent));
                        }
                        ret.addObject("txtEdit", "txtEdit");
                    }
                }
            } else {
                // word excel 在线编辑
                vo.setCanEditOnline(true);
                vo.setBodyType(bodyType);
                vo.setBody(dr.getSourceId() + "");
            }
        }

        if (!isHistory && (vo.getDocResource().getCommentEnabled() || vo.getDocResource().getCommentCount() > 0)) {
            List<DocForumPO> forums = docForumManager.findFirstForumsByDocId(dr.getId());
            vo.setForums(this.getForumVOList(forums,dr.getId(), isGroupLib));
            ret.addObject("fourm", true);
        }
        return ret.addObject("vo", vo).addObject("isPersonalLib", isPersonal).addObject("isHistory", isHistory);
    }

    /** 文档评论 */
    public ModelAndView docOpenForum(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView ret = new ModelAndView("apps/doc/docOpenForum");
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        boolean isPersonal = (docLibType == Constants.PERSONAL_LIB_TYPE.byteValue());
        boolean isGroupLib = (docLibType == Constants.GROUP_LIB_TYPE.byteValue());
        DocResourcePO dr = docHierarchyManager.getDocResourceById(docResId);
        DocOpenBodyVO vo = new DocOpenBodyVO(dr);
        this.setFolderItemRef(vo);
        DocMimeTypePO docMimeType = docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId());
        if (docMimeType.isOffice()) {
            this.setBodyContent2VO(docResId, vo);
        } else {
            String bodyType = Constants.getBodyType(dr.getMimeTypeId());
            vo.setIsFile(true);
            V3XFile file = null;
            try {
                file = fileManager.getV3XFile(dr.getSourceId());
                vo.setCreateDate(file.getCreateDate());
                vo.setCreateDateString(file.getCreateDate().toString().substring(0, 10));
            } catch (BusinessException e) {
                log.error("取得V3xfile", e);
            }
            vo.setFile(file);
            if (bodyType == null) {
                // 不可以在线编辑
            } else {
                // word excel 在线编辑
                vo.setCanEditOnline(true);
                vo.setBodyType(bodyType);
                vo.setBody(dr.getSourceId() + "");
            }
        }
        if (vo.getDocResource().getCommentCount() > 0) {
            List<DocForumPO> forums = docForumManager.findFirstForumsByDocId(docResId);
            vo.setForums(this.getForumVOList(forums,docResId, isGroupLib));
        }
        ret.addObject("vo", vo);
        ret.addObject("isPersonalLib", isPersonal);
        return ret;
    }

    private void setBodyContent2VO(Long docResId, DocOpenBodyVO vo) {
        DocBodyPO docBody = docHierarchyManager.getBody(docResId);
        this.setBodyContent2VO(docBody, vo);
    }

    private void setBodyContent2VO(DocBodyPO docBody, DocOpenBodyVO vo) {
        vo.setIsFile(false);
        String body = "";
        String bodyType = "";
        if (docBody != null) {
            body = docBody.getContent();
            bodyType = docBody.getBodyType();
            // 创建日期
            Date createDate = docBody.getCreateDate();
            if (createDate != null)
                vo.setCreateDate(createDate);
        }
        vo.setBody(body);
        vo.setBodyType(bodyType);
    }

    /** 添加文档评论界面进入 */
    public ModelAndView docForumAddView(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/docForumAdd");
    }

    /** 添加文档评论  
     * @throws BusinessException */
    public ModelAndView docForumAdd(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        String content = request.getParameter("content");
        Long docResId = NumberUtils.toLong(request.getParameter("docResId"));
        DocResourcePO dr = this.docHierarchyManager.getDocResourceById(docResId);
        // 存在性判断
        if (dr == null) {
            super.rendJavaScript(response,
                    "alert(window.dialogArguments.v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));"
                            + "parent.window.dialogArguments.parent.location.reload(true);" + "parent.window.close();");
            return null;
        }

        Long userId = AppContext.currentUserId();
        DocForumPO docForum = docForumManager.pubDocForum(docResId, 0L, "", content, userId);
        // 更新订阅文档
        docAlertLatestManager.addAlertLatest(dr, Constants.ALERT_OPR_TYPE_FORUM, userId, new Date(),
                Constants.DOC_MESSAGE_ALERT_COMMENT, null);
        this.updateIndex(docResId);

        String timeFormat = ResourceUtil.getString("common.datetime.pattern");
        super.rendJavaScript(response,
                "parent.addForum('" + docForum.getId() + "','" + Datetimes.format(docForum.getCreateTime(), timeFormat)
                        + "')");

        DocActionPO action = new DocActionPO();
		action.setId(UUIDLong.longUUID());
		action.setActionUserId(userId);
		action.setSubjectId(docResId);
		action.setActionType(DocActionEnum.forums.key());
		action.setUserAccountId(AppContext.currentAccountId());
		action.setActionTime(new Date());
		action.setDescription("forums");
		action.setStatus(0);
		if(userId.equals(dr.getCreateUserId())){
			action.setCanEarn(false);
		}
        docActionManager.insertDocAction(action);
        return null;
    }

    /** 回复文档评论   
     * @throws BusinessException */
    public ModelAndView docForumReply(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        String content = request.getParameter("content");
        Long docResId = NumberUtils.toLong(request.getParameter("docResId"));

        // 存在性判断
        DocResourcePO dr = this.docHierarchyManager.getDocResourceById(docResId);
        if (dr == null) {
            super.rendJavaScript(response,
                    "alert(window.dialogArguments.v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));"
                            + "parent.top.close();");
            return null;
        }

        Long forumId = Long.valueOf(request.getParameter("forumId"));
        Long userId = AppContext.currentUserId();

        DocForumPO docForum = docForumManager.pubDocForum(docResId, forumId, "", content, userId);
        // 更新订阅文档
        docAlertLatestManager.addAlertLatest(dr, Constants.ALERT_OPR_TYPE_FORUM, userId, new Date(),
                Constants.DOC_MESSAGE_ALERT_COMMENT, null);
        this.updateIndex(docResId);

        String timeFormat = ResourceUtil.getString("common.datetime.pattern");
        String dateTimeStr = Datetimes.format(docForum.getCreateTime(), timeFormat);
        super.rendJavaScript(response, "parent.replyOK('" + docForum.getId() + "','" + dateTimeStr + "')");
        return null;
    }

    /**
     * 删除文档评论及回复。
     */
    public ModelAndView deleteDocForum(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long docResId = Long.valueOf(request.getParameter("docResId"));

        // 存在性判断
        if (!docHierarchyManager.docResourceExist(docResId)) {
            super.rendJavaScript(response,
                    "alert(window.dialogArguments.v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));"
                            + "window.dialogArguments.parent.location.reload(true);" + "parent.close();");
            return null;
        }

        boolean flag = Boolean.valueOf(request.getParameter("flag"));
        long forumId = Long.valueOf(request.getParameter("forumId"));
        if (flag) {
            docForumManager.deleteDocForumAndReply(forumId);
        } else {
            docForumManager.deleteReply(forumId);
        }
        return this.docOpenForum(request, response);
    }

    @Deprecated
    public ModelAndView docDownloadNewWindow(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView("apps/doc/docDownloadIframe");
        String docResourceId = request.getParameter("id");
        boolean flag = this.docHierarchyManager.docDownloadCompress(Long.valueOf(docResourceId));
        mav.addObject("flag", flag);
        return mav;
    }

    /**
     * 批量下载C++程序用的
     * 
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @SetContentType
    public ModelAndView docDownloadNew4Multi(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String docResourceId = request.getParameter("id");

        //		String lentpotent2 = docAclManager.getBorrowPotent(Long.parseLong(docResourceId));
        //		if(lentpotent2 != null && lentpotent2.substring(0, 1) != "1") {
        //			PrintWriter out = response.getWriter();
        //			out.println("2");
        //			out.close();
        //			return null;
        //      	}

        if (!this.docHierarchyManager.docResourceExist(Long.parseLong(docResourceId))) {
            response.addHeader("Rang", "-1"); //不存在
            return null;
        }

        this.docHierarchyManager.docDownloadCompress(Long.parseLong(docResourceId));

        return docDownloadNew(request, response);
    }

    /** 下载复合文档 */
    @SetContentType
    public ModelAndView docDownloadNew(HttpServletRequest request, HttpServletResponse response) {
        String docResourceId = request.getParameter("id");
        File zipFile = DocHierarchyManagerImpl.downloadMap.get(docResourceId);
        if (zipFile == null) {
            response.addHeader("FileDownloadError", "1"); //不存在
            return null;
        }
        InputStream in = null;
        OutputStream out = null;
        String zipfilename = zipFile.getName();
        try {
            in = new FileInputStream(zipFile);
            response.setContentType("application/x-msdownload; charset=UTF-8");
            response.setHeader("Content-disposition", "attachment;" + FileUtil.getDownloadFileName(request,zipfilename));
            response.setContentLength(in.available());
            out = response.getOutputStream();
            CoderFactory.getInstance().download(in, out);
        } catch (Exception e) {
            if (!"ClientAbortException".equals(e.getClass().getSimpleName())) {
                ModelAndView modelAndView = new ModelAndView("common/fileUpload/error");
                modelAndView.addObject("error", "Exception");
                modelAndView.addObject("filename", zipfilename);

                return modelAndView;
            }
        } finally {
            IOUtils.closeQuietly(in);
            IOUtils.closeQuietly(out);
        }

        /** **************** 删除临时文件开始 *********************** */

        try {
            DocHierarchyManagerImpl.downloadMap.remove(docResourceId);
            zipFile.delete();
        } catch (Exception e) {
            // log.error("复合文档下载", e);
        }

        /** **************** 删除临时文件结束 *********************** */

        return null;
    }

    /** 打开页面的菜单 */
    public ModelAndView docOpenMenu(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView ret = new ModelAndView("apps/doc/docOpenMenu");
        boolean isHistory = Constants.VERSION_FLAG.equals(request.getParameter("versionFlag"));
        String resIdStr = request.getParameter(isHistory ? "docVersionId" : "docResId");
        Long resId = Long.valueOf(resIdStr);

        if (!isHistory && !"true".equals(request.getParameter("isLink"))) {
            // SECURITY 访问安全检查
            if (!SecurityCheck.isLicit(request, response, ApplicationCategoryEnum.doc, AppContext.getCurrentUser(),
                    resId, null, null)) {
                return null;
            }
        }

        DocResourcePO dr = getDocResource4Show(isHistory, resId);
        String createDate = dr.getCreateTime().toString().substring(0, 10);
        boolean isUploadFile = false;
        boolean commentEnabled = dr.getCommentEnabled();

        Long downloadId = resId;
        DocBodyPO docBody = docHierarchyManager.getBody(dr.getId());
        if (docBody != null) {
            ret.addObject("bodyType", docBody.getBodyType());
        }

        long formatType = docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getFormatType();
        if (formatType == Constants.FORMAT_TYPE_DOC_FILE) {
            isUploadFile = true;
            downloadId = dr.getSourceId();
            ret.addObject("bodyType", Constants.getBodyType(dr.getMimeTypeId()));
            // 对于上传文件，因为可能出现替换情况，导致新建时间不一致，所以应该从系统取。解决下载的定位问题
            try {
                V3XFile file = fileManager.getV3XFile(downloadId);
                createDate = file.getCreateDate().toString().substring(0, 10);
            } catch (BusinessException e) {
                log.error("从fileManager取得V3xFile, ", e);
            }

        }
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        boolean isPrivateLib = docLibType.equals(Constants.PERSONAL_LIB_TYPE);

        // 访问次数记录
        // 2007.07.23 因为 v3x.openWindow()会自动对同一 url
        // 的外层框架页面缓存，所以访问次数从iframe转移到menu
        // 不能使用 docLibType 进行文档类型判断，因为
        // docLibType 记录当前用户所在库
        // 而 单位借阅 中的文档属于公共库，需要记录打开数据，但此时 libtype 是 personal
        if (!isHistory) {
            DocLibPO lib = docLibManager.getDocLibById(dr.getDocLibId());

            // 对需要记录查看日志的文档库记录日志
            if (lib.getLogView()) {
                operationlogManager.insertOplog(resId, dr.getParentFrId(), ApplicationCategoryEnum.doc,
                        ActionType.LOG_DOC_VIEW, ActionType.LOG_DOC_VIEW + ".desc", AppContext.currentUserName(),
                        dr.getFrName());
            }
            Long userId = AppContext.currentUserId();
            docHierarchyManager.accessOneTime(resId, dr.getIsLearningDoc(), !userId.equals(dr.getCreateUserId()));
            docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(),
                    DocActionEnum.read.key(), dr.getId(), "read",!userId.equals(dr.getCreateUserId()));

            boolean isGroupAdmin = this.canAdminGroup();
            ret.addObject("isAdministrator", DocMVCUtils.isAccountSpaceManager(
            		spaceManager, userId, AppContext.currentAccountId()));
            ret.addObject("isGroupAdmin", isGroupAdmin);

            int depAdminSize = DocMVCUtils.getDeptsByManagerSpace(spaceManager, AppContext.currentUserId()).size();

            ret.addObject("depAdminSize", depAdminSize);
            ret.addObject("commentEnabled", commentEnabled);
            String lockMsg = this.docHierarchyManager.getLockMsg(dr.getId(), userId);
            boolean isLocked = !Constants.LOCK_MSG_NONE.equals(lockMsg);
            ret.addObject("isLocked", isLocked);
            ret.addObject("lockMsg", lockMsg);
        }

        ret.addObject("dr", dr).addObject("isHistory", isHistory);
        ret.addObject("isEdocLib", docLibType.byteValue() == Constants.EDOC_LIB_TYPE.byteValue());
        ret.addObject("createDate", createDate).addObject("isUploadFile", isUploadFile)
                .addObject("canPrint4Upload", dr.canPrint4Upload());
        ret.addObject("downloadId", downloadId).addObject("isPrivateLib", isPrivateLib);
        return ret.addObject("isGroupLib", (docLibType.byteValue() == Constants.GROUP_LIB_TYPE.byteValue()));
    }

    /** 打开页面的页签部分 */
    public ModelAndView docOpenLabel(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView ret = new ModelAndView("apps/doc/docOpenLabel");
        boolean isHistory = Constants.VERSION_FLAG.equals(request.getParameter("versionFlag"));
        String resIdStr = request.getParameter(isHistory ? "docVersionId" : "docResId");
        Long resId = Long.valueOf(resIdStr);

        DocResourcePO dr = null;
        if (isHistory) {
            DocVersionInfoPO dvi = this.docVersionInfoManager.getDocVersion(resId);
            dr = dvi.getDocResourceFromXml();
        } else {
            dr = docHierarchyManager.getDocResourceById(resId);
        }
        DocPropVO docPropVO = this.getPropVOByDr(dr);
        ret.addObject("prop", docPropVO);

        long formatType = docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getFormatType();
        boolean isUploadFile = formatType == Constants.FORMAT_TYPE_DOC_FILE;
        ret.addObject("isUploadFile", isUploadFile);

        int metaSize = contentTypeManager.hasExtendMetadata(docPropVO.getDocResource().getFrType()) ? 1 : 0;
        String metaHtml = "";
        if (metaSize > 0)
            metaHtml = isHistory ? htmlUtil.getHistoryViewHtml(resId) : htmlUtil.getViewHtml(resId);

        ret.addObject("extendSize", metaSize);
        ret.addObject("metadataHtml", metaHtml);

        List<Attachment> atts = attachmentManager.getByReference(resId);
        ret.addObject("atts", atts);
        ret.addObject("attSize", atts == null ? 0 : atts.size());

        DocLibPO lib = docLibManager.getDocLibById(docPropVO.getDocResource().getDocLibId());
        boolean isPersonalLib = lib != null && lib.isPersonalLib();
        return ret.addObject("isPersonalLib", isPersonalLib);
    }

    /** 取得属性 */
    private DocPropVO getPropVOByDr(DocResourcePO dr) {
        DocPropVO pvo = new DocPropVO(dr);
        pvo.setPath(this.getPhysicalPath(dr.getLogicalPath()));
        pvo.setIcon(this.getIcon(dr.getIsFolder(), dr.getMimeTypeId()));
        this.setFolderItemRef(pvo);

        pvo.setIsShortCut(dr.getFrType() == Constants.LINK || dr.getFrType() == Constants.LINK_FOLDER);
        pvo.setIsPigeonhole(Constants.isPigeonhole(dr.getFrType()));
        return pvo;
    }

    /** 取得图片名称 */
    private String getIcon(boolean isFolder, Long mimeTypeId) {
    	if(mimeTypeId != null){
    		String icon = docMimeTypeManager.getDocMimeTypeById(mimeTypeId).getIcon();
            if (isFolder && !"".equals(icon)) {
                if (icon.indexOf("|") != -1) {
                    icon = icon.substring(0, icon.indexOf("|"));
                }
            }
            return icon;
    	}else{
    		return "folder_close.gif";
    	}
    }

    // 取得文档夹属性
    private FolderItemFolder getFolderPropVO(HttpServletRequest request) {
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        DocResourcePO dr = docHierarchyManager.getDocResourceById(docResId);
        FolderItemFolder folder = new FolderItemFolder(dr);
        folder.setPath(this.getPhysicalPath(dr.getLogicalPath()));
        folder.setIcon(this.getIcon(dr.getIsFolder(), dr.getMimeTypeId()));
        this.setFolderItemRef(folder);
        return folder;
    }

    // 保存文档属性
    @SuppressWarnings("unchecked")
    private void saveDocProp(HttpServletRequest request, HttpServletResponse response, boolean saveVersion)
            throws BusinessException {
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        Long userId = AppContext.currentUserId();
        Map paramap = new HashMap();
        Map<String, String[]> srcParaMap = request.getParameterMap();
        DocResourcePO dr = docHierarchyManager.getDocResourceById(docResId);
        boolean versionEnabled = false;
        String versionComment = null;

        Map<String, Object> namedParams = new HashMap<String, Object>();
        boolean isEdoc = dr.getFrType() == Constants.SYSTEM_ARCHIVES;
        for (Iterator<Entry<String, String[]>> iter = srcParaMap.entrySet().iterator(); iter.hasNext();) {
            Entry<String, String[]> entry = iter.next();
            String sname = entry.getKey();
            if ("docDesc".equals(sname)) {
                namedParams.put("frDesc", entry.getValue()[0]);
            } else if ("commentEnabled".equals(sname)) {
                boolean ce = Boolean.valueOf(entry.getValue()[0]);
                namedParams.put("commentEnabled", ce);
                if (!ce && !isEdoc)
                    docAlertManager.deleteAlertByDocResourceIdAndAlertType(docResId);
            } else if ("recommendEnabled".equals(sname)) {
                boolean re = Boolean.valueOf(entry.getValue()[0]);
                namedParams.put("recommendEnable", re);
            } else if ("docKeywords".equals(sname)) {
                namedParams.put("keyWords", entry.getValue()[0]);
            }
            if (!isEdoc) {
                if ("versionComment".equals(sname)) {
                    versionComment = entry.getValue()[0];
                    namedParams.put("versionComment", versionComment);
                } else if ("versionEnabled".equals(sname)) {
                    versionEnabled = Boolean.valueOf(entry.getValue()[0]);
                    namedParams.put("versionEnabled", versionEnabled);
                } else if (this.needHandleMetadata(sname)) {
                    // 处理多值元数据
                    String[] values = (String[]) entry.getValue();
                    this.addMetadataKV(paramap, sname, values);
                }
            }
        }

        if (versionEnabled && saveVersion)
            this.docVersionInfoManager.saveDocVersionInfo(versionComment, dr);

        namedParams.put("lastUpdate", new Date());
        namedParams.put("lastUserId", userId);
        this.docHierarchyManager.updateDocResource(docResId, namedParams);
        if (!paramap.isEmpty())
            docMetadataManager.updateMetadata(docResId, paramap);

        DocResourcePO destDr = docHierarchyManager.getDocResourceById(docResId);
        // 记录操作日志
        operationlogManager.insertOplog(docResId, destDr.getParentFrId(), ApplicationCategoryEnum.doc,
                ActionType.LOG_DOC_EDIT_DOCUMENT, ActionType.LOG_DOC_EDIT_DOCUMENT + ".desc",
                AppContext.currentUserName(), destDr.getFrName());
        
        docAlertLatestManager.addAlertLatest(destDr, Constants.ALERT_OPR_TYPE_EDIT, userId, new Date(),
                Constants.DOC_MESSAGE_ALERT_MODIFY_EDIT, destDr.getFrName());

        docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(), DocActionEnum.edit.key(),
                docResId, "");
    }

    /** 保存文档夹属性 
     * @throws BusinessException */
    @SuppressWarnings("unchecked")
    private void saveFolderProp(HttpServletRequest request) throws BusinessException {
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        DocResourcePO drs = docHierarchyManager.getDocResourceById(docResId);

        Long userId = AppContext.currentUserId();
        String orgIds = Constants.getOrgIdsOfUser(userId);
        Map metadatas = new HashMap();
        Map<String, Object> properties = new HashMap<String, Object>();

        Map<String, String[]> srcParaMap = request.getParameterMap();
        for (Iterator<Entry<String, String[]>> iter = srcParaMap.entrySet().iterator(); iter.hasNext();) {
            Entry<String, String[]> entry = iter.next();
            String sname = entry.getKey();
            if ("folderDesc".equals(sname)) {
                properties.put("frDesc", entry.getValue()[0]);
            } else if ("subfolderEnabled".equals(sname)) {
                boolean se = Boolean.valueOf(entry.getValue()[0]);
                boolean hasPermission = this.docHierarchyManager.hasEditPermission(drs, userId, orgIds);
                if (hasPermission) {
                    properties.put("subfolderEnabled", se);
                }
            } else if ("foldVersionEnabled".equals(sname)) {
                boolean fveChangeFlag = Boolean.parseBoolean(request.getParameter("fveChangeFlag"));
                if (fveChangeFlag) {
                    int editScopeAll = NumberUtils.toInt(request.getParameter("appAllVersion"));
                    if (editScopeAll != -1l) {
                        boolean fve = Boolean.valueOf(entry.getValue()[0]);
                        docHierarchyManager.setFolderVersionEnabled(drs, fve, editScopeAll, userId);
                    }
                }
            } else if ("foldCommentEnabled".equals(sname)) {
                boolean fceChangeFlag = Boolean.parseBoolean(request.getParameter("fceChangeFlag"));
                if (fceChangeFlag) {
                    int editScopeAll = NumberUtils.toInt(request.getParameter("appAll"));
                    if(drs.getFrType()!=Constants.FORMAT_TYPE_LINK){
	                    if (editScopeAll != -1l) {
	                        boolean fre = Boolean.valueOf(entry.getValue()[0]);
	                        docHierarchyManager.setFolderCommentEnabled(drs, fre, editScopeAll, userId);
	                    }
                    }
                }
            } else if ("foldRecommendEnabled".equals(sname)) {
                boolean freChangeFlag = Boolean.parseBoolean(request.getParameter("freChangeFlag"));
                if (freChangeFlag) {
                    int editScopeAll = NumberUtils.toInt(request.getParameter("appAllRecommend"));
                    if (editScopeAll != -1l) {
                        boolean fre = Boolean.valueOf(entry.getValue()[0]);
                        docHierarchyManager.setFolderRecommendEnabled(drs, fre, editScopeAll, userId);
                    }
                }
            } else if (this.needHandleMetadata(sname)) {
                this.addMetadataKV(metadatas, sname, entry.getValue());
            }
        }

        this.docHierarchyManager.updateDocResource(docResId, properties);
        if (!metadatas.isEmpty())
            docMetadataManager.updateMetadata(docResId, metadatas);

        // 记录操作日志
        operationlogManager.insertOplog(docResId, drs.getParentFrId(), ApplicationCategoryEnum.doc,
                ActionType.LOG_DOC_EDIT_FOLDER, ActionType.LOG_DOC_EDIT_FOLDER + ".desc", AppContext.currentUserName(),
                Constants.getDocI18nValue(drs.getFrName()));

        drs = this.docHierarchyManager.getDocResourceById(docResId);
        docAlertLatestManager.addAlertLatest(drs, Constants.ALERT_OPR_TYPE_EDIT, userId, new Date(),
                Constants.DOC_MESSAGE_ALERT_MODIFY_EDIT_FOLDER, drs.getFrName());

        docActionManager.insertDocAction(AppContext.currentUserId(), AppContext.currentAccountId(), new Date(),
                DocActionEnum.edit.key(), docResId, "edit");

    }

    /** 单个属性的简单查询 
     * @throws BusinessException */
    public ModelAndView simpleQuery(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        return this.simpleOrAdvancedQuery(request, response, true, "apps/doc/rightNew");
    }
    
    /** 适用专题单个属性的简单查询 
     * @throws BusinessException */
    public ModelAndView simpleZhuanTiQuery(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        return this.simpleOrAdvancedQuery(request, response, true, "apps/doc/downNew");
    }

    /** 多个属性组合起来的高级查询 
     * @throws BusinessException */
    public ModelAndView advancedQuery(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        return this.simpleOrAdvancedQuery(request, response, false, "apps/doc/advancedSearchResult");
    }

    private ModelAndView simpleOrAdvancedQuery(HttpServletRequest request, HttpServletResponse response,
            boolean isSimple, String url) throws BusinessException {
        
    	// 客开 START
    	//ModelAndView ret = new ModelAndView(isSimple ? "apps/doc/rightNew" : "apps/doc/advancedSearchResult");
        ModelAndView ret = new ModelAndView(url);
        // 客开 END
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        // 在生成文档列表时，就把文档权限入口传入 入口参数参考EntranceTypeEnum.java
        int entranceType = 2;
        if(Constants.PERSONAL_LIB_TYPE.equals(docLibType)) {
        	entranceType = 1;
        } else if(Constants.EDOC_LIB_TYPE.equals(docLibType)){
            entranceType = 9;
        } else {
           entranceType = 5;
        }
        Long docLibId = Long.valueOf(request.getParameter("docLibId"));
        DocLibPO docLib = docLibManager.getDocLibById(docLibId);
        Long isNew = 0L;
        if(Strings.isNotBlank(request.getParameter("isNew"))){
        	isNew = Long.valueOf(request.getParameter("isNew"));
        }
        Long isFromSea = 1L;
        DocMVCUtils.returnVaule(ret, docLibType, docLib, request, this.contentTypeManager, this.docLibManager,true);

        Long resId = Long.valueOf(request.getParameter("resId"));
        Long frType = Long.valueOf(request.getParameter("frType"));
        DocResourcePO parent = this.getParenetDocResource(resId, frType);
        ret.addObject("parent", parent);

        List<DocTableVO> docs = null;
        if (isNew == 1) {
            docs = this.getQueryResultVOs(request, parent, docLibId, docLibType, ret, isSimple, true);
        } else {
            docs = this.getQueryResultVOs(request, parent, docLibId, docLibType, ret, isSimple, false);
        }
        List<DocResourcePO> drs = new ArrayList<DocResourcePO>();
        for (DocTableVO dtv : docs) {
            drs.add(dtv.getDocResource());
        }
        handleOpenSquare(parent, docLib, drs, docs);
        ret.addObject("docs", docs);

    	if(!isSimple){
    		String adv_isNewView = request.getParameter("adv_isNewView");
    		if(Strings.isBlank(adv_isNewView)){
    			adv_isNewView = "false";
    		}
    		ret.addObject("adv_isNewView", adv_isNewView);
    	}
        boolean openToZoneFlag = DocUtils.isOpenToZoneFlag();
        
        ret.addObject("entranceType",entranceType);
        this.initRightAclData(request, ret);
        
        List<Long> ownerSet = DocMVCUtils.getLibOwners(parent);
        boolean isOwner = ownerSet != null && ownerSet.contains(AppContext.currentUserId());
        //不是个人，项目库，开启插件
        ret.addObject("isAllowArchivePigeonhole",(docLib.getType() != Constants.PERSONAL_LIB_TYPE && 
                SystemEnvironment.hasPlugin("archive") &&  docLib.getType() != Constants.PROJECT_LIB_TYPE && isOwner ));
        //区隔
        ret.addObject("docCollectFlag",SystemProperties.getInstance().getProperty("doc.collectFlag"));
        ret.addObject("docRecommendFlag",SystemProperties.getInstance().getProperty("doc.recommendFlag"));
		ret.addObject("docOpenToZoneFlag",openToZoneFlag);
		ret.addObject("isNewView",isNew);
		ret.addObject("isFromSea",isFromSea);
        return ret;
    }

    private DocResourcePO getParenetDocResource(Long folderId, Long frType) {
        DocResourcePO folder = docHierarchyManager.getDocResourceById(folderId);
        if (frType == Constants.PERSON_BORROW || frType == Constants.PERSON_SHARE
                || frType == Constants.DEPARTMENT_BORROW) {
            folder = new DocResourcePO();
            folder.setId(folderId);
            folder.setFrType(frType);
            folder.setLogicalPath(folderId+"");
            String name2 = null;
            if (frType == Constants.DEPARTMENT_BORROW)
                name2 = Constants.DEPARTMENT_BORROW_KEY;
            else
                name2 = Constants.getOrgEntityName(V3xOrgEntity.ORGENT_TYPE_MEMBER, folderId, false);
            folder.setFrName(name2);
        }
        return folder;
    }

    private List<DocTableVO> getQueryResultVOs(HttpServletRequest request, DocResourcePO parent, Long docLibId,
            Byte docLibType, ModelAndView ret, boolean isSimpleQuery,boolean isNew) throws BusinessException {
        Long resId = NumberUtils.toLong(request.getParameter("resId"));
        List<DocResourcePO> result1 = null;
        List<DocMetadataDefinitionPO> dmds = docLibManager.getListColumnsByDocLibId(docLibId,Constants.All_EDOC_ELMENT);
        Long userId = AppContext.currentUserId();
        if (isSimpleQuery) {
            SimpleDocQueryModel simpleQueryModel = SimpleDocQueryModel.parseRequest(request);
            ret.addObject("simpleQueryModel", simpleQueryModel);
			Long frType = NumberUtils.toLong(request.getParameter("frType"));
			if ((Strings.equals(DocConstants.FOLDER_SHARE, frType)) || (Strings.equals(DocConstants.FOLDER_BORROW, frType))) {
				byte shareType;
				if (Strings.equals(DocConstants.FOLDER_SHARE, frType)) {
					shareType = 2;
				} else {
					shareType = 3;
				}
				result1 = this.docHierarchyManager.findResourceFromShareAndBorrow(userId, simpleQueryModel, shareType);
			}else{
				result1 = this.docHierarchyManager.getSimpleQueryResult(isNew, simpleQueryModel, resId, docLibType, 0);
			}
        } else {
            DocSearchModel dsm = DocSearchModel.parseRequest(request);
            result1 = this.docHierarchyManager.getAdvancedQueryResult(isNew,dsm, resId, docLibType);
        }
        boolean isShareAndBorrow = BooleanUtils.toBoolean(request.getParameter("isShareAndBorrowRoot"));
        List<DocTableVO> docs = this.getTableVOs(result1, dmds, ret, userId, isShareAndBorrow, docLibType, parent, request);
        return docs;
    }

    // 查找复合文档的内容
    public FolderItemDoc getFolderItemDoc(DocResourcePO dr) {
        FolderItemDoc fid = new FolderItemDoc(dr);
        fid.setPath(this.getPhysicalPath(dr.getLogicalPath()));
        fid.setIcon(this.getIcon(dr.getIsFolder(), dr.getMimeTypeId()));
        fid.setAtts(attachmentManager.getByReference(dr.getId()));

        DocBodyPO body = docHierarchyManager.getBody(dr.getId());
        fid.setBody(body.getContent());

        if (dr.getIsCheckOut()) {
            fid.setCheckOutUserName(getUserName(dr.getCheckOutUserId()));
        }
        this.setFolderItemRef(fid);
        return fid;
    }

    // 设置forumVo，会存在性能问题
    private List<DocForumVO> getForumVOList(List<DocForumPO> forums,Long docId, boolean isGroupLib) {
        List<DocForumVO> vos = new ArrayList<DocForumVO>();
        List<DocForumPO> replyList =docForumManager.findReply(docId);
        Map<Long,List<DocForumPO>> replyMap = buildForum(replyList);
        if (CollectionUtils.isNotEmpty(forums)) {
            for (DocForumPO forum : forums) {
                DocForumVO vo = new DocForumVO(forum);
                Object[] name2valid = this.getForumUserName(forum.getCreateUserId(), isGroupLib);
                vo.setName((String)name2valid[0]);
                vo.setForumUserNameValid((Boolean)name2valid[1]);
                //回复
                List<DocForumPO> replys = replyMap.get(forum.getId());
                List<DocForumReplyVO> replyvos = new ArrayList<DocForumReplyVO>();
                if (CollectionUtils.isNotEmpty(replys)) {
                    for (DocForumPO tr : replys) {
                        DocForumReplyVO trvo = new DocForumReplyVO(tr);
                        Object[] name2valid2 = this.getForumUserName(tr.getCreateUserId(), isGroupLib);
                        trvo.setName((String)name2valid2[0]);
                        trvo.setReplyUserValid((Boolean)name2valid2[1]);
                        replyvos.add(trvo);
                    }
                }
                vo.setReplys(replyvos);
                //评论人图片
                String srcImg = Functions.getAvatarImageUrl(forum.getCreateUserId());
                vo.setSrcImg(srcImg);
                vos.add(vo);
            }
        }
        return vos;
    }

    /**
     * 获取评论或评论回复创建者在文档评论区域的显示名称
     * @param createUserId	评论或回复创建者
     * @param isGroupLib	是否集团文档库
     * @return	评论区域的显示名称
     */
    private Object[] getForumUserName(Long createUserId, boolean isGroupLib) {
        return Constants.getOrgEntityName2userValid("Member", createUserId, isGroupLib);
    }

    /**
     * 设置 FolderItem 中引用型属性
     * @param item
     */
    private void setFolderItemRef(FolderItem item) {
        DocResourcePO dr = item.getDocResource();
        item.setCreateUserName(this.getUserName(dr.getCreateUserId()));
        item.setLastUserName(this.getUserName(dr.getLastUserId()));
        String typeName = contentTypeManager.getContentTypeById(dr.getFrType()).getName();
        item.setType(Constants.getDocI18nValue(typeName));
    }

    private String getUserName(Long userId) {
        String name = Functions.showMemberName(userId);
        return name == null ? "" : name;
    }

    // 得到某个节点的物理路径
    private String getPhysicalPath(String logicalPath) {
        if (Strings.isBlank(logicalPath))
            return "";

        StringBuilder sb = new StringBuilder("");
        // 2008.04.01 不显示自己
        String[] arr = logicalPath.split("\\.");
        String ids = "";
        for (int i = 0; i < arr.length; i++) {
            ids += "," + arr[i];
        }

        List<DocResourcePO> list = this.docHierarchyManager.getDocsByIds(ids.substring(1));
        if (Strings.isEmpty(list))
            return "";
        Map<String, DocResourcePO> map = new HashMap<String, DocResourcePO>();
        for (DocResourcePO td : list) {
            map.put(td.getId().toString(), td);
        }

        for (int i = 0; i < (arr.length == 1 ? 1 : (arr.length - 1)); i++) {
            DocResourcePO td = map.get(arr[i]);
            if (td == null)
                continue;
            sb.append("\\");
            String key = td.getFrName();
            if (Constants.needI18n(td.getFrType()))
                key = ResourceUtil.getString(key);
            sb.append(key);
        }
        return sb.toString();
    }
    /**
     * 取得某个文档（夹）的路径
     */
    private String getLocation(String logicalPath) {
    	return getLocation(logicalPath,null);
    }

    /**
     * 取得某个文档（夹）的路径
     */
    private String getLocation(String logicalPath,HttpServletRequest request) {
        List<DocResourcePO> locList = new ArrayList<DocResourcePO>();
        if (Strings.isBlank(logicalPath))
            return "";

        // 2008.04.01 不显示自己
        String[] arr = logicalPath.split("\\.");
        String ids = StringUtils.join(arr, ',');
        List<DocResourcePO> list = this.docHierarchyManager.getDocsByIds(ids);
        if (Strings.isEmpty(list)){
            return "";
        }

        Map<String, DocResourcePO> map = new HashMap<String, DocResourcePO>();
        for (DocResourcePO td : list) {
            map.put(td.getId().toString(), td);
        }

        for (int i = 0; i < arr.length; i++) {
            DocResourcePO td = map.get(arr[i]);
            if (td == null)
                continue;
            locList.add(td);
        }

        StringBuilder sb = new StringBuilder("");
        DocResourcePO docResource = null;
        DocLibPO docLib = null;
        Long domainId = null;
        if (locList.size() > 5) {
            sb.append("...");
            for (int i = (locList.size() - 5); i < locList.size(); i++) {
                docResource = locList.get(i);
                docLib = this.docLibManager.getDocLibById(docResource.getDocLibId());
                domainId = docLib.getDomainId();
                // 如果是共享外单位的文档夹，文档库名称后面需加上外单位名称简称
                String name = docResource.getFrName();
                name = Constants.getDocI18nValue(name);
                if ((i == locList.size() - 5) && domainId != null && domainId.longValue() != 0l
                        && domainId.longValue() != AppContext.getCurrentUser().getLoginAccount()) {
                    try {
                        name = (name + "(" + this.orgManager.getAccountById(domainId).getShortName() + ")");
                    } catch (BusinessException e) {
                        log.error("", e);
                    }
                }
                String name2 = Strings.getLimitLengthString(name, 20, "...");
                if(request != null) {
                	name = this.convertToLink(name2, name, docResource.getId(), docResource.getFrType(),request);
                } else {
                	name = this.convertToLink(name2, name, docResource.getId(), docResource.getFrType()); 
                }               
                sb.append(Constants.NAV_SPLIT + name);
            }
        } else {
            for (int i = 0; i < locList.size(); i++) {
                docResource = locList.get(i);
                docLib = this.docLibManager.getDocLibById(docResource.getDocLibId());
                domainId = docLib.getDomainId();
                // 如果是共享外单位的文档夹，名称后面需加上外单位名称简称
                String name = docResource.getFrName();
                name = Constants.getDocI18nValue(name);
                if (i == 0 && domainId != null && domainId.longValue() != 0l
                        && domainId.longValue() != AppContext.getCurrentUser().getLoginAccount()) {
                    try {
                        name = (name + "(" + this.orgManager.getAccountById(domainId).getShortName() + ")");
                    } catch (BusinessException e) {
                        log.error("", e);
                    }
                }
                String name2 = Strings.getLimitLengthString(name, 20, "...");
                if(request != null) {
                	name = this.convertToLink(name2, name, docResource.getId(), docResource.getFrType(),request);
                } else {
                	name = this.convertToLink(name2, name, docResource.getId(), docResource.getFrType());
                }      
                if (i == 0)
                    sb.append(name);
                else
                    sb.append(Constants.NAV_SPLIT + name);
            }
        }

        return sb.toString();
    }
    // 将当前位置的字符串转换为打开链接
    private String convertToLink(String showName, String title, long id, long frType,HttpServletRequest request) {
    	String v = null;
    	boolean isPassAcl = false;
    	boolean all = false;
		boolean edit = false;
		boolean add = false;
		boolean readonly = false;
		boolean browse = false;
		boolean list = false;
    	try {
			Potent potent = docAclManager.getAclVO(id);
			String isBorrowOrShare = DocMVCUtils.getParameter(request, "isShareAndBorrowRoot");
			if(potent != null) {
				all = potent.isAll();
				edit = potent.isEdit();
				add = potent.isCreate();
				readonly = potent.isReadOnly();
				browse = potent.isRead();
				list = potent.isList();
				isPassAcl = true;
			}
			if(Long.valueOf(40).equals(frType)) {
				isBorrowOrShare = "false";
				all = edit = add = list = true;
				readonly = browse = false;
				isPassAcl = true;
			}
			if(Long.valueOf(110).equals(frType)) {
				isBorrowOrShare = "false";
			}
			if(isPassAcl) {
				v = SecurityHelper.digest(id,frType,request.getParameter("docLibId"),
	            		request.getParameter("docLibType"),isBorrowOrShare,all,edit,
	        			add,readonly,browse,list);
			} else {
				v = SecurityHelper.digest(id,frType,request.getParameter("docLibId"),
	            		request.getParameter("docLibType"),isBorrowOrShare);
			}
			
		} catch (BusinessException e) {
			// TODO Auto-generated catch block
			log.error("", e);
		}
        return "<a class='link-blue' href=\\\"javascript:folderOpenFunWithoutAcl('" + id + "','" + frType
                + "','" + v+ "','" + request.getAttribute("projectTypeId")  + "')\\\" title=\\\"" + Strings.toHTML(title) + "\\\">" + Strings.toHTML(Strings.getLimitLengthString(showName,18,"..")) + "</a>";
    }
    // 将当前位置的字符串转换为打开链接
    private String convertToLink(String showName, String title, long id, long frType) {
        return "<a class='link-blue' href=\\\"javascript:folderOpenFunWithoutAcl('" + id + "','" + frType
                + "')\\\" title=\\\"" + Strings.toHTML(title) + "\\\">" + Strings.toHTML(Strings.getLimitLengthString(showName,18,"..")) + "</a>";
    }

    public ModelAndView docPropertyIframe(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView("apps/doc/docPropertiesIframe");
        boolean extandexit = false;

        boolean isHistory = Constants.VERSION_FLAG.equals(request.getParameter("versionFlag"));
        String resIdStr = request.getParameter(isHistory ? "docVersionId" : "docResId");
        Long resId = Long.valueOf(resIdStr);
        DocResourcePO dr = this.getDocResource4Show(isHistory, resId);

        boolean projectFolder = false;
        if (dr != null) {
            if (contentTypeManager.hasExtendMetadata(dr.getFrType()))
                extandexit = true;
        } else {
            return null;
        }
        mav.addObject("extandexit", extandexit);

        long type = dr.getFrType();
        boolean folderLink = false;
        boolean docLink = false;
        if (type == Constants.FOLDER_CASE || type == Constants.FOLDER_CASE_PHASE)
            projectFolder = true;
        else if (type == Constants.LINK_FOLDER)
            folderLink = true;
        else if (type == Constants.LINK)
            docLink = true;
        mav.addObject("projectFolder", projectFolder);
        mav.addObject("folderLink", folderLink);
        mav.addObject("docLink", docLink);

        DocLibPO lib = docLibManager.getDocLibById(dr.getDocLibId());
        boolean noShare = lib.getType() == Constants.PROJECT_LIB_TYPE.byteValue();
        mav.addObject("noShare", noShare);
        // 判断是否正在查看个人借阅
        boolean ispb = false;
        if (lib.isPersonalLib() && !isHistory)
            ispb = this.docHierarchyManager.isViewPerlBorrowDoc(AppContext.currentUserId(), resId);      
        String vForDocProperty = SecurityHelper.digest(DocMVCUtils.getParameter(request, "resId"),DocMVCUtils.getParameter(request, "docResId"),DocMVCUtils.getParameter(request, "frType"),DocMVCUtils.getParameter(request, "docLibId"),
        		DocMVCUtils.getParameter(request, "docLibType"),DocMVCUtils.getParameter(request, "isShareAndBorrowRoot"),DocMVCUtils.getParameter(request, "all"),DocMVCUtils.getParameter(request, "edit"),
        		DocMVCUtils.getParameter(request, "add"),DocMVCUtils.getParameter(request, "create"),DocMVCUtils.getParameter(request, "readonly"),DocMVCUtils.getParameter(request, "browse"),DocMVCUtils.getParameter(request, "read"),DocMVCUtils.getParameter(request, "list"),DocMVCUtils.getParameter(request, "propEditValue"),DocMVCUtils.getParameter(request, "parentCommentEnabled"),
        		ispb);
        mav.addObject("v",vForDocProperty);
        return mav.addObject("isPerBorrow", ispb);
    }

    private DocResourcePO getDocResource4Show(boolean isHistory, Long resId) {
        DocResourcePO dr = null;
        DocVersionInfoPO dvi = null;
        if (isHistory) {
            dvi = this.docVersionInfoManager.getDocVersion(resId);
            if (dvi == null) {
            	return null;
            }
            dr = dvi.getDocResourceFromXml();
        } else {
            dr = docHierarchyManager.getDocResourceById(resId);
        }
        return dr;
    }

    public ModelAndView docProperty(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView("apps/doc/docProperties");
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        String isFolder = request.getParameter("isFolder");

        boolean isHistory = Constants.VERSION_FLAG.equals(request.getParameter("versionFlag"));
        String resIdStr = request.getParameter(isHistory ? "docVersionId" : "docResId");
        Long docResId = Long.valueOf(resIdStr);
        DocResourcePO dr = this.getDocResource4Show(isHistory, docResId);

        Long parentId = dr.getParentFrId();
        Integer maxFrOrder = this.docHierarchyManager.getMaxOrder(parentId);
        // 权限判断的属性可以修改标记
        String propEditValue = request.getParameter("propEditValue"); // 为真可以修改
        // 是否借阅共享标记
        String isShareAndBorrowRoot = request.getParameter("isShareAndBorrowRoot"); // 为真不能修改
        // 是否从文档库设置页面进入标记
        boolean isLib = StringUtils.isNotBlank(request.getParameter("isLib"));
        boolean isGroupRes = (docLibType.byteValue() == Constants.GROUP_LIB_TYPE.byteValue());

        // 页签显示标记
        String lPublic = request.getParameter("lPublic");
        String lPersonal = request.getParameter("lPersonal");
        String lBorrow = request.getParameter("lBorrow");
        String lExtend = request.getParameter("lExtend");

        long theDocLibId = 0L;
        boolean isPersonalLib = false;
        boolean isEdocLib = false;

        // 是否可以修改属性标记
        boolean bool = "true".equals(propEditValue) && "false".equals(isShareAndBorrowRoot);
        FolderItemFolder folderPropVO = null;
        List<DocPersonalShareVO> myGrantVO = null;
        List<PotentModel> grantVO = null;
        boolean userAllAcl = false;
        List<DocBorrowVO> borrowVO = null;
        DocPropVO docPropVO = null;
        DocLibTableVo libVO = null;
        boolean isDocLink = false;
        long docLibId;
        if (!isLib) {
            if ("true".equals(isFolder)) {
                // 取得文档夹属性
                folderPropVO = this.getFolderPropVO(request);
                folderPropVO.setName(Strings.toHTML(folderPropVO.getName()));
                docLibId = folderPropVO.getDocResource().getDocLibId();
                boolean isOwner = docLibManager.isOwnerOfLib(AppContext.currentUserId(),docLibId);
                // 取得共享数据
                if (lPersonal != null && "true".equals(lPersonal)||isOwner) {
                    myGrantVO = DocMVCUtils.getMyGrantVO(docResId, docAclManager);
                }

                if (lPublic != null && "true".equals(lPublic))
                    grantVO = this.getGrantVO(request, isGroupRes);

                String folderAcl = this.docAclManager.getAclString(docResId);
                mav.addObject("folderAcl", folderAcl);
                mav.addObject("editVersion", folderAcl.indexOf("all=true") != -1);

                theDocLibId = folderPropVO.getDocResource().getDocLibId();
            } else {
                // 取得借阅数据
                if (lBorrow != null && "true".equals(lBorrow))
                    borrowVO = this.getBorrowVO(request);

                // 取得属性
                docPropVO = this.getPropVOByDr(dr);
                docLibId = dr.getDocLibId();
                isDocLink = dr.getFrType() == Constants.LINK || dr.getFrType() == Constants.LINK_FOLDER;

                theDocLibId = dr.getDocLibId();
                mav.addObject("doc_fr_type", dr.getFrType());
            }
        } else {
            // 非个人文档库取得库的根文档夹的共享数据
            if ("true".equals(lPublic))
                grantVO = this.getGrantVO(request, isGroupRes);
            // 取得文档库属性，只读
            libVO = this.getLibVO(request);
            docLibId = libVO.getDoclib().getId();

            theDocLibId = docLibId;
            isPersonalLib = libVO.getDoclib().isPersonalLib();
            isEdocLib = libVO.getDoclib().isEdocLib();
        }

        if (grantVO != null) {
            StringBuilder ownerIds = new StringBuilder();
            for (PotentModel pm : grantVO) {
                //user类别有三类:人员、部门、单位
                if ((pm.getUserId() == AppContext.currentUserId()
                        || AppContext.getCurrentUser().getDepartmentId().equals(pm.getUserId()) || AppContext
                        .getCurrentUser().getAccountId().equals(pm.getUserId())) && pm.isAll()) {
                    userAllAcl = true;
                    break;
                }
            }
            boolean flag = false ;
            for (PotentModel pm : grantVO) {
                if (pm.getIsLibOwner()) {
                    if(flag){
                        ownerIds.append(",");
                    }
                    ownerIds.append(pm.getUserId());
                    flag = true;
                }
            }
            mav.addObject("ownerIds", ownerIds.toString());
        }
        String metadataHtml = null;
        if ("true".equals(lExtend)) {
            if (isHistory) {
                metadataHtml = htmlUtil.getHistoryViewHtml(docResId);
            } else {
                metadataHtml = htmlUtil.getEditHtml(docResId, (!bool));
            }
        }
        //是文档才能评论评分
        boolean isDoc = false;
        long frType =  dr.getFrType();
        if(Constants.DOCUMENT==frType||Constants.FOLDER_COMMON==frType){
            isDoc = true;
        }
        
        //是否为库管理员
        boolean isLibOwner = docHierarchyManager.isOwnerOfLib(docLibId, AppContext.getCurrentUser().getId());
        mav.addObject("isLibOwner", isLibOwner);
        mav.addObject("isDoc", isDoc);
        mav.addObject("maxFrOrder", maxFrOrder);
        mav.addObject("folderPropVO", folderPropVO);
        mav.addObject("myGrantVO", myGrantVO);
        mav.addObject("grantVO", grantVO);
        mav.addObject("userAllAcl", userAllAcl);
        mav.addObject("borrowVO", borrowVO);
        mav.addObject("docPropVO", docPropVO);
        mav.addObject("bool", bool);
        mav.addObject("libVO", libVO);
        mav.addObject("isLib", isLib);
        mav.addObject("isDocLink", isDocLink);
        mav.addObject("docLibId", docLibId);
        mav.addObject("metadataHtml", metadataHtml);
        //区隔
        mav.addObject("docForumFlag",SystemProperties.getInstance().getProperty("doc.forumFlag"));
        mav.addObject("docRecommendFlag",SystemProperties.getInstance().getProperty("doc.recommendFlag"));
        // 集团文档库可以跨单位授权
        mav.addObject("isGroupLib", (docLibType.byteValue() == Constants.GROUP_LIB_TYPE.byteValue()));
        // 单位文档、用户自定义文档（2009-08-24）及公文档案夹（2010-11-18）也开放共享范围，支持跨单位共享
        boolean openShareScope = docLibType.byteValue() == Constants.ACCOUNT_LIB_TYPE.byteValue()
                || docLibType.byteValue() == Constants.USER_CUSTOM_LIB_TYPE.byteValue()
                || docLibType.byteValue() == Constants.EDOC_LIB_TYPE.byteValue();
        mav.addObject("openShareScope", openShareScope);

        if (!isLib) {
            DocLibPO lib = docLibManager.getDocLibById(theDocLibId);
            if (lib != null) {
                isPersonalLib = lib.isPersonalLib();
                isEdocLib = lib.isEdocLib();
            }
        }

        return mav.addObject("isPersonalLib", isPersonalLib).addObject("isEdocLib", isEdocLib);
    }

    /**
     * 页签式页面数据的保存 包含 共享（个人，公共）、借阅、属性（常规+扩展）
     */
    public ModelAndView docLabeldSave(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException, IOException {
        Byte docLibType = Byte.valueOf(request.getParameter("docLibType"));
        String isFolder = request.getParameter("isFolder");

        String ucfProp = request.getParameter("ucfProp");
        String ucfVersionProp = request.getParameter("ucfVersionProp");
        String ucfPublic = request.getParameter("ucfPublic");
        String ucfPersonal = request.getParameter("ucfPersonal");
        String ucfBorrow = request.getParameter("ucfBorrow");

        Long docResId = Long.valueOf(request.getParameter("docResId"));
        if ("true".equals(isFolder)) {
            // 保存文档夹属性
            if ("true".equals(ucfProp)) {
                this.saveFolderProp(request);
            }

            // 保存共享数据
            if (docLibType.equals(Constants.PERSONAL_LIB_TYPE)) {
                if ("true".equals(ucfPersonal))
                    this.saveMyGrant(request);
            } else {
                if ("true".equals(ucfPublic))
                    this.saveGrant(request);
            }
        } else {
            // 权限操作
            if ("true".equals(ucfBorrow))
                this.saveBorrow(request);

            // 保存属性
            if ("true".equals(ucfProp) || "true".equals(ucfVersionProp)) {
                boolean saveVersion = "true".equals(ucfProp);
                this.saveDocProp(request, response, saveVersion);
            }
            this.updateIndex(docResId);
        }
        return null;
    }

    /**
     * 锁定文档进行编辑。
     */
    public ModelAndView lockDoc(HttpServletRequest request, HttpServletResponse response) throws IOException {
        long docResId = Long.parseLong(request.getParameter("docResId"));
        Long userId = AppContext.currentUserId();

        docHierarchyManager.checkOutDocResource(docResId, userId);
        super.rendJavaScript(response, "parent.window.location.reload(true);");
        return null;
    }

    /**
     * 释放文档锁。
     */
    public ModelAndView unlockDoc(HttpServletRequest request, HttpServletResponse response) throws IOException {
        long docResId = Long.parseLong(request.getParameter("docResId"));
        Long userId = AppContext.currentUserId();

        docHierarchyManager.checkInDocResourceWithoutAcl(docResId, userId);
        super.rendJavaScript(response, "parent.window.location.reload(true);");
        return null;
    }
    /**
     * 获取文档库前端展现所需的VO集合
     * @param includePersonalLib	是否包含个人文档库
     * @throws BusinessException 
     */
    private List<DocLibTableVo> getDocLibVOs(boolean includePersonalLib) throws BusinessException {
        Long currentUserId = AppContext.currentUserId();
        Long domainId = AppContext.getCurrentUser().getLoginAccount();
        List<DocLibPO> allDocLibsShow = this.getPagenatedDocLibs(includePersonalLib, currentUserId, domainId,false);
        List<Long> allLibIds = CommonTools.getIds(allDocLibsShow);
        Map<Long, DocResourcePO> allRootMap = this.docHierarchyManager.getRootMapByLibIds(allLibIds);

        List<DocLibTableVo> allLibVos = new ArrayList<DocLibTableVo>();
        boolean isEdoc = Functions.isEnableEdoc();
        boolean isPluginEdoc = AppContext.hasPlugin("edoc");
        boolean isPluginProject = AppContext.hasPlugin("project");
        if (CollectionUtils.isNotEmpty(allDocLibsShow)) {
        	allLibVos = getLibVos(allDocLibsShow,allRootMap,isEdoc,isPluginEdoc,isPluginProject,currentUserId);
        }
        return allLibVos;
    }

    /**
     * 在前端文档库查看时获取分页文档库结果集
     * @param includePersonalLib	是否包含个人文档库
     * @param currentUserId		当前用户ID
     * @param domainId		当前用户登录单位ID
     * @throws BusinessException 
     */
    private List<DocLibPO> getPagenatedDocLibs(boolean includePersonalLib, Long currentUserId, Long domainId,boolean isPage)
            throws BusinessException {
        List<DocLibPO> docLibs = null;
        if (includePersonalLib) {
            docLibs = docLibManager.getDocLibsByUserIdNav(currentUserId, domainId);
        } else {
            docLibs = docLibManager.getCommonDocLibsByUserId(currentUserId, domainId);
        }

        boolean showGroupLib = Constants.isShowGroupLib();
        boolean showEdocLib = AppContext.getCurrentUser().isInternal() && Constants.edocModuleEnabled();
        if (CollectionUtils.isNotEmpty(docLibs)) {
            for (Iterator<DocLibPO> iterator = docLibs.iterator(); iterator.hasNext();) {
                DocLibPO docLib = iterator.next();
                if ((!showGroupLib && docLib.isGroupLib()) || (!showEdocLib && docLib.isEdocLib())) {
                    iterator.remove();
                }
            }
        }
        if(isPage){
        	return CommonTools.pagenate(docLibs);
        }else{
        	return docLibs;
        }
    }

    /**
     * 从菜单"知识管理" -> "文档库管理"进入文档库管理列表页面（不包括用户个人文档库）
     * @throws BusinessException 
     */
    public ModelAndView docLibsConfig(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        List<DocLibTableVo> allLibVos = this.getDocLibVOs(false);
        return new ModelAndView("apps/doc/libRightWorkspace", "allLibVos", allLibVos);
    
    }

    private String getLibOwnerNames(List<Long> libOwners, boolean needAccountShort) {
        StringBuilder ownerNames = new StringBuilder();
        if (CollectionUtils.isNotEmpty(libOwners)) {
            int j = 0;
            for (Long memberId : libOwners) {
                String memberName = Constants.getOrgEntityName(V3xOrgEntity.ORGENT_TYPE_MEMBER, memberId,
                        needAccountShort);
                if (j != 0) {
                    ownerNames.append(Constants.getCommonI18nValue("common.separator.label") + memberName);
                } else {
                    ownerNames.append(memberName);
                }
                j++;
            }
        }
        return ownerNames.toString();
    }

    /**
     * 取得文档库的属性
     * @throws BusinessException 
     */
    public DocLibTableVo getLibVO(HttpServletRequest request) throws BusinessException {
        String sLibId = request.getParameter("docLibId");
        long currentUserId = AppContext.currentUserId();
        if (sLibId == null || "".equals(sLibId)) {
            return null;
        }
        Long libId = Long.valueOf(sLibId);
        DocLibPO lib = docLibManager.getDocLibById(libId);
        DocLibTableVo vo = new DocLibTableVo(lib);
        long userId = lib.getCreateUserId();
        vo.setCreateName(getUserName(userId)); // 获取创建者
        List<Long> the_manager = docLibManager.getOwnersByDocLibId(lib.getId());
        boolean isFromOtherAccount = (lib.getDomainId() != AppContext.getCurrentUser().getLoginAccount());
        String otherAccountShortName = "";
        if (isFromOtherAccount && !"".equals(vo.getCreateName())) {
            try {
                otherAccountShortName = "(" + this.orgManager.getAccountById(lib.getDomainId()).getShortName() + ")";
            } catch (BusinessException e) {
                log.error("获取当前文档库所在单位出现异常", e);
            }
        }
        StringBuilder manager_list = new StringBuilder();
        if (the_manager != null) {
            int j = 0;
            for (Long oid : the_manager) {
                V3xOrgMember _member = null;
                try {
                    _member = orgManager.getMemberById(oid);
                } catch (BusinessException e) {
                    log.error("orgManager取得member", e);
                }
                if (_member == null || !_member.isValid())
                    continue;
                if (j != 0) {
                    manager_list.append(",");
                }
                if (isFromOtherAccount) {
                    manager_list.append(_member.getName() + otherAccountShortName);
                } else {
                    manager_list.append(_member.getName());
                }

                j++;
                // 获取管理员
                // 设置管理员标记
                if (currentUserId == _member.getId().longValue())
                    vo.setIsOwner(true);
            }
        }
        vo.setManagerName(manager_list.toString());
        // 获取库类型
        vo.setDocLibType(Constants.getDocLibType(lib.getType()));
        // 设置库的根
        DocAclVO root = new DocAclVO(docHierarchyManager.getRootByLibId(libId));
        root.setIsPersonalLib(lib.isPersonalLib());
        vo.setIcon(this.getIcon(true, root.getDocResource().getMimeTypeId()));
        this.setGottenAclsInVO(root, currentUserId, false);
        vo.setRoot(root);
        return vo;
    }

    /**
     * 正则表达式转换文件名
     * @param name
     */
    private String checkAndRep(String name) {
        String rex = "[:\\/<>*?|]";
        Pattern p = Pattern.compile(rex);
        Matcher m = p.matcher(name);
        StringBuffer sbr = new StringBuffer();
        while (m.find()) {
            m.appendReplacement(sbr, "_");
        }
        m.appendTail(sbr);
        return sbr.toString();
    }

    /**
     * 文档日志导出excel
     * @throws BusinessException 
     */
    public ModelAndView fileLogToExcel(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        boolean search = Boolean.valueOf(request.getParameter("search")); 
        String flag = request.getParameter("flag");
        String isGroupLib = request.getParameter("isGroupLib");
        String docLibId = request.getParameter("docLibId");
        Long userId= AppContext.getCurrentUser().getId();
        String docResId = request.getParameter("docResourceId");
        String name = "";
        long drId = Long.valueOf(docResId);
        List<OperationLog> list = null;
        if(search){
        	String fromTime = request.getParameter("fromTime");
            String toTime = request.getParameter("toTime");
            String userName = request.getParameter("userName");
            String title = request.getParameter("title");
            String actionType = request.getParameter("actionType");
            DocResourcePO doc = docHierarchyManager.getDocResourceById(Long.parseLong(docResId));
        	List<Long> docIds = new ArrayList<Long>();
        	List<Long> libOwnerIds = DocMVCUtils.getLibOwners(doc);
            boolean isOwner = libOwnerIds != null && libOwnerIds.contains(userId);
        	if(isOwner){
            	List<DocResourcePO> docs = docHierarchyManager.getDocsByDocLibId(Long.parseLong(docLibId));
            	for(DocResourcePO d:docs){
            		docIds.add(d.getId());
            	}
                docIds.add(Long.parseLong(docResId));
            }else{
            	docIds = docHierarchyManager.getDocsByParentFrId(doc.getId());
            	List<Long> ids = new ArrayList<Long>();
            	ids.add(Long.parseLong(docResId));
            	for(Long docId:docIds){
            		Potent p = docAclManager.getAclVO(docId);
            		if(p.isAll()){
            			ids.add(docId);
            		}
            	}
            	docIds = new ArrayList<Long>();
            	docIds = ids;
            }
            Map<String,Object> map = new HashMap<String, Object>();
            map.put("userName", userName);
            map.put("fromTime", fromTime);
            map.put("toTime", toTime);
            map.put("title", title);
            map.put("actionType", actionType);
            
            list = operationlogManager.getAllOperationLogByConditions(docIds, false,map);
            name = "文档";
        }else {
        	DocResourcePO dr = docHierarchyManager.getDocResourceById(drId);
        	name = dr.getFrName();
        	if ("folderLog".equals(flag)) {
	        	list = operationlogManager.queryBySubObjectIdOrObjectId(drId, drId, false); // 查询出该文档在当前库中记录的所有日志
	        	name = ResourceUtil.getString(name);
	        } else {
	        	list = operationlogManager.queryByObjectId(drId, false);
	        }
        }	
        DataRecord dataRecord = new DataRecord();
        name = this.checkAndRep(name);
        if ("true".equals(isGroupLib)) {
            String[] columnName = { 
            		ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,"log.user"),
            		ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,"doc.jsp.log.account.label"),
            		ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,"log.operation"),
            		ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,"log.time"), 
            		ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,"log.description"),
            		ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,"log.remoteip") };
            dataRecord.setColumnName(columnName);
            dataRecord.setColumnWith(new short[] { 20, 30, 30, 30, 60, 30 });
        } else {
            String[] columnName = { 
            		ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,"log.user"), 
            		ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,"log.operation"),
            		ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,"log.time"), 
            		ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,"log.description"),
            		ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,"log.remoteip") };
            dataRecord.setColumnName(columnName);
            dataRecord.setColumnWith(new short[] { 20, 30, 30, 60, 30 });
        }
        dataRecord.setTitle(name + ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,"log.title"));
        dataRecord.setSheetName("sheet1");

        for (int i = 0; i < list.size(); i++) {
            DataRow row = new DataRow();
            OperationLog log_ = list.get(i);
            String user = "";
            V3xOrgMember member = null;
            try {
                member = orgManager.getMemberById(log_.getMemberId());
            } catch (BusinessException e) {
                log.error("orgManager取得member", e);
            }
            if (member != null)
                user = Functions.showMemberName(member); // 操作人
            String actionName = ResourceBundleUtil.getString(Constants.RESOURCE_BASENAME,log_.getActionType()); // 得到对应KEY的值
            row.addDataCell(user, DataCell.DATA_TYPE_TEXT);
            if ("true".equals(isGroupLib)) {
                V3xOrgAccount account = null;
                try {
                    account = orgManager.getAccountById(member.getOrgAccountId());
                    row.addDataCell(account.getShortName(), DataCell.DATA_TYPE_TEXT);
                } catch (BusinessException e) {
                    log.error("从orgManager取得用户", e);
                }
            }
            row.addDataCell(actionName, DataCell.DATA_TYPE_TEXT);
            row.addDataCell(log_.getActionTime().toString().substring(0, 16), DataCell.DATA_TYPE_DATETIME);

            //待确认
            String desc = ResourceBundleUtil.getStringOfParameterXML(Constants.RESOURCE_BASENAME,
                    log_.getContentLabel(), log_.getContentParameters());
            row.addDataCell(desc, DataCell.DATA_TYPE_TEXT);
            row.addDataCell(log_.getRemoteIp(), DataCell.DATA_TYPE_TEXT);
            try {
                dataRecord.addDataRow(row);
            } catch (Exception e) {
                log.error("日志的excel导出", e);
            }
        }
        try {
            if (dataRecord.getTitle().length() > 60)
                fileToExcelManager.save(response, dataRecord.getTitle().substring(0, 60), dataRecord);
            else
                fileToExcelManager.save(response, dataRecord.getTitle(), dataRecord);

        } catch (Exception e) {
            log.error("日志的excel导出", e);
        }
        return null;
    }

    /** 关联项目归档树框架  */
    public ModelAndView docTreeProjectIframe(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/docTreeProjectIframe");
    }

    /**
     * 关联项目归档树
     * @throws BusinessException 
     */
    public ModelAndView listProjectRoots(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView ret = new ModelAndView("apps/doc/docTreeProject");
        Long userId = AppContext.currentUserId();
        Long projectId = Long.valueOf(request.getParameter("projectId"));

        String hql = "from DocResourcePO as d where sourceId = ? and frType = ?";
        List<DocResourcePO> projects = docHierarchyManager.findDocResourceByHql(hql, projectId, Constants.FOLDER_CASE);

        DocResourcePO project = null;
        if (Strings.isEmpty(projects)) {
            return ret;
        } else {
            project = projects.get(0);
        }

        DocTreeVO projectvo = DocMVCUtils.getDocTreeVO(userId, project, Constants.PROJECT_LIB_TYPE, docMimeTypeManager,
                docAclManager);

        String hql2 = "from DocResourcePO as d where parentFrId = 0 and docLibId = ? ";
        List<DocResourcePO> roots = docHierarchyManager.findDocResourceByHql(hql2, project.getDocLibId());
        DocResourcePO root = null;
        if (Strings.isEmpty(roots)) {
            return ret;
        } else {
            root = roots.get(0);
        }
        DocTreeVO rootvo = DocMVCUtils.getDocTreeVO(userId, root, Constants.PROJECT_LIB_TYPE, docMimeTypeManager,
                docAclManager);
        return ret.addObject("root", rootvo).addObject("project", projectvo);
    }

    // 弹出树
    public ModelAndView xmlJspProject(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        response.setContentType("text/xml");
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        Long userId = AppContext.currentUserId();

        String sparentId = request.getParameter("resId");
        Long parentId = Long.valueOf(sparentId);
        String stype = request.getParameter("frType");
        Long frType = Long.valueOf(stype);
        DocResourcePO parent = docHierarchyManager.getDocResourceById(parentId);

        // 对于资源是否存在的判断
        if (parent == null) {
            out.println("<exist>no</exist>");
            return null;
        }

        DocLibPO lib = docLibManager.getDocLibById(parent.getDocLibId());
        boolean isPersonalLib = lib.isPersonalLib();
        List<DocResourcePO> drs = null;
        if (isPersonalLib) {
            drs = docHierarchyManager.findFolders(parentId, frType, userId, "", true,null);
        } else {
            String orgIds = Constants.getOrgIdsOfUser(userId);
            drs = docHierarchyManager.findFolders(parentId, frType, userId, orgIds, false,null);
        }
        if (Strings.isEmpty(drs)) {
            return null;
        }
        List<DocTreeVO> folders = new ArrayList<DocTreeVO>();
        for (DocResourcePO dr : drs) {
            DocTreeVO vo = this.getDocTreeVO(userId, dr, isPersonalLib);
            folders.add(vo);
        }

        out.println("<tree text=\"loaded\">");
        String xmlstr = DocMVCUtils.getXmlStr4LoadNodeOfProjectTree(folders);
        out.println(xmlstr);
        out.println("</tree>");

        return null;
    }

    // 发送到常用文档
    public ModelAndView sendToFavorites(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String successKey = "doc.myfavorite.success.alert";
        String failureKey = "doc.myfavorite.failure.alert";
        try {
            String sdocid = request.getParameter("docId");
            String userIds = request.getParameter("userIds");
            String userType = request.getParameter("userType");
            String orgType = V3xOrgEntity.ORGENT_TYPE_MEMBER;
            List<Long> orgIds = new ArrayList<Long>();

            if ("member".equals(userType)) {
                orgIds.add(AppContext.currentUserId());
            } else if ("dept".equals(userType)) {
                successKey = "doc.favorite.dept.success.alert";
                failureKey = "doc.favorite.dept.failure.alert";

                orgType = V3xOrgEntity.ORGENT_TYPE_DEPARTMENT;
                if (userIds == null || "".equals(userIds)) {
                    // 预防跨部门担任管理员
                    Set<Long> depts = DocMVCUtils.getDeptsByManagerSpace(spaceManager, AppContext.currentUserId());

                    if (depts != null && depts.size() > 0) {
                        orgIds.add(depts.iterator().next());
                    } else
                        orgIds.add(AppContext.getCurrentUser().getDepartmentId());
                } else {
                    StringTokenizer stk = new StringTokenizer(userIds, ",");
                    while (stk.hasMoreTokens()) {
                        orgIds.add(Long.valueOf(stk.nextToken()));
                    }
                }
            } else if ("account".equals(userType)) {
                successKey = "doc.favorite.account.success.alert";
                failureKey = "doc.favorite.account.failure.alert";
                orgType = V3xOrgEntity.ORGENT_TYPE_ACCOUNT;
                orgIds.add(AppContext.getCurrentUser().getLoginAccount());
            } else if ("group".equals(userType)) {
                successKey = "doc.favorite.group.success.alert";
                failureKey = "doc.favorite.group.failure.alert";
                orgType = Constants.ORGENT_TYPE_GROUP;
                orgIds.add(0L);
            }

            if (sdocid == null || "".equals(sdocid)) {
                // 上面菜单
                String[] ids = {};
                String[] isNewView = request.getParameterValues("isNewView");
        		if (isNewView.length > 0 && Boolean.parseBoolean(isNewView[0])){
        			ids = request.getParameterValues("newCheckBox");
                }else{
                	ids = request.getParameterValues("id");
                }
                List<Long> docIds = new ArrayList<Long>();
                if (ids != null && ids.length > 0) {
                    for (String s : ids) {
                        // 存在性验证
                        Long drsId = NumberUtils.toLong(s);
                        if (docHierarchyManager.docResourceExist(drsId)) {
                            docIds.add(drsId);
                            docActionManager.insertDocAction(AppContext.currentUserId(), AppContext.currentAccountId(),
                                    new Date(), DocActionEnum.sendKonwledge.key(), drsId, orgType);
                        }
                    }
                }

                docFavoriteManager.setFavoriteDoc(docIds, orgIds, orgType);
            } else {
                // 右键菜单过来，单个文档id
                long docId = Long.valueOf(sdocid);
                // 存在性验证
                if (docHierarchyManager.docResourceExist(docId)) {
                    docFavoriteManager.setFavoriteDoc(docId, orgIds, orgType);
                    docActionManager.insertDocAction(AppContext.currentUserId(), AppContext.currentAccountId(),
                            new Date(), DocActionEnum.sendKonwledge.key(), docId, orgType);
                }
            }
            return sendToReturn(request,response,successKey);
           
        } catch (Exception e) {
            log.error("发送到常用文档", e);
            return sendToReturn(request,response,failureKey);
        }
    }

    /** 更多常用文档   
     * @throws BusinessException */
    @SuppressWarnings("unchecked")
    public ModelAndView docFavoriteMore(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView mav = new ModelAndView("apps/doc/docFavoriteMore");

        Long userId = AppContext.currentUserId();
        String orgIds = Constants.getOrgIdsOfUser(userId);

        String userType = request.getParameter("userType");
        String orgType = V3xOrgEntity.ORGENT_TYPE_MEMBER;
        String titlePostfix = "personal";
        long orgId = userId;
        if ("dept".equals(userType)) {
            orgType = V3xOrgEntity.ORGENT_TYPE_DEPARTMENT;
            orgId = AppContext.getCurrentUser().getDepartmentId();
            String sdepId = request.getParameter("deptId");
            if (sdepId != null && !"".equals(sdepId)) {
                orgId = Long.valueOf(sdepId);
            }
            titlePostfix = "dept";
        } else if ("account".equals(userType)) {
            orgType = V3xOrgEntity.ORGENT_TYPE_ACCOUNT;
            orgId = AppContext.getCurrentUser().getLoginAccount();
            titlePostfix = "account";
        } else if ("group".equals(userType)) {
            orgType = Constants.ORGENT_TYPE_GROUP;
            orgId = AppContext.getCurrentUser().getAccountId();
            //GOV-4188.公共空间里点击组织学习区和组织知识文档 start
            if ((Boolean) SysFlag.is_gov_only.getFlag()) {
                titlePostfix = "gov";
            } else {
                titlePostfix = "group";
            }
            //GOV-4188.公共空间里点击组织学习区和组织知识文档 end
        }

        // 分页数据
        int pageNo = NumberUtils.toInt(request.getParameter("page"), 1);
        int pageSize = NumberUtils.toInt(request.getParameter("pageSize"), 20);
        Pagination.setFirstResult((pageNo - 1) * pageSize);
        Pagination.setMaxResults(pageSize);
        
        String condition = request.getParameter("condition");
        List alist = null;
        if (Strings.isNotBlank(condition)) {
            String value = "";
            if ("createDate".equals(condition)) {
                value = request.getParameter("textfield") + " # " + request.getParameter("textfield1");
            } else {
                value = request.getParameter("textfield");
            }
            if(Strings.isBlank(value)){
            	alist = docFavoriteManager.getFavoritesByPage(orgType, orgId);
            }else{
            	alist = docFavoriteManager.getFavoritesByPage(orgType, orgId, condition, value);
            }
        } else {
            alist = docFavoriteManager.getFavoritesByPage(orgType, orgId);
        }

        List<DocFavoritePO> dfs = (List<DocFavoritePO>) (alist.get(1));
        List<DocFavoriteVO> dfvos = this.getDocFavoriteVos(dfs, userId, orgIds);

        boolean canAdmin = true;
        if (!orgType.equals(V3xOrgEntity.ORGENT_TYPE_MEMBER)) {
            canAdmin = this.canAdminSpace(orgType, orgId);
        }

        mav.addObject("canAdmin", canAdmin);
        mav.addObject("dfvos", dfvos);
        mav.addObject("siteType", orgType);
        mav.addObject("siteId", orgId);
        mav.addObject("userType", userType);
        mav.addObject("total", (Integer) (alist.get(0)));
        mav.addObject("title", "doc.jsp.home.more.favorite.title." + titlePostfix);
        mav.addObject("types", contentTypeManager.getAllSearchContentType());
        return mav;
    }

    // 判断是否具有空间管理权限
    private boolean canAdminSpace(String spaceType, Long spaceId) throws BusinessException {
        if (spaceType == null) {
            return false;
        }
        if (V3xOrgEntity.ORGENT_TYPE_DEPARTMENT.equals(spaceType)) {
            return DocMVCUtils.isDeptSpaceManager(spaceManager, AppContext.currentUserId(), spaceId);
        } else if (V3xOrgEntity.ORGENT_TYPE_ACCOUNT.equals(spaceType)) {
        	return DocMVCUtils.isAccountSpaceManager(spaceManager, AppContext.currentUserId(), AppContext.currentAccountId());
        } else if (Constants.ORGENT_TYPE_GROUP.equals(spaceType)) {
            return DocMVCUtils.isGroupSpaceManager(spaceManager, AppContext.currentUserId());
        }
        return false;
    }

    /** 更多最新订阅  
     * @throws BusinessException */
    public ModelAndView docAlertLatestMore(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView mav = new ModelAndView("apps/doc/docAlertLatestMore");
        byte status = Constants.DOC_ALERT_STATUS_ALL;
        String statu = request.getParameter("status");

        if (statu != null) {
            status = Byte.valueOf(statu);
            mav = new ModelAndView("apps/doc/docAlertLatestMoreMine");
        }

        String flag = request.getParameter("flag");
        if ("doc".equals(flag)) {
            mav.addObject("flag", flag);
        } else {
            mav.addObject("flag", "front");
        }

        User user = AppContext.getCurrentUser();
        Long userId = user.getId();
        String orgIds = Constants.getOrgIdsOfUser(userId);
        long alertUserId = userId;
        List<DocAlertLatestPO> dals = new ArrayList<DocAlertLatestPO>();
        try {
            String condition = request.getParameter("condition");
            if (condition != null && !"".equals(condition)) {
                String value = "";
                if ("createDate".equals(condition)) {
                    value = request.getParameter("textfield") + " # " + request.getParameter("textfield1");
                } else {
                    value = request.getParameter("textfield");
                }
                dals = docAlertLatestManager.findAlertLatestsByUserPaged(alertUserId, status, condition, value);
            } else {
                dals = docAlertLatestManager.findAlertLatestsByUserPaged(alertUserId, status);
            }
        } catch (BusinessException e) {
            log.error("", e);
        }
        List<DocAlertLatestVO> dalvos = this.getAlertLatestVos(dals, userId, orgIds);
        mav.addObject("dalvos", dalvos);
        mav.addObject("status", statu);
        mav.addObject("types", contentTypeManager.getAllSearchContentType());
        return mav;
    }

    /** 取消常用文档  */
    public ModelAndView docAlertLatestDel(HttpServletRequest request, HttpServletResponse response) {
        String ids = request.getParameter("ids");
        docAlertLatestManager.deleteLatestByIds(ids);
        String statu = request.getParameter("status");
        String flag = request.getParameter("flag");
        return redirectModelAndView("/doc.do?method=docAlertLatestMore&status=" + statu + "&flag=" + flag, "parent");
    }

    /** 取消常用文档  */
    public ModelAndView docFavoriteCancel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String ids = request.getParameter("ids");
        docFavoriteManager.deleteFavoriteDocByIds(ids);
        super.rendJavaScript(response, "parent.location.reload(true);");
        return null;
    }

    // 修改常用文档显示顺序
    public ModelAndView docFavoriteResort(HttpServletRequest request, HttpServletResponse response) {
        long srcId = Long.valueOf(request.getParameter("id"));
        long destId = Long.valueOf(request.getParameter("destId"));
        String flag = request.getParameter("flag");
        if ("up".equals(flag)) {
            docFavoriteManager.updateDocFavoriteOrderUp(srcId, destId);
        } else if ("down".equals(flag)) {
            docFavoriteManager.updateDocFavoriteOrderDown(srcId, destId);
        }

        return null;
    }

    /** 封装 DocFavoriteVO 
     * @throws BusinessException */
    private List<DocFavoriteVO> getDocFavoriteVos(List<DocFavoritePO> dfs, Long userId, String orgIds)
            throws BusinessException {
        if (Strings.isEmpty(dfs)) {
            return new ArrayList<DocFavoriteVO>();
        }
        List<DocFavoriteVO> ret = new ArrayList<DocFavoriteVO>();
        for (DocFavoritePO df : dfs) {
            DocResourcePO dr = df.getDocResource();
            DocFavoriteVO vo = new DocFavoriteVO(df);
            this.setGottenAclsInVO(vo, AppContext.currentUserId(), false);
            if (dr.getFrType() == Constants.LINK) {
                vo.setIsLink(true);
            } else if (dr.getFrType() == Constants.LINK_FOLDER) {
                vo.setIsFolderLink(true);
            }
            vo.setCreateUserName(getUserName(dr.getCreateUserId()));

            DocLibPO lib = docLibManager.getDocLibById(dr.getDocLibId());
            vo.setDocLibType(lib.getType());
            vo.setIcon(this.getIcon(dr.getIsFolder(), dr.getMimeTypeId()));
            vo.setType(contentTypeManager.getContentTypeById(dr.getFrType()).getName());
            vo.setHasAttachments(dr.getHasAttachments());
            ret.add(vo);
        }
        return ret;
    }

    // 封装 DocAlertLatestVO
    private List<DocAlertLatestVO> getAlertLatestVos(List<DocAlertLatestPO> dals, Long userId, String orgIds)
            throws BusinessException {
        if (dals == null) {
            return new ArrayList<DocAlertLatestVO>();
        }
        List<DocAlertLatestVO> ret = new ArrayList<DocAlertLatestVO>();
        for (DocAlertLatestPO dal : dals) {
            DocResourcePO dr = docHierarchyManager.getDocResourceById(dal.getDocResourceId());
            DocAlertLatestVO vo = new DocAlertLatestVO(dal, dr);
            vo.setLastUserName(getUserName(dr.getLastUserId()));
            this.setGottenAclsInVO(vo, AppContext.currentUserId(), false);
            if (dr.getFrType() == Constants.LINK || dr.getFrType() == Constants.LINK_FOLDER) {
                vo.setIsLink(true);
            }

            DocLibPO lib = docLibManager.getDocLibById(dr.getDocLibId());
            vo.setDocLibType(lib.getType());
            vo.setIcon(this.getIcon(dr.getIsFolder(), dr.getMimeTypeId()));

            DocTypePO docType = contentTypeManager.getContentTypeById(dr.getFrType());
            vo.setType(docType.getName());

            String oprType = ResourceUtil.getString(Constants.getAlertTypeKey(dal.getChangeType()));
            vo.setOprType(oprType);

            ret.add(vo);
        }
        return ret;
    }

    /**
     * 文档夹修改属性的影响范围确定
     */
    public ModelAndView folderPropEditScopeView(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/folderPropEditScope");
    }

    /**
     * 转换成标准的office
     */
    private void toStanderOffice(String subject, List<Attachment> atts, V3XFile file) throws BusinessException,
            FileNotFoundException {
        String srcPath=fileManager.getFolder(file.getCreateDate(), true) + File.separator+ String.valueOf(file.getId());
        try {
            //1.解密文件
            String newPath  = CoderFactory.getInstance().decryptFileToTemp(srcPath);
            //2.转换成标准正文
            String newPathName = SystemEnvironment.getSystemTempFolder() + File.separator + String.valueOf(UUIDLong.longUUID());
            Util.jinge2StandardOffice(newPath, newPathName);
            //3.构造输入流
            InputStream in  = new FileInputStream(new File(newPathName)) ;
            V3XFile f = fileManager.save(in, ApplicationCategoryEnum.doc, subject, file.getCreateDate(), false);
            atts.add(new Attachment(f, ApplicationCategoryEnum.edoc, com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE.FILE));
        } catch (Exception e) {
            log.error("", e);
        }
       
    }

    /**
     * 转发邮件
     */
    public ModelAndView sendToWebMail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user =AppContext.getCurrentUser();
        try {
            if (!webmailApi.hasDefaultMbc(user.getId())) {
                ModelAndView mav = new ModelAndView("webmail/error");
                mav.addObject("errorMsg", "2");
                mav.addObject("url", "?method=list&jsp=set");
                return mav;
            }
        } catch (Exception e1) {
            log.error("调用邮件接口判断当前用户是否有邮箱设置：", e1);
        }

        Long docResId = Long.valueOf(request.getParameter("docResId"));
        DocResourcePO dr = docHierarchyManager.getDocResourceById(docResId);
        if (dr == null) {
            super.rendJavaScript(response, "alert('" + Constants.getDocI18nValue("doc.src.deleted")
                    + "');parent.window.history.back();");
            return null;
        }

        long formatType = docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getFormatType();
        String subject = dr.getFrName();
        if (formatType == Constants.FORMAT_TYPE_DOC_WORD){
            subject += ".doc";
        }else if (formatType == Constants.FORMAT_TYPE_DOC_EXCEL){
            subject += ".xls";
        }else if (formatType == Constants.FORMAT_TYPE_DOC_WORD_WPS){
            subject += ".wps";
        }else if (formatType == Constants.FORMAT_TYPE_DOC_EXCEL_WPS){
            subject += ".et";
        }else if(formatType == MainbodyType.HTML.getKey()){
            subject += ".html";
        }
        
        String bodyContent = "";
        List<Attachment> atts = new ArrayList<Attachment>();
        if (formatType != Constants.FORMAT_TYPE_DOC_FILE) {
            atts = attachmentManager.getByReference(docResId);

            DocBodyPO body = docHierarchyManager.getBody(docResId);
            bodyContent = body.getContent();

            if (formatType == Constants.FORMAT_TYPE_DOC_EXCEL || formatType == Constants.FORMAT_TYPE_DOC_EXCEL_WPS
                    || formatType == Constants.FORMAT_TYPE_DOC_WORD || formatType == Constants.FORMAT_TYPE_DOC_WORD_WPS) {
                String bodyType = body.getBodyType();
                Long fileId = Long.valueOf(bodyContent);
                bodyContent = "";

                String bodyFileName = dr.getFrName();
                try {
                    InputStream in = fileManager.getStandardOfficeInputStream(fileId, dr.getCreateTime());
                    if (com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_WORD.equals(bodyType)) {
                        bodyFileName += ".doc";
                    } else if (com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_EXCEL.equals(bodyType)) {
                        bodyFileName += ".xls";
                    } else if (com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_WPS_WORD.equals(bodyType)) {
                        bodyFileName += ".wps";
                    } else if (com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_WPS_EXCEL.equals(bodyType)) {
                        bodyFileName += ".et";
                    }

                    V3XFile file3x = fileManager.save(in, ApplicationCategoryEnum.mail, bodyFileName,
                            dr.getCreateTime(), false);
                    Attachment att = new Attachment(file3x, ApplicationCategoryEnum.mail,
                            com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE.FILE);
                    if (atts == null)
                        atts = new ArrayList<Attachment>();
                    atts.add(att);
                } catch (Exception e) {
                    log.error("转发邮件中，在线编辑的office文档转换为附件 ", e);
                }
            }
        } else {
            V3XFile file = null;
            try {
                file = fileManager.getV3XFile(dr.getSourceId());
                if (file.getType() == null) {
                    file.setType(com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE.FILE.ordinal());
                }
                File realFile = fileManager.getFile(file.getId());
                if (realFile == null || !realFile.exists()) {
                    super.rendJavaScript(response, "alert('" + Constants.getDocI18nValue("doc.src.deleted")
                            + "');parent.window.history.back();");
                    return null;
                }
            } catch (BusinessException e) {
                log.error("取得V3xFile", e);
            }
            Attachment att = new Attachment(file);
            att.setFilename(dr.getFrName());
            atts.add(att);
        }
        this.docHierarchyManager.logForward("true", docResId);
        return webmailApi.forwardMail(docResId, subject, bodyContent, atts);
    }

    /**
     * 进入签出文档管理界面iframe
     */
    public ModelAndView docCheckoutIframe(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/docCheckoutIframe");
    }

    /**
     * 进入签出文档管理界面
     */
    public ModelAndView docCheckoutView(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView ret = new ModelAndView("apps/doc/docCheckoutAdmin");
        long docLibId = Long.valueOf(request.getParameter("docLibId"));
        List<DocResourcePO> drs = docHierarchyManager.findAllCheckoutDocsByDocLibIdByPage(docLibId);
        List<DocCheckOutVO> vos = this.getCheckoutVos(drs);
        ret.addObject("covos", vos);
        return ret;
    }

    // 封装 DocCheckOutVo
    private List<DocCheckOutVO> getCheckoutVos(List<DocResourcePO> drs) {
        List<DocCheckOutVO> vos = new ArrayList<DocCheckOutVO>();
        if (Strings.isEmpty(drs)){
            return vos;
        }
        for (DocResourcePO d : drs) {
            DocCheckOutVO vo = new DocCheckOutVO(d);
            vo.setCheckOutUserName(Functions.showMemberName(d.getCheckOutUserId()));
            DocTypePO type = contentTypeManager.getContentTypeById(d.getFrType());
            if (type != null)
                vo.setType(type.getName());
            vo.setPath(this.getPhysicalPath(d.getLogicalPath()));
            vo.setIcon(this.getIcon(false, d.getMimeTypeId()));
            vos.add(vo);
        }

        return vos;
    }

    /**
     * 签入文档
     */
    public ModelAndView docCheckin(HttpServletRequest request, HttpServletResponse response) {
        String[] ids = request.getParameterValues("id");
        long userId = AppContext.currentUserId();
        for (String id : ids) {
            docHierarchyManager.checkInDocResourceWithoutAcl(Long.valueOf(id), userId);
        }
        return this.docCheckoutView(request, response);
    }

    /** ******************* 文档订阅开始 ***************************** */

    /** 文档订阅管理框架 */
    public ModelAndView docAlertAdminIndex(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/docAlertAdmin/index");
    }

    /** 文档订阅管理列表 
     * @throws BusinessException */
    public ModelAndView docAlertAdminList(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        List<DocAlertAdminVO> davos = this.getDocAlertAdminVO();
        boolean isA6Flag = DocMVCUtils.isOnlyA6()||DocMVCUtils.isOnlyA6S()||DocMVCUtils.isGovVer()||DocMVCUtils.isG6Group();
        boolean isShowLoctions = true;
        String isG6 = SystemProperties.getInstance().getProperty("edoc.isG6");
        if (isA6Flag || "true".equals(isG6)) {
        	isShowLoctions  = false;
        }
        return new ModelAndView("apps/doc/docAlertAdmin/list", "davos", davos).addObject("isShowLoction",isShowLoctions);
    }

    /** 获取文档订阅管理的列表元素VO 
     * @throws BusinessException */
    private List<DocAlertAdminVO> getDocAlertAdminVO() throws BusinessException {
        List<List<DocAlertPO>> das = docAlertManager.findAllAlertsOfCurrentUserByPage();
        List<DocAlertAdminVO> davos = new ArrayList<DocAlertAdminVO>();
        for (List<DocAlertPO> dalist : das) {
            DocResourcePO dr = docHierarchyManager.getDocResourceById(dalist.get(0).getDocResourceId());
            if (dr == null)
                continue;
            davos.add(this.getDocAlertAdminVO(dalist, dr, "list"));
        }

        Collections.sort(davos);
        return davos;
    }

    /** 文档订阅管理查看 */
    public ModelAndView docAlertAdminView(HttpServletRequest request, HttpServletResponse response) {
        String alertIds = request.getParameter("alertIds");
        List<DocAlertPO> das = docAlertManager.findAlertsByIds(alertIds);
        DocResourcePO dr = docHierarchyManager.getDocResourceById(das.get(0).getDocResourceId());
        DocAlertAdminVO vo = this.getDocAlertAdminVO(das, dr, "view");
        return new ModelAndView("apps/doc/docAlertAdmin/view", "vo", vo);
    }

    /** 进入文档订阅管理的修改页面  */
    public ModelAndView docAlertAdminEdit(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView("apps/doc/docAlertAdmin/edit");
        String alertIds = request.getParameter("alertIds");
        List<DocAlertPO> das = docAlertManager.findAlertsByIds(alertIds);
        DocResourcePO dr = docHierarchyManager.getDocResourceById(das.get(0).getDocResourceId());
        DocAlertAdminVO vo = this.getDocAlertAdminVO(das, dr, "view");
        mav.addObject("isFolder", dr.getIsFolder());
        mav.addObject("docResId", dr.getId());
        mav.addObject("editFlag", true);
        mav.addObject("comment", dr.getCommentEnabled());
        mav.addObject("vo", vo);
        String name = ResourceUtil.getString(dr.getFrName());
        return mav.addObject("name", name);
    }

    /** 文档个人订阅修改页面的保存  */
    public ModelAndView docAlertEdit(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long userId = AppContext.currentUserId();
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        boolean isFolder = Boolean.parseBoolean(request.getParameter("isFolder"));
        String alertIds = request.getParameter("alertIds");
        boolean sendMessage = "true".equals(request.getParameter("message"));
        boolean setSubFolder = "true".equals(request.getParameter("check_box_subFolder"));
        docAlertManager.deleteAlertsByIds(alertIds);

        Set<Byte> typeSet = this.getTypes4Alert(request);
        if (typeSet.size() == 4) {
            docAlertManager.addAlert(docResId, isFolder, Constants.ALERT_OPR_TYPE_ALL, V3xOrgEntity.ORGENT_TYPE_MEMBER,
                    userId, userId, sendMessage, setSubFolder, false);
        } else if (typeSet.size() > 0) {
            for (Byte alertOprType : typeSet) {
                docAlertManager.addAlert(docResId, isFolder, alertOprType, V3xOrgEntity.ORGENT_TYPE_MEMBER, userId,
                        userId, sendMessage, setSubFolder, false);
            }
        }
        super.rendJavaScript(response, "parent.window.closeAndRef();");
        return null;
    }

    /**
     * 放弃修改文档订阅
     */
    public ModelAndView docAlertCancel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        docAlertManager.deleteAlertsByIds(request.getParameter("ids"));
        super.rendJavaScript(response, "parent.location.reload(true);");
        return null;
    }

    /**
     * 封装文档订阅管理vo
     */
    private DocAlertAdminVO getDocAlertAdminVO(List<DocAlertPO> docAlerts, DocResourcePO docResource, String from) {
        DocAlertAdminVO vo = new DocAlertAdminVO(docAlerts, docResource);

        if ("list".equals(from)) {
            // 列表显示
            vo.setIcon(this.getIcon(docResource.getIsFolder(), docResource.getMimeTypeId()));
            DocTypePO type = contentTypeManager.getContentTypeById(docResource.getFrType());
            if (type != null)
                vo.setType(type.getName());
            vo.setAlertCreater(getUserName(docAlerts.get(0).getCreateUserId()));
        } else if ("view".equals(from)) {
            // 详细查看
            vo.setPath(this.getPhysicalPath(docResource.getLogicalPath()));
            DocTypePO type = contentTypeManager.getContentTypeById(docResource.getFrType());
            if (type != null)
                vo.setType(type.getName());
            vo.setAlertCreater(getUserName(docResource.getCreateUserId()));
        } else if ("edit".equals(from)) {
            // 修改页面
        }

        return vo;
    }

    /** 进入个人文档订阅设置窗口  */
    public ModelAndView docAlertView(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView("apps/doc/docAlert");
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        DocResourcePO dr = docHierarchyManager.getDocResourceById(docResId);
        List<DocAlertPO> alerts = docAlertManager.findPersonalAlertByDrIdOfCurrentUser(docResId);
        boolean editFlag = false;
        DocAlertAdminVO vo = null;
        if (alerts != null && alerts.size() > 0) {
            editFlag = true;
            vo = this.getDocAlertAdminVO(alerts, dr, "set");
        }
        mav.addObject("isFolder", dr.getIsFolder());
        mav.addObject("docResId", docResId);
        mav.addObject("editFlag", editFlag);
        mav.addObject("name", dr.getFrName());
        mav.addObject("vo", vo);
        mav.addObject("commentEnable", dr.getCommentEnabled());
        //区隔
        mav.addObject("docOpenFlag",SystemProperties.getInstance().getProperty("doc.docOpenFlag"));
        return mav;
    }

    /**
     * 根据用户前端的选择，确定需要提醒的文档操作类型
     */
    private Set<Byte> getTypes4Alert(HttpServletRequest request) {
        String add = request.getParameter("check_box_add");
        String edit = request.getParameter("check_box_edit");
        String delete = request.getParameter("check_box_delete");
        String forum = request.getParameter("check_box_forum");

        Set<Byte> typeSet = new HashSet<Byte>();
        if (add != null)
            typeSet.add(Constants.ALERT_OPR_TYPE_ADD);
        if (edit != null)
            typeSet.add(Constants.ALERT_OPR_TYPE_EDIT);
        if (delete != null)
            typeSet.add(Constants.ALERT_OPR_TYPE_DELETE);
        if (forum != null)
            typeSet.add(Constants.ALERT_OPR_TYPE_FORUM);

        return typeSet;

    }

    /** 文档个人订阅设置页面的保存  */
    public ModelAndView docAlert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long userId = AppContext.currentUserId();
        Long docResId = Long.valueOf(request.getParameter("docResId"));
        boolean isFolder = Boolean.parseBoolean(request.getParameter("isFolder"));
        boolean sendMessage = "true".equals(request.getParameter("message"));
        boolean setSubFolder = false;

        docAlertManager.deleteAlertByDocResourceIdOfCurrentUesr(docResId);

        Set<Byte> typeSet = this.getTypes4Alert(request);
        if (typeSet.isEmpty()) {
            docAlertLatestManager.deleteAlertLatestByDrIdAndOprTypeOfCurrentUser(docResId, null);
        } else if (typeSet.size() == 4) {
            docAlertManager.addAlert(docResId, isFolder, Constants.ALERT_OPR_TYPE_ALL, V3xOrgEntity.ORGENT_TYPE_MEMBER,
                    userId, userId, sendMessage, setSubFolder, false);
        } else {
            // 删除不订阅的 DocAlertLatest
            Set<Byte> delTypes = new HashSet<Byte>();
            if (!typeSet.contains(Constants.ALERT_OPR_TYPE_EDIT))
                delTypes.add(Constants.ALERT_OPR_TYPE_EDIT);
            if (!typeSet.contains(Constants.ALERT_OPR_TYPE_FORUM))
                delTypes.add(Constants.ALERT_OPR_TYPE_FORUM);
            if (!typeSet.contains(Constants.ALERT_OPR_TYPE_ADD))
                delTypes.add(Constants.ALERT_OPR_TYPE_ADD);
            if (!typeSet.contains(Constants.ALERT_OPR_TYPE_DELETE))
                delTypes.add(Constants.ALERT_OPR_TYPE_DELETE);

            if(!delTypes.isEmpty()){
                docAlertLatestManager.deleteAlertLatestByDrIdAndOprTypeOfCurrentUser(docResId, delTypes);
            }
            for (Byte alertOprType : typeSet) {
                docAlertManager.addAlert(docResId, isFolder, alertOprType, V3xOrgEntity.ORGENT_TYPE_MEMBER, userId,
                        userId, sendMessage, setSubFolder, false);
            }
            if (!isFolder) {
                docAlertManager.addToLatest(docResId, userId);
            }

        }
        Boolean f = (Boolean) (BrowserFlag.OpenWindow.getFlag(AppContext.getCurrentUser()));
        if (f) {
            super.rendJavaScript(response, "parent.close();");
        } else {
            super.rendJavaScript(response, "parent.parent.winDocAlert.close();");
        }
        return null;
    }

    /** 发送到学习区  */
    public ModelAndView sendToLearn(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String successKey = "doc.learning.personal.success.alert";
        String failureKey = "doc.learning.personal.failure.alert";
        Long userId = AppContext.currentUserId();
        Long accountId = AppContext.currentAccountId();
        try {
            String sdocid = request.getParameter("docId");
            String userIds = request.getParameter("userIds");
            String userType = request.getParameter("userType");
            String orgType = V3xOrgEntity.ORGENT_TYPE_MEMBER;
            List<Long> orgIds = new ArrayList<Long>();
            List<String> orgTypes = new ArrayList<String>();
            if ("member".equals(userType)) {
                String[] ss = userIds.split(",");
                for (String s : ss) {
                    String[] sss = s.split("\\|");
                    orgIds.add(Long.valueOf(sss[0]));
                    orgTypes.add(sss[1]);
                }
            } else if ("dept".equals(userType)) {
                successKey = "doc.learning.dept.success.alert";
                failureKey = "doc.learning.dept.failure.alert";

                orgType = V3xOrgEntity.ORGENT_TYPE_DEPARTMENT;
                if (userIds == null || "".equals(userIds)) {
                    // 预防跨部门担任管理员
                    Set<Long> depts = DocMVCUtils.getDeptsByManagerSpace(spaceManager, AppContext.currentUserId());

                    if (depts != null && depts.size() > 0) {
                        orgIds.add(depts.iterator().next());
                        orgTypes.add(orgType);
                    } else {
                        orgIds.add(AppContext.getCurrentUser().getDepartmentId());
                        orgTypes.add(orgType);
                    }
                } else {
                    StringTokenizer stk = new StringTokenizer(userIds, ",");
                    while (stk.hasMoreTokens()) {
                        orgIds.add(Long.valueOf(stk.nextToken()));
                        orgTypes.add(orgType);
                    }
                }
            } else if ("account".equals(userType)) {
                successKey = "doc.learning.account.success.alert";
                failureKey = "doc.learning.account.failure.alert";

                orgType = V3xOrgEntity.ORGENT_TYPE_ACCOUNT;
                orgTypes.add(orgType);
                orgIds.add(AppContext.getCurrentUser().getLoginAccount());

            } else if ("group".equals(userType)) {
                successKey = "doc.learning.group.success.alert";
                failureKey = "doc.learning.group.failure.alert";

                orgType = Constants.ORGENT_TYPE_GROUP;
                orgTypes.add(orgType);
                orgIds.add(0L);
            }

            if (sdocid == null || "".equals(sdocid)) {
                // 上面菜单
                String[] ids = {};
                String[] isNewView = request.getParameterValues("isNewView");
        		if (isNewView.length > 0 && Boolean.parseBoolean(isNewView[0])){
        			ids = request.getParameterValues("newCheckBox");
                }else{
                	ids = request.getParameterValues("id");
                }
                List<Long> docIds = new ArrayList<Long>();
                for (String s : ids) {
                    if (docHierarchyManager.docResourceExist(Long.valueOf(s))) {
                        docIds.add(Long.valueOf(s));
                        try {
                        	//推荐人的动态
                        	List<DocActionUserPO> listDocActionUser = new ArrayList<DocActionUserPO>();
							DocActionPO dp = new DocActionPO();
							dp.setIdIfNew();
							dp.setActionUserId(userId);
							dp.setUserAccountId(accountId);
							dp.setActionTime(new Date());
							dp.setActionType(DocActionEnum.sendStudy.key());
							dp.setSubjectId(Long.valueOf(s));
							dp.setDescription("");
							for(int i = 0; i<orgIds.size() ;i++){
                        		DocActionUserPO daup = new DocActionUserPO();
                        		daup.setIdIfNew();
                        		daup.setUserId(orgIds.get(i));
                        		daup.setUserType(orgTypes.get(i));
                        		daup.setDescription("");
                        		daup.setDocActionId(dp.getId());
                        		listDocActionUser.add(daup);
                        	}
							dp.setUserSet(listDocActionUser);
							dp.setStatus(0);
                            docActionManager.insertDocAction(dp);
                        } catch (KnowledgeException e) {
                            log.error("", e);
                        }
                    }
                }
                if (V3xOrgEntity.ORGENT_TYPE_MEMBER.equals(orgType)) {
                    docLearningManager.sendToLearnCenter(docIds, orgTypes, orgIds);
                } else {
                    docLearningManager.sendToLearnCenter(docIds, orgType, orgIds);
                }
                docHierarchyManager.setDocLearning(docIds);
            } else {
                // 右键菜单过来，单个文档id
                long docId = Long.valueOf(sdocid);
                if (docHierarchyManager.docResourceExist(docId)) {
                    if ("member".equals(userType)) {
                        docLearningManager.sendToLearnCenter(docId, orgTypes, orgIds);
                    } else {
                        docLearningManager.sendToLearnCenter(docId, orgType, orgIds);
                    }
                    docHierarchyManager.setDocLearning(docId);
                    try {
                    	//推荐人的动态
                    	List<DocActionUserPO> listDocActionUser = new ArrayList<DocActionUserPO>();
						DocActionPO dp = new DocActionPO();
						dp.setIdIfNew();
						dp.setActionUserId(userId);
						dp.setUserAccountId(accountId);
						dp.setActionTime(new Date());
						dp.setActionType(DocActionEnum.sendStudy.key());
						dp.setSubjectId(docId);
						dp.setDescription("");
						for(int i = 0; i<orgIds.size();i++){
                    		DocActionUserPO daup = new DocActionUserPO();
                    		daup.setIdIfNew();
                    		daup.setUserId(orgIds.get(i));
                    		daup.setUserType(orgTypes.get(i));
                    		daup.setDescription("");
                    		daup.setDocActionId(dp.getId());
                    		listDocActionUser.add(daup);
                    	}
						dp.setUserSet(listDocActionUser);
						dp.setStatus(0);
                        docActionManager.insertDocAction(dp);
                    } catch (KnowledgeException e) {
                        log.error("", e);
                    }
                }
            }            
            return sendToReturn(request,response,successKey);
        } catch (Exception e) {
            log.error("发送到学习区", e);
            return sendToReturn(request,response,failureKey);
        }
    }
    
    private ModelAndView sendToReturn(HttpServletRequest request, HttpServletResponse response,String messageKey)throws BusinessException{
        if(request.getParameter("isNewFrame")==null){//兼容老的
            try {
                super.rendJavaScript(response, "alert('" + ResourceUtil.getString(messageKey) + "');");
            } catch (IOException e) {
                log.error("", e);
            }
        }else{
            request.setAttribute("returnString", "{'message':'" + ResourceUtil.getString(messageKey) + "'}");
            return new ModelAndView("apps/doc/personal/value");
        }
        return null;
    }

    // 更多
    @SuppressWarnings("unchecked")
    public ModelAndView docLearningMore(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView mav = new ModelAndView("apps/doc/docLearningMore");
        String deptId = request.getParameter("deptId");
        String accountId = request.getParameter("accountId");
        String groupId = request.getParameter("groupId");
        long orgId = AppContext.currentUserId();
        String orgType = V3xOrgEntity.ORGENT_TYPE_MEMBER;
        String titlePostfix = "personal";
        if (deptId != null && !"".equals(deptId)) {
            orgType = V3xOrgEntity.ORGENT_TYPE_DEPARTMENT;
            orgId = Long.valueOf(deptId);
            titlePostfix = "dept";
        } else if (accountId != null && !"".equals(accountId)) {
            orgType = V3xOrgEntity.ORGENT_TYPE_ACCOUNT;
            orgId = Long.valueOf(accountId);
            titlePostfix = "account";
        } else if (groupId != null && !"".equals(groupId)) {
            orgType = Constants.ORGENT_TYPE_GROUP;
            orgId = AppContext.getCurrentUser().getLoginAccount();
            //GOV-4188.公共空间里点击组织学习区和组织知识文档 start
            if ((Boolean) SysFlag.is_gov_only.getFlag()) {
                titlePostfix = "gov";
            } else {
                titlePostfix = "group";
            }
            //GOV-4188.公共空间里点击组织学习区和组织知识文档 end
        }

        boolean canAdmin = true;
        if (!orgType.equals(V3xOrgEntity.ORGENT_TYPE_MEMBER))
            canAdmin = this.canAdminSpace(orgType, orgId);

        String condition = request.getParameter("condition");
        List alist = null;
        if (condition != null && !"".equals(condition)) {
            String value = "";
            if ("createDate".equals(condition)) {
                value = request.getParameter("textfield") + " # " + request.getParameter("textfield1");
            } else {
                value = request.getParameter("textfield");
            }
            alist = docLearningManager.getDocLearningsByPage(orgType, orgId, condition, value);
        } else {
            alist = docLearningManager.getDocLearningsByPage(orgType, orgId);
        }

        List<DocLearningPO> dls = (List<DocLearningPO>) (alist.get(1));
        
        
        for (DocLearningPO dlp : dls) {
        	List<DocLearningPO> dpList = docLearningManager.getDocLearningsForRange(dlp);
        	List<Long> ids = new ArrayList<Long>();
        	for (DocLearningPO docLearningPO : dpList) {
				if(ids.contains(docLearningPO.getOrgId())){
					continue;
				}else{
					ids.add(docLearningPO.getOrgId());
				}
			}
        	Map<String,String> retMap = DocUtils.getStrNameFromOrgForDocLearningMore(ids, AppContext.currentUserId(), orgManager, 6,"docLearningMore");
        	dlp.setSendOthersStr(retMap.get("recommendeder"));
        	dlp.setSendOthersStrAll(retMap.get("recommendederAll"));
        	dlp.setCheckRemined("true".equals(retMap.get("isCheckRemined"))?true:false);
        	dlp.setRemindInfo(retMap.get("remindInfo"));
		}
        List<DocLearningVO> dlvos = this.getDocLearningVOs(dls);
        mav.addObject("canAdmin", canAdmin);
        mav.addObject("dlvos", dlvos);
        mav.addObject("total", (Integer) (alist.get(0)));
        mav.addObject("title", "doc.jsp.home.more.learn.title." + titlePostfix);
        mav.addObject("personalLearning","personal".equals(titlePostfix));
        mav.addObject("titlePostfix",titlePostfix);
        mav.addObject("deptId", deptId);
        mav.addObject("accountId", accountId);
        mav.addObject("groupId", groupId);
        mav.addObject("types", contentTypeManager.getAllSearchContentType());
        return mav;
    }

    /** 取消  */
    public ModelAndView docLearningCancel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        docLearningManager.cancelLearn(request.getParameter("ids"),request.getParameter("fromPage"));
        super.rendJavaScript(response, "parent.location.reload(true);");
        return null;
    }

    // 封装学习文档的vo
    private List<DocLearningVO> getDocLearningVOs(List<DocLearningPO> dls) {
        List<DocLearningVO> ret = new ArrayList<DocLearningVO>();
        if (dls == null)
            return ret;
        for (DocLearningPO dl : dls) {
            DocLearningVO vo = new DocLearningVO(dl);
            vo.setRecommender(getUserName(dl.getCreateUserId()));
            vo.setIcon(this.getIcon(false, dl.getDocResource().getMimeTypeId()));
            vo.setSendOthersStr(dl.getSendOthersStr());
            vo.setSendOthersStrAll(dl.getSendOthersStrAll());
            vo.setCheckRemined(dl.isCheckRemined()+"");
            vo.setRemindInfo(dl.getRemindInfo());
            vo.setHasAttachments(dl.getDocResource().getHasAttachments());
            ret.add(vo);
        }

        return ret;
    }

	/**
	 * 部门选择
	 */
	public ModelAndView selectDepts(HttpServletRequest request,
			HttpServletResponse response) throws BusinessException {
		Set<V3xOrgDepartment> depts = DocMVCUtils.getDeptsByManagerSpace(
				spaceManager, orgManager, AppContext.currentUserId());
		return new ModelAndView("apps/doc/deptSelect", "depts", depts);
    }

    public ModelAndView docLearningHistoryIframe(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/docLearningHistoryIframe");
    }

    /**
     * 进入学习历史界面
     */
    public ModelAndView docLearningHistory(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView ret = new ModelAndView("apps/doc/docLearningHistory");
        long docId = Long.valueOf(request.getParameter("docId"));
        List<DocLearningHistoryPO> dlhs = null;
        String sdept = request.getParameter("deptId");
        String isGroupLibS = request.getParameter("isGroupLib");
        boolean isGroupLib = ("true".equals(isGroupLibS));

        if (sdept == null || "".equals(sdept)) {
            dlhs = docLearningManager.getTheLearnHistoryByPage(docId);
        } else {
            long deptId = Long.valueOf(sdept);
            dlhs = docLearningManager.getTheLearnHistoryByDeptByPage(docId, deptId);
        }

        List<DocLearningHistoryVO> dlhvos = this.getDocLearningHistoryVOs(dlhs, isGroupLib);
        // 查询条件
        String searchContent = request.getParameter("searchContent");
        if (Strings.isNotBlank(searchContent)) {
            ret.addObject("searchContent", searchContent);
        }
        ret.addObject("docId", docId);
        ret.addObject("dlhvos", dlhvos);
        return ret;
    }

    // 封装学习历史vo
    private List<DocLearningHistoryVO> getDocLearningHistoryVOs(List<DocLearningHistoryPO> dlhs, boolean isGroupLib) {
        List<DocLearningHistoryVO> vos = new ArrayList<DocLearningHistoryVO>();
        if (Strings.isEmpty(dlhs)){
            return vos;
        }

        String accountName = "";

        for (DocLearningHistoryPO dlh : dlhs) {
            DocLearningHistoryVO vo = new DocLearningHistoryVO(dlh);
            try {
                V3xOrgMember member = orgManager.getMemberById(dlh.getAccessMemberId());

                if (member != null) {
                    if (isGroupLib) {
                        V3xOrgAccount acc = orgManager.getAccountById(member.getOrgAccountId());
                        if (acc != null)
                            accountName = "(" + acc.getShortName() + ")";
                    }
                    vo.setMemberName(member.getName());
                    V3xOrgDepartment dept = orgManager.getDepartmentById(dlh.getDepartmentId());
                    if (dept != null) {
                        vo.setDeptName(dept.getName() + accountName);
                    } else {
                        vo.setDeptName("");
                    }
                } else {
                    vo.setDeptName("");
                    vo.setMemberName("");
                }
            } catch (BusinessException e) {
                log.error("orgManager取得member", e);
            }

            vos.add(vo);
        }

        return vos;
    }

    /** ************************ 学习区结束 ******************************** */

    /** 新的进入编辑文档高级属性界面  */
    public ModelAndView theNewEditDocPropertiesPage(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView editProperties = new ModelAndView("apps/doc/community/editDocProperties");
        editProperties.addObject("keyword", request.getParameter("keyword"));
        editProperties.addObject("description", request.getParameter("description"));
        return editProperties;
    }
    /** 进入编辑文档高级属性界面  */
    public ModelAndView editDocPropertiesPage(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/editDocProperties");
    }

    /**
     * 当前用户角色判断
     * @throws BusinessException
     * @return 传过来部门，返回当前用户管理的部门集合，如果一个没有，返回空集合 id, name
     * @deprecated DocMVCUtils.getDeptsByManagerSpace(spaceManager,orgManager,userId)
     */
    public List<V3xOrgDepartment> getAuthorizedDepartments1() throws BusinessException {
        List<V3xOrgDepartment> ret = new ArrayList<V3xOrgDepartment>();
        Set<Long> deptSet = DocMVCUtils.getDeptsByManagerSpace(spaceManager, AppContext.currentUserId());
        for (Long id : deptSet) {
            V3xOrgDepartment dept = null;
            try {
                dept = orgManager.getDepartmentById(id);
            } catch (BusinessException e) {
                log.error("orgManager取得dept", e);
            }
            if (dept != null)
                ret.add(dept);
        }

        return ret;
    }

    /**
     * 知识管理自己实现的当前位置
     */
    public ModelAndView navigation(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/navigation");
    }

    /** 从文档中心顶级节点进入文档库列表界面 
     * @throws BusinessException */
    public ModelAndView docLibsList(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
    	ModelAndView ret = new ModelAndView("apps/doc/libsList");
        List<DocLibTableVo> allLibVos = this.getDocLibVOs(true);
        ret.addObject("allLibVos", allLibVos);
        return ret;
    }

    /*---------------------------- 2007.10.12 修改关联文档添加方式begin -------------------------------------*/
    /*-------整个系统共用一套框架(collaboration/list4QuoteFrame.jsp)，每个应用拥有一个页签 ----------------------*/
    /**
     * 进入关联文档添加页面框架
     */
    public ModelAndView list4QuoteFrame(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("collaboration/list4QuoteFrame");
    }

    /**
     * 进入关联文档添加页面框架的知识管理页签
     */
    public ModelAndView docQuoteFrame(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/quote/docQuoteFrame");
    }

    /**
     * 进入关联文档添加页面框架的知识管理页签 树
     */
    public ModelAndView docQuoteTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return this.listRoots(request, response);
    }

    /** 进入关联文档添加页面框架的知识管理页签 列表 
     * @throws BusinessException */
    public ModelAndView docQuoteList(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView ret = new ModelAndView("apps/doc/quote/docQuoteList");
        List<DocLinkVO> the_list = new ArrayList<DocLinkVO>();

        if (AppContext.hasResourceCode("F04_docIndex") || AppContext.hasResourceCode("F04_myDocLibIndex")) {
            Long userId = AppContext.currentUserId();
            DocResourcePO root = docHierarchyManager.getPersonalFolderOfUser(userId);
            if (root != null) {
                List<DocResourcePO> drs = new ArrayList<DocResourcePO>();
                if (AppContext.getCurrentUser().getExternalType() == OrgConstants.ExternalType.Inner.ordinal()) {
                    drs = docHierarchyManager.findAllDocsByPage(false, root.getId(), root.getFrType(), userId, null,
                            "quote");
                } else {
                    //是否为企业版
                    boolean isEnterpriseVer = (Boolean) (SysFlag.sys_isEnterpriseVer.getFlag());
                    DocLibPO lib = null;
                    Long accountId = OrgHelper.getVJoinAllowAccount();
                    if (isEnterpriseVer) {
                        lib = this.docLibManager.getDeptLibById(accountId);
                    } else {
                        lib = this.docLibManager.getGroupDocLib();
                    }
                    DocResourcePO dr = docHierarchyManager.getRootByLibId(lib.getId());
                    drs = docHierarchyManager.findAllDocsByPage(false, dr.getId(), dr.getFrType(), userId, null);
                }
                
                the_list = this.getDocLinkVos(drs);
                ret.addObject("parentId", root.getId());

                Long docLibId = root.getDocLibId();
                ret.addObject("docLibId", docLibId).addObject("docLibType", Constants.PERSONAL_LIB_TYPE);
                DocMVCUtils.renderSearchConditions(ret, docLibManager, docLibId,true);
            }
        }
        List<DocTypePO> types = contentTypeManager.getAllSearchContentType();
        return ret.addObject("the_list", the_list).addObject("types", types);
    }

    /** 关联树的展开 
     * @throws BusinessException */
    public ModelAndView xmlJspQuote(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        response.setContentType("text/xml");
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        Long userId = AppContext.currentUserId();
        
        String stype = request.getParameter("frType");
        Long frType = Long.valueOf(stype);
        String projectTypeId = request.getParameter("projectTypeId");
        String sparentId = request.getParameter("resId");
        Long parentId = Long.valueOf(sparentId);
        DocResourcePO parent = docHierarchyManager.getDocResourceById(parentId);

        // 对于资源是否存在的判断
        if (parent == null) {
            out.println("<exist>no</exist>");
            return null;
        }
        
        Long docLibId = parent.getDocLibId();
        DocLibPO lib = docLibManager.getDocLibById(docLibId);

        List<DocResourcePO> drs = null;
        boolean isPersonalLib = lib.isPersonalLib();
        if (isPersonalLib) {
            drs = docHierarchyManager.findFolders(parentId, frType, userId, "", true,null);
        } else if (AppContext.getCurrentUser().isAdministrator() || AppContext.getCurrentUser().isGroupAdmin()) {
            drs = docHierarchyManager.findFoldersWithOutAcl(parentId);
        } else {
            String orgIds = Constants.getOrgIdsOfUser(userId);
            //项目虚拟目录查询
            if (DocMVCUtils.isProjectVirtualCategory(frType, parent.getId(), lib,projectTypeId)) {
                drs = docHierarchyManager.findFolders(parentId, Constants.FOLDER_PROJECT_ROOT, userId, orgIds, false,new ArrayList<Long>());
                //根据项目类型Id查询所有项目id
//                List<ProjectBO> psList = projectApi.findProjectsByTypeIdAndMemberId(userId,Long.parseLong(projectTypeId));
//                List<Long> sourceIds = new ArrayList<Long>();//项目id
//                for (ProjectBO pSummary : psList) {
//                    sourceIds.add(pSummary.getId());
//                }
                List<Long> sourceIds = projectApi.findProjectIdsByMemberAndType(userId, Long.parseLong(projectTypeId));
                List<DocResourcePO> removeDocList = new ArrayList<DocResourcePO>();
                for (DocResourcePO doc : drs) {
                    if (doc.getSourceId() != null && !sourceIds.contains(doc.getSourceId())) {
                        ProjectBO ps = projectApi.getProject(doc.getSourceId());
                        if (!(ps.getProjectTypeId() + "").equals(projectTypeId)) {
                            removeDocList.add(doc);
                        }
                    }
                }
                if(!removeDocList.isEmpty()){//删除不是指定项目类别的
                    drs.removeAll(removeDocList);
                }
            } else {
                drs = docHierarchyManager.findFolders(parentId, frType, userId, orgIds, false,null);
            }
        }
        //项目文档根据项目文档类别构建
        drs = DocMVCUtils.projectRootCategory(frType, parent.getId(), lib, drs, projectApi, orgManager);
        if (Strings.isEmpty(drs)){
            return null;
        }

        List<DocTreeVO> folders = new ArrayList<DocTreeVO>();
        for (DocResourcePO dr : drs) {
            if ((dr.getFrType() == Constants.FOLDER_PLAN) || (dr.getFrType() == Constants.FOLDER_TEMPLET)
                    || (dr.getFrType() == Constants.FOLDER_SHARE) || (dr.getFrType() == Constants.FOLDER_BORROW)
                    || (dr.getFrType() == Constants.FOLDER_SHAREOUT) || (dr.getFrType() == Constants.FOLDER_BORROWOUT)) {
                continue;
            } else {
                if (isPersonalLib)
                    dr.setIsMyOwn(true);
                DocTreeVO vo = this.getDocTreeVO(userId, dr, isPersonalLib);
                folders.add(vo);
            }
        }

        out.println("<tree text=\"loaded\">");
        String xmlstr = DocMVCUtils.getXmlStr4LoadNodeOfQuoteTree(docLibId, folders);
        out.println(xmlstr);
        out.println("</tree>");
        return null;
    }

    /**
     * 进入关联文档添加页面框架的知识管理页签 列表 展开
     * @throws BusinessException 
     */
    public ModelAndView listDocs4Quote(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        long resId = Long.valueOf(request.getParameter("resId"));
        long frType = Long.valueOf(request.getParameter("frType"));

        // 对于资源是否存在的判断
        if (!docHierarchyManager.docResourceExist(resId)) {
            super.rendJavaScript(response, "alert(parent.v3x.getMessage('DocLang.doc_alert_source_deleted_folder'));"
                    + "parent.location.href = parent.location.href;");
            return null;
        }
        Long userId = AppContext.currentUserId();
        String projectTypeId = request.getParameter("projectTypeId");
        String sparentId = request.getParameter("resId");
        Long parentId = Long.valueOf(sparentId);
        DocResourcePO parent = docHierarchyManager.getDocResourceById(parentId);
        
        Long docLibId = parent.getDocLibId();
        DocLibPO lib = docLibManager.getDocLibById(docLibId);

        // 取得本页应该显示的DocResource对象
        List<DocResourcePO> drs = new ArrayList<DocResourcePO>();
        if (frType == Constants.FOLDER_SHAREOUT || frType == Constants.FOLDER_BORROWOUT) {
            Long parentFrId = parent.getParentFrId();
            drs = docHierarchyManager.findAllDocsByPage(false,parentFrId, frType, userId,null);
        } else {
            String queryFlag = request.getParameter("queryFlag");
            if (BooleanUtils.toBoolean(queryFlag)) {
                String pingHoleSelect = request.getParameter("pingHoleSelect");
                if (Strings.isNotBlank(pingHoleSelect)) {
                    int pingHoleSelectFlag = Integer.valueOf(pingHoleSelect);
                    drs = docHierarchyManager.findAllDocsByPage(false,resId, frType, userId, pingHoleSelectFlag);
                }
            } else {
                //项目虚拟目录查询
                if (DocMVCUtils.isProjectVirtualCategory(frType, resId, lib,projectTypeId)) {
//                    //根据项目类型Id查询所有项目id
//                    List<ProjectBO> psList = projectApi.findProjectsByTypeIdAndMemberId(userId,Long.parseLong(projectTypeId));
//                    List<Long> sourceIds = new ArrayList<Long>();//项目id
//                    for (ProjectBO pSummary : psList) {
//                        sourceIds.add(pSummary.getId());
//                    }
                	List<Long> sourceIds = projectApi.findProjectIdsByMemberAndType(userId, Long.parseLong(projectTypeId));
                	drs = docHierarchyManager.findAllDocsByPage(false,resId, Constants.FOLDER_PROJECT_ROOT, userId,sourceIds);
                } else {
                    drs = docHierarchyManager.findAllDocsByPage(false,resId, frType, userId,null,"quote");
                }
            }
        }
        
        if (parent != null) {
            //项目文档根据项目文档类别构建
            drs = DocMVCUtils.projectRootCategory(frType, parent.getId(), lib, drs, projectApi,orgManager);
        }
        ModelAndView ret = new ModelAndView("apps/doc/quote/docQuoteList");
        List<DocLinkVO> the_list = this.getDocLinkVos(drs);

        List<DocTypePO> types = contentTypeManager.getAllSearchContentType(); // 获取所有得内容类型
        ret.addObject("the_list", the_list);
        ret.addObject("types", types);
        ret.addObject("parentId", resId);

        DocMVCUtils.renderSearchConditions(ret, docLibManager, docLibId,true);

        return ret;
    }

    /** 关联文档查询 - 单个属性查询  
     * @throws BusinessException */
    public ModelAndView docQuoteSimpleSearch(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        return this.docQuoteSearch(request, response, true);
    }

    /** 关联文档查询 - 多个属性高级组合查询  
     * @throws BusinessException */
    public ModelAndView docQuoteAdvancedSearch(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        return this.docQuoteSearch(request, response, false);
    }

    private ModelAndView docQuoteSearch(HttpServletRequest request, HttpServletResponse response, boolean isSimple)
            throws BusinessException {
        ModelAndView ret = new ModelAndView("apps/doc/quote/docQuoteList");
        Long parentId = NumberUtils.toLong(request.getParameter("parentId"));
        String docLibStr = StringUtils.defaultIfEmpty(request.getParameter("docLibType"),
                String.valueOf(Constants.PERSONAL_LIB_TYPE));
        Byte docLibType = Byte.valueOf(docLibStr);

        List<DocResourcePO> drs = null;
        if (isSimple) {
            SimpleDocQueryModel simpleQueryModel = SimpleDocQueryModel.parseRequest(request);
            drs = this.docHierarchyManager.getSimpleQueryResult(false,simpleQueryModel, parentId, docLibType,0, "quote");
            ret.addObject("simpleQueryModel", simpleQueryModel);
        } else {
            DocSearchModel dsm = DocSearchModel.parseRequest(request);
            drs = this.docHierarchyManager.getAdvancedQueryResult(false,dsm, parentId, docLibType, "quote");
        }
        List<DocLinkVO> the_list = this.getDocLinkVos(drs);

        List<DocTypePO> types = contentTypeManager.getAllSearchContentType();
        ret.addObject("the_list", the_list);
        ret.addObject("types", types);
        ret.addObject("parentId", parentId);

        Long docLibId = NumberUtils.toLong(request.getParameter("docLibId"));
        DocMVCUtils.renderSearchConditions(ret, docLibManager, docLibId,true);
        return ret;
    }

    // 封装DocLinkVo
    private List<DocLinkVO> getDocLinkVos(List<DocResourcePO> drs) {
        List<DocLinkVO> ret = new ArrayList<DocLinkVO>();

        if (Strings.isEmpty(drs)){
            return ret;
        }

        long docLibId = drs.get(0).getDocLibId();
        DocLibPO lib = docLibManager.getDocLibById(docLibId);

        for (int i = 0; i < drs.size(); i++) {
            DocLinkVO doclinkVo = new DocLinkVO(drs.get(i));
            String frName = ResourceUtil.getString(doclinkVo.getDocRes().getFrName());
            //doclinkVo.getDocRes().setFrName(frName.replace("'", "‘"));
            doclinkVo.getDocRes().setFrName(frName);
            doclinkVo.setUserName(getUserName(drs.get(i).getCreateUserId()));
            doclinkVo.setIcon(this.getIcon(drs.get(i).getIsFolder(), drs.get(i).getMimeTypeId()));
            DocTypePO docType = contentTypeManager.getContentTypeById(drs.get(i).getFrType());
            if (docType != null)
                doclinkVo.setType(docType.getName());

            if (drs.get(i).getDocLibId() == docLibId) {
                doclinkVo.setDocLibType(lib != null ? lib.getType() : Constants.PERSONAL_LIB_TYPE);
            } else {
                DocLibPO lib2 = docLibManager.getDocLibById(drs.get(i).getDocLibId());
                doclinkVo.setDocLibType(lib2 != null ? lib2.getType() : Constants.PERSONAL_LIB_TYPE);
            }

            ret.add(doclinkVo);
        }

        return ret;
    }

    public ModelAndView openHelp(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/help", "isPersonLib", request.getParameter("isPersonLib"));
    }

    // 从首页进入新建文档
    // TODO(duanyl) 可以与theNewAddDoc合二为一
    public ModelAndView addDocIndex(HttpServletRequest request, HttpServletResponse response) throws IOException,
            BusinessException {
        ModelAndView ret = new ModelAndView("apps/doc/community/theNewDocAdd");
        docHomepageIndex(request, response);
        boolean isProject = false;
        String from = "project";
        // 文件类型转换
        String bodyType = request.getParameter("bodyType");
        int bodyTypeId = 10;
        int mimeTypeId = 22;
        if("OfficeWord".equals(bodyType)) {
        	bodyTypeId = 41;
        	mimeTypeId = 23;
        } else if("OfficeExcel".equals(bodyType)) {
        	bodyTypeId = 42;
        	mimeTypeId = 24;
        } else if("WpsWord".equals(bodyType)) {
        	bodyTypeId = 43;
        	mimeTypeId = 25;
        } else if("WpsExcel".equals(bodyType)) {
        	bodyTypeId = 44;
        	mimeTypeId = 26;
        }
        String sdocId = request.getParameter("docResId");
        String sprojectId = request.getParameter("projectId");
        String sprojectPhaseId = request.getParameter("projectPhaseId");
        long docResId = 0L;
        DocResourcePO parent = null;
        if (sdocId != null && !"".equals(sdocId)) {
            docResId = Long.valueOf(sdocId).longValue();
            parent = docHierarchyManager.getDocResourceById(docResId);
        } else if (Strings.isNotBlank(sprojectId)) {
        	isProject = true;
            long projectId = Long.valueOf(sprojectId).longValue();
            long projectPhaseId = NumberUtils.toLong(sprojectPhaseId, TaskConstants.PROJECT_PHASE_ALL);
            DocResourcePO projectFolder = null;
            if (projectPhaseId == TaskConstants.PROJECT_PHASE_ALL) {
                projectFolder = docHierarchyManager.getProjectFolderByProjectId(projectId);
            } else {
                projectFolder = docHierarchyManager.getProjectFolderByProjectId(projectPhaseId, true);
            }

            if (projectFolder != null) {
                parent = projectFolder;

                docResId = projectFolder.getId().longValue();
                ret.addObject("commentEnabled", projectFolder.getCommentEnabled());
                ret.addObject("versionEnabled", projectFolder.isVersionEnabled());
                ret.addObject("recommendEnable", projectFolder.getRecommendEnable());
                long frType = projectFolder.getFrType();
                ret.addObject("frType", Long.valueOf(frType));
            }
        }
        
        if (parent == null) {
            super.printV3XJS(response);
            StringBuilder sb = new StringBuilder();
            if (sdocId != null && !"".equals(sdocId)) {
                sb.append("alert('" + Constants.getDocI18nValue("doc.forder.noexist") + "');");
            } else {
                sb.append(" alert('" + Constants.getDocI18nValue("doc.forder.project.noexist") + "');");
            }
            sb.append("window.history.back();");
            super.rendJavaScript(response, sb.toString());
            return null;
        }
        
        DocLibPO lib = docLibManager.getDocLibById(parent.getDocLibId());
        byte docLibType = lib.getType();
        boolean contentTypeFlag = true;
        String htmlStr = "";
        if (docLibType != Constants.PERSONAL_LIB_TYPE.byteValue()) {
            long docLibId = Long.valueOf(lib.getId().longValue()).longValue();
            List<DocTypePO> _contentTypes = docLibManager.getContentTypesForDoc(docLibId);
            List<DocTypePO> contentTypes = new ArrayList<DocTypePO>();
            for(DocTypePO _type : _contentTypes) {
            	try {
					DocTypePO type = (DocTypePO)_type.clone();
					type.setId(_type.getId());
					type.setName(DocMVCUtils.getDisplayName4MetadataDefinition2(type.getName(),null));
					contentTypes.add(type);
				} catch (CloneNotSupportedException e) {
					// TODO Auto-generated catch block
					log.error("", e);
				}
            }
            ret.addObject("contentTypes", contentTypes);
            if (contentTypes == null || contentTypes.size() < 1)
                contentTypeFlag = false;
            else
                htmlStr = htmlUtil.getNewHtml(((DocTypePO) contentTypes.get(0)).getId().longValue());
        } else {
            contentTypeFlag = false;
        }
        Long docId = UUIDLong.absLongUUID();
        ret.addObject("isProject", isProject);
        ret.addObject("docId", docId);
        ret.addObject("parentDr", parent);
        ret.addObject("contentTypeFlag", Boolean.valueOf(contentTypeFlag));
        ret.addObject("html", htmlStr);
        ret.addObject("docLib", lib);
        ret.addObject("openFrom", from);
        ret.addObject("docResId", Long.valueOf(docResId));
        ret.addObject("docLibId", lib.getId());
        ret.addObject("mimeTypeId",mimeTypeId);
        ret.addObject("bodyType", bodyTypeId);
        return ret;
    }

    // 从精灵上传文档
    @SuppressWarnings("unchecked")
    public ModelAndView uploadDoc(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String error = "uploadError:";
        String uploadok = "uploadOk:";
        PrintWriter out = response.getWriter();
        try {
            Long userId = AppContext.currentUserId();
            DocLibPO doclib = docLibManager.getOwnerDocLibByUserId(userId);
            long docLibId = doclib.getId();
            Byte docLibType = 1;
            Long docResourceId = docHierarchyManager.getDocByType(docLibId, Constants.FOLDER_MINE).getId();

            boolean parentCommentEnabled = false;
            boolean parentRecommendEnable = false;
            List<V3XFile> list = new ArrayList<V3XFile>();
            try {
                MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
                Iterator fileNames = multipartRequest.getFileNames();
                while (fileNames.hasNext()) {
                    String filename = String.valueOf(fileNames.next());
                    MultipartFile fileItem = multipartRequest.getFile(filename);
                    V3XFile file = fileManager.save(fileItem.getInputStream(), ApplicationCategoryEnum.doc, filename,
                            new Date(), true);
                    list.add(file);
                }
            } catch (Exception e) {
                out.println(error);
                log.error("通过fileManager保存file", e);
                return null;
            }
            // 得到上传文件
            if (Strings.isNotEmpty(list)) {
                String sysTemp = SystemEnvironment.getSystemTempFolder();
                String docTemp = sysTemp + "/doctemp/";
                File temp = new File(docTemp);
                temp.mkdir();
                for (V3XFile the_file : list) {
                    //空间不足检查
                    if (docLibType == Constants.PERSONAL_LIB_TYPE.byteValue()) {
                        DocStorageSpacePO space = docSpaceManager.getDocSpaceByUserId(userId);
                        if (space.getTotalSpaceSize() < (the_file.getSize() + space.getUsedSpaceSize()))
                            throw new BusinessException(ResourceUtil.getString("doc.personal.storage.not.enough"));
                    }
                    DocResourcePO dr = docHierarchyManager.uploadFileWithoutAcl(the_file, docLibId, docLibType,
                            docResourceId, userId, parentCommentEnabled, false, parentRecommendEnable);
                    Long newId = dr.getId();
                    // 记录操作日志
                    operationlogManager.insertOplog(newId, docResourceId, ApplicationCategoryEnum.doc,
                            ActionType.LOG_DOC_UPLOAD, ActionType.LOG_DOC_UPLOAD + ".desc",
                            AppContext.currentUserName(), the_file.getFilename());
                    // 更新订阅文档
                    docAlertLatestManager.addAlertLatest(dr, Constants.ALERT_OPR_TYPE_ADD, userId, new Date(),
                            Constants.DOC_MESSAGE_ALERT_ADD_DOC, null);

                    // 全文检索
                    try {
                        if (AppContext.hasPlugin("index")) {
                            indexManager.add(newId, ApplicationCategoryEnum.doc.getKey());
                        }
                    } catch (Exception e) {
                        log.error("全文检索入库", e);
                    }

                    // 上传图片类或PDF文件，docBody中需保存对应记录
                    if (dr.isImage() || dr.isPDF()) {
                        DocBodyPO picBody = new DocBodyPO();
                        Date time = new Date();
                        picBody.setCreateDate(new Date(time.getTime()));
                        picBody.setBodyType(dr.isImage() ? com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML
                                : com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_PDF);
                        picBody.setContent(dr.getSourceId().toString());

                        this.docHierarchyManager.saveBody(newId, picBody);
                    }
                    if (OfficeTransHelper.allowTrans(the_file)) {
                        officeTransManager.generate(the_file.getId(), the_file.getCreateDate(), false);
                    }
                    docActionManager.insertDocAction(userId, AppContext.currentAccountId(), new Date(),
                            DocActionEnum.upload.key(), docResourceId, "jinlin");
                }
            }else{
                out.println(error);
                return null;
            }
        } catch (BusinessException e) {
            out.println(error);
            out.println(e.getMessage());
            return null;
        } catch (Exception e) {
            // -> Ignore
        }
        out.println(uploadok);
        return null;
    }

    /*----------------------------------------文档历史版本--------------------------------------*/

    /** 历史版本信息记录列表框架页面 */
    public ModelAndView listAllDocVersionsFrame(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("apps/doc/history/docResHistoriesFrame");
    }

    /** 列出文档对应的所有历史版本信息记录 */
    public ModelAndView listAllDocVersions(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long docResId = NumberUtils.toLong(request.getParameter("docResId"));
        List<DocVersionInfoPO> allVersions = docVersionInfoManager.getAllDocVersion(docResId,
                SearchModel.getSearchModel(request));
        if(allVersions!=null){
        	 for(DocVersionInfoPO dp : allVersions){
             	String vForDocPropertyIframe = SecurityHelper.digest(10,dp.getId());
             	dp.setvForDocVersion(vForDocPropertyIframe);
             }
        }
        return new ModelAndView("apps/doc/history/docResHistories", "allVersions", allVersions);
    }

    /** 删除选中的历史版本信息记录 */
    public ModelAndView deleteDocVersions(HttpServletRequest request, HttpServletResponse response) throws IOException {
        this.docVersionInfoManager.delete(request.getParameter("docVersionIds"));
        super.rendJavaScript(response, "parent.window.location.href = parent.window.location;");
        return null;
    }

    /**
     * 文档图片更多
     * @param request
     * @param response
     * @return
     * @throws IOException
     * @throws BusinessException 
     * @throws NumberFormatException 
     */
    public ModelAndView moreDocPictures(HttpServletRequest request, HttpServletResponse response) throws IOException,
            NumberFormatException, BusinessException {
        ModelAndView mav = new ModelAndView("apps/doc/moreDocPictures");
        User user = AppContext.getCurrentUser();
        String folderIdStr = request.getParameter("folderId");
        String fragmentId = request.getParameter("fragmentId");
        String ordinal = request.getParameter("ordinal");

        List<SectionPanel> panels = portletEntityPropertyManager.getSectionPanel(Long.parseLong(fragmentId), ordinal,
                "singlePanel", "");
        if (CollectionUtils.isNotEmpty(panels)) {
            for (SectionPanel panel : panels) {
                DocResourcePO dr = docHierarchyManager.getDocResourceById(NumberUtils.toLong(panel.getId()));
                if (dr != null) {
                    String panelName = ResourceUtil.getString(dr.getFrName());
                    panel.setName(panelName);
                }
            }
        }
        List<DocResourcePO> docResources = null;
        if (Strings.isNotBlank(folderIdStr)) {
            docResources = docHierarchyManager.getDocsByTypes(Long.parseLong(folderIdStr), user.getId(),
                    Constants.FORMAT_TYPE_ID_UPLOAD_JPG, Constants.FORMAT_TYPE_ID_UPLOAD_GIF,
                    Constants.FORMAT_TYPE_ID_UPLOAD_PNG);
        }

        int size = Pagination.getRowCount();

        int pageSize = NumberUtils.toInt(request.getParameter("pageSize"), Pagination.getMaxResults());
        if (pageSize < 1) {
            pageSize = Pagination.getMaxResults();
        }

        int page = NumberUtils.toInt(request.getParameter("page"), 1);
        if (docResources != null) {
            if (size == 0) {
                size = docResources.size();
            }

            for (DocResourcePO doc : docResources) {
                try {
                    Date cDate = this.fileManager.getV3XFile(doc.getSourceId()).getCreateDate();
                    doc.setCreateTime(new Timestamp(cDate.getTime()));

					if(!docHierarchyManager.hasOpenPermission(doc.getId(),user.getId())){
						doc.setHasAcl(false);
						doc.setFrName(ResourceUtil.getString("doc.file.noauth.open"));
					}else{
						doc.setHasAcl(true);
					}
                } catch (BusinessException e) {
                    log.error("获取文件时出现异常[文件ID= " + doc.getSourceId() + "]", e);
                }
            }
        }

        int pages = (size + pageSize - 1) / pageSize;
        if (pages < 1) {
            pages = 1;
        }

        if (page < 1) {
            page = 1;
        } else if (page > pages) {
            page = pages;
        }
        mav.addObject("docResources", docResources);
        mav.addObject("folderId", folderIdStr);
        mav.addObject("pageSize", pageSize);
        mav.addObject("page", page);
        mav.addObject("pages", pages);
        mav.addObject("size", size);
        mav.addObject("allPanels", panels);
        return mav;
    }

    public void setUserMessageManager(UserMessageManager userMessageManager) {
        this.userMessageManager = userMessageManager;
    }

    public void setIndexManager(IndexManager indexManager) {
        this.indexManager = indexManager;
    }

    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }

    public void setOfficeTransManager(OfficeTransManager officeTransManager) {
        this.officeTransManager = officeTransManager;
    }

    public void setEnumManagerNew(EnumManager enumManager) {
        this.enumManagerNew = enumManager;
    }

    public void setSpaceManager(SpaceManager spaceManager) {
        this.spaceManager = spaceManager;
    }

    public void setDocLearningManager(DocLearningManager docLearningManager) {
        this.docLearningManager = docLearningManager;
    }

    public void setDocAlertLatestManager(DocAlertLatestManager docAlertLatestManager) {
        this.docAlertLatestManager = docAlertLatestManager;
    }

    public void setDocFavoriteManager(DocFavoriteManager docFavoriteManager) {
        this.docFavoriteManager = docFavoriteManager;
    }

    public void setMetadataDefManager(MetadataDefManager metadataDefManager) {
        this.metadataDefManager = metadataDefManager;
    }

    public void setDocAlertManager(DocAlertManager docAlertManager) {
        this.docAlertManager = docAlertManager;
    }

    public void setDocMetadataManager(DocMetadataManager docMetadataManager) {
        this.docMetadataManager = docMetadataManager;
    }

    public void setDocForumManager(DocForumManager docForumManager) {
        this.docForumManager = docForumManager;
    }

    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }

    public void setDocMimeTypeManager(DocMimeTypeManager docMimeTypeManager) {
        this.docMimeTypeManager = docMimeTypeManager;
    }

    public void setDocAclManager(DocAclManager docAclManager) {
        this.docAclManager = docAclManager;
    }

    public void setContentTypeManager(ContentTypeManager contentTypeManager) {
        this.contentTypeManager = contentTypeManager;
    }

    public void setDocLibManager(DocLibManager docLibManager) {
        this.docLibManager = docLibManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setDocHierarchyManager(DocHierarchyManager docHierarchyManager) {
        this.docHierarchyManager = docHierarchyManager;
    }

    public void setOperationlogManager(OperationlogManager operationlogManager) {
        this.operationlogManager = operationlogManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public void setMaxSize4ShowContent(int maxSize4ShowContent) {
        this.maxSize4ShowContent = maxSize4ShowContent;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }

    public void setHtmlUtil(HtmlUtil htmlUtil) {
        this.htmlUtil = htmlUtil;
    }

    public String getJsonView() {
        return jsonView;
    }

    public void setJsonView(String jsonView) {
        this.jsonView = jsonView;
    }

    public void setDocVersionInfoManager(DocVersionInfoManager docVersionInfoManager) {
        this.docVersionInfoManager = docVersionInfoManager;
    }

    public void setTypesShowContentDirectlyTEXT(String[] typesShowContentDirectlyTEXT) {
        if (typesShowContentDirectlyTEXT != null) {
            for (String s : typesShowContentDirectlyTEXT) {
                this.typesShowContentDirectlyTEXT.add(s);
            }
        }
    }

    public void setTypesShowContentDirectlyHTML(String[] typesShowContentDirectlyHTML) {
        if (typesShowContentDirectlyHTML != null) {
            for (String s : typesShowContentDirectlyHTML) {
                this.typesShowContentDirectlyHTML.add(s);
            }
        }
    }

    public PartitionManager getPartitionManager() {
        return partitionManager;
    }

    public void setPartitionManager(PartitionManager partitionManager) {
        this.partitionManager = partitionManager;
    }

    public void setPortletEntityPropertyManager(PortletEntityPropertyManager portletEntityPropertyManager) {
        this.portletEntityPropertyManager = portletEntityPropertyManager;
    }

    public void setDocFilingManager(DocFilingManager docFilingManager) {
        this.docFilingManager = docFilingManager;
    }

    public void setDocActionManager(DocActionManager docActionManager) {
        this.docActionManager = docActionManager;
    }
    
    public void setDocAclNewManager(DocAclNewManager docAclNewManager) {
        this.docAclNewManager = docAclNewManager;
    }    

    public ModelAndView knowledgeBrowse(HttpServletRequest request, HttpServletResponse response) throws IOException,
            NumberFormatException, BusinessException {
        ModelAndView modelView = new ModelAndView("apps/doc/community/knowledgeBrowse");
        String isCollCube = request.getParameter("isCollCube");
        modelView.addObject("isCollCube", isCollCube);
        User user = AppContext.getCurrentUser();
        Long userId = user.getId();
        boolean isHistory = Constants.VERSION_FLAG.equals(request.getParameter("versionFlag"));
        long resId = Long.valueOf(isHistory ? request.getParameter("docVersionId") : request.getParameter("docResId"));
        long id = resId;
        boolean docExist = true;
        boolean isLink = false;
        // 判定当前浏览器是否是IE
        BrowserEnum currentBrowser = BrowserEnum.valueOf(request);
        boolean isIE = DocMVCUtils.isOfficeSupport(currentBrowser);
        String fileCreateDate = null;
        DocResourcePO doc = this.getDocResource4Show(isHistory, resId);
        if (doc == null) {
            docExist = false;
            docExist = false;
            if("1".equals(isCollCube)){
            	String javaScript = "alert('文档已经被删除或取消公开、借阅！');";
            	super.rendJavaScript(response,javaScript);
                return null;
            }else{
            	return modelView.addObject("docExist", docExist);
            }
        }
        //协同立方打开
        if ("1".equals(isCollCube)) {
            String validInfo = docHierarchyManager.getValidInfo(resId, 6, AppContext.currentUserId(), null);
            if (Strings.isNotBlank(validInfo) && validInfo.length() > 3) {
                char hasOp = validInfo.charAt(1);
                if ('0' != hasOp) {
                    String javaScript = "alert('您无权限打开改文档！');";
                    super.rendJavaScript(response,javaScript);
                    return null;
                }
                String url = validInfo.substring(3);
                if (!modelView.getViewName().equals(url)) {
                    return super.redirectModelAndView(url);
                }
            }
        }
        
        if (doc.getFrType() == Constants.LINK) {
            // 记录映射文件所在父文档夹
        	id = doc.getSourceId();
            doc = docHierarchyManager.getDocResourceById(id);
            isLink = true;
            if (doc == null) {
            	return modelView.addObject("docExist", docExist);
            }
        } else if (Constants.isPigeonhole(doc.getFrType())) {
            boolean pigExist = docFilingManager.hasPigeonholeSource(Constants.getAppEnum(doc.getFrType()).key(),
                    doc.getSourceId());
            if (!pigExist) {
                docExist = false;
                return modelView.addObject("docExist", docExist);
            }
        }
        id = doc.getId();
        //文档入口
        String entranceTypes = request.getParameter("entranceType");
        EntranceTypeEnum entranceType = EntranceTypeEnum.parseEntranceType(entranceTypes);
        long validateDocId = resId;
        if(EntranceTypeEnum.otherLibs.equals(entranceType) && !isLink) {
        	validateDocId = docHierarchyManager.getDocResourceById(resId).getParentFrId();
        }
        //SECURITY 访问安全检查
        // 对于一个映射文档，其权限验证应传递映射的Id，不能传递源文档Id duanyl
        //如果从关联文档打开，无需做安全性验证。但用此方式可能有风险，后续要改成成:(关联文档下)在公共文档库打开，走文档夹权限。
        if(!EntranceTypeEnum.associatedDoc.equals(entranceType)) {
        	if (!SecurityCheck.isLicit(request, response, ApplicationCategoryEnum.doc, AppContext.getCurrentUser(), validateDocId,
                    null, null)) {
            	String openFrom = request.getParameter("openFrom");
            	String javaScript = "";
            	if("docCenter".equals(openFrom)) {
            		javaScript = "parent.document.body.removeChild(parent.document.getElementById('docOpenDialogOnlyId'));";
            	} else {
            	    javaScript = "if(parent.document.getElementById('docOpenDialogOnlyId')) {" +
            	    		"if(parent.document.getElementById('docOpenDialogOnlyId_oMxtMask')){" +
            	    		"parent.document.body.removeChild(parent.document.getElementById('docOpenDialogOnlyId_oMxtMask'));} " +
            	    		"if(parent.document.getElementById('docOpenDialogOnlyId_mask')){" +
            	    		"parent.document.body.removeChild(parent.document.getElementById('docOpenDialogOnlyId_mask'));}" +
            	    		"parent.document.body.removeChild(parent.document.getElementById('docOpenDialogOnlyId'));}";
            		javaScript += "if(window.parentDialogObj&&window.parentDialogObj['docOpenDialogOnlyId'].close) {" +
            				"window.parentDialogObj['docOpenDialogOnlyId'].close();}";
            	}
            	super.rendJavaScript(response,javaScript);
                return null;
            }
        }       
        DocLibPO lib = docLibManager.getDocLibById(doc.getDocLibId());
        if (lib.isPersonalLib()) {
            if (docLibManager.isOwnerOfLib(userId, lib.getId())) {
                doc.setIsMyOwn(true);
            }
        }

        String createDate = doc.getCreateTime().toString().substring(0, 10);
        boolean isUploadFile = false;
        long formatType = docMimeTypeManager.getDocMimeTypeById(doc.getMimeTypeId()).getFormatType();
        if (formatType == Constants.FORMAT_TYPE_DOC_FILE) {
            isUploadFile = true;
            // 对于上传文件，因为可能出现替换情况，导致新建时间不一致，所以应该从系统取。解决下载的定位问题
            V3XFile file = fileManager.getV3XFile(doc.getSourceId());
            String vForDocFileDownload = file.getV();
            modelView.addObject("vForDocFileDownload", vForDocFileDownload);
            createDate = file.getCreateDate().toString().substring(0, 10);
        }
        boolean isBorrowOrShare = false;
        if (docLibManager.isOwnerOfLib(userId, lib.getId())) {
            doc.setIsMyOwn(true);
        } else {
            isBorrowOrShare = true;
        }

        Byte docLibType = lib.getType();
        boolean isPrivateLib = docLibType.equals(Constants.PERSONAL_LIB_TYPE);
        boolean isGroupLib = docLibType.equals(Constants.GROUP_LIB_TYPE);
        boolean isGroupAdmin = this.canAdminGroup();
        List<Long> deptId= spaceManager.getDeptsByManagerSpace(AppContext.currentUserId());
        Set<Long> deptIdSet = new HashSet<Long>(deptId);
        int depAdminSize = deptIdSet.size();
        //附件
        List<Attachment> atts = null;
        if(isHistory) {
        	atts = attachmentManager.getByReference(resId);
        } else {  
        	atts = attachmentManager.getByReference(doc.getId());
        }        
        int relevanceSize = 0;//关联文档个数
        for (Attachment attachment : atts) {
            if (attachment.getType().equals(2)) {
                relevanceSize++;
            }
        }
        //文档属性
        DocPropVO docPropVO = this.getPropVOByDr(doc);
        if(!doc.getCreateUserId().equals(AppContext.currentUserId())) {
        	docPropVO.setAccessCount(docPropVO.getAccessCount());
        }
        //文档权限查询
        Potent docPotent = null;
        // 权限表里对应的物理权限
        DocAcl docAcl = docAclNewManager.getDocAclWithEntrance(resId, userId,entranceType);          
        docPotent = docAcl.getMappingPotent();
        
        String vForDocPropertyIframe = SecurityHelper.digest(doc.getId(),doc.getFrType(),doc.getDocLibId(),
        		docLibType,true,true,true,true,true,true,true,true,doc.getRecommendEnable());       
        String lockMsg = this.docHierarchyManager.getLockMsg(doc.getId(), user.getId());
        boolean isLocked = !Constants.LOCK_MSG_NONE.equals(lockMsg);
        boolean isEdocLib = docLibType.byteValue() == Constants.EDOC_LIB_TYPE.byteValue();

        String avgScoreCss = KnowledgeUtils.getAvgScoreClass(doc.getTotalScore(), doc.getScoreCount());
        String srcImg = Functions.getAvatarImageUrl(doc.getCreateUserId());
        
        // 是否是借阅/共享文档(不含公共共享)
        boolean isShareAndBorrowRoot = false; 
        if(entranceType.equals(EntranceTypeEnum.borrowOrShare) || entranceType.equals(EntranceTypeEnum.borrowOut) || entranceType.equals(EntranceTypeEnum.shareOut)  || (docAcl.getSharetype() != null &&  (docAcl.getSharetype() == 1 || docAcl.getSharetype() == 2 || docAcl.getSharetype() == 3))) {
        	isShareAndBorrowRoot = true;
        }
        // 是否是office类型的
        boolean isOffice = false;
        Long mimeTypeId = doc.getMimeTypeId();
        DocMimeTypePO mime = docMimeTypeManager.getDocMimeTypeById(mimeTypeId);
        if(mime.isMSOrWPS() || mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_DOC || mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_XLS 
        		|| mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_WPS_DOC || mimeTypeId.intValue() == Constants.FORMAT_TYPE_ID_UPLOAD_WPS_XLS) {
        	isOffice = true;
        }
        if(isUploadFile) {
        	fileCreateDate = DocMVCUtils.getCreateDateOfFile(doc, this.fileManager);
        } else {
        	fileCreateDate = Datetimes.formatDate(doc.getCreateTime());
        }
        // 文档是否被锁定
        if (doc.getIsCheckOut()) {
            modelView.addObject("checkname", getUserName(doc.getCheckOutUserId()));
        }
        
        //处理收藏文档
        List<Map<String,Long>> collectFlag = knowledgeFavoriteManager.getFavoriteSource(CommonTools.newArrayList(doc.getId()),AppContext.currentUserId());
        if(!collectFlag.isEmpty()){
            modelView.addObject("isCollect", true);
            modelView.addObject("collectDocId", collectFlag.get(0).get("id"));
        }
        
        modelView.addObject("isOffice", isOffice);
        modelView.addObject("isLinkOpenNoneAcl", false);
        //收藏在映射打开，如果没有权限或者只有列表权限，将不能收藏
        if(isLink){
           DocAcl docAcl2 = docAclNewManager.getDocAclWithoutEntrance(doc, userId);  
           Potent p = docAcl2.getMappingPotent();
           //有列表或者无权限
            if (!p.isAll() && !p.isEdit() && !p.isRead() && !p.isReadOnly()) {
                modelView.addObject("isLinkOpenNoneAcl", true);
           }
        }
        
        
        modelView.addObject("onlyA6", DocMVCUtils.isOnlyA6());
        modelView.addObject("isGov", DocMVCUtils.isGovVer()||DocMVCUtils.isG6Group());
        modelView.addObject("onlyA6s", DocMVCUtils.isOnlyA6S());
        //离职人员处理
        V3xOrgMember entity = orgManager.getMemberById(doc.getCreateUserId());
        //判断是否开启office
        
        boolean officeTransFlag = "enable".equals(systemConfig.get("office_transform_enable")) ? true : false;
        modelView.addObject("officeTransFlag",officeTransFlag);
        modelView.addObject("isIE",isIE);
        modelView.addObject("isOffice", isOffice);
        modelView.addObject("createUserValid", entity.isValid());
        modelView.addObject("createUserName", Functions.showMemberName(entity));
        modelView.addObject("fileCreateDate", fileCreateDate);
        
        modelView.addObject("isPrivateLib", isPrivateLib);
        modelView.addObject("isGroupLib", isGroupLib);
        modelView.addObject("depAdminSize", depAdminSize);
        modelView.addObject("docPotent", docPotent);
        modelView.addObject("doc", doc);
        modelView.addObject("prop", docPropVO);
        modelView.addObject("docLibType", lib.getType());
        modelView.addObject("docExist", docExist);
        modelView.addObject("isLink", isLink);
        modelView.addObject("isLocked", isLocked);
        modelView.addObject("lockMsg", lockMsg);

        modelView.addObject("isEdocLib", isEdocLib);
        modelView.addObject("createDate", createDate);
        modelView.addObject("isUploadFile", isUploadFile);
        modelView.addObject("canPrint4Upload", doc.canPrint4Upload());
        modelView.addObject("isAdministrator", DocMVCUtils.isAccountSpaceManager(spaceManager, userId, user.getLoginAccount()));
        modelView.addObject("isGroupAdmin", isGroupAdmin);

        modelView.addObject("isUploadFile", isUploadFile);
        modelView.addObject("isShareAndBorrowRoot", isShareAndBorrowRoot);
        modelView.addObject("isBorrowOrShare", isBorrowOrShare);
        modelView.addObject("isHistory",isHistory);
        modelView.addObject("docCollectFlag",SystemProperties.getInstance().getProperty("doc.collectFlag"));
        modelView.addObject("attachmentsJSON", Strings.toHTML(JSONUtil.toJSONString(atts)));//附件，关联文档
        modelView.addObject("relevanceSize", relevanceSize);
        modelView.addObject("avgScoreCss", avgScoreCss);
        modelView.addObject("avgScore", doc.getAvgScore());
        modelView.addObject("docCreateUserImgSrc", srcImg);
        modelView.addObject("vForDocPropertyIframe",vForDocPropertyIframe);

        //区隔
        modelView.addObject("docOpenFlag",SystemProperties.getInstance().getProperty("doc.docOpenFlag"));
        modelView.addObject("forumFlag",SystemProperties.getInstance().getProperty("doc.forumFlag"));
        return modelView;
    }

    /**
     * 查询文章评论
     */
    public ModelAndView getForums(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView modelAndView = new ModelAndView("apps/doc/community/knowledgeBrowseTemp");
        Long docId = Long.parseLong(request.getParameter("docId").toString());
        String docCreateUserId = (String) request.getParameter("docCreateUserId");
        V3xOrgMember entity= orgManager.getMemberById(Long.parseLong(docCreateUserId));
        Long loginUserId = AppContext.getCurrentUser().getId();
        List<DocForumPO> forums = docForumManager.findFirstForumsByDocId(docId);
        //增加人员头像
        List<DocForumVO> docForums = this.getForumVOList(forums,docId,false);
        request.setAttribute("forums", docForums);
        request.setAttribute("docCreateUserId", docCreateUserId);
        request.setAttribute("docCreateUserName", Functions.showMemberName(entity));
        request.setAttribute("docCreateUserValid",entity.isValid());
        request.setAttribute("loginUserId", loginUserId);
        request.setAttribute("docId", docId);
        return modelAndView;
    }
    
    private Map<Long,List<DocForumPO>> buildForum(List<DocForumPO> replys){
        Map<Long,List<DocForumPO>> replyMap = new HashMap<Long,List<DocForumPO>>();
        
        for (DocForumPO reply : replys) {
            Long pForumId = reply.getParentForumId();
            List<DocForumPO> cForums = replyMap.get(pForumId);
            if(cForums==null){
                cForums=new ArrayList<DocForumPO>();
            }
            
            cForums.add(reply);
            replyMap.put(pForumId, cForums);
        }
        return replyMap;
    }
    
    /**
     * todo 显示项目文档
     * @param homePage 是否在项目首页(只显示9条文档，如果是在更多页面，则按照分页显示)
     * @throws BusinessException 
     */
    private void renderProjectDocs(long projectId, Long phaseId, ModelAndView mav, boolean homePage) throws BusinessException {
        List<FolderItemDoc> docList = null;
        boolean hasAcl = false;
        boolean addAcl = false;
        String orgIds = Constants.getOrgIdsOfUser(AppContext.getCurrentUser().getId());
        Set<Integer> sets = docAclManager.getDocResourceAclList(projectId, orgIds);

        boolean all = sets != null && sets.contains(Constants.ALLPOTENT);
        boolean edit = sets != null && sets.contains(Constants.EDITPOTENT);
        boolean add = sets != null && sets.contains(Constants.ADDPOTENT);
        boolean readonly = sets != null && sets.contains(Constants.READONLYPOTENT);
        boolean browse = sets != null && sets.contains(Constants.BROWSEPOTENT);
        boolean list = sets != null && sets.contains(Constants.LISTPOTENT);
        boolean b = all || edit || add, c = readonly || browse || list;
        if (b || c) {
            hasAcl = true;
            if (homePage) {
                Pagination.setNeedCount(false);
                Pagination.setFirstResult(0);
                Pagination.setMaxResults(9);
            }
        }
        docList = docHierarchyManager.getLatestDocsOfProject(projectId, phaseId, orgIds, hasAcl);
        if (all || edit || add) {
            addAcl = true;
        }
        if (homePage && CollectionUtils.isNotEmpty(docList) && docList.size() > 8) {
            docList.remove(docList.size() - 1);
        }
        if (Strings.isNotEmpty(docList)) {
            for (FolderItemDoc doc : docList) {
            	String logicPathString = knowledgeManager.getLocation(doc.getDocResource().getLogicalPath(), false);
            	doc.setPathString(logicPathString);
            }
        }
        mav.addObject("docList", docList);
        mav.addObject("hasAcl", hasAcl);
        mav.addObject("addAcl", addAcl);
        mav.addObject("all", all);
        mav.addObject("edit", edit);
        mav.addObject("add", add);
        mav.addObject("readonly", readonly);
        mav.addObject("browse", browse);
        mav.addObject("list", list);
    }

    /**
     * todo  查询更多
     * @param homePage 是否在项目首页(只显示9条文档，如果是在更多页面，则按照分页显示)
     * @throws BusinessException 
     */
    private void renderProjectDocsByCondition(String condition, long projectId, Long phaseId, ModelAndView mav, boolean homePage, Map<String, String> paramMap) throws BusinessException {
        List<FolderItemDoc> docList = new ArrayList<FolderItemDoc>();
        boolean hasAcl = false;
        boolean addAcl = false;
        String orgIds = Constants.getOrgIdsOfUser(AppContext.getCurrentUser().getId());
        Set<Integer> sets = docAclManager.getDocResourceAclList(projectId, orgIds);

        boolean all = sets != null && sets.contains(Constants.ALLPOTENT);
        boolean edit = sets != null && sets.contains(Constants.EDITPOTENT);
        boolean add = sets != null && sets.contains(Constants.ADDPOTENT);
        boolean readonly = sets != null && sets.contains(Constants.READONLYPOTENT);
        boolean browse = sets != null && sets.contains(Constants.BROWSEPOTENT);
        boolean list = sets != null && sets.contains(Constants.LISTPOTENT);
        boolean b = all || edit || add, c = readonly || browse || list;
        if (b || c) {
            hasAcl = true;
            if (homePage) {
                Pagination.setNeedCount(false);
                Pagination.setFirstResult(0);
                Pagination.setMaxResults(9);
            }
        }
        docList = docHierarchyManager.getLatestDocsOfProjectByCondition(condition, projectId, phaseId, paramMap, orgIds, hasAcl);
        if (all || edit || add) {
            addAcl = true;
        }

        if (Strings.isNotEmpty(docList)) {
            for (FolderItemDoc doc : docList) {
                String logicPathString = knowledgeManager.getLocation(doc.getDocResource().getLogicalPath(), false);
                doc.setPathString(logicPathString);
            }
        }
        mav.addObject("docList", docList);
        mav.addObject("hasAcl", hasAcl);
        mav.addObject("addAcl", addAcl);
        mav.addObject("all", all);
        mav.addObject("edit", edit);
        mav.addObject("add", add);
        mav.addObject("readonly", readonly);
        mav.addObject("browse", browse);
        mav.addObject("list", list);
    }

    /**
     * 更多项目文档
     */
    public ModelAndView moreProjectDoc(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long projectId = NumberUtils.toLong(request.getParameter("projectId"));
        boolean hasAccess = projectApi.hasViewPermission(AppContext.currentUserId(), projectId);
		if (!hasAccess) {
			throw new BusinessException(AppContext.currentUserName() + " 无权访问");
		}

        ModelAndView mav = new ModelAndView("apps/doc/project/moreProjectDoc");
        Long phaseId = NumberUtils.toLong(request.getParameter("phaseId"));
        this.renderProjectDocs(projectId, phaseId, mav, false);

        ProjectBO projectCompose = projectApi.getProject(projectId);
        boolean isManager = projectApi.isManager(AppContext.currentUserId(), projectId);
        mav.addObject("projectCompose", projectCompose);
        mav.addObject("isManager", isManager);
        mav.addObject("morePro", ApplicationCategoryEnum.doc);
        mav.addObject("projectId", projectId);
        mav.addObject("phaseId", phaseId);
        mav.addObject("condition", "choice");
        mav.addObject("managerFlag", request.getParameter("managerFlag"));
        return mav;
    }

    /**
     * 条件查询更多项目文档
     */
    public ModelAndView queryMoreProjectDocByCondition(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/doc/project/moreProjectDoc");
        Long projectId = NumberUtils.toLong(request.getParameter("projectId"));
        Long phaseId = NumberUtils.toLong(request.getParameter("phaseId"));

        String condition = request.getParameter("condition");
        String name = request.getParameter("name");
        String beginTime = request.getParameter("beginTime");
        String endTime = request.getParameter("endTime");
        String lastUserId = request.getParameter("lastUserId");

        Map<String, String> param = new HashMap<String, String>();
        param.put("name", name);
        param.put("beginTime", beginTime);
        param.put("endTime", endTime);
        param.put("lastUserId", lastUserId);

        this.renderProjectDocsByCondition(condition, projectId, phaseId, mav, false, param);

        ProjectBO projectCompose = projectApi.getProject(projectId);
        boolean isManager = projectApi.isManager(AppContext.currentUserId(), projectId);

        mav.addObject("condition", condition);
		if ("name".equals(condition)) {
			mav.addObject("name", name);
		} else if ("modifyDate".equals(condition)) {
			mav.addObject("beginTime", beginTime);
			mav.addObject("endTime", endTime);
		} else if ("lastUserId".equals(condition)) {
			mav.addObject("lastUserId", lastUserId);
		}

        mav.addObject("projectCompose", projectCompose);
        mav.addObject("isManager", isManager);
        mav.addObject("morePro", ApplicationCategoryEnum.doc);
        mav.addObject("projectId", projectId);
        mav.addObject("phaseId", phaseId);
        return mav;
    }

    /**
     * M1侧四专用
     */
    public ModelAndView test(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
//    	docHierarchyManager.getAllCommmonDocCount( null, 6393174481546202888L, "", null, 4840282265262506617l, "");
    	docHierarchyManager.getAllPersonAlShareDocCount(null,null,null,4840282265262506617l);
    	AppContext.currentUserId();
        return null;
    }

	public void setKnowledgeFavoriteManager(KnowledgeFavoriteManager knowledgeFavoriteManager) {
        this.knowledgeFavoriteManager = knowledgeFavoriteManager;
    }

    public void setDocSpaceManager(DocSpaceManager docSpaceManager) {
        this.docSpaceManager = docSpaceManager;
    }

	public SystemConfig getSystemConfig() {
		return systemConfig;
	}

	public void setSystemConfig(SystemConfig systemConfig) {
		this.systemConfig = systemConfig;
	}

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    public void setCollaborationApi(CollaborationApi collaborationApi) {
        this.collaborationApi = collaborationApi;
    }

    public void setWebmailApi(WebmailApi webmailApi) {
        this.webmailApi = webmailApi;
    }

    public void setEdocApi(EdocApi edocApi) {
        this.edocApi = edocApi;
    }

    public void setProjectApi(ProjectApi projectApi) {
        this.projectApi = projectApi;
    }
    
    public void setKnowledgeManager(KnowledgeManager knowledgeManager) {
        this.knowledgeManager = knowledgeManager;
    }

	public void setProjectPhaseEventManager(
			ProjectPhaseEventManager projectPhaseEventManager) {
		this.projectPhaseEventManager = projectPhaseEventManager;
	}
	
	public List<DocLibTableVo> getLibVos(List<DocLibPO> docLibsShow, Map<Long, DocResourcePO> rootMap,
			boolean isEdoc, boolean isPluginEdoc, boolean isPluginProject,
			Long currentUserId) throws BusinessException {
			List<DocLibTableVo> libVos = new ArrayList<DocLibTableVo>();
            for (DocLibPO docLib : docLibsShow) {
                if (docLib.getType() == Constants.EDOC_LIB_TYPE.byteValue()) {
                    if (!isEdoc || !isPluginEdoc) {
                        continue;
                    }
                }
                if (docLib.getType() == Constants.PROJECT_LIB_TYPE.byteValue()) {
                    if (!isPluginProject) {
                        continue;
                    }
                }
                DocResourcePO drRoot = rootMap.get(docLib.getId());
                if (drRoot == null)
                    continue;

                DocAclVO root = new DocAclVO(drRoot);
                boolean isPersonalLib = docLib.isPersonalLib();
                root.getDocResource().setIsMyOwn(isPersonalLib);
                root.setIsPersonalLib(isPersonalLib);
                this.setGottenAclsInVO(root, currentUserId, false);

                DocLibTableVo vo = new DocLibTableVo(docLib);
                vo.setCreateName(Functions.showMemberName(docLib.getCreateUserId()));
                vo.setDocLibType(Constants.getDocLibType(docLib.getType()));
                vo.setRoot(root);
                //公文库显示  共享  huangfj 2013-05-15
                //vo.setNoShare(docLib.isEdocLib() || docLib.isProjectLib());

                List<Long> libOwners = docLibManager.getOwnersByDocLibId(docLib.getId());
                vo.setIsOwner(libOwners != null && libOwners.contains(currentUserId));
                String libOwnerNames = this.getLibOwnerNames(libOwners, docLib.isGroupLib());
                vo.setManagerName(libOwnerNames);
                String v = SecurityHelper.digest(vo.getRoot().getDocResource().getId(),vo.getRoot().getDocResource().getFrType(),vo.getDoclib().getId(),
                		vo.getDoclib().getType(),false,vo.getRoot().isAllAcl(),vo.getRoot().isEditAcl(),
                		vo.getRoot().isAddAcl(),vo.getRoot().isReadOnlyAcl(),vo.getRoot().isBrowseAcl(),vo.getRoot().isListAcl());
                vo.setV(v);
                String vForProperties = SecurityHelper.digest(vo.getRoot().getDocResource().getId(),vo.getDoclib().getId(),vo.getDoclib().getType(),
                		false);
                vo.setvForProperties(vForProperties);
//                String vForShare = SecurityHelper.digest(vo.getRoot().getDocResource().getId(),vo.getDoclib().getId(),vo.getDoclib().getType(),
//                		false,vo.getRoot().isAllAcl(),vo.getRoot().isEditAcl(),
//                		vo.getRoot().isAddAcl(),vo.getRoot().isReadOnlyAcl(),vo.getRoot().isBrowseAcl(),vo.getRoot().isListAcl());
                vo.setvForShare(vForProperties);
                libVos.add(vo);
            }
		return libVos;
	}
	
	/**
	 * 查看一个文档库的日志记录 
	 * @param request
	 * @param response
	 * @return
	 */
    public ModelAndView docLogsView(HttpServletRequest request, HttpServletResponse response)throws Exception {
        ModelAndView modelView = new ModelAndView("apps/doc/log/docLogQuery");
        Long userId= AppContext.getCurrentUser().getId();
        Long docLibId = Long.valueOf(request.getParameter("docLibId"));
        String fromTime = request.getParameter("fromTime");
        String toTime = request.getParameter("toTime");
        String userName = request.getParameter("userName");
        String title = request.getParameter("title");
        String actionType = request.getParameter("actionType");
        String docResId = request.getParameter("docResId");
        
        DocResourcePO doc = docHierarchyManager.getDocResourceById(Long.parseLong(docResId));
        
        List<Long> libOwnerIds = DocMVCUtils.getLibOwners(doc);
        boolean isOwner = libOwnerIds != null && libOwnerIds.contains(userId);
        List<Long> docIds = new ArrayList<Long>();
        //判断是否为管理员,管理员获取所有文档日志,非管理员获取当前路径下的所有文档及文档夹操作日志	
        if(isOwner){
        	List<DocResourcePO> docs = docHierarchyManager.getDocsByDocLibId(docLibId);
        	for(DocResourcePO d:docs){
        		docIds.add(d.getId());
        	}
            docIds.add(Long.parseLong(docResId));
        }else{
        	docIds = docHierarchyManager.getDocsByParentFrId(doc.getId());
        	List<Long> ids = new ArrayList<Long>();
        	ids.add(Long.parseLong(docResId));
        	for(Long docId:docIds){
        		Potent p = docAclManager.getAclVO(docId);
        		if(p.isAll()){
        			ids.add(docId);
        		}
        	}
        	docIds = new ArrayList<Long>();
        	docIds = ids;
        }
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("userName", userName);
        map.put("fromTime", fromTime);
        map.put("toTime", toTime);
        map.put("title", title);
        map.put("actionType", actionType);
        
        List<OperationLog> docLogs = operationlogManager.getAllOperationLogByConditions(docIds, true,map);
        V3xOrgMember member = null;
        V3xOrgAccount account = null;
        List<ListDocLog> the_list = new ArrayList<ListDocLog>();
        
        if(Strings.isEmpty(docLogs)){
        	return modelView;
        }
        for (OperationLog docLog:docLogs) {
            ListDocLog listDocLog = new ListDocLog();
            listDocLog.setOperationLog(docLog);
            try {
                member = orgManager.getMemberById(docLog.getMemberId());
                account = orgManager.getAccountById(member.getOrgAccountId());
            } catch (BusinessException e) {
                log.error("从orgManager取得用户", e);
            }
            listDocLog.setMember(member);
            listDocLog.setAccount(account);
            the_list.add(listDocLog);
        }
        
        modelView.addObject("docLogVeiw", the_list);
        modelView.addObject("docLibId", docLibId);
        modelView.addObject("isFolder", false);
        modelView.addObject("search", true);
        return modelView;
    }
    /**
     * 我的收藏
     * @param request
     * @param response
     * @return
     */
    public ModelAndView myCollection(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	ModelAndView modelView = new ModelAndView("apps/doc/myFavority");
    	Long userId = AppContext.currentUserId();
    	//获取个人文档库
    	DocLibPO lib = docLibManager.getPersonalLibOfUser(userId);
    	Long docLibId = lib.getId();
    	String condition = request.getParameter("condition");
    	String fromTime = request.getParameter("fromTime");
    	String toTime = request.getParameter("toTime");
    	String userName = request.getParameter("userName");
    	String title = request.getParameter("title");
    	String frType = request.getParameter("frType");
    	String value1 = "";
    	String value2 = "";
    	Map<String,Object> map = new HashMap<String, Object>();
    	if(Strings.isNotBlank(condition)){
    		if("title".equals(condition)){
    			map.put("docName", title);
    			value1 = title;
    		}else if("userName".equals(condition)){
    			map.put("userName", userName);
    			value1 = userName;
    		}else if("createDate".equals(condition)){
    			map.put("fromTime", fromTime);
    			map.put("toTime", toTime);
    			value1 = fromTime;
    			value2 = toTime;
    		}else if("frType".equals(condition)){
    			map.put("frType", frType);
    			value1 = frType;
    		}
    	}
    	map.put("docLibId", docLibId.toString());
    	List<DocResourcePO> lists =  docHierarchyManager.findFavoriteByCondition(map);
    	List<Map<String,Object>> myFav =  new ArrayList<Map<String,Object>>();
    	for(DocResourcePO list:lists){
    		Map<String,Object> m = new HashMap<String, Object>();
    		DocTypePO docType = contentTypeManager.getContentTypeById(Long.valueOf(list.getFrType()));
    		String typeName = docType.getName();
    		m.put("typeName", typeName);
    		m.put("createTime", list.getCreateTime());
    		m.put("frName", list.getFrName());
    		m.put("name", orgManager.getMemberById(list.getCreateUserId()).getName());
    		m.put("id", list.getId());
    		m.put("isLink", list.getFrType() == Constants.LINK);
    		m.put("createUserId", list.getCreateUserId());
    		m.put("appEnumKey", getAppEnum(list.getFrType()));
    		Map<String,String> logicPath = getLogicPath(list.getLogicalPath());
    		String fullPath = logicPath.get("fullPath");
    		String halfPath = logicPath.get("halfPath");
    		m.put("fullPath", fullPath);
    		m.put("halfPath", halfPath);
    		m.put("parentId", list.getParentFrId());
    		m.put("docLibId", list.getDocLibId());
    		m.put("sourceId", list.getSourceId());
    		m.put("v", SecurityHelper.digest(list.getParentFrId(),31,list.getDocLibId(),1,Boolean.FALSE,true,true ,
    				true,true,true,true));
    		myFav.add(m);
    		
    	}
    	List<DocTypePO> types = contentTypeManager.getAllSearchContentType();
        List<DocTypePO> typesRe = new ArrayList<DocTypePO>();
        List<Long> needRemoveId = new ArrayList<Long>();
        needRemoveId.add(Constants.SYSTEM_COL);//协同
        needRemoveId.add(Constants.SYSTEM_FORM);//表單
        needRemoveId.add(Constants.SYSTEM_NEWS);//新闻
        needRemoveId.add(Constants.SYSTEM_BULLETIN);//公告
        needRemoveId.add(Constants.SYSTEM_BBS);//讨论
        needRemoveId.add(Constants.DOCUMENT);//文档
        //needRemoveId.add(Constants.FOLDER_COMMON);//文件夹
        needRemoveId.add(Constants.LINK);//映射
        needRemoveId.add(Constants.SYSTEM_INFO);//映射
        for (DocTypePO dp : types) {
            if (needRemoveId.contains(dp.getId())) {
                typesRe.add(dp);
            }
        }
        types = typesRe;
    	
    	modelView.addObject("myFav", myFav);
    	modelView.addObject("docLibId", docLibId);
    	modelView.addObject("condition", condition);
    	modelView.addObject("types", types);
    	modelView.addObject("value1", value1);
    	modelView.addObject("value2", value2);
    	modelView.addObject("onlyA6", DocMVCUtils.isOnlyA6());
    	modelView.addObject("onlyA6s", DocMVCUtils.isOnlyA6S());
    	return modelView;
    }
    
    public int getAppEnum(Long type){
    	if (type == Constants.SYSTEM_ARCHIVES) {
            return ApplicationCategoryEnum.edoc.getKey();
        } else if (type == Constants.SYSTEM_BBS) {
            return ApplicationCategoryEnum.bbs.getKey();
        } else if (type == Constants.SYSTEM_BULLETIN) {
            return ApplicationCategoryEnum.bulletin.getKey();
        } else if (type == Constants.SYSTEM_COL) {
            return ApplicationCategoryEnum.collaboration.getKey();
        } else if (type == Constants.SYSTEM_FORM) {
            return ApplicationCategoryEnum.form.getKey();
        } else if (type == Constants.SYSTEM_INQUIRY) {
            return ApplicationCategoryEnum.inquiry.getKey();
        } else if (type == Constants.SYSTEM_MEETING) {
            return ApplicationCategoryEnum.meeting.getKey();
        } else if (type == Constants.SYSTEM_NEWS) {
            return ApplicationCategoryEnum.news.getKey();
        } else if (type == Constants.SYSTEM_PLAN) {
            return ApplicationCategoryEnum.plan.getKey();
        } else if (type == Constants.SYSTEM_MAIL) {
            return ApplicationCategoryEnum.mail.getKey();
        } else if (type == Constants.SYSTEM_INFO) {
            return ApplicationCategoryEnum.info.getKey();
        } else if (type == Constants.SYSTEM_INFOSTAT) {
            return ApplicationCategoryEnum.infoStat.getKey();
        } else {
            return ApplicationCategoryEnum.doc.getKey();
        }
    }
    
    public Map<String,String> getLogicPath(String path){
    	Map<String,String> m = new HashMap<String, String>();
    	String[] pathList = path.split("\\.");
    	
    	StringBuffer fullName = new StringBuffer();
    	for(int i=0;i<pathList.length;i++){
    		fullName.append("/"+ResourceUtil.getString(docHierarchyManager.getDocResourceById(Long.parseLong(pathList[i])).getFrName()));
    	}
    	m.put("fullPath", fullName.toString());
    	StringBuffer name = new StringBuffer();
    	if(pathList.length<4){
    		m.put("halfPath", fullName.toString());
    	}else{
    		for(int i=pathList.length-1;i<pathList.length;i--){
    			if(i<pathList.length-3){
    				break;
    			}
    			name.insert(0,"/"+ResourceUtil.getString(docHierarchyManager.getDocResourceById(Long.parseLong(pathList[i])).getFrName()));
    		}
    		name.insert(0, "...");
    		m.put("halfPath", name.toString());
    	}
    	return m;
    }
    
    public ModelAndView docMoveAlert(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView ret = new ModelAndView("apps/doc/docMoveAlert");
        String ids = request.getParameter("ids");
        String[] frIds = ids.split(",");
        List<String> frNames = new ArrayList<String>();
        for (String frId : frIds) {
			DocResourcePO doc = docHierarchyManager.getDocResourceById(Long.parseLong(frId));
			frNames.add(doc.getFrName());
		}
        ret.addObject("names", frNames);
        return ret;
    }
    
    public ModelAndView redirect4VJ(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView ret = new ModelAndView("apps/doc/redirect4VJ");
        return ret;
    }
}