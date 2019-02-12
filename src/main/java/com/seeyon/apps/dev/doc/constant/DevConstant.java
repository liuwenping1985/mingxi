package com.seeyon.apps.dev.doc.constant;

import com.seeyon.ctp.common.constants.SystemProperties;


public abstract class DevConstant {
	public static final String EXPORT_DOC_KEY= "EXPORT_DOC_ExportMapVO_SessionContext_KEY";
	public static String transPdfserverAddr = SystemProperties.getInstance().getProperty("exportdoc.transpdf.serverAddress", "80.46.8.69");
	public static int transPdfserverport = SystemProperties.getInstance().getIntegerProperty("exportdoc.transpdf.serverport", 5801);
	public static final String Edoc_WD = "文单";
	public static final String Edoc_ZW = "正文";
	public static final String Doc_FJ = "附件";
	public static final String EXP_Form = "表单";
	public static final String EXP_Edoc = "公文";
	public static final String File_dot = ".";
}
