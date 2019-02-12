package com.cinda.exchange.client.util;

import java.io.File;
import java.io.IOException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.cinda.exchange.client.Client;
import com.seeyon.apps.czexchange.bo.Elecdocument;
import com.seeyon.apps.czexchange.dao.EdocSummaryAndDataRelationDAO;
import com.seeyon.apps.czexchange.enums.EdocSendOrReceiveStatusEnum;
import com.seeyon.apps.czexchange.manager.CzDocExchangeManager;
import com.seeyon.apps.czexchange.po.EdocSummaryAndDataRelation;
import com.seeyon.apps.czexchange.util.XMLUtil;
import com.seeyon.apps.dev.doc.manager.ExportDocManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.ZipUtil;
import com.seeyon.oainterface.common.OAInterfaceException;
import com.seeyon.v3x.exchange.domain.EdocSendRecord;
import com.seeyon.v3x.exchange.manager.SendEdocManager;

public class ClientUtil {

	private static final Log log = LogFactory.getLog(ClientUtil.class);
	public static int jianhuanPort = 9000;// (Integer.parseInt(SystemProperties.getInstance().getProperty("czexchange.HD_EXCHANGE_PORT")));
	public static String jianhuanServer = SystemProperties.getInstance().getProperty("czexchange.HD_EXCHANGE_SERVER");
	private static boolean isneedDelFile = "true".equalsIgnoreCase(SystemProperties.getInstance().getProperty("czexchange.delFile"));
	private static CzDocExchangeManager czDocExchangeManager;
	private static  ExportDocManager exportDocManager = (ExportDocManager) AppContext.getBean("exportDocManager");
	public static CzDocExchangeManager getCzDocExchangeManager() {
		if(czDocExchangeManager==null){
			czDocExchangeManager = (CzDocExchangeManager) AppContext.getBean("czDocExchangeManager");
		}
		return czDocExchangeManager;
	}

	private static EdocSummaryAndDataRelationDAO edocSummaryAndDataRelationDAO;
	public static EdocSummaryAndDataRelationDAO getEdocSummaryAndDataRelationDAO() {
		if(edocSummaryAndDataRelationDAO==null){
			edocSummaryAndDataRelationDAO = (EdocSummaryAndDataRelationDAO) AppContext.getBean("edocSummaryAndDataRelationDAO");
		}
		return edocSummaryAndDataRelationDAO;
	}
	
	private static OrgManager orgManager;
	

	public static OrgManager getOrgManager() {
		if(orgManager==null){
			orgManager = (OrgManager) AppContext.getBean("orgManager");
		}
		return orgManager;
	}

	/*
	 * 判断一个信息是否已经处理完成
	 */
	public static boolean isEndStep(String msgId){
		EdocSummaryAndDataRelation relation = getEdocSummaryAndDataRelationDAO().getRelationByMsgId(msgId);
		return relation.getStatus()== EdocSendOrReceiveStatusEnum.Received.getKey();
	}
	
	/*
	 * 从公文交换平台接受一条公文信息
	 */
	public static boolean receiveEdoc(Client client, String msgId){
		//先接收数据到临时目录
		
		
		String zipFilePath = exportDocManager.getTempFilepath("receiveEdoc"+File.separator+msgId);
		String zipFileName = zipFilePath+File.separator+msgId + ".zip";
		//接收数据,将文件接收到tempFilePath临时目录
		String[] receiveMsg = client.receiveData(msgId, zipFilePath);
		if(receiveMsg==null||receiveMsg.length==0){
			return false;
		}

		//解压zip文件
		// 从下面开始的程序， 用 main 方法进行测试
		File zipFile = new File(zipFileName);
		String fileName = zipFile.getName();
//		String outFilePath = zipFilePath + File.separator+fileName.substring(0,fileName.length()-4)+File.separator;
//		File tmpFileDir = new File(zipFilePath);
//		tmpFileDir.mkdirs();
		try {
			ZipUtil.unzip(zipFile, new File(zipFilePath));
		} catch (IOException e) {
			log.error("", e);
		}

//		String elementXmlPath = zipFilePath+File.separator+msgId;
		// 下面这个文件中， 包含了收到公文的所有的信息
		Elecdocument elecdocument = XMLUtil.toBean(www.seeyon.com.utils.FileUtil.readTextFile(zipFilePath+File.separator+"element.xml", "GBK"), Elecdocument.class);
		elecdocument.setMsgId(msgId);
		
		try {
			getCzDocExchangeManager().receiveEdoc(elecdocument);
		} catch (BusinessException e) {
			log.error("", e);
			return false;
		} catch (OAInterfaceException e) {
			log.error("", e);
			return false;
		} catch (Exception e){
			log.error("", e);
			return false;
		}
		
		if(isneedDelFile){
			www.seeyon.com.utils.FileUtil.delDir(new File(zipFilePath));
		}
		
		// 成功接收公文以后， 更新对应表中的状态
		getEdocSummaryAndDataRelationDAO().updateStatus(msgId, EdocSendOrReceiveStatusEnum.Received.getKey());
		return true;
	}
	/*
	 * 在收到公文交换平台发送的公文信息的时候， 调用该方法， 客户端已经返回了接收成功的信息， 所以， 在这里， 必须保证处理正确
	 */
	public static void receiveReceipt(String msgId){

		log.info("receiveReceipt............");
		// 把公文交换系统的 msgId, 转换成 OA 系统的 docId
		//EdocSummaryAndDataRelation edocSummaryAndDataRelation =  getEdocSummaryAndDataRelationDAO().getRelationByMsgId(msgId);
		/*
		Long accountId = edocSummaryAndDataRelation.getAccountId();
		
		V3xOrgAccount v3xOrgAccount = null;
		try {
			v3xOrgAccount = getOrgManager().getAccountById(accountId);
		} catch (BusinessException e1) {
			log.error("", e1);
		}
		*/
		// 下面的收到回执的处理程序来自于  open.seeyon.com
		//0未签收为1更新状态为已签收，为2更新状态为拒绝(第三方系统已签收)
//		DocumentManager  doocumentManager = DocumentManager.getInstance();
//		try {
//			doocumentManager.updateEdocState(edocSummaryAndDataRelation.getEdocId(),String.valueOf(accountId), v3xOrgAccount.getName() ,2);  // OA 中的发送的公文 ID， 接收的单位 ID， 接收的单位名称， 状态
//		} catch (OAInterfaceException e) {
//			log.error("", e);
//		}
		try {
			EdocSummaryAndDataRelation edocSummaryAndDataRelation =  getEdocSummaryAndDataRelationDAO().getRelationByMsgId(msgId);
			
			if(edocSummaryAndDataRelation == null){
				log.info("获取第三方系统签收消息为空！msgId= "+msgId);
				return;
			}
			SendEdocManager sendEdocManager = (SendEdocManager) AppContext.getBean("sendEdocManager");
			EdocSendRecord rec = sendEdocManager.getEdocSendRecord(edocSummaryAndDataRelation.getEdocId());
			getCzDocExchangeManager().updateEdocState(edocSummaryAndDataRelation.getEdocId(),rec.getSendedTypeIds(), rec.getSendedNames() ,1);  // OA 中的发送的公文 ID， 接收的单位 ID， 接收的单位名称， 状态

			// 更新 EdocSummaryAndDataRelation
			getEdocSummaryAndDataRelationDAO().updateStatus(msgId, EdocSendOrReceiveStatusEnum.sendReceived.getKey());  // 
			log.info("第三方系统签收公文更新OA状态完成！msgId="+msgId);
			
		} catch (Exception e) {
			log.error("第三方系统签收公文更新OA状态失败！",e);
		}
		 
	}
	
	public static String[] sendData(String from, String to, String filePath){
		Client client = new Client(jianhuanServer,jianhuanPort);
		return client.sendData(from, to, filePath);
		
	}
	
	public static boolean sendFlag(String msgId, String flag){
		Client client = new Client(jianhuanServer,jianhuanPort);
		try{
			client.sendFlag(msgId, flag);
		}catch(Exception e){
			log.error("", e);
			return false;
		}
		return true;
		
	}
	/*
	 * 下面的是测试 解压 ZIP 的程序
	 */
	/*
	public static void main(String [] args){
		// 测试解压 ZIP 的程序部分
		String msgId = "123456789";
		String tempFilePath="C:\\tempFile";

		//设置tempFilePath的路径
		if(!tempFilePath.endsWith("/")) {
			tempFilePath+="/";
		}
		//解压zip文件
		File zipFile = new File(tempFilePath+"/"+msgId+".zip");
		String fileName = zipFile.getName();
		String outFilePath = tempFilePath + File.separator+fileName.substring(0,fileName.length()-4)+File.separator;
		File tmpFileDir = new File(outFilePath);
		tmpFileDir.mkdirs();
	//	try {
		//	ZipUtil.unzip(zipFile, new File(outFilePath));
		//	com.cinda.exchange.client.util.ZipUtil.unZip(zipFile.getAbsolutePath(), outFilePath);
			CzZipUtil.unZip(zipFile.getAbsolutePath(), outFilePath);
			
	//	} catch (IOException e) {
	//		log.error("", e);
	//	}
		
	}
	*/
	/*
	 * 下面的程序测试收文中的部分程序
	 */
	public static void main1(String [] args){
		
		
		String tempFilePath = "C:\\Seeyon\\A8\\base\\cztemp\\";  // Constant.HD_TEMP_RECEIVE;
		//设置tempFilePath的路径
		if(!tempFilePath.endsWith("/")) {
			tempFilePath+="/";
		}
		String msgId = "123456789";
		//解压zip文件
		// 从下面开始的程序， 用 main 方法进行测试
		File zipFile = new File(tempFilePath+"/"+msgId+".zip");
		String fileName = zipFile.getName();
		String outFilePath = tempFilePath + File.separator+fileName.substring(0,fileName.length()-4)+File.separator;
		File tmpFileDir = new File(outFilePath);
		tmpFileDir.mkdirs();
		try {
			ZipUtil.unzip(zipFile, new File(outFilePath));
		} catch (IOException e) {
			log.error("", e);
		}

		String elementXmlPath = tempFilePath+"/"+msgId;
		// 下面这个文件中， 包含了收到公文的所有的信息
		File elementXml=new File(elementXmlPath+"/element.xml");
		
		Elecdocument elecdocument = XMLUtil.toBean(FileUtil.fileToString(elementXml), Elecdocument.class);
		elecdocument.setMsgId(msgId);
		
		try {
			getCzDocExchangeManager().receiveEdoc(elecdocument);
		} catch (BusinessException e) {
			log.error("", e);
		} catch (OAInterfaceException e) {
			log.error("", e);
		}
		FileUtil.removeFile(tempFilePath+"/"+msgId+".zip");//删除接收到的zip文件
		FileUtil.removeFile(tempFilePath+"/"+msgId);//删除解压后的zip文件夹
		
		// 成功接收公文以后， 更新对应表中的状态
		getEdocSummaryAndDataRelationDAO().updateStatus(msgId, EdocSendOrReceiveStatusEnum.Received.getKey());

	}
	public static void main(String[] args) throws Exception {
		Client cl = new Client("80.32.9.5",9000);
		cl.sendFlag("3353248685", "asdf");
//		cl.sendData("30130030", "30130030", "/Users/mac/Desktop/3353248685717406907.zip");
	}
	
}
