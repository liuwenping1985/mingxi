package com.seeyon.apps.duban.controller;

import com.seeyon.apps.duban.mapping.MappingService;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.apps.duban.service.ConfigFileService;
import com.seeyon.apps.duban.service.DubanMainService;
import com.seeyon.apps.duban.util.UIUtils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.v3x.util.annotation.NeedlessCheckLogin;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 督办任务控制器
 * Created by liuwenping on 2019/11/7.
 */
public class DubanTaskController extends BaseController {

    private static final Logger LOGGER = Logger.getLogger(DubanTaskController.class);
    DubanMainService dubanMainService = DubanMainService.getInstance();

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


        return modelAndView;


    }
    /**
     * 获取督办任务
     *
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView getDubanTask(HttpServletRequest request, HttpServletResponse response) {

        List<DubanTask> taskList = dubanMainService.getDubanTask();
        UIUtils.responseJSON(taskList,response);

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
