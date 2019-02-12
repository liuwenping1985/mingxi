package cn.com.cinda.taskcenter.common;

/**
 * 定义全局变量的参数(该类已经被新类TaskInfor替换，最好使用新类)
 */

public class GloabVar {

	// 任务类型
	public final static Integer TASK_KIND_APP = new Integer(
			TaskInfor.TASK_KIND_APP);// 流程应用

	public final static Integer TASK_KIND_MANAGE = new Integer(
			TaskInfor.TASK_KIND_MANAGE);// 任务管理

	public final static Integer TASK_KIND_OTHER = new Integer(
			TaskInfor.TASK_KIND_OTHER);// 其他

	// 任务状态
	public final static int TASK_STATUS_BUILD = TaskInfor.TASK_STATUS_BUILD;// 建立

	public final static int TASK_STATUS_ASSIGNED = TaskInfor.TASK_STATUS_ASSIGNED;// 已分配、指派

	public final static int TASK_STATUS_READED = TaskInfor.TASK_STATUS_READED;// 已读

	public final static int TASK_STATUS_APPED = TaskInfor.TASK_STATUS_APPED;// 已申请

	public final static int TASK_STATUS_FINISHED = TaskInfor.TASK_STATUS_FINISHED;// 已完成

	// public final static Integer TASK_STATUS_APPED2 = new Integer(21);// 已申请
	//
	// public final static Integer TASK_STATUS_FINISHED2 = new Integer(31);//
	// 已完成

	// 消息发送状态
	public final static Integer TASK_MSG_STATUS_NOSEND = new Integer(
			TaskInfor.TASK_MSG_STATUS_NOSEND);// 不发送

	public final static Integer TASK_MSG_STATUS_SEND = new Integer(
			TaskInfor.TASK_MSG_STATUS_SEND);// 发送、没有发送

	public final static Integer TASK_MSG_STATUS_SENDED = new Integer(
			TaskInfor.TASK_MSG_STATUS_SENDED);// 已经发送

	public final static Integer TASK_MSG_STATUS_SENDFAIL = new Integer(
			TaskInfor.TASK_MSG_STATUS_SENDFAIL);// 发送失败

	// 是否允许转交
	public final static Integer TASK_ALLOW_DELIVER_NO = new Integer(
			TaskInfor.TASK_ALLOW_DELIVER_NO);// 不允许转交

	public final static Integer TASK_ALLOW_DELIVER_YES = new Integer(
			TaskInfor.TASK_ALLOW_DELIVER_YES);// 允许转交

	// //TASK_RESULT任务结果编码表中所带的参数

	// 结果编码
	public final static String TASK_RESULT_CODE_AGREE = TaskInfor.TASK_RESULT_CODE_AGREE;// 同意

	public final static String TASK_RESULT_CODE_BACK = TaskInfor.TASK_RESULT_CODE_BACK;// 退回

	public final static String TASK_RESULT_CODE_NOTAGREE = TaskInfor.TASK_RESULT_CODE_NOTAGREE;// 否决

	public final static String TASK_RESULT_CODE = TaskInfor.TASK_RESULT_CODE;// 默认－提交

	// 删除标记
	public final static Integer Delflag = new Integer(TaskInfor.TASK_ALLOW_DELETE_NO);// 默认－删除标记

	public final static String APP_VAR_1 = "APP_VAR_1";

	public final static String APP_VAR_2 = "APP_VAR_2";

	public final static String APP_VAR_3 = "APP_VAR_3";

	public final static String APP_VAR_4 = "APP_VAR_4";

	public final static String APP_VAR_5 = "APP_VAR_5";

	public final static String APP_VAR_6 = "APP_VAR_6";

	public final static String APP_VAR_7 = "APP_VAR_7";

	public final static String APP_VAR_8 = "APP_VAR_8";

	public final static String APP_VAR_9 = "APP_VAR_9";

	// 权限使用
	public final static String SYSTEM_ADMINISTRATOR = TaskInfor.SYSTEM_ADMINISTRATOR;// 全域管理员(系统管理员)

	public final static String DEP_ADMINISTRATOR = TaskInfor.DEP_ADMINISTRATOR;// 办事处管理员(部门管理员)

}
