package com.seeyon.apps.doc.util;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.collaboration.enums.ColOpenFrom;
import com.seeyon.apps.doc.enums.EntranceTypeEnum;
import com.seeyon.apps.doc.manager.ContentTypeManager;
import com.seeyon.apps.doc.manager.DefaultSearchCondition;
import com.seeyon.apps.doc.manager.DocAclManager;
import com.seeyon.apps.doc.manager.DocAclNewManager;
import com.seeyon.apps.doc.manager.DocHierarchyManager;
import com.seeyon.apps.doc.manager.DocLibManager;
import com.seeyon.apps.doc.manager.DocMimeTypeManager;
import com.seeyon.apps.doc.po.DocAcl;
import com.seeyon.apps.doc.po.DocLibPO;
import com.seeyon.apps.doc.po.DocMetadataDefinitionPO;
import com.seeyon.apps.doc.po.DocMetadataOptionPO;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.doc.po.DocTypePO;
import com.seeyon.apps.doc.util.Constants.DocSourceType;
import com.seeyon.apps.doc.vo.DocAclVO;
import com.seeyon.apps.doc.vo.DocCollection;
import com.seeyon.apps.doc.vo.DocPersonalShareVO;
import com.seeyon.apps.doc.vo.DocTableVO;
import com.seeyon.apps.doc.vo.DocTreeVO;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.apps.edoc.bo.EdocElementBO;
import com.seeyon.apps.project.api.ProjectApi;
import com.seeyon.apps.project.bo.ProjectBO;
import com.seeyon.apps.project.bo.ProjectMemberInfoBO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.ApplicationSubCategoryEnum;
import com.seeyon.ctp.common.constants.ProductEditionEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.flag.BrowserEnum;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.common.dao.paginate.Pagination;


/**
 * 用于分离DocController中的部分私有方法
 * @author <a href="mailto:yangm@seeyon.com">Rookie Young</a> 2010-10-25
 */
public class DocMVCUtils {
    private static final Log  logger = LogFactory.getLog(DocMVCUtils.class);
    
    private static OrgManager         orgManager = null;
    private static EdocApi edocApi;
	private static OrgManager getOrgManager(){
		if(orgManager == null){
			orgManager = (OrgManager)AppContext.getBean("orgManager");
		}
		return orgManager;
	}
	
	public static EdocApi getEdocApi() {
	    if (edocApi == null) {
	        edocApi = (EdocApi) AppContext.getBean("edocApi");
        }
        return edocApi;
    }
	
    /**
     * 获取文档树节点VO，此方法为重构后extract method，以便单点维护(2010-10-25)
     * @param userId	用户ID
     * @param dr	文档
     * @param isPersonalLib		是否为个人文档库
     * @return	文档树节点VO
     * @throws BusinessException 
     */
    public static DocTreeVO getDocTreeVO(Long userId, DocResourcePO dr, boolean isPersonalLib,
            DocMimeTypeManager docMimeTypeManager, DocAclManager docAclManager) throws BusinessException {
        DocTreeVO vo = new DocTreeVO(dr);
        setGottenAclsInVO(vo, userId, false, docAclManager);
        Long mimeTypeId = dr.getMimeTypeId();
        if(mimeTypeId==null){
            mimeTypeId = 31L;//文档夹
        }
        String srcIcon = docMimeTypeManager.getDocMimeTypeById(mimeTypeId).getIcon();
        if (srcIcon.indexOf('|') != -1) {
            vo.setOpenIcon(srcIcon.substring(srcIcon.indexOf('|') + 1, srcIcon.length()));
            vo.setCloseIcon(srcIcon.substring(0, srcIcon.indexOf('|')));
        } else {
            vo.setOpenIcon(srcIcon);
            vo.setCloseIcon(srcIcon);
        }
        vo.setIsPersonalLib(isPersonalLib);
        setNeedI18nInVo(vo);
        return vo;
    }
    
    /**
     * 虚拟项目类别
     * @return
     */
    public static boolean isProjectVirtualCategory(Long frType, Long folderId, DocLibPO docLib, String projectTypeId) {
        return folderId.equals(Constants.DOC_LIB_ROOT_ID_PROJECT) 
                && docLib.getType() == Constants.PROJECT_LIB_TYPE 
                && frType == Constants.PERSON_SHARE 
                && projectTypeId != null && !"".equals(projectTypeId);
    }
    
    /**
     * 新建虚拟项目分类(跟目录，为项目文档库)，虚拟的判定为Constants.PERSON_SHARE，非个人分享一种
     */
    public static List<DocResourcePO> projectRootCategory(Long frType, Long folderId, DocLibPO docLib, List<DocResourcePO> drs,ProjectApi projectApi,OrgManager orgManager) throws BusinessException {
        if(isProjectRoot(frType, folderId, docLib)){
            List<ProjectBO> ptList =  projectApi.findProjectsByMemberId(AppContext.currentUserId());
            List<Long> psIds = new ArrayList<Long>();
            for (ProjectBO ps : ptList) {
                psIds.add(ps.getId());
            }
            
            //如果能查出文档，那么就有权限查看某个分类下的文档，必须查询出项目分类
            if (Strings.isNotEmpty(drs)) {
                for (DocResourcePO doc : drs) {
                    if (!psIds.contains(doc.getSourceId())) {
                        //本不想放循环里面查询，但是向庆拒绝提供批量查询的方法，我忍...，我忍...
                        ProjectBO ps = projectApi.getProject(doc.getSourceId());
                        if (ps != null && ps.getId() != null) {
                            psIds.add(ps.getId());
                            ptList.add(ps);
                        }
                    }
                }
            }
            
            Map<Long,String> ptMap = new HashMap<Long,String>();
            Set<Long> ptypes = new HashSet<Long>();
            for (ProjectBO pt : ptList) {
                if (pt.getDomainId() != AppContext.currentAccountId()) {
                    V3xOrgAccount account =orgManager.getAccountById(pt.getDomainId());
                    String accountName = account.getName();
                    ptMap.put(pt.getProjectTypeId(), pt.getProjectTypeName()+"("+accountName+")");
                } else {
                    ptMap.put(pt.getProjectTypeId(), pt.getProjectTypeName());
                }
                ptypes.add(pt.getProjectTypeId());
            }
            drs = buildProjectFloder(ptMap,ptypes,folderId,docLib.getId());
            //项目分类是通过项目动态包装的，所以这里应该是包装后，项目分类的数据
            Pagination.setRowCount(drs.size());
        }
        return drs;
    }
    
    /**
     * 项目跟目录
     */
    public static boolean isProjectRoot(Long frType, Long folderId, DocLibPO docLib) {
        return folderId.equals(Constants.DOC_LIB_ROOT_ID_PROJECT) && docLib.getType() == Constants.PROJECT_LIB_TYPE && frType == Constants.FOLDER_PROJECT_ROOT;
    }
    
    public static void parseProjectStatus(List<DocResourcePO> drs,ProjectApi projectApi,DocHierarchyManager docHierarchyManager) throws BusinessException {
        //没数据返回时的判定空的判定
        List<ProjectBO> ptList = projectApi.findProjectsByMemberId(AppContext.currentUserId());
        Map<Long, Byte> sourceId2State = new HashMap<Long, Byte>();
        for (ProjectBO projectSummary : ptList) {
            sourceId2State.put(projectSummary.getId(), (byte) projectSummary.getProjectState());
        }
        //logicPath与项目状态map
        Map<String, Byte> logicPath2pState = new HashMap<String, Byte>();
        //找出project
        List<DocResourcePO> pRootFolders = docHierarchyManager.findProjectRootFolder();
        for (DocResourcePO doc : pRootFolders) {
            Byte state = sourceId2State.get(doc.getSourceId());
            if (state != null) {
                logicPath2pState.put(doc.getLogicalPath(), state);
            }
        }
        //设置状态
        for (DocResourcePO doc : drs) {
            String[] logicPath = doc.getLogicalPath().split("[.]");
            if (logicPath.length > 1) {
                StringBuilder rootlogicPath = new StringBuilder(logicPath[0]);
                rootlogicPath.append(".").append(logicPath[1]);
                Byte state = logicPath2pState.get(rootlogicPath.toString());
                doc.setProjectStatus(state);
            }
        }
    }
    
    public static List<DocResourcePO> buildProjectFloder(Map<Long, String> ptMap, Set<Long> pTypes, Long folderId,Long docLibId) {
        Timestamp date = new Timestamp(System.currentTimeMillis());
        List<DocResourcePO> drs = new ArrayList<DocResourcePO>();
        for (Long projectTypeId : pTypes) {
            DocResourcePO dr = new DocResourcePO();
            dr.setId(folderId);
            dr.setFrName(ptMap.get(projectTypeId));
            dr.setFrType(Constants.PERSON_SHARE);//虚拟类型，不是个人分享
            dr.setCreateTime(date);
            dr.setCreateUserId(null);
            dr.setDocLibId(docLibId);
            dr.setIsFolder(true);
            dr.setSubfolderEnabled(false);
            dr.setFrSize(0);
            dr.setMimeTypeId(null);
            dr.setLastUpdate(date);
            dr.setLastUserId(null);
            dr.setLogicalPath(folderId.toString());
            dr.setProjectTypeId(projectTypeId);
            drs.add(dr);
        }
        return drs;
    }
    
    /**
     * 是否是A6版本
     * @return
     */
    public static boolean isOnlyA6() {
        SystemProperties systemInstance = SystemProperties.getInstance();
        String onlyA6 = systemInstance.getProperty("system.onlyA6");
        if (onlyA6 != null && "true".equals(onlyA6)) {
            return true;
        }
        return false;
    }
    
    /**
     * 是否是A6-s版本
     * @return
     */
    public static boolean isOnlyA6S() {
        return ProductEditionEnum.getCurrentProductEditionEnum().getValue().equals(ProductEditionEnum.a6s.getValue());
    }
    /**
     * G6单组织
     */
    public static boolean isGovVer(){
        return ProductEditionEnum.getCurrentProductEditionEnum().getValue().equals(ProductEditionEnum.government.getValue());
    }
    
    /**
     * G6多组织
     */
    public static boolean isG6Group(){
        return ProductEditionEnum.getCurrentProductEditionEnum().getValue().equals(ProductEditionEnum.governmentgroup.getValue());
    }

    /**
     * 获取文档树节点VO，此方法为重构后extract method，以便单点维护(2010-10-25)
     * @param userId	用户ID
     * @param dr	文档
     * @param docLibType	文档库类型
     * @return	文档树节点VO
     * @throws BusinessException 
     */
    public static DocTreeVO getDocTreeVO(Long userId, DocResourcePO dr, byte docLibType,
            DocMimeTypeManager docMimeTypeManager, DocAclManager docAclManager) throws BusinessException {
        DocTreeVO vo = getDocTreeVO(userId, dr, docLibType == Constants.PERSONAL_LIB_TYPE, docMimeTypeManager,
                docAclManager);
        vo.setDocLibType(docLibType);
        return vo;
    }

    /** 设置DocAclVO对象中的权限标记  
     * @throws BusinessException */
    public static void setGottenAclsInVO(DocAclVO vo, Long userId, boolean isBorrowOrShare, DocAclManager docAclManager)
            throws BusinessException {
        if (AppContext.getCurrentUser().isAdministrator()) {
            vo.setAllAcl(true);
            vo.setAddAcl(true);
            vo.setEditAcl(true);
            vo.setReadOnlyAcl(true);
            vo.setBrowseAcl(true);
            vo.setListAcl(true);
            return;
        }

        DocResourcePO dr = vo.getDocResource();
        if (dr == null)
            return;

        // 计划
        if (dr.getFrType() == Constants.FOLDER_PLAN || dr.getFrType() == Constants.FOLDER_PLAN_DAY
                || dr.getFrType() == Constants.FOLDER_PLAN_MONTH || dr.getFrType() == Constants.FOLDER_PLAN_WEEK
                || dr.getFrType() == Constants.FOLDER_PLAN_WORK) {
            vo.setAllAcl(false);
            vo.setAddAcl(false);
            vo.setEditAcl(false);
            vo.setReadOnlyAcl(false);
            vo.setBrowseAcl(false);
            vo.setListAcl(true);
        } else if (dr.getFrType() == Constants.SYSTEM_PLAN) {
            vo.setAllAcl(false);
            vo.setAddAcl(false);
            vo.setEditAcl(false);
            vo.setReadOnlyAcl(false);
            vo.setBrowseAcl(false);
            vo.setListAcl(false);
            vo.setIsBorrowOrShare(true);
        } else if (isBorrowOrShare || (vo.getIsPersonalLib() && !dr.getIsMyOwn())) {
            // 借阅、共享的权限设置
            vo.setAllAcl(false);
            vo.setAddAcl(false);
            vo.setEditAcl(false);
            vo.setListAcl(false);
            vo.setIsBorrowOrShare(true);

            String acl = docAclManager.getBorrowPotent(dr.getId());
            // 进入此方法不是个人（单位）借阅就是个人共享 duanyl
            if (acl != null) {
                vo.setReadOnlyAcl('1' == acl.charAt(0));
                vo.setBrowseAcl('1' == acl.charAt(1));
                vo.setListAcl('1' == acl.charAt(2));
            } else {
                vo.setBrowseAcl(true);
            }

        } else if (dr.getIsMyOwn()) {
            vo.setAllAcl(true);
            vo.setAddAcl(true);
            vo.setEditAcl(true);
            vo.setReadOnlyAcl(true);
            vo.setBrowseAcl(true);
            vo.setListAcl(true);
        } else {
            // 2007.07.19 lihf 权限从DocResource取得（Manager返回时已经添加）
            Set<Integer> aclset = vo.getDocResource().getAclSet();
            if (Strings.isEmpty(aclset)) {
                if (!vo.getDocResource().getHasAcl()) {
                    // 不做重复抽取
                    String aclIds = Constants.getOrgIdsOfUser(userId);
                    Set<Integer> acls = docAclManager.getDocResourceAclList(dr, aclIds);
                    if (acls != null) {
                        if (acls.contains(Constants.ALLPOTENT))
                            vo.setAllAcl(true);

                        if (acls.contains(Constants.EDITPOTENT))
                            vo.setEditAcl(true);

                        if (acls.contains(Constants.ADDPOTENT))
                            vo.setAddAcl(true);

                        if (acls.contains(Constants.READONLYPOTENT))
                            vo.setReadOnlyAcl(true);

                        if (acls.contains(Constants.BROWSEPOTENT))
                            vo.setBrowseAcl(true);

                        if (acls.contains(Constants.LISTPOTENT))
                            vo.setListAcl(true);
                    }
                }
            } else {
                for (int da : aclset) {
                    switch (da) {
                        case Constants.ALLPOTENT:
                            vo.setAllAcl(true);
                            break;
                        case Constants.ADDPOTENT:
                            vo.setAddAcl(true);
                            break;
                        case Constants.EDITPOTENT:
                            vo.setEditAcl(true);
                            break;
                        case Constants.READONLYPOTENT:
                            vo.setReadOnlyAcl(true);
                            break;
                        case Constants.BROWSEPOTENT:
                            vo.setBrowseAcl(true);
                            break;
                        case Constants.LISTPOTENT:
                            vo.setListAcl(true);
                            break;
                    }
                }
            }
        }
    }

    private static Set<Long> NEED_I18N_TYPES = null;
    static {
        NEED_I18N_TYPES = new HashSet<Long>();

        NEED_I18N_TYPES.add(Constants.FOLDER_MINE);
        NEED_I18N_TYPES.add(Constants.FOLDER_CORP);
        NEED_I18N_TYPES.add(Constants.ROOT_ARC);
        NEED_I18N_TYPES.add(Constants.FOLDER_ARC_PRE);
        NEED_I18N_TYPES.add(Constants.FOLDER_PROJECT_ROOT);
        NEED_I18N_TYPES.add(Constants.FOLDER_PLAN);
        NEED_I18N_TYPES.add(Constants.FOLDER_TEMPLET);
        NEED_I18N_TYPES.add(Constants.FOLDER_SHARE);
        NEED_I18N_TYPES.add(Constants.FOLDER_SHAREOUT);
        NEED_I18N_TYPES.add(Constants.FOLDER_BORROWOUT);
        NEED_I18N_TYPES.add(Constants.FOLDER_BORROW);
        NEED_I18N_TYPES.add(Constants.FOLDER_PLAN_DAY);
        NEED_I18N_TYPES.add(Constants.FOLDER_PLAN_MONTH);
        NEED_I18N_TYPES.add(Constants.FOLDER_PLAN_WEEK);
        NEED_I18N_TYPES.add(Constants.FOLDER_PLAN_WORK);
        NEED_I18N_TYPES.add(Constants.DEPARTMENT_BORROW);
    }

    /** 设置DocAcLVO中的needI18n标记  */
    public static void setNeedI18nInVo(DocAclVO vo) {
        Long type = vo.getDocResource().getFrType();
        vo.setNeedI18n(NEED_I18N_TYPES.contains(type));
    }

    /**
     * 计算每一列宽度，标题列宽度3倍展现，公文号2倍展现，其余按照所得结果展现
     */
    public static List<Integer> getColumnWidthNew(List<DocMetadataDefinitionPO> dmds) {
        List<Integer> widths = new ArrayList<Integer>();
        for (DocMetadataDefinitionPO dmd : dmds) {
            if ("frName".equals(dmd.getPhysicalName()))
                widths.add(Constants.getWidthByType(dmd.getType()) * 3);
            else if ("avarchar17".equals(dmd.getPhysicalName()))
                widths.add(Constants.getWidthByType(dmd.getType()) * 2);
            else
                widths.add(Constants.getWidthByType(dmd.getType()));
        }
        logger.debug("result widths -- " + widths);
        return widths;
    }

    //判定用户是否集团管理员
    public static boolean isGroupAdmin(OrgManager orgManager, Long userId) {
        try {
            return orgManager.isRole(userId, null, Role_NAME.GroupManager.name());
        } catch (BusinessException e) {
            logger.error("通过spaceManager判断用户是否集团管理员出错", e);
        }
        return false;
    }

    //判定用户是否单位管理员
    public static boolean isAccountAdmin(OrgManager orgManager, Long userId, Long accountId) {
        try {
            return orgManager.isRole(userId, accountId, Role_NAME.AccountAdministrator.name());
        } catch (BusinessException e) {
            logger.error("通过spaceManager判断用户是否单位管理员出错", e);
        }
        return false;
    }

    //判定用户是否集团空间的管理员
    public static boolean isGroupSpaceManager(SpaceManager spaceManager, Long userId) {
        try {
            return spaceManager.isGroupSpaceManager(userId);
        } catch (BusinessException e) {
            logger.error("通过spaceManager判断用户是否具有集团空间管理员出错", e);
        }
        return false;
    }

    //判定用户是否指定单位的单位空间管理员
    public static boolean isAccountSpaceManager(SpaceManager spaceManager, Long userId, Long accountId) {
        try {
            return spaceManager.isAccountSpaceManager(userId, accountId);
        } catch (BusinessException e) {
            logger.error("通过spaceManager判断用户是否具有登陆单位空间管理员出错", e);
        }
        return false;

    }

    //判定用户是否指定部门的部门空间管理员
    public static boolean isDeptSpaceManager(SpaceManager spaceManager, Long userId, Long deptId) {
        try {
            return spaceManager.isDeptSpaceManager(userId, deptId);
        } catch (BusinessException e) {
            logger.error("通过spaceManager判断用户是否具有登陆单位空间管理员出错", e);
        }
        return false;
    }

	// 获取用户为部门空间管理员的部门列表（部门ID）
	public static Set<Long> getDeptsByManagerSpace(SpaceManager spaceManager, Long userId) {
		Set<Long> deptIdList = new HashSet<Long>();
		try {
			List<Long> deptIds = spaceManager.getDeptsByManagerSpace(userId);
			for (Long deptId : deptIds) {
				V3xOrgDepartment dept = getOrgManager().getDepartmentById(deptId);
				if (dept != null && dept.isValid() && dept.getOrgAccountId().equals(AppContext.currentAccountId())) {
					deptIdList.add(deptId);
				}
			}
		} catch (BusinessException e) {
			logger.error("通过spaceManager获取用户为部门空间管理员的部门ID列表出错", e);
		}
		return deptIdList;
	}

	// 获取用户为部门空间管理员的部门列表（部门）
	public static Set<V3xOrgDepartment> getDeptsByManagerSpace(SpaceManager spaceManager, OrgManager orgManager, Long userId) {
		Set<V3xOrgDepartment> deptList = new HashSet<V3xOrgDepartment>();
		try {
			for (Long deptId : getDeptsByManagerSpace(spaceManager, userId)) {
				V3xOrgDepartment dept = orgManager.getDepartmentById(deptId);
				deptList.add(dept);
			}
		} catch (BusinessException e) {
			logger.error("通过spaceManager获取用户为部门空间管理员的部门列表出错", e);
		}
		return deptList;
	}

    /** 
     * 得到当前用户可以推送首页的部门集合 
     * @deprecated
     */
    public static Set<Long> getDepSetAdmin(OrgManager orgManager) throws BusinessException {
        // 部门管理员、部门主管都可以发送到部门首页
        HashSet<Long> set = new HashSet<Long>();
        long userId = AppContext.currentUserId();
        SpaceManager spaceManager = (SpaceManager) AppContext.getBean("spaceManager");
        set.addAll(getDeptsByManagerSpace(spaceManager, userId));
        return set;
    }

    /**
     * 在点击文档中心左侧树节点时，动态获取xml信息以便加载节点下的子节点
     * @param docLibId	文档库ID
     * @param folders	文档树节点(子文件夹)VOs
     * @return	xloadtree加载子节点时所需的xml信息
     */
    public static String getXmlStr4LoadNodeOfCommonTree(Long docLibId, List<DocTreeVO> folders) {
        StringBuilder result = new StringBuilder();
        for (DocTreeVO vo : folders) {
            DocResourcePO doc = vo.getDocResource();
            String name = Strings.toXmlStr(doc.getFrName());
            if (vo.getNeedI18n()) {
                name = ResourceUtil.getString(name);
            }

            result.append("<tree businessId=\"" + doc.getId() + "\" icon=\"" + vo.getCloseIcon()
                    + "\" openIcon =\"" + vo.getOpenIcon() + "\"" + " text=\"" + name
                    + "\" src=\"/seeyon/doc.do?method=xmlJsp" + "&amp;resId=" + doc.getId()
                    + "&amp;frType=" + doc.getFrType()+"&amp;projectTypeId="+doc.getProjectTypeId() + "&amp;isShareAndBorrowRoot="
                    + vo.getIsBorrowOrShare() + "\" action=\"javascript:showSrcAndAction('"
                    + doc.getId() + "','" + doc.getFrType() + "','" + docLibId + "','"
                    + vo.getDocLibType() + "','" + vo.getIsBorrowOrShare() + "','" + vo.isAllAcl() + "','"
                    + vo.isEditAcl() + "','" + vo.isAddAcl() + "','" + vo.isReadOnlyAcl() + "','" + vo.isBrowseAcl()
                    + "','" + vo.isListAcl() + "','" + vo.getV()+ "','" + doc.getProjectTypeId() + "')\"/>");
        }

        return result.toString();
    }
    
    // 客开   START
    public static String getXmlStr4LoadNodeOfCommonTopTree(Long docLibId, List<DocTreeVO> folders) {
        StringBuilder result = new StringBuilder();
        for (DocTreeVO vo : folders) {
            DocResourcePO doc = vo.getDocResource();
            String name = Strings.toXmlStr(doc.getFrName());
            if (vo.getNeedI18n()) {
                name = ResourceUtil.getString(name);
            }

            result.append("<tree businessId=\"" + doc.getId() + "\" icon=\"" + vo.getCloseIcon()
                    + "\" openIcon =\"" + vo.getOpenIcon() + "\"" + " text=\"" + name
                    + "\" src=\"/seeyon/doc.do?method=xmlTopJsp" + "&amp;resId=" + doc.getId()
                    + "&amp;frType=" + doc.getFrType()+"&amp;projectTypeId="+doc.getProjectTypeId() + "&amp;isShareAndBorrowRoot="
                    + vo.getIsBorrowOrShare() + "\" action=\"javascript:showSrcAndAction1('"
                    + doc.getId() + "','" + doc.getFrType() + "','" + docLibId + "','"
                    + vo.getDocLibType() + "','" + vo.getIsBorrowOrShare() + "','" + vo.isAllAcl() + "','"
                    + vo.isEditAcl() + "','" + vo.isAddAcl() + "','" + vo.isReadOnlyAcl() + "','" + vo.isBrowseAcl()
                    + "','" + vo.isListAcl() + "','" + vo.getV()+ "','" + doc.getProjectTypeId() + "')\"/>");
        }

        return result.toString();
    }
    
    // 客开   END

    /**
     * 在点击弹出树节点时，动态获取xml信息以便加载节点下的子节点
     * @param lib	文档库
     * @param folders	文档树节点(子文件夹)VOs
     * @param otherAccountShortName		外单位名称简称
     * @return	xloadtree加载子节点时所需的xml信息
     */
    public static String getXmlStr4LoadNodeOfMoveTree(DocLibPO lib, List<DocTreeVO> folders,
            String otherAccountShortName,String validAcls) {
        StringBuilder xmlstr = new StringBuilder("");
        for (DocTreeVO vo : folders) {
            DocResourcePO doc = vo.getDocResource();
            String name = Strings.toXmlStr(doc.getFrName());
            if (vo.getNeedI18n()) {
                name = ResourceUtil.getString(name) + otherAccountShortName;
            }
            xmlstr.append("<tree businessId=\"" + doc.getId() + "\" icon=\"" + vo.getCloseIcon()
                    + "\" openIcon =\"" + vo.getOpenIcon() + "\"" + " text=\"" + name
                    + "\" src=\"/seeyon/doc.do?method=xmlJspMove" + "&amp;resId=" + doc.getId()
                    + "&amp;frType=" + doc.getFrType() + "&amp;docLibId="
                    + doc.getDocLibId()+ "&amp;projectTypeId=" + doc.getProjectTypeId() + "&amp;docLibType=" + lib.getType()
                    + "&amp;isShareAndBorrowRoot=" + vo.getIsBorrowOrShare() + "&amp;logicalPath="
                    + doc.getLogicalPath() + "&amp;all=" + vo.isAllAcl() + "&amp;edit="
                    + vo.isEditAcl() + "&amp;add=" + vo.isAddAcl() + "&amp;commentEnabled="+ doc.getCommentEnabled() + "&amp;validAcl=" + validAcls
                     + "\" " + "action=\"validateAcl4New('" + vo.isAllAcl()
                    + "','" + vo.isEditAcl() + "','" + vo.isAddAcl() + "');\" " + " target=\"moveIframe\"/>");
        }
        return xmlstr.toString();
    }

    /**
     * 在插入关联文档时，点击关联文档中心左侧树节点时，动态获取xml信息以便加载节点下的子节点
     * @param docLibId	文档库ID
     * @param folders	文档树节点(子文件夹)VOs
     * @return	xloadtree加载子节点时所需的xml信息
     */
    public static String getXmlStr4LoadNodeOfQuoteTree(Long docLibId, List<DocTreeVO> folders) {
        StringBuilder sb = new StringBuilder();
        if (CollectionUtils.isNotEmpty(folders)) {
            for (DocTreeVO vo : folders) {
                String name = Strings.toXmlStr(vo.getDocResource().getFrName());
                if (vo.getNeedI18n()) {
                    name = ResourceUtil.getString(name);
                }

                sb.append("<tree businessId=\"" + vo.getDocResource().getId() + "\" icon=\"" + vo.getCloseIcon()
                        + "\" openIcon =\"" + vo.getOpenIcon() + "\"" + " text=\"" + name
                        + "\" src=\"/seeyon/doc.do?method=xmlJspQuote" + "&amp;projectTypeId="+vo.getDocResource().getProjectTypeId()+"&amp;resId=" + vo.getDocResource().getId()
                        + "&amp;frType=" + vo.getDocResource().getFrType()
                        + "\" action=\"javascript:showSrcAndAction4Quote('" + vo.getDocResource().getId() + "','"
                        + vo.getDocResource().getFrType() + "','" + docLibId + "','" + vo.getDocLibType() + "','"
                        + vo.getIsBorrowOrShare() + "','" + vo.isAllAcl() + "','" + vo.isEditAcl() + "','"
                        + vo.isAddAcl() + "','" + vo.isReadOnlyAcl() + "','" + vo.isBrowseAcl() + "','" +vo.getDocResource().getProjectTypeId()+"','"
                        + vo.isListAcl() + "','" + "')\"/>");
            }
        }
        return sb.toString();
    }

    /**
     * 在项目文档夹下点击树状节点时，动态获取xml信息以便加载节点下的子节点
     * @param folders	文档树节点(子文件夹)VOs
     * @return	xloadtree加载子节点时所需的xml信息
     */
    public static String getXmlStr4LoadNodeOfProjectTree(List<DocTreeVO> folders) {
        StringBuilder sb = new StringBuilder();
        if (CollectionUtils.isNotEmpty(folders)) {
            for (DocTreeVO vo : folders) {
                String name = vo.getDocResource().getFrName();
                if (vo.getNeedI18n()) {
                    name = ResourceUtil.getString(name);
                }
                sb.append("<tree businessId=\"" + vo.getDocResource().getId() + "\" icon=\"" + vo.getCloseIcon()
                        + "\" openIcon =\"" + vo.getOpenIcon() + "\"" + " text=\"" + name
                        + "\" src=\"/seeyon/doc.do?method=xmlJspProject" + "&amp;resId=" + vo.getDocResource().getId()
                        + "&amp;frType=" + vo.getDocResource().getFrType() + "&amp;docLibId="
                        + vo.getDocResource().getDocLibId() + "&amp;docLibType=" + Constants.PROJECT_LIB_TYPE
                        + "\" target=\"moveIframe\"/>");
            }
        }
        return sb.toString();
    }

    /**
     * 如果当前点击的单位/用户自定义文档库是从外单位共享而来的<br>
     * 点击打开之后其下的文档夹名称需要加上外单位简称
     * @param lib	文档库(本单位文档库或外单位共享来的文档库)
     */
    public static String getOtherAccountShortName(DocLibPO lib, OrgManager orgManager) {
        String result = "";
        boolean isFromOtherAccount = lib.getDomainId() != AppContext.getCurrentUser().getLoginAccount()
                && (lib.getType() == Constants.ACCOUNT_LIB_TYPE.byteValue() || lib.getType() == Constants.USER_CUSTOM_LIB_TYPE
                        .byteValue() || lib.getType() == Constants.EDOC_LIB_TYPE
                        .byteValue());
        if (isFromOtherAccount) {
            try {
                result = "(" + orgManager.getAccountById(lib.getDomainId()).getShortName() + ")";
            } catch (BusinessException e) {
                logger.error("获取当前文档库所在单位出现异常", e);
            }
        }
        return result;
    }

    /** 设置是否归档类型标记  */
    public static void setPigFlag(DocTableVO vo) {
        long type = vo.getDocResource().getFrType();
        if (type == Constants.SYSTEM_ARCHIVES) {
            vo.setIsPig(true);
            vo.setAppEnumKey(ApplicationCategoryEnum.edoc.getKey());
        } else if (type == Constants.SYSTEM_BBS) {
            vo.setIsPig(true);
            vo.setAppEnumKey(ApplicationCategoryEnum.bbs.getKey());
        } else if (type == Constants.SYSTEM_BULLETIN) {
            vo.setIsPig(true);
            vo.setAppEnumKey(ApplicationCategoryEnum.bulletin.getKey());
        } else if (type == Constants.SYSTEM_COL) {
            vo.setIsPig(true);
            vo.setAppEnumKey(ApplicationCategoryEnum.collaboration.getKey());
        } else if (type == Constants.SYSTEM_FORM) {
            vo.setIsPig(true);
            vo.setAppEnumKey(ApplicationCategoryEnum.form.getKey());
        } else if (type == Constants.SYSTEM_INQUIRY) {
            vo.setIsPig(true);
            vo.setAppEnumKey(ApplicationCategoryEnum.inquiry.getKey());
        } else if (type == Constants.SYSTEM_MEETING) {
            vo.setIsPig(true);
            vo.setAppEnumKey(ApplicationCategoryEnum.meeting.getKey());
        } else if (type == Constants.SYSTEM_NEWS) {
            vo.setIsPig(true);
            vo.setAppEnumKey(ApplicationCategoryEnum.news.getKey());
        } else if (type == Constants.SYSTEM_PLAN) {
            vo.setIsPig(true);
            vo.setAppEnumKey(ApplicationCategoryEnum.plan.getKey());
        } else if (type == Constants.SYSTEM_MAIL) {
            vo.setIsPig(true);
            vo.setAppEnumKey(ApplicationCategoryEnum.mail.getKey());
        } else if (type == Constants.SYSTEM_INFO) {
            vo.setIsPig(true);
            vo.setAppEnumKey(ApplicationCategoryEnum.info.getKey());
        } else if (type == Constants.SYSTEM_INFOSTAT) {
            vo.setIsPig(true);
            vo.setAppEnumKey(ApplicationCategoryEnum.infoStat.getKey());
        } else {
            vo.setIsPig(false);
            vo.setAppEnumKey(ApplicationCategoryEnum.doc.getKey());
        }
    }

    /** 转换file的创建日期为 yyyy-mm-dd */
    public static String getCreateDateOfFile(DocResourcePO dr, FileManager fileManager) {
        if (dr == null) {
            return new Date().toString().substring(0, 10);
        }
        return getCreateDateOfFile(dr.getSourceId(), fileManager);
    }

    /** 转换file的创建日期为 yyyy-mm-dd */
    public static String getCreateDateOfFile(Long sourceId, FileManager fileManager) {
        if (sourceId != null) {
            List<V3XFile> files = getCreateDateOfFile(new Long[] { sourceId }, fileManager);
            if (!files.isEmpty()) {
                return files.get(0).getCreateDate().toString().substring(0, 10);
            }
        }
        return new Date().toString().substring(0, 10);
    }

    /** 转换file的创建日期为 yyyy-mm-dd */
    public static List<V3XFile> getCreateDateOfFile(Long[] sourceIds, FileManager fileManager) {
        List<V3XFile> files = null;
        // 对于上传文件，因为可能出现替换情况，导致新建时间不一致，所以应该从系统取。解决下载的定位问题
        try {
            if (sourceIds != null && sourceIds.length > 0) {
                files = fileManager.getV3XFile(sourceIds);
            }
            if (files == null) {
                files = new ArrayList<V3XFile>();
            }
        } catch (BusinessException e) {
            logger.error("从fileManager取得V3xFile, ", e);
        }
        return files;
    }

    /** 取得我的文档授权数据  */
    public static List<DocPersonalShareVO> getMyGrantVO(Long docResId, DocAclManager docAclManager) {
        List<DocPersonalShareVO> pvos = getDocPersonalShareVOs(docResId, docAclManager, false);
        //个人文档夹子目录共享权限删除
        if ((pvos.size() == 1 && pvos.get(0).isInherit())) {
            pvos.clear();
            return pvos;
        }

        if (CollectionUtils.isNotEmpty(pvos)) {
            return pvos;
        } else {
            return getDocPersonalShareVOs(docResId, docAclManager, true);
        }
    }

    public static List<DocPersonalShareVO> getDocPersonalShareVOs(Long docResId, DocAclManager docAclManager,
            boolean inherit) {
        List<DocPersonalShareVO> result = null;

        List<DocAcl> ilist = null;
        if (inherit) {
            ilist = docAclManager.getPersonalShareInHeritList(docResId);
        } else {
            ilist = docAclManager.getPersonalShareList(docResId);
        }

        if (ilist != null) {
            result = new ArrayList<DocPersonalShareVO>();
            for (DocAcl acl : ilist) {
                DocPersonalShareVO pvo = new DocPersonalShareVO();
                //解决个人共享设置的冗余数据
                if (acl.getOwnerId() == acl.getUserId() && acl.getSharetype().equals(Constants.SHARETYPE_PERSSHARE)) {
                    pvo.setInherit(true);
                } else {
                    pvo.setInherit(inherit);
                }
                pvo.setUserId(acl.getUserId());
                String userName = Constants.getOrgEntityName(acl.getUserType(), acl.getUserId(), false);

                pvo.setUserName(userName);
                pvo.setUserType(acl.getUserType());
                pvo.setAclId(acl.getId());

                pvo.setAlert(acl.getIsAlert());
                if (inherit) {
                    pvo.setAlertId(0l);
                } else if (acl.getDocAlertId() != null) {
                    pvo.setAlertId(acl.getDocAlertId());
                }
                result.add(pvo);
            }
        }
        return result;
    }

    public static String[] setDocMetadataDefinitionNames(List<DocMetadataDefinitionPO> definitions, Byte docLibType,boolean isEdocAll) {
        if (CollectionUtils.isNotEmpty(definitions)) {
            List<String> names = new ArrayList<String>(definitions.size());
            Map<Long, EdocElementBO> edocElementMap = new HashMap<Long,EdocElementBO>();
            for (DocMetadataDefinitionPO def : definitions) {
                if (docLibType.equals(Constants.EDOC_LIB_TYPE)) {
                    parseEdocMetadateDef(edocElementMap, def);
                }
                
                if (def == null || def.getStatus() == null || 
                   (!isEdocAll && def.getStatus() == Constants.DOC_METADATA_DEF_STATUS_DELETED)){
                    continue;
                }
                String name = def.getName();
                // 公文建文日期 与 协同发起日期同属一个字段，但显示名称不同
                if (def.getId() == DefaultSearchCondition.Search_EDOC_SEND_DATE
                        && docLibType == Constants.EDOC_LIB_TYPE.byteValue()) {
                    name = ResourceUtil.getString("edoc.edoctitle.createDate.label");
                } else {
                    name = DocMVCUtils.getDisplayName4MetadataDefinition(name);
                }

                def.setShowName(name);
                names.add(name);
            }
            return names.toArray(new String[0]);
        }
        return new String[0];
    }

    /**
     * 写入需要渲染显示的数据，通常会在不同显示场合重复出现
     * @throws BusinessException 
     */
    public static void returnVaule(ModelAndView ret, Byte docLibType, DocLibPO docLib, HttpServletRequest request,
            ContentTypeManager contentTypeManager, DocLibManager docLibManager,boolean isEdocAll) throws BusinessException {
        List<DocTypePO> types = contentTypeManager.getAllSearchContentType();

        if (docLib != null) {
            //如果是我的文档库，则查询条件：内容类型  只显示以下的项
            if (docLib.isPersonalLib()) {
                List<DocTypePO> typesRe = new ArrayList<DocTypePO>();
                List<Long> needRemoveId = new ArrayList<Long>();
                needRemoveId.add(Constants.SYSTEM_COL);//协同
                needRemoveId.add(Constants.SYSTEM_FORM);//表單
                needRemoveId.add(Constants.SYSTEM_NEWS);//新闻
                needRemoveId.add(Constants.SYSTEM_BULLETIN);//公告
                needRemoveId.add(Constants.SYSTEM_BBS);//讨论
                needRemoveId.add(Constants.DOCUMENT);//文档
                needRemoveId.add(Constants.FOLDER_COMMON);//文件夹
                needRemoveId.add(Constants.LINK);//映射
                needRemoveId.add(Constants.SYSTEM_INFO);//映射
                for (DocTypePO dp : types) {
                    if (needRemoveId.contains(dp.getId())) {
                        typesRe.add(dp);
                    }
                }
                types = typesRe;
            } else {
                List<DocTypePO> typesRe = new ArrayList<DocTypePO>();
                List<Long> needRemoveId = new ArrayList<Long>();
                if (!AppContext.hasPlugin("plan")) {
                    needRemoveId.add(Constants.SYSTEM_PLAN);//计划
                }
                for (DocTypePO dp : types) {
                    if (needRemoveId.contains(dp.getId())) {
                        typesRe.add(dp);
                    }
                }
                types.removeAll(typesRe);
            }
        }

        ret.addObject("types", types);
        Long docLibId = docLib.getId();
        renderSearchConditions(ret, docLibManager, docLibId, isEdocAll);

        ret.addObject("isGroupLib", (docLibType.byteValue() == Constants.GROUP_LIB_TYPE.byteValue()));
        ret.addObject("isPrivateLib", docLibType.equals(Constants.PERSONAL_LIB_TYPE));
        ret.addObject("isEdocLib", (docLibType.byteValue() == Constants.EDOC_LIB_TYPE.byteValue()));
        ret.addObject("folderEnabled", docLib.getFolderEnabled());
        ret.addObject("a6Enabled", docLib.getA6Enabled());
        ret.addObject("officeEnabled", docLib.getOfficeEnabled());
        ret.addObject("uploadEnabled", docLib.getUploadEnabled());
        ret.addAllObjects(Constants.EDITOR_TYPES);
        ret.addObject("docLibId", docLibId);
        ret.addObject("docLibType", docLibType);
        ret.addObject("isPersonalLib", (docLibType.byteValue() == Constants.PERSONAL_LIB_TYPE.byteValue()));
        ret.addObject("isGroupLib", (docLibType.byteValue() == Constants.GROUP_LIB_TYPE.byteValue()));
        ret.addObject("isEdocLib", (docLibType.byteValue() == Constants.EDOC_LIB_TYPE.byteValue()));
        ret.addObject("noShare", (docLibType.byteValue() == Constants.EDOC_LIB_TYPE.byteValue() || docLibType
                .byteValue() == Constants.PROJECT_LIB_TYPE.byteValue()));
        ret.addObject("theLib", docLib);
        ret.addObject("isShareAndBorrowRoot", BooleanUtils.toBoolean(request.getParameter("isShareAndBorrowRoot")));
    }

    public static void renderSearchConditions(ModelAndView ret, DocLibManager docLibManager, Long docLibId,boolean isEdocAll) throws BusinessException {
        DocLibPO lib = docLibManager.getDocLibById(docLibId);
        List<DocMetadataDefinitionPO> searchConditions = docLibManager.getSearchConditions4DocLib(docLibId, lib.getType());
        if (Constants.EDOC_LIB_TYPE == lib.getType()) {
            for (DocMetadataDefinitionPO mdf : searchConditions) {
                if (mdf.getIsEdocElement() && mdf.getType() == Constants.EDOCENUM) {
                    parseEdocEnum(mdf);
                }
            }
        }
        setDocMetadataDefinitionNames(searchConditions, lib.getType(),isEdocAll);
        ret.addObject("searchConditions", parseNullEdocMetadateDef(searchConditions,lib.getType()));

        List<DocMetadataDefinitionPO> miscConditions = docLibManager.getMiscSearchConditions4DocLib(searchConditions);
        setDocMetadataDefinitionNames(miscConditions, lib.getType(),isEdocAll);
        ret.addObject("miscConditions", parseNullEdocMetadateDef(miscConditions,lib.getType()));
    }
    
    /**
     * 将入口参数装换为openFrom，opanFrom值对于协同类型文档的打开，有限制左右 duanyl
     */
    public static String transIntoOpenFrom(int entrance) {
        EntranceTypeEnum entranceType = EntranceTypeEnum.parseEntranceType(entrance);
        if (EntranceTypeEnum.shareOut==entranceType || EntranceTypeEnum.borrowOrShare==entranceType
                || EntranceTypeEnum.borrowOut==entranceType) {
            return "lenPotent";
        } else if (EntranceTypeEnum.edocDocLib==entranceType) {
            return "edocDocLib";
        } else if (EntranceTypeEnum.associatedDoc==entranceType) {
            return "glwd";
        } else {
            return "docLib";
        }
    }

    /**
     * 获取打开知识的链接，同时对于系统类型的知识要获取其权限
     * @param dr
     * @param entrance
     * @param docAclManager
     * @param baseDoc
     * @return
     */
    public static String getOpenKnowledgeUrl(DocResourcePO dr, int entrance, DocAclNewManager docAclNewManager,
            DocHierarchyManager docHierarchyManager, DocResourcePO baseDoc) {
        String lenPotent = null;
        String url = null;
        EntranceTypeEnum entranceType = EntranceTypeEnum.parseEntranceType(entrance);
        Long validatedDocId = dr.getId();
        DocResourcePO dr0=dr;
        if (dr.getFrType() == Constants.LINK) {
            dr = docHierarchyManager.getDocResourceById(dr.getSourceId());
        }
        if (dr.getFrType() == Constants.SYSTEM_COL || dr.getFrType() == Constants.SYSTEM_FORM  || dr.getFrType() == Constants.SYSTEM_ARCHIVES|| dr.getFrType() == Constants.SYSTEM_INFO) {
            String openFrom = transIntoOpenFrom(entrance);
            try {
                lenPotent = docAclNewManager.getCollOrEdocPotent(validatedDocId, entranceType);
                if (lenPotent.charAt(3) == '1') {
                    openFrom = "lenPotent";
                }
                if (dr.getFrType() == Constants.SYSTEM_COL || dr.getFrType() == Constants.SYSTEM_FORM) {
                    openFrom = ColOpenFrom.docLib.toString();
                }
                //收藏文档传递参数为glwd
                if(DocSourceType.favorite.key().equals(dr.getSourceType())){
                	openFrom = ColOpenFrom.glwd.toString();
                }
                
                lenPotent = lenPotent.substring(0, 3);
            } catch (BusinessException e) {
                logger.error("", e);
            }
            //修改规则：OA-73281，规则详细见bug备注
            /*if (EntranceTypeEnum.associatedDoc.equals(entranceType)) {
                lenPotent = lenPotent.substring(0, 1) + "00";
            }*/
            if (dr.getFrType() == Constants.SYSTEM_COL || dr.getFrType() == Constants.SYSTEM_FORM) {
                url = "/collaboration/collaboration.do?method=summary&affairId=" + dr.getSourceId() + "&openFrom="
                        + openFrom + "&lenPotent=" + lenPotent+"&pigeonholeType="+dr.getPigeonholeType();
            } else if(dr.getFrType() == Constants.SYSTEM_ARCHIVES) {
                url = "/edocController.do?method=edocDetailInDoc&openFrom=" + openFrom + "&summaryId="
                        + dr.getSourceId() + "&lenPotent=" + lenPotent;
            } else if (dr.getFrType() == Constants.SYSTEM_INFO) {
            	url = getInfoDetailUrl(dr, docHierarchyManager, url, lenPotent);
            }
        } else if (dr.getFrType() == Constants.SYSTEM_MEETING) {
            url = "/mtMeeting.do?method=detail&fromPigeonhole=true&id=" + dr.getSourceId();
        } else if (dr.getFrType() == Constants.SYSTEM_PLAN) {
            url = "/plan.do?method=initDetailHome&editType=doc&id=" + dr.getSourceId();
        } else if (dr.getFrType() == Constants.SYSTEM_MAIL) {
            url = "/webmail.do?method=showMail&id=" + dr.getSourceId();
        } else if (dr.getFrType() == Constants.SYSTEM_NEWS) {
            url = "/newsData.do?method=newsView&newsId=" + dr.getSourceId() + "&from=pigeonhole";
        } else if (dr.getFrType() == Constants.SYSTEM_BULLETIN) {
            url = "/bulData.do?method=bulView&bulId=" + dr.getSourceId() + "&from=pigeonhole";
        } else if (dr.getFrType() == Constants.SYSTEM_BBS) {
            url = "/bbs.do?method=bbsView&articleId=" + dr.getSourceId() + "&from=pigeonhole";
        } else if (dr.getFrType() == Constants.SYSTEM_INQUIRY) {
            url = "/inquiryData.do?method=inquiryView&inquiryId=" + dr.getSourceId() + "&from=pigeonhole";
        } else {
            if (entrance == 8) {
                String vForKnowledgeBrowse = SecurityHelper.digest(validatedDocId, entrance, "glwd");
                url = "/doc.do?method=knowledgeBrowse&docResId=" + validatedDocId + "&entranceType=" + entrance
                        + "&v=" + vForKnowledgeBrowse;
            } else {
                String vForKnowledgeBrowse = SecurityHelper.digest(validatedDocId, entrance);
                url = "/doc.do?method=knowledgeBrowse&docResId=" + validatedDocId + "&entranceType=" + entrance + "&v="
                        + vForKnowledgeBrowse;
            }
        }

        //关联文档的打开需要传入前一对象ID
        //用于权限校验传递，请勿改动
        // TODO(duanyl) 验证baseApp传递的为数字还是字符串
        if (baseDoc != null) {
            url += "&baseObjectId=" + baseDoc.getId() + "&baseApp=" + baseDoc.getFrType();
            if (Constants.isPigeonhole(baseDoc) || baseDoc.getSourceId() != null) {
                url += "&openerSummaryId=" + baseDoc.getSourceId();
            }
        }
        
        if (entrance == 8 && url.indexOf("openFrom") == -1) {
            url += "&openFrom=glwd";
        }
        
        if (dr0.getFrType() == Constants.LINK) {
            dr = dr0;
        }
        //解决归档的协同等发送到其他文件夹，权限丢失的问题
        if (url.indexOf("docResId") == -1) {
            url += "&docResId=" + dr.getId();
        }
        url += "&docId=" + dr.getId();
        
        return url;
    }

	@SuppressWarnings("unchecked")
	private static String getInfoDetailUrl(DocResourcePO dr, DocHierarchyManager docHierarchyManager, String url, String lenPotent) {
		Map<String, Object> metadataMap =  (Map<String, Object>)docHierarchyManager.getDocMetadataMap(dr.getId());
		Integer subApp = (Integer)metadataMap.get("integer2");
		if (subApp == null) {
		    url = "/info/infoDetail.do?method=summary&summaryId=&affairId=" + dr.getSourceId() + "&openFrom=Done&lenPotent="+lenPotent;
		}else{
			if(subApp==ApplicationSubCategoryEnum.info_self.key()||subApp==ApplicationSubCategoryEnum.info_tempate.key()){//信息报送
		        url = "/info/infoDetail.do?method=summary&summaryId=&affairId=" + dr.getSourceId() + "&openFrom=Done&lenPotent="+lenPotent+"&docFlag=yes";
		    }else if(subApp==ApplicationSubCategoryEnum.info_magazine.key()){//信息期刊审核
		    	url = "/info/magazine.do?method=summary&summaryId=&affairId=" + dr.getSourceId() + "&openFrom=Done&lenPotent="+lenPotent;
		    }else if(subApp==ApplicationSubCategoryEnum.info_magazine_publish.key()){//信息期刊发布
		        url = "/info/magazine.do?method=summaryPublish&summaryId=&affairId=" + dr.getSourceId() + "&openFrom=Done&lenPotent="+lenPotent;
		    }else if(subApp==ApplicationSubCategoryEnum.info_stat.key()){//期刊统计
		        url = "/info/infoStat.do?method=showInfoStatView&listType=oldStatView&statId="+dr.getSourceId();
		    }
		}
		return url;
	}
    
    /**
     * 根据文档类型获取其是否归档及如果归档，对应的打开链接地址
     * @throws BusinessException 
     */
    public static PigUrlInfo getPigUrlInfo(HttpServletRequest request, DocResourcePO dr, boolean isPersonalLibOwner,
            DocAclManager docAclManager) throws BusinessException {
        boolean pig = false;
        String url = "";
        long id = dr.getId();
        if (dr.getFrType() == Constants.SYSTEM_COL ||  dr.getFrType() ==Constants.SYSTEM_FORM|| dr.getFrType() == Constants.SYSTEM_ARCHIVES || dr.getFrType() == Constants.SYSTEM_INFO) {
            pig = true;
            String openFrom = request.getParameter("openFrom");
            String lenPotent = "";
            if ("lenPotent".equals(openFrom)) {
                openFrom = "lenPotent";
                lenPotent = docAclManager.getEdocBorrowPotent(id);
            } else if ("sysMessage".equals(openFrom)) {
                openFrom = "docLib";
                lenPotent = docAclManager.getEdocSharePotent(id);
            } else {
                lenPotent = docAclManager.getEdocSharePotent(id);
            }

            if (dr.getFrType() == Constants.SYSTEM_COL || dr.getFrType() ==Constants.SYSTEM_FORM) {
                if (isPersonalLibOwner) {
                    lenPotent = "111";
                }
                url = "/collaboration/collaboration.do?method=summary&affairId=" + dr.getSourceId() + "&openFrom="
                        + openFrom + "&lenPotent=" + lenPotent+"&pigeonholeType="+dr.getPigeonholeType();
            } else if(dr.getFrType() == Constants.SYSTEM_ARCHIVES) {
                url = "/edocController.do?method=edocDetailInDoc&openFrom=" + openFrom + "&summaryId="
                        + dr.getSourceId() + "&lenPotent=" + lenPotent;
            } else if(dr.getFrType() == Constants.SYSTEM_INFO) {
            	DocHierarchyManager docHierarchyManager = (DocHierarchyManager)AppContext.getBean("docHierarchyManager");
            	url = getInfoDetailUrl(dr, docHierarchyManager, url, lenPotent);
            }
        } else if (dr.getFrType() == Constants.SYSTEM_MEETING) {
            pig = true;
            url = "/mtMeeting.do?method=detail&fromPigeonhole=true&id=" + dr.getSourceId();
        } else if (dr.getFrType() == Constants.SYSTEM_PLAN) {
            pig = true;
            url = "/plan.do?method=initDetailHome&editType=doc&id=" + dr.getSourceId();
        } else if (dr.getFrType() == Constants.SYSTEM_MAIL) {
            pig = true;
            url = "/webmail.do?method=showMail&id=" + dr.getSourceId();
        } else if (dr.getFrType() == Constants.SYSTEM_NEWS) {
            pig = true;
            url = "/newsData.do?method=newsView&newsId=" + dr.getSourceId() + "&from=pigeonhole";
        } else if (dr.getFrType() == Constants.SYSTEM_BULLETIN) {
            pig = true;
            url = "/bulData.do?method=bulView&bulId=" + dr.getSourceId() + "&from=pigeonhole";
        } else if (dr.getFrType() == Constants.SYSTEM_BBS) {
            pig = true;
            url = "/bbs.do?method=bbsView&articleId=" + dr.getSourceId() + "&from=pigeonhole";
        } else if (dr.getFrType() == Constants.SYSTEM_INQUIRY) {
            pig = true;
            url = "/inquiryData.do?method=inquiryView&inquiryId=" + dr.getSourceId() + "&from=pigeonhole";
        }

        //关联文档的打开需要传入前一对象ID
        //用于权限校验传递，请勿改动
        if (Strings.isNotBlank(request.getParameter("baseObjectId"))) {
            url += "&openFrom=glwd&baseObjectId=" + request.getParameter("baseObjectId") + "&baseApp="
                    + request.getParameter("baseApp");
            if (Strings.isNotBlank(request.getParameter("openerSummaryId"))) {
                url += "&openerSummaryId=" + request.getParameter("openerSummaryId");
            }
        }
        //解决归档的协同等发送到其他文件夹，权限丢失的问题
        url += "&docResId=" + id + "&docId=" + id;

        return new PigUrlInfo(pig, url);
    }

    private static List<Long> FILTER_TYPES = new ArrayList<Long>();
    static {
        FILTER_TYPES.add(Constants.FOLDER_TEMPLET);
        FILTER_TYPES.add(Constants.FOLDER_SHAREOUT);
        FILTER_TYPES.add(Constants.FOLDER_BORROWOUT);
        FILTER_TYPES.add(Constants.FOLDER_BORROW);
        FILTER_TYPES.add(Constants.FOLDER_PLAN_WEEK);
        FILTER_TYPES.add(Constants.FOLDER_PLAN_MONTH);
        FILTER_TYPES.add(Constants.FOLDER_PLAN_DAY);
        FILTER_TYPES.add(Constants.FOLDER_PLAN_WORK);
        FILTER_TYPES.add(Constants.FOLDER_SHARE);
    }

    /**
     * 对数据进行过滤
     * @param needNoFilter	是否不需过滤，如果不需要过滤，则直接返回全部记录，否则进行处理
     */
    public static List<DocResourcePO> getListDocResource(List<DocResourcePO> drs, boolean needNoFilter) {
        if (drs == null || needNoFilter) {
            return drs;
        }

        List<DocResourcePO> list = new ArrayList<DocResourcePO>(drs.size());
        for (DocResourcePO docResource : drs) {
            if (!FILTER_TYPES.contains(docResource.getFrType())) {
                list.add(docResource);
            }
        }
        return list;
    }

    /**
     * 获取图片文件的显示内容
     * @param sourceId	图片源文件ID
     * @param drCreateTime	文件创建日期
     * @return	图片文件的显示内容
     */
    public static String getPicBody(Long sourceId, Date drCreateTime) {
    	String src = "/seeyon/fileUpload.do?method=showRTE&amp;fileId="+ sourceId + "&amp;createDate=" + Datetimes.formatDate(drCreateTime) + "&amp;type=image'";
        String result = " <img  border='0' alt='' width='720' class='attaListImg' showType='image' src='"+ src +"' showId='"+ src +"' showDate='"+ drCreateTime +"' style='cursor:pointer'>";
        return result;
    }

    /**
     * 根据文档获取所在文档库的管理员，如果是在项目文档库，则取项目的负责人和项目助理
     */
    public static List<Long> getLibOwners(DocResourcePO dr) {
        if (Constants.DOC_LIB_ID_PROJECT.longValue() == dr.getDocLibId()) {
            return DocMVCUtils.getProjectFolderOwners(dr.getLogicalPath());
        } else {
            DocLibManager docLibManager = (DocLibManager) AppContext.getBean("docLibManager");
            return docLibManager.getOwnersByDocLibId(dr.getDocLibId());
        }
    }

    /**
     * 项目文档库情况下，将项目负责人和项目助理作为文档库的管理员，辅助文档排序的权限判断
     * @param logicalPath	项目文档夹的逻辑路径
     * @return	项目负责人和助理的ID集合
     */
    public static List<Long> getProjectFolderOwners(String logicalPath) {
        try {
            String[] docIdsArray = StringUtils.split(logicalPath, '.');
            if (docIdsArray.length == 1)
                return null;

            String pdocId = docIdsArray[1];
            DocHierarchyManager docHierarchyManager = (DocHierarchyManager) AppContext.getBean("docHierarchyManager");

            DocResourcePO pdoc = docHierarchyManager.getDocResourceById(NumberUtils.toLong(pdocId));
            if (pdoc != null && pdoc.getSourceId() != null) {
                ProjectApi projectApi = (ProjectApi) AppContext.getBean("projectApi");
                List<ProjectMemberInfoBO> projectMembers = projectApi.findProjectMembers(pdoc.getSourceId());
                List<Long> userIds = new ArrayList<Long>();
                for (ProjectMemberInfoBO ProjectMemberInfoBO : projectMembers) {
                    if (ProjectMemberInfoBO.getMemberType() == ProjectMemberInfoBO.memberType_manager 
                            || ProjectMemberInfoBO.getMemberType() == ProjectMemberInfoBO.memberType_assistant) {
                        userIds.add(ProjectMemberInfoBO.getMemberId());
                    }
                }
                return userIds;
            }
        } catch (Exception e) {
            logger.error("项目文档授权时，通过项目文档夹[逻辑路径=" + logicalPath + "]的sourceId获得ProjectSummary异常！", e);
        }
        return null;
    }

    /**
     * 获取元数据属性信息在文档列表显示的列名称
     * @param dmdName	元数据属性名称
     */
    public static String getDisplayName4MetadataDefinition(String dmdName, Object... param) {
        return getDisplayName4MetadataDefinition2(dmdName, "doc.", param);
    }
    
    public static void handleCollect(List<? extends DocCollection> docs,List<Map<String,Long>> collectFlag){
        Map<Long,Long> doc2SourceId = new HashMap<Long,Long>();
        for (Map<String, Long> map : collectFlag) {
            doc2SourceId.put(map.get("sourceId"), map.get("id"));
            doc2SourceId.put(map.get("id"), map.get("sourceId"));
        }
        
        for (DocCollection docZoneVo : docs) {
            if(doc2SourceId.get(docZoneVo.getId())!=null){
                docZoneVo.setCollect(true);
                docZoneVo.setCollectDocId(doc2SourceId.get(docZoneVo.getId()));
            }
        }
    }

    /**
     * 获取元数据属性信息在文档列表显示的列名称
     * @param dmdName	元数据属性名称
     */
    public static String getDisplayName4MetadataDefinition2(String dmdName, String value, Object... param) {
        String aname = ResourceUtil.getString(dmdName, param);//新标准
        if (aname != null && aname.equals(dmdName)) {
            String resourceName = Constants.getResourceNameOfMetadata(dmdName, value);
            if (Strings.isNotBlank(resourceName)) {
                aname = ResourceBundleUtil.getString(resourceName, aname, param);//旧标准
            }
        }
        return aname;
    }

    /**
     * 根据文档库设置的属性显示信息确定是否需要在显示列表时抓取元数据信息，避免无谓sql发出
     * @param dmds	文档库所对应的栏目显示信息
     */
    public static boolean needFetchMetadata(List<DocMetadataDefinitionPO> dmds) {
        for (DocMetadataDefinitionPO dmd : dmds) {
            if (!dmd.getIsDefault())
                return true;
        }
        return false;
    }
    
    public static boolean needFetchEdocMetadata(List<DocMetadataDefinitionPO> dmds) {
        for (DocMetadataDefinitionPO dmd : dmds) {
            if (dmd.getIsEdocElement()) {
                return true;
            }
        }
        return false;
    }
    
    public static boolean isOfficeSupport(BrowserEnum currentBrowser) {
        return !(BrowserEnum.iPad == currentBrowser || BrowserEnum.Opera == currentBrowser);
        //return (BrowserEnum.IE.equals(currentBrowser) || BrowserEnum.IE11.equals(currentBrowser) || BrowserEnum.IE10.equals(currentBrowser) || BrowserEnum.IE9.equals(currentBrowser));
    }
    

    public static String getParameter(HttpServletRequest request, String param) {
        return request.getParameter(param) == null ? "" : request.getParameter(param);
    }
    
    
    /**
    * 处理公文扩展元素
    * 标题     :subject
                   拟文日期 : createdate
                   公文文号 :doc_mark
                   内部文号 :serial_no
                   文件密级 :secret_level
                   发文单位 :send_unit
                   拟稿人 :create_person
                   发文部门: send_department
    */
   @SuppressWarnings("unchecked")
   private static final List<String> repeatElements = Arrays.asList(new String[] { "subject", "createdate", "doc_mark", "serial_no", "secret_level", "send_unit", "create_person", "send_department" });

   public static void parseEdocMetadateDef(List<DocMetadataDefinitionPO> the_list, DocLibPO lib) {
       if (Constants.EDOC_LIB_TYPE == lib.getType()) {
            List<EdocElementBO> edocElements = new ArrayList<EdocElementBO>();
            try {
                edocElements = getEdocApi().findEdocElementsByStatus4Doc(AppContext.currentAccountId(), -1);
            } catch (BusinessException e) {
            }
            for (EdocElementBO edocElement : edocElements) {
                if (!repeatElements.contains(edocElement.getFieldName())) {
                    DocMetadataDefinitionPO dmd = new DocMetadataDefinitionPO();
                    dmd.setId(edocElement.getId());
                    dmd.setName(edocElement.getName());
                    dmd.setIsSystem(edocElement.isSystem());
                    dmd.setIsDefault(false);
                    dmd.setIsPercent(false);
                    dmd.setIsEdocElement(true);
                    dmd.setEdocElement(edocElement);
                    dmd.setDomainId(edocElement.getDomainId());
                    dmd.setStatus(Constants.DOC_METADATA_DEF_STATUS_DRAFT);
                    dmd.setEdocEnable(edocElement.getStatus() == 1);
                    the_list.add(dmd);
                }
            }
       }
   }
   /**
    * 处理公文元素定义
    * @param edocElementMap
    * @param dmd
    */
   public static void parseEdocMetadateDef(Map<Long, EdocElementBO> edocElementMap, DocMetadataDefinitionPO dmd) {
       if (edocElementMap.isEmpty()) {
            List<EdocElementBO> edocElements = new ArrayList<EdocElementBO>();
            try {
                edocElements = getEdocApi().findEdocElementsByStatus4Doc(AppContext.currentAccountId(), -1);
            } catch (BusinessException e) {
            }
            for (EdocElementBO edocElement : edocElements) {
                edocElementMap.put(edocElement.getId(), edocElement);
            }
       }
       EdocElementBO edocElement = edocElementMap.get(dmd.getId());
       if (edocElement != null) {//公文里面能找到
            if (!repeatElements.contains(edocElement.getFieldName()) && (Strings.isBlank(dmd.getName()) || dmd.getIsEdocElement())) {
               dmd.setName(edocElement.getName());
               dmd.setIsSystem(edocElement.isSystem());
               dmd.setIsDefault(false);
               dmd.setIsPercent(false);
               dmd.setIsEdocElement(true);
               dmd.setType(Constants.getEdocType2DocMetadataDefType(edocElement));
               dmd.setDomainId(edocElement.getDomainId());
               dmd.setStatus(edocElement.getStatus() == 1 ? Constants.DOC_METADATA_DEF_STATUS_DRAFT : Constants.DOC_METADATA_DEF_STATUS_DELETED);
               dmd.setPhysicalName(edocElement.getPoFieldName());
               dmd.setEdocElement(edocElement);
               dmd.setEdocEnable(edocElement.getStatus() == 1);
           }
       }
   }
   
   /**
    * 公文枚举到文档中心文档属性枚举映射
 * @throws BusinessException 
    */
   private static void parseEdocEnum(DocMetadataDefinitionPO mdf) throws BusinessException {
       List<CtpEnumItem> enumItems = getEdocApi().findEdocElementEnumItems4Doc(mdf.getId());
       Set<DocMetadataOptionPO> metadataOption = new HashSet<DocMetadataOptionPO>();
       for (CtpEnumItem item : enumItems) {
           if (item.getOutputSwitch() == com.seeyon.ctp.common.ctpenumnew.Constants.METADATAITEM_SWITCH_ENABLE) {
               DocMetadataOptionPO option = new DocMetadataOptionPO();
               option.setId(Long.valueOf(item.getValue()));
               option.setOptionItem(ResourceUtil.getString(item.getLabel()));
               metadataOption.add(option);
           }
       }
       mdf.setMetadataOption(metadataOption);
   }
   
    public static void parseSelectEdocMetadataDef(List<DocMetadataDefinitionPO> seleced,Byte docLibType) {
        if(docLibType.equals(Constants.EDOC_LIB_TYPE)){
            Map<Long, EdocElementBO> edocElementMap = new HashMap<Long, EdocElementBO>();
            for (DocMetadataDefinitionPO dmd : seleced) {
                parseEdocMetadateDef(edocElementMap, dmd);
            }
        }
    }
   
   /**
    * 删除公文和文档中心重复定义的
    */
   public static void parseRemoveEdocMetadateDef(List<DocMetadataDefinitionPO> the_list){
       List<DocMetadataDefinitionPO> removeDmp = new ArrayList<DocMetadataDefinitionPO>();
       List<Long> removeEdocIds = Arrays.asList(new Long[]{101L,104L,131L,132L,133L,136L,146L});
       for (DocMetadataDefinitionPO dmp : the_list) {
           if ((dmp.getIsSystem() && "metadataDef.category.edoc".equals(dmp.getCategory())
                   && !removeEdocIds.contains(dmp.getId()))) {
               removeDmp.add(dmp);
           }
       }
       if (!removeDmp.isEmpty()) {
           the_list.removeAll(removeDmp);
       }
   }
   
   //处理停用元素
   public static List<DocMetadataDefinitionPO> parseNullEdocMetadateDef(List<DocMetadataDefinitionPO> columns, Byte docLibType) {
       if (docLibType.equals(Constants.EDOC_LIB_TYPE)) {
           List<DocMetadataDefinitionPO> edoColumns = new ArrayList<DocMetadataDefinitionPO>();
           for (DocMetadataDefinitionPO dmd : columns) {
               if (dmd.getIsEdocElement()) {
                   if (dmd.isEdocEnable()) {
                       edoColumns.add(dmd);
                   }
               } else {
                   edoColumns.add(dmd);
               }
           }
           return edoColumns;
       }
       return columns;
   }
}
