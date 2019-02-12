package com.seeyon.ctp.organization.manager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.CustomizeConstants;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.task.AsynchronousBatchTask;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgLevel;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.bo.V3xOrgPost;
import com.seeyon.ctp.organization.bo.V3xOrgTeam;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.webmodel.WebEntity4QuickIndex;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UniqueList;
import com.seeyon.ctp.util.json.JSONUtil;

public class OrgIndexManagerImpl extends AsynchronousBatchTask<Object> implements OrgIndexManager {

    private final static Log logger              = LogFactory.getLog(OrgIndexManagerImpl.class);
    protected OrgManager     orgManager;
    protected OrgCache       orgCache;
    protected CustomizeManager       customizeManager;

    /**
     * 快速录入，最近联系人
     */
    private final static int orgRecentSavedLength = 30;
    private final static int orgFastSearchLength = 10;

    public final static String ORG_RECENT_TYPE_INDEX = "ORG_RECENT_TYPE_INDEX";
    public final static String ORG_RECENT_TYPE_SELECT_PEOPLE = "ORG_RECENT_TYPE_SELECT_PEOPLE_STRING";
    //单位缓存
    private Map<Long,V3xOrgAccount> accountMap;
    //部门缓存
    private Map<Long,V3xOrgDepartment> deptMap;
    
    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }
    
    public void setOrgCache(OrgCache orgCache) {
		this.orgCache = orgCache;
	}
    
	public void setCustomizeManager(CustomizeManager customizeManager) {
        this.customizeManager = customizeManager;
    }

    @Override
    public String getOrgIndexDatas() throws BusinessException {
        User user = AppContext.getCurrentUser();
        Long currentLoginAccId = user.getLoginAccount();
        List<WebEntity4QuickIndex> indexData = new ArrayList<WebEntity4QuickIndex>();
        //OA-64293
        List<V3xOrgMember> allMembers = new UniqueList<V3xOrgMember>();
        List<V3xOrgMember> wholeMembers = orgCache.getAllV3xOrgEntity(V3xOrgMember.class, null);
        List<V3xOrgAccount> canAccs = orgManager.accessableAccounts(user.getId());
        Set<Long> accIds = new HashSet<Long>();
        for(V3xOrgAccount acc:canAccs){
            accIds.add(acc.getId());
        }
        for (V3xOrgMember member : wholeMembers) {
            if(accIds.contains(member.getOrgAccountId())){
                allMembers.add(member);
            }
        }

        //重名增加部门信息
        dealDupNameMembers(allMembers);
        for (V3xOrgMember m : allMembers) {
            if (!m.isValid() || m.getIsAdmin()) continue; // 如果人员无效直接过滤掉
            WebEntity4QuickIndex data = null;
            if(currentLoginAccId.equals(m.getOrgAccountId())) {
                data = new WebEntity4QuickIndex("Member|"+m.getId()+"|"+m.getOrgAccountId(), m.getName(), null);
            } else {
                //OA-55168 跨单位人员，显示单位简称
                V3xOrgAccount account = getAccount(m.getOrgAccountId());
                if(null == account) {
                    continue;
                }
                if(m.getName().contains("(") && m.getName().contains("-")) {
                    data = new WebEntity4QuickIndex("Member|"+m.getId()+"|"+m.getOrgAccountId(), m.getName(), null);
                } else {
                    data = new WebEntity4QuickIndex("Member|"+m.getId()+"|"+m.getOrgAccountId(), m.getName() + "("+ account.getShortName() +")", null);
                }
            }
            indexData.add(data);
        }
        return JSONUtil.toJSONString(indexData);
    }

    @Override
    public List<V3xOrgEntity> getRecentData(Long memberId, String customType) throws BusinessException {
       return getRecentData(memberId, customType, false);
    }

    @Override
    public List<V3xOrgEntity> getRecentData(Long memberId, String customType,boolean isCheckLevelScope) throws BusinessException {
        List<V3xOrgEntity> allMembers = new UniqueList<V3xOrgEntity>(orgRecentSavedLength);
        String recentDatas = OrgHelper.getCustomizeManager().getCustomizeValue(memberId, CustomizeConstants.ORG_RECENT);
        if(Strings.isNotBlank(recentDatas)) {
            String[] oldData = recentDatas.split(",");
            for(String s : oldData) {
                if(Strings.isBlank(s) || s.split("[|]").length<2){
                    continue;
                }
                String memberIdStr = s.split("[|]")[1];
                try {
                	Long.valueOf(memberIdStr);
				} catch (Exception e) {
					continue;
				}
                V3xOrgMember m = orgManager.getMemberById(Long.valueOf(memberIdStr));
                if(null != m && m.isValid()) {//OA-64293
                	if (m.isVJoinExternal()) {//过滤V-Join人员
                		continue;
                	}
                    if(isCheckLevelScope){
                        if(OrgHelper.checkLevelScope(memberId, m.getId())){
                            allMembers.add(m);
                        }
                    }else{
                        allMembers.add(m);
                    }
                }
            }
        }
        return allMembers;
    }

    /**
     * 返回某人可以访问的所有单位ID的集合
     * @param memberId
     * @return
     * @throws BusinessException
     */
    private Set<Long> getAccessAccountsIds(Long memberId) throws BusinessException {
        Set<Long> result = new HashSet<Long>();
        List<V3xOrgAccount> accs = orgManager.accessableAccounts(memberId);
        for (V3xOrgAccount a : accs) {
            if(a.isGroup()) continue;
            result.add(a.getId());
        }
        return result;
    }

    @Override
    public String getRecentDataStr(Long memberId, String customType) throws BusinessException {
        User user = AppContext.getCurrentUser();
        Long currentLoginAccId = user.getLoginAccount();
        List<V3xOrgMember> allMembers = new UniqueList<V3xOrgMember>(10);
        String recentDatas = OrgHelper.getCustomizeManager().getCustomizeValue(memberId, CustomizeConstants.ORG_RECENT);
        List<WebEntity4QuickIndex> indexData = new ArrayList<WebEntity4QuickIndex>();
        if(Strings.isNotBlank(recentDatas)) {
            String[] oldData = recentDatas.split(",");
            for(String s : oldData) {
                V3xOrgMember m = orgManager.getMemberById(Long.valueOf(s.split("[|]")[1]));
                if(null != m && m.isValid()) {//OA-64293 
                    if (m.isVJoinExternal()) {//过滤V-Join人员
                        continue;
                    }
                	//默认不进行职务级别控制
            		allMembers.add(m);
                }
            }
        }
        dealDupNameMembers(allMembers);//OA-55808
        for(V3xOrgMember m : allMembers) {
            WebEntity4QuickIndex data = null;
            if(currentLoginAccId.equals(m.getOrgAccountId())) {
                data = new WebEntity4QuickIndex("Member|"+m.getId()+"|"+m.getOrgAccountId(), m.getName(), null);
            } else {
                //OA-55168 跨单位人员，显示单位简称
                V3xOrgAccount account = getAccount(m.getOrgAccountId());
                if(null == account || !account.isValid()) {
                    continue;
                }
                if(m.getName().contains("(") && m.getName().contains("-")) {
                    data = new WebEntity4QuickIndex("Member|"+m.getId()+"|"+m.getOrgAccountId()+"|"+m.getName(), m.getName(), null);
                } else {
                    //data = new WebEntity4QuickIndex("Member|"+m.getId()+"|"+m.getOrgAccountId()+"|"+m.getName() + "("+ account.getShortName() +")", m.getName() + "("+ account.getShortName() +")", null);
                    
                	data = new WebEntity4QuickIndex("Member|"+m.getId()+"|"+m.getOrgAccountId()+"|"+m.getName(), m.getName(), null);
                }
            }
            indexData.add(data);
        }
        return JSONUtil.toJSONString(indexData);
    }
    
    
    @Override
    public String getSearchDataStr(String key) throws BusinessException {
    	List<WebEntity4QuickIndex> searchData = new UniqueList<WebEntity4QuickIndex>(orgFastSearchLength);
        User user = AppContext.getCurrentUser();
        Long currentLoginAccId = user.getLoginAccount();
    	key = key.toLowerCase();
        List<V3xOrgMember> wholeMembers = orgCache.getAllV3xOrgEntityNoClone(V3xOrgMember.class, null);
        for(V3xOrgMember m : wholeMembers) {
        	String name = m.getName().toLowerCase();
        	if(name.indexOf(key)>=0 && m.isValid()){
        		if(OrgHelper.checkLevelScope(user.getId(), m.getId())){
                    WebEntity4QuickIndex data = null;
                    if(currentLoginAccId.equals(m.getOrgAccountId())) {
                        data = new WebEntity4QuickIndex("Member|"+m.getId()+"|"+m.getOrgAccountId()+"|"+m.getName(), m.getName(), null);
                    } else {
                        //OA-55168 跨单位人员，显示单位简称
                        V3xOrgAccount account = getAccount(m.getOrgAccountId());
                        if(null == account || !account.isValid()) {
                            continue;
                        }
                        data = new WebEntity4QuickIndex("Member|"+m.getId()+"|"+m.getOrgAccountId()+"|"+m.getName() + "("+ account.getShortName() +")", m.getName() + "("+ account.getShortName() +")", null);
                    }
                    searchData.add(data);
                    if(searchData.size()>=orgFastSearchLength) break;
        		}
        	}
        }
        return JSONUtil.toJSONString(searchData);
    }

    @Override
    public String checkFromCopy(String beforeCheckStr) throws BusinessException {
        if(Strings.isNotBlank(beforeCheckStr)) {
            List<WebEntity4QuickIndex> indexData = new ArrayList<WebEntity4QuickIndex>();
            //按照名称匹配到的人集合
            List<V3xOrgMember> correctMemberList = new UniqueList<V3xOrgMember>();
            //没有匹配到的名称集合
            List<String> notMatchMemberList = new ArrayList<String>();
            //匹配到多个人的名称集合
            List<String> dupNameMemberList = new ArrayList<String>();
            
            Set<Long> accIdSet = new HashSet<Long>();
            Set<Long> memberIds = new HashSet<Long>();
            Long memberId = AppContext.getCurrentUser().getId();
            V3xOrgMember thisMember = orgManager.getMemberById(memberId);
            if(!thisMember.getIsInternal()){
            	List<V3xOrgEntity>  entities = orgManager.getExternalMemberWorkScope(memberId, false);
            	for(V3xOrgEntity m: entities){
            		memberIds.add(m.getId());
            	}
            }else{
            	accIdSet = getAccessAccountsIds(memberId);
            }

            String[] strs = beforeCheckStr.split("、");
            for(String s : strs) {
                if(Strings.isNotBlank(s.trim())) {
                    List<V3xOrgMember> list = orgManager.getMemberByName(s.trim());
                    if(list.size() == 0) {//没有查询到
                        notMatchMemberList.add(s.trim());
                    } else if(list.size() > 1) {//重名人员
                        dupNameMemberList.add(s.trim());
                    } else {
                        V3xOrgMember member = list.get(0);
                        if(OrgHelper.checkLevelScope(memberId, member.getId()) && (accIdSet.contains(member.getOrgAccountId()) || 
                    			(memberIds.contains(member.getId())||memberIds.contains(member.getOrgDepartmentId())||memberIds.contains(member.getOrgAccountId())))) {
                            correctMemberList.add(member);
                        } else {
                            notMatchMemberList.add(s.trim());
                        }
                    }
                }
            }

            //唯一匹配的人员toJSON
            for (V3xOrgMember m : correctMemberList) {
                V3xOrgDepartment d = getDept(((V3xOrgMember)m).getOrgDepartmentId());
                WebEntity4QuickIndex data = new WebEntity4QuickIndex("Member|"+m.getId()+"|"+m.getOrgAccountId(), m.getName(), null==d?"":d.getName());
                indexData.add(data);
            }
            //重名人员toJSON
            for (String s : dupNameMemberList) {
                WebEntity4QuickIndex data = new WebEntity4QuickIndex("", s, "", "2");
                indexData.add(data);
            }
            //没有匹配到的人员toJSON
            for (String s : notMatchMemberList) {
                WebEntity4QuickIndex data = new WebEntity4QuickIndex("", s, "", "1");
                indexData.add(data);
            }
            logger.debug(JSONUtil.toJSONString(indexData));
            return JSONUtil.toJSONString(indexData);
        }

        return null;
    }


    /**
     * 处理重名人员追加部门名称方法
     * @param members
     * @return
     * @throws BusinessException
     */
    private List<V3xOrgMember> dealDupNameMembers(List<V3xOrgMember> members) throws BusinessException {
        Map<String, V3xOrgMember> nameMap = new HashMap<String, V3xOrgMember>();
        Long currentAccountId = AppContext.currentAccountId();
        for (V3xOrgMember m : members) {
            if(nameMap.containsKey(m.getName())) {
                // 将已经在map中的取出来setName
                V3xOrgMember dupNameMember = nameMap.get(m.getName());
                V3xOrgDepartment dept1 = getDept(dupNameMember.getOrgDepartmentId());
                if(null != dept1 && dept1.isValid()) {
                    if(currentAccountId.longValue() != dupNameMember.getOrgAccountId().longValue()) {
                        V3xOrgAccount account = getAccount(dupNameMember.getOrgAccountId());
                        if(null != account && account.isValid()) {
                            dupNameMember.setName(m.getName()+"("+account.getShortName() + "-" + dept1.getName() +")");
                        }
                    } else {
                        dupNameMember.setName(m.getName()+"("+dept1.getName()+")");
                    }
                }

                // 将用于对比的人员setName
                V3xOrgDepartment dept2 = getDept(m.getOrgDepartmentId());
                if(null != dept2 && dept2.isValid()) {
                    if(currentAccountId.longValue() != m.getOrgAccountId().longValue()) {
                        V3xOrgAccount account = getAccount(m.getOrgAccountId());
                        if(null != account && account.isValid()) {
                            m.setName(m.getName()+"("+account.getShortName()+ "-" + dept2.getName() +")");
                        }
                    } else {
                        m.setName(m.getName()+"("+dept2.getName()+")");
                    }
                }
            } else {
                nameMap.put(m.getName(), m);
            }
        }

        return members;
    }

    public void saveCustomOrgRecent(Long memberId, String orgDataStr) throws BusinessException {
        if(Strings.isBlank(orgDataStr)) {
            return ;//如果什么都没有选择，则直接返回
        }
        
        super.addTask(new Object[]{memberId, orgDataStr});
    }
    
    private V3xOrgAccount getAccount(Long accountId) throws BusinessException{
    	if(null==accountMap){
    		accountMap = new HashMap<Long,V3xOrgAccount>();
    	}
    	if(accountMap.containsKey(accountId)){
    		return accountMap.get(accountId);
    	}else{
    		V3xOrgAccount account = orgManager.getAccountById(accountId);
    		accountMap.put(accountId, account);
    		return account;
    	}
    }
    
    private V3xOrgDepartment getDept(Long deptId) throws BusinessException{
    	if(null==deptMap){
    		deptMap = new HashMap<Long,V3xOrgDepartment>();
    	}
    	if(deptMap.containsKey(deptId)){
    		return deptMap.get(deptId);
    	}else{
    		V3xOrgDepartment dept = orgManager.getDepartmentById(deptId);
    		deptMap.put(deptId, dept);
    		return dept;
    	}
    }

    public String getABThreadName(){
        return "ORG_RECENT";
    }
    
    protected void doBatch(List<Object> e) {
        Map<Long, String> memberId2orgDataStrMap = new HashMap<Long, String>();
        
        for (Object orgDataStrObj : e) {
            Long memberId = (Long)((Object[])orgDataStrObj)[0];
            String orgDataStr = (String)((Object[])orgDataStrObj)[1];
            
            String old = memberId2orgDataStrMap.get(memberId);
            if(Strings.isBlank(old)){
                old = orgDataStr;
            }
            else{
                old = orgDataStr + "," + old;
            }
            
            memberId2orgDataStrMap.put(memberId, old);
        }
        
        for (Map.Entry<Long, String> o : memberId2orgDataStrMap.entrySet()) {
            saveOne(o.getKey(), o.getValue());
        }
    }
    
    private void saveOne(Long memberId, String orgDataStr){
        List<String> customRecent = new UniqueList<String>();
        
        String[] datas = orgDataStr.split(",");
        for(String s : datas) {
            if("Member".equals(s.split("[|]")[0])) {//临时加限制，以后有变动直接保存其他类型的数据
                customRecent.add(s);
            }
        }
        
        //如果新选择的<10，读取旧数据
        if(customRecent.size() < orgRecentSavedLength) {
            String oldRecentDatas = customizeManager.getCustomizeValue(memberId, CustomizeConstants.ORG_RECENT);
            if(Strings.isNotBlank(oldRecentDatas)) {
                String[] oldData = oldRecentDatas.split(",");
                for(String s : oldData) {
                    customRecent.add(s);
                }
            }
        }
        
        if (customRecent.size() >= orgRecentSavedLength) {
            customRecent = customRecent.subList(0, orgRecentSavedLength);
        }

        String toSave = Strings.join(customRecent, ",");
        
        customizeManager.saveOrUpdateCustomize(memberId, CustomizeConstants.ORG_RECENT, toSave);
    }

	@Override
	public String getAllMembersWithDisable(Long accountId) throws BusinessException {
		List<V3xOrgMember> memberList = orgManager.getAllMembersWithDisable(accountId);
		List<FastSelectObj> list = new ArrayList<FastSelectObj>();
		for(V3xOrgMember member : memberList){
			FastSelectObj  fsp = new FastSelectObj();
			fsp.setId("Member|"+member.getId());
			fsp.setText(member.getName());
			if(member.getState()==2){
				fsp.setText(member.getName()+"(离职)");
			}
			if(!member.getEnabled()){
				fsp.setText(member.getName()+"(停用)");
			}
			list.add(fsp);
		}
		return JSONUtil.toJSONString(list);
	}

	@Override
	public String getAllDepartments(Long accountId,String key) throws BusinessException {
		List<V3xOrgEntity> departments= getSimpleDataList(V3xOrgDepartment.class.getSimpleName(),key,accountId);
		List<FastSelectObj> list = new ArrayList<FastSelectObj>();
		for(V3xOrgEntity dep : departments){
			FastSelectObj  fsd = new FastSelectObj();
			fsd.setId("Department|"+dep.getId());
			fsd.setText(dep.getName());
			list.add(fsd);
		}
		fastSelectSort(list);
		return JSONUtil.toJSONString(list);
	}

	@Override
	public String getAllTeams(Long accountId,String key) throws BusinessException {
		List<V3xOrgEntity> teams = getSimpleDataList(V3xOrgTeam.class.getSimpleName(),key,accountId);
		List<FastSelectObj> list = new ArrayList<FastSelectObj>();
		for(V3xOrgEntity team : teams){
			FastSelectObj  fst = new FastSelectObj();
			fst.setId("Team|"+team.getId());
			fst.setText(team.getName());
			list.add(fst);
		}
		fastSelectSort(list);
		return JSONUtil.toJSONString(list);
	}

	@Override
	public String getAllPosts(Long accountId,String key) throws BusinessException {
		List<V3xOrgEntity> posts =  getSimpleDataList(V3xOrgPost.class.getSimpleName(),key,accountId);
		List<FastSelectObj> list = new ArrayList<FastSelectObj>();
		for(V3xOrgEntity post : posts){
			FastSelectObj  fsd = new FastSelectObj();
			fsd.setId("Post|"+post.getId());
			fsd.setText(post.getName());
			list.add(fsd);
		}
		fastSelectSort(list);
		return JSONUtil.toJSONString(list);
	}

	@Override
	public String getAllLevels(Long accountId,String key) throws BusinessException {
		List<V3xOrgEntity> levels = getSimpleDataList(V3xOrgLevel.class.getSimpleName(),key,accountId);
		List<FastSelectObj> list = new ArrayList<FastSelectObj>();
		for(V3xOrgEntity level : levels){
			FastSelectObj  fsl = new FastSelectObj();
			fsl.setId("Level|"+level.getId());
			fsl.setText(level.getName());
			list.add(fsl);
		}
		fastSelectSort(list);
		return JSONUtil.toJSONString(list);
	}

	@Override
	public String getAllAccounts(String key) throws BusinessException {
		List<V3xOrgEntity> accounts = getSimpleDataList(V3xOrgAccount.class.getSimpleName(),key,null);
		List<FastSelectObj> list = new ArrayList<FastSelectObj>();
		for(V3xOrgEntity account : accounts){
			FastSelectObj  fsa = new FastSelectObj();
			fsa.setId("Account|"+account.getId());
			fsa.setText(account.getName());
			list.add(fsa);
		}
		fastSelectSort(list);
		return JSONUtil.toJSONString(list);
	}

	private List<V3xOrgEntity> getSimpleDataList(String className,String key,Long accountId) throws BusinessException {
		List<V3xOrgEntity> result = new UniqueList<V3xOrgEntity>();
		List<V3xOrgEntity> datas =  orgManager.getEntityNoRelation(className, "name", key, accountId, false, false, true);
		result.addAll(datas);
		if(result.size()<orgFastSearchLength){
			List<V3xOrgEntity> disableDatas=  orgManager.getDisableEntity(className, null,"name",key);
			result.addAll(disableDatas);
		}
    	if(result.size()>orgFastSearchLength){
    		return result.subList(0, orgFastSearchLength);
    	}else{
    		return result;
    	}
	}

	@Override
	public String getFastRecentDataMember(Long memberId, String customType) throws BusinessException {
        User user = AppContext.getCurrentUser();
        Long currentLoginAccId = user.getLoginAccount();
        List<FastSelectObj> list = new ArrayList<FastSelectObj>();
        List<V3xOrgMember> allMembers = new UniqueList<V3xOrgMember>(orgFastSearchLength);
        String recentDatas = OrgHelper.getCustomizeManager().getCustomizeValue(memberId, CustomizeConstants.ORG_RECENT);
        if(Strings.isNotBlank(recentDatas)) {
            String[] oldData = recentDatas.split(",");
            for(String s : oldData) {
                V3xOrgMember m = orgManager.getMemberById(Long.valueOf(s.split("[|]")[1]));
                if(null != m && m.isValid()) {//OA-64293 
                    if (m.isVJoinExternal()) {//过滤V-Join人员
                        continue;
                    }
                	//默认不进行职务级别控制
            		allMembers.add(m);
                }
            }
        }
        dealDupNameMembers(allMembers);//OA-55808
        if(allMembers.size() >orgFastSearchLength){
        	allMembers = allMembers.subList(0, orgFastSearchLength);
        }
        for(V3xOrgMember m : allMembers) {
        	FastSelectObj data = null;
        	if(m.getOrgDepartmentId()!=-1){
                if(currentLoginAccId.equals(m.getOrgAccountId())) {
               	 data = new FastSelectObj("Member|"+m.getId(), m.getName());
               } else {
                   //OA-55168 跨单位人员，显示单位简称
                   V3xOrgAccount account = getAccount(m.getOrgAccountId());
                   if(null == account || !account.isValid()) {
                       continue;
                   }
                   if(m.getName().contains("(") && m.getName().contains("-")) {
                   	data = new FastSelectObj("Member|"+m.getId(), m.getName());
                   } else {
                   	 data = new FastSelectObj("Member|"+m.getId(), m.getName() + "("+ account.getShortName() +")");
                   }
               }
        	}
            list.add(data);
        }
        fastSelectSort(list);
        return JSONUtil.toJSONString(list);
	}
	
	@Override
	public String getFastSearchDataStr(String key) throws BusinessException {
		Long accountId = AppContext.getCurrentUser().getAccountId();
		List<V3xOrgEntity> entitys =   getSimpleDataList(V3xOrgMember.class.getSimpleName(),key,null);
		List<V3xOrgMember> allMembers = new UniqueList<V3xOrgMember>(orgFastSearchLength);
		for(V3xOrgEntity entity :entitys){
			V3xOrgMember member = ((V3xOrgMember)entity);
			if (member.isVJoinExternal()) {//过滤V-Join人员
                continue;
            }
			allMembers.add(member);
		}
		List<V3xOrgMember> members = dealDupNameMembers(allMembers); //OA-124109
    	List<FastSelectObj> list = new ArrayList<FastSelectObj>();
    	for(V3xOrgMember member :members){
			FastSelectObj  fsm = new FastSelectObj();
			fsm.setId("Member|"+member.getId());
			fsm.setText(member.getName());
			if(member.getState()==2){
				fsm.setText(member.getName()+"("+ResourceUtil.getString("ctp.select2.people.departure")+")");
			}else if(!member.getEnabled()){
				fsm.setText(member.getName()+"("+ResourceUtil.getString("ctp.select2.people.deactivate")+")");
			}
			// 此段注释,重名方法中已做处理
/*			if(!member.getOrgAccountId().equals(accountId)){
				 V3xOrgAccount account = getAccount(member.getOrgAccountId());
				 if(member.getState()==2 || !member.getEnabled()){
					 fsm.setText(fsm.getText()+"("+account.getShortName()+")");
				 }else{
					 fsm.setText(member.getName()+"("+account.getShortName()+")");
				 }
				
			}*/
			list.add(fsm);
    	}
    	fastSelectSort(list);
    	return JSONUtil.toJSONString(list);
	}
	
	class FastSelectObj{
		//快速选人值ID
		String id;
		//快速选人显示名称
		String text;
		public FastSelectObj(){
			
		}
		public FastSelectObj(String string, String name) {
			this.id = string;
			this.text = name;
		}
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
		public String getText() {
			return text;
		}
		public void setText(String text) {
			this.text = text;
		}	
	}
	private void fastSelectSort(List<FastSelectObj> list) {
		Collections.sort(list ,new Comparator<FastSelectObj>(){

			@Override
			public int compare(FastSelectObj o1, FastSelectObj o2) {
				return o1.getText().compareTo(o2.getText());
			}
			
		});
	}
}
