package com.seeyon.ctp.portal.link.manager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.link.dao.LinkOptionValueDao;
import com.seeyon.ctp.portal.po.PortalLinkOption;
import com.seeyon.ctp.portal.po.PortalLinkOptionValue;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.LightWeightEncoder;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;

public class LinkOptionManagerImpl implements LinkOptionManager {
    private static final Log   log = LogFactory.getLog(LinkOptionManagerImpl.class);
    private OrgManager         orgManager;
    private LinkOptionValueDao linkOptionValueDao;

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setLinkOptionValueDao(LinkOptionValueDao linkOptionValueDao) {
        this.linkOptionValueDao = linkOptionValueDao;
    }

    @Override
    public DataRecord exportLinkOptionTemplate(List<PortalLinkOption> linkOptionList) {
        if (linkOptionList == null || linkOptionList.size() == 0) {
            return null;
        }
        DataRecord dataRecord = new DataRecord();
        //导出excel文件的国际化
        String exportTitleLabel = "关联系统参数列表";
        String loginNameLabel = "登录名";
        String[] columnName = new String[linkOptionList.size() + 1];
        columnName[0] = loginNameLabel;
        if (null != linkOptionList && linkOptionList.size() > 0) {
            for (int i = 0; i < linkOptionList.size(); i++) {
                PortalLinkOption linkOption = linkOptionList.get(i);
                columnName[i + 1] = linkOption.getParamName();
            }
        }
        dataRecord.setColumnName(columnName);
        dataRecord.setTitle(exportTitleLabel);
        dataRecord.setSheetName(exportTitleLabel);
        return dataRecord;
    }

    @Override
    public String importLinkOptinValue(Long linkSystemId, List<List<String>> linkOptionValueList, String repeat)
            throws BusinessException {
        StringBuilder overLeapAndOverCastInfo = new StringBuilder();
        int caAccountListSize = 0;
        StringBuilder result = new StringBuilder();
        if (linkOptionValueList != null)
            caAccountListSize = linkOptionValueList.size();
        Map<String, V3xOrgMember> memberCache = new HashMap<String, V3xOrgMember>();
        Map<String, PortalLinkOption> linkOptionCache = new HashMap<String, PortalLinkOption>();
        Map<String, PortalLinkOptionValue> linkOptionValueCache = new HashMap<String, PortalLinkOptionValue>();
        List<PortalLinkOptionValue> linkOptionValuesForAdd = new ArrayList<PortalLinkOptionValue>();
        List<PortalLinkOptionValue> linkOptionValuesForUpdate = new ArrayList<PortalLinkOptionValue>();
        List<String> tableHead = linkOptionValueList.get(0);
        String[] paramNames = new String[tableHead.size() - 2];
        for (int i = 0; i <= paramNames.length - 1; i++) {
            paramNames[i] = tableHead.get(i + 1);
        }
        for (int i = 1; i < caAccountListSize; i++) {
            List<String> record = linkOptionValueList.get(i);
            String loginName = record.get(0);
            if (loginName == null || loginName.trim().length() == 0) {
                result.append(ResourceUtil.getString("link.jsp.import.loginnamenull.prompt") + (i + 2)).append("<br/>");
                continue;
            }
            String[] paramValues = new String[paramNames.length];
            for (int j = 0; j < paramValues.length; j++) {
                paramValues[j] = record.get(j + 1);
//                if (paramValues[j] == null || paramValues[j].trim().length() == 0) {
//                    continue;
//                } else {
                    V3xOrgMember member = memberCache.get(loginName);
                    try {
                        if (member == null) {
                            member = orgManager.getMemberByLoginName(loginName);
                            memberCache.put(loginName, member);
                        }
                    } catch (BusinessException e) {
                        log.error("error when importLinkOptinValue, cause by " + e);
                        result.append(ResourceUtil.getString("link.jsp.import.nouser.prompt") + loginName).append("<br/>");
                        break;
                    }
                    if (member == null) {
                        log.error("error when importLinkOptinValue, can not find V3xOrgMember by loginName:"
                                + loginName);
                        result.append(ResourceUtil.getString("link.jsp.import.nouser.prompt") + loginName).append("<br/>");
                        break;
                    }
                    Long userId = member.getId();
                    String userName = member.getName();
                    PortalLinkOption existLinkOption = linkOptionCache.get(linkSystemId + paramNames[j]);
                    if (existLinkOption == null) {
                        existLinkOption = findLinkOptionBy(linkSystemId, paramNames[j]);
                        linkOptionCache.put(linkSystemId + paramNames[j], existLinkOption);
                    }
                    if (existLinkOption == null) {
                        log.error("error when importLinkOptinValue, 关联系统参数为空, 参数:" + paramNames[j]);
                        result.append(ResourceUtil.getString("link.jsp.import.nooption.prompt") + "paramName:" + paramNames[j]).append("<br/>");
                        continue;
                    } else {
                        PortalLinkOptionValue ploValueInDB = this.selectLinkOptionValue(existLinkOption.getId(), userId);
                        if(ploValueInDB != null){
                            ploValueInDB.setValue(LightWeightEncoder.encodeString(ploValueInDB.getValue()));
                        }
                        PortalLinkOptionValue existLinkOptionValue = linkOptionValueCache.get(linkSystemId + paramNames[j] + userId);
                        if(existLinkOptionValue == null && ploValueInDB == null){
                            //如果内存和数据库里都没有值，则新增
                            PortalLinkOptionValue newLinkOptionValue = new PortalLinkOptionValue();
                            newLinkOptionValue.setNewId();
                            newLinkOptionValue.setLinkOptionId(existLinkOption.getId());
                            newLinkOptionValue.setUserId(userId);
                            newLinkOptionValue.setValue(LightWeightEncoder.encodeString(paramValues[j]));
                            linkOptionValuesForAdd.add(newLinkOptionValue);
                            linkOptionValueCache.put(linkSystemId + paramNames[j] + userId, newLinkOptionValue);
                        } else if(existLinkOptionValue == null && ploValueInDB != null){
                            //如果内存没有值，数据库里有值
                            if("0".equals(repeat)){
                                //跳过
                                linkOptionValueCache.put(linkSystemId + paramNames[j] + userId, ploValueInDB);
                                overLeapAndOverCastInfo.append(userName).append(",").append(Strings.toHTML(paramNames[j])).append(",").append(ResourceUtil.getString("link.import.result.overleap")).append("<br/>");
                                continue;
                            } else {
                                //覆盖，更新数据库里的值
                                ploValueInDB.setValue(LightWeightEncoder.encodeString(paramValues[j]));
                                linkOptionValuesForUpdate.add(ploValueInDB);
                                linkOptionValueCache.put(linkSystemId + paramNames[j] + userId, ploValueInDB);
                                overLeapAndOverCastInfo.append(userName).append(",").append(Strings.toHTML(paramNames[j])).append(",").append(ResourceUtil.getString("link.import.result.overcast")).append("<br/>");
                            }
                        } else if(existLinkOptionValue != null){
                            //如果内存有值
                            if("0".equals(repeat)){
                                //跳过
                                overLeapAndOverCastInfo.append(userName).append(",").append(Strings.toHTML(paramNames[j])).append(",").append(ResourceUtil.getString("link.import.result.overleap")).append("<br/>");
                                continue;
                            } else {
                                //覆盖
                                if(ploValueInDB != null){
                                    ploValueInDB.setValue(LightWeightEncoder.encodeString(paramValues[j]));
                                    linkOptionValuesForUpdate.add(ploValueInDB);
                                }
                                existLinkOptionValue.setValue(LightWeightEncoder.encodeString(paramValues[j]));
                                linkOptionValueCache.put(linkSystemId + paramNames[j] + userId, existLinkOptionValue);
                                overLeapAndOverCastInfo.append(userName).append(",").append(Strings.toHTML(paramNames[j])).append(",").append(ResourceUtil.getString("link.import.result.overcast")).append("<br/>");
                            }
                        }
                    }
                }
            }
//        }
        if (result.length() == 0) {
            //deleteParamValuesByLinkSystemId(linkSystemId);
            DBAgent.saveAll(linkOptionValuesForAdd);
            DBAgent.updateAll(linkOptionValuesForUpdate);
        } else {
            throw new BusinessException(result.toString());
        }
        return overLeapAndOverCastInfo.toString();
    }

    @Override
    @SuppressWarnings("unchecked")
    public PortalLinkOption findLinkOptionBy(Long linkSystemId, String paramName) {
        String hql = "from PortalLinkOption as link where link.linkSystemId=:linkSystemId and link.paramName=:paramName";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("linkSystemId", linkSystemId);
        params.put("paramName", paramName);
        List<PortalLinkOption> result = DBAgent.find(hql, params);
        if (result != null && result.size() > 0) {
            return (PortalLinkOption) result.get(0);
        }
        return null;
    }

    @Override
    public void deleteParamValuesByLinkSystemId(Long linkSystemId) {
        List<PortalLinkOption> linkOptions = selectLinkOptions(linkSystemId);
        List<Long> linkOptionIdList = new ArrayList<Long>();
        for (PortalLinkOption linkOption : linkOptions) {
            linkOptionIdList.add(linkOption.getId());
        }
        StringBuffer hql = new StringBuffer();
        hql.append("delete from PortalLinkOptionValue where linkOptionId in (:linkOptionIds)");
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("linkOptionIds", linkOptionIdList);
        DBAgent.bulkUpdate(hql.toString(), params);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<PortalLinkOption> selectLinkOptions(Long linkSystemId) {
        String hql = "from PortalLinkOption where linkSystemId = :linkSystemId order by orderNum asc";
        Map<String, Object> nameParameters = new HashMap<String, Object>();
        nameParameters.put("linkSystemId", linkSystemId);
        List<PortalLinkOption> list = DBAgent.find(hql, nameParameters);
        List<PortalLinkOption> newList = new ArrayList<PortalLinkOption>();
        for (PortalLinkOption option : list) {
            PortalLinkOption optionCloned = null;
            try {
                optionCloned = (PortalLinkOption) BeanUtils.cloneBean(option);
            } catch (Exception e) {
                log.error(e);
            }
            optionCloned.setParamValue(LightWeightEncoder.decodeString(optionCloned.getParamValue()));
            newList.add(optionCloned);
        }
        return newList;
    }
    @SuppressWarnings({ "unchecked", "rawtypes" })
    @Override
    public FlipInfo selectLinkOptionValues(FlipInfo fi, Map params) throws BusinessException {
        String linkSystemId = (String) params.get("linkSystemId");
        if (Strings.isBlank(linkSystemId)) {
            return fi;
        }
        List<PortalLinkOption> linkOptionList = this.selectLinkOptions(Long.valueOf(linkSystemId));
        if(CollectionUtils.isEmpty(linkOptionList)){
        	return fi;
        }
        StringBuffer hql = new StringBuffer(
                "select new map(lov.userId as userId) from PortalLinkOptionValue lov where lov.linkOptionId = :linkOptionId");
        Map p = new HashMap();
        p.put("linkOptionId", linkOptionList.get(0).getId());
        List<Map> optionValueMapList = DBAgent.find(hql.toString(), p, fi);
        for (Map userMap : optionValueMapList) {
            Long userId = (Long) userMap.get("userId");
            V3xOrgMember v3xOrgMember = orgManager.getMemberById(userId);
            String userName = v3xOrgMember.getName();
            String loginName = v3xOrgMember.getLoginName();
            userMap.put("userName", userName);
            userMap.put("loginName", loginName);
            userMap.put("paramName", "");
        }
        return fi;
    }
    @Override
    public void deleteParamValues(List<String> linkOptionIds, List<String> userIds) {
        List<Long> linkOptionIdList = new ArrayList<Long>();
        List<Long> userIdList = new ArrayList<Long>();
        for (String linkOptionId : linkOptionIds) {
            linkOptionIdList.add(Long.valueOf(linkOptionId));
        }
        for (String userId : userIds) {
            userIdList.add(Long.valueOf(userId));
        }
        StringBuffer hql = new StringBuffer();
        hql.append("delete from PortalLinkOptionValue where linkOptionId in (:linkOptionIds) and userId in (:userIds)");
        Map<String, Object> nameParameters = new HashMap<String, Object>();
        nameParameters.put("linkOptionIds", linkOptionIdList);
        nameParameters.put("userIds", userIdList);
        DBAgent.bulkUpdate(hql.toString(), nameParameters);
    }

    @Override
    public List<PortalLinkOptionValue> selectLinkOptionValues(List<Long> linkOptionId, long userId)
            throws BusinessException {
        List<PortalLinkOptionValue> newList = new ArrayList<PortalLinkOptionValue>();
        List<PortalLinkOptionValue> linkOptionValues = linkOptionValueDao.selectLinkOptionValues(userId, linkOptionId);
        for (PortalLinkOptionValue linkOptionValue : linkOptionValues) {
            PortalLinkOptionValue linkOptionValueCloned = null;
            try {
                linkOptionValueCloned = (PortalLinkOptionValue) BeanUtils.cloneBean(linkOptionValue);
            } catch (Exception e) {
                throw new BusinessException(e);
            }
            linkOptionValueCloned.setValue(LightWeightEncoder.decodeString(linkOptionValueCloned.getValue()));
            newList.add(linkOptionValueCloned);
        }
        return newList;
    }

    @Override
    public PortalLinkOptionValue selectLinkOptionValue(long linkOptionId, long userId) {
        List<Long> linkOptionIds = new ArrayList<Long>();
        linkOptionIds.add(linkOptionId);
        List<PortalLinkOptionValue> linkOptionValues = linkOptionValueDao.selectLinkOptionValues(userId, linkOptionIds);
        if (!linkOptionValues.isEmpty()) {
            PortalLinkOptionValue optionValue = linkOptionValues.get(0);
            optionValue.setValue(LightWeightEncoder.decodeString(optionValue.getValue()));
            return optionValue;
        }
        return null;
    }

    @Override
    public PortalLinkOptionValue selectLinkOptionValueCurrent(long linkOptionId) {
        return selectLinkOptionValue(linkOptionId, AppContext.currentUserId());
    }

    @Override
    public void saveLinkOptionValue(List<Map<String, Object>> linkOptionValue) {
        if (!linkOptionValue.isEmpty()) {
            List<PortalLinkOptionValue> linkOptionValues = ParamUtil.mapsToBeans(linkOptionValue,
                    PortalLinkOptionValue.class, true);
            for (PortalLinkOptionValue optionValue : linkOptionValues) {
                optionValue.setUserId(AppContext.currentUserId());
                optionValue.setValue(LightWeightEncoder.encodeString(optionValue.getValue()));
            }
            linkOptionValueDao.deleteLinkOptionValue(linkOptionValues);
            linkOptionValueDao.saveLinkOptionValue(linkOptionValues);
        }
    }
}
