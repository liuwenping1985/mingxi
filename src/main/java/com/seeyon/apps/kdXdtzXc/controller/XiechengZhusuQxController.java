package com.seeyon.apps.kdXdtzXc.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.kdXdtzXc.manager.XiechengZhusuQxManager;
import com.seeyon.apps.kdXdtzXc.po.XiechengZhusuQx;
import com.seeyon.apps.kdXdtzXc.util.JSONUtils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.ctp.util.json.JSONUtil;

public class XiechengZhusuQxController extends BaseController {

    private static final Log LOGGER = LogFactory.getLog(XiechengZhusuQxController.class);
    private XiechengZhusuQxManager xiechengZhusuQxManager;

    public XiechengZhusuQxManager getXiechengZhusuQxManager() {
		return xiechengZhusuQxManager;
	}
	public void setXiechengZhusuQxManager(XiechengZhusuQxManager xiechengZhusuQxManager) {
		this.xiechengZhusuQxManager = xiechengZhusuQxManager;
	}

	/**
     * 功能: 列表页面
     */
    @NeedlessCheckLogin
    public ModelAndView listXiechengZhusuQx(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/listXiechengZhusuQx");
        return modelAndView;
    }

    
    
    /**
     * 功能: 新增修改页面
     */
    public ModelAndView editXiechengZhusuQx(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("kdXdtzXc/xiecheng/editXiechengZhusuQx");
        String xiechengZhusuQxId = request.getParameter("xiechengZhusuQxId");
        if (!StringUtils.isEmpty(xiechengZhusuQxId)) {
            XiechengZhusuQx xiechengZhusuQx = xiechengZhusuQxManager.getDataById(Long.valueOf(xiechengZhusuQxId));
            modelAndView.addObject("xiechengZhusuQx", xiechengZhusuQx);
        }
        return modelAndView;
    }
    
    /**
     * 功能: 保存记录
     */
    public void save(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
        	 String message = "操作成功！";
        	// 得到表单传过来的值
        	String jsonStr = request.getParameter("_json_params") == null ? "{}" : request.getParameter("_json_params");
        	XiechengZhusuQx xiechengZhusuQx = JSONUtil.parseJSONString(jsonStr, XiechengZhusuQx.class);
        	Long id = xiechengZhusuQx.getId();
        	if(id == null){
	    		 // 保存
	            xiechengZhusuQxManager.saveByAdd(request);
	            message = "新增成功！";
        	}else{
        		//修改
        		xiechengZhusuQxManager.updateByZhusuQx(request);
        		message = "修改成功！";
        	}
           
            
            this.write(JSONUtils.objects2json("success", true, "message", message), response);
        } catch (Exception e) {
            this.write(JSONUtils.objects2json("success", false, "message", "操作失败:" + e.getMessage()), response);
            e.printStackTrace();
        }
    }
    
    /**
     * 功能: 删除记录
     */
    public void deleteById(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            String ids = request.getParameter("id");
            if (StringUtils.isEmpty(ids))
                throw new BusinessException("请先选择记录！");
            String[] id_ary = ids.split(",");
            for (int i = 0; i < id_ary.length; i++) {
                Long id = Long.valueOf(id_ary[i]);
                xiechengZhusuQxManager.deleteById(id);
            }

            String info = JSONUtils.objects2json("success", true, "message", "删除成功!");
            this.write(info, response);
        } catch (Exception e) {
            this.write(JSONUtils.objects2json("success", false, "message", "删除失败:" + e.getMessage()), response);
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
