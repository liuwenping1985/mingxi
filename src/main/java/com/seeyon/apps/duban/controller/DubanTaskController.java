package com.seeyon.apps.duban.controller;

import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.service.MappingService;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.service.ConfigFileService;
import com.seeyon.apps.duban.service.DubanMainService;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.apps.duban.util.UIUtils;
import com.seeyon.apps.duban.vo.CommonJSONResult;
import com.seeyon.apps.duban.vo.DubanBaseInfo;
import com.seeyon.apps.duban.vo.form.FormTable;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.ncdeploy.db.DataBase;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.v3x.util.annotation.NeedlessCheckLogin;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

/**
 * 督办任务控制器
 * Created by liuwenping on 2019/11/7.
 */
public class DubanTaskController extends BaseController {

    private static final Logger LOGGER = Logger.getLogger(DubanTaskController.class);
    private DubanMainService dubanMainService = DubanMainService.getInstance();
    private OrgManager orgManager;

    public OrgManager getOrgManager() {
        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;
    }

    /**
     * 列出进展页面
     *
     * @param request
     * @param response
     * @return
     */
    public ModelAndView listProcessHome(HttpServletRequest request, HttpServletResponse response) {


        ModelAndView modelAndView = new ModelAndView("apps/duban/processMainPage");
        return modelAndView;
    }

    /**
     * 台账
     *
     * @param request
     * @param response
     * @return
     */
    public ModelAndView dashBord(HttpServletRequest request, HttpServletResponse response) {

        ModelAndView modelAndView = new ModelAndView("apps/duban/dashbord");
        User user = AppContext.getCurrentUser();
        List<DubanTask> taskList = dubanMainService.getAllLeaderDubanTaskList(user.getId());

        String havingLeaderTask = String.valueOf(!CommonUtils.isEmpty(taskList));

        modelAndView.addObject("havingLeaderTask",havingLeaderTask);



        return modelAndView;


    }

    public ModelAndView getRunningDubanTaskList(HttpServletRequest request, HttpServletResponse response) {
        CommonJSONResult ret = new CommonJSONResult();

        try {
            DubanBaseInfo dubanBaseInfo = new DubanBaseInfo();
            Long memberId = AppContext.currentUserId();
            dubanBaseInfo.setLeaderList(dubanMainService.getRuuningLeaderDubanTaskList(memberId));
            dubanBaseInfo.setXiebanTaskList(dubanMainService.getRuuningColLeaderDubanTaskList(memberId));
            dubanBaseInfo.setCengbanTaskList(dubanMainService.getRunningMainDubanTask(memberId));
            dubanBaseInfo.setSupervisorTaskList(dubanMainService.getRunningDubanTaskSupervisor(memberId));
            ret.setCode("success");
            ret.setStatus("0");
            ret.setData(dubanBaseInfo);
        } catch (Exception e) {
            e.printStackTrace();
            ret.setCode("failed");
            ret.setStatus("1");
            ret.setMsg(e.getMessage());
        }

        UIUtils.responseJSON(ret, response);

        return null;

    }

    /**
     * 获取全部督办任务
     *
     * @param request
     * @param response
     * @return
     */

    public ModelAndView getAllDubanTaskList(HttpServletRequest request, HttpServletResponse response) {
        String mode = request.getParameter("mode");
        List<DubanTask> taskList = new ArrayList<DubanTask>();
        if (CommonUtils.isEmpty(mode)) {
            taskList = dubanMainService.getAllDubanTask();
        } else if ("leader".equals(mode)) {
            taskList = dubanMainService.getAllLeaderDubanTaskList(AppContext.currentUserId());
        } else if ("duban".equals(mode)) {
            taskList = dubanMainService.getAllDubanTaskSupervisor(AppContext.currentUserId());
        } else if ("xieban".equals(mode)) {
            taskList = dubanMainService.getAllColLeaderDubanTaskList(AppContext.currentUserId());
        } else if ("cengban".equals(mode)) {
            taskList = dubanMainService.getAllMainDubanTask(AppContext.currentUserId());
        }
        UIUtils.responseJSON(taskList, response);

        return null;


    }

    /**
     * 获取全部督办任务
     *
     * @param request
     * @param response
     * @return
     */

    public ModelAndView getFinishedDubanTaskList(HttpServletRequest request, HttpServletResponse response) {
        String mode = request.getParameter("mode");
        List<DubanTask> taskList = new ArrayList<DubanTask>();
        if (CommonUtils.isEmpty(mode)) {
            taskList = dubanMainService.getAllDubanTask();
        } else if ("leader".equals(mode)) {
            taskList = dubanMainService.getFinishedLeaderDubanTaskList(AppContext.currentUserId());
        } else if ("duban".equals(mode)) {
            taskList = dubanMainService.getFinishedDubanTaskSupervisor(AppContext.currentUserId());
        } else if ("xieban".equals(mode)) {
            taskList = dubanMainService.getFinishedColLeaderDubanTaskList(AppContext.currentUserId());
        } else if ("cengban".equals(mode)) {
            taskList = dubanMainService.getFinishedMainDubanTask(AppContext.currentUserId());
        }
        UIUtils.responseJSON(taskList, response);

        return null;


    }

    /**
     * 添加领导意见
     *
     * @param request
     * @param response
     * @return
     */
    public ModelAndView addLeaderOpinion(HttpServletRequest request, HttpServletResponse response) {

        String taskId = request.getParameter("taskId");

        String opinion = request.getParameter("opinion");

        CommonJSONResult cjr = new CommonJSONResult();
        try {


            FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
            User user = AppContext.getCurrentUser();
            if (CommonUtils.isEmpty(opinion)) {
                opinion = "";
            }
            String tbName = ftd.getFormTable().getName();
            String sql = "select id,field0016 from " + tbName + " where field0001='" + taskId + "'";

            Map data = DataBaseUtils.querySingleDataBySQL(sql);
            Object val = data.get("field0016");
            StringBuilder stb = new StringBuilder();
            if (val == null) {
                stb.append("");
            } else {
                stb.append(String.valueOf(val));
            }
            String dateStr = CommonUtils.formatDateSimple(new Date());
            stb.append("\n" + dateStr + " 【" + user.getName() + "】:" + opinion + "");

            sql = "update " + tbName + " set field0016='" + stb.toString() + "' where id = " + data.get("id");
            cjr.setData(data);
            DataBaseUtils.executeUpdate(sql);
        } catch (Exception e) {
            e.printStackTrace();
            cjr.setStatus("0");
            cjr.setMsg(e.getMessage());
            cjr.setCode("ERROR");
        }
        UIUtils.responseJSON(cjr, response);
        return null;
    }

    /**
     * 获取督办任务
     *
     * @param request
     * @param response
     * @return
     */

    public ModelAndView getRunningDubanTask(HttpServletRequest request, HttpServletResponse response) {
        String mode = request.getParameter("mode");
        List<DubanTask> taskList = new ArrayList<DubanTask>();
        if (CommonUtils.isEmpty(mode)) {
            taskList = dubanMainService.getAllDubanTask();
        } else if ("leader".equals(mode)) {
            taskList = dubanMainService.getRuuningLeaderDubanTaskList(AppContext.currentUserId());
        } else if ("duban".equals(mode)) {
            taskList = dubanMainService.getRunningDubanTaskSupervisor(AppContext.currentUserId());
        } else if ("xieban".equals(mode)) {
            taskList = dubanMainService.getRuuningColLeaderDubanTaskList(AppContext.currentUserId());
        } else if ("cengban".equals(mode)) {
            taskList = dubanMainService.getRunningMainDubanTask(AppContext.currentUserId());
        }
        UIUtils.responseJSON(taskList, response);

        return null;


    }

    public ModelAndView getDataDetail(HttpServletRequest request, HttpServletResponse response) {

        String sid = request.getParameter("sid");
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where id=" + sid;
        Map data = DataBaseUtils.querySingleDataBySQL(sql);
        List<FormTable> tables = ftd.getFormTable().getSlaveTableList();
        if (!CommonUtils.isEmpty(tables)) {
            FormTable formTable = tables.get(0);
            String sql2 = "select * from " + formTable.getName() + " where formmain_id=" + sid;
            List<Map> dataList = DataBaseUtils.queryDataListBySQL(sql2);
            data.put(formTable.getName(), dataList);
        }
        Object field0006 = data.get("field0006");
        if (field0006 != null && !CommonUtils.isEmpty("" + field0006)) {

            String sql3 = "select * from ctp_attachment where SUB_REFERENCE in(" + field0006 + ")";
            List<Map> attList = DataBaseUtils.queryDataListBySQL(sql3);
            List<Map> retList = new ArrayList<Map>();
            for (Map data_ : attList) {
                Map<String, Object> data2 = (Map<String, Object>) data_;
                Map ret = new HashMap();
                for (Map.Entry<String, Object> entry : data2.entrySet()) {
                    Object val = entry.getValue();
                    String key = entry.getKey();
                    if (val instanceof Long) {
                        ret.put(key, String.valueOf(val));
                    } else if (val instanceof BigDecimal) {
                        ret.put(key, ((BigDecimal) val).toPlainString());
                    } else {
                        ret.put(key, val);
                    }
                    retList.add(ret);

                }

            }
            data.put("field0006", retList);
        }


        UIUtils.responseJSON(data, response);

        return null;


    }

    public ModelAndView showDbps(HttpServletRequest request, HttpServletResponse response) {
        String sid = request.getParameter("sid");
        String url = "/seeyon/content/content.do?method=index&isFullPage=true&moduleId=" + sid + "&moduleType=37&rightId=-7358326681974652894.634760108374510857|-5695649081455064417.-678199947012652287|4691278459417608212.4729432398069056994|-8589896943821304179.6079481201566305033|1772868952482005122.7434405613586957248|-8025070505852907711.8822098668542315262|-2099901832207187109.906517871566734426|4569029994082815411.6556388215328424719|-6194359099302984515.-4571615919362650815|-1840510641429921571.-958050165871522989|4905125698409613191.5494109670702924843|8654405196159535160.3862491316711538842|-6030440839836187926.-7160389505585493498&contentType=20&viewState=2&indexParam=0";
        try {
            response.sendRedirect(url);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;


    }


    public ModelAndView getMemberName(HttpServletRequest request, HttpServletResponse response) {

        String sid = request.getParameter("sid");

        try {
            V3xOrgMember member = CommonUtils.getOrgManager().getMemberById(CommonUtils.getLong(sid));

            Map data = new HashMap();
            data.put("name", member.getName());

            UIUtils.responseJSON(data, response);

        } catch (BusinessException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * 跳页面
     *
     * @param request
     * @param response
     * @return
     */
    public ModelAndView goPage(HttpServletRequest request, HttpServletResponse response) {

        String page = request.getParameter("page");
        ModelAndView modelAndView = new ModelAndView("apps/duban/" + page);
        return modelAndView;
    }

    /**
     * 重载配置
     *
     * @param request
     * @param response
     * @return
     */
    public ModelAndView reloadConfig(HttpServletRequest request, HttpServletResponse response) {

        Object rst = ConfigFileService.reload();

        UIUtils.responseJSON(rst, response);

        return null;
    }

    /**
     * 重载配置
     *
     * @param request
     * @param response
     * @return
     */
    public ModelAndView reloadMapping(HttpServletRequest request, HttpServletResponse response) {

        MappingService.getInstance().reloadMapping();

        UIUtils.responseJSON("OK", response);

        return null;
    }

}
