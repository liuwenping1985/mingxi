package com.seeyon.ctp.common.office;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.IOFileFilter;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.barCode.manager.BarCodeManager;
import com.seeyon.ctp.common.cache.CacheAccessable;
import com.seeyon.ctp.common.cache.CacheFactory;
import com.seeyon.ctp.common.cache.CacheMap;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.encrypt.CoderFactory;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.filemanager.manager.Util;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.office.manager.OfficeBakFileManager;
import com.seeyon.ctp.common.office.po.OfficeBakFile;
import com.seeyon.ctp.common.office.trans.manager.OfficeTransManager;
import com.seeyon.ctp.common.office.trans.util.OfficeTransHelper;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.login.online.OnlineManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.portaltemplate.manager.PortalTemplateManager;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.system.signet.domain.V3xDocumentSignature;
import com.seeyon.v3x.system.signet.domain.V3xHtmDocumentSignature;
import com.seeyon.v3x.system.signet.domain.V3xSignet;
import com.seeyon.v3x.system.signet.enums.V3xHtmSignatureEnum;
import com.seeyon.v3x.system.signet.manager.SignetManager;
import com.seeyon.v3x.system.signet.manager.V3xHtmDocumentSignatManager;

import DBstep.iMsgServer2000;

/**
 * 
 * 
 * @author <a href="mailto:tanmf@seeyon.com">Tanmf</a>
 * @version 1.0 2006-12-12
 */
public class HandWriteManager {
	private OnlineManager onlineManager;
	private OrgManager orgManager;
	private PortalTemplateManager portalTemplateManager;
	private OfficeBakFileManager officeBakFileManager;
	
	public void setOfficeBakFileManager(OfficeBakFileManager officeBakFileManager) {
		this.officeBakFileManager = officeBakFileManager;
	}

	public OfficeBakFileManager getOfficeBakFileManager() {
		return officeBakFileManager;
	}
	public void setPortalTemplateManager(PortalTemplateManager portalTemplateManager) {
		this.portalTemplateManager = portalTemplateManager;
	}

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

	private static Log log = LogFactory.getLog(HandWriteManager.class);
	
	private static String rc="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources";
	
	
	private Long fileId;

	private Date createDate;
	
	private Long originalFileId;
	
	private Date originalCreateDate;
	
	private boolean needClone = false;
	
	private boolean needReadFile = false;

	private FileManager fileManager;
	
	private SignetManager signetManager;
	
	private OfficeTransManager officeTransManager;

	
	private BarCodeManager barCodeManager;
	
	private AttachmentManager attachmentManager;
	
	private V3xHtmDocumentSignatManager htmSignetManager;
	
	public void setHtmSignetManager(V3xHtmDocumentSignatManager htmSignetManager) {
		this.htmSignetManager = htmSignetManager;
	}
	
	public void setAttachmentManager(AttachmentManager attachmentManager) {
		this.attachmentManager = attachmentManager;
	}


	public void setOnlineManager(OnlineManager onlineManager) {
        this.onlineManager = onlineManager;
    }

	public OfficeTransManager getOfficeTransManager() {
		return officeTransManager;
	}

	public void setOfficeTransManager(OfficeTransManager officeTransManager) {
		this.officeTransManager = officeTransManager;
	}	
	
	/*private synchronized void init() {
	    // TODO
		if(onLineManager == null){
			orgManager = (OrgManager) AppContext.getBean("OrgManager");
			onLineManager = (OnLineManager)AppContext.getBean("onLineManager");
		}
	}
	public HandWriteManager()
	{
		init();		
	}*/

	public void setSignetManager(SignetManager signetManager)
	{		
		this.signetManager=signetManager;
	}

	public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}

	
	public void setBarCodeManager(BarCodeManager barCodeManager) {
		this.barCodeManager = barCodeManager;
	}
	/**
	 * 调入用户有权使用的印章列表
	 * 【注意】修改代理人名称的中括号的格式时，需要同步修改LoadSinature 方法，改方法依赖代理人名称格式中的中括号
	 */
	public boolean LoadSinatureList(iMsgServer2000 msgObj) throws BusinessException {
		User user = AppContext.getCurrentUser();
        String affairMemberName = msgObj.GetMsgByName("affairMemberName");
        boolean isProxy = isProxy(msgObj);
		try{
			String mMarkList="";
			List<V3xSignet> ls = signetManager.findSignetByMemberId(user.getId());
            List<V3xSignet> proxySignetList = Collections.emptyList();
            //代理的时候，当前登录人的id和affairMemberId不相等，这时，只查询被代理的签章
            if (isProxy) {
                String affairMemberId = msgObj.GetMsgByName("affairMemberId");
                proxySignetList = signetManager.findSignetByMemberId(Long.valueOf(affairMemberId));
            }
            
			Collections.sort(ls, new Comparator<V3xSignet>() {
	            public int compare(V3xSignet o1, V3xSignet o2) {
	                return o1.getMarkDate().compareTo(o2.getMarkDate());
	            }
	        });
			
			//代理人处理的时候，要显示为：印章名[被代理人姓名]
			List<Map<String,Object>> markList = new ArrayList<Map<String,Object>>();
            for (V3xSignet signet : proxySignetList) {
                String markName = signet.getMarkName() + "[" + affairMemberName + "]";
                mMarkList += markName + "\r\n";
                
                Map<String,Object> signetObj = new HashMap<String,Object>();
                signetObj.put("name", markName);
                signetObj.put("id", signet.getId());
                markList.add(signetObj);
            }
			
            for (V3xSignet signet : ls) {
                String markName = signet.getMarkName();
                if(!user.getLoginAccount().equals(signet.getOrgAccountId())){
                	markName =  markName + "("+Functions.getAccountShortName(signet.getOrgAccountId())+")";
                }
                mMarkList += markName + "\r\n";
                Map<String,Object> signetObj = new HashMap<String,Object>();
                signetObj.put("name", markName);
                signetObj.put("id", signet.getId());
                markList.add(signetObj);
            }
            msgObj.SetMsgByName("MARKLIST",JSONUtil.toJSONString(markList));
			msgObj.SetMsgByName("JsonMode","true");
			msgObj.SetMsgByName("SIGNATRUELIST",JSONUtil.toJSONString(markList));   //文单印章 iWebrevision
		    msgObj.MsgError("");				//清除错误信息
        } catch (Exception e) {
            log.error(e);
            throw new BusinessException(e.getMessage(), e);
        }
		return true;		
	}
	
	//根据印章名称，密码，调入印章图片
    public boolean LoadSinature(iMsgServer2000 msgObj) throws BusinessException {
        String mMarkName = msgObj.GetMsgByName("IMAGENAME"); //取得文档名		 
        //String mUserName=msgObj.GetMsgByName("USERNAME");		//取得文档名
        String mPassword = msgObj.GetMsgByName("PASSWORD"); //取得文档类型
        String mMarkId = msgObj.GetMsgByName("IMAGEID");//印章ID
        String affairMemberId = msgObj.GetMsgByName("affairMemberId");
        String affairMemberName = msgObj.GetMsgByName("affairMemberName");
        msgObj.MsgTextClear();

        msgObj.SetMsgByName("affairMemberId", affairMemberId);//当前待办所属人员信息不能被清空
        msgObj.SetMsgByName("affairMemberName", affairMemberName);//当前待办所属人员信息不能被清空

        V3xSignet signet = null;
        try {
            //印章名称中含有"["时，就表示是代理的印章
        	 boolean isProxy = mMarkName.lastIndexOf("[") != -1 && mMarkName.lastIndexOf("]") != -1;
            //代理的时候，当前登录人的id和affairMemberId不相等，这时，需要把增加的代理信息去掉，否则印章判断会失败
        	 if (isProxy) {
                 mMarkName = mMarkName.substring(0, mMarkName.lastIndexOf("["));
             } else {
                 affairMemberId = null;
             }
             //signet = signetManager.findByMarknameAndPassword(mMarkName, mPassword, affairMemberId);
         	signet = signetManager.findByIdAndPassword(mMarkId, mPassword, affairMemberId);
            if (signet != null) {
                byte[] b = signet.getMarkBodyByte();//
                msgObj.SetMsgByName("IMAGETYPE", Strings.isBlank(signet.getImgType())?".jpg":signet.getImgType()); //设置图片类型
                /*
                String signetPath = SystemEnvironment.getBaseFolder() + "/signet/xxjsb.gif";
                
                File imageObj = new File(signetPath);
                if (imageObj.exists()){
                	byte[] imageData = file2byte(imageObj);
                	if(imageData != null){
                		b = imageData;
                	}
                }
                */
                msgObj.MsgFileBody(b); //将文件信息打包
                msgObj.SetMsgByName("SIGNTYPE", null!=signet.getMarkType()? Integer.toString(signet.getMarkType()) :"1" ); //（手写签名0，单位印章1）默认值1  
                msgObj.SetMsgByName("STATUS", ResourceBundleUtil.getString(rc, "ocx.alert.opensucceed.label")); //设置状态信息
                msgObj.SetMsgByName("ZORDER", "5"); //4:在文字上方 5:在文字下
                msgObj.MsgError(""); //清除错误信息
            } else {
                msgObj.MsgError(ResourceBundleUtil.getString(rc, "ocx.alert.pwderr.label"));
            }
        } catch (Exception e) {
            throw new BusinessException(e.getMessage(), e);
        }
        return true;
    }
    
	
	/**
	 * 调用文档的签章记录
	 * @param msgObj
	 * @return
	 * @throws BusinessException
	 */
	public boolean LoadDocumentSinature(iMsgServer2000 msgObj) throws BusinessException {

		String mRecordId=msgObj.GetMsgByName("RECORDID");
		
		String affairMemberId=msgObj.GetMsgByName("affairMemberId");
		String affairMemberName=msgObj.GetMsgByName("affairMemberName");
		msgObj.MsgTextClear();
		msgObj.SetMsgByName("affairMemberId",affairMemberId);//当前待办所属人员信息不能被清空
		msgObj.SetMsgByName("affairMemberName",affairMemberName);//当前待办所属人员信息不能被清空
		List<V3xDocumentSignature> ls=null;
		try{			
			ls=signetManager.findDocumentSignatureByDocumentId(mRecordId);
			String mMarkName=ResourceBundleUtil.getString(rc,"ocx.signname.label")+"\r\n";
			String mUserName=ResourceBundleUtil.getString(rc,"ocx.signuser.label")+"\r\n";
			String mDateTime=ResourceBundleUtil.getString(rc,"ocx.signtime.label")+"\r\n";
			String mHostName=ResourceBundleUtil.getString(rc,"ocx.clientip.label")+"\r\n";
			String mMarkGuid=ResourceBundleUtil.getString(rc,"ocx.serialnumber.label")+"\r\n";
			//log.error("DEBUG INFO:签章记录列头数据：("+mMarkName+")("+mUserName+")("+mDateTime+")("+mHostName+")("+mMarkGuid+")");
			for(V3xDocumentSignature ds:ls)
			{
				mMarkName+=ds.getMarkname()+"\r\n";
				mUserName+=ds.getUsername()+"\r\n";
				mDateTime+=Datetimes.formatDatetime(ds.getSignDate())+"\r\n";
				mHostName+=ds.getHostname()+"\r\n";
				mMarkGuid+=ds.getMarkguid()+"\r\n";
			}
			msgObj.SetMsgByName("MARKNAME",mMarkName);
			msgObj.SetMsgByName("USERNAME",mUserName);
			msgObj.SetMsgByName("DATETIME",mDateTime);
			msgObj.SetMsgByName("HOSTNAME",mHostName);
			msgObj.SetMsgByName("MARKGUID",mMarkGuid);
			msgObj.SetMsgByName("STATUS","调入成功!");  	//设置状态信息
			msgObj.MsgError("");				//清除错误信息
		}catch(Exception e)
		{
			throw new BusinessException(e.getMessage(),e);
		}
		return true;		
	}

	public String ajaxGetOfficeExtension(String fileId) {
	    String extension = "";
	    if ((Strings.isNotBlank(fileId)) && (NumberUtils.isNumber(fileId))) {
	      try {
	        V3XFile file = this.fileManager.getV3XFile(Long.valueOf(fileId));
	        String mimeType = "";
	        if(file!=null){
	        	mimeType = file.getMimeType();
	        	if ("application/vnd.openxmlformats-officedocument.wordprocessingml.document".equals(mimeType))
	        		extension = "docx";
	        	else if ("application/msword".equals(mimeType))
	        		extension = "doc";
	        	else if ("application/vnd.ms-excel".equals(mimeType))
	        		extension = "xls";
	        	else if ("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet".equals(mimeType))
	        		extension = "xlsx";
	        }
	      }
	      catch (NumberFormatException e) {
	        log.error("", e);
	      } catch (BusinessException e) {
	        log.error("", e);
	      }
	    }
	    return extension;
	  }
	private boolean isFileExsit(String path ,Long fileId){
		File ftemp = new File(path+fileId);	
		if(ftemp.exists() && ftemp.isFile()){
			return true;
		}else{
			return false;
		}
	}
	/**
	 * 调入文件之后,直接把数据放到控件服务器对象msgObj中
	 * 调入时查询备份文件ID组合后放如控件，提供花脸查看功能
	 * @return
	 * @throws BusinessException
	 */
	public boolean LoadFile(iMsgServer2000 msgObj) throws Exception {

		// 没有创建实践，说明是新建
		if (createDate == null) {
			msgObj.SetMsgByName("STATUS", "打开成功!");
			msgObj.MsgError("");
			return true;
		}
		
		Long loadFileId = originalFileId != null ? originalFileId : fileId;
		Date loadCreateDate = originalCreateDate != null ? originalCreateDate : createDate;
		String filePath = this.fileManager.getFolder(loadCreateDate, true) + File.separator ;
		
		
		V3XFile	tempFile = fileManager.getV3XFile(loadFileId);
		if(tempFile != null){
			if(tempFile.getUpdateDate() != null){
				filePath = this.fileManager.getFolder(tempFile.getUpdateDate(), true)+ File.separator ;
				boolean isFileExsit = isFileExsit(filePath,loadFileId);
				if(!isFileExsit){
					filePath = this.fileManager.getFolder(tempFile.getCreateDate(), true)+ File.separator ;
				}
			}else{
				filePath = this.fileManager.getFolder(tempFile.getCreateDate(), true)+ File.separator ;
			}
		}
		String loadBack=msgObj.GetMsgByName("loadBack");
		String loadFileBackName=msgObj.GetMsgByName("backFileName");
		if("true".equals(loadBack) && Strings.isNotBlank(loadFileBackName)){
			filePath = filePath+loadFileBackName;
		}else{
			String backFileName = "";
			if(tempFile !=null ){
				backFileName = findLastBackFiledName(this.fileManager.getFolder(tempFile.getCreateDate(), true),loadFileId);
			}
			msgObj.SetMsgByName("backFileName",backFileName);
			filePath += loadFileId;
		}
		
		if(needReadFile){
			String newfilePath = filePath;
			try {
				newfilePath = CoderFactory.getInstance().decryptFileToTemp(filePath);
			} catch (Exception e) {
				log.error("读取文件失败", e);
				msgObj.MsgError("打开失败!");
				return false;
			}
			if (msgObj.MsgFileLoad(newfilePath)) {
				if(tempFile==null){
					tempFile=fileManager.getV3XFile(loadFileId);
				}
				//检查备份
				String checkBack=msgObj.GetMsgByName("checkBack");
				if(!"false".equals(checkBack)){					
					if(tempFile!=null){
				        //设置调入文档备份文档的IDs
						msgObj.SetMsgByName("backupIds",findBackFileIds(tempFile.getFilename()));
					}
				}
				if(tempFile!=null){
					Date officeUpateTime=tempFile.getUpdateDate();
					if(officeUpateTime==null){officeUpateTime=tempFile.getCreateDate();}
					if(officeUpateTime!=null)
					{
						msgObj.SetMsgByName("OfficeUpdateTime",Long.toString(officeUpateTime.getTime()));
					}					
				}
				msgObj.SetMsgByName("STATUS", "打开成功!");
				msgObj.MsgError("");
				return true;
			}
			else{
				msgObj.MsgError("打开失败!");
				return false;
			}
		}
		else{
			msgObj.SetMsgByName("STATUS", "打开成功!");
			msgObj.MsgError("");
		}
		return true;
	}
	/**
	 * 保存文档签章记录
	 * @param msgObj
	 * @return
	 * @throws BusinessException
	 */
	public boolean saveDocumentSignatureRecord(iMsgServer2000 msgObj,HttpServletRequest request) throws BusinessException {
	    V3xDocumentSignature ds=new V3xDocumentSignature();
		ds.setIdIfNew();
		ds.setRecordId(msgObj.GetMsgByName("RECORDID"));//取得模板编号
		String markNameToSave=msgObj.GetMsgByName("MARKNAME");
		String affairMemberName=msgObj.GetMsgByName("affairMemberName");
		boolean isProxy=isProxy(msgObj);
		if(Strings.isNotBlank(markNameToSave)){
			if(isProxy&&markNameToSave.lastIndexOf("[")!=-1){
				markNameToSave=markNameToSave.substring(0,markNameToSave.lastIndexOf("["));
			}
		}
		ds.setMarkname(markNameToSave);//设置印章名称
		//代理人签章的时候需要单独处理：代理人名称（代理XX）
		String userName=AppContext.currentUserName();
		if(isProxy){
			userName=userName+"(代理"+affairMemberName+")";//盖章用户名称
		}
		ds.setUsername(userName);//盖章用户名称
		
		ds.setSignDate(new Timestamp(Datetimes.parseDatetime(msgObj.GetMsgByName("DATETIME")).getTime()));
		ds.setMarkguid(msgObj.GetMsgByName("MARKGUID"));
		ds.setHostname(Strings.getRemoteAddr(request));
		try{
		  signetManager.save(ds);
		}catch(Exception e)
		{
			throw new BusinessException(e);
		}
		return true;		
	}

	/**
	 * 向客户端插入图片
	 * @param msgObj
	 * @return
	 * @throws Exception
	 */
	public void insertImage(iMsgServer2000 msgObj,HttpServletRequest request)throws  Exception{
		User user = AppContext.getCurrentUser();
		Long accountId = user.getLoginAccount();
		String path=SystemProperties.getInstance().getProperty(SystemProperties.CONFIG_APPLICATION_ROOT_KEY);
		path = Strings.getCanonicalPath(path);
		String url = portalTemplateManager.getAccountLogo(accountId);
		msgObj.MsgFileLoad(path + File.separator + "main" + File.separator + "frames" + File.separator + url);
	}
	/**
	 * 保存文档，如果文档存在，则覆盖，不存在，则添加
	 * 清稿保存时，备份原文件，最多备份5份
	 * @return
	 * @throws BusinessException
	 */
	public boolean saveFile(iMsgServer2000 msgObj) throws Exception {
		log.error("office SaveFile start!");
		if (createDate == null) { 
			createDate = new Date();
		}
		Date today = new Date();
		String newPdfFileId = msgObj.GetMsgByName("newPdfFileId");
        if(Strings.isNotBlank(newPdfFileId))//如果是Word转PDF，则需要新生成ID
			fileId=Long.valueOf(newPdfFileId);
		
		if(needClone){//需要clone
			//originalCreateDate空指针导致调用Office格式模板发送报错	Mazc 2009-11-24
			Date loadCreateDate = originalCreateDate;
			if(loadCreateDate == null){
				String _originalCreateDate = msgObj.GetMsgByName("originalCreateDate");
				if(Strings.isNotBlank(_originalCreateDate)){
					loadCreateDate = Datetimes.parseDatetime(_originalCreateDate);
				}
				else{
					loadCreateDate = createDate;
				}
			}
			try {
				this.fileManager.clone(originalFileId, loadCreateDate, fileId, createDate);
			}
			catch (FileNotFoundException e) {
			}
		}
		String bakOldPath = this.fileManager.getFolder(createDate, true)+ File.separator + fileId;
		
		String filePath = this.fileManager.getFolder(today, true)+ File.separator + fileId;

		//备份物理文件，防止文件丢失。
		
		bakPhysicalFile(filePath,bakOldPath);
		
			
		boolean isSuccessSave = false;
		
		// 标准office的处理

		String editType=msgObj.GetMsgByName("editType");

		if("clearDocument".equals(editType))
		{//清稿保存，进行备份
			V3XFile tempFile=null;
			List<Long> obfList = officeBakFileManager.getOfficeBakFileIds(fileId);
			List<V3XFile> fs = new ArrayList<V3XFile>();
			Long[] fileIds = null;
			if (obfList.size() > 0) {
				fileIds = new Long[obfList.size()];
				for(int i =0;i<obfList.size();i++){
					fileIds[i] = obfList.get(i);
				}
				fs = fileManager.getV3XFile(fileIds);
 			}
//			List<V3XFile> fs=fileManager.findByFileName("copy"+fileId.toString());
			while(fs!=null && fs.size()>=5){
				tempFile=fs.remove(0);
				fileManager.deleteFile(tempFile.getId(),true);
				officeBakFileManager.delete(tempFile.getId());
			}
		
		try{
			/************************************性能优化开始**********************************/
			V3XFile v3xFile = fileManager.clone(fileId);
			OfficeBakFile officeBakFile = new OfficeBakFile();
			officeBakFile.setFileId(v3xFile.getId());
			officeBakFile.setSourceId(fileId);
			officeBakFileManager.save(officeBakFile);//保存表间关系
			/************************************性能优化结束**********************************/
			}
			catch(FileNotFoundException e){
				//ignore e
			}
			catch(Exception e){
				//直接新建，清稿没有原文件不需要备份
				//throw new BusinessException(e.getMessage());
				log.error("",e);
			}
		}
		
		String tempFile = SystemEnvironment.getSystemTempFolder() + File.separator + UUIDLong.absLongUUID();
		boolean isDraftTaoHong="draftTaoHong".equals(msgObj.GetMsgByName("draftTaoHong"));//拟文正文套红
		isSuccessSave = msgObj.MsgFileSave(tempFile);
		if(!isSuccessSave){
			log.error("office正文保存失败(msgObj.MsgFileSave),isSuccessSave:"+isSuccessSave+",tempFile:"+tempFile);
		}
		//如果需要转换成标准office正文，加密前先转换
		String notJinge2StandardOffice = msgObj.GetMsgByName("notJinge2StandardOffice");
		if(!"true".equals(notJinge2StandardOffice)){
			boolean toJingge =  Util.jinge2StandardOffice(tempFile, tempFile);
			if(isSuccessSave && !toJingge){
				log.error("office正文转为标准office的时候失败( Util.jinge2StandardOffice).isSuccessSave:"+isSuccessSave+",toJingge:"+toJingge);
			}
			isSuccessSave = toJingge;
		}
		try {
			CoderFactory.getInstance().encryptFile(tempFile, filePath);
		} catch (Exception e) {
			log.error("filePath="+filePath);
			log.error("CoderFactory.getInstance() Exception:",e);
		}
		File f = new File(filePath);
		if(f != null && f.exists())
			msgObj.SetMsgByName("fileSize",f.length()+"");
		log.error("保存文件完成。isSuccessSave="+isSuccessSave);
		if (isSuccessSave) {
		    V3XFile file = fileManager.getV3XFile(fileId);
			// 先删除以保证能触发OFFICE转换
	        Integer category = new Integer(msgObj.GetMsgByName("CATEGORY"));
	        if(officeTransManager != null) {
	        	officeTransManager.clean(fileId, Datetimes.format(today, "yyyyMMdd"));
	        }
		     String stdOffice = msgObj.GetMsgByName("stdOffice");
			if(stdOffice != null && "true".equals(stdOffice)){
				//updateFileNameTo2003(fileId);
				//文档中心历史版本编辑需要插入数据。
				if(!"true".equals(msgObj.GetMsgByName("needInsertToV3XFile"))) return true;
			}
			boolean isNew = false;
			if(null == file){
			    file = new V3XFile();
			    isNew = true;
			}
			file.setId(fileId);
			file.setCategory(category);
			file.setFilename(fileId.toString());
			file.setSize(Long.valueOf(msgObj.MsgFileSize()));
			if("pdf".equalsIgnoreCase(msgObj.GetMsgByName("toFileType"))){
				file.setMimeType("application/pdf");
			}
			else{
				 String realFileType = msgObj.GetMsgByName("realFileType");
				 String mimeType = "msoffice";
				 if (".docx".equals(realFileType))
					 mimeType ="application/vnd.openxmlformats-officedocument.wordprocessingml.document";
			     else if (".doc".equals(realFileType))
			    	 mimeType="application/msword";
			     else if (".xls".equals(realFileType))
			    	 mimeType = "application/vnd.ms-excel";
			     else if (".xlsx".equals(realFileType))
			    	 mimeType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
				 
				 file.setMimeType(mimeType);
			}
			
			
			file.setUpdateDate(today);
			/**
			 * 由于officeTrans暂未迁移，此处删除会引起正文套红失败，暂时屏蔽
			 */
			/*if(!needClone||isDraftTaoHong){
				this.fileManager.deleteFile(fileId, false);
			}*/
			User user = AppContext.getCurrentUser();
			if(user != null){
				file.setCreateMember(user.getId());
				file.setAccountId(user.getAccountId());
			}
			
			/**
			 * 文件Clone.Office转化等都是取CreateDate,所以这个地方设置一下，兼容老代码	
			 */
			file.setCreateDate(today);
			if(!isNew){
				this.fileManager.update(file);
			}else{
				this.fileManager.save(file);
			}
			 
			//更新锁信息
			/*UserUpdateObject os = useObjectList.get(String.valueOf(fileId));
			if(os!=null){
				if(user.getId().equals(os.getUserId())){
					//只能精确到秒，不能精确到毫秒，因为数据库字段保存不了毫秒的值
					os.setLastUpdateTime(file.getUpdateDate());
				}
			}*/
			msgObj.SetMsgByName("STATUS", "保存成功!");
			msgObj.MsgError("");
			
			// 为了适应是否支持转换的判断
			file.setType(com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE.FILE.ordinal());
			if (("msoffice").equals(file.getMimeType()))
				file.setFilename(file.getFilename() + ".doc");

			try {
				if (OfficeTransHelper.allowTrans(file)) {
				    officeTransManager.clean(fileId, Datetimes.format(today, "yyyyMMdd")); 
					officeTransManager.generate(fileId, today, true);
				}
			} catch(Exception e) {
				log.error("保存正文时，office转换服务出错", e);
			}
			String loadBack=msgObj.GetMsgByName("loadBack");
			String backFileName=msgObj.GetMsgByName("backFileName");
			if("true".equals(loadBack)){
				log.error(user.getName()+",id："+user.getId()+",修复正文。修复正文Id："+fileId+",备份文件Id:"+backFileName);
			}
			
			//删除临时文件中的解密后的文档
	        String stdTempFilePath = SystemEnvironment.getSystemTempFolder() + File.separator + fileId + "Std_Office";
	        File stdTempFIle = new File(stdTempFilePath);
	        if(stdTempFIle.exists() && stdTempFIle.isFile()){
	            //删除文件
	            try {
	                //有线程同步风险，暂时这样写
                    stdTempFIle.delete();
                } catch (SecurityException e) {
                    log.error("删除Office零时文件缓存失败", e);
                }
	        }
			
			return true;
		}
		
		msgObj.MsgError("saveFaile!");
		log.error("保存offiec正文,isSuccessSave:"+isSuccessSave);
		return false;
	}
//	private void  updateFileNameTo2003(Long fileId){
//
//		V3XFile file = null;
//		try {
//			file = fileManager.getV3XFile(fileId);
//		} catch (BusinessException e) {
//			log.error(e);
//		}
//		if(file!=null){
//			String fileName = file.getFilename();
//			if(Strings.isNotBlank(fileName)){
//				String[] suffix = fileName.split("[.]");
//				if(suffix!=null && suffix.length>1){
//					int len = suffix.length;
//					if("docx".equalsIgnoreCase(suffix[len-1])){
//						fileName = suffix[len-2]+".doc";
//					}else if("xlsx".equalsIgnoreCase(suffix[len-1])){
//						fileName = suffix[len-2]+".xls";
//					}else if("pptx".equalsIgnoreCase(suffix[len-1])){
//						fileName = suffix[len-2]+".ppt";
//					}
//				}
//			}
//			file.setFilename(fileName);
//			fileManager.update(file);
//		}
//	}
	
	/**
	 * 根据filedId删除file
	 */
	public boolean deleteFile(iMsgServer2000 msgObj) throws Exception {
			File file = null;
			if(Strings.isNotBlank(fileId.toString())){
				file = this.fileManager.getFile(fileId);
			}
			if(file != null && "pdf".equalsIgnoreCase(msgObj.GetMsgByName("toFileType"))){
					this.fileManager.deleteFile(fileId, true);
			}
			msgObj.SetMsgByName("STATUS", "保存成功!");
			msgObj.MsgError("");
			return true;
	}
	
	private void bakPhysicalFile(String filePath,String oldPath) {
		// 公文正文备份
		//命名规则：原文件名_时刻（到秒）.bak
		//存放路径：Office正文原始文件路径下
		//比如原始office正文存放在e:\\ufseeyon\group\base\\upload\2010\01\20下，则备份文件也放到这个路径下，主要方便运维同事查找，存在的问题是不能做增量备份
		//todo:流程结束，备份文件删除
		try {
			String now = Datetimes.format(new Date(), "yyyyMMddHHmmss");
			String contentFileBak=filePath+"_"+now+".bak";
			File f=new File(oldPath);
			if(f.exists()){
				FileUtils.copyFile(f, new File(contentFileBak));
			}
		}
		catch (Exception e) {
			log.error("公文正文内容备份异常 ：" + fileId, e);
		}
	}
	/**
	 * 发送处理后的数据包
	 * 
	 * @param response
	 */
	public void sendPackage(HttpServletResponse response, iMsgServer2000 msgObj) {
		/*ServletOutputStream out = null;
		try {
			out = response.getOutputStream();

			out.write(msgObj.MsgVariant());
			out.flush();
		}
		catch (Exception e) {
		}
		finally {
			if (out != null) {
				try {
					out.close();
				}
				catch (IOException e) {
				}
			}
		}*/
		msgObj.SendPackage(response);
	}

	/**
	 * 从request中读取参数，并写道iMsgServer2000中去
	 * 
	 * @param request
	 *            由controller传过来
	 * @param iMsgServer2000
	 */
	public void readVariant(HttpServletRequest request, iMsgServer2000 msgObj) {
		/*byte[] bs = null;
		try {
			InputStream in = request.getInputStream();
			if (in != null) {
				bs = org.apache.commons.io.IOUtils.toByteArray(in);
			}
		}
		catch (IOException e1) {
		}

		if (bs != null) {
			msgObj.MsgVariant(bs);
		}
		*/
		msgObj.ReadPackage(request);
		

		fileId = Long.valueOf(msgObj.GetMsgByName("RECORDID"));
		createDate = Datetimes.parseDatetime(msgObj.GetMsgByName("CREATEDATE"));
		
		String _originalFileId = msgObj.GetMsgByName("originalFileId");
		needClone = _originalFileId != null && !"".equals(_originalFileId.trim());
		
		needReadFile = Boolean.parseBoolean(msgObj.GetMsgByName("needReadFile"));
		
		if(needClone){
		    String _originalCreateDate = msgObj.GetMsgByName("originalCreateDate");
			originalFileId = Long.valueOf(_originalFileId);
			originalCreateDate = Datetimes.parseDatetime(_originalCreateDate);
		}
	}
	
	//=============================================避免office正文多人同时修改代码开始===================================
	//用office的处理文件ID做为key保存的修改记录
	//private static Map<String,UserUpdateObject> useObjectList=new Hashtable<String,UserUpdateObject>();
	private final static CacheAccessable cacheFactory = CacheFactory.getInstance(HandWriteManager.class);
	private static CacheMap<String,UserUpdateObject> useObjectList = cacheFactory.createMap("FlowId");
	
	public static Map<String, UserUpdateObject> getUseObjectList() {
		return useObjectList.toMap();
	}
	public static void setUseObjectList(Map<String, UserUpdateObject> omap) {
		useObjectList.replaceAll(omap);
	}
	//修改对象,放入对象修改列表
	public synchronized UserUpdateObject editObjectState(String objId)
	{
		
		String from = Constants.login_sign.stringValueOf(AppContext.getCurrentUser().getLoginSign());
		
		if(objId==null || "".equals(objId)){return null;}
		User user= AppContext.getCurrentUser();
		UserUpdateObject os=null;
		os=useObjectList.get(objId);
		if(os==null)
		{//无人修改
			os=new UserUpdateObject();
			try{
				os.setLastUpdateTime(user.getLoginTimestamp());
				os.setObjId(objId);			
				os.setUserId(user.getId());
				os.setUserName(user.getName());
				os.setFrom(from);
				addUpdateObj(os);
			}catch(Exception e)
			{	
				log.error("", e);
			}
		}else{
			if(os.getUserId().longValue()==user.getId().longValue() && Strings.equals(os.getFrom(), from))
			{
				os.setCurEditState(false);
			}
			else
			{
				//有用户修改时，要判断用户是否在线,如果用户不在线，删除修改状态
				boolean editUserOnline=true;
				V3xOrgMember member = null; //当前office控件编辑用户
				try{
					member = orgManager.getEntityById(V3xOrgMember.class, os.getUserId());
					boolean isSameLogin  = onlineManager.isSameLogin(member.getLoginName(), os.getLastUpdateTime()) ;
					editUserOnline = onlineManager.isOnline(member.getLoginName()) && isSameLogin;
					
				}catch(Exception e1){
					log.warn("检查文档是否被编辑，文档编辑用户不存在[" + os.getUserId() + "]", e1);					
				}
				if(editUserOnline)
				{
					os.setCurEditState(true);
				}
				else
				{
					//编辑用户已经离线，修改文档编辑人为当前用户
					os.setUserId(user.getId());
					os.setCurEditState(false);		
					os.setLastUpdateTime(user.getLoginTimestamp());
				}
			}						
		}
		return os;
	}
	//检查对象是否被修改
	public synchronized UserUpdateObject checkObjectState(String objId)
	{
		UserUpdateObject os=null;
		os=useObjectList.get(objId);
		if(os==null){os=new UserUpdateObject();}
		return os;
	}
	
	public  synchronized boolean deleteUpdateObj(String objId ){
		User user=AppContext.getCurrentUser();
		if(user==null) return true;
		long userId = user.getId();
		return deleteUpdateObj(objId, String.valueOf(userId));
	}
	
	public  synchronized void deleteUpdateObjs(String handWriteKeys ){
		User user=AppContext.getCurrentUser();
		if(user!=null){
			long userId = user.getId();
			if(Strings.isNotEmpty(handWriteKeys)){
	    		String[] objIds = handWriteKeys.split("[,]");
	    		for(String objId : objIds){
	    			deleteUpdateObj(objId, String.valueOf(userId));
	    		}
	    	}
		}
	}
	/**
	 * 解锁
	 * @param objId  解锁对象ID ，如公文正文的ID
	 * @param userId 当前用户的ID
	 * @return
	 */
	public synchronized boolean deleteUpdateObj(String objId,String userId )
	{
		UserUpdateObject os=null;
		os=useObjectList.get(objId);
		
		if(os==null || Strings.isBlank(userId)){return true;}
		String from = Constants.login_sign.stringValueOf(AppContext.getCurrentUser().getLoginSign());
		if(Long.valueOf(userId).equals(os.getUserId()) && Strings.equals(from, os.getFrom()))
		{
			useObjectList.remove(objId);
			//发送集群通知
//			String[] so= new String[2];
//			so[0] = objId;
//			so[1] = userId;
//			NotificationManager.getInstance().send(NotificationType.EdocUserOfficeObjectRomoveOffice, so);
		}
		return true;
	}
	public synchronized boolean addUpdateObj(UserUpdateObject uo)
	{		
		useObjectList.put(uo.getObjId(),uo);	
//		发送集群通知
//		NotificationManager.getInstance().send(NotificationType.EdocUserOfficeObjectAddOffice, uo);
		return true;
	}
	//=============================================避免office正文多人同时修改代码结束===================================
	
	
	private String findBackFileIds(String fn){
		int ic = 0;
		String ids = "";
		// List<V3XFile> fs=fileManager.findByFileName("copy"+fn);
		List<V3XFile> fs = new ArrayList<V3XFile>();
		List<Long> obfList = new ArrayList<Long>();
		if(fn.indexOf(".") != -1){
			fn = fn.substring(0,fn.indexOf("."));
		}
		if (NumberUtils.isNumber(fn)) {//fn是文件Id,不是文件名时
			obfList = officeBakFileManager.getOfficeBakFileIds(Long.parseLong(fn));
		}
		try {
			Long[] fileIds = null;
			if (obfList.size() > 0) {
				fileIds = new Long[obfList.size()];
				for (int i = 0; i < obfList.size(); i++) {
					fileIds[i] = obfList.get(i);
				}
				fs = fileManager.getV3XFile(fileIds);
			}
			for (V3XFile tempFile : fs) {
				if (ic != 0) {
					ids += ",";
				}
				ic++;
				ids += tempFile.getId();
			}
		} catch (BusinessException e) {
			log.error("findBackFileIds报错", e);
		}
		return ids;
	}
	
	private String findLastBackFiledName(String fileFolder,final Long loadFileId){
		File backFileFolder = new File(fileFolder);
		
		if(!backFileFolder.isDirectory()){
			return "";
		}
		@SuppressWarnings("unchecked")
		Collection<File> backFileList = FileUtils.listFiles(backFileFolder, new IOFileFilter() {
			@Override
			public boolean accept(File file, String fileName) {
				
				return fileName.endsWith(".bak") && fileName.startsWith(loadFileId.toString());
			}
			@Override
			public boolean accept(File file) {
				String fileName = file.getName();
				return fileName.endsWith(".bak") && fileName.startsWith(loadFileId.toString());
			}
		}, null);
		List<File> backFiles = new ArrayList<File>();
		backFiles.addAll(backFileList);
		Collections.sort(backFiles, new Comparator<File>() {
		    @Override
		    public int compare(File file1, File file2) {
		        return Long.valueOf(file2.lastModified()).compareTo(Long.valueOf(file1.lastModified()));
		    }
		});
		Collections.sort(backFiles, Collections.reverseOrder());
		if(backFiles.size()<=0){
			return "";
		}else{
			return backFiles.get(0).getName();
		}
	}
	
	public boolean taoHong(iMsgServer2000 msgObj) throws BusinessException {
		//本段处理是否调用文档时打开模版，
		//还是套用模版时打开模版。
	    String officePath=msgObj.GetMsgByName("TEMPLATE");      //取得文档编号
		String mCommand=msgObj.GetMsgByName("COMMAND");
		//String templetType=msgObj.GetMsgByName("TEMPLATETYPE");
		if("INSERTFILE".equalsIgnoreCase(mCommand))
		{
			String affairMemberId=msgObj.GetMsgByName("affairMemberId");
			String affairMemberName=msgObj.GetMsgByName("affairMemberName");
			msgObj.MsgTextClear();
			msgObj.SetMsgByName("affairMemberId",affairMemberId);//当前待办所属人员信息不能被清空
			msgObj.SetMsgByName("affairMemberName",affairMemberName);//当前待办所属人员信息不能被清空
		
			if(msgObj.MsgFileLoad(officePath))
			{
				msgObj.SetMsgByName("STATUS","打开模板成功!");		//设置状态信息
				msgObj.MsgError("");
			}
			else
			{
				msgObj.MsgError("打开模板失败!");		//设置错误信息
			}
		}
		return true;
	}
	
	public boolean saveClientFile(iMsgServer2000 msgObj) throws Exception {
		if (createDate == null) { 
			createDate = new Date();
		}

		Long fileName = UUIDLong.absLongUUID();

		String filePath = this.fileManager.getFolder(createDate, true)
		+ File.separator + fileName;

		boolean isSuccessSave = false;

		Integer category = new Integer(msgObj.GetMsgByName("CATEGORY"));

		String tempFile = SystemEnvironment.getSystemTempFolder() + File.separator + UUIDLong.absLongUUID();
		isSuccessSave = msgObj.MsgFileSave(tempFile);
		if(!isSuccessSave){
			log.error("office上传文件保存失败(msgObj.MsgFileSave),isSuccessSave:"+isSuccessSave+",tempFile:"+tempFile);
		}
		
		CoderFactory.getInstance().encryptFile(tempFile, filePath);
		File f = new File(filePath);
		if(f != null && f.exists())
			msgObj.SetMsgByName("fileSize",f.length()+"");

		String ext = msgObj.GetMsgByName("fileExt");
		if (isSuccessSave) {
			V3XFile file = new V3XFile();
			file.setId(fileName);
			file.setCategory(category);
			file.setFilename(fileName.toString());
			file.setSize(Long.valueOf(msgObj.MsgFileSize()));

			file.setCreateDate(createDate);
			String noMillisecondTime = Datetimes.format(new Date(System.currentTimeMillis()),"yyyy-MM-dd HH:mm:ss");
			file.setUpdateDate(Datetimes.parseDate(noMillisecondTime));

			User user = AppContext.getCurrentUser();
			if(user != null){
				file.setCreateMember(user.getId());
				file.setAccountId(user.getAccountId());
			}

			this.fileManager.save(file);
		}
		
		//保存二维码文件信息到bar_code_info
		String saveCodeFile = msgObj.GetMsgByName("saveCodeFile");
		String objectId = msgObj.GetMsgByName("objectId");
		if("true".equals(saveCodeFile) && Strings.isNotBlank(objectId)) {
			this.barCodeManager.saveBarCode(Long.valueOf(objectId), fileName,ext, category);
		}

		msgObj.SetMsgByName("STATUS", "保存成功!");
		msgObj.MsgError("");

		return true;
	}
	
	private boolean isProxy(iMsgServer2000 msgObj){
		boolean isProxy=false;
		Long userId=AppContext.currentUserId();
		String affairMemberId=msgObj.GetMsgByName("affairMemberId");
		//待办的所属人id和当前登录人的id不相等的时候，是代理人处理,新建的时候affairMemberId=0排除此种情况
		if(Strings.isNotBlank(affairMemberId)&&!"0".equals(affairMemberId)&&!affairMemberId.equals(userId.toString())){
			isProxy=true;
		}
		return isProxy;
	}
	/**
	 * 多浏览器下获取当前登录用户（多浏览器下使用office控件获取不到session）
	 * @param msgObj
	 * @return
	 * @throws BusinessException
	 */
	public User getCurrentUser(iMsgServer2000 msgObj) throws BusinessException{
		String userIdStr = msgObj.GetMsgByName("currentUserId");
		if(Strings.isBlank(userIdStr)){
			 userIdStr = msgObj.GetMsgByName("EXTPARAM");
		}
		User user = new User();
		Long userId = -1L;
		if(Strings.isNotBlank(userIdStr)){
			userId = Long.valueOf(userIdStr);
		}
		V3xOrgMember currentMember = orgManager.getMemberById(userId);
		if(null!=currentMember){
			user.setId(currentMember.getId());
            user.setDepartmentId(currentMember.getOrgDepartmentId());
            user.setLoginAccount(currentMember.getOrgAccountId());
            user.setLoginName(currentMember.getLoginName());
            user.setName(currentMember.getName());
		}
		return user;
		
	}
	
	/**
	 * 插入签批内容图片
	 */
	public void insertHandWriteImg(iMsgServer2000 msgObj, String fieldName, String mLabelName) {
		if(Strings.isNotBlank(fieldName)){
			String tempFolder = new File(new File("").getAbsolutePath()).getParentFile().getParentFile().getPath();
			String tempPath = tempFolder + "/base/upload/taohongTemp/" + fieldName;
			File imgFile = new File(tempPath);
			if(imgFile != null && imgFile.exists()){
				byte[] pictureValue = file2byte(imgFile);
				msgObj.MsgFileBody(pictureValue);
				msgObj.SetMsgByName("IMAGETYPE","gif");			//指定图片的类型
				msgObj.SetMsgByName("POSITION",mLabelName);			//设置插入的位置
				msgObj.SetMsgByName("STATUS","插入图片成功!");			//设置状态信息
				msgObj.MsgError("");								//清除错误信息
				//删除临时文件
				imgFile.delete();
			}else{
				String[] filedArray = fieldName.split("_");
				if(filedArray.length > 1){
					String RECORDID = filedArray[1];
					List<V3xHtmDocumentSignature> dsList = null;
					V3xHtmDocumentSignature ds = new V3xHtmDocumentSignature();
					dsList = htmSignetManager.findBySummaryIdPolicyAndType(Long.valueOf(RECORDID), fieldName,
							V3xHtmSignatureEnum.HTML_SIGNATURE_DOCUMENT.getKey());
					//表单签批
					if (dsList != null && dsList.size() > 0) {
						ds = dsList.get(0);
						String srcData = ds.getFieldValue(); // 设置签章数据
						if(Strings.isNotBlank(srcData)){
							byte[] pictureValue = msgObj.LoadRevisionAsImgByte(srcData);
							msgObj.MsgFileBody(pictureValue);
							msgObj.SetMsgByName("IMAGETYPE","gif");			//指定图片的类型
							msgObj.SetMsgByName("POSITION",mLabelName);			//设置插入的位置
							msgObj.SetMsgByName("STATUS","插入图片成功!");			//设置状态信息
							msgObj.MsgError("");	
						}
					}
					
				}
			}
		}
	}
	
	private byte[] file2byte(File file) {
		byte[] buffer = null;
		try {
			FileInputStream fis = new FileInputStream(file);
			ByteArrayOutputStream bos = new ByteArrayOutputStream();
			byte[] b = new byte[1024];
			int n;
			while ((n = fis.read(b)) != -1) {
				bos.write(b, 0, n);
			}
			fis.close();
			bos.close();
			buffer = bos.toByteArray();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return buffer;
	}
	
	/**
	 * 插入二维码图片
	 */
	public void insertBarcode(iMsgServer2000 msgObj, String subReference, String mLabelName) {
		if(Strings.isNotBlank(subReference)){
			List<Long> fileIds = attachmentManager.getBySubReference(Long.valueOf(subReference));
			if(fileIds != null && fileIds.size() > 0){
				Long fileId = fileIds.get(0);
				try {
					V3XFile file = fileManager.getV3XFile(fileId);
					String path = fileManager.getFolder(file.getCreateDate(), false);
					String mFilePath = path + File.separator + fileId;
					if(msgObj.MsgFileLoad(mFilePath)){
						String imgType = file.getMimeType().split("[/]")[1];
						msgObj.SetMsgByName("IMAGETYPE",imgType);			//指定图片的类型
						msgObj.SetMsgByName("POSITION",mLabelName);			//设置插入的位置
						msgObj.SetMsgByName("STATUS","插入图片成功!");			//设置状态信息
						msgObj.MsgError("");								//清除错误信息
					}else{
						msgObj.MsgError("插入图片失败!");						//设置错误信息
					}
					return;
				} catch (BusinessException e) {
					log.error("插入图片异常：", e);
				}
			}
		}
		msgObj.MsgError("插入图片失败!");						//设置错误信息
	}

	/**
	 * 插入图片
	 * @param createDate 
	 */
	public void insertImg(iMsgServer2000 msgObj, String subReference, String mLabelName, String createDate) {
		if(Strings.isNotBlank(createDate)){
			try {
				String[] dateArr = createDate.split("-");
				Calendar cal = Calendar.getInstance();
				cal.set(Calendar.YEAR, Integer.valueOf(dateArr[0]));
				cal.set(Calendar.MONTH, Integer.valueOf(dateArr[1]) - 1);
				cal.set(Calendar.DAY_OF_MONTH, Integer.valueOf(dateArr[2]));
				String newfilePath = "";
				if(Strings.isNotBlank(subReference)){
					String filePath = fileManager.getFolder(new Date(cal.getTimeInMillis()), false);
					String mFilePath = filePath + File.separator + subReference;
					newfilePath = mFilePath;
					//图片套红，必须要先解密才能插入word文档
					if(needReadFile){
						try {
							newfilePath = CoderFactory.getInstance().decryptFileToTemp(mFilePath);
						} catch (Exception e) {
							log.error("图片解密异常：", e);
						}
					}
				}
				if(msgObj.MsgFileLoad(newfilePath)){
					String imgType = "jpg";
					msgObj.SetMsgByName("IMAGETYPE",imgType);			//指定图片的类型
					msgObj.SetMsgByName("POSITION",mLabelName);			//设置插入的位置
					msgObj.SetMsgByName("STATUS","插入图片成功!");			//设置状态信息
					msgObj.MsgError("");								//清除错误信息
				}else{
					msgObj.MsgError("插入图片失败!");						//设置错误信息
				}
				return;
			} catch (BusinessException e) {
				msgObj.MsgError("插入图片失败!");
			}
		}
		msgObj.MsgError("插入图片失败!");						//设置错误信息
	}
}