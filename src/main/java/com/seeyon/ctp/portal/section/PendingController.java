//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.portal.section;

import com.seeyon.apps.collaboration.manager.PendingManager;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.portal.bo.StatisticalChart;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.portal.space.manager.PortletEntityPropertyManager;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.edoc.EdocEnum.edocType;
import com.seeyon.v3x.edoc.manager.EdocHelper;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.joinwork.bpm.definition.BPMSeeyonPolicy;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

public class PendingController extends BaseController {
    private static final Log log = LogFactory.getLog(PendingController.class);
    private PortletEntityPropertyManager portletEntityPropertyManager;
    private PendingManager pendingManager;

    public PendingController() {
    }

    public void setPortletEntityPropertyManager(PortletEntityPropertyManager portletEntityPropertyManager) {
        this.portletEntityPropertyManager = portletEntityPropertyManager;
    }

    public void setPendingManager(PendingManager pendingManager) {
        this.pendingManager = pendingManager;
    }

    public ModelAndView transPendingMain(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/pendingMain");
        User user = AppContext.getCurrentUser();
        Long memberId = user.getId();
        Long fragmentId = Long.parseLong(request.getParameter("fragmentId"));
        String sectionId = request.getParameter("sectionId");
        modelAndView.addObject("sectionId", sectionId);
        String ordinal = request.getParameter("ordinal");
        new ArrayList();
        int pageSize = 8;
        int width = 0;
        String widthStr = request.getParameter("width");
        if (Strings.isNotBlank(widthStr)) {
            width = Integer.valueOf(widthStr);
        }

        Map<String, String> preference = this.portletEntityPropertyManager.getPropertys(fragmentId, ordinal);
        String graphical = (String)preference.get("graphical_value");
        if (Strings.isBlank(graphical)) {
            graphical = "importantLevel,overdue,handlingState,handleType,exigency";
        }

        String[] graphicalArr = graphical.split(",");
        List<String> graphicalList = Arrays.asList(graphicalArr);
        String remindDays = (String)preference.get("dueToRemind");
        Integer dueToRemind = 0;
        if (Strings.isNotBlank(remindDays)) {
            dueToRemind = Integer.valueOf((String)preference.get("dueToRemind"));
        }

        String currentPanel = SectionUtils.getPanel("all", preference);
        String rowStr = (String)preference.get("rowList");
        String countStr = (String)preference.get("count");
        if (Strings.isNotBlank(countStr)) {
            pageSize = Integer.parseInt(countStr);
        }

        String columnsStyle = (String)Strings.escapeNULL((String)preference.get("columnStyle"), "listAndStatisticalGraph");
        if (Strings.isBlank(rowStr)) {
            rowStr = "subject,receiveTime,sendUser,category";
        }

        List<String> columnHeaderList = new ArrayList();
        String[] rows = rowStr.split(",");
        String[] var27 = rows;
        int var26 = rows.length;

        for(int var25 = 0; var25 < var26; ++var25) {
            String row = var27[var25];
            columnHeaderList.add(row.trim());
        }

        List<CtpAffair> affairs = this.pendingManager.getPendingList(memberId, fragmentId, ordinal);
        List<PendingRow> rowList = new ArrayList();
        this.pendingManager.affairList2PendingRowList(affairs, rowList, user, currentPanel, false, rowStr);
        List<PendingRow> rowList1 = new ArrayList();
        List<PendingRow> rowList2 = new ArrayList();
        PendingRow pr1 = new PendingRow();
        int i;
        int count;
        if ("doubleList".equals(columnsStyle)) {
            i = 1;

            for(Iterator var31 = rowList.iterator(); var31.hasNext(); ++i) {
                PendingRow pr = (PendingRow)var31.next();
                if (i % 2 != 0) {
                    rowList1.add(pr);
                } else {
                    rowList2.add(pr);
                }
            }

            count = pageSize - (rowList.size() + 1) / 2;

            for(int j = 0; j < count; ++j) {
                rowList1.add(pr1);
                rowList2.add(pr1);
            }
        } else {
            rowList1 = rowList;
            i = pageSize - rowList.size();

            for(count = 0; count < i; ++count) {
                rowList1.add(pr1);
                rowList2.add(pr1);
            }
        }

        modelAndView.addObject("rowList1", rowList1);
        modelAndView.addObject("rowList2", rowList2);
        modelAndView.addObject("pageSize", pageSize);
        modelAndView.addObject("dueToRemind", dueToRemind);
        modelAndView.addObject("columnsStyle", columnsStyle);
        modelAndView.addObject("graphicalList", graphicalList);
        modelAndView.addObject("columnHeaderList", columnHeaderList);
        modelAndView.addObject("currentPanel", currentPanel);
        modelAndView.addObject("fragmentId", fragmentId);
        modelAndView.addObject("ordinal", ordinal);
        modelAndView.addObject("width", width);
        return modelAndView;
    }

    public ModelAndView showTestChart(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/report/chart/testChart");
        return mav;
    }

    public ModelAndView morePending(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/morePending");
        FlipInfo fi = new FlipInfo();
        String fragmentId = request.getParameter("fragmentId");
        String ordinal = request.getParameter("ordinal");
        String rowStr = request.getParameter("rowStr");
        if (Strings.isBlank(rowStr)) {
            rowStr = "subject,receiveTime,sendUser,category";
        }

        Map<String, Object> query = new HashMap();
        query.put("fragmentId", fragmentId);
        query.put("ordinal", ordinal);
        query.put("state", StateEnum.col_pending.key());
        query.put("isTrack", false);
        if (Strings.equals(request.getParameter("from"), "Agent")) {
            query.put("rowStr", rowStr);
            this.pendingManager.getMoreAgentList4SectionContion(fi, query);
        } else {
            if (Strings.isNotBlank(request.getParameter("myRemind")) && "meeting".equals(request.getParameter("myRemind"))) {
                query.put("myRemind", "meeting");
            }

            this.pendingManager.getMoreList4SectionContion(fi, query);
        }

        User user = AppContext.getCurrentUser();
        V3xOrgMember member = EdocHelper.getFirstEdocRole(user.getAccountId(), user.getId(), edocType.recEdoc.ordinal());
        if (member != null) {
            modelAndView.addObject("isRegistRole", "true");
        }

        request.setAttribute("ffmoreList", fi);
        fi.setParams(query);
        modelAndView.addObject("params", query);
        modelAndView.addObject("total", fi.getTotal());
        modelAndView.addObject("rowStr", rowStr);
        ColUtil.putImportantI18n2Session();
        return modelAndView;
    }

    public ModelAndView showLeftList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = AppContext.getCurrentUser();
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/showLeftList");
        String dataName = request.getParameter("dataName");
        String pageSize = request.getParameter("pageSize");
        String dueToRemindStr = request.getParameter("dueToRemind");
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
            width = Integer.valueOf(widthStr);
        }

        Map<String, String> preference = this.portletEntityPropertyManager.getPropertys(fragmentId, ordinal);
        Long memberId = user.getId();
        if (Strings.isNotBlank(dueToRemindStr)) {
            Integer.valueOf(dueToRemindStr);
        }

        List<String> columnHeaderList = new ArrayList();
        String[] columnNames = columnHeaderStr.split(",");
        String[] var23 = columnNames;
        int var22 = columnNames.length;

        for(int var21 = 0; var21 < var22; ++var21) {
            String c = var23[var21];
            columnHeaderList.add(c.trim());
        }

        int pageCount = 8;
        if (Strings.isNotBlank(pageSize)) {
            pageCount = Integer.valueOf(pageSize);
        }

        List<ApplicationCategoryEnum> apps = new ArrayList();
        apps.add(ApplicationCategoryEnum.collaboration);
        apps.add(ApplicationCategoryEnum.edocSend);
        apps.add(ApplicationCategoryEnum.edocRec);
        apps.add(ApplicationCategoryEnum.edocSign);
        apps.add(ApplicationCategoryEnum.exSend);
        apps.add(ApplicationCategoryEnum.exSign);
        apps.add(ApplicationCategoryEnum.edocRegister);
        apps.add(ApplicationCategoryEnum.edocRecDistribute);
        apps.add(ApplicationCategoryEnum.meeting);
        apps.add(ApplicationCategoryEnum.bulletin);
        apps.add(ApplicationCategoryEnum.inquiry);
        apps.add(ApplicationCategoryEnum.news);
        apps.add(ApplicationCategoryEnum.office);
        apps.add(ApplicationCategoryEnum.info);
        FlipInfo fp = new FlipInfo();
        fp.setSize(pageCount);
        List<CtpAffair> affairList = new ArrayList();
        List<PendingRow> rowList = new ArrayList();
        List<Integer> colEnums = new ArrayList();
        colEnums.add(ApplicationCategoryEnum.collaboration.getKey());
        List<Integer> edocEnums = new ArrayList();
        edocEnums.add(ApplicationCategoryEnum.edocSend.getKey());
        edocEnums.add(ApplicationCategoryEnum.edocRec.getKey());
        edocEnums.add(ApplicationCategoryEnum.edocSign.getKey());
        edocEnums.add(ApplicationCategoryEnum.exSend.getKey());
        edocEnums.add(ApplicationCategoryEnum.exSign.getKey());
        edocEnums.add(ApplicationCategoryEnum.edocRegister.getKey());
        edocEnums.add(ApplicationCategoryEnum.edocRecDistribute.getKey());
        fp.setSortField("receiveTime");
        fp.setSortOrder("desc");
        ArrayList appEnums;
        if ("pending".equals(dataName)) {
            affairList = this.pendingManager.getPendingAffairList(fp, memberId, preference);
        } else if ("zcdb".equals(dataName)) {
            affairList = this.pendingManager.getZcdbAffairList(fp, memberId, preference);
        } else if ("import3".equals(dataName)) {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, colEnums, 3, memberId, preference);
        } else if ("import2".equals(dataName)) {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, colEnums, 2, memberId, preference);
        } else if ("import1".equals(dataName)) {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, colEnums, 1, memberId, preference);
        } else if ("overdue".equals(dataName)) {
            affairList = this.pendingManager.getAffairsIsOverTime(fp, memberId, preference, true);
        } else if ("noOverdue".equals(dataName)) {
            affairList = this.pendingManager.getAffairsIsOverTime(fp, memberId, preference, false);
        } else if ("teTi".equals(dataName)) {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, edocEnums, 5, memberId, preference);
        } else if ("urgent".equals(dataName)) {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, edocEnums, 4, memberId, preference);
        } else if ("expedited".equals(dataName)) {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, edocEnums, 3, memberId, preference);
        } else if ("pingAnxious".equals(dataName)) {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, edocEnums, 2, memberId, preference);
        } else if ("commonExigency".equals(dataName)) {
            affairList = this.pendingManager.getAffairsByCategoryAndImpLevl(fp, edocEnums, 1, memberId, preference);
        } else if ("zyxt".equals(dataName)) {
            affairList = this.pendingManager.getCollAffairs(fp, memberId, preference, false);
        } else if ("xtbdmb".equals(dataName)) {
            affairList = this.pendingManager.getCollAffairs(fp, memberId, preference, true);
        } else if ("shouWen".equals(dataName)) {
            appEnums = new ArrayList();
            appEnums.add(ApplicationCategoryEnum.edocRec.key());
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        } else if ("faWen".equals(dataName)) {
            appEnums = new ArrayList();
            appEnums.add(ApplicationCategoryEnum.edocSend.key());
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        } else if ("daiFaEdoc".equals(dataName)) {
            appEnums = new ArrayList();
            appEnums.add(ApplicationCategoryEnum.exSend.key());
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        } else if ("daiQianShou".equals(dataName)) {
            appEnums = new ArrayList();
            appEnums.add(ApplicationCategoryEnum.exSign.key());
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        } else if ("daiDengJi".equals(dataName)) {
            appEnums = new ArrayList();
            appEnums.add(ApplicationCategoryEnum.edocRegister.key());
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        } else if ("qianBao".equals(dataName)) {
            appEnums = new ArrayList();
            appEnums.add(ApplicationCategoryEnum.edocSign.key());
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        } else if ("huiYi".equals(dataName)) {
            appEnums = new ArrayList();
            appEnums.add(ApplicationCategoryEnum.meeting.key());
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        } else if ("huiYiShi".equals(dataName)) {
            appEnums = new ArrayList();
            appEnums.add(ApplicationCategoryEnum.meetingroom.key());
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        } else if ("daiShenPiGGXX".equals(dataName)) {
            appEnums = new ArrayList();
            appEnums.add(ApplicationCategoryEnum.news.getKey());
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        } else if ("daiShenPiZHBG".equals(dataName)) {
            appEnums = new ArrayList();
            appEnums.add(ApplicationCategoryEnum.office.key());
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        } else if ("diaoCha".equals(dataName)) {
            appEnums = new ArrayList();
            appEnums.add(ApplicationCategoryEnum.inquiry.key());
            affairList = this.pendingManager.getAffairCountByApp(fp, memberId, preference, appEnums);
        }

        this.pendingManager.affairList2PendingRowList((List)affairList, rowList, user, currentPanel, false, columnHeaderStr);
        appEnums = (ArrayList)rowList;
        PendingRow pr1 = new PendingRow();
        int count = pageCount - rowList.size();

        for(int j = 0; j < count; ++j) {
            appEnums.add(pr1);
        }
        Map<String,CtpAffair> outSideAffair = new HashMap<String,CtpAffair>();

        if(affairList!=null) {
            //List<CtpAffair> affairList=(List<CtpAffair>)affairs;
            //System.out.println("((List)affairList).size():"+affairList.size());
            for (int k = 0; k < affairList.size(); k++) {
                CtpAffair affair = (CtpAffair)affairList.get(k);
                // System.out.println("affair.getExtraMap()"+JSON.toJSONString(affair.getExtraMap()));
                // System.out.println("affair.getExtraAttr(outside_affair):"+affair.getExtraAttr("outside_affair"));
                if("YES".equals(affair.getExtraAttr("outside_affair"))){
                    outSideAffair.put(String.valueOf(affair.getId()),affair);
                }else{

                  
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
                row.setLink("/seeyon/syncU8UserToken.do?method=openPending&affId="+affair.getId()+"&url="+ URLEncoder.encode(affair.getAddition(),"utf-8"));
            }
        }
        modelAndView.addObject("columnHeaderList", columnHeaderList);
        modelAndView.addObject("leftList", appEnums);
        modelAndView.addObject("width", width);
        return modelAndView;
    }

    public ModelAndView showStatisticalChart(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/statisticalChart_choose");
        List<StatisticalChart> allList = new ArrayList();
        new ArrayList();
        StatisticalChart handleType = new StatisticalChart("handleType", "collaboration.statisticalChart.handleType.label");
        allList.add(handleType);
        StatisticalChart importantLevel = new StatisticalChart("importantLevel", "collaboration.statisticalChart.importantLevel.label");
        allList.add(importantLevel);
        StatisticalChart overdue;
        if ((Boolean)SysFlag.edoc_notShow.getFlag()) {
            overdue = new StatisticalChart("exigency", "collaboration.statisticalChart.exigency.label");
            allList.add(overdue);
        }

        overdue = new StatisticalChart("overdue", "collaboration.statisticalChart.overdue.label");
        allList.add(overdue);
        StatisticalChart handlingState = new StatisticalChart("handlingState", "collaboration.statisticalChart.handlingState.label");
        allList.add(handlingState);
        modelAndView.addObject("metadata", allList);
        return modelAndView;
    }

    public ModelAndView handlingState(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/handlingState_choose");
        if ("waitSendSection".equals(request.getParameter("comeFrom"))) {
            mav.addObject("waitSendSection", "1");
        }

        return mav;
    }

    private String getPolicyName(CtpAffair affair) {
        String policy = affair.getNodePolicy();
        return Strings.isNotBlank(policy) ? BPMSeeyonPolicy.getShowName(policy) : null;
    }
}
