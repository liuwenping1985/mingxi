package com.seeyon.apps.u8login.controller;

import com.seeyon.apps.u8login.po.MemberU8Info;
import com.seeyon.apps.u8login.util.UIUtils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/6/15.
 */
public class U8LoginController  extends BaseController {





    @NeedlessCheckLogin
    public ModelAndView syncUserInfo(HttpServletRequest request, HttpServletResponse response){

        Map<String,String> data = new HashMap<String,String>();
        String userCode = request.getParameter("userCode");
        if(StringUtils.isEmpty(userCode)){
            data.put("result","false");
            data.put("message","USER_CODE_INVALID");
            UIUtils.responseJSON(data,response);
            return null;

        }
        String password = request.getParameter("password");
        if(StringUtils.isEmpty(password)){
            password = "";

        }
        List<MemberU8Info> list = DBAgent.find("from MemberU8Info where userCode='"+userCode+"'");
        if(CollectionUtils.isEmpty(list)){
            MemberU8Info info = new MemberU8Info();
            info.setIdIfNew();
            info.setUserCode(userCode);
            info.setPassword(password);
            DBAgent.save(info);
            data.put("result","true");
            data.put("message","USER_ADD");

        }else{
            MemberU8Info info = list.get(0);
            info.setPassword(password);
            DBAgent.update(info);
            data.put("result","true");
            data.put("message","USER_PASSWORD_CHANGED");

        }
        UIUtils.responseJSON(data,response);
        return null;
    }
}
