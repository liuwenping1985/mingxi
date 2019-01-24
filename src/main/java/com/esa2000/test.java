//package com.esa2000;
//
//import com.esa2000.pdfsign.util.CommonUtil;
//import com.esa2000.pdfsign.util.Log4jLoader;
//
//public class test {
//
//	/**
//	 * @param args
//	 */
//	public static void main(String[] args) {
//		// TODO Auto-generated method stub
//		Log4jLoader.loadLog4j();
////		String waterpath ="E:\\民信测试\\waterMark.png";
////		byte[] imgBytes =CommonUtil.readBytesFromFile(waterpath);
//		String pdfPath = "E:\\民信测试\\201901222.pdf";
//		String signedPdfPath = "E:\\民信测试\\201901222_sign.pdf";
//		String pfxSealPath = "E:\\民信测试\\hetong.dat";
//		byte[] pfxSealBytes = CommonUtil.readBytesFromFile(pfxSealPath);
//
//
//		PfxSignShell signShell = new PfxSignShell();
//
//		signShell.init(pdfPath, signedPdfPath, true);
//
////		signShell.initSoftSeal(pdfPath);
//		signShell.initSoftSeal(pfxSealBytes);
//		// 通过坐标定位盖章
//		// signShell.loadLic("D:/azt.lic");
//		// 设置关键字的偏移量
//		// signShell.setLeftOffset(50);
////		signShell.addImage(imgBytes, 595, 842, 0, 0, 1);
////		signShell.addWaterMark("E:\\民信测试\\waterMark.bmp", 100, 100, 1);
////		signShell.addSeal("buyerkey", 1);
//		signShell.addSeal(100, 100, 1);
//		signShell.sign();
//
//		signShell.close();
//		signShell.getSignCount(signedPdfPath);
//		 CommonUtil.openFile(signedPdfPath);
//
//	}
//
//}
