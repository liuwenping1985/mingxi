package com.seeyon.ctp.organization.manager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgAccount;
import com.seeyon.ctp.util.FlipInfo;

public interface AccountManager {

    FlipInfo showAccounts(final FlipInfo fi, final Map params) throws BusinessException;
    
    FlipInfo loadParent(final FlipInfo fi, final Map params) throws BusinessException;
    
    Long updateAcc(Map map) throws BusinessException;
    
    Long updateAcc4Admin(Map map) throws BusinessException;
    
    HashMap viewAccount(Long accountId) throws BusinessException;
    
    Long createAcc(Map map) throws BusinessException;

    Boolean delAccounts(Long[] ids) throws BusinessException;
    
    /**
     * 获取集团所有内部单位的最大排序号
     * @param accountId
     * @return
     * @throws BusinessException
     */
    Integer getMaxSort() throws BusinessException;
    
    /**
     * 改造单位管理的单位树变为异步的树
     */
    List<WebV3xOrgAccount> showAccountTree(Map params) throws BusinessException;
    
    /**
     * 判断当前ldap是否启动
     * @return
     */
    boolean isEnableLdap();

    /**
     * 获取所有的集团自定义的单位角色
     * @param accountId
     * @return
     * @throws Exception
     */
	HashMap getAccountCustomerRoles(Long accountId) throws Exception;
	
	// 客开 设置虚拟管理角色
	void setVirtualAccAdmin(String virtualAccAdmin);
}
