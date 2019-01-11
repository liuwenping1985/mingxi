package com.seeyon.ctp.form.design;

//import com.seeyon.apps.ruian.design.AssetsSelectSubjectPlugin_QiTaTYSB;
import com.seeyon.ctp.common.controller.BaseController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by liuwenping on 2019/1/7.
 */
public class EextendFormRuianController extends BaseController {

        public ModelAndView index(HttpServletRequest request, HttpServletResponse response){
            ModelAndView mav = new ModelAndView("/apps/ruian/tttt");

            return mav;
        }

    public static void main(String[] args){
      //  AssetsSelectSubjectPlugin_QiTaTYSB gl;
        System.out.println("0000000");
    }
}
