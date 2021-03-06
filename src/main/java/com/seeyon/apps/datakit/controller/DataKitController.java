package com.seeyon.apps.datakit.controller;

import com.seeyon.apps.datakit.po.OriginalDataObject;
import com.seeyon.apps.datakit.service.DataKitService;
import com.seeyon.apps.datakit.util.DataKitSupporter;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManagerImpl;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

public class DataKitController extends BaseController {

    private DataKitService dataKitService;

    public ModelAndView showOneData(HttpServletRequest request, HttpServletResponse response){
        //获取同步的数据
        List<OriginalDataObject> dataList = dataKitService.getSourceList();
        //枚举的父 -3545157928521216088

        // acount 3271769283932670093

        DataKitSupporter.responseJSON(dataList,response);
        return null;
    }

    public ModelAndView showTwoData(HttpServletRequest request, HttpServletResponse response){

        try {

            DataKitSupporter.responseJSON(dataKitService.getRootEnum(),response);
        } catch (BusinessException e) {
            e.printStackTrace();
        }
        return null;
    }
    public ModelAndView showThreeData(HttpServletRequest request, HttpServletResponse response){

        try {
            EnumManagerImpl impl;
            DataKitSupporter.responseJSON(dataKitService.getExistCtpEnumItem(),response);
        } catch (BusinessException e) {
            e.printStackTrace();
        }
        return null;
    }


    public ModelAndView gogogo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<CtpEnumItem> itemList = dataKitService.doWorkInOneStep();
        DataKitSupporter.responseJSON(itemList,response);
        return null;
    }



    public DataKitService getDataKitService() {
        return dataKitService;
    }

    public void setDataKitService(DataKitService dataKitService) {
        this.dataKitService = dataKitService;
    }
}
