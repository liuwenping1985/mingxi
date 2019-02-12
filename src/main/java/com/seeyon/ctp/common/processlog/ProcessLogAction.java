package com.seeyon.ctp.common.processlog;

/**
 * 流程日志枚举（用于流程日志）
 * 
 */
public enum ProcessLogAction {
	// 发起协同
	sendColl(1),
	// 发起表单
	sendForm(2),
	// 拟文
	drafting(3),
	// 登记
	register(4),
	// 撤销流程
	cancelColl(5),
	// 终止流程
	stepStop(6),
	// 封发
	seal(7),
	// 加签
	insertPeople(8),
	// 减签
	deletePeople(9),
	// 当前会签
	colAssign(10),
	// 知会
	inform(11),
	// 传阅
	passRound(12),
	// 增加节点
	addNode(13),
	// 删除节点
	deleteNode(14),
	// 替换节点
	replaceNode(15),
	// 节点超期，系统自动替换节点
	replaceNode_SysAuto(28),
	// 节点超期，系统自动跳过此节点
	processColl_SysAuto(29),
	// 回退
	stepBack(16),
	// 取回
	takeBack(17),
	// 暂存待办
	zcdb(18),
	// 处理提交
	commit(19),
	// 协同处理
	processColl(20),
	/** 转办*/
	transfer(58),

	/**
	 * 
	 * 公文处理
	 * 
	 * 转发公告/转发发文/修改正文/正文套红/修改文单/签章/归档
	 */
	processEdoc(21),
	
	//多级会签
	addMoreSign(22),
    //修改附件
	updateAttachment(23),
	
	//增加附件
	addAttachment(24),
	//在线编辑附件
	updateAttachmentOnline(25),
	//删除附件
	deleteAttachment(26),
	//节点属性
	nodeproperties(27),
	//修改节点权限
	changeNodePolicy(30),
	
    //branches_a8_v350_r_gov GOV-1309 魏俊彪 增加信息报送信息新建日志信息 start
    infoCreate(31),//信息报送——信息新建
    infoOption(32),//信息报送——信息处理
    //branches_a8_v350_r_gov GOV-1309 魏俊彪 增加信息报送信息新建日志信息 end
    
    //branches_a8_v350_r_gov GOV-2877. 唐桂林 增加公文退回拟稿人日志信息 start
    stepBackToSender(33),//退回拟稿人
    //branches_a8_v350_r_gov GOV-2877. 唐桂林 增加公文退回拟稿人日志信息 end
    
    //branches_a8_v350_r_gov GOV-549  唐桂林 增加公文分发日志信息 start
    distributer(34),//分发
    //branches_a8_v350_r_gov GOV-549  唐桂林 增加公文分发日志信息 end	
	colStepBackToSender(35),//退回协同发起人
	colStepBackToPoint(36),//退回拟稿人	
	colStepBackToResend(37),//指定会退后发起人重新发起
	processMode(38), //执行模式
	nodeLimitTime(39), //节点期限（包含处理期限和提前提醒）
	deadTerm(40), //处理期限
	remindTime(41), //提前提醒
	colStepBackReMeToReGo(42),//协同提交自动将指定回退提交给我的模式转化为流程重走
	colStepBackReMeToReGo4Send(43),//协同提交自动将指定回退提交给我的模式转化为流程重走
	
	//流程表单触发动作，流程日志记录，对应国际化key 在表单资源文件中 start
	triggerUnflowSuccess(45), //触发数据存档成功
	triggerUnflowFail(46),//触发数据存档失败
	triggerFlowSuccess(47),//触发流程成功
	triggerFlowFail(48),//触发流程失败
	triggerFillbackSuccess(49), //触发回写成功
	triggerFillbackFail(50),//触发回写失败
	//流程表单触发动作，流程日志记录 end
	triggerMeetingSuccess(51),
	triggerTaskSuccess(52),//流程触发任务成功
	triggerTaskFail(53),//流程触发任务失败
	triggerMeetingFailed(54),
	turnRec(56),// 转收文
	autoskip(57),//重複跳过
	createMemberSuccess(60),//触发创建人员成功
	createMemberFail(61),//触发创建人员失败
	updateMemberSuccess(62),//触发更新人员成功
	updateMemberFail(63);//触发更新人员失败
	/**
	 * 公文处理子操作。
	 * 
	 * 
	 */
	public enum ProcessEdocAction {
		// 转发公告
		forwardBulletin(1),
		// 转发发文
		fowardIssuing(2),
		// 修改正文
		modifyBody(3),
		// 正文套红
		Body(4),
		// 修改文单
		modifyForm(5),
		// 签章
		signed(6),
		// 归档
		pigeonhole(7),
		//文单套红
		bodyFromRed(8),		
		//部门归档
		depHigeonhole(9),
		//公文督办
		duban(10),
		//文单签批
		wendanqianp(11),
		//修改文号
		modifyWordNo(12),
		//退回发起人
		stepBackToStart(13),
		
		stepBackReMeToReGo(42);//公文提交自动将指定回退提交给我的模式转化为流程重走
		private int key;

		ProcessEdocAction(int key) {
			this.key = key;
		}

		public int getKey() {
			return this.key;
		}

		public int key() {
			return this.key;
		}

		public static ProcessEdocAction valueOf(int key) {
			ProcessEdocAction[] enums = ProcessEdocAction.values();
			if (enums != null) {
				for (ProcessEdocAction enum1 : enums) {
					if (enum1.key() == key) {
						return enum1;
					}
				}
			}
			return null;
		}
	}

	// 标识 用于数据库存储
	private int key;

	ProcessLogAction(int key) {
		this.key = key;
	}

	public int getKey() {
		return this.key;
	}

	public int key() {
		return this.key;
	}

	/**
	 * 根据key得到枚举类型
	 * 
	 * @param key
	 * @return
	 */
	public static ProcessLogAction valueOf(int key) {
		ProcessLogAction[] enums = ProcessLogAction.values();
		if (enums != null) {
			for (ProcessLogAction enum1 : enums) {
				if (enum1.key() == key) {
					return enum1;
				}
			}
		}
		return null;
	}

}
