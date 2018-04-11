package com.seeyon.apps.datakit.controller;

import com.seeyon.apps.datakit.po.OriginalDataObject;
import com.seeyon.apps.datakit.service.DataKitService;
import com.seeyon.apps.datakit.util.DataKitSupporter;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DataKitController extends BaseController {

    private DataKitService dataKitService;

    public ModelAndView showOneData(HttpServletRequest request, HttpServletResponse response){
        //获取同步的数据
        List<OriginalDataObject> dataList = dataKitService.getSourceList();
        //枚举的父 -3545157928521216088

        // acount 3271769283932670093
        //PendingController.class;
        //apps/collaboration/pendingMain
        DataKitSupporter.responseJSON(dataList,response);
        return null;
    }

    public ModelAndView clearAll(HttpServletRequest request, HttpServletResponse response){
        //获取同步的数据
        List<OriginalDataObject> dataList = dataKitService.getAllSourceList();
        for(OriginalDataObject data:dataList){
            data.setUpdateStatus("N");
            data.setSyncStatus("N");
        }
        dataKitService.saveSourceList(dataList);
        DataKitSupporter.responseJSON(dataList,response);
        return null;
    }
    public ModelAndView fix(HttpServletRequest request, HttpServletResponse response){
        //获取同步的数据
        List<OriginalDataObject> dataList = dataKitService.getAllSourceList();
        for(OriginalDataObject data:dataList){
            data.setUpdateStatus("N");
            data.setSyncStatus("Y");
        }
        dataKitService.saveSourceList(dataList);
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
            DataKitSupporter.responseJSON(dataKitService.getExistCtpEnumItem(),response);
        } catch (BusinessException e) {
            e.printStackTrace();
        }
        return null;
    }

    public ModelAndView refresh(HttpServletRequest request, HttpServletResponse response) throws Exception {
        boolean ret= dataKitService.refresh();
        Map<String,String> retData = new HashMap<String,String>();
        retData.put("刷新结果:",ret?"成功":"失败");
        DataKitSupporter.responseJSON(retData,response);
        return null;
    }

    public ModelAndView syncEnum(HttpServletRequest request, HttpServletResponse response){
       Map data =  dataKitService.syncFromOutside();
        DataKitSupporter.responseJSON(data,response);
        return null;
    }
    public ModelAndView syncBusget(HttpServletRequest request, HttpServletResponse response){
        Map data =  dataKitService.syncFromOutsideBudge();
        DataKitSupporter.responseJSON(data,response);
        return null;
    }
    public ModelAndView info(HttpServletRequest request, HttpServletResponse response){
        Map data =  dataKitService.getBuget();
        DataKitSupporter.responseJSON(data,response);
        return null;
    }
    public ModelAndView info2(HttpServletRequest request, HttpServletResponse response){
        List data =  dataKitService.showFormmain0230();
        DataKitSupporter.responseJSON(data,response);
        return null;
    }
    public ModelAndView stop(HttpServletRequest request, HttpServletResponse response){
       dataKitService.setStop(true);
        DataKitSupporter.responseJSON("Stopped",response);
        return null;
    }
    public ModelAndView start(HttpServletRequest request, HttpServletResponse response){
        dataKitService.setStop(false);
        DataKitSupporter.responseJSON("Started",response);
        return null;
    }
    public ModelAndView syncBudge(HttpServletRequest request, HttpServletResponse response){
        Map data =  dataKitService.syncFromOutsideBudge();
        DataKitSupporter.responseJSON(data,response);
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
