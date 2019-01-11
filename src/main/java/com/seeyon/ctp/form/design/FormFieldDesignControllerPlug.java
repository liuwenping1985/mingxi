package com.seeyon.ctp.form.design;

import com.seeyon.ctp.common.controller.BaseController;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FormFieldDesignControllerPlug extends BaseController {
    public ModelAndView formToPlug(HttpServletRequest request,
                                   HttpServletResponse response) throws Exception {
        return new ModelAndView("ctp/form/design/extPlug");//也可以return new ModelAndView(new InternalResourceView("/WEB-INF/jsp/extFormPlug.jsp"));
    }
    public  static  void    main(String []args){
        System.out.print("a");
    }
}