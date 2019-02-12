package com.seeyon.apps.czexchange.manager.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;

import com.alibaba.fastjson.JSONObject;
import com.cinda.exchange.client.util.ClientUtil;
import com.cinda.exchange.client.util.FileUtil;
import com.seeyon.apps.cinda.authority.domain.UmOrganization;
import com.seeyon.apps.cinda.authority.domain.UmUser;
import com.seeyon.apps.czexchange.bo.Attachfile;
import com.seeyon.apps.czexchange.bo.Elecdocument;
import com.seeyon.apps.czexchange.dao.EdocSummaryAndDataRelationDAO;
import com.seeyon.apps.czexchange.enums.EdocSendOrReceiveStatusEnum;
import com.seeyon.apps.czexchange.manager.CzSursenSendManager;
import com.seeyon.apps.czexchange.po.EdocSummaryAndDataRelation;
import com.seeyon.apps.czexchange.util.CzEdocUtil;
import com.seeyon.apps.czexchange.util.CzOrgUtil;
import com.seeyon.apps.czexchange.util.XMLUtil;
import com.seeyon.apps.dev.doc.dao.CindaUserDao;
import com.seeyon.apps.dev.doc.enums.EdocTypeEnum;
import com.seeyon.apps.dev.doc.manager.ExportDocManager;
import com.seeyon.apps.dev.doc.utils.DocFileInfo;
import com.seeyon.apps.sursenExchange.po.MidSendFile;
import com.seeyon.apps.sursenExchange.util.SursenExchangeUtil;
import com.seeyon.apps.sursenExchange.util.SursenIOReader;
import com.seeyon.apps.sursenexchange.api.SendToSursenParam;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.ZipUtil;
import com.seeyon.oainterface.exportData.commons.AttachmentExport;
import com.seeyon.oainterface.exportData.document.DocumentExport;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.manager.EdocManager;
import com.seeyon.v3x.exchange.domain.EdocSendRecord;
import com.seeyon.v3x.exchange.manager.SendEdocManager;

public class CzSursenSendManagerImpl implements CzSursenSendManager {

	private static Log log = LogFactory.getLog(CzSursenSendManagerImpl.class);
	
	
	private OrgManager orgManager;
	private ExportDocManager exportDocManager;
	private EdocManager edocManager;
	private CindaUserDao cindaUserDao;
	private SendEdocManager sendEdocManager;
	private static boolean istransPdf = "true".equalsIgnoreCase(SystemProperties.getInstance().getProperty("czexchange.transPdf"));
	private static boolean isneedDelFile = "true".equalsIgnoreCase(SystemProperties.getInstance().getProperty("czexchange.delFile"));
	public void setCindaUserDao(CindaUserDao cindaUserDao) {
		this.cindaUserDao = cindaUserDao;
	}

	public void setSendEdocManager(SendEdocManager sendEdocManager) {
		this.sendEdocManager = sendEdocManager;
	}

	public void setEdocManager(EdocManager edocManager) {
		this.edocManager = edocManager;
	}

	public void setExportDocManager(ExportDocManager exportDocManager) {
		this.exportDocManager = exportDocManager;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	public OrgManager getOrgManager() {
		return orgManager;
	}
	private FileManager fileManager;
	
	private EdocSummaryAndDataRelationDAO edocSummaryAndDataRelationDAO;
	
	
	public EdocSummaryAndDataRelationDAO getEdocSummaryAndDataRelationDAO() {
		return edocSummaryAndDataRelationDAO;
	}

	public void setEdocSummaryAndDataRelationDAO(
			EdocSummaryAndDataRelationDAO edocSummaryAndDataRelationDAO) {
		this.edocSummaryAndDataRelationDAO = edocSummaryAndDataRelationDAO;
	}

	public FileManager getFileManager() {
		return fileManager;
	}

	public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}
	/**
	 * 获取发送的多个子公司id转umid
	 * @param docId
	 * @return
	 * @throws BusinessException
	 */
	private String getSendToUmOrgIds (EdocSendRecord edocSendRecord) throws BusinessException{
		String changeAccountRoot = SystemProperties.getInstance().getProperty("czexchange.defaultsAccount");
		StringBuffer toId = new StringBuffer();
		String sends = edocSendRecord.getSendedNames();
		String[] sendsList = sends.split("、");
		String[] changeUnitList = changeAccountRoot.split("@");
		for (String sendUnit : sendsList) {
			
			for(String changeUnit : changeUnitList){
				String[] changeNameAndId=changeUnit.split(",");
				if(changeNameAndId.length>1 && changeNameAndId[0].equalsIgnoreCase(sendUnit)){
					if(toId.length() > 0){
						toId.append(",");
					}
					toId.append(changeNameAndId[1]);
				}
			}
		}
		
		return toId.toString();
	}
	/*
	 * 在发送公文的时候， 进行调用， 返回公文发送是成功还是失败
	 * @see com.seeyon.apps.sursenExchange.send.manager.SursenSendManager#sendToSursen(com.seeyon.apps.sursenexchange.api.SendToSursenParam)
	 */
	@Override
	public boolean sendToSursen(SendToSursenParam param)
			throws BusinessException {
			// 发送公文的时候， 把文单， 附件， 正文等相关信息， 压缩成一个 ZIP 文件进行发送
			log.info("开始进行公文交换：参数为param="+JSONObject.toJSONString(param));
			//发送单位一直是固定的自己服务的是一个单位
			String from = SystemProperties.getInstance().getProperty("czexchange.ownersystemId", "1177814005103");
			UmOrganization umorg = cindaUserDao.getOrgById(from);
			V3xOrgAccount acc = orgManager.getAccountByName(umorg.getOrganizationname());
			if(acc==null){
				log.error("出现配置错误，请联系管理员检查是否正确配置的OA系统所属公司的id");
				return false;
			}
			// 转换成 Code
//			User user = AppContext.getCurrentUser();

			String roleName = "Accountexchange";
			List<V3xOrgMember> listmembr = orgManager.getMembersByRole(acc.getId(), roleName);
			String loginName = AppContext.getSystemProperty("czexchange.dataExchageUser");
			if(listmembr!=null && listmembr.size()>0){
				loginName = listmembr.get(0).getLoginName();
				log.info("当前接收公文的人员系统设定为："+loginName);
			}
			V3xOrgMember member = orgManager.getMemberByLoginName(loginName);
			if(member==null){
				String errorMessage = "公文交换插件信息输出: 根据登录名称在系统中没有找到人员, 请检查登录名称的配置。czexchange.meetingExchageUser";
				log.error(errorMessage);
				return false;
			}
			UmUser umuser = cindaUserDao.getbyLoginNane(member.getLoginName());

			// 下面的程序用来生成发送的 ZIP 文件
			String docId = param.getDocid();
			Long edocId = param.getEdocId();
			EdocSendRecord edocSendRecord = sendEdocManager.getEdocSendRecord(Long.parseLong(docId));
			//
			String to = getSendToUmOrgIds(edocSendRecord);

			if(Strings.isBlank(to) && "null".equalsIgnoreCase(to)){
				log.error("发送公文的时候， 送达单位为空， 不能进行发送");
				return false;
			}
			String zipFilePath = this.exportDocManager.getTempFilepath("edocsend"+File.separator+docId);
			String zipFileName = zipFilePath+File.separator+docId + ".zip";
			// 在发送公文的时候， 执行到下面这个程序就报错了， 致远一直没有解决
			DocumentExport documentExport = CzEdocUtil.getDocumentExportByEdocId(Long.valueOf(docId));
			EdocSummary edocSummary = edocManager.getEdocSummaryById(edocId, true);
			log.info("edocSummary="+edocSummary.getId());

			String edocThirdId = this.getThirdId(edocSummary);
			List<File> list = new ArrayList<File>();
			// 增加正文
			
			DocFileInfo zwinfo = this.exportDocManager.exportEdocZW(documentExport, edocSummary);
			
			
			if(istransPdf){
				this.exportDocManager.toPdfFile(zwinfo, documentExport);
			}else{
				try {
					String temppath = zipFilePath+File.separator+zwinfo.getId()+"."+zwinfo.getFile_suffix();
					www.seeyon.com.utils.FileUtil.write(zwinfo.getFile_InputStream(), new FileOutputStream(temppath));
					zwinfo.setFile(new File(temppath));
				} catch (Exception e1) {
					log.error("",e1);
					return false;
				}
			}
			

			
			
			list.add(zwinfo.getFile());
			
			// XML
			Elecdocument elecdocument = new Elecdocument();
			elecdocument.getExchange().setReceive(param.getSendTo());
			elecdocument.getExchange().setReceivecode(to);
			elecdocument.getExchange().setSender("信达投资");
			elecdocument.getExchange().setSendcode(from);
			elecdocument.getExchange().setFlag("true");
			elecdocument.getExchange().setGwcode(edocThirdId);
			elecdocument.getGwelement().setBaosonguser(umuser.getUserid());
			elecdocument.getGwelement().setBaosongname(umuser.getUsername());
			elecdocument.getGwelement().setJinji(param.getEmergency());
			elecdocument.getGwelement().setMiji(Strings.isBlank(param.getSecret())?"否":param.getSecret());
			elecdocument.getGwelement().setNianxian("永久");
//			V3xOrgMember member = orgManager.getMemberByLoginName(user.getLoginName());
			V3xOrgDepartment department = orgManager.getDepartmentById(member.getOrgDepartmentId());
			elecdocument.getGwelement().setPerson_liable(department.getName());  // 办公室
			elecdocument.getGwelement().setTitle(param.getDoctitle());
			elecdocument.getGwelement().setWenhao(param.getDocMark());
			
			Date date = param.getCreateDate()==null? new Date():param.getCreateDate();
			elecdocument.getExchange().setSendtime(Datetimes.format(date, "yyyy-MM-dd HH:mm:ss"));
			
			com.seeyon.apps.czexchange.bo.File cinda_zw_file = new com.seeyon.apps.czexchange.bo.File(); 
			cinda_zw_file.setFileName(zwinfo.getFile().getName());
			cinda_zw_file.setAttachname(zwinfo.getFile_title());
			elecdocument.getText().setFile(cinda_zw_file);
			
			List<Attachfile> attachFileList = new ArrayList<Attachfile>();
			// 增加附件
			List<AttachmentExport>  listAtt  = documentExport.getAttachmentList();
			if(listAtt!=null){
				for (AttachmentExport att : listAtt) {
					String temppath = zipFilePath+File.separator+att.getId()+"."+att.getFilesuffix();
					File tempatt = new File(temppath);
					try {
						www.seeyon.com.utils.FileUtil.write(new FileInputStream(att.getAbsolutepath()), new FileOutputStream(tempatt));
					} catch (Exception e) {
						log.error("获取附件出错",e);
						return false;
					}
					list.add(tempatt);
					Attachfile attachfile= new Attachfile();
					attachfile.setAttachname("附件："+att.getFileName());
					attachfile.setFileName(tempatt.getName());
					attachFileList.add(attachfile);
				}
			}
			//处理文单
			DocFileInfo wdinfo = this.exportDocManager.exportEdocWD(documentExport, edocSummary);
			
			if(istransPdf){
				this.exportDocManager.toPdfFile(wdinfo, documentExport);
			}else{
				try {
					String temppath = zipFilePath+File.separator+wdinfo.getId()+"."+wdinfo.getFile_suffix();
					www.seeyon.com.utils.FileUtil.write(wdinfo.getFile_InputStream(), new FileOutputStream(temppath));
					wdinfo.setFile(new File(temppath));
				} catch (Exception e1) {
					log.error("处理文单",e1);
					return false;
				}
			}
			list.add(wdinfo.getFile());
			try {
				Attachfile attachfile= new Attachfile();
				attachfile.setAttachname("文单："+wdinfo.getFile_title());
				attachfile.setFileName(wdinfo.getFile_fullName());
				attachFileList.add(attachfile);
			} catch (Exception e) {
				log.error("保存附件失败",e);
				return false;
			}
			elecdocument.getAttach().setAttachfile(attachFileList);
		
			// 增加属性说明的 XML 文档
			String xmlStr = XMLUtil.toXml(elecdocument);
			String xmlFileName = "element.xml";
			File XML_File = new File(zipFilePath + File.separator + xmlFileName);
			FileUtil.StringToFile(XML_File, xmlStr);
			list.add(XML_File);
			try {
				ZipUtil.zip(list, new File(zipFileName));
			} catch (Exception e) {
				log.error("打包zip出错：",e);
				return false;
			}
			log.info("开始推送交换数据 =====from="+from+",to="+to+",zipFileName="+zipFileName);
			String [] msgIds = ClientUtil.sendData(from, to, zipFileName);
			if(msgIds!=null&&msgIds.length>0){
				for (String id : msgIds) {
					
					//删除临时文件
					EdocSummaryAndDataRelation rel = new EdocSummaryAndDataRelation();
					rel.setIdIfNew();
					rel.setAccountId(member.getOrgAccountId());
					rel.setApp(EdocTypeEnum.sendEdoc.getKey());
					rel.setEdocId(Long.parseLong(docId));
					rel.setMsgId(id);
					rel.setThirdId(edocThirdId);
					rel.setStatus(EdocSendOrReceiveStatusEnum.send.getKey());
					DBAgent.saveOrUpdate(rel);
				}
				if(isneedDelFile){
					www.seeyon.com.utils.FileUtil.delDir(new File(zipFilePath));
				}
				return true;
			}
			
			return false;
	}
	private String getThirdId(EdocSummary summary){
		String edocid = String.valueOf(summary.getId());
		Date st = summary.getStartTime();
		String thirdId = Datetimes.format(st, "yyMMdd")+edocid.substring(edocid.length()-4);
		return thirdId;
	}
			// TODO:
			// 下面这段程序暂时保留， 具有一定的参考价值
	/*     */   private List<MidSendFile> getFiles(SendToSursenParam param, Integer sendSummaryId)
			/*     */     throws BusinessException
			/*     */   {
			/* 116 */     List<MidSendFile> files = new ArrayList();
			/* 117 */     MidSendFile sendFile = new MidSendFile();
			/* 120 */     byte[] bContents = null;
			/* 121 */     if (param.getBodyType() != null) {
			/* 122 */       sendFile.setFileType(0);
			/*     */     }
			/* 124 */     if (param.getBodyContentType().equals("HTML")) {
			/* 125 */       sendFile.setFileName("正文.txt");
			/* 126 */       String bContent = param.getBodyContent();
			/* 127 */       bContents = bContent.getBytes();
			/* 128 */       sendFile.setSendSumaryId(sendSummaryId);
			/*     */     } else {
			/* 130 */       String fid = param.getBodyContent();
			/* 131 */       sendFile.setFileName("正文" + SursenExchangeUtil.getSuffix(param.getBodyContentType()));
			/* 132 */       sendFile.setSendSumaryId(sendSummaryId);
			/* 133 */       File file = null;
			/*     */       try {
			/* 135 */         Long ffid = Long.valueOf(fid == null ? "-1" : fid);
			/* 136 */         file = this.fileManager.getFile(ffid);
			/* 137 */         if (file != null) {
			/* 138 */           file = this.fileManager.getStandardOffice(file.getAbsolutePath());
			/*     */         }
			/* 140 */         if (file != null) {
			/* 141 */           bContents = SursenIOReader.ReadFile(file);
			/*     */           
			/*     */ 
			/*     */ 
			/* 145 */           SursenIOReader.removeFile(file.getAbsolutePath());
			/*     */         }
			/*     */       } catch (Exception e) {
			/* 148 */         log.info("正文读取错误或文件不存在", e);
			/*     */       }
			/*     */     }
			/* 151 */     sendFile.setFileBody(Hibernate.createBlob(bContents));
			/* 152 */     files.add(sendFile);
			/*     */     Long af_id;
			/* 154 */     byte[] att; File file; if (Strings.isNotEmpty(param.getAttachments()))
			/*     */     {
			/*     */ 
			/* 157 */       List<Attachment> attachments = param.getAttachments();
			/* 158 */       Attachment attachment = null;
			/* 159 */       af_id = null;
			/* 160 */       att = null;
			/* 161 */       file = null;
			/* 162 */       if ((attachments != null) && (attachments.size() > 0)) {
			/* 163 */         if (attachments.size() == 1) {
			/* 164 */           sendFile = new MidSendFile();
			/* 166 */           attachment = (Attachment)attachments.get(0);
			/* 167 */           af_id = attachment.getFileUrl();
			/* 168 */           sendFile.setSendSumaryId(sendSummaryId);
			/* 169 */           sendFile.setFileName(attachment.getFilename());
			/* 170 */           sendFile.setFileType(1);
			/*     */           try {
			/* 172 */             file = this.fileManager.getFile(af_id);
			/* 173 */             if (file != null) {
			/* 174 */               att = SursenIOReader.ReadFile(file);
			/*     */             }
			/*     */           } catch (BusinessException e) {
			/* 177 */             log.info("附件读取失败", e);
			/*     */           } catch (IOException e) {
			/* 179 */             log.info("附件读取失败", e);
			/*     */           }
			/* 181 */           sendFile.setFileBody(Hibernate.createBlob(att));
			/* 182 */           files.add(sendFile);
			/*     */         } else {
			/* 184 */           for (Attachment atta : attachments) {
			/* 185 */             sendFile = new MidSendFile();
			/* 187 */             sendFile.setSendSumaryId(sendSummaryId);
			/* 188 */             sendFile.setFileName(atta.getFilename());
			/* 189 */             sendFile.setFileType(1);
			/* 190 */             af_id = atta.getFileUrl();
			/* 191 */             int attType = atta.getType().intValue();
			/* 192 */             if (attType != 2)
			/*     */             {
			/*     */               try
			/*     */               {
			/* 196 */                 file = this.fileManager.getFile(af_id);
			/* 197 */                 if (file != null) {
			/* 198 */                   att = SursenIOReader.ReadFile(file);
			/*     */                 }
			/*     */               } catch (BusinessException e) {
			/* 201 */                 log.info("附件读取失败", e);
			/*     */               } catch (Exception e) {
			/* 203 */                 log.info("附件读取失败", e);
			/*     */               }
			/*     */               
			/* 206 */               sendFile.setFileBody(Hibernate.createBlob(att));
			/* 207 */               files.add(sendFile);
			/*     */             }
			/*     */           }
			/*     */         }
			/*     */       }
			/*     */     }
			/* 213 */     return files;
			/*     */   }

public static void main(String[] args) {
	EdocSummary su = new EdocSummary();
	su.setStartTime(new Timestamp(System.currentTimeMillis()));
	su.setId(98676787444274956L);
	String edocid = String.valueOf(su.getId());
	Date st = su.getStartTime();
	
	String thirdId = Datetimes.format(st, "yyMMdd")+edocid.substring(edocid.length()-4);

	System.out.println(thirdId);
}
}
