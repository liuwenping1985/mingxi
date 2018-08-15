package com.seeyon.apps.xinjue.service;

import com.seeyon.apps.xinjue.constant.EnumParameterType;
import com.seeyon.apps.xinjue.util.UIUtils;
import com.seeyon.apps.xinjue.vo.HaiXingParameter;
import com.seeyon.ctp.util.DBAgent;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public class XingjueService {
    private HaiXingParameter getHaixingParameterByType(EnumParameterType type){
        HaiXingParameter parameter = new HaiXingParameter();
        parameter.getBiz_content().put("funcode",type.getCode());
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
    public void syncAllDataByPeriod(){

        


    }

}
