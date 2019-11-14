package com.seeyon.apps.nbd.po;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.annotation.ClobText;
import com.seeyon.apps.duban.vo.form.FormTableDefinition;
import com.seeyon.apps.nbd.core.table.entity.NormalTableDefinition;
import com.seeyon.apps.duban.util.CommonUtils;

/**
 * Created by liuwenping on 2018/12/3.
 */
public class Ftd extends CommonPo {

    @ClobText
    private String data;

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public static FormTableDefinition getFormTableDefinition(Ftd ftd){
        String data = ftd.getData();
        if(CommonUtils.isEmpty(data)){
            return null;
        }

        FormTableDefinition formTableDefinition = JSON.parseObject(data,FormTableDefinition.class);


        return formTableDefinition;

    }
    public static NormalTableDefinition getNormalTableDefinition(Ftd ftd){
        String data = ftd.getData();
        if(CommonUtils.isEmpty(data)){
            return null;
        }

        NormalTableDefinition tableDefinition = JSON.parseObject(data,NormalTableDefinition.class);


        return tableDefinition;

    }
    public void setFormTableDefinition(FormTableDefinition ftd){
        if(ftd == null){
            return ;
        }
        String ftdString = JSON.toJSONString(ftd);
        this.setData(ftdString);

    }
    public void setNormalTableDefinition(NormalTableDefinition ftd){
        if(ftd == null){
            return ;
        }
        String ftdString = JSON.toJSONString(ftd);
        this.setData(ftdString);

    }
}
