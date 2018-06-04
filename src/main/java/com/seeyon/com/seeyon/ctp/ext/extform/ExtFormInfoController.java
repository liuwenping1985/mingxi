package com.seeyon.com.seeyon.ctp.ext.extform;

import com.seeyon.ctp.common.controller.BaseController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.InternalResourceView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ExtFormInfoController extends BaseController {
    public ModelAndView openPersonAffairLink(HttpServletRequest request, HttpServletResponse response) throws Exception {


        //formmain 1397
        return new ModelAndView(new InternalResourceView("/WEB-INF/jsp/ext/testinfo/extform.jsp"));
    }

}
