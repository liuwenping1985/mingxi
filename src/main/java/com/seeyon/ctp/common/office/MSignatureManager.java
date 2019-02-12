package com.seeyon.ctp.common.office;

import com.seeyon.ctp.common.exceptions.BusinessException;

/**
 * 
 * @author Administrator
 *
 */
public interface MSignatureManager {
    /**
     * 保存签章及操作历史信息
     * @param paramStr 参数字符串
     * @return true成功，false失败
     * @throws BusinessException 直接抛出业务相关异常
     */
    public boolean transSaveSignatureAndHistory(String paramStr,String affairId,String isNewImg) throws BusinessException;
}
