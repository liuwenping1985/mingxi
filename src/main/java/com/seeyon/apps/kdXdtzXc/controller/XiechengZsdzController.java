package com.seeyon.apps.kdXdtzXc.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.kdXdtzXc.manager.XiechengZsdzManager;
import com.seeyon.apps.kdXdtzXc.po.XiechengZsdz;
import com.seeyon.apps.kdXdtzXc.util.JSONUtils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

public class XiechengZsdzController extends BaseController {
    private static final Log LOGGER = LogFactory.getLog(XiechengZsdzController.class);
    
    private XiechengZsdzManager xiechengZsdzManager;

    public XiechengZsdzManager getXiechengZsdzManager() {
		return xiechengZsdzManager;
	}

	public void setXiechengZsdzManager(XiechengZsdzManager xiechengZsdzManager) {
		this.xiechengZsdzManager = xiechengZsdzManager;
	}


	/**
     * 功能: 列表页面 
     */
    @NeedlessCheckLogin
    public ModelAndView listXiechengZsdz(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/listXiechengZsdz");
    	List<XiechengZsdz> xiechengZsdzList = xiechengZsdzManager.getAll();
    	if(xiechengZsdzList != null && xiechengZsdzList.size() > 0 ){
    		XiechengZsdz xiechengZsdz =  xiechengZsdzList.get(0);
        	String CreateTime = xiechengZsdz.getCreateTime();//得到创建时间
            modelAndView.addObject("CreateTime", CreateTime);
    	}
        return modelAndView;
    }
    public ModelAndView listXiechengZsdzDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/listXiechengZsdzDialog");
    	List<XiechengZsdz> xiechengZsdzList = xiechengZsdzManager.getAll();
    	if(xiechengZsdzList != null && xiechengZsdzList.size() > 0 ){
    		XiechengZsdz xiechengZsdz =  xiechengZsdzList.get(0);
        	String CreateTime = xiechengZsdz.getCreateTime();//得到创建时间
            modelAndView.addObject("CreateTime", CreateTime);
    	}
        return modelAndView;
    }
    
    /**
     * 功能: 携程结算-酒店
     */
    @NeedlessCheckLogin
    public void xiechengJiudianJieShuan(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	 try {
             String message = "操作成功！";
             // 保存
             System.out.println("====================同步携程酒店结算数据_开始====================");
             xiechengZsdzManager.xiechengJiudianJieShuan();
             System.out.println("====================同步携程酒店结算数据_结束====================");
             message = "新增成功！";
             this.write(JSONUtils.objects2json("success", true, "message", message), response);
         } catch (Exception e) {
             this.write(JSONUtils.objects2json("success", false, "message", "操作失败:" + e.getMessage()), response);
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
