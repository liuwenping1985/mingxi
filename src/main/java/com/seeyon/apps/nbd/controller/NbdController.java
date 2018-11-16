package com.seeyon.apps.nbd.controller;

import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by liuwenping on 2018/8/17.
 */

public class NbdController extends BaseController{



    @NeedlessCheckLogin
    public ModelAndView selectTable(HttpServletRequest request, HttpServletResponse response){



        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView selectQueryTable(HttpServletRequest request, HttpServletResponse response){






        return null;

    }


    @NeedlessCheckLogin
    public ModelAndView selectCommdityMall(HttpServletRequest request, HttpServletResponse response){






        return null;

    }

}
