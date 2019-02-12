package com.seeyon.apps.czexchange.util;

import java.io.File;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;

import com.cinda.exchange.client.util.FileUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.form.util.Dom4jxmlUtils;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.oainterface.exportData.commons.AttachmentExport;
import com.seeyon.oainterface.exportData.commons.TextAttachmentExport;
import com.seeyon.oainterface.exportData.commons.TextExport;
import com.seeyon.oainterface.exportData.commons.TextHtmlExport;
import com.seeyon.oainterface.exportData.document.DocumentExport;
import com.seeyon.v3x.edoc.domain.EdocBody;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.exception.EdocException;
import com.seeyon.v3x.edoc.manager.EdocManager;
import com.seeyon.v3x.services.ServiceException;
import com.seeyon.v3x.services.document.DocumentFactory;
import com.seeyon.v3x.services.document.impl.DocumentManager;


public class CzEdocUtil {

	private static Log log = LogFactory.getLog(CzEdocUtil.class);
	
	private static EdocManager edocManager = getEdocManager() ;
	
	
	public static EdocManager getEdocManager() {
		if(edocManager==null){
			edocManager = (EdocManager) AppContext.getBean("edocManager");
		}
		return edocManager;
	}
	public static String getTempFilepath(String localpath){
		String temppath = SystemEnvironment.getBaseFolder()+File.separator+"edocTrans"+File.separator+localpath+File.separator;
		File file = new File(temppath);
    	File filePath = new File(temppath);
        if (!filePath.exists()) {  
            filePath.mkdirs();  
        }
        log.info("exportedoc Temp path:"+file.getAbsolutePath());
		return file.getAbsolutePath();  
	}
	private static FileManager fileManager;
	
	
	public static FileManager getFileManager() {
		if(fileManager==null){
			fileManager = (FileManager) AppContext.getBean("fileManager");
		}
		return fileManager;
	}

	public static String getEdocFormHtmlFile(Long id){
		try {
			AppContext.setBean("workflowApiManager", AppContext.getBean("wapi"));
			
			DocumentFactory  documentManager = DocumentManager.getInstance();
			 
			String[] args = documentManager.exportOfflineEdocModel(id);
				String edocXml = args[0];
				Document document = Dom4jxmlUtils.paseXMLToDoc(edocXml);
				String xslFile = args[1];
				int index = xslFile.indexOf("\r\n");
				if (index == 0) {
					xslFile = xslFile.substring(2, xslFile.length());
				}
				return XmlXslToHtmlUtil.transformToString(document,xslFile);
		} catch (Exception e) {
			log.error("",e);
		}
		return null;
	}
	
	public static DocumentExport getDocumentExportByEdocId(Long edocId){
		//调用客开的方法导出文单
		AppContext.setBean("workflowApiManager", AppContext.getBean("wapi"));
		
		 DocumentFactory  documentManager = DocumentManager.getInstance();
		 DocumentExport documentExport = null;
		try {
			documentExport = documentManager.exportEdoc(edocId);
		} catch (ServiceException e) {
			log.error("", e);
		}
		 return documentExport;
	}
	
	public static EdocSummary getEdocSummaryByEdocId(Long edocId){
		try {
			return edocManager.getEdocSummaryById(edocId, true);
		} catch (EdocException e) {
			log.error("", e);
		}
		return null;
	}
	
	public static File getEdocZW(DocumentExport export,EdocSummary summary) throws Exception {
		if(export==null||summary==null){
			log.info("export=="+export);
			log.info("summary=="+summary);
		}
		// 存在正文，将正文下载到本地
		boolean soucess = false;
		Long docId = summary.getId();
		TextExport te = export.getDocContent();
		Set<EdocBody> body = summary.getEdocBodies();
		log.warn("当前公文body有"+body.size()+"个");
		EdocBody bdy=null;
		EdocBody tempBody = null;
		Date updateTime = null;
		Iterator ite=(Iterator) body.iterator();
		while(ite.hasNext()){
			tempBody=(EdocBody)ite.next();
			log.info("EdocBody 信息输出：createTime = " + tempBody.getCreateTime() + " updateTime = " + tempBody.getLastUpdate() + "contentType = " +  tempBody.getContentType() + "contentStatus = " + tempBody.getContentStatus());
			if(updateTime==null) {
				updateTime = tempBody.getLastUpdate();
				bdy = tempBody;
			}
			if(tempBody.getLastUpdate().after(updateTime)){
				bdy = tempBody;
				updateTime = tempBody.getLastUpdate();
			}
		}
		log.warn("当前取到的body为"+bdy.getContent()+" bdy.LastUpdate="+Datetimes.format(bdy.getLastUpdate(), "yyyy-MM-dd HH:mm:ss"));
		File file = null;
		Long file_size = null;
		String suffix = "html";
		Long id  = -1L;
		// HTML正文
		if (te.getTextType() == TextExport.C_Type_Html) {
			if(bdy!=null){
				TextHtmlExport the = (TextHtmlExport) te;
				String htmlResult = the.getContext();
				id = bdy.getId();
				if(Strings.isNotBlank(htmlResult)){
					try {
						String docHtml = XmlXslToHtmlUtil.transformToString(htmlResult);
				//		inputStream = new ByteArrayInputStream(docHtml.getBytes("utf-8"));
						String fullpath = getTempFilepath(summary.getId()+"")+id+"."+suffix;
						www.seeyon.com.utils.FileUtil.writeFile(getTempFilepath(summary.getId()+"")+id+"."+suffix, htmlResult);
						FileUtil.StringToFile(file, docHtml);
						file_size = Long.valueOf(docHtml.length());
						file = new File(fullpath);
					} catch (UnsupportedEncodingException e) {
						log.error("",e);
					}
					return file;
				}
			}
			// 附件类型正文
		}else if (te.getTextType() == TextExport.C_Type_Attachment) {
			TextAttachmentExport textExport = (TextAttachmentExport) te;
			String dat = "";
			// 根据正文附件的类型， 确定扩展名
			switch (textExport.getType()) {
			
			case TextAttachmentExport.C_Text_DOC:
				dat = "doc";
				break;
				
			case TextAttachmentExport.C_Text_XSL:
				dat = "xls";
				break;
				
			case TextAttachmentExport.C_Text_WPS:
				dat = "wps";
				break;
				
			case TextAttachmentExport.C_Text_ET:
				dat = "et";
				break;
			default:
				break;
			}
			id = Long.valueOf(bdy.getContent());
			if (Strings.isNotBlank(dat)) {
				try {
					file = getFileManager().getStandardOffice(id, bdy.getCreateTime());
					log.warn("当前正文的路径为："+file.getAbsolutePath()+" id="+id);
				} catch (Exception e) {
					log.error("获取附件正文异常",e);
					throw new Exception("获取附件正文失败！");
				}
				return file;
			}
		}
		return file;
	}
	
	public static List<File> getEdocAttachment(DocumentExport export){
		List<File> returnList = new ArrayList();
		if(export==null) return returnList;
		List<AttachmentExport> listAttachmentExport = export.getAttachmentList();
		if(listAttachmentExport!=null&&listAttachmentExport.size()>0){
			
			for(AttachmentExport attachmentExport : listAttachmentExport){
				File file = new File(attachmentExport.getAbsolutepath());
				returnList.add(file);
			}
		}
		return returnList;
	}
}
