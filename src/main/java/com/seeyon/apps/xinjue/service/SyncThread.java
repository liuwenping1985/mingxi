package com.seeyon.apps.xinjue.service;

import com.seeyon.apps.xinjue.constant.EnumParameterType;

import java.util.Date;
import java.util.TimerTask;

public class SyncThread extends TimerTask {
    private Date startDate;
    private Date endDate;
    private XingjueService service;
    private EnumParameterType[] enumTyps = {
            EnumParameterType.ORG,
            EnumParameterType.BILL,
            EnumParameterType.COMMODITY,
            EnumParameterType.CUSTOM,
            EnumParameterType.WAREHOUSE
    };
    public XingjueService getService() {
        return service;
    }

    public void setService(XingjueService service) {
        this.service = service;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public void run() {

        for(EnumParameterType type:enumTyps){

            switch(type){
                case ORG:{
                    syncORG();
                    break;
                }
                case CUSTOM:{
                    syncCUSTOM();

                    break;
                }
                case BILL:{
                    syncBILL();

                    break;
                }
                case WAREHOUSE:{
                    syncWAREHOUSE();

                    break;
                }
                case COMMODITY:{
                    syncCOMMODITY();
                    break;
                }
            }
            
        }
    }

    private void syncORG(){


    }
    private void syncBILL(){


    }
    //增量
    private void syncCOMMODITY(){


    }
    private void syncCUSTOM(){


    }
    private void syncWAREHOUSE(){


    }
}
