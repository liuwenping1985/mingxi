package com.seeyon.v3x.bulletin.util;

import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.bulletin.bo.BulDataBO;
import com.seeyon.apps.bulletin.bo.BulTypeBO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.bulletin.domain.BulType;
import com.seeyon.v3x.bulletin.manager.BulTypeManager;

/**
 * 公告模块的常用工具类
 * @author wolf
 */
public class BulletinUtils {

    private OrgManager       orgManager;
    private static final Log log = LogFactory.getLog(BulletinUtils.class);

    /**
     * 根据用户ID获取V3xOrgMember
     * @param userId
     */
    public V3xOrgMember getMemberById(Long userId) {
        V3xOrgMember member = null;
        if (userId == 0)
            return new V3xOrgMember();
        try {
            member = orgManager.getMemberById(userId);
        } catch (BusinessException e) {
            log.error("获取实体失败", e);
        }
        if (member == null)
            member = new V3xOrgMember();
        return member;
    }

    /**
     * 根据用户ID获取用户名称
     */
    public String getMemberNameByUserId(Long userId) {
        return getMemberById(userId).getName();
    }

    /**
     * 根据部门Id获取部门名称
     * @param departmentId
     */
    public String getDepartmentNameById(Long departmentId, boolean needAccountShort, boolean isSpace) {
        String result = "";
        if (isSpace) {
            result = getOrgEntityNameOld(V3xOrgEntity.ORGENT_TYPE_DEPARTMENT, departmentId, needAccountShort, orgManager, isSpace);
        } else {
            result = getOrgEntityName(V3xOrgEntity.ORGENT_TYPE_DEPARTMENT, departmentId, needAccountShort, orgManager);
        }
        if (StringUtils.isBlank(result) && departmentId != null) {
            result = String.valueOf(departmentId);
        }
        return result;
    }

    /**
     * 根据实体Bean的property属性的类型，把value转换为正确的类型。主要在条件查询中使用
     * @param mainCls 实体Bean的类
     * @param property Bean的属性
     * @param value Bean的Property属性的值
     * @return 根据Bean的Property类型，把value转换为正确的类型
     */
    @SuppressWarnings("rawtypes")
    public static Object getPropertyObject(Class mainCls, String property, String value) {
        try {
            if (StringUtils.isBlank(value))
                return null;
            Class cls = null;
            try {
                PropertyDescriptor p = PropertyUtils.getPropertyDescriptor(mainCls.newInstance(), property);
                cls = p.getPropertyType();

            } catch (IllegalAccessException e) {
                log.error("实体转类型出错", e);
            } catch (InvocationTargetException e) {
                log.error("实体转类型出错", e);
            } catch (NoSuchMethodException e) {
                log.error("实体转类型出错", e);
            } catch (InstantiationException e) {
                log.error("实体转类型出错", e);
            }

            String clsName = cls.getSimpleName();
            Object newValue = value;
            if ("String".equals(clsName)) {
                newValue = value;
            } else if ("Integer".equals(clsName)) {
                newValue = Integer.valueOf(value);
            } else if ("Long".equals(clsName)) {
                newValue = Long.valueOf(value);
            } else if ("Boolean".equalsIgnoreCase(clsName)) {
                if ("1".equals(value) || "true".equals(value) || "t".equals(value))
                    newValue = Boolean.TRUE;
                else
                    newValue = Boolean.FALSE;
            }
            return newValue;
        } catch (SecurityException e) {
            log.error("实体转类型出错", e);
        }
        return value;
    }

    /**
     * 利用反射取得一个对象的属性值
     */
    public Object getAttributeValue(Object obj, String attribute) {
        if (obj == null || Strings.isBlank(attribute))
            return null;
        String methodName = "get" + attribute.toUpperCase().charAt(0) + attribute.substring(1);
        Method method = null;
        try {
            method = obj.getClass().getMethod(methodName);
        } catch (Exception e) {
            log.error("利用反射取得一个对象的属性值出错", e);
            methodName = "is" + attribute.toUpperCase().charAt(0) + attribute.substring(1);
            try {
                method = obj.getClass().getMethod(methodName);
            } catch (Exception e1) {
                log.error("利用反射取得一个对象的属性值出错", e1);
            }
        }
        if (method == null)
            return null;
        Object value = null;
        try {
            value = method.invoke(obj);
        } catch (Exception e) {
            log.error("利用反射取得一个对象的属性值出错", e);
        }

        return value;
    }

    /**
     * 自动设置bean的某个属性的值，会自动将value类型转换为property属性的类型
     * @param bean
     * @param property
     * @param value
     * @throws Exception 
     */
    public static void setProperty(Object bean, String property, String value) throws Exception {
        try {
            Object newValue = getPropertyObject(bean.getClass(), property, value);
            PropertyUtils.setSimpleProperty(bean, property, newValue);
        } catch (IllegalAccessException e) {
            log.error("", e);
            throw e;
        } catch (InvocationTargetException e) {
            log.error("", e);
            throw e;
        } catch (NoSuchMethodException e) {
            log.error("", e);
            throw e;
        }
    }

    public static String getOrgEntityName(String orgType, long orgId, boolean needAccountShort, OrgManager orgManager) {
        return BulletinUtils.getOrgEntityNameOld(orgType, orgId, needAccountShort, orgManager, false);
    }

    /**
     * 得到组织模型实体的名称
     */
    public static String getOrgEntityNameOld(String orgType, long orgId, boolean needAccountShort, OrgManager orgManager, boolean isSpace) {
        String name = null;
        User user = AppContext.getCurrentUser();
        try {
            if (orgManager == null)
                orgManager = (OrgManager) AppContext.getBean("orgManager");

            V3xOrgEntity entity = null;
            if (V3xOrgEntity.ORGENT_TYPE_MEMBER.equals(orgType)) {
                entity = orgManager.getMemberById(orgId);
            } else if (V3xOrgEntity.ORGENT_TYPE_DEPARTMENT.equals(orgType)) {
                entity = orgManager.getDepartmentById(orgId);
            } else if (V3xOrgEntity.ORGENT_TYPE_ACCOUNT.equals(orgType)) {
                entity = orgManager.getAccountById(orgId);
            } else if (V3xOrgEntity.ORGENT_TYPE_POST.equals(orgType)) {
                entity = orgManager.getPostById(orgId);
            } else if (V3xOrgEntity.ORGENT_TYPE_ROLE.equals(orgType)) {
                entity = orgManager.getRoleById(orgId);
            } else if (V3xOrgEntity.ORGENT_TYPE_TEAM.equals(orgType)) {
                entity = orgManager.getTeamById(orgId);
            } else if (V3xOrgEntity.ORGENT_TYPE_LEVEL.equals(orgType)) {
                entity = orgManager.getLevelById(orgId);
            }

            if (entity != null) {
                name = entity.getName();
                if (user != null && user.getLoginAccount() != null) {
                    if (user.getLoginAccount() != null) {
                        if (!user.getLoginAccount().equals(entity.getOrgAccountId())) {
                            V3xOrgAccount account = orgManager.getAccountById(entity.getOrgAccountId());
                            if (account != null) {
                                name += "(" + account.getShortName() + ")";
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            log.error("获取组织模型名称时出现异常，类型[" + orgType + "]，id[" + orgId + "]", e);
        }

        return StringUtils.defaultString(name);
    }

    /**
     * 得到组织模型实体的名称
     */
    public static String getOrgEntityName(String orgType, long orgId, boolean needAccountShort) {
        return getOrgEntityName(orgType, orgId, needAccountShort, null);
    }

    /**
     * 获取宽栏目置顶公告的标题HTML代码
     * @param bulData  置顶公告
     */
    public static String getTopedBulTitleHtml(BulData bulData) {
        return getTopedBulTitleHtml(bulData, false);
    }

    /**
     * 获取置顶公告的标题HTML代码
     * @param bulData  置顶公告
     * @param isNarrow 是否在窄栏目
     */
    public static String getTopedBulTitleHtml(BulData bulData, boolean isNarrow) {
        boolean attach = BooleanUtils.isTrue(bulData.getAttachmentsFlag());
        int maxLength = (isNarrow ? 40 : 36) - (attach ? 2 : 0);
        String title = bulData.getTitle();
        return "<font class='div-float' color=red>[" + ResourceBundleUtil.getString(Constants.BUL_RESOURCE_BASENAME, "label.top.js") + "]</font>" + "<span class='div-float' title='"
                + Functions.toHTML(title) + "'> " + Functions.toHTML(Strings.getLimitLengthString(title, maxLength, "...")) + "</span>" + "<span class='attachment_" + attach
                + " div-float display_inline-block'></span>" + (isNarrow ? "" : ("<span class='bodyType_" + bulData.getDataFormat() + " div-float display_inline-block'></span>"));
    }

    public void initData(BulData data) {
        initDataFlag(data, false);
    }

    /**
     * 初始化公告 1、初始化发起者姓名 2、初始化公告是否存在附件标志 3、初始化公告发布部门的中文名称
     * 主要用于首页栏目中的公告列表展现
     */
    public void initDataFlag(BulData data, boolean showshortName) {
        User user = AppContext.getCurrentUser();
        if (data.getPublishDepartmentId() == null) {
            // 设置为发起者所在部门
            Long userId = data.getCreateUser();
            Long depId = getMemberById(userId).getOrgDepartmentId();
            data.setPublishDepartmentId(depId);
        }

        BulTypeManager bulTypeManager = (BulTypeManager) AppContext.getBean("bulTypeManager");
        BulType theType = bulTypeManager.getById(data.getTypeId());
        if (theType != null) {
            data.setType(theType);
            boolean groupType = theType.getSpaceType().intValue() == SpaceType.group.ordinal() || theType.getSpaceType().intValue() == SpaceType.public_custom_group.ordinal()
                    || theType.getSpaceType().intValue() == SpaceType.custom.ordinal() || theType.getSpaceType().intValue() == SpaceType.public_custom.ordinal();

            data.setPublishDeptName(this.getDepartmentNameById(data.getPublishDepartmentId(), groupType, showshortName));
            data.setTypeName(theType.getTypeName());
        }
        data.setPublishMemberName("");
        //拼装显示发布名称
        String showPublishName = data.getPublishDeptName();
        
        // SZP 客开 START
        /*
        if (showPublishName.equals("-2329940225728493295")){
        	data.setPublishDeptName("中国信达资产管理股份有限公司");
        	showPublishName = "中国信达资产管理股份有限公司";
        */
        // 设置公司名称
	    Map<String,String> accounts = orgManager.getAccountIdAndNames();
		if(accounts.containsKey(showPublishName)){
			showPublishName = accounts.get(showPublishName);
			data.setPublishDeptName(showPublishName);
        	
        }else if (showPublishName.equals("-1010101010101010101")){
        	data.setPublishDepartmentId(-1010101010101010101L);
        	data.setPublishDeptName("");
        	showPublishName = "";
        }
        // SZP 客开 END
        
        String memberNameAndDeptName = "";
        V3xOrgMember member = null;
        V3xOrgAccount account = null;
        Long pigeonholeUserId = data.getPublishUserId();
        try {
            if (pigeonholeUserId != null && orgManager.getMemberById(pigeonholeUserId) != null) {
                member = orgManager.getMemberById(pigeonholeUserId);
                if (member != null) {
                    if (user != null && user.getLoginAccount() != null && !user.getLoginAccount().equals(member.getOrgAccountId())) {
                        account = orgManager.getAccountById(member.getOrgAccountId());
                        data.setPublishMemberName(account != null ? member.getName() + "(" + account.getShortName() + ")" : member.getName());
                    } else {
                        data.setPublishMemberName(member.getName());
                    }
                }
            } else {
                member = orgManager.getMemberById(data.getCreateUser());
            }
        } catch (BusinessException e) {
            log.info("获取发布人异常:" + pigeonholeUserId + e);
        }
        if (member != null) {
            if (user != null && user.getLoginAccount() != null && !user.getLoginAccount().equals(member.getOrgAccountId())) {
                try {
                    if (account == null) {
                        account = orgManager.getAccountById(member.getOrgAccountId());
                    }
                } catch (BusinessException e) {
                    log.info("获取人员单位错误:" + member.getOrgAccountId() + e);
                }
            }
            memberNameAndDeptName = account != null ? member.getName() + "(" + account.getShortName() + ")" + "/" + data.getPublishDeptName() : member.getName() + "/" + data.getPublishDeptName();
        }
        if (data.isShowPublishUserFlag()) {
            showPublishName = memberNameAndDeptName;
        }
        data.setShowPublishName(showPublishName);
        int state = data.getState();
        //客开 start
        if (state == Constants.DATA_STATE_ALREADY_CREATE || state == Constants.DATA_STATE_TYPESETTING_CREATE) {
            data.setNoDelete(true);
            data.setNoEdit(true);
        } else if (state == Constants.DATA_STATE_ALREADY_AUDIT || state == Constants.DATA_STATE_TYPESETTING_PASS) {
            data.setNoEdit(true);
        }
        //客开end
        
        if (data.getReadCount() == null) {
            data.setReadCount(0);
        }
    }

    /** 初始化公告列表  */
    public void initList(List<BulData> list) {
        if (CollectionUtils.isNotEmpty(list)) {
            for (BulData data : list) {
                initData(data);
            }
        }
    }

    /**
     * 获取公告板块集合的ID集合
     */
    public static Set<Long> getIdSet(Collection<BulType> coll) {
        Set<Long> set = new HashSet<Long>();
        if (CollectionUtils.isNotEmpty(coll)) {
            for (BulType bt : coll) {
                set.add(bt.getId());
            }
        }
        return set;
    }

    /** 根据空间类型获取单位或集团ID */
    public static Long getAccountId(int spaceType, OrgManager orgManager) {
        Long accountId = -1l;
        User user = AppContext.getCurrentUser();
        if (user != null) {
            accountId = user.getLoginAccount();
        }
        if (spaceType == SpaceType.group.ordinal()) {
            try {
                accountId = orgManager.getRootAccount().getId();
            } catch (BusinessException e) {
                log.error("", e);
            }
        }
        return accountId;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public static BulTypeBO bulTypePOToBO(BulType bulType) {
        if (bulType == null) {
            return null;
        }

        BulTypeBO bulTypeBO = new BulTypeBO();
        bulTypeBO.setId(bulType.getId());
        bulTypeBO.setAccountId(bulType.getAccountId());
        bulTypeBO.setAuditFlag(bulType.isAuditFlag());
        bulTypeBO.setAuditUser(bulType.getAuditUser());
        bulTypeBO.setCreateDate(bulType.getCreateDate());
        bulTypeBO.setCreateUser(bulType.getCreateUser());
        bulTypeBO.setDescription(bulType.getDescription());
        bulTypeBO.setExt1(bulType.getExt1());
        bulTypeBO.setExt2(bulType.getExt2());
        bulTypeBO.setSpaceType(bulType.getSpaceType());
        bulTypeBO.setTopCount(bulType.getTopCount());
        bulTypeBO.setTypeName(bulType.getTypeName());
        bulTypeBO.setUpdateDate(bulType.getUpdateDate());
        bulTypeBO.setUpdateUser(bulType.getUpdateUser());
        bulTypeBO.setUsedFlag(bulType.isUsedFlag());
        bulTypeBO.setIsAuditorModify(bulType.getIsAuditorModify());
        return bulTypeBO;
    }

    public static BulDataBO bulDataPOToBO(BulData bulData) {
        if (bulData == null) {
            return null;
        }

        BulDataBO bulDataBO = new BulDataBO();
        bulDataBO.setId(bulData.getId());
        bulDataBO.setTitle(bulData.getTitle());
        bulDataBO.setPublishScope(bulData.getPublishScope());
        bulDataBO.setPublishDepartmentId(bulData.getPublishDepartmentId());
        bulDataBO.setBrief(bulData.getBrief());
        bulDataBO.setKeywords(bulData.getKeywords());
        bulDataBO.setDataFormat(bulData.getDataFormat());
        bulDataBO.setContent(bulData.getContent());
        bulDataBO.setCreateDate(bulData.getCreateDate());
        bulDataBO.setCreateUser(bulData.getCreateUser());
        bulDataBO.setAuditDate(bulData.getAuditDate());
        bulDataBO.setAuditUserId(bulData.getAuditUserId());
        bulDataBO.setAuditAdvice(bulData.getAuditAdvice());
        bulDataBO.setPublishDate(bulData.getPublishDate());
        bulDataBO.setPublishUserId(bulData.getPublishUserId());
        bulDataBO.setPigeonholeDate(bulData.getPigeonholeDate());
        bulDataBO.setPigeonholeUserId(bulData.getPigeonholeUserId());
        bulDataBO.setPigeonholePath(bulData.getPigeonholePath());
        bulDataBO.setUpdateDate(bulData.getUpdateDate());
        bulDataBO.setUpdateUser(bulData.getUpdateUser());
        bulDataBO.setReadCount(bulData.getReadCount());
        bulDataBO.setTopOrder(bulData.getTopOrder());
        bulDataBO.setState(bulData.getState());
        bulDataBO.setDeletedFlag(bulData.isDeletedFlag());
        bulDataBO.setAccountId(bulData.getAccountId());
        bulDataBO.setExt1(bulData.getExt1());
        bulDataBO.setExt2(bulData.getExt2());
        bulDataBO.setExt3(bulData.getExt3());
        bulDataBO.setExt4(bulData.getExt4());
        bulDataBO.setExt5(bulData.getExt5());
        bulDataBO.setTypeId(bulData.getTypeId());
        return bulDataBO;
    }

    /**
     * 查询字段，顺序不能变，要加只能在最后追加
     * @param objList
     * @return
     */
    public static List<BulData> objArr2NewsData(List<Object[]> objList) {
        List<BulData> list = new ArrayList<BulData>();
        if (Strings.isEmpty(objList)) {
            return list;
        }

        for (Object[] arr : objList) {
            BulData data = new BulData();
            int n = 0;
            data.setId((Long) arr[n++]);
            data.setTitle((String) arr[n++]);
            data.setDataFormat((String) arr[n++]);
            data.setCreateDate((Timestamp) arr[n++]);
            data.setCreateUser((Long) arr[n++]);
            data.setUpdateDate((Timestamp) arr[n++]);
            data.setUpdateUser((Long) arr[n++]);
            data.setPublishDate((Timestamp) arr[n++]);
            data.setPublishUserId((Long) arr[n++]);
            data.setPublishScope((String) arr[n++]);
            data.setPublishDepartmentId((Long) arr[n++]);
            data.setShowPublishUserFlag((Boolean) arr[n++]);
            data.setAuditDate((Timestamp) arr[n++]);
            data.setAuditUserId((Long) arr[n++]);
            data.setTypeId((Long) arr[n++]);
            data.setAccountId((Long) arr[n++]);
            data.setReadCount((Integer) arr[n++]);
            data.setTopOrder((Byte) arr[n++]);
            data.setState((Integer) arr[n++]);
            data.setDeletedFlag((Boolean) arr[n++]);
            data.setExt1((String) arr[n++]);
            data.setExt2((String) arr[n++]);
            data.setExt3((String) arr[n++]);
            data.setExt4((String) arr[n++]);
            data.setExt5((String) arr[n++]);
            data.setAttachmentsFlag((Boolean) arr[n++]);
            data.setPublishChoose((Integer) arr[n++]);
            data.setWritePublish((String) arr[n++]);
            data.setAuditDate1((Timestamp) arr[n++]);
            data.setAuditUserId1((Long) arr[n++]);
            data.setAuditAdvice1((String) arr[n++]);
            data.setOldId((Long) arr[n++]);
            list.add(data);
        }
        return list;
    }

}
