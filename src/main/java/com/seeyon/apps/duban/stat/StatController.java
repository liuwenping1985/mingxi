package com.seeyon.apps.duban.stat;

import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.po.SlaveDubanTask;
import com.seeyon.apps.duban.service.DubanMainService;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.duban.util.UIUtils;
import com.seeyon.apps.duban.vo.CommonJSONResult;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

public class StatController extends BaseController {

    private static final Logger LOGGER = Logger.getLogger(StatController.class);

    private DubanMainService dubanMainService = DubanMainService.getInstance();

    private StatMainService statMainService = StatMainService.getInstance();

    private FieldName2Field00xxUtils fieldName2Field00xxUtils = FieldName2Field00xxUtils.getInstance_db();

    private Map getParameterMap(HttpServletRequest request) {
        Map map = new HashMap();
        List<String> taskSourceList = new ArrayList<String>();
        List<String> taskLevelList = new ArrayList<String>();
        List<String> deptIdList = new ArrayList<String>();
        Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String name = params.nextElement();
            String val = request.getParameter(name);
            if(val==null){
                continue;
            }

            if (name.startsWith("taskSource")) {
                String tid = "'"+val+"'";
                taskSourceList.add(tid);
            }else if(name.startsWith("taskLevel")){
                String tid = "'"+val+"'";
                taskLevelList.add(tid);
            }else if(name.equals("deptValue")){
                if(!StringUtils.isEmpty(val)){
                    String[] ids = val.split(",");
                    for(String tempId:ids){
                        if(!StringUtils.isEmpty(tempId)){
                            deptIdList.add("'"+tempId+"'");
                        }
                    }
                }
            }else{
                map.put(name,val);
            }

        }
        map.put("taskSource",taskSourceList);
        map.put("taskLevel",taskLevelList);
        map.put("deptId",deptIdList);
        return map;


    }

    @NeedlessCheckLogin
    public ModelAndView dataStat4Pie(HttpServletRequest request, HttpServletResponse response) {

        Map params = getParameterMap(request);
        List taskSource = (List)params.get("taskSource");
        List taskLevel = (List)params.get("taskLevel");
        String startDate = (String)params.get("time_min");
        String endDate = (String)params.get("time_max");
        List deptId = (List)params.get("deptId");

        StringBuffer whereSql = new StringBuffer(" where 1=1");

        if (!CommonUtils.isEmpty(taskSource)) {
            String field00xx = fieldName2Field00xxUtils.getField00xx("任务来源");
            whereSql.append(" and ").append(field00xx).append("  in(").append(CommonUtils.joinExtend(taskSource,",")).append(")");
        }

        if (!CommonUtils.isEmpty(taskLevel)) {
            String field00xx = fieldName2Field00xxUtils.getField00xx("任务分级");
            whereSql.append(" and ").append(field00xx).append("  in(").append(CommonUtils.joinExtend(taskLevel,",")).append(")");
        }

        if (!CommonUtils.isEmpty(startDate)) {
            // field00xx = fieldName2Field00xxUtils.getField00xx("任务ID");//从任务ID就能得到立项时间。
            whereSql.append(" and approve_date>='").append(startDate).append("'");
        }

        if (!CommonUtils.isEmpty(endDate)) {
            // field00xx = fieldName2Field00xxUtils.getField00xx("任务ID");//从任务ID就能得到立项时间。
            whereSql.append(" and approve_date<='").append(endDate).append("'");
        }

        if (!CommonUtils.isEmpty(deptId)) {
            String field00xx = fieldName2Field00xxUtils.getField00xx("承办部门名称");
            whereSql.append(" and (").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门0");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门1");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门2");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门3");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门4");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门5");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门6");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门7");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门8");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门9");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append("))");
        }
        List<DubanTask> dubanTasks = statMainService.getDubanTaskBySql(whereSql.toString());

        System.out.println("饼图查询结果集大小=" + dubanTasks.size());
        StatPieChart statPieChart = sorting4Pie(dubanTasks);

        CommonJSONResult commonJSONResult = new CommonJSONResult();
        //0 成功 1失败
        commonJSONResult.setStatus("0");
        //成功无所谓，失败的话填失败的简单信息
        commonJSONResult.setMsg("success");

        //如果返回的结果是列表就是返回list 里边装对象
        //commonJSONResult.setItems(new ArrayList(0));
        //如果单个数据就setData，setItems和setData 一般情况下只设置一个
        commonJSONResult.setData(statPieChart);
        UIUtils.responseJSON(commonJSONResult, response);
        return null;
    }


    @NeedlessCheckLogin
    public ModelAndView dataStat4Bar(HttpServletRequest request, HttpServletResponse response) {
        String period = request.getParameter("period");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String deptIds = request.getParameter("deptId");
        List deptId = new ArrayList();
        if(!StringUtils.isEmpty(deptIds)){
            String[] ids = deptIds.split(",");
            for(String tempId:ids){
                if(!StringUtils.isEmpty(tempId)){
                    deptId.add("'"+tempId+"'");
                }
            }
        }

        String sortType = request.getParameter("sortType");

        if (period.equalsIgnoreCase(Constance.DAY))//本日
        {
            startDate = DateUtils.getToday();
            endDate = startDate;
        } else if (period.equalsIgnoreCase(Constance.WEEK))//本周
        {
            startDate = DateUtils.getWeekStart();
            endDate = DateUtils.getWeekEnd();
        } else if (period.equalsIgnoreCase(Constance.MONTH))//本月
        {
            startDate = DateUtils.getMonthStart();
            endDate = DateUtils.getMonthEnd();
        } else if (period.equalsIgnoreCase(Constance.YEAR))//本年
        {
            startDate = DateUtils.getYearStart();
            endDate = DateUtils.getYearEnd();
        }

        StringBuffer whereSql = new StringBuffer(" where 1=1");

        if (!CommonUtils.isEmpty(startDate)) {
            //field00xx = fieldName2Field00xxUtils.getField00xx("立项时间");
            whereSql.append(" and approve_date >='").append(startDate).append("'");
        }

        if (!CommonUtils.isEmpty(endDate)) {
            //field00xx = fieldName2Field00xxUtils.getField00xx("立项时间");
            whereSql.append(" and approve_date <='").append(endDate).append("'");
        }

        if (!CommonUtils.isEmpty(deptId)) {
            String field00xx = fieldName2Field00xxUtils.getField00xx("承办部门名称");
            whereSql.append(" and (").append(field00xx).append(" in(").append(deptId).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门0");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门1");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门2");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门3");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门4");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门5");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门6");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门7");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门8");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append(")");
            field00xx = fieldName2Field00xxUtils.getField00xx("配合部门9");
            whereSql.append(" or ").append(field00xx).append(" in(").append(CommonUtils.joinExtend(deptId,",")).append("))");
        }
        List<DubanTask> dubanTasks = statMainService.getDubanTaskBySql(whereSql.toString());

        Map<String, StatBarBo> dataMap = getDataMap4Bar(dubanTasks);
        sorting4Bar(dataMap, sortType);

        CommonJSONResult commonJSONResult = new CommonJSONResult();
        //0 成功 1失败
        commonJSONResult.setStatus("0");
        //成功无所谓，失败的话填失败的简单信息
        commonJSONResult.setMsg("success");

        commonJSONResult.setData(dataMap);

        UIUtils.responseJSON(commonJSONResult, response);
        return null;
    }

    private StatPieChart sorting4Pie(List<DubanTask> dubanTasks) {
        //左边的饼图
        List doneOntimeList = new ArrayList();
        List doneDelayList = new ArrayList();
        List doingNowList = new ArrayList();

        //右边的饼图
        List doingNormalList = new ArrayList();
        List doingLowRiskList = new ArrayList();
        List doingMediumRiskList = new ArrayList();
        List doingHighRiskList = new ArrayList();
        List garbageList = new ArrayList();
        for (DubanTask task : dubanTasks) {
            if (task.getFinishDate() != null && task.getProcess().equals("100"))//这个要所有的涉及到部门包括承办和配合都需要完成。
            {
                String field00xx = fieldName2Field00xxUtils.getField00xx("任务ID");
                List delayApplyList = statMainService.getDelayAppByTaskId(" where "+field00xx+"='" + task.getTaskId() + "'");
                if (!CommonUtils.isEmpty(delayApplyList)) {
                    doneDelayList.add(task);//延期完成
                } else {
                    doneOntimeList.add(task);//按时完成
                }
            } else {
                doingNowList.add(task);
                String lightStr = task.getTaskLight();
                if (lightStr != null) {
                    if (lightStr.equals("正常推进")) {
                        doingNormalList.add(task);
                    } else if (lightStr.equals("低风险")) {
                        doingLowRiskList.add(task);
                    } else if (lightStr.equals("有风险但可控")) {
                        doingMediumRiskList.add(task);
                    } else if (lightStr.equals("风险不可控,不能按期完成")) {
                        doingHighRiskList.add(task);
                    } else {
                        garbageList.add(task);
                    }
                } else {//看下一次都没有汇报，那任务默认的状态是啥
                    doingNormalList.add(task);
                }
            }
        }
        StatPieChart statPieChart = new StatPieChart();
        statPieChart.setDoneOntime(doneOntimeList.size() + "");
        statPieChart.setDoneDelay(doneDelayList.size() + "");
        statPieChart.setDoingNow(doingNowList.size() + "");

        statPieChart.setDoingNormal(doingNormalList.size() + "");
        statPieChart.setDoingLowRisk(doingLowRiskList.size() + "");
        statPieChart.setDoingMediumRisk(doingMediumRiskList.size() + "");
        statPieChart.setDoingHighRisk(doingHighRiskList.size() + "");
        return statPieChart;
    }

    private void sorting4Bar(Map<String, StatBarBo> dataMap, String sortType) {
        List<Map.Entry<String, StatBarBo>> infoIds =
                new ArrayList<Map.Entry<String, StatBarBo>>(dataMap.entrySet());

        //工作量
        if (sortType.equalsIgnoreCase(Constance.WORKLOAD)) {
            Collections.sort(infoIds, new Comparator<Map.Entry<String, StatBarBo>>() {
                public int compare(Map.Entry<String, StatBarBo> o1, Map.Entry<String, StatBarBo> o2) {
                    Double d2 = o2.getValue().getWorkload();
                    Double d1 = o1.getValue().getWorkload();
                    return (d2.compareTo(d1));
                }
            });
        }
        //任务数
        else if (sortType.equalsIgnoreCase(Constance.TASKNUM)) {
            Collections.sort(infoIds, new Comparator<Map.Entry<String, StatBarBo>>() {
                public int compare(Map.Entry<String, StatBarBo> o1, Map.Entry<String, StatBarBo> o2) {
                    int d2 = o2.getValue().getTaskNum();
                    int d1 = o1.getValue().getTaskNum();
                    return (d2 - d1);
                }
            });
        }
        //完成率
        else if (sortType.equalsIgnoreCase(Constance.COMPLETIONRATE)) {
            Collections.sort(infoIds, new Comparator<Map.Entry<String, StatBarBo>>() {
                public int compare(Map.Entry<String, StatBarBo> o1, Map.Entry<String, StatBarBo> o2) {
                    Double d2 = o2.getValue().getCompletionRate();
                    Double d1 = o1.getValue().getCompletionRate();
                    return d2.compareTo(d1);
                }
            });
        }
        //完成分
        else if (sortType.equalsIgnoreCase(Constance.COMPLETIONSCORE)) {
            Collections.sort(infoIds, new Comparator<Map.Entry<String, StatBarBo>>() {
                public int compare(Map.Entry<String, StatBarBo> o1, Map.Entry<String, StatBarBo> o2) {
                    int d2 = o2.getValue().getCompletionNum();
                    int d1 = o1.getValue().getCompletionNum();
                    return d2 - d1;
                }
            });
        }
    }

    private Map<String, StatBarBo> getDataMap4Bar(List<DubanTask> dubanTasks) {
        Map<String, StatBarBo> dataMap = new HashMap<String, StatBarBo>();
        for (DubanTask task : dubanTasks) {
            SplitDubanTask splitMain = new SplitDubanTask();
            splitMain.setTaskId(task.getTaskId());
            if (task.getMainDeptName() == null || task.getMainDeptName().equals("")) {
                continue; //承办部门怎么会有空，也许正在立项没走完。
            }
            splitMain.setDeptName(task.getMainDeptName());
            System.out.println("主负责部门=" + task.getMainDeptName());
            splitMain.setIsMainRole(1);
            splitMain.setTaskLevel(task.getTaskLevel());
            System.out.println("任务级别=" + task.getTaskLevel());
            splitMain.setTaskSource(task.getTaskSource());
            System.out.println("任务来源=" + task.getTaskSource());
            splitMain.setIsFinish(task.getProcess().equals("100") == true ? 1 : 0);
            splitMain.calKgScore();//计算工作量
            splitMain.setFinishScore(task.getTotoalScore() == null ? 0 : task.getTotoalScore());//填充完成分

            StatBarBo statBarBo = dataMap.get(task.getMainDeptName());
            if (statBarBo == null) {
                statBarBo = new StatBarBo();
            }
            statBarBo.add(splitMain);
            dataMap.put(task.getMainDeptName(), statBarBo);


            List<SlaveDubanTask> list = task.getSlaveDubanTaskList();
            for (SlaveDubanTask slaveDubanTask : list) {
                SplitDubanTask splitSub = new SplitDubanTask();
                splitSub.setTaskId(task.getTaskId());
                if (slaveDubanTask.getDeptName() == null ||
                        slaveDubanTask.getDeptName().equals("")) {
                    continue;
                }
                splitSub.setDeptName(slaveDubanTask.getDeptName());
                System.out.println("配合部门名称=" + slaveDubanTask.getDeptName());
                splitSub.setIsMainRole(0);
                splitSub.setTaskLevel(task.getTaskLevel());
                splitSub.setTaskSource(task.getTaskSource());
                splitSub.calKgScore();
                splitSub.setIsFinish(splitMain.getIsFinish());//配合任务完成，需要看主任务是否完成，这个是否合理，需要讨论
                splitSub.setFinishScore(0);//配合没有完成分，这个讨论一下，这个需要讨论。

                statBarBo = dataMap.get(slaveDubanTask.getDeptName());
                if (statBarBo == null) {
                    statBarBo = new StatBarBo();
                }
                statBarBo.add(splitSub);
                dataMap.put(slaveDubanTask.getDeptName(), statBarBo);
            }
        }
        return dataMap;
    }


}
