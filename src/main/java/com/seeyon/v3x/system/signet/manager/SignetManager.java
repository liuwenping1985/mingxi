package com.seeyon.v3x.system.signet.manager;

import java.util.List;
import java.util.Map;

import com.seeyon.v3x.system.signet.domain.V3xDocumentSignature;
import com.seeyon.v3x.system.signet.domain.V3xHtmDocumentSignature;
import com.seeyon.v3x.system.signet.domain.V3xSignet;

public interface SignetManager {

	// 获取全部信息
	public java.util.List<com.seeyon.v3x.system.signet.domain.V3xSignet> findAll()
			throws Exception;
	
	// 更具单位ID获取信息
	public java.util.List<com.seeyon.v3x.system.signet.domain.V3xSignet> findAllAccountID(Long accountID)
	throws Exception;

	// 添加印章数据
	public void save(com.seeyon.v3x.system.signet.domain.V3xSignet signet)
			throws Exception;
	
	
	//保存印章记录
	public void save(V3xDocumentSignature v3xDocumentSignature)	throws Exception;

	public void deleteByRecordId(String recordId);

	// 修改数据
	public void update(com.seeyon.v3x.system.signet.domain.V3xSignet signet)
			throws Exception;

	// 删除数据
	public void deleteSignet(long id) throws Exception;

	// 通过 ID 获取数据
	public com.seeyon.v3x.system.signet.domain.V3xSignet getSignet(Long id);

	//获取指定文档上面的签章信息
	public java.util.List<com.seeyon.v3x.system.signet.domain.V3xDocumentSignature> findDocumentSignatureByDocumentId(String docId)	throws Exception;
	
	//获取指定用户的印章信息
	public com.seeyon.v3x.system.signet.domain.V3xSignet findByMarknameAndPassword(String markname,String pwd, String affairMemberId);
	//复制印章数据,用于转发后印章有效性验证
	//检查是否已经复制过,没有复制过复制
	public boolean insertSignet(Long srcContentId,Long newContentId);
	
    /**
     * 得到某人印章
     * @param memberId
     * @return
     * @throws Exception
     */
    public List<V3xSignet> findSignetByMemberId(Long memberId);
    
    /**
     * 判断某人是否有印章
     * @param memberId
     * @return
     * @throws Exception
     */
    public boolean hasSignet(Long memberId);
    
    /**
     * 清除指定人员的印章授权。
     * @param memberId
     * @throws Exception 
     */
    void clearSignet(long memberId) throws Exception;
    
    /**
     * 判断印章markName是否重复
     * @param markName
     * @return
     * @throws Exception
     */
    public boolean checkMarknameIsDuple(String markName);
    public boolean checkMarknameIsDupleInAccountScope(String markName);
    /**
     * 删除某个单位下面所以的印章。
     * @param accountId
     */
    public void deleteByAccountId(Long accountId);
    
    /*
     * 按单位id查找印章
     */
    public java.util.List<com.seeyon.v3x.system.signet.domain.V3xSignet> findAllByAccountId(Long accountId)
	throws Exception;

    public boolean saveSignets(Map<String, Object> params) throws Exception;
    
    /**
	 * 根据ID和密码取印章
	 * @param markId 印章ID
	 * @param pwd 印章密码
	 * @param affairMemberId
	 * @return
	 */
	public V3xSignet findByIdAndPassword(String markId,String pwd,String affairMemberId);

}
