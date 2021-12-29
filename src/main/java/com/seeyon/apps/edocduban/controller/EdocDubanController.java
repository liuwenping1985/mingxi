package com.seeyon.apps.edocduban.controller;

import com.seeyon.apps.attendance.AttendanceConstants;
import com.seeyon.apps.edocduban.manager.EdocDuBanManager;
import com.seeyon.apps.edocduban.vo.DubanInfoVo;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.excel.DataCell;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.*;
import com.seeyon.v3x.edoc.webmodel.EdocSearchModel;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.*;

public class EdocDubanController extends BaseController {

    private EdocDuBanManager dubanManager;
    private OrgManager orgManager;

    public OrgManager getOrgManager() {
        return orgManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public EdocDuBanManager getDubanManager() {
        return dubanManager;
    }

    public void setDubanManager(EdocDuBanManager dubanManager) {
        this.dubanManager = dubanManager;
    }

    private Boolean isExporting = false;
    private FileToExcelManager fileToExcelManager;

    public FileToExcelManager getFileToExcelManager() {
        if (fileToExcelManager == null) {
            fileToExcelManager = (FileToExcelManager) AppContext.getBean("fileToExcelManager");
        }
        return fileToExcelManager;
    }

    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }

    public ModelAndView edocDubanManager(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView("/apps/edocDuban/edocDubanManager");
        //查询公文督办员
        User user = AppContext.getCurrentUser();

        //   -1730833917365171641
        try {
            boolean isdubanAdmin = orgManager.hasSpecificRole(user.getId(), -1730833917365171641L, "公文督办管理员");
            boolean isAttendanceAdmin = orgManager.hasSpecificRole(user.getId(), user.getAccountId(), "收文督办确认员");
            //根据公文督办员查询职位为处长的人
            //boolean isAttendanceAdmin = dubanManager.isDubanAdminSection(user);
            System.out.println(isdubanAdmin + "================" + isAttendanceAdmin);
            if (!isdubanAdmin && !isAttendanceAdmin) {
                StringBuffer sb = new StringBuffer();
                sb.append("alert(\"您没有使用本功能的权限！！！\");");
                sb.append("if(window.dialogArguments){"); // 弹出
                sb.append("  window.returnValue = \"true\";");
                sb.append("  window.close();");
                sb.append("} else {");
                sb.append("history.back();");
                sb.append("}");
                rendJavaScript(response, sb.toString());
                return null;
            } else {
                mav.addObject("isdubanAdmin", isdubanAdmin);
                mav.addObject("isAttendanceAdmin", isAttendanceAdmin);
                return mav;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        //根据公文督办员获取当前部门的处长

        return mav;
    }

    public ModelAndView goPageView(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String page = request.getParameter("page");
        ModelAndView mav = new ModelAndView(page);
        mav.addObject("type", request.getParameter("type"));
        mav.addObject("isdubanAdmin", request.getParameter("isdubanAdmin"));
        mav.addObject("isAttendanceAdmin", request.getParameter("isAttendanceAdmin"));
        Date date = DateUtil.currentDate();
        String startTime = Datetimes.formatNoTimeZone(Datetimes.getFirstDayInMonth(date, Locale.getDefault()),
                DateUtil.YEAR_MONTH_DAY_PATTERN);
        mav.addObject(AttendanceConstants.AttendanceQueryParam.startTime.name(), startTime);
        String endTime = Datetimes.formatNoTimeZone(Datetimes.getLastDayInMonth(date, Locale.getDefault()),
                DateUtil.YEAR_MONTH_DAY_PATTERN);
        mav.addObject(AttendanceConstants.AttendanceQueryParam.endTime.name(), endTime);

        return mav;
    }
    /**
     * 根据edoc_id回退督办
     */
    public ModelAndView rollbackDuban(HttpServletRequest request, HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String summaryIds = request.getParameter("summaryIds");
        String type = request.getParameter("type");
        if (!Strings.isEmpty(summaryIds)) {
            boolean success = false;
            if (!Strings.isEmpty(type)) {
                success = dubanManager.rollbackEdocDuban(summaryIds, type);
            }
            //添加到督办表中，状态设置为待确认
            try {
                if (success) {
                    response.getWriter().print(0);
                } else {
                    response.getWriter().print(1);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    /**
     * 根据edoc_id创建督办
     */
    public ModelAndView sendToDuban(HttpServletRequest request, HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String summaryIds = request.getParameter("summaryIds");
        String type = request.getParameter("type");
        if (!Strings.isEmpty(summaryIds)) {
            boolean success = false;
            if (!Strings.isEmpty(type)) {
                success = dubanManager.saveOrUpdateEdocDuban(summaryIds, type);
            }
            //添加到督办表中，状态设置为待确认
            try {
                if (success) {
                    response.getWriter().print(0);
                } else {
                    response.getWriter().print(1);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    /**
     * 发送督办
     *
     * @param request
     * @param response
     * @return
     */
    public ModelAndView sendDuban(HttpServletRequest request, HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String summaryId = request.getParameter("summaryId");
        String memberIds = request.getParameter("memberIds");
        try {
            if (!Strings.isEmpty(summaryId) && !Strings.isEmpty(memberIds)) {
                Long edocId = Long.valueOf(summaryId);
                dubanManager.sendOversee(edocId, memberIds);
                response.getWriter().print("0");
            } else {
                response.getWriter().print("发送督办到待办失败！");
            }
        } catch (Exception e) {
            try {
                response.getWriter().print(e.getMessage());
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }
        return null;
    }


    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * 导出excel
     *
     * @param request
     * @param response
     * @return
     */
    public ModelAndView exportToExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (isExporting == true) {
            super.rendText(response, "is exporting");
            return null;
        } else {
            logger.info(AppContext.currentUserName() + " 正在导出督办数据！");
            isExporting = true;
        }
        try {
            DataRecord dataRecord = new DataRecord();
            Map<String, Object> params = ParamUtil.getJsonParams();
            String type = params.get("type") + "";
            String name = "";
            if ("1".equals(type)) {
                name = "--数据抽取导出";
            } else if ("2".equals(type)) {
                name = "--督办确认导出";
            } else if ("1".equals(type)) {
                name = "--督办台账导出";
            }
            String title = "督办数据列表" + name;
            dataRecord.setTitle(title);
            if (params == null || params.size() == 0) {
                super.rendText(response, "导出失败");
                return null;
            }

            String[] headList = {};
            if ("3".equals(type)) {
                headList = new String[]{"收文时间", "来文文号", "公文标题", "拟办意见", "领导批示", "办理结果", "落实情况"};
            } else {
                headList = new String[]{"收文时间", "来文文号", "公文标题", "拟办意见", "领导批示", "办理结果"};
            }
            dataRecord.setColumnName(headList);

            FlipInfo fi = new FlipInfo(-1, -1);
            fi = dubanManager.findedocSummaryList(fi, params);
            List<DubanInfoVo> result = fi.getData();
            for (DubanInfoVo dubanInfoVo : result) {
                DataRow dataRow = new DataRow();
                dataRow.addDataCell(sdf.format(dubanInfoVo.getCreateTime()), DataCell.DATA_TYPE_TEXT);
                dataRow.addDataCell(dubanInfoVo.getDocMark(), DataCell.DATA_TYPE_TEXT);
                dataRow.addDataCell(dubanInfoVo.getSubject(), DataCell.DATA_TYPE_TEXT);
                dataRow.addDataCell(dubanInfoVo.getNibanOpinion(), DataCell.DATA_TYPE_TEXT);
                dataRow.addDataCell(dubanInfoVo.getLeaderOpinion(), DataCell.DATA_TYPE_TEXT);
                dataRow.addDataCell(dubanInfoVo.getTransactionOpinion(), DataCell.DATA_TYPE_TEXT);
                if ("3".equals(type)) {
                    dataRow.addDataCell(dubanInfoVo.getWorkableOpinion(), DataCell.DATA_TYPE_TEXT);
                }
                dataRecord.addDataRow(dataRow);
            }
            if ("3".equals(type)) {
                dataRecord.setColumnWith(new short[]{20, 30, 55, 55, 55, 55, 55});
            } else {
                dataRecord.setColumnWith(new short[]{20, 30, 55, 55, 55, 55});
            }
            dataRecord.setSheetName("sheet1");
            fileToExcelManager.save(response, title, dataRecord);
        } catch (Exception e) {
            logger.error("", e);
        } finally {
            isExporting = false;
        }
        return null;
    }

    /**
     * 督办台账查询页
     *
     * @param request
     * @param response
     * @return
     */
    public ModelAndView statCompQuery(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView modelAndView = new ModelAndView("/apps/edocDuban/overseeQuery");
        EdocSearchModel em = new EdocSearchModel();
        try {
            this.bind(request, em);
        } catch (Exception e) {
            e.printStackTrace();
        }
        modelAndView.addObject("combQueryObj", em);
        int state = Strings.isBlank(request.getParameter("state")) ? -1 : Integer.parseInt(request.getParameter("state"));
        modelAndView.addObject("state", state);
        return modelAndView;
    }

    public ModelAndView dubanfeedback(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mav = new ModelAndView("/apps/edocDuban/dubanfeedback");
        //String queryId = ReqUtil.getString(request, "queryId");
        //mav.addObject("type", "query");
        //mav.addObject("queryId", queryId);
        String summaryId = ReqUtil.getString(request, "summaryId");
        String options="";
        if(!Strings.isEmpty(summaryId)){
            options=dubanManager.findoptionsById(Long.valueOf(summaryId));
        }
        mav.addObject("options",options);


        return mav;
    }


}
