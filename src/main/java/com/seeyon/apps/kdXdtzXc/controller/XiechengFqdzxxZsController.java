package com.seeyon.apps.kdXdtzXc.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

public class XiechengFqdzxxZsController extends BaseController {

    private static final Log LOGGER = LogFactory.getLog(XiechengFqdzxxZsController.class);


    /**
     * 功能: 列表页面
     */
    @NeedlessCheckLogin
    public ModelAndView listXiechengFqdzxxZs(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	System.out.println("listXiechengFqdzxxZs");
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/listXiechengFqdzxxZs");
        return modelAndView;
    }

    
    
    protected void write(String str, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(str);
        response.getWriter().flush();
        response.getWriter().close();
    }
}
