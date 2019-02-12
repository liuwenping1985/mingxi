package com.seeyon.apps.doc.manager;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.orm.hibernate3.HibernateCallback;

import com.seeyon.apps.doc.dao.DocAclDao;
import com.seeyon.apps.doc.dao.DocDao;
import com.seeyon.apps.doc.dao.DocMetadataDao;
import com.seeyon.apps.doc.dao.DocResourceDao;
import com.seeyon.apps.doc.po.DocAcl;
import com.seeyon.apps.doc.po.DocAlertPO;
import com.seeyon.apps.doc.po.DocLibPO;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.doc.po.Potent;
import com.seeyon.apps.doc.util.Constants;
import com.seeyon.apps.doc.util.DocMVCUtils;
import com.seeyon.apps.doc.util.DocUtils;
import com.seeyon.apps.doc.vo.PotentModel;
import com.seeyon.apps.project.api.ProjectApi;
import com.seeyon.apps.project.bo.ProjectMemberInfoBO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.ctp.common.dao.paginate.Pagination;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.security.SecurityHelper;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Strings;

@SuppressWarnings("rawtypes")
public class DocAclManagerImpl extends BaseHibernateDao implements DocAclManager {

	private static final Log log = LogFactory.getLog(DocAclManagerImpl.class);

    private DocAclDao        				docAclDao;
    private DocResourceDao   				docResourceDao;
    private DocDao           				docDao;
    private DocLibManager    			 	docLibManager;
    private DocHierarchyManager          	docHierarchyManager;
    private OrgManager						orgManager;
    private DocMetadataDao                  docMetadataDao;
    private ProjectApi          projectApi;
    
    public DocHierarchyManager getDocHierarchyManager() {
		return docHierarchyManager;
	}
	public void setDocHierarchyManager(DocHierarchyManager docHierarchyManager) {
		this.docHierarchyManager = docHierarchyManager;
	}
	public DocLibManager getDocLibManager() {
		return docLibManager;
	}
	public void setDocLibManager(DocLibManager docLibManager) {
		this.docLibManager = docLibManager;
	}
    public DocResourceDao getDocResourceDao() {
        return docResourceDao;
    }

    public void setDocResourceDao(DocResourceDao docResourceDao) {
        this.docResourceDao = docResourceDao;
    }

    public DocAclDao getDocAclDao() {
        return docAclDao;
    }

    public void setDocAclDao(DocAclDao docAclDao) {
        this.docAclDao = docAclDao;
    }

    public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	public Set<Integer> getDocResourceAclList(DocResourcePO doc, String userIds) {
        return getDocResourceAclList(doc, userIds, null);
    }
	
	 /**
     * 取得文档的逻辑路径，获得此节点上级的全部节点 根据节点和用户反向从DocAcl表中查找有权限的记录
     * 如过查到则直接返回，未查到则继续查询上级节点
     */
    public Set<Integer> getDocResourceAclList(DocResourcePO doc, String userIds, Map<Long, Set<Integer>> aclMap) {
        if (aclMap == null) {
            aclMap = this.getGroupedAclSet(doc, userIds);
        }
        Set<Integer> potentSet = new HashSet<Integer>();
        for(Set<Integer> set : aclMap.values()){
        	potentSet.addAll(set);
        }
        return potentSet;
    }
    
    /**
     * 取得文档的逻辑路径，获得此节点上级的全部节点 根据节点和用户反向从DocAcl表中查找有权限的记录
     * 如过查到则直接返回，未查到则继续查询上级节点
     */
    @SuppressWarnings("unchecked")
    public Set<Integer> getDocResourceAclList(long projectId, String userIds) {
        String hql1 = "from DocResourcePO where sourceId = ? and frType = ?";
        List<DocResourcePO> list1 = docResourceDao.findVarargs(hql1, projectId, Constants.FOLDER_CASE);
        if (Strings.isEmpty(list1))
            return null;

        DocResourcePO docProject = list1.get(0);
        return this.getDocResourceAclList(docProject, userIds);
    }
    
    public Potent getAclVO(long docId) throws BusinessException {
        DocResourcePO doc = this.docResourceDao.get(docId);
        return getAclVO(doc);
    }
    
    // 左侧数的权限获取，与getAclString功能一样，知识返回值不同
    public Potent getAclVO(DocResourcePO doc) throws BusinessException {
        Potent potent = new Potent();
        if (doc == null) {
            return potent;
        }
        String path = doc.getLogicalPath();

        String[] docIdsArray = path.split("\\.");
        String praId = docIdsArray[0];
//        DocHierarchyManager docHierarchyManager = (DocHierarchyManager) AppContext.getBean("docHierarchyManager");
        DocResourcePO myDocRoot = docHierarchyManager.getPersonalFolderOfUser(AppContext.currentUserId());
        DocResourcePO praDoc = this.docResourceDao.get(Long.valueOf(praId));

        String orgIds = Constants.getOrgIdsOfUser(AppContext.currentUserId());
        Set<Integer> sets = this.getDocResourceAclList(doc, orgIds);
        boolean all = sets.contains(Constants.ALLPOTENT);
        boolean edit = sets.contains(Constants.EDITPOTENT);
        boolean add = sets.contains(Constants.ADDPOTENT);
        boolean readonly = sets.contains(Constants.READONLYPOTENT);
        boolean browse = sets.contains(Constants.BROWSEPOTENT);
        boolean list = sets.contains(Constants.LISTPOTENT);

        if (praDoc.getFrType() == Constants.FOLDER_MINE && myDocRoot.getId().equals(praDoc.getId())) {
            all = true;
            edit = true;
            add = true;
            readonly = true;
            browse = true;
            list = true;
        }

        if (doc.getFrType() == Constants.FOLDER_SHAREOUT || doc.getFrType() == Constants.FOLDER_BORROWOUT
                || doc.getFrType() == Constants.FOLDER_SHARE || doc.getFrType() == Constants.FOLDER_BORROW
                || doc.getFrType() == Constants.FOLDER_PLAN || doc.getFrType() == Constants.FOLDER_PLAN_WEEK
                || doc.getFrType() == Constants.FOLDER_PLAN_MONTH || doc.getFrType() == Constants.FOLDER_PLAN_DAY
                || doc.getFrType() == Constants.FOLDER_PLAN_WORK) {
            all = false;
            edit = false;
            add = false;
            readonly = false;
            browse = true;
            list = true;
        }
        potent.setAll(all);
        potent.setEdit(edit);
        potent.setCreate(add);
        potent.setReadOnly(readonly);
        potent.setRead(browse);
        potent.setList(list);
        return potent;
    }
    /**
     * <pre>
     * 得到一个类似：“all=" + all + "&edit=" + edit + "&add=" + add + "&readonly=" + readonly + "&browse=" + browse + "&list=" + list”
     * 格式的权限串，在js中调用ajax使用
     * </pre>
     * @throws BusinessException 
     */
    public String getAclString(long docId) throws BusinessException {
        Potent potent = this.getAclVO(docId);
        return "all=" + potent.isAll() + "&edit=" + potent.isEdit() + "&add=" + potent.isCreate() + "&readonly=" + potent.isReadOnly() + "&browse=" + potent.isRead() + "&list=" + potent.isList();
    }
    @Override
	public String getAclStringAndV(Long resId, Long frType,
			String docLibId, String docLibType, String isShareAndBorrowRoot)
			throws BusinessException {
    	String flag = "";
    	String v = "";
    	boolean all = false;
    	boolean edit = false;
    	boolean add = false;
    	boolean readonly = false;
    	boolean browse = false;
    	boolean list = false;
    	// 是否有权限字符串返回
    	boolean isHasAcl = false;
    	Potent potent = this.getAclVO(resId);
    	if(potent != null) {
    		isHasAcl = true;
    		all = potent.isAll();
        	edit = potent.isEdit();
        	add = potent.isCreate();
        	readonly = potent.isReadOnly();
        	browse = potent.isRead();
        	list = potent.isList();
        	flag = "all=" + all + "&edit=" + edit + "&add=" + add + "&readonly=" + readonly + "&browse=" + browse
                    + "&list=" + list;        
    	}
    	if(frType== Constants.FOLDER_MINE){
    		isHasAcl = true;
        	isShareAndBorrowRoot = "false";
        	all = true;
        	edit = true;
        	add = true;
        	readonly = false;
        	browse = false;
        	list = true;
   		 }
        if(frType == Constants.FOLDER_SHAREOUT || frType ==Constants.FOLDER_BORROWOUT){
			isShareAndBorrowRoot = "false";
		}
        if(isHasAcl) {
        	v = SecurityHelper.digest(resId,frType,docLibId,docLibType,isShareAndBorrowRoot,all,edit,add,readonly,browse,list);
        } else {
        	v = SecurityHelper.digest(resId,frType,docLibId,docLibType,isShareAndBorrowRoot);
        }   	
    	return flag + "&v=" + v;
	}
    /**
     * 文档权限控制 ，是否有打开查看的权限
     * @throws BusinessException 
     */
    public boolean hasOpenAcl(long docId) throws BusinessException {
    	long userId = AppContext.currentUserId();
    	return docHierarchyManager.hasOpenPermission(docId, userId);
//        // 有共享和借阅权限的
//        DocResourcePO doc = this.docResourceDao.get(docId);
//        if (doc == null) {
//            log.warn("[" + this.getClass().getCanonicalName() + ".hasOpenAcl]获取文档资源不存在，id：" + docId);
//            return false;
//        }
//        String path = doc.getLogicalPath();
//        String[] docIdsArray = path.split("\\.");
//        String praId = docIdsArray[0];
//
//        long userId = AppContext.currentUserId();
//        DocResourcePO myDocRoot = this.getPersonalFolderOfUser(userId);
//        DocResourcePO praDoc = this.docResourceDao.get(Long.valueOf(praId));
//        String orgIds = Constants.getOrgIdsOfUser(userId);
//        Set<Integer> sets = this.getDocResourceAclList(doc, orgIds);
//        boolean all = sets.contains(Constants.ALLPOTENT);
//        boolean edit = sets.contains(Constants.EDITPOTENT);
//        boolean add = sets.contains(Constants.ADDPOTENT);
//        boolean readonly = sets.contains(Constants.READONLYPOTENT);
//        boolean browse = sets.contains(Constants.BROWSEPOTENT);
//        boolean dborrow = sets.contains(Constants.DEPTBORROW);
//        boolean pborrow = sets.contains(Constants.PERSONALBORROW);
//        boolean pshare = sets.contains(Constants.PERSONALSHARE);
//        if (praDoc != null && praDoc.getFrType() == Constants.FOLDER_MINE
//                && praDoc.getId().equals(myDocRoot.getId()))
//            all = true;
//
////        if (dborrow) {
////            //单位借阅
////            return this.hasAclertBoorrow(docId, userId, false);
////        }
////        if (pborrow) {
////            //个人借阅
////            return this.hasAclertBoorrow(docId, userId, true);
////        }
//        //  写入权限待清理。只有写入权限时有权查看自己创建的文档
//        if (all || edit || readonly || browse || pshare || (add && doc.getCreateUserId() == userId))
//        	return true;
//		if (dborrow || pborrow) {
//			String potent = this.getBorrowPotent(docId);
//			if ("00".equals(potent)) {
//				return false;
//			}
//			return true;
//		}
//		return false;
    }

    /**
     * 取得权限数据
     * 根据组织模型id进行了区分
     */
    public Map<Long, Set<Integer>> getGroupedAclSet(DocResourcePO doc, String orgIds) {
        Map<Long, Set<Integer>> ret = new HashMap<Long, Set<Integer>>();
        // 1. 抽取从当前docResource开始向上，所有树形结构链上的节点的对于当前orgIds的权限
        String path = doc.getLogicalPath();
        String[] docIdsArray = path.split("\\.");
        List<DocAcl> aclList = this.getDocAclFromDocIdsAndOrgIds(CommonTools.parseStr2Ids(path, "\\."), orgIds);
        
        //在继承树上，有自己的权限，自己的权限优先所有其他权限（单位部门）
        boolean isFind=false;
        for (int i = docIdsArray.length; i > 0; i--) {
            String reId = docIdsArray[i - 1];
            for (DocAcl docAcl : aclList) {
                if (OrgConstants.ORGENT_TYPE.Member.name().equals(docAcl.getUserType()) && docAcl.getUserId() == AppContext.currentUserId()) {
                    if (reId.equals(String.valueOf(docAcl.getDocResourceId()))) {
                        isFind=true;
                        Set<Integer> set = new HashSet<Integer>();
                        set.addAll(docAcl.getMappingPotent().adapterPotentToSet(docAcl.getSharetype()));
                        ret.put(AppContext.currentUserId(), set);//为有自己权限的标记                 
                        break;
                    }
                }
            }
            if (isFind){
                break;
            }
        }

        Map<Long, Map<Long, Set<Integer>>> groupedAcl = new HashMap<Long, Map<Long, Set<Integer>>>();
        for (DocAcl da : aclList) {
            Map<Long, Set<Integer>> map = groupedAcl.get(da.getDocResourceId());
            if (map == null) {
                map = new HashMap<Long, Set<Integer>>();
                Set<Integer> set = new HashSet<Integer>();
                set.addAll(da.getMappingPotent().adapterPotentToSet(da.getSharetype()));
                map.put(da.getUserId(), set);
                groupedAcl.put(da.getDocResourceId(), map);
            } else {
                Set<Integer> set = map.get(da.getUserId());
                if (set == null) {
                    set = new HashSet<Integer>();
                    set.addAll(da.getMappingPotent().adapterPotentToSet(da.getSharetype()));
                    map.put(da.getUserId(), set);
                } else {
                    set.addAll(da.getMappingPotent().adapterPotentToSet(da.getSharetype()));
                }
            }
        }

        // 2. 从树形结构顶部开始向下循环，按组织模型id的不同进行区分，记录权限记录。
        //    对于同一个组织模型id，后边的权限覆盖前面的。
        for (int i = 0; i < docIdsArray.length; i++) {
            Map<Long, Set<Integer>> map = groupedAcl.get(Long.valueOf(docIdsArray[i]));
            if (map == null)
                continue;
            else {
                Set<Long> keySet = map.keySet();
                for (Long orgId : keySet) {
                    // 不继承时候，覆盖权限
                    ret.put(orgId, map.get(orgId));
                }
            }
        }
        return ret;
    }

    @SuppressWarnings("unchecked")
    public List<DocAcl> getDocAclFromDocIdsAndOrgIds(List<Long> docIds, String orgIds) {
        String hql = "from DocAcl where docResourceId in (:dids) and userId in (:oids) and (shareType in (0,2) or (shareType in (1,3) and sdate<=:tdate and edate>=:tdate))";
        Map<String, Object> nmap = new HashMap<String, Object>();
        nmap.put("dids", docIds);
        nmap.put("oids", Constants.parseStrings2Longs(orgIds, ","));
        nmap.put("tdate", new Date());
        return docAclDao.find(hql, -1, -1, nmap);
    }

    /**
     * 批量取得某个权限组的文档（夹）本身的权限，不涉及继承
     * Map<docId, Set<DocAcl>>
     */
    public Map<Long, Set<DocAcl>> getAclSet(List<Long> docIds, String orgIds) {
        List<DocAcl> aclList = this.getDocAclFromDocIdsAndOrgIds(docIds, orgIds);

        Map<Long, Set<DocAcl>> map = new HashMap<Long, Set<DocAcl>>();
        for (Long id : docIds) {
            map.put(id, new HashSet<DocAcl>());
        }
        if (aclList != null) {
            for (DocAcl da : aclList) {
                map.get(da.getDocResourceId()).add(da);
            }
        }
        return map;
    }

    @SuppressWarnings("unchecked")
    public List<DocResourcePO> findNextNodeOfTree(DocResourcePO doc, String userIds,List<Long> sourceIds) {
        String hqlSourceIdIn = "";
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("parentFrId", doc.getId());
        if (Strings.isNotEmpty(sourceIds)) {
            hqlSourceIdIn = " and a.sourceId in(:sourceIds)";
            params.put("sourceIds", sourceIds);
        }
        
        String hsql = "from DocResourcePO as a where a.parentFrId=:parentFrId" + hqlSourceIdIn + " and a.isFolder=1  order by a.frOrder asc";
        List<DocResourcePO> list = DBAgent.find(hsql, params);
        return this.filterTreeNodes(doc, list, userIds);
    }

    @SuppressWarnings("unchecked")
    public List<DocResourcePO> findNextNodeOfTreeWithOutAcl(DocResourcePO doc) {
        String hsql = "from DocResourcePO as a where a.parentFrId=? and a.isFolder=1 ";
        return docResourceDao.findVarargs(hsql, doc.getId());
    }

    @Override
	public List<DocResourcePO> findAllFoldersWithOutAcl(DocResourcePO doc) {
        String hsql = "from DocResourcePO as a where a.logicalPath like ? and a.isFolder=1 ";
        return docResourceDao.findVarargs(hsql, doc.getLogicalPath()+".%");
	}
	//	 过滤树上的节点
    private List<DocResourcePO> filterTreeNodes(DocResourcePO parent, List<DocResourcePO> list, String orgIds) {
        List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
        if (Strings.isEmpty(list)){
            return ret;
        }

        // 1. 一次抽出所有子文档夹的权限记录 Map<docId, Set<DocAcl>>
        Set<Long> docIds = new HashSet<Long>();
        for (DocResourcePO dr : list) {
            docIds.add(dr.getId());
        }
        Set<Long> orgSet = Constants.parseStrings2Longs(orgIds, ",");
        Map<Long, Set<Integer>> parentAclMap = this.getGroupedAclSet(parent, orgIds);
        parentAclMap.remove(-1L);
        Set<Integer> parentAcl = this.getDocResourceAclList(parent, orgIds);
        boolean parentHasPotent = this.hasPotent(parentAcl);
        Map<Long, Map<Long, Set<Integer>>> aclMap = this.getAclMapOfDocs(docIds, parent, orgSet);
        // 2. 遍历子文档夹，取出对应的权限
        List<DocResourcePO> subs = new ArrayList<DocResourcePO>();
        for (DocResourcePO dr : list) {
            Map<Long, Set<Integer>> map = aclMap.get(dr.getId());
            if (map == null || map.isEmpty()) {
                // 2.1 没有记录，说明继承	
                // 2.1.1 是“集团、单位、公文、项目”文档库的根展开(因为这些库的根是默认对所有人开放的)
                // 2.1.2 是其他的展开(说明上级目录已经验证过权限), 在树上显示 true
                if (parentHasPotent) {
                    ret.add(dr);
                } else {
                    subs.add(dr);
                }
                dr.setAclSet(parentAcl);
            } else {
                Map<Long, Set<Integer>> ownmap = new HashMap<Long, Set<Integer>>();
                // 按照顺序添加
                ownmap.putAll(parentAclMap);
                ownmap.putAll(aclMap.get(dr.getId()));
                Set<Integer> potentSet = new HashSet<Integer>();
                for (Set<Integer> set : ownmap.values()) {
                    potentSet.addAll(set);
                }
                dr.setAclSet(potentSet);

                // 2.2 有记录，说明不继承	
                // 2.2.1 有权限，在树上显示 true
                // 2.2.2 没有权限，向下查找文档夹，看是否有权限 nextPath
                if (this.hasPotent(potentSet)) {
                    ret.add(dr);
                } else {
                    subs.add(dr);
                }
            }
        }
        if (subs.size() > 0) {
            subs = this.hasPotentInNextPath(subs, orgSet);
            ret.addAll(subs);
        }
        return ret;
    }

    /**
     * 重载方法getAclMapOfDocs 
     * 使用连接查询 ，去除in字句
     */
    @SuppressWarnings("unchecked")
    private Map<Long, Map<Long, Set<Integer>>> getAclMapOfDocs(Set<Long> docIds, DocResourcePO doc, Set<Long> orgIds) {
        String hqll = "select docAcl.docResourceId, docAcl.userId, docAcl.potent  from DocAcl docAcl , "
                + " DocResourcePO docResource where " + "  docResource.isFolder=1 and docResource.parentFrId=:parentId"
                + " and docAcl.userId in (:oids) " + " and docAcl.sharetype = " + Constants.SHARETYPE_DEPTSHARE
                + " and docResource.id = docAcl.docResourceId  ";

        Map<String, Object> nmap = new HashMap<String, Object>();
        nmap.put("parentId", doc.getId());
        nmap.put("oids", orgIds);

        List<Object[]> list = (List<Object[]>) docAclDao.find(hqll, -1, -1, nmap);

        Map<Long, Map<Long, Set<Integer>>> ret = new HashMap<Long, Map<Long, Set<Integer>>>();
        for (Long did : docIds) {
            ret.put(did, new HashMap<Long, Set<Integer>>());
        }

        for (Object[] arr : list) {
            Map<Long, Set<Integer>> map = ret.get((Long) arr[0]);
            if (map != null) {
                Set<Integer> set = map.get((Long) arr[1]);
                if (set == null) {
                    set = new HashSet<Integer>();
                    map.put((Long) arr[1], set);
                }
                Potent potent = new Potent(String.valueOf(arr[2]));
                set.addAll(potent.adapterPotentToSet(Constants.SHARETYPE_DEPTSHARE));
            }
        }

        return ret;
    }

    // 取得某个权限组对多个文档的权限 Map<docId, Set<DocAcl>>
    @SuppressWarnings("unchecked")
    private Map<Long, Map<Long, Set<Integer>>> getAclMapOfDocs(Set<Long> docIds, Set<Long> orgIds) {
        Map<Long, Map<Long, Set<Integer>>> ret = new HashMap<Long, Map<Long, Set<Integer>>>();
        for (Long did : docIds) {
            ret.put(did, new HashMap<Long, Set<Integer>>());
        }

        String hql = "select docResourceId, userId, potent  from DocAcl where docResourceId in (:dids) and userId in (:oids) and sharetype = "
                + Constants.SHARETYPE_DEPTSHARE;
        Map<String, Object> nmap = new HashMap<String, Object>();
        nmap.put("dids", docIds);
        nmap.put("oids", orgIds);
        List<Object[]> list = (List<Object[]>) docAclDao.find(hql, -1, -1, nmap);

        for (Object[] arr : list) {
            Map<Long, Set<Integer>> map = ret.get((Long) arr[0]);
            Set<Integer> set = map.get((Long) arr[1]);
            if (set == null) {
                set = new HashSet<Integer>();
                map.put((Long) arr[1], set);
            }
            Potent p = new Potent((String) arr[2]);
            set.addAll(p.adapterPotentToSet(Constants.SHARETYPE_DEPTSHARE));
        }

        return ret;
    }

    // 判断是否有权限
    private boolean hasPotent(Set<Integer> set) {
        for (Integer a : set) {
            if (a.intValue() != Constants.NOPOTENT)
                return true;
        }
        return false;
    }

    // 判断
    @SuppressWarnings("unchecked")
    private List<DocResourcePO> hasPotentInNextPath(List<DocResourcePO> subs, Set<Long> orgIds) {
        StringBuilder hqlHead = new StringBuilder(
                "select doc.logicalPath, doc.parentFrId from DocResourcePO doc, DocAcl da where doc.docLibId = :libid and doc.isFolder = true and doc.id = da.docResourceId ");
        hqlHead.append(" and da.userId in(:oids) and da.sharetype = ");
        hqlHead.append(Constants.SHARETYPE_DEPTSHARE);
        hqlHead.append(" and da.potent != '");
        hqlHead.append(Potent.noPotent);
//        hqlHead.append("' and (");
        hqlHead.append("'");
        List<Object[]> list2 = new ArrayList<Object[]>();
        //数据非常大时，sql异常
        Map<String, Object> nmap = new HashMap<String, Object>();
        List<DocResourcePO>[] paramArr = Strings.splitList(subs, 100);
        for (int i = 0; i < paramArr.length; i++) {
            StringBuilder hql = new StringBuilder(hqlHead);
            nmap.clear();
            nmap.put("libid", subs.get(0).getDocLibId());
            nmap.put("oids", orgIds);
//            for (int j = 0; j < paramArr[i].size(); j++) {
//                DocResourcePO dr = paramArr[i].get(j);
//                if (j > 0) {
//                    hql.append(" or ");
//                }
//                hql.append("doc.logicalPath like :lp" + j);
//                nmap.put("lp" + j, dr.getLogicalPath() + ".%");
//            }
//            hql.append(") ");
            List<Object[]> list = this.docAclDao.find(hql.toString(), -1, -1, nmap);
            if (!list.isEmpty()) {
                list2.addAll(list);
            }
        }
        
        if (Strings.isEmpty(list2)) {
            return Collections.emptyList();
        }
        //显示有文档的目录
        List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
        for (DocResourcePO dr : subs) {
            for (Object[] arr : list2) {
                String lp = (String) arr[0];
                if (lp.startsWith(dr.getLogicalPath() + ".")) {
                    ret.add(dr);
                    break;
                }
            }
        }
        return ret;
    }

	public List<DocResourcePO> findNextNodeOfTablePageByDate(boolean isNewView, final DocResourcePO doc, String userIds, int currentPage, int pageSize) {
		String orderStr = " order by doc.frOrder, doc.lastUpdate desc, doc.mimeOrder";
		return findResources(isNewView, doc, userIds, currentPage, pageSize, orderStr, null);
	}

    public List<DocResourcePO> findNextNodeOfTablePage(boolean isNewView, final DocResourcePO doc, String userIds, int currentPage,
            int pageSize,List<Long> sourceIds, String... type) {
    	//客开   gyz 2018-07-05 start
        //String orderStr = " order by doc.lastUpdate desc, doc.frOrder desc";
        //客开   gyz 2018-07-05 end
    	
    	String orderStr = " order by doc.frOrder, doc.lastUpdate desc";
		return findResources(isNewView, doc, userIds, currentPage, pageSize, orderStr, sourceIds, type);
    }

    @SuppressWarnings("unchecked")
    private List<DocResourcePO> findResources(boolean isNewView,final DocResourcePO doc, String userIds, int currentPage, int pageSize,
            String orderString,List<Long> sourceIds, String... type) {
        // 1. 取得父文档夹权限	
        Map<Long, Set<Integer>> parentAclMap = this.getGroupedAclSet(doc, userIds);
        //取出个人权限表的权限
        Set<Integer> personalPotent = parentAclMap.remove(-1L);
        Set<Integer> parentAcl = this.getDocResourceAclList(doc, userIds, parentAclMap);
        boolean parentHasPotent = this.hasPotent(parentAcl);

        final Set<Long> userIdLongs = Constants.parseStrings2Longs(userIds, ",");
        // 2.1 如果有权限
        List<DocResourcePO> list = null;
        final String orderStr = orderString;

        boolean isOwner = false;

        User user = AppContext.getCurrentUser();
        if (user != null) {
            Long userId = user.getId();
            //isOwner = this.docUtils.isOwnerOfLib(userId, doc.getDocLibId());
            //项目文档的判定
            List<Long> libOwnerIds = DocMVCUtils.getLibOwners(doc);
            isOwner = libOwnerIds != null && libOwnerIds.contains(userId);
        }
        
        if(currentPage>-1&&pageSize>-1){
        	Pagination.setMaxResults(pageSize);
        	Pagination.setFirstResult(pageSize*(currentPage-1));
        }
        if (isOwner) {
            String hql = "from DocResourcePO doc where doc.parentFrId = ? ";
            if (currentPage == -1 && pageSize == -1) {
                list = this.docResourceDao.find(hql + orderString, -1, -1, null, doc.getId());
            } else {
                list = this.docResourceDao.findWithCount(hql + orderString, "select count(doc.id) " + hql, null, doc.getId());
            }
        } else if (parentHasPotent && Strings.isNotBlank(userIds)) {
            // 只有写入权限时，只能查看自己创建的文档
            boolean justHasAddPotent = parentAcl != null
                    && ((parentAcl.size() == 1 && parentAcl.iterator().next() == Constants.ADDPOTENT) || (parentAcl
                            .size() == 2 && parentAcl.contains(Constants.ADDPOTENT) && parentAcl
                                .contains(Constants.NOPOTENT)));

            if (justHasAddPotent) {
                String hql = "from " + DocResourcePO.class.getCanonicalName()
                        + " as doc where doc.parentFrId=? and doc.createUserId=? ";
            	list = this.docResourceDao.findWithCount(hql + orderString, "select count(doc.id) " + hql, null,
                        doc.getId(), AppContext.currentUserId());
                
            } else {
                String hql = "";
                boolean hasHighRight = true;
                //关联文档需要浏览及以上权限
                if (type.length > 0 && "quote".equals(type[0])) {
                    // 只有列表权限时，只能查看有权限的子文件，文件夹
                    if (((parentAcl.size() == 1 && parentAcl.iterator().next() == Constants.LISTPOTENT) || (parentAcl
                                    .size() == 2 && parentAcl.contains(Constants.LISTPOTENT) && parentAcl
                                        .contains(Constants.NOPOTENT)))) {
                        hql = "from DocResourcePO doc where doc.parentFrId = :parentId and (doc.id not in"
                                + "(select doc2.id from DocResourcePO doc2, DocAcl da2 where doc2.parentFrId = :parentId"
                                + " and doc2.isFolder = true and doc2.id = da2.docResourceId and da2.userId in(:userIds)"
                                + " and da2.sharetype = "
                                + Constants.SHARETYPE_DEPTSHARE
                                + " and da2.potent = '"
                                + Potent.noPotent + "'))";
                        hasHighRight = false;
                    }
                }
                if (hasHighRight) {
                    //上级文档夹有继承的个人的权限(不包括无权限)
                    boolean hasHierarchyPersonalPotent = (personalPotent!=null && (personalPotent.size()>1||!(personalPotent.contains(0)&&personalPotent.size()==1)));
                    String queryCnd = " and da3.sharetype = "+ Constants.SHARETYPE_DEPTSHARE+ " and da3.potent != '"+ Potent.noPotent+ "'";
                    if(hasHierarchyPersonalPotent){
                        queryCnd = "";
                    }
                    
                    hql = "from DocResourcePO doc where doc.parentFrId = :parentId and (exists ("
                            + " select doc3.id from DocResourcePO doc3, DocAcl da3 where doc3.parentFrId = :parentId and doc3.id = da3.docResourceId"
                            + " and da3.userId in(:userIds)"
                            + queryCnd
                            + " and doc.id = doc3.id) or not exists(select doc2.id from DocResourcePO doc2, DocAcl da2 "
                            + " where doc2.parentFrId = :parentId and doc2.isFolder = true and doc2.id = da2.docResourceId"
                            + " and da2.userId in(:userIds)" + " and doc.id = doc2.id))";
                }
                Map<String, Object> params = new HashMap<String, Object>();
                params.put("parentId", doc.getId());
                params.put("userIds", userIdLongs);
                
                if (currentPage == -1 && pageSize == -1) {
                    list = this.docResourceDao.find(hql + orderString, -1, -1, params);
                } else {
                    list = this.docResourceDao.findWithCount(hql + orderString, "select count(doc.id) " + hql, params);
                }
                //对仅仅只有列表权限的文档进行处理
                if (list.size() > 999) {
                    List<DocResourcePO>[] splitList = Strings.splitList(list, 1000);
                    for (int i = 0; i < splitList.length; i++) {
                        parseOnlyListDoc(splitList[i], userIdLongs, hasHighRight);
                    }
                } else {
                    parseOnlyListDoc(list, userIdLongs, hasHighRight);
                }
            }
        } else {
            final List<Long> sourceIdList = sourceIds;
            final int page = currentPage;
            final int pagesize = pageSize;
            final String hql = "from DocResourcePO doc, DocAcl da where doc.id = da.docResourceId and doc.parentFrId = :pid and "
                    + " da.userId in (:userIds) and da.sharetype = "
                    + Constants.SHARETYPE_DEPTSHARE
                    + " and da.potent != '" + Potent.noPotent+"'";
            list = (List<DocResourcePO>) this.getHibernateTemplate().execute(new HibernateCallback() {
                public Object doInHibernate(Session session) throws HibernateException, SQLException {
                    boolean flag = sourceIdList != null && !sourceIdList.isEmpty();
                    String hql0 = hql + (flag ? " and doc.sourceId in(:sourceIds)" : "");
                    Map<String,Object> m = new HashMap<String, Object>();
                    m.put("userIds", userIdLongs);
                    m.put("pid", doc.getId());
                    if(flag){
                        m.put("sourceIds", sourceIdList);
                    }
                    List l = docResourceDao.find("select count(distinct doc.id) " + hql0, -1,-1,m);
                    int rowCount = ((Number) (l.get(0))).intValue();
                    Pagination.setRowCount(rowCount);
                    int p = Pagination.getFirstResult();
                    int n = Pagination.getMaxResults();
                    if(page == -1 && pagesize == -1){
                    	p = -1;
                    	n = -1;
                    }
                    
                    return docResourceDao.find("select distinct doc " + hql0 + orderStr, p, n,m);
                }
            });
        }
        if (list == null)
            list = new ArrayList<DocResourcePO>();

        Set<Long> docids = new HashSet<Long>();
        for (DocResourcePO td : list) {
            if (td.getIsFolder())
                docids.add(td.getId());
        }
        // 有子文档夹
        if (docids.size() > 0) {
            Map<Long, Map<Long, Set<Integer>>> aclMap = this.getAclMapOfDocs(docids,
                    Constants.parseStrings2Longs(userIds, ","));
            // 添加权限记录
            for (DocResourcePO d : list) {
                if (d.getIsFolder()) {
                    Map<Long, Set<Integer>> map = aclMap.get(d.getId());
                    if (map == null) {
                        d.setAclSet(parentAcl);
                    } else {
                        Map<Long, Set<Integer>> ownmap = new HashMap<Long, Set<Integer>>();
                        // 按照顺序添加
                        ownmap.putAll(parentAclMap);
                        ownmap.putAll(aclMap.get(d.getId()));
                        
                        Set<Integer> potentSet = new HashSet<Integer>();
                        for (Set<Integer> entry : ownmap.values()) {
                            potentSet.addAll(entry);
                        }

                        d.setAclSet(potentSet);
                    }
                } else {
                    d.setAclSet(parentAcl);
                }
            }
        } else {
            for (DocResourcePO td : list) {
                td.setAclSet(parentAcl);
            }
        }
        return list;
    }
    //重写方法 单独为档案查询  客开 赵辉 start
    public List<DocResourcePO> findNextNodeOfTablePage( final DocResourcePO doc, String userIds, int currentPage,
            int pageSize, String... type) {
        String orderStr = " order by doc.frOrder, doc.lastUpdate desc ";
		return findResources( doc, userIds, currentPage, pageSize, orderStr,type);
    }
    
    @SuppressWarnings("unchecked")
    private List<DocResourcePO> findResources(final DocResourcePO doc, String userIds, int currentPage, int pageSize,
            String orderString, String... type) {
        // 1. 取得父文档夹权限	
        Map<Long, Set<Integer>> parentAclMap = this.getGroupedAclSet(doc, userIds);
        //取出个人权限表的权限
        //Set<Integer> personalPotent = parentAclMap.remove(-1L);
        Set<Integer> parentAcl = this.getDocResourceAclList(doc, userIds, parentAclMap);
        //boolean parentHasPotent = this.hasPotent(parentAcl);

       // final Set<Long> userIdLongs = Constants.parseStrings2Longs(userIds, ",");
        // 2.1 如果有权限
        List<DocResourcePO> list = null;
       // final String orderStr = orderString;

       /* boolean isOwner = false;

        User user = AppContext.getCurrentUser();
        if (user != null) {
            Long userId = user.getId();
            //isOwner = this.docUtils.isOwnerOfLib(userId, doc.getDocLibId());
            //项目文档的判定
            List<Long> libOwnerIds = DocMVCUtils.getLibOwners(doc);
            isOwner = libOwnerIds != null && libOwnerIds.contains(userId);
        }*/
        
        if(currentPage>-1&&pageSize>-1){
        	Pagination.setMaxResults(pageSize);
        	Pagination.setFirstResult(pageSize*(currentPage-1));
        }
        
            String hql = "from DocResourcePO doc where doc.parentFrId = ? ";
            if (currentPage == -1 && pageSize == -1) {
                list = this.docResourceDao.find(hql + orderString, -1, -1, null, doc.getId());
            } else {
                list = this.docResourceDao.findWithCount(hql + orderString, "select count(doc.id) " + hql, null, doc.getId());
            }
        
        if (list == null)
            list = new ArrayList<DocResourcePO>();

        Set<Long> docids = new HashSet<Long>();
        for (DocResourcePO td : list) {
            if (td.getIsFolder())
                docids.add(td.getId());
        }
        // 有子文档夹
        if (docids.size() > 0) {
            Map<Long, Map<Long, Set<Integer>>> aclMap = this.getAclMapOfDocs(docids,
                    Constants.parseStrings2Longs(userIds, ","));
            // 添加权限记录
            for (DocResourcePO d : list) {
                if (d.getIsFolder()) {
                    Map<Long, Set<Integer>> map = aclMap.get(d.getId());
                    if (map == null) {
                        d.setAclSet(parentAcl);
                    } else {
                        Map<Long, Set<Integer>> ownmap = new HashMap<Long, Set<Integer>>();
                        // 按照顺序添加
                        ownmap.putAll(parentAclMap);
                        ownmap.putAll(aclMap.get(d.getId()));
                        
                        Set<Integer> potentSet = new HashSet<Integer>();
                        for (Set<Integer> entry : ownmap.values()) {
                            potentSet.addAll(entry);
                        }

                        d.setAclSet(potentSet);
                    }
                } else {
                    d.setAclSet(parentAcl);
                }
            }
        } else {
            for (DocResourcePO td : list) {
                td.setAclSet(parentAcl);
            }
        }
        return list;
    }
  //重写方法 单独为档案查询  客开 赵辉 start
    
    @SuppressWarnings("unchecked")
    private void parseOnlyListDoc(List<DocResourcePO> docs,Set<Long> userIdLongs, boolean hasHighRight) {
        if(!docs.isEmpty()){
            Map<Long, DocResourcePO> docMap = new HashMap<Long, DocResourcePO>();
            for (DocResourcePO doc : docs) {
                docMap.put(doc.getId(), doc);
            }
            Map<String, Object> param = new HashMap<String, Object>();
            Potent onlyList = new Potent();
            onlyList.setList(true);
            param.put("potent", onlyList.toString());//仅仅列表权限
            param.put("docIds", docMap.keySet());
            param.put("userIds", userIdLongs);
            //查询大于个人共享的
            if (!hasHighRight) {//父文档夹仅仅有列表权限
                List<DocAcl> aclList = docDao.findBy("from DocAcl acl where acl.docResourceId in(:docIds) and acl.userId in(:userIds) and acl.potent <> :potent", param, null);
                for (DocAcl docAcl : aclList) {//去掉大于列表权限的
                    docMap.remove(docAcl.getDocResourceId());
                }
                for (DocResourcePO doc : docMap.values()) {
                    doc.setOnlyList(true);
                }
            } else {
                List<DocAcl> aclList = docDao.findBy("from DocAcl acl where acl.docResourceId in(:docIds) and acl.userId in(:userIds) and acl.potent = :potent", param, null);
                for (DocAcl docAcl : aclList) {
                    docMap.get(docAcl.getDocResourceId()).setOnlyList(true);
                }
            } 
        }
    }
  //重写方法 单独为档案条件查询  客开 赵辉 start
    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getResourcesByConditionAndPotentPageDA(boolean isNew,List<DocResourcePO> docList, DocResourcePO parent,
            String userIds, String... type) {
        List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
        List<DocResourcePO> list = new ArrayList<DocResourcePO>();
        // 1. 得到所有有权限记录的 logicalPath, userId, potent  //and dr.logicalPath like :logicalPath
        String hql = "select dr.logicalPath, acl.userId, acl.potent,acl.sharetype from DocResourcePO as dr, DocAcl as acl"
                + " where dr.id = acl.docResourceId  and (acl.sharetype = "
                + Constants.SHARETYPE_DEPTSHARE + " or acl.sharetype = " + Constants.SHARETYPE_PERSSHARE
                + ") and acl.userId in (:userIds)" + " order by dr.logicalPath, acl.potent, dr.createTime desc";

        final Set<Long> userIdLongs = Constants.parseStrings2Longs(userIds, ",");

        Map<String, Object> namedParameterMap = new HashMap<String, Object>();
        namedParameterMap.put("userIds", userIdLongs);
        // 过滤掉当前文档库外的无效记录，减少遍历次数
        /*String parentLP = parent.getLogicalPath();
        if (parentLP.indexOf(".") != -1)
            namedParameterMap.put("logicalPath", parentLP.substring(0, parentLP.indexOf(".")) + "%");
        else
            namedParameterMap.put("logicalPath", parentLP + "%");*/
        List<Object> indexParameter = null;
        List<Object[]> los = docAclDao.find(hql, -1, -1, namedParameterMap, indexParameter);
        if (Strings.isEmpty(los)){
            return ret;
        }
        List<String> noAclList = new ArrayList<String>(); //存放没有权限的记录，用于过滤权限时校验
        // 2. 组织封装有权限的数据 Map<logicalPath., Map<userId,Set<potent>>>
        Map<String, Map<String, Set<Integer>>> map = new HashMap<String, Map<String, Set<Integer>>>();
        for (Object[] lo : los) {
            Potent p = new Potent(String.valueOf(lo[2]));
            if (p.isNoPotent()) {
                noAclList.add(lo[0].toString() + ".");
                continue;
            }

            Map<String, Set<Integer>> submap = map.get(lo[0] + ".");
            if (submap == null) {
                submap = new HashMap<String, Set<Integer>>();
                Set<Integer> set = new HashSet<Integer>();
                set.addAll(p.adapterPotentToSet(Constants.SHARETYPE_PERSSHARE));//bug --muyunxing
                submap.put(lo[1].toString(), set);
                map.put(lo[0] + ".", submap);
            } else {
                Set<Integer> set = submap.get(lo[1].toString());
                if (set == null) {
                    set = new HashSet<Integer>();
                    submap.put(lo[1].toString(), set);
                }
                set.addAll(p.adapterPotentToSet(Constants.SHARETYPE_PERSSHARE));//bug --muyunxing
            }
        }

        Map<String, Set<Integer>> map2 = new HashMap<String, Set<Integer>>();
        for (String lp : map.keySet()) {
            Map<String, Set<Integer>> submap = map.get(lp);
            Set<Integer> aclset = new HashSet<Integer>();
            for (String uid : submap.keySet()) {
                aclset.addAll(submap.get(uid));
            }
            map2.put(lp, aclset);
        }

        // 3. 权限过滤
        Set<String> keySet = map2.keySet();
        //写入权限
        Set<Integer> addAcl = new HashSet<Integer>();
        addAcl.add(Constants.ADDPOTENT);
        for (DocResourcePO td : docList) {
            String lp = td.getLogicalPath();
            while (true) {
                // 存在因继承而产生的无权限记录时，应被单独设置的权限覆盖 modified by yangm at 2011-01-25
                if (noAclList.contains(lp + ".") && !keySet.contains(lp + ".")) {
                    break;
                }

                if (keySet.contains(lp + ".")) {
                    Set<Integer> aclSet = map2.get(lp + ".");
                    if (type.length > 0 && "quote".equals(type[0])) {
                    	if (aclSet.contains(Constants.ALLPOTENT) || aclSet.contains(Constants.EDITPOTENT)
                                || aclSet.contains(Constants.READONLYPOTENT) || aclSet.contains(Constants.BROWSEPOTENT)
                                || aclSet.contains(Constants.LISTPOTENT)) {
                            td.setAclSet(aclSet);
                            list.add(td);
                            td.setOnlyList(hasOnlyList(td.getAclSet()));
                            break;
                    	}
                    } else {
                    	if (aclSet.contains(Constants.ALLPOTENT) || aclSet.contains(Constants.EDITPOTENT)
                                || aclSet.contains(Constants.READONLYPOTENT) || aclSet.contains(Constants.BROWSEPOTENT)
                                || aclSet.contains(Constants.LISTPOTENT)) {
                            td.setAclSet(aclSet);
                            list.add(td);
                            td.setOnlyList(hasOnlyList(td.getAclSet()));
                            break;
                    	}
                    }
                    if(aclSet.containsAll(addAcl)) {
                    	//只有自己创建的文档才显示
                        if (td.getCreateUserId() != null
                                && AppContext.currentUserId() == td.getCreateUserId().longValue()) {
                            td.setAclSet(aclSet);
                            list.add(td);
                            td.setOnlyList(hasOnlyList(td.getAclSet()));
                            break;
                        }
                    }
                }

                int loc = lp.lastIndexOf(".");
                if (loc == -1)
                    break;
                lp = lp.substring(0, lp.lastIndexOf("."));
            }
        }
        return list;
    }
  //重写方法 单独为档案条件查询  客开 赵辉 start
    
    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getResourcesByConditionAndPotentPage(boolean isNew,List<DocResourcePO> docList, DocResourcePO parent,
            String userIds, String... type) {
        List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
        List<DocResourcePO> list = new ArrayList<DocResourcePO>();
        // 1. 得到所有有权限记录的 logicalPath, userId, potent
        String hql = "select dr.logicalPath, acl.userId, acl.potent,acl.sharetype from DocResourcePO as dr, DocAcl as acl"
                + " where dr.id = acl.docResourceId and dr.logicalPath like :logicalPath and (acl.sharetype = "
                + Constants.SHARETYPE_DEPTSHARE + " or acl.sharetype = " + Constants.SHARETYPE_PERSSHARE
                + ") and acl.userId in (:userIds)" + " order by dr.logicalPath, acl.potent, dr.createTime desc";

        final Set<Long> userIdLongs = Constants.parseStrings2Longs(userIds, ",");

        Map<String, Object> namedParameterMap = new HashMap<String, Object>();
        namedParameterMap.put("userIds", userIdLongs);
        // 过滤掉当前文档库外的无效记录，减少遍历次数
        String parentLP = parent.getLogicalPath();
        if (parentLP.indexOf(".") != -1)
            namedParameterMap.put("logicalPath", parentLP.substring(0, parentLP.indexOf(".")) + "%");
        else
            namedParameterMap.put("logicalPath", parentLP + "%");
        List<Object> indexParameter = null;
        List<Object[]> los = docAclDao.find(hql, -1, -1, namedParameterMap, indexParameter);
        if (Strings.isEmpty(los)){
            return ret;
        }
        List<String> noAclList = new ArrayList<String>(); //存放没有权限的记录，用于过滤权限时校验
        // 2. 组织封装有权限的数据 Map<logicalPath., Map<userId,Set<potent>>>
        Map<String, Map<String, Set<Integer>>> map = new HashMap<String, Map<String, Set<Integer>>>();
        for (Object[] lo : los) {
            Potent p = new Potent(String.valueOf(lo[2]));
            if (p.isNoPotent()) {
                noAclList.add(lo[0].toString() + ".");
                continue;
            }

            Map<String, Set<Integer>> submap = map.get(lo[0] + ".");
            if (submap == null) {
                submap = new HashMap<String, Set<Integer>>();
                Set<Integer> set = new HashSet<Integer>();
                set.addAll(p.adapterPotentToSet(Constants.SHARETYPE_PERSSHARE));//bug --muyunxing
                submap.put(lo[1].toString(), set);
                map.put(lo[0] + ".", submap);
            } else {
                Set<Integer> set = submap.get(lo[1].toString());
                if (set == null) {
                    set = new HashSet<Integer>();
                    submap.put(lo[1].toString(), set);
                }
                set.addAll(p.adapterPotentToSet(Constants.SHARETYPE_PERSSHARE));//bug --muyunxing
            }
        }

        Map<String, Set<Integer>> map2 = new HashMap<String, Set<Integer>>();
        for (String lp : map.keySet()) {
            Map<String, Set<Integer>> submap = map.get(lp);
            Set<Integer> aclset = new HashSet<Integer>();
            for (String uid : submap.keySet()) {
                aclset.addAll(submap.get(uid));
            }
            map2.put(lp, aclset);
        }

        // 3. 权限过滤
        Set<String> keySet = map2.keySet();
        //写入权限
        Set<Integer> addAcl = new HashSet<Integer>();
        addAcl.add(Constants.ADDPOTENT);
        for (DocResourcePO td : docList) {
            String lp = td.getLogicalPath();
            while (true) {
                // 存在因继承而产生的无权限记录时，应被单独设置的权限覆盖 modified by yangm at 2011-01-25
                if (noAclList.contains(lp + ".") && !keySet.contains(lp + ".")) {
                    break;
                }

                if (keySet.contains(lp + ".")) {
                    Set<Integer> aclSet = map2.get(lp + ".");
                    if (type.length > 0 && "quote".equals(type[0])) {
                    	if (aclSet.contains(Constants.ALLPOTENT) || aclSet.contains(Constants.EDITPOTENT)
                                || aclSet.contains(Constants.READONLYPOTENT) || aclSet.contains(Constants.BROWSEPOTENT)
                                || aclSet.contains(Constants.LISTPOTENT)) {
                            td.setAclSet(aclSet);
                            list.add(td);
                            td.setOnlyList(hasOnlyList(td.getAclSet()));
                            break;
                    	}
                    } else {
                    	if (aclSet.contains(Constants.ALLPOTENT) || aclSet.contains(Constants.EDITPOTENT)
                                || aclSet.contains(Constants.READONLYPOTENT) || aclSet.contains(Constants.BROWSEPOTENT)
                                || aclSet.contains(Constants.LISTPOTENT)) {
                            td.setAclSet(aclSet);
                            list.add(td);
                            td.setOnlyList(hasOnlyList(td.getAclSet()));
                            break;
                    	}
                    }
                    if(aclSet.containsAll(addAcl)) {
                    	//只有自己创建的文档才显示
                        if (td.getCreateUserId() != null
                                && AppContext.currentUserId() == td.getCreateUserId().longValue()) {
                            td.setAclSet(aclSet);
                            list.add(td);
                            td.setOnlyList(hasOnlyList(td.getAclSet()));
                            break;
                        }
                    }
                }

                int loc = lp.lastIndexOf(".");
                if (loc == -1)
                    break;
                lp = lp.substring(0, lp.lastIndexOf("."));
            }
        }
        return list;
    }
    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getResourcesByConditionAndPotentPage4XZ(Long userId,List<DocResourcePO> docList,
    		String userIds, String... type) {
    	DocLibPO doclib= docLibManager.getOwnerDocLibByUserId(userId);
    	List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
    	List<DocResourcePO> list = new ArrayList<DocResourcePO>();
    	// 1. 得到所有有权限记录的 logicalPath, userId, potent
    	String hql = "select dr.logicalPath, acl.userId, acl.potent,acl.sharetype from DocResourcePO as dr, DocAcl as acl"
    			+ " where dr.id = acl.docResourceId  and (acl.sharetype = "
    			+ Constants.SHARETYPE_DEPTSHARE + " or acl.sharetype = " + Constants.SHARETYPE_PERSSHARE
    			+ ") and acl.userId in (:userIds)" + " order by dr.logicalPath, acl.potent, dr.createTime desc";
    	
    	final Set<Long> userIdLongs = Constants.parseStrings2Longs(userIds, ",");
    	
    	Map<String, Object> namedParameterMap = new HashMap<String, Object>();
    	namedParameterMap.put("userIds", userIdLongs);
    	// 过滤掉当前文档库外的无效记录，减少遍历次数
    	List<Object> indexParameter = null;
    	List<Object[]> los = docAclDao.find(hql, -1, -1, namedParameterMap, indexParameter);
    	if (Strings.isEmpty(los)){
    		for(DocResourcePO l:docList){
    			if(doclib.getId().equals(l.getDocLibId())){
    				ret.add(l);
    			}
    		}
    		return ret;
    	}
    	List<String> noAclList = new ArrayList<String>(); //存放没有权限的记录，用于过滤权限时校验
    	// 2. 组织封装有权限的数据 Map<logicalPath., Map<userId,Set<potent>>>
    	Map<String, Map<String, Set<Integer>>> map = new HashMap<String, Map<String, Set<Integer>>>();
    	for (Object[] lo : los) {
    		Potent p = new Potent(String.valueOf(lo[2]));
    		if (p.isNoPotent()) {
    			noAclList.add(lo[0].toString() + ".");
    			continue;
    		}
    		
    		Map<String, Set<Integer>> submap = map.get(lo[0] + ".");
    		if (submap == null) {
    			submap = new HashMap<String, Set<Integer>>();
    			Set<Integer> set = new HashSet<Integer>();
    			set.addAll(p.adapterPotentToSet(Constants.SHARETYPE_PERSSHARE));//bug --muyunxing
    			submap.put(lo[1].toString(), set);
    			map.put(lo[0] + ".", submap);
    		} else {
    			Set<Integer> set = submap.get(lo[1].toString());
    			if (set == null) {
    				set = new HashSet<Integer>();
    				submap.put(lo[1].toString(), set);
    			}
    			set.addAll(p.adapterPotentToSet(Constants.SHARETYPE_PERSSHARE));//bug --muyunxing
    		}
    	}
    	
    	Map<String, Set<Integer>> map2 = new HashMap<String, Set<Integer>>();
    	for (String lp : map.keySet()) {
    		Map<String, Set<Integer>> submap = map.get(lp);
    		Set<Integer> aclset = new HashSet<Integer>();
    		for (String uid : submap.keySet()) {
    			aclset.addAll(submap.get(uid));
    		}
    		map2.put(lp, aclset);
    	}
    	
    	// 3. 权限过滤
    	Set<String> keySet = map2.keySet();
    	//写入权限
    	Set<Integer> addAcl = new HashSet<Integer>();
    	addAcl.add(Constants.ADDPOTENT);
    	Long myDocLibId= doclib.getId();
    	for (DocResourcePO td : docList) {
    		String lp = td.getLogicalPath();
    		while (true) {
    			//个人文档下，取出
        		if(td.getDocLibId() == myDocLibId){
        			list.add(td);
        			break;
        		}
    			
    			// 存在因继承而产生的无权限记录时，应被单独设置的权限覆盖 modified by yangm at 2011-01-25
    			if (noAclList.contains(lp + ".") && !keySet.contains(lp + ".")) {
    				break;
    			}
    			
    			if (keySet.contains(lp + ".")) {
    				Set<Integer> aclSet = map2.get(lp + ".");
    				if (type.length > 0 && "quote".equals(type[0])) {
    					if (aclSet.contains(Constants.ALLPOTENT) || aclSet.contains(Constants.EDITPOTENT)
    							|| aclSet.contains(Constants.READONLYPOTENT) || aclSet.contains(Constants.BROWSEPOTENT)
    							|| aclSet.contains(Constants.LISTPOTENT)) {
    						td.setAclSet(aclSet);
    						list.add(td);
    						td.setOnlyList(hasOnlyList(td.getAclSet()));
    						break;
    					}
    				} else {
    					if (aclSet.contains(Constants.ALLPOTENT) || aclSet.contains(Constants.EDITPOTENT)
    							|| aclSet.contains(Constants.READONLYPOTENT) || aclSet.contains(Constants.BROWSEPOTENT)
    							|| aclSet.contains(Constants.LISTPOTENT)) {
    						td.setAclSet(aclSet);
    						list.add(td);
    						td.setOnlyList(hasOnlyList(td.getAclSet()));
    						break;
    					}
    				}
    				if(aclSet.containsAll(addAcl)) {
    					//只有自己创建的文档才显示
    					if (td.getCreateUserId() != null
    							&& AppContext.currentUserId() == td.getCreateUserId().longValue()) {
    						td.setAclSet(aclSet);
    						list.add(td);
    						td.setOnlyList(hasOnlyList(td.getAclSet()));
    						break;
    					}
    				}
    			}
    			
    			int loc = lp.lastIndexOf(".");
    			if (loc == -1)
    				break;
    			lp = lp.substring(0, lp.lastIndexOf("."));
    		}
    	}
    	return list;
    }
    
    private boolean hasOnlyList(Set<Integer> aclSet){
		return !aclSet.contains(Constants.ALLPOTENT)
				&& !aclSet.contains(Constants.EDITPOTENT)
				&& !aclSet.contains(Constants.READONLYPOTENT)
				&& !aclSet.contains(Constants.BROWSEPOTENT)
				&& aclSet.contains(Constants.LISTPOTENT);
    }
    
    /**
     * lihf 2008.03.20
     * 不传 DocResource 对象，改传 logicalPath 集合
     * 暂供综合查询使用
     */
    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getResourcesByConditionAndPotentPageNoDr(Map<Long, String> docMap, String userIds,
            int currentPage, int pageSize) {
        List<DocResourcePO> ret = new ArrayList<DocResourcePO>();
        if (docMap == null || docMap.isEmpty())
            return ret;

        // 1. 得到所有有权限记录的 logicalPath, userId, potent
        String hql = "select dr.logicalPath, acl.userId, acl.potent from DocResourcePO as dr, DocAcl as acl";
        hql += " where dr.id = acl.docResourceId and acl.sharetype = " + Constants.SHARETYPE_DEPTSHARE
                + " and acl.userId in (:userIds)";
        hql += " order by dr.logicalPath, acl.potent desc";

        final Set<Long> userIdLongs = Constants.parseStrings2Longs(userIds, ",");

        Map<String, Object> namedParameterMap = new HashMap<String, Object>();
        namedParameterMap.put("userIds", userIdLongs);
        List<Object> indexParameter = null;
        List<Object[]> los = docAclDao.find(hql, -1, -1, namedParameterMap, indexParameter);

        if (Strings.isEmpty(los))
            return ret;
        // 2. 组织封装有权限的数据 Map<logicalPath., Map<userId,Set<potent>>>
        Map<String, Map<String, Set<Integer>>> map = new HashMap<String, Map<String, Set<Integer>>>();
        for (Object[] lo : los) {
            Potent p = new Potent(String.valueOf(lo[2]));
            if (p.isNoPotent()) {
                continue;
            }
            Map<String, Set<Integer>> submap = map.get(lo[0] + ".");
            if (submap == null) {
                submap = new HashMap<String, Set<Integer>>();
                Set<Integer> set = new HashSet<Integer>();
                set.addAll(p.adapterPotentToSet(Constants.SHARETYPE_DEPTSHARE));
                submap.put(lo[1].toString(), set);
                map.put(lo[0] + ".", submap);
            } else {
                Set<Integer> set = submap.get(lo[1].toString());
                if (set == null) {
                    set = new HashSet<Integer>();
                    submap.put(lo[1].toString(), set);
                }
                set.addAll(p.adapterPotentToSet(Constants.SHARETYPE_DEPTSHARE));
            }
        }
        // 增加继承来的权限
        List<String> slist = new ArrayList<String>();
        Set<String> mapkey = map.keySet();
        slist.addAll(mapkey);
        Collections.sort(slist);
        for (String ss : slist) {
            Map<String, Set<Integer>> tmap = map.get(ss);
            for (String tk : slist) {
                if (tk.startsWith(ss) && !tk.equals(ss)) {
                    Map<String, Set<Integer>> newmap = new HashMap<String, Set<Integer>>();
                    newmap.putAll(tmap);
                    newmap.putAll(map.get(tk));
                    map.put(tk, newmap);
                }
            }
        }

        // Map<logicalPath, Set<Integer>>
        Map<String, Set<Integer>> map2 = new HashMap<String, Set<Integer>>();
        for (String lp : map.keySet()) {
            Map<String, Set<Integer>> submap = map.get(lp);
            Set<Integer> aclset = new HashSet<Integer>();
            for (String uid : submap.keySet()) {
                aclset.addAll(submap.get(uid));
            }
            map2.put(lp, aclset);
        }

        // 3. 权限过滤
        //		 lihf: 2007.09.12 不使用存储过程完成查询  end
        List<Long> idList = new ArrayList<Long>();
        Set<Long> idKeySet = docMap.keySet();
        Set<String> keySet = map2.keySet();
        for (Long tid : idKeySet) {
            String lp = docMap.get(tid);
            while (true) {
                if (keySet.contains(lp + ".")) {
                    idList.add(tid);
                    break;
                } else {
                    int loc = lp.lastIndexOf(".");
                    if (loc == -1)
                        break;
                    lp = lp.substring(0, lp.lastIndexOf("."));
                }
            }

        }

        if (idList.isEmpty())
            return ret;

        Pagination.setRowCount(idList.size());

        int first = Pagination.getFirstResult();
        int end1 = first + pageSize;
        int end2 = idList.size();//list.size();
        int end = 0;
        if (end1 > end2)
            end = end2;
        else
            end = end1;

        String idStr = "";
        for (int i = first; i < end; i++) {
            idStr += "," + idList.get(i);
        }
        if (idStr.length() == 0)
            return ret;

        ret = docResourceDao.getDocsByIds(idStr.substring(1));
        for (DocResourcePO doc : ret) {
            doc.setAclSet(map2.get(doc.getLogicalPath()));
        }
        return ret;
    }

    public void setPotentNoInherit(Long userId, String userType, Long docId, boolean isAlert, Long alertId)
            throws BusinessException {
        DocAcl docAcl = buildDocAcl(userId, userType, docId, Constants.SHARETYPE_DEPTSHARE);
        docAcl.getMappingPotent().adapterIntAddPotent(Constants.NOPOTENT);
        docAcl.setIsAlert(isAlert);
        docAcl.setDocAlertId(alertId);
        docDao.saveOrUpdate(docAcl);
    }

    @SuppressWarnings("unchecked")
    public void deletePotent(DocResourcePO doc) {
        /**
         * 查找文档的全部下级节点，删除权限表中关于这些节点的记录
         */
        List<Long> dlist = new ArrayList<Long>();
        dlist.add(doc.getId());
        if (doc.getIsFolder()) {
            String hsql = "select distinct da.docResourceId from DocAcl as da, DocResourcePO as dr where da.docResourceId=dr.id and dr.logicalPath like :lp";
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("lp", doc.getLogicalPath() + ".%");
            List<Long> dlist1 = docResourceDao.find(hsql, -1, -1, map);
            dlist.addAll(dlist1);
        }

        String queryString = "delete from DocAcl as a where a.docResourceId in (:dlist)";
        List<List<Long>> lists = this.getSubLists(dlist);
        for (int i = 0; i < lists.size(); i++) {
            Map<String, Object> namedParameterMap = new HashMap<String, Object>();
            namedParameterMap.put("dlist", lists.get(i));
            docAclDao.bulkUpdate(queryString, namedParameterMap);
        }
    }

    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getBorrowDocsPageOld(final String userIds, final Long ownerId, int currentPage,
            int pagesize) {
        List<DocResourcePO> docList = new ArrayList<DocResourcePO>();
        List<DocAcl> list = (List<DocAcl>) this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                String hsql = "from DocAcl as a where a.userId in (:userIds) and a.sharetype="
                        + Constants.SHARETYPE_PERSBORROW + " and ownerId=:owner and a.sdate<=:start and a.edate>=:end";
                String hql2 = "select count(*) " + hsql;
                Date time = new Date(System.currentTimeMillis());
                Map<String,Object> m = new HashMap<String, Object>();
                m.put("owner", ownerId);
                m.put("start", time);
                m.put("end", time);
                List list2 = docAclDao.find(hql2, -1, -1, m);
                //sunzm hibernate 兼容性修改
                Pagination.setRowCount(((Number) (list2.get(0))).intValue());

                m.put("userIds", Constants.parseStrings2Longs(userIds, ","));
                return (List<DocAcl>) docAclDao.find(hql2, Pagination.getFirstResult(), Pagination.getMaxResults(), m);
            }
        });

        for (int i = 0; i < list.size(); i++) {
            DocResourcePO doc = docResourceDao.get(list.get(i).getDocResourceId());
            docList.add(doc);
        }
        return docList;
    }

    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getBorrowDocsPage(final String userIds, final Long ownerId, int currentPage, int pagesize) {
        final Set<Long> userIdLongs = Constants.parseStrings2Longs(userIds, ",");

        List<Long> list = (List<Long>) this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                String hsql = "from DocAcl as a where a.userId in (:userIds) and a.sharetype="
                        + Constants.SHARETYPE_PERSBORROW + " and ownerId=:owner and a.sdate<=:start and a.edate>=:end";
                String hql2 = "select count(distinct a.docResourceId) " + hsql;
                Date time = new Date(System.currentTimeMillis());
                Map<String,Object> m =  new HashMap<String, Object>();
                m.put("userIds", userIdLongs);
                m.put("start", time);
                m.put("end", time);
                m.put("owner", ownerId);
                List list2 = docAclDao.find(hql2, -1, -1, m);
                //sunzm hibernate 兼容性修改
                Pagination.setRowCount(((Number) (list2.get(0))).intValue());

                return (List<Long>) docAclDao.find("select distinct a.docResourceId " + hsql, Pagination.getFirstResult(), Pagination.getMaxResults(),m);
            }
        });

        List<DocResourcePO> docList = null;
        if (list != null && list.size() > 0) {
            Set<Long> idset = new HashSet<Long>();
            for (Long id : list) {
                idset.add(id);
            }

            String hql = "from DocResourcePO where id in(:ids) order by createTime desc";
            Map<String, Object> amap = new HashMap<String, Object>();
            amap.put("ids", idset);
            docList = this.docResourceDao.find(hql, -1, -1, amap);
        } else
            return new ArrayList<DocResourcePO>();

        return docList;
    }

    @SuppressWarnings("unchecked")
    public Set<Long> getBorrowUserIds(final String userIds) {
        /**
         * 查找出个人借阅的权限记录 将记录的所有人加入Set中
         */
        Set<Long> uidSet = new HashSet<Long>();
        final Set<Long> userIdLongs = Constants.parseStrings2Longs(userIds, ",");

        List<DocAcl> list = (List<DocAcl>) this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                String hsql = "from DocAcl as a where a.userId in (:userIds) and a.sharetype="
                        + Constants.SHARETYPE_PERSBORROW + " and a.sdate<=:start and a.edate>=:end";
                Date time = new Date(System.currentTimeMillis());
                Map<String,Object> m = new HashMap<String, Object>();
                m.put("userIds", userIdLongs);
                m.put("start", time);
                m.put("end", time);
                return (List<DocAcl>) docAclDao.find(hsql, -1, -1,m);
            }
        });

        // 2007.10.18 加入组织模型有效性判断
        List<DocAcl> list_valid = new ArrayList<DocAcl>();
        if (list != null)
            for (DocAcl acl : list) {
                if (Constants.isValidOrgEntity(V3xOrgEntity.ORGENT_TYPE_MEMBER, acl.getOwnerId())) {
                    list_valid.add(acl);
                }
            }

        for (int i = 0; i < list_valid.size(); i++) {
            uidSet.add(list_valid.get(i).getOwnerId());
        }
        return uidSet;
    }

    @SuppressWarnings("unchecked")
    public Set<Long> getBorrowUserIdsPage(final String userIds, int currentPage, int pagesize) {
        Set<Long> uidSet = new HashSet<Long>();
        final Set<Long> userIdLongs = Constants.parseStrings2Longs(userIds, ",");

        List<DocAcl> list = (List<DocAcl>) this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                String hsql = "from DocAcl as a where a.userId in (:userIds) and a.sharetype="
                        + Constants.SHARETYPE_PERSBORROW + " and a.sdate<=:start and a.edate>=:end";
                Date time = new Date(System.currentTimeMillis());
                Map<String,Object> m = new HashMap<String, Object>();
                m.put("userIds", userIdLongs);
                m.put("start", time);
                m.put("end", time);
                return (List<DocAcl>) docAclDao.find(hsql, -1, -1, m);
            }
        });

        // 2007.10.18 加入组织模型有效性判断
		List<DocAcl> list_valid = new ArrayList<DocAcl>();
		if (list != null) {
			for (DocAcl acl : list) {
				if (Constants.isValidOrgEntity(V3xOrgEntity.ORGENT_TYPE_MEMBER,
						acl.getOwnerId())) {
					list_valid.add(acl);
				}
			}
		}
          
        for (DocAcl da : list_valid) {
            uidSet.add(da.getOwnerId());
        }
        
        int dept = this.getDeptBorrowDocsCount(userIds) > 0 ? 1 : 0;
        
        // 但由于我要借出条目置顶指定，所以分多少页要进行计算
        pagesize = (pagesize == 1) ? 2:pagesize;
        double totalRow = (double)(uidSet.size() + dept);
        double totalPage = Math.ceil(totalRow / (pagesize - 1));
        Pagination.setRowCount((int)(totalRow+totalPage));
        // 虽然每页显示n个，可由于我借出的文档 一直要在行，其实要按n-1个/页来取
        int first = Pagination.getFirstResult() - currentPage + 1 ;
        int end1 = first + Pagination.getMaxResults() - 1;
        int end2 = uidSet.size();
		int end = 0;
		if (end1 > end2) {
			end = end2;
		} else {
			end = end1;
		}
		
        List<Long> uidList=new ArrayList<Long>();
        uidList.addAll(uidSet);
        
        if(currentPage != -1 && pagesize != -1){
        	uidList=uidList.subList(first, end);
        }
        
        return new HashSet<Long>(uidList);

    }
    
    /**
     * 查找个人共享的权限记录 根据记录的文档id查找出全部文档资源
     */
    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getShareRootDocs(String userIds, Long ownerId) {
        String hsql = "from DocAcl as a where a.userId in (:ids) and ownerId=:oid and (a.sharetype=:deptShare or a.sharetype=:personShare) "
                + "  order by a.docResourceId";
        Set<Long> ids = Constants.parseStrings2Longs(userIds, ",");
        try {
			ids.addAll(orgManager.getAllUserDomainIDs(ownerId));
		} catch (BusinessException e) {
			log.error("", e);
		}
        Map<String, Object> nmap = new HashMap<String, Object>();
        nmap.put("ids", ids);
        nmap.put("oid", ownerId);
        nmap.put("deptShare", Constants.SHARETYPE_DEPTSHARE);
        nmap.put("personShare", Constants.SHARETYPE_PERSSHARE);
        List<DocAcl> list = docAclDao.find(hsql, -1, -1, nmap);
        
        StringBuilder in = new StringBuilder();
        boolean flag = false ;
        for (int i = 0; i < list.size(); i++) {
            if(flag){
                in.append(",");
            }
            in.append(list.get(i).getDocResourceId());
            flag = true ;
        }
        if (in.length() > 0) {
            String sql = "from DocResourcePO as a where a.id in (:dids)";
            Map<String, Object> nmap2 = new HashMap<String, Object>();
            nmap2.put("dids", Constants.parseStrings2Longs(in.toString(), ","));
            return docResourceDao.find(sql, -1, -1, nmap2);
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getShareRootDocsPage(String userIds, Long ownerId, int currentPage, int pagesize) {
        String sql = "select distinct drp from DocResourcePO as drp,DocAcl as a where drp.id=a.docResourceId and a.userId in (:ids) and a.sharetype=" + Constants.SHARETYPE_PERSSHARE
            + " and a.ownerId=:oid order by drp.frOrder,drp.id";
        Map<String, Object> namedParameterMap = new HashMap<String, Object>();
        namedParameterMap.put("ids", Constants.parseStrings2Longs(userIds, ","));
        namedParameterMap.put("oid", ownerId);
        return docResourceDao.find(sql, namedParameterMap);
    }

    /**
     * 查找出个人共享的权限记录 将记录的所有人加入Set中
     * 查询共享所有人列表
     */
    @SuppressWarnings("unchecked")
    public Set<Long> getShareUserIds(String userIds) {
        Set<Long> uidSet = new HashSet<Long>();
        String hsql = "from DocAcl as a where a.userId in (:ids) and a.sharetype=" + Constants.SHARETYPE_PERSSHARE;
        Map<String, Object> nmap = new HashMap<String, Object>();
        nmap.put("ids", Constants.parseStrings2Longs(userIds, ","));
        List<DocAcl> list = docAclDao.find(hsql, -1, -1, nmap);

        // 2007.10.18 加入组织模型有效性判断
        List<DocAcl> list_valid = new ArrayList<DocAcl>();
        if (list != null)
            for (DocAcl acl : list) {
                if (Constants.isValidOrgEntity(V3xOrgEntity.ORGENT_TYPE_MEMBER, acl.getOwnerId())) {
                    list_valid.add(acl);
                }
            }

        for (int i = 0; i < list_valid.size(); i++) {
            uidSet.add(list_valid.get(i).getOwnerId());
        }
        return uidSet;
    }

    // 查询共享所有人列表（分页）
    @SuppressWarnings("unchecked")
    public Set<Long> getShareUserIdsPage(String userIds, int currentPage, int pagesize) {
        Set<Long> uidSet = new HashSet<Long>();
        String hsql = "from DocAcl as a where a.userId in (:ids) and a.sharetype=" + Constants.SHARETYPE_PERSSHARE;
        Map<String, Object> nmap = new HashMap<String, Object>();
        nmap.put("ids", Constants.parseStrings2Longs(userIds, ","));
        List<DocAcl> list = docAclDao.find(hsql, -1, -1, nmap);

        // 2007.10.18 加入组织模型有效性判断
        List<DocAcl> list_valid = new ArrayList<DocAcl>();
        if (list != null)
            for (DocAcl acl : list) {
                if (Constants.isValidOrgEntity(V3xOrgEntity.ORGENT_TYPE_MEMBER, acl.getOwnerId())) {
                    list_valid.add(acl);
                }
            }
        Pagination.setRowCount(list_valid.size());

        int first = Pagination.getFirstResult();
        int end1 = first + Pagination.getMaxResults();
        int end2 = list_valid.size();
        int end = 0;
        if (end1 > end2){
            end = end2; 
        }else{
            end = end1;
        }
        
        List<DocAcl> list_valid_ret = list_valid.subList(first, end);
        for (DocAcl da : list_valid_ret) {
            uidSet.add(da.getOwnerId());
        }
        return uidSet;
    }

    // 设置继承权限
    @SuppressWarnings("unchecked")
    public void setPotentInherit(Long docId, byte docLibType, long docLibId) {
        // 删除所有非继承的权限
        String hql1 = "from DocAcl as a where a.docResourceId = ?" + " and (a.sharetype="
                + Constants.SHARETYPE_DEPTSHARE+" or a.sharetype = "+ Constants.SHARETYPE_PERSSHARE+")";
        String hql = "delete "+ hql1;
        List<DocAcl> srclist = docAclDao.findVarargs(hql1, docId);
        if (Strings.isEmpty(srclist)){
            return;
        }
        docAclDao.bulkUpdate(hql, null, new Object[] { docId });

        // 在删除权限的时候判断 在当前自定义库下，是否仍有有权限的文档记录，没有则删除 member 记录
        if (docLibType == Constants.USER_CUSTOM_LIB_TYPE.byteValue()) {
            String hql2 = "from DocResourcePO where docLibId = ?";
            List<DocResourcePO> list = docResourceDao.findVarargs(hql2, docLibId);
            StringBuilder drids = new StringBuilder();
            boolean flag = false ;
            for (DocResourcePO d : list) {
                if (flag) {
                    drids.append(",");
                }
                drids.append(d.getId());
                flag = true;
            }
            
            flag=false;
            if (drids.length()!=0) {
                StringBuilder userids = new StringBuilder();
                for (DocAcl da : srclist) {
                    if(flag){
                        userids.append(",");
                    }
                    flag=true;
                    userids.append(da.getUserId());
                }
                String ids = drids.toString();
                String hql3 = "from DocAcl where docResourceId in(:dids) and userId in(:uids)";
                Map<String, Object> nmap = new HashMap<String, Object>();
                nmap.put("dids", Constants.parseStrings2Longs(ids, ","));
                nmap.put("uids", Constants.parseStrings2Longs(userids.toString(), ","));
                List<DocAcl> list2 = docAclDao.find(hql3, -1, -1, nmap);
                if (Strings.isEmpty(list2)) {
                    this.deleteLibMember(docLibId, userids.toString());
                }
            }
        }
        //如果是项目文档恢复继承1.找到当前项目id的summaryId，2.找到相关人员
        if (Constants.PROJECT_LIB_TYPE.equals(docLibType)) {
            DocResourcePO project = docHierarchyManager.getDocResourceById(docId);
            if (project != null && project.getSourceId() != null) {//项目根目录
                List<ProjectMemberInfoBO> memberInfos;
                try {
                    memberInfos = projectApi.findProjectMembers(project.getSourceId());
                    if (Strings.isNotEmpty(memberInfos)) {
                        saveProjectAcl(memberInfos, project.getCreateUserId(), project.getId(), project.getSourceId());
                    }
                } catch (BusinessException e) {
                    log.error("", e);
                }
            }
        }
    }
    
    // 保存项目权限
    // 负责人、助理：全部权限
    // 成员、领导：增、看
    // 相关人员：看
    @SuppressWarnings("unchecked")
	public void saveProjectAcl(List<ProjectMemberInfoBO> members, Long userId, Long projectFolderId, Long projectId) throws BusinessException {
        int minOrder = getMaxOrder();
//        List<Long> userIds = CommonTools.getIds(members);
        List<Long> userIds = new ArrayList<Long>();
        if (CollectionUtils.isNotEmpty(members)) {
        	for (ProjectMemberInfoBO member : members) {
        		userIds.add(member.getMemberId());
        	}
        }
        
        List<DocAlertPO> docAlerts = new ArrayList<DocAlertPO>();
        List<DocAcl> newDocAcl = new ArrayList<DocAcl>();
        List<DocAcl> updateDocAcl = new ArrayList<DocAcl>();
        Map<String,Object> params = new HashMap<String, Object>();
        DocResourcePO docRes = docResourceDao.get(projectFolderId);
        DocLibPO docLib = this.docUtils.getDocLibById(docRes.getDocLibId());
        Map<Long,DocAcl> userId2DocAcl = new HashMap<Long, DocAcl>();//user->acl
        boolean isCustomLib = docLib.getType() == Constants.USER_CUSTOM_LIB_TYPE.byteValue();
        
        String hql = "from DocAcl acl where acl.userId in(:userIds) and acl.userType=:userType and acl.sharetype=:sharetype and acl.docResourceId=:docResourceId";
        params.put("userType", V3xOrgEntity.ORGENT_TYPE_MEMBER);
        params.put("sharetype", Constants.SHARETYPE_DEPTSHARE);
        params.put("docResourceId", projectFolderId);
        List<DocAcl> l = new ArrayList<DocAcl>();
        List<DocAcl> docAclList = new ArrayList<DocAcl>();
        if(userIds.size()>1000){
        	List<Long>[] splitIds = Strings.splitList(userIds, 999);
        	for(List<Long> sp:splitIds){
        		params.put("userIds", sp);
        		l = DBAgent.find(hql, params);
        		docAclList.addAll(l);
        	}
        }else{
        	params.put("userIds", userIds);
        	docAclList = DBAgent.find(hql, params);
        }
        
        for (DocAcl acl : docAclList) {
            userId2DocAcl.put(acl.getUserId(), acl);
        }
        
        for (ProjectMemberInfoBO pm : members) {
            DocAlertPO alert = DocAlertPO.valueOf(projectFolderId, true, Constants.ALERT_OPR_TYPE_ADD, V3xOrgEntity.ORGENT_TYPE_MEMBER, pm.getMemberId(), userId, true, false, true);
            docAlerts.add(alert);// 默认给项目成员订阅
            Long alertId = alert.getId();
            Byte type = (byte) pm.getMemberType();
            Long memberId = pm.getMemberId();
            DocAcl acl = userId2DocAcl.get(memberId);
            if (acl == null) {
                acl = new DocAcl();
                acl.setIdIfNew();
                acl.setDocResourceId(projectFolderId);
                acl.setUserId(memberId);
                acl.setUserType(V3xOrgEntity.ORGENT_TYPE_MEMBER);
                acl.setSharetype(Constants.SHARETYPE_DEPTSHARE);
                userId2DocAcl.put(memberId, acl);
                newDocAcl.add(acl);
            }
            acl.setIsAlert(true);
            acl.setDocAlertId(alertId);
            acl.setAclOrder(minOrder + 1);
            minOrder++;
            boolean isProjectMember = false;
            if (ProjectMemberInfoBO.memberType_charge.equals(type) || ProjectMemberInfoBO.memberType_member.equals(type)) {// 项目领导、项目成员
                acl.getMappingPotent().adapterIntAddPotent(Constants.ADDPOTENT);
                acl.getMappingPotent().adapterIntAddPotent(Constants.READONLYPOTENT);
                isProjectMember  = true;
            } else if (ProjectMemberInfoBO.memberType_interfix.equals(type)) { // 相关人员
                acl.getMappingPotent().adapterIntAddPotent(Constants.READONLYPOTENT);
                isProjectMember  = true;
            } else if (ProjectMemberInfoBO.memberType_manager.equals(type) || ProjectMemberInfoBO.memberType_assistant.equals(type)) { // 项目负责人、项目助理
                acl.getMappingPotent().adapterIntAddPotent(Constants.ALLPOTENT);
                isProjectMember  = true;
            }
            if (isCustomLib && isProjectMember) {
                this.setLibMember(docLib.getId(), userId, V3xOrgEntity.ORGENT_TYPE_MEMBER);
            }
        }
        
        for (DocAcl docAcl : newDocAcl) {
            userId2DocAcl.remove(docAcl.getUserId());
        }
        
        for (Map.Entry<Long, DocAcl> uEntry : userId2DocAcl.entrySet()) {
            updateDocAcl.add(uEntry.getValue());
        }
        
        DBAgent.saveAll(docAlerts);
        DBAgent.saveAll(newDocAcl);
        DBAgent.updateAll(updateDocAcl);
    }

    // 设置个人共享权限
    public Long setPersonalSharePotent(Long userId, String userType, Long docId, Long ownerId, Long alertId) {
        DocAcl acl = buildDocAcl(userId, userType, docId, Constants.SHARETYPE_PERSSHARE);
        acl.setOwnerId(ownerId);
        acl.getMappingPotent().adapterIntAddPotent(Constants.PERSONALSHARE);// 个人共享暂时设为8
        //个人共享默认为浏览权限
        acl.getMappingPotent().setRead(true);
        acl.getMappingPotent().setList(true);
        if (alertId != null) {
            acl.setIsAlert(true);
            acl.setDocAlertId(alertId);
        }
        docDao.saveOrUpdate(acl);
        return acl.getId();
    }

    private DocAcl buildDocAcl(Long userId, String userType, Long docId, Byte sharetype) {
        DocAcl acl = null;
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("userId", userId);
        params.put("userType", userType);
        params.put("sharetype", sharetype);
        params.put("docResourceId", docId);
        List<DocAcl> docAcls = docDao.findBy(DocAcl.class, params);
        if (!docAcls.isEmpty()) {
            acl = docAcls.get(0);
        } else {
            acl = new DocAcl();
            acl.setIdIfNew();
            acl.setDocResourceId(docId);
            acl.setUserId(userId);
            acl.setUserType(userType);
            acl.setSharetype(sharetype);
        }
        return acl;
    }

    // 设置个人借阅的权限
    public void setNewPersonalBorrowPotent(Long userId, String userType, Long docId, Long ownerId, Date sdate,
            Date edate, Byte lenPotent, String lenPotent2) {
        DocAcl acl = buildDocAcl(userId, userType, docId, Constants.SHARETYPE_PERSBORROW);
        acl.setOwnerId(ownerId);
        acl.getMappingPotent().adapterIntAddPotent(Constants.PERSONALBORROW);
        acl.setSharetype(Constants.SHARETYPE_PERSBORROW);
        acl.setEdate(edate);
        acl.setSdate(sdate);
        acl.setLenPotent(lenPotent);
        acl.getMappingPotent().setLenPotent2(lenPotent2);
        acl.getMappingPotent().setList(true);
        docDao.saveOrUpdate(acl);
    }

    // 更新个人借阅的权限，只许更新开始、结束时间
    public void updatePersonalBorrowPotent(Long docAclId, Date sdate, Date edate) {
        DocAcl acl = docAclDao.get(docAclId);
        acl.setEdate(edate);
        acl.setSdate(sdate);
        docAclDao.update(acl);
    }

    /** 删除借阅权限  */
    public void deleteBorrowDoc(Long docAclId) {
        docAclDao.delete(docAclId.longValue());
    }

    /** 删除共享权限  */
    public void deleteShareDoc(Long docAclId) {
        docAclDao.delete(docAclId.longValue());
    }

    // 获取单位借阅列表（分页）
    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getDeptBorrowDocsPageOld(final String userIds, int currentPage, int pagesize) {
        List<DocAcl> list = (List<DocAcl>) this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                String hsql = "from DocAcl as a where a.userId in (" + userIds + ") and a.sharetype="
                        + Constants.SHARETYPE_DEPTBORROW + " and a.sdate<=:starttime and a.edate>=:endtime";
                String hql2 = "select count(*) " + hsql;
                Date time = new Date(System.currentTimeMillis());
                Map<String,Object> m = new HashMap<String, Object>();
                m.put("starttime", time);
                m.put("endtime", time);
                List list2 = docAclDao.find(hql2, -1, -1, m);
                //sunzm hibernate 兼容性修改
                Pagination.setRowCount(((Number) (list2.get(0))).intValue());

                return (List<DocAcl>) docAclDao.find(hsql, Pagination.getFirstResult(), Pagination.getMaxResults(), m);
            }
        });

        List<DocResourcePO> docList = new ArrayList<DocResourcePO>();
        for (int i = 0; i < list.size(); i++) {
            DocResourcePO doc = docResourceDao.get(list.get(i).getDocResourceId());
            docList.add(doc);
        }
        return docList;
    }

    @SuppressWarnings("unchecked")
    public List<DocResourcePO> getDeptBorrowDocsPage(final String userIds, int currentPage, int pagesize) {

        final Set<Long> userIdLongs = Constants.parseStrings2Longs(userIds, ",");
        List<Long> list = (List<Long>) this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                String hsql = "from DocAcl as a where a.userId in (:userIds) and a.sharetype="
                        + Constants.SHARETYPE_DEPTBORROW + " and a.sdate<=:starttime and a.edate>=:endtime";
                String hql2 = "select count(distinct a.docResourceId) " + hsql;
                Date time = new Date(System.currentTimeMillis());
                Map<String,Object> m = new HashMap<String, Object>();
                m.put("userIds", userIdLongs);
                m.put("starttime", time);
                m.put("endtime", time);
                List list2 = docAclDao.find(hql2, -1, -1, m);
                //sunzm hibernate 兼容性修改
                Pagination.setRowCount(((Number) (list2.get(0))).intValue());

                return (List<Long>) docAclDao.find("select distinct a.docResourceId " + hsql, Pagination.getFirstResult(), Pagination.getMaxResults(), m);
            }
        });

        List<DocResourcePO> docList = null;
        if (list != null && list.size() > 0) {
            Set<Long> idsset = new HashSet<Long>();
            for (Long id : list) {
                idsset.add(id);
            }

            String hql = "from DocResourcePO where id in(:ids)";
            Map<String, Object> amap = new HashMap<String, Object>();
            amap.put("ids", idsset);
            docList = this.docResourceDao.find(hql, -1, -1, amap);
        } else
            return new ArrayList<DocResourcePO>();

        return docList;
    }

    // 获取单位借阅列表记录数
    @SuppressWarnings("unchecked")
    public int getDeptBorrowDocsCount(final String userIds) {
        Map<String, Object> nmap = new HashMap<String, Object>();
        nmap.put("userIds", Constants.parseStrings2Longs(userIds, ","));
        String hsql = "from DocAcl as a where a.userId in (:userIds) and a.sharetype=" + Constants.SHARETYPE_DEPTBORROW;
        List<DocAcl> list2 = docAclDao.find(hsql, -1, -1, nmap);
        return list2.size();
    }

    // 设置单位借阅权限
    public void setNewDeptBorrowPotent(Long userId, String userType, Long docId, Date sdate, Date edate,
            Byte lenPotent, String lenPotent2) {
        DocAcl acl = buildDocAcl(userId, userType, docId, Constants.SHARETYPE_DEPTBORROW);
        acl.setEdate(edate);
        acl.setSdate(sdate);
        acl.setLenPotent(lenPotent);
        acl.getMappingPotent().adapterIntAddPotent(Constants.DEPTBORROW);
        acl.getMappingPotent().setLenPotent2(lenPotent2);
        acl.getMappingPotent().setList(true);
        docDao.saveOrUpdate(acl);
    }

    // 更新单位借阅权限
    public void updateDeptBorrowPotent(Long docAclId, Date sdate, Date edate) {
        DocAcl acl = docAclDao.get(docAclId);
        acl.setEdate(edate);
        acl.setSdate(sdate);
        docAclDao.update(acl);
    }

    // 设置单位共享权限
    public void setDeptSharePotent(Long userId, String userType, Long docId, int potent, boolean isAlert, Long alertId,
            int minOrder) {
        DocResourcePO docRes = docResourceDao.get(docId);
        DocLibPO docLib = this.docUtils.getDocLibById(docRes.getDocLibId());

        DocAcl acl = buildDocAcl(userId, userType, docId, Constants.SHARETYPE_DEPTSHARE);
        acl.getMappingPotent().adapterIntAddPotent(potent);
        acl.setIsAlert(isAlert);
        acl.setDocAlertId(alertId);
        acl.setAclOrder(minOrder + 1);
        docDao.saveOrUpdate(acl);

        if (docLib.getType() == Constants.USER_CUSTOM_LIB_TYPE.byteValue() && potent != Constants.NOPOTENT) {
            this.setLibMember(docLib.getId(), userId, userType);
        }
    }

    // 判断是否有权限删除文档夹/文档
    @SuppressWarnings("unchecked")
    public boolean canBeDelete(DocResourcePO doc, String userIds) {
        /**
         * 取得文档的逻辑路径，获得此节点上级的全部节点 根据节点和用户反向从DocAcl表中查找有权限的记录
         * 如过查到且权限为:编辑权限or全部权限,则证明本级可删除,跳出循环;否则继续查找上级节点权限 查询全部下级节点
         * 根据节点id循环查询是否有权限删除 如果全部有权限则证明下级文档可删除;否则下级文档不可删除
         * 如果本级和下级都可删除则返回true;否则返回false
         */
        boolean flag = false;// 是否有权限标记
        String lp = doc.getLogicalPath();
        String[] lps = lp.split("\\.");
        // 从下而上的查找权限信息（查找本级是否可删除）
        for (int i = lps.length - 1; i >= 0; i--) {
            String hsql = "from DocAcl as a where a.docResourceId = :docid and a.userId in (:userids) order by a.potent";
            Map<String, Object> namedMap = new HashMap<String, Object>();
            namedMap.put("docid", Long.valueOf(lps[i]));
            namedMap.put("userids", Constants.parseStrings2Longs(userIds, ","));
            List<DocAcl> list = docAclDao.find(hsql, -1, -1, namedMap);//log.info("canBeDelete使用namedMap，in 结果：" + list);
            for (int j = 0; j < list.size(); j++) {
                Potent potent = list.get(j).getMappingPotent();
                if (potent.isAll() || potent.isEdit()) {// 编辑权限or全部权限
                    flag = true;
                    break;
                }
            }
            if (flag) {
                break;
            }
        }
        // 自上而下的查找权限信息（查找下级是否可删除）
        boolean flagNext = true;
        String hsql2 = "from DocResourcePO as a where a.logicalPath like :lp order by a.frOrder ,a.id";
        Map<String, Object> namedMap = new HashMap<String, Object>();
        namedMap.put("lp", lp + ".%");
        List<DocResourcePO> dlist = docResourceDao.find(hsql2, -1, -1, namedMap);//log.info("canBeDelete使用namedMap，like 结果：" + dlist);
        for (int i = 0; i < dlist.size(); i++) {
            String hsql3 = "from DocAcl as a where a.docResourceId = :docid and a.userId in (:userids) order by a.potent desc";
            Map<String, Object> nameMap = new HashMap<String, Object>();
            nameMap.put("docid", dlist.get(i).getId());
            nameMap.put("userids", Constants.parseStrings2Longs(userIds, ","));
            List<DocAcl> alist = docAclDao.find(hsql3, -1, -1, nameMap);
            for (int j = 0; j < alist.size(); j++) {
                Potent potent = alist.get(j).getMappingPotent();
                if (potent.isNoPotent()) {
                    flagNext = false;
                }
                if (potent.isAll() || potent.isEdit()) {
                    flagNext = true;
                }
            }
            if (!flagNext) {
                break;
            }
        }

        return flag && flagNext;
    }

    // 设置文档库成员
    public void setLibMember(Long docLibId, Long userId, String userType) {
        this.docUtils.getDocLibManager().setLibMember(docLibId, userId, userType);
    }

    // 删除文档库成员
    public void deleteLibMember(Long docLibId, String userIds) {
        this.docUtils.getDocLibManager().deleteLibMember(docLibId, userIds);
    }

    // 删除权限
    @SuppressWarnings("unchecked")
    public void deletePotentByUser(Long docId, Long userId, String userType, byte docLibType, long docLibId) {
        String hsql = "delete from DocAcl as a where a.docResourceId=? and a.userId=?" + " and a.sharetype="
                + Constants.SHARETYPE_DEPTSHARE + " and a.userType=?";
        docAclDao.bulkUpdate(hsql, null, docId, userId, userType);
        
        String hql3 = "select da from " + DocAcl.class.getName() + " da, " + DocResourcePO.class.getName()
                + " dr where da.docResourceId = dr.id "
                + "and dr.docLibId = :ids and dr.isFolder = true and da.userId = :userid and da.sharetype = "
                + Constants.SHARETYPE_DEPTSHARE + " and da.potent != '" + Potent.noPotent+"'";

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("ids", docLibId);
        map.put("userid", userId);
        List<DocAcl> list2 = docAclDao.find(hql3, -1, -1, map);
        if (Strings.isEmpty(list2)) {
            this.deleteLibMember(docLibId, "" + userId);
        }
    }

    // 删除权限
    @SuppressWarnings("unchecked")
    public void deletePotentByMaUser(Long docId, Long userId, String userType, byte docLibType, long docLibId) {
        String hsql = "delete from DocAcl as a where a.docResourceId=? and a.userId=?" + " and a.sharetype="
                + Constants.SHARETYPE_DEPTSHARE + " and a.userType=?";
        docAclDao.bulkUpdate(hsql, null, docId, userId, userType);

        /*String hql3 = "from DocAcl where docResourceId in(select doc.id from DocResource doc where doc.docLibId =:ids and doc.isFolder = true ) and userId = :userid and sharetype = "
        			  + Constants.SHARETYPE_DEPTSHARE + " and potent != " + Constants.NOPOTENT;*/

        String hql2 = "select da.id from " + DocAcl.class.getName() + " da, " + DocResourcePO.class.getName()
                + " dr where da.docResourceId = dr.id "
                + "and dr.docLibId = :ids and dr.isFolder = true and da.userId = :userid and da.sharetype = "
                + Constants.SHARETYPE_DEPTSHARE;

        String hql3 = hql2 + " and da.potent != '" + Potent.noPotent+"'";

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("ids", docLibId);
        map.put("userid", userId);

        List<Long> list2 = docAclDao.find(hql3, -1, -1, map);
        if (CollectionUtils.isEmpty(list2)) {
            this.deleteLibMember(docLibId, "" + userId);
        }
        /*String hql4 = "delete from DocAcl where docResourceId in(select doc.id from DocResource doc where doc.docLibId =:ids and doc.isFolder = true ) and userId = :userid and sharetype = "
        		+ Constants.SHARETYPE_DEPTSHARE;*/

        List<Long> list3 = docAclDao.find(hql2, -1, -1, map);
        /* if (CollectionUtils.isNotEmpty(list3)) {
            String hql4 = "delete from " + DocAcl.class.getName() + " where id in (:ids2)";
            docAclDao.bulkUpdate(hql4, CommonTools.newHashMap("ids2", list3));
        }*/
    
        if (CollectionUtils.isNotEmpty(list3)) {
            // 存放判定数据
            Map<String, Object> map3 = new HashMap<String, Object>();
            int len = list3.size();
            // in中的条件每次最多900
            int count = 900;
            int size = len % count;
            if(size == 0) {
                size = len / count;
            } else {
                size = (len / count) + 1;
            }
            String hql4 = "delete from " + DocAcl.class.getName() + " where id ";
            for(int i = 0; i < size; i++) {
                map3.clear();
                String hql4_1 = hql4;
                int fromIndex = i * count;
                int toIndex = Math.min(fromIndex + count, len);
                hql4_1+="in (:ids"+ String.valueOf(i+2) +") ";
                map3.put("ids"+String.valueOf(i+2), list3.subList(fromIndex, toIndex));
                docAclDao.bulkUpdate(hql4_1.toString(), map3);
            }
        }

        // 此处可能会有问题, 出现过客户bug
        //文档库管理员无需删组织模型, 查看时单独处理
        /*String aclIds = Constants.getOrgIdsOfUser(userId);
        Map<String, Object> nmap = new HashMap<String, Object>();
        nmap.put("ids", docLibId);
        nmap.put("userIds", Constants.parseStrings2Longs(aclIds, ","));

        String hql5 = "delete from DocAcl where docResourceId in (select doc.id from DocResource doc where doc.docLibId =:ids and doc.isFolder = true ) and userId in (:userIds) and sharetype = "
        		+ Constants.SHARETYPE_DEPTSHARE + "and potent = " + Constants.NOPOTENT;
        docAclDao.bulkUpdate(hql5, nmap);*/
    }

    // 删除权限
    public void deletePotentByUser(Long aclId) {
        docAclDao.delete(aclId.longValue());
    }

    // 查找继承的权限记录
    @SuppressWarnings("unchecked")
    public List<DocAcl> getDocAclListByInherit(Long docId) {
        /**
         * 取得文档资源的逻辑路径 从文档资源的上级节点开始反向查找单位共享的权限记录
         */
        List<DocAcl> list = new ArrayList<DocAcl>();
        String notin = "";
        String hsql2 = "from DocAcl as a where a.docResourceId = ? and a.userId=?" + " and a.sharetype="
                + Constants.SHARETYPE_DEPTSHARE + " and a.userType=? order by a.potent";// 查找上级的权限

        String lp = docResourceDao.get(docId).getLogicalPath();
        String[] ss = lp.split("\\.");
        if (ss.length == 1)
            return null;
        
        Map<String, Object> namedParameterMap = new HashMap<String, Object>();
        for (int i = ss.length - 2; i >= 0; i--) {
            if (notin.length() != 0) {
                namedParameterMap.put("userId", Constants.parseStrings2Longs(notin, ","));
            }
            String hsql = "select a.userId, a.userType from DocAcl as a where a.docResourceId=? and a.sharetype="
                    + Constants.SHARETYPE_DEPTSHARE + " group by a.userId,a.userType";
            if (notin.length() != 0) {
                hsql = "select a.userId, a.userType from DocAcl as a where a.docResourceId=? and a.userId not in (:userId) and a.sharetype="
                        + Constants.SHARETYPE_DEPTSHARE + " group by a.userId,a.userType";
            } 
            
            List<Object[]> l = docAclDao.find(hsql, -1, -1, namedParameterMap, Long.parseLong(ss[i])); // 分组查找上级的权限
            aaa: for (Object[] acl : l) {
                Long userId = (Long) (acl[0]);
                for (DocAcl a : list) {
                    if (a.getUserId() == userId) {
                        continue aaa;
                    }
                }
                String userType = acl[1].toString();
                List<DocAcl> l2 = docAclDao.findVarargs(hsql2, Long.valueOf(ss[i]), userId, userType);
                for (DocAcl a : l2) {
                    if (a.getMappingPotent().isNoPotent()) {
                        notin = notin + userId + ",";
                    } else {
                        if (list.isEmpty()){
                            list.add(a);
                        }else {
                            list.add(a);
                        }
                    }
                }
            }
        }

        return this.filterInvalid(list);
    }

    // 查找非继承的权限记录
    // lihf 
    @SuppressWarnings("unchecked")
    public List<List<DocAcl>> getDocAclListByNew(Long docId) {
        /**
         * 查找本级的权限记录
         */
        List<List<DocAcl>> list = new ArrayList<List<DocAcl>>();
        String hsql = "select a.userId, a.userType from DocAcl as a where a.docResourceId=? and a.sharetype="
                + Constants.SHARETYPE_DEPTSHARE + " group by a.userId,a.userType";
        String hsql2 = "from DocAcl as a where a.docResourceId = ?" + " and a.userId=?" + " and a.sharetype="
                + Constants.SHARETYPE_DEPTSHARE + " and userType=? order by a.potent ";
        //                  + "' and a.potent!=" + Potent.noPotent;
        List<Object[]> l = docAclDao.findVarargs(hsql, docId);// 分组查找
        for (Object[] acl : l) {
            Long userId = (Long) (acl[0]);
            String userType = acl[1].toString();
            List<DocAcl> l2 = docAclDao.findVarargs(hsql2, docId, userId, userType);// 根据分组查找记录
            if (!list.contains(l2) && l2.size() > 0)
                list.add(l2);
        }

        // 进行组织模型实体有效性判断
        List<List<DocAcl>> list_ret = new ArrayList<List<DocAcl>>();
        for (List<DocAcl> sublist : list) {
            if (sublist != null && sublist.size() > 0) {
                if (Constants.isValidOrgEntity(sublist.get(0).getUserType(), sublist.get(0).getUserId()))
                    list_ret.add(sublist);
            }
        }

        return list_ret;
    }

    // 个人借阅权限列表
    @SuppressWarnings("unchecked")
    public List<DocAcl> getPersonalBorrowList(final Long docResourceId) {
        String hsql = "from DocAcl as a where a.docResourceId=? and a.sharetype =" + Constants.SHARETYPE_PERSBORROW
                + " and a.edate>=?";
        List<DocAcl> l = this.docAclDao.findVarargs(hsql, docResourceId, new Date(System.currentTimeMillis()));
        return filterInvalid(l);
    }

    // 单位借阅权限列表
    @SuppressWarnings("unchecked")
    public List<DocAcl> getDeptBorrowList(final Long docResourceId) {
        String hsql = " from DocAcl as a where a.docResourceId=? and a.sharetype =" + Constants.SHARETYPE_DEPTBORROW
                + " and a.edate>=?";
        List<DocAcl> docAclList = this.docAclDao.findVarargs(hsql, docResourceId, new Date(System.currentTimeMillis()));
        return this.filterInvalid(docAclList);
    }

    // 个人共享权限列表
    @SuppressWarnings("unchecked")
    public List<DocAcl> getPersonalShareList(Long docResourceId) {
        String hsql = "from DocAcl as a where a.docResourceId=? and a.sharetype =" + Constants.SHARETYPE_PERSSHARE;
        List<DocAcl> docAclList = docAclDao.findVarargs(hsql, docResourceId);
        return this.filterInvalid(docAclList);
    }

    /** 进行组织模型实体有效性判断  */
    private List<DocAcl> filterInvalid(List<DocAcl> docAclList) {
        List<DocAcl> list_ret = new ArrayList<DocAcl>();
        if (CollectionUtils.isNotEmpty(docAclList)) {
            for (DocAcl acl : docAclList) {
                if (Constants.isValidOrgEntity(acl.getUserType(), acl.getUserId())) {
                    list_ret.add(acl);
                }
            }
        }
        return list_ret;
    }

    /** 个人共享继承的权限列表   */
    @SuppressWarnings("unchecked")
    public List<DocAcl> getPersonalShareInHeritList(Long docResourceId) {
        DocResourcePO doc = docResourceDao.get(docResourceId);
        if (doc != null) {
            DocResourcePO parDoc = docResourceDao.get(doc.getParentFrId());
            if (parDoc != null) {
                String lp = parDoc.getLogicalPath();
                Long drId = this.getDrId4Acl(lp);
                if (drId != null) {
                    String hsql = "from DocAcl as a where a.docResourceId=?" + " and a.sharetype="
                            + Constants.SHARETYPE_PERSSHARE;
                    List<DocAcl> l = docAclDao.findVarargs(hsql, drId);
                    return filterInvalid(l);
                }
            }
        }
        return null;
    }

    /**
     * 获取子文档夹继承权限所依赖的最近父文档夹ID
     * @param logicalPath	子文档夹上一级父文档夹的逻辑路径	
     */
    @SuppressWarnings("unchecked")
    private Long getDrId4Acl(String logicalPath) {
        String hql = "select docResourceId, count(id) from DocAcl where docResourceId in (:drIds) "
                + "and sharetype=:sharetype  group by docResourceId";
        Map<String, Object> nameParameters = new HashMap<String, Object>();
        List<Long> drIds = CommonTools.parseStr2Ids(logicalPath, "[.]");
        nameParameters.put("drIds", drIds);
        nameParameters.put("sharetype", Constants.SHARETYPE_PERSSHARE);

        List<Object[]> result = this.docAclDao.find(hql, -1, -1, nameParameters);

        Long ret = null;
        if (CollectionUtils.isNotEmpty(result)) {
            Map<Long, Integer> map = new HashMap<Long, Integer>();
            for (Object[] arr : result) {
                //sunzm hibernate 兼容性修改
                map.put((Long) arr[0], ((Number) arr[1]).intValue());
            }

            Collections.reverse(drIds);
            for (Long drId : drIds) {
                if (map.get(drId) != null && map.get(drId).intValue() > 0) {
                    ret = drId;
                    break;
                }
            }
        }
        if (log.isDebugEnabled()) {
            log.debug(ret == null ? "哥，翻遍祖宗十八代都找不到订阅记录，洗洗睡吧..." : "哥，找到订阅记录了!年谱中，这位爷的身份证号是[" + ret + "]");
        }
        return ret;
    }

    /** 删除权限   */
    public void deletePotentByUser(Long docResourceId, Long userId, String userType, int potent) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("userId", userId);
        params.put("docResourceId", docResourceId);
        params.put("userType", userType);
        List<DocAcl> docAcls = docDao.findBy(DocAcl.class, params);
        if (!docAcls.isEmpty()) {
            DocAcl docAcl = docAcls.get(0);
            docAcl.getMappingPotent().adapterIntDelPotent(potent);
            docDao.update(docAcl);
        }
        //      String hsql = "delete from DocAcl as a where a.docResourceId=? and a.userId=? and a.userType=? and a.potenttype=?";
        //        docAclDao.bulkUpdate(hsql, null, docResourceId, userId, userType, potent);
    }

    /** 是否不继承   */
    public boolean isNoInherit(Long userId, String userType, Long docResourceId) {
        String hsql = "select count(a.id) from DocAcl as a where a.docResourceId = ? and a.userId=? and a.userType=? and a.potent = '"
                + Potent.noPotent+"'" ;

        // sunzm hibernate兼容性修改
        Integer count = null;
        Number number = (Number) docAclDao.findUnique(hsql, null, docResourceId, userId, userType);
        if (null != number) {
            count = number.intValue();
        }
        return count != null && count.intValue() > 0;
    }

    // 删除借阅
    public void deleteBorrow(Long docResourceId, boolean isMine) {
        String hsql = "delete from DocAcl as a where a.docResourceId=?";
        if (isMine) {
            hsql = hsql + " and a.sharetype=" + Constants.SHARETYPE_PERSBORROW;
        } else {
            hsql = hsql + " and a.sharetype=" + Constants.SHARETYPE_DEPTBORROW;
        }
        docAclDao.bulkUpdate(hsql, null, docResourceId);
    }

    /**
     * 将不在usersId这个集合中的借阅对象删除
     */
    public void deleteBorrow(Long docResourceId, List<Long> usersId, boolean isMine) {
        docAclDao.deleteBorrow(docResourceId, usersId, isMine);
    }

    /**
     * 判断是不是有此人的在此文档的借阅
     * @param docResourceId
     * @param userid
     * @return
     */
    @SuppressWarnings("unchecked")
    public boolean hasAclertBoorrow(Long docResourceId, Long userid, boolean isMine) {
        boolean flag = false;
        DetachedCriteria dc;
        if (isMine) {
            dc = DetachedCriteria.forClass(DocAcl.class).add(Restrictions.eq("docResourceId", docResourceId))
                    .add(Restrictions.eq("userId", userid))
                    .add(Restrictions.eq("sharetype", Constants.SHARETYPE_PERSBORROW));
        } else {
            dc = DetachedCriteria.forClass(DocAcl.class).add(Restrictions.eq("docResourceId", docResourceId))
                    .add(Restrictions.eq("userId", userid))
                    .add(Restrictions.eq("sharetype", Constants.SHARETYPE_DEPTBORROW));
        }

        List<DocAcl> docAclList = docAclDao.executeCriteria(dc, -1, -1);
        if (!docAclList.isEmpty()) {
            flag = true;
        }
        return flag;
    }

    // 删除个人共享
    public void deletePersonalShare(Long docResourceId) {
        String hsql = "delete from DocAcl as a where a.docResourceId=? and a.sharetype="
                + Constants.SHARETYPE_PERSSHARE;
        docAclDao.bulkUpdate(hsql, null, docResourceId);
    }

    public void deletePersonalShare(Long docResourceId, List<Long> userIds, boolean isPersonLib) {
        docAclDao.deletePersonalShare(docResourceId, userIds, isPersonLib);
    }

    /**
     * 判断是不是有此人的在此文档的共享
     * @param docResourceId
     * @param userid
     * @return
     */
    @SuppressWarnings("unchecked")
    public boolean hasAclertShare(Long docResourceId, Long userid, boolean isMine) {
        boolean flag = false;
        DetachedCriteria dc;
        if (isMine) {
            dc = DetachedCriteria.forClass(DocAcl.class).add(Restrictions.eq("docResourceId", docResourceId))
                    .add(Restrictions.eq("userId", userid))
                    .add(Restrictions.eq("sharetype", Constants.SHARETYPE_PERSSHARE));
        } else {
            dc = DetachedCriteria.forClass(DocAcl.class).add(Restrictions.eq("docResourceId", docResourceId))
                    .add(Restrictions.eq("userId", userid))
                    .add(Restrictions.eq("sharetype", Constants.SHARETYPE_DEPTSHARE));
        }

        List<DocAcl> docAclList = docAclDao.executeCriteria(dc, -1, -1);
        if (!docAclList.isEmpty()) {
            flag = true;
        }
        return flag;
    }

    // 删除单位共享
    public void deleteDeptShareByDoc(Long docResourceId) {
        String hsql = "delete from DocAcl as a where a.docResourceId=? and a.sharetype="
                + Constants.SHARETYPE_DEPTSHARE;
        docAclDao.bulkUpdate(hsql, null, docResourceId);
    }

    public void deleteProjectFolderShare(Long projectFolderId, List<Long> oldProjectMemberIds) {
        String hsql = "delete from DocAcl as a where a.docResourceId=:projectFolderId and a.sharetype="
                + Constants.SHARETYPE_DEPTSHARE + " and a.userId in (:userIds) and a.userType=:member";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("projectFolderId", projectFolderId);
        params.put("userIds", oldProjectMemberIds);
        params.put("member", V3xOrgEntity.ORGENT_TYPE_MEMBER);

        docAclDao.bulkUpdate(hsql, params);
    }

    public Map<Long, String> getSpecialAclsByDocResourceId(DocResourcePO dr, Set<Integer> aclLevels) {
        return this.docAclDao.getAclMap4Index(dr);
    }

    @Deprecated
    public Map<Long, String> getSpecialAclsByDocResourceId(Long docResourceId, Set<Integer> aclLevels) {
        DocResourcePO dr = docResourceDao.get(docResourceId);
        return this.getSpecialAclsByDocResourceId(dr, aclLevels);
    }

    /**
     * 取消权限记录里的订阅标记
     */
    public void cancelAlertByAlertIds(String alertIds) {
        Map<String, Object> nameParameters = new HashMap<String, Object>();
        nameParameters.put("alertIds", Constants.parseStrings2Longs(alertIds, ","));
        String hql = "update DocAcl set isAlert = false, docAlertId = null where docAlertId in (:alertIds) and isAlert = true";
        docAclDao.bulkUpdate(hql, nameParameters);
    }

    /**
     * 取得某个文档夹的共享数据
     */
    public List<PotentModel> getGrantVOs(long docResId, boolean isGroupRes) {
        List<PotentModel> objs = new ArrayList<PotentModel>();

        DocResourcePO dr = docResourceDao.get(docResId);
        List<Long> ownerIds = DocMVCUtils.getLibOwners(dr);
        // 继承
        List<DocAcl> l = this.getDocAclListByInherit(docResId);
        int order = 0;
        Set<Long> set = new LinkedHashSet<Long>();
        if (CollectionUtils.isNotEmpty(l)) {
            for (DocAcl a : l) {
                set.add(a.getUserId());
            }

            boolean alert = false;
            Long alertId = -1l;
            for (Long uid : set) {
                PotentModel p = new PotentModel();
                p.setUserId(uid);

                for (DocAcl a : l) {
                    if (a.getUserId() == uid) {
                        order = a.getAclOrder();
                        alert = a.getIsAlert();
                        alertId = a.getDocAlertId();
                        if (p.getUserName() == null) {
                            String userName = Constants.getOrgEntityName(a.getUserType(), a.getUserId(), isGroupRes);

                            p.setUserName(userName);
                            p.setUserType(a.getUserType());
                        }
                        p.copyAcl(a);
                    }
                }
                
                if (ownerIds.contains(uid)){
                    p.setIsLibOwner(true); 
                    alert = true;//库管理员默认订阅
                }

                if (!this.isNoInherit(p.getUserId(), p.getUserType(), docResId)) {
                    p.setInherit(true);

                    p.setAlert(alert);
                    p.setAlertId(alertId);
                    p.setAclOrder(order);

                    objs.add(p);
                }
            }
        }
        // 非继承
        List<List<DocAcl>> l2 = this.getDocAclListByNew(docResId);
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
                isAlert = acl2.getIsAlert();
                order = acl2.getAclOrder();
                if (isAlert)
                    alertId = acl2.getDocAlertId();
                if (p.getUserId() == null) {
                    p.setUserId(acl2.getUserId());
                    if (ownerIds.contains(acl2.getUserId())){
                        p.setIsLibOwner(true);
                        isAlert = true;
                    }
                    p.setUserType(acl2.getUserType());
                    String userName = Constants.getOrgEntityName(acl2.getUserType(), acl2.getUserId(), isGroupRes);
                    p.setUserName(userName);
                    p.setUserType(acl2.getUserType());
                }
                p.copyAcl(acl2);
            }

            p.setAlert(isAlert);
            p.setAlertId(alertId);
            p.setInherit(false);
            p.setAclOrder(order);
            if (!flag) {
                objs.add(p);
            }
        }
        this.filterNoPotent(objs);
        Collections.sort(objs);
        return objs;
    }

    /** 过滤掉没有权限的记录  */
    private void filterNoPotent(List<PotentModel> list) {
        if (CollectionUtils.isNotEmpty(list)) {
            for (Iterator<PotentModel> iterator = list.iterator(); iterator.hasNext();) {
                PotentModel pm = (PotentModel) iterator.next();
                if (!pm.hasPotent())
                    iterator.remove();
            }
        }
    }

    /**
     * 得到某个文档的某种共享类型的权限列表
     */
    @SuppressWarnings("unchecked")
    public List<DocAcl> getAclList(long docResId, byte sharetype) {
        String hql = "from DocAcl where docResourceId = ? and sharetype = ?";
        return this.docAclDao.findVarargs(hql, docResId, sharetype);
    }

    @SuppressWarnings("unchecked")
    public List<DocAcl> getAclListByPotent(long docResId, int potenttype, long userId) {
        String hql = "from DocAcl where docResourceId = ? and potent like ? and userId = ?";
        String potent = Potent.getQueryStringForIntPotent(new Integer[] { potenttype });
        return this.docAclDao.findVarargs(hql, docResId, potent, userId);
    }

    @SuppressWarnings("unchecked")
    public boolean hasAcl(DocResourcePO dr, long parentId) throws BusinessException {
        Map<String, Object> namedParameterMap = new HashMap<String, Object>();
        String ids = Constants.getOrgIdsOfUser(AppContext.currentUserId());
        Set<Long> set = Constants.parseStrings2Longs(ids, ",");

        if (dr.getIsFolder())
            namedParameterMap.put("id", dr.getId());
        else
            namedParameterMap.put("id", parentId);
        namedParameterMap.put("userId", Constants.parseStrings2Longs(ids, ","));
        String hql = "from DocAcl where docResourceId=:id and sharetype = " + Constants.SHARETYPE_DEPTSHARE
                + " and userId in(:userId)";

        List<DocAcl> acls = this.docAclDao.find(hql, -1, -1, namedParameterMap);
        if (acls.size() > 0) {
            boolean flag = true;
            for (DocAcl al : acls) {
                if (al.getMappingPotent().isNoPotent())
                    flag = false;
            }
            return flag;
        } else {
            List<DocAcl> iacls = this.getDocAclListByInherit(dr.getId());
            if (iacls.size() > 0) {
                boolean flag = false;
                for (DocAcl acl : iacls) {
                    if (set.contains(acl.getUserId()) && !acl.getMappingPotent().isNoPotent())
                        flag = true;
                }
                return flag;

            } else
                return false;
        }
    }

    private DocUtils docUtils;

    public DocUtils getDocUtils() {
        return docUtils;
    }

    public void setDocUtils(DocUtils docUtils) {
        this.docUtils = docUtils;
    }

    /**
     * 取得普通文档的借阅权限
     */

    @SuppressWarnings("unchecked")
    public String getBorrowPotent(final long docId) throws BusinessException {
        String ret = "00";
        
        final String hsql = "from DocAcl as a where a.docResourceId = :did and a.userId in (:userIds) and (a.sharetype="
                + Constants.SHARETYPE_DEPTBORROW
                + " or a.sharetype= "
                + Constants.SHARETYPE_PERSBORROW
                + " )and a.sdate<=:starttime and a.edate>=:endtime";
        
        final List<Long> userIds = Constants.getOrgIdsOfUser1(AppContext.currentUserId());
        final Date time = new Date(System.currentTimeMillis());
        
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("userIds", userIds);
        params.put("starttime", time);
        params.put("endtime", time);
        params.put("did", docId);
        List<DocAcl> list = this.find(hsql.toString(), -1, -1, params);

        if (!list.isEmpty()) {

            String lp21_ = "0";
            String lp22_ = "0";
            String lp23_ = "0";
            for (DocAcl da : list) {

                String lp2 = da.getMappingPotent().getLenPotent2();
                if (lp2 != null) {
                    String str1 = lp2.substring(0, 1);
                    String str2 = lp2.substring(1);
                    lp21_ = ("1".equals(lp21_) || "1".equals(str1) ? "1" : "0");
                    lp22_ = ("1".equals(lp22_) || "1".equals(str2) ? "1" : "0");
                }
                lp23_ = "1".equals(lp23_)||"1".equals(da.getMappingPotent().toString().substring(4, 5))?"1":"0";
                if ("1".equals(lp21_))
                    return lp21_ + lp22_ + lp23_;
            }

            ret = lp21_ + lp22_ + lp23_;
        } else {
        	return null;
        }

        return ret;
    }
    
    /**
     * (duanyl) 对于所有类型文档的权限判定，可以通过一种方法判定
     * 取得公文借阅权限
     */
    
    public String getEdocBorrowPotent(final long docId) throws BusinessException{
        return getEdocBorrowPotent(docId,AppContext.currentUserId());
    }
    
    @SuppressWarnings("unchecked")
    public String getEdocBorrowPotent(final Long docId,final Long userId) throws BusinessException {
        String ret = "000";
        final List<Long> userIds = Constants.getOrgIdsOfUser1(userId);
        List<DocAcl> list = (List<DocAcl>) this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException, SQLException {
                String hsql = "from DocAcl as a where a.docResourceId = :did and a.userId in (:userIds) and (a.sharetype="
                        + Constants.SHARETYPE_DEPTBORROW
                        + " or a.sharetype= "
                        + Constants.SHARETYPE_PERSBORROW
                        + ") and a.sdate<=:starttime and a.edate>=:endtime";
                Date time = new Date();
                Map<String,Object> m = new HashMap<String, Object>();
                m.put("userIds", userIds);
                m.put("starttime", time);
                m.put("endtime", time);
                m.put("did", docId);
                return docAclDao.find(hsql, -1, -1, m);
            }
        });

        if (list != null) {
            byte lp_ = Constants.LENPOTENT_CONTENT;
            String lp21_ = "0";
            for (DocAcl da : list) {
                Byte lp = da.getLenPotent();
                if (lp != null && lp.equals(Constants.LENPOTENT_ALL))
                    lp_ = lp;
                String lp2 = da.getMappingPotent().getLenPotent2();
                String str1 = lp2.substring(0, 1);
                lp21_ = ("1".equals(lp21_) || "1".equals(str1) ? "1" : "0");

                if ("11".equals(lp_ + lp21_))
                    return "111";
            }

            ret = lp_ + lp21_ + lp21_;
        }

        return ret;
    }

    /**
     * 取得公文共享权限
     * @throws BusinessException 
     * 
     */
    //TODO(duanyl) 这个方法名要改，所有的非文档类型的文件，查看时都可用此方法进行权限判断
    public String getEdocSharePotent(final long docId) throws BusinessException {
    	long docLibId = docHierarchyManager.getDocResourceById(docId).getDocLibId();
    	if(docLibManager.isOwnerOfLib(AppContext.currentUserId(), docLibId)) {
    		return "111";
    	}
        String ret = "100";
        DocResourcePO doc = this.docResourceDao.get(docId);
        if (doc == null) {
            return ret;
        } else {
            if (doc.getFrType() == Constants.FORMAT_TYPE_LINK) {
                Long dId = doc.getSourceId();
                doc = this.docResourceDao.get(dId);
            }
        }
        String orgIds = Constants.getOrgIdsOfUser(AppContext.currentUserId());
        Set<Integer> sets = this.getDocResourceAclList(doc, orgIds);
        boolean all = sets.contains(Constants.ALLPOTENT);
        boolean edit = sets.contains(Constants.EDITPOTENT);
//        boolean add = sets.contains(Constants.ADDPOTENT);
        boolean readonly = sets.contains(Constants.READONLYPOTENT);

        if (all || edit || readonly)
            ret = "111";

        return ret;
    }

    /**
     * 根据订阅id得到对应的授权对象
     */
    @SuppressWarnings("unchecked")
    public List<DocAcl> getAclListByAlertId(List<Long> alertIds) {
        if (alertIds == null) {
            return null;
        }
        String hql = "from DocAcl where docAlertId in(:alertIds)";
        Map<String, Object> nameParameters = new HashMap<String, Object>();
        nameParameters.put("alertIds", alertIds);
        return this.docAclDao.find(hql, nameParameters);
    }

    @SuppressWarnings("unchecked")
    public DocResourcePO getPersonalFolderOfUser(long userId) {
        String hql = "select dr from DocResourcePO as dr where dr.createUserId = ? and dr.frType = ?";
        List<DocResourcePO> list = docResourceDao.findVarargs(hql, userId, Constants.FORMAT_TYPE_FOLDER_MINE);
        if (list != null && list.size() > 0)
            return list.get(0);
        else
            return null;

    }

    public int getMinOrder() {
        return this.getMaxOrMinOrder(false);
    }

    public int getMaxOrder() {
        return this.getMaxOrMinOrder(true);
    }

    /**
     * 获取当前表中的最大或最小aclOrder	 
     * @param max	是否取最大（还是最小）
     * @return	最大或最小排序号
     */
    private int getMaxOrMinOrder(boolean max) {
        String hql = "select " + (max ? "max" : "min") + " (a.aclOrder) from DocAcl a";
        Integer result = (Integer) this.docAclDao.findUnique(hql, null);
        return result == null ? 0 : result;
    }

    @SuppressWarnings("unchecked")
    public String hasAclToDeleteAll(DocResourcePO doc, Long userId) throws BusinessException {
        StringBuilder names = new StringBuilder();
        String orgIds = Constants.getOrgIdsOfUser(userId);
        final Set<Long> userIdLongs = Constants.parseStrings2Longs(orgIds, ",");

        String hql = " select distinct doc.id from DocResourcePO doc , DocAcl acl where doc.logicalPath like (:path) and acl.userId in(:userIdLongs) and doc.id = acl.docResourceId";
        Map<String, Object> nameParameters = new HashMap<String, Object>();
        nameParameters.put("path", doc.getLogicalPath() + ".%");
        nameParameters.put("userIdLongs", userIdLongs);
        List<Long> list = docAclDao.find(hql, -1, -1, nameParameters);
        boolean flag = false ;
        if (list.size() > 0) {
            for (Long id : list) {
                DocResourcePO doc1 = this.docResourceDao.get(id);
                Set<Integer> sets = this.getDocResourceAclList(doc1, orgIds);
                if (!sets.contains(Constants.ALLPOTENT)){
                    if(flag){
                        names.append(",");
                    }
                    names.append(doc1.getFrName());
                    flag = true ;
                }
            }
        }
        return names.toString();
    }

    /**
     * 分离List，解决in内参数过多，分开处理
     * 
     * @param list
     * @return
     */
    public List<List<Long>> getSubLists(List<Long> list) {
        List<List<Long>> result = new ArrayList<List<Long>>();
        int maxSize = 999;
        if (list != null) {
            int size = list.size();
            if (size <= maxSize) {
                result.add(list);
            } else {
                for (int i = 0;;) {
                    int toIndex = i + maxSize;
                    if (toIndex >= size) {
                        result.add(list.subList(i, size));
                        break;
                    } else {
                        result.add(list.subList(i, toIndex));
                    }
                    i = toIndex;
                }
            }
        }
        return result;
    }

	@Override
	public byte findAclType(String logicalPath, Long userId) {
        String[] arr = logicalPath.split("\\.");
        Set<Long> docPaths = new HashSet<Long>();
		for(String s : arr){
			docPaths.add(Long.valueOf(s));
		}
		List<Long> ordIds;
		try {
			ordIds = orgManager.getAllUserDomainIDs(userId);
		} catch (BusinessException e) {
			log.error("", e);
			ordIds = new ArrayList<Long>();
			ordIds.add(userId);
		}
        List<DocAcl> docAcls = this.docAclDao.findDocAcl(docPaths, ordIds);
        Map<Long,Byte> docAclTypeMap = new HashMap<Long,Byte>();
        for(DocAcl docAcl : docAcls){
        	docAclTypeMap.put(docAcl.getDocResourceId(), docAcl.getSharetype());
        }
        for(int i = arr.length-1 ; i >= 0 ; i--){
        	Byte aclType = docAclTypeMap.get(Long.valueOf(arr[i]));
        	if(aclType!= null){
        		return aclType;
        	}
        }
		return -1;
	}
	
    public Map<Long, Byte> findShareTypeByDocId(Collection<Long> docIds, Long userId) {
        Map<Long, Byte> docId2ShareType = new HashMap<Long, Byte>();
        try {
            if(Strings.isNotEmpty(docIds)){
                List<Long> userIds = orgManager.getAllUserDomainIDs(userId);
                List<Object[]> docAcls = docAclDao.findShareType(docIds, userIds);
                int zero = 0, one = 1;
                for (Object[] objects : docAcls) {
                    docId2ShareType.put((Long) objects[zero], (Byte) objects[one]);
                } 
            }
        } catch (BusinessException e) {
            log.error("", e);
        }
        return docId2ShareType;
    }
    
	public Set<Long> getHasAclDocResourceIds(Collection<Long> userIds){
		return docAclDao.getHasAclDocResourceIds(userIds);
	}
	
	public void setDocDao(DocDao docDao) {
        this.docDao = docDao;
    }
	
    @Override
    public Map getDocMetadataMap(Long docResourceId) {
        return docMetadataDao.getDocMetadataMap(docResourceId);
    }
    
    public void setDocMetadataDao(DocMetadataDao docMetadataDao) {
        this.docMetadataDao = docMetadataDao;
    }
    public void setProjectApi(ProjectApi projectApi) {
        this.projectApi = projectApi;
    }
	
	@Override
	  public List<DocResourcePO> getDocResources(Collection<Long> userIds, byte shareType){
	    List<Long> docIds = this.docAclDao.getDocResourceIdsByUserId(userIds, shareType);
	    return this.docHierarchyManager.getDocsByIds(docIds);
	  }
	
	@SuppressWarnings("unchecked")
	@Override
	public Set<Long> getAllBorrowResourceIds(String userIds, Byte shareType) {
        /**
         * 查找出个人借阅的权限记录 将记录的所有人加入Set中
         */
        Set<Long> docIdSet = new HashSet<Long>();
        StringBuffer hsql = new StringBuffer();
        Map<String, Object> nmap = new HashMap<String, Object>();
        hsql.append(" from DocAcl as a where (a.userId in (:userIds) or a.ownerId in (:userIds)) ");
        nmap.put("userIds", Constants.parseStrings2Longs(userIds, ","));
        if(Strings.equals(Constants.SHARETYPE_PERSSHARE, shareType)){
        	hsql.append(" and a.sharetype=2 ");
        }else{
        	hsql.append(" and a.sharetype in (1,3) and a.sdate<=:start and a.edate>=:end");
        	Date time = new Date(System.currentTimeMillis());
        	nmap.put("start", time);
        	nmap.put("end", time);
        }
       
        List<DocAcl> list = this.filterInvalid(docAclDao.find(hsql.toString(), -1, -1, nmap));
        if (CollectionUtils.isNotEmpty(list)) {
        	/**
        	 * 人员有效性校验
        	 */
        	List<DocAcl> de_list = new ArrayList<DocAcl>();
            for (DocAcl acl : list) {
                if (acl.getOwnerId()!=0 && !Constants.isValidOrgEntity(V3xOrgEntity.ORGENT_TYPE_MEMBER, acl.getOwnerId())) {
                	de_list.add(acl);
                }
            }
            if(CollectionUtils.isNotEmpty(de_list)){
            	list.removeAll(de_list);
            }
            for (DocAcl docAcl : list) {
            	docIdSet.add(docAcl.getDocResourceId());
            }
        }
		return docIdSet;
	}

                
}