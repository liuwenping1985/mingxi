package com.seeyon.apps.doc.manager;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.doc.dao.DocResourceDao;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.OrgConstants.UnitType;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.CommonTools;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public class DocResourceNewManagerImpl implements DocResourceNewManager {
	private static final Log         log = LogFactory.getLog(DocResourceNewManagerImpl.class);
	
	//private DocResourceNewDao docResourceNewDao;
	
	private OrgManager orgManager;
	private AffairManager affairManager;
	
	private DocResourceDao docResourceDao;
	
	 private Long getMogamiDepartment(Long deptId) throws Exception{
	    	UnitType type = OrgConstants.UnitType.Department;
	    	this.orgManager = (OrgManager)AppContext.getBean("orgManager");
	    	V3xOrgDepartment parentDepartment = null ;
	    	while(type != OrgConstants.UnitType.Account ){
	    		
	    		parentDepartment = orgManager.getParentDepartment(deptId);
	    		if(parentDepartment == null){
	    			return deptId;
	    		}
	    		else if(parentDepartment.getType() == OrgConstants.UnitType.Department){
	    			deptId = parentDepartment.getId();
	    			type = parentDepartment.getType();
	    		}
	    	}
	    	return deptId;
	    }
	  
	    public Long setTransFer(String type){
	    	
	    			this.orgManager = (OrgManager)AppContext.getBean("orgManager");
					DocHierarchyManager docHierarchyMaanger = (DocHierarchyManager)AppContext.getBean("docHierarchyManager");
					 V3xOrgDepartment department = null;
					try {
						department = orgManager.getDepartmentById(getMogamiDepartment(AppContext.getCurrentUser().getDepartmentId()));
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						log.error("获取单位失败："+e);
					}
					 String name = department.getName();
					 List<DocResourcePO> findByFrName2 = docHierarchyMaanger.findByFrName(name);
					 
					 Long archiveId = 0L;
					 List<DocResourcePO> findByFrName = docHierarchyMaanger.findByFrName(type);
					for (DocResourcePO docResourcePO : findByFrName) {
						String logicalPath = docResourcePO.getLogicalPath();
						String[] LogicalPath = logicalPath.split("\\.");
						if (LogicalPath.length < 2) continue;
						
						for (DocResourcePO docResourcePO2 : findByFrName2) {
							Long docResourceId = Long.valueOf(LogicalPath[1]);
							if(docResourcePO2.getId().equals(docResourceId)){
								archiveId = docResourcePO.getId();
								break;
							}
						}
						if (archiveId != 0L)break;
					}
				return 	archiveId;
						
	    }
	    
	/**
	 * 收文预归档根据承办部门归档
	 * @param sourceId 为收文summaryID
	 */
	    @AjaxAccess
	public void updateDocResource(Long sourceId){
		String type  = "收文";
		List<DocResourcePO> docsBySourceId = docResourceDao.getDocsBySourceId(CommonTools.parseStr2Ids(sourceId.toString()));
		DocResourcePO docResourcePO = docsBySourceId.get(0);
		log.info("原archiveId："+docResourcePO.getParentFrId());
		
		Long archiveId = this.setTransFer(type);
		
		List<DocResourcePO> docsByIds = docResourceDao.getDocsByIds(archiveId.toString());
		DocResourcePO docResourcePO2 = docsByIds.get(0);
		log.info("LogicalPath："+docResourcePO2.getLogicalPath()+"."+docResourcePO.getId());
		//kekai zhaohui 重新赋值排序序号 start
		Number FrOrder = docResourceDao.getMinFrOderByParentFrId(archiveId);
		log.info("FrOrder：" + FrOrder);
		if(FrOrder==null){
			FrOrder = 0;
		}
		docResourcePO.setFrOrder(FrOrder.intValue()-1);
		//kekai zhaohui 重新赋值排序序号 end
		docResourcePO.setParentFrId(archiveId);
		docResourcePO.setLogicalPath(docResourcePO2.getLogicalPath()+"."+docResourcePO.getId());
		
		docResourceDao.update(docResourcePO);
		
		
		
	}
	    
	// 客开 gyz 2018-07-04 start
	/**
	 * 签报预归档根据发起人部门归档
	 * 
	 * @param sourceId
	 *            为收文summaryID
	 * @throws BusinessException
	 */
	@AjaxAccess
	public void updateReportResource(Long sourceId, Long senderId) throws BusinessException {
		String type = "签报";
		CtpAffair ctpAffair = affairManager.getSenderAffair(sourceId);
		List<DocResourcePO> docsBySourceId = docResourceDao
				.getDocsBySourceId(CommonTools.parseStr2Ids(ctpAffair.getId().toString()));
		DocResourcePO docResourcePO = docsBySourceId.get(0);
		log.info("原archiveId：" + docResourcePO.getParentFrId());
		V3xOrgMember member = orgManager.getMemberById(senderId);
		Long archiveId = this.setTransFer1(type, member.getOrgDepartmentId());

		List<DocResourcePO> docsByIds = docResourceDao.getDocsByIds(archiveId.toString());
		DocResourcePO docResourcePO2 = docsByIds.get(0);
		log.info("LogicalPath：" + docResourcePO2.getLogicalPath() + "." + docResourcePO.getId());
		//kekai zhaohui 重新赋值排序序号 start
		log.info("FrOrder：" + docResourcePO2.getFrOrder());
		Number FrOrder = docResourceDao.getMinFrOderByParentFrId(archiveId);
		log.info("FrOrder：" + FrOrder);
		if(FrOrder==null){
			FrOrder = 0;
		}
		docResourcePO.setFrOrder(FrOrder.intValue()-1);
		//kekai zhaohui 重新赋值排序序号 end
		docResourcePO.setParentFrId(archiveId);
		docResourcePO.setLogicalPath(docResourcePO2.getLogicalPath() + "." + docResourcePO.getId());

		docResourceDao.update(docResourcePO);
	}

	public Long setTransFer1(String type, Long departmentId) {

		this.orgManager = (OrgManager) AppContext.getBean("orgManager");
		DocHierarchyManager docHierarchyMaanger = (DocHierarchyManager) AppContext.getBean("docHierarchyManager");
		V3xOrgDepartment department = null;
		try {
			department = orgManager.getDepartmentById(getMogamiDepartment(departmentId));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			log.error("获取单位失败：" + e);
		}
		String name = department.getName();
		List<DocResourcePO> findByFrName2 = docHierarchyMaanger.findByFrName(name);

		Long archiveId = 0L;
		List<DocResourcePO> findByFrName = docHierarchyMaanger.findByFrName(type);
		for (DocResourcePO docResourcePO : findByFrName) {
			String logicalPath = docResourcePO.getLogicalPath();
			String[] LogicalPath = logicalPath.split("\\.");
			if (LogicalPath.length < 2)
				continue;

			for (DocResourcePO docResourcePO2 : findByFrName2) {
				Long docResourceId = Long.valueOf(LogicalPath[1]);
				if (docResourcePO2.getId().equals(docResourceId)) {
					archiveId = docResourcePO.getId();
					break;
				}
			}
			if (archiveId != 0L)
				break;
		}
		return archiveId;
	}
	// 客开 gyz 2018-07-04 end

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	public void setDocResourceDao(DocResourceDao docResourceDao) {
		this.docResourceDao = docResourceDao;
	}

	// 客开 gyz 2018-07-04 start
	public void setAffairManager(AffairManager affairManager) {
		this.affairManager = affairManager;
	}
	// 客开 gyz 2018-07-04 end

}
