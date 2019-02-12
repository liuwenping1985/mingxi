package com.seeyon.apps.kdXdtzXc.util;

import com.seeyon.apps.kdXdtzXc.base.util.StringUtilsExt;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by tap-pcng43 on 2017-6-30.
 */
public class NotifyMessageUtil {

    static Map<String, String> mlc = new HashMap();
    static Map<String, String> messageLinkConstants = new HashMap();

    static {
        messageLinkConstants.put(ApplicationCategoryEnum.global.key() + "", "全局");
        messageLinkConstants.put(ApplicationCategoryEnum.collaboration.key() + "", "协同应用");
        messageLinkConstants.put(ApplicationCategoryEnum.form.key() + "", "表单");
        messageLinkConstants.put(ApplicationCategoryEnum.doc.key() + "", "知识管理");
        messageLinkConstants.put(ApplicationCategoryEnum.edoc.key() + "", "公文");
        messageLinkConstants.put(ApplicationCategoryEnum.plan.key() + "", "计划");
        messageLinkConstants.put(ApplicationCategoryEnum.meeting.key() + "", "会议");
        messageLinkConstants.put(ApplicationCategoryEnum.bulletin.key() + "", "公告");
        messageLinkConstants.put(ApplicationCategoryEnum.news.key() + "", "新闻");
        messageLinkConstants.put(ApplicationCategoryEnum.bbs.key() + "", "讨论");
        messageLinkConstants.put(ApplicationCategoryEnum.inquiry.key() + "", "调查");
        messageLinkConstants.put(ApplicationCategoryEnum.calendar.key() + "", "日程事件");
        messageLinkConstants.put(ApplicationCategoryEnum.mail.key() + "", "邮件");
        messageLinkConstants.put(ApplicationCategoryEnum.organization.key() + "", "组织模型");
        messageLinkConstants.put(ApplicationCategoryEnum.project.key() + "", "项目");
        messageLinkConstants.put(ApplicationCategoryEnum.relateMember.key() + "", "关联人员");
        messageLinkConstants.put(ApplicationCategoryEnum.exchange.key() + "", "交换");
        messageLinkConstants.put(ApplicationCategoryEnum.hr.key() + "", "人力资源");
        messageLinkConstants.put(ApplicationCategoryEnum.blog.key() + "", "博客");
        messageLinkConstants.put(ApplicationCategoryEnum.edocSend.key() + "", "发文");
        messageLinkConstants.put(ApplicationCategoryEnum.edocRec.key() + "", "收文");
        messageLinkConstants.put(ApplicationCategoryEnum.edocSign.key() + "", "签报");
        messageLinkConstants.put(ApplicationCategoryEnum.exSend.key() + "", "待发送公文");
        messageLinkConstants.put(ApplicationCategoryEnum.exSign.key() + "", "待签收公文");
        messageLinkConstants.put(ApplicationCategoryEnum.edocRegister.key() + "", "待登记公文");
        messageLinkConstants.put(ApplicationCategoryEnum.communication.key() + "", "在线交流");
        messageLinkConstants.put(ApplicationCategoryEnum.office.key() + "", "综合办公");
        messageLinkConstants.put(ApplicationCategoryEnum.agent.key() + "", "代理设置");
        messageLinkConstants.put(ApplicationCategoryEnum.modifyPassword.key() + "", "密码修改");
        messageLinkConstants.put(ApplicationCategoryEnum.meetingroom.key() + "", "会议室");
        messageLinkConstants.put(ApplicationCategoryEnum.taskManage.key() + "", "任务管理");
        messageLinkConstants.put(ApplicationCategoryEnum.guestbook.key() + "", "留言板");
        messageLinkConstants.put(ApplicationCategoryEnum.info.key() + "", "信息报送");
        messageLinkConstants.put(ApplicationCategoryEnum.infoStat.key() + "", "信息报送统计");
        messageLinkConstants.put(ApplicationCategoryEnum.edocRecDistribute.key() + "", "收文分发");
        messageLinkConstants.put(ApplicationCategoryEnum.notice.key() + "", "公示板");
        messageLinkConstants.put(ApplicationCategoryEnum.attendance.key() + "", "签到");
        messageLinkConstants.put(ApplicationCategoryEnum.mobileAppMgrForHTML5.key() + "", "移动应用接入");
        messageLinkConstants.put(ApplicationCategoryEnum.sapPlugin.key() + "", "sap插件");
        messageLinkConstants.put(ApplicationCategoryEnum.ThirdPartyIntegration.key() + "", "第三方整合");
        messageLinkConstants.put(ApplicationCategoryEnum.show.key() + "", "大秀");
        messageLinkConstants.put(ApplicationCategoryEnum.wfanalysis.key() + "", "流程绩效");
        messageLinkConstants.put(ApplicationCategoryEnum.behavioranalysis.key() + "", "行为绩效");
        messageLinkConstants.put(ApplicationCategoryEnum.biz.key() + "", "业务生成器");
        messageLinkConstants.put(ApplicationCategoryEnum.commons.key() + "", "公共资源");
        messageLinkConstants.put(ApplicationCategoryEnum.workflow.key() + "", "工作流");
        messageLinkConstants.put(ApplicationCategoryEnum.unflowform.key() + "", "无流程表单");
        messageLinkConstants.put(ApplicationCategoryEnum.formqueyreport.key() + "", "表单查询统计");
        messageLinkConstants.put(ApplicationCategoryEnum.cmp.key() + "", "cmp");
        messageLinkConstants.put(ApplicationCategoryEnum.dee.key() + "", "dee模块");
        messageLinkConstants.put(ApplicationCategoryEnum.application.key() + "", "应用");
        messageLinkConstants.put(ApplicationCategoryEnum.m3commons.key() + "", "公共资源");
        messageLinkConstants.put(ApplicationCategoryEnum.login.key() + "", "登陆");
        messageLinkConstants.put(ApplicationCategoryEnum.message.key() + "", "消息");
        messageLinkConstants.put(ApplicationCategoryEnum.my.key() + "", "我的");
        messageLinkConstants.put(ApplicationCategoryEnum.search.key() + "", "搜索");
        messageLinkConstants.put(ApplicationCategoryEnum.todo.key() + "", "待办");


    }

    public static String getMessageLinkType(String MESSAGE_CATEGORY) {
        String s = messageLinkConstants.get(MESSAGE_CATEGORY);
        if (!StringUtilsExt.isNullOrNone(s)) {
            return s;
        }
        return "其他";
    }


    static {
        mlc.put("message.link.cal", "/seeyon/calendar/calEvent.do?method=editCalEvent&id={0}&random={1}");
        mlc.put("message.link.edoc.done", "/seeyon/edocController.do?method=detailIFrame&from=Done&affairId={0}");
        mlc.put("message.link.project.leaveWord", "/seeyon/guestbook.do?method=moreLeaveWordModel&project={1}&departmentId={0}&fromModel=top");
        mlc.put("message.link.department.leaveWord", "/seeyon/guestbook.do?method=moreLeaveWordModel&project={1}&departmentId={0}&fromModel=top");
        mlc.put("message.link.info.docview", "/seeyon/info/infoDetail.do?method=summary&openFrom=doc&affairId={0}&summaryId={1}");
        mlc.put("message.link.hr.salary.open", "/seeyon/hrViewSalary.do?method=viewSalary&fromMessage=true");
        mlc.put("message.link.col.supervise", "/seeyon/collaboration/collaboration.do?method=summary&openFrom=supervise&summaryId={0}");
        mlc.put("message.link.office.autoN.repairView", "/seeyon/office/autoMgr.do?method=autoRepairEdit&id={0}");
        mlc.put("message.link.office.stockN.audit", "/seeyon/office/stockUse.do?method=stockAuditEdit&affairId={0}&v={0}");
        mlc.put("message.link.news.assessor.audit", "/seeyon/newsData.do?method=userView&id={0}&t={1}&auditFlag=0&from=message");
        mlc.put("message.link.edoc.sended", "/seeyon/edocController.do?method=detailIFrame&from=sended&affairId={0}");
        mlc.put("message.link.mt.summary_send", "/seeyon/mtMeeting.do?method=showSummary&id={0}");
        mlc.put("message.link.plan.summary", "/seeyon/plan/plan.do?method=initPlanDetailFrame&planId={0}");
        mlc.put("message.link.edoc.pending", "/seeyon/edocController.do?method=detailIFrame&from=Pending&affairId={0}");
        mlc.put("message.link.info.magazine.publishPending", "/seeyon/info/magazine.do?method=summaryPublish&openFrom=Pending&affairId={0}&magazineId={1}");
        mlc.put("message.link.doc.open.learning", "/seeyon/doc.do?method=docOpenIframeOnlyId&docResId={0}&openFrom=docLearning");
        mlc.put("message.link.info.stat.view", "/seeyon/info/infoStat.do?method=showInfoStatView&statId={0}");
        mlc.put("message.link.plan.send", "/seeyon/plan/plan.do?method=initPlanDetailFrame&planId={0}");
        mlc.put("message.link.doc.folder.open", "/seeyon/doc.do?method=docHomepageIndex&docResId={0}");
        mlc.put("message.link.info.pending", "/seeyon/info/infoDetail.do?method=summary&openFrom=Pending&affairId={0}&summaryId={1}&contentAnchor={2}");
        mlc.put("message.link.doc.open.borrowHandle", "doc/knowledgeController.do?method=borrowHandle");
        mlc.put("message.link.info.magazine.auditPending", "/seeyon/info/magazine.do?method=summary&openFrom=Pending&affairId={0}&magazineId={1}");
        mlc.put("message.link.exchange.sent", "/seeyon/exchangeEdoc.do?method=edit&modelType=sent&id={0}&affairId={1}");
        mlc.put("message.link.office.stockN.view", "/seeyon/office/stockUse.do?method=stockApplyIframe&applyId={0}&operate={1}&v={0}");
        mlc.put("message.link.bul.alreadyauditing", "/seeyon/bulData.do?method=userView&id={0}&auditFlag=0&from=message");
        mlc.put("message.link.mt.send", "/seeyon/mtMeeting.do?method=myDetailFrame&id={0}&proxy={1}&proxyId={2}&state=10");
        mlc.put("message.link.bulletin.open", "/seeyon/bulData.do?method=userView&id={0}&auditFlag=0&from=message");
        mlc.put("message.link.exchange.register.pending", "/seeyon/edocController.do?method=entryManager&entry=recManager&listType=newEdoc&comm=register&edocType={0}&recieveId={1}&edocId={2}");
        mlc.put("message.link.exchange.send", "/seeyon/exchangeEdoc.do?method=sendDetail&modelType=toSend&id={0}&affairId={1}");
        mlc.put("message.link.office.assetN.audit", "/seeyon/office/assetUse.do?method=assetAuditEdit&operate=audit&affairId={0}&v={0}");
        mlc.put("message.link.plan.reply", "/seeyon/plan/plan.do?method=initPlanDetailFrame&planId={0}");
        mlc.put("message.link.office.autoN.safetyView", "/seeyon/office/autoMgr.do?method=autoSafetyEdit&id={0}");
        mlc.put("message.link.bul.auditing", "/seeyon/bulData.do?method=audit&id={0}&from=message");
        mlc.put("message.link.inquiry.send", "/seeyon/inquirybasic.do?method=showInquiryFrame&bid={0}&surveytypeid={1}&message=message");
        mlc.put("message.link.news.assessor.auditing", "/seeyon/newsData.do?method=userView&id={0}&auditFlag=0&from=message");
        mlc.put("message.link.uc.fax.message", "/seeyon/ext/fax/fax/faxDetail.jsp?id={0}");
        mlc.put("message.link.info.magazine.send", "/seeyon/info/magazine.do?method=summary&openFrom=Send&affairId={0}&magazineId={1}");
        mlc.put("message.link.cal.view", "/seeyon/calendar/calEvent.do?method=editCalEvent&id={0}&random={1}");
        mlc.put("message.link.formtrigger.msg.flow", "/seeyon/collaboration/collaboration.do?method=summary&openFrom=listDone&summaryId={0}");
        mlc.put("message.link.info.done", "/seeyon/info/infoDetail.do?method=summary&openFrom=Done&affairId={0}&summaryId={1}&contentAnchor={2}");
        mlc.put("message.link.office.meetingroom", "/seeyon/meetingroom.do?method=createPerm&openWin=1&id={0}");
        mlc.put("message.link.info.magazine.view", "/seeyon/info/magazine.do?method=summary&openFrom=viewPage&magazineId={0}");
        mlc.put("message.link.mt.mtCreater", "/seeyon/mtMeeting.do?method=myDetailFrame&id={0}&proxy={1}&proxyId={2}&state=10");
        mlc.put("message.link.inq.auditing", "/seeyon/inquirybasic.do?method=survey_check&bid={0}&from=message");
        mlc.put("message.link.office.autoN.view", "/seeyon/office/autoUse.do?method=autoApplyIframe&applyId={0}&isEdit={1}&isRecedeEdit={2}&state={3}&v={0}");
        mlc.put("message.link.taskmanage.viewfeedback", "/seeyon/taskmanage/taskinfo.do?method=taskDetailIndex&id={0}&msgLocation=Feedback&feedBackId={1}");
        mlc.put("message.link.col.pending", "/seeyon/collaboration/collaboration.do?method=summary&openFrom=listPending&affairId={0}&contentAnchor={1}");
        mlc.put("message.link.formtrigger.msg.unflow", "/seeyon/content/content.do?method=index&isFullPage=true&moduleId={0}&moduleType={1}&rightId={2}&contentType=20&viewState=2");
        mlc.put("message.link.news.writedetail", "/seeyon/newsData.do?method=writeDetail&id={0}&from=message");
        mlc.put("message.link.news.auditing", "/seeyon/newsData.do?method=audit&id={0}&from=message");
        mlc.put("message.link.info.send", "/seeyon/info/infoDetail.do?method=summary&openFrom=Send&affairId={0}&summaryId={1}&contentAnchor={2}");
        mlc.put("message.link.bul.alreadyaudit", "/seeyon/bulData.do?method=userView&id={0}&t={1}&auditFlag=0&from=message");
        mlc.put("message.link.bul.writedetail", "/seeyon/bulData.do?method=writeDetail&id={0}&from=message");
        mlc.put("message.link.edoc.docview", "/seeyon/edocController.do?method=detailIFrame&from=doc&summaryId={0}");
        mlc.put("message.link.doc.open.recommend", "doc/knowledgeController.do?method=getDocRecommend");
        mlc.put("message.link.sap.synchLog", "/seeyon/sap.do?method=synchLog");
        mlc.put("message.link.news.open", "/seeyon/newsData.do?method=userView&id={0}&auditFlag=0&from=message");
        mlc.put("message.link.office.asset", "/seeyon/asset.do?method=create_perm&from=message&fs=1&id={0}");
        mlc.put("message.link.space.leaveWord", "/seeyon/guestbook.do?method=moreLeaveWordModel&project={1}&departmentId={0}&fromModel=top&custom=true");
        mlc.put("message.link.col.done.detail", "/seeyon/collaboration/collaboration.do?method=summary&openFrom=listDone&affairId={0}&contentAnchor={1}");
        mlc.put("message.link.exchange.register.receive", "/seeyon/exchangeEdoc.do?method=edit&id={0}&modelType=received");
        mlc.put("message.link.doc.open.index", "/seeyon/doc.do?method=docOpenIframeOnlyId&docResId={0}&openFrom=glwd");
        mlc.put("message.link.office.stock", "/seeyon/stockAudit.do?method=edit&from=message&applyId={0}");
        mlc.put("message.link.doc.openfromborrow", "/seeyon/doc.do?method=docOpenIframeOnlyId&docResId={0}&fromFlag=BorrowMsg&isBorrowOrShare=true");
        mlc.put("message.link.doc.open.only", "/seeyon/doc.do?method=docOpenIframeOnlyId&docResId={0}");
        mlc.put("message.link.taskmanage.view", "/seeyon/taskmanage/taskinfo.do?method=taskDetailIndex&id={0}");
        mlc.put("message.link.edoc.supervise.detail", "/seeyon/edocSupervise.do?method=detail&summaryId={0}&isOpenFrom=supervise");
        mlc.put("message.link.office.bookN.audit", "/seeyon/office/bookUse.do?method=bookAuditDetail&bookApplyId={0}&v={0}");
        mlc.put("message.link.bbs_reply", "/seeyon/bbs.do?method=showPost&articleId={0}&boardId={1}&resourceMethod={2}&from=message");
        mlc.put("message.link.office.autoN.inspectionView", "/seeyon/office/autoMgr.do?method=autoInspectionEdit&id={0}");
        mlc.put("message.link.info.draft", "/seeyon/info/infoDetail.do?method=summary&openFrom=Draft&affairId={0}&summaryId={1}&contentAnchor={2}");
        mlc.put("message.link.office.autoN.illegalView", "/seeyon/office/autoMgr.do?method=autoIllegalEdit&id={0}");
        mlc.put("message.link.bbs.auditing", "/seeyon/bbs.do?method=showPost&articleId={0}&boardId={1}&from=message");
        mlc.put("message.link.office.auto", "/seeyon/autoAudit.do?method=edit&from=message&applyId={0}");
        mlc.put("message.link.office.assetN.view", "/seeyon/office/assetUse.do?method=assetApplyIframe&applyId={0}&operate={1}&v={0}");
        mlc.put("message.link.col.waiSend", "/seeyon/collaboration/collaboration.do?method=summary&openFrom=listWaitSend&affairId={0}&contentAnchor={1}");
        mlc.put("message.link.exchange.registered", "/seeyon/edocController.do?method=edocRegister&registerId={0}");
        mlc.put("message.link.project.info", "/seeyon/project.do?method=projectInfo&projectId={0}");
        mlc.put("message.link.NC.message", "javascript:getA8Top().openHistoryNCMessage('{0}','{1}', '{2}', '{3}')");
        mlc.put("message.link.col.done.newflow", "/seeyon/collaboration/collaboration.do?method=summary&openFrom=listDone&affairId={0}&contentAnchor={1}&newflowBaseSummaryId={2}&processId={3}&relativeProcessId={4}");
        mlc.put("message.link.office.autoN.audit", "/seeyon/office/autoUse.do?method=autoAuditEdit&affairId={0}&v={0}");
        mlc.put("message.link.inq.alreadyauditing", "/seeyon/inquirybasic.do?method=showInquiryFrame&bid={0}&alauditFlag=0&from=message");
        mlc.put("message.link.relateMember.set.leader", "/seeyon/relateMember.do?method=setRelateMember&memberId={0}&relatedId={1}&oper={2}");
        mlc.put("message.link.mt.reply", "/seeyon/mtMeeting.do?method=myDetailFrame&id={0}&state=10&contentAnchor={1}");
        mlc.put("message.link.edoc.report", "/seeyon/edocController.do?method=detailIFrame&from=Done&affairId={0}");
        mlc.put("message.link.mt.invite", "/seeyon/mtMeeting.do?method=myDetailFrame&id={0}&proxy={1}&proxyId={2}&state=10");
        mlc.put("message.link.exchange.distribute", "/seeyon/edocController.do?method=entryManager&entry=recManager&toFrom=newEdoc&edocType={0}&registerId={1}&app={2}&comm=distribute&recListType=listDistribute");
        mlc.put("message.link.mt.summary", "/seeyon/mtSummary.do?method=myDetailFrame&mId={0}&recordId={1}&proxy={2}&proxyId={3}");
        mlc.put("message.link.hr.salary.admin", "/seeyon/hrSalary.do?method=home&_resourceCode=F03_hrSalary");
        mlc.put("message.link.edoc.supervise.main", "/seeyon/edocSupervise.do?method=mainEntry");
        mlc.put("message.link.exchange.register.govpending", "/seeyon/edocController.do?method=entryManager&entry=recManager&toFrom=newEdocRegister&comm=create&edocType=1&registerType=1&recieveId={0}&edocId={1}&sendUnitId={2}&listType=registerPending&recListType=registerPending");
        mlc.put("message.link.taskmanage.viewfromreply", "/seeyon/taskmanage/taskinfo.do?method=taskDetailIndex&id={0}");
        mlc.put("message.link.mt.room_perm", "/seeyon/meetingroom.do?method=createPerm&id={0}&proxy={1}&proxyId={2}&openWin=1&periodicityInfoId={3}");
        mlc.put("message.link.news.alreadyauditing", "/seeyon/newsData.do?method=audit&id={0}&from=message");
        mlc.put("message.link.office.bookN.lended", "/seeyon/office/bookUse.do?method=myBookLendDetail&bookApplyId={0}&v={0}");
        mlc.put("message.link.edoc.waitSend", "/seeyon/edocController.do?method=detailIFrame&from=listWaitSend&affairId={0}");
        mlc.put("message.link.webservice.message", "javascript:getA8Top().v3x.openWindow({url : '{0}',workSpace: 'yes'})");
        mlc.put("message.link.office.book", "/seeyon/book.do?method=create_perm&from=message&show=1&id={0}");
        mlc.put("message.link.exchange.receive", "/seeyon/exchangeEdoc.do?method=receiveDetail&modelType=toReceive&id={0}");
        mlc.put("message.link.bbs.open", "/seeyon/bbs.do?method=showPost&articleId={0}&resourceMethod={1}&from=message");
        mlc.put("message.link.formbizconfig.view", "/seeyon/form/formSection.do?method=show&type=view&id={0}&from=Message");
    }
}
