package com.seeyon.apps.kdXdtzXc.controller;

import com.seeyon.apps.kdXdtzXc.KimdeConstant;
import com.seeyon.apps.kdXdtzXc.base.util.MapWapperExt;
import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;
import com.seeyon.apps.kdXdtzXc.manager.TravelExpenseXinChengDetailManager;
import com.seeyon.apps.kdXdtzXc.po.TravelExpenseXinChengDetail;
import com.seeyon.apps.kdXdtzXc.po.ZongCaiZqyj;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.apps.kdXdtzXc.util.WriteUtil;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

/**
 * Created by tap-pcng43 on 2017-10-2.
 */
public class TravelExpenseXinChengDetailController extends BaseController {
    private static Log log = LogFactory.getLog(TravelExpenseXinChengDetailController.class);
    private TravelExpenseXinChengDetailManager travelExpenseXinChengDetailManager;

    public TravelExpenseXinChengDetailManager getTravelExpenseXinChengDetailManager() {
        return travelExpenseXinChengDetailManager;
    }

    public void setTravelExpenseXinChengDetailManager(TravelExpenseXinChengDetailManager travelExpenseXinChengDetailManager) {
        this.travelExpenseXinChengDetailManager = travelExpenseXinChengDetailManager;
    }

    /**
     * sso 单点登录到首页
     * http://localhost:80/seeyon/zh5gsSso.do?method=ssoLogin&user=xxx&code=dssds
     *
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @NeedlessCheckLogin
    public ModelAndView buzhuDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("kdXdtzXc/travelExpenseXinChengDetail");
        return mav;

    }

    @NeedlessCheckLogin
    public ModelAndView buzhuDetailShow(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String recordid = request.getParameter("recordid");
        ModelAndView mav = new ModelAndView("kdXdtzXc/travelExpenseXinChengDetailShow");
        mav.addObject("recordid", recordid);
        return mav;

    }


    @NeedlessCheckLogin
    public void getBuzhuDetailData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            String formmain_id_str = request.getParameter("formmain_id");
            Long formmain_id = ToolkitUtil.parseLong(formmain_id_str);
            Long id = formmain_id;
            TravelExpenseXinChengDetail ted = travelExpenseXinChengDetailManager.getTravelExpenseXinChengDetail(id);
            if (ted == null) {
                System.out.println("数据库无对象==");
                ted = new TravelExpenseXinChengDetail();
                ted.setFormmain_id(formmain_id);
                ted.setId(id);
            } else {
                System.out.println("数据库有对象");
            }
            ted.initStr();
            String json = JSONUtilsExt.toJson(new MapWapperExt().add("success", true).add("message", "成功").add("data", ted).toMap());
            System.out.println("反馈内容get=" + json);
            WriteUtil.write(json, response);

        } catch (Exception e) {
            String json = JSONUtilsExt.toJson(new MapWapperExt().add("success", false).add("message", "失败").add("data", null).toMap());
            log.error("保存错误", e);
            e.printStackTrace();
            WriteUtil.write(json, response);

        }
    }

    public void saveBuzhuDetailData(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            String aa = request.getParameter("aa");
            String id_str = request.getParameter("id");
            String formmain_id_str = request.getParameter("formmain_id");
            System.out.println("id_str===" + id_str);
            System.out.println("formmain_id_str===" + formmain_id_str);

            Integer ybChucaiDays = ToolkitUtil.parseInt(request.getParameter("ybChucaiDays"));
            System.out.println("ybChucaiDays==" + ybChucaiDays);
            Integer ybBuzhuDays = ToolkitUtil.parseInt(request.getParameter("ybBuzhuDays"));
            Integer ybFeiBuZhuDays = ToolkitUtil.parseInt(request.getParameter("ybFeiBuZhuDays"));
            String ybBeizhu = request.getParameter("ybBeizhu");
            System.out.println("ybBeizhu==" + ybBeizhu);


            Integer xgChucaiDays = ToolkitUtil.parseInt(request.getParameter("xgChucaiDays"));
            Integer xgBuzhuDays = ToolkitUtil.parseInt(request.getParameter("xgBuzhuDays"));
            Integer xgFeiBuZhuDays = ToolkitUtil.parseInt(request.getParameter("xgFeiBuZhuDays"));
            String xgBeizhu = request.getParameter("xgBeizhu");

            Integer xzChucaiDays = ToolkitUtil.parseInt(request.getParameter("xzChucaiDays"));
            Integer xzBuzhuDays = ToolkitUtil.parseInt(request.getParameter("xzBuzhuDays"));
            Integer xzFeiBuZhuDays = ToolkitUtil.parseInt(request.getParameter("xzFeiBuZhuDays"));
            String xzBeizhu = request.getParameter("xzBeizhu");


            Long formmain_id = ToolkitUtil.parseLong(formmain_id_str);
            Long id = ToolkitUtil.parseLong(id_str);
            TravelExpenseXinChengDetail ted = travelExpenseXinChengDetailManager.getTravelExpenseXinChengDetail(id);
            if (ted == null) {
                ted = new TravelExpenseXinChengDetail();
            }
            ted.setId(id);
            ted.setFormmain_id(formmain_id);

            ted.setYbChucaiDays(ybChucaiDays);
            ted.setYbBuzhuDays(ybBuzhuDays);
            ted.setYbFeiBuZhuDays(ybFeiBuZhuDays);
            ted.setYbBeizhu(ybBeizhu);

          /*  ted.setXgChucaiDays(xgChucaiDays);
            ted.setXgBuzhuDays(xgBuzhuDays);
            ted.setXgFeiBuZhuDays(xgFeiBuZhuDays);
            ted.setXgBeizhu(xgBeizhu);

            ted.setXzChucaiDays(xzChucaiDays);
            ted.setXzBuzhuDays(xzBuzhuDays);
            ted.setXzFeiBuZhuDays(xzFeiBuZhuDays);
            ted.setXzBeizhu(xzBeizhu);*/


            ted.setInsert_date(new Date());
            travelExpenseXinChengDetailManager.save(ted);
            String json = JSONUtilsExt.toJson(new MapWapperExt().add("data", ted).add("success", true).add("message", "保存成功！").toMap());
            System.out.println("反馈内容=" + json);
            WriteUtil.write(json, response);
        } catch (Exception e) {
            log.error("保存错误", e);
            e.printStackTrace();
            String json = JSONUtilsExt.toJson(new MapWapperExt().add("data", null).add("success", false).add("message", "保存失败：" + e.getMessage()).toMap());
            WriteUtil.write(json, response);

        }
    }


}