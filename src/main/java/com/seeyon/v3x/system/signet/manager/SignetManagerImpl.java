package com.seeyon.v3x.system.signet.manager;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import DBstep.iMsgServer2000;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.cache.CacheAccessable;
import com.seeyon.ctp.common.cache.CacheFactory;
import com.seeyon.ctp.common.cache.CacheMap;
import com.seeyon.ctp.common.cache.loader.AbstractMapDataLoader;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.office.HtmlHandWriteManager;
import com.seeyon.ctp.common.office.MSignatureManager;
import com.seeyon.ctp.common.office.MSignaturePicHandler;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.TextEncoder;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.common.web.login.CurrentUser;
import com.seeyon.v3x.system.signet.dao.DocumentSignatureDao;
import com.seeyon.v3x.system.signet.dao.SignetDao;
import com.seeyon.v3x.system.signet.domain.V3xDocumentSignature;
import com.seeyon.v3x.system.signet.domain.V3xHtmDocumentSignature;
import com.seeyon.v3x.system.signet.domain.V3xSignet;

public class SignetManagerImpl implements SignetManager {
	private static Log log = LogFactory.getLog(SignetManagerImpl.class);
	private SignetDao signetDao;
	
	private DocumentSignatureDao documentSignatureDao;
	private MSignatureManager mSignatureManagerforM3;
	private HtmlHandWriteManager htmlHandWriteManager;
	
	/**
	 * 加密说明：字段password、markBody是加密的
	 */
	private CacheMap<Long,V3xSignet> allV3xSignet = null;
	
	private OrgManager orgManager;
	
	public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }
	
	public void setDocumentSignatureDao(DocumentSignatureDao documentSignatureDao) {
		this.documentSignatureDao=documentSignatureDao;
	}
	
	public void setSignetDao(SignetDao signetDao) {
		this.signetDao = signetDao;
	}
	public HtmlHandWriteManager getHtmlHandWriteManager() {
		return htmlHandWriteManager;
	}

	public void setHtmlHandWriteManager(HtmlHandWriteManager htmlHandWriteManager) {
		this.htmlHandWriteManager = htmlHandWriteManager;
	}
	
	public MSignatureManager getmSignatureManagerforM3() {
		return mSignatureManagerforM3;
	}

	public void setmSignatureManagerforM3(MSignatureManager mSignatureManagerforM3) {
		this.mSignatureManagerforM3 = mSignatureManagerforM3;
	}
	/**
	 * 加载所有印章管理
	 */
	public void init() {
		CacheAccessable cacheFactory = CacheFactory.getInstance(SignetManager.class);
		allV3xSignet = cacheFactory.createLinkedMap("allV3xSignet");
		allV3xSignet.setDataLoader(new AbstractMapDataLoader<Long, V3xSignet>(allV3xSignet) {
			@Override
			protected Map<Long, V3xSignet> loadLocal() {
				List<V3xSignet> temp = signetDao.findAll();
				Map<Long,V3xSignet> map = new HashMap<Long,V3xSignet>();
				if(!temp.isEmpty()){
					for (V3xSignet sig : temp) {
						map.put(sig.getId(), sig);
					}
				}
				return map;
			}

			@Override
			protected V3xSignet loadLocal(Long k) {
				return signetDao.getSignet(k);
			}
		});
		allV3xSignet.reload();
	}

	public void deleteSignet(long id) {
		signetDao.delete(id);
		allV3xSignet.remove(id);
/*		V3xSignet temp = getSignet(id);
		if(temp != null){
			allV3xSignet.remove(temp);
		}*/
	}

	public List<V3xSignet> findAll() throws Exception {
		List<V3xSignet> result = new ArrayList<V3xSignet>(allV3xSignet.size());
		for (V3xSignet sig : allV3xSignet.values()) {
			result.add(sig);
		}
		return result;
	}
	
	
	public void deleteByAccountId(Long accountId){
		signetDao.deleteByAccountId(accountId);
	}

	public void save(V3xSignet signet) throws Exception {
		signetDao.create(signet);
		allV3xSignet.put(signet.getId(),signet);
	}
	
	public void save(V3xDocumentSignature v3xDocumentSignature)	throws Exception {
		documentSignatureDao.save(v3xDocumentSignature);
	}

	public void deleteByRecordId(String recordId) {
		documentSignatureDao.deleteByRecordId(recordId);
	}

	public void update(V3xSignet signet) throws Exception {
		signetDao.update(signet);
		allV3xSignet.notifyUpdate(signet.getId());
	}

	public V3xSignet getSignet(Long id) {
		return allV3xSignet.get(id);
/*		for (int i = 0; i < allV3xSignet.size(); i++) {
			V3xSignet temp = allV3xSignet.get(i);
			if(temp.getId().equals(id)){
				return temp;
			}
		}
		
		return null;*/
	}

	/**
	 * 通过 AJAX 进行密码判断
	 * @param id
	 * @param oldPassword 原密码，明文
	 * @param isOnlyEnable
	 * @return
	 */
	public int getSignet(long id, String oldPassword, boolean isOnlyEnable) {
		if (isOnlyEnable == true) {
			V3xSignet signet = this.getSignet(id);
			if(signet != null && !oldPassword.equals(TextEncoder.decode(signet.getPassword()))){
				return 0;
			}
		}
		
		return 1;
	}
		
	//	获取指定文档上面的签章信息
	public java.util.List<V3xDocumentSignature> findDocumentSignatureByDocumentId(String docId)	throws Exception
	{
		return documentSignatureDao.findByRecordId(docId);
	}
	
	public V3xSignet findByMarknameAndPassword(String markname,String pwd,String affairMemberId) {
		Long currentUserId=CurrentUser.get().getId();
		Long memberId = 0L;
		if(Strings.isBlank(affairMemberId)){
			memberId = currentUserId;
		}else{
			memberId=Long.valueOf(affairMemberId);
		}
		for (V3xSignet temp : allV3xSignet.values()) {
			if(null!=temp.getOrgAccountId() && 
			   null!=temp.getMarkName() && temp.getMarkName().equals(markname) &&
			   null!=temp.getPassword()	&& TextEncoder.decode(temp.getPassword()).equals(pwd)&& 
			   String.valueOf(memberId).equals(temp.getUserName())){
				 return temp;
			}
		}
		
		return null;
	}

	public List<V3xSignet> findAllAccountID(Long accountID) throws Exception {
		List<V3xSignet> result = new ArrayList<V3xSignet>();
/*		for (int i = 0; i < allV3xSignet.size(); i++) {
			V3xSignet temp = allV3xSignet.get(i);
			if(temp.getOrgAccountId().equals(accountID)){
				result.add(temp);
			}
		}*/
		for (V3xSignet temp : allV3xSignet.values()) {
			if(temp.getOrgAccountId().equals(accountID)){
				result.add(temp);
			}		
		}		
		return result;
	}

	public boolean insertSignet(Long srcContentId,Long newContentId)
	{
		if(srcContentId==null || newContentId==null){return false;}
		try{
			java.util.List<V3xDocumentSignature> sl=findDocumentSignatureByDocumentId(srcContentId.toString());
			if(sl.size()<=0){return true;}//没有印章不需要复制
			java.util.List<V3xDocumentSignature> slNew=findDocumentSignatureByDocumentId(newContentId.toString());
			if(slNew.size()>0){return true;}//印章已经复制过
			for(V3xDocumentSignature ds:sl)
			{
				V3xDocumentSignature tempDs=new V3xDocumentSignature();
				tempDs.setIdIfNew();
				tempDs.setHostname(ds.getHostname());
				tempDs.setMarkguid(ds.getMarkguid());
				tempDs.setMarkname(ds.getMarkname());
				tempDs.setRecordId(newContentId.toString());
				tempDs.setSignDate(ds.getSignDate());
				tempDs.setUsername(ds.getUsername());
				documentSignatureDao.save(tempDs);
			}			
		}catch(Exception e)
		{
			return false;
		}
		return true;
	}

    /**
     * 得到某人印章
     * @param memberId
     * @return
     * @throws Exception
     */
    public List<V3xSignet> findSignetByMemberId(Long memberId) {
		List<V3xSignet> result = new ArrayList<V3xSignet>();
		for (V3xSignet temp : allV3xSignet.values()) {
			if(temp.getUserName()==null)continue;
			if(temp.getUserName().equals(memberId.toString())){
				result.add(temp);
			}
		}		
		return result;
    }
    
    /**
     * 判断某人是否有印章
     * @param memberId
     * @return
     * @throws Exception
     */
    public boolean hasSignet(Long memberId){
/*		for (int i = 0; i < allV3xSignet.size(); i++) {
			V3xSignet temp = allV3xSignet.get(i);
			if(temp.getUserName().equals(memberId.toString())){
				return true;
			}
		}*/
    	if(memberId==null) return false;
		for (V3xSignet temp : allV3xSignet.values()) {
			if(temp.getUserName()==null) continue;
			if(temp.getUserName().equals(memberId.toString())){
				return true;
			}
		}	
		return false;
    }
	@Override
	public void clearSignet(long memberId) throws Exception {
		for (V3xSignet sig : allV3xSignet.values()) {
			if(sig.getUserName()==null) continue;
			if(sig.getUserName().equals(memberId+"")){
				sig.setUserName("");
				sig.setPassword("");
				update(sig);
			}
		}	
	}   
    public boolean checkMarknameIsDuple(String markName) {
/*		for (int i = 0; i < allV3xSignet.size(); i++) {
			V3xSignet temp = allV3xSignet.get(i);
			if(temp.getMarkName().equals(markName)){
				return true;
			}
		}*/
		for (V3xSignet temp : allV3xSignet.values()) {
			if(temp.getMarkName().equals(markName)){
				return true;
			}
		}			
		return false;
    }
    public boolean checkMarknameIsDupleInAccountScope(String markName,Long orgAccountId) {
		for (V3xSignet temp : allV3xSignet.values()) {
			if(temp.getMarkName().equals(markName)
					&& temp.getOrgAccountId().equals(orgAccountId)){
				return true;
			}
		}			
		return false;
    }

	/**
	 * 
	 * 方法描述： ajax方法，判断是否被取消了权限
	 *
	 */
	public boolean ajaxIsCancelled(String id){
		V3xSignet signet = this.getSignet(Long.parseLong(id));
		//if(signet != null && signet.getUserName().equals(String.valueOf(CurrentUser.get().getId()))){
		if(signet != null && signet.getUserName().equals(String.valueOf(CurrentUser.get().getId()))){

			return true;
		}
		
		return false;
	}

	@Override
	public boolean checkMarknameIsDupleInAccountScope(String markName) {
		// TODO Auto-generated method stub
		return false;
	}

	
	public List<V3xSignet> findAllByAccountId(Long accountId) throws Exception {
		List<V3xSignet> result = new ArrayList<V3xSignet>(allV3xSignet.size());
		for (V3xSignet sig : allV3xSignet.values()) {
			if(sig.getOrgAccountId().equals(accountId)){
				result.add(sig);
			} 
		}
		return result;
	}
	/**
	 * 批量保存签章数据
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public boolean saveSignets(Map<String, Object> params) throws Exception {
		try{
			String _isNewImg= ParamUtil.getString(params, "isNewImg");
			boolean isNewImg=false;
			String affairId = "";
	        if(Strings.isNotBlank(_isNewImg)){
	        	isNewImg=Boolean.valueOf(_isNewImg);
	        }
	        if(isNewImg){
	        	affairId= ParamUtil.getString(params, "affairId");
	        }
			String qianpiData = ParamUtil.getString(params, "qianpiData");
			mSignatureManagerforM3.transSaveSignatureAndHistory(qianpiData,affairId,String.valueOf(isNewImg));
		}catch(Exception e)	{
			log.error("保存签批报错", e);
			return false;
		}
		return true;
	}
	
	public V3xSignet findByIdAndPassword(String markId,String pwd,String affairMemberId) {
		Long currentUserId=CurrentUser.get().getId();
		Long memberId = 0L;
		if(Strings.isBlank(affairMemberId)){
			memberId = currentUserId;
		}else{
			memberId=Long.valueOf(affairMemberId);
		}
		for (V3xSignet temp : allV3xSignet.values()) {
			if(null!=temp.getOrgAccountId() && 
			   null!=temp.getId() && temp.getId().toString().equals(markId) &&
			   null!=temp.getPassword()	&& TextEncoder.decode(temp.getPassword()).equals(pwd)
					&& String.valueOf(memberId).equals(temp.getUserName())){
				return temp;
			}
		}
		
		return null;
	}
	/**
	 * 给表单提供的签章数据批量保存的接口
	 */
	/*@Override
	public boolean saveSignets2Form(boolean isNewImg,List<V3xHtmDocumentSignature> list) throws Exception {
		HttpServletRequest request = AppContext.getRawRequest();
		try{
			if(!isNewImg && list!=null){
				for(V3xHtmDocumentSignature signature:list){
					String recordID = String.valueOf(signature.getSummaryId());
	                String fieldName = signature.getFieldName();
	                User user = AppContext.getCurrentUser();
	                String fieldValue = "";
	                try {
	                    fieldValue = MSignaturePicHandler.encodeSignatureDataForJINGE(signature.getFieldValue());
	                } catch (IOException e) {
	                    throw new BusinessException("",e);
	                }
	                
	                iMsgServer2000 msgObj = new iMsgServer2000();
	                msgObj.SetMsgByName("RECORDID", recordID);
	                msgObj.SetMsgByName("FIELDNAME", fieldName);
	                msgObj.SetMsgByName("FIELDVALUE", fieldValue);
	                msgObj.SetMsgByName("USERNAME", user.getName());
	                msgObj.SetMsgByName("CLIENTIP", request.getRemoteAddr());
	                String markGUID = "{" + UUID.randomUUID() + "}";
	                msgObj.SetMsgByName("MARKGUID", markGUID);
	                msgObj.SetMsgByName("isNewImg", "false");
	                htmlHandWriteManager.saveSignature(msgObj);
	                msgObj.MsgTextClear();
	                msgObj.SetMsgByName("RECORDID", recordID);
	                msgObj.SetMsgByName("FIELDNAME", fieldName);
	                msgObj.SetMsgByName("USERNAME", user.getName());
	                msgObj.SetMsgByName("MARKNAME", "");
	                msgObj.SetMsgByName("MARKGUID", markGUID);
	                msgObj.SetMsgByName("CLIENTIP", request.getLocalAddr());
	                htmlHandWriteManager.saveSignatureHistory(msgObj);
				}
			}
		}catch(Exception e)	{
			return false;
		}
		return false;
	}*/
}
