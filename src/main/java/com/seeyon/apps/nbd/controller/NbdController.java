package com.seeyon.apps.nbd.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    @NeedlessCheckLogin
    public ModelAndView index(HttpServletRequest request, HttpServletResponse response){

//        List<Attachment> list = null;
//        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
//        if (isMultipart) {
//            try {
//                System.out.println("is isMultipart");
//                Map data = new HashMap();
//                //list = this.uploadFiles(this.request, data);
//                Object obj = data.get("req");
//                if (obj != null) {
//                    this.request = (HttpServletRequest) obj;
//                }
//            } catch (BusinessException e) {
//                e.printStackTrace();
//            }
//        }
        CommonParameter parameter = CommonParameter.parseParameter(request);
//        if (!CollectionUtils.isEmpty(list)) {
//            System.out.println("FILE UPLOAD SUCCESS");
//            for (Attachment att : list) {
//                System.out.println("att:" + att.getFilename());
//            }
//        } else {
//            System.out.println("NO FILE INPUT DATA STREAM");
//        }
//        parameter.setAttachmentList(list);
        // NbdResponseEntity entity = handler.receive(parameter, request, response);
        Map retMap = new HashMap();

        retMap.put("result",true);
        retMap.put("msg","");
        retMap.put("data", JSON.toJSONString(parameter));
        UIUtils.responseJSON(parameter,response);




        return null;

    }

}
