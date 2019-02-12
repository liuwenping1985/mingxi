package com.seeyon.apps.kdXdtzXc.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.xfire.service.invoker.ApplicationScopePolicy;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.kdXdtzXc.manager.XiechengJtdzManager;
import com.seeyon.apps.kdXdtzXc.scheduled.XieChengDuiZhang;
import com.seeyon.apps.kdXdtzXc.util.JSONUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

public class XiechengFqdzxxJtController extends BaseController {

    private static final Log LOGGER = LogFactory.getLog(XiechengFqdzxxJtController.class);


    /**
     * 功能: 列表页面
     */
    @NeedlessCheckLogin
    public ModelAndView listXiechengFqdzxxJt(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	System.out.println("listXiechengFqdzxxJt");
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/listXiechengFqdzxxJt");
        return modelAndView;
    }
    
    /**
     * 功能: 对账列表页面
     */
    @NeedlessCheckLogin
    public ModelAndView listXiechengFqdzSJ(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	System.out.println("listXiechengFqdzxxJt");
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/listXiechengFqdzSJ");
        return modelAndView;
    }

    /**手动获取中间区数据保存打到OA中**/
    public void getDmzData(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	try {
    		XiechengJtdzManager xc=(XiechengJtdzManager)AppContext.getBean("xiechengJtdzManager");
    		xc.xieChengDuiZhang();
        	/*XieChengDuiZhang duiZhang = new XieChengDuiZhang();
        	duiZhang.xieChengDuiZhang();*/
            String info = JSONUtils.objects2json("success", true, "message", "数据获取成功!");
            this.write(info, response);
        } catch (Exception e) {
            this.write(JSONUtils.objects2json("success", false, "message", "数据获取失败:" + e.getMessage()), response);
            e.printStackTrace();
        }
    }
    
    protected void write(String str, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(str);
        response.getWriter().flush();
        response.getWriter().close();
    }
}
