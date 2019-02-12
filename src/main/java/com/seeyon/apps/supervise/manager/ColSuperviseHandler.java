package com.seeyon.apps.supervise.manager;

import java.util.ArrayList;
import java.util.Date;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.supervise.CtpSuperviseDetail;
import com.seeyon.ctp.common.po.supervise.CtpSupervisor;
import com.seeyon.ctp.common.supervise.bo.SuperviseQueryCondition;
import com.seeyon.ctp.common.supervise.bo.SuperviseWebModel;
import com.seeyon.ctp.common.supervise.enums.SuperviseEnum;
import com.seeyon.ctp.common.supervise.handler.SuperviseAppInfoBO;
import com.seeyon.ctp.common.supervise.handler.SuperviseHandler;
import com.seeyon.ctp.common.supervise.vo.SuperviseMessageParam;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.po.OrgMember;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.IdentifierUtil;
import com.seeyon.ctp.util.SQLWildcardUtil;
import com.seeyon.ctp.util.Strings;
public class ColSuperviseHandler implements SuperviseHandler{
    private ColManager colManager;
    public ColManager getColManager() {
        return colManager;
    }
    public void setColManager(ColManager colManager) {
        this.colManager = colManager;
    }

    @Override
    public ModuleType getModuleType() {
        return ModuleType.collaboration;
    }

    @Override
    public List<SuperviseWebModel> getSuperviseDataList(FlipInfo fi,EnumMap<SuperviseQueryCondition, List<String>> queryCondition) throws BusinessException {
        /**表单分类开始**/
      List<String> listCategory = queryCondition.get("templeteCategorys");
      if(!Strings.isEmpty(listCategory)){
        String hqlCategory =" select t.id from CtpTemplate t,CtpTemplateCategory ca where t.categoryId = ca.id and t.bodyType=20 and ca.id in (:categoryIds) ";
        Map<String, Object> categoryMap  = new HashMap<String, Object>();
        categoryMap.put("categoryIds", listCategory);
        List _categoryList = DBAgent.find(hqlCategory.toString(), categoryMap);
        List listId =new ArrayList<String>();
        for(int i = 0; i < _categoryList.size(); i++) {
          Long objectCate = (Long) _categoryList.get(i);
          listId.add(objectCate+"");
        }
        if(!Strings.isEmpty(listId)){
          queryCondition.put(SuperviseQueryCondition.templeteIds,listId);
        }
      }
      
      
      
      Set<SuperviseQueryCondition>  keySet = queryCondition.keySet();
		boolean isMemberNameQuery = false;
		if(Strings.isNotEmpty(keySet)){
			for(SuperviseQueryCondition sqc : keySet){
				if(sqc == SuperviseQueryCondition.colSuperviseSender){
					isMemberNameQuery = true;
					break;
				}
			}
		}
      
        StringBuilder hql = new StringBuilder("select summ.formAppid,") // szp
        .append("summ.subject,")
        .append("summ.startMemberId,")
        .append("summ.startDate,")
        .append("summ.importantLevel,")
        .append("summ.deadline,")
        .append("summ.deadlineDatetime,")
        .append("summ.finishDate,")
        .append("summ.newflowType,")
        .append("summ.currentNodesInfo,")
        .append("de.id,")
        .append("de.awakeDate,")
        .append("de.count,")
        .append("de.entityId,")
        .append("de.description,")
        .append("de.status,")
        .append("de.entityType,")
        .append("summ.resentTime,")
        .append("summ.forwardMember,")
        .append("summ.bodyType,")
        .append("summ.identifier,")
        //.append("mem.name,")
        .append("summ.processId,")
        .append("summ.caseId,")
        .append("summ.templeteId,")
        .append("summ.orgAccountId, ")
        .append("summ.coverTime ")
        .append(" from " )
        .append(CtpSuperviseDetail.class.getName() )
        .append( " as de," )
        .append(CtpSupervisor.class.getName() )
        .append( " as su, " )
        .append( ColSummary.class.getName() )
        .append( " as summ ");
        if(isMemberNameQuery){
        	hql.append(",").append(OrgMember.class.getName()).append(" as mem ");
        }
        
        hql.append(" where su.superviseId=de.id and de.entityId=summ.id ");
        
        if(isMemberNameQuery){
        	hql.append(" and summ.startMemberId = mem.id ");
        }
        
        hql.append(" and su.supervisorId=:userId and de.entityType=:entityType and de.status <> :notstatus ");
        long userId = AppContext.currentUserId();
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("entityType", SuperviseEnum.EntityType.summary.ordinal());
        params.put("notstatus", SuperviseEnum.superviseState.waitSupervise.ordinal());
        params.put("userId", userId);
        
        
        int a =0 ;
        Iterator<SuperviseQueryCondition> it = keySet.iterator();
        while(it.hasNext()){
            SuperviseQueryCondition condition = it.next();
            List<String> value = queryCondition.get(condition);
            if(condition == SuperviseQueryCondition.colSuperviseTitle){
                hql.append(" and summ.subject like :title");
                params.put("title", "%"+value.get(0)+"%");
            }else if(condition == SuperviseQueryCondition.colSuperviseSender){
                hql.append(" and mem.name like :startMemberName");
                params.put("startMemberName", "%" + SQLWildcardUtil.escape(value.get(0)) + "%");
            }else if(condition == SuperviseQueryCondition.colImportantLevel){
                hql.append(" and summ.importantLevel = :importantLevel");
                params.put("importantLevel", Integer.parseInt(value.get(0)));
            }else if(condition == SuperviseQueryCondition.colSuperviseSendTime){
                String startDate = value.get(0);
                if(Strings.isNotBlank(startDate)){
                    hql.append(" and summ.startDate >= :startDate");
                    java.util.Date stamp = Datetimes.getTodayFirstTime(startDate);
                    params.put("startDate",stamp);
                }
                if(value.size()==2){
                    String endDate = value.get(1);
                    if(Strings.isNotBlank(endDate)){
                        hql.append(" and summ.startDate <= :endDate");
                        java.util.Date stamp = Datetimes.getTodayLastTime(endDate);
                        params.put("endDate",stamp);
                    }
                }
            }else if(condition == SuperviseQueryCondition.status && value.get(0) != null){
                Integer status = Integer.parseInt(value.get(0));
                hql.append(" and de.status= :status");
                params.put("status",status);
            }else if(condition == SuperviseQueryCondition.templeteIds && Strings.isNotEmpty(value)){
                    hql.append(" and summ.templeteId in(:templeteIds) ");
                    List<Long> l = new ArrayList<Long>();
                    
                    for(String s : value){
                        String[] value2 = s.split(",");
                        for (String s2 : value2) {
                            l.add(Long.valueOf(s2));
                        }
                    }
                    params.put("templeteIds",l);
            }else if(condition == SuperviseQueryCondition.templeteAll && "templeteAll".equals(value.get(0))){
              hql.append(" and summ.bodyType=20 ");
            }else if(condition == SuperviseQueryCondition.deadlineDatetime){
                String startDate = value.get(0); 
                if(Strings.isNotBlank(startDate)){
                    hql.append(" and summ.deadlineDatetime >= :startDate");
                    java.util.Date stamp = Datetimes.getTodayFirstTime(startDate);
                    params.put("startDate",stamp);
                }
                if(value.size()==2){
                    String endDate = value.get(1);
                    if(Strings.isNotBlank(endDate)){
                        hql.append(" and summ.deadlineDatetime <= :endDate");
                        java.util.Date stamp = Datetimes.getTodayLastTime(endDate);
                        params.put("endDate",stamp);
                    }
                }
            
            
        }else if(condition == SuperviseQueryCondition.moduleId && value.get(0) != null){//chenxd
        	List<String> moduleId = queryCondition.get(SuperviseQueryCondition.moduleId);
        	String _moduleId = moduleId.get(0);
        	hql.append(" and summ.id =:_moduleId ");
        	params.put("_moduleId",Long.parseLong(_moduleId));
        }
        }
        hql.append(" order by summ.startDate desc");
        List result = null; 
        if(fi != null){
            result = DBAgent.find(hql.toString(), params, fi);
        }else{
            result = DBAgent.find(hql.toString(), params);
        }
        List<SuperviseWebModel> modelList = new ArrayList<SuperviseWebModel>();
        if(result != null && !result.isEmpty()){
            for(int i = 0;i < result.size();i++){
                Object[] res = (Object[]) result.get(i);
                SuperviseWebModel model = new SuperviseWebModel();
                int j = 0;
                //表单ID
                Long formAppId = (Long)res[j++]; // SZP
                model.setFormAppId(formAppId); // SZP
                //标题
                model.setTitle((String)res[j++]);
                //发送人id
                Long sdId = (Long)res[j++];
                model.setSender(sdId);
                //发起日期
                Date startDate = (Date)res[j++];
                model.setSendDate(startDate);
                //重要程度
                model.setImportantLevel((Integer)res[j++]);
                //流程期限
                model.setDeadline((Long)res[j++]);
                Date deadlineDatetime = (Date)res[j++];
                if(deadlineDatetime!=null){//新数据显示时间点
                	model.setDeadlineDatetime(deadlineDatetime);
                	model.setDeadlineName(ColUtil.getDeadLineName(deadlineDatetime));
                }else if(model.getDeadline()!=null){//兼容老数据，按时间段显示
                	model.setDeadlineName(ColUtil.getDeadLineName(model.getDeadline()));
                }else{
                  model.setDeadlineName(ResourceUtil.getString("collaboration.project.nothing.label"));
                }
                //结束日期
                Date finishDate = (Date)res[j++];
                //流程是否超期
                ColSummary summary = new ColSummary();
                summary.setSubject(model.getTitle());
                summary.setDeadlineDatetime(deadlineDatetime);
                summary.setFinishDate(finishDate);
                summary.setStartDate(startDate);
                //应用类型为协同
                model.setAppType(ApplicationCategoryEnum.collaboration.ordinal());
                //流程类型
                model.setNewflowType((Integer)res[j++]);
                //当前处理人信息
                String cninfo=(String)res[j++];
                summary.setCurrentNodesInfo(cninfo);
                model.setCurrentNodesInfo(ColUtil.parseCurrentNodesInfo(summary));
                Date now = new Date(System.currentTimeMillis());
                //督办事项ID
                model.setId((Long)res[j++]);
                //督办日期
                Date awakeDate = (Date)res[j++];
                if(awakeDate != null && now.after(awakeDate)){
                    model.setIsRed(true);
                }
                model.setAwakeDate(awakeDate);
                //催办次数
                Object _count = res[j++];
                if(_count == null ){
                	_count = 0;
                }
                model.setCount(Integer.parseInt(String.valueOf(_count)));
                //协同id(督办应用ID)
                model.setSummaryId((Long)res[j++]);
                //督办描述
                model.setContent(Strings.toHTML((String)res[j++]));
                //督办事项状态
                model.setStatus((Integer)res[j++]);
                //督办 应用类型
                model.setEntityType((Integer)res[j++]);
                //重复发起次数
                model.setResendTime((Integer)res[j++]);
                summary.setResentTime(model.getResendTime());
                //转发人
                model.setForwardMember((String)res[j++]);
                summary.setForwardMember(model.getForwardMember());
                //正文类型
                model.setBodyType((String)res[j++]);
                //标识字符串(判断是否有附件)
                Object identifier = res[j++];
                if(identifier != null){
                    Boolean hasAtt = IdentifierUtil.lookupInner(identifier.toString(),0, '1');
                    model.setHasAttachment(hasAtt);
                }else{
                    model.setHasAttachment(false);
                }
                //发送人名称
             //   j++;
                model.setSenderName(Functions.showMemberName(sdId));
         
                //流程ID
                model.setProcessId((String)res[j++]);
                //caseId
                model.setCaseId((Long)res[j++]);
                //模版Id
                Object tempId = res[j++];
                if(tempId != null){
                    model.setIsTemplate(true);
                }else{
                    model.setIsTemplate(false);
                }
                //单位id
                model.setFlowPermAccountId((Long)res[j++]);
                Map<String, String> defaultNodeMap = colManager.getColDefaultNode(model.getFlowPermAccountId());
                model.setDefaultNodeName(defaultNodeMap.get("defaultNodeName"));
                model.setDefaultNodeLable(defaultNodeMap.get("defaultNodeLable"));
                
                //流程超期
                Object coverTime = res[j++];
                boolean isCoverTime = false;
                if(coverTime != null){
                	isCoverTime = (Boolean)coverTime;
                }
                model.setWorkflowTimeout(isCoverTime);
                model.setDetailPageUrl(getDetailPageUrl());
                //重新加工标题
                String subject = ColUtil.showSubjectOfSummary(summary, false, -1, null);
                model.setTitle(subject);
                model.setAppName("collaboration"); 
                modelList.add(model);
            }
        }
        if(fi != null){
            fi.setData(modelList);
        }
        return modelList;
    }

    @Override
    public String getDetailPageUrl() {
        return "collaboration/collaboration.do?method=summary";
    }
    @Override
    public SuperviseMessageParam getSuperviseMessageParam4SaveImmediate(Long moduleId) throws BusinessException{
    	ColSummary summary = colManager.getColSummaryById(moduleId);
    	SuperviseMessageParam smp = new SuperviseMessageParam(true,summary.getImportantLevel(),summary.getSubject(),summary.getForwardMember(),summary.getStartMemberId());
    	return smp;
    }
	@Override
	public long getFlowPermAccountId(long summaryId) throws BusinessException {
		ColSummary s = colManager.getColSummaryById(summaryId);
		if(s!=null){
			return ColUtil.getFlowPermAccountId(s.getOrgAccountId(), s);
		}
		return 0;
	}
	@Override
    public Map<Long,SuperviseAppInfoBO> getAppInfo(List<Long> summaryIds) throws BusinessException {
		
		Map<Long,SuperviseAppInfoBO> superviseAppInfoBOs = new HashMap<Long,SuperviseAppInfoBO>();
		
		List<ColSummary> colSummarys = colManager.findColSummarysByIds(summaryIds);
    	for(ColSummary summary : colSummarys){
    		SuperviseAppInfoBO superviseAppInfoBO = new SuperviseAppInfoBO();
    		superviseAppInfoBO.setCurrentNodesInfo(ColUtil.parseCurrentNodesInfo(summary));
    		superviseAppInfoBO.setCaseId(summary.getCaseId());
    		superviseAppInfoBO.setProcessId(summary.getProcessId());
    		superviseAppInfoBO.setTemplateId(summary.getTempleteId());
    		superviseAppInfoBO.setDeadlineDatetime(summary.getDeadlineDatetime());
    		// 当流程期限不为空，且当前时间大于设置的流程期限时，设为超期
    		Boolean isCoverTime = summary.isCoverTime();
            boolean isDeadlineDatetime = summary.getDeadlineDatetime()!=null && new Date().after(summary.getDeadlineDatetime());
            if((isCoverTime != null && isCoverTime) || isDeadlineDatetime){
            	superviseAppInfoBO.setWorkflowTimeout(true);
            }
            
            superviseAppInfoBOs.put(summary.getId(),superviseAppInfoBO);
    	}
    	return superviseAppInfoBOs;
		
	}

}
