//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.organization.principal;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.cache.CacheAccessable;
import com.seeyon.ctp.common.cache.CacheFactory;
import com.seeyon.ctp.common.cache.CacheMap;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.security.MessageEncoder;
import com.seeyon.ctp.organization.bo.OrganizationMessage;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgPrincipal;
import com.seeyon.ctp.organization.bo.OrganizationMessage.MessageStatus;
import com.seeyon.ctp.organization.po.OrgPrincipal;
import com.seeyon.ctp.organization.principal.dao.PrincipalDao;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UniqueList;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class PrincipalManagerImpl implements PrincipalManager {
    private static final Log logger = LogFactory.getLog(PrincipalManagerImpl.class);
    private CacheMap<String, OrgPrincipal> principalBeans = null;
    private CacheMap<Long, String> principalBeansId2LoginName = null;
    private PrincipalDao principalDao;
    private SystemConfig systemConfig;

    public PrincipalManagerImpl() {
    }

    public void setPrincipalDao(PrincipalDao principalDao) {
        this.principalDao = principalDao;
    }

    public void setSystemConfig(SystemConfig systemConfig) {
        this.systemConfig = systemConfig;
    }

    public void init() {
        CacheAccessable cacheFactory = CacheFactory.getInstance(PrincipalManager.class);
        this.principalBeans = cacheFactory.createMap("PrincipalBeans");
        this.principalBeansId2LoginName = cacheFactory.createMap("PrincipalBeansId2LoginName");
        List<OrgPrincipal> principals = this.principalDao.selectAll();
        Map<String, OrgPrincipal> _temp1 = new HashMap();
        Map<Long, String> _temp2 = new HashMap();
        Iterator var5 = principals.iterator();

        while(var5.hasNext()) {
            OrgPrincipal orgPrincipal = (OrgPrincipal)var5.next();
            _temp1.put(orgPrincipal.getLoginName(), orgPrincipal);
            _temp2.put(orgPrincipal.getMemberId(), orgPrincipal.getLoginName());
        }

        this.principalBeans.putAll(_temp1);
        this.principalBeansId2LoginName.putAll(_temp2);
        logger.info("加载OrgPrincipal完成");
    }

    public boolean isExist(String loginName) {
        return this.principalBeans.contains(loginName);
    }

    public boolean isExist(long memberId) {
        try {
            OrgPrincipal bean = this.getPrincipalBeanByMemberId(memberId);
            return bean != null;
        } catch (NoSuchPrincipalException var4) {
            return false;
        }
    }

    public long getMemberIdByLoginName(String loginName) throws NoSuchPrincipalException {
        OrgPrincipal bean = (OrgPrincipal)this.principalBeans.get(loginName);
        if(bean == null) {
            throw new NoSuchPrincipalException(loginName);
        } else {
            return bean.getMemberId().longValue();
        }
    }

    public String getLoginNameByMemberId(long memberId) throws NoSuchPrincipalException {
        return this.getPrincipalBeanByMemberId(memberId).getLoginName();
    }

    private OrgPrincipal getPrincipalBeanByMemberId(long memberId) throws NoSuchPrincipalException {
        String loginName = (String)this.principalBeansId2LoginName.get(Long.valueOf(memberId));
        if(null != loginName) {
            OrgPrincipal orgPrincipal = (OrgPrincipal)this.principalBeans.get(loginName);
            if(null != orgPrincipal) {
                return orgPrincipal;
            }
        }

        throw new NoSuchPrincipalException(String.valueOf(memberId));
    }

    public OrganizationMessage insert(V3xOrgPrincipal principal) {
        List<V3xOrgPrincipal> principals = new ArrayList(1);
        principals.add(principal);
        return this.insertBatch(principals);
    }

    public OrganizationMessage insertBatch(List<V3xOrgPrincipal> principals) {
        OrganizationMessage message = new OrganizationMessage();
        if(principals != null && !principals.isEmpty()) {
            List<OrgPrincipal> prps = new ArrayList();

            for(int k = 0; k < principals.size(); ++k) {
                V3xOrgPrincipal principal = (V3xOrgPrincipal)principals.get(k);
                long memberId = principal.getMemberId().longValue();
                String loginName = principal.getLoginName();
                String password = principal.getPassword();
                if(this.isExist(loginName)) {
                    message.addErrorMsg((V3xOrgEntity)null, MessageStatus.POST_REPEAT_NAME);
                } else if(this.isExist(memberId)) {
                    message.addErrorMsg((V3xOrgEntity)null, MessageStatus.POST_REPEAT_NAME);
                } else {
                    message.addSuccessMsg((V3xOrgEntity)null);
                    OrgPrincipal prp = new OrgPrincipal();
                    prp.setIdIfNew();
                    prp.setMemberId(Long.valueOf(memberId));
                    prp.setClassName((String)null);
                    prp.setLoginName(loginName);
                    prp.setEnable(Boolean.valueOf(true));
                    prp.setCreateTime(new Date());
                    prp.setUpdateTime(new Date());
                    prp.setExpirationDate((Date)null);
                    prps.add(prp);

                    try {
                        MessageEncoder encode = new MessageEncoder();
                        prp.setCredentialValue(encode.encode(loginName, password));
                    } catch (Exception var12) {
                        ;
                    }
                }
            }

            this.principalDao.insertBatch(prps);
            Map<String, OrgPrincipal> _temp = new HashMap();
            Map<Long, String> _temp2 = new HashMap();
            Iterator var15 = prps.iterator();

            while(var15.hasNext()) {
                OrgPrincipal orgPrincipal = (OrgPrincipal)var15.next();
                _temp.put(orgPrincipal.getLoginName(), orgPrincipal);
                _temp2.put(orgPrincipal.getMemberId(), orgPrincipal.getLoginName());
            }

            this.principalBeans.putAll(_temp);
            this.principalBeansId2LoginName.putAll(_temp2);
            return message;
        } else {
            return message;
        }
    }

    public OrganizationMessage update(V3xOrgPrincipal principal) {
        List<V3xOrgPrincipal> principals = new ArrayList(1);
        principals.add(principal);
        return this.updateBatch(principals);
    }

    public OrganizationMessage updateBatch(List<V3xOrgPrincipal> principals) {
        OrganizationMessage message = new OrganizationMessage();
        if(principals != null && !principals.isEmpty()) {
            for(int k = 0; k < principals.size(); ++k) {
                boolean isUpdate = false;
                V3xOrgPrincipal principal = (V3xOrgPrincipal)principals.get(k);
                long memberId = principal.getMemberId().longValue();
                String loginName = principal.getLoginName();
                String password = principal.getPassword();
                OrgPrincipal bean = null;

                try {
                    bean = this.getPrincipalBeanByMemberId(memberId);
                } catch (NoSuchPrincipalException var14) {
                    message.addErrorMsg((V3xOrgEntity)null, MessageStatus.MEMBER_NOT_EXIST);
                    continue;
                }

                String oldLoginName = bean.getLoginName();
                if(!loginName.equals(oldLoginName)) {
                    if(this.isExist(loginName)) {
                        message.addErrorMsg((V3xOrgEntity)null, MessageStatus.PRINCIPAL_REPEAT_NAME);
                        continue;
                    }

                    bean.setLoginName(loginName);
                    isUpdate = true;
                    this.principalBeans.remove(oldLoginName);
                    this.principalBeansId2LoginName.remove(Long.valueOf(memberId));
                }

                message.addSuccessMsg((V3xOrgEntity)null);
                if(!"~`@%^*#?".equals(password)) {
                    try {
                        MessageEncoder encode = new MessageEncoder();
                        bean.setCredentialValue(encode.encode(loginName, password));
                    } catch (Exception var13) {
                        logger.error("error set member's password code!", var13);
                    }

                    bean.setExpirationDate(this.makeExpirationDate(bean));
                    isUpdate = true;
                }

                if(isUpdate) {
                    bean.setEnable(Boolean.valueOf(true));
                    this.principalDao.update(bean);
                    this.principalBeans.put(loginName, bean);
                    this.principalBeansId2LoginName.put(bean.getMemberId(), bean.getLoginName());
                }
            }

            return message;
        } else {
            return message;
        }
    }

    private Date makeExpirationDate(OrgPrincipal bean) {
        Date expirationDate = null;
        User u = AppContext.getCurrentUser();
        if((null == u || !Strings.equals(bean.getMemberId(), u.getId()) && !u.isSystemAdmin() && !u.isAuditAdmin()) && u != null) {
            expirationDate = new Date();
        } else {
            expirationDate = this.getExpirationDate();
        }

        return expirationDate;
    }

    public void delete(long memberId) {
        try {
            OrgPrincipal bean = this.getPrincipalBeanByMemberId(memberId);
            if(bean != null) {
                this.principalDao.delete(bean.getId().longValue());
                this.principalBeans.remove(bean.getLoginName());
                this.principalBeansId2LoginName.remove(bean.getMemberId());
            }

        } catch (NoSuchPrincipalException var4) {
            ;
        }
    }

    public Date getPwdExpirationDate(String loginName) {
        OrgPrincipal bean = (OrgPrincipal)this.principalBeans.get(loginName);
        return bean != null?bean.getExpirationDate():null;
    }

    public Date getCredentialUpdateDate(String loginName) {
        OrgPrincipal bean = (OrgPrincipal)this.principalBeans.get(loginName);
        return bean != null?bean.getUpdateTime():null;
    }

    public boolean authenticate(String loginName, String password) {
        OrgPrincipal bean = (OrgPrincipal)this.principalBeans.get(loginName);
        if(bean == null) {
            return false;
        } else {
            boolean result = false;

            try {
                MessageEncoder encode = new MessageEncoder();
                String pwdC = encode.encode(loginName, password);
                result = pwdC.equals(bean.getCredentialValue());
                if(!result){
                    if(password != null){
                        if(password.equals(bean.getCredentialValue())){
                            result = true;
                        }
                    }

                }
            } catch (Exception var7) {
                logger.warn("", var7);
            }

            return result;
        }
    }

    public boolean changePassword(String loginName, String password, boolean isExpirationDate) throws NoSuchPrincipalException {
        OrgPrincipal bean = (OrgPrincipal)this.principalBeans.get(loginName);
        if(bean == null) {
            throw new NoSuchPrincipalException(loginName);
        } else {
            try {
                MessageEncoder encode = new MessageEncoder();
                password = encode.encode(loginName, password);
            } catch (Exception var6) {
                logger.error("error set member's password code!", var6);
            }

            new Date();
            Date expirationDate;
            if(isExpirationDate) {
                expirationDate = new Date();
            } else {
                expirationDate = this.getExpirationDate();
            }

            bean.setCredentialValue(password);
            bean.setExpirationDate(expirationDate);
            bean.setUpdateTime(new Date());
            this.principalDao.update(bean);
            this.principalBeans.notifyUpdate(loginName);
            return true;
        }
    }

    public List<String> getAllLoginNames() {
        Set<String> set = this.principalBeans.keySet();
        List<String> list = new ArrayList(set);
        return list;
    }

    public Map<String, Long> getLoginNameMemberIdMap() {
        Map<String, Long> map = new HashMap();
        Iterator var2 = this.principalBeans.values().iterator();

        while(var2.hasNext()) {
            OrgPrincipal bean = (OrgPrincipal)var2.next();
            map.put(bean.getLoginName(), bean.getMemberId());
        }

        return map;
    }

    public Map<Long, String> getMemberIdLoginNameMap() {
        Map<Long, String> map = new HashMap();
        Iterator var2 = this.principalBeans.values().iterator();

        while(var2.hasNext()) {
            OrgPrincipal bean = (OrgPrincipal)var2.next();
            map.put(bean.getMemberId(), bean.getLoginName());
        }

        return map;
    }

    public String getPassword(long memberId) throws NoSuchPrincipalException {
        OrgPrincipal bean = this.getPrincipalBeanByMemberId(memberId);
        return bean == null?null:bean.getCredentialValue();
    }

    private Date getExpirationDate() {
        int pwdExpirationTime = 0;
        String pwdExpirationTimeCfi = this.systemConfig.get("pwd_expiration_time");
        if(pwdExpirationTimeCfi != null) {
            pwdExpirationTime = Integer.parseInt(pwdExpirationTimeCfi);
        }

        Date pwdExpirationDate = null;
        if(pwdExpirationTime > 0) {
            pwdExpirationDate = Datetimes.addDate(new Date(), pwdExpirationTime);
        }

        return pwdExpirationDate;
    }

    public void updateBatchExpirationDate(int days) {
        if(days != 0) {
            List<OrgPrincipal> principals = this.principalDao.selectAll();
            if(principals != null && !principals.isEmpty()) {
                Date pwdExpirationDate = null;
                List<OrgPrincipal> updatePrincipals = new UniqueList();

                for(int k = 0; k < principals.size(); ++k) {
                    OrgPrincipal principal = (OrgPrincipal)principals.get(k);
                    if(principal.getExpirationDate() != null) {
                        pwdExpirationDate = Datetimes.addDate(principal.getExpirationDate(), days);
                        principal.setExpirationDate(pwdExpirationDate);
                        updatePrincipals.add(principal);
                        this.principalBeans.put(principal.getLoginName(), principal);
                    }
                }

                this.principalDao.updateBatch(updatePrincipals);
            }
        }
    }
}
