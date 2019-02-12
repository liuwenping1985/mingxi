package com.seeyon.v3x.edoc.manager;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.filemanager.manager.Util;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.v3x.edoc.dao.CindaEdocMarkCategoryDAO;
import com.seeyon.v3x.edoc.dao.EdocMarkCategoryDAO;
import com.seeyon.v3x.edoc.domain.EdocMarkCategory;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.exception.EdocException;

public class CindaEdocMarkCategoryManagerImpl implements CindaEdocMarkCategoryManager{
	
	private static final Log log = LogFactory.getLog(CindaEdocMarkCategoryDAO.class);
	
	private CindaEdocMarkCategoryDAO cindaEdocMarkCategoryDAO;
	private EdocMarkCategoryDAO edocMarkCategoryDAO;
	private FileManager fileManager;
	
	@AjaxAccess
	public Boolean updateEdocMarkCategory(String docMark){
		Long loginAccount = AppContext.getCurrentUser().getLoginAccount();
		
		String current_No = docMark.split("\\|")[1].split("〕")[1].substring(0, docMark.split("\\|")[1].split("〕")[1].length()-1);
		String doc_Mark = docMark.split("\\|")[1].split("〔")[0];
		EdocMarkCategory containEdocMarkCategory = cindaEdocMarkCategoryDAO.containEdocMarkCategory(doc_Mark,loginAccount);
		if(containEdocMarkCategory!=null){
				
				if(containEdocMarkCategory.getCurrentNo()<=Integer.valueOf(current_No)){
					
					containEdocMarkCategory.setCurrentNo(Integer.valueOf(current_No)+1);
					log.info("当前文号:"+docMark.split("\\|")[1]+"按序文号："+Integer.valueOf(current_No)+1);
					edocMarkCategoryDAO.updateEdocMarkCategory(containEdocMarkCategory);
					return true;
				}
			
			
		}
		log.info("当前文号:"+docMark.split("\\|")[1]);
		return false;
	}
	
	@AjaxAccess
	public Boolean updateEdocMarkCategoryNull(String docMark){
		Long loginAccount = AppContext.getCurrentUser().getLoginAccount();
		int current =0;
		String current_No = docMark.split("\\|")[1].split("〕")[1].substring(0, docMark.split("\\|")[1].split("〕")[1].length()-1);
		String doc_Mark = docMark.split("\\|")[1].split("〔")[0];
		EdocMarkCategory containEdocMarkCategory = cindaEdocMarkCategoryDAO.containEdocMarkCategory(doc_Mark,loginAccount);
		if(containEdocMarkCategory!=null){
			current = Integer.valueOf(current_No)+1;
				if(containEdocMarkCategory.getCurrentNo()<=current){
					containEdocMarkCategory.setCurrentNo(Integer.valueOf(current_No));
					log.info("当前文号:"+docMark.split("\\|")[1]+"按序文号："+Integer.valueOf(current_No));
					edocMarkCategoryDAO.updateEdocMarkCategory(containEdocMarkCategory);
					return true;
				}
		}
		log.info("当前文号:"+docMark.split("\\|")[1]);
		return false;
	}
	
	@AjaxAccess
	public void updateEdocMark(Long summary_id, String string16Mark,String string12Mark) throws Exception{
		EdocSummaryManager edocSummaryManager = (EdocSummaryManager)AppContext.getBean("edocSummaryManager");
		EdocSummary edocSummaryById = edocSummaryManager.getEdocSummaryById(summary_id, false, true);
		edocSummaryById.setVarchar16(string16Mark);
		edocSummaryById.setVarchar12(string12Mark);
		edocSummaryManager.updateEdocSummary(edocSummaryById,true);
	}
	
	@AjaxAccess
	public void backQianBaoDoc(Long fileId) throws BusinessException{
		File file2 = fileManager.getFile(fileId);
		V3XFile file = fileManager.getV3XFile(fileId);
		if(file != null){
				String[] dateS = file.getCreateDate().toString().split("-");
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
				String oldPath = file2.getAbsolutePath().split("base")[0]+"base/upload/"+dateS[0]+"/"+dateS[1]+"/"
						+dateS[2].split(" ")[0]+"/"+file.getId();
				String doc = oldPath +  "_"+sdf.format(new Date()).toString()+".bak";
				//String docPath = sysTemp + "doc/";
				//File docFile = new File(docPath);
				//docFile.mkdirs();
				Util.jinge2StandardOffice(oldPath, doc);
		}
		
	}

	public void setCindaEdocMarkCategoryDAO(CindaEdocMarkCategoryDAO cindaEdocMarkCategoryDAO) {
		this.cindaEdocMarkCategoryDAO = cindaEdocMarkCategoryDAO;
	}

	public void setEdocMarkCategoryDAO(EdocMarkCategoryDAO edocMarkCategoryDAO) {
		this.edocMarkCategoryDAO = edocMarkCategoryDAO;
	}
	public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}

}
