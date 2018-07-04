package com.seeyon.ctp.portal.section;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.agent.bo.AgentModel;
import com.seeyon.apps.agent.utils.AgentUtil;
import com.seeyon.apps.collaboration.manager.PendingManager;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.apps.edoc.enums.EdocEnum.edocType;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairCondition;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.portal.po.StatisticalChart;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.portal.space.manager.PortletEntityPropertyManager;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;

import java.net.URI;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

public class PendingController
        extends BaseController
{
    private static final Log log = LogFactory.getLog(PendingController.class);
    private PortletEntityPropertyManager portletEntityPropertyManager;
    private PendingManager pendingManager;
    private AffairManager affairManager;
    private EdocApi edocApi;

    public void setPortletEntityPropertyManager(PortletEntityPropertyManager portletEntityPropertyManager)
    {
        this.portletEntityPropertyManager = portletEntityPropertyManager;
    }

    public void setPendingManager(PendingManager pendingManager)
    {
        this.pendingManager = pendingManager;
    }

    public void setAffairManager(AffairManager affairManager)
    {
        this.affairManager = affairManager;
    }

    public void setEdocApi(EdocApi edocApi)
    {
        this.edocApi = edocApi;
    }

    public ModelAndView transPendingMain(HttpServletRequest request, HttpServletResponse response)
            throws Exception
    {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/pendingMain");
        User user = AppContext.getCurrentUser();
        Long memberId = user.getId();
        Long fragmentId = Long.valueOf(Long.parseLong(request.getParameter("fragmentId")));
        String sectionId = request.getParameter("sectionId");
        modelAndView.addObject("sectionId", sectionId);
        String ordinal = request.getParameter("ordinal");
        List<String> graphicalList = new ArrayList();
        int pageSize = 8;
        int width = 0;
        String widthStr = request.getParameter("width");
        if (Strings.isNotBlank(widthStr)) {
            width = Integer.valueOf(widthStr).intValue();
        }
        Map<String, String> preference = this.portletEntityPropertyManager.getPropertys(fragmentId, ordinal);

        String graphical = (String)preference.get("graphical_value");
        if (Strings.isBlank(graphical)) {
            graphical = "importantLevel,overdue,handlingState,handleType";
        }
        String[] graphicalArr = graphical.split(",");
        graphicalList = Arrays.asList(graphicalArr);

        String remindDays = (String)preference.get("dueToRemind");
        Integer dueToRemind = Integer.valueOf(0);
        if (Strings.isNotBlank(remindDays)) {
            dueToRemind = Integer.valueOf((String)preference.get("dueToRemind"));
        }
        String currentPanel = SectionUtils.getPanel("all", preference);

        String rowStr = (String)preference.get("rowList");

        String countStr = (String)preference.get("count");
        if (Strings.isNotBlank(countStr)) {
            pageSize = Integer.parseInt(countStr);
        }
        String columnsStyle = (String)Strings.escapeNULL(preference.get("columnStyle"), "orderList");
        if (columnsStyle.equals("doubleList")) {
            columnsStyle = "orderList";
        }
        if (Strings.isBlank(rowStr)) {
            rowStr = "subject,receiveTime,sendUser,category";
        }
        List<String> columnHeaderList = new ArrayList();
        String[] rows = rowStr.split(",");
        for (String row : rows) {
            columnHeaderList.add(row.trim());
        }
        Object affairs = null;
        if ("agentSection".equals(sectionId))
        {
            columnsStyle = "orderList";
            currentPanel = "agent";

            AffairCondition condition = new AffairCondition(memberId, StateEnum.col_pending, new ApplicationCategoryEnum[0]);
            Object[] agentObj = AgentUtil.getUserAgentToMap(memberId);
            boolean agentToFlag = ((Boolean)agentObj[0]).booleanValue();
            Map<Integer, List<AgentModel>> map = (Map)agentObj[1];
            condition.setAgent(Boolean.valueOf(agentToFlag), map);

            FlipInfo fi = new FlipInfo();
            fi.setNeedTotal(false);
            fi.setPage(1);
            fi.setSize(pageSize);
            fi.setSortField("receiveTime");
            fi.setSortOrder("desc");

            affairs = condition.getAgentPendingAffair(this.affairManager, fi);
        }
        else
        {
            //System.out.println("test1");
           // System.out.println("test:"+this.pendingManager==null);
           // System.out.println("memberId:"+memberId);
          //  System.out.println("fragmentId:"+fragmentId);
           // System.out.println("ordinal:"+ordinal);
            affairs = getPendingList222(memberId, fragmentId, ordinal);
           // System.out.println("test2");
        }
        Object rowList = this.pendingManager.affairList2PendingRowList((List)affairs, false, false, user, currentPanel, true, rowStr);
       // System.out.println("test2");
        PendingRow pr1 = new PendingRow();
        int count = pageSize - ((List)rowList).size();
        for (int j = 0; j < count; j++) {
            ((List)rowList).add(pr1);
        }
       // System.out.println("((List)rowList).size():"+((List)rowList).size());
        Map<String,CtpAffair> outSideAffair = new HashMap<String,CtpAffair>();

        if(affairs!=null) {
            List<CtpAffair> affairList=(List<CtpAffair>)affairs;
            //System.out.println("((List)affairList).size():"+affairList.size());
            for (int k = 0; k < affairList.size(); k++) {
                CtpAffair affair = (CtpAffair)affairList.get(k);
               // System.out.println("affair.getExtraMap()"+JSON.toJSONString(affair.getExtraMap()));
               // System.out.println("affair.getExtraAttr(outside_affair):"+affair.getExtraAttr("outside_affair"));
                if("YES".equals(affair.getExtraAttr("outside_affair"))){
                    outSideAffair.put(String.valueOf(affair.getId()),affair);
                }else{

                    if(affair.getObjectId()!=null&&affair.getObjectId().equals( Long.valueOf(0L))){
                        outSideAffair.put(String.valueOf(affair.getId()),affair);
                    }

                }
            }
        }

        for(int i=0;i<((List)rowList).size();i++){
            PendingRow row = ((List<PendingRow>)rowList).get(i);
            Long id = row.getId();

            if(id == null){
                continue;
            }
            CtpAffair affair = outSideAffair.get(String.valueOf(id));
            if(affair!=null){
                row.setLink("/datakit/outaffair.do?method=openPending&affId="+affair.getId()+"&url="+ URLEncoder.encode(affair.getAddition(),"utf-8"));
            }
        }

        modelAndView.addObject("rowList1", rowList);
        modelAndView.addObject("pageSize", Integer.valueOf(pageSize));
        modelAndView.addObject("dueToRemind", dueToRemind);
        modelAndView.addObject("columnsStyle", columnsStyle);
        modelAndView.addObject("graphicalList", graphicalList);
        modelAndView.addObject("columnHeaderList", columnHeaderList);
        modelAndView.addObject("currentPanel", currentPanel);
        modelAndView.addObject("fragmentId", fragmentId);
        modelAndView.addObject("ordinal", ordinal);
        modelAndView.addObject("width", Integer.valueOf(width));
        modelAndView.addObject("memberId", memberId);
        modelAndView.addObject("orgId", user.getAccountId());
        return modelAndView;
    }

    public List<CtpAffair> getPendingList222(Long memberId, Long fragmentId, String ordinal) {
        System.out.println("test3");
        try {
            Map<String, String> preference = this.portletEntityPropertyManager.getPropertys(fragmentId, ordinal);
            System.out.println("test4");
            System.out.println(preference);
            return getPublicPendingList222(memberId, preference);
        }catch(Exception e){
            e.printStackTrace();
        }
        return new ArrayList<CtpAffair>();
    }

    public List<CtpAffair> getPublicPendingList222(Long memberId, Map<String, String> preference) {
        System.out.println("test5");
        String currentPanel = SectionUtils.getPanel("all", preference);
        System.out.println("test6");
        AffairCondition condition = getPendingSectionAffairCondition222(memberId, preference);
        System.out.println("test110");
        int pageSize = 8;
        String countStr = (String)preference.get("count");
        if (Strings.isNotBlank(countStr)) {
            pageSize = Integer.parseInt(countStr);
        }

        String columnStyle = (String)preference.get("columnStyle");
        if ("doubleList".equals(columnStyle)) {
            pageSize *= 2;
        }

        FlipInfo fi = new FlipInfo();
        fi.setNeedTotal(false);
        fi.setPage(1);
        fi.setSize(pageSize);
        List<Integer> appEnum = new ArrayList();
        System.out.println("test7");
        if ("sender".equals(currentPanel)) {
            System.out.println("test8");
            String tempStr = (String)preference.get(currentPanel + "_value");
            return (List)this.affairManager.getAffairListBySender(memberId, tempStr, condition, false, fi, appEnum, new String[0]);
        } else {
            fi.setSortField("receiveTime");
            fi.setSortOrder("desc");
            System.out.println("test9");
            return condition.getPendingAffair(this.affairManager, fi);
        }
    }
    private AffairCondition getPendingSectionAffairCondition222(Long memberId, Map<String, String> preference) {
        String currentPanel = SectionUtils.getPanel("all", preference);
        String isFromMore = (String)preference.get("isFromMore");
        boolean fromMore = false;
        if (Strings.isNotBlank(isFromMore)) {
            fromMore = Boolean.valueOf(fromMore);
        }

        Object[] agentObj = AgentUtil.getUserAgentToMap(memberId);
        boolean agentToFlag = (Boolean)agentObj[0];
        Map<Integer, List<AgentModel>> ma = (Map)agentObj[1];
        AffairCondition condition = new AffairCondition(memberId, StateEnum.col_pending, new ApplicationCategoryEnum[]{ApplicationCategoryEnum.collaboration, ApplicationCategoryEnum.edoc, ApplicationCategoryEnum.meeting, ApplicationCategoryEnum.bulletin, ApplicationCategoryEnum.news, ApplicationCategoryEnum.inquiry, ApplicationCategoryEnum.office, ApplicationCategoryEnum.info, ApplicationCategoryEnum.meetingroom, ApplicationCategoryEnum.edocRecDistribute, ApplicationCategoryEnum.infoStat});
        if (!"all".equals(currentPanel)) {
            if ("overTime".equals(currentPanel)) {
                condition.addSearch(AffairCondition.SearchCondition.overTime, (String)null, (String)null, fromMore);
            } else if ("freeCol".equals(currentPanel)) {
                condition.addSearch(AffairCondition.SearchCondition.catagory, "catagory_coll", (String)null, fromMore);
            } else if (!"agent".equals(currentPanel)) {
                if (Strings.isNotBlank(currentPanel) && "sources".equals(currentPanel)) {
                    condition.addSourceSearchCondition(preference, fromMore);
                } else {
                    String tempStr = (String)preference.get(currentPanel + "_value");
                    if (!Strings.isBlank(tempStr) && !"null".equalsIgnoreCase(tempStr)) {
                        if ("templete_pending".equals(currentPanel)) {
                            condition.addSearch(AffairCondition.SearchCondition.templete, tempStr, (String)null, fromMore);
                        } else if ("Policy".equals(currentPanel)) {
                            condition.addSearch(AffairCondition.SearchCondition.policy4Portal, tempStr, (String)null, fromMore);
                        } else if ("importLevel".equals(currentPanel)) {
                            condition.addSearch(AffairCondition.SearchCondition.importLevel, tempStr, (String)null, fromMore);
                        } else if ("catagory".equals(currentPanel)) {
                            condition.addSearch(AffairCondition.SearchCondition.catagory, tempStr, (String)null, fromMore);
                        } else if ("track_catagory".equals(currentPanel)) {
                            condition.addSearch(AffairCondition.SearchCondition.catagory, tempStr, (String)null, fromMore);
                        } else if ("handlingState".equals(currentPanel)) {
                            condition.addSearch(AffairCondition.SearchCondition.handlingState, tempStr, (String)null, fromMore);
                        }
                    }
                }
            }
        }

        condition.setAgent(agentToFlag, ma);
        return condition;
    }

    public ModelAndView showTestChart(HttpServletRequest request, HttpServletResponse response)
            throws Exception
    {
        ModelAndView mav = new ModelAndView("apps/report/chart/testChart");
        return mav;
    }

    public ModelAndView morePending(HttpServletRequest request, HttpServletResponse response)
            throws Exception
    {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/morePending");
        FlipInfo fi = new FlipInfo();
        String fragmentId = request.getParameter("fragmentId");
        String ordinal = request.getParameter("ordinal");
        String rowStr = request.getParameter("rowStr");
        String columnsName = request.getParameter("columnsName");
        if (Strings.isBlank(rowStr)) {
            rowStr = "subject,receiveTime,sendUser,category";
        }
        Map<String, Object> query = new HashMap();
        query.put("fragmentId", fragmentId);
        query.put("ordinal", ordinal);
        query.put("state", Integer.valueOf(StateEnum.col_pending.key()));
        query.put("isTrack", Boolean.valueOf(false));
        if (Strings.equals(request.getParameter("from"), "Agent"))
        {
            query.put("rowStr", rowStr);
            this.pendingManager.getMoreAgentList4SectionContion(fi, query);
        }
        else
        {
            if (Strings.isNotBlank(request.getParameter("myRemind"))) {
                query.put("myRemind", request.getParameter("myRemind"));
            }
            this.pendingManager.getMoreList4SectionContion(fi, query);
        }
        User user = AppContext.getCurrentUser();
        if (AppContext.hasPlugin("edoc"))
        {
            boolean isCreate = this.edocApi.isEdocCreateRole(user.getId(), user.getLoginAccount(), edocType.recEdoc.ordinal());
            modelAndView.addObject("isRegistRole", Boolean.valueOf(isCreate));
        }
        request.setAttribute("ffmoreList", fi);
        fi.setParams(query);
        modelAndView.addObject("params", query);
        modelAndView.addObject("columnsName", columnsName);
        modelAndView.addObject("total", Integer.valueOf(fi.getTotal()));
        if (Strings.isEmpty(fi.getData())) {
            log.info("数据量：" + fi.getTotal() + ",data=" + fi.getData());
        } else if ((fi.getData().get(0) instanceof PendingRow)) {
            log.info("数据量：" + fi.getTotal() + ",data=" + ((PendingRow)fi.getData().get(0)).getSubject());
        }
        modelAndView.addObject("rowStr", rowStr);

        ColUtil.putImportantI18n2Session();

        return modelAndView;
    }

    public ModelAndView showLeftList(HttpServletRequest request, HttpServletResponse response)
            throws Exception
    {
        User user = AppContext.getCurrentUser();
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/showLeftList");
        String dataName = request.getParameter("dataName");
        String pageSize = request.getParameter("pageSize");
        String columnHeaderStr = request.getParameter("columnHeaderStr");
        String currentPanel = request.getParameter("currentPanel");
        String _fragmentId = request.getParameter("fragmentId");
        Long fragmentId = Long.valueOf(_fragmentId);
        String ordinal = request.getParameter("ordinal");
        String sectionId = request.getParameter("sectionId");
        modelAndView.addObject("sectionId", sectionId);
        int width = 0;
        String widthStr = request.getParameter("width");
        if (Strings.isNotBlank(widthStr)) {
            width = Integer.valueOf(widthStr).intValue();
        }
        Map<String, String> preference = this.portletEntityPropertyManager.getPropertys(fragmentId, ordinal);
        Long memberId = user.getId();
        List<String> columnHeaderList = new ArrayList();
        String[] columnNames = columnHeaderStr.split(",");
        for (String c : columnNames) {
            columnHeaderList.add(c.trim());
        }
        int pageCount = 8;
        if (Strings.isNotBlank(pageSize)) {
            pageCount = Integer.valueOf(pageSize).intValue();
        }
        Object apps = new ArrayList();
        ((List)apps).add(ApplicationCategoryEnum.collaboration);
        ((List)apps).add(ApplicationCategoryEnum.edocSend);
        ((List)apps).add(ApplicationCategoryEnum.edocRec);
        ((List)apps).add(ApplicationCategoryEnum.edocSign);
        ((List)apps).add(ApplicationCategoryEnum.exSend);
        ((List)apps).add(ApplicationCategoryEnum.exSign);
        ((List)apps).add(ApplicationCategoryEnum.edocRegister);
        ((List)apps).add(ApplicationCategoryEnum.edocRecDistribute);
        ((List)apps).add(ApplicationCategoryEnum.meeting);
        ((List)apps).add(ApplicationCategoryEnum.bulletin);
        ((List)apps).add(ApplicationCategoryEnum.inquiry);
        ((List)apps).add(ApplicationCategoryEnum.news);
        ((List)apps).add(ApplicationCategoryEnum.office);
        ((List)apps).add(ApplicationCategoryEnum.info);

        FlipInfo fp = new FlipInfo();
        fp.setSize(pageCount);
        List<CtpAffair> affairList = new ArrayList();

        List<Integer> colEnums = new ArrayList();
        colEnums.add(Integer.valueOf(ApplicationCategoryEnum.collaboration.getKey()));
        List<Integer> edocEnums = new ArrayList();
        edocEnums.add(Integer.valueOf(ApplicationCategoryEnum.edocSend.getKey()));
        edocEnums.add(Integer.valueOf(ApplicationCategoryEnum.edocRec.getKey()));
        edocEnums.add(Integer.valueOf(ApplicationCategoryEnum.edocSign.getKey()));
        edocEnums.add(Integer.valueOf(ApplicationCategoryEnum.exSend.getKey()));
        edocEnums.add(Integer.valueOf(ApplicationCategoryEnum.exSign.getKey()));
        edocEnums.add(Integer.valueOf(ApplicationCategoryEnum.edocRegister.getKey()));
        edocEnums.add(Integer.valueOf(ApplicationCategoryEnum.edocRecDistribute.getKey()));

        fp.setSortField("receiveTime");
        fp.setSortOrder("desc");
        if ("pending".equals(dataName))
        {
            affairList = this.pendingManager.getPendingAffairList(fp, memberId, preference);
        }
        else if ("zcdb".equals(dataName))
        {
            affairList = this.pendingManager.getZcdbAffairList(fp, memberId, preference);
        }
        else if ("import3".equals(dataName))
        {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, colEnums, 3, memberId, preference);
        }
        else if ("import2".equals(dataName))
        {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, colEnums, 2, memberId, preference);
        }
        else if ("import1".equals(dataName))
        {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, colEnums, 1, memberId, preference);
        }
        else if ("overdue".equals(dataName))
        {
            affairList = this.pendingManager.getAffairsIsOverTime(fp, memberId, preference, true);
        }
        else if ("noOverdue".equals(dataName))
        {
            affairList = this.pendingManager.getAffairsIsOverTime(fp, memberId, preference, false);
        }
        else if ("teTi".equals(dataName))
        {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, edocEnums, 5, memberId, preference);
        }
        else if ("urgent".equals(dataName))
        {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, edocEnums, 4, memberId, preference);
        }
        else if ("expedited".equals(dataName))
        {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, edocEnums, 3, memberId, preference);
        }
        else if ("pingAnxious".equals(dataName))
        {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, edocEnums, 2, memberId, preference);
        }
        else if ("commonExigency".equals(dataName))
        {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, edocEnums, 1, memberId, preference);
        }
        else if ("zyxt".equals(dataName))
        {
            affairList = this.pendingManager.getCollAffairs(fp, memberId, preference, false);
        }
        else if ("xtbdmb".equals(dataName))
        {
            affairList = this.pendingManager.getCollAffairs(fp, memberId, preference, true);
        }
        else if ("shouWen".equals(dataName))
        {
            List<Integer> appEnums = new ArrayList();
            appEnums.add(Integer.valueOf(ApplicationCategoryEnum.edocRec.key()));
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        }
        else if ("faWen".equals(dataName))
        {
            List<Integer> appEnums = new ArrayList();
            appEnums.add(Integer.valueOf(ApplicationCategoryEnum.edocSend.key()));
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        }
        else if ("daiFaEdoc".equals(dataName))
        {
            List<Integer> appEnums = new ArrayList();
            appEnums.add(Integer.valueOf(ApplicationCategoryEnum.exSend.key()));
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        }
        else if ("daiQianShou".equals(dataName))
        {
            List<Integer> appEnums = new ArrayList();
            appEnums.add(Integer.valueOf(ApplicationCategoryEnum.exSign.key()));
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        }
        else if ("daiDengJi".equals(dataName))
        {
            List<Integer> appEnums = new ArrayList();
            appEnums.add(Integer.valueOf(ApplicationCategoryEnum.edocRegister.key()));
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        }
        else if ("qianBao".equals(dataName))
        {
            List<Integer> appEnums = new ArrayList();
            appEnums.add(Integer.valueOf(ApplicationCategoryEnum.edocSign.key()));
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        }
        else if ("huiYi".equals(dataName))
        {
            List<Integer> appEnums = new ArrayList();
            appEnums.add(Integer.valueOf(ApplicationCategoryEnum.meeting.key()));
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        }
        else if ("huiYiShi".equals(dataName))
        {
            List<Integer> appEnums = new ArrayList();
            appEnums.add(Integer.valueOf(ApplicationCategoryEnum.meetingroom.key()));
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        }
        else if ("daiShenPiGGXX".equals(dataName))
        {
            List<Integer> publicInfoEnums = new ArrayList();
            publicInfoEnums.add(Integer.valueOf(ApplicationCategoryEnum.news.getKey()));
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, publicInfoEnums);
        }
        else if ("daiShenPiZHBG".equals(dataName))
        {
            List<Integer> appEnums = new ArrayList();
            appEnums.add(Integer.valueOf(ApplicationCategoryEnum.office.key()));
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        }
        else if ("diaoCha".equals(dataName))
        {
            List<Integer> appEnums = new ArrayList();
            appEnums.add(Integer.valueOf(ApplicationCategoryEnum.inquiry.key()));
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        }
        List<PendingRow> rowList = this.pendingManager.affairList2PendingRowList(affairList, false, false, user, currentPanel, false, columnHeaderStr);

        List<PendingRow> rowList1 = rowList;
        PendingRow pr1 = new PendingRow();
        int count = pageCount - rowList.size();
        for (int j = 0; j < count; j++) {
            rowList1.add(pr1);
        }
        modelAndView.addObject("columnHeaderList", columnHeaderList);
        modelAndView.addObject("leftList", rowList1);
        modelAndView.addObject("width", Integer.valueOf(width));
        return modelAndView;
    }

    public ModelAndView showStatisticalChart(HttpServletRequest request, HttpServletResponse response)
            throws Exception
    {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/statisticalChart_choose");
        List<StatisticalChart> allList = new ArrayList();
        List<StatisticalChart> leftList = new ArrayList();

        StatisticalChart handleType = new StatisticalChart("handleType", "collaboration.statisticalChart.handleType.label");
        allList.add(handleType);

        StatisticalChart importantLevel = new StatisticalChart("importantLevel", "collaboration.statisticalChart.importantLevel.label");
        allList.add(importantLevel);
        if (AppContext.hasPlugin("edoc"))
        {
            StatisticalChart exigency = new StatisticalChart("exigency", "collaboration.statisticalChart.exigency.label");
            allList.add(exigency);
        }
        StatisticalChart overdue = new StatisticalChart("overdue", "collaboration.statisticalChart.overdue.label");
        allList.add(overdue);

        StatisticalChart handlingState = new StatisticalChart("handlingState", "collaboration.statisticalChart.handlingState.label");
        allList.add(handlingState);
        leftList = allList;

        modelAndView.addObject("metadata", leftList);
        return modelAndView;
    }

    public ModelAndView handlingState(HttpServletRequest request, HttpServletResponse response)
            throws Exception
    {
        ModelAndView mav = new ModelAndView("apps/collaboration/handlingState_choose");
        if ("waitSendSection".equals(request.getParameter("comeFrom"))) {
            mav.addObject("waitSendSection", "1");
        }
        return mav;
    }
}
