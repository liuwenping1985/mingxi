package com.seeyon.ctp.organization.manager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.MemberPost;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgSecondPost;
import com.seeyon.ctp.util.FlipInfo;

/**
 * <p>Title: 人员兼职管理信息业务层接口</p>
 * <p>Description: 提供兼职管理外部功能的Manager接口</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 * @author lilong
 */
public interface ConcurrentPostManager {

    /**
     * 兼职到本单位关系列表
     * @param fi
     * @param params
     * @return
     * @throws BusinessException
     */
    FlipInfo list4in(final FlipInfo fi, final Map params) throws BusinessException;

    /**
     * 兼职到外单位的兼职列表
     * @param fi
     * @param params
     * @return
     * @throws BusinessException
     */
    FlipInfo list4out(final FlipInfo fi, final Map params) throws BusinessException;

    /**
     * 管理兼职关系列表
     * @param fi
     * @param params
     * @return
     * @throws BusinessException
     */
    FlipInfo list4Manager(final FlipInfo fi, final Map params) throws BusinessException;
    
    /**
     * 副岗列表
     * @param fi
     * @param params
     * @return
     * @throws BusinessException
     */
    FlipInfo list4SecondPost(final FlipInfo fi, final Map params) throws BusinessException;

    /**
     * 子单位兼职管理
     * @param fi
     * @param params
     * @return
     * @throws BusinessException
     */
    FlipInfo list4SubUnitManage(final FlipInfo fi, final Map params) throws BusinessException;
    
    /**
     * 修改兼职关系
     * @param map
     * @return 兼职关系id
     * @throws BusinessException
     */
    void updateOne(Map map) throws BusinessException;

    /**
     * 创建一个兼职关系
     * @param map
     * @return 新建兼职关系的id
     * @throws BusinessException
     */
    void createOne(Map map) throws BusinessException;

    /**
     * 删除兼职关系
     * @param ids
     * @return  异常信息
     * @throws BusinessException
     */
    Map<String,Object> delConPosts(Long[] ids) throws BusinessException;
    
    /**
     * 查看兼职信息
     * @param relId
     * @return
     * @throws BusinessException
     */
    HashMap viewOne(Long relId) throws BusinessException;
    
    /**
     * 根据人员id获取主岗名称
     * @param memberId 人员id
     * @return 主岗名称
     * @throws BusinessException
     */
    HashMap<String, String> getPriPostNameByMemberId(Long memberId) throws BusinessException;
    
    /**
     * 为批量添加增加的接口，检验选中的人员的单位和要兼职的单位是否相同
     * @param memberIds 多个人员id字符串
     * @param accountIds 多个单位id字符串
     * @return false 有交集，有重复；true 无交集，无重复
     */
    boolean checkBatConpostAccount(String memberIds, String accountIds) throws BusinessException;
    
    Map<Long, List<MemberPost>> getSecondPostMap(Long accountId, Map params) throws BusinessException;
    
    List<WebV3xOrgSecondPost> dealSecondPostInfo(Map<Long, List<MemberPost>> resultMap) throws BusinessException;
    /**
     * 查询属于当前登录单位及其子单位下的单位ID
     * @return
     * @throws BusinessException
     */
    String getIncludeUnitIds() throws BusinessException;
    /**
     * 验证兼职记录是否可修改
     * @param relId
     * @return
     * @throws BusinessException
     */
    Map<String,Object> checkCanModify(Long relId) throws BusinessException;
    /**
     * 检查是否可以删除
     * @param relId
     * @return
     * @throws BusinessException
     */
    String checkCanDel(Long relId) throws BusinessException;
    /**
     * 允许父单位管理其所有子单位的兼职
     * @param switchOn
     * @throws BusinessException
     */
    void conPostSwitch(Boolean switchOn) throws BusinessException;
    
    boolean canSubunitManageConPost() throws BusinessException;
    
    // 客开设置虚拟集团管理员角色
    void setVirtualGroupAccountId(Long virtualGroupAccountId);
    
}
