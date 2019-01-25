package com.esa2000.subcenter;

import com.esa2000.PfxSignShell;
//import com.esa2000.pdfsign.draw.ImageProcess;
import com.esa2000.pdfsign.server.ShellExtendForSubCerter;
import com.esa2000.pdfsign.util.CommonUtil;
import com.esa2000.pdfsign.util.ImageProcess;
import org.apache.log4j.PropertyConfigurator;

import java.io.InputStream;

public class PDFSignDemoDUOCA {
	
	 static String name ="11";
	 static String OUTPUT_PATH= "/Users/liuwenping/Documents/"+name+"_sign.pdf" ;
	 static String INPUT_PATH= "/Users/liuwenping/Documents/"+name+".pdf" ;
	 
//     public void testAddSealFromSubCerter() throws Exception {
// 		signedPdfPath = String.format(DEST, "add_seal_from_sub_center");
    	
	 	public static void main(String[] args) throws Exception{
 		ShellExtendForSubCerter shellExtend = new ShellExtendForSubCerter();


		// ------------------  设置一些基本信息并下载证书  ------------------
		// 下载软证书用的URL
//		String certQueryServerUrl = "https://api.easysign.cn/MuCA/CertQueryServlet";
 		String certQueryServerUrl = "http://testyqt.easysign.cn:8028/APIService/MuCA/CertQueryServlet";
// 		String certQueryServerUrl = "http://azt.easysign.cn/MuCA/CertQueryServlet";
//		String certQueryServerUrl = "http://127.0.0.1:8080/APWebPF/CertQueryServlet";
//		String certQueryServerUrl = "http://120.27.143.67:8080/APWebPF/CertQueryServlet";
		// 证书ID
		String certId = "AE99909DFBFE39E29D9D5CC7E9BC4F4E";
		// 设置编码方式,GBK或者UTF-8
		shellExtend.setCharsetName("UTF-8");
//		shellExtend.setColor(Color.red);
//		String userName = shellExtend.getUserName();
		//String time = CommonUtil.getCurrTimeString("yyyy年MM月dd日");
		// 组合需要添加的字符串，以"\n"换行
//		StringBuffer sealTextBuffer = new StringBuffer();
		
		
//		sealTextBuffer.append(userName);
		
		// 下载证书并生成图片
		//initCert参数描述：参数1：下载证书url；参数2：证书编号
//		int result = shellExtend.initCert(certQueryServerUrl, certId);
		int result = shellExtend.initCACert(certQueryServerUrl, certId, "mca");
//		int result = shellExtend.initCert(certQueryServerUrl, certId, "dfca","123456");
//		int result = shellExtend.initCert(certQueryServerUrl, certId.trim(), "dfca","111111");

		if(result == 0) {// 成功
			PfxSignShell signShell = new PfxSignShell();
			//初始化签章文档
//			signShell.init(Reources.PDF_BLANK, signedPdfPath, true);
			signShell.init(INPUT_PATH, OUTPUT_PATH, true);
			
			//生成公章
			
			byte[] imgBytes = ImageProcess.createCircleSeal("深圳市前盛供应链贸易有限公司 ", "合同专用章");
			//初始化证书印章数据
//			  byte[] imgBytes = ImageProcess.drawRectangleSealImg(userName);
			signShell.initSoftSeal(shellExtend.getPfxBytes(), imgBytes, shellExtend.getPassword());
			//byte[] imgBytes = ImageProcess.createEllipseSeal(firmName, centerName, sealType, 200, 200);
//			signShell.initSoftSeal(shellExtend.getPfxBytes(),shellExtend.getImageBytes(),shellExtend.getPassword());
//			signShell.initSoftSeal(shellExtend);
//			signShell.addSealText(sealTextBuffer.toString(), 100, 100, 1);
// 			signShell.addSealText(time, 100, 200, 1);
			//定位
			InputStream is=null;
			//PropertyConfigurator.configure(is);
			signShell.addSeal(100, 200, 1);
//			signShell.addImage(imgBytes, 300, 300, 100, 100, 1);
			//签名
			signShell.sign();
			//关闭
			signShell.close();
		} else {
			System.out.println("获取软证书失败，错误代码如下：" + result);
		}

//		Assert.assertTrue(new File(signedPdfPath).exists());
		CommonUtil.openFile(OUTPUT_PATH);
	}
	 	
	
}