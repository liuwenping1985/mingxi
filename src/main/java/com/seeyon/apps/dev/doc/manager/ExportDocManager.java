package com.seeyon.apps.dev.doc.manager; 

import com.seeyon.apps.dev.doc.exception.ExportDocException;
import com.seeyon.apps.dev.doc.utils.DocFileInfo;
import com.seeyon.apps.dev.doc.utils.ExportMap;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.oainterface.common.OAInterfaceException;
import com.seeyon.oainterface.exportData.commons.AttachmentExport;
import com.seeyon.oainterface.exportData.document.DocumentExport;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.services.ServiceException;

public interface ExportDocManager {
	/**
	 * 获取标题
	 * @param docId
	 * @return
	 * @throws OAInterfaceException
	 * @throws ServiceException 
	 */
	public String getDocTitle(String docId);
	/**
	 * 导出公文主方法
	 * @param docId
	 * @param userId
	 * @return
	 * @throws ServiceException 
	 */
	public String exportArchive(String docId, String userId);
	/**
	 * 获得OA文档库所有Edo和flow
	 * @param docId
	 * @param hasExped
	 * @return
	 * @throws ServiceException
	 */
	public ExportMap getExportEdocIds(String[] ids, boolean hasExped)
			throws ServiceException;
	public DocFileInfo exportDocAttachment(AttachmentExport att, EdocSummary summary)
			throws ExportDocException;
	public DocFileInfo exportEdocZW(DocumentExport export, EdocSummary summary)
			throws ExportDocException;
	public DocFileInfo exportEdocWD(DocumentExport export, EdocSummary summary)
			throws ExportDocException;
	public byte[] toPdfFile(DocFileInfo info, DocumentExport export)
			throws ExportDocException;
	public String getTempFilepath(String path);

}
