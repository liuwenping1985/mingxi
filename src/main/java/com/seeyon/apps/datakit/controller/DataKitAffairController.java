package com.seeyon.apps.datakit.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.datakit.service.DataKitAffairService;
import com.seeyon.apps.datakit.util.DataKitSupporter;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2018/4/4.
 */
public class DataKitAffairController {

    private DataKitAffairService dataKitAffairService;

    @NeedlessCheckLogin
    public ModelAndView postAffair(HttpServletRequest request, HttpServletResponse response) throws IOException {
        CtpAffair affair = new CtpAffair();
        BufferedReader br = request.getReader();

        String str, wholeStr = "";
        while((str = br.readLine()) != null){
            wholeStr += str;
        }
        if(br!=null){
            try {
                br.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        System.out.println(wholeStr);
        Map data = null;
        data = (Map)JSON.parse(wholeStr);
        DataKitSupporter.responseJSON(data,response);
        return null;
    }

    public DataKitAffairService getDataKitAffairService() {
        return dataKitAffairService;
    }

    public void setDataKitAffairService(DataKitAffairService dataKitAffairService) {
        this.dataKitAffairService = dataKitAffairService;
    }
}
