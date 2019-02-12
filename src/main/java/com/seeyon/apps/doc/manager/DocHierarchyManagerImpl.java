package com.seeyon.apps.doc.manager;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.hibernate.type.Type;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.seeyon.apps.archive.api.ArchiveApi;
import com.seeyon.apps.archive.manager.IArchiveSync.ArchiveVO;
import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.doc.dao.DocBodyDao;
import com.seeyon.apps.doc.dao.DocDao;
import com.seeyon.apps.doc.dao.DocFromPotentDao;
import com.seeyon.apps.doc.dao.DocMetadataDao;
import com.seeyon.apps.doc.dao.DocResourceDao;
import com.seeyon.apps.doc.dao.DocResourceNewDao;
import com.seeyon.apps.doc.enums.DocActionEnum;
import com.seeyon.apps.doc.enums.EntranceTypeEnum;
import com.seeyon.apps.doc.event.DocAddEvent;
import com.seeyon.apps.doc.event.DocCancelFavoriteEvent;
import com.seeyon.apps.doc.exception.KnowledgeException;
import com.seeyon.apps.doc.po.DocAcl;
import com.seeyon.apps.doc.po.DocBodyPO;
import com.seeyon.apps.doc.po.DocLibPO;
import com.seeyon.apps.doc.po.DocMetadataDefinitionPO;
import com.seeyon.apps.doc.po.DocMetadataObjectPO;
import com.seeyon.apps.doc.po.DocMetadataOptionPO;
import com.seeyon.apps.doc.po.DocMimeTypePO;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.doc.po.DocTypeDetailPO;
import com.seeyon.apps.doc.po.DocTypePO;
import com.seeyon.apps.doc.po.DocVersionInfoPO;
import com.seeyon.apps.doc.po.Potent;
import com.seeyon.apps.doc.util.ActionType;
import com.seeyon.apps.doc.util.Constants;
import com.seeyon.apps.doc.util.Constants.DocSourceType;
import com.seeyon.apps.doc.util.Constants.LockStatus;
import com.seeyon.apps.doc.util.DocMVCUtils;
import com.seeyon.apps.doc.util.DocMgrUtils;
import com.seeyon.apps.doc.util.DocSearchHqlUtils;
import com.seeyon.apps.doc.util.DocUtils;
import com.seeyon.apps.doc.util.compress.CompressUtil;
import com.seeyon.apps.doc.vo.DocEditVO;
import com.seeyon.apps.doc.vo.DocSearchModel;
import com.seeyon.apps.doc.vo.DocSortProperty;
import com.seeyon.apps.doc.vo.DocTableVO;
import com.seeyon.apps.doc.vo.DocTreeVO;
import com.seeyon.apps.doc.vo.FolderItemDoc;
import com.seeyon.apps.doc.vo.GridVO;
import com.seeyon.apps.doc.vo.SimpleDocQueryModel;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.apps.edoc.bo.EdocSummaryBO;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.apps.plan.bo.PlanBO;
import com.seeyon.apps.project.api.ProjectApi;
import com.seeyon.apps.project.bo.ProjectBO;
import com.seeyon.apps.project.bo.ProjectMemberInfoBO;
import com.seeyon.apps.project.bo.ProjectPhaseBO;
import com.seeyon.apps.project.bo.ProjectSummaryDataBO;
import com.seeyon.apps.storage.manager.DocSpaceManager;
import com.seeyon.apps.taskmanage.util.TaskConstants;
import com.seeyon.apps.webmail.api.WebmailApi;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.HisAffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.ctp.common.dao.paginate.Pagination;
import com.seeyon.ctp.common.encrypt.CoderFactory;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.filemanager.manager.PartitionManager;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.lock.manager.LockManager;
import com.seeyon.ctp.common.lock.manager.LockState;
import com.seeyon.ctp.common.operationlog.manager.OperationlogManager;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.affair.CtpAffairHis;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.po.lock.Lock;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.login.online.OnlineRecorder;
import com.seeyon.ctp.login.online.OnlineUser;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.SQLWildcardUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.isearch.model.ConditionModel;

public class DocHierarchyManagerImpl extends BaseHibernateDao implements DocHierarchyManager {

    private static final Log         log = LogFactory.getLog(DocHierarchyManagerImpl.class);

    private static NodeList          nodes;
    private static Map<String, Node> nodesMap;
    protected DocActionManager         docActionManager;
    protected DocDao                   docDao;
    protected DocAclManager            docAclManager;
    protected DocBodyDao               docBodyDao;
    protected DocMimeTypeManager       docMimeTypeManager;
    protected DocForumManager          docForumManager;
    protected DocFromPotentDao         docFromPotentDao;
    protected DocMetadataManager       docMetadataManager;
    protected DocResourceDao           docResourceDao;
    protected DocAlertLatestManager  docAlertLatestManager;
    protected DocUtils               docUtils;
    protected FileManager            fileManager;
    protected OperationlogManager    operationlogManager;
    protected OrgManager             orgManager;
    protected PartitionManager       partitionManager;
    protected AttachmentManager      attachmentManager;
    protected DocSpaceManager        docSpaceManager;
    protected ContentTypeManager     contentTypeManager;
    protected DocFavoriteManager     docFavoriteManager;
    protected DocAlertManager        docAlertManager;
    protected DocVersionInfoManager  docVersionInfoManager;
    protected DocLearningManager     docLearningManager;
    protected DocFilingManager		 docFilingManager;
    protected DocAclNewManager       docAclNewManager;
    private AppLogManager appLogManager;
    private EnumManager                  enumManagerNew;
    private CollaborationApi 			 collaborationApi;
    private EdocApi  				 	 edocApi;
    private KnowledgeFavoriteManager     knowledgeFavoriteManager;
    private static final String BEGIN_TIME = "beginTime";
	private static final String END_TIME = "endTime";
	private static final String ORG_NAME = "Name";
	private static final String IS_DEFAULT = "IsDefault";

	/** 文档层级总数上限 */
    private int                     folderLevelLimit;
    private DocMetadataDao          docMetadataDao;

    protected IndexManager          indexManager;
    protected DocLibManager 		docLibManager;
    protected AffairManager         affairManager;
	private HisAffairManager 		hisAffairManager;
	private ProjectApi          projectApi;
	private ArchiveApi      archiveApi;
	private WebmailApi webmailApi;
	
    // 在类加载时读取归档配置文�?
    public void initPigeonhole() {
        DocumentBuilderFactory domfac = DocumentBuilderFactory.newInstance();
        InputStream is = null;
        try {
            DocumentBuilder dombuilder;
            dombuilder = domfac.newDocumentBuilder();
            String pigeonhole = Constants.getPluginPropFilePath("pigeonhole.xml");
            is = new FileInputStream(pigeonhole);
            Document doc = dombuilder.parse(new File(pigeonhole));
            Element root = doc.getDocumentElement();
            nodes = root.getChildNodes();
            nodesMap = new HashMap<String, Node>();
            for (int i = 0; i < nodes.getLength(); i++) {
                Node app = nodes.item(i);
                if (app.getNodeType() == Node.ELEMENT_NODE) {
                    nodesMap.put(app.getNodeName(), app);
                }
            }
            is.close();
            log.info("DocHierarchyManagerImpl 加载归档设置文件 pigeonhole.xml 成功?");
        } catch (ParserConfigurationException e) {
            log.error("DocHierarchyManagerImpl 加载归档设置文件 pigeonhole.xml: ", e);
        } catch (SAXException e) {
            log.error("DocHierarchyManagerImpl 加载归档设置文件 pigeonhole.xml: ", e);
        } catch (IOException e) {
            log.error("DocHierarchyManagerImpl 加载归档设置文件 pigeonhole.xml: ", e);
        } finally {
            IOUtils.closeQuietly(is);
        }
    }
    public void setDocFilingManager(DocFilingManager docFilingManager) {
		this.docFilingManager = docFilingManager;
	}
    public void setPartitionManager(PartitionManager partitionManager) {
        this.partitionManager = partitionManager;
    }

    public void setDocMetadataDao(DocMetadataDao docMetadataDao) {
        this.docMetadataDao = docMetadataDao;
    }

    public void setOperationlogManager(OperationlogManager operationlogManager) {
        this.operationlogManager = operationlogManager;
    }

    public void setDocVersionInfoManager(DocVersionInfoManager docVersionInfoManager) {
        this.docVersionInfoManager = docVersionInfoManager;
    }

    public void setDocAlertLatestManager(DocAlertLatestManager docAlertLatestManager) {
        this.docAlertLatestManager = docAlertLatestManager;
    }

    public void setDocAlertManager(DocAlertManager docAlertManager) {
        this.docAlertManager = docAlertManager;
    }

    public void setDocFavoriteManager(DocFavoriteManager docFavoriteManager) {
        this.docFavoriteManager = docFavoriteManager;
    }

    public void setDocForumManager(DocForumManager docForumManager) {
        this.docForumManager = docForumManager;
    }

    public void setContentTypeManager(ContentTypeManager contentTypeManager) {
        this.contentTypeManager = contentTypeManager;
    }
    
    public void setKnowledgeFavoriteManager(
			KnowledgeFavoriteManager knowledgeFavoriteManager) {
		this.knowledgeFavoriteManager = knowledgeFavoriteManager;
	}
    
	public ContentTypeManager getContentTypeManager() {
        return contentTypeManager;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    public void setDocSpaceManager(DocSpaceManager docSpaceManager) {
        this.docSpaceManager = docSpaceManager;
    }

    public void setDocMetadataManager(DocMetadataManager docMetadataManager) {
        this.docMetadataManager = docMetadataManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public void setDocMimeTypeManager(DocMimeTypeManager docMimeTypeManager) {
        this.docMimeTypeManager = docMimeTypeManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setDocResourceDao(DocResourceDao docResourceDao) {
        this.docResourceDao = docResourceDao;
    }

    public void setDocAclManager(DocAclManager docAclManager) {
        this.docAclManager = docAclManager;
    }

    public void setDocBodyDao(DocBodyDao docBodyDao) {
        this.docBodyDao = docBodyDao;
    }

    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }
	public void setDocAclNewManager(DocAclNewManager docAclNewManager) {
		this.docAclNewManager = docAclNewManager;
	}
	
    public void setEnumManagerNew(EnumManager enumManager) {
		this.enumManagerNew = enumManager;
	}
    
	public void setCollaborationApi(CollaborationApi collaborationApi) {
		this.collaborationApi = collaborationApi;
	}
	public void setEdocApi(EdocApi edocApi) {
		this.edocApi = edocApi;
	}
	public void setFolderLevelLimit(int folderLevelLimit) {
        if (folderLevelLimit > 20 || folderLevelLimit <= 0)
            this.folderLevelLimit = 20;
        else
            this.folderLevelLimit = folderLevelLimit;
    }

    // 连接字符串成为acl�?要的格式
    private String getAclIdsByOrgIds(String orgIds, Long userId) {
        if (Strings.isBlank(orgIds)) {
            return String.valueOf(userId);
        } else {
            return orgIds + "," + userId;
        }
    }

    // 判断某个用户对某个DocResource对象是否拥有某种权限
    private boolean hasPermission(DocResourcePO dr, Long userId, String orgIds, List<Integer> levels) {
    	//文档夹下的管理员始终有权�?
    	if(docLibManager.getPersonalLibOfUser(userId).getId().equals(dr.getDocLibId()))
    		return true;
        String aclIds = this.getAclIdsByOrgIds(orgIds, userId);
        Set<Integer> acls = docAclManager.getDocResourceAclList(dr, aclIds);
        // 判断是否没有任何权限返回
        if ((acls == null) || (levels == null)) {
            return false;
        }
        if(dr.getFrType() == Constants.FORMAT_TYPE_SYSTEM_ARCHIVES && acls.contains(Constants.NOPOTENT)) {
        	return true;
        }
        // 判断是否返回了需要的权限
        for (Integer temp : levels)
            if (acls.contains(temp)){
                return true;
            }
        return false;
    }

    private static List<Integer> ALL_EDIT_POTENT     = Arrays.asList(Constants.ALLPOTENT, Constants.EDITPOTENT);
    private static List<Integer> ALL_EDIT_ADD_POTENT = Arrays.asList(Constants.ALLPOTENT, Constants.EDITPOTENT,
                                                             Constants.ADDPOTENT);
    private static List<Integer> ALL_DOWNLOAD_POTENT = Arrays.asList(Constants.ALLPOTENT, Constants.EDITPOTENT,
                                                             Constants.ADDPOTENT, Constants.READONLYPOTENT);
    private static List<Integer> ALL_OPEN_POTENT     = Arrays.asList(Constants.ALLPOTENT, Constants.EDITPOTENT,
                                                             Constants.ADDPOTENT, Constants.READONLYPOTENT,
                                                             Constants.BROWSEPOTENT, Constants.PERSONALSHARE);

    public boolean hasEditPermission(DocResourcePO dr, Long userId, String orgIds) {
        return this.hasPermission(dr, userId, orgIds, ALL_EDIT_POTENT);
    }

    // 判断某个用户对某个文档夹是否拥有创建权限
    public boolean hasDownloadPermission(DocResourcePO dr, Long userId, String orgIds) {
        return this.hasPermission(dr, userId, orgIds, ALL_DOWNLOAD_POTENT);
    }

    public boolean hasOpenPermission(Long docId, Long userId, EntranceTypeEnum entranceType) {
        DocResourcePO dr = this.getDocResourceById(docId);
        // 如果是历史版本，只要存在，就可以打开 duanyl
        if (dr == null) {
            DocVersionInfoPO dvi = docVersionInfoManager.getDocVersion(docId);
            if (dvi == null) {
                return false;
            }
            return true;
        }
        if (dr.getFrType() == Constants.LINK) {
            // 如果sourceType�?3，则说明（这个映射文档）为收藏来的，只有列表权限，不�?定能打开
            // 如果映射文档不是收藏来的，则�?定能打开 duanyl
            if (dr.getSourceType() == null) {
                return true;
            }
            if (dr.getSourceType() != 3) {
                return true;
            }
            dr = this.getDocResourceById(dr.getSourceId());
        }

        try {
            DocAcl docAcl = docAclNewManager.getDocAclWithEntrance(dr.getId(), userId, entranceType);
            // 根据入口不同对权限进行截�?
            boolean isPersonalLibAdmin = (docLibManager.getPersonalLibOfUser(userId).getId().equals(dr.getDocLibId()));
            docAcl.cutOutDocAcl(entranceType, isPersonalLibAdmin);
            Potent docPotent = null;
            docPotent = docAcl.getMappingPotent();

            if (docPotent.isAll() || docPotent.isEdit() || docPotent.ispShare() || docPotent.isRead() || docPotent.isReadOnly()
            //公文，�?�阅能打�?
                    || (dr.getFrType() == Constants.SYSTEM_ARCHIVES && Byte.valueOf(Constants.SHARETYPE_DEPTBORROW).equals(docAcl.getSharetype()))
                    //公文，共享为列表，并在公文档库中都能打开
                    //|| (dr.getFrType() == Constants.SYSTEM_ARCHIVES && Byte.valueOf(Constants.SHARETYPE_DEPTSHARE).equals(docAcl.getSharetype()) && entranceType.equals(EntranceTypeEnum.edocDocLib))
                    ) {
                return true;
            }
            // 单独有写入权限，不能打开，若同时是自己创建的，可以打�?
            if (docPotent.isCreate() && dr.getCreateUserId() != null && dr.getCreateUserId() == AppContext.currentUserId()) {
                return true;
            }
        } catch (BusinessException e1) {
            log.error("", e1);
        }
        return false;
    }
    // 判断某个用户对某个文档夹是否拥有打开权限
    public boolean hasOpenPermission(Long docId, Long userId) {
        String orgIds = null;
        DocResourcePO dr = this.getDocResourceById(docId);
        // 如果是历史版本，只要存在，就可以打开 duanyl
        if(dr == null) {
        	DocVersionInfoPO dvi = docVersionInfoManager.getDocVersion(docId);
        	if(dvi == null) {
        		return false;
        	}
        	return true;
        }
        try {
            orgIds = StringUtils.join(orgManager.getAllUserDomainIDs(userId), ',');
        } catch (BusinessException e) {
            log.error("", e);
        }
        return hasOpenPermission(dr, userId, orgIds);
    }

    // 判断某个用户对某个文档夹是否拥有打开权限
    public boolean hasOpenPermission(DocResourcePO dr, Long userId, String orgIds) {
    	if(dr.getFrType() == Constants.LINK) {
    		// 如果sourceType�?3，则说明（这个映射文档）为收藏来的，只有列表权限，不�?定能打开
    		// 如果映射文档不是收藏来的，则�?定能打开 duanyl
    		if(dr.getSourceType() == null) {
    			return true;
    		}
    		if(dr.getSourceType() != 3) {
    			return true;
    		}
    		dr = this.getDocResourceById(dr.getSourceId());
    	}
        if( this.hasPermission(dr, userId, orgIds, ALL_OPEN_POTENT))
        	return true;
        try {
            //学习文档 有打�?权限
			if(docLearningManager.isLearnDoc(dr.getId(),userId))
				return true;
			//知识文档 有打�?权限
			if(docFavoriteManager.isFavorite(dr.getId(),userId))
				return true;
		} catch (BusinessException e) {
			log.error("",e);
		}
        return false;
    }

    /**
     *  判断某个用户对某个文档夹是否拥有创建权限
     * @param dr
     * @param userId
     * @param orgIds
     * @return
     */
    boolean hasCreatePermission(DocResourcePO dr, Long userId, String orgIds) {
        return this.hasPermission(dr, userId, orgIds, ALL_EDIT_ADD_POTENT);
    }

    /** 取得当前表中的最�? fr_order  */
    public int getMinOrder(Long parentId) {
        return this.getMaxOrMinOrder(parentId, false);
    }

    /**
     * 获取当前表中的最大或�?小fr_order
     * @param parentId
     * @param max	是否取最大（还是�?小）
     * @return	�?大或�?小排序号
     */
    private int getMaxOrMinOrder(Long parentId, boolean max) {
        if (parentId != 0) {
            String hql = "select " + (max ? "max" : "min") + "(d.frOrder) from DocResourcePO d where d.parentFrId = ?";
            Number result = (Number) this.docResourceDao.findUnique(hql, null, parentId);
            return result == null ? 0 : result.intValue();
        }
        return 0;
    }

    /** 取得当前表中的最�? fr_order  */
    public int getMaxOrder(Long parentId) {
        return this.getMaxOrMinOrder(parentId, true);
    }

    /**
     * 按照指定的排序号获得其离它最近的�?个文�?
     * @param parentId:文档夹id
     * @param order：指定的排序�?
     * @param orderType：如果是">"，则是下�?个显示的对象 �? 如果�?"<"，则是上�?个显示的对象
     * @author Fanxc
     */
    @SuppressWarnings("unchecked")
    public DocResourcePO getDocByOrderType(Long parentId, int order, String orderType) {
        DocResourcePO ret = null;
        StringBuilder buffer = new StringBuilder(
                "from DocResourcePO dr where dr.parentFrId = ? and dr.frOrder = (select ");

        if (">".equals(orderType)) {
            buffer.append(" min(d.frOrder) from DocResourcePO d where d.parentFrId = ? and d.frOrder ");
        } else if ("<".equals(orderType)) {
            buffer.append(" max(d.frOrder) from DocResourcePO d where d.parentFrId = ? and d.frOrder ");
        }
        buffer.append(orderType);
        String hql = buffer.toString() + " ? " + DocSearchHqlUtils.HQL_FR_TYPE + ")";
        List<DocResourcePO> list = docResourceDao.find(hql, 0, 1, null, parentId, parentId, order);
        if (CollectionUtils.isNotEmpty(list)) {
            ret = list.get(0);
        }
        return ret;
    }
    public boolean hasSameNameAndSameTypeDr(Long parentId, Long docId,String name, Long type) {
    	String hql = "select count(dr.id) from DocResourcePO dr where frName = ? and dr.parentFrId = ? and frType = ? and dr.id != ?";
        //sunzm hibernate兼容性修�?
        Integer count = null;
        Number number = (Number) this.docResourceDao.findUnique(hql, null, name.trim(), parentId, type,docId);
        if (null != number) {
            count = number.intValue();
        }
        return count != null && count.intValue() > 0;
    }
    // 判断在同�?父文档夹下是否存在同名�?�同格式 的节�?
    public boolean hasSameNameAndSameTypeDr(Long parentId, String name, Long type) {
        String hql = "select count(dr.id) from DocResourcePO dr where frName = ? and dr.parentFrId = ? and frType = ?";
        //sunzm hibernate兼容性修�?
        Integer count = null;
        Number number = (Number) this.docResourceDao.findUnique(hql, null, name.trim(), parentId, type);
        if (null != number) {
            count = number.intValue();
        }
        return count != null && count.intValue() > 0;
    }

    // 判断在同�?父文档夹下是否存在同名�?�同格式 的节�?
    public boolean hasSameNameAndSameTypeDr(Long parentId, String name, String type) {
    	Long frType = Constants.DOCUMENT;
    	if(Strings.isNotBlank(type) && Strings.isDigits(type)){
    		try {
				frType = Long.parseLong(type);
			} catch (Exception e) {
		    	frType = Constants.DOCUMENT;
			}
    	}
        return this.hasSameNameAndSameTypeDr(parentId, name, frType);
    }

    // 判断在同�?父文档夹下是否存在同名�?�同格式 的节�?
    public boolean hasSameName(Long parentId, String name) {
        String hql = "select count(dr.id) from DocResourcePO dr where frName = ? and dr.parentFrId = ?";
        //sunzm hibernate兼容性修�?
        Integer count = null;
        Number number = (Number) this.docResourceDao.findUnique(hql, null, name.trim(), parentId);
        if (null != number) {
            count = number.intValue();
        }
        return count != null && count.intValue() > 0;
    }

    /**
     * 判断�?个文档是否归档类�?
     * 
     * common: 直接打开类型 link,4654646: 源文件存在的链接类型，sourceId link: 链接类型，源文件不存�?
     * 2,46466565465465 归档类型，第�?个是key，第二个是sourceId
     */
    public String getTheOpenType(Long docResourceId) {
        DocResourcePO dr = docResourceDao.get(docResourceId);
        long type = dr.getFrType();
        String ret = "common";
        // 链接类型
        if (type == Constants.LINK) {
            ret = "link";
            // 归档类型的链接判�?
            DocResourcePO srcDr = docResourceDao.get(dr.getSourceId());
            if (srcDr != null) {
                type = srcDr.getFrType();
                if (type == Constants.SYSTEM_ARCHIVES) {
                    ret = ApplicationCategoryEnum.edoc.getKey() + ",";
                } else if (type == Constants.SYSTEM_BBS) {
                    ret = ApplicationCategoryEnum.bbs.getKey() + ",";
                } else if (type == Constants.SYSTEM_BULLETIN) {
                    ret = ApplicationCategoryEnum.bulletin.getKey() + ",";
                } else if (type == Constants.SYSTEM_COL) {
                    ret = ApplicationCategoryEnum.collaboration.getKey() + ",";
                } else if (type == Constants.SYSTEM_FORM) {
                    ret = ApplicationCategoryEnum.form.getKey() + ",";
                } else if (type == Constants.SYSTEM_INQUIRY) {
                    ret = ApplicationCategoryEnum.inquiry.getKey() + ",";
                } else if (type == Constants.SYSTEM_MEETING) {
                    ret = ApplicationCategoryEnum.meeting.getKey() + ",";
                } else if (type == Constants.SYSTEM_NEWS) {
                    ret = ApplicationCategoryEnum.news.getKey() + ",";
                } else if (type == Constants.SYSTEM_PLAN) {
                    ret = ApplicationCategoryEnum.plan.getKey() + ",";
                } else if (type == Constants.SYSTEM_MAIL) {
                    ret = ApplicationCategoryEnum.mail.getKey() + ",";
                } else if (type == Constants.SYSTEM_INFO) {
                    ret = ApplicationCategoryEnum.info.getKey() + ",";
                } else {
                    return ret + "," + dr.getSourceId()+","+dr.getSourceType();
                }
                dr = srcDr;
            }
        } else {
            if (type == Constants.SYSTEM_ARCHIVES) {
                ret = ApplicationCategoryEnum.edoc.getKey() + ",";
            } else if (type == Constants.SYSTEM_BBS) {
                ret = ApplicationCategoryEnum.bbs.getKey() + ",";
            } else if (type == Constants.SYSTEM_BULLETIN) {
                ret = ApplicationCategoryEnum.bulletin.getKey() + ",";
            } else if (type == Constants.SYSTEM_COL) {
                ret = ApplicationCategoryEnum.collaboration.getKey() + ",";
            } else if (type == Constants.SYSTEM_FORM) {
                ret = ApplicationCategoryEnum.form.getKey() + ",";
            } else if (type == Constants.SYSTEM_INQUIRY) {
                ret = ApplicationCategoryEnum.inquiry.getKey() + ",";
            } else if (type == Constants.SYSTEM_MEETING) {
                ret = ApplicationCategoryEnum.meeting.getKey() + ",";
            } else if (type == Constants.SYSTEM_NEWS) {
                ret = ApplicationCategoryEnum.news.getKey() + ",";
            } else if (type == Constants.SYSTEM_PLAN) {
                ret = ApplicationCategoryEnum.plan.getKey() + ",";
            } else if (type == Constants.SYSTEM_MAIL) {
                ret = ApplicationCategoryEnum.mail.getKey() + ",";
            } else if (type == Constants.SYSTEM_INFO) {
                ret = ApplicationCategoryEnum.info.getKey() + ",";
            }
        }

        if (!ret.startsWith("common"))
            ret = ret + dr.getSourceId()+","+dr.getSourceType();

        return ret;
    }

    public DocResourcePO createFolderByTypeWithoutAcl(String name, Long type, Long docLibId, Long destFolderId,
            Long userId) throws BusinessException {
        return this.createFolderByTypeWithoutAcl(name, type, docLibId, destFolderId, userId, false, true, true);
    }

    public DocResourcePO createFolderByTypeWithoutAcl(String name, Long type, Long docLibId, Long destFolderId,
            Long userId, boolean parentVersionEnabled, boolean parentCommentEnabled, boolean parentRecommendEnable)
            throws BusinessException {
        int minOrder = this.getMinOrder(destFolderId);

        DocResourcePO dr = new DocResourcePO();
        dr.setFrName(name);
        dr.setParentFrId(destFolderId);
        dr.setAccessCount(0);
        dr.setCommentCount(0);
        dr.setCommentEnabled(false);
        dr.setCreateTime(new Timestamp(new Date().getTime()));
        dr.setCreateUserId(userId);
        dr.setDocLibId(docLibId);
        dr.setIsFolder(true);
        dr.setSubfolderEnabled(true);
        dr.setFrOrder(minOrder - 1);
        dr.setFrSize(0);
        dr.setFrType(type);
        dr.setLastUpdate(new Timestamp(new Date().getTime()));
        dr.setLastUserId(userId);
        dr.setStatus(Byte.parseByte("2"));
        dr.setStatusDate(new Timestamp(new Date().getTime()));
        dr.setMimeTypeId(type);
        dr.setMimeOrder(docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getOrderNum());
        dr.setIsCheckOut(false);
        dr.setVersionEnabled(parentVersionEnabled);
        dr.setCommentEnabled(parentCommentEnabled);
        dr.setRecommendEnable(parentRecommendEnable);
        docResourceDao.saveAndGetId(dr);
        return dr;
    }

    // 创建根文档夹
    private DocResourcePO createRoot(Long docLibId, String docLibName, Long contentType, Long userId)
            throws BusinessException {
        // 判断当前库下是否已经存在根文档夹, 存在则直接返�?
        DocResourcePO existRoot = this.getRootByLibId(docLibId);
        if (existRoot != null)
            throw new BusinessException("doc_lib_init_again");
        return this.createFolderByTypeWithoutAcl(docLibName, contentType, docLibId, 0L, userId);
    }

    public void moveDocWithoutAcl(DocResourcePO dr, Long srcLibId, Long destLibId, Long destFolderId, Long userId,
            boolean destPersonal, boolean parentCommentEnabled, boolean destFolderRecommendEnable, int destFolderLevelPath) throws BusinessException {
        //  系统类型移动时不进行同名校验            
        if (dr.getFrType() > Constants.FORMAT_TYPE_SYSTEM_MAIL
                && this.hasSameNameAndSameTypeDr(destFolderId, dr.getFrName(), dr.getFrType()))
            throw new BusinessException("doc_move_dupli_name_failure_alert");

        // 删除相关的权限记�?
        docAclManager.deletePotent(dr);
        if (dr.getIsFolder()) {
            this.moveFolderWithoutAcl(dr, srcLibId, destLibId, destFolderId, userId, destPersonal, destFolderLevelPath, parentCommentEnabled, destFolderRecommendEnable);
        } else {
            this.moveLeafWithoutAcl(dr, srcLibId, destLibId, destFolderId, userId, destPersonal, parentCommentEnabled, destFolderRecommendEnable);
        }
    }

    private void moveFolderWithoutAcl(DocResourcePO dr, Long srcLibId, Long docLibId, Long destFolderId, Long userId,
            boolean destPersonal, int destFolderLevelPath,boolean parentCommentEnabled,boolean parentRecommendEnable) throws BusinessException {
        String oldParentPath = dr.getLogicalPath();
        List<DocResourcePO> drs = docResourceDao.findByLogicPathLike(oldParentPath + ".");
        int oldParentPathLength = oldParentPath.length();

        if (this.hasSameNameAndSameTypeDr(destFolderId, dr.getFrName(), dr.getFrType()))
            throw new BusinessException("doc_move_dupli_name_failure_alert");

        // 先进行文档层级控制判断，避免移动过程中抛出异常，数据出现紊乱
        for (DocResourcePO tempDr : drs) {
            if (tempDr.getIsFolder()) {
                int totalDepth = tempDr.getRelativeLevelDepth(dr.getId()) + destFolderLevelPath + 1;
                if (totalDepth > this.folderLevelLimit)
                    throw new BusinessException("doc_alert_level_too_deep");
            }
        }

        this.moveLeafWithoutAcl(dr, srcLibId, docLibId, destFolderId, userId, destPersonal,  parentCommentEnabled, parentRecommendEnable);

        long sumSize = 0L;
        Timestamp curtTime = new Timestamp(System.currentTimeMillis());
        for (DocResourcePO tempDr : drs) {
            if (tempDr.getFrType() == Constants.DOCUMENT)
                sumSize += tempDr.getFrSize();

            tempDr.setDocLibId(docLibId);
            tempDr.setLastUserId(userId);
            tempDr.setLastUpdate(curtTime);
            tempDr.setOpenSquareTime(curtTime);

            if (destPersonal) {
                tempDr.setIsCheckOut(false);
            }

            tempDr.setLogicalPath(dr.getLogicalPath() + tempDr.getLogicalPath().substring(oldParentPathLength));
            
            docResourceDao.update(tempDr);
        }

        // 修改个人文档库的空间占有情况
        if (this.isPersonalLib(srcLibId))
            docSpaceManager.subUsedSpaceSize(userId, sumSize);

        if (this.isPersonalLib(docLibId)) {
            docSpaceManager.addUsedSpaceSize(userId, sumSize);
        }
    }

    private void moveLeafWithoutAcl(DocResourcePO dr, Long srcLibId, Long destLibId, Long destFolderId, Long userId,
            boolean destPersonal, boolean parentCommentEnabled, boolean destFolderRecommendEnable) throws BusinessException {
        int minOrder = this.getMinOrder(destFolderId);
        // 修改 doc_resources 表中相关属�??
        dr.setDocLibId(destLibId);
        dr.setParentFrId(destFolderId);
        dr.setLastUserId(userId);
        dr.setLastUpdate(new Timestamp(new Date().getTime()));
        dr.setFrOrder(minOrder - 1);
        dr.setCommentEnabled(parentCommentEnabled);
        dr.setRecommendEnable(destFolderRecommendEnable);

        if (destPersonal) {
            //dr.setCommentEnabled(false);
            dr.setIsCheckOut(false);
        }

        String newParentPath = docResourceDao.get(destFolderId).getLogicalPath();
        dr.setLogicalPath(newParentPath + "." + dr.getId());
        dr.setOpenSquareTime(new Timestamp(System.currentTimeMillis()));
        docResourceDao.update(dr);

        // 修改个人文档库的空间占有情况
        if (dr.getFrType() == Constants.DOCUMENT) {
            if (this.isPersonalLib(srcLibId))
                docSpaceManager.subUsedSpaceSize(userId, dr.getFrSize());

            if (this.isPersonalLib(destLibId)) {
                docSpaceManager.addUsedSpaceSize(userId, dr.getFrSize());
            }
        }
    }

    public void removeDocWithAcl(DocResourcePO dr, Long userId, String orgIds, boolean first) throws BusinessException {
        if (!this.hasPermission(dr, userId, orgIds, ALL_EDIT_POTENT))
            throw new BusinessException("doc_deal_no_acl");

        this.removeDocWithoutAcl(dr, userId, first);
    }

    // 根据人名列表封装DocResource对象�?
    // 使用userId作为docResourceId, PERSON_SHARE等作为frType, userName作为frName
    @SuppressWarnings("unchecked")
    private List<DocResourcePO> getDrListByUserIds(Set<Long> userIds, long contentType, Long currentUserId)
            throws BusinessException {
        List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
        if (contentType == Constants.PERSON_BORROW || contentType == Constants.PERSON_SHARE) {
            String hql = "from DocResourcePO as dr where dr.createUserId =:uid and dr.frType =:ftype";
            Map<String, Object> nmap = new HashMap<String, Object>();
            nmap.put("uid", currentUserId);
            if (contentType == Constants.PERSON_BORROW)
                nmap.put("ftype", Constants.FOLDER_BORROWOUT);
            else
                nmap.put("ftype", Constants.FOLDER_SHAREOUT);
            List<DocResourcePO> docList = docResourceDao.find(hql, -1, -1, nmap);

            if (docList.size() == 1)
                ret.add(docList.get(0));
        }
        //共享文档�?,删除自己的名�?,因为有一个我共享的虚拟目�?
        userIds.remove(currentUserId);
        for (Long userId : userIds) {
            DocResourcePO dr = new DocResourcePO();
            dr.setId(userId);
            dr.setFrName(Constants.getOrgEntityName("Member", userId, false));
            dr.setFrType(contentType);

            dr.setCreateTime(new Timestamp(new Date().getTime()));
            dr.setCreateUserId(userId);
            dr.setDocLibId(0);
            dr.setIsFolder(true);
            dr.setSubfolderEnabled(false);
            dr.setFrSize(0);
            dr.setLastUpdate(new Timestamp(new Date().getTime()));
            dr.setLastUserId(userId);

            ret.add(dr);

        }
        // 单位借阅在我的�?�阅中的显示
        if (contentType == Constants.PERSON_BORROW) {
            long userId = AppContext.currentUserId();
            String orgIds = Constants.getOrgIdsOfUser(userId);
            if (docAclManager.getDeptBorrowDocsCount(this.getAclIdsByOrgIds(orgIds, userId)) > 0) {
                DocResourcePO dr = new DocResourcePO();
                dr.setId(0L);
                dr.setFrName(Constants.DEPARTMENT_BORROW_KEY);
                dr.setFrType(Constants.DEPARTMENT_BORROW);
                dr.setCreateTime(new Timestamp(new Date().getTime()));
                dr.setCreateUserId(0L);
                dr.setDocLibId(0L);
                dr.setIsFolder(true);
                dr.setSubfolderEnabled(false);
                dr.setFrSize(0);
                dr.setLastUpdate(new Timestamp(new Date().getTime()));

                ret.add(dr);
            }
        }

        return ret;
    }

    public DocResourcePO createCommonFolder(String name, Long destFolderId, Long userId, String orgIds)
            throws BusinessException {
        return this.createCommonFolderWithoutAcl(name, destFolderId, userId);
    }

    public DocResourcePO createCommonFolderWithoutAcl(String name, Long destFolderId, Long userId) throws BusinessException {
        return this.createCommonFolderWithoutAcl(name, destFolderId, userId, false, false, false);
    }

    public DocResourcePO createCommonFolderWithoutAcl(String name, Long destFolderId, Long userId,
            boolean parentVersionEnabled, boolean parentCommentEnabled, boolean parentRecommendEnable)
            throws BusinessException {
        // 判断目的文档夹是否允许创建子文档�?
        DocResourcePO destFolder = docResourceDao.get(destFolderId);
        if (!destFolder.getSubfolderEnabled())
            throw new BusinessException("doc_subfolder_disabled");

        // 判断是否存在同名同类型记�?
        if (this.hasSameNameAndSameTypeDr(destFolderId, name, Constants.FOLDER_COMMON))
            throw new BusinessException("doc_upload_dupli_name_folder_failure_alert");

        return this.createFolderByTypeWithoutAcl(name, Constants.FOLDER_COMMON, destFolder.getDocLibId(), destFolderId,
                userId, parentVersionEnabled, parentCommentEnabled, parentRecommendEnable);
    }

    public Long initPersonalLib(Long docLibId, String docLibName, Long userId) throws BusinessException {
        DocResourcePO root = this.createRoot(docLibId, Constants.FOLDER_MINE_KEY, Constants.FOLDER_MINE, userId);
        Long rootId = root.getId();
        // 创建必要的文档夹
        DocResourcePO borrow = this.createFolderByTypeWithoutAcl(Constants.FOLDER_BORROW_KEY, Constants.FOLDER_BORROW,
                docLibId, rootId, userId);
        this.createFolderByTypeWithoutAcl(Constants.FOLDER_BORROWOUT_KEY, Constants.FOLDER_BORROWOUT, docLibId,
                borrow.getId(), userId);
        DocResourcePO share = this.createFolderByTypeWithoutAcl(Constants.FOLDER_SHARE_KEY, Constants.FOLDER_SHARE,
                docLibId, rootId, userId);
        this.createFolderByTypeWithoutAcl(Constants.FOLDER_SHAREOUT_KEY, Constants.FOLDER_SHAREOUT, docLibId,
                share.getId(), userId);
        return rootId;
    }

    public Long initCorpLib(Long docLibId, String docLibName, Long userId) throws BusinessException {
        Long rootId = this.createRoot(docLibId, Constants.FOLDER_CORP_KEY, Constants.FOLDER_CORP, userId).getId();
        return rootId;
    }

    public Long initCaseLib(Long docLibId, String docLibName, Long userId) throws BusinessException {
        Long rootId = this.createRoot(docLibId, Constants.FOLDER_PROJECT_ROOT_KEY, Constants.FOLDER_PROJECT_ROOT,
                userId).getId();
        return rootId;
    }

    public Long initArcsLib(Long docLibId, String docLibName, Long userId) throws BusinessException {
        Long rootId = this.createRoot(docLibId, Constants.ROOT_ARC_KEY, Constants.ROOT_ARC, userId).getId();

        // 07.08.31 增加�?个公文预归档文档�?
        this.createFolderByTypeWithoutAcl(Constants.FOLDER_ARC_PRE_KEY, Constants.FOLDER_ARC_PRE, docLibId, rootId,
                userId);

        return rootId;
    }

    public Long initCustomLib(Long docLibId, String docLibName, Long userId) throws BusinessException {
        Long rootId = this.createRoot(docLibId, docLibName, Constants.FOLDER_COMMON, userId).getId();
        return rootId;
    }

    public Long uploadFile(V3XFile file, Long docLibId, byte docLibType, Long destFolderId, Long userId, String orgIds,
            boolean parentCommentEnabled, boolean parentVersionEnabled, boolean parentRecommendEnable)
            throws BusinessException {
        if (!this.hasCreatePermission(docResourceDao.get(destFolderId), userId, orgIds))
            throw new BusinessException("doc_link_create_doclink_alert");

        return this.uploadFileWithoutAcl(file, docLibId, docLibType, destFolderId, userId, parentCommentEnabled,
                parentVersionEnabled, parentRecommendEnable).getId();
    }

    public DocResourcePO uploadFileWithoutAcl(V3XFile file, Long docLibId, byte docLibType, Long destFolderId,
            Long userId, boolean parentCommentEnabled, boolean parentVersionEnabled, DocResourcePO dr,
            boolean parentRecommendEnable, boolean checkSame) throws BusinessException {
        // 个人文档库增加使用空�?
        if (docLibType == Constants.PERSONAL_LIB_TYPE.byteValue()) {
            docSpaceManager.addUsedSpaceSize(userId, file.getSize());
        }

        if (checkSame) {
            // 判断是否存在同名文档
            if (this.hasSameNameAndSameTypeDr(destFolderId, file.getFilename(), Constants.DOCUMENT))
                throw new BusinessException("doc.upload.dupli.name.failure.alert");
        }

        int minOrder = this.getMinOrder(destFolderId);
        Timestamp time = new Timestamp(new Date().getTime());
        String name = file.getFilename();
        dr.setFrName(name);
        dr.setFrSize(file.getSize());
        dr.setParentFrId(destFolderId);
        dr.setAccessCount(0);
        dr.setCommentCount(0);
        dr.setCommentEnabled(parentCommentEnabled);
        dr.setVersionEnabled(parentVersionEnabled);
        dr.setRecommendEnable(parentRecommendEnable);
        dr.setCreateTime(time);
        dr.setCreateUserId(userId);
        dr.setDocLibId(docLibId);
        dr.setIsFolder(false);
        dr.setFrOrder(minOrder - 1);
        dr.setFrType(Constants.DOCUMENT);
        dr.setLastUpdate(time);
        dr.setLastUserId(userId);
        dr.setSourceId(file.getId());
        dr.setStatus(Byte.parseByte("2"));
        dr.setStatusDate(time);
        dr.setIsCheckOut(false);
        // 从文件管理组件得到文件类型后�?
        String postfix = name.substring(name.lastIndexOf(".") + 1, name.length());
        dr.setMimeTypeId(docMimeTypeManager.getDocMimeTypeByFilePostix(postfix));
        dr.setMimeOrder(docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getOrderNum());
        docResourceDao.saveAndGetId(dr);
        
        //触发新建事件-上传
        DocAddEvent docAddEvent = new DocAddEvent(this);
        docAddEvent.setCreateType(DocAddEvent.CREATETYPE_UPLOAD);
        docAddEvent.setDocResourceBO(DocMgrUtils.docResourcePOToBO(dr));
        EventDispatcher.fireEvent(docAddEvent);
        return dr;
    }

    public DocResourcePO uploadFileWithoutAcl(V3XFile file, Long docLibId, byte docLibType, Long destFolderId,
            Long userId, boolean parentCommentEnabled, boolean parentVersionEnabled, boolean parentRecommendEnable)
            throws BusinessException {
        DocResourcePO dr = new DocResourcePO();
        return uploadFileWithoutAcl(file, docLibId, docLibType, destFolderId, userId, parentCommentEnabled,
        		parentVersionEnabled, dr, parentRecommendEnable, true);
    }

    /**
     * 创建复合文档
     */
    public DocResourcePO createDoc(String name, DocBodyPO docBody, Long docLibId, Long destFolderId, Long userId,
            String orgIds, boolean parentCommentEnabled, boolean parentVersionEnabled, boolean parentRecommendEnable,
            long contentTypeId, Map<String, Comparable> metadatas) throws BusinessException {
        if (!this.hasCreatePermission(docResourceDao.get(destFolderId), userId, orgIds)) {
            throw new BusinessException("doc_deal_no_acl");
        }

        return this.createDocWithoutAcl(name, docBody, docLibId, destFolderId, userId, parentCommentEnabled,
                parentVersionEnabled, parentRecommendEnable, contentTypeId, metadatas);
    }

    public DocResourcePO createDocWithoutAcl(String name, DocBodyPO docBody, Long docLibId, Long destFolderId,
            Long userId, boolean parentCommentEnabled, boolean parentVersionEnabled, boolean parentRecommendEnable,
            long contentTypeId, Map<String, Comparable> metadatas) throws BusinessException {
        return createDocWithoutAcl(name, "", "", docBody, docLibId, destFolderId, userId, parentCommentEnabled,
                parentVersionEnabled, parentRecommendEnable, contentTypeId, metadatas);
    }
    /**
     * 新加方法，新建文档，不�?�虑权限
     * @param docId
     * @param mimeId
     * @param name
     * @param description
     * @param keyword
     * @param docLibId
     * @param destFolderId
     * @param userId
     * @param parentCommentEnabled
     * @param parentVersionEnabled
     * @param parentRecommendEnable
     * @param contentTypeId
     * @param metadatas
     * @return
     */
    public DocResourcePO createDocWithoutAcl(Long docId,Long mimeTypeId,String name, String description, String keyword,
            Long docLibId, Long destFolderId, Long userId, boolean parentCommentEnabled, boolean parentVersionEnabled,
            boolean parentRecommendEnable, long contentTypeId, Map<String, Comparable> metadatas) {
        int minOrder = this.getMinOrder(destFolderId);
        Timestamp now = new Timestamp(new Date().getTime());
        DocResourcePO dr = new DocResourcePO();
        dr.setId(docId);
        dr.setMimeTypeId(mimeTypeId);
        dr.setFrName(name);
        dr.setFrDesc(description);
        dr.setKeyWords(keyword);
        dr.setParentFrId(destFolderId);
        dr.setAccessCount(0);
        dr.setCommentCount(0);
        dr.setCommentEnabled(parentCommentEnabled);
        dr.setVersionEnabled(parentVersionEnabled);
        dr.setRecommendEnable(parentRecommendEnable);
        dr.setCreateTime(now);
        dr.setCreateUserId(userId);
        dr.setDocLibId(docLibId);
        dr.setIsFolder(false);
        dr.setFrOrder(minOrder - 1);
        dr.setFrSize(0);
        dr.setFrType(contentTypeId);
        dr.setLastUpdate(now);
        dr.setLastUserId(userId);
        dr.setStatus(Byte.parseByte("2"));
        dr.setStatusDate(now);
        dr.setMimeOrder(docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getOrderNum());
        dr.setIsCheckOut(false);
        docResourceDao.saveAndGetId(dr);
        if ((metadatas != null) && (metadatas.size() > 0))
            docMetadataManager.addMetadata(docId, metadatas);
        
        //保存应用日志
        appLogManager.insertLog(AppContext.getCurrentUser(),AppLogAction.Doc_Wd_New,AppContext.currentUserName(),dr.getFrName());
        
		// 记录操作日志
        operationlogManager.insertOplog(dr.getId(), dr.getParentFrId(), ApplicationCategoryEnum.doc, ActionType.LOG_DOC_ADD_DOCUMENT, ActionType.LOG_DOC_ADD_DOCUMENT + ".desc",
                AppContext.currentUserName(), dr.getFrName());

        //触发新建事件-新建
        DocAddEvent docAddEvent = new DocAddEvent(this);
        docAddEvent.setCreateType(DocAddEvent.CREATETYPE_NEW);
        docAddEvent.setDocResourceBO(DocMgrUtils.docResourcePOToBO(dr));
        EventDispatcher.fireEvent(docAddEvent);
        return dr;
    }
    /**
     * 创建复合文档，不考虑权限
     */
    public DocResourcePO createDocWithoutAcl(String name, String description, String keyword, DocBodyPO docBody,
            Long docLibId, Long destFolderId, Long userId, boolean parentCommentEnabled, boolean parentVersionEnabled,
            boolean parentRecommendEnable, long contentTypeId, Map<String, Comparable> metadatas) {
        long mimeId = Constants.FORMAT_TYPE_DOC_A6;
        String bodyType = docBody.getBodyType();
        if (bodyType.equals(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_WORD))
            mimeId = Constants.FORMAT_TYPE_DOC_WORD;
        else if (bodyType.equals(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_EXCEL))
            mimeId = Constants.FORMAT_TYPE_DOC_EXCEL;
        else if (bodyType.equals(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_WPS_WORD))
            mimeId = Constants.FORMAT_TYPE_DOC_WORD_WPS;
        else if (bodyType.equals(com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_WPS_EXCEL))
            mimeId = Constants.FORMAT_TYPE_DOC_EXCEL_WPS;

        int minOrder = this.getMinOrder(destFolderId);
        Timestamp now = new Timestamp(new Date().getTime());

        DocResourcePO dr = new DocResourcePO();
        dr.setFrName(name);
        dr.setFrDesc(description);
        dr.setKeyWords(keyword);
        dr.setParentFrId(destFolderId);
        dr.setAccessCount(0);
        dr.setCommentCount(0);
        dr.setCommentEnabled(parentCommentEnabled);
        dr.setVersionEnabled(parentVersionEnabled);
        dr.setRecommendEnable(parentRecommendEnable);
        dr.setCreateTime(now);
        dr.setCreateUserId(userId);
        dr.setDocLibId(docLibId);
        dr.setIsFolder(false);
        dr.setFrOrder(minOrder - 1);
        dr.setFrSize(0);
        dr.setFrType(contentTypeId);
        dr.setLastUpdate(now);
        dr.setLastUserId(userId);
        dr.setStatus(Byte.parseByte("2"));
        dr.setStatusDate(now);
        dr.setMimeTypeId(mimeId);
        dr.setMimeOrder(docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getOrderNum());
        dr.setIsCheckOut(false);
        Long newId = docResourceDao.saveAndGetId(dr);
        this.saveBody(newId, docBody);

        // 记录操作日志
        operationlogManager.insertOplog(dr.getId(), dr.getParentFrId(), ApplicationCategoryEnum.doc, ActionType.LOG_DOC_ADD_DOCUMENT, ActionType.LOG_DOC_ADD_DOCUMENT + ".desc",
                AppContext.currentUserName(), dr.getFrName());

        if ((metadatas != null) && (metadatas.size() > 0))
            docMetadataManager.addMetadata(newId, metadatas);

        //触发新建事件-新建
        DocAddEvent docAddEvent = new DocAddEvent(this);
        docAddEvent.setCreateType(DocAddEvent.CREATETYPE_NEW);
        docAddEvent.setDocResourceBO(DocMgrUtils.docResourcePOToBO(dr));
        EventDispatcher.fireEvent(docAddEvent);
        return dr;
    }

    /** *******************************归档�?�?************************************** */

    // 返回归档配置文件�? NodeList
    static Map<String, Node> getNodesMap() {
        return nodesMap;
    }

    /** *******************************归档结束************************************** */

    /**
     * 创建链接
     */
    public DocResourcePO createLink(Long sourceId, Long docLibId, Long destFolderId, Long userId, String orgIds)
            throws BusinessException {
        if (!this.hasCreatePermission(docResourceDao.get(destFolderId), userId, orgIds))
            throw new BusinessException("DocLang.doc_link_create_doclink_alert");
        return this.createLinkWithoutAcl(sourceId, docLibId, destFolderId, userId, "", "");
    }

    /**
     * 批量创建链接,包括文档、文档夹
     */
    public List<Long> createLinks(List<Long> sourceIds, Long docLibId, Long destFolderId, Long userId, String orgIds)
            throws BusinessException {
        if (!this.hasCreatePermission(docResourceDao.get(destFolderId), userId, orgIds))
            throw new BusinessException("DocLang.doc_link_create_doclink_alert");

        return this.createLinksWithoutAcl(sourceIds, docLibId, destFolderId, userId);
    }

    /**
     * 批量创建链接,包括文档、文档夹，不考虑权限
     */
    public List<Long> createLinksWithoutAcl(List<Long> sourceIds, Long docLibId, Long destFolderId, Long userId)
            throws BusinessException {
        // 判断目的文档夹是否允许创建子文档�?
        DocResourcePO destFolder = docResourceDao.get(destFolderId);
        if (!destFolder.getSubfolderEnabled())
            throw new BusinessException("DocLang.doc_link_create_folder");

        List<Long> ret = new ArrayList<Long>();

        // 判断是否存在同名文档链接
        for (Long sourceId : sourceIds) {
            DocResourcePO sourceDr = docResourceDao.get(sourceId);
            if (this.hasSameNameAndSameTypeDr(destFolderId, sourceDr.getFrName(), Constants.LINK))
                continue;
            DocResourcePO dr = this.createLinkOnly(sourceDr, destFolderId, docLibId, userId, "", "");
            if (dr != null)
                ret.add(dr.getId());
        }

        return ret;
    }

    /**
     * 创建链接，不考虑权限
     */
    public DocResourcePO createLinkWithoutAcl(Long sourceId, Long docLibId, Long destFolderId, Long userId,
            String keyWord, String sourceType) throws BusinessException {
        // 判断是否存在同名文档链接
        DocResourcePO sourceDr = docResourceDao.get(sourceId);
        if (this.hasSameNameAndSameTypeDr(destFolderId, sourceDr.getFrName(),
                (sourceDr.getIsFolder() ? Constants.LINK_FOLDER : Constants.LINK)))
            throw new BusinessException("DocLang.doc_link_create_same_name");

        return this.createLinkOnly(sourceDr, destFolderId, docLibId, userId, keyWord, sourceType);
    }

    // 创建链接，没有任何判�?
    private DocResourcePO createLinkOnly(DocResourcePO sourceDr, Long destFolderId, Long docLibId, Long userId,
            String keyWord, String sourceType) {
        int minOrder = this.getMinOrder(destFolderId);
        Long type = sourceDr.getIsFolder() ? Constants.LINK_FOLDER : Constants.LINK;
        DocResourcePO docResource = new DocResourcePO();
        docResource.setAccessCount(sourceDr.getAccessCount());
        docResource.setCommentCount(sourceDr.getCommentCount());
        docResource.setCommentEnabled(sourceDr.getCommentEnabled());
        docResource.setFrName(sourceDr.getFrName());
        docResource.setFrOrder(minOrder - 1);
        docResource.setFrSize(sourceDr.getFrSize());
        docResource.setIsFolder(false);
        docResource.setStatus(sourceDr.getStatus());
        docResource.setStatusDate(sourceDr.getStatusDate());
        docResource.setSubfolderEnabled(false);
        docResource.setDocLibId(docLibId);
        docResource.setFrType(type);
        docResource.setSourceId(sourceDr.getId());
        docResource.setParentFrId(destFolderId);
        docResource.setCreateUserId(userId);
        docResource.setCreateTime(new Timestamp(new Date().getTime()));
        docResource.setLastUserId(userId);
        docResource.setLastUpdate(new Timestamp(new Date().getTime()));
        docResource.setMimeTypeId(type);
        docResource.setMimeOrder(docMimeTypeManager.getDocMimeTypeById(docResource.getMimeTypeId()).getOrderNum());
        docResource.setKeyWords(keyWord);
        docResource.setIsCheckOut(false);

        if ("favorite".equals(sourceType)) {
            docResource.setFavoriteSource(sourceDr.getId());
            docResource.setSourceType(3);
            //文档收藏：创建人�?  源文档创建人  内容类型�? 映射
            docResource.setCreateUserId(sourceDr.getCreateUserId());
            docResource.setLastUserId(sourceDr.getCreateUserId());
            sourceDr.setCollectCount(sourceDr.getCollectCount() + 1);
            docResourceDao.update(sourceDr);
        }
        docResourceDao.saveAndGetId(docResource);
        return docResource;
    }

    public void updateDocResource(Long docResourceId, Map<String, Object> properties) {
        if (properties != null && !properties.isEmpty()) {
            docResourceDao.update(docResourceId, properties);
        }
    }

    public DocResourcePO replaceDoc(DocResourcePO dr, V3XFile file, Long userId, String orgIds, boolean remainOld)
            throws BusinessException {
        if (this.hasEditPermission(dr, userId, orgIds)) {
            return this.replaceDocWithoutAcl(dr, file, userId, remainOld);
        } else {
            throw new BusinessException("doc_deal_no_acl");
        }
    }

    public DocResourcePO replaceDocWithoutAcl(DocResourcePO dr, V3XFile file, Long userId, boolean remainOld)
            throws BusinessException {
        Long docResourceId = dr.getId();
        boolean old_isImage = dr.isImage();
        boolean old_isPdf = dr.isPDF();
        boolean old_hasDocBody = old_isImage || old_isPdf;
        Timestamp now = new Timestamp(new Date().getTime());
        try {
            // 删除附件、关联文�?
            attachmentManager.deleteByReference(docResourceId);
            if (!remainOld) {
            	Long sourceId = dr.getSourceId();
            	if(sourceId == null || Long.valueOf(0).equals(sourceId)) {
            		sourceId = docResourceId;
            	}
                fileManager.deleteFile(sourceId, true);
            }
        } catch (BusinessException e) {
            log.error("替换文件时�?�，删除原来的附件�?�关联文档或源文件时出现异常�?", e);
        }
        String name = file.getFilename();
        if (!name.equals(dr.getFrName())) {
            updateLinkName(docResourceId, name);
        }
        dr.setFrName(name);
        dr.setAccessCount(0);
        dr.setCommentEnabled(true);
        dr.setHasAttachments(false);
        dr.setIsFolder(false);
        dr.setLastUpdate(now);
        dr.setLastUserId(userId);
        dr.setSourceId(file.getId());
        dr.setIsCheckOut(false);
        dr.setCheckOutUserId(null);
        // 从文件管理组件得到文件类型后�?
        String postfix = name.substring(name.lastIndexOf(".") + 1, name.length());
        dr.setMimeTypeId(docMimeTypeManager.getDocMimeTypeByFilePostix(postfix));
        dr.setMimeOrder(docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getOrderNum());

        docResourceDao.update(dr);
        this.getHibernateTemplate().flush();

        boolean new_isImage = dr.isImage();
        boolean new_isPdf = dr.isPDF();
        boolean new_hasDocBody = new_isImage || new_isPdf;

        String formatType = new_isImage ? com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML
                : com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_PDF;

        if (old_hasDocBody && new_hasDocBody) {
            this.docBodyDao.update(
                    docResourceId,
                    CommonTools.newHashMap(new String[] { "createDate", "content", "bodyType" }, new Object[] { now,
                            file.getId().toString(), formatType }));
        } else if (old_hasDocBody && !new_hasDocBody) {
            this.docBodyDao.delete(docResourceId);
        } else if (!old_hasDocBody && new_hasDocBody) {
            DocBodyPO db = new DocBodyPO();
            db.setCreateDate(now);
            db.setContent(file.getId().toString());
            db.setBodyType(formatType);
            this.saveBody(docResourceId, db);
        }

        this.updateFileSize(docResourceId);
        return dr;
    }

    public DocResourcePO replaceDocWithoutAcl(Long docResourceId, V3XFile file, Long userId, boolean remainOld)
            throws BusinessException {
        DocResourcePO dr = this.getDocResourceById(docResourceId);
        return this.replaceDocWithoutAcl(dr, file, userId, remainOld);
    }

    public void checkOutDocResource(Long docResourceId, Long userId) {
        Date now = new Date(System.currentTimeMillis());
        this.docResourceDao.update(
                docResourceId,
                CommonTools.newHashMap(new String[] { "isCheckOut", "checkOutTime", "checkOutUserId", "lastUpdate",
                        "lastUserId" }, new Object[] { true, now, userId, now, userId }));
    }

    /**
     * 签入文档
     */
    public void checkInDocResource(Long docResourceId, Long userId, String orgIds) throws BusinessException {
        DocResourcePO dr = docResourceDao.get(docResourceId);
        // 判断当前用户对目标文档夹是否具有签入权限
        List<Integer> levels = Arrays.asList(Constants.ALLPOTENT);
        if (!this.hasPermission(dr, userId, orgIds, levels))
            throw new BusinessException("doc_deal_no_acl");

        this.checkInDocResourceWithoutAcl(docResourceId, userId);
    }

    /**
     * 签入文档,不�?�虑权限
     */
    public void checkInDocResourceWithoutAcl(Long docResourceId, Long userId) {
        this.docResourceDao.update(
                docResourceId,
                CommonTools.newHashMap(new String[] { "isCheckOut", "lastUpdate", "lastUserId" }, new Object[] { false,
                        new Date(System.currentTimeMillis()), userId }));
    }

    public void checkInDocResourcesWithoutAcl(List<Long> drIds, Long userId) throws BusinessException {
        String hql = "update " + DocResourcePO.class.getCanonicalName()
                + " set isCheckOut=false, lastUpdate=?, lastUserId=? where id in (:ids)";
        this.docResourceDao.bulkUpdate(hql, CommonTools.newHashMap("ids", drIds), new Date(System.currentTimeMillis()),
                userId);
    }

    /**
     * 修改复合文档
     */
    public void updateDoc(FolderItemDoc doc, Long userId, String orgIds) throws BusinessException {
        if (this.hasEditPermission(doc.getDocResource(), userId, orgIds))
            this.updateDocWithoutAcl(doc, userId);
        else
            throw new BusinessException("doc_deal_no_acl");
    }

    /**
     * 修改复合文档, 不�?�虑权限
     */
    public DocResourcePO updateDocWithoutAcl(FolderItemDoc doc, Long userId) throws BusinessException {
        DocResourcePO dr = doc.getDocResource();
        String body = doc.getBody();
        if (!doc.getName().equals(dr.getFrName())) {
            updateLinkName(dr.getId(), doc.getName());
        }
        dr.setFrName(doc.getName());
        dr.setLastUpdate(new Timestamp(new Date().getTime()));
        dr.setLastUserId(userId);
        dr.setFrType(doc.getContentTypeId());
        dr.setFrDesc(doc.getDesc());
        dr.setKeyWords(doc.getKeywords());
        dr.setVersionComment(doc.getVersionComment());

        // 修改签出标记
        dr.setCheckOutTime(null);
        dr.setCheckOutUserId(null);
        dr.setIsCheckOut(false);
        dr.setHasAttachments(doc.getHasAtt());

        docResourceDao.update(dr);

        List<Attachment> atts = attachmentManager.getByReference(dr.getId());
        DocBodyPO docBody = new DocBodyPO();
        docBody.setContent(body);
        this.updateDocSize(dr.getId(), docBody, atts);
        return dr;
    }

    /**
     * 更改复合文档的大�?
     */
    public void updateDocSize(Long docResourceId, DocBodyPO docBody, List<Attachment> atts) throws BusinessException {
        DocResourcePO dr = docResourceDao.get(docResourceId);
        long oldSize = dr.getFrSize();
        long size = 0L;
        long formatType = docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getFormatType();
        if (formatType == Constants.FORMAT_TYPE_DOC_A6) {
        	if(docBody.getContent() != null) {
        		size = docBody.getContent().getBytes().length;
        	}
        } else {
            V3XFile file;
            try {
                file = fileManager.getV3XFile(Long.valueOf(docBody.getContent()));
                if (file != null)
                    size = file.getSize();
            } catch (NumberFormatException e) {
                log.error("从fileManager取得在线编辑的V3xFile", e);
            } catch (BusinessException e) {
                log.error("从fileManager取得在线编辑的V3xFile", e);
            }
        }
        for (Attachment att : atts) {
            if (att.getFileUrl() != null) {
                size += att.getSize();
            }
        }
        dr.setFrSize(size);
        dr.setHasAttachments(CollectionUtils.isNotEmpty(atts));

        docResourceDao.update(dr);

        // 更改个人文档库的占用空间
        if (this.isPersonalLib(dr.getDocLibId())) {
            docSpaceManager.addUsedSpaceSize(AppContext.currentUserId(), dr.getFrSize() - oldSize);
        }
    }

    public void updateDocAttFlag(Long docResourceId, boolean attaFlag) throws BusinessException {
        DocResourcePO dr = docResourceDao.get(docResourceId);
        dr.setHasAttachments(attaFlag);
        docResourceDao.update(dr);
    }

    private void updateFileSize(DocResourcePO dr) throws BusinessException {
        long oldSize = dr.getFrSize();
        V3XFile file;
        long size = 0L;
        try {
            file = fileManager.getV3XFile(dr.getSourceId());
            if (file != null)
                size = file.getSize();
        } catch (BusinessException e) {
            log.error("从fileManager取得在线编辑的V3xFile", e);
        }
        dr.setFrSize(size);

        docResourceDao.update(dr);

        // 更改个人文档库的占用空间
        if (this.isPersonalLib(dr.getDocLibId())) {
            docSpaceManager.addUsedSpaceSize(AppContext.currentUserId(), dr.getFrSize() - oldSize);
        }
    }

    /**
     * 更改上传文件的大�?
     */
    public void updateFileSize(Long docResourceId) throws BusinessException {
        DocResourcePO dr = docResourceDao.get(docResourceId);
        if (dr != null)
            this.updateFileSize(dr);
    }

    /**
     * 判断给定的libId对应的库是否个人文档�?
     */
    public boolean isPersonalLib(Long libId) {
        if (libId == null||libId.equals(0L))
            return false;

        DocLibPO lib = this.docUtils.getDocLibById(libId);
        return lib.getType() == Constants.PERSONAL_LIB_TYPE.byteValue();
    }

    /**
     * 判断用户是否库的管理�?
     */
    public boolean isOwnerOfLib(Long libId, Long userId) {
        return this.docUtils.isOwnerOfLib(userId, libId);
    }

    /**
     * 保存复合文档的正�?
     */
    public void saveBody(Long docResourceId, DocBodyPO docBody) {
        // 保存正文到到 doc_body �?
        docBody.setDocResourceId(docResourceId);
        docBodyDao.save(docBody);
    }

    public void updateBody(Long docResourceId, String content) {
        String hql = "update " + DocBodyPO.class.getCanonicalName() + " set content=? where docResourceId=?";
        docBodyDao.bulkUpdate(hql, null, content, docResourceId);
    }

    /**
     * 删除复合文档的正�?
     */
    public void removeBody(Long docResourceId) {
        docBodyDao.delete(docResourceId.longValue());
    }

    /**
     * 查找复合文档的正�?
     */
    public DocBodyPO getBody(Long docResourceId) {
        return docBodyDao.get(docResourceId);
    }

    public DocResourcePO updateFileWithoutAcl(DocEditVO vo, byte docLibType, boolean remainOldFile) throws BusinessException {
        DocResourcePO dr = vo.getDocResource();
        long userId = AppContext.currentUserId();
        // 替换
        V3XFile file = vo.getFile();
        if (file != null) {
            // 如需保留历史版本，则保留源文�?
            if (!remainOldFile) {
                try {
                    fileManager.deleteFile(dr.getSourceId(), true);
                } catch (BusinessException e) {
                    log.error("从fileManager删除在线编辑的V3xFile", e);
                }
            }

            dr.setSourceId(file.getId());
            // 从文件管理组件得到文件类型后�?
            String name = file.getFilename();
            String postfix = name.substring(name.lastIndexOf(".") + 1, name.length());
            dr.setMimeTypeId(docMimeTypeManager.getDocMimeTypeByFilePostix(postfix));
            dr.setMimeOrder(docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getOrderNum());
        }

        if (!vo.getName().equals(dr.getFrName())) {
            updateLinkName(dr.getId(), vo.getName());
        }
        dr.setFrName(vo.getName());
        dr.setFrType(vo.getContentTypeId());
        dr.setFrDesc(vo.getDesc());
        dr.setKeyWords(vo.getKeywords());
        dr.setVersionComment(vo.getVersionComment());

        dr.setLastUpdate(new Timestamp(new Date().getTime()));
        dr.setLastUserId(userId);

        // 修改签出标记
        dr.setCheckOutTime(null);
        dr.setCheckOutUserId(null);
        dr.setIsCheckOut(false);

        docResourceDao.update(dr);
        this.updateFileSize(dr);
        return dr;
    }

    public DocResourcePO updateFileWithoutAcl(DocEditVO vo, byte docLibType) throws BusinessException {
        return this.updateFileWithoutAcl(vo, docLibType, false);
    }

    public synchronized void accessOneTime(Long docResourceId, boolean learning, boolean isRecordAccessCount) {
		DocResourcePO doc = docResourceDao.get(docResourceId);
		doc.setAccessCount(doc.getAccessCount() + 1);
		this.docResourceDao.update(doc);

        if (learning) {
            docLearningManager.learnTheDoc(docResourceId);
        }

		// 记录动作
		try {
			docActionManager.insertDocAction(AppContext.currentUserId(),
					AppContext.currentAccountId(), new Date(),
					DocActionEnum.read.key(), docResourceId, "read",
					isRecordAccessCount);
		} catch (KnowledgeException e) {
			log.error("", e);
		}
    }

	public synchronized void accessOneTime(Long docResourceId) {
		DocResourcePO dr = docResourceDao.get(docResourceId);
		Long userId = AppContext.currentUserId();
		if (dr != null) {
			this.accessOneTime(docResourceId, dr.getIsLearningDoc(), !userId
					.equals(dr.getCreateUserId()));
			try {
				docActionManager.insertDocAction(userId, AppContext
						.currentAccountId(), new Date(), DocActionEnum.read
						.key(), dr.getId(), "read", !userId.equals(dr
						.getCreateUserId()));
			} catch (KnowledgeException e) {
				log.error("", e);
			}
		}

	}

    public synchronized void forumOneTime(Long docResourceId) {
        DocResourcePO doc = docResourceDao.get(docResourceId);
        doc.setCommentCount(doc.getCommentCount()+1);
        this.docResourceDao.update(doc);
    }

    public synchronized void deleteForumOneTime(Long docResourceId) {
        DocResourcePO dr = docResourceDao.get(docResourceId);
        int nc = dr.getCommentCount() - 1;
        dr.setCommentCount(nc > 0 ? nc : 0);
        docResourceDao.update(dr);
    }

    public void moveDocWithoutAcl4Project(DocResourcePO dr) {
        if (dr.getIsFolder()) {
            this.moveFolderWithoutAcl4Project(dr);
        } else {
            this.moveLeafWithoutAcl4Project(dr);
        }
    }

    private void moveFolderWithoutAcl4Project(DocResourcePO dr) {
        // 2. 根据将要被移动的文档夹的 logicalPath 找到它下面所有的子节�?
        // 2.1 找到文档夹的�?有子节点
        String oldParentPath = dr.getLogicalPath();
        // 此处比较的logicalPath后边加上了一个点 . 表示查找它的下级内容�?
        // 防止在寻�? 1.2 下面的内容时找到 1.20
        List<DocResourcePO> drs = docResourceDao.findByLogicPathLike(oldParentPath + ".");
        // 2.2 保存原路径长度，供后�?(4)使用
        int oldParentPathLength = oldParentPath.length();

        // 3. 移动文档夹本�?
        this.moveLeafWithoutAcl4Project(dr);
        // 4. 修改�?有子节点的表记录�?
        // 4.1 修改 doc_resources 表的记录，此处不用修�? parentId
        String newParentPath = Constants.DOC_LIB_ROOT_ID_PROJECT + "." + dr.getId();
        for (DocResourcePO tempDr : drs) {
            tempDr.setDocLibId(Constants.DOC_LIB_ID_PROJECT);
            tempDr.setLastUserId(-1L);
            tempDr.setLastUpdate(new Timestamp(new Date().getTime()));

            StringBuilder sb = new StringBuilder(tempDr.getLogicalPath());
            tempDr.setLogicalPath(newParentPath + sb.substring(oldParentPathLength));
            docResourceDao.update(tempDr);
        }

    }

    private void moveLeafWithoutAcl4Project(DocResourcePO dr) {
        dr = docResourceDao.get(dr.getId());
        // 修改 doc_resources 表中相关属�??
        dr.setDocLibId(Constants.DOC_LIB_ID_PROJECT);
        dr.setParentFrId(Constants.DOC_LIB_ROOT_ID_PROJECT);
        dr.setLastUserId(-1L);
        dr.setLastUpdate(new Timestamp(new Date().getTime()));
        dr.setFrOrder(1);
        dr.setCommentEnabled(false);

        String newParentPath = "" + Constants.DOC_LIB_ROOT_ID_PROJECT;
        dr.setLogicalPath(newParentPath + "." + dr.getId());

        docResourceDao.update(dr);
    }

    /**
     * 重命名文�?/文档�?
     */
    public void renameDoc(Long docResourceId, String newName, Long userId, String orgIds) throws BusinessException {
        DocResourcePO docResource = docResourceDao.get(docResourceId);
        if (!this.hasEditPermission(docResource, userId, orgIds))
            throw new BusinessException("对不起，您没有重命名该文档的权限�?");

        this.renameDocWithoutAcl(docResourceId, newName, userId);
    }

    public void renameDocWithoutAcl(Long docResourceId, String newName, Long userId) {
        docResourceDao.update(docResourceId,
                CommonTools.newHashMap(new String[] { "lastUserId", "lastUpdate", "frName", "isCheckOut" },
                        new Object[] { userId, new Date(System.currentTimeMillis()), newName, false }));

        updateLinkName(docResourceId, newName);
    }

    public void setFolderCommentEnabled(DocResourcePO drs, boolean enabled, int includeDocs, Long userId) {
        Map<String, Object> params = new HashMap<String, Object>();
        String hql = "update DocResourcePO set lastUserId = ?, lastUpdate = ?, commentEnabled = ? where id = :id ";
        params.put("id", drs.getId());
        if (includeDocs == Constants.SCOPE_LEV1_CHILDS) {
            hql += " or (parentFrId = :id and isFolder = false) ";
        } else if (includeDocs == Constants.SCOPE_ALL) {
            hql += " or logicalPath like :lp ";
            params.put("lp", drs.getLogicalPath() + ".%");
        }
        this.docResourceDao.bulkUpdate(hql, params, userId, new Date(System.currentTimeMillis()), enabled);
    }

    public void setFolderRecommendEnabled(DocResourcePO drs, boolean enabled, int includeDocs, Long userId) {
        Map<String, Object> params = new HashMap<String, Object>();
        String hql = "update DocResourcePO set lastUserId = ?, lastUpdate = ?, recommendEnable = ? where id = :id ";
        params.put("id", drs.getId());
        if (includeDocs == Constants.SCOPE_LEV1_CHILDS) {
            hql += " or (parentFrId = :id and isFolder = false) ";
        } else if (includeDocs == Constants.SCOPE_ALL) {
            hql += " or logicalPath like :lp ";
            params.put("lp", drs.getLogicalPath() + ".%");
        }
        this.docResourceDao.bulkUpdate(hql, params, userId, new Date(System.currentTimeMillis()), enabled);
    }

    public void setFolderVersionEnabled(DocResourcePO drs, boolean fve, int includeDocs, Long userId) {
        String hql = "update DocResourcePO set lastUserId = ?, lastUpdate = ?, versionEnabled = ? where id = :id ";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("id", drs.getId());

        //huangfj 2011-12-30 �?启历史版本，仅应用到本文档夹下：仅对本文档夹下的文档起作用，不对文档夹起作用
        if (includeDocs == Constants.SCOPE_LEV1_CHILDS) {
            hql += " or (parentFrId = :id and isFolder=false)";
        } else if (includeDocs == Constants.SCOPE_ALL) {
            hql += " or logicalPath like :lp ";
            params.put("lp", drs.getLogicalPath() + ".%");
        }
        this.docResourceDao.bulkUpdate(hql, params, userId, new Date(System.currentTimeMillis()), fve);
    }

    public void setDocLearning(long docResourceId) {
        Map<String, Object> columns = CommonTools.newHashMap(new String[] { "isLearningDoc" },
                new Object[] { true });
        docResourceDao.update(docResourceId, columns);
    }

    public void setDocLearning(List<Long> docResourceIds) {
        String hql = "update DocResourcePO set isLearningDoc=? where id in (:ids)";
        Map<String, Object> params = CommonTools.newHashMap("ids", docResourceIds);
        this.docResourceDao.bulkUpdate(hql, params, true);
    }

    public void cancelDocLearning(long docResourceId) {
        docResourceDao.update(docResourceId, CommonTools.newHashMap("isLearningDoc", false));
    }

    public void cancelDocLearning(List<Long> docResourceIds) {
        String hql = "update DocResourcePO set isLearningDoc=? where id in (:ids)";
        Map<String, Object> params = CommonTools.newHashMap("ids", docResourceIds);
        this.docResourceDao.bulkUpdate(hql, params, false);
    }

    // 不�?�虑权限(在进入此方法之前已经判断过了)
    public void removeDocWithoutAcl(DocResourcePO dr, Long userId, boolean first) throws BusinessException {
        Long drId = dr.getId();
        if (first) {
            // 删除相关的权限记�?
            docAclManager.deletePotent(dr);
            // 删除元数�?
            if (contentTypeManager.hasExtendMetadata(dr.getFrType()))
                docMetadataManager.deleteMetadata(dr);
            // 删除评论
            docForumManager.deleteDocForumByDocId(dr);
            // 删除常用文档
            docFavoriteManager.deleteFavoriteDocByDoc(dr);
            // 删除订阅
            docAlertManager.deleteAlertByDocResourceId(dr);
            // 删除�?新订�?
            docAlertLatestManager.deleteAlertLatestsByDoc(dr);
            // 删除正文内容
            if(dr.getMimeTypeId() == Constants.FORMAT_TYPE_DOC_A6 || dr.getMimeTypeId() == Constants.FORMAT_TYPE_DOC_WORD || dr.getMimeTypeId() == Constants.FORMAT_TYPE_DOC_EXCEL
            		|| dr.getMimeTypeId() == Constants.FORMAT_TYPE_DOC_WORD_WPS || dr.getMimeTypeId() == Constants.FORMAT_TYPE_DOC_EXCEL_WPS) {
            	try {
					MainbodyService.getInstance().deleteContentAllByModuleId(ModuleType.doc, dr.getId());
				} catch (BusinessException e) {
					log.error("删除正文内容出错", e);
				}
            }           
        }

        if (dr.getIsFolder() && first) {
            this.removeFolderWithoutAcl(dr, userId);
        } else {
            if (!dr.getIsFolder()) {
                // 删除全文�?�?
                try {
                    if (AppContext.hasPlugin("index")) {
                        indexManager.delete(drId, ApplicationCategoryEnum.doc.getKey());
                    }
                } catch (Exception e) {
                    log.error("删除文档[id=" + drId + "]全文�?索信息时出现异常�?", e);
                }
                // 删除学习文档
                if (dr.getIsLearningDoc())
                    docLearningManager.deleteLearnByDocId(drId);

                // 2. 根据文档类型判断有无内容，如果有，调用内容管理接口删除内�?
                try {
                    DocMgrUtils.deleteBodyAndSource(dr, docMimeTypeManager, fileManager, docBodyDao);
                } catch (BusinessException e) {
                    log.error("从fileManager删除在线编辑的V3xFile出现异常�?", e);
                }

                // 删除附件
                try {
                    attachmentManager.removeByReference(drId);
                } catch (BusinessException e) {
                    log.error("从attachManager删除附件�?", e);
                }
                // 删除个人使用空间
                if (this.isPersonalLib(dr.getDocLibId()))
                    if (dr.getFrSize() > 0)
                        docSpaceManager.subUsedSpaceSize(userId, dr.getFrSize());
            }
            // 删除历史版本信息记录
            this.docVersionInfoManager.deleteByDocResourceId(drId);
            //删除操作痕迹   因为文档收藏后，�?要根据action查询收藏记录
            docActionManager.removeDocActionBySubject(drId);
            // 3. 删除 doc_resources 表中的记�?
            docResourceDao.delete(drId.longValue());
            // 如果是删除收藏，触发事件
            if (dr.getSourceId()!=null || dr.getFavoriteSource()!=null) {
                Long sorceId = dr.getFavoriteSource() == null ? dr.getSourceId() : dr.getFavoriteSource();
                DocCancelFavoriteEvent event = new DocCancelFavoriteEvent(dr, sorceId);
                EventDispatcher.fireEvent(event);
            }
        }
    }

    public void removeFolderWithoutAcl(DocResourcePO dr, Long userId) throws BusinessException {
        // 1. 查找 docLogicalPath
        // 2. 根据文档夹的 logicalPath 查找�?有对应文档夹下的�?有内容，包含文档、文档夹，使�? like path.%
        String hql = "from DocResourcePO doc where doc.logicalPath like :logicalPath";
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("logicalPath", dr.getLogicalPath()+".%");
        List<DocResourcePO> children = docResourceDao.find(hql,params);
        if (Strings.isEmpty(children)) {
            docResourceDao.delete(dr.getId().longValue());
        } else {
            // 添加文档夹本身进去需要删除列�?
            children.add(dr);
            // 3. 逐个删除节点
            for (DocResourcePO tempDr : children) {
                this.removeDocWithoutAcl(tempDr, userId, false);
            }
        }
    }

    /**
     * 删除个人文档库下�?有内容，不保留根节点 库类型和用户权限在文档库管理处判断，此处不再进行判断
     * @throws BusinessException
     */
    protected void emptyLib(Long libId, Long userId) throws BusinessException {
        this.removeDocWithoutAcl(this.getRootByLibId(libId), userId, true);
    }

    public DocResourcePO getRootByLibId(Long libId) {
        String hql = "from " + DocResourcePO.class.getName() + " where parentFrId=0 and docLibId=?";
        return (DocResourcePO) this.docResourceDao.findUnique(hql, null, libId);
    }

    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getRootByLibIds(List<Long> libIds) {
        String hql = "from DocResourcePO dr where parentFrId = 0 and docLibId in (:libIds)";
        Map<String, Object> nmap = new HashMap<String, Object>();
        nmap.put("libIds", libIds);
        return docResourceDao.find(hql, -1, -1, nmap);
    }

    public Map<Long, DocResourcePO> getRootMapByLibIds(List<Long> libIds) {
        List<DocResourcePO> drs = this.getRootByLibIds(libIds);
        Map<Long, DocResourcePO> result = new HashMap<Long, DocResourcePO>();
        if (CollectionUtils.isNotEmpty(drs)) {
            for (DocResourcePO dr : drs) {
                result.put(dr.getDocLibId(), dr);
            }
        }
        return result;
    }

    public List<DocResourcePO> getRootsByLibIds(List<Long> ids, String orgIds) {
        List<DocResourcePO> drs = this.getRootByLibIds(ids);
        if (CollectionUtils.isNotEmpty(drs)) {
            List<Long> docIds = CommonTools.getIds(drs);
            Map<Long, Set<DocAcl>> map = this.docAclManager.getAclSet(docIds, orgIds);
            for (DocResourcePO dr : drs) {
                Set<Integer> set = new HashSet<Integer>();
                for (DocAcl da : map.get(dr.getId())) {
                    if (da.getSharetype().byteValue() == Constants.SHARETYPE_DEPTSHARE
                            && !da.getMappingPotent().isNoPotent()) {
                        set.addAll(da.getMappingPotent().adapterPotentToSet(da.getSharetype()));
                    }
                }
                dr.setAclSet(set);
            }
        }
        return drs;
    }

    public List<DocResourcePO> getRootsByLibIds(String idStrs, String orgIds) {
        return this.getRootsByLibIds(CommonTools.parseStr2Ids(idStrs), orgIds);
    }

    /**
     * 得到某个用户的个人文档库的根
     */
    public DocResourcePO getPersonalFolderOfUser(long userId) {
        String hql = "select dr from DocResourcePO as dr where dr.createUserId = ? and dr.frType = ?";
        List<DocResourcePO> list = docResourceDao.findVarargs(hql, userId, Constants.FORMAT_TYPE_FOLDER_MINE);
        if (list != null && list.size() > 0) {
            return list.get(0);
        } else {
            return null;
        }
    }

    /**
     * 得到某个用户的个人文档库的根
     */
    public DocResourcePO getPersonalLibRootOfUser(long userId) {
        String hql = "select dr from DocResourcePO as dr, DocLibPO as dl, DocLibOwnerPO as dlo where "
                + " dr.docLibId = dl.id and dl.id = dlo.docLibId and dlo.ownerId = ? and dl.type = ? and dr.parentFrId = 0";

        List<DocResourcePO> list = docResourceDao.findVarargs(hql, userId, Constants.PERSONAL_LIB_TYPE.byteValue());
        if (list != null && list.size() > 0) {
            return list.get(0);
        } else {
            return null;
        }
    }

    /**
     * 查找我的文档库下的文档夹 在查询�?�阅，共享时考虑权限
     * @throws BusinessException 
     */
    public List<DocResourcePO> findMyFolders(Long parentId, Long contentType, Long userId, String orgIds)
            throws BusinessException {
        // 根据传过来的内容类型，调用相应的方法
        if (contentType == Constants.FOLDER_SHARE) {
            return this.getDrListByUserIds(this.getShareUserIds(userId, orgIds), Constants.PERSON_SHARE, userId);
        } else if (contentType == Constants.FOLDER_BORROW) {
            return this.getDrListByUserIds(this.getBorrowUserIds(userId, orgIds), Constants.PERSON_BORROW, userId);
        } else if (contentType == Constants.PERSON_SHARE) {
            return this.getShareRootDocs(parentId, userId, orgIds);
        } else if (contentType == Constants.PERSON_BORROW || contentType == Constants.DEPARTMENT_BORROW) {
            return new ArrayList<DocResourcePO>();
        } else {
            String hql = "from DocResourcePO as d where d.parentFrId=? and d.isFolder=true " + Order_By;
            return docResourceDao.findVarargs(hql, parentId);
        }
    }

    /** 排序：按照文件编号�?�创建日期降序排�? */
    private static String Order_By = " order by d.frOrder asc,d.createTime desc ";   

    public List<DocResourcePO> findAllMyDocsByPageByDate(Long parentId, Long contentType, Integer pageNo,
            Integer pageSize, Long userId) throws BusinessException {
        return this.findAllMyDocsByPage(parentId, contentType, pageNo, pageSize, userId, Order_By);
    }

    public List<DocResourcePO> findAllMyDocsByPage(Long parentId, Long contentType, Integer pageNo, Integer pageSize,
            Long userId) throws BusinessException {
        return this.findAllMyDocsByPage(parentId, contentType, pageNo, pageSize, userId, Order_By);
    }

    /**
     * 分页查找我的文档库下的所有内�?
     * 
     * 不�?�虑权限
     * @throws BusinessException 
     */
    private List<DocResourcePO> findAllMyDocsByPage(Long parentId, Long contentType, Integer pageNo, Integer pageSize,
            Long userId, String orderStr) throws BusinessException {
        List<DocResourcePO> ret = null;
        // 根据传过来的内容类型，调用相应的方法
        String orgIds = Constants.getOrgIdsOfUser(userId);
        if (contentType == Constants.FOLDER_SHARE){
        	ret = this.getDrListByUserIds(this.getShareUserIdsByPage(userId, orgIds, pageNo, pageSize),
        			Constants.PERSON_SHARE, userId);
        }
        else if (contentType == Constants.FOLDER_BORROW){
        	ret = this.getDrListByUserIds(this.getBorrowUserIdsByPage(userId, orgIds, pageNo, pageSize),
        			Constants.PERSON_BORROW, userId);
        }
        else if (contentType == Constants.FOLDER_SHAREOUT || contentType == Constants.FOLDER_BORROWOUT) {
            List<DocResourcePO> drs = new ArrayList<DocResourcePO>();
            List<DocResourcePO> fdrs = new ArrayList<DocResourcePO>();
            DocResourcePO dr = this.getDocResourceById(parentId);
            long pId = dr.getParentFrId();
            String lp = this.getDocResourceById(pId).getLogicalPath();

            String hql = "from DocResourcePO as d where logicalPath like :lp " + DocSearchHqlUtils.HQL_FR_TYPE;
            Map<String, Object> nmap = new HashMap<String, Object>();
            nmap.put("lp", lp + ".%");

            ret = docResourceDao.find(hql, -1, -1, nmap);
            if (ret != null) {
                List<DocAcl> ilist = null;
                for (DocResourcePO drt : ret) {
                    if (drt.getIsFolder()) {
                        ilist = docAclManager.getPersonalShareList(drt.getId());
                        Strings.addAllIgnoreEmpty(ilist, docAclManager.getPersonalShareInHeritList(drt.getId()));
                    } else {
                        ilist = docAclManager.getPersonalBorrowList(drt.getId());
                    }

                    if (drt.getIsFolder() && ilist != null && !ilist.isEmpty())
                        fdrs.add(drt);
                    else if ((!drt.getIsFolder()) && ilist != null && !ilist.isEmpty())
                        drs.add(drt);

                }
            }

            if (contentType == Constants.FOLDER_SHAREOUT) {
                Pagination.setRowCount(fdrs.size());
                if(pageNo == -1 && pageSize == -1){
                	return fdrs;
                }else{
                	return this.getPagedDrs(fdrs, pageNo, pageSize);
                }
            } else {
                Pagination.setRowCount(drs.size());
                if(pageNo == -1 && pageSize == -1){
                	return drs;
                }else{
                	return this.getPagedDrs(drs, pageNo, pageSize);
                }
                
            }

        }

        else if (contentType == Constants.PERSON_SHARE){
        	ret = this.getShareRootDocsByPage(parentId, pageNo, pageSize, userId, orgIds);
        }
        else if (contentType == Constants.PERSON_BORROW){
        	ret = this.getBorrowDocsByPage(parentId, pageNo, pageSize, userId, orgIds);
        }
        else if (contentType == Constants.DEPARTMENT_BORROW) {
            ret = docAclManager.getDeptBorrowDocsPage(this.getAclIdsByOrgIds(orgIds, userId), pageNo, pageSize);
        }
        //TODO sunzm plan 临时注释
        else if (contentType == Constants.FOLDER_PLAN_DAY || contentType == Constants.FOLDER_PLAN_MONTH
                || contentType == Constants.FOLDER_PLAN_WEEK || contentType == Constants.FOLDER_PLAN_WORK) {
            //        	int rowcount = planManager.countDraftsmanPlan(userId, Constants.getPlanTypeByFrType(contentType));
            //        	Pagination.setRowCount(rowcount);
            List<PlanBO> plans = null;// = planManager.getDraftsmanPlan(userId, Constants.getPlanTypeByFrType(contentType));

            ret = this.getDrsByPlans(plans);
        } else {
            // 我的文档库下显示不依�? frOrder
            // 根据 类型-时间
            String hql = "and " + "d.frType!=" + Constants.FOLDER_PLAN
                    + " and d.frType!=" + Constants.FOLDER_TEMPLET + " and d.frType!=" + Constants.FOLDER_SHAREOUT
                    + " and d.frType!=" + Constants.FOLDER_BORROW + " and d.frType!=" + Constants.FOLDER_SHARE;
            String perfix = "from DocResourcePO d where d.parentFrId=? ";
            if(pageNo == -1 && pageSize == -1){
            	ret = this.find(perfix + hql + orderStr, pageNo, pageSize, null, parentId);
            }else{
            	ret = this.find(perfix + hql + orderStr, null, parentId);
            }
            if (ret != null && ret.size() > 0) {
                if (this.docUtils.isOwnerOfLib(userId, ret.get(0).getDocLibId())) {
                    for (DocResourcePO tdr : ret) {
                        tdr.setIsMyOwn(true);
//                        if (tdr.getFrType() == Constants.SYSTEM_COL) {
//                            //sunzm  affairManager、hisAffairManager 在哪儿注入？ 
//                            //CtpAffair affair = affairManager.get(tdr.getSourceId());
//                            //TODO sunzm  col 临时注释
//                            //看一下是否被转储�?
//                            //            				            if(affair == null){
//                            //            				            	affair = this.hisAffairManager.getById(tdr.getSourceId());
//                            //            				            }
//                            //            				            //关联的协同不存在 
//                            //            				            if(affair == null){
//                            //            								tdr.setIsRelationAuthority(Boolean.FALSE);
//                            //            				            }else{
//                            //            				            	//sunzm 目前无此方法
//                            //            								tdr.setIsRelationAuthority(affair.getIsRelationAuthority());
//                            //            				            }
//                        }
                    }
                }
            }
        }
        return ret;
    }

    // 根据 Plan 封装 DocResourcePO 对象
    private List<DocResourcePO> getDrsByPlans(List<PlanBO> plans) {
        User user = AppContext.getCurrentUser();
        List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
        long i = 0;
        for (PlanBO p : plans) {
            DocResourcePO dr = new DocResourcePO();
            dr.setId(i++);
            dr.setSourceId(p.getId());
            dr.setFrName(p.getTitle());
            dr.setFrType(Constants.SYSTEM_PLAN);
            dr.setCreateTime(new Timestamp(new Date().getTime()));
            dr.setCreateUserId(user.getId());
            dr.setDocLibId(0L);
            dr.setIsFolder(false);
            dr.setSubfolderEnabled(false);
            dr.setFrSize(0);
            dr.setLastUpdate(new Timestamp(new Date().getTime()));
            dr.setLastUserId(user.getId());
            dr.setMimeTypeId(Constants.SYSTEM_PLAN);
            dr.setMimeOrder(docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getOrderNum());
            dr.setHasAttachments(p.isHasAttatchment());
            ret.add(dr);

        }
        return ret;
    }

    public List<DocResourcePO> findMyDocs4Rel(Long parentId) throws BusinessException {
        List<DocResourcePO> ret = null;
        String hql = "from DocResourcePO as d where d.parentFrId=? and " + "d.frType!=" + Constants.FOLDER_PLAN
                + " and d.frType!=" + Constants.FOLDER_TEMPLET + " and d.frType!=" + Constants.FOLDER_BORROW
                + " and d.frType!=" + Constants.FOLDER_SHARE + " order by d.frOrder ";//,  d.frType desc, d.lastUpdate desc,  d.createTime desc";
        ret = docResourceDao.findVarargs(hql, parentId);

        return ret;
    }

    /**
     * 通过文档类型和parentId查找文档
     */
    public List<DocResourcePO> findDocByType(Long parentId, Long type) throws BusinessException {
        String hql = "from DocResourcePO as d where d.parentFrId =? and d.frType=? order by d.frOrder ";
        return docResourceDao.findVarargs(hql, parentId, type);
    }

    /**
     * 通用文档夹查�?
     * @throws BusinessException 
     */
    public List<DocResourcePO> findFolders(Long parentId, Long contentType, Long userId, String orgIds,
            boolean isPersonalLib,List<Long> sourceIds) throws BusinessException {
        List<DocResourcePO> ret = null;
        // 虚拟的DocResourcePO对象判断
        String aclIds = this.getAclIdsByOrgIds(orgIds, userId);
        if ((contentType == Constants.PERSON_SHARE) || (contentType == Constants.PERSON_BORROW)
                || (contentType == Constants.DEPARTMENT_BORROW) || (contentType == Constants.FOLDER_SHARE)
                || (contentType == Constants.FOLDER_BORROW))
            ret = this.findMyFolders(parentId, contentType, userId, orgIds);
        else {
            DocResourcePO dr = docResourceDao.get(parentId);
            if (!isPersonalLib) {
                ret = docAclManager.findNextNodeOfTree(dr, aclIds,sourceIds);
            } else{
                ret = this.findMyFolders(parentId, contentType, userId, orgIds);
            }
        }
        return ret;
    }

    public List<DocResourcePO> findFoldersWithOutAcl(Long parentId) {
        List<DocResourcePO> ret = null;
        DocResourcePO dr = docResourceDao.get(parentId);
        ret = docAclManager.findNextNodeOfTreeWithOutAcl(dr);
        return ret;
    }

    @Override
	public List<DocResourcePO> getAllFoldersWithOutAcl(DocResourcePO parentDoc) {
		return docAclManager.findAllFoldersWithOutAcl(parentDoc);
	}
	@Override
	public List<DocResourcePO> getAllFoldersWithOutAcl(Long parentId) {
        DocResourcePO parentDoc = docResourceDao.get(parentId);
        return getAllFoldersWithOutAcl(parentDoc);
	}
	/**
     * 首页查找文档内容
     * @throws BusinessException 
     */
    public List<DocResourcePO> findAllDocsByPageBySection(Long parentId, Long contentType, Integer pageNo,
            Integer pageSize, Long userId) throws BusinessException {
        List<DocResourcePO> ret = null;
        // 虚拟的DocResourcePO对象判断
        // String aclIds = this.getAclIdsByOrgIds(orgIds, userId);
        if ((contentType == Constants.PERSON_SHARE) || (contentType == Constants.PERSON_BORROW)
                || (contentType == Constants.DEPARTMENT_BORROW)) {
            ret = this.findAllMyDocsByPage(parentId, contentType, pageNo, pageSize, userId);
        } else {
            DocResourcePO dr = docResourceDao.get(parentId);
            if (this.isNotPartOfMyLib(userId, dr.getDocLibId())) {
                String aclIds = Constants.getOrgIdsOfUser(userId);
                ret = docAclManager.findNextNodeOfTablePageByDate(false,dr, aclIds, pageNo, pageSize);
            } else {
                ret = this.findAllMyDocsByPageByDate(parentId, contentType, pageNo, pageSize, userId);
            }
        }

        return ret;
    }

    public List<DocResourcePO> findAllDocsByPage(boolean isNewView,Long parentId, Long contentType, Long userId,List<Long> sourceIds, String... type)
            throws BusinessException {
        Integer pageNo = 0;
        Integer first = Pagination.getFirstResult();
        if(isNewView){
        	Pagination.setMaxResults(30);
        }
        Integer pageSize = Pagination.getMaxResults();
        pageNo = first / pageSize + 1;
        List<DocResourcePO> list = new ArrayList<DocResourcePO>();
        list = this.findAllDocsByPage(isNewView,parentId, contentType, pageNo, pageSize, userId,sourceIds, type);
        return list;
    }

    
    private DocResourceNewDao docResourceNewDao;
    
    public void setDocResourceNewDao(DocResourceNewDao docResourceNewDao) {
		this.docResourceNewDao = docResourceNewDao;
	}
	/**
     * 通用分页查找�?有内�?
     * @throws BusinessException 
     */
    public List<DocResourcePO> findAllDocsByPage(Boolean isNewView,Long parentId, Long contentType, Integer pageNo, Integer pageSize,
            Long userId,List<Long> sourceIds, String... type) throws BusinessException {
        List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
        // 虚拟的DocResourcePO对象判断
        if ((contentType == Constants.PERSON_SHARE) || (contentType == Constants.PERSON_BORROW)
                || (contentType == Constants.DEPARTMENT_BORROW)) {
            ret = this.findAllMyDocsByPage(parentId, contentType, pageNo, pageSize, userId);
        } else {  //kekai  zhaohui  档案查询修改  start
            DocResourcePO dr = docResourceDao.get(parentId);
            if (this.isNotPartOfMyLib(userId, dr.getDocLibId())) {
                String aclIds = Constants.getOrgIdsOfUser(userId);
                if(AppContext.getSystemProperty("doc.frNameMeeting") .equals(parentId.toString())  || AppContext.getSystemProperty("doc.frNameQianBao") .equals(parentId.toString()) 
                		|| AppContext.getSystemProperty("doc.frNameShouWen") .equals(parentId.toString()) || AppContext.getSystemProperty("doc.frNameFaWen") .equals(parentId.toString())){
                	
                	String getdocIdsByFrName = docResourceNewDao.getdocIdsByFrName(dr);
                	String[] split = getdocIdsByFrName.split(",");
                	for (int i = 0; i < split.length; i++) {
                		 DocResourcePO dro = docResourceDao.get(Long.valueOf(split[i]));
                		 List<DocResourcePO> findNextNodeOfTablePage = docAclManager.findNextNodeOfTablePage(dro, aclIds, pageNo, pageSize, type);
                		if(!findNextNodeOfTablePage.isEmpty()){
                		
                		 ret.addAll(findNextNodeOfTablePage);
                		 
                		 ListSort(ret);
						
                		}
					}
                }else{
				ret = docAclManager.findNextNodeOfTablePage(isNewView,dr, aclIds, pageNo, pageSize,sourceIds, type);
                }
              //kekai  zhaohui  档案查询修改  start
            } else {
                ret = this.findAllMyDocsByPage(parentId, contentType, pageNo, pageSize, userId);
            }
        }
        return ret;
    }
    // kekai  zhaohui  档案查询 时间排序 start
    private static  void ListSort(List<DocResourcePO> docResourcePO) {
        Collections.sort(docResourcePO , new Comparator<DocResourcePO>() {
            @Override
            public int compare(DocResourcePO o1, DocResourcePO o2) {
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                try {
                    Date dt1 = format.parse(o1.getCreateTime().toString());
                    Date dt2 = format.parse(o2.getCreateTime().toString());
                    if (dt1.getTime() < dt2.getTime()) {
                        return 1;
                    } else if (dt1.getTime() > dt2.getTime()) {
                        return -1;
                    } else {
                        return 0;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                return 0;
            }
        });
    }
 // kekai  zhaohui  档案查询 时间排序 start
    
    public DocResourcePO getDocResourceById(Long docResourceId) {
        return docResourceDao.get(docResourceId);
    }

    public boolean docResourceExist(Long docResourceId) {
        return isDocExsit(docResourceId);
    }

    public boolean deeperThanLimit(DocResourcePO drs) {
        return drs.deeperThanLimit(this.folderLevelLimit);
    }

    public boolean docResourceEdit(Long docResourceId) {
        DocResourcePO ret = docResourceDao.get(docResourceId);
        return ret == null ? true : ret.getIsCheckOut();
    }

    public String docResourceNoChange(Long docResourceId, String logicalPath) {
        DocResourcePO ret = docResourceDao.get(docResourceId);
        if (ret == null)
            return "delete";
        else if (!ret.getLogicalPath().equals(logicalPath))
            return "move";
        else
            return "true";
    }

    /**
     * 根据docResourceId 查找某个文档的从根节点开始的整个文档夹对象链
     */
    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getFoldersChainById(Long docResourceId) {
        DocResourcePO doc = docResourceDao.get(docResourceId);
        if (doc != null) {
            String logicalPath = doc.getLogicalPath();
            List<Long> docIds = CommonTools.parseStr2Ids(logicalPath, ".");
            docIds.remove(docResourceId);
            if (CollectionUtils.isNotEmpty(docIds)) {
                String hql = "from " + DocResourcePO.class.getName() + " as d where d.id in (:ids)";
                Map<String, Object> params = new HashMap<String, Object>();
                params.put("ids", docIds);
                return this.docResourceDao.find(hql, -1, -1, params);
            }
        }
        return null;
    }

    /** 判断将要被条件搜索的文档夹是否个人文档库�?属，即是否需要判断权�?  */
    public boolean isNotPartOfMyLib(Long userId, Long libId) {
        if (libId != null && userId != null) {
            DocLibPO lib = this.docUtils.getDocLibById(libId);
            return lib == null || !lib.isPersonalLib();
        }
        return true;
    }

    /** 右上角查询，当不�?要权限过滤时候，取得分页数据 */
    private List<DocResourcePO> getPagedDrs(List<DocResourcePO> src, Integer pageNo, Integer pageSize) {
        List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
        int first = Pagination.getFirstResult();
        int end1 = first + pageSize;
        int end2 = src.size();
        int end = 0;
        if (end1 > end2) {
            end = end2;
        } else {
            end = end1;
        }
        for (int i = first; i < end; i++) {
            src.get(i).setIsMyOwn(true);
            ret.add(src.get(i));
        }
        return ret;
    }

    public String getPhysicalPath(String logicalPath, String separator) {
        return getPhysicalPathDetail(logicalPath, separator, true, 0);
    }

    public String getPhysicalPathDetail(String logicalPath, String separator, boolean needSub1, int beginIndex) {
        if (Strings.isBlank(logicalPath)) {
            return "";
        }
        StringBuilder sb = new StringBuilder("");
        String ids = logicalPath.replace('.', ',');
        String[] arr = logicalPath.split("\\.");

        List<DocResourcePO> list = this.getDocsByIds(ids.substring(beginIndex));
        if (Strings.isEmpty(list)){
            return "";
        }

        Map<String, DocResourcePO> map = new HashMap<String, DocResourcePO>();
        for (DocResourcePO td : list) {
            map.put(td.getId().toString(), td);
        }
        int loop = 0;
        if (needSub1) {
            loop = (arr.length == 1 ? 1 : (arr.length - 1));
        } else {
            loop = arr.length;
        }
        for (int i = 0; i < loop; i++) {
            DocResourcePO td = map.get(arr[i]);
            if (td == null)
                continue;
            if (i > 0)
                sb.append(separator);
            String key = td.getFrName();
            if (Constants.needI18n(td.getFrType()))
                key = Constants.getDocI18nValue(key);
            sb.append(key);
        }

        return sb.toString();
    }

    /**
     * 判断�?个库下是否只存在�?个根文档�?
     */
    public boolean isLibOnlyRoot(Long libId) {
        // 通过判断该库下是否只有一个节�?
        List<DocResourcePO> drs = docResourceDao.findBy("docLibId", libId);
        return CollectionUtils.isEmpty(drs) || drs.size() == 1;
    }

    /**
     * 查询共享�?有人列表
     * @throws BusinessException 
     */
    public Set<Long> getShareUserIds(Long userId, String orgIds) throws BusinessException {
        String aclIds = Constants.getOrgIdsOfUser(userId);
        return docAclManager.getShareUserIds(aclIds);
    }

    /**
     * 查询共享�?有人列表（分页）
     */
    public Set<Long> getShareUserIdsByPage(Long userId, String orgIds, Integer pageNo, Integer pageSize) {
        String aclIds = this.getAclIdsByOrgIds(orgIds, userId);
        return docAclManager.getShareUserIdsPage(aclIds, pageNo, pageSize);
    }

    /**
     * 根据�?有人查询共享第一级文档夹
     */
    public List<DocResourcePO> getShareRootDocs(Long ownerId, Long userId, String orgIds) {
        String aclIds = this.getAclIdsByOrgIds(orgIds, userId);
        return docAclManager.getShareRootDocs(aclIds, ownerId);
    }

    /**
     * 根据�?有人查询共享第一级文档夹（分页）
     */
    public List<DocResourcePO> getShareRootDocsByPage(Long ownerId, Integer pageNo, Integer pageSize, Long userId,
            String orgIds) {
        String aclIds = this.getAclIdsByOrgIds(orgIds, userId);
        return docAclManager.getShareRootDocsPage(aclIds, ownerId, pageNo, pageSize);
    }

    /**
     * 查询借阅�?有人id列表
     * @throws BusinessException 
     */
    public Set<Long> getBorrowUserIds(Long userId, String orgIds) throws BusinessException {
        String aclIds = Constants.getOrgIdsOfUser(userId);
        return docAclManager.getBorrowUserIds(aclIds);
    }

    /**
     * 查询借阅�?有人id列表(分页)
     */
    public Set<Long> getBorrowUserIdsByPage(Long userId, String orgIds, Integer pageNo, Integer pageSize) {
        String aclIds = this.getAclIdsByOrgIds(orgIds, userId);
        return docAclManager.getBorrowUserIdsPage(aclIds, pageNo, pageSize);
    }

    /**
     * 根据�?有人查询借阅文档(分页)
     */
    public List<DocResourcePO> getBorrowDocsByPage(Long ownerId, Integer pageNo, Integer pageSize, Long userId,
            String orgIds) {
        String aclIds = this.getAclIdsByOrgIds(orgIds, userId);
        return docAclManager.getBorrowDocsPage(aclIds, ownerId, pageNo, pageSize);
    }

    public List<DocResourcePO> findAllCheckedOutDocsByDays(int days) throws BusinessException {
        String hql = "from DocResourcePO dr where dr.isCheckOut = 'true' and (dr.checkOutTime <= ?)";
        Date flagtime = new Date(new Date().getTime() - days * 24 * 60 * 60 * 1000);
        return docResourceDao.findVarargs(hql, flagtime);
    }

    public List<DocResourcePO> findAllCheckoutDocsByDocLibIdByPage(final long docLibId) {
        String hql = "from DocResourcePO dr where dr.docLibId= ? and dr.isFolder = false and dr.isCheckOut=true ";
        return docResourceDao.findVarargs(hql, docLibId);
    }

    public List<DocResourcePO> findDocResourceByHql(String hql, Object... args) {
        return docResourceDao.findVarargs(hql, args);
    }

    public List<DocResourcePO> findFirstDocResourceById(long docResId) {
        List<DocResourcePO> list = docResourceDao.findBy("parentFrId", docResId);
        return list;
    }

    /**
     * 根据id获取名字
     * 
     * @return 正常返回 name; 如果该文档不存在，返�? null
     */
    public String getNameById(Long docResourceId) {
        DocResourcePO dr = docResourceDao.get(docResourceId);
        if (dr == null) {
            return null;
        }
        String key = dr.getFrName();
        String name = ResourceUtil.getString(key);
        DocLibPO lib = docLibManager.getDocLibById(dr.getDocLibId());
		String otherAccountShortName = DocMVCUtils.getOtherAccountShortName(lib, orgManager);
		if(Strings.isNotBlank(otherAccountShortName)){
			name = Strings.toXmlStr(name + otherAccountShortName);
		}
        return name;
    }

    /**
     * 找出某个文档夹下的所有符合类型的数据记录
     * 
     * @param types
     *            类型连接字符�?,逗号分割 �? 163,165,56
     */
    public List<DocResourcePO> getDocsInFolderByType(long folderId, String types) {
        String hql = "from DocResourcePO where parentFrId = :fid ";
        Map<String, Object> amap = new HashMap<String, Object>();
        amap.put("fid", folderId);
        if(types!=null){
            amap.put("ids", Constants.parseStrings2Longs(types, ",")); 
            hql += " and frType in (:ids)";
        }
        return docResourceDao.find(hql, -1, -1, amap);
    }

    /**
     * 找出某个文档夹下的所有符合类型的数据记录，包含子文件�?
     * 
     * @param types
     *            类型连接字符�?,逗号分割 �? 163,165,56
     */
    public List<DocResourcePO> getAllDocsInFolderByType(long folderId, String types) {
        List<DocResourcePO> list = new ArrayList<DocResourcePO>();
        DocResourcePO dr = this.getDocResourceById(folderId);
        if (dr != null) {
            String hql = "from DocResourcePO where logicalPath like :logicalPath";
            Map<String, Object> amap = new HashMap<String, Object>();
            amap.put("logicalPath", dr.getLogicalPath() + ".%");
            if (Strings.isNotBlank(types)) {
                amap.put("ids", Constants.parseStrings2Longs(types, ","));
                hql += " and frType in (:ids)";
            }
            list = docResourceDao.find(hql, -1, -1, amap);
        }
        return list;
    }

    /**
     * 查询某人共享给当前用户的�?有文�? 关联人员使用
     * @throws BusinessException 
     */
    public List<DocTreeVO> getShareDocsByOwnerId(Long memberId, Long ownerId) throws BusinessException {
        List<DocTreeVO> ret = new ArrayList<DocTreeVO>();

        String aclIds = Constants.getOrgIdsOfUser(memberId);
        List<DocResourcePO> list = docAclManager.getShareRootDocs(aclIds, ownerId);
        if (list != null) {
            for (DocResourcePO dr : list) {
                DocTreeVO vo = new DocTreeVO(dr);
                String srcIcon = docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getIcon();
                if(srcIcon.indexOf('|')==-1){
                	vo.setCloseIcon(srcIcon);
                }else{
                	vo.setCloseIcon(srcIcon.substring(0, srcIcon.indexOf('|')));
                }
                vo.setShowName(ResourceUtil.getString(dr.getFrName()));
                ret.add(vo);
            }
        }
        return ret;
    }

    /** **************项目管理�?�?******************* */

    /**
     * 新建项目 1. 生成项目�?级文档夹 2. 生成该项目的二级阶段文档�?
     * 
     * @return 项目�?级文档夹的id 不判断权限，在项目管理处做判�?
     * @throws BusinessException 
     */
    public Long createNewProject(ProjectBO summary, Long userId) throws BusinessException {
        // 取得项目文档库的�?
        DocLibPO lib = this.docUtils.getDocLibManager().getProjectDocLib();
        DocResourcePO root = this.getRootByLibId(lib.getId());
        // 转换数据
        ProjectSummaryDataBO appObject = new ProjectSummaryDataBO(summary);
        // 1. 新建项目文档�?
        Long newProjectId = this.createCaseFolder(summary.getProjectName(), Constants.FOLDER_CASE, summary.getId(),
                lib.getId(), root.getId(), userId);

        Node appNode = DocHierarchyManagerImpl.getNodesMap().get("project_data");
        if (appNode != null)
            this.saveProjectMetadata(newProjectId, appObject, appNode, true);

        // 3. 新建阶段文档�?
        List<ProjectPhaseBO> phases = projectApi.findProjectPhases(summary.getId());
        if (phases != null) {
            for (ProjectPhaseBO p : phases) {
                Long pid = this.createCaseFolder(p.getPhaseName(), Constants.FOLDER_CASE_PHASE, p.getId(), lib.getId(),
                        newProjectId, userId);
                Node appNode2 = DocHierarchyManagerImpl.getNodesMap().get("project_phase_data");
                if (appNode2 != null)
                    this.saveProjectMetadata(pid, p, appNode2, true);
            }
        }
        // 4. 保存权限
//        List<ProjectMemberInfoBO> members = projectApi.findProjectMembers(summary.getId());
        docAclManager.saveProjectAcl(summary.getMemberObjList(), userId, newProjectId, summary.getId());

        return newProjectId;
    }

    // 项目文档夹，项目阶段文档夹类型的元数据保�?
    // newId: 对应文档夹的id
    private void saveProjectMetadata(Long newId, Object appObject, Node appNode, boolean newFlag) throws BusinessException {
        try {
            // 遍历数据库表
            for (Node table = appNode.getFirstChild(); table != null; table = table.getNextSibling()) {
                String tableName = table.getNodeName();
                Map metadatas = new HashMap();
                if (table.getNodeType() == Node.ELEMENT_NODE) {
                    // 遍历字段、属性的对应
                    for (Node prop = table.getFirstChild(); prop != null; prop = prop.getNextSibling()) {
                        if (prop.getNodeType() == Node.ELEMENT_NODE) {
                            NamedNodeMap atts = prop.getAttributes();
                            String methodName = atts.getNamedItem("method").getNodeValue();
                            Method method = appObject.getClass().getMethod(methodName);
                            Object value = method.invoke(appObject);
                            String valueClassName = atts.getNamedItem("type").getNodeValue();
                            Class valueClass = null;
                            if (valueClassName.contains(".")) {// 处理对象类型
                                valueClass = Class.forName(valueClassName);
                                valueClass.cast(value);
                            } else {
                                // 处理基本类型
                                if ("byte".equals(valueClassName)) {
                                    valueClass = byte.class;
                                } else if ("short".equals(valueClassName)) {
                                    valueClass = short.class;
                                } else if ("int".equals(valueClassName)) {
                                    valueClass = int.class;
                                } else if ("long".equals(valueClassName)) {
                                    valueClass = long.class;
                                } else if ("float".equals(valueClassName)) {
                                    valueClass = float.class;
                                } else if ("double".equals(valueClassName)) {
                                    valueClass = double.class;
                                } else if ("char".equals(valueClassName)) {
                                    valueClass = char.class;
                                } else if ("boolean".equals(valueClassName)) {
                                    valueClass = boolean.class;
                                }
                            }

                            if ("doc_resources".equals(table.getNodeName())) {
                            } else if ("doc_metadata".equals(table.getNodeName())) {
                                String column = atts.getNamedItem("column").getNodeValue();
                                metadatas.put(column, value);
                            }
                        }
                    }
                    // 向不同的表保存元数据
                    if ("doc_resources".equals(tableName)) {
                    } else if ("doc_metadata".equals(tableName)) {
                        Set<String> keys = metadatas.keySet();
                        if (newFlag)
                            docMetadataManager.addMetadata(newId, metadatas);
                        else
                            docMetadataManager.updateMetadata(newId, metadatas);
                    }
                }// end of 有效表节�?
            }
        } catch (Exception e) {
            log.error("保存关联项目的元数据", e);
        }
    }

    /** 新建项目文档夹和项目阶段文档�?  */
    private Long createCaseFolder(String name, Long type, Long sourceId, Long docLibId, Long destFolderId, Long userId) {
        int minOrder = this.getMinOrder(destFolderId);
        DocResourcePO dr = new DocResourcePO();
        dr.setFrName(name);
        dr.setParentFrId(destFolderId);
        dr.setAccessCount(0);
        dr.setCommentCount(0);
        dr.setCommentEnabled(false);
        dr.setCreateTime(new Timestamp(new Date().getTime()));
        dr.setCreateUserId(userId);
        dr.setDocLibId(docLibId);
        dr.setIsFolder(true);
        dr.setSourceId(sourceId);
        dr.setSubfolderEnabled(true);
        dr.setFrOrder(minOrder - 1);
        dr.setFrSize(0);
        dr.setFrType(type);
        dr.setLastUpdate(new Timestamp(new Date().getTime()));
        dr.setLastUserId(userId);
        dr.setStatus(Byte.parseByte("2"));
        dr.setStatusDate(new Timestamp(new Date().getTime()));
        dr.setMimeTypeId(type);
        dr.setMimeOrder(docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getOrderNum());
        dr.setIsCheckOut(false);
        // 系统预定义类型的 mimeTypeId == docTypeId
        dr.setMimeTypeId(type);
        dr.setMimeOrder(docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getOrderNum());

        return docResourceDao.saveAndGetId(dr);
    }

    /**
     * 修改项目信息
     * 
     * @param summary
     *            要修改的项目summary
     * @param addPhases
     *            要新增的阶段
     * @param updatePhases
     *            要修改的阶段
     * @param delPhaseIds
     *            要删除的阶段id串，�? 1,2,3
     * @throws BusinessException 
     */
    public void updateProject(ProjectBO oldSummary, ProjectBO summary, List<ProjectPhaseBO> addPhases, List<ProjectPhaseBO> updatePhases,
            List<Long> deletePhaseIds, Long userId) throws BusinessException {
        DocResourcePO projectFolder = this.getProjectFolderByProjectId(summary.getId());
        if (projectFolder == null) {
            return;
        }
        Long projectFolderId = projectFolder.getId();
        // 修改DocResourcePO中保存的项目名称
        this.renameDocWithoutAcl(projectFolderId, summary.getProjectName(), userId);
        Node appNode = DocHierarchyManagerImpl.getNodesMap().get("project_data");
        if (appNode != null)
            this.saveProjectMetadata(projectFolderId, new ProjectSummaryDataBO(summary), appNode, false);

        //删除权限、订阅只针对修改前的项目人员
        List<Long> oldProjectMemberIds = oldSummary.getAllProjectMembers();
        List<ProjectMemberInfoBO> members = projectApi.findProjectMembers(summary.getId());
        //由于现阶段传递不了原来项目人员的人员集合（不是人员id集合），�?以不能根据人员类型进行筛选�?�采取先删除�?有权限，再新增权限的方式
        if (!oldProjectMemberIds.isEmpty()) {
        	docAclManager.deleteProjectFolderShare(projectFolderId, oldProjectMemberIds);
            docAlertManager.deleteProjectFolderAlert(projectFolder, oldProjectMemberIds);
        }
        if (!members.isEmpty()) {
            docAclManager.saveProjectAcl(members, userId, projectFolderId, summary.getId());
        }
        // 2. 增加项目阶段
        this.newProjectPhases(addPhases, projectFolder.getDocLibId(), projectFolder.getId(), userId);
        // 3. 修改项目阶段
        this.updateProjectPhases(updatePhases, userId);
        // 4. 删除项目阶段
        this.deleteProjectPhase(deletePhaseIds);
        //更新全文�?索，修改项目成员时调�?
        DocUtils.updateIndex(projectFolder, indexManager, this);
    }

    // 修改项目阶段
    private void updateProjectPhases(List<ProjectPhaseBO> updatePhases, Long userId) throws BusinessException {
        if (updatePhases == null)
            return;
        for (ProjectPhaseBO p : updatePhases) {
            DocResourcePO projectPhase = this.getProjectFolderByProjectId(p.getId(), true);
            if (projectPhase == null) {
                return;
            }

            this.renameDocWithoutAcl(projectPhase.getId(), p.getPhaseName(), userId);
            Node appNode = DocHierarchyManagerImpl.getNodesMap().get("project_phase_data");
            if (appNode != null)
                this.saveProjectMetadata(projectPhase.getId(), p, appNode, false);
        }
    }

    // 删除项目阶段
    @SuppressWarnings("unchecked")
    private void deleteProjectPhase(List<Long> deletePhaseIds) throws BusinessException {
        if (deletePhaseIds == null)
            return;
        for (int i = 0; i < deletePhaseIds.size(); i++) {
            // 1. 找到该项目阶段的文档�?
            DocResourcePO project = this.getProjectFolderByProjectId(deletePhaseIds.get(i), true);
            if (project == null) {
                return;
            }
            DocResourcePO detail = docMetadataManager.getDocResourceDetail(project.getId());
            // 2. 更改删除标记
            List<DocMetadataObjectPO> metadatas = detail.getMetadataList();
            Map params = new HashMap();
            for (DocMetadataObjectPO m : metadatas) {
                if (m.getPhysicalName().equals(Constants.FOLDER_CASE_PHASE_PHYSICAL_NAME_DELETE))
                    m.setMetadataValue(true);
                try {
                    params.put(m.getPhysicalName(),
                            Constants.getTrueTypeValue(m.getPhysicalName(), String.valueOf(m.getMetadataValue())));
                } catch (ParseException e) {
                    log.error("删除项目阶段", e);
                }
            }
            docMetadataManager.updateMetadata(project.getId(), params);
            // 直接删除项目阶段对应的文档夹，不管文档夹中是否有文档�?
            removeProjectFolderWithoutAcl(project.getSourceId());
        }
    }

    // 增加项目阶段
    private void newProjectPhases(List<ProjectPhaseBO> newPhases, Long docLibId, Long destFolderId, Long userId)
            throws BusinessException {
        if (newPhases == null)
            return;
        for (ProjectPhaseBO p : newPhases) {
            Long pid = this.createCaseFolder(p.getPhaseName(), Constants.FOLDER_CASE_PHASE, p.getId(), docLibId,
                    destFolderId, userId);
            Node appNode = DocHierarchyManagerImpl.getNodesMap().get("project_phase_data");
            if (appNode != null)
                this.saveProjectMetadata(pid, p, appNode, true);
        }
    }

    //删除项目 关联项目模块做了项目删除标记，文档也要做删除标记
    @SuppressWarnings("unchecked")
    public void deleteProject(Long summaryId) throws BusinessException {
        // 1. 找到该项目的文档�?
        DocResourcePO project = this.getProjectFolderByProjectId(summaryId);
        if (project == null) {
            return;
        }

        DocResourcePO detail = docMetadataManager.getDocResourceDetail(project.getId());
        // 2. 更改状�?�为删除标记
        List<DocMetadataObjectPO> metadatas = detail.getMetadataList();
        Map params = new HashMap();
        for (DocMetadataObjectPO m : metadatas) {
            if (m.getPhysicalName().equals(Constants.FOLDER_CASE_PHYSICAL_NAME_STATUS)) {
                m.setMetadataValue(ProjectBO.STATE_DELETE);
            }
            try {
                params.put(m.getPhysicalName(),
                        Constants.getTrueTypeValue(m.getPhysicalName(), String.valueOf(m.getMetadataValue())));
            } catch (ParseException e) {
                log.error("删除关联项目", e);
            }
        }
        docMetadataManager.updateMetadata(project.getId(), params);
    }

    public List<FolderItemDoc> getLatestDocsOfProject(Long projectId, Long phaseId, String orgids, boolean hasAcl)
            throws BusinessException {
        boolean isPhase = phaseId != TaskConstants.PROJECT_PHASE_ALL;
        DocResourcePO projectFolder = this.getProjectFolderByProjectId(isPhase ? phaseId : projectId, isPhase);
        if (projectFolder != null) {
            List<DocResourcePO> drs = this.docResourceDao.getDocsOfProjectPhase(projectFolder.getLogicalPath(), orgids,
                    hasAcl, null);

            if (CollectionUtils.isNotEmpty(drs)) {
                List<FolderItemDoc> ret = new ArrayList<FolderItemDoc>(drs.size());
                for (DocResourcePO dr : drs) {
                    FolderItemDoc doc = new FolderItemDoc(dr);
                    DocMimeTypePO mime = docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId());
                    if (mime != null)
                        doc.setIcon("/apps_res/doc/images/docIcon/" + mime.getIcon());
                    DocTypePO type = contentTypeManager.getContentTypeById(dr.getFrType());

                    String stype = "";
                    if (type != null)
                        stype = ResourceUtil.getString(type.getName());
                    doc.setType(stype);
                    ret.add(doc);
                }
                return ret;
            }
        }

        return null;
    }

    public List<FolderItemDoc> getLatestDocsOfProjectByCondition(String condition, Long projectId, Long phaseId,
            Map<String, String> paramMap, String orgids, boolean hasAcl) throws BusinessException {
        boolean isPhase = phaseId != TaskConstants.PROJECT_PHASE_ALL;
        DocResourcePO projectFolder = this.getProjectFolderByProjectId(isPhase ? phaseId : projectId, isPhase);
        if (projectFolder != null) {
            paramMap.put("condition", condition);
            List<DocResourcePO> drs = this.docResourceDao.getDocsOfProjectPhase(projectFolder.getLogicalPath(), orgids,
                    hasAcl, paramMap);

            if (CollectionUtils.isNotEmpty(drs)) {
                List<FolderItemDoc> ret = new ArrayList<FolderItemDoc>(drs.size());
                for (DocResourcePO dr : drs) {
                    FolderItemDoc doc = new FolderItemDoc(dr);
                    DocMimeTypePO mime = docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId());
                    if (mime != null)
                        doc.setIcon("/apps_res/doc/images/docIcon/" + mime.getIcon());
                    DocTypePO type = contentTypeManager.getContentTypeById(dr.getFrType());
                    String stype = "";
                    if (type != null)
                        stype = ResourceUtil.getString(type.getName());
                    doc.setType(stype);

                    ret.add(doc);
                }
                return ret;
            }
        }

        return null;
    }

    /**
     * 根据项目id得到项目文档�?
     */
    @SuppressWarnings("unchecked")
    public DocResourcePO getProjectFolderByProjectId(long projectId, boolean isPhase) {
        String hql1 = "from DocResourcePO where sourceId = ? and frType = ? and isFolder=true";
        List<DocResourcePO> list1 = this.docResourceDao.findVarargs(hql1, projectId, isPhase ? Constants.FOLDER_CASE_PHASE
                : Constants.FOLDER_CASE);
        if (Strings.isEmpty(list1)){
            return null;
        }
        return list1.get(0);
    }

    public DocResourcePO getProjectFolderByProjectId(long projectid) {
        return this.getProjectFolderByProjectId(projectid, false);
    }

    /**
     * 判断�?个项目或项目阶段文档夹下是否有文档（不算文档夹，不论层级�?
     */
    public boolean hasDocsInProject(long sourceId) {
        boolean ret = false;

        DocResourcePO dr = this.getDocResBySourceId(sourceId);
        if (dr == null)
            return ret;

        final List<Type> parameterTypes = new ArrayList<Type>();
        final List<Object> parameterValues = new ArrayList<Object>();

        parameterTypes.add(Hibernate.STRING);
        parameterValues.add(dr.getLogicalPath() + ".%");

        String hql = "from DocResourcePO where isFolder = false and logicalPath like ?";
        int total = this.docResourceDao.getQueryCount(hql, parameterValues.toArray(new Object[parameterValues.size()]),
                parameterTypes.toArray(new Type[parameterTypes.size()]));
        if (total > 0)
            return true;

        return ret;
    }
    
    public List<Long> findFolderAllChilds(DocResourcePO doc){
        String hql = "select doc.id from DocResourcePO doc where doc.isFolder = :isFolder and doc.logicalPath like :logicalPath";
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("isFolder", false);
        params.put("logicalPath", doc.getLogicalPath()+"%");
        return DBAgent.find(hql, params);
    }

    /**
     * 判断项目或项目阶段文档夹下是否有文档（不算文档夹，不论层级）,sourceIds ","分割项目或�?�项目阶段sourceID
     */
    public boolean hasDocsInProjects(String sourceIds) {
        boolean hasDoc = false;
        String[] sids = sourceIds.split(",");
        for (String sid : sids) {
            if (hasDocsInProject(Long.parseLong(sid))) {
                hasDoc = true;
                break;
            }
        }
        return hasDoc;
    }

    /**
     * 删除项目文档夹项目阶段文档夹
     */
    public void removeProjectFolderWithoutAcl(long sourceId) throws BusinessException {
        DocResourcePO dr = this.getDocResBySourceId(sourceId);
        if (dr == null)
            return;
        this.removeDocWithoutAcl(dr, AppContext.currentUserId(), true);
    }

    /** **************项目管理结束******************* */

    public DocLearningManager getDocLearningManager() {
        return docLearningManager;
    }

    public void setDocLearningManager(DocLearningManager docLearningManager) {
        this.docLearningManager = docLearningManager;
    }

    /**
     * 获取带有单位�?称的实体�?
     */
    public String getEntityNameWithAccountShort(String orgType, Long orgId) {
        return Constants.getOrgEntityName(orgType, orgId, true);
    }

    public DocResourcePO getDocResBySourceId(long sourceId) {
        String hql = "from DocResourcePO where sourceId = ?";
        return (DocResourcePO) this.docResourceDao.findUnique(hql, null, sourceId);
    }

    /**
     * 判断内容类型
     */
    public boolean contentTypeExist(long typeId) {
        return this.contentTypeManager.getContentTypeById(typeId) != null;
    }

    /**
     * Map<tempFolder, temp> Map<docResId, zipfile>
     */
    public static Map<String, File> downloadMap              = new HashMap<String, File>();

    public static final String      DOWNLOAD_TEMP_FOLDER_KEY = "tempFolder";

    public boolean docHistoryDownloadCompress(long docVersionId) {
        return this.downloadCompress(docVersionId, true);
    }

    /**
     * 将复合文档打包供用户下载
     * @param resId		资源ID：文档ID �? 历史版本信息ID
     * @param history	是否为历史版本文�?
     */
    private boolean downloadCompress(long resId, boolean history) {
        DocResourcePO dr = null;
        DocBodyPO docBody = null;
        if (!history) {
            dr = this.getDocResourceById(resId);
            docBody = this.getBody(resId);
        } else {
            DocVersionInfoPO dvi = this.docVersionInfoManager.getDocVersion(resId);
            dr = dvi.getDocResourceFromXml();
            docBody = dvi.getDocBodyFromXml();
        }
        String bodyType = "HTML";
        if (docBody != null) {
            bodyType = docBody.getBodyType();
        }
        String sSrcName = dr.getFrName();
        sSrcName = Constants.dealUnChar(sSrcName);
        String srcName = sSrcName;
        String filename = srcName + ".html";
        String sysTemp = SystemEnvironment.getSystemTempFolder();
        String docTemp = sysTemp + "/doctemp/";
        File temp = new File(docTemp);
        temp.mkdir();
        List<File> files = new ArrayList<File>();
        if ("HTML".equals(docBody.getBodyType())) {
           String  content = DocUtils.parseBodyContent(docBody.getContent(), temp, files, fileManager);
           docBody.setContent(content);
        }
        String inner = this.getInnerOfDocResource(dr, docBody);
        downloadMap.put(DOWNLOAD_TEMP_FOLDER_KEY, temp);
        // 保存正文中的图片的名�? Map<fileUrl, fileName>
        Map<String, String> imgName = new HashMap<String, String>();

        /** ********************** 附件下载�?�? ********************************* */
        
        List<Attachment> atts = attachmentManager.getByReference(resId);
        for (Attachment att : atts) {
            if (att.getFileUrl() == null) {
                continue;
            }
            imgName.put(att.getFileUrl() + "", att.getFilename());
            OutputStream tout = null;
            InputStream tin = null;
            try {
                tout = new FileOutputStream(docTemp + att.getFilename());
                tin = fileManager.getFileInputStream(att.getFileUrl());
                if (tin == null) {
                    tout.close();
                    continue;
                }
                CoderFactory.getInstance().download(tin, tout);
            } catch (FileNotFoundException e1) {
                log.error("复合文档下载", e1);
            } catch (BusinessException e1) {
                log.error("复合文档下载", e1);
            } catch (IOException e1) {
                log.error("复合文档下载", e1);
            } catch (Exception e1) {
                log.error("复合文档下载", e1);
            }
            try {
                if (tin != null) {
                    tin.close();
                }
            } catch (Exception e) {
                log.error("复合文档下载", e);
            } finally {
                try {
                    if (tout != null) {
                        tout.close();
                    }
                } catch (Exception e) {
                    log.error("复合文档下载", e);
                }
            }
            files.add(new File(docTemp + att.getFilename()));
        }
        /** ********************** 附件下载结束 ********************************* */

        try {
            int first = inner.indexOf("<img border=");
            while (first != -1) {
                int onload = inner.indexOf("onload", first);
                if (onload != -1) {
                    inner = inner.replace(inner.substring(onload, onload + 27), "");
                }
                int src = inner.indexOf("src", first);
                int srcend = inner.indexOf("\"", src + 6);
                int fileId = inner.indexOf("fileId", src);
                int fileIdEnd = inner.indexOf("&amp", fileId);
                String strSrc = inner.substring(src + 5, srcend);
                String theName = imgName.get(inner.substring(fileId + 7, fileIdEnd));
                inner = inner.replace(strSrc, theName);
                int end = inner.indexOf(">", src);
                first = inner.indexOf("<img border=", end);
            }
        } catch (Exception e) {
            log.error("复合文档下载", e);
        }

        /**
         * *********************** word, excel格式文件的下载开�?
         * ***************************
         */
        if (!"HTML".equals(bodyType)) {
            Long fileId = Long.valueOf(docBody.getContent());
            File bodyFile = null;
            String bodyFileName = srcName;
            if(dr.getSourceId() != null){
            	bodyFileName = srcName.substring(0,srcName.lastIndexOf("."));
            }
            try {
                bodyFile = fileManager.getStandardOffice(fileId, dr.getLastUpdate());
            } catch (BusinessException e1) {
                log.error("复合文档下载", e1);
            }
            if (bodyFile != null) {
                if (com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_WORD.equals(bodyType)) {
                    // FileManager的标准转�?
                    bodyFileName += ".doc";
                } else if (com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_OFFICE_EXCEL.equals(bodyType)) {
                    bodyFileName += ".xls";
                } else if (com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_WPS_WORD.equals(bodyType)) {
                    bodyFileName += ".wps";
                } else if (com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_WPS_EXCEL.equals(bodyType)) {
                    bodyFileName += ".et";
                }
                OutputStream bodyout = null;
                InputStream bodyin = null;
                try {
                    bodyout = new FileOutputStream(docTemp + bodyFileName);
                    bodyin = new FileInputStream(bodyFile);
                    IOUtils.copy(bodyin, bodyout);
                    bodyout.flush();
                } catch (FileNotFoundException e1) {
                    log.error("复合文档下载", e1);
                } catch (IOException e1) {
                    log.error("复合文档下载", e1);
                }
                try {
                    if (bodyin != null) {
                        bodyin.close();
                    }
                } catch (Exception e) {
                    log.error("复合文档下载", e);
                } finally {
                    try {
                        if (bodyout != null) {
                            bodyout.close();
                        }
                    } catch (Exception e) {
                        log.error("复合文档下载", e);
                    }
                }
                files.add(new File(docTemp + bodyFileName));
            }

        }

        /**
         * *********************** word, excel格式文件的下载结�?
         * ***************************
         */

        /** ********************** 正文下载�?�? ********************************* */
        PrintWriter out1 = null;
        try {
            out1 = new PrintWriter(new OutputStreamWriter(new FileOutputStream(docTemp + filename), "utf-8"));
            IOUtils.write(inner, out1);
            out1.flush();
        } catch (FileNotFoundException e1) {
            log.error("复合文档下载", e1);
        } catch (IOException e1) {
            log.error("复合文档下载", e1);
        }
        try {
            if (out1 != null) {
                out1.close();
            }
        } catch (Exception e) {
            log.error("复合文档下载", e);
        }
        files.add(new File(docTemp + filename));
        /** ********************** 正文下载结束 ********************************* */
        File zipFile = null;
        try {
            zipFile = CompressUtil.zip(docTemp + srcName, files);
            downloadMap.put(resId + "", zipFile);
        } catch (Exception e) {
            log.error("复合文档下载压缩", e);
        }

        /** **************** 删除临时文件�?�? *********************** */
        for (File f : files) {
            try {
                f.delete();
            } catch (Exception e) {
                log.error("删除临时文件", e);
            }
        }

        /** **************** 删除临时文件结束 *********************** */

        return (zipFile != null);
    }

    public boolean docDownloadCompress(long docResourceId) {
        return this.downloadCompress(docResourceId, false);
    }

    private String getInnerOfDocResource(DocResourcePO dr, DocBodyPO body) {
        String frName = dr.getFrName();
        String inner = "<html><head><title>";
        inner += frName;
        inner += "</title>";
        inner +="<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /></head><body><table width='100%' cellpadding='0' cellspacing='0'><tr><td style='padding: 10px 20px;'><table width='100%' cellpadding='0' cellspacing='0' style='border: solid 1px #999999; '><tr><td height='30'><div id=\"propDiv\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" height=\"5%\" align=\"center\">";
        inner += "<tr><td height=\"10\" style=\"repeat-x;background-color: f6f6f6;\"><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" align=\"center\">";

        inner += "<tr><td width=\"90\" height=\"28\" nowrap style=\"text-align: right;	padding-right: 5px;	font-size: 12px;height: 24px; padding-top: 10px;\">";
        inner += ResourceUtil.getString("doc.jsp.open.body.name") + ": ";
        inner += "</td>	<td style=\"padding-top: 10px; font-size: 12px;\">";
        inner += frName;
        inner += "</td></tr>";

        inner += "<tr><td width=\"90\" height=\"28\" nowrap style=\"text-align: right;	padding-right: 5px;	font-size: 12px;height: 24px; padding-top: 10px;\">";
        inner += ResourceUtil.getString("doc.metadata.def.creater") + ": ";
        inner += "</td>	<td style=\"padding-top: 10px; font-size: 12px;\">";
        inner += Constants.getOrgEntityName("Member", dr.getCreateUserId(), false) + " ("
                + Datetimes.formateToLocaleDatetime(dr.getCreateTime()) + ")";
        inner += "</td></tr>";

        inner += "</table></td></tr><tr><td height=\"5\" style=\" repeat-x;	background-color: #f6f6f6;\"></td></tr></table></div></td> </tr> <tr> <td valign='top'> ";
        inner += "<div id=\"bodyDiv\"><table width=\"100%\" border=\"0\" height=\"10%\" cellspacing=\"0\" cellpadding=\"0\" style=\"\"><tr>";
        inner += "<td style=\" repeat-y;	width: 20px;\"><img src=\"\" height=\"1\" width=\"20px\"></td> <td align=\"center\" style='padding: 20px 0px;'><div style='text-align: left;' id=\"\">";

        String trueBody = "";
        if ("HTML".equals(body.getBodyType()) && Strings.isNotBlank(body.getContent())) {
            trueBody = body.getContent();
        }
        inner += trueBody;
        inner += "</div></td> <td style=\" repeat-y;width: 20px;\"><img src=\"\" height=\"1\" width=\"20px\"></td></tr></table></div></td> </tr> </table>";
        inner += "</td></tr></table></body></html>";

        return inner;
    }

    public List<DocResourcePO> iSearch(ConditionModel cModel, DocTypePO docType) throws BusinessException {
        Long docLibId = cModel.getDocLibId();
        long userId = cModel.getUser().getId();

        List<DocResourcePO> listDocs = docResourceDao.iSearch(cModel, docType);
        DocLibPO lib = this.docUtils.getDocLibById(docLibId);
        if (lib.isPersonalLib()) {
            return CommonTools.pagenate(listDocs);
        } else {
            DocResourcePO parent = this.getRootByLibId(docLibId);
            if (parent == null) {
                return null;
            }
            String aclIds = Constants.getOrgIdsOfUser(userId);
            Integer pageNo = 0;
            Integer first = Pagination.getFirstResult();
            Integer pageSize = Pagination.getMaxResults();
            pageNo = first / pageSize + 1;
            List<DocResourcePO> list = docAclManager.getResourcesByConditionAndPotentPage(false,listDocs, parent, aclIds);
            return list;
        }
    }

    /**
     * 综合查询(归档�?)
     * @throws BusinessException 
     */
    public List<DocResourcePO> iSearchPiged(ConditionModel cModel, DocTypePO docType) throws BusinessException {
        Long docLibId = cModel.getDocLibId();
        long userId = AppContext.currentUserId();
        DocLibPO lib = this.docUtils.getDocLibById(docLibId);
        List<DocResourcePO> list = new ArrayList<DocResourcePO>();
        Map<Object, Object> params = new HashMap<Object, Object>();
        Map<Long, String> idPathMap = new HashMap<Long, String>();
        String sql = this.getQueryString4ISearchPiged(cModel, docType,params);
        List lists = DBAgent.find(sql,params);
        Iterator itr = lists.iterator();
        while (itr.hasNext()) {
        	Object[] nextObj = (Object[])itr.next();
        	idPathMap.put((Long)nextObj[0],(String) nextObj[1]);
        }
        if (idPathMap.isEmpty()) {
            return list;
        }
        Integer pageNo = 0;
        Integer first = Pagination.getFirstResult();
        Integer pageSize = Pagination.getMaxResults();
        pageNo = first / pageSize + 1;
        if (lib.getType() == Constants.PERSONAL_LIB_TYPE.byteValue()) {
            List<Long> idList = new ArrayList<Long>(idPathMap.keySet());
            idList = CommonTools.pagenate(idList);
            list = docResourceDao.getDocsByIds(idList);
        } else {
            String aclIds = Constants.getOrgIdsOfUser(userId);
            list = docAclManager.getResourcesByConditionAndPotentPageNoDr(idPathMap, aclIds, pageNo, pageSize);
        }
        return list;
    }

    private String getQueryString4ISearchPiged(ConditionModel cModel, DocTypePO docType, Map<Object, Object> params) {
            StringBuilder sb = new StringBuilder("select d.id, d.logicalPath from DocResourcePO d, DocMetadata m ");
            boolean isColPiged = String.valueOf(ApplicationCategoryEnum.collaboration.key()).equals(cModel.getAppKey());
            // 协同�?关联Affair�?
            if (isColPiged) {
                sb.append(", CtpAffair a");
            }
            sb.append(" where d.id = m.docResourceId and d.docLibId = ").append(":docLibId");
            if(isColPiged){
            	sb.append(" and d.frType in (1,9) ");
            }else{
            	sb.append(" and d.frType = ").append(":frType");
            	params.put("frType", docType.getId());
            }
            params.put("docLibId", cModel.getDocLibId());
            if (Strings.isNotBlank(cModel.getTitle())) {
            	sb.append(" and d.frName like ").append(":frName");
                params.put("frName", "%" + SQLWildcardUtil.escape(cModel.getTitle()) + "%");
            }
            if (Strings.isNotBlank(cModel.getKeywords())) {
            	sb.append(" and d.keyWords like ").append(":keyWords");
                params.put("keyWords", "%" + SQLWildcardUtil.escape(cModel.getKeywords()) + "%");
            }
            if (isColPiged) {
                sb.append(" and d.sourceId = a.id and a.app=1 and a.state in(:states");
                List<Integer> states = new ArrayList<Integer>();
                if (cModel.getFromUserId() != null && cModel.getToUserId() == null) {
                    states.add(StateEnum.col_sent.key());
                } else {
                    states.add(StateEnum.col_pending.key());
                    states.add(StateEnum.col_done.key());
                }
                params.put("states", states);
                sb.append(") and a.delete!=1 and a.memberId=:memberId");
                params.put("memberId", AppContext.currentUserId());
                if (cModel.getFromUserId() != null && cModel.getToUserId() != null) {
                    sb.append(" and m.reference1 =:reference1 ");
                    params.put("reference1", cModel.getFromUserId());
                }
            } else {
                boolean isBbsPiged = String.valueOf(ApplicationCategoryEnum.bbs.key()).equals(cModel.getAppKey());
                boolean isNewsPiged = String.valueOf(ApplicationCategoryEnum.news.key()).equals(cModel.getAppKey());
                boolean isInquiryPiged = String.valueOf(ApplicationCategoryEnum.inquiry.key()).equals(cModel.getAppKey());
                boolean isBulletinPiged = String.valueOf(ApplicationCategoryEnum.bulletin.key()).equals(cModel.getAppKey());
                if(isBbsPiged || isNewsPiged ||isInquiryPiged ||isBulletinPiged){
                    
                }else{
                    sb.append(" and m.reference1 =:reference1 ");
                    params.put("reference1", AppContext.currentUserId());
                }
            }
        if (cModel.getBeginDate() != null) {
            sb.append(" and m.date1 >= :beginDate");
            params.put("beginDate", cModel.getBeginDate());
        }

        if (cModel.getEndDate() != null) {
            sb.append(" and m.date1 <= :endDate");
            params.put("endDate", cModel.getEndDate());
        }
        return sb.toString();
    }

    /**
     * 根据id串得到多个docResource
     */
    public List<DocResourcePO> getDocsByIds(String ids) {
        if (Strings.isBlank(ids)) {
            return new ArrayList<DocResourcePO>();
        }
        return getDocsByIds(Constants.parseStrings2Longs(ids, ","));
    }

    /**
     * 根据id集合得到多个docResource
     */
    @Override
    public List<DocResourcePO> getDocsByIds(Collection<Long> ids) {
    	List<DocResourcePO> docResourceList = new ArrayList<DocResourcePO>();
        if (Strings.isNotEmpty(ids)) {
            String hql = "from DocResourcePO where id in(:docIds)";
            Map<String, Object> params = new HashMap<String, Object>();
            if( ids.size() > 999){
            	List<Long> docIds = new ArrayList<Long>();
            	docIds.addAll(ids);
    			List<Long>[] id = Strings.splitList(docIds, 1000);
    			for (int i = 0; i < id.length; i++) {
    				params.put("docIds", id[i]);
    				List<DocResourcePO> result = docResourceDao.find(hql, -1, -1, params);
    				docResourceList.addAll(result);
    			}
            }else{
            	params.put("docIds", ids);
            	docResourceList = docResourceDao.find(hql, -1, -1, params);
            }
        }
        return docResourceList;
    }

    /**
     * 判断�?个人是否正在查看别人（个人）借阅给自己的文档
     */
    public boolean isViewPerlBorrowDoc(long memberId, long docResId) {
        List<DocAcl> list = docAclManager.getAclList(docResId, Constants.SHARETYPE_PERSBORROW);
        if (Strings.isEmpty(list)) {
            return false;
        } else {
            for (DocAcl da : list) {
                if (da.getUserId() == memberId) {
                    return true;
                }
            }
        }
        return false;
    }

    public DocUtils getDocUtils() {
        return docUtils;
    }

    public void setDocUtils(DocUtils docUtils) {
        this.docUtils = docUtils;
    }

    /**
     * 找到某个父文档夹的所有一级子节点
     */
    public List<DocResourcePO> getAllFirstChildren(long parentId) {
        String hql = "from DocResourcePO where parentFrId = ?";
        return this.docResourceDao.findVarargs(hql, parentId);
    }

    /**
     * 初始�?
     * 
     */
    public void init() {
        initPigeonhole();
        // �?查格式类型的排序字段
        int invlidCount = this.docResourceDao.getQueryCount("from DocResourcePO where mimeOrder = 0", null, null);
        if (invlidCount > 0) {
            String hql = "update DocResourcePO set mimeOrder = ? where mimeTypeId = ?";
            log.info("更新文档的排序字段开始�?��?��??");
            for (DocMimeTypePO dmt : com.seeyon.apps.doc.manager.DocMimeTypeManagerImpl.docMimeTypeTable.values()) {
                this.docResourceDao.bulkUpdate(hql, null, dmt.getOrderNum(), dmt.getId());
            }
            log.info("更新文档的排序字段结束�??");
        }
    }

    /**
     * 记录转发协同、邮件的日志
     */
    public void logForward(String isMail, Long docResourceId) {
        if (Strings.isBlank(isMail) || docResourceId == null) {
            return;
        }
        DocResourcePO dr = this.getDocResourceById(docResourceId);
        if (dr == null) {
            return;
        }
        if (this.isPersonalLib(dr.getDocLibId())) {
            return;
        }
        String typeKey = "doc.contenttype.xietong";
        long uId = AppContext.currentUserId();
        boolean hasMail = false;
        try {
            if (webmailApi.hasDefaultMbc(uId)) {
                hasMail = true;
            }
        } catch (Exception e1) {
            log.error("调用邮件接口判断当前用户是否有邮箱设置：", e1);
        }

        if ("true".equals(isMail)) {
            typeKey = "doc.contenttype.mail";
            String typeValue = ResourceUtil.getString(typeKey);

            // 记录操作日志
            if (hasMail == true)
                operationlogManager.insertOplog(docResourceId, dr.getParentFrId(), ApplicationCategoryEnum.doc,
                        ActionType.LOG_DOC_FORWARD, ActionType.LOG_DOC_FORWARD + ".desc", AppContext.currentUserName(),
                        typeValue, dr.getFrName());
        } else {
            String typeValue = ResourceUtil.getString(typeKey);
            operationlogManager.insertOplog(docResourceId, dr.getParentFrId(), ApplicationCategoryEnum.doc,
                    ActionType.LOG_DOC_FORWARD, ActionType.LOG_DOC_FORWARD + ".desc", AppContext.currentUserName(),
                    typeValue, dr.getFrName());
        }
    }

    @Deprecated
    public boolean lockState(long docid, boolean locked) {
        DocResourcePO dr = this.docResourceDao.get(docid);
        if (dr == null) {
            return false;
        }
        if (dr.getIsCheckOut()) {
            return locked;
        } else {
            return !locked;
        }
    }

    public Long getParentFrIdByResourceId(Long docResourceId) {
        DocResourcePO res = this.getDocResourceById(docResourceId);
        if (res != null) {
            return res.getParentFrId();
        }
        return null;
    }

    public void setDocFromPotentDao(DocFromPotentDao docFromPotentDao) {
        this.docFromPotentDao = docFromPotentDao;
    }

    public void deleteDocByResources(List<Long> resourceIds, Long userId) throws BusinessException {
        List<DocResourcePO> docs = this.docResourceDao.getDocsBySourceId(resourceIds);
        for (DocResourcePO doc : docs) {
            Long did = doc.getId();
            docAlertLatestManager.addAlertLatest(doc, Constants.ALERT_OPR_TYPE_DELETE, userId, new Date(
                    new Date().getTime()), Constants.DOC_MESSAGE_ALERT_DELETE_DOC, null);
            removeDocWithoutAcl(doc, userId, true);
            operationlogManager.insertOplog(did, doc.getParentFrId(), ApplicationCategoryEnum.doc,
                    ActionType.LOG_DOC_REMOVE_DOCUMENT, ActionType.LOG_DOC_REMOVE_DOCUMENT + ".desc",
                    AppContext.currentUserName(), doc.getFrName());
        }
    }

    public List<DocResourcePO> findSubFolderDocs(Long id) {
        return this.docResourceDao.getSubDocResources(id);
    }

    public DocResourcePO getDocByType(long libId, long type) {
        Map<String, Object> nameParameters = new HashMap<String, Object>();
        String hql = "from DocResourcePO as dr where dr.docLibId= :lid and dr.frType = :tp";
        nameParameters.put("lid", libId);
        nameParameters.put("tp", type);
        return (DocResourcePO) docResourceDao.findUnique(hql, nameParameters);
    }

    public void recoidopertionLog(String fileid, String logType, boolean history) {
        if (Strings.isBlank(fileid) || Strings.isBlank(logType)) {
            return;
        }
        try {
            DocResourcePO dr = null;
            String versionInfo = "";
            if (history) {
                DocVersionInfoPO dvi = this.docVersionInfoManager.getDocVersion(NumberUtils.toLong(fileid));
                if (dvi != null) {
                    dr = dvi.getDocResourceFromXml();
                    versionInfo = "[" + Constants.getDocI18nValue("doc.menu.history.label") + " - V" + dvi.getVersion()
                            + ".0]";
                }
            } else {
                dr = this.getDocResourceById(Long.valueOf(fileid));
            }
            if (dr == null) {
                return;
            }
            Long userId = AppContext.currentUserId();
            if(!history && !userId .equals(dr.getCreateUserId())){
                if ("downLoadFile".equals(logType)) {
                    try {
                        docActionManager.insertDocAction(userId,AppContext.currentAccountId(), 
                        		new Date(), DocActionEnum.download.key(), dr.getId(), "download");
                        dr.setDownloadCount(dr.getDownloadCount()+1);
                        this.docResourceDao.update(dr);
                    } catch (KnowledgeException e) {
                        log.error("", e);
                    }
                    
                }
                if ("docPrint".equals(logType)) {
                    try {
                        docActionManager.insertDocAction(userId,AppContext.currentAccountId(), 
                        		new Date(), DocActionEnum.print.key(), dr.getId(), "print");
                    } catch (KnowledgeException e) {
                        log.error("", e);
                    }
                }
            }
            if(!history && userId .equals(dr.getCreateUserId())) {
            	if ("downLoadFile".equals(logType)) {
            		dr.setDownloadCount(dr.getDownloadCount()+1);
                    this.docResourceDao.update(dr);
            	}
            }
            DocLibPO docLib = this.docUtils.getDocLibManager().getDocLibById(dr.getDocLibId());
            if (docLib == null) {
                return;
            }
            if (docLib.getDownloadLog() != null && docLib.getDownloadLog() && "downLoadFile".equals(logType)) {
                this.operationlogManager.insertOplog(dr.getId(), dr.getParentFrId(), ApplicationCategoryEnum.doc,
                        ActionType.LOG_DOC_DOWNLOAD, ActionType.LOG_DOC_DOWNLOAD + ".desc",
                        AppContext.currentUserName(), dr.getFrName() + versionInfo);
            }
            if (docLib.getPrintLog() != null && docLib.getPrintLog() && "docPrint".equals(logType)) {
                this.operationlogManager.insertOplog(dr.getId(), dr.getParentFrId(), ApplicationCategoryEnum.doc,
                        ActionType.LOG_DOC_PRINT, ActionType.LOG_DOC_PRINT + ".desc", AppContext.currentUserName(),
                        dr.getFrName() + versionInfo);
            }
        } catch (Exception e) {
            log.error("记录文档操作日志时�?�出现问�?", e);
        }
    }

    public void recoidopertionLog(String fileid, String logType) {
        this.recoidopertionLog(fileid, logType, false);
    }

    public boolean checkDocResourceIsSystem(String typeId, String docResId) throws BusinessException {
        if (Strings.isNotBlank(typeId)) {
            DocTypePO contentType = contentTypeManager.getContentTypeById(Long.valueOf(typeId));
            if (contentType != null) {
                Set<DocTypeDetailPO> typeDetailes = contentType.getDocTypeDetail();
                if (typeDetailes != null) {
                    for (DocTypeDetailPO docTypeDetail : typeDetailes) {
                        if (!docTypeDetail.getNullable()) {
                            return true;
                        }
                    }
                }
                return false;
            }
        }
        return false;
    }

    /**
     * 通过文档的id获得sourceId
     */
    public Long getDocResSourceId(Long docResId) {
        Long sourceId = this.docResourceDao.get(docResId).getSourceId();
        if (sourceId == null) {
            return -1L;
        }
        return sourceId;
    }

    public void saveOrder(List<DocResourcePO> docList, List<Integer> frOrderList) {
        if (docList != null && docList.size() > 0 && frOrderList != null && frOrderList.size() > 0
                && docList.size() == frOrderList.size()) {
            for (int i = 0; i < docList.size(); i++) {
                DocResourcePO doc = docList.get(i);
                doc.setFrOrder(frOrderList.get(i));
                this.docResourceDao.update(doc);
            }
        }

    }

    public boolean judgeSamePigeonhole(Long docResId, Integer appEnumKey, String colIds) {
    	List<Long> srIds = CommonTools.parseStr2Ids(colIds);
        return judgeSamePigeonhole(docResId,appEnumKey,srIds);
    }
    public boolean judgeSamePigeonhole(Long docResId, Integer appEnumKey, List<Long> colIds) {
    	Long contentId = Constants.getContentTypeIdByAppEnumKey(appEnumKey);
    	if (contentId != null && (
    			contentId == ApplicationCategoryEnum.collaboration.key()//协同
    			|| appEnumKey == ApplicationCategoryEnum.edoc.key() //公文
    			|| appEnumKey == ApplicationCategoryEnum.form.key() //表单
    			|| contentId==Constants.SYSTEM_INFO)) {
    		if (CollectionUtils.isNotEmpty(colIds)) {
    			return this.docResourceDao.judgeSamePigeonhole(docResId, contentId, colIds);
    		}
    	}
    	return false;
    }

    /**
     * 获取文件的正文内容，以便用户在文档中心点击文件时，可以直接查看其内容<br>
     * @param fileId
     * @see com.seeyon.apps.doc.controller.DocController#docOpenBody
     */
    public String getTextContent(Long fileId) {
        String result = null;
        try {
            File f = this.fileManager.getFile(fileId);
            result = CoderFactory.getInstance().getFileToString(f.getAbsolutePath());
        } catch (BusinessException e) {
            log.warn("文件Id=" + fileId + "不存�?", e);
        } catch (Exception e) {
            log.error("解密读取文件内容时出现异常，文件Id=" + fileId, e);
        }
        return result;
    }

    public List<DocSortProperty> getDocSortTable(List<DocResourcePO> docs) {
        List<DocSortProperty> sortProperty = new ArrayList<DocSortProperty>();
        
        List<DocMetadataDefinitionPO> dmds = null;
        String edocNumName = "";
        String edocInNumName = "";
        for (DocResourcePO doc : docs) {
            DocSortProperty property = new DocSortProperty();
            property.setId(doc.getId());//复�?�框的�??
            //设置图标
            DocMimeTypePO mime = this.docMimeTypeManager.getDocMimeTypeById(doc.getMimeTypeId());
            String icon = mime.getIcon();
            if (icon.contains("|")) {
                icon = icon.split("\\|")[0];
            }
            property.setDocImageType(icon);

            //设置名称
            property.setDocName(ResourceUtil.getString(doc.getFrName()));
            
            property.setFrType(doc.getFrType());

            //设置内容类型
            DocTypePO type = this.contentTypeManager.getContentTypeById(doc.getFrType());
            property.setDocContentType(type.getName());

            //设置创建�?
            try {
                V3xOrgMember member = this.orgManager.getMemberById(doc.getCreateUserId());
                property.setDocCreater(member == null ? "" : member.getName());
            } catch (BusinessException e) {
                log.error("获取文档排序列表的创建人数据时出错！");
            }

            //设置�?后修改时�?
            property.setDocLastUpdateDate(doc.getLastUpdate());
            DocLibPO docLibById = docLibManager.getDocLibById(doc.getDocLibId());
        	if (docLibById.getType() == Constants.EDOC_LIB_TYPE) {
        		if (dmds == null) {
        			dmds = docLibManager.getListColumnsByDocLibId(doc.getDocLibId(),Constants.All_EDOC_ELMENT);
        		}
        		if (Strings.isBlank(edocNumName) || Strings.isBlank(edocInNumName)) {
        			for (DocMetadataDefinitionPO dmd : dmds) {
        				if (dmd.getId().equals(131L)) {
        					edocNumName = dmd.getPhysicalName();
        				}
        				if (dmd.getId().equals(132L)) {
        					edocInNumName = dmd.getPhysicalName();
        				}
        			}
        		}
        		
        		Long docResId = -1L;
        		if (Constants.LINK == doc.getFrType()) {
        			docResId = doc.getSourceId();
        		} else {
        			docResId = doc.getId();
        		}
        		property.setEdocNumber(this.getDocMetadatasValue(docResId, edocNumName));
        		property.setEdocInNumber(this.getDocMetadatasValue(docResId, edocInNumName));
        	}
            sortProperty.add(property);//封装
        }
        return sortProperty;
    }
    
    private String getDocMetadatasValue (Long docResId,String metaDataName) {
    	Map docMetadataMap = this.docMetadataManager.getDocMetadataMap(docResId);
    	Object object = docMetadataMap.get(metaDataName);
    	return object != null ? String.valueOf(object) : "";
    }

    /**
     * 对文档的4种排序统�?成一个方法，Modify By Fanxc
     * @param docResId : �?要排序的文档的主键id
     * @param sortType:操作类型，即 upwards（上移） 、downwards（下移）、top（置顶）、end（末页）
     */
    public boolean sort(Long docResId, String sortType) {
        boolean result = true;
        DocResourcePO doc = this.getDocResourceById(docResId);
        int order = doc.getFrOrder();//讲需要排序的文档的序号记录下来，后面用到
        String sortLogicChar = "";
        if ("upwards".equals(sortType) || "top".equals(sortType)) {
            sortLogicChar = "<";
        } else if ("downwards".equals(sortType) || "end".equals(sortType)) {
            sortLogicChar = ">";
        }
        if ("upwards".equals(sortType) || "downwards".equals(sortType)) {
            result = this.singleSort(doc, sortLogicChar, order);
        } else if ("top".equals(sortType) || "end".equals(sortType)) {
            result = this.listSort(doc, sortLogicChar, order);
        }
        return result;
    }

    /**
     * 文档的上移或者下移，此时只针对两条数据更新数据库
     * @param doc：需要上移或者下移的文档
     * @param sortLogicChar：�?�辑符号，即"<"（上移）  ">"（下移）
     * @param order：需要上移或者下移的文档的排序号，应该是update之前的排序号
     */
    private boolean singleSort(DocResourcePO doc, String sortLogicChar, int order) {
        DocResourcePO changedObj = this.getDocByOrderType(doc.getParentFrId(), order, sortLogicChar);
        if (changedObj == null) {
            return false;
        }
        int changedOrder = changedObj.getFrOrder();
        doc.setFrOrder(changedOrder);
        this.docResourceDao.update(doc);
        changedObj.setFrOrder(order);
        this.docResourceDao.update(changedObj);
        return true;
    }

    /**
     * 文档的置顶或者末�?
     * @param doc：需要置顶或者末页的文档
     * @param sortLogicChar：：逻辑符号，即"<"（置顶）  ">"（末页）
     * @param order：：被操作文档的排序号，应该是update之前的排序号
     * @author Fanxc
     */
    private boolean listSort(DocResourcePO doc, String sortLogicChar, int order) {
        List<DocResourcePO> docList = this.getAllPreOrderByParentId(doc.getParentFrId(), order, sortLogicChar);
        if (Strings.isEmpty(docList)) {
            return false;
        }
        doc.setFrOrder(docList.get(0).getFrOrder());
        this.docResourceDao.update(doc);
        for (int i = 0; i < docList.size(); i++) {
            DocResourcePO tempPre = docList.get(i);//拿到当前的文�?
            if (i == docList.size() - 1) {//当是�?后一个文档时，就只需要把它的order号设置成我们选择的文档order即可
                tempPre.setFrOrder(order);//此处�?要注意，应该用之前保存的序号，�?�不能直接用doc.getFrOrder()，因为这时已经改�?
            } else {
                DocResourcePO tempNext = docList.get(i + 1);//取得它后面的那个文档
                tempPre.setFrOrder(tempNext.getFrOrder());//排序号依次后�?
            }
            this.docResourceDao.update(tempPre);
        }
        return true;
    }

    /**
     * 得到�?有在此文档排序号之前的文�?
     * @param parentId:文档夹id
     * @param order:文档的排序号,以此为根据查�?
     * @param orderType:如果�?">"，则是在其后面显示的对象 �? 如果�?"<"，则是在其前面显示的对象
     * @author Fanxc
     */
    @SuppressWarnings("unchecked")
    private List<DocResourcePO> getAllPreOrderByParentId(Long parentId, int order, String orderType) {
        List<DocResourcePO> orderList = new ArrayList<DocResourcePO>();

        /**
         * 此处中sql的条件主要是排除系统自定义的�?些文档，限制到我们新建或者上传的
         * 并没有对权限进行限制，因为只有文档夹的管理员才可以进行�?�排序�?�的操作，管理员拥有�?有权�?
         */
        StringBuilder buffer = new StringBuilder("from DocResourcePO as d where d.parentFrId=? and d.frOrder ");
        buffer.append(orderType);
        buffer.append(" ? ").append(DocSearchHqlUtils.HQL_FR_TYPE).append("order by d.frOrder");
        if (">".equals(orderType)) {
            buffer.append(" desc");
        }
        Object[] indexParam = { parentId, order };
        orderList = docResourceDao.find(buffer.toString(), -1, -1, null, indexParam);
        return orderList;
    }

    public boolean isNeedSort(Long docResId, String sortType) {
        DocResourcePO doc = this.getDocResourceById(docResId);
        String sortLogicChar = "";
        if ("upwards".equals(sortType) || "top".equals(sortType)) {
            sortLogicChar = "<";
        } else if ("downwards".equals(sortType) || "end".equals(sortType)) {
            sortLogicChar = ">";
        }
        DocResourcePO changedObj = this.getDocByOrderType(doc.getParentFrId(), doc.getFrOrder(), sortLogicChar);
        if (changedObj == null) {
            return false;
        }
        return true;
    }

    public List<DocResourcePO> findAllDocsByPage(boolean isNewView,Long parentId, Long contentType, Long userId, int flag)
            throws BusinessException {
        Integer first = Pagination.getFirstResult();
        if(isNewView){
        	Pagination.setMaxResults(30);
        }
        Integer pageSize = Pagination.getMaxResults();
        Integer pageNo = first / pageSize + 1;
        List<DocResourcePO> list = this.findAllDocsByPage(parentId, contentType, pageNo, pageSize, userId, flag);
        
        return list;
    }

    public List<DocResourcePO> findAllDocsByPage(Long parentId, Long contentType, Integer pageNo, Integer pageSize,
            Long userId, int flag) throws BusinessException {
        List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
        List<DocResourcePO> all = this.findAllDocsByPage(true,parentId, contentType, -1, -1, userId,null);
        if (all == null) {
            return null;
        }
        for (DocResourcePO docResource : all) {
            if (flag == 1 && docResource.isThird_hasPingHole()) {
                ret.add(docResource);
                continue;
            }
            if (flag == 0 && !docResource.isThird_hasPingHole()) {
                ret.add(docResource);
            }
        }
        Pagination.setRowCount(ret.size());
        return this.getPagedDrs(ret, pageNo, pageSize);
    }

    public void updateDocResourceAfterPingHole(List<Long> ids) {
        if (Strings.isEmpty(ids)) {
            return;
        }
        String hql = "update DocResourcePO dr set dr.third_hasPingHole = '1' where dr.id in (:ids) ";
        Map<String, Object> namedParameterMap = new HashMap<String, Object>();
        namedParameterMap.put("ids", ids);
        this.docResourceDao.bulkUpdate(hql, namedParameterMap);
    }

    public Boolean hasPingHole(Long id) {
        Boolean flag = Boolean.FALSE;
        DocResourcePO docResource = docResourceDao.get(id);
        if (docResource == null) {
            log.error("文件已经被删除！�?");
            return null;
        }
        if (!docResource.isThird_hasPingHole()) {
            return Boolean.TRUE;
        }
        return flag;
    }

    @SuppressWarnings("unchecked")
    public void checkOrder(Long parentId) {
        String hql = "select distinct frOrder from DocResourcePO where parentFrId = ? ";
        List<Long> ids = this.docResourceDao.find(hql, null, parentId);
        String hql1 = "from DocResourcePO as d where d.parentFrId=? ";
        List<DocResourcePO> orderList = docResourceDao.find(hql1, -1, -1, null, parentId);
        int orderSize = orderList.size();
        if (ids.size() != orderSize) {
            int i = orderSize + 1;
            for (DocResourcePO dr : orderList) {
                dr.setFrOrder(i);
                i--;
            }
        }
    }

    private boolean isDocExsit(Long archiveId) {
        if (archiveId == null) {
            return false;
        }
        DocResourcePO doc = getDocResourceById(archiveId);
        if (doc == null) {
            return false;
        }else if (doc.getFrType() == Constants.LINK) {
            doc = getDocResourceById(doc.getSourceId());
            if (doc == null) {
                return false;
            }
        }
        return true;
    }

    @Deprecated
    public boolean getCheckStatus(Long docId) {
        return !Constants.LOCK_MSG_NONE.equals(this.getLockMsg(docId));
    }

    public int getFolderLevelLimit() {
        return folderLevelLimit;
    }

    public List<DocResourcePO> getSimpleQueryResult(boolean isNewView,SimpleDocQueryModel sdqm, Long parentFrId, Byte docLibType,Integer pageNo,
            String... type) throws BusinessException {
        if (sdqm == null || !sdqm.isValid()) {
            throw new IllegalArgumentException("按照单个属�?�简单查询文档时，查询条件无�?!");
        }
        DocSearchModel dsm = new DocSearchModel(sdqm);
        List<DocResourcePO> docs = new ArrayList<DocResourcePO>();
        docs = this.getQueryResult(isNewView,parentFrId, dsm, docLibType,pageNo, type);
        return docs;
    }

    public List<DocResourcePO> getAdvancedQueryResult(boolean isNew,DocSearchModel dsm, Long parentFrId, Byte docLibType,
            String... type) throws BusinessException {
        if (dsm == null || !dsm.isValid()) {
            throw new IllegalArgumentException("按照多个属�?�组合查询文档时，查询条件无�?!");
        }
        List<DocResourcePO> docs = this.getQueryResult(isNew,parentFrId, dsm, docLibType,null,type);
        return docs;
    }

    private List<DocResourcePO> getQueryResult(boolean isNew,Long docResourceId, DocSearchModel dsm, Byte docLibType,Integer pageNo, String... type)
            throws BusinessException {
        DocResourcePO dr = docResourceDao.get(docResourceId);
        if (dr == null) {
            log.warn("查询[id=" + docResourceId + "]文档夹下文档时，文档夹已被他人删�?!");
            return null;
        }
        //客开 赵辉 添加文档ID判断 档案条件查询 start
        List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
        List<DocResourcePO> docs = new ArrayList<DocResourcePO>();
        if(AppContext.getSystemProperty("doc.frNameMeeting") .equals(docResourceId.toString())  || AppContext.getSystemProperty("doc.frNameQianBao") .equals(docResourceId.toString()) 
        		|| AppContext.getSystemProperty("doc.frNameShouWen") .equals(docResourceId.toString()) || AppContext.getSystemProperty("doc.frNameFaWen") .equals(docResourceId.toString())){
        	 ret = DocSearchHqlUtils.searchByPropertiesDA(dr, dsm, docResourceDao, docMetadataDao,isNew,pageNo);
 	        Long userId = AppContext.currentUserId();
 	        boolean owner = this.docUtils.isOwnerOfLib(userId, dr.getDocLibId());
 	        if (docLibType == Constants.LIB_TYPE_NO.byteValue()) {
 	            DocLibPO lib = this.docUtils.getDocLibById(dr.getDocLibId());
 	            docLibType = lib.getType();
 	        }
 	        docs = this.handleAclAndPaginateDA(isNew,userId, dr, ret, docLibType, owner, type);
 	
 	        if (Strings.isNotEmpty(docs)) {
 	            if (docUtils.isOwnerOfLib(userId, docs.get(0).getDocLibId())) {
 	                for (DocResourcePO tdr : docs) {
 	                    tdr.setIsMyOwn(true);
 	                }
 	            }
 	        }
 	        if(isNew){
 	            Pagination.setMaxResults(30);
 	            Pagination.setFirstResult(30*pageNo);
 	        }
 	     //客开 赵辉 添加文档ID判断 档案条件查询 end
        }else{
	        ret = DocSearchHqlUtils.searchByProperties(dr, dsm, docResourceDao, docMetadataDao,isNew,pageNo);
	        Long userId = AppContext.currentUserId();
	        boolean owner = this.docUtils.isOwnerOfLib(userId, dr.getDocLibId());
	        if (docLibType == Constants.LIB_TYPE_NO.byteValue()) {
	            DocLibPO lib = this.docUtils.getDocLibById(dr.getDocLibId());
	            docLibType = lib.getType();
	        }
	        docs = this.handleAclAndPaginate(isNew,userId, dr, ret, docLibType, owner, type);
	
	        if (Strings.isNotEmpty(docs)) {
	            if (docUtils.isOwnerOfLib(userId, docs.get(0).getDocLibId())) {
	                for (DocResourcePO tdr : docs) {
	                    tdr.setIsMyOwn(true);
	                }
	            }
	        }
	        if(isNew){
	            Pagination.setMaxResults(30);
	            Pagination.setFirstResult(30*pageNo);
	        }
        }
        return CommonTools.pagenate(docs);
    }

    public List<DocResourcePO> getDocsByTypes(Long folderId, Long userId, long... docTypes) throws BusinessException {
        DocResourcePO folder = docResourceDao.get(folderId);
        if (folder == null) {
            return null;
        }
        List<DocResourcePO> ret = this.findDocsByTypes(folder, docTypes);
        DocLibPO lib = this.docUtils.getDocLibById(folder.getDocLibId());
        Byte docLibType = lib.getType();
        boolean owner = this.docUtils.isOwnerOfLib(userId, folder.getDocLibId());
        return this.handleAclAndPaginate(false,userId, folder, ret, docLibType, owner);
    }
    //重写方法 档案条件查询  客开 赵辉 start
    private List<DocResourcePO> handleAclAndPaginateDA(boolean isNew,Long userId, DocResourcePO folder, List<DocResourcePO> ret,
            Byte docLibType, boolean owner, String... type) throws BusinessException {
        if (CollectionUtils.isNotEmpty(ret)) {
            //因为有脏数据存在，需要清理，renhy
            //            String hql = "select doc.id from DocResourcePO doc where doc.frType = 21 and  not EXISTS (from DocResourcePO doc2 where doc2.id=doc.parentFrId)";
            //            List<Long> ids = docResourceDao.find(hql);
            //            if(!ids.isEmpty()){
            //                String deleteHql ="delete from DocResourcePO d where d.id in(:ids)";
            //                docResourceDao.bulkUpdate(deleteHql, CommonTools.newHashMap("ids", ids));
            //            }
            if (!Constants.PERSONAL_LIB_TYPE.equals(docLibType) && !owner) {
                String aclIds = Constants.getOrgIdsOfUser(userId);
                ret = docAclManager.getResourcesByConditionAndPotentPageDA(isNew,ret, folder, aclIds, type);
            } 
        }
        return ret;
    }
    //重写方法 档案条件查询  客开 赵辉 start
    private List<DocResourcePO> handleAclAndPaginate(boolean isNew,Long userId, DocResourcePO folder, List<DocResourcePO> ret,
            Byte docLibType, boolean owner, String... type) throws BusinessException {
        if (CollectionUtils.isNotEmpty(ret)) {
            //因为有脏数据存在，需要清理，renhy
            //            String hql = "select doc.id from DocResourcePO doc where doc.frType = 21 and  not EXISTS (from DocResourcePO doc2 where doc2.id=doc.parentFrId)";
            //            List<Long> ids = docResourceDao.find(hql);
            //            if(!ids.isEmpty()){
            //                String deleteHql ="delete from DocResourcePO d where d.id in(:ids)";
            //                docResourceDao.bulkUpdate(deleteHql, CommonTools.newHashMap("ids", ids));
            //            }
            if (!Constants.PERSONAL_LIB_TYPE.equals(docLibType) && !owner) {
                String aclIds = Constants.getOrgIdsOfUser(userId);
                ret = docAclManager.getResourcesByConditionAndPotentPage(isNew,ret, folder, aclIds, type);
            } 
        }
        return ret;
    }

    @SuppressWarnings("unchecked")
    private List<DocResourcePO> findDocsByTypes(DocResourcePO folder, long... docTypes) {
        String hql = "from DocResourcePO as d where d.parentFrId =:parentFrId and d.mimeTypeId in (:mimeTypes) "
                + DocSearchHqlUtils.HQL_FR_TYPE + Order_By;
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("parentFrId", folder.getId());
        List<Long> mimeTypes = new ArrayList<Long>(docTypes.length);
        for (long docType : docTypes) {
            mimeTypes.add(docType);
        }
        params.put("mimeTypes", mimeTypes);
        return docResourceDao.find(hql, -1, -1, params);
    }

    @SuppressWarnings("unchecked")
    public DocResourcePO getDocByFileId(String bodyContent) {
        String hql = "select dr from DocResourcePO dr, DocBodyPO db where dr.id=db.docResourceId and db.bodyType != :htmlBody and db.content like :content";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("htmlBody", com.seeyon.ctp.common.constants.Constants.EDITOR_TYPE_HTML);
        params.put("content", bodyContent);
        List<DocResourcePO> list = docResourceDao.find(hql, -1, -1, params);
        if (CollectionUtils.isNotEmpty(list)) {
            return list.get(0);
        }
        return null;
    }

    private LockManager docManageLock;

    public void setDocManageLock(LockManager docManageLock) {
        this.docManageLock = docManageLock;
    }

    public void lockWhenAct(Long docResourceId, Long userId) {
        this.docManageLock.lock(userId, docResourceId);
    }

    public void lockWhenAct(Long docResourceId) {
        this.lockWhenAct(docResourceId, AppContext.currentUserId());
    }

    public void unLockAfterAct(Long docResourceId) {
        this.docManageLock.unlock(docResourceId);
    }

    public String getLockMsg(Long docResId) {
        return this.getLockMsg(docResId, AppContext.currentUserId());
    }

    public String[] getLockMsgAndStatus(Long docResId) {
        return this.getLockMsgAndStatus(docResId, AppContext.currentUserId());
    }

    public String[] getLockMsgAndStatus(Long docResId, Long userId) {
        DocResourcePO dr = docResourceDao.get(docResId);
        return getLockMsgAndStatus(dr, userId);
    }

    public String[] getLockMsgAndStatus(DocResourcePO dr, Long userId) {
        // 文档已被删除
        if (dr == null) {
            return new String[] { Constants.getDocI18nValue("doc.lockstatus.msg.docinvalid"),
                    String.valueOf(LockStatus.DocInvalid.key()) };
        }

        // 应用�?(只有文档可能存在)
        String docName = Strings.escapeJavascript(Constants.getDocI18nValue(dr.getFrName()));
        if (!dr.getIsFolder() && dr.getIsCheckOut() && dr.getCheckOutUserId().longValue() != userId) {
            String lockerName = Functions.showMemberName(dr.getCheckOutUserId());
            return new String[] { ResourceUtil.getString("doc.lockstatus.msg.applock", docName, lockerName),
                    String.valueOf(LockStatus.AppLock.key()) };
        }

        // 并发操作�?(文档/文档夹均可能存在)
        List<Lock> mylocks = new ArrayList<Lock>();
        List<Lock> locks = this.docManageLock.getLocks(dr.getId());
        if (Strings.isNotEmpty(locks)) {
            for (Lock lk : locks) {
                if (lk != null && LockState.effective_lock.equals(this.docManageLock.isValid(lk))) {
                    mylocks.add(lk);
                }
            }
        }
        
        if (CollectionUtils.isNotEmpty(mylocks)) {
            Lock lock = mylocks.get(0);
            // 根据锁定时用户登录时间和目前实际锁持有�?�的登录时间来确定锁的占有是否仍旧有�?
            Long lockerId = lock.getOwner();
            User user = AppContext.getCurrentUser();
            String from = user!=null? com.seeyon.ctp.common.constants.Constants.login_sign.valueOf(user.getLoginSign()).toString():com.seeyon.ctp.common.constants.Constants.login_sign.pc.toString();
            if (lockerId != userId.longValue() || (lockerId == userId.longValue() && !from.equals(lock.getFrom()))) {
                V3xOrgMember member = null;
                try {
                    member = this.orgManager.getMemberById(lockerId);

                    if (member != null && member.isValid()) {
                        OnlineUser onlineUser = OnlineRecorder.getOnlineUser(member.getLoginName());
                        if (onlineUser != null) {
                            String editorName = Functions.showMemberName(lockerId);
                            int resource_choice = dr.getIsFolder() ? 1 : 0;
                            return new String[] {
                            		ResourceUtil.getString("doc.lockstatus.msg.actionlock", docName, editorName,
                                            resource_choice), String.valueOf(LockStatus.ActionLock.key()) };
                        }
                    }

                } catch (BusinessException e) {
                    log.warn("根据[id=" + lockerId + "]无法查找到对应人�?!", e);
                }
            }
        }

        return new String[] { Constants.LOCK_MSG_NONE, String.valueOf(Constants.LockStatus.None.key()) };
    }

    public String getLockMsg(Long docResId, Long userId) {
        String[] msg_status = this.getLockMsgAndStatus(docResId, userId);
        return msg_status[0];
    }

    public boolean isDocAppUnlocked(Long docResId, Long userId) {
        DocResourcePO dr = this.getDocResourceById(docResId);
        return dr == null || !dr.getIsCheckOut();
    }

    public void updateProjectManagerAuth4ProjectFolder(Long projectId, List<Long> oldManagers, List<Long> newManagers) {
        // 暂只处理新增的项目文档夹管理员，为其赋予全部权限、默认订�?
        List<Long> addedManagers = Strings.getAddedCollection(oldManagers, newManagers);
        if (CollectionUtils.isNotEmpty(addedManagers)) {
            Long userId = AppContext.currentUserId();
            DocResourcePO dr = this.getProjectFolderByProjectId(projectId);
            if (dr != null) {
                Long projectFolderId = dr.getId();
                this.docAclManager.deleteProjectFolderShare(projectFolderId, addedManagers);
                int minOrder = docAclManager.getMaxOrder();
                for (Long managerId : addedManagers) {
                    Long alertId = docAlertManager.addAlert(projectFolderId, true, Constants.ALERT_OPR_TYPE_ADD,
                            V3xOrgEntity.ORGENT_TYPE_MEMBER, managerId, userId, true, false, true);

                    docAclManager.setDeptSharePotent(managerId, V3xOrgEntity.ORGENT_TYPE_MEMBER, projectFolderId,
                            Constants.ALLPOTENT, true, alertId, minOrder++);
                }
                //更新全文�?索，修改项目成员时调�?
                DocUtils.updateIndex(dr, indexManager, this);
            } else {
                log.warn("项目[id=" + projectId + "]对应项目文件夹已被删�?!");
            }
        }
    }

    public void setIndexManager(IndexManager indexManager) {
        this.indexManager = indexManager;
    }


    public DocLibManager getDocLibManager() {
        return docLibManager;
    }

    public void setDocLibManager(DocLibManager docLibManager) {
        this.docLibManager = docLibManager;
    }

    @Override
    public Map<String, String> updateFolderPigeonhole(Map<String, String> map) {
        String name = map.get("title");
        String parentId = map.get("parentId");
        Long pId = parentId == null ? 0l : Long.parseLong(parentId);
        DocResourcePO parent = this.getDocResourceById(pId);
        if (parent == null) {
            map.put("eMessage", "doc_alert_source_deleted_folder");
        } else if (this.deeperThanLimit(parent)) {
            map.put("eMessage", "doc_alert_level_too_deep");
            map.put("eParam", String.valueOf(getFolderLevelLimit()));
        }
        if(map.get("eMessage")!=null){
            return map;
        }
        DocResourcePO dr = null;
        try {
            dr = this.createCommonFolderWithoutAcl(name, pId, AppContext.currentUserId(), parent.isVersionEnabled(),
                    parent.getCommentEnabled(), parent.getRecommendEnable());
            map.remove("eMessage");
        } catch (BusinessException e) {
            log.error("创建文档异常", e);
            log.error("", e);
            map.put("eMessage", e.getMessage());
            return map;
        }

        Long docLibId = dr.getDocLibId();
        map.put("id", dr.getId().toString());
        map.put("docLibId", docLibId + "");

        DocLibPO dlp = docLibManager.getDocLibById(docLibId);
        map.put("docLibType", dlp.getType() + "");
        map.put("frType", dr.getFrType() + "");
        return map;
    }

	/**
	 * ajax调用，协同转发的辅助方法
	 */
	public Long getSummaryIdByAffairId(long affairId) {
		CtpAffair affair;
		try {
			affair = affairManager.get(affairId);
			if(affair == null){
				CtpAffairHis affairHis = hisAffairManager.getById(affairId);
				return affairHis.getObjectId();
			}
			return affair.getObjectId();
		} catch (BusinessException e) {
			log.error("",e);
		}
		return null;
	}
    //批量保存文档信息
    public void saveAllDocResource(List<DocResourcePO> docList) {
        docResourceDao.savePatchAll(docList);
    }

    @Override
	public Integer getDocSourceType(Long docId) throws BusinessException {
		return null;
	}

	@Override
	public String getDocSourceTypeName(Long docId) throws BusinessException {
		return null;
	}

	public void setDocActionManager(DocActionManager docActionManager) {
        this.docActionManager = docActionManager;
    }

    public void setDocDao(DocDao docDao) {
        this.docDao = docDao;
    }
    
    public boolean isExist(Long docId) {
    	return "0".equals(existValidate(docId));
    }
    //返回值说�?     0:知识存在�?1：当前文档不存在�?2：映射源不存�? �?3：归档源不存�?, 4:文档库停用；
    public String existValidate(Long docId) {
    	String isExist = "0";
    	// 文档存在性验�?
    	if (docId == null) {
            return "1";
        }
        DocResourcePO dr = getDocResourceById(docId);
        if (dr == null) {
            return "1";
        }
        //停用文档库也能查看OA-50415
        //        DocLibPO lib = docLibManager.getDocLibById(dr.getDocLibId());
        //		if(lib.isDisabled()) {
        //			return "4";
        //		}
        if (dr.getFrType() == Constants.LINK) {
        	docId = dr.getSourceId();
            dr = getDocResourceById(docId);
            if (dr == null) {
                return "2";
            }
        }
    	boolean isPig = Constants.isPigeonhole(dr);
    	if(isPig) {
    		try {
				isExist = docFilingManager.hasPigeonholeSource(Constants.getAppEnum(dr.getFrType()).key(), dr.getSourceId()) ? "0" : "3";
			} catch (Exception e) {
				log.error("",e);
                return "3";
			}
    	}
    	return isExist;
    }
    
    public void insertDocLogViewForM1(DocResourcePO dr){
    	try {
    		operationlogManager.insertOplog(dr.getId(), dr.getParentFrId(), ApplicationCategoryEnum.doc, ActionType.LOG_DOC_VIEW,
                    ActionType.LOG_DOC_VIEW + ".desc", AppContext.currentUserName(), dr.getFrName());
		} catch (Exception e) {
			log.error("M1插入文档查看日志失败：insertDocLogViewForM1�?", e);
		}
    }
    public String getValidInfo(Long docId,Integer entrance,Long userId,Long baseDocId) {
    	String isExist = "0";
    	String aclInfo = "0";
    	String url = null;
    	Long validateDocId = docId;
    	boolean isLink = false;
    	DocResourcePO baseDoc = null;
    	Long validUserId = (userId == null) ? AppContext.currentUserId() : userId;
    	
    	// 文档存在性验证，如果不存在，直接返回 duanyl
    	isExist = existValidate(docId);
    	if(!"0".equals(isExist)) {
    		return isExist;
    	}
    	DocResourcePO dr = getDocResourceById(docId);
    	if (dr.getFrType() == Constants.LINK) {
    		isLink = true;
            dr = getDocResourceById(dr.getSourceId());
    	}
    	boolean isPig = Constants.isPigeonhole(dr);
    	EntranceTypeEnum entranceType = EntranceTypeEnum.parseEntranceType(entrance);
    	// 如果从公共库看，则取知识的文档夹权限 duanyl
//    	if(EntranceTypeEnum.otherLibs.equals(entranceType) && !isLink) {
//    		validateDocId = dr.getParentFrId();
//    	}
    	// 文档打开权限验证    	
    	aclInfo = hasOpenPermission(validateDocId,validUserId,entranceType) ? "0" : "1";
    	// 从关联文档打�?时，�?定有打开权限 duanyl
    	if(EntranceTypeEnum.associatedDoc.equals(entranceType)) {
    		aclInfo = "0";
    	}
    	// 判定是否有知识社区资�?
   	 	if(!AppContext.getCurrentUser().hasResourceCode("F04_docIndex") 
   	 			&& !AppContext.getCurrentUser().hasResourceCode("F04_myDocLibIndex")
   	 			&& !AppContext.getCurrentUser().hasResourceCode("F04_accDocLibIndex") 
   	 			&& !AppContext.getCurrentUser().hasResourceCode("F04_eDocLibIndex")
   	 			&& !AppContext.getCurrentUser().hasResourceCode("F04_proDocLibIndex")) {
   	 		aclInfo = "2";
   	 	}
    	
    	try {
    	    //只是在学习区能打�?，收藏的文档也能打开
    	    if(!"0".equals(aclInfo) && (docLearningManager.isLearnDoc(validateDocId, validUserId)||docFavoriteManager.isFavorite(validateDocId,validUserId))){
                aclInfo = "3";
            }
        } catch (BusinessException e) {
            log.error("", e);
        }
    	
    	if(!"0".equals(aclInfo)&&!"3".equals(aclInfo)) {
            return isExist + aclInfo;
        }
    	
    	// 增加�?次访问次�?
    	this.accessOneTime(dr.getId(), dr.getIsLearningDoc(), !validUserId.equals(dr.getCreateUserId()));
    	// 记录文档日志
        if (docLibManager.getDocLibById(dr.getDocLibId()).getLogView()) {
        	operationlogManager.insertOplog(dr.getId(), dr.getParentFrId(), ApplicationCategoryEnum.doc, ActionType.LOG_DOC_VIEW,
                    ActionType.LOG_DOC_VIEW + ".desc", AppContext.currentUserName(), dr.getFrName());
        }
    	// 如果从关联文档打�?
    	if(entrance != null && 8 == entrance && baseDocId != null) {
    		baseDoc = getDocResourceById(baseDocId);
    	}
    	if(isLink && !isPig) {
    		dr = getDocResourceById(docId);
    	}
    	// 如果为映射的非归档类型，此方法也要传映射本身的对�? duanyl
    	url = DocMVCUtils.getOpenKnowledgeUrl(getDocResourceById(validateDocId), entrance, docAclNewManager,this, baseDoc);
    	return isExist + aclInfo + url;
    }
	 //客开 赵辉 重写ajax方法 
    @AjaxAccess
    public String getValidInfo(Long docId,Integer entrance,Long userId,Long baseDocId,Long param) {
    	String isExist = "0";
    	String aclInfo = "0";
    	String url = null;
    	Long validateDocId = docId;
    	boolean isLink = false;
    	DocResourcePO baseDoc = null;
    	Long validUserId = (userId == null) ? AppContext.currentUserId() : userId;
    	
    	// 文档存在性验证，如果不存在，直接返回 duanyl
    	isExist = existValidate(docId);
    	if(!"0".equals(isExist)) {
    		return isExist;
    	}
    	DocResourcePO dr = getDocResourceById(docId);
    	if (dr.getFrType() == Constants.LINK) {
    		isLink = true;
            dr = getDocResourceById(dr.getSourceId());
    	}
    	boolean isPig = Constants.isPigeonhole(dr);
    	EntranceTypeEnum entranceType = EntranceTypeEnum.parseEntranceType(entrance);
    	// 如果从公共库看，则取知识的文档夹权限 duanyl
//    	if(EntranceTypeEnum.otherLibs.equals(entranceType) && !isLink) {
//    		validateDocId = dr.getParentFrId();
//    	}
    	// 文档打开权限验证    	
    	aclInfo = hasOpenPermission(validateDocId,validUserId,entranceType) ? "0" : "1";
    	// 从关联文档打�?时，�?定有打开权限 duanyl
    	if(EntranceTypeEnum.associatedDoc.equals(entranceType)) {
    		aclInfo = "0";
    	}
    	// 判定是否有知识社区资�?
   	 	if(!AppContext.getCurrentUser().hasResourceCode("F04_docIndex") 
   	 			&& !AppContext.getCurrentUser().hasResourceCode("F04_myDocLibIndex")
   	 			&& !AppContext.getCurrentUser().hasResourceCode("F04_accDocLibIndex") 
   	 			&& !AppContext.getCurrentUser().hasResourceCode("F04_eDocLibIndex")
   	 			&& !AppContext.getCurrentUser().hasResourceCode("F04_proDocLibIndex")) {
   	 		aclInfo = "2";
   	 	}
    	
    	try {
    	    //只是在学习区能打�?，收藏的文档也能打开
    	    if(!"0".equals(aclInfo) && (docLearningManager.isLearnDoc(validateDocId, validUserId)||docFavoriteManager.isFavorite(validateDocId,validUserId))){
                aclInfo = "3";
            }
        } catch (BusinessException e) {
            log.error("", e);
        }
    	
    	/*if(!"0".equals(aclInfo)&&!"3".equals(aclInfo)) {
            return isExist + aclInfo;
        }*/
    	
    	// 增加�?次访问次�?
    	this.accessOneTime(dr.getId(), dr.getIsLearningDoc(), !validUserId.equals(dr.getCreateUserId()));
    	// 记录文档日志
        if (docLibManager.getDocLibById(dr.getDocLibId()).getLogView()) {
        	operationlogManager.insertOplog(dr.getId(), dr.getParentFrId(), ApplicationCategoryEnum.doc, ActionType.LOG_DOC_VIEW,
                    ActionType.LOG_DOC_VIEW + ".desc", AppContext.currentUserName(), dr.getFrName());
        }
    	// 如果从关联文档打�?
    	if(entrance != null && 8 == entrance && baseDocId != null) {
    		baseDoc = getDocResourceById(baseDocId);
    	}
    	if(isLink && !isPig) {
    		dr = getDocResourceById(docId);
    	}
    	// 如果为映射的非归档类型，此方法也要传映射本身的对�? duanyl
    	url = DocMVCUtils.getOpenKnowledgeUrl(getDocResourceById(validateDocId), entrance, docAclNewManager,this, baseDoc);
    	return isExist + aclInfo + url;
    }
	@Override
	public List<DocResourcePO> getAllBorrowDoc(Integer first, Integer size,
			List<Long> OutMiniType, String title, List<Long> createIds,Long userId) throws BusinessException {
		FlipInfo fpi = new FlipInfo(first/size+1,size);
		return docResourceDao.findBorrowDoc(fpi,orgManager.getAllUserDomainIDs(userId), title, createIds, OutMiniType);
	}
	@Override
	public Integer getAllBorrowDocCount(
			List<Long> OutMiniType, String title, List<Long> createIds,Long userId)
			throws BusinessException {
		FlipInfo fpi = new FlipInfo(0,1);
		docResourceDao.findBorrowDoc(fpi,orgManager.getAllUserDomainIDs(userId), title, createIds, OutMiniType);
		return fpi.getTotal();
	}
	@Override
	public List<DocResourcePO> getAllCommmonDoc(Integer first, Integer size,
			List<Long> OutMiniType, Long docId, String title, List<Long> createIds,Long userId,String type)
			throws BusinessException {
		List<DocResourcePO> list = getCommmonDoc(OutMiniType, docId, title, createIds, userId,type);
		Integer min = list.size()>first? first<=0?0:first : 0;
		Integer max = list.size()>(first+size)? first+size : list.size();
		if(size == -1){
			max = list.size();
		}else{
			max = list.size()>(first+size)? first+size : list.size();
		}
		return list.subList(min, max);
	}
	@Override
	public Integer getAllCommmonDocCount(List<Long> OutMiniType, Long docId, String title,
			List<Long> createIds,Long userId,String type) throws BusinessException {
		return getCommmonDoc(OutMiniType, docId, title, createIds, userId,type).size();
	}
	private List<DocResourcePO> getCommmonDoc(List<Long> OutMiniType, Long docId, String title,
			List<Long> createIds,Long userId,String type) throws BusinessException {
		FlipInfo fpi = new FlipInfo(0,-1);
		DocResourcePO doc = this.getDocResourceById(docId);
        boolean isOwner = docLibManager.isOwnerOfLib(userId, doc.getDocLibId());
        //权限过滤
        if(isOwner){
    		return docResourceDao.findDocByAclType(fpi,docId,null, title, createIds, OutMiniType,null);
        }else{
        	String userIds = Constants.getOrgIdsOfUser(userId);
            // 1. 取得父文档夹权限	
            Map<Long, Set<Integer>> parentAclMap = docAclManager.getGroupedAclSet(doc, userIds);
            Set<Integer> parentAcl = docAclManager.getDocResourceAclList(doc, userIds, parentAclMap);
            boolean parentHasPotent = false;
            for (Integer a : parentAcl) {
                if (a.intValue() != Constants.NOPOTENT)
                	parentHasPotent = true;
            }
            if(parentHasPotent){

                if ("quote".equals(type)) {
                    // 只有列表权限时，只能查看�?  无权限的子文件夹
                	boolean onlyList = true;
                	for(Integer acl : parentAcl){
                		if(acl==Constants.ALLPOTENT || acl ==Constants.EDITPOTENT  || acl == Constants.ADDPOTENT 
                				|| acl ==Constants.READONLYPOTENT || acl == Constants.BROWSEPOTENT)
                			onlyList = false;
                	}
                	if(onlyList){
                    	List<Byte> aclTypes = new ArrayList<Byte>();
                    	aclTypes.add(Constants.SHARETYPE_DEPTSHARE);
                    	aclTypes.add(Constants.SHARETYPE_PERSSHARE);
                        return docResourceDao.findDocByAclType(fpi,docId,orgManager
        						.getAllUserDomainIDs(userId), title, createIds, OutMiniType, aclTypes);
                	}
                }
                // 只有写入权限时，只能查看自己创建的文�?
                if((parentAcl.size() == 1 && parentAcl.iterator().next() == Constants.ADDPOTENT) || (parentAcl
                                .size() == 2 && parentAcl.contains(Constants.ADDPOTENT) && parentAcl
                                    .contains(Constants.NOPOTENT))){
                	if(createIds == null){
                		createIds = new ArrayList<Long>();
                		createIds.add(userId);
                	}else{
                		createIds.clear();
                		createIds.add(userId);
                	}
                }
                List<DocResourcePO> list = docResourceDao.findDocByAclType(fpi,docId,null, title, createIds, OutMiniType,null);
				List<DocResourcePO> list2 = docResourceDao
						.findDocByAclTypeWithoutAcl(fpi, docId, orgManager
								.getAllUserDomainIDs(userId), title, createIds,
								OutMiniType, Constants.SHARETYPE_DEPTSHARE);
				list.removeAll(list2);
				return list;
            }else{
            	List<Byte> aclTypes = new ArrayList<Byte>();
            	aclTypes.add(Constants.SHARETYPE_DEPTSHARE);
            	aclTypes.add(Constants.SHARETYPE_PERSSHARE);
                return docResourceDao.findDocByAclType(fpi,docId,orgManager
						.getAllUserDomainIDs(userId), title, createIds, OutMiniType, aclTypes);
            }
        }
	}
	@Override
	public List<DocResourcePO> getAllPersonAlShareDoc(Integer first,
			Integer size, List<Long> OutMiniType, String title,
			List<Long> createIds,Long userId) throws BusinessException {
		FlipInfo fpi = new FlipInfo(first/size+1,size);
    	List<Byte> aclTypes = new ArrayList<Byte>();
    	aclTypes.add(Constants.SHARETYPE_PERSSHARE);
		return docResourceDao.findDocByAclType(fpi,null,orgManager.getAllUserDomainIDs(userId), title, createIds, 
				OutMiniType,aclTypes);
	}
	@Override
	public Integer getAllPersonAlShareDocCount(
			List<Long> OutMiniType, String title, List<Long> createIds,Long userId)
			throws BusinessException {
		FlipInfo fpi = new FlipInfo(0,1);
    	List<Byte> aclTypes = new ArrayList<Byte>();
    	aclTypes.add(Constants.SHARETYPE_PERSSHARE);
		docResourceDao.findDocByAclType(fpi,null,orgManager.getAllUserDomainIDs(userId), title, createIds, 
				OutMiniType,aclTypes);
		return fpi.getTotal();
	}
	
	 /**
	  * 文档树，异步调用时，用到
     * @param frType
     * @param prantDocId
     * @param validAcls
     * @param lib
     * @return
     * @throws BusinessException
     */
    public List<DocTreeVO> getTreeNode(Long frType, Long prantDocId, String validAcls, DocLibPO lib,String projectTypeId,boolean isSection)
            throws BusinessException {
        List<DocResourcePO> drs = null;
        Long userId = AppContext.currentUserId();
        boolean validAcl = true;
        if (validAcls != null && "false".equals(validAcls))
            validAcl = false;

        boolean isPersonalLib = lib.isPersonalLib();
        if (isPersonalLib || AppContext.getCurrentUser().isAdministrator() || AppContext.getCurrentUser().isGroupAdmin()// 单位管理员登�?
                || (!validAcl)) { // 预归档，不要求验证权�?
            drs = findFolders(prantDocId, frType, userId, "", true,null);
        } else {
            String orgIds = Constants.getOrgIdsOfUser(userId);
            //项目虚拟目录查询
            if (DocMVCUtils.isProjectVirtualCategory(frType, prantDocId, lib,projectTypeId)&&!isSection) {
                //根据项目类型Id查询�?有项目id
//                List<ProjectBO> psList = projectApi.findProjectsByTypeIdAndMemberId(userId,Long.parseLong(projectTypeId));
//                List<Long> sourceIds = new ArrayList<Long>();//项目id
//                for (ProjectBO pSummary : psList) {
//                    sourceIds.add(pSummary.getId());
//                }
            	List<Long> sourceIds = projectApi.findProjectIdsByMemberAndType(userId, Long.parseLong(projectTypeId));
                drs = findFolders(prantDocId, Constants.FOLDER_PROJECT_ROOT, userId, orgIds, false,sourceIds);
            } else {
                drs = findFolders(prantDocId, frType, userId, orgIds, false,null);
            }
        }
        
        List<DocTreeVO> folders = new ArrayList<DocTreeVO>();
        
        if ((drs == null)){
            return folders;
        }
        
        if(!isSection){
            //项目文档根据项目文档类别构建
            drs = DocMVCUtils.projectRootCategory(frType, prantDocId, lib, drs,projectApi,orgManager);
        }
        
        for (DocResourcePO dr : drs) {
            if ((dr.getFrType() == Constants.FOLDER_PLAN) || (dr.getFrType() == Constants.FOLDER_SHAREOUT)
                    || (dr.getFrType() == Constants.FOLDER_TEMPLET) || (dr.getFrType() == Constants.FOLDER_SHARE)
                    || (dr.getFrType() == Constants.FOLDER_BORROW)) {
                continue;
            } else {
                if (isPersonalLib){
                    dr.setIsMyOwn(true);
                }
                DocTreeVO vo = DocMVCUtils.getDocTreeVO(userId, dr, isPersonalLib, docMimeTypeManager, docAclManager);
                folders.add(vo);
            }
        }
        return folders;
    }
    
    /**
     * @param appName
     * @param flag
     * @param spaceType
     * @param pigeonholeType
     * @param validAcl
     * @param id
     * @param docLibType
     * @return
     * @throws BusinessException
     * @throws Exception
     */
    public List<DocTreeVO> getTreeRootNode(String appName, String flag, String spaceType, String pigeonholeType,
            String validAcl, String id, String docLibType) throws BusinessException, Exception {
        List<DocLibPO> libsSrc = new ArrayList<DocLibPO>();
        List<DocLibPO> libsSrcAll = null;
        User user = AppContext.getCurrentUser();
        Long domainId = AppContext.getCurrentUser().getLoginAccount();
        
        boolean isV5Member = user.getExternalType() == OrgConstants.ExternalType.Inner.ordinal();
        if (!isV5Member) {
            domainId = OrgHelper.getVJoinAllowAccount();
        }
        
        // If there is no shareout or borrowOut doc root ,add it into DB!
        if (!user.isAdmin() && isV5Member) {
            DocLibPO lib = this.docLibManager.getPersonalLibOfUser(AppContext.currentUserId());
            DocResourcePO mydoc = this.getRootByLibId(lib.getId());
            Long myDocId = mydoc.getDocLibId();
            if (mydoc != null) {
                DocResourcePO borrowDoc = this.getDocByType(myDocId,
                        Constants.FOLDER_BORROWOUT);
                DocResourcePO shareDoc = this.getDocByType(myDocId,
                        Constants.FOLDER_SHAREOUT);
                if (borrowDoc == null && shareDoc == null) {
                    DocResourcePO borrow = this.getDocByType(myDocId,
                            Constants.FOLDER_BORROW);
                    DocResourcePO share = this.getDocByType(myDocId, Constants.FOLDER_SHARE);
                    try {
                        this.createFolderByTypeWithoutAcl(Constants.FOLDER_BORROWOUT_KEY,
                                Constants.FOLDER_BORROWOUT, myDocId, borrow.getId(),
                                AppContext.currentUserId());

                        this.createFolderByTypeWithoutAcl(Constants.FOLDER_SHAREOUT_KEY,
                                Constants.FOLDER_SHAREOUT, myDocId, share.getId(),
                                AppContext.currentUserId());
                    } catch (BusinessException e) {
                        log.error("创建借阅和共享出去的文档节点", e);
                    }
                }
            }
        }

        if (user.isAdmin()) {
            libsSrcAll = docLibManager.getDocLibs(domainId);
            for (DocLibPO dl : libsSrcAll) {
                if (!dl.isPersonalLib()&& !dl.isProjectLib()) {
                    libsSrc.add(dl);
                }
            }
        } else if ("pigeonhole".equals(flag)) {
            // 表单管理�?
            // boolean isFormAdmin = MainHelper.isFORMAdmin(orgManager);
            if ("false".equals(validAcl))
                libsSrc = docLibManager.getDocLibs(domainId);
            else
                libsSrc = docLibManager.getDocLibsByUserId(user.getId(), domainId);

        } else if (flag != null) {
            // 移动�?
            boolean hasLibFlag = false;
            if(Strings.isNotBlank(id)){
                List<DocResourcePO> docs = this.getDocsByIds(id);
                for(DocResourcePO doc : docs){
                    if(DocSourceType.favorite.key().equals(doc.getSourceType())
                            || DocSourceType.favoriteAtt.key().equals(doc.getSourceType())){
                        libsSrc.add(docLibManager.getPersonalLibOfUser(user.getId()));
                        hasLibFlag = true;
                        break;
                    }
                }
            }
            if(!hasLibFlag){
                libsSrc = docLibManager.getDocLibsByUserId(user.getId(), domainId);
            }

        } else {
            // 文档�?
            libsSrc = docLibManager.getDocLibsByUserIdNav(user.getId(), domainId);
        }
        if (!isV5Member) {
            boolean isEnterpriseVer = (Boolean)(SysFlag.sys_isEnterpriseVer.getFlag());
            List<DocLibPO> ls = new ArrayList<DocLibPO>();
            for (DocLibPO lib : libsSrc) {
                if (Constants.PERSONAL_LIB_TYPE == lib.getType()) {
                    continue;
                }
                if (Constants.EDOC_LIB_TYPE == lib.getType()) {
                    continue;
                }
                if (Constants.PROJECT_LIB_TYPE == lib.getType()) {
                    continue;
                }
                if (isEnterpriseVer && Constants.GROUP_LIB_TYPE == lib.getType()) {
                    continue;
                }
                ls.add(lib);
            }
            libsSrc = new ArrayList<DocLibPO>();
            libsSrc.addAll(ls);
        }
        
        
        boolean showGroupLib = Constants.isShowGroupLib();
        // 2008.05.28 外部人员不可见公文档案库
        boolean showEdocLib = (user.isInternal() && (Constants.edocModuleEnabled()));
        boolean showPersonalLib = true;
        if ("move".equals(flag)) {
            if (docLibType != null
                    && ((Constants.EDOC_LIB_TYPE + "").equals(docLibType)
                            || (Constants.ACCOUNT_LIB_TYPE + "").equals(docLibType)
                            || (Constants.PROJECT_LIB_TYPE + "").equals(docLibType)
                            || (Constants.GROUP_LIB_TYPE + "").equals(docLibType) || (Constants.USER_CUSTOM_LIB_TYPE + "")
                            .equals(docLibType)))
                showPersonalLib = false;
        }
        List<DocLibPO> libs = new ArrayList<DocLibPO>();
        // 过滤
        if ("pigeonhole".equals(flag)) {
            int appKey = NumberUtils.toInt(appName);
            // 公文
            if (ApplicationCategoryEnum.edoc.key() == appKey) {
                for (DocLibPO l : libsSrc) {
                    //公文模板,单位归档的时候显示本单位的：公文档案库，集团文档，单位文�?
                    if (Strings.isNotEmpty(pigeonholeType)) {
                        if ("EdocTempletePrePigeonhole".equals(pigeonholeType) //预归�?
                                || "EdocAccountPigoenhole".equals(pigeonholeType)) { //单位归档

                            if (l.getType() == Constants.EDOC_LIB_TYPE.byteValue()
                                    || l.getType() == Constants.ACCOUNT_LIB_TYPE.byteValue()
                                    || l.getType() == Constants.GROUP_LIB_TYPE.byteValue())
                                libs.add(l);
                        }
                        if ("EdocAccountPigoenhole".equals(pigeonholeType)) { //单位归档
                            if (l.getType() == Constants.USER_CUSTOM_LIB_TYPE.byteValue())
                                libs.add(l);
                        }
                    } else {//只要在文档库中有相应的权�?,部门归档可以归档到以下文档库中：集团文档�?,单位文档�?,自定义文档库（不能归档到项目文档�?

                        if (l.getType() == Constants.ACCOUNT_LIB_TYPE.byteValue() //单位文档�?
                                || l.getType() == Constants.GROUP_LIB_TYPE.byteValue()
                                || l.getType() == Constants.USER_CUSTOM_LIB_TYPE.byteValue()) //集团文档�?
                            libs.add(l);
                    }
                }
                if (!"EdocTempletePrePigeonhole".equals(pigeonholeType)) {
                    addPartTimeLibs(libs);
                }
            }
            // 公告、新闻�?�调查�?�会�?
            else if (ApplicationCategoryEnum.bulletin.key() == appKey || ApplicationCategoryEnum.news.key() == appKey
                    || ApplicationCategoryEnum.inquiry.key() == appKey|| ApplicationCategoryEnum.bbs.key() == appKey
                    || ApplicationCategoryEnum.meeting.key() == appKey) {
                if (showGroupLib) {
                    for (DocLibPO l : libsSrc) {
                        if (l.getType() != Constants.EDOC_LIB_TYPE.byteValue()
                                && l.getType() != Constants.PERSONAL_LIB_TYPE.byteValue())
                            libs.add(l);
                    }
                } else {
                    for (DocLibPO l : libsSrc) {
                        if (l.getType() != Constants.GROUP_LIB_TYPE.byteValue()
                                && l.getType() != Constants.EDOC_LIB_TYPE.byteValue()
                                && l.getType() != Constants.PERSONAL_LIB_TYPE.byteValue())
                            libs.add(l);
                    }
                }
            } else {
                // 其他归档
                if (showGroupLib) {
                    for (DocLibPO l : libsSrc) {
                        if (l.getType() != Constants.EDOC_LIB_TYPE.byteValue())
                            libs.add(l);
                    }
                } else {
                    for (DocLibPO l : libsSrc) {
                        if (isV5Member && l.getType() != Constants.GROUP_LIB_TYPE.byteValue()
                                && l.getType() != Constants.EDOC_LIB_TYPE.byteValue()) {
                            libs.add(l);
                        }
                        if (!isV5Member && l.getType() != Constants.EDOC_LIB_TYPE.byteValue()) {
                            libs.add(l);
                        }
                    }
                }
            }
        } else if (showGroupLib && showEdocLib) {
            libs.addAll(libsSrc);
        } else {
            if (showGroupLib) {
                for (DocLibPO l : libsSrc) {
                    if (l.getType() != Constants.EDOC_LIB_TYPE.byteValue())
                        libs.add(l);
                }
            } else if (showEdocLib) {
                for (DocLibPO l : libsSrc) {
                    if (l.getType() != Constants.GROUP_LIB_TYPE.byteValue())
                        libs.add(l);
                }
            } else {
                for (DocLibPO l : libsSrc) {
                    if (isV5Member && l.getType() != Constants.GROUP_LIB_TYPE.byteValue()
                            && l.getType() != Constants.EDOC_LIB_TYPE.byteValue()) {
                        libs.add(l);
                    }
                    if (!isV5Member && l.getType() != Constants.EDOC_LIB_TYPE.byteValue()) {
                        libs.add(l);
                    }
                }
            }
        }

        List<DocLibPO> libs2 = new ArrayList<DocLibPO>();
        if (!showPersonalLib || "department".equals(spaceType)) {
            for (DocLibPO l : libs) {
                if (l.getType() != Constants.PERSONAL_LIB_TYPE.byteValue())
                    libs2.add(l);
            }
        } else if ("group".equals(spaceType) || "public_custom_group".equals(spaceType)) {
            for (DocLibPO l : libs) {
                if (l.isGroupLib()){
                    libs2.add(l);
                }
            }
        } else {
            libs2 = libs;
        }

        // 列出�?有文档库的根文档�?
        List<DocTreeVO> roots = new ArrayList<DocTreeVO>();
        List<Long> libids = CommonTools.getIds(libs2);
        List<DocResourcePO> rootDrs = null;
        Map<Long, DocResourcePO> rootMap = new HashMap<Long, DocResourcePO>();
        if (CollectionUtils.isNotEmpty(libids)) {
            rootDrs = getRootsByLibIds(libids, Constants.getOrgIdsOfUser(user.getId()));
            if (rootDrs != null) {
                for (DocResourcePO td : rootDrs) {
                    rootMap.put(td.getDocLibId(), td);
                }
            }
        }

        //资源菜单权限判定
        if(!user.isAdmin()){
            List<DocLibPO> noAclLib = new ArrayList<DocLibPO>();
            for (DocLibPO l : libs2) {
                if(l.getType() == Constants.PERSONAL_LIB_TYPE.byteValue()){
                    //协同模板管理员不能有我的文档
                    if(!(user.hasResourceCode("F04_myDocLibIndex")
                            ||user.hasResourceCode("F04_docIndex"))){
                        noAclLib.add(l);
                    }
                }else if(l.getType() == Constants.ACCOUNT_LIB_TYPE.byteValue()){
                    if(!(user.hasResourceCode("F04_accDocLibIndex")
                            ||user.hasResourceCode("F04_docIndex"))){
                        noAclLib.add(l);
                    }
                }else if(l.getType() == Constants.EDOC_LIB_TYPE.byteValue()){
                    if(!(user.hasResourceCode("F04_eDocLibIndex")
                            ||user.hasResourceCode("F04_docIndex")
                            ||user.hasResourceCode("F04_accDocLibIndex"))){
                        noAclLib.add(l); 
                    }
                }else if(l.getType() == Constants.PROJECT_LIB_TYPE.byteValue()){
                    if(!(user.hasResourceCode("F04_proDocLibIndex")
                            ||user.hasResourceCode("F04_docIndex"))){
                        noAclLib.add(l);
                    }
                }else if(l.getType() == Constants.GROUP_LIB_TYPE.byteValue()){
                    if(!(user.hasResourceCode("F04_groupDocLibIndex")
                            ||user.hasResourceCode("F04_docIndex"))){
                        noAclLib.add(l);
                    }
                }
            }
            libs2.removeAll(noAclLib);
        }
        long loginAccountId = AppContext.getCurrentUser().getLoginAccount();
        boolean isEdoc = Functions.isEnableEdoc();
        boolean isPluginEdoc = AppContext.hasPlugin("edoc");
        boolean isPluginProject = AppContext.hasPlugin("project");
        for (DocLibPO lib : libs2) {
            if (lib.isDisabled()){
                continue;
            }
            if (lib.getType() == Constants.EDOC_LIB_TYPE.byteValue()) {
                if (!isEdoc || !isPluginEdoc){
                    continue;
                }
            }
            if (lib.getType() == Constants.PROJECT_LIB_TYPE.byteValue()) {
                if (!isPluginProject){
                    continue;
                }
            }

            DocResourcePO dr = rootMap.get(lib.getId());
            if (dr == null){
                continue;
            }
            if (lib.isPersonalLib()){
                dr.setIsMyOwn(true);
            }
            DocTreeVO vo = new DocTreeVO(dr);
            DocMVCUtils.setGottenAclsInVO(vo, user.getId(), false, docAclManager);
            String srcIcon = docMimeTypeManager.getDocMimeTypeById(dr.getMimeTypeId()).getIcon();
            vo.setOpenIcon(srcIcon.substring(srcIcon.indexOf('|') + 1, srcIcon.length()));
            vo.setCloseIcon(srcIcon.substring(0, srcIcon.indexOf('|')));
            vo.setIsPersonalLib(lib.getType() == Constants.PERSONAL_LIB_TYPE.byteValue());
            vo.setDocLibType(lib.getType());
            if (lib.getDomainId() != loginAccountId) {
                vo.setOtherAccountId(lib.getDomainId());
            }
            DocMVCUtils.setNeedI18nInVo(vo);
            String v = null;
            if(vo.getDocLibType() == (byte)1) {
                v = SecurityHelper.digest(vo.getDocResource().getId(),vo.getDocResource().getFrType(),vo.getDocResource().getDocLibId(),
                        vo.getDocLibType(),vo.getIsBorrowOrShare(),vo.isAllAcl(),vo.isEditAcl(),
                        vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl());
            } else {
                Potent potent = docAclManager.getAclVO(vo.getDocResource().getId());
                boolean all = potent.isAll();
                boolean edit = potent.isEdit();
                boolean add = potent.isCreate();
                boolean readonly = potent.isReadOnly();
                boolean browse = potent.isRead();
                boolean list = potent.isList();
                boolean isShareAndBorrowRoot = vo.getIsBorrowOrShare();
                if(Long.valueOf(40).equals(vo.getDocResource().getFrType())) {
                    isShareAndBorrowRoot = false;
                    all = edit = add = list = true;
                    readonly = browse = false;
                }
                if(Long.valueOf(110).equals(vo.getDocResource().getFrType()) || Long.valueOf(111).equals(vo.getDocResource().getFrType())) {
                    isShareAndBorrowRoot = false;
                }
                v = SecurityHelper.digest(vo.getDocResource().getId(),vo.getDocResource().getFrType(),vo.getDocResource().getDocLibId(),
                        vo.getDocLibType(),isShareAndBorrowRoot,all,edit,add,readonly,browse,list);
            }            
            vo.setV(v);
            roots.add(vo);
        }
        return roots;
    }
    
	@Override
    /**
     * 归档界面查询
     * @throws BusinessException
     * @throws Exception 
     */
    public List<DocTreeVO> getTreeRootNode(String appName, String flag, String spaceType, String pigeonholeType,
            String validAcl, String id, String docLibType, String frName) throws BusinessException, Exception {
    	List<DocTreeVO> root = this.getTreeRootNode(appName, flag, spaceType, pigeonholeType, validAcl, id, docLibType);
    	if(Strings.isNotBlank(frName)){
    		User user = AppContext.getCurrentUser();
    		List<DocResourcePO> doc4Search = this.findByFrName(frName);
    		List<Long> listLong = new ArrayList<Long>();
    		List<DocLibPO> libs = new ArrayList<DocLibPO>();
    		for (DocTreeVO docTreeVO : root) {
    			DocResourcePO doc = docTreeVO.getDocResource();
				listLong.add(doc.getId());
				DocLibPO lib = docLibManager.getDocLibById(doc.getDocLibId());
    			if(!libs.contains(lib)){
    				libs.add(lib);
    			}
			}
    		List<DocResourcePO> noTypeList = this.get4TreeNode(doc4Search, listLong, user);
    		List<DocResourcePO> needNodeList = new ArrayList<DocResourcePO>();
    		if(!Strings.equals("fromTempleteManage", pigeonholeType)){
    			//非流程表单预归档--添加项目虚拟文档
    			needNodeList = this.buildProjectFolder(noTypeList);
    		}else{
    			needNodeList = noTypeList;
    		}
    	
    		long loginAccountId = AppContext.getCurrentUser().getLoginAccount();
    		boolean isEdoc = Functions.isEnableEdoc();
    		boolean isPluginEdoc = SystemEnvironment.hasPlugin("edoc");
    		List<DocTreeVO> roots = new ArrayList<DocTreeVO>();
    		for (DocLibPO lib : libs) {
    			if (lib.isDisabled()){
    				continue;
    			}
    			if (lib.getType() == Constants.EDOC_LIB_TYPE.byteValue()) {
    				if (!isEdoc || !isPluginEdoc){
    					continue;
    				}
    			}
           
    			List<DocResourcePO> list2 = new ArrayList<DocResourcePO>();
            	for(DocResourcePO dr : needNodeList){
            		if(dr.getDocLibId() == lib.getId()){
            			list2.add(dr);
            		}
            	}
            	
            	for(DocResourcePO doc: list2){
            		if (doc == null){
                		continue;
                	}
            		if (lib.isPersonalLib()){
            			doc.setIsMyOwn(true);
                	}
                    DocTreeVO vo = new DocTreeVO(doc);
                    /*Start*/
                    DocMVCUtils.setGottenAclsInVO(vo, user.getId(), false, docAclManager);
                    String srcIcon = docMimeTypeManager.getDocMimeTypeById(doc.getMimeTypeId()).getIcon();
                    vo.setOpenIcon(srcIcon.substring(srcIcon.indexOf('|') + 1, srcIcon.length()));
                    if(srcIcon.indexOf('|') == -1){
                    	vo.setCloseIcon(vo.getOpenIcon());
                    }else{
                    	vo.setCloseIcon(srcIcon.substring(0, srcIcon.indexOf('|')));
                    }
                    vo.setIsPersonalLib(lib.getType() == Constants.PERSONAL_LIB_TYPE.byteValue());
                    vo.setDocLibType(lib.getType());
                    if (lib.getDomainId() != loginAccountId) {
                        vo.setOtherAccountId(lib.getDomainId());
                    }
                    DocMVCUtils.setNeedI18nInVo(vo);
                    String v = null;
                    if(vo.getDocLibType() == (byte)1) {
                        v = SecurityHelper.digest(vo.getDocResource().getId(),vo.getDocResource().getFrType(),vo.getDocResource().getDocLibId(),
                                vo.getDocLibType(),vo.getIsBorrowOrShare(),vo.isAllAcl(),vo.isEditAcl(),
                                vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl());
                    } else {
                        Potent potent = docAclManager.getAclVO(vo.getDocResource().getId());
                        boolean all = potent.isAll();
                        boolean edit = potent.isEdit();
                        boolean add = potent.isCreate();
                        boolean readonly = potent.isReadOnly();
                        boolean browse = potent.isRead();
                        boolean list = potent.isList();
                        boolean isShareAndBorrowRoot = vo.getIsBorrowOrShare();
                        if(Long.valueOf(40).equals(vo.getDocResource().getFrType())) {
                            isShareAndBorrowRoot = false;
                            all = edit = add = list = true;
                            readonly = browse = false;
                        }
                        if(Long.valueOf(110).equals(vo.getDocResource().getFrType()) || Long.valueOf(111).equals(vo.getDocResource().getFrType())) {
                            isShareAndBorrowRoot = false;
                        }
                        v = SecurityHelper.digest(vo.getDocResource().getId(),vo.getDocResource().getFrType(),vo.getDocResource().getDocLibId(),
                                vo.getDocLibType(),isShareAndBorrowRoot,all,edit,add,readonly,browse,list);
                    }            
                    vo.setV(v);
                    /*End*/
                    roots.add(vo);
                }
            }
    		return roots;
    	}else{
    		return root;
    	}
    }
    
    /**
     * 方法用于getTreeRootNodes
     * 
     * 此集合中并没有�?�项目类型�?�虚拟文档夹
     * 
     * @param listForTree
     * @param rids
     * @return
     * @throws BusinessException 
     * 
     */
    private List<DocResourcePO> get4TreeNode(List<DocResourcePO> list, List<Long> rids, User user) throws BusinessException{
    	Long userId = user.getId();
    	List<Long> userIds = orgManager.getAllUserDomainIDs(userId);
        Set<Long> docIds = docAclManager.getHasAclDocResourceIds(userIds); 
    	List<String> listPath = new ArrayList<String>();
    	for(DocResourcePO dr : list){
    		String logicalPath = dr.getLogicalPath();
    		for(Long rid : rids){
    			if(logicalPath.indexOf(rid.toString()) != -1){
    				listPath.add(logicalPath);
    			}
    		}
    	}
    	List<String> pathList = new UniqueList<String>();
    	for (String path : listPath) {
			for(Long docId : docIds){
				if(path.indexOf(docId.toString()) != -1){
					pathList.add(path);
				}
			}
		}

    	List<Long> ids = new ArrayList<Long>();
		for (String string : pathList) {
			for (String id : string.split("\\.")) {
				if(!ids.contains(id)){
					ids.add(Long.parseLong(id));
				}
			}
		}
		
		List<DocResourcePO> list3 = this.getDocsByIds(ids);
		Map<Long, DocResourcePO> rootMap = new HashMap<Long, DocResourcePO>();
		for (DocResourcePO dr : list3) {
			rootMap.put(dr.getId(), dr);
		}
		
		List<DocResourcePO> docList =new UniqueList<DocResourcePO>();
		for(Long id:ids){
			DocResourcePO dr = rootMap.get(id);
			if(dr != null){
				docList.add(dr);
			}
		}
		return docList;
    }
    
    /**
     * 项目文档虚拟文档建立
     * 
     * 用于模糊文档查询
     * @param list4P
     * @return
     * @throws BusinessException 
     * 
     */
    private List<DocResourcePO> buildProjectFolder(List<DocResourcePO> list) throws BusinessException{
    	List<DocResourcePO> listDoc = new ArrayList<DocResourcePO>();
    	List<DocResourcePO> needList = new ArrayList<DocResourcePO>();
		for (DocResourcePO dr : list) {
			if (dr.getFrType() == Constants.FOLDER_CASE) {
				ProjectBO ps = this.projectApi.getProject(dr.getSourceId());
				Long folderId = dr.getParentFrId();
				DocResourcePO pdr = new DocResourcePO();
				if (ps != null && dr != null) {
					Long projectTypeId = ps.getProjectTypeId() < 0 ? 0 - ps.getProjectTypeId() : ps.getProjectTypeId();
					pdr.setId(projectTypeId);
					pdr.setFrName(ps.getProjectTypeName());
					pdr.setFrType(Constants.PERSON_SHARE);// 虚拟类型，不是个人分�?
					pdr.setCreateUserId(null);
					pdr.setDocLibId(dr.getDocLibId());
					pdr.setIsFolder(true);
					pdr.setSubfolderEnabled(false);
					pdr.setFrSize(0);
					pdr.setMimeTypeId(Constants.FOLDER_PROJECT_ROOT);
					pdr.setParentFrId(folderId);
					pdr.setLastUserId(null);
					pdr.setLogicalPath(folderId.toString() + "." + Constants.DOC_LIB_ROOT_ID_PROJECT);
					pdr.setProjectTypeId(ps.getProjectTypeId());
					pdr.setSourceId(dr.getSourceId());
					dr.setProjectTypeId(projectTypeId);
					for (DocResourcePO drp : listDoc) {
						DocLibPO docLib = docLibManager.getDocLibById(drp.getDocLibId());
						if (docLib != null) {
							if (DocMVCUtils.isProjectRoot(drp.getFrType(), drp.getId(), docLib)) {// 900--包括项目文档和所有项目类型的文件�?
								if (!needList.contains(pdr)) {
									needList.add(pdr);
								}
							}
						}
					}
					if (!listDoc.contains(pdr)) {
						listDoc.add(pdr);// 不加入pdr会导致项目类型文件夹�?直添加到needList,导致数据多余
					}
				}
			}
			needList.add(dr);
			listDoc.add(dr);
		}
		return needList;
    } 
    
    public void addPartTimeLibs(List<DocLibPO> libs) throws Exception {
        List<DocLibPO> partTimeLibs = docLibManager.getAllPartDocResouces(Constants.ACCOUNT_LIB_TYPE,
                AppContext.getCurrentUser());
        if (partTimeLibs == null) {
            return;
        }
        for (DocLibPO docLib : partTimeLibs) {
            if (!libs.contains(docLib))
                libs.add(docLib);
        }
    }
    
    @Override
    public List<DocResourcePO> findPageDocs(Integer first, Integer size, Long docId, Long userId, String frType,String type) throws BusinessException {
        return findPageDocs(first, size, docId, userId, frType, type, null);
    }
    @Override
    public Integer findAllDocCount(Long parentId, Long userId, String frType, String type) throws BusinessException {
        return findM1Docs(parentId, userId,frType,type,null).size();
    }

    /**
     * 通用文档夹查�? M1专用
     * @throws BusinessException 
     */
    public Integer findAllDocCount(Long parentId, Long userId,String frType,String type,String projectTypeId) throws BusinessException {
        return findM1Docs(parentId, userId,frType,type,projectTypeId).size();
    }

    /**
     * 通用文档夹查�?
     * @throws BusinessException 
     */
    public List<DocResourcePO> findPageDocs(Integer first,Integer size, Long parentId, Long userId,String frType,String type,String projectTypeId) 
    		throws BusinessException {
    	List<DocResourcePO> docs = findM1Docs(parentId, userId,frType,type,projectTypeId);
    	if(first<=1)
    		first = 1;
    	if(!docs.isEmpty()){
        	if(first+size>docs.size()){
        		return docs.subList(first-1, docs.size());
        	}else{
        		return docs.subList(first-1, first+size-1);
        	}
    	}
    	return docs;
    }


/**
 * 通用文档夹查�?
 * @throws BusinessException 
 */
private List<DocResourcePO> findM1Docs(Long parentId, Long userId,String frType2,String type,String projectTypeId) 
		throws BusinessException {
    DocResourcePO docRes = this.getDocResourceById(parentId);
    if (docRes == null)
    	return new ArrayList<DocResourcePO>();

    String orgIds = Constants.getOrgIdsOfUser(userId);
    Map<Long, Set<Integer>> parentAclMap = docAclManager.getGroupedAclSet(docRes, orgIds);
    Set<Integer> parentAcl = docAclManager.getDocResourceAclList(docRes, orgIds, parentAclMap);
    boolean parentHasPotent = false;
    for (Integer a : parentAcl) {
        if (a.intValue() != Constants.NOPOTENT){
            parentHasPotent = true;
            break;
        }
    }
    Long docLibId = null;
    DocLibPO docLib = null;
    Long frType = Long.valueOf(frType2);
    if ((frType == Constants.PERSON_BORROW || frType == Constants.PERSON_SHARE
        || frType == Constants.DEPARTMENT_BORROW) && !Constants.DOC_LIB_ROOT_ID_PROJECT.equals(parentId)) {
        docLib = this.docLibManager.getPersonalLibOfUser(userId);
        docLibId = docLib.getId();
    } else {
        docLibId = docRes.getDocLibId();
        docLib = docLibManager.getDocLibById(docLibId);
    }
    List<DocResourcePO> drs = null;
    if (docLib.isPersonalLib() && !Constants.PROJECT_LIB_TYPE.equals(docLib.getType())) {
        drs = this.findFolders(parentId, frType, userId, "", true,null);

	    List<DocResourcePO> remove = new ArrayList<DocResourcePO>();
        boolean hasPlan = Constants.hasMenuMyPlanOfCurrentUser();
        for (DocResourcePO dr : drs) {
            long type2 = dr.getFrType();
            // 我的计划判断
            if (type2 == Constants.FOLDER_PLAN || type2 == Constants.FOLDER_PLAN_DAY
                    || type2 == Constants.FOLDER_PLAN_MONTH || type2 == Constants.FOLDER_PLAN_WEEK
                    || type2 == Constants.FOLDER_PLAN_WORK) {
                if (!hasPlan)
    				remove.add(dr);
            }else if(type2 == Constants.FOLDER_SHARE || type2 == Constants.FOLDER_BORROW){
            	if("quote".equals(type) && docRes.getFrType()==Constants.FOLDER_MINE){
    				remove.add(dr);
                }
            }
        }
    	drs.removeAll(remove);
    } else {
        if (projectTypeId != null) {//5.1版本以后
            if (DocMVCUtils.isProjectRoot(frType, docRes.getId(), docLib)) {//项目文档根目�?
                drs = findFolders(parentId, frType, userId, orgIds, false, null);
                drs = DocMVCUtils.projectRootCategory(frType, docRes.getId(), docLib, drs, projectApi, orgManager);
            } else if (DocMVCUtils.isProjectVirtualCategory(frType, docRes.getId(), docLib, projectTypeId)) {//项目文档虚拟目录
//                //根据项目类型Id查询�?有项目id
//                List<ProjectBO> psList = projectApi.findProjectsByTypeIdAndMemberId(userId,Long.parseLong(projectTypeId));
//                List<Long> sourceIds = new ArrayList<Long>();//项目id
//                for (ProjectBO pSummary : psList) {
//                    sourceIds.add(pSummary.getId());
//                }
            	List<Long> sourceIds = projectApi.findProjectIdsByMemberAndType(userId, Long.parseLong(projectTypeId));
            	drs = findFolders(parentId, Constants.FOLDER_PROJECT_ROOT, userId, orgIds, false, sourceIds);
            } else {
                drs = findFolders(parentId, frType, userId, orgIds, false, null);
            }
        } else {
            drs = findFolders(parentId, frType, userId, orgIds, false, null);
        }
    }

    boolean isMy = docLibManager.isOwnerOfLib(userId, docLibId);
    if(parentHasPotent || isMy){
    	if(!isMy){
    	    for(Integer acl : parentAcl){
                if(acl==Constants.ALLPOTENT || acl ==Constants.EDITPOTENT  || acl == Constants.ADDPOTENT 
                        || acl ==Constants.READONLYPOTENT || acl == Constants.BROWSEPOTENT)
                    break;
            }
    	}
        if (frType == Constants.FOLDER_SHAREOUT || frType == Constants.FOLDER_BORROWOUT) {
            Long parentFrId = docRes.getParentFrId();
            drs.addAll(this.findAllDocsByPage(false,parentFrId, frType, userId,null));
        } else {
            Pagination.setFirstResult(0);
            Pagination.setMaxResults(-1);
            // 虚拟的DocResourcePO对象判断
            if (((frType == Constants.PERSON_SHARE) || (frType == Constants.PERSON_BORROW)
                    || (frType == Constants.DEPARTMENT_BORROW))&& !Constants.DOC_LIB_ROOT_ID_PROJECT.equals(parentId)) {
                List<DocResourcePO> l = this.findAllMyDocsByPage(parentId, frType, 1, -1, userId);
                for (DocResourcePO doc : l) {
                    if (!doc.getIsFolder()) {
                        drs.add(doc);
                    }
                }
            } else {
                if (!docLib.isPersonalLib()) {
                    // 只有写入权限时，只能查看自己创建的文�?
                    boolean justHasAddPotent = parentAcl != null
                            && ((parentAcl.size() == 1 && parentAcl.iterator().next() == Constants.ADDPOTENT) || (parentAcl
                                    .size() == 2 && parentAcl.contains(Constants.ADDPOTENT) && parentAcl
                                        .contains(Constants.NOPOTENT)));
                    if (justHasAddPotent) {
                        drs.addAll(docResourceDao.findDocFilesByFolder(parentId, userId));
                    } else {
                        drs.addAll(docResourceDao.findDocFilesByFolder(parentId, null));
                    }
                } else {
                    
                    
                    
                    List<DocResourcePO> l = this.findAllMyDocsByPage(parentId, frType, 1, -1, userId);
                    for (DocResourcePO doc : l) {
                        if (!doc.getIsFolder()) {
                            drs.add(doc);
                        }
                    }
                }
            }
        }
    }
	return drs;
}

    /**
     * 查询文档夹下收藏的文档id
     * 没有返回-1，有返回id
     * String 主要是�?�虑js中截取的问题
     */
    public String hasFavoriteDoc(Long parentDocId) throws BusinessException {
        DocResourcePO parentDocResource = getDocResourceById(parentDocId);
        String hql = "from DocResourcePO doc where doc.logicalPath like :logicalPath and (doc.sourceType =:sourceType1 or doc.sourceType =:sourceType2)";
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("logicalPath",  parentDocResource.getLogicalPath()+".%");
        params.put("sourceType1", DocSourceType.favorite.key());
        params.put("sourceType2", DocSourceType.favoriteAtt.key());
        List<DocResourcePO> docs = docResourceDao.find(hql, -1, -1, params);
        String docId = "-1";
        if(!docs.isEmpty()){
            docId = docs.get(0).getId().toString();
        }
        return docId;
    }
    
    /**
     * 找出�?有项目文档的根文�?
     */
    @Override
    public List<DocResourcePO> findProjectRootFolder() {
        String hql = "from DocResourcePO doc where doc.parentFrId=:parentFrId and doc.sourceId is not null";
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("parentFrId", Constants.DOC_LIB_ROOT_ID_PROJECT);
        return DBAgent.find(hql, params);
    }
    
    
    /**
     * 更新全文�?�?
    * @param docResId
    */
   private void updateIndex(Long docResId) {
           // 更新全文�?�?
           try {
               if (AppContext.hasPlugin("index")) {
                   indexManager.update(docResId, ApplicationCategoryEnum.doc.getKey());
               }
           } catch (Exception e) {
               log.error("更新文档[id=" + docResId + "]全文�?索信息时出现异常�?", e);
           }
   }
   
    public Map<String, Object> isPigeonholeArchive(String ids) {
        Map<ApplicationCategoryEnum, List<ArchiveVO>> appCode2DocsMap = appCode2DocsMap(docResourceDao.findPigeonholeArchive(CommonTools.parseStr2Ids(ids), Boolean.FALSE));
        List<DocResourcePO> docs = docResourceDao.findPigeonholeArchive(CommonTools.parseStr2Ids(ids), Boolean.TRUE);
        List<ArchiveVO> vos = new ArrayList<ArchiveVO>();
        for (DocResourcePO doc : docs) {
            vos.add(new ArchiveVO(doc.getId(), doc.getFrType(), doc.getFrName(), doc.getSourceId()));
        }
        return archiveApi.isPigeonholeArchive(appCode2DocsMap, vos);
    }
   
    public Map<String, Object> updatePigeonholeArchive(String ids, String isDuplicatePigeonhole) {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        List<Long> _ids = CommonTools.parseStr2Ids(ids);
        //找到业务id对应的文�?
        Map<ApplicationCategoryEnum, List<ArchiveVO>> appCode2DocsMap = appCode2DocsMap(docResourceDao.findPigeonholeArchive(_ids, Boolean.FALSE));
        List<ArchiveVO> pigDocList = archiveApi.updatePigeonholeArchive(appCode2DocsMap);
        resultMap.put("alert", ResourceUtil.getString("doc.archive.snyc.piged.js", pigDocList.size(), (_ids.size() - pigDocList.size())));
        Set<Long> docIds = new HashSet<Long>();
        for (ArchiveVO vo : pigDocList) {
            docIds.add(vo.getId());
        }
        docResourceDao.updatePigeonholeArchive(docIds);
        return resultMap;
    }
    
    private Map<ApplicationCategoryEnum, List<ArchiveVO>> appCode2DocsMap(List<DocResourcePO> _docList) {
        Map<ApplicationCategoryEnum, List<ArchiveVO>> appCode2DocsMap = new HashMap<ApplicationCategoryEnum, List<ArchiveVO>>();
        for (DocResourcePO doc : _docList) {
            ApplicationCategoryEnum appCode = Constants.getAppCodeByFrType(doc.getFrType());
            List<ArchiveVO> docList = appCode2DocsMap.get(appCode);
            if (docList == null) {
                docList = new ArrayList<ArchiveVO>();
                appCode2DocsMap.put(appCode, docList);
            }
            docList.add(new ArchiveVO(doc.getId(),doc.getFrType(),doc.getFrName(),doc.getSourceId()));
        }
        return appCode2DocsMap;
    }
   
   /**
    * 修改映射的名�?
    * @param docResourceId
    * @param newName
    */
   private void updateLinkName(Long docResourceId, String newName) {
       docResourceDao.updateLinkName(docResourceId, newName);
       //增加对映射文档全文检索的更新
       updateLink(docResourceId);
   }
   
   /**
    * 更新映射全文�?�?
    * @param docResourceId
    * @param newName
    */
   public void updateLink(Long docResourceId) {
       //增加对映射文档全文检索的更新
       List<Long> allLinks = docResourceDao.getAllLink(docResourceId);
       for(Long link:allLinks){
           this.updateIndex(link);
       }
   }

	@Override
	public String fileIllegal(String fileId) throws Exception {
    	return SecurityHelper.digest(fileId);
	}
	
    public void setProjectApi(ProjectApi projectApi) {
        this.projectApi = projectApi;
    }
    @Override
    public Map getDocMetadataMap(Long docResourceId) {
        return docMetadataDao.getDocMetadataMap(docResourceId);
    }
	public void setAppLogManager(AppLogManager appLogManager) {
		this.appLogManager = appLogManager;
	}
	public AttachmentManager getAttachmentManager() {
        return attachmentManager;
    }
	
    public ArchiveApi getArchiveApi() {
        return archiveApi;
    }
    public void setArchiveApi(ArchiveApi archiveApi) {
        this.archiveApi = archiveApi;
    }
    public void setWebmailApi(WebmailApi webmailApi) {
        this.webmailApi = webmailApi;
    }
    @Override
	public String getValidInfo(String docResIds) {
		String isExist = "0";
		String[] ids = docResIds.split(",");
		for(String id:ids){
			isExist = existValidate(Long.parseLong(id));
			if(!"0".equals(isExist)) {
	    		return isExist;
	    	}
		}
		return isExist;
	}
    /**
     * 新视图的ajax请求获取
     */
	@Override
	public String doc4newView(String params) throws BusinessException {
		Long userId = AppContext.currentUserId();
		Map map = (Map) JSONUtil.parseJSONString(params);
		int pageNo = Integer.parseInt(map.get("pageNo").toString());
		Long folderId = Long.parseLong(map.get("resId").toString());
		Long frType = Long.parseLong(map.get("frType").toString());
		String projectTypeId = "";
		if(map.get("projectTypeId")!=null){
			projectTypeId = map.get("projectTypeId").toString();
		}
		Long docLibId = Long.parseLong(map.get("docLibId").toString());
		//String docLibType = map.get("docLibType").toString();
		boolean isShareAndBorrowRoot = Boolean.parseBoolean(map.get("isShareAndBorrowRoot").toString());
		String all = map.get("all").toString();
		String edit = map.get("edit").toString();
		String add = map.get("add").toString();
		String readonly = map.get("readonly").toString();
		String browse = map.get("browse").toString();
		String list = map.get("list").toString();
		String v = map.get("v").toString();
		
		// 根据文档夹Id获得文档夹对�?
        DocResourcePO folder = this.getParenetDocResource(folderId, frType);
		DocLibPO docLib = docLibManager.getDocLibById(docLibId);
		Byte docLibType = docLib.getType();
        if (Strings.isNotBlank(map.get("docLibType").toString())) {
            docLibType = Byte.valueOf(map.get("docLibType").toString());
        }
		int entranceType = 2;
		// 在生成文档列表时，就把文档权限入口传�?
		if ((frType == Constants.FOLDER_BORROW || frType == Constants.FOLDER_SHAREOUT
                || frType == Constants.FOLDER_BORROWOUT || frType == Constants.FOLDER_SHARE
                || frType == Constants.PERSON_BORROW || frType == Constants.PERSON_SHARE
                || frType == Constants.DEPARTMENT_BORROW || frType == Constants.FOLDER_TEMPLET
                || frType == Constants.FOLDER_PLAN || frType == Constants.FOLDER_PLAN_DAY
                || frType == Constants.FOLDER_PLAN_MONTH || frType == Constants.FOLDER_PLAN_WEEK
                || frType == Constants.FOLDER_PLAN_WORK) && !Constants.PROJECT_LIB_TYPE.equals(docLibType)) {
            isShareAndBorrowRoot = true;
        }
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
        //公文档案库入口参�?
        }else if(docLib.getType() == Constants.EDOC_LIB_TYPE){
            entranceType = 9;
        } else {
           entranceType = 5;
        }
        
        Pagination.setFirstResult(30*pageNo);
        
        // 取得本页应该显示的DocResource对象
        List<DocResourcePO> allDrs = new ArrayList<DocResourcePO>();
        if (frType == Constants.FOLDER_SHAREOUT || frType == Constants.FOLDER_BORROWOUT) {
            Long parentFrId = folder.getParentFrId();
            allDrs = this.findAllDocsByPage(true,parentFrId, frType, userId,null);
        } else {
            //项目虚拟目录查询
            if (DocMVCUtils.isProjectVirtualCategory(frType, folderId, docLib,projectTypeId)) {
                //根据项目类型Id查询�?有项目id
//                List<ProjectBO> psList = projectApi.findProjectsByTypeIdAndMemberId(userId,Long.parseLong(projectTypeId));
//                List<Long> sourceIds = new ArrayList<Long>();//项目id
//                for (ProjectBO pSummary : psList) {
//                    sourceIds.add(pSummary.getId());
//                }
            	List<Long> sourceIds = projectApi.findProjectIdsByMemberAndType(userId, Long.parseLong(projectTypeId));
            	
            	allDrs = this.findAllDocsByPage(true,folderId, Constants.FOLDER_PROJECT_ROOT, userId,sourceIds);
            } else {
            	allDrs = this.findAllDocsByPage(true,folderId, frType, userId,null);
            	
            }
        }
        int rowCount = Pagination.getRowCount();
        // 根据 docLibId 得到有序的栏目元数据列表
        List<DocMetadataDefinitionPO> dmds = docLibManager.getListColumnsByDocLibId(docLibId,Constants.All_EDOC_ELMENT);

    	allDrs = DocMVCUtils.projectRootCategory(frType, folderId, docLib, allDrs,projectApi,orgManager);
    	List<DocTableVO> allDocs = this.getTableVOs(allDrs, dmds, userId, isShareAndBorrowRoot, docLibType, folder,
        		false,entranceType,map);
        List<Long> allDocIds = new ArrayList<Long>();
        for (DocTableVO allDoc : allDocs) {
        	allDocIds.add(allDoc.getDocResource().getId());
        }
        List<Map<String,Long>> allCollectFlag = knowledgeFavoriteManager.getFavoriteSource(allDocIds,AppContext.currentUserId());
        DocMVCUtils.handleCollect(allDocs,allCollectFlag);
    	Map<String,Object> m = new HashMap<String, Object>();
    	pageNo = pageNo+1;
    	m.put("allDocs", allDocs);
    	m.put("pageNo", pageNo);
        
    	m.put("onlyA6", DocMVCUtils.isOnlyA6());
    	m.put("onlyA6s", DocMVCUtils.isOnlyA6S());
    	m.put("isA6",DocMVCUtils.isOnlyA6()||DocMVCUtils.isOnlyA6S());//OA-74381  文档中心没有面包�?
        //G6
        boolean isG6 = DocMVCUtils.isGovVer()||DocMVCUtils.isG6Group();
        m.put("isGovVer",isG6);
        
        //不是个人，项目库，开启插�?
        m.put("entranceType", entranceType);
        String resJson = JSONUtil.toJSONString(m);
		return resJson;
	}
	
	
	private List<DocTableVO> getTableVOs(List<DocResourcePO> drs, List<DocMetadataDefinitionPO> dmds,
            Long userId, boolean isBorrowOrShare, byte docLibType, DocResourcePO parent, boolean isQuery,Integer entrance,Map map)
            throws BusinessException {
        List<DocTableVO> docs = new ArrayList<DocTableVO>();
        List<Integer> widths = DocMVCUtils.getColumnWidthNew(dmds);
        
        
        int pageNo = Integer.parseInt(map.get("pageNo").toString());
		Long folderId = Long.parseLong(map.get("resId").toString());
		Long frType = Long.parseLong(map.get("frType").toString());
		String projectTypeId = "";
		if(map.get("projectTypeId")!=null){
			projectTypeId = map.get("projectTypeId").toString();
		}
		Long docLibId = Long.parseLong(map.get("docLibId").toString());
		//String docLibType = map.get("docLibType").toString();
		boolean isShareAndBorrowRoot = Boolean.parseBoolean(map.get("isShareAndBorrowRoot").toString());
		String all = map.get("all").toString();
		String edit = map.get("edit").toString();
		String add = map.get("add").toString();
		String readonly = map.get("readonly").toString();
		String browse = map.get("browse").toString();
		String list = map.get("list").toString();
        
        // 没有数据时返回标题栏
        if (CollectionUtils.isEmpty(drs)) {
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
        } else {
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
                if (docLibType == Constants.EDOC_LIB_TYPE.byteValue() && DocMVCUtils.needFetchEdocMetadata(dmds)) {//�?要查询公文中的扩展属�?
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
                //显示\r\n的处�?
                dr.setFrName(dr.getFrName().replaceAll("\r\n", ""));
                // 单位借阅从左边目录树点击进去正常，从列表里面点击、单位�?�阅错误，发现传递的参数readOnly参数不同，，单位借阅时这里特意修�?
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
                // 设置其file属�??
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
                    	DocMVCUtils.setGottenAclsInVO(vo, userId, isBorrowOrShare, docAclManager);
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
                            log.error("getTableVos通过反射取得相应的栏目�?�时出现异常[属�?�名称：" + name + "]:", e);
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
                        // 判断是否引用类型元数据，取得相应属�??
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
                        

                    // �?要调用元数据组件
                    if (value != null && Strings.isNotBlank(value.toString())) {
                        EnumNameEnum mne = Constants.getMetadataNameEnum(dmd.getName(), value.toString(),
                                dr.getFrType());
                        if (mne != null) {
                            value = enumManagerNew.getEnumItemLabel(mne, value.toString());
                            value = DocMVCUtils.getDisplayName4MetadataDefinition(String.valueOf(value),
                                    value.toString());
                        }
                    }

                    //对数据升级问题文档夹记录数进行过�?(文档夹记录数默认�?0,其他不变)
                    if(dr.getIsFolder()&&"阅读".equals(DocMVCUtils.getDisplayName4MetadataDefinition(dmd.getName()))){
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
                
                
             // 如果是文档夹，计算安全访问的v�?
                if(dr.getIsFolder()) {
                	String v = SecurityHelper.digest(vo.getDocResource().getId(),vo.getDocResource().getFrType(),docLibId,
                    		docLibType,isShareAndBorrowRoot,vo.isAllAcl(),vo.isEditAcl(),
                			vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl());
                    vo.setV(v);
                }
                String parentCommentEnabled = "";
                String parentRecommendEnable = "";
                
                // 文档中心列表上的文档的属性操作安全�?�验�?
                String vForDocPropertyIframe = SecurityHelper.digest(folderId,vo.getDocResource().getId(),frType,docLibId,
                		docLibType,isShareAndBorrowRoot,vo.isAllAcl(),vo.isEditAcl(),
            			vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl(),parentCommentEnabled,parentRecommendEnable);
                vo.setvForDocPropertyIframe(vForDocPropertyIframe);
                // 文档中心列表上的借阅操作安全性验�?
                String vForBorrow = SecurityHelper.digest(vo.getDocResource().getId(),frType,
                		docLibType,isBorrowOrShare,vo.isAllAcl(),vo.isEditAcl(),vo.isAddAcl(),vo.isReadOnlyAcl(),vo.isBrowseAcl(),vo.isListAcl());
                vo.setvForBorrow(vForBorrow);
                docs.add(vo);
            }
        }

        if (CollectionUtils.isNotEmpty(docs) && isQuery) {
            Collections.sort(docs);
        }

        return docs;
    }
	
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
				log.error("查询协同结束状�?�异常：",e);
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
				log.error("查询公文结束状�?�异常：",e);
			}
		}
	}
	
	private DocResourcePO getParenetDocResource(Long folderId, Long frType) {
        DocResourcePO folder = this.getDocResourceById(folderId);
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
	
	
	public String seaDoc4newView(String params) throws BusinessException {
		String a = params.substring(34,params.length());
		String[] jsonStrs = a.split("&");
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < jsonStrs.length; i++) {
			String[] strings = jsonStrs[i].split("=");
			if(strings.length>1){
				String b = strings[0]+":'"+strings[1]+"',";
				sb.append(b);
			}
		}
		sb.substring(0, sb.length()-1).toString();
		String jsonStr = "{"+sb.substring(0, sb.length()-1).toString()+"}";
		Map map = (Map) JSONUtil.parseJSONString(jsonStr);
		int pageNo = Integer.parseInt(map.get("pageNo").toString());
        Byte docLibType = Byte.valueOf(map.get("docLibType").toString());
        // 在生成文档列表时，就把文档权限入口传�? 入口参数参�?�EntranceTypeEnum.java
        int entranceType = 2;
        if(!Constants.PERSONAL_LIB_TYPE.equals(docLibType)) {
        	entranceType = 1;
        } else if(Constants.EDOC_LIB_TYPE.equals(docLibType)){
            entranceType = 9;
        } else {
           entranceType = 5;
        }
        Long docLibId = Long.valueOf(map.get("docLibId").toString());
        DocLibPO docLib = docLibManager.getDocLibById(docLibId);

        Long resId = Long.valueOf(map.get("resId").toString());
        Long frType = Long.valueOf(map.get("frType").toString());
        DocResourcePO parent = this.getParenetDocResource(resId, frType);
        
        	
    	List<DocTableVO> allDocs = this.getQueryResultVOs(parent, docLibId, docLibType,true,map);
    	List<DocResourcePO> allDrs = new ArrayList<DocResourcePO>();
    	for (DocTableVO dtv : allDocs) {
        	allDrs.add(dtv.getDocResource());
        }
    	handleOpenSquare(parent,docLib,allDrs,allDocs);
        
    	Map<String,Object> m = new HashMap<String, Object>();
    	pageNo = pageNo+1;
    	m.put("allDocs", allDocs);
    	m.put("pageNo", pageNo);
        
    	m.put("onlyA6", DocMVCUtils.isOnlyA6());
    	m.put("onlyA6s", DocMVCUtils.isOnlyA6S());
    	m.put("isA6",DocMVCUtils.isOnlyA6()||DocMVCUtils.isOnlyA6S());//OA-74381  文档中心没有面包�?
        //G6
        boolean isG6 = DocMVCUtils.isGovVer()||DocMVCUtils.isG6Group();
        m.put("isGovVer",isG6);
        
        //不是个人，项目库，开启插�?
        m.put("entranceType", entranceType);
        String resJson = JSONUtil.toJSONString(m);
		
		
		return resJson;
	}
	
	
	private void handleOpenSquare(DocResourcePO parentFolder, DocLibPO docLib,List<DocResourcePO> drs, List<DocTableVO> docs) {
        if (DocUtils.isOpenToZoneFlag() && (this.isPersonalLib(parentFolder.getDocLibId()) || docLib.isPersonalLib())) {//仅仅个人文档库才�?要查询公�?到广场的标记
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
	
	private boolean isDocument(Long frType){
       return  frType==Constants.FOLDER_COMMON||frType==Constants.DOCUMENT;
    }
	
	
	private List<DocTableVO> getQueryResultVOs(DocResourcePO parent, Long docLibId,
            Byte docLibType, boolean isSimpleQuery,Map map) throws BusinessException {
        Long resId = NumberUtils.toLong(map.get("resId").toString());
        List<DocResourcePO> result1 = null;
        List<DocMetadataDefinitionPO> dmds = docLibManager.getListColumnsByDocLibId(docLibId,Constants.All_EDOC_ELMENT);
        Integer pageNo = Integer.parseInt(map.get("pageNo").toString());
        if (isSimpleQuery) {
            SimpleDocQueryModel simpleQueryModel = this.parseRequest(map);
            result1 = this.getSimpleQueryResult(true,simpleQueryModel, resId, docLibType,pageNo);
        } 
        Long userId = AppContext.currentUserId();
        boolean isShareAndBorrow = BooleanUtils.toBoolean(map.get("isShareAndBorrowRoot").toString());
        List<DocTableVO> docs = null;
        docs = this.getTableVOs(result1, dmds,userId, isShareAndBorrow, docLibType, parent,true,null,map);
        return docs;
    }
	
	public static SimpleDocQueryModel parseRequest(Map map) {
		String nameAndType = map.get("propertyNameAndType").toString();
		return parseRequest(nameAndType, map);
	}
	
	
	public static SimpleDocQueryModel parseRequest(String nameAndType, Map<String,String> map) {
		if(Strings.isNotBlank(nameAndType)) {
			String[] p_t = StringUtils.split(nameAndType, '|');
			if(p_t != null && p_t.length > 0) {
				SimpleDocQueryModel sdm = new SimpleDocQueryModel();
				sdm.setPropertyName(p_t[0]);
				sdm.setPropertyType(NumberUtils.toInt(p_t[1]));
				
				if(sdm.getPropertyType() == Constants.DATE || sdm.getPropertyType() == Constants.DATETIME) {
					sdm.setValue1(map.get(sdm.getPropertyName() + BEGIN_TIME));
					sdm.setParamName1(sdm.getPropertyName() + BEGIN_TIME);
					
					sdm.setValue2(map.get(sdm.getPropertyName() + END_TIME));
					sdm.setParamName2(sdm.getPropertyName() + END_TIME);
				}
				else if(sdm.getPropertyType() == Constants.USER_ID || sdm.getPropertyType() == Constants.DEPT_ID) {
					sdm.setValue1(map.get(sdm.getPropertyName()));
					sdm.setParamName1(sdm.getPropertyName());
					
					sdm.setValue2(map.get(sdm.getPropertyName() + ORG_NAME));
					sdm.setParamName2(sdm.getPropertyName() + ORG_NAME);
				}
				else if(sdm.getPropertyType() == Constants.CONTENT_TYPE) {
					// 历史原因，避免与url中的frType变量重名冲突
					sdm.setValue1(map.get(sdm.getPropertyName() + "Value"));
					sdm.setParamName1(sdm.getPropertyName());
				}
				else {
					sdm.setValue1(map.get(sdm.getPropertyName()));
					sdm.setParamName1(sdm.getPropertyName());
				}
				sdm.setSimple(BooleanUtils.toBoolean(map.get(sdm.getPropertyName() + IS_DEFAULT)));
				return sdm;
			}
		}
		return null;
	}
	
	@Override
	public List<DocResourcePO> findByFrName(String frName) {
		String hql = " from DocResourcePO doc where doc.isFolder = :isFolder and doc.frName like :frName and doc.frType in (:frType)";
        Map<String,Object> params = new HashMap<String,Object>();
        List<Long> frType = new ArrayList<Long>();
        frType.add(Constants.FOLDER_COMMON);// 31普�?�文档夹
        frType.add(Constants.FOLDER_CASE);//38 项目文档�?
        frType.add(Constants.FOLDER_CASE_PHASE);//39 项目阶段文档�?
        frType.add(Constants.FOLDER_EDOC);//48 公文文档�?
        params.put("isFolder", true);
        params.put("frName", "%" + SQLWildcardUtil.escape(frName)+"%");
        params.put("frType", frType);
        return DBAgent.find(hql, params);
	}

	@Override
	public List<DocResourcePO> getDocsByDocLibId(Long docLibId){
		return docResourceDao.getDocsByLibId(docLibId);
	}
	
	@Override
    public List<DocResourcePO> findFavoriteByCondition(Map<String,Object> map) {
    	return docResourceDao.findFavoriteByCondition(map);
    }
	
	@Override
	public List<Long> getDocsByParentFrId(Long parentFrId) {
		return docResourceDao.getDocsByParentFrId(parentFrId);
	}
	
	@Override
	public void updateDocResourceFRNameByColSummaryId(String frname, Long summaryId) {
		try {
			//1、根据objectId查询affairId
			List<Long> sourceIdList = affairManager.getAllAffairIdByAppAndObjectId(ApplicationCategoryEnum.collaboration, summaryId);
			//2、更新frname�?
			if(sourceIdList != null && sourceIdList.size() > 0){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("frName", frname);
				params.put("sourceIds", sourceIdList);
				String hql = "update DocResourcePO set frName=:frName where sourceId in(:sourceIds)";
				DBAgent.bulkUpdate(hql, params);
			}
		} catch (BusinessException e) {
			log.error("更新docResourceFRName异常�?",e);
		}
	}
	
	@Override
	public void updateDocMetadataAvarchar1ByColSummaryId(String avarchar1, Long summaryId) {
		try {
			//1、根据objectId查询affairId
			List<Long> sourceIdList = affairManager.getAllAffairIdByAppAndObjectId(ApplicationCategoryEnum.collaboration, summaryId);
			if(sourceIdList != null && sourceIdList.size() > 0){
				//2、根据sourceId查询 doc_resource_id
				Map<String, Object> resParams = new HashMap<String, Object>();
				resParams.put("sourceIds", sourceIdList);
				List<Long> ids = DBAgent.find("select id from DocResourcePO where sourceId in (:sourceIds)",resParams);
				if(ids != null && ids.size() > 0){
					//3、根据resource_id更新doc_metadata字段
					for(Long id:ids){
						Map paramap = new HashMap();
						paramap.put("avarchar1", avarchar1);
						docMetadataManager.updateMetadata(id, paramap);
					}
				}
			}
		} catch (BusinessException e) {
			log.error("更新DocMetadataAvarchar1异常�?",e);
		}
	}

	@Override
	public List<DocResourcePO> findResourceFromShareAndBorrow(Long userId, SimpleDocQueryModel sdqm, Byte shareType)
			throws BusinessException {
		String orgIds = Constants.getOrgIdsOfUser(userId);
		List<DocResourcePO> list = new ArrayList<DocResourcePO>();
		Set<Long> docIds = docAclManager.getAllBorrowResourceIds(orgIds, shareType);
		list = this.getDocsByIds(docIds);
		if(!CollectionUtils.isEmpty(list)){
			List<String> logicPaths = new UniqueList<String>();
			for (DocResourcePO docResourcePO : list) {
				logicPaths.add(docResourcePO.getLogicalPath());
			}
			DocSearchModel dsm = new DocSearchModel(sdqm);
	        List<DocResourcePO> docs = docResourceDao.getDocResourceByLogicPathLike(logicPaths, dsm);
			return CommonTools.pagenate(docs);
		}else{
			return list;
		}
	}

}