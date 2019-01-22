package com.seeyon.apps.ztask.controller;

import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by liuwenping on 2019/1/18.
 */
public class TaskController extends BaseController {

    @NeedlessCheckLogin
    public ModelAndView createTask(HttpServletRequest request, HttpServletResponse response){




        return null;
    }

}
