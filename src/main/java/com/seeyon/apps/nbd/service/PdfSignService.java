//package com.seeyon.apps.nbd.service;
//
//import com.esa2000.PfxSignShell;
//import com.esa2000.pdfsign.server.ShellExtendForSubCerter;
//import com.esa2000.pdfsign.util.ImageProcess;
//import com.seeyon.apps.nbd.core.config.ConfigService;
//import com.seeyon.apps.nbd.core.util.CommonUtils;
//
///**
// * Created by liuwenping on 2019/1/28.
// */
//public class PdfSignService {
//
//
//    public static void sign(String inputFile,String outputFile){
//
//        ShellExtendForSubCerter shellExtend = new ShellExtendForSubCerter();
//        // 设置编码方式,GBK或者UTF-8
//        shellExtend.setCharsetName("UTF-8");
//        String certQueryServerUrl = ConfigService.getPropertyByName("sign_cert_url","");
////		shellExtend.setColor(Color.red);
////		String userName = shellExtend.getUserName();
//        //String time = CommonUtil.getCurrTimeString("yyyy年MM月dd日");
//        // 组合需要添加的字符串，以"\n"换行
////		StringBuffer sealTextBuffer = new StringBuffer();
//
//
////		sealTextBuffer.append(userName);
//
//        // 下载证书并生成图片
//        //initCert参数描述：参数1：下载证书url；参数2：证书编号
////		int result = shellExtend.initCert(certQueryServerUrl, certId);
//        String certId = ConfigService.getPropertyByName("sign_cert_id","");
//        int result = shellExtend.initCACert(certQueryServerUrl, certId, "mca");
////		int result = shellExtend.initCert(certQueryServerUrl, certId, "dfca","123456");
////		int result = shellExtend.initCert(certQueryServerUrl, certId.trim(), "dfca","111111");
//
//        if(result == 0) {// 成功
//            PfxSignShell signShell = new PfxSignShell();
//            //初始化签章文档
////			signShell.init(Reources.PDF_BLANK, signedPdfPath, true);
//            signShell.init(inputFile, outputFile, true);
//
//            //生成公章
//            String companyName = ConfigService.getPropertyByName("sign_company_name","测试单位");
//            String typeName = ConfigService.getPropertyByName("sign_type_name","合同专用章");
//
//            String keyWords = ConfigService.getPropertyByName("sign_key_words","盖章,签字盖章");
//
//            byte[] imgBytes = ImageProcess.createCircleSeal(companyName , typeName);
//            //初始化证书印章数据
////			  byte[] imgBytes = ImageProcess.drawRectangleSealImg(userName);
//            signShell.initSoftSeal(shellExtend.getPfxBytes(), imgBytes, shellExtend.getPassword());
//            //byte[] imgBytes = ImageProcess.createEllipseSeal(firmName, centerName, sealType, 200, 200);
////			signShell.initSoftSeal(shellExtend.getPfxBytes(),shellExtend.getImageBytes(),shellExtend.getPassword());
////			signShell.initSoftSeal(shellExtend);
////			signShell.addSealText(sealTextBuffer.toString(), 100, 100, 1);
//// 			signShell.addSealText(time, 100, 200, 1);
//            //定位
//            String[] keyWds = keyWords.split(",");
//            if(CommonUtils.isNotEmpty(keyWds)){
//                return ;
//            }
//
//           // InputStream is=null;
//            //PropertyConfigurator.configure(is);
//           // signShell.addSeal()
//            for(String key:keyWds){
//                try {
//                    signShell.addSeal(key);
//                    signShell.sign();
//                    //关闭
//                    signShell.close();
//                    break;
//                }catch(Exception e){
//                    e.printStackTrace();
//                }
//            }
////            signShell.addSeal(100, 200, 1);
//////			signShell.addImage(imgBytes, 300, 300, 100, 100, 1);
////            //签名
////            signShell.sign();
////            //关闭
////            signShell.close();
//        } else {
//            System.out.println("获取软证书失败，错误代码如下：" + result);
//        }
//
////		Assert.assertTrue(new File(signedPdfPath).exists());
//       // CommonUtil.openFile(outputFile);
//    }
//
//}
