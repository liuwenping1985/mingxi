package com.seeyon.apps.duban.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.apps.duban.po.DubanConfigItem;
import com.seeyon.apps.duban.po.DubanScoreRecord;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.po.SlaveDubanTask;
import com.seeyon.apps.duban.service.ConfigFileService;
import com.seeyon.apps.duban.service.DubanMainService;
import com.seeyon.apps.duban.service.MappingService;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.util.DataBaseUtils;
import com.seeyon.apps.duban.util.SendMessageUtils;
import com.seeyon.apps.duban.util.UIUtils;
import com.seeyon.apps.duban.vo.CommonJSONResult;
import com.seeyon.apps.duban.vo.DubanBaseInfo;
import com.seeyon.apps.duban.vo.DubanStatData;
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
import org.apache.log4j.Logger;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
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

    public ModelAndView getPreProcessProperties(HttpServletRequest request, HttpServletResponse response) {

        User user = AppContext.getCurrentUser();
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

            SendMessageUtils.sendMessage(user.getId(), ids, deptName + "-" + user.getName() + "(" + dateStr + "):" + opinion.trim(), "");
        } catch (Exception e) {
            e.printStackTrace();
            cjr.setStatus("0");
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
                String curDeptId = String.valueOf(AppContext.getCurrentUser().getDepartmentId());
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
    public ModelAndView getStatDataDetail(HttpServletRequest request, HttpServletResponse response){
        CommonJSONResult data = new CommonJSONResult();
        String ids = request.getParameter("taskIds");
        List<DubanTask> taskList = dubanMainService.getStatDubanList(ids);
        data.setItems(taskList);
        data.setCode("200");
        UIUtils.responseJSON(data, response);
        return null;

    }

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
        StringBuilder sql = new StringBuilder("from DubanScoreRecord where 1=1 ");
        Map params = new HashMap();
        if (start != null) {
            sql.append("and createDate>:createDate");
            params.put("createDate", start);
        }
        if (end != null) {
            sql.append("and createDate>:endDate");
            params.put("endDate", end);
        }


        List<DubanScoreRecord> dsrList = DBAgent.find(sql.toString(), params);
        //
        List<DubanStatData> dataList = new ArrayList<DubanStatData>();
        Map<Long, List<DubanScoreRecord>> deptDubanScoreRecordMap = new HashMap<Long, List<DubanScoreRecord>>();
        if (!CommonUtils.isEmpty(dsrList)) {

            for (DubanScoreRecord record : dsrList) {
                if("-999".equals(record.getZhuGuanScore())){
                    continue;
                }
                Long deptId = record.getDepartmentId();
                List<DubanScoreRecord> rList = deptDubanScoreRecordMap.get(deptId);
                if (rList == null) {
                    rList = new ArrayList<DubanScoreRecord>();
                    deptDubanScoreRecordMap.put(deptId, rList);
                }
                rList.add(record);
            }
            String dateParams = JSON.toJSONString(params);
            String sqlTask = "select * from ";
            for(Map.Entry<Long,List<DubanScoreRecord>> entry:deptDubanScoreRecordMap.entrySet()){
                Long deptId = entry.getKey();
                List<DubanScoreRecord> recordList = entry.getValue();
                Map<String,List<DubanScoreRecord>> taskMaps = new HashMap<String, List<DubanScoreRecord>>();
                for(DubanScoreRecord record:recordList){
                    List<DubanScoreRecord> taskList = taskMaps.get(record.getTaskId());
                    if(taskList==null){
                        taskList = new ArrayList<DubanScoreRecord>();
                        taskMaps.put(record.getTaskId(),taskList);
                    }
                    taskList.add(record);
                }
                try {
                    V3xOrgDepartment department =  getOrgManager().getDepartmentById(deptId);
                    //计算分数
                    Set summaryIdSet = new HashSet();
                    Double score =0d;
                    Double keScore = 0d;
                    for(Map.Entry<String,List<DubanScoreRecord>> taskScoreRecordS:taskMaps.entrySet()){
                       for(DubanScoreRecord record:taskScoreRecordS.getValue()){
                           String ke = record.getKeGuanScore();

                           String zhu = record.getZhuGuanScore();
                           if(!CommonUtils.isEmpty(ke)){
                               score+=Double.parseDouble(ke);
                               keScore+=Double.parseDouble(ke);
                           }
                           if(!CommonUtils.isEmpty(zhu)){
                               score+=Double.parseDouble(zhu);
                           }


                       }
                    }
                    DubanStatData statData = new DubanStatData();
                    statData.setDateParams(dateParams);
                    statData.setTaskScore(String.valueOf(score));
                    statData.setDeptId(String.valueOf(deptId));
                    statData.setDeptName(department.getName());
                    statData.setTaskCount(""+taskMaps.size());
                    statData.setRenwuliang(String.valueOf(keScore));
                    statData.setTaskParams(CommonUtils.joinSet(taskMaps.keySet(),","));

                    statData.setSummaryParams(CommonUtils.joinSet(summaryIdSet,","));
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
        }
        data.setItems(dataList);
        List<String>taskIdParams = new ArrayList<String>();
        for(DubanStatData statData:dataList){
            taskIdParams.add(statData.getTaskParams());
        }
        List<DubanTask> taskList = dubanMainService.getStatDubanList(CommonUtils.join(taskIdParams,","));
        //
        if(!CollectionUtils.isEmpty(taskList)){
            //String levelA = ConfigFileService.getPropertyByName("ctp.group.task_level.A.enum");
            Map<String,String> taskAMap = new HashMap<String, String>();
            Map<String,String> finishMap = new HashMap<String, String>();
            for(DubanTask task:taskList){
                if("A".equals(task.getTaskLevel())){
                    taskAMap.put(task.getTaskId(),"1");
                }
                if("100".equals(task.getMainProcess())){
                    finishMap.put(task.getTaskId(),"1");
                }
            }
            for(DubanStatData statData:dataList){
                String taskIds = statData.getTaskParams();
                int a = 0;
                int f = 0;
                if(taskIds!=null&&!"".equals(taskIds)){
                    String[] ids = taskIds.split(",");
                    for(String tid:ids){
                        if(taskAMap.containsKey(tid)){
                            a++;
                        }
                        if(finishMap.containsKey(tid)){
                            f++;
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
}