package com.seeyon.apps.czexchange.common;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.czexchange.bo.Attach;
import com.seeyon.apps.czexchange.bo.Attachfile;
import com.seeyon.apps.czexchange.bo.Elecdocument;
import com.seeyon.apps.dev.doc.manager.ExportDocManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.util.Strings;
import com.seeyon.oainterface.exportData.commons.AttachmentExport;
import com.seeyon.oainterface.exportData.commons.PersonExport;
import com.seeyon.oainterface.exportData.commons.TextAttachmentExport;
import com.seeyon.oainterface.exportData.document.DocumentExport;
import com.seeyon.oainterface.exportData.document.DocumentFormExport;
import com.seeyon.v3x.edoc.domain.EdocSummary;


public class EdocUtil {
	private static Log log = LogFactory.getLog(EdocUtil.class);
	private static ExportDocManager exportDocManager = (ExportDocManager) AppContext.getBean("exportDocManager");
	public static DocumentExport getDocumentExport(Elecdocument elecdocument) throws BusinessException {
		
		FileManager fileManager = (FileManager) AppContext.getBean("fileManager");
		DocumentExport export = new DocumentExport(); 

		
		// 重要 
		
		export.setDocumentThirdPartyId(String.valueOf(elecdocument.getRelationId()));
		
		//
		export.setDocTitle(elecdocument.getGwelement().getTitle());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		export.setDocCreateTime(sdf.format(new Date()));

		export.setNotifyTime(0);
		PersonExport docCreatePerson = new PersonExport();
		docCreatePerson.setId(-1l);
		docCreatePerson.setName(elecdocument.getGwelement().getBaosongname());
		export.setDocCreatePerson(docCreatePerson);
		List<AttachmentExport> ret = new ArrayList<AttachmentExport>();
//		String folderPath = Constant.HD_TEMP_RECEIVE + "\\" + elecdocument.getMsgId() + "\\";
		String folderPath = exportDocManager.getTempFilepath("receiveEdoc"+File.separator+elecdocument.getMsgId());
		
		Attach attachObj = elecdocument.getAttach();
		
		if (attachObj != null && attachObj.getAttachfile() != null){
		
			for(Attachfile attachfile : attachObj.getAttachfile()){
				AttachmentExport ae = new AttachmentExport();
				// attachfile.getFileName() 中包含的只是这个附件的文件名称， 并不是这个附件的全路径， 需要增加目录的部分
				String fileName = attachfile.getFileName();
				String attpathName = folderPath+File.separator+fileName;
				String showName = attachfile.getAttachname();
				showName = showName.indexOf(".")==-1?showName+fileName.substring(fileName.lastIndexOf(".")-1,fileName.length()):showName;
				File file = new File(attpathName);
				if(!file.exists()){
					log.error(" 附件不存在：" + attachfile.getAttachname() + " " + file.getAbsolutePath());
				}
				V3XFile v3xfile = null;
				try {
					v3xfile = fileManager.save(file, ApplicationCategoryEnum.edocRec,showName, new Date(), true);
				} catch (BusinessException e) {
					log.error("", e);
					throw e;
				}
				attachfile.setFileId(v3xfile.getId());
				ae.setId(attachfile.getFileId()==null? 0l:attachfile.getFileId());
				ae.setFileName(showName);
				ae.setFilesuffix(attachfile.getFileName().substring(attachfile.getFileName().lastIndexOf("."), attachfile.getFileName().length()));
				ret.add(ae);
			}
		}
		export.setAttachmentList(ret);
		// 下面的程序处理公文单上的元素
		List<DocumentFormExport> ls = convertEdocForm(elecdocument);
		export.setFormElementList(ls);
		
		// TODO: 下面的部分处理正文
//		TextAttachmentExport textExport = new TextAttachmentExport();
//		String fileName = elecdocument.getText().getFile().getFileName();
//		if(Strings.isNotBlank(fileName)){
//			String docfilepath = folderPath+File.separator+fileName;
//			textExport.setAbsolutepath(docfilepath);
//			textExport.setDownloadpath(docfilepath);
//			textExport.setFilesuffix(fileName.substring(fileName.indexOf("."), fileName.length()));
//		}
//		export.setDocContent(textExport);
		
	
		return export;
	}
	
	private static Date changeToDate(String s){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		try{
			return sdf.parse(s);
		}catch(Exception e){
			log.error("公文交换插件输出信息：  在进行字符串转日期的时候出错， 转换前的字符串是  " +s, e);
		}
		    return null;
	}

	private static List<DocumentFormExport> convertEdocForm(Elecdocument elecdocument)
	{
		java.util.List<DocumentFormExport> ls=new ArrayList<DocumentFormExport>();

		DocumentFormExport dfeTemp=new DocumentFormExport();

		dfeTemp.setElementName("公文单ID");
		dfeTemp.setAttributeName("formId");
		dfeTemp.setDataType("long");
		dfeTemp.setId("");
		dfeTemp.setValue(_toString(elecdocument.getFormId()));
		ls.add(dfeTemp);

		dfeTemp=new DocumentFormExport();
		dfeTemp.setElementName("文件标题");
		dfeTemp.setAttributeName("subject");
		dfeTemp.setDataType("String");      
		dfeTemp.setId("");
		dfeTemp.setValue(elecdocument.getGwelement().getTitle());
		ls.add(dfeTemp);

//		dfeTemp=new DocumentFormExport();
//		dfeTemp.setElementName("公文种类");
//		dfeTemp.setAttributeName("docType");
//		dfeTemp.setDataType("String");      
//		dfeTemp.setId("");
//		dfeTemp.setValue(record.getDocType());
//		ls.add(dfeTemp);

		dfeTemp=new DocumentFormExport();       
		dfeTemp.setElementName("公文类型");
		dfeTemp.setAttributeName("edocType");
		dfeTemp.setDataType("int");     
		dfeTemp.setId("");
		dfeTemp.setValue(_toString(0));
		ls.add(dfeTemp);

		dfeTemp=new DocumentFormExport();       
		dfeTemp.setElementName("行文类型");
		dfeTemp.setAttributeName("sendType");
		dfeTemp.setDataType("String");      
		dfeTemp.setId("");
		dfeTemp.setValue("6");
		ls.add(dfeTemp);

		dfeTemp=new DocumentFormExport();       
		dfeTemp.setElementName("公文文号");
		dfeTemp.setAttributeName("docMark");
		dfeTemp.setDataType("String");      
		dfeTemp.setId("");
		dfeTemp.setValue(elecdocument.getGwelement().getWenhao());
		ls.add(dfeTemp);

		dfeTemp=new DocumentFormExport();       
		dfeTemp.setElementName("内部文号");
		dfeTemp.setAttributeName("serialNo");
		dfeTemp.setDataType("String");      
		dfeTemp.setId("");
		dfeTemp.setValue("");
		ls.add(dfeTemp);

//		dfeTemp=new DocumentFormExport();       
//		dfeTemp.setElementName("文件密级");
//		dfeTemp.setAttributeName("secretLevel");
//		dfeTemp.setDataType("String");      
//		dfeTemp.setId("");
//		dfeTemp.setValue(record.getSecretLevel());
//		ls.add(dfeTemp);
//
//		dfeTemp=new DocumentFormExport();       
//		dfeTemp.setElementName("紧急程度");
//		dfeTemp.setAttributeName("urgentLevel");
//		dfeTemp.setDataType("String");      
//		dfeTemp.setId("");
//		dfeTemp.setValue(record.getUrgentLevel());
//		ls.add(dfeTemp);
//		User user = new User();
//		user.setId(-1l);
//		user.setName(record.getIssuer());
//		AppContext.putThreadContext("SESSION_CONTEXT_USERINFO_KEY", user);
		dfeTemp=new DocumentFormExport();       
		dfeTemp.setElementName("建文人");
		dfeTemp.setAttributeName("createPerson");
		dfeTemp.setDataType("String");      
		dfeTemp.setId("");
		dfeTemp.setValue(elecdocument.getGwelement().getBaosongname());
		ls.add(dfeTemp);

		dfeTemp=new DocumentFormExport();       
		dfeTemp.setElementName("保密期限");
		dfeTemp.setAttributeName("keepPeriod");
		dfeTemp.setDataType("int");     
		dfeTemp.setId("");
		dfeTemp.setValue(_toString(0));  // ?? 是否是永久保存
		ls.add(dfeTemp);

	
		

		
//		OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
//		try {
//			if(record.getRecOrgId().startsWith("cgs_")) {
//				List<V3xOrgEntity>  list = orgManager.getEntity(V3xOrgDepartment.class.getSimpleName(), "code", record.getRecOrgId(), null);
//				dfeTemp=new DocumentFormExport();       
//				dfeTemp.setElementName("主送单位Id");
//				dfeTemp.setAttributeName("sendToId");
//				dfeTemp.setDataType("String");      
//				dfeTemp.setId("");
//				dfeTemp.setValue("Department|"+list.get(0).getId());
//				ls.add(dfeTemp);
//				
//				dfeTemp=new DocumentFormExport();       
//				dfeTemp.setElementName("主送单位");
//				dfeTemp.setAttributeName("sendTo");
//				dfeTemp.setDataType("String");      
//				dfeTemp.setId("");
//				dfeTemp.setValue(list.get(0).getName());
//				ls.add(dfeTemp);
//			
//			} else {
//				List<V3xOrgEntity>  list = orgManager.getEntity(V3xOrgAccount.class.getSimpleName(), "code", record.getRecOrgId(), null);
		dfeTemp=new DocumentFormExport();       
		dfeTemp.setElementName("主送单位Id");
		dfeTemp.setAttributeName("sendToId");
		dfeTemp.setDataType("String");      
		dfeTemp.setId(String.valueOf(elecdocument.getAccountId()));
		dfeTemp.setValue("Account|"+elecdocument.getAccountId());
		ls.add(dfeTemp);

		dfeTemp=new DocumentFormExport();       
		dfeTemp.setElementName("主送单位");
		dfeTemp.setAttributeName("sendTo");
		dfeTemp.setDataType("String");      
		dfeTemp.setId("");
		dfeTemp.setValue("");
		ls.add(dfeTemp);

		dfeTemp=new DocumentFormExport();       
		dfeTemp.setElementName("发文单位");
		dfeTemp.setAttributeName("sendUnit");
		dfeTemp.setDataType("String");      
		dfeTemp.setId("");
		dfeTemp.setValue(elecdocument.getExchange().getSender());
		ls.add(dfeTemp);

		dfeTemp=new DocumentFormExport();       
		dfeTemp.setElementName("签发人");
		dfeTemp.setAttributeName("issuer");
		dfeTemp.setDataType("String");      
		dfeTemp.setId("");
		dfeTemp.setValue(elecdocument.getGwelement().getBaosongname());
		ls.add(dfeTemp);
		//        
		dfeTemp=new DocumentFormExport();       
		dfeTemp.setElementName("签发日期");
		dfeTemp.setAttributeName("signingDate");
		dfeTemp.setDataType("Date");        
		dfeTemp.setId("");
		if(elecdocument.getExchange().getSendtime() != null) {
			dfeTemp.setValue(elecdocument.getExchange().getSendtime());
			ls.add(dfeTemp);
		}
		

		//        dfeTemp=new DocumentFormExport();       
		//        dfeTemp.setElementName("印发单位");
		//        dfeTemp.setAttributeName("printUnit");
		//        dfeTemp.setDataType("String");      
		//        dfeTemp.setId("");
		//        dfeTemp.setValue(edocSummary.getPrintUnit());
		//        ls.add(dfeTemp);

		//		dfeTemp=new DocumentFormExport();       
		//		dfeTemp.setElementName("印发份数");
		//		dfeTemp.setAttributeName("copies");
		//		dfeTemp.setDataType("int");     
		//		dfeTemp.setId("");
		//		dfeTemp.setValue(_toString(record.getCopies()));
		//		ls.add(dfeTemp);

		//        dfeTemp=new DocumentFormExport();       
		//        dfeTemp.setElementName("主题词");
		//        dfeTemp.setAttributeName("keywords");
		//        dfeTemp.setDataType("String");      
		//        dfeTemp.setId("");
		//        dfeTemp.setValue(edocSummary.getKeywords());
		//        ls.add(dfeTemp);
		//        
		//        dfeTemp=new DocumentFormExport();       
		//        dfeTemp.setElementName("打印人");
		//        dfeTemp.setAttributeName("printer");
		//        dfeTemp.setDataType("String");      
		//        dfeTemp.setId("");
		//        dfeTemp.setValue(edocSummary.getPrinter());
		
		        dfeTemp=new DocumentFormExport();       
		        dfeTemp.setElementName("联系人");
		        dfeTemp.setAttributeName("string3");
		        dfeTemp.setDataType("String");      
		        dfeTemp.setId("");
		        dfeTemp.setValue(elecdocument.getGwelement().getBaosongname());
		
		        dfeTemp=new DocumentFormExport();       
		        dfeTemp.setElementName("联系方式");
		        dfeTemp.setAttributeName("phone");
		        dfeTemp.setDataType("String");      
		        dfeTemp.setId("");
		        dfeTemp.setValue("");
		
//		ls.add(dfeTemp);

		//        customEdocElementExport(ls,edocSummary);

		return ls;
	}
	private static String _toString(Integer value)
	{
		return value==null?"":value.toString();
	}
	private static String _toString(Long value)
	{
		return value==null?"":value.toString();
	}
	private static String _toString(Date value)
	{
		return value==null?"":value.toString();
	}
	private static void customEdocElementExport(List<DocumentFormExport> ls,EdocSummary edocSummary) {
		String[][] type={{"Date","date","getDate"},{"String","varchar","getVarchar"},{"Integer","integer","getInteger"},{"Double","decimal","getDecimal"},{"String","list","getList"},{"String","text","getText"}};
		for (int i = 0; i < type.length; i++) {
			for (int y = 1; y < 21; y++) {
				try {
					java.lang.reflect.Method method=null;
					try {
						String tempMethodName=type[i][2]+y;
						if("getText11".equals(tempMethodName))
						{
							break;
						}
						method = EdocSummary.class.getDeclaredMethod(tempMethodName);
					} catch (Exception e) {
						e.printStackTrace();
						break;
					}
					if(method==null){break;}
					Object object=method.invoke(edocSummary);
					if(object!=null){
						DocumentFormExport  dfeTemp=new DocumentFormExport();       
						dfeTemp.setElementName("自定义公文元素");
						dfeTemp.setAttributeName(type[i][1]+y);
						dfeTemp.setDataType(type[i][0]);        
						dfeTemp.setId("");
						dfeTemp.setValue(object.toString());
						ls.add(dfeTemp);
					}
				} catch (Exception e) {
					log.error("", e);
					break;
				}
			}
		}
	}
}
