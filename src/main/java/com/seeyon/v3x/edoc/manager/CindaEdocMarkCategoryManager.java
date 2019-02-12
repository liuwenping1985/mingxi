package com.seeyon.v3x.edoc.manager;

import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.annotation.AjaxAccess;

public interface CindaEdocMarkCategoryManager {

	@AjaxAccess
	public Boolean updateEdocMarkCategory(String docMark);
	@AjaxAccess
	public void backQianBaoDoc(Long fileId) throws BusinessException;
	@AjaxAccess
	public Boolean updateEdocMarkCategoryNull(String docMark);
	@AjaxAccess
	public void updateEdocMark(Long summary_id, String string16Mark,String string12Mark) throws Exception;
}
