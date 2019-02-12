package cn.com.cinda.taskcenter.common;

/**
 * 任务中心常量声明
 * 
 * @author hkgt
 * 
 */
public final class TaskInfor {

	/**
	 * 应用编码：所有
	 */
	public final static String APP_CODE_All = "ALL";
	/**
	 * 应用编码：诉讼预警
	 */
	public final static String APP_CODE_SSYJ = "SSYJ";

	/**
	 * 应用编码：处置流程
	 */
	public final static String APP_CODE_CZLC = "CZLC";
	/**
	 * 应用编码：跟进审计
	 */
	public final static String APP_CODE_GJSJ = "GJSJ";

	/**
	 * 应用编码：模板流程
	 */
	public final static String APP_CODE_MBLC = "MBLC";

	/**
	 * 应用编码：项目档案
	 */
	public final static String APP_CODE_XMDA = "XMDA";

	/**
	 * 应用编码：OA流程
	 */
	public final static String APP_CODE_OA = "OALC";

	/**
	 * 应用编码：ISO
	 */
	public final static String APP_CODE_ISO = "ISO";

	/**
	 * 配置文件路径
	 */
	public final static String CONFIG_FILE_PATH = "/home/ap/commcfg/taskcenter/taskCenter.property";
	
	//门户配置文件路径
	public final static String DOMAIN_FILE_PATH = "/home/ap/commcfg/idpserver/env.properties";
	/**
	 * 任务类型：流程应用
	 */
	public final static int TASK_KIND_APP = 10;

	/**
	 * 任务类型：任务管理
	 */
	public final static int TASK_KIND_MANAGE = 20;

	/**
	 * 任务类型：其他
	 */
	public final static int TASK_KIND_OTHER = 30;
	/**
	 * 任务类型：所有
	 */
	public final static int TASK_KIND_ALL = 40;

	/**
	 * 应用链接状态：待办
	 */
	public final static String APP_LINK_TODO = "0";

	/**
	 * 应用链接状态：已办
	 */
	public final static String APP_LINK_DONE = "1";

	/**
	 * 应用链接状态：转交
	 */
	public final static String APP_LINK_DELIVER = "2";

	/**
	 * 任务状态：新建
	 */
	public final static int TASK_STATUS_BUILD = 10;

	/**
	 * 任务状态：已分配、指派
	 */
	public final static int TASK_STATUS_ASSIGNED = 11;

	/**
	 * 任务状态：已分配，但还没有接受(待办)
	 */
	public final static int TASK_STATUS_READED = 12;

	/**
	 * 任务状态：已申领，已经接受(在办)
	 */
	public final static int TASK_STATUS_APPED = 13;

	/**
	 * 任务状态：完成
	 */
	public final static int TASK_STATUS_FINISHED = 14;

	/**
	 * 任务状态：已终止
	 */
	public final static int TASK_STATUS_CANCEL = 15;
	/**
	 * 任务状态：所有
	 */
	public final static int TASK_STATUS_ALL = 99;

	/**
	 * 流程结束时，任务所处环节值
	 */
	public final static String FLOW_END_BATCH_NAME = "流程结束";

	/**
	 * 消息状态：不发送
	 */
	public final static int TASK_MSG_STATUS_NOSEND = 10;

	/**
	 * 消息状态：发送、还没有发送
	 */
	public final static int TASK_MSG_STATUS_SEND = 11;

	/**
	 * 消息状态：已经发送
	 */
	public final static int TASK_MSG_STATUS_SENDED = 12;

	/**
	 * 消息状态：发送失败
	 */
	public final static int TASK_MSG_STATUS_SENDFAIL = 13;

	/**
	 * 是否允许转交：不允许
	 */
	public final static int TASK_ALLOW_DELIVER_NO = 0;

	/**
	 * 是否允许转交：允许
	 */
	public final static int TASK_ALLOW_DELIVER_YES = 1;

	/**
	 * 任务结果编码：提交(默认)
	 */
	public final static String TASK_RESULT_CODE = "0";

	/**
	 * 任务结果编码：同意
	 */
	public final static String TASK_RESULT_CODE_AGREE = "1";

	/**
	 * 任务结果编码：退回
	 */
	public final static String TASK_RESULT_CODE_BACK = "2";

	/**
	 * 任务结果编码：否决
	 */
	public final static String TASK_RESULT_CODE_NOTAGREE = "3";

	/**
	 * 是否允许删除任务：不允许
	 */
	public final static int TASK_ALLOW_DELETE_NO = 0;

	/**
	 * 是否允许删除任务：允许
	 */
	public final static int TASK_ALLOW_DELETE_YES = 1;

	/**
	 * 应用自定义字段名称1
	 */
	public final static String APP_VAR_1 = "APP_VAR_1";

	/**
	 * 应用自定义字段名称2
	 */
	public final static String APP_VAR_2 = "APP_VAR_2";

	/**
	 * 应用自定义字段名称3
	 */
	public final static String APP_VAR_3 = "APP_VAR_3";

	/**
	 * 应用自定义字段名称4
	 */
	public final static String APP_VAR_4 = "APP_VAR_4";

	/**
	 * 应用流程名称
	 */
	public final static String APP_VAR_5 = "APP_VAR_5";

	/**
	 * 应用自定义字段名称6
	 */
	public final static String APP_VAR_6 = "APP_VAR_6";

	/**
	 * 应用自定义字段名称7
	 */
	public final static String APP_VAR_7 = "APP_VAR_7";

	/**
	 * 应用自定义字段名称8
	 */
	public final static String APP_VAR_8 = "APP_VAR_8";

	/**
	 * 应用自定义字段名称9
	 */
	public final static String APP_VAR_9 = "APP_VAR_9";

	/**
	 * 权限使用：全域管理员(系统管理员)
	 */
	public final static String SYSTEM_ADMINISTRATOR = "ZGS_TASK_QYGLY";

	/**
	 * 权限使用：办事处管理员(部门管理员)
	 */
	public final static String DEP_ADMINISTRATOR = "BSC_TASK_GLY";

	/**
	 * 任务待办列表每页显示记录条数
	 */
	public final static int TODOLIST_PAGE_COUNT_USE = 5;

	/**
	 * 任务已办列表每页显示记录条数
	 */
	public final static int DONELIST_PAGE_COUNT_USE = 5;

	/**
	 * 监控列表每页显示记录条数
	 */
	public final static int MONITORLIST_PAGE_COUNT_USE = 15;

	/**
	 * 已办查询列表每页显示记录条数
	 */
	public final static int DONE_QUERYLIST_PAGE_COUNT_USE = 15;

}
