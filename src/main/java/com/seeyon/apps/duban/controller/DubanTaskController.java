package com.seeyon.apps.duban.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.po.DubanConfigItem;
import com.seeyon.apps.duban.po.DubanScoreRecord;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.po.SlaveDubanTask;
import com.seeyon.apps.duban.service.ConfigFileService;
import com.seeyon.apps.duban.service.DubanMainService;
import com.seeyon.apps.duban.service.DubanScoreManager;
import com.seeyon.apps.duban.service.MappingService;
import com.seeyon.apps.duban.service.impl.DubanScoreManagerImpl;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.apps.duban.util.SendMessageUtils;
import com.seeyon.apps.duban.util.UIUtils;
import com.seeyon.apps.duban.vo.CommonJSONResult;
import com.seeyon.apps.duban.vo.DubanBaseInfo;
import com.seeyon.apps.duban.vo.DubanStatData;
import com.seeyon.apps.duban.vo.LineData;
import com.seeyon.apps.duban.vo.form.FormTable;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.duban.wrapper.DataTransferStrategy;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;
import www.seeyon.com.utils.StringUtil;

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
    private DubanScoreManager dubanScoreManager;

    public DubanScoreManager getDubanScoreManager() {
        if (dubanScoreManager == null) {
            dubanScoreManager = (DubanScoreManager) AppContext.getBean("dubanScoreManager");
        }
        return dubanScoreManager;
    }

    public OrgManager getOrgManager() {
        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;
    }

    private User getCurrentOrMockUser() {
        User user = AppContext.getCurrentUser();
        if (user == null) {
            //4539057419316513978
            user = new User();
            user.setId(4539057419316513978L);
            user.setDepartmentId(-2509449334167942440L);
            user.setAccountId(-8876840092684173183L);
            user.setName("苗江涛");
            user.setLoginName("miaojt");
            user.setLoginAccount(user.getAccountId());
            user.setLoginTimestamp(System.currentTimeMillis());
        }
        return user;

    }

    public ModelAndView checkCanFinish(HttpServletRequest request, HttpServletResponse response) {
        String recordId = request.getParameter("recordId");
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where id='" + recordId + "'";
        Map dibiao = DataBaseUtils.querySingleDataBySQL(sql);
        DubanTask task = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, dibiao, ftd);
        CommonJSONResult cjr = new CommonJSONResult();
        cjr.setStatus("0");
        cjr.setData("YES");
        if (task != null) {
            User user = AppContext.getCurrentUser();
            try {
                V3xOrgMember member = getOrgManager().getMemberById(user.getId());
                if(getDubanScoreManager().isCengban(member,dibiao)){
                    List<SlaveDubanTask> slaveDubanTasks = task.getSlaveDubanTaskList();
                    for(SlaveDubanTask slaveDubanTask:slaveDubanTasks){
                        if(!StringUtils.isEmpty(slaveDubanTask.getDeptName())){
                            if(!"100".equals(slaveDubanTask.getProcess())){
                                cjr.setData("NO");
                            }
                        }
                    }

                }
            } catch (BusinessException e) {
                cjr.setStatus("1");
                e.printStackTrace();
            }

        }
        UIUtils.responseJSON(cjr,response);
        return null;

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

    public ModelAndView saveDubanConfigItems(HttpServletRequest request, HttpServletResponse response) {
        try {
            Map<String, String[]> params = request.getParameterMap();
            Map<String, String> dataMap = new HashMap<String, String>();
            for (Map.Entry<String, String[]> entry : params.entrySet()) {
                dataMap.put(entry.getKey(), entry.getValue() != null ? entry.getValue()[0] : "");
            }

            if (dataMap == null) {

                UIUtils.responseJSON("ERROR", response);
                return null;
            }
            List<DubanConfigItem> dataList = DBAgent.find("from " + DubanConfigItem.class.getSimpleName() + " where state=1");
            Map<String, DubanConfigItem> itemMap = new HashMap<String, DubanConfigItem>();
            for (DubanConfigItem item : dataList) {
                if ("cb_xishu".equals(item.getName())) {
                    itemMap.put("cb_xishu", item);
                    continue;
                }
                if ("xb_xishu".equals(item.getName())) {
                    itemMap.put("xb_xishu", item);
                    continue;
                }
                itemMap.put(String.valueOf(item.getEnumId()), item);
            }

            for (Map.Entry<String, String> entry : dataMap.entrySet()) {

                String value = entry.getValue();
                String key = entry.getKey();
                DubanConfigItem item = itemMap.get(key);
                if (item == null) {

                    Long enumId = CommonUtils.getLong(key);
                    if (enumId == null) {
                        continue;
                    }
                    item = new DubanConfigItem();
                    item.setIdIfNew();
                    item.setEnumId(enumId);
                    item.setState(1);
                }
                item.setItemValue(value);
                DBAgent.saveOrUpdate(item);

            }


            UIUtils.responseJSON(dataMap, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
        UIUtils.responseJSON("exception exception", response);
        return null;

    }

    /**
     * 列出设置分数数据
     *
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView getDubanConfigItemDataList(HttpServletRequest request, HttpServletResponse response) {

        try {
            String sourceEnumId = ConfigFileService.getPropertyByName("ctp.group.task_source.enum");
            String levelEnumId = ConfigFileService.getPropertyByName("ctp.group.task_level.enum");

            String sql = "select * from ctp_enum_item where REF_ENUMID=" + sourceEnumId + " or REF_ENUMID=" + levelEnumId;

            List<Map> dataMapList = DataBaseUtils.queryDataListBySQL(sql);

            List<DubanConfigItem> dataList = DBAgent.find("from " + DubanConfigItem.class.getSimpleName() + " where state=1");
            //Map<String, DubanConfigItem> dataListMapping = new HashMap<String, DubanConfigItem>();

//        for(DubanConfigItem item:dataList){
//            dataListMapping.put(String.valueOf(item.getEnumId()),item);
//        }
            Map<String, Map> seeyonEnumMap = new HashMap<String, Map>();
            for (Map data : dataMapList) {
                data.put("sid", String.valueOf(data.get("id")));
                if (sourceEnumId.equals(String.valueOf(data.get("ref_enumid")))) {

                    data.put("enum_group", "task_source");
                }
                if (levelEnumId.equals(String.valueOf(data.get("ref_enumid")))) {

                    data.put("enum_group", "task_level");
                }
                seeyonEnumMap.put(String.valueOf(data.get("id")), data);
            }
            for (DubanConfigItem item : dataList) {
                String itemName = item.getName();
                if ("xb_xishu".equals(itemName) || "cb_xishu".equals(itemName)) {
                    String jsonString = JSON.toJSONString(item);
                    Map jsonMap = JSON.parseObject(jsonString, HashMap.class);
                    jsonMap.put("sid", String.valueOf(item.getId()));
                    jsonMap.put("showvalue", itemName);
                    jsonMap.put("set_value", item.getItemValue());
                    seeyonEnumMap.put(itemName, jsonMap);
                    continue;
                }
                Long enumId = item.getEnumId();
                if (enumId != null) {
                    String key = String.valueOf(enumId);
                    Map data = seeyonEnumMap.get(key);
                    if (data != null && !data.isEmpty()) {
                        data.put("set_value", item.getItemValue());
                    }

                }

            }
            List<Map> retList = new ArrayList<Map>();
            retList.addAll(seeyonEnumMap.values());
            CommonJSONResult ret = new CommonJSONResult();
            ret.setItems(retList);
            UIUtils.responseJSON(ret, response);
            return null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        UIUtils.responseJSON("ERROR", response);
        return null;
    }


    @NeedlessCheckLogin
    public ModelAndView getPreProcessProperties(HttpServletRequest request, HttpServletResponse response) {

        User user = getCurrentOrMockUser();
        List<DubanTask> taskList = dubanMainService.getAllLeaderDubanTaskList(user.getId());
        String havingLeaderTask = String.valueOf(!CommonUtils.isEmpty(taskList));
        Map data = new HashMap();
        List<DubanTask> supervisorTaskList = dubanMainService.getAllDubanTaskSupervisor(user.getId());
        Map templateProperties = ConfigFileService.getTemplateProperties();
        data.put("templateProperties", templateProperties);
        data.put("havingLeaderTask", havingLeaderTask);
        data.put("havingSupervisorTask", String.valueOf(!CommonUtils.isEmpty(supervisorTaskList)));
        data.put("leaderTaskList", taskList);
        data.put("supervisorTaskList", supervisorTaskList);
        UIUtils.responseJSON(data, response);
        return null;
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
        return modelAndView;


    }

    @NeedlessCheckLogin
    public ModelAndView getRunningDubanTaskList(HttpServletRequest request, HttpServletResponse response) {
        CommonJSONResult ret = new CommonJSONResult();

        try {
            DubanBaseInfo dubanBaseInfo = new DubanBaseInfo();
            User user = getCurrentOrMockUser();
            Long memberId = user.getId();
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
    @NeedlessCheckLogin
    public ModelAndView getAllDubanTaskList(HttpServletRequest request, HttpServletResponse response) {
        String mode = request.getParameter("mode");
        List<DubanTask> taskList = new ArrayList<DubanTask>();
        User user = getCurrentOrMockUser();
        Long memberId = user.getId();
        if (CommonUtils.isEmpty(mode)) {
            taskList = dubanMainService.getAllDubanTask();
        } else if ("leader".equals(mode)) {
            taskList = dubanMainService.getAllLeaderDubanTaskList(memberId);
        } else if ("duban".equals(mode)) {
            taskList = dubanMainService.getAllDubanTaskSupervisor(memberId);
        } else if ("xieban".equals(mode)) {
            taskList = dubanMainService.getAllColLeaderDubanTaskList(memberId);
        } else if ("cengban".equals(mode)) {
            taskList = dubanMainService.getAllMainDubanTask(memberId);
        }
        UIUtils.responseJSON(doApprovingFilter(taskList), response);

        return null;


    }

    /**
     * 获取全部督办任务
     *
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView getFinishedDubanTaskList(HttpServletRequest request, HttpServletResponse response) {
        String mode = request.getParameter("mode");
        List<DubanTask> taskList = new ArrayList<DubanTask>();
        User user = getCurrentOrMockUser();
        Long memberId = user.getId();
        if (CommonUtils.isEmpty(mode)) {
            taskList = dubanMainService.getAllDubanTask();
        } else if ("leader".equals(mode)) {
            taskList = dubanMainService.getFinishedLeaderDubanTaskList(memberId);
        } else if ("duban".equals(mode)) {
            taskList = dubanMainService.getFinishedDubanTaskSupervisor(memberId);
        } else if ("xieban".equals(mode)) {
            taskList = dubanMainService.getFinishedColLeaderDubanTaskList(memberId);
        } else if ("cengban".equals(mode)) {
            taskList = dubanMainService.getFinishedMainDubanTask(memberId);
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
    @NeedlessCheckLogin
    public ModelAndView addLeaderOpinion(HttpServletRequest request, HttpServletResponse response) {

        String taskId = request.getParameter("taskId");

        String opinion = request.getParameter("opinion");

        CommonJSONResult cjr = new CommonJSONResult();
        try {
            FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
            User user = getCurrentOrMockUser();
            if (CommonUtils.isEmpty(opinion)) {
                opinion = "";
            }
            String tbName = ftd.getFormTable().getName();
            String sql = "select id,field0016," +
                    "field0012,field0019,field0026,field0033,field0040,field0047,field0054,field0061,field0068,field0075,field0082,field0089 from "
                    + tbName + " where field0001='" + taskId + "'";

            Map data = DataBaseUtils.querySingleDataBySQL(sql);
            Object val = data.get("field0016");
            StringBuilder stb = new StringBuilder();
            if (val == null) {
                stb.append("");
            } else {
                stb.append(String.valueOf(val));
            }
            V3xOrgDepartment dept = this.getOrgManager().getDepartmentById(user.getDepartmentId());
            String deptName = "";
            if (dept != null) {
                deptName = dept.getName();
            }
            String dateStr = CommonUtils.formatDateHourMinute(new Date());
            stb.append("\n\n" + deptName + "-" + user.getName() + "(" + dateStr + "):" + opinion.trim() + "");

            sql = "update " + tbName + " set field0016='" + stb.toString() + "' where id = " + data.get("id");
            cjr.setData(data);
            DataBaseUtils.executeUpdate(sql);

            List<Long> ids = new ArrayList();
            ids.add(Long.valueOf(data.get("field0019").toString()));

            //0026 配合责任人0，,12督办员，19，主办负责人
            for (int i = 26; i < 100; i = i + 7) {
                if (data.get("field00" + i) != null) {
                    ids.add(Long.valueOf(data.get("field00" + i).toString()));
                }
            }
            cjr.setStatus("0");
            SendMessageUtils.sendMessage(user.getId(), ids, deptName + "-" + user.getName() + "(" + dateStr + "):" + opinion.trim(), "");
        } catch (Exception e) {
            e.printStackTrace();
            cjr.setStatus("1");
            cjr.setMsg(e.getMessage());
            cjr.setCode("ERROR");
        }
        UIUtils.responseJSON(cjr, response);
        return null;
    }

    private void sendMessage() {

    }

    /**
     * 获取督办任务
     *
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView getRunningDubanTask(HttpServletRequest request, HttpServletResponse response) {
        String mode = request.getParameter("mode");
        List<DubanTask> taskList = new ArrayList<DubanTask>();
        User user = getCurrentOrMockUser();
        Long mId = user.getId();
        if (CommonUtils.isEmpty(mode)) {
            taskList = dubanMainService.getAllDubanTask();
        } else if ("leader".equals(mode)) {
            taskList = dubanMainService.getRuuningLeaderDubanTaskList(mId);
        } else if ("duban".equals(mode)) {
            taskList = dubanMainService.getRunningDubanTaskSupervisor(mId);
        } else if ("xieban".equals(mode)) {
            taskList = dubanMainService.getRuuningColLeaderDubanTaskList(mId);
        } else if ("cengban".equals(mode)) {
            taskList = dubanMainService.getRunningMainDubanTask(mId);
        }


        UIUtils.responseJSON(doApprovingFilter(taskList), response);

        return null;


    }

    @NeedlessCheckLogin
    public ModelAndView getDataDetail(HttpServletRequest request, HttpServletResponse response) {

        String sid = request.getParameter("sid");
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where id=" + sid;
        Map data = DataBaseUtils.querySingleDataBySQL(sql);
        DubanTask dubanTask = DataTransferStrategy.filledFtdValueByObjectType(DubanTask.class, data, ftd);
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
        //找到是承办还是协办
        String linkToType = request.getParameter("linkToType");
        if (CommonUtils.isEmpty(linkToType)) {
            linkToType = "cengban";
        }
        data.put("mode_type", linkToType);
        if ("cengban".equals(linkToType)) {
            data.put("cengban_process", dubanTask.getMainProcess());
        } else if ("xieban".equals(linkToType)) {
            List<SlaveDubanTask> slaveDubanTaskList = dubanTask.getSlaveDubanTaskList();
            if (!CommonUtils.isEmpty(slaveDubanTaskList)) {
                String curDeptId = String.valueOf(getCurrentOrMockUser().getDepartmentId());
                for (SlaveDubanTask sTask : slaveDubanTaskList) {
                    String deptId = sTask.getDeptName();
                    if (curDeptId.equals(deptId)) {
                        String no = sTask.getNo();
                        Integer index = Integer.parseInt(no);
                        String processField = "field00" + (28 + 7 * (index - 1));
                        data.put("xieban_process", sTask.getProcess());
                        data.put("xieban_field", processField);
                    }
                }
            } else {
                data.put("xieban_field", "");
            }

        }


        data.put("template_id_info_map", ConfigFileService.getTemplateProperties());


        UIUtils.responseJSON(data, response);

        return null;


    }

    @NeedlessCheckLogin
    public ModelAndView showDbps(HttpServletRequest request, HttpServletResponse response) {
        String sid = request.getParameter("sid");
        String url = ConfigFileService.getPropertyByName("ctp.duban.duban_detail_all_url") + sid + "&from_duban=1";
        try {
            response.sendRedirect(url);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;


    }

    @NeedlessCheckLogin
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

    @NeedlessCheckLogin
    public ModelAndView getDepartmentName(HttpServletRequest request, HttpServletResponse response) {

        String sid = request.getParameter("sid");

        try {
            V3xOrgDepartment department = CommonUtils.getOrgManager().getDepartmentById(CommonUtils.getLong(sid));

            Map data = new HashMap();
            data.put("name", department.getName());

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
    @NeedlessCheckLogin
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

    @NeedlessCheckLogin
    public ModelAndView getStatDataDetail(HttpServletRequest request, HttpServletResponse response) {
        CommonJSONResult data = new CommonJSONResult();
        String ids = request.getParameter("taskIds");
        List<DubanTask> taskList = dubanMainService.getStatDubanList(ids);
        data.setItems(taskList);
        data.setCode("200");
        UIUtils.responseJSON(data, response);
        return null;

    }

    private List<DubanTask> doApprovingFilter(List<DubanTask> dubanTaskList) {
        if (CollectionUtils.isEmpty(dubanTaskList)) {
            return dubanTaskList;
        }
        try {
            List<DubanTask> filterDubanTask = getApprovingItemList();
            if (!CollectionUtils.isEmpty(filterDubanTask)) {
                Set<String> approvingTaskSet = new HashSet<String>();
                for (DubanTask task : filterDubanTask) {
                    approvingTaskSet.add(task.getTaskId());
                }
                Iterator<DubanTask> it = dubanTaskList.iterator();
                while (it.hasNext()) {
                    DubanTask dt = it.next();
                    if (approvingTaskSet.contains(dt.getTaskId())) {
                        it.remove();
                    }
                }

            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return dubanTaskList;


    }

    @NeedlessCheckLogin
    public ModelAndView getStatData(HttpServletRequest request, HttpServletResponse response) {

        CommonJSONResult data = new CommonJSONResult();
        String startDate = request.getParameter("start_date");
        Date start = null, end = null;
        if (startDate != null) {
            start = CommonUtils.parseDate(startDate);
        }
        String endDate = request.getParameter("end_date");
        if (endDate != null) {
            end = CommonUtils.parseDate(endDate);
        }
        String deptIds = request.getParameter("deptIds");
        StringBuilder sql = new StringBuilder("from DubanScoreRecord where 1=1 ");
        Map params = new HashMap();
        if (start != null) {
            sql.append("and createDate>=:createDate");
            params.put("createDate", start);
        }
        if (end != null) {
            sql.append(" and createDate<=:endDate");
            params.put("endDate", end);
        }
        if (deptIds != null) {
            String[] dids = deptIds.split(",");

            List<Long> departmentIds = new ArrayList<Long>();
            for (String did : dids) {
                Long deptId = CommonUtils.getLong(did);
                if (deptId != null) {
                    departmentIds.add(deptId);
                }
            }
            if (!CollectionUtils.isEmpty(departmentIds)) {
                sql.append(" and departmentId in(:departmentIds)");
                params.put("departmentIds", departmentIds);
            }


        }
        List<DubanScoreRecord> dsrList = DBAgent.find(sql.toString(), params);
        //
        List<DubanStatData> dataList = new ArrayList<DubanStatData>();
        //以部门id将结果分组
        Map<Long, List<DubanScoreRecord>> deptDubanScoreRecordMap = new HashMap<Long, List<DubanScoreRecord>>();
        if (!CommonUtils.isEmpty(dsrList)) {

            for (DubanScoreRecord record : dsrList) {
                Long deptId = record.getDepartmentId();
                List<DubanScoreRecord> rList = deptDubanScoreRecordMap.get(deptId);
                if (rList == null) {
                    rList = new ArrayList<DubanScoreRecord>();
                    deptDubanScoreRecordMap.put(deptId, rList);
                }
                rList.add(record);
            }
            String dateParams = JSON.toJSONString(params);

            for (Map.Entry<Long, List<DubanScoreRecord>> entry : deptDubanScoreRecordMap.entrySet()) {
                //部门维度
                Long deptId = entry.getKey();
                List<LineData> lineDatas = new ArrayList<LineData>();
                List<DubanScoreRecord> recordList = entry.getValue();
                Map<String, List<DubanScoreRecord>> taskMaps = new HashMap<String, List<DubanScoreRecord>>();
                for (DubanScoreRecord record : recordList) {
                    List<DubanScoreRecord> taskList = taskMaps.get(record.getTaskId());
                    if (taskList == null) {
                        taskList = new ArrayList<DubanScoreRecord>();
                        taskMaps.put(record.getTaskId(), taskList);
                    }
                    taskList.add(record);
                }
                try {
                    V3xOrgDepartment department = getOrgManager().getDepartmentById(deptId);
                    //计算分数
                    Set summaryIdSet = new HashSet();
                    Double score = 0d;
                    Double keScore = 0d;
                    //taskId为key
                    for (Map.Entry<String, List<DubanScoreRecord>> taskScoreRecordS : taskMaps.entrySet()) {
                        Double zhuguanScore = 0d;
                        Double wanchengScore = 0d;
                        Double keguanScore = 0d;
                        int keSize = 0;
                        int zhuSize = 0;
                        int wanchengSize = 0;
                        for (DubanScoreRecord record : taskScoreRecordS.getValue()) {
                            String ke = record.getKeGuanScore();
                            if (!CommonUtils.isEmpty(ke)) {
                                keguanScore += Double.parseDouble(ke);
                                keSize++;
                            }
                            String zhu = record.getZhuGuanScore();
                            //去掉主动汇报的
                            if (!"-999".equals(zhu)) {
                                if (!CommonUtils.isEmpty(zhu)) {
                                    zhuguanScore += Double.parseDouble(zhu);
                                    zhuSize++;
                                }
                                String wan = record.getScore();
                                if (!CommonUtils.isEmpty(wan)) {
                                    wanchengScore += Double.parseDouble(wan);
                                    wanchengSize++;
                                }
                            }

                        }
                        LineData lineData = new LineData();
                        if (keSize > 0) {
                            keScore += (keguanScore / keSize);
                            lineData.setKeGuanScore(String.valueOf((keguanScore / keSize)));
                        }
                        if (zhuSize > 0) {
                            zhuguanScore = zhuguanScore / zhuSize;
                            lineData.setZhuguanScore(String.valueOf(zhuguanScore));
                        }
                        if (wanchengSize > 0) {
                            wanchengScore = wanchengScore / wanchengSize;
                            lineData.setWanchengScore(String.valueOf(wanchengScore));
                        }
                        if (keSize == 0) {
                            keSize = 1;
                        }
                        lineData.setTaskId(taskScoreRecordS.getKey());
                        lineDatas.add(lineData);
                        score += ((keguanScore / keSize) * (zhuguanScore / 100d) * (wanchengScore / 100d));
                    }
                    DubanStatData statData = new DubanStatData();
                    statData.setLineDatas(lineDatas);
                    statData.setDateParams(dateParams);
                    statData.setTaskScore(String.valueOf(score));
                    statData.setDeptId(String.valueOf(deptId));
                    statData.setDeptName(department.getName());
                    statData.setTaskCount("" + taskMaps.size());
                    //一个taskId一个然后累加
                    statData.setRenwuliang(String.valueOf(keScore));
                    statData.setTaskParams(CommonUtils.joinSet(taskMaps.keySet(), ","));

                    statData.setSummaryParams(CommonUtils.joinSet(summaryIdSet, ","));
                    statData.setTaskATypeCount("0");
                    statData.setWancheng("0%");
                    dataList.add(statData);
                } catch (Exception e) {
                    data.setCode("500");
                    data.setMsg(e.getMessage());
                    e.printStackTrace();
                    UIUtils.responseJSON(data, response);
                    return null;
                }

            }
        } else {
            data.setItems(new ArrayList());
            data.setCode("200");
            UIUtils.responseJSON(data, response);
            return null;
        }
        data.setItems(dataList);
        List<String> taskIdParams = new ArrayList<String>();
        for (DubanStatData statData : dataList) {
            taskIdParams.add(statData.getTaskParams());
        }
        List<DubanTask> taskList = dubanMainService.getStatDubanList(CommonUtils.join(taskIdParams, ","));
        //
        if (!CollectionUtils.isEmpty(taskList)) {
            //String levelA = ConfigFileService.getPropertyByName("ctp.group.task_level.A.enum");
            Map<String, String> taskAMap = new HashMap<String, String>();
            Map<String, String> finishMap = new HashMap<String, String>();
            Map<String, DubanTask> taskContainerMap = new HashMap<String, DubanTask>();
            for (DubanTask task : taskList) {
                if ("A".equals(task.getTaskLevel()) || String.valueOf(task.getTaskLevel()).startsWith("A")) {
                    taskAMap.put(task.getTaskId(), "1");
                }
                if ("100".equals(task.getMainProcess())) {
                    finishMap.put(task.getTaskId(), "1");
                }
                taskContainerMap.put(task.getTaskId(), task);
            }
            for (DubanStatData statData : dataList) {
                String taskIds = statData.getTaskParams();
                int a = 0;
                int f = 0;
                if (taskIds != null && !"".equals(taskIds)) {
                    String[] ids = taskIds.split(",");
                    for (String tid : ids) {
                        if (taskAMap.containsKey(tid)) {
                            a++;
                        }
                        if (finishMap.containsKey(tid)) {
                            f++;
                        }
                    }
                }
                List<LineData> lineDataList = statData.getLineDatas();
                if (!CollectionUtils.isEmpty(lineDataList)) {
                    for (LineData dots : lineDataList) {
                        String tid = dots.getTaskId();
                        DubanTask dtask = taskContainerMap.get(tid);
                        if (dtask != null) {
                            dots.setTaskLevelName(dtask.getTaskLevel());
                            dots.setTaskSourceName(dtask.getTaskSource());
                            dots.setAtype(taskAMap.containsKey(tid));
                            dots.setFinished(finishMap.containsKey(tid));

                        }
                    }


                }
                statData.setTaskATypeCount(String.valueOf(a));
                statData.setWancheng(String.valueOf(f));
            }

        }

        data.setCode("200");
        UIUtils.responseJSON(data, response);
        return null;

    }

    private List<DubanTask> getApprovingItemList() {

        String tableName = ConfigFileService.getPropertyByName("duban.task.approving.table.name");
        String templateNo = ConfigFileService.getPropertyByName("duban.task.approving.table.code");
        String sql = "SELECT id,form_recordid FROM col_summary WHERE templete_id = (select id from ctp_template where templete_number = '" + templateNo + "') and state=0";
        List<Map> dataMapList = DataBaseUtils.queryDataListBySQL(sql);
        if (!CollectionUtils.isEmpty(dataMapList)) {
            Map<String, String> keyMaps = new HashMap<String, String>();
            for (Map data : dataMapList) {
                // idMaps.put(String.valueOf(data.get("form_recordid")), String.valueOf(data.get("id")));
                keyMaps.put(String.valueOf(data.get("id")), String.valueOf(data.get("form_recordid")));
            }
            String affairSql = "select member_id,object_id from ctp_affair where state=3 and object_id in (" + CommonUtils.joinExtend(keyMaps.keySet(), ",") + ")";
            List<Map> affairDataList = DataBaseUtils.queryDataListBySQL(affairSql);
            if (!CommonUtils.isEmpty(affairDataList)) {
                Map<String, String> approvingAffairsMap = new HashMap<String, String>();

                for (Map affairData : affairDataList) {

                    approvingAffairsMap.put(String.valueOf(affairData.get("object_id")), String.valueOf(affairData.get("member_id")));
                }
                Map<String, String> recordIdMap = new HashMap<String, String>();
                for (String key : approvingAffairsMap.keySet()) {
                    String val = keyMaps.get(key);
                    if (!StringUtil.isEmpty(val)) {
                        recordIdMap.put(key, keyMaps.get(key));
                    }
                }
                if (!CollectionUtils.isEmpty(recordIdMap)) {
                    String formmainSql = "select * from " + tableName + " where id in (" + CommonUtils.joinExtend(recordIdMap.values(), ",") + ")";
                    // List<Map> dataList = DataBaseUtils.queryDataListBySQL(formmainSql);
                    FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
                    List<DubanTask> taskList = dubanMainService.translateDubanTask(formmainSql, ftd);
                    if (!CollectionUtils.isEmpty(taskList)) {
                        for (DubanTask task : taskList) {
                            task.setProcess("0");
                            task.setMainDeptName("");
                        }
                    }
                    return taskList;
                } else {
                    LOGGER.info("没有数据:" + affairSql);
                }

            } else {
                LOGGER.info("找不到数据:" + affairSql);
            }

        } else {
            return new ArrayList<DubanTask>(0);
        }
        return new ArrayList<DubanTask>(0);
    }

    @NeedlessCheckLogin
    public ModelAndView getApprovingTaskList(HttpServletRequest request, HttpServletResponse response) {
        try {
            List<DubanTask> retList = new ArrayList<DubanTask>();
            User user = getCurrentOrMockUser();
            List<DubanTask> taskList = getApprovingItemList();
            if (!CollectionUtils.isEmpty(taskList)) {
                for (DubanTask task : taskList) {
                    if (user.getName().equals(task.getSupervisor())) {
                        retList.add(task);
                    }
                }
            }

            UIUtils.responseJSON(retList, response);
        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

//    @NeedlessCheckLogin
//    public ModelAndView dataStat(HttpServletRequest request, HttpServletResponse response) {
//
//        CommonJSONResult commonJSONResult = new CommonJSONResult();
//        //0 成功 1失败
//        commonJSONResult.setStatus("0");
//        //成功无所谓，失败的话填失败的简单信息
//        commonJSONResult.setMsg("success");
//
//        //如果返回的结果是列表就是返回list 里边装对象
//        commonJSONResult.setItems(new ArrayList(0));
//        //如果单个数据就setData，setItems和setData 一般情况下只设置一个
//
//        Map data = new HashMap();
//        data.put("high", "10");
//        data.put("low", "20");
//        commonJSONResult.setData(data);
//
//        UIUtils.responseJSON(commonJSONResult, response);
//
//
//        return null;
//    }

    @NeedlessCheckLogin
    public ModelAndView getWatcherData(HttpServletRequest request, HttpServletResponse response) {
        User user = getCurrentOrMockUser();
        FormTableDefinition ftd = MappingService.getInstance().getFormTableDefinitionDByCode(MappingCodeConstant.DUBAN_TASK);
        String sql = "select * from " + ftd.getFormTable().getName() + " where (field0147 like '%" + user.getId() + "%' or field0147 like '%" + user.getName() + "%')";
        String state = request.getParameter("state");
        if ("RUNNING".equals(state)) {
            sql += " and (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + "!=100 or " + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + " is null)";
        }
        if ("DONE".equals(state)) {
            sql += " and (" + MappingCodeConstant.FIELD_DUBAN_WANCHENGLV_SUPERVISOR + "=100)";
        }
        //field0013
        List<DubanTask> taskList = dubanMainService.translateDubanTask(sql, ftd);
        UIUtils.responseJSON(doApprovingFilter(taskList), response);
        //field0147
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getDeptSimpleDataList(HttpServletRequest request, HttpServletResponse response) {
        User user = getCurrentOrMockUser();

        try {
            List<V3xOrgDepartment> deptList = getOrgManager().getAllDepartments(user.getAccountId());
            List<Map> simpleDeptList = new ArrayList<Map>();
            for (V3xOrgDepartment dept : deptList) {
                Map map = new HashMap();

                String name = dept.getName();
                String sid = String.valueOf(dept.getId());
                Long sort = dept.getSortId();
                map.put("title", name);
                map.put("value", sid);
                map.put("sort", sort);
                simpleDeptList.add(map);

            }
            UIUtils.responseJSON(simpleDeptList, response);
        } catch (BusinessException e) {
            e.printStackTrace();
            UIUtils.responseJSON(new ArrayList(), response);
        }

        //  UIUtils.responseJSON(taskList, response);
        //field0147
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getSimpleDataDubanTask(HttpServletRequest request, HttpServletResponse response) {

        String taskId = request.getParameter("taskId");
        CommonJSONResult ret = new CommonJSONResult();
        try {
            DubanTask task = getDubanScoreManager().getKeGuanScoreByCurrentUser(taskId);
            if (task == null) {
                ret.setStatus("0");
            } else {
                ret.setStatus("1");
                ret.setData(task);
            }
        } catch (Exception e) {

            e.printStackTrace();
        }

        UIUtils.responseJSON(ret, response);
        //field0147
        return null;
    }

}