package com.seeyon.apps.czexchange.manager.impl;

import java.io.File;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.czexchange.dao.EdocSummaryAndDataRelationDAO;
import com.seeyon.apps.czexchange.manager.CzSursenReceiveManager;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.apps.edoc.api.ReceiveEdocParam;
import com.seeyon.apps.sursenExchange.bo.SursenXmlContent;
import com.seeyon.apps.sursenExchange.po.MidReceiveFile;
import com.seeyon.apps.sursenExchange.po.MidReceiveSummary;
import com.seeyon.apps.sursenExchange.util.SursenExchangeUtil;
import com.seeyon.apps.sursenExchange.util.SursenIOReader;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.encrypt.CoderFactory;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumBean;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;

public class CzSursenReceiveManagerImpl implements CzSursenReceiveManager {
	
	private static Log log = LogFactory.getLog(CzSursenReceiveManagerImpl.class);
	
	
	private static int RETURNS_CONTINUE = 5;
	private static int RETURNS_ERROR = 0;
	
	
	private OrgManager orgManager;
	private FileManager fileManager;
	private EnumManager v3xmetadataManager;
	
	private EdocSummaryAndDataRelationDAO edocSummaryAndDataRelationDAO;
	
	
	public EdocSummaryAndDataRelationDAO getEdocSummaryAndDataRelationDAO() {
		return edocSummaryAndDataRelationDAO;
	}


	public void setEdocSummaryAndDataRelationDAO(
			EdocSummaryAndDataRelationDAO edocSummaryAndDataRelationDAO) {
		this.edocSummaryAndDataRelationDAO = edocSummaryAndDataRelationDAO;
	}


	public EnumManager getV3xmetadataManager() {
		return v3xmetadataManager;
	}


	public void setV3xmetadataManager(EnumManager v3xmetadataManager) {
		this.v3xmetadataManager = v3xmetadataManager;
	}


	public FileManager getFileManager() {
		return fileManager;
	}


	public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}

	private EdocApi edocApi = null;

	public EdocApi getEdocApi() {
		return edocApi;
	}


	public void setEdocApi(EdocApi edocApi) {
		this.edocApi = edocApi;
	}


	public OrgManager getOrgManager() {
		return orgManager;
	}


	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}


	@Override
	public void saveReceiveSummary(MidReceiveSummary paramMidReceiveSummary)
			throws BusinessException {
	}
		

		/*     */   
		/*     */   public int createNewSummary(MidReceiveSummary ers) throws BusinessException
		/*     */   {
		/* 133 */     ReceiveEdocParam param = new ReceiveEdocParam();
		/* 134 */     param.setId(Long.valueOf(UUIDLong.longUUID()));
		/*     */     
		/* 136 */     log.info("定时任务开始跟踪 *****************createNewSummary ***************** ");
		/* 137 */     log.info("edocSummaryId = " + param.getId());
		/*     */     
		/*     */ 
		/* 140 */     if (this.orgManager == null) {
		/* 141 */       this.orgManager = ((OrgManager)AppContext.getBean("OrgManager"));
		/*     */     }
		/*     */     
		/*     */ 
		/* 145 */     String createUnitId = ers.getUnitName();
		/* 146 */     log.info("发文单位ID：" + createUnitId);
		/* 147 */     param.setSendUnitName(createUnitId);
		/*     */     
		/* 149 */     V3xOrgAccount sendUnit = null;
		/*     */     
		/*     */ 
		/* 152 */     if (createUnitId != null) {
		/* 153 */       sendUnit = this.orgManager.getAccountByName(createUnitId);
		/*     */     }
		/*     */     
		/* 156 */     if (sendUnit == null) {
		/* 157 */       log.info("发文单位不存在");
		/* 158 */       return RETURNS_CONTINUE;
		/*     */     }
		/*     */     
		/*     */ 
		/*     */ 
		/* 163 */     SursenXmlContent edocExchange2Content = com.seeyon.apps.sursenExchange.util.SursenExchangeToXmlUtil.readXML(ers.getContent());
		/*     */     
		/*     */ 
		/* 166 */     param.setOrgAccountId(sendUnit.getId());
		/* 167 */     param.setHasArchive(false);
		/* 168 */     param.setDeadline(Long.valueOf(0L));
		/* 169 */     param.setEdocType(Integer.valueOf(0));
		/* 170 */     param.setCanTrack(Integer.valueOf(0));
		/* 171 */     param.setIdentifier("00000000000000000000");
		/* 172 */     param.setSubject(edocExchange2Content.getDoctitle());
		/* 173 */     param.setKeywords(edocExchange2Content.getSubject());
		/* 174 */     param.setIssuer(edocExchange2Content.getPublishperson());
		/*     */     
		/*     */ 
		/* 177 */     String year = edocExchange2Content.getYearNo();
		/* 178 */     String docNopre = edocExchange2Content.getDocNoPre();
		/* 179 */     String water = edocExchange2Content.getWaterNo();
		/* 180 */     String docmark = docNopre + "〔" + year + "〕" + water + "号";
		/* 181 */     param.setDocMark(docmark);
		/* 182 */     param.setCreatePerson(edocExchange2Content.getCreator());
		/*     */     
		/*     */ 
		/* 185 */     param.setSendTo(ers.getUnitName());
		/* 186 */     param.setCopyTo(edocExchange2Content.getCc());
		/*     */     
		/* 188 */     Long now = Long.valueOf(System.currentTimeMillis());
		/* 189 */     param.setStartTime(new Timestamp(now.longValue()));
		/* 190 */     param.setCreateTime(new Timestamp(now.longValue()));
		/* 191 */     param.setState(Integer.valueOf(3));
		/* 192 */     param.setDocType("1");
		/* 193 */     param.setSendType("1");
		/* 194 */     param.setKeepPeriod(Integer.valueOf(1));
		/*     */     
		/*     */ 
		/* 197 */     CtpEnumBean metadata = this.v3xmetadataManager.getEnum(EnumNameEnum.edoc_secret_level.name());
		/* 198 */     List<CtpEnumItem> list = metadata.getItems();
		/* 199 */     for (CtpEnumItem mitem : list) {
		/* 200 */       if (Strings.isNotBlank(metadata.getResourceBundle())) {
		/* 201 */         String name = ResourceBundleUtil.getString(metadata
		/* 202 */           .getResourceBundle(), mitem.getLabel(), new Object[0]);
		/* 203 */         if (name.equals(edocExchange2Content.getSecret())) {
		/* 204 */           param.setSecretLevel(mitem.getValue());
		/* 205 */           break;
		/*     */         }
		/*     */       }
		/*     */     }
		/*     */     
		/*     */ 
		/* 211 */     metadata = this.v3xmetadataManager.getEnum(EnumNameEnum.edoc_urgent_level.name());
		/* 212 */     list = metadata.getItems();
		/* 213 */     for (CtpEnumItem mitem : list) {
		/* 214 */       String name = ResourceBundleUtil.getString(metadata
		/* 215 */         .getResourceBundle(), mitem.getLabel(), new Object[0]);
		/* 216 */       if (name.equals(edocExchange2Content.getEmergency())) {
		/* 217 */         param.setUrgentLevel(mitem.getValue());
		/* 218 */         break;
		/*     */       }
		/*     */     }
		/*     */     
		/* 222 */     param.setSendUserNames(edocExchange2Content.getSendPerson());
		/*     */     try
		/*     */     {
		/* 225 */       if (sendUnit != null) {
		/* 226 */         excueSummaryFile(param, ers);
		/*     */         
		/*     */ 
		/* 229 */         this.edocApi.receiveEdoc(param);
		/*     */       }
		/* 231 */       log.info("定时任务跟踪结束 *****************end ***************** edocSummary.subject=" + param.getSubject());
		/*     */     } catch (Exception e) {
		/* 233 */       log.error(e.getMessage(), e);
		/* 234 */       return RETURNS_ERROR;
		/*     */     }
		/*     */     
		/* 237 */     return RETURNS_ERROR;

		
	}

	@Override
	public void updateReceiveSummary(MidReceiveSummary paramMidReceiveSummary)
			throws BusinessException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public MidReceiveSummary getReceiveSummaryById(Long paramLong)
			throws BusinessException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void getSursenSummary() {
		/*  99 */     log.info("****getSursenSummary ***********定时任务开始***start***");
		/*     */     
		/*     */ 
		/* 102 */     List<MidReceiveSummary> erss = this.edocSummaryAndDataRelationDAO.findBy("flag", Integer.valueOf(MidReceiveSummary.Flag.UNFETCH.ordinal()));
		/*     */     
		/*     */ 
		/* 105 */     if (Strings.isNotEmpty(erss))
		/*     */     {
		/* 107 */       log.info("****erss.size=" + erss.size());
		/*     */       
		/* 109 */       for (int i = 0; i < erss.size(); i++) {
		/*     */         try {
		/* 111 */           MidReceiveSummary ers = (MidReceiveSummary)erss.get(i);
		/*     */           
		/* 113 */           log.info("****ers.getId=" + ers.getId());
		/*     */           
		/* 115 */           int returns = createNewSummary(ers);
		/*     */           
		/* 117 */           log.info("****returns=" + returns);
		/*     */           
		/* 119 */           if (returns == RETURNS_CONTINUE) {
		/*     */             continue;
		/*     */           }
		/*     */         } catch (Exception e) {
		/* 123 */           log.error("", e);
		/*     */         }
		/*     */       }
		/*     */     }
		/*     */     
		/* 128 */     log.info("****getSursenSummary ***********定时任务结束***end***");
		
		
	}

	@Override
	public void saveFile(List<V3XFile> files) {
		     if (files.size() > 0) {
				 for (V3XFile v3XFile : files) {
				        this.fileManager.save(v3XFile);
		         }
			 }
	}

	/*     */   
	/*     */ 
	/*     */   private void excueSummaryFile(ReceiveEdocParam edocSummary, MidReceiveSummary ers)
	/*     */   {
	/* 620 */     List<V3XFile> v3xFiles = new ArrayList();
	/* 621 */     List<Attachment> attachments = new ArrayList();
	/* 622 */     List<MidReceiveFile> getReceiveFiles = this.edocSummaryAndDataRelationDAO.findFileBy(ers.getId());
	/* 623 */     for (MidReceiveFile receiveFile : getReceiveFiles) {
	/* 624 */       byte[] b = new byte[4096];
	/*     */       
	/* 626 */       b = SursenExchangeUtil.getBytes(receiveFile.getFileBody());
	/*     */       try
	/*     */       {
	/* 629 */         V3XFile v3xFile = new V3XFile();
	/* 630 */         v3xFile.setNewId();
	/* 631 */         v3xFile.setFilename(String.valueOf(UUIDLong.longUUID()));
	/* 632 */         v3xFile.setCreateDate(edocSummary.getCreateTime());
	/* 633 */         v3xFile.setCategory(Integer.valueOf(1));
	/* 634 */         String mimeType = SursenExchangeUtil.getMimeType(receiveFile.getFileName());
	/* 635 */         v3xFile.setMimeType(mimeType);
	/* 636 */         v3xFile.setType(Integer.valueOf(0));
	/* 637 */         v3xFile.setAccountId(Long.valueOf(edocSummary.getOrgAccountId().longValue()));
	/* 638 */         v3xFile.setUpdateDate(edocSummary.getCreateTime());
	/* 639 */         if (receiveFile.getFileType() == 0)
	/*     */         {
	/* 641 */           File f = SursenIOReader.writeFile(String.valueOf(UUIDLong.longUUID()), edocSummary.getCreateTime(), b);
	/* 642 */           v3xFile.setSize(Long.valueOf(SursenIOReader.getSize(f).longValue()));
	/* 643 */           v3xFile.setFilename(v3xFile.getId().toString());
	/*     */           
	/* 645 */           CoderFactory.getInstance().encryptFile(f.getAbsolutePath(), SursenIOReader.uploadFilePath(edocSummary.getCreateTime(), null) + v3xFile.getId().toString());
	/* 646 */           SursenIOReader.removeFile(f.getAbsolutePath());
	/*     */           
	/*     */ 
	/* 649 */           edocSummary.setBodyType("gd");
	/* 650 */           edocSummary.setBodyFile(v3xFile);
	/*     */         }
	/*     */         else {
	/* 653 */           File f = SursenIOReader.writeFile(String.valueOf(v3xFile.getId()), edocSummary.getCreateTime(), b);
	/* 654 */           v3xFile.setSize(Long.valueOf(SursenIOReader.getSize(f).longValue()));
	/* 655 */           Attachment attachment = new Attachment();
	/* 656 */           attachment.setNewId();
	/* 657 */           attachment.setSubReference(edocSummary.getId());
	/* 658 */           attachment.setReference(edocSummary.getId());
	/* 659 */           attachment.setFileUrl(v3xFile.getId());
	/* 660 */           attachment.setCategory(Integer.valueOf(4));
	/* 661 */           attachment.setCreatedate(v3xFile.getCreateDate());
	/* 662 */           attachment.setFilename(receiveFile.getFileName());
	/* 663 */           attachment.setMimeType(v3xFile.getMimeType());
	/* 664 */           attachment.setSize(v3xFile.getSize());
	/* 665 */           attachment.setSort(0);
	/* 666 */           v3xFile.setFilename(attachment.getFilename());
	/* 667 */           attachment.setType(Integer.valueOf(0));
	/* 668 */           attachments.add(attachment);
	/*     */         }
	/* 670 */         v3xFiles.add(v3xFile);
	/*     */       } catch (Exception e) {
	/* 672 */         log.error("错误", e);
	/*     */       }
	/*     */     }
	/*     */     
	/*     */ 
	/* 677 */     edocSummary.setAttachments(attachments);
	/*     */     
	/*     */ 
	/* 680 */     saveFile(v3xFiles);
	/*     */     
	/*     */ 
	/* 683 */     ers.setFlag(1);
	/* 685 */     this.edocSummaryAndDataRelationDAO.updateReceiveSummary(ers);
	/*     */   }



}
