package com.seeyon.v3x.system.signet.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.v3x.system.signet.domain.V3xHtmDocumentSignature;

public class V3xHtmDocumentSignatureDao extends BaseHibernateDao<V3xHtmDocumentSignature> {
	
	/**
	 * 
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月7日下午1:39:43
	 * @param summaryId
	 * @param policy
	 * @param signType: V3xHtmSignatureEnum类型的key值
	 * @return
	 */
	@SuppressWarnings("unchecked")
    public List <V3xHtmDocumentSignature> findBySummaryIdPolicyAndType(Long summaryId,String policy, int signType){
	    String hsql="from V3xHtmDocumentSignature where summaryId=? and fieldName=? and signetType=?";
        return super.findVarargs(hsql, new Object[]{summaryId,policy, signType});
	}

	/**
     * 
     * @Description : 通过summaryId和signType获取签名信息
     * @Author      : xuqiangwei
     * @Date        : 2014年11月14日上午10:34:44
     * @param summaryId
     * @param signType
     * @return
     */
	public List<V3xHtmDocumentSignature> findBySummaryIdAndType(Long summaryId, int signType){
	    
	    String hql="from V3xHtmDocumentSignature where summaryId =:summaryId and signetType=:_type";
        Map<String,Object> parameter = new HashMap<String,Object>();
        parameter.put("summaryId", summaryId);
        parameter.put("_type", signType);
        @SuppressWarnings("unchecked")
        List<V3xHtmDocumentSignature> ls = (List<V3xHtmDocumentSignature>)super.find(hql, parameter);
        return ls;
	}
	
	/**
	 * 通过summaryId获取签名信息
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月29日上午11:15:52
	 * @param summaryId
	 * @return
	 */
    public List<V3xHtmDocumentSignature> findBySummaryId(Long summaryId){
        
        String hql="from V3xHtmDocumentSignature where summaryId =:summaryId";
        Map<String,Object> parameter = new HashMap<String,Object>();
        parameter.put("summaryId", summaryId);
        @SuppressWarnings("unchecked")
        List<V3xHtmDocumentSignature> ls = (List<V3xHtmDocumentSignature>)super.find(hql, parameter);
        return ls;
    }
	
	/**
	 * 通过SummaryID和类型删除签批数据
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月7日下午1:35:08
	 * @param summaryId
	 * @param signType: V3xHtmSignatureEnum类型的key值
	 */
	public void deleteBySummaryIdAndType(Long summaryId, int signType){
	    String hql = "delete from V3xHtmDocumentSignature as ds where ds.summaryId=? and ds.signetType=?";
        super.bulkUpdate(hql, null, new Object[] { summaryId, signType});
	}
	
	/**
     * 
     * @Description : 通过SummaryID删除签名或印章信息
     * @Author      : xuqiangwei
     * @Date        : 2014年11月14日上午10:59:44
     * @param summaryId
     */
    public void deleteBySummaryId(Long summaryId){
        String hql = "delete from V3xHtmDocumentSignature as ds where ds.summaryId=?";
        super.bulkUpdate(hql, null, new Object[] { summaryId});
    }
	
	/**
	 * 通过affairId获取签名信息
	 * @Date        : 2014年11月7日下午1:31:51
	 * @param affairId
	 * @return
	 */
	public V3xHtmDocumentSignature getByAffairId(Long affairId) {
	    String hql="from V3xHtmDocumentSignature where affairId =:_affairId";
        Map<String,Object> parameter = new HashMap<String,Object>();
        parameter.put("_affairId", affairId);
        List<V3xHtmDocumentSignature> ls=(List<V3xHtmDocumentSignature>)super.find(hql, parameter);
        if(Strings.isNotEmpty(ls)){
            return (V3xHtmDocumentSignature)ls.get(0);
        }
        return null;
	}
	
	/**
	 * 通过affaire和类型获取签名
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月7日下午1:28:58
	 * @param affairId : 事项ID
	 * @param signType : V3xHtmSignatureEnum类型的key值
	 * @return
	 */
	public V3xHtmDocumentSignature getByAffairIdAndType(Long affairId, int signType) {
	    String hql="from V3xHtmDocumentSignature where affairId =:_affairId and signetType=:_type";
        Map<String,Object> parameter = new HashMap<String,Object>();
        parameter.put("_affairId", affairId);
        parameter.put("_type", signType);
        List<V3xHtmDocumentSignature> ls=(List<V3xHtmDocumentSignature>)super.find(hql, parameter);
        if(Strings.isNotEmpty(ls)){
            return (V3xHtmDocumentSignature)ls.get(0);
        }
        return null;
	}
	
	/**
	 * 通过SummaryID,affairId和类型 获取签批图片
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月7日下午1:43:24
	 * @param summaryId
	 * @param affairId
	 * @param signType: V3xHtmSignatureEnum类型的key值
	 * @return
	 */
	public V3xHtmDocumentSignature getBySummaryIdAffairIdAndType(Long summaryId, Long affairId, int signType){
	    String hql="from V3xHtmDocumentSignature where summaryId=:_summaryId and affairId =:_affairId and signetType=:_type";
        Map<String,Object> parameter = new HashMap<String,Object>();
        parameter.put("_affairId", affairId);
        parameter.put("_type", signType);
        parameter.put("_summaryId", summaryId);
        List<V3xHtmDocumentSignature> ls=(List<V3xHtmDocumentSignature>)super.find(hql, parameter);
        if(Strings.isNotEmpty(ls)){
            return (V3xHtmDocumentSignature)ls.get(0);
        }
        return null;
	}
	
	/**
	 * 删除edocSummary具体事项的签名方式
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月7日下午3:15:28
	 * @param summaryId
	 * @param affairId
	 * @param signType
	 */
	public void deleteBySummaryIdAffairIdAndType(Long summaryId, Long affairId, int signType){
	    String hql = "delete from V3xHtmDocumentSignature as ds where ds.summaryId=? and ds.signetType=? and affairId =?";
        super.bulkUpdate(hql, null, new Object[] { summaryId, signType, affairId});
	}
	
	/**
	 * 批量删除指定summary的电子签章
	 * @Author      : xuqiangwei
	 * @Date        : 2014年11月17日下午5:11:35
	 * @param summaryId
	 * @param affairIds
	 * @param signType
	 */
	public void deleteBySummaryIdAffairsAndType(Long summaryId, List<Long> affairIds, int signType){
	    String hql = "delete from V3xHtmDocumentSignature as ds where ds.summaryId=:_summaryId and ds.signetType=:_type and affairId in (:_affairIds)";
	    Map<String,Object> parameter = new HashMap<String,Object>();
        parameter.put("_affairIds", affairIds);
        parameter.put("_type", signType);
        parameter.put("_summaryId", summaryId);
	    super.bulkUpdate(hql, parameter);
	}
	
	public List<V3xHtmDocumentSignature> getByFieldName(String fieldName) {
		String hql="from V3xHtmDocumentSignature where fieldName =:fieldName";
        Map<String,Object> parameter = new HashMap<String,Object>();
        parameter.put("fieldName", fieldName);
        @SuppressWarnings("unchecked")
        List<V3xHtmDocumentSignature> ls = (List<V3xHtmDocumentSignature>)super.find(hql, parameter);
        return ls;
	}
	
	public void deleteBySummaryIdAndTypeAndUserName(Long summaryId, int signType,String userName){
	    String hql = "delete from V3xHtmDocumentSignature as ds where ds.summaryId=? and ds.signetType=? and ds.userName=?";
        super.bulkUpdate(hql, null, new Object[] { summaryId, signType,userName});
	}
}
