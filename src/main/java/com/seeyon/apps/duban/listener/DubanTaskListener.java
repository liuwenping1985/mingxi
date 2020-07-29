package com.seeyon.apps.duban.listener;

import com.seeyon.apps.collaboration.event.*;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.duban.service.CommonServiceTrigger;
import com.seeyon.apps.duban.service.ConfigFileService;
import com.seeyon.apps.duban.service.DubanMainService;
import com.seeyon.apps.duban.service.DubanScoreManager;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.exceptions.InfrastructureException;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.ctp.form.modules.engin.base.formData.FormDataManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.annotation.ListenEvent;
import org.apache.log4j.Logger;
import org.springframework.orm.hibernate3.support.CTPHibernateDaoSupport;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 主要的流转逻辑
 * Created by liuwenping on 2019/11/5.
 */
public class DubanTaskListener {

    private static final Logger LOGGER = Logger.getLogger(DubanTaskListener.class);

    private DecimalFormat decimalFormat = new DecimalFormat("#.00");

    private DubanMainService mainService = DubanMainService.getInstance();

    private DubanScoreManager dubanScoreManager;
    private ColManager colManager;

    private OrgManager orgManager;


    public ColManager getColManager() {
        if (colManager == null) {
            colManager = (ColManager) AppContext.getBean("colManager");
        }
        return colManager;
    }

    public OrgManager getOrgManager() {
        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;
    }

    public DubanScoreManager getDubanScoreManager() {
        if (dubanScoreManager == null) {
            dubanScoreManager = (DubanScoreManager) AppContext.getBean("dubanScoreManager");
        }
        return dubanScoreManager;
    }



    /**
     * 结束
     *
     * @param event
     */
    @ListenEvent(event = CollaborationFinishEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onFinish(CollaborationFinishEvent event) {
        Long summaryId = event.getSummaryId();
        Long affairId = event.getAffairId();
        Long memberId = null;
        V3xOrgMember member = null;
        //往台账表插入数据
        ColSummary colSummary = null;
        Long deptId = null;

        try {
            colSummary = getColManager().getSummaryById(summaryId);
            memberId = colSummary.getStartMemberId();
            member = this.getOrgManager().getMemberById(memberId);
        } catch (BusinessException e) {
            e.printStackTrace();
        }
        if (CommonServiceTrigger.needProcess(summaryId)) {
            Long templateId = colSummary.getTempleteId();

            String val = mainService.getFormTemplateCode(templateId);
            //主表的结构
            try {

                if ("DB_FEEDBACK".equals(val) || "DB_FEEDBACK_AUTO".equals(val)) {

                    getDubanScoreManager().onFeedBackFinish(val, colSummary, member);

                } else if ("DB_DONE_APPLY".equals(val)) {

                    getDubanScoreManager().onDoneApplyFinish(val, colSummary, member);


                } else if ("DB_DELAY_APPLY".equals(val)) {
                    getDubanScoreManager().onDelayApplyFinish(val, colSummary, member);

                }
            } catch (Exception e) {
                e.printStackTrace();
            }


        } else {
            System.out.println("I AM out out out:" + summaryId);
        }

    }


    private void freshData(String rcdId) {

        String fid = ConfigFileService.getPropertyByName("ctp.duban.form_template_id");

        String sql = "select content_template_id from ctp_content_all where MODULE_ID=" + rcdId;

        Map data = DataBaseUtils.querySingleDataBySQL(sql);

        String ctid = String.valueOf(data.get("content_template_id"));

        FormDataManager formDataManager = (FormDataManager) AppContext.getBean("formDataManager");
        if (formDataManager != null) {
            try {
                List<String> ids = new ArrayList<String>();
                ids.add(rcdId);
                formDataManager.saveBatchRefresh(ids, ctid, "37", fid);
            } catch (Exception e) {
                e.printStackTrace();

            }
        }
    }

    /**
     * 开始
     *
     * @param event
     */
    @ListenEvent(event = CollaborationStartEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onStart(CollaborationStartEvent event) {

        System.out.println("触发任务分数计算:");
        Long summaryId = event.getSummaryId();
        if (CommonServiceTrigger.needProcess(summaryId)) {
            ColSummary colSummary = null;
            V3xOrgMember member = null;
            try {
                Long memberId = getColManager().getAffairById(event.getAffairId()).getSenderId();
                member = getOrgManager().getMemberById(memberId);
                if (member == null) {
                    LOGGER.error("can not find user!error-code：3478");
                    return;
                }
                colSummary = getColManager().getSummaryById(summaryId);
            } catch (BusinessException e) {
                e.printStackTrace();
                return;
            }
            String val = mainService.getFormTemplateCode(colSummary.getTempleteId());
            if ("DB_FEEDBACK".equals(val)||"DB_FEEDBACK_AUTO".equals(val)) {

                getDubanScoreManager().caculateScoreWhenStartOrProcess(val, colSummary, member);


            }


        }


    }

    /**
     * 取消
     *
     * @param event
     */
    @ListenEvent(event = CollaborationCancelEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onCancel(CollaborationCancelEvent event) {



    }

    /**
     * 取回
     *
     * @param event
     */
    @ListenEvent(event = CollaborationStepBackEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onStepBack(CollaborationStepBackEvent event) {


    }

    /**
     * 终止
     *
     * @param event
     */
    @ListenEvent(event = CollaborationStopEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onStop(CollaborationStopEvent event) {


    }

    private boolean isLogging = true;

    private void log(Object obj) {
        if (isLogging) {
            System.out.println(obj);
        }

    }

    /**
     * 处理
     *
     * @param event
     */
    @ListenEvent(event = CollaborationProcessEvent.class, async = true, mode = EventTriggerMode.afterCommit)
    public void onProcess(CollaborationProcessEvent event) {

        Long summaryId = event.getSummaryId();
        log("this way plz:" + summaryId);
        if (CommonServiceTrigger.needProcess(summaryId)) {
            log("i AM IN:" + summaryId);
            ColSummary colSummary = null;
            V3xOrgMember member = null;

            try {
                Long memberId = event.getAffair().getSenderId();
                member = getOrgManager().getMemberById(memberId);
                if (member == null) {
                    LOGGER.error("can not find user!error-code：3478");
                    return;
                }
                colSummary = getColManager().getSummaryById(summaryId);
            } catch (BusinessException e) {
                e.printStackTrace();
                return;
            }
            String templateCode = mainService.getFormTemplateCode(colSummary.getTempleteId());
            log("templateCode:" + summaryId);
            getDubanScoreManager().caculateScoreWhenStartOrProcess(templateCode, colSummary, member);
            //完成后
            if ("DB_DONE_APPLY".equals(templateCode)) {
                try {
                    getDubanScoreManager().onDoneApplyProcess(templateCode, colSummary, member);
                } catch (BusinessException e) {
                    e.printStackTrace();
                }

            }
        }
    }


    private static CTPHibernateDaoSupport currentHibernateDaoSupport() {
        if (!"true".equals(AppContext.getThreadContext("SPRING_AOP_LOCK"))) {
            throw new InfrastructureException("当前BS方法未采用Spring管理数据库连接，请检查方法命名是否符合Spring设置！");
        } else {
            return (CTPHibernateDaoSupport) AppContext.getThreadContext("SPRING_HIBERNATE_DAO_SUPPORT");
        }
    }


    public static void main(String[] args) {
        Long id = 1L;
        String ids = "/1.0/eWJlWUJFQTMxMjo=";

       // System.out.println(PwdEncoder.decode(ids));
    }

}
