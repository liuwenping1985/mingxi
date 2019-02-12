package com.seeyon.apps.doc.manager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Observable;
import java.util.Observer;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.doc.dao.DocLibDao;
import com.seeyon.apps.doc.dao.DocLibMemberDao;
import com.seeyon.apps.doc.dao.DocLibOwnerDao;
import com.seeyon.apps.doc.dao.DocListColumnDao;
import com.seeyon.apps.doc.dao.DocResourceDao;
import com.seeyon.apps.doc.dao.DocSearchConfigDao;
import com.seeyon.apps.doc.dao.DocTypeListDao;
import com.seeyon.apps.doc.po.DocAcl;
import com.seeyon.apps.doc.po.DocLibMemberPO;
import com.seeyon.apps.doc.po.DocLibOwnerPO;
import com.seeyon.apps.doc.po.DocLibPO;
import com.seeyon.apps.doc.po.DocListColumnPO;
import com.seeyon.apps.doc.po.DocMetadataDefinitionPO;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.doc.po.DocSearchConfigPO;
import com.seeyon.apps.doc.po.DocTypeListPO;
import com.seeyon.apps.doc.po.DocTypePO;
import com.seeyon.apps.doc.po.Potent;
import com.seeyon.apps.doc.util.Constants;
import com.seeyon.apps.doc.util.Constants.OperEnum;
import com.seeyon.apps.doc.util.DocMVCUtils;
import com.seeyon.apps.doc.vo.DocLibTableVo;
import com.seeyon.apps.edoc.bo.EdocElementBO;
import com.seeyon.apps.storage.manager.DocSpaceManager;
import com.seeyon.ctp.common.AbstractSystemInitializer;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.cache.CacheAccessable;
import com.seeyon.ctp.common.cache.CacheFactory;
import com.seeyon.ctp.common.cache.CacheMap;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.dao.paginate.Pagination;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.Strings;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class DocLibManagerImpl extends AbstractSystemInitializer implements DocLibManager, Observer {
    private static final Log                                   log                         = LogFactory.getLog(DocLibManagerImpl.class);
    private final CacheAccessable                              factory                     = CacheFactory.getInstance(DocLibManagerImpl.class);
    // <文档库id,文档栏目列表>
    private CacheMap<Long, ArrayList<DocMetadataDefinitionPO>> columnTable;
    // <文档库id,查询条件设置列表>
    private CacheMap<Long, ArrayList<DocMetadataDefinitionPO>> searchConditionTable;
    //<文档库id,文档库内容类型>
    private CacheMap<Long, ArrayList<DocTypePO>>               contentTypeTable;
    // “新建”菜单下拉选择的DocTypePO
    private CacheMap<Long, ArrayList<DocTypePO>>               contentTypeTableForNew;
    // 文档类的DocTypePO 选择，即新建、编辑页面的选择
    private CacheMap<Long, ArrayList<DocTypePO>>               contentTypeTableForDoc;
    // 默认查询条件
    private List<DocMetadataDefinitionPO>                      defaultSearchConditions     = null;
    // 默认公文档案库查询条件
    private List<DocMetadataDefinitionPO>                      defaultEdocSearchConditions = null;
    // 所有公共文档库
    private CacheMap<Long, DocLibPO>                           publicDocLibsMap;
    // 文档库管理员集合， 包含个人库 Map<libId, List<memberId>>
    private CacheMap<Long, ArrayList<Long>>                    docLibOwnersMap;
    private DocLibDao                                          docLibDao;
    private ContentTypeManager                                 contentTypeManager;
    private MetadataDefManager                                 metadataDefManager;
    private DocLibOwnerDao                                     ownerDao;
    private DocSpaceManager                                    docSpaceManager;
    private DocHierarchyManager                                docHierarchyManager;
    private OrgManager                                         orgManager;
    private DocListColumnDao                                   docListColumnDao;
    private DocSearchConfigDao                                 docSearchConfigDao;
    private DocTypeListDao                                     docTypeListDao;
    private DocLibMemberDao                                    docLibMemberDao;
    private DocResourceDao                                     docResourceDao;
    private DefaultListColumn                                  defaultListColumn;
    private DefaultSearchCondition                             defaultSearchCondition;
    private DocAclManager                                      docAclManager;
    private DocAlertManager                                    docAlertManager;

    public void setDocSearchConfigDao(DocSearchConfigDao docSearchConfigDao) {
        this.docSearchConfigDao = docSearchConfigDao;
    }

    public void setDefaultListColumn(DefaultListColumn defaultListColumn) {
        this.defaultListColumn = defaultListColumn;
    }

    public void setDefaultSearchCondition(DefaultSearchCondition defaultSearchCondition) {
        this.defaultSearchCondition = defaultSearchCondition;
    }

    public void setDocResourceDao(DocResourceDao docResourceDao) {
        this.docResourceDao = docResourceDao;
    }

    public void setDocLibMemberDao(DocLibMemberDao docLibMemberDao) {
        this.docLibMemberDao = docLibMemberDao;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setDocHierarchyManager(DocHierarchyManager docHierarchyManager) {
        this.docHierarchyManager = docHierarchyManager;
    }

    public void setDocSpaceManager(DocSpaceManager docSpaceManager) {
        this.docSpaceManager = docSpaceManager;
    }

    public void setMetadataDefManager(MetadataDefManager metadataDefManager) {
        this.metadataDefManager = metadataDefManager;
    }

    public void setDocLibDao(DocLibDao docLibDao) {
        this.docLibDao = docLibDao;
    }

    public void setOwnerDao(DocLibOwnerDao ownerDao) {
        this.ownerDao = ownerDao;
    }

    public void setContentTypeManager(ContentTypeManager contentTypeManager) {
        this.contentTypeManager = contentTypeManager;
    }

    public void setDocTypeListDao(DocTypeListDao docTypeListDao) {
        this.docTypeListDao = docTypeListDao;
    }

    public void setDocListColumnDao(DocListColumnDao docListColumnDao) {
        this.docListColumnDao = docListColumnDao;
    }

    public void setDocAclManager(DocAclManager docAclManager) {
        this.docAclManager = docAclManager;
    }

    public void setDocAlertManager(DocAlertManager docAlertManager) {
        this.docAlertManager = docAlertManager;
    }

    private void validSystemProjectLib() {
        // 1. 查找项目库
        String hql = "from DocLibPO where type = " + Constants.PROJECT_LIB_TYPE;
        List<DocLibPO> libs = this.docLibDao.findVarargs(hql);
        if (Strings.isEmpty(libs)) {
            log.error("系统缺少项目文档库，请初始化系统数据！");
            return;
        } else {
            boolean hasProject = false;
            for (DocLibPO lib : libs) {
                if (lib.getId().longValue() == Constants.DOC_LIB_ID_PROJECT.longValue()) {
                    hasProject = true;
                    break;
                }
            }
            if (!hasProject) {
                log.error("系统缺少项目文档库，请初始化系统数据！");
                return;
            }
        }
        // 2. 看是否有多余的项目库
        for (DocLibPO lib : libs) {
            if (lib.getId().longValue() != Constants.DOC_LIB_ID_PROJECT.longValue()) {
                DocResourcePO root = this.docHierarchyManager.getRootByLibId(lib.getId());
                if (root != null) {
                    List<DocResourcePO> list = this.docHierarchyManager.getAllFirstChildren(root.getId());
                    if (list != null)
                        for (DocResourcePO dr : list) {
                            this.docHierarchyManager.moveDocWithoutAcl4Project(dr);
                        }
                }
                this.deleteInvalidProject(lib.getId(), root);
                log.info("统一项目文档库：" + lib.getId());
            }
        }
    }

    @Override
    public void initialize() {
        //项目文档库统一
        this.validSystemProjectLib();

        //加载文档属性数据到内存
        metadataDefManager.init();

        //加载内容类型数据到内存
        contentTypeManager.init();

        // 加载文档库显示栏目数据到内存
        this.init();

        log.info("文档管理初始化数据加载成功!");
    }

    private synchronized CacheMap createMap(String cacheName) {
        if (factory.isExist(cacheName)) {
            return factory.getMap(cacheName);
        }
        return factory.createMap(cacheName);
    }

    private synchronized void init() {
        columnTable = createMap("columnTable");
        searchConditionTable = createMap("searchConditionTable");
        contentTypeTable = createMap("contentTypeTable");
        contentTypeTableForNew = createMap("contentTypeTableForNew");
        contentTypeTableForDoc = createMap("contentTypeTableForDoc");
        publicDocLibsMap = createMap("publicDocLibsMap");
        docLibOwnersMap = createMap("docLibOwnersMap");

        defaultSearchConditions = this.defaultSearchCondition.getDefaultSearchCondition();
        defaultEdocSearchConditions = this.defaultSearchCondition.getDefaultEdocSearchCondition();

        columnTable.clear();
        searchConditionTable.clear();
        contentTypeTable.clear();
        contentTypeTableForNew.clear();
        contentTypeTableForDoc.clear();

        // 文档库管理员
        initLibOwner();

        List<DocLibPO> docLibs = docLibDao.getDocLibs();
        if (Strings.isEmpty(docLibs)) {
            return;
        }

        for (DocLibPO docLib : docLibs) {
            if (!AppContext.hasPlugin("project") && docLib.getType() == Constants.PROJECT_LIB_TYPE) { //a6s下不显示项目文档
                continue;
            }
            if (!AppContext.hasPlugin("edoc") && docLib.getType() == Constants.EDOC_LIB_TYPE) { //a6s下不显示公文档案
                continue;
            }

            this.initPartAdd(Arrays.asList(docLib), false);
        }
    }

    //文档库管理员
    private void initLibOwner() {
        docLibOwnersMap.clear();
        List<DocLibOwnerPO> owners = ownerDao.findVarargs("from " + DocLibOwnerPO.class.getCanonicalName() + " order by sortId asc");
        if (owners != null) {
            for (DocLibOwnerPO dlo : owners) {
                ArrayList<Long> list = docLibOwnersMap.get(dlo.getDocLibId());
                if (list == null) {
                    list = new ArrayList<Long>();
                }
                list.add(dlo.getOwnerId());
                docLibOwnersMap.put(dlo.getDocLibId(), list);
            }
        }
    }

    // 个人库增加
    private void initPartAddPersonal(DocLibPO lib, long memberId) {
        if (lib == null) {
            return;
        }
        ArrayList<Long> set = docLibOwnersMap.get(lib.getId());
        if (set == null) {
            set = new ArrayList<Long>();
            docLibOwnersMap.put(lib.getId(), set);
        }
        set.add(memberId);
    }

    public synchronized void initPart(OperEnum oper, List<DocLibPO> libs) {
        if (Strings.isEmpty(libs) || oper == null) {
            return;
        }
        if (OperEnum.add == oper) {
            this.initPartAdd(libs, true);
        } else if (OperEnum.edit == oper) {
            this.initPartEdit(libs);
        } else if (OperEnum.delete == oper) {
            this.initPartDelete(libs);
        }
    }

    private void initPartAdd(List<DocLibPO> libs, boolean initLibOwner) {
        for (int i = 0; i < libs.size(); i++) {
            DocLibPO docLib = libs.get(i);
            long docLibId = docLib.getId();
            publicDocLibsMap.put(docLibId, docLib);

            if (initLibOwner) {
                ArrayList<Long> ovs = new ArrayList<Long>();
                List<DocLibOwnerPO> ols = this.ownerDao.findVarargs("from DocLibOwnerPO where docLibId = ? order by sortId asc", docLibId);
                if (Strings.isNotEmpty(ols)) {
                    for (DocLibOwnerPO dlo : ols) {
                        ovs.add(dlo.getOwnerId());
                    }
                }
                docLibOwnersMap.put(docLibId, ovs);
            }

            if (!docLib.getIsDefault() || docLib.getType() == Constants.EDOC_LIB_TYPE.byteValue()) {
                this.cacheListColumns(docLibId);
            }

            if (!docLib.getIsSearchConditionDefault()) {
                this.cacheSearchConfigs(docLibId);
            }

            List<DocTypeListPO> docTypeList = docTypeListDao.getDocTypeList(docLibId);
            ArrayList<DocTypePO> contentTypes = new ArrayList<DocTypePO>(); // all
            ArrayList<DocTypePO> contentTypes2 = new ArrayList<DocTypePO>(); // for doc
            ArrayList<DocTypePO> contentTypes3 = new ArrayList<DocTypePO>(); // for new
            if (Strings.isNotEmpty(docTypeList)) {
                for (int j = 0; j < docTypeList.size(); j++) {
                    DocTypeListPO temp = docTypeList.get(j);
                    DocTypePO docType = contentTypeManager.getContentTypeById(temp.getDocTypeId());
                    if (docType.getStatus() != Constants.CONTENT_TYPE_DELETED) {
                        contentTypes.add(docType);
                    }
                    if (docType.getParentType() == Constants.CONTENT_CATEGORY_DOCUMENT && docType.getStatus() != Constants.CONTENT_TYPE_DELETED) {
                        contentTypes2.add(docType);
                    } else if (docType.getStatus() != Constants.CONTENT_TYPE_DELETED) {
                        contentTypes3.add(docType);
                    }
                }
            }

            DocTypePO typeDoc = contentTypeManager.getContentTypeById(Constants.DOCUMENT);
            contentTypes2.add(typeDoc);

            contentTypeTable.put(docLibId, contentTypes);
            contentTypeTableForDoc.put(docLibId, contentTypes2);
            contentTypeTableForNew.put(docLibId, contentTypes3);
        }
    }

    private void initPartEdit(List<DocLibPO> libs) {
        this.initPartDelete(libs);
        this.initPartAdd(libs, true);
    }

    private void initPartDelete(List<DocLibPO> libs) {
        for (DocLibPO lib : libs) {
            columnTable.remove(lib.getId());
            searchConditionTable.remove(lib.getId());
            contentTypeTable.remove(lib.getId());
            contentTypeTableForNew.remove(lib.getId());
            contentTypeTableForDoc.remove(lib.getId());
            publicDocLibsMap.remove(lib.getId());
            docLibOwnersMap.remove(lib.getId());
        }
    }

    private void cacheListColumns(long docLibId) {
        List<DocListColumnPO> columns = docListColumnDao.findColumnByOrderNum(docLibId);
        if (columns != null && columns.size() > 0) {
            ArrayList<DocMetadataDefinitionPO> metadataDefs = new ArrayList<DocMetadataDefinitionPO>();
            for (int j = 0; j < columns.size(); j++) {
                DocListColumnPO column = columns.get(j);
                long metadataDefId = column.getMetadataDefiniotionId();
                DocMetadataDefinitionPO metadataDef = metadataDefManager.getMetadataDefById(metadataDefId);
                if (metadataDef == null) {
                    metadataDef = new DocMetadataDefinitionPO();
                    metadataDef.setId(metadataDefId);
                    metadataDef.setIsEdocElement(true);
                }
                metadataDefs.add(metadataDef);
            }
            columnTable.put(docLibId, metadataDefs);
        } else {
            columnTable.remove(docLibId);
            this.docLibDao.bulkUpdate("update DocLibPO set isDefault = true where id = ?", null, docLibId);
        }
    }

    private void cacheSearchConfigs(long docLibId) {
        List<DocSearchConfigPO> sconfigs = this.docSearchConfigDao.getSearchConfigs4Lib(docLibId);
        if (CollectionUtils.isNotEmpty(sconfigs)) {
            ArrayList<DocMetadataDefinitionPO> metadataDefs = new ArrayList<DocMetadataDefinitionPO>(sconfigs.size());
            for (DocSearchConfigPO sc : sconfigs) {
                Long metadataDefiniotionId = sc.getMetadataDefiniotionId();
                DocMetadataDefinitionPO metadataDef = metadataDefManager.getMetadataDefById(metadataDefiniotionId);
                if (metadataDef == null) {
                    metadataDef = new DocMetadataDefinitionPO();
                    metadataDef.setId(metadataDefiniotionId);
                    metadataDef.setIsEdocElement(true);
                }
                metadataDefs.add(metadataDef);
            }
            searchConditionTable.put(docLibId, metadataDefs);
        } else {
            searchConditionTable.remove(docLibId);
            this.docLibDao.bulkUpdate("update DocLibPO set isSearchConditionDefault = true where id = ?", null, docLibId);
        }
    }

    private void initVirtualLib(DocLibPO doclib) {
        if (doclib == null) {
            return;
        }

        docLibDao.restoreVirtualLib(doclib.getId());
        this.deleteDocTypeList(doclib.getId());
        this.deleteListColumn(doclib.getId());
        this.deleteSearchConfigs(doclib.getId());

        initPart(OperEnum.edit, Arrays.asList(doclib));
    }

    public long addDocLib(DocLibPO doclib, Long domainId, List<Long> owners) throws BusinessException {
        Date now = new Date(System.currentTimeMillis());
        doclib.setIdIfNew();
        doclib.setType(Constants.USER_CUSTOM_LIB_TYPE);
        doclib.setCreateUserId(-1L);
        doclib.setCreateTime(now);
        doclib.setLastUserId(-1L);
        doclib.setLastUpdate(now);
        doclib.setDomainId(domainId);
        doclib.setOrderNum(this.getMaxDocLibOrder(domainId) + 1);
        DocLibPO virtualLib = docLibDao.get(domainId);
        boolean isDefault = (virtualLib == null ? true : virtualLib.getIsDefault());
        boolean isSearchConditionDefault = (virtualLib == null ? true : virtualLib.getIsSearchConditionDefault());
        doclib.setIsDefault(isDefault);
        doclib.setIsSearchConditionDefault(isSearchConditionDefault);
        docLibDao.save(doclib);

        // 添加文档库管理员，处理内容类型、显示栏目、查询条件
        this.addDocLibOwners(doclib.getId(), owners);
        docTypeListDao.batchUpdateDocLibId(domainId, doclib.getId());
        docListColumnDao.batchUpdateDocLibId(domainId, doclib.getId());
        docSearchConfigDao.batchUpdateDocLibId(domainId, doclib.getId());
        docHierarchyManager.initCustomLib(doclib.getId(), doclib.getName(), -1L);

        initPart(OperEnum.add, Arrays.asList(doclib));

        this.initVirtualLib(virtualLib);

        return doclib.getId();
    }

    public boolean addVirtualDocLib(long domainId) {
        try {
            DocLibPO doclib = new DocLibPO();
            doclib.setId(domainId);
            doclib.setName("virtual_system");
            doclib.setDescription("virtual_system");
            doclib.setType(Constants.USER_CUSTOM_LIB_TYPE);
            doclib.setTypeEditable(true);
            doclib.setColumnEditable(true);
            doclib.setFolderEnabled(true);
            doclib.setIsHidden(false);
            doclib.setCreateUserId(-1L);
            doclib.setCreateTime(new Date());
            doclib.setLastUserId(-1L);
            doclib.setLastUpdate(new Date());
            doclib.setStatus(Constants.DOC_LIB_ENABLED);
            doclib.setIsDefault(true);
            doclib.setOrderNum(0);
            doclib.setListByDefaultOrder(true);
            doclib.setOfficeEnabled(true);
            doclib.setA6Enabled(true);
            doclib.setUploadEnabled(true);
            doclib.setLogView(false);
            doclib.setDomainId(domainId);
            doclib.setPrintLog(false);
            doclib.setDownloadLog(false);
            doclib.setSearchConditionEditable(true);
            doclib.setIsSearchConditionDefault(true);

            docLibDao.save(doclib);

            // 重新加载文档库显示栏目数据到内存中
            initPart(OperEnum.add, Arrays.asList(doclib));
        } catch (Exception e) {
            log.error("新建虚拟库时出现异常[单位id=" + domainId + "]：", e);
            return false;
        }
        return true;
    }

    /**
     * 新建个人文档库，创建用户时调用此接口。
     */
    public DocLibPO addDocLib(long userId) throws BusinessException {
    	DocLibPO lib = getPersonalLibOfUser1(userId);
        if (lib != null) {
        	return lib;
        }
        DocLibPO doc_lib = this.saveDocLib(userId);
        this.initPartAddPersonal(doc_lib, userId);
        return doc_lib;
    }

    private DocLibPO saveDocLib(Long userId) throws BusinessException {
        DocLibPO doclib = new DocLibPO();
        doclib.setIdIfNew();
        doclib.setName("doc.contenttype.mydoc");
        doclib.setDescription("");
        doclib.setType(Constants.PERSONAL_LIB_TYPE);// 个人文档库

        doclib.setTypeEditable(false);
        doclib.setListByDefaultOrder(true);
        doclib.setColumnEditable(false);
        doclib.setSearchConditionEditable(false);
        doclib.setLogView(false);
        doclib.setFolderEnabled(true);
        doclib.setA6Enabled(true);
        doclib.setOfficeEnabled(true);
        doclib.setUploadEnabled(true);

        doclib.setIsHidden(false);
        doclib.setCreateUserId(userId); // 个人文档库的创建者默认为该库的所有者
        doclib.setCreateTime(new Date());
        doclib.setLastUserId(userId);
        doclib.setLastUpdate(new Date());
        doclib.setStatus(Constants.DOC_STATUS);
        doclib.setIsDefault(true);
        doclib.setIsSearchConditionDefault(true);
        doclib.setOrderNum(0); //个人文档库的顺序统一为0
        doclib.setShareEnabled(true);;
        docLibDao.save(doclib);
        // 增加个人文档库根节点
        docHierarchyManager.initPersonalLib(doclib.getId(), doclib.getName(), userId);
        this.addDocLibOwners(doclib.getId(), userId); // 对个人文档库授权
        docSpaceManager.addDocSpace(userId, 0L, 0L); // 分配空间

        log.debug("新建用户userId=" + userId + "时,成功新建了该用户的个人文档库!");

        return doclib;
    }

    public void addSysDocLibs(long domainId) throws BusinessException {
        DocLibPO docLibPO = this.getDeptLibById(domainId);
        if (docLibPO != null) {
            return;
        }

        // 导入导出时，没有当前用户
        // 并且这个创建用户已经失去意义，系统下只能取到系统管理员
        Long userId = -1l;
        long nowTime = System.currentTimeMillis();
        // 创建单位文档库
        DocLibPO docLib = new DocLibPO();
        docLib.setIdIfNew();
        docLib.setName("doc.contenttype.danweiwendang");
        docLib.setType(Constants.ACCOUNT_LIB_TYPE);
        docLib.setDescription("");

        docLib.setA6Enabled(true);
        docLib.setOfficeEnabled(true);
        docLib.setFolderEnabled(true);
        docLib.setUploadEnabled(true);
        docLib.setColumnEditable(true);
        docLib.setSearchConditionEditable(true);
        docLib.setListByDefaultOrder(true);
        docLib.setLogView(false);

        docLib.setIsDefault(true);
        docLib.setIsSearchConditionDefault(true);
        docLib.setIsHidden(false);
        docLib.setTypeEditable(true);
        docLib.setStatus(Constants.DOC_LIB_ENABLED);

        docLib.setCreateTime(new Date(nowTime));
        docLib.setCreateUserId(userId);
        docLib.setLastUpdate(new Date(nowTime));
        docLib.setLastUserId(userId);
        docLib.setOrderNum(1);
        docLib.setDomainId(domainId);
        docLibDao.save(docLib);

        //增加单位文档库根节点
        docHierarchyManager.initCorpLib(docLib.getId(), docLib.getName(), userId);

        // 创建公文档案库
        DocLibPO docLib2 = new DocLibPO();
        docLib2.setIdIfNew();
        docLib2.setName("doc.contenttype.gongwendangan");
        docLib2.setType(Constants.EDOC_LIB_TYPE);
        docLib2.setDescription("");

        docLib2.setA6Enabled(false);
        docLib2.setOfficeEnabled(false);
        docLib2.setFolderEnabled(false);
        docLib2.setUploadEnabled(false);
        docLib2.setColumnEditable(true);
        docLib2.setSearchConditionEditable(true);
        docLib2.setListByDefaultOrder(true);
        docLib2.setLogView(true);

        docLib2.setIsDefault(true);
        docLib2.setIsSearchConditionDefault(true);
        docLib2.setIsHidden(false);
        docLib2.setTypeEditable(false);
        docLib2.setStatus(Constants.DOC_LIB_ENABLED);

        docLib2.setCreateTime(new Date(nowTime));
        docLib2.setCreateUserId(userId);
        docLib2.setLastUpdate(new Date(nowTime));
        docLib2.setLastUserId(userId);
        docLib2.setOrderNum(3);
        docLib2.setDomainId(domainId);
        docLibDao.save(docLib2);

        // 08.09.17 公文档案库修改默认栏目
        this.initEdocLibColumn(docLib2.getId());

        // 添加公文档案库根节点及待归档公文目录
        docHierarchyManager.initArcsLib(docLib2.getId(), docLib2.getName(), userId);

        log.info("成功新建单位id=" + domainId + "的单位、公文文档库!");

        // 重新加载文档库显示栏目数据到内存中
        initPart(OperEnum.add, Arrays.asList(docLib, docLib2));
    }

    // 初始化公文库的显示栏目
    //	公文档案默认显示的栏目改为：
    //	依次为：文件密级、名称、公文文号、发文单位、大小、修改时间
    //	INSERT INTO `doc_list_columns` VALUES ('2297742928612312004', '-8504476490460345464', '8', '5');
    //	INSERT INTO `doc_list_columns` VALUES ('2524989101889896631', '-8504476490460345464', '4', '4');
    //	INSERT INTO `doc_list_columns` VALUES ('9096159212938217757', '-8504476490460345464', '136', '3');
    //	INSERT INTO `doc_list_columns` VALUES ('2166683770136775158', '-8504476490460345464', '131', '2');
    //	INSERT INTO `doc_list_columns` VALUES ('3611846396406614753', '-8504476490460345464', '2', '1');
    //	INSERT INTO `doc_list_columns` VALUES ('2787270725440127732', '-8504476490460345464', '133', '0');
    private void initEdocLibColumn(long docLibId) {
        Long[] defIds = new Long[] { 133L, 2L, 131L, 4L, 8L, 132L, 147L, 136L };
        for (int i = 0; i < defIds.length; i++) {
            DocListColumnPO docList = new DocListColumnPO();
            docList.setIdIfNew();
            docList.setDocLibId(docLibId);
            docList.setMetadataDefiniotionId(defIds[i]); // DocDetail ID
            docList.setOrderNum(i); // 排列的顺序
            docListColumnDao.save(docList);
        }
    }

    public String getAccountDocLibName(Long accountId) throws BusinessException {
        for (Iterator<Entry<Long, DocLibPO>> ite = publicDocLibsMap.toMap().entrySet().iterator(); ite.hasNext();) {
            Entry<Long, DocLibPO> entry = ite.next();
            DocLibPO lib = entry.getValue();
            if (lib.isAccountLib() && lib.getDomainId() == accountId) {
                return Constants.getDocI18nValue(lib.getName());
            }
        }
        throw new BusinessException("按照[id='" + accountId + "']无法查找到与之对应的单位文档库");
    }

    public void deleteOrgDocLibs(long domainId) throws BusinessException {
        docLibDao.deleteDocLibsByDomainId(domainId);
    }

    public DocLibPO getDocLibById(long id) {
        DocLibPO lib = publicDocLibsMap.get(id);
        if (lib != null)
            return lib;
        else
            return docLibDao.get(id);
    }

    /**
     * 获取文档库的详细信息列表
     * @param ids docLib的ID列表。
     * @return
     */
    public List<DocLibPO> getDocLibByIds(Collection<Long> ids) {
        return docLibDao.getDocLibByIds(ids);
    }

    public void modifyDocLib(DocLibPO docLib, String name) throws BusinessException {
        if (!docLib.getName().equals(name.trim())) {
            this.docResourceDao.updateRootFolderName(docLib.getId(), name);
        }

        docLib.setName(name);
        this.modifyDocLib(docLib);
    }

    public void modifyDocLib(DocLibPO docLib) throws BusinessException {
        docLib.setLastUserId(AppContext.currentUserId()); // 设置最后的更改人员
        docLib.setLastUpdate(new Date()); // 设置最后的更改时间
        docLibDao.update(docLib);

        List<DocLibPO> alist = new ArrayList<DocLibPO>();
        alist.add(docLib);
        initPart(OperEnum.edit, alist);
    }

    public void addDocLibOwners(long docLibId, long... userId) {
        if (userId == null || userId.length == 0)
            return;

        List<DocLibOwnerPO> owners = new ArrayList<DocLibOwnerPO>(userId.length);
        for (int i = 0; i < userId.length; i++) {
            owners.add(new DocLibOwnerPO(docLibId, userId[i], i));
        }
        ownerDao.savePatchAll(owners);
    }

    public void addDocLibOwners(long docLibId, List<Long> userIds) {
        if (CollectionUtils.isEmpty(userIds))
            return;

        List<DocLibOwnerPO> owners = new ArrayList<DocLibOwnerPO>(userIds.size());
        for (int i = 0; i < userIds.size(); i++) {
            owners.add(new DocLibOwnerPO(docLibId, userIds.get(i), i));
        }
        ownerDao.savePatchAll(owners);
    }

    public void deleteDocLibOwners(long docLibId) {
        this.ownerDao.bulkUpdate("delete from DocLibOwnerPO where docLibId = ?", null, docLibId);
    }

    public void setListColumnOrder(List<List> list) {
        for (int i = 0; i < list.size(); i++) {
            List the_list = list.get(i);
            if (the_list.isEmpty() == false) {
                long id = (Long) the_list.get(0);
                int order = (Integer) the_list.get(1);
                DocListColumnPO doc = docListColumnDao.get(id);
                doc.setOrderNum(order);
                docListColumnDao.update(doc);
            }
        }

    }

    public void deleteDocLib(long id) throws BusinessException {
        try {
            DocLibPO doc_lib = this.getDocLibById(id); // 获取要删除的自定义文档库
            if (doc_lib.getType() != Constants.USER_CUSTOM_LIB_TYPE.byteValue()) {
                log.warn("不允许对系统文档库进行删除操作!");
                throw new BusinessException("无权删除该文档库");
            } else {
                if (!docHierarchyManager.isLibOnlyRoot(id)) {
                    throw new BusinessException("DocLang.doc_lib_delete_doclib");
                }
            }
            this.deleteDocLibOwners(id); //手动删除文档库所有者
            this.deleteListColumn(id); //手动删除栏目列表
            this.deleteDocTypeList(id); //手动删除类型列表
            this.deleteSearchConfigs(id); //手动删除查询条件列表
            docHierarchyManager.removeDocWithoutAcl(docHierarchyManager.getRootByLibId(id), AppContext.currentUserId(), true);

            docLibMemberDao.bulkUpdate("delete from DocLibMemberPO where docLibId = ?", null, id);
            docLibDao.delete(doc_lib);
        } catch (BusinessException e) {
            log.error("删除文档库[id=" + id + "]的过程中出现异常：", e);
        }
    }

    public void deleteInvalidProject(long id, DocResourcePO root) {
        this.deleteListColumn(id); //手动删除栏目列表
        this.deleteDocTypeList(id); //手动删除类型列表
        this.deleteSearchConfigs(id); //手动删除查询条件列表
        if (root != null) {
            docResourceDao.bulkUpdate("delete from DocResourcePO where id = ?", null, root.getId());
        }
        docLibMemberDao.bulkUpdate("delete from DocLibMemberPO where docLibId = ?", null, id);
        docLibDao.bulkUpdate("delete from DocLibPO where id = ? ", null, id);
    }

    public void deleteUserDocLib(long userId) throws BusinessException {
        DocLibPO doc_lib = this.getPersonalLibOfUser(userId);
        if (doc_lib == null) {
            return;
        }
        ((DocHierarchyManagerImpl) docHierarchyManager).emptyLib(doc_lib.getId(), userId);
        docLibDao.deleteObject(doc_lib);
    }

    public List<DocLibPO> getDocLibs(long domainId) {
        List<DocLibPO> list = new ArrayList<DocLibPO>();
        //A6s版本需要过滤掉项目文档和公文文档
        List<Byte> a6sList = new ArrayList<Byte>();
        if (DocMVCUtils.isOnlyA6S()) {
            a6sList.add(Constants.EDOC_LIB_TYPE.byteValue());
            a6sList.add(Constants.PROJECT_LIB_TYPE.byteValue());
        }
        for (DocLibPO dl : publicDocLibsMap.values()) {
            if (dl.isEnabled() && (dl.getDomainId() == domainId && dl.getId().longValue() != domainId) || dl.getType() == Constants.GROUP_LIB_TYPE.byteValue() || dl.getType() == Constants.PROJECT_LIB_TYPE.byteValue()) {
                if (dl.getType() != Constants.EDOC_LIB_TYPE.byteValue() && !a6sList.contains(dl.getType())) {
                    list.add(dl);
                } else if (Constants.edocModuleEnabled() && !a6sList.contains(dl.getType())) {
                    list.add(dl);
                }
            }
        }
        Collections.sort(list);

        return list;
    }

    /**
     * 非个人库，非集团库，非虚拟库，排序
     */
    public List<DocLibPO> getDocLibsWithoutGroupLib(long domainId) {
        return this.getDocLibsWithoutGroupLib(domainId, Constants.DOC_LIB_ALL);
    }

    public List<DocLibPO> getDocLibsByUserId(long userId, long domainId) throws BusinessException {
        List<DocLibPO> docLibs = new ArrayList<DocLibPO>();
        docLibs.add(this.getPersonalLibOfUser(userId));
        // 获取所有得自定义及公共文档库
        List<DocLibPO> list = this.getCommonDocLibsByUserId(userId, domainId);
        docLibs.addAll(list);

        return docLibs;
    }

    public DocLibPO getPersonalLibOfUser(long userId) {
        DocLibPO lib = getPersonalLibOfUser1(userId);
        if (lib == null) {
            try {
                lib = this.saveDocLib(userId);

                this.initPartAddPersonal(lib, userId);

            } catch (BusinessException e) {
                log.error("新建个人[id=" + userId + "]文档库时出现异常 ", e);
            }
        }

        return lib;
    }

    /**
     * 取得某个人的个人文档库
     * 
     */
    private DocLibPO getPersonalLibOfUser1(long userId) {
        String hql = "select dl from DocLibPO dl, DocLibOwnerPO dlo where dl.id = dlo.docLibId and dlo.ownerId = ? and dl.type = " + Constants.PERSONAL_LIB_TYPE;
        List<DocLibPO> list = this.docLibDao.findVarargs(hql, userId);
        if (list != null && list.size() > 0) {
            return list.get(0);
        }
        return null;
    }

    /**
     * 取单位文档库
     * @param userId
     * @return
     */
    public DocLibPO getDeptLibById(long domainId) {

        String hql = "select dl from DocLibPO dl where dl.domainId = ? and dl.type = " + Constants.ACCOUNT_LIB_TYPE;
        List<DocLibPO> list = this.docLibDao.findVarargs(hql, domainId);
        if (list != null && list.size() > 0) {
            return list.get(0);
        }

        return null;

    }

    // 根据用户ID获取用户能够查阅的文档库（不包含个人文档库）
    public List<DocLibPO> getCommonDocLibsByUserId(long userId, long domainId) throws BusinessException {
        List<DocLibPO> theDocLibs = new ArrayList<DocLibPO>();
        // 取得本单位所有公共库
        List<DocLibPO> docLibs = this.getDocLibs(domainId);
        theDocLibs.addAll(docLibs);

        String userInfo = Constants.getOrgIdsOfUser(userId);

        // 删除自定义的非成员库
        List<Long> memberLibs = docLibDao.getAllMember(userInfo); //按自定义文档库的顺序得到所有有权限的库	

        if (!AppContext.getCurrentUser().isAdministrator()) {
            for (int i = 0; i < docLibs.size(); i++) {
                DocLibPO docLib = docLibs.get(i);
                if (docLib.getType() == Constants.USER_CUSTOM_LIB_TYPE.byteValue()) {
                    if (Strings.isEmpty(memberLibs)) {
                        theDocLibs.remove(docLib);
                    } else {
                        if (!memberLibs.contains(docLib.getId()))
                            theDocLibs.remove(docLib);
                    }
                }
            }
        }

        //用户能够查阅的外单位单位文档库和自定义文档库 added by Meng Young at 2009-08-21
        List<DocLibPO> otherAccountLibs = this.getDocLibsFromOtherAccountBySharing(userId, domainId);
        if (otherAccountLibs != null && otherAccountLibs.size() > 0) {
            theDocLibs.addAll(otherAccountLibs);
        }

        Collections.sort(theDocLibs);

        return theDocLibs;
    }

    public List<DocLibPO> getAllPartDocResouces(byte type, User user) throws Exception {
        return getAllPartDocResouces(user, true, type);
    }

    public List<DocLibPO> getAllPartDocResouces(User user) throws Exception {
        return getAllPartDocResouces(user, true);
    }

    private List<DocLibPO> getAllPartDocResouces(User user, boolean flag, Byte... type) throws Exception {
        if (user == null) {
            return null;
        }
        StringBuilder hql = new StringBuilder();
        Map<String, Object> namedParameters = new HashMap<String, Object>();

        hql.append("from " + DocLibPO.class.getName() + " lib where lib.domainId in(:orgids)");

        if (type != null && type.length > 0) {
            hql.append(" and lib.type in (:types)");
            namedParameters.put("types", CommonTools.parseArr2List(type));
        }

        List<V3xOrgAccount> list = orgManager.concurrentAccount(user.getId());
        List<Long> result = new ArrayList<Long>();
        if (CollectionUtils.isNotEmpty(list)) {
            for (V3xOrgAccount entity : list) {
                if (entity != null && entity.isValid()) {
                    result.add(entity.getId());
                }
            }
        }
        namedParameters.put("orgids", result);
        return this.docLibDao.find(hql.toString(), -1, -1, namedParameters);
    }

    /**
     * 获取用户能够查阅的外单位单位文档库和自定义文档库
     * @param userId   当前登录用户ID
     * @param domainId 当前登录用户所在单位ID
     * @throws BusinessException 
     */
    public List<DocLibPO> getDocLibsFromOtherAccountBySharing(long userId, long domainId) throws BusinessException {
        Map<String, Object> namedParameters = new HashMap<String, Object>();
        String hql = "select distinct lib from " + DocLibPO.class.getName() + " lib, " + DocResourcePO.class.getName() + " res, " + DocAcl.class.getName() + " acl, " + OrgUnit.class.getName() + " unit " + "where lib.id=res.docLibId and res.id=acl.docResourceId and lib.domainId != :userAccountId "
                + "and acl.userId in (:ids) " + "and lib.domainId = unit.id " + "and unit.deleted = 0 ";
        if (!AppContext.getCurrentUser().isInternal()) {
            hql += " and acl.userType != :account ";
            namedParameters.put("account", V3xOrgEntity.ORGENT_TYPE_ACCOUNT);
        }

        hql += " and ((acl.sharetype in (1,3) and acl.sdate<=:tdate and acl.edate>=:tdate) or acl.sharetype in (0,2))";
        hql += " and acl.potent != :nopotent " + " and lib.status = :enabled and (lib.type<:projectLibType and lib.type<>:personalLibType) " + " order by lib.orderNum ";

        namedParameters.put("userAccountId", domainId);
        namedParameters.put("ids", Constants.getOrgIdsOfUser1(userId));
        //取消权限之后，数据库仍有一条权限记录，其权限为无权限，需将此情况排除在外
        namedParameters.put("nopotent", Potent.noPotent);
        namedParameters.put("tdate", new Date());
        namedParameters.put("projectLibType", Constants.PROJECT_LIB_TYPE);
        namedParameters.put("personalLibType", Constants.PERSONAL_LIB_TYPE);
        namedParameters.put("enabled", Constants.DOC_LIB_ENABLED);
        log.info("userId:"+userId+"-----domainId:"+domainId);
        return this.docLibDao.find(hql, -1, -1, namedParameters);
    }

    public void addDocTypeList(long docLibId, List<List> docTypeId) throws BusinessException {
        List<DocTypeListPO> list = docTypeListDao.findBy("docLibId", docLibId);
        if (Strings.isNotEmpty(list)) {
            this.deleteDocTypeList(docLibId);
        }
        for (int i = 0; i < docTypeId.size(); i++) {
            List _list = docTypeId.get(i);
            if (_list.isEmpty() == false) {
                long theId = (Long) _list.get(0);
                int order = (Integer) _list.get(1);
                DocTypeListPO typeList = new DocTypeListPO();
                typeList.setIdIfNew();
                typeList.setDocTypeId(theId);
                typeList.setDocLibId(docLibId);
                typeList.setOrderNum(order);
                docTypeListDao.save(typeList);
            }
        }
        // 重新状态文档库显示栏目数据到内存中		
        List<DocLibPO> alist = new ArrayList<DocLibPO>();
        alist.add(this.getDocLibById(docLibId));
        initPart(OperEnum.edit, alist);
    }

    public void deleteDocTypeList(long docLibId) {
        this.docTypeListDao.bulkUpdate("delete from DocTypeListPO where docLibId = ?", null, docLibId);
    }

    public List<DocTypePO> getContentTypes(long docLibId) {
        return contentTypeTable.get(docLibId);
    }

    public List<DocTypePO> getContentTypesForNew(long docLibId) {
        return contentTypeTableForNew.get(docLibId);
    }

    public List<DocTypePO> getContentTypesForDoc(long docLibId) {
        return contentTypeTableForDoc.get(docLibId);
    }

    public List<DocTypePO> getValidContentTypesForDoc(long docLibId) {
        List<DocTypePO> _contentTypes = this.getContentTypesForDoc(docLibId);
        List<DocTypePO> contentTypes = null;
        if (CollectionUtils.isNotEmpty(_contentTypes)) {
            contentTypes = new ArrayList<DocTypePO>(_contentTypes.size());
            for (DocTypePO type : _contentTypes) {
                if (type.getStatus() != Constants.CONTENT_TYPE_DELETED) {
                    try {
                        DocTypePO type2 = (DocTypePO) type.clone();
                        type2.setId(type.getId());
                        type2.setName(DocMVCUtils.getDisplayName4MetadataDefinition2(type.getName(), null));
                        contentTypes.add(type2);
                    } catch (Exception e) {
                        log.error("", e);
                    }
                }
            }
        }
        return contentTypes;
    }

    public void setDocTypeView(List<List> list) {
        for (int i = 0; i < list.size(); i++) {
            List the_list = list.get(i);
            if (!the_list.isEmpty()) {
                long id = (Long) the_list.get(0);
                int order = (Integer) the_list.get(1);
                DocTypeListPO doc = docTypeListDao.get(id);
                doc.setOrderNum(order);
                docTypeListDao.update(doc);
            }
        }
    }

    public void deleteListColumn(long docLibId) {
        docListColumnDao.delete(new Object[][] { { "docLibId", docLibId } });
    }

    public void deleteSpecificColumn(long docMetadataDefId) {
        String hql = "delete from DocListColumnPO where metadataDefiniotionId = ?";
        docListColumnDao.bulkUpdate(hql, null, docMetadataDefId);
    }

    public void deleteSpecificSearchConfig(long docMetadataDefId) {
        String hql = "delete from DocSearchConfigPO where metadataDefiniotionId = ?";
        docSearchConfigDao.bulkUpdate(hql, null, docMetadataDefId);
    }

    public List<DocMetadataDefinitionPO> getListColumnsByDocLibId(long docLibId, boolean isDefaultColumn) {
        List<DocMetadataDefinitionPO> listColumns = null;
        if (isDefaultColumn) {
            DocLibPO docLib = getDocLibById(docLibId);
            boolean isEdocLib = (docLib.getType() == Constants.EDOC_LIB_TYPE);
            listColumns = new ArrayList<DocMetadataDefinitionPO>(getDefaultColumnList(isEdocLib));
        } else {
            listColumns = new ArrayList<DocMetadataDefinitionPO>(columnTable.get(docLibId));
        }
        return listColumns;
    }

    public List<DocMetadataDefinitionPO> getListColumnsByDocLibId(long docLibId, int edocElementState) {
        List<DocMetadataDefinitionPO> returnList = null;
        //区隔
        boolean forumFlag = "true".equals(SystemProperties.getInstance().getProperty("doc.forumFlag"));
        boolean isArchiveEnable = SystemEnvironment.hasPlugin("archive");
        List<DocMetadataDefinitionPO> listColumns = columnTable.get(docLibId);
        DocLibPO docLib = getDocLibById(docLibId);
        boolean isEdocLib = (docLib.getType() == Constants.EDOC_LIB_TYPE);
        if (CollectionUtils.isNotEmpty(listColumns)) {
            returnList = new ArrayList<DocMetadataDefinitionPO>(listColumns);
        } else {
            returnList = new ArrayList<DocMetadataDefinitionPO>(this.getDefaultColumnList(isEdocLib));
        }

        if (returnList != null) {
            //去掉评论
            DocMetadataDefinitionPO forum = null, archiveDmd = null;
            for (DocMetadataDefinitionPO dmd : returnList) {
                if (!forumFlag && dmd.getId().equals(12L)) {
                    forum = dmd;
                    break;
                }

                if (!isArchiveEnable && Constants.DOC_METADATA_DEF_ARCHIVE_ID.equals(dmd.getId())) {
                    archiveDmd = dmd;
                    continue;
                }
            }

            if (forum != null) {
                returnList.remove(forum);
            }

            if (archiveDmd != null) {
                returnList.remove(archiveDmd);
            }
        }

        if (isEdocLib && CollectionUtils.isNotEmpty(returnList)) {
            Map<Long, EdocElementBO> edocElementMap = new HashMap<Long, EdocElementBO>();
            for (DocMetadataDefinitionPO def : returnList) {
                DocMVCUtils.parseEdocMetadateDef(edocElementMap, def);
            }
        }
        return returnList;
    }

    public DocMetadataDefinitionPO getDocMetadataDefByDetailId(long detailId) {
        long id = contentTypeManager.getMetadataDefIdByDocDetailId(detailId);
        return metadataDefManager.getMetadataDefById(id);
    }

    public void setDocSearchConditions(Long docLibId, List<Long> searchConditions) {
        DocLibPO lib = this.getDocLibById(docLibId);
        if (lib.getIsSearchConditionDefault()) {
            lib.setIsSearchConditionDefault(false);
            docLibDao.update(lib);
        } else {
            this.deleteSearchConfigs(docLibId);
        }

        if (CollectionUtils.isNotEmpty(searchConditions)) {
            List<DocSearchConfigPO> sconfigs = new ArrayList<DocSearchConfigPO>(searchConditions.size());
            int order = 0;
            for (Long sConditionId : searchConditions) {
                sconfigs.add(new DocSearchConfigPO(sConditionId, docLibId, order));
                order++;
            }
            this.docSearchConfigDao.savePatchAll(sconfigs);
        }

        this.initPart(OperEnum.edit, Arrays.asList(lib));
    }

    public void setDocListColumn(long docLibId, List<List> list) {
        DocLibPO doc_lib = this.getDocLibById(docLibId);
        if (doc_lib.getIsDefault()) {
            //如果是公文档案库，默认数据库是有数据的所以需要先走删除
            if (Constants.EDOC_LIB_TYPE == doc_lib.getType()) {
                this.deleteListColumn(docLibId);
            }
            for (int i = 0; i < list.size(); i++) {
                List the_list = list.get(i);
                if (the_list.isEmpty() == false) {
                    long theId = (Long) the_list.get(0);
                    int order = (Integer) the_list.get(1);
                    DocListColumnPO docList = new DocListColumnPO();
                    docList.setIdIfNew();
                    docList.setDocLibId(docLibId);
                    docList.setMetadataDefiniotionId(theId); // metadataDefinitionId 
                    docList.setOrderNum(order); // 排列的顺序
                    docListColumnDao.save(docList);
                }
            }

            doc_lib.setIsDefault(false);
            docLibDao.update(doc_lib);
        } else {
            this.deleteListColumn(docLibId);
            for (int i = 0; i < list.size(); i++) {
                List the_list = list.get(i);
                if (the_list.isEmpty() == false) {
                    long theId = (Long) the_list.get(0);
                    int order = (Integer) the_list.get(1);
                    DocListColumnPO docList = new DocListColumnPO();
                    docList.setIdIfNew();
                    docList.setDocLibId(docLibId);
                    docList.setMetadataDefiniotionId(theId); // DocDetail ID
                    docList.setOrderNum(order); // 排列的顺序
                    docListColumnDao.save(docList);
                }

            }
        }
        // 态文档库显重新状示栏目数据到内存中
        List<DocLibPO> alist = Arrays.asList(doc_lib);
        this.initPart(OperEnum.edit, alist);
    }

    /**
     * 将文档库栏目设为默认
     */
    public String[] setListColumnToDefault(Long docLibId) {
        DocLibPO doc_lib = this.getDocLibById(docLibId);
        this.deleteListColumn(docLibId);
        doc_lib.setIsDefault(true);
        docLibDao.update(doc_lib);

        // 重新加载文档库显示栏目数据到内存中
        this.initPart(OperEnum.edit, Arrays.asList(doc_lib));
        boolean isEodcLib = doc_lib.getType() == Constants.EDOC_LIB_TYPE.byteValue() ? true : false;
        List<DocMetadataDefinitionPO> listColumns = this.getDefaultColumnList(isEodcLib);
        return DocMVCUtils.setDocMetadataDefinitionNames(listColumns, doc_lib.getType(), false);

    }

    private List<DocMetadataDefinitionPO> getDefaultColumnList(boolean isEdocLib) {
        return this.defaultListColumn.getDefaultListColumns(isEdocLib);
    }

    public Map<Long, List<Long>> getDocLibOwnersByIds(List<Long> docLibIds) {
        // 进行组织模型实体有效性判断
        Map<Long, List<Long>> mapRet = new HashMap<Long, List<Long>>();
        for (Long id : docLibIds) {
            mapRet.put(id, new ArrayList<Long>());
        }

        Set<Long> keyset = docLibOwnersMap.keySet();
        for (Long key : keyset) {
            if (docLibIds.contains(key)) {
                ArrayList<Long> set = docLibOwnersMap.get(key);
                if (set == null)
                    continue;
                for (Long oid : set) {
                    if (Constants.isValidOrgEntity(V3xOrgEntity.ORGENT_TYPE_MEMBER, oid))
                        mapRet.get(key).add(oid);
                }
            }
        }
        return mapRet;
    }

    /**
     * @deprecated 废弃，使用{@link #getDocLibOwnersByIds(List)}
     */
    public Map<Long, List<Long>> getDocLibOwnersByIds(String docLibIds) {
        return this.getDocLibOwnersByIds(CommonTools.parseStr2Ids(docLibIds));
    }

    public void deleteDocLibs(List<Long> ids) throws BusinessException {
        if (ids.isEmpty())
            return;

        for (int i = 0; i < ids.size(); i++) {
            DocLibPO doclib = this.getDocLibById(ids.get(i));
            if (!docHierarchyManager.isLibOnlyRoot(doclib.getId())) {
                throw new BusinessException("DocLang.doc_lib_delete_doclib&" + doclib.getName());
            }
            this.deleteDocLib(doclib.getId());
        }
        // 重新状态文档库显示栏目数据到内存中
        List<DocLibPO> alist = new ArrayList<DocLibPO>();
        for (Long id : ids) {
            DocLibPO lib = new DocLibPO();
            lib.setId(id);
            alist.add(lib);
        }
        initPart(OperEnum.delete, alist);
    }

    public void setDefaultListColumnOrder(long docLibId, List<List> list) {
        DocLibPO docLib = this.getDocLibById(docLibId);
        for (int i = 0; i < list.size(); i++) {
            List the_list = (List) list.get(i);
            if (the_list.isEmpty() == false) {
                DocListColumnPO docList = new DocListColumnPO();
                long theId = (Long) the_list.get(0);
                int orderNum = (Integer) the_list.get(1);
                docList.setIdIfNew();
                docList.setDocLibId(docLibId);
                docList.setMetadataDefiniotionId(theId);
                docList.setOrderNum(orderNum);
                docListColumnDao.save(docList);
            }
        }

        docLib.setIsDefault(false);
        docLibDao.update(docLib);

    }

    public List<DocLibPO> getDocLibsByUserIdNav(long userId, long domainId) throws BusinessException {
        return this.getDocLibsByUserId(userId, domainId);
    }

    public void deleteDocTypeListByTypeId(long docTypeId) {
        docTypeListDao.deleteDocTypeListByTypeId(docTypeId);
    }

    // 获取库的最大的orderNum
    private int getMaxDocLibOrder(long domainId) {
        int ret = 0;
        for (DocLibPO dl : publicDocLibsMap.values()) {
            if (dl.getDomainId() == domainId && dl.getOrderNum() > ret)
                ret = dl.getOrderNum();
        }

        return ret;
    }

    private DocLibPO getNearDocLib(DocLibPO lib, boolean upper, long domainId) {
        DocLibPO ret = lib;
        int orderNum = lib.getOrderNum();
        // 记录最上最下的文档库
        DocLibPO up = null;
        DocLibPO down = null;
        for (DocLibPO dl : publicDocLibsMap.values()) {
            if (dl.getDomainId() == domainId && dl.getType() == Constants.USER_CUSTOM_LIB_TYPE.byteValue()) {
                if (up == null)
                    up = dl;
                if (down == null)
                    down = dl;
                if (upper) {
                    if (dl.getOrderNum() < orderNum) {
                        if (ret.getId().longValue() == lib.getId().longValue())
                            ret = dl;
                        else if (ret.getOrderNum() < dl.getOrderNum())
                            ret = dl;
                    }
                } else {
                    if (dl.getOrderNum() > orderNum) {
                        if (ret.getId().longValue() == lib.getId().longValue())
                            ret = dl;
                        else if (ret.getOrderNum() > dl.getOrderNum())
                            ret = dl;
                    }
                }
                if (dl.getOrderNum() > down.getOrderNum())
                    down = dl;
                if (dl.getOrderNum() < up.getOrderNum())
                    up = dl;
            }
        }

        if (ret.getId().longValue() == lib.getId().longValue()) {
            if (upper)
                ret = down;
            else
                ret = up;
        }

        return ret;
    }

    /** 
     * 重新进行排序
     */
    public void moveDocLib(List<List> list) {
        //得到所有的公共的最大的排序号
        int num = list.size();
        int orderNum[] = new int[num];
        for (int i = 0; i < list.size(); i++) {
            List the_list = list.get(i);
            if (the_list.isEmpty() == false) {
                long id = (Long) the_list.get(0);
                //int order = (Integer) the_list.get(1);
                DocLibPO docLib = this.getDocLibById(id);
                orderNum[i] = docLib.getOrderNum();
            }
        }
        //对数组中的数据进行排序
        for (int i = 0; i < orderNum.length; i++) {
            for (int j = i + 1; j < orderNum.length; j++) {
                if (orderNum[i] > orderNum[j]) {
                    int tmp = orderNum[i];
                    orderNum[i] = orderNum[j];
                    orderNum[j] = tmp;
                }
            }
        }

        /**
         * 修改排序号
         */
        for (int i = 0; i < list.size(); i++) {
            List the_list = list.get(i);
            if (the_list.isEmpty() == false) {
                long id = (Long) the_list.get(0);
                DocLibPO docLib = this.getDocLibById(id);
                docLib.setOrderNum(orderNum[i]);
                docLibDao.update(docLib);
            }
        }
    }

    public void moveDocLib(long docLibId, long domainId, boolean up) {
        DocLibPO docLib = this.getDocLibById(docLibId);
        DocLibPO nearDocLib = this.getNearDocLib(docLib, up, domainId);
        if (nearDocLib != null) {
            if (nearDocLib.getType() != Constants.USER_CUSTOM_LIB_TYPE.byteValue() || nearDocLib.getId().longValue() == docLibId) {
                return;
            }
            docLib.setOrderNum(nearDocLib.getOrderNum());
            nearDocLib.setOrderNum(docLib.getOrderNum());
            docLibDao.update(docLib);
            docLibDao.update(nearDocLib);
        }
    }

    public DocLibPO getOwnerDocLibByUserId(long userId) {
        return this.getPersonalLibOfUser(userId);
    }

    public void updateDocLib(List arg) {
        List list = (List) arg;
        for (Object o : list) {
            if (o instanceof DocTypePO) {
                DocTypePO t = (DocTypePO) o;
                Set<Long> keyset = contentTypeTable.keySet();
                for (Long tl : keyset) {
                    contentTypeTable.get(tl).remove(t);
                    contentTypeTableForNew.get(tl).remove(t);
                    contentTypeTableForDoc.get(tl).remove(t);
                }

            } else if (o instanceof DocMetadataDefinitionPO) {
                DocMetadataDefinitionPO t = (DocMetadataDefinitionPO) o;
                Set<Long> keyset = columnTable.keySet();
                for (Long tl : keyset) {
                    List<DocMetadataDefinitionPO> alist = new ArrayList<DocMetadataDefinitionPO>(columnTable.get(tl));
                    alist.remove(t);
                }

                Set<Long> keyset2 = searchConditionTable.keySet();
                for (Long tl : keyset2) {
                    List<DocMetadataDefinitionPO> alist = searchConditionTable.get(tl);
                    alist.remove(t);
                }
            }
        }
    }

    public void update(Observable obj, Object arg) {
        // 只有删除才会 notifyObservers()
        if (arg == null || !(arg instanceof List))
            return;
        updateDocLib((List) arg);
    }

    public DocLibPO getGroupDocLib() {
        for (DocLibPO dl : publicDocLibsMap.values()) {
            if (dl.getType() == Constants.GROUP_LIB_TYPE.byteValue())
                return dl;
        }
        return null;
    }

    public DocLibPO getProjectDocLib() {
        for (DocLibPO dl : publicDocLibsMap.values()) {
            if (dl.getType() == Constants.PROJECT_LIB_TYPE.byteValue())
                return dl;
        }
        return null;
    }

    /** 个人文档库名称：我的文档 */
    //sunzm private static final String PERSONAL_DOC_LIB_NAME = Constants.getDocI18nValue(Constants.FOLDER_MINE_KEY);
    private static final String PERSONAL_DOC_LIB_NAME = "我的文档";

    @Deprecated
    public boolean hasSameNameDocLib(String name, long docLibId) {
        String[] result = this.validateDocLibName(name, docLibId);
        return BooleanUtils.toBoolean(result[0]);
    }

    public String[] validateDocLibName(String name, long docLibId) {
        if (name != null) {
            if (name.equals(PERSONAL_DOC_LIB_NAME)) {
                String msg = Constants.getDocI18nValue("doc.doclib.name.same.personal");
                return new String[] { String.valueOf(true), msg };
            }

            DocLibPO currentLib = this.getDocLibById(docLibId);

            for (DocLibPO lib : publicDocLibsMap.values()) {
                String libName = Constants.getDocI18nValue(lib.getName());
                if (libName.equals(name)) {
                    if (docLibId == 0l && (lib.isGroupLib() || lib.isPersonalLib() || lib.isProjectLib() || lib.getDomainId() == AppContext.getCurrentUser().getLoginAccount()))
                        return new String[] { String.valueOf(true), getValidateDocLibNameMsg(lib) };

                    // 不同类型文档库不允许重名，同类型文档库但所在单位不同允许同名（比如：单位文档、公文档案）
                    if (docLibId != 0 && docLibId != lib.getId().longValue() && (currentLib.getType() != lib.getType() || currentLib.getDomainId() == lib.getDomainId())) {
                        return new String[] { String.valueOf(true), getValidateDocLibNameMsg(lib) };
                    }
                }
            }
        }
        return new String[] { String.valueOf(false), null };
    }

    /**
     * 文档库名称重复时，给出有效的提示信息供用户判断
     */
    private String getValidateDocLibNameMsg(DocLibPO lib) {
        String libName = Constants.getDocI18nValue(lib.getName());
        String str = ResourceUtil.getString("doc.doclib.name.same.public", ResourceUtil.getString(Constants.getDocLibType(lib.getType())), libName);
        return str;
    }

    /**
     * 取得默认显示栏目
     */
    public List<DocMetadataDefinitionPO> getDefaultColumnList() {
        return this.getDefaultColumnList(false);
    }

    /**
     * 取消文档库新建
     */
    public void cancelAdd() {
        if (AppContext.getCurrentUser() != null) {
            DocLibPO docLib = this.getDocLibById(AppContext.getCurrentUser().getLoginAccount());
            this.initVirtualLib(docLib);
        }
    }

    /**
     * 取得某个单位下某种类型的文档库
     * 
     */
    public List<DocLibPO> getLibsOfAccount(long domainId, byte libType) {
        List<DocLibPO> ret = new ArrayList<DocLibPO>();
        for (DocLibPO dl : publicDocLibsMap.values()) {
            if (dl.getDomainId() == domainId && dl.getType() == libType)
                ret.add(dl);
        }

        return ret;
    }

    /**
     * 判断当前用户是否某个库的owner
     */
    public boolean isOwnerOfLib(Long userId, Long libId) {
        ArrayList<Long> set = docLibOwnersMap.get(libId);
        if (set == null)
            return false;
        else
            return set.contains(userId);
    }

    /**
     * 根据docLibId 得到 owners
     * @param userId
     * @return
     */
    public List<Long> getOwnersByDocLibId(long docLibId) {
        ArrayList<Long> set = docLibOwnersMap.get(docLibId);
        if (CollectionUtils.isNotEmpty(set)) {
            List<Long> result = new ArrayList<Long>(set.size());
            for (Long ownerId : set) {
                try {
                    V3xOrgMember member = this.orgManager.getMemberById(ownerId);
                    if (member != null && member.isValid()) {
                        result.add(member.getId());
                    }
                } catch (BusinessException e) {
                    log.warn("查找不到[id=" + ownerId + "]的人员!");
                }
            }
            return result;
        } else {
            return new ArrayList<Long>();
        }
    }

    public void setLibMember(Long docLibId, Long userId, String userType) {
        String hsql = "from DocLibMemberPO as a where a.docLibId=? and a.userId=? and a.userType=?";
        List<DocLibMemberPO> list = docLibMemberDao.findVarargs(hsql, docLibId, userId, userType);
        if (Strings.isEmpty(list)) {
            DocLibMemberPO docm = new DocLibMemberPO();
            docm.setDocLibId(docLibId);
            docm.setIdIfNew();
            docm.setUserId(userId);
            docm.setUserType(userType);
            docLibMemberDao.save(docm);
        }
    }

    public void deleteLibMember(Long docLibId, String userIds) {
        String hql = "delete from DocLibMemberPO as a where a.docLibId=? and a.userId in (:userIds)";
        Map<String, Object> namedParameters = new HashMap<String, Object>();
        namedParameters.put("userIds", Constants.parseStrings2Longs(userIds, ","));

        docLibMemberDao.bulkUpdate(hql, namedParameters, docLibId);
    }

    public boolean isEmpty() {
        Long domainId = AppContext.getCurrentUser().getLoginAccount();
        List<DocLibPO> list = this.getDocLibsWithoutGroupLib(domainId); // 获取所有的自定义文档库和公共文档库
        List<DocLibPO> docLibs = new ArrayList<DocLibPO>();
        for (int i = 0; i < list.size(); i++) {
            DocLibPO docLib = list.get(i);
            if (docLib.getType() == Constants.USER_CUSTOM_LIB_TYPE.byteValue()) {
                docLibs.add(docLib);
            }
        }
        return docLibs.isEmpty();
    }

    /**
     * 获取用户管理的文档库id
     * @param owner
     * @return          文档库id列表
     */
    public List<Long> getLibsByOwner(Long owner) {
        return this.ownerDao.getLibsByOwner(owner);
    }

    public List<DocLibPO> getDocLibs(boolean isGroup, Long accountId) {
        return this.getDocLibs(isGroup, accountId, Constants.DOC_LIB_ALL);
    }

    public List<DocLibPO> getDocLibs(boolean isGroup, Long accountId, byte status) {
        List<DocLibPO> docLibs = new ArrayList<DocLibPO>();
        List<DocLibPO> docLibs1 = new ArrayList<DocLibPO>();
        if (isGroup) {
        	//客开 赵辉 修改 查询方式 重写了 getGroupDocLib 方法
        	List<DocLibPO> lib = this.getGroupDocLib(docLibs1);
        	DocLibPO plib = this.getProjectDocLib();
        	for (DocLibPO docLibPO : lib) {
        		if (Constants.validateStatus(docLibPO, status))
                    docLibs.add(docLibPO);
			}
            
        	
	            if (Constants.validateStatus(plib, status))
	                docLibs.add(plib);
        	
        } else {
            // 获取所有的自定义文档库和公共文档库
            docLibs = this.getDocLibsWithoutGroupLib(accountId, status);

            if (!Constants.isGroupVer()) {
                DocLibPO plib = this.getProjectDocLib();
                if (Constants.validateStatus(plib, status))
                    docLibs.add(plib);
            }
        }

        Collections.sort(docLibs);
        return docLibs;
    }
    //客开 赵辉 重写 getGroupDocLib   方法 start
    public List<DocLibPO> getGroupDocLib(List<DocLibPO> docLibs) {
        for (DocLibPO dl : publicDocLibsMap.values()) {
            if (dl.getType() == Constants.GROUP_LIB_TYPE.byteValue())
            	docLibs.add(dl);
        }
        return docLibs;
    }
    //客开 赵辉 重写 getGroupDocLib   方法 end
  

    /**
     * 非个人库，非集团库，非虚拟库，排序
     * @param accountId		单位ID
     * @param status		所要获取文档库状态类型，包括：启用、停用、全部(不区分启用还是停用)
     * @return
     */
    private List<DocLibPO> getDocLibsWithoutGroupLib(Long accountId, byte status) {
        List<DocLibPO> list = new ArrayList<DocLibPO>();
        for (DocLibPO dl : publicDocLibsMap.values()) {
            if (dl.getDomainId() == accountId && dl.getId().longValue() != accountId && Constants.validateStatus(dl, status) && (dl.getType() != Constants.EDOC_LIB_TYPE || Constants.edocModuleEnabled())) {
                list.add(dl);
            }
        }
        Collections.sort(list);

        return list;
    }

    public void disableDocLibs(String docLibIds) {
        this.updateStatus(docLibIds, Constants.DOC_LIB_DISABLED);
    }

    private void updateStatus(String docLibIds, byte status) {
        List<Long> ids = CommonTools.parseStr2Ids(docLibIds);
        if (CollectionUtils.isNotEmpty(ids)) {
            this.docLibDao.updateStatus(ids, status);

            List<DocLibPO> libs = new ArrayList<DocLibPO>(ids.size());
            for (Long id : ids) {
                DocLibPO lib = this.getDocLibById(id);
                lib.setStatus(status);
                libs.add(lib);
            }
            this.initPartEdit(libs);
        }
    }

    public void enableDocLibs(String docLibIds) {
        this.updateStatus(docLibIds, Constants.DOC_LIB_ENABLED);
    }

    public List<DocLibTableVo> getDocLibTableVOs(List<DocLibPO> docLibs) {
        List<DocLibTableVo> the_list = new ArrayList<DocLibTableVo>();

        Integer first = Pagination.getFirstResult();
        Integer pageSize = Pagination.getMaxResults();
        Pagination.setRowCount(docLibs.size());

        for (int i = first; i < first + pageSize; i++) {
            if (i > docLibs.size() - 1) {
                break;
            }
            DocLibPO docLib = docLibs.get(i);
            DocLibTableVo vo = new DocLibTableVo(docLib);
            List<Long> the_manager = this.getOwnersByDocLibId(docLib.getId());
            StringBuilder manager_list = new StringBuilder();
            int j = 0;
            for (Long oid : the_manager) {
                V3xOrgMember member = null;
                try {
                    member = orgManager.getMemberById(oid);
                } catch (BusinessException e) {
                    log.error("orgManager取得member", e);
                }
                if (member != null && member.isValid()) {
                    if (j != 0) {
                        manager_list.append(",");
                        manager_list.append(member.getEntityType());
                        manager_list.append("|");
                        manager_list.append(oid);

                    } else {
                        manager_list.append(member.getEntityType());
                        manager_list.append("|");
                        manager_list.append(oid);
                    }
                    j++;
                }
            }
            vo.setManagerName(manager_list.toString());
            //获取库类型
            vo.setDocLibType(Constants.getDocLibType(docLib.getType()));
            the_list.add(vo);
        }
        return the_list;
    }

    public List<DocMetadataDefinitionPO> getDefaultSearchConditions() {
        if (defaultSearchConditions == null)
            defaultSearchConditions = this.defaultSearchCondition.getDefaultSearchCondition();
        return defaultSearchConditions;
    }

    private List<DocMetadataDefinitionPO> getDefaultSearchConditions(boolean isEdocLib) {
        if (isEdocLib) {
            return new ArrayList<DocMetadataDefinitionPO>(this.getDefaultEdocSearchConditions());
        } else {
            return new ArrayList<DocMetadataDefinitionPO>(this.getDefaultSearchConditions());
        }
    }

    public String[] setSearchConditions2Default(Long docLibId) {
        this.deleteSearchConfigs(docLibId);

        DocLibPO doc_lib = this.getDocLibById(docLibId);
        doc_lib.setIsSearchConditionDefault(true);
        docLibDao.update(doc_lib);

        // 重新加载文档库显示栏目数据到内存中
        List<DocLibPO> alist = Arrays.asList(doc_lib);
        this.initPart(OperEnum.edit, alist);

        List<DocMetadataDefinitionPO> searchConditions = this.getDefaultSearchConditions(doc_lib.isEdocLib());
        return DocMVCUtils.setDocMetadataDefinitionNames(searchConditions, doc_lib.getType(), false);
    }

    /**
     * 删除文档库对应的搜索条件配置记录
     * @param docLibId
     */
    public void deleteSearchConfigs(Long docLibId) {
        docSearchConfigDao.delete(new Object[][] { { "docLibId", docLibId } });
    }

    public List<DocMetadataDefinitionPO> getSearchConditions4DocLib(Long docLibId, Byte docLibType) {
        List<DocMetadataDefinitionPO> searchConditions = searchConditionTable.get(docLibId);
        if (CollectionUtils.isNotEmpty(searchConditions)) {
            boolean isArchiveEnable = SystemEnvironment.hasPlugin("archive");
            List<DocMetadataDefinitionPO> dmds = new ArrayList<DocMetadataDefinitionPO>(searchConditions);
            for (DocMetadataDefinitionPO d : searchConditions) {
                if (!isArchiveEnable && Constants.DOC_METADATA_DEF_ARCHIVE_ID.equals(d.getId())) {
                    dmds.remove(d);
                    break;
                }
            }
            return dmds;
        }

        return this.getDefaultSearchConditions(Constants.EDOC_LIB_TYPE.equals(docLibType));
    }

    public List<DocMetadataDefinitionPO> getDefaultEdocSearchConditions() {
        if (defaultEdocSearchConditions == null)
            defaultEdocSearchConditions = this.defaultSearchCondition.getDefaultEdocSearchCondition();
        return defaultEdocSearchConditions;
    }

    public boolean isDocLibEnabled(Long docLibId) {
        DocLibPO lib = this.getDocLibById(docLibId);
        return lib != null && lib.isEnabled();
    }

    public List<DocMetadataDefinitionPO> getMiscSearchConditions4DocLib(List<DocMetadataDefinitionPO> selectedConditions) {
        List<DocMetadataDefinitionPO> all = this.metadataDefManager.getAllSearchableMetadataDef();
        Strings.removeAllIgnoreEmpty(all, selectedConditions);
        return all;
    }

    @Override
    public List<DocLibPO> getDocLibsByUserIdFromPortalSelector(long userId, long domainId, boolean isAccountAdmin) throws BusinessException {
        List<DocLibPO> docLibs = new ArrayList<DocLibPO>();
        DocLibPO dp = this.getPersonalLibOfUserFromPortalSelector(userId, isAccountAdmin);
        if (dp != null) {
            docLibs.add(dp);
        }
        // 获取所有得自定义及公共文档库
        List<DocLibPO> list = this.getCommonDocLibsByUserId(userId, domainId);
        docLibs.addAll(list);
        return docLibs;
    }

    private DocLibPO getPersonalLibOfUserFromPortalSelector(long userId, boolean isAccountAdmin) {
        DocLibPO lib = getPersonalLibOfUser1(userId);
        if ((lib == null) && !isAccountAdmin) {
            try {
                lib = this.saveDocLib(userId);
                this.initPartAddPersonal(lib, userId);
            } catch (BusinessException e) {
                log.error("新建个人[id=" + userId + "]文档库时出现异常 ", e);
            }
        }

        return lib;
    }

    @Override
    public int deleteMemberAccLibsOwner(Long userId, Long accountId) throws BusinessException {
        List<Long> docLibIds = docLibDao.deleteMemberDocLibsOwner(userId, accountId, Constants.ACCOUNT_LIB_TYPE);
        if (Strings.isNotEmpty(docLibIds)) {
            for (Long docLibId : docLibIds) {
                DocResourcePO dr = docHierarchyManager.getRootByLibId(docLibId);
                docAclManager.deletePotentByUser(dr.getId(), userId, V3xOrgEntity.ORGENT_TYPE_MEMBER, Constants.ACCOUNT_LIB_TYPE, docLibId);
                docAlertManager.deleteAllAlertByDocResourceIdAndOrg(dr, V3xOrgEntity.ORGENT_TYPE_MEMBER, userId);
            }
            //清缓存
            initLibOwner();
        }
        return docLibIds.size();
    }

    public DocLibPO addVjoinMemberDocResources(Long userId) throws BusinessException{
        DocLibPO lib = getPersonalLibOfUser1(userId);
        if (lib != null) {
            return lib;
        }
        DocLibPO doclib = new DocLibPO();
        doclib.setIdIfNew();
        doclib.setName("doc.contenttype.mydoc");
        doclib.setDescription("");
        doclib.setType(Constants.PERSONAL_LIB_TYPE);// 个人文档库

        doclib.setTypeEditable(false);
        doclib.setListByDefaultOrder(true);
        doclib.setColumnEditable(false);
        doclib.setSearchConditionEditable(false);
        doclib.setLogView(false);
        doclib.setFolderEnabled(true);
        doclib.setA6Enabled(true);
        doclib.setOfficeEnabled(true);
        doclib.setUploadEnabled(true);

        doclib.setIsHidden(false);
        doclib.setCreateUserId(userId); // 个人文档库的创建者默认为该库的所有者
        doclib.setCreateTime(new Date());
        doclib.setLastUserId(userId);
        doclib.setLastUpdate(new Date());
        doclib.setStatus(Constants.DOC_STATUS);
        doclib.setIsDefault(true);
        doclib.setIsSearchConditionDefault(true);
        doclib.setOrderNum(0); //个人文档库的顺序统一为0
        doclib.setShareEnabled(true);;
        docLibDao.save(doclib);
        // 增加个人文档库根节点
        
        DocResourcePO existRoot = docHierarchyManager.getRootByLibId(doclib.getId());
        if (existRoot != null)
            throw new BusinessException("doc_lib_init_again");
        docHierarchyManager.createFolderByTypeWithoutAcl(doclib.getName(), Constants.FOLDER_MINE, doclib.getId(), 0L, userId);
        this.addDocLibOwners(doclib.getId(), userId); // 对个人文档库授权
        this.initPartAddPersonal(doclib, userId);
        return doclib;
        
    }
}
