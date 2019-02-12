package com.seeyon.apps.kdXdtzXc.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.kdXdtzXc.manager.XiechengJtdzManager;
import com.seeyon.apps.kdXdtzXc.manager.XiechengZsdzManager;
import com.seeyon.apps.kdXdtzXc.po.XiechengJtdz;
import com.seeyon.apps.kdXdtzXc.util.JSONUtils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

public class XiechengJtdzController extends BaseController {
	
	private XiechengJtdzManager xiechengJtdzManager;
	
	public XiechengJtdzManager getXiechengJtdzManager() {
		return xiechengJtdzManager;
	}

	public void setXiechengJtdzManager(XiechengJtdzManager xiechengJtdzManager) {
		this.xiechengJtdzManager = xiechengJtdzManager;
	}
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
    public ModelAndView listXiechengJtdz(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/listXiechengJtdz");
        List<XiechengJtdz> xiechengJtdzzList = xiechengJtdzManager.getAll();
        if(xiechengJtdzzList !=null && xiechengJtdzzList.size() >0){
        	 XiechengJtdz xiechengJtdz =  xiechengJtdzzList.get(0);
         	 String CreateTime = xiechengJtdz.getCreateTime();//得到创建时间
         	 modelAndView.addObject("CreateTime", CreateTime);
        }
       
        return modelAndView;
    }
    public ModelAndView listXiechengJtdzDialog(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/listXiechengJtdzDialog");
        List<XiechengJtdz> xiechengJtdzzList = xiechengJtdzManager.getAll();
        if(xiechengJtdzzList !=null && xiechengJtdzzList.size() >0){
        	 XiechengJtdz xiechengJtdz =  xiechengJtdzzList.get(0);
         	 String CreateTime = xiechengJtdz.getCreateTime();//得到创建时间
         	 modelAndView.addObject("CreateTime", CreateTime);
        }
       
        return modelAndView;
    }
    
    /**
     * 功能: 携程结算-交通
     */
    @NeedlessCheckLogin
    public void xiechengJiaoTongJieShuan(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	 try {
             String message = "操作成功！";
             long startTime=System.currentTimeMillis();
             //执行方法
             long endTime=System.currentTimeMillis();
             float excTime=(float)(endTime-startTime)/1000;
             //在携程发起对帐信息添加一条信息（每月添加一次）
             xiechengZsdzManager.saveXiechengFqdzxx();
             System.out.println("====================同步携程交通结算数据_开始====================");
             xiechengJtdzManager.xiechengJiaoTongJieShuan();//添加携程交通对账数据
             System.out.println("执行时间："+excTime+"s");
             System.out.println("====================同步携程交通结算数据_结束====================");
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
