package com.seeyon.v3x.system.signet.manager;

import java.util.List;

import com.seeyon.v3x.system.signet.domain.V3xHtmDocumentSignature;

public interface V3xHtmDocumentSignatManager {
    
	/**
	 * 更新签批对象
	 * @param htmSignate
	 */
	public void update(V3xHtmDocumentSignature htmSignate);
	
	/**
	 * 
	 * @Description : 保存签名或印章
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月14日上午10:25:19
	 * @param htmSignate
	 */
	public void save(V3xHtmDocumentSignature htmSignate);
	
	/**
	 * 根据affairId取到签批对象
	 * @param affairId
	 * @return
	 */
	public V3xHtmDocumentSignature getByAffairId(Long affairId);
	
	/**
	 * 
	 * @Description : 通过summaryId，policy和signType获取签名或印章信息
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月14日上午10:15:37
	 * @param summaryId
	 * @param policy
	 * @param signType
	 * @return
	 */
	public List<V3xHtmDocumentSignature> findBySummaryIdPolicyAndType(Long summaryId,String policy, int signType);
	
	/**
	 * 
	 * @Description : 通过summaryId和signType获取签名或印章信息
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月14日上午10:34:44
	 * @param summaryId
	 * @param signType
	 * @return
	 */
	public List<V3xHtmDocumentSignature> findBySummaryIdAndType(Long summaryId, int signType);
	
	/**
	 * 通过SummaryID获取全部的签名或印章信息
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月29日上午11:13:13
	 * @param summaryId
	 * @return
	 */
	public List<V3xHtmDocumentSignature> findBySummaryId(Long summaryId);
	
	/**
	 * 
	 * @Description : 根据签名或印章ID查询签名或印章
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月14日上午10:41:48
	 * @param id
	 * @return
	 */
	public V3xHtmDocumentSignature getById(Long id);
	
	/**
     * 通过SummaryID,affairId和类型 获取签批图片
     * @Author      : xuqiangwei
     * @Date        : 2014年11月7日下午1:43:24
     * @param summaryId
     * @param affairId
     * @param signType: V3xHtmSignatureEnum类型的key值
     * @return
     */
	public V3xHtmDocumentSignature getBySummaryIdAffairIdAndType(Long summaryId, Long affairId, int signType);
	
	/**
     * 删除edocSummary具体事项的签名或印章方式
     * @Author      : xuqiangwei
     * @Date        : 2014年11月7日下午3:15:28
     * @param summaryId
     * @param affairId
     * @param signType
     */
    public void deleteBySummaryIdAffairIdAndType(Long summaryId, Long affairId, int signType);
    
    
    /**
     * 
     * @Description : 通过SummaryID和type删除签名或印章信息
     * @Author      : xuqiangwei
     * @Date        : 2014年11月14日上午10:56:16
     * @param summaryId
     * @param signType
     */
    public void deleteBySummaryIdAndType(Long summaryId, int signType);
    
    /**
     * 
     * @Description : 通过SummaryID删除签名或印章信息
     * @Author      : xuqiangwei
     * @Date        : 2014年11月14日上午10:59:44
     * @param summaryId
     */
    public void deleteBySummaryId(Long summaryId);
    
    /**
     * 批量删除指定summary的电子签章
     * @Author      : xuqiangwei
     * @Date        : 2014年11月17日下午5:11:35
     * @param summaryId
     * @param affairIds
     * @param signType
     */
    public void deleteBySummaryIdAffairsAndType(Long summaryId, List<Long> affairIds, int signType);
    
    /***
     * 根据文件名取签批
     * @param fieldName
     * @return
     */
    public List<V3xHtmDocumentSignature> getByFieldName(String fieldName);
    
    public void deleteBySummaryIdAndTypeAndUserName(Long summaryId, int signType,String userName);
}
