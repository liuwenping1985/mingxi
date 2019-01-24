package com.esa2000;

import java.io.File;

import com.esa2000.pdfsign.util.FileUtil;

public class Reources {
	
	public static String USER_DIR = System.getProperty("user.dir");
	public static String DAT_PATH = USER_DIR + "/temp/dat/";
	public static String PFX_PATH = USER_DIR + "/temp/pfx/";
	public static String IMG_PATH = USER_DIR + "/temp/img/";
	public static String OUTPUT_PATH = USER_DIR + "/temp/output/";
	public static String PDF_PATH = USER_DIR + "/temp/pdf/";

	public static String PDF_LATERAL = "src/test/reource/pdf/LateralPDF.pdf";
	public static String PDF_LATERAL1 = "src/test/reource/pdf/LateralPDF1.pdf";
	public static String PDF_VERTICAL = "src/test/reource/pdf/VerticalPDF.pdf";
	public static String PDF_BJAZT = "src/test/reource/pdf/bjazt.pdf";
	public static String PDF_PAGE13 = "src/test/reource/pdf/Page13.pdf";
	public static String PDF_ITEXT_CREATE= "src/test/reource/pdf/Itext_Create.pdf";
	public static String PDF_PP= "src/test/reource/pdf/pp.pdf";
	public static String PDF_BLANK = "src/test/reource/pdf/1.pdf";
	public static String PDF_WK_CREATE = "src/test/reource/pdf/WK_Create1.pdf";
	public static String PDF_WordSave = "src/test/reource/pdf/PDF 电子签章云计算服务器演示说明_WordSave.pdf";
	public static String PDF_WPSSave = "src/test/reource/pdf/PDF 电子签章云计算服务器演示说明_WPSSave.pdf";
	public static String PDF_YZOfficeSave = "src/test/reource/pdf/PDF 电子签章云计算服务器演示说明_YZOfficeSave.pdf";
	public static String PDF_EN_123456 = "src/test/reource/pdf/JiaMi_By123456.pdf";

	public static String IMG_WATER_MARK = "src/test/reource/img/WaterMark.bmp";
	public static String IMG_SEAL_ZXH = "src/test/reource/img/ZhouXiaoHua.bmp";
	public static String IMG_SEAL_LCW = "src/test/reource/img/signImg.bmp";
	public static String IMG_SEAL_BJAZT = "src/test/reource/img/印章4.bmp";
	public static String IMG_SEAL_300DPI_BMP = "src/test/reource/img/300DPI.bmp";
	public static String IMG_SEAL_5DPI_BMP = "src/test/reource/img/50DPI.bmp";
	public static String IMG_SEAL_300DPI_GIF = "src/test/reource/img/300DPI.gif";
	public static String IMG_SEAL_50DPI_GIF = "src/test/reource/img/50DPI.gif";
	public static String IMG_SEAL_BIG = "src/test/reource/img/电子公章_大.bmp";
	public static String IMG_SEAL = "src/test/reource/img/";
	
	public static String PFX_TEST1 = "src/test/reource/pfx/test1.pfx";
	public static String PFX_PASSWORD = "1111";

	public static String DAT_BASEPATH = "src/test/reource/dat/";
	public static String DAT_GZ = DAT_BASEPATH + "0100000000.dat";
	public static String DAT_SZ = DAT_BASEPATH + "Lcw.dat";
	
	public static String LOG4j = "src/test/reource/PDFLog.properties";
	public static String TARGET_PATH = "test/";
	
	//根证书目录
	public static final String ROOT_CERT_RESOUCE = System.getProperty("user.dir")+ File.separator+"resource" ;

	static {
		FileUtil.mkdir(TARGET_PATH);
	}
}
