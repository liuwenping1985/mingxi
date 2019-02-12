package com.seeyon.apps.kdXdtzXc.manager;

import java.util.List;
import java.util.Map;

import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public interface LingDaoDaiBanManager {
	List<Map<String, Object>> listCtpAffairmanage();
	
		@AjaxAccess
	 public abstract FlipInfo getallGenDuo(FlipInfo paramFlipInfo, Map<String, Object> params)throws BusinessException;
	/**
	 * 
	 * @param objectid
	 * @return
	 * 公文流程激活
	 */
	public CtpAffair listQueryCtpAffair(Long objectid);	
	/**
	 * 专题
	 * @param parentFrId
	 * @return
	 */
	@AjaxAccess
	public abstract  FlipInfo listAllDocResourcePO(FlipInfo paramFlipInfo, Map<String, Object> params)throws BusinessException;
}
