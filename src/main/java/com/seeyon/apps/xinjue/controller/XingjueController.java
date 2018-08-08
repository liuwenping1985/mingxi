package com.seeyon.apps.xinjue.controller;

import com.seeyon.apps.xinjue.constant.EnumParameterType;
import com.seeyon.apps.xinjue.service.XingjueService;
import com.seeyon.apps.xinjue.util.UIUtils;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class XingjueController {

    private XingjueService svc;

    public XingjueService getSvc() {
        if(svc == null){
            svc = new XingjueService();
        }
        return svc;
    }

    @NeedlessCheckLogin
    public ModelAndView syncData(HttpServletRequest request, HttpServletResponse response){

        String type = request.getParameter("type");
        Map ret  = new HashMap();
        if("org".equals(type)){

            EnumParameterType p_type = EnumParameterType.ORG;
            try {
                List list = this.getSvc().getData(p_type);
                ret.put("data",list);
            } catch (IOException e) {
                e.printStackTrace();
                ret.put("data","error");
            }

            UIUtils.responseJSON(ret,response);
        }

        return null;
    }

    public static void main(String[] args) throws IOException {
        XingjueController conm = new XingjueController();
        conm.getSvc().getData(EnumParameterType.ORG);
    }
}
