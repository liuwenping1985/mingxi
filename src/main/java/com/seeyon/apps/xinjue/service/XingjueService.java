package com.seeyon.apps.xinjue.service;

import com.seeyon.apps.xinjue.constant.EnumParameterType;
import com.seeyon.apps.xinjue.util.UIUtils;
import com.seeyon.apps.xinjue.vo.HaiXingParameter;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Timer;

public class XingjueService {
    public HaiXingParameter getHaixingParameterByType(EnumParameterType type){
        HaiXingParameter parameter = new HaiXingParameter();
        parameter.getBiz_content().put("funcode",type.getCode());
        parameter.generateSign();
        return parameter;
    }
    private SimpleDateFormat pFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    public HaiXingParameter getHaixingParameterByType(EnumParameterType type,Date startDate,Date endDate){
        HaiXingParameter parameter = new HaiXingParameter();
        parameter.getBiz_content().put("funcode",type.getCode());
        parameter.getBiz_content().put("bgndate",pFormat.format(startDate));
        parameter.getBiz_content().put("enddate",pFormat.format(endDate));
        parameter.generateSign();
        return parameter;
    }
    public List getData(EnumParameterType type) throws IOException {
        HaiXingParameter parameter = getHaixingParameterByType(type);
        XingjueDataParser parser = XingjueParaserFactory.getParser(type);
        Map data = UIUtils.post(parameter);
        List list = parser.parseData(data);
        return list;
    }

    public List getData(EnumParameterType type,HaiXingParameter haiXingParameter) throws IOException {
        //HaiXingParameter parameter = getHaixingParameterByType(type);
        XingjueDataParser parser = XingjueParaserFactory.getParser(type);
        Map data = UIUtils.post(haiXingParameter);
        List list = parser.parseData(data);
        return list;
    }
    public List getData(EnumParameterType type,Date startDate,Date endDate) throws IOException {
        HaiXingParameter parameter = getHaixingParameterByType(type,startDate,endDate);
        XingjueDataParser parser = XingjueParaserFactory.getParser(type);
        Map data = UIUtils.post(parameter);
        List list = parser.parseData(data);
        return list;
    }
    private Timer scheduleTimer;

    public void syncAllDataByPeriod(){

        Timer timer = getScheduleTimer();
        if(timer==null){

            this.setScheduleTimer(new Timer());
            timer = this.getScheduleTimer();
        }else{
            timer.cancel();
        }
        SyncThread st = new SyncThread();
        st.setService(this);
        timer.schedule(st,1000,24*3600*1000);

    }
    public void stopDataSync(){

        Timer timer = getScheduleTimer();
        if(timer!=null){

            timer.cancel();

        }


    }
    public static void main(String[] args){
        XingjueService s = new XingjueService();




    }

    public Timer getScheduleTimer() {
        return scheduleTimer;
    }

    public void setScheduleTimer(Timer scheduleTimer) {
        this.scheduleTimer = scheduleTimer;
    }
}
