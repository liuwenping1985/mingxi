package cn.com.cinda.taskcenter.model;

import java.io.Serializable;

/**
 * 任务中心的任务对象
 * 
 * @author hkgt
 * 
 */
public class Task implements Serializable {

	public Task() {

	}

	// 计算任务数量
	int count;

	// 计算任务数量
	int countA;

	// 计算任务数量
	int countB;

	// 计算任务数量
	int countC;

	// 计算任务数量
	int countD;

	// 计算任务数量
	int countE;

	// 计算任务数量
	int countF;

	// 计算所有已经完成的任务需要的时间
	float timeAll;

	// 计算完成已经完成的任务所需要的平均时间
	float timeAvg;

	// 链接类型编码
	String task_linkType_code = "";

	// 链接路径
	String task_link_format = "";
   //其他 链接路径
	String task_link_format2 = "";
   //	 其他链接路径
	String task_link_format3 = "";
   //	其他 链接路径
	String task_link_format4= "";
   //	 其他链接路径
	String task_link_format5 = "";

	// 链接状态
	String task_link_status = "";

	// 应用编码
	String task_app_code = "";

	// 应用名称
	String task_app_name = "";

	// 数据库中的字段
	/**
	 * 任务id 由应用编码+"-"+应用自定义id组成， 应用编码具体值要引用常量类TaskInfor中定义的
	 */
	String task_id;

	/**
	 * 任务类型
	 */
	Integer task_kind;

	/**
	 * 任务所属批次
	 */
	String task_batch_id;

	/**
	 * 任务批次名称
	 */
	String task_batch_name;

	/**
	 * 流程环节名称
	 */
	String task_stage_name;

	/**
	 * 任务主题
	 */
	String task_subject;

	/**
	 * 任务内容
	 */
	String task_content;

	/**
	 * 任务状态
	 */
	String task_status;

	/**
	 * 创建者
	 */
	String task_creator;

	/**
	 * 指派者
	 */
	String task_designator;

	/**
	 * 被分配者
	 */
	String task_assigneer;

	/**
	 * 分配机制
	 */
	String task_assignee_rule;

	/**
	 * 被抄送者
	 */
	String task_cc;

	/**
	 * 是否允许转交
	 */
	Integer task_allow_deliver;

	/**
	 * 申领人
	 */
	String task_confirmor;

	/**
	 * 执行人
	 */
	String task_executor;

	/**
	 * 提交人
	 */
	String task_submit;

	/**
	 * 创建时间
	 */
	String task_create_time;

	/**
	 * 分配时间
	 */
	String task_assignee_time;

	/**
	 * 申领时间
	 */
	String task_confirm_time;

	/**
	 * 完成时间
	 */
	String task_submit_time;

	/**
	 * 结果代码
	 */
	String task_result_code;

	/**
	 * 机构代码
	 */
	String dept_code;

	/**
	 * 意见内容
	 */
	String task_comments;

	/**
	 * 应用来源
	 */
	String task_app_src;

	/**
	 * 应用模块
	 */
	String task_app_moudle;

	/**
	 * 应用自定义1
	 */
	String app_var_1;

	/**
	 * 应用自定义2
	 */
	String app_var_2;

	/**
	 * 应用自定义3
	 */
	String app_var_3;

	/**
	 * 应用自定义4
	 */
	String app_var_4;

	/**
	 * 应用流程名称
	 */
	String app_var_5;

	/**
	 * 应用自定义6
	 */
	String app_var_6;

	/**
	 * 应用自定义7
	 */
	String app_var_7;

	/**
	 * 应用自定义8
	 */
	String app_var_8;

	/**
	 * 应用自定义9
	 */
	String app_var_9;

	/**
	 * 消息id
	 */
	String task_msg_id;

	/**
	 * 消息状态
	 */
	Integer task_msg_status;

	/**
	 * 链接格式类型
	 */
	String task_link_type;

	/**
	 * 第二个链接
	 */
	String task_link2_name;

	/**
	 * 第二个链接格式类型
	 */
	String task_link2_type;

	/**
	 * 第3个链接
	 */
	String task_link3_name;

	/**
	 * 第3个链接格式类型
	 */
	String task_link3_type;

	/**
	 * 第4个链接
	 */
	String task_link4_name;

	/**
	 * 第4个链接格式类型
	 */
	String task_link4_type;

	/**
	 * 第5个链接
	 */
	String task_link5_name;

	/**
	 * 第5个链接格式类型
	 */
	String task_link5_type;

	/**
	 * 删除标记
	 */
	Integer delflag;

	/**
	 * 日期1
	 */
	String date1;

	/**
	 * 日期2
	 */
	String date2;

	/**
	 * 应用自定义状态
	 */
	String task_app_state;

	public String getDate1() {
		return date1;
	}

	public void setDate1(String date1) {
		this.date1 = date1;
	}

	public String getDate2() {
		return date2;
	}

	public void setDate2(String date2) {
		this.date2 = date2;
	}

	public String getApp_var_1() {
		return app_var_1;
	}

	public void setApp_var_1(String app_var_1) {
		this.app_var_1 = app_var_1;
	}

	public String getApp_var_2() {
		return app_var_2;
	}

	public void setApp_var_2(String app_var_2) {
		this.app_var_2 = app_var_2;
	}

	public String getApp_var_3() {
		return app_var_3;
	}

	public void setApp_var_3(String app_var_3) {
		this.app_var_3 = app_var_3;
	}

	public String getApp_var_4() {
		return app_var_4;
	}

	public void setApp_var_4(String app_var_4) {
		this.app_var_4 = app_var_4;
	}

	public String getApp_var_5() {
		return app_var_5;
	}

	public void setApp_var_5(String app_var_5) {
		this.app_var_5 = app_var_5;
	}

	public String getApp_var_6() {
		return app_var_6;
	}

	public void setApp_var_6(String app_var_6) {
		this.app_var_6 = app_var_6;
	}

	public String getApp_var_7() {
		return app_var_7;
	}

	public void setApp_var_7(String app_var_7) {
		this.app_var_7 = app_var_7;
	}

	public String getApp_var_8() {
		return app_var_8;
	}

	public void setApp_var_8(String app_var_8) {
		this.app_var_8 = app_var_8;
	}

	public String getApp_var_9() {
		return app_var_9;
	}

	public void setApp_var_9(String app_var_9) {
		this.app_var_9 = app_var_9;
	}

	public Integer getDelflag() {
		return delflag;
	}

	public void setDelflag(Integer delflag) {
		this.delflag = delflag;
	}

	public String getDept_code() {
		return dept_code;
	}

	public void setDept_code(String dept_code) {
		this.dept_code = dept_code;
	}

	public Integer getTask_allow_deliver() {
		return task_allow_deliver;
	}

	public void setTask_allow_deliver(Integer task_allow_deliver) {
		this.task_allow_deliver = task_allow_deliver;
	}

	public String getTask_app_src() {
		return task_app_src;
	}

	public void setTask_app_src(String task_app_src) {
		this.task_app_src = task_app_src;
	}

	public String getTask_app_moudle() {
		return task_app_moudle;
	}

	public void setTask_app_moudle(String task_app_moudle) {
		this.task_app_moudle = task_app_moudle;
	}

	public String getTask_assignee_rule() {
		return task_assignee_rule;
	}

	public void setTask_assignee_rule(String task_assignee_rule) {
		this.task_assignee_rule = task_assignee_rule;
	}

	public String getTask_assignee_time() {
		return task_assignee_time;
	}

	public void setTask_assignee_time(String task_assignee_time) {
		this.task_assignee_time = task_assignee_time;
	}

	public String getTask_assigneer() {
		return task_assigneer;
	}

	public void setTask_assigneer(String task_assigneer) {
		this.task_assigneer = task_assigneer;
	}

	public String getTask_batch_id() {
		return task_batch_id;
	}

	public void setTask_batch_id(String task_batch_id) {
		this.task_batch_id = task_batch_id;
	}

	public String getTask_batch_name() {
		return task_batch_name;
	}

	public void setTask_batch_name(String task_batch_name) {
		this.task_batch_name = task_batch_name;
	}

	public String getTask_cc() {
		return task_cc;
	}

	public void setTask_cc(String task_cc) {
		this.task_cc = task_cc;
	}

	public String getTask_creator() {
		return task_creator;
	}

	public void setTask_creator(String task_creator) {
		this.task_creator = task_creator;
	}

	public String getTask_comments() {
		return task_comments;
	}

	public void setTask_comments(String task_comments) {
		this.task_comments = task_comments;
	}

	public String getTask_confirm_time() {
		return task_confirm_time;
	}

	public void setTask_confirm_time(String task_confirm_time) {
		this.task_confirm_time = task_confirm_time;
	}

	public String getTask_confirmor() {
		return task_confirmor;
	}

	public void setTask_confirmor(String task_confirmor) {
		this.task_confirmor = task_confirmor;
	}

	public String getTask_content() {
		return task_content;
	}

	public void setTask_content(String task_content) {
		this.task_content = task_content;
	}

	public String getTask_create_time() {
		return task_create_time;
	}

	public void setTask_create_time(String task_create_time) {
		this.task_create_time = task_create_time;
	}

	public String getTask_designator() {
		return task_designator;
	}

	public void setTask_designator(String task_designator) {
		this.task_designator = task_designator;
	}

	public String getTask_executor() {
		return task_executor;
	}

	public void setTask_executor(String task_executor) {
		this.task_executor = task_executor;
	}

	public String getTask_id() {
		return task_id;
	}

	/**
	 * 任务id 由应用编码+"-"+应用自定义id组成， 应用编码具体值要引用常量类TaskInfor中定义的
	 */
	public void setTask_id(String task_id) {
		this.task_id = task_id;
	}

	public Integer getTask_kind() {
		return task_kind;
	}

	public void setTask_kind(Integer task_kind) {
		this.task_kind = task_kind;
	}

	public String getTask_link_type() {
		return task_link_type;
	}

	public void setTask_link_type(String task_link_type) {
		this.task_link_type = task_link_type;
	}

	public String getTask_link2_name() {
		return task_link2_name;
	}

	public void setTask_link2_name(String task_link2_name) {
		this.task_link2_name = task_link2_name;
	}

	public String getTask_link2_type() {
		return task_link2_type;
	}

	public void setTask_link2_type(String task_link2_type) {
		this.task_link2_type = task_link2_type;
	}

	public String getTask_link3_name() {
		return task_link3_name;
	}

	public void setTask_link3_name(String task_link3_name) {
		this.task_link3_name = task_link3_name;
	}

	public String getTask_link3_type() {
		return task_link3_type;
	}

	public void setTask_link3_type(String task_link3_type) {
		this.task_link3_type = task_link3_type;
	}

	public String getTask_link4_name() {
		return task_link4_name;
	}

	public void setTask_link4_name(String task_link4_name) {
		this.task_link4_name = task_link4_name;
	}

	public String getTask_link4_type() {
		return task_link4_type;
	}

	public void setTask_link4_type(String task_link4_type) {
		this.task_link4_type = task_link4_type;
	}

	public String getTask_link5_name() {
		return task_link5_name;
	}

	public void setTask_link5_name(String task_link5_name) {
		this.task_link5_name = task_link5_name;
	}

	public String getTask_link5_type() {
		return task_link5_type;
	}

	public void setTask_link5_type(String task_link5_type) {
		this.task_link5_type = task_link5_type;
	}

	public String getTask_msg_id() {
		return task_msg_id;
	}

	public void setTask_msg_id(String task_msg_id) {
		this.task_msg_id = task_msg_id;
	}

	public Integer getTask_msg_status() {
		return task_msg_status;
	}

	public void setTask_msg_status(Integer task_msg_status) {
		this.task_msg_status = task_msg_status;
	}

	public String getTask_result_code() {
		return task_result_code;
	}

	public void setTask_result_code(String task_result_code) {
		this.task_result_code = task_result_code;
	}

	public String getTask_stage_name() {
		return task_stage_name;
	}

	public void setTask_stage_name(String task_stage_name) {
		this.task_stage_name = task_stage_name;
	}

	public String getTask_status() {
		return task_status;
	}

	public void setTask_status(String task_status) {
		this.task_status = task_status;
	}

	public String getTask_subject() {
		return task_subject;
	}

	public void setTask_subject(String task_subject) {
		this.task_subject = task_subject;
	}

	public String getTask_submit() {
		return task_submit;
	}

	public void setTask_submit(String task_submit) {
		this.task_submit = task_submit;
	}

	public String getTask_submit_time() {
		return task_submit_time;
	}

	public void setTask_submit_time(String task_submit_time) {
		this.task_submit_time = task_submit_time;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public int getCountA() {
		return countA;
	}

	public void setCountA(int countA) {
		this.countA = countA;
	}

	public int getCountB() {
		return countB;
	}

	public void setCountB(int countB) {
		this.countB = countB;
	}

	public int getCountC() {
		return countC;
	}

	public void setCountC(int countC) {
		this.countC = countC;
	}

	public int getCountD() {
		return countD;
	}

	public void setCountD(int countD) {
		this.countD = countD;
	}

	public int getCountE() {
		return countE;
	}

	public void setCountE(int countE) {
		this.countE = countE;
	}

	public int getCountF() {
		return countF;
	}

	public void setCountF(int countF) {
		this.countF = countF;
	}

	public String getTask_link_format() {
		return task_link_format;
	}
	public String getTask_link_format2() {
		return task_link_format2;
	}
	public String getTask_link_format3() {
		return task_link_format3;
	}
	public String getTask_link_format4() {
		return task_link_format4;
	}
	public String getTask_link_format5() {
		return task_link_format5;
	}

	public void setTask_link_format(String task_link_format) {
		this.task_link_format = task_link_format;
	}
	public void setTask_link_format2(String task_link_format2) {
		this.task_link_format2 = task_link_format2;
	}
	public void setTask_link_format3(String task_link_format3) {
		this.task_link_format3 = task_link_format3;
	}
	public void setTask_link_format4(String task_link_format4) {
		this.task_link_format4 = task_link_format4;
	}
	public void setTask_link_format5(String task_link_format5) {
		this.task_link_format5 = task_link_format5;
	}

	public String getTask_linkType_code() {
		return task_linkType_code;
	}

	public void setTask_linkType_code(String task_linkType_code) {
		this.task_linkType_code = task_linkType_code;
	}

	public String getTask_app_code() {
		return task_app_code;
	}

	public void setTask_app_code(String task_app_code) {
		this.task_app_code = task_app_code;
	}

	public String getTask_app_name() {
		return task_app_name;
	}

	public void setTask_app_name(String task_app_name) {
		this.task_app_name = task_app_name;
	}

	public String getTask_link_status() {
		return task_link_status;
	}

	public void setTask_link_status(String task_link_status) {
		this.task_link_status = task_link_status;
	}

	public String getTask_app_state() {
		return task_app_state;
	}

	public void setTask_app_state(String task_app_state) {
		this.task_app_state = task_app_state;
	}

	public float getTimeAll() {
		return this.timeAll;
	}

	public void setTimeAll(float timeAll) {
		this.timeAll = timeAll;
	}

	public float getTimeAvg() {
		return this.timeAvg;
	}

	public void setTimeAvg(float timeAvg) {
		this.timeAvg = timeAvg;
	}

}
