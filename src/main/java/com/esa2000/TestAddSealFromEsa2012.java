package com.esa2000;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

import com.esa2000.pdfsign.SealControl;
import com.esa2000.pdfsign.util.CommonUtil;
import com.esa2000.pdfsign.util.Log4jLoader;
import com.esa2000.pdfsign.util.PFXSealDownloader;


public class TestAddSealFromEsa2012 {

	public static void main(String[] args) throws MalformedURLException, IOException {
		Log4jLoader.loadLog4j();
//		String name ="2222";//文件名称
//	    String INPUT_PATH= "temp\\pdf\\"+name+".pdf" ;//输入路径
//	    String OUTPUT_PATH= "temp\\output\\"+name+"_sign.pdf" ;//输出路径
		String pdfPath = "E:\\民信测试\\00007.pdf";
		String signedPdfPath = "E:\\民信测试\\00007g_sign.pdf";
		
		
		//电子印章服务软证书下载路径
		String servletUrl = "http://103.245.130.251:8080/APWebPF/PFXSealServlet";
//		String servletUrl = "http://103.245.131.104:8080/APWebPF/PFXSealServlet";
//		String servletUrl = "http://esa.ikongjian.com/APWebPF/PFXSealServlet";
//	    String servletUrl = "http://es.jicleasing.cn:8080/APWebPF/PFXSealServlet";
	    
		// 印章特性码
		String sealCode = "91110117563632538D002";
		// 印章类型 
		int sealType = 1;
		try{
			//esa2012不需要进行编码  一签通需要进行编码
			// 电子印章服务软证书下载接口
			sealCode = CommonUtil.base64EncodeString(sealCode, "UTF-8");
			
			String returnResult = PFXSealDownloader.downloadPfxSealFromEsa2012(servletUrl, sealCode, sealType);
			
			if(returnResult!=null&&!"".equals(returnResult)&&!returnResult.equals("1")) {
				// 电子印章获取成功				
				PfxSignShell signShell = new PfxSignShell();
				
				signShell.init(pdfPath,signedPdfPath, true);
				signShell.setLeftOffset(40);
				signShell.initSoftSeal(returnResult.getBytes());
//				signShell.addText("同意审批", 100, 100, 2);
//				signShell.addSeal(110,110,1);
				signShell.addSeal("卖方：");
				signShell.sign();
				signShell.close();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		CommonUtil.openFile(signedPdfPath);
	}
	
}
