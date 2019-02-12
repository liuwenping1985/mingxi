package com.seeyon.v3x.system.signet.manager;

import java.util.List;

import com.seeyon.v3x.system.signet.dao.V3xHtmDocumentSignatureDao;
import com.seeyon.v3x.system.signet.domain.V3xHtmDocumentSignature;

public class V3xHtmDocumentSignatManagerImpl implements
		V3xHtmDocumentSignatManager {

	private V3xHtmDocumentSignatureDao htmlSignDao;

	public void setHtmlSignDao(V3xHtmDocumentSignatureDao htmlSignDao) {
		this.htmlSignDao = htmlSignDao;
	}

	
	@Override
	public void update(V3xHtmDocumentSignature htmSignate) {
		htmlSignDao.update(htmSignate);
	}

	@Override
	public void save(V3xHtmDocumentSignature htmSignate){
	    this.htmlSignDao.save(htmSignate);
	}
	
	@Override
	public V3xHtmDocumentSignature getByAffairId(Long affairId) {
		return htmlSignDao.getByAffairId(affairId);
	}

    @Override
    public List<V3xHtmDocumentSignature> findBySummaryIdPolicyAndType(Long summaryId, String policy, int signType) {
        return this.htmlSignDao.findBySummaryIdPolicyAndType(summaryId, policy, signType);
    }


    @Override
    public List<V3xHtmDocumentSignature> findBySummaryIdAndType(Long summaryId, int signType) {
        
        return this.htmlSignDao.findBySummaryIdAndType(summaryId, signType);
    }

    @Override
    public List<V3xHtmDocumentSignature> findBySummaryId(Long summaryId){
        return this.htmlSignDao.findBySummaryId(summaryId);
    }
    

    @Override
    public V3xHtmDocumentSignature getById(Long id) {
        return this.htmlSignDao.get(id);
    }


    @Override
    public V3xHtmDocumentSignature getBySummaryIdAffairIdAndType(Long summaryId, Long affairId, int signType) {
        return this.htmlSignDao.getBySummaryIdAffairIdAndType(summaryId, affairId, signType);
    }


    @Override
    public void deleteBySummaryIdAffairIdAndType(Long summaryId, Long affairId, int signType) {
        this.htmlSignDao.deleteBySummaryIdAffairIdAndType(summaryId, affairId, signType);
    }


    @Override
    public void deleteBySummaryIdAndType(Long summaryId, int signType) {
        this.htmlSignDao.deleteBySummaryIdAndType(summaryId, signType);
    }


    @Override
    public void deleteBySummaryId(Long summaryId) {
        this.htmlSignDao.deleteBySummaryId(summaryId);
    }


    @Override
    public void deleteBySummaryIdAffairsAndType(Long summaryId, List<Long> affairIds, int signType) {
        this.htmlSignDao.deleteBySummaryIdAffairsAndType(summaryId, affairIds, signType);
    }

    @Override
	public List<V3xHtmDocumentSignature> getByFieldName(String fieldName) {
		return htmlSignDao.getByFieldName(fieldName);
	}
    

	@Override
	public void deleteBySummaryIdAndTypeAndUserName(Long summaryId,
			int signType, String userName) {
		 htmlSignDao.deleteBySummaryIdAndTypeAndUserName(summaryId,signType,userName);
	}
}
