//package com.seeyon.ctp.ext.extform;
//
//import com.alibaba.fastjson.JSON;
//import com.seeyon.apps.collaboration.bo.DateSharedWithWorkflowEngineThreadLocal;
//import com.seeyon.apps.collaboration.controller.CollaborationController;
//import com.seeyon.apps.collaboration.enums.ColHandleType;
//import com.seeyon.apps.collaboration.enums.CollaborationEnum;
//import com.seeyon.apps.collaboration.event.CollaborationAddCommentEvent;
//import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
//import com.seeyon.apps.collaboration.listener.WorkFlowEventListener;
//import com.seeyon.apps.collaboration.manager.ColManager;
//import com.seeyon.apps.collaboration.manager.ColManagerImpl;
//import com.seeyon.apps.collaboration.manager.ColMessageManager;
//import com.seeyon.apps.collaboration.po.ColSummary;
//import com.seeyon.apps.collaboration.util.ColSelfUtil;
//import com.seeyon.apps.collaboration.util.ColUtil;
//import com.seeyon.apps.index.manager.IndexManager;
//import com.seeyon.client.CTPRestClient;
//import com.seeyon.ctp.common.AppContext;
//import com.seeyon.ctp.common.ModuleType;
//import com.seeyon.ctp.common.authenticate.domain.User;
//import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
//import com.seeyon.ctp.common.content.ContentUtil;
//import com.seeyon.ctp.common.content.affair.*;
//import com.seeyon.ctp.common.content.affair.constants.StateEnum;
//import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
//import com.seeyon.ctp.common.content.comment.Comment;
//import com.seeyon.ctp.common.content.comment.CommentManager;
//import com.seeyon.ctp.common.content.comment.CommentManagerImpl;
//import com.seeyon.ctp.common.content.mainbody.MainbodyType;
//import com.seeyon.ctp.common.controller.BaseController;
//import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
//import com.seeyon.ctp.common.exceptions.BusinessException;
//import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
//import com.seeyon.ctp.common.permission.manager.PermissionManager;
//import com.seeyon.ctp.common.po.affair.CtpAffair;
//import com.seeyon.ctp.common.po.comment.CtpCommentAll;
//import com.seeyon.ctp.common.po.processlog.ProcessLogDetail;
//import com.seeyon.ctp.common.processlog.ProcessLogAction;
//import com.seeyon.ctp.common.processlog.manager.ProcessLogManager;
//import com.seeyon.ctp.event.EventDispatcher;
//import com.seeyon.ctp.event.EventTriggerMode;
//import com.seeyon.ctp.ext.extform.util.UIUtils;
//import com.seeyon.ctp.ext.extform.vo.Formson1569;
//import com.seeyon.ctp.form.service.FormManager;
//import com.seeyon.ctp.organization.bo.V3xOrgMember;
//import com.seeyon.ctp.organization.manager.MemberManager;
//import com.seeyon.ctp.organization.manager.OrgManager;
//import com.seeyon.ctp.organization.principal.NoSuchPrincipalException;
//import com.seeyon.ctp.organization.principal.PrincipalManager;
//import com.seeyon.ctp.util.*;
//import com.seeyon.ctp.util.annotation.ListenEvent;
//import com.seeyon.ctp.workflow.util.WorkflowUtil;
//import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;
//import com.seeyon.ctp.workflow.wapi.WorkflowApiManagerImpl;
//import com.seeyon.v3x.worktimeset.manager.WorkTimeManager;
//import net.joinwork.bpm.engine.wapi.WorkflowBpmContext;
//import org.apache.axis.utils.StringUtils;
//import org.apache.commons.lang3.math.NumberUtils;
//import org.apache.commons.logging.Log;
//import org.apache.commons.logging.LogFactory;
//import org.springframework.util.CollectionUtils;
//import org.springframework.web.servlet.ModelAndView;
//import org.springframework.web.servlet.view.InternalResourceView;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.text.SimpleDateFormat;
//import java.util.*;
//
//public class ExtFormInfoController extends BaseController {
//    private static Log log = LogFactory.getLog(WorkFlowEventListener.class);
//    private  PrincipalManager  principalManager;
//
//    public PrincipalManager getPrincipalManager() {
//        return principalManager;
//    }
//    private CTPRestClient client ;
//
//    public void setPrincipalManager(PrincipalManager principalManager) {
//        this.principalManager = principalManager;
//    }
//    public ModelAndView checkFormIsOk2(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        //formmain 1397
//        return new ModelAndView(new InternalResourceView("/WEB-INF/jsp/ext/formcomponent/extform.jsp"));
//    }
//    public ModelAndView checkFormIsOk(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        //formmain 1397
//
//        String affairId = request.getParameter("affairId");
//        /**
//         * test :7255984374117713477
//         * product:4369223031188048854
//         */
//        String templateId = request.getParameter("tplId");
//        Map<String,Object> data = new HashMap<String,Object>();
//        if(StringUtils.isEmpty(affairId)){
//            data.put("result",false);
//            data.put("reason","AFFAIR_ID_NOT_FOUND");
//            UIUtils.responseJSON(data,response);
//            return null;
//        }
//        if(StringUtils.isEmpty(templateId)){
//            data.put("result",false);
//            data.put("reason","TEMPLATE_NOT_FOUND");
//            UIUtils.responseJSON(data,response);
//            return null;
//        }
//        List<CtpAffair> affairList = new ArrayList<CtpAffair>(0);
//        try {
//            affairList = DBAgent.find("from CtpAffair where id=" + affairId);
//            if (CollectionUtils.isEmpty(affairList)) {
//                data.put("result", false);
//                data.put("reason", "AFFAIR_NOT_FOUND");
//                UIUtils.responseJSON(data,response);
//                return null;
//            }
//        }catch(Exception e){
//            e.printStackTrace();
//            data.put("result", false);
//            data.put("reason", "AFFAIR_NOT_FOUND");
//            UIUtils.responseJSON(data,response);
//        }
//        CtpAffair affair = affairList.get(0);
//        Long tplId = affair.getTempleteId();
//        if(tplId==null){
//            data.put("result",false);
//            data.put("reason","AFFAIR_INNER_TPL_ID_NOT_FOUND");
//            UIUtils.responseJSON(data,response);
//            return null;
//        }
//        if(String.valueOf(tplId).equals(templateId)){
//            data.put("result",true);
//            UIUtils.responseJSON(data,response);
//        }else{
//            data.put("result",false);
//            data.put("reason","NOT_MATCH");
//            UIUtils.responseJSON(data,response);
//        }
//        return null;
//    }
//
//    public ModelAndView openPersonAffairLink(HttpServletRequest request, HttpServletResponse response) throws NoSuchPrincipalException {
//
//        /**
//         * test :8703799250809407701
//         * product:-4679650058905172061,-3220873770960730919,-640281432140132614
//         */
//        String linkTplId = request.getParameter("linkTplIds");
//
//        String oaLoginName = request.getParameter("oaLoginName");
//
//        Map<String,Object> data = new HashMap<String,Object>();
//
//        if(StringUtils.isEmpty(linkTplId)){
//            data.put("result", false);
//            data.put("reason","OUT_TEMPLATE_NOT_FOUND");
//            UIUtils.responseJSON(data,response);
//            return null;
//        }
//
//        if(StringUtils.isEmpty(oaLoginName)){
//            data.put("result",false);
//            data.put("reason","LOGIN_NAME_NOT_FOUND");
//            UIUtils.responseJSON(data,response);
//            return null;
//        }
//       // Long outLinkTplId = Long.parseLong(linkTplId);
//        linkTplId="("+linkTplId+")";
//        Long memberId = principalManager.getMemberIdByLoginName(oaLoginName);
//        List<CtpAffair> afList =  DBAgent.find("from CtpAffair where templeteId in "+linkTplId+" and senderId="+memberId+"and state=3");
//        if(!CollectionUtils.isEmpty(afList)){
//            if(afList.size()>0){
//                CtpAffair affair = afList.get(0);
//                data.put("affair", JSON.toJSONString(affair));
//                data.put("affairId", String.valueOf(affair.getId()));
//                data.put("templateId", String.valueOf(affair.getTempleteId()));
//                if(afList.size()>1) {
//                    data.put("warning", "AFFAIR_MULTI_FOUND");
//                }
//            }
//            data.put("result",true);
//            UIUtils.responseJSON(data,response);
//        }else{
//            data.put("result",false);
//            data.put("reason","AFFAIR_NOT_FOUND");
//            UIUtils.responseJSON(data,response);
//            return null;
//        }
//
//
//        UIUtils.responseJSON(data,response);
//        return null;
//
//    }
//    private static final Long TARGET_TEMPLATE_ID = 4369223031188048854L;
//    private static final String TARGET_SUBMIT_TEMPLATE_ID = "(-4679650058905172061,-3220873770960730919,-640281432140132614)";
//
//    @ListenEvent(event= CollaborationFinishEvent.class,mode=EventTriggerMode.immediately,async = true)//协同发起成功提交事务后执行，异步模式。
//    public void onCollaborationEnd(CollaborationFinishEvent event) throws Exception {
//       // 7255984374117713477 event.getAffairId(); w
//        Long affairId = event.getAffairId();
//        if(affairId  == null){
//            log.error("----affairId:"+affairId);
//            return;
//        }
//        List<CtpAffair> list = DBAgent.find("from CtpAffair where id="+affairId);
//        if(CollectionUtils.isEmpty(list)){
//            log.error("----list is empty----");
//            return;
//        }
//        //User user = AppContext.getCurrentUser();
//        //System.out.println("user:"+user==null?"null":JSON.toJSONString(user));
//        CtpAffair affair = list.get(0);
//
//       // Long memberId = affair.getMemberId();
//        log.error("--getTempleteId--:"+affair.getTempleteId());
//        if((""+TARGET_TEMPLATE_ID).equals(""+affair.getTempleteId())){
//            //找到该单子的那几个被考核人
//
//            Long recordId = affair.getFormRecordid();
//            StringBuilder memberIdstr = new StringBuilder();
//            String sql2 = "from Formson1569 where formmainId="+recordId;
//            List<Formson1569> formson1569s = new ArrayList<Formson1569>();
//            try {
//                formson1569s = DBAgent.find(sql2);
//            }catch(Exception e){
//                e.printStackTrace();
//            }
//
//            if(CollectionUtils.isEmpty(formson1569s)){
//                log.error("out found formson1569s");
//                return;
//            }
//            log.error(" formson1569s size:"+formson1569s.size());
//            List<Long>mIds = new ArrayList<Long>();
//            for(Formson1569 son:formson1569s){
//                try {
//                    Long memberId = principalManager.getMemberIdByLoginName(son.getField0011());
//                    mIds.add(memberId);
//                }catch(Exception e){
//                    e.printStackTrace();
//                }
//            }
//            int tag =0;
//            for(Long id:mIds){
//                if(tag==0){
//                    memberIdstr.append("(").append(id);
//                }else{
//                    memberIdstr.append(",").append(id);
//                }
//                tag++;
//            }
//            memberIdstr.append(")");
//
//            String sql = "from CtpAffair where templeteId in "+TARGET_SUBMIT_TEMPLATE_ID+" and senderId in"+memberIdstr+"and state=3";
//            log.error("sql:"+sql);
//            List<CtpAffair> affairList = DBAgent.find(sql);
//            log.error("affairList---size:"+JSON.toJSONString(affairList));
//            if(CollectionUtils.isEmpty(affairList)){
//                return;
//            }
//           ColManager colManager = (ColManager)AppContext.getBean("colManager");
//            log.error("----is out----:"+affair.getTempleteId());
//            // af.setState(4);
//            //  DBAgent.update(af);
//            /**
//             *
//             trackParam:{"zdgzry":"","trackRange_members_textbox":""}
//             templateColSubject:
//              templateWorkflowId:-3052006732260228892
//              colSummaryDomian:{"bodyType":"20","attModifyFlag":"0","subject":"01-02--考核汇总
//              表(oa1?2018-06-11?11:02)","isDeleteSupervisior":"false","templateColSubject":"",
//              "modifyFlag":"0","templateWorkflowId":"-3052006732260228892","flowPermAccountId"
//              :"670869647114347","cancelOpinionPolicy":"0","processId":"-2963048075200017466",
//              "isLoadNewFile":"0","canDeleteORarchive":"","summaryId":"7809141347969251159","c
//              ontentstr":"","disAgreeOpinionPolicy":"0","createDate":"2018-06-11 11:03:19"}
//             flowPermAccountId:670869647114347
//              params:{trackParam={"zdgzry":"","trackRange_members_textbox":""}, templateColSub
//              ject=, templateWorkflowId=-3052006732260228892}
//
//             */
//            for(CtpAffair af:affairList){
//                try {
//                     ColSummary colSummary =  colManager.getSummaryById(af.getObjectId());
//                     Map params = genParam(af.getTempleteId());
//                    // colManager.transFinishWorkItem(colSummary,af,params);
//                  //  Comment comment = new Comment();
//                    transSubmit(affair,af,colSummary,ColHandleType.finish,params);
//                   // colManager.transFinishWorkItemPublic(affair, colSummary, comment, ColHandleType.finish, params);
//
//                }catch(Exception e){
//                    log.error("error----"+af.getSubject(),e);
//                    e.printStackTrace();
//                }catch(Error error){
//                    error.printStackTrace();
//                }
//            }
//        }
//
//    }
//private SimpleDateFormat format = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss");
//    private Map<String, String> genColSummary(ColSummary colSummary){
//        /**
//         {"bodyType":"20","attModifyFlag":"0","subject":"01-02--考核汇总
//         表(oa1?2018-06-11?11:02)","isDeleteSupervisior":"false","templateColSubject":"",
//         "modifyFlag":"0","templateWorkflowId":"-3052006732260228892","flowPermAccountId"
//         :"670869647114347","cancelOpinionPolicy":"0","processId":"-2963048075200017466",
//         "isLoadNewFile":"0","canDeleteORarchive":"","summaryId":"7809141347969251159","c
//         ontentstr":"","disAgreeOpinionPolicy":"0","createDate":"2018-06-11 11:03:19"}
//         */
//        Map<String, String> params = new HashMap<String, String>();
//        params.put("bodyType",colSummary.getBodyType());
//        params.put("attModifyFlag","0");
//        params.put("subject",colSummary.getSubject());
//        params.put("isDeleteSupervisior","false");
//        params.put("templateColSubject","");
//        params.put("modifyFlag","0");
//        params.put("templateWorkflowId",String.valueOf(colSummary.getTempleteId()));
//        params.put("flowPermAccountId",String.valueOf(colSummary.getOrgAccountId()));
//        params.put("cancelOpinionPolicy","0");
//        params.put("processId",colSummary.getProcessId());
//        params.put("isLoadNewFile","0");
//        params.put("canDeleteORarchive","");
//        params.put("summaryId",String.valueOf(colSummary.getId()));
//        params.put("contentstr","");
//        params.put("disAgreeOpinionPolicy","0");
//        params.put("createDate",""+format.format(colSummary.getCreateDate()));
//        return params;
//    }
//    private Map genParam(Long templateId){
//        Map params = new HashMap();
//        Map<String, String> trackPara = new HashMap<String, String>();
//        params.put("trackParam", trackPara);
//
//        //Map<String, Object> templateMap = ParamUtil.getJsonDomain("colSummaryData");
//        params.put("templateColSubject", "");
//
//        params.put("templateWorkflowId",String.valueOf(templateId));
//
//        return params;
//    }
//    private void transSubmit(CtpAffair pAffair,CtpAffair affair, ColSummary summary, ColHandleType handleType, Map<String, Object> params) throws BusinessException {
//      //  User user = AppContext.getCurrentUser();
//        ColManagerImpl colManager = (ColManagerImpl)AppContext.getBean("colManager");
//        CommentManager commentManager = (CommentManager)AppContext.getBean("ctpCommentManager");
//       // System.out.println("commentManager:"+commentManager);
//        ColMessageManager colMessageManager = (ColMessageManager)AppContext.getBean("colMessageManager");
//        //System.out.println("colMessageManager:"+colMessageManager);
//        WorkTimeManager workTimeManager = (WorkTimeManager)AppContext.getBean("workTimeManager");
//        //System.out.println("workTimeManager:"+workTimeManager);
//        FormManager formManager = (FormManager)AppContext.getBean("formManager");
//        //System.out.println("formManager:"+formManager);
//        AffairManager affairManager = (AffairManager)AppContext.getBean("affairManager");
//       // System.out.println("affairManager:"+affairManager);
//        IndexManager indexManager = (IndexManager)AppContext.getBean("indexManager");
//       // System.out.println("indexManager:"+indexManager);
//        Map<String, String> colSummaryDomian = genColSummary(summary);
//       // System.out.println("colSummaryDomian:"+colSummaryDomian);
//        String _flowPermAccountId = (String)colSummaryDomian.get("flowPermAccountId");
//        Long flowPermAccountId = Strings.isBlank(_flowPermAccountId) ? summary.getOrgAccountId() : Long.valueOf(_flowPermAccountId);
//      //  System.out.println("flowPermAccountId:"+flowPermAccountId);
//        Comment comment = new Comment();
//        comment.setPushMessage(false);
//        comment.setId(UUIDLong.longUUID());
//        comment.setContent("AUTO COMMIT");
//        comment.setAffairId(affair.getId());
//        commentManager.insertComment(comment);
//        AffairUtil.setHasAttachments(affair, ColUtil.isHasAttachments(summary));
//        AffairData affairData = ColUtil.getAffairData(summary);
//        affairData.setMemberId(affair.getMemberId());
//        affairData.addBusinessData("flowPermAccountId", flowPermAccountId);
//        Integer t = WorkFlowEventListener.COMMONDISPOSAL;
//        affairData.addBusinessData("operationType", t);
//        Boolean isRego = false;
//        String isProcessCompetion;
//        String _pigeonholeValue;
//
//            Boolean isSepicalBackedSubmit = Integer.valueOf(SubStateEnum.col_pending_specialBacked.getKey()).equals(affair.getSubState());
//            isProcessCompetion = (String)params.get("conditionsOfNodes");
//            _pigeonholeValue = (String)params.get("subState");
//            Map<String, String> wfRetMap = workflowFinish2(pAffair,comment, affairData, affair.getSubObjectId(), affair, summary, isProcessCompetion, _pigeonholeValue, params);
//            String nextMembers = (String)wfRetMap.get("nextMembers");
//            isRego = "true".equals(wfRetMap.get("isRego"));
//            String nextMembersWithoutPolicyInfo = (String)wfRetMap.get("nextMembersWithoutPolicyInfo");
//            if (Strings.isNotBlank(nextMembersWithoutPolicyInfo) && isSepicalBackedSubmit) {
//                colMessageManager.transSendSubmitMessage4SepicalBacked(summary, nextMembersWithoutPolicyInfo, affair, comment);
//            }
//
//            List<ProcessLogDetail> allProcessLogDetailList = colManager.getWapi().getAllWorkflowMatchLogAndRemoveCache();
//          //  processLogManager.insertLog(user, Long.parseLong(summary.getProcessId()), affair.getActivityId(), ProcessLogAction.commit, comment.getId(), actionTime, allProcessLogDetailList, new String[]{nextMembers});
//            affair.setState(StateEnum.col_done.getKey());
//
//
//        Date nowTime;
//        long responseTime;
//        if (affair.getSignleViewPeriod() == null && affair.getFirstViewDate() != null) {
//            nowTime = new Date();
//            responseTime = workTimeManager.getDealWithTimeValue(affair.getFirstViewDate(), nowTime, affair.getOrgAccountId());
//            affair.setSignleViewPeriod(responseTime);
//        }
//
//        if (affair.getFirstResponsePeriod() == null) {
//            nowTime = new Date();
//            responseTime = workTimeManager.getDealWithTimeValue(affair.getReceiveTime(), nowTime, affair.getOrgAccountId());
//            affair.setFirstResponsePeriod(responseTime);
//        }
//
//        if (handleType.ordinal() == ColHandleType.finish.ordinal()) {
//            HttpServletRequest request = AppContext.getRawRequest();
//            Long pigeonholeValue = null;
//            if (request != null) {
//                _pigeonholeValue = request.getParameter("pigeonholeValue");
//                if (_pigeonholeValue != null) {
//                    pigeonholeValue = Long.parseLong(_pigeonholeValue);
//                }
//            }
//
//            _pigeonholeValue = (String)params.get("archiveValue");
//            if (Strings.isNotBlank(_pigeonholeValue) && NumberUtils.isNumber(_pigeonholeValue)) {
//                pigeonholeValue = Long.valueOf(_pigeonholeValue);
//            }
//
//            if (pigeonholeValue != null && pigeonholeValue != 0L) {
//                colManager.transPigeonhole(summary, affair, pigeonholeValue, "handle");
//            }
//        }
//
//        if (String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType())) {
//            List commentList = commentManager.getCommentAllByModuleId(ModuleType.collaboration, affair.getObjectId());
//
//            try {
//                formManager.updateDataState(summary, affair, handleType, commentList);
//            } catch (Exception var23) {
//                //LOG.error("更新表单相关信息异常", var23);
//            }
//        }
//
//        boolean isFinished = Integer.valueOf(CollaborationEnum.flowState.finish.ordinal()).equals(summary.getState()) || Integer.valueOf(CollaborationEnum.flowState.terminate.ordinal()).equals(summary.getState());
//        if (isFinished) {
//            affair.setFinish(true);
//        } else {
//            Map<String, String> trackParam = (Map)params.get("trackParam");
//          //  colManager.saveTrackInfo(affair, trackParam);
//        }
//
//        affairManager.updateAffair(affair);
//        if (Strings.isNotBlank(affair.getNodePolicy()) && !"inform".equals(affair.getNodePolicy())) {
//            isProcessCompetion = DateSharedWithWorkflowEngineThreadLocal.getIsProcessCompetion();
//            if (!isRego && (!Strings.isNotBlank(isProcessCompetion) || !isProcessCompetion.equals("1"))) {
//                if (handleType.ordinal() == ColHandleType.finish.ordinal()) {
//                    ColUtil.setCurrentNodesInfoFromCache(summary, affair.getMemberId());
//                } else {
//                    ColUtil.setCurrentNodesInfoFromCache(summary, (Long)null);
//                }
//            } else {
//                ColUtil.updateCurrentNodesInfo(summary);
//            }
//        }
//
//        ColUtil.addOneReplyCounts(summary);
//        colManager.updateColSummary(summary);
//        if (AppContext.hasPlugin("index")) {
//            boolean isForm = String.valueOf(MainbodyType.FORM.getKey()).equals(summary.getBodyType());
//
//            try {
//                if (isForm) {
//                    indexManager.update(summary.getId(), ApplicationCategoryEnum.form.getKey());
//                } else {
//                    indexManager.update(summary.getId(), ApplicationCategoryEnum.collaboration.getKey());
//                }
//            } catch (Exception var24) {
//                String errorInfo = "全文检索更新异常,传入参数summaryId:" + summary.getId() + "mnoduletype:" + (isForm ? "2" : "1");
//            //    LOG.error(errorInfo, var24);
//                throw new BusinessException(errorInfo, var24);
//            }
//        }
//
//        ColSelfUtil.fireAutoSkipEvent(this);
//    }
//    public static Map<String, String> workflowFinish2(CtpAffair pAffair,Comment c, AffairData affairData, long subObjectId, CtpAffair affair, Object appObj, String conditionsOfNodes, String subState, Map<String, Object> params) throws BusinessException {
//       // User user = AppContext.getCurrentUser();
//        WorkflowBpmContext context = new WorkflowBpmContext();
//        context.setDebugMode(false);
//        context.setAppObject(appObj);
//        context.setBusinessData("CtpAffair", affair);
//        context.setBusinessData("CURRENT_OPERATE_MEMBER_ID", affair.getMemberId());
//        context.setBusinessData("CURRENT_OPERATE_COMMENT_ID", c.getId());
//        context.setBusinessData("CURRENT_OPERATE_AFFAIR_ID", affair.getId());
//        context.setBusinessData("ColSummary", appObj);
//        context.setCurrentWorkitemId(subObjectId);
//
//        context.setCurrentUserId(String.valueOf(pAffair.getMemberId()));
//        OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
//        String name = orgManager.getMemberById(pAffair.getMemberId()).getName();
//        context.setCurrentUserName(name);
//        context.setCurrentAccountId(String.valueOf(pAffair.getOrgAccountId()));
//        context.setCurrentAccountName("");
//        context.setBusinessData("comment", c);
//        context.setBusinessData("CTP_AFFAIR_DATA", affairData);
//        context.setBusinessData("subState", subState);
//        Map<String, String> wfdef = new HashMap<String, String>();
//        String processXml = "";
//        String dynamicFormMasterIds = "";
//        boolean isRego = false;
//        context.setDynamicFormMasterIds(dynamicFormMasterIds);
//        context.setToReGo(isRego);
//        context.setMobile(false);
//
//       context.setBusinessData("operationType", affairData.getBusinessData().get("operationType"));
//
//
//        processXml = WorkflowUtil.getTempProcessXml(processXml);
//        if (processXml != null && !"".equals(processXml.trim())) {
//            context.setProcessXml(processXml);
//        }
//
//        String readyObjectJSON = (String)wfdef.get("readyObjectJSON");
//        if (readyObjectJSON != null && !"".equals(readyObjectJSON.trim())) {
//            context.setReadyObjectJson(readyObjectJSON);
//        }
//
//        String popNodeSubProcessJson = "";
//        String selectedPeoplesOfNodes = (String)wfdef.get("workflow_node_peoples_input");
////        if (Strings.isBlank(conditionsOfNodes)) {
////            conditionsOfNodes = (String)wfdef.get("workflow_node_condition_input");
////        }
//
//        String processChangeMessage = (String)wfdef.get("processChangeMessage");
//        context.setPopNodeSubProcessJson(popNodeSubProcessJson);
//        context.setSelectedPeoplesOfNodes(selectedPeoplesOfNodes);
//        if (Strings.isBlank(conditionsOfNodes)) {
//            context.setConditionsOfNodes("{\"condition\":[{\"nodeId\":\"end\",\"isDelete\":\"false\"}]}");
//        } else {
//            context.setConditionsOfNodes(conditionsOfNodes);
//        }
//
//        context.setChangeMessageJSON(processChangeMessage);
//        context.setMastrid(affairData.getFormRecordId() == null ? null : String.valueOf(affairData.getFormRecordId()));
//        context.setFormData(affairData.getFormAppId() == null ? null : String.valueOf(affairData.getFormAppId()));
//        context.setVersion("2.0");
//        if (null == affairData.getTemplateId()) {
//            context.setFreeFlow(true);
//        }
//        //ColManagerImpl colManager = (ColManagerImpl)AppContext.getBean("colManager");
//        WorkflowApiManager wapi = (WorkflowApiManager)AppContext.getBean("wapi");
//        WorkflowApiManagerImpl il;
//
//       com.seeyon.apps.collaboration.listener.WorkFlowEventListener li;//onWorkitemFinished(WorkFlowEventListener.java:385)
//        String[] result = wapi.finishWorkItem(context);
//        Long flowAccount = pAffair.getOrgAccountId();
//        if (affairData.getBusinessData("flowPermAccountId") != null) {
//            flowAccount = (Long)affairData.getBusinessData("flowPermAccountId");
//        }
//
//        String[] policyIds = null;
//        if (result != null && result.length == 3) {
//            policyIds = result[2].split(",");
//        }
//
//        updatePermissinRef(affairData.getModuleType(), policyIds, flowAccount);
//        Map<String, String> wfRetMap = new HashMap();
//        wfRetMap.put("isRego", isRego ? "true" : "false");
//        wfRetMap.put("nextMembers", result[0]);
//        wfRetMap.put("nextMembersWithoutPolicyInfo", result[1]);
//        return wfRetMap;
//    }
//    public static void updatePermissinRef(Integer modulType, String[] policyLists, Long accountId) throws BusinessException {
//        ModuleType type = ModuleType.getEnumByKey(modulType);
//        String configCategory = "";
//        if (!ModuleType.collaboration.name().equals(type.name()) && !ModuleType.form.name().equals(type.name())) {
//            if (ModuleType.edocSend.name().equals(type.name())) {
//                configCategory = EnumNameEnum.edoc_send_permission_policy.name();
//            } else if (ModuleType.edocRec.name().equals(type.name())) {
//                configCategory = EnumNameEnum.edoc_rec_permission_policy.name();
//            } else if (ModuleType.edocSign.name().equals(type.name())) {
//                configCategory = EnumNameEnum.edoc_qianbao_permission_policy.name();
//            } else if (ModuleType.info.name().equals(type.name())) {
//                configCategory = EnumNameEnum.info_send_permission_policy.name();
//            }
//        } else {
//            configCategory = EnumNameEnum.col_flow_perm_policy.name();
//        }
//        PermissionManager permissionManager = (PermissionManager)AppContext.getBean("permissionManager");
//        if (policyLists != null && policyLists.length > 0) {
//            for(int i = 0; i < policyLists.length; ++i) {
//                permissionManager.updatePermissionRef(configCategory, policyLists[i], accountId);
//            }
//        }
//
//    }
//
//}
