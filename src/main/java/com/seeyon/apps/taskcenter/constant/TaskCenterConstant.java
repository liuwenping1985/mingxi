package com.seeyon.apps.taskcenter.constant;

import com.seeyon.ctp.common.constants.SystemProperties;

public class TaskCenterConstant {
	/**tasskcenter.property[serverconf]*/
	public static final String DATASOURCE = SystemProperties.getInstance().getProperty("taskcenter.groupConfig.serverconf.DATASOURCE", "TaskDB");
	public static final String WEBLOGIC_USER = SystemProperties.getInstance().getProperty("taskcenter.groupConfig.serverconf.WEBLOGIC_USER", "caller");
	public static final String WEBLOGIC_PASSWORD = SystemProperties.getInstance().getProperty("taskcenter.groupConfig.serverconf.WEBLOGIC_PASSWORD", "12345678");
	public static final String PROVIDER_URL = SystemProperties.getInstance().getProperty("taskcenter.groupConfig.serverconf.PROVIDER_URL", "t3://appsrv01:8071,appsrv02:8071,appsrv03:8072,appsrv04:8072,appsrv05:8073,appsrv06:8073");
	public static final String PROVIDER_URL_DB = SystemProperties.getInstance().getProperty("taskcenter.groupConfig.serverconf.PROVIDER_URL_DB", "t3://appsrv01:8071,appsrv02:8071,appsrv03:8072,appsrv04:8072,appsrv05:8073,appsrv06:8073");
	public static final String usermanagerProviderUrl = SystemProperties.getInstance().getProperty("taskcenter.groupConfig.serverconf.usermanagerProviderUrl", "http://portal01.zc.cinda.ccb/um/usermanagerService"); // ÐèÐÞ¸ÄURL  ÕÔ»Ô
	public static final String taskManagerUrl = SystemProperties.getInstance().getProperty("taskcenter.groupConfig.serverconf.taskManagerUrl", "http://portal10.zc.cinda.ccb/gtaskctr/axis/services/");
	
	public static final String hrRemoteUrl = SystemProperties.getInstance().getProperty("taskcenter.groupConfig.serverconf.hrRemoteUrl", "http://hcm.cinda.ccb:7002/hcm/service/WorkToDoWebService?wsdl");//http://80.44.56.129:7006/hcm/service/WorkToDoWebService?wsdl
	public static final String zcRemoteUrl = SystemProperties.getInstance().getProperty("taskcenter.groupConfig.serverconf.zcRemoteUrl", "http://hr-ess.cinda.ccb/ess/jsp/xdzcLogin.jsp");
	/*[TODO]*/
	public static final int pageSize = SystemProperties.getInstance().getIntegerProperty("taskcenter.groupConfig.serverconf.pagesize", 200);
	
	public static final String taskListurl= "/seeyon/taskCenter.do?method=todoList&taskgroup=";
	public static final String taskdoneListurl= "/seeyon/taskCenter.do?method=donelist&taskgroup=";
	public static final String portolurl = SystemProperties.getInstance().getProperty("taskcenter.groupConfig.serverconf.portolurl", "http://portal.zc.cinda.ccb");

}
