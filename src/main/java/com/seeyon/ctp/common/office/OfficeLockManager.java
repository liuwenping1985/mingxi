package com.seeyon.ctp.common.office;

import com.seeyon.ctp.common.exceptions.BusinessException;


public interface OfficeLockManager {
    /**
	 * 解锁文档中的所有office锁
	 * @param recordId 文档的id，例如office正文的fileId
	 * @return
	 * @throws BusinessException
	 */
	public boolean unlockAll(Long fileId) throws BusinessException;
	
	/**
	 * 解锁某一个锁
	 * @param objId
	 * @return
	 * @throws BusinessException
	 */
	public boolean unlock(String objId) throws BusinessException;
	
	/**
	 * 解锁某一个锁
	 * @param objId
	 * @param userId 需要解锁的人员Id，一般情况下是当前用户Id
	 * @return
	 * @throws BusinessException
	 */
	public boolean unlock(String objId,Long memberId) throws BusinessException;
	
	/**
	 * 加锁
	 * @param objId
	 * @return
	 * @throws BusinessException
	 */
	public OfficeLockObject lock(String objId) throws BusinessException;
    
	/**
	 * 获取校验锁
	 * @param objId
	 * @return
	 * @throws BusinessException
	 */
	public OfficeLockObject getLock(String objId) throws BusinessException;

}
