package com.seeyon.apps.duban.service;

import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;

/**
 * Created by liuwenping on 2019/11/7.
 */
public class CommonServiceTrigger {

    private static ColManager colManager;
    private static EnumManager enumManager;

    public static EnumManager getEnumManager(){

        if(enumManager==null){

            enumManager = (EnumManager)AppContext.getBean("enumManagerNew");
        }

        return enumManager;


    }

    public static ColManager getColManager() {

        if (colManager == null) {
            colManager = (ColManager) AppContext.getBean("colManager");
        }

        return colManager;


    }

    //private static

    public static boolean needProcess(Long summaryId) {
        try {

            ColSummary colSummary = getColManager().getSummaryById(summaryId);
            Long templateId = colSummary.getTempleteId();
            System.out.println("======"+templateId+"=======");
            String ids = ConfigFileService.getPropertyByName("ctp.template.ids");
            return ids.contains(String.valueOf(templateId));


        } catch (BusinessException e) {
            e.printStackTrace();
        }

        return false;

    }
    public static void main(String[] args){



    }
}
