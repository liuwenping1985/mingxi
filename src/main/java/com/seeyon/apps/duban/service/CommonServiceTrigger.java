package com.seeyon.apps.duban.service;

import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import org.apache.commons.lang.StringUtils;

/**
 * Created by liuwenping on 2019/11/7.
 */
public class CommonServiceTrigger {

    private static ColManager colManager;
    private static EnumManager enumManager;
    private static  DubanMainService mainService = DubanMainService.getInstance();
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
            String code =  mainService.getFormTemplateCode(templateId);
            if(!StringUtils.isEmpty(code)){
                if(code.startsWith("DB")){
                    return true;
                }
            }



        } catch (BusinessException e) {
            e.printStackTrace();
        }

        return false;

    }
    public static void main(String[] args){



    }
}
