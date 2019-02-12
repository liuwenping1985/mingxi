package com.seeyon.apps.dev.doc.manager;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;

import www.seeyon.com.utils.FileUtil;
import cn.com.hkgt.cinda.interfaces.AffixObj;
import cn.com.hkgt.cinda.interfaces.ArchiveObj;

import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.dev.doc.constant.DevConstant;
import com.seeyon.apps.dev.doc.dao.CindaUserDao;
import com.seeyon.apps.dev.doc.enums.FIleTypeEnum;
import com.seeyon.apps.dev.doc.exception.ExportDocException;
import com.seeyon.apps.dev.doc.utils.DocFileInfo;
import com.seeyon.apps.dev.doc.utils.ExportMap;
import com.seeyon.apps.dev.doc.utils.FileExporter;
import com.seeyon.apps.dev.doc.utils.Ftp;
import com.seeyon.apps.dev.doc.utils.FtpInfo;
import com.seeyon.apps.dev.doc.utils.XmlXslToHtmlUtil;
import com.seeyon.apps.doc.manager.DocHierarchyManager;
import com.seeyon.apps.doc.po.DocResourcePO;
import com.seeyon.apps.docexport.util.DocExportUtils;
import com.seeyon.apps.docexport.util.TransPDF;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.GlobalNames;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.idmapper.GuidMapper;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.form.util.Dom4jxmlUtils;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.AjaxAccess;
import com.seeyon.oainterface.common.OAInterfaceException;
import com.seeyon.oainterface.exportData.arcfolder.ArcContent_Doc;
import com.seeyon.oainterface.exportData.arcfolder.ArcContent_Flow;
import com.seeyon.oainterface.exportData.arcfolder.ArcContent_Folder;
import com.seeyon.oainterface.exportData.arcfolder.ArcFolderItem;
import com.seeyon.oainterface.exportData.arcfolder.IArcContent;
import com.seeyon.oainterface.exportData.commons.AttachmentExport;
import com.seeyon.oainterface.exportData.commons.TextAttachmentExport;
import com.seeyon.oainterface.exportData.commons.TextExport;
import com.seeyon.oainterface.exportData.commons.TextHtmlExport;
import com.seeyon.oainterface.exportData.document.DocumentExport;
import com.seeyon.oainterface.exportData.flow.FlowExport;
import com.seeyon.v3x.edoc.domain.EdocBody;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.manager.EdocSummaryManager;
import com.seeyon.v3x.services.ServiceException;
import com.seeyon.v3x.services.document.impl.DocumentManager;




public class ExportDocManagerImpl implements ExportDocManager{
	private static final Log log = LogFactory.getLog(ExportDocManagerImpl.class);
	private DocHierarchyManager docHierarchyManager;
	private CindaUserDao cindaUserDao;
	private EdocSummaryManager edocSummaryManager;
	private AttachmentManager attachmentManager;
	private FileManager fileManager;
	private OrgManager orgManager;
	private ColManager colManager;
	private GuidMapper guidMapper;
	private ObjectTransManager objectTransManager;
	private DocumentManager documentManager  = this.getDocumentManager();
	
	public void setGuidMapper(GuidMapper guidMapper) {
		this.guidMapper = guidMapper;
	}

	public DocumentManager getDocumentManager() {
		if(documentManager==null){
			documentManager = DocumentManager.getInstance();
		}
		return documentManager;
	}
	public void setObjectTransManager(ObjectTransManager objectTransManager) {
		this.objectTransManager = objectTransManager;
	}
	public void setColManager(ColManager colManager) {
		this.colManager = colManager;
	}
	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}
	public void setAttachmentManager(AttachmentManager attachmentManager) {
		this.attachmentManager = attachmentManager;
	}
	public void setEdocSummaryManager(EdocSummaryManager edocSummaryManager) {
		this.edocSummaryManager = edocSummaryManager;
	}

	public void setCindaUserDao(CindaUserDao cindaUserDao) {
		this.cindaUserDao = cindaUserDao;
	}
	public void setDocHierarchyManager(DocHierarchyManager docHierarchyManager) {
		this.docHierarchyManager = docHierarchyManager;
	}
	@Override
	public String getTempFilepath(String path){
		String temppath = SystemEnvironment.getBaseFolder()+File.separator+"exportedoc"+File.separator+path+File.separator;
		File file = new File(temppath);
    	File filePath = new File(temppath);
        if (!filePath.exists()) {  
            filePath.mkdirs();  
        }
        log.info("exportedoc Temp path:"+file.getAbsolutePath());
		return file.getAbsolutePath();  
	}
	@Override
	public byte[] toPdfFile(DocFileInfo info,DocumentExport export) throws ExportDocException{
		String docId = info.getDocId();
		//公文单输出流	
		byte[] wdbytearr = null;
		String tempfileName = getTempFilepath(docId+"")+File.separator+info.getFile_fullName();
		String temppdfName = getTempFilepath(docId+"")+File.separator+info.getFile_name()+".pdf";
		try {
			FileUtil.write(info.getFile_InputStream(), new FileOutputStream(tempfileName));
		} catch (Exception e1) {
			throw new ExportDocException("将《"+export.getDocTitle()+"》文单导出到本地出错！",e1);
		}
		try {
			TransPDF trans = new TransPDF(DevConstant.transPdfserverAddr, DevConstant.transPdfserverport);
			trans.transFile(tempfileName, temppdfName);
		} catch (Exception e) {
			throw new ExportDocException("转换《"+export.getDocTitle()+"》文单为pdf出错！",e);
		}
		try {
			byte[] fileBytes =  DocExportUtils.convertFileToByteArr(new FileInputStream(temppdfName));
			File temp = new File(temppdfName);
			info.setFile(temp);
			info.setFile_fullName(temp.getName());
			return fileBytes;
		} catch (Exception e1) {
			throw new ExportDocException("转换《"+export.getDocTitle()+"》文单pdf转换为字节流出错！",e1);
		}
	}
	/**
	 * 公文归档的主入口方法
	 * @param export
	 * @return
	 * @throws ExportDocException
	 */
	public boolean createExportEdoc(DocumentExport export) throws ExportDocException{
		
		log.info("公文归档信息， 进入了程序 exportDoc" + new Date());
		boolean soucess = true;
		Long docId = -1L;
		EdocSummary summary = null;
		// 获取公文对象,现在不知道什么版本就不对了，也不知道DocumentExport的id到底是affair还是summary的id
			CtpAffair affair = null;
			try {
				affair = colManager.getAffairById(export.getDocumentId());
			} catch (BusinessException e) {
				log.error("获取affair异常",e);
			}
			if(affair==null){
				summary = edocSummaryManager.findById(export.getDocumentId());
			}else{
				summary = edocSummaryManager.findById(affair.getObjectId());
			}
			if(summary==null) {
				soucess=false;
				throw new ExportDocException(export.getDocTitle()+" 获取公文对象失败");
			}
			docId = summary.getId();
			
			List<ArchiveObj> arcList = new ArrayList<ArchiveObj>();


			DocFileInfo wedaninfo = this.exportEdocWD(export, summary);
			//TODO
			//处理上传附件部分
			List<AffixObj> listAttr = this.exportAttachments(export, summary); 
			//处理上传正文部分
			try {
				DocFileInfo zwInfo = this.exportEdocZW(export, summary);
				//转储pdf文件
				this.toPdfFile(zwInfo, export);
				listAttr.add(DocExportUtils.convertToAffixObj(zwInfo));
			} catch (Exception e) {
				soucess=false;
				log.info("归档《"+export.getDocTitle()+"》正文出错，"+e.getMessage(),e);
				throw new ExportDocException("归档《"+export.getDocTitle()+"》正文出错，"+e.getMessage(),e);
			}
			
			//保存公文信息到中间库
			arcList.add(DocExportUtils.transToArchiveObj(summary, this.toPdfFile(wedaninfo, export), listAttr));
			String userid = AppContext.getCurrentUser().getLoginName();//cindaUserDao.getbyLoginNane(AppContext.getCurrentUser().getLoginName()).getUserid();
			String ownerIp = AppContext.getRawRequest().getLocalAddr();
			log.info("归档用户的id是：=="+userid);
			log.info("归档用户的IP是：=="+ownerIp);
			if(Strings.isBlank(ownerIp)){
				ownerIp = "80.32.9.246";
			}
			String serveraddr = DocExportUtils.serviceUrl;
			log.info("读取配置归档服务器地址为："+serveraddr);
			if(Strings.isBlank(serveraddr)){
				serveraddr = "http://portal02.zc.cinda.ccb/archivegeWeb/geArchiveService";
			}
			DocExportUtils.archiveFile(arcList, serveraddr,userid,ownerIp);
		log.info("公文归档信息， 出了程序 exportDoc" + new Date());
		return soucess;
	}
	private List<AffixObj> exportAttachments(DocumentExport export ,EdocSummary summary) throws ExportDocException{
		Long docId = summary.getId();
		List<AttachmentExport> list = export.getAttachmentList();
		List<AffixObj> listattr = new ArrayList<AffixObj>();
		if(list==null || list.size()==0) return listattr;
		for (AttachmentExport att : list) {
			// 20161031 ljx 修改了下面的构造方法
			try {
				DocFileInfo info = this.exportDocAttachment(att, summary);
				listattr.add(DocExportUtils.convertToAffixObj(info));
			} catch (Exception e) {
				throw new ExportDocException(export.getDocTitle()+"获取附件失败！",e);
			}
		}
		return listattr;
	}
	private boolean upLoadEdocWD(DocumentExport export,EdocSummary summary) throws ExportDocException{

		FtpInfo info = (FtpInfo) exportEdocWD( export, summary);
		try {
			Ftp.getInstance().upload(info);
		} catch (Exception e) {
			throw new ExportDocException("《"+export.getDocTitle()+"》上传ftp异常！",e);
		}
		Boolean soucess = info.isSuccess();
		 if(soucess){
			 soucess = this.saveOrUpdataEdocExportfile(info);
			 if(!soucess){
					throw new ExportDocException("《"+export.getDocTitle()+"》保存文单记录到中间库异常！");
			 }
		 }else{
			 throw new ExportDocException("《"+export.getDocTitle()+"》上传ftp异常！");
		 }

	
		return soucess;
	}
	@Override
	public DocFileInfo exportEdocWD(DocumentExport export,EdocSummary summary) throws ExportDocException{
		InputStream in;
		Long docId = summary.getId();
		String formHtml = getEdocFormHtmlFile(docId);
		if (Strings.isNotBlank(formHtml)) {
			
			try {
				in = new ByteArrayInputStream(formHtml.getBytes("UTF-8"));
			} catch (UnsupportedEncodingException e) {
				throw new ExportDocException("《"+export.getDocTitle()+"》导出获取文单失败！",e);
			}  
			//公文单的文件id和公文id是一个值
			String suffix = "html";
			String fileName =  export.getDocTitle() +DevConstant.Edoc_WD;
			String ftpFileName = docId+ "."+suffix;
			String ftppath =Ftp.showPathString(docId+"");
			String pathName = ftppath+ftpFileName;
			 return new DocFileInfo(docId, ftppath, in, Long.valueOf(formHtml.length()), ftpFileName, docId+"", fileName, FIleTypeEnum.Edoc_ZW.getText());
		}else{
			throw new ExportDocException("《"+export.getDocTitle()+"》导出获取文单失败！");
		}
	}
	@Override
	public DocFileInfo exportEdocZW(DocumentExport export,EdocSummary summary) throws ExportDocException{

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
		InputStream inputStream =null;
		Long file_size = null;
		String suffix = "html";
		String ftpFileName = "";
		String fileName = export.getDocTitle() + DevConstant.Edoc_ZW;
		String ftpPath =Ftp.showPathString(docId+"");
		Long id  = -1L;
		// HTML正文
		if (te.getTextType() == TextExport.C_Type_Html) {
			if(bdy!=null){
				TextHtmlExport the = (TextHtmlExport) te;
				String htmlResult = the.getContext();
				id = bdy.getId();
				ftpFileName =  id + "."+suffix;
				if(Strings.isNotBlank(htmlResult)){
					try {
						String docHtml = XmlXslToHtmlUtil.transformToString(htmlResult);
						inputStream = new ByteArrayInputStream(docHtml.getBytes("utf-8"));
						file_size = Long.valueOf(docHtml.length());
					} catch (UnsupportedEncodingException e) {
						log.error("",e);
						throw new ExportDocException(fileName+"导出html正文异常！",e);
					}
				}
			}
			// 附件类型正文
		}else if (te.getTextType() == TextExport.C_Type_Attachment) {
			TextAttachmentExport textExport = (TextAttachmentExport) te;
			String dat = "";
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
			id = textExport.getId();
			try {
				if (Strings.isNotBlank(dat)) {
					File file = fileManager.getStandardOffice(id, bdy.getCreateTime());
					suffix =  dat;
					ftpFileName = id+"."+dat;
						log.info("上传文件"+fileName+"，文件路径："+textExport.getAbsolutepath());
						inputStream  = new FileInputStream(textExport.getAbsolutepath());
				}
			} catch (Exception e) {
				throw new ExportDocException(fileName+"导出html正文异常！",e);
			}
			
		}
		DocFileInfo fileInfo = new DocFileInfo(id, ftpPath, null, ftpFileName, docId+"", fileName, FIleTypeEnum.Edoc_ZW.getText());
		fileInfo.setFile_InputStream(inputStream);
		return fileInfo;
	
	}
	/**
	 * 上传公文正文到ftp
	 * @param export
	 * @param body
	 * @param docId
	 * @param isexist
	 * @return
	 * @throws Exception
	 */
	private boolean upLoadZW(DocumentExport export,EdocSummary summary) throws ExportDocException {
		FtpInfo info = (FtpInfo) exportEdocZW(export, summary);
		Boolean soucess = false;
		if(info !=null){
			try {
				soucess = Ftp.getInstance().upload(info).isSuccess();
				if(soucess){
					soucess = saveOrUpdataEdocExportfile(info);
					if(!soucess){
						throw new ExportDocException("《"+export.getDocTitle()+"》保存正文记录到中间库异常！");
					}
				}
			} catch (Exception e) {
				throw new ExportDocException("《"+export.getDocTitle()+"》保存正文异常！",e);
			}
		}
		return soucess;
	}
	/**
	 * 通过文件下载服务，下载附件到本地，并上传至ftp服务器
	 * 
	 * @param attachmentList
	 *            附件的集合
	 * @param docId
	 *            公文id
	 * @return 附件原文的集合
	 */
	private boolean upLoadAttachments(DocumentExport export ,EdocSummary summary) throws ExportDocException{
		boolean soucess = false;
		Long docId = summary.getId();
		List<AttachmentExport> list = export.getAttachmentList();
		if(list==null || list.size()==0) return true;
		for (AttachmentExport att : list) {
			// 20161031 ljx 修改了下面的构造方法
			try {
				FtpInfo info = (FtpInfo) this.exportDocAttachment(att, summary);
				soucess=Ftp.getInstance().upload(info).isSuccess();
				if(soucess){
					soucess = this.saveOrUpdataEdocExportfile(info);
					 if(!soucess){
							throw new ExportDocException("《"+export.getDocTitle()+"》保存附件记录到中间库异常！");
					 }
				}else{
					log.error("上传附件失败 ");
				}
			} catch (Exception e) {
				throw new ExportDocException(export.getDocTitle()+"获取附件失败！");
			}
		}
		return soucess;
	}
	/**
	 * 通过文件下载服务，下载附件到本地
	 * 
	 * @param attachmentList
	 *            附件的集合
	 * @param docId
	 *            公文id
	 * @return 附件原文的集合
	 */
	@Override
	public DocFileInfo exportDocAttachment(AttachmentExport att,EdocSummary summary) throws ExportDocException{

		Long fileId = att.getId();
		V3XFile v3xfile = null;
		try {
			v3xfile = fileManager.getV3XFile(fileId);
		} catch (Exception e) {
			throw new ExportDocException("获取附件失败fileId="+fileId+",FileName="+att.getFileName(),e);
		}
		if (v3xfile != null) {
			String fileName =  v3xfile.getFilename();
			String suffix = att.getFilesuffix();
			String ftpfileName = fileId+"."+suffix;
			String ftppath = Ftp.showPathString(summary.getId()+"");
			String ftpPathName = ftppath+ftpfileName;
			String fileloaclPath = att.getAbsolutepath();
			if(Strings.isNotBlank(fileloaclPath)){
				log.info("上传文件"+fileName+"，文件路径："+fileloaclPath);
				File file = null;
				try {
					file = fileManager.getFile(fileId);
				} catch (BusinessException e) {
					throw new ExportDocException(summary.getSubject()+"获取附件失败！没有找到文件或本身不是文件"+fileName+"文件路径："+fileloaclPath,e);
				}
				if(file!=null){
					// 20161031 ljx 修改了下面的构造方法
					try {
						return new DocFileInfo(fileId, ftppath, new FileInputStream(file), ftpfileName, summary.getId()+"", fileName, FIleTypeEnum.Edoc_FJ.getText());
					} catch (FileNotFoundException e) {
						throw new ExportDocException(summary.getSubject()+"获取附件失败！没有找到文件或本身不是文件"+fileName+"文件路径："+fileloaclPath,e);
					}
				}
			}
		}
		throw new ExportDocException("获取附件失败fileId="+fileId+",FileName="+att.getFileName());
	}

	/**
	 * 归档附加等信息
	 */
	private boolean saveOrUpdataEdocExportfile(FtpInfo info){
		return false;}
	/**
	 * 归档公文的主表
	 * @param summary
	 */
	private boolean saveOrUpdateSummaryTable(ColSummary summary){
		return false;}
	/**
	 * 归档公文的主表
	 * @param summary
	 */
	private boolean saveEdocTable(DocumentExport export,EdocSummary summary){
		return false;}
	
	/**
	 * 公文单部分导出
	 * 
	 * @param args
	 *            包含XML和XSL的文件字符串数组
	 * @param id
	 *            公文id
	 * @return html文件名
	 */
	public String getEdocFormHtmlFile(Long id){
		try {
			//调用客开的方法导出文单
			AppContext.setBean("workflowApiManager", AppContext.getBean("wapi"));
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

	private boolean uploadOAFormfile(ColSummary summary, Long affairId) throws ExportDocException{

		boolean success = false;
		FtpInfo info = null;
		Long summaryId = summary.getId();
		try {
			
			//公文单的文件id和公文id是一个值
			String suffix = "html";
			String fileName =  summary.getSubject() +DevConstant.EXP_Form+DevConstant.File_dot+suffix;
			String ftpFileName = summaryId+ DevConstant.File_dot+suffix;
			Date date= summary.getFinishDate();
			if(date==null){
				date = summary.getCreateDate();
			}
			String ftppath ="";
			if(date!=null){
				String  yearMoth = Datetimes.format(date, "yyyyMM");
				ftppath =Ftp.showPathString(yearMoth,summaryId+"");
			}else{
				ftppath =Ftp.showPathString(summaryId+"");
			}
			String[] args = null;
			try {
				args = documentManager.exportOfflineFormModel(affairId);
			} catch (Exception e) {
				throw new ExportDocException("《"+summary.getSubject()+"》导出获取文单失败！",e);
			}
			if(args!=null&& Strings.isNotBlank(args[1])){
				String formHtml = args[1];
				formHtml = this.getFormImages(formHtml,ftppath);
				formHtml = XmlXslToHtmlUtil.transformToString(formHtml);
				InputStream in = new ByteArrayInputStream(formHtml.getBytes("UTF-8")); 
				info = new FtpInfo(summaryId, ftppath, in, Long.valueOf(formHtml.length()), ftpFileName, summaryId+"", fileName, FIleTypeEnum.Edoc_ZW.getText());
				info.setFile_sortId(1L);
				success = Ftp.getInstance().upload(info).isSuccess();
			}
		} catch (Exception e) {
			throw new ExportDocException("《"+summary.getSubject()+"》导出获取文单失败！",e);
		}
	
		 if(success){
			 success = this.saveOrUpdataEdocExportfile(info);
			 if(!success){
					throw new ExportDocException("《"+summary.getSubject()+"》保存文单记录到中间库异常！");
			 }
		 }
		return success;
	}
	/**
	 * 获取文档标题
	 * 
	 * @param docId
	 *            文档id
	 * @return 该文档的标题
	 * @throws ServiceException 
	 * @throws OAInterfaceException
	 */
	@Override@AjaxAccess
	public String getDocTitle(String docId){
		String titie = "false";
		if(Strings.isNotBlank(docId)){
			Long id = null;
			try {
				id = Long.parseLong(docId.trim());
			} catch (NumberFormatException e) {
				log.error("",e);
			}
			if(id!=null){
				ExportMap map = (ExportMap) AppContext.getSessionContext(DevConstant.EXPORT_DOC_KEY);
				Object con =  map.get(id);
				if(con!=null && con instanceof DocumentExport){
					DocumentExport exp = (DocumentExport)con;
					titie = exp.getDocTitle();
				}
				if(con!=null && con instanceof FlowExport){
					FlowExport exp = (FlowExport)con;
					titie = exp.getFlowTitle();
				}
			}
		}
		return titie;
	}
	
	
	@AjaxAccess
	@Override
	public String exportArchive(String docId, String userId){
		String exportMsg = "true";
		boolean soucess = false;
		Long id = null;
		if(Strings.isNotBlank(docId)&& Strings.isNotBlank(userId)){
			try {
				id = Long.parseLong(docId.trim());
			} catch (NumberFormatException e) {
				log.error("",e);
			}
			if(id!=null){
				ExportMap map = (ExportMap) AppContext.getSessionContext(DevConstant.EXPORT_DOC_KEY);
				Object con =  map.get(id);
				//处理公文导出
				if(con!=null && con instanceof DocumentExport){
					DocumentExport exp = (DocumentExport)con;
					try {
						this.createExportEdoc(exp);
					} catch (Exception e) {
						log.error(e.getMessage(),e);
						soucess = false;
						exportMsg = e.getMessage();
					}
				}
//		if(con!=null && con instanceof FlowExport){
//			FlowExport exp = (FlowExport)con;
//			titie = exp.getFlowTitle();
//		}
				//更新数据状态
				if(soucess){
					try {
						documentManager.updateArchiveState(id, 1);
						map.remove(id);
					} catch (Exception e) {
						log.error("更新状态异常",e);
					}
				}
			}
			}
		return exportMsg;				
	}
	@Override
	public ExportMap getExportEdocIds(String[] ids,boolean hasExped) throws ServiceException{
		ExportMap map = new ExportMap();
		for (String idstr : ids) {
			if(Strings.isNotBlank(idstr)){
				
				try {
					Long id = Long.parseLong(idstr);
					ExportMap vo = this.getExportsById(id, hasExped);
					if(vo!=null){
						map.putAll(vo);
					}
				} catch (NumberFormatException e) {
					log.info("传入的参数不是Long型Id param="+idstr);
				}
			}
		}
			return map;
	}
	private ExportMap getExportsById(Long id,boolean hasExped) throws ServiceException{
		ExportMap map = new ExportMap();
		DocResourcePO po = this.docHierarchyManager.getDocResourceById(id);
		if(po!=null){
			if(po.getIsFolder()){
				List<DocResourcePO> list = docHierarchyManager.getAllFirstChildren(po.getId());
				for (DocResourcePO chpo : list) {
						map.putAll(this.getExportsById(chpo.getId(), hasExped));
				}
			}else{
				ArcFolderItem item = documentManager.exportArchive(po.getId());
				if (po!=null && item.getContent() != null) {
					switch (item.getContent().getContentType()) {
					case IArcContent.C_iFolderItemType_Doc:
					{	
						ArcContent_Doc con = (ArcContent_Doc) item.getContent();
						DocumentExport doc = con.getDoc();
						if(hasExped || !po.isThird_hasPingHole()){
							map.put(po.getId(), doc,po,po.isThird_hasPingHole());
//					List<DocumentFormExport> lis = doc.getFormElementList();
							
						}
						break;
					}
					case IArcContent.C_iFolderItemType_Flow:
					{	
						ArcContent_Flow con = (ArcContent_Flow) item.getContent();
						FlowExport doc  = con.getFlow();
						if(hasExped || !po.isThird_hasPingHole()){
							map.put(po.getId(), doc,po,po.isThird_hasPingHole());
						}
						break;
					}
					case IArcContent.C_iFolderItemType_Folder:
					{
						//如过是个文件夹,那么久查找下面的数据
						ArcContent_Folder folder = (ArcContent_Folder)item.getContent();
						List<ArcFolderItem> list =  folder.getList();
						for (ArcFolderItem Item :list) {
							map.putAll(this.getExportsById(Item.getId(), hasExped));
						}
						break;
					}
					}
				}
			}
		}
		return map;				
	}

	public User cheakVirtualUser(V3xOrgMember member){
		// 创建一个虚拟用户
		User user = AppContext.getCurrentUser();
		if(user!=null && member.getLoginName().equals(user.getLoginName())){
			return user;
		}else{
			if(member==null){
				member = OrgHelper.getOrgManager().getSystemAdmin();
			}
			user = new User();
			user.setAccountId(member.getOrgAccountId());
			user.setId(member.getId());
			user.setLoginName(member.getLoginName());
			user.setDepartmentId(member.getOrgDepartmentId());
			user.setLoginAccount(member.getOrgAccountId());
			AppContext.putThreadContext(GlobalNames.SESSION_CONTEXT_USERINFO_KEY, user);
		}
		return user;
	}
private boolean exportFormFlowAttachments(ColSummary summary) throws ExportDocException{

	boolean soucess = false;
	Long docId = summary.getId();
	List<Attachment> list = attachmentManager.getByReference(summary.getId());
	if(list==null || list.size()==0){
		log.info("协同《"+summary.getSubject()+"》没有附件,不许要附件归档！");
		return true;
	}
	int loop=1;
	for (Attachment att : list) {
		Long fileId = att.getFileUrl();
		V3XFile v3xfile = null;
		try {
			v3xfile = fileManager.getV3XFile(fileId);
		} catch (Exception e) {
			throw new ExportDocException(summary.getSubject()+"获取附件失败！"+att.getFilename(),e);
		}
		if (v3xfile != null) {
			String fileName =  v3xfile.getFilename();
			String suffix = fileName.substring(fileName.lastIndexOf(DevConstant.File_dot)+1);
			String ftpfileName = fileId+"."+suffix;
			Date date= summary.getFinishDate();
			if(date==null){
				date = summary.getCreateDate();
			}
			String ftppath ="";
			String summaryId = summary.getId()+"";
			if(date!=null){
				String  yearMoth = Datetimes.format(date, "yyyyMM");
				ftppath =Ftp.showPathString(yearMoth,summaryId);
			}else{
				ftppath =Ftp.showPathString(summaryId);
			}
			try {
				File file = fileManager.getFile(fileId);
				if(file!=null){
					loop++;
					FtpInfo info = new FtpInfo(fileId, ftppath, file, docId+"", att.getFilename(), FIleTypeEnum.Edoc_FJ.getText());
					info.setFile_fullName(ftpfileName);
					info.setFile_sortId(Long.valueOf(loop));
					soucess=Ftp.getInstance().upload(info).isSuccess();
					if(soucess){
						soucess = this.saveOrUpdataEdocExportfile(info);
						if(!soucess){
							throw new ExportDocException("《"+summary.getSubject()+"》保存附件记录到中间库异常！");
						}
						
						
					}
				}
			} catch (Exception e) {
				throw new ExportDocException("《"+summary.getSubject()+"》保存附件记录到中间库异常！",e);
			}
		

		
		}

	
	}
	return soucess;

}	
/**
 * 图标问题处理	
 * @param formHtml
 * @param ftppath
 * @return
 */
private String getFormImages(String formHtml,String ftppath){
		Map<Long ,File> images = new HashMap<Long, File>();
		Map<String ,String> imageTagMap = new HashMap<String, String>();
		String top = "<img";
		String end = ">";
		String tmp = formHtml;
		String paramkey = "fileId";
		while (Strings.isNotBlank(tmp) && tmp.indexOf(top)!=-1){
			String imageTag =  tmp.substring(tmp.indexOf(top));
			tmp = imageTag.substring(imageTag.indexOf(end)+1);
			imageTag = imageTag.substring(0,imageTag.indexOf(end)+1);
			if(imageTag.indexOf("src")!=-1&&imageTag.indexOf("&")!=-1){
				String [] strarr = imageTag.split("&");
				for (String tmpstr : strarr) {
					
					if(tmpstr.startsWith(paramkey) && tmpstr.indexOf("=")!=-1){
						String[] keys = tmpstr.split("=");
						if(keys.length>0 && Strings.isNotBlank(keys[1])){
							String id = keys[1].trim();
							imageTagMap.put( id,imageTag);
						}
					}
				}
			}
		}
		for (String fileId : imageTagMap.keySet()) {
			try {
				V3XFile v3xfile = fileManager.getV3XFile(Long.parseLong(fileId));
				File file = fileManager.getFile(Long.parseLong(fileId));
				String ingname = v3xfile.getFilename();
				if(file!=null){
					String imgCode = FileExporter.file2BASE64CodeString(file);
					String imgfiletag = "<img src=\"data:image/png;base64,"+imgCode+"\" style=\"WIDTH: 157px; HEIGHT: 69px\">";
					formHtml = formHtml.replace(imageTagMap.get(fileId), imgfiletag);
					if(formHtml.indexOf(imageTagMap.get(fileId))!=-1){
						log.info("图片替换失败了");
					}
				}
/*				if(file!=null){
					boolean soucess=Ftp.getInstance().upload(file, ingname, ftppath);
					if(soucess){
						String imgfiletag = "<img src=\"./"+ingname+"\" style=\"WIDTH: 157px; HEIGHT: 69px\">";
						formHtml = formHtml.replace(imageTagMap.get(fileId), imgfiletag);
						if(formHtml.indexOf(imageTagMap.get(fileId))!=-1){
							log.info("图片替换失败了");
						}
					}
				}*/
			} catch (Exception e) {
				log.error("导出表单图片出错"+e.getMessage());
			}
		}
		return formHtml;
		
	}
	public static void main(String[] args) {
		System.out.println("asdfasdf"+File.separator+"gggg");
		//String s = "<div><img src='/seeyon/fileUpload.do?method=showRTE&fileId=200665154098513588&createDate=2016-08-11&type=image'><font color=red>##{cityName}##</fond><img src='/seeyon/fileUpload.do?method=showRTE&fileId=2008&createDate=2016-08-11&type=image'></div>";
	}

}
