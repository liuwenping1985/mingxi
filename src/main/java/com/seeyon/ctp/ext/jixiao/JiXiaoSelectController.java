package com.seeyon.ctp.ext.jixiao;

import com.seeyon.ctp.common.controller.BaseController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.InternalResourceView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class JiXiaoSelectController extends BaseController {
    public ModelAndView getDataFromOutside(HttpServletRequest request, HttpServletResponse response) throws Exception {


        //formmain 1397
        return new ModelAndView(new InternalResourceView("/WEB-INF/jsp/ext/testinfo/extform.jsp"));
    }
}
