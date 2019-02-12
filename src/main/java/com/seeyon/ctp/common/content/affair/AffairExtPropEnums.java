package com.seeyon.ctp.common.content.affair;

public enum AffairExtPropEnums {
	/**
	 * 以名字为准，数据库记录的就是这个名字，不能轻易修改
	 */
	meeting_emcee,//会议主持人
	meeting_place,//会议地点
	meeting_record_state,//会议纪要标识
	meeting_emcee_id, //主持人id
	meeting_videoConf,//会议方式(0曾通会议 1视频会议)
	edoc_edocMark,//公文文号
	edoc_sendUnit,//公文发文单位
	edoc_sendAccountId, // 发文单位ID
	edoc_lastOperateState,//公文当前Affair最后的操作是不是取回
	edoc_edocExSendRetreat,//发文分发退件标识
	edoc_edocRecieveRetreat ,//收文签收退件标识
	edoc_edocRegisterRetreat,//收文登记退件标识
	processing_progress,//处理进展 (已处理人数/总人数(会议、调查字段))
	spaceType,
	spaceId,
	typeId,
	processPeriod,//流程期限
	info_magazineAuditState, //期刊审核状态：不发布
	//***********开发：苗永锋*****************需求：公文盖章封发后转pdf格式交换 **************开始*****Begin***************//
	exchange_pdf_body//交换PDF正文
	//***********开发：苗永锋*****************需求：公文盖章封发后转pdf格式交换 ***************结束*****End****************//

}
