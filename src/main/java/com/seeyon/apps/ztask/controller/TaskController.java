package com.seeyon.apps.ztask.controller;

import com.seeyon.apps.platform.util.UIHelper;
import com.seeyon.apps.ztask.vo.ResponseJsonData;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by liuwenping on 2019/1/18.
 */
public class TaskController extends BaseController {
    /**
     * 创建任务
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView createTask(HttpServletRequest request, HttpServletResponse response){

        ResponseJsonData data = new ResponseJsonData();



        UIHelper.responseJSON(data,response);
        return null;
    }

    /**
     * 更新任务信息（不含后续信息）
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView updateTask(HttpServletRequest request, HttpServletResponse response){

        ResponseJsonData data = new ResponseJsonData();



        UIHelper.responseJSON(data,response);
        return null;
    }

    /**
     * 删除任务
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView deleteTask(HttpServletRequest request, HttpServletResponse response){

        ResponseJsonData data = new ResponseJsonData();



        UIHelper.responseJSON(data,response);
        return null;
    }

    /**
     * 创建子任务
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView createChildTask(HttpServletRequest request, HttpServletResponse response){

        ResponseJsonData data = new ResponseJsonData();

        UIHelper.responseJSON(data,response);
        return null;
    }

    /**
     * 督办任务
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView superviceTask(HttpServletRequest request, HttpServletResponse response){

        ResponseJsonData data = new ResponseJsonData();

        UIHelper.responseJSON(data,response);
        return null;
    }

    /**
     * 完成任务
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView finishTask(HttpServletRequest request, HttpServletResponse response){

        ResponseJsonData data = new ResponseJsonData();

        UIHelper.responseJSON(data,response);
        return null;
    }

    /**
     * 停止任务
     * @param request
     * @param response
     * @return
     */
    @NeedlessCheckLogin
    public ModelAndView stopTask(HttpServletRequest request, HttpServletResponse response){

        ResponseJsonData data = new ResponseJsonData();

        UIHelper.responseJSON(data,response);
        return null;
    }

    public static void main(String[] args){
        System.out.println("TEST");
    }


}
