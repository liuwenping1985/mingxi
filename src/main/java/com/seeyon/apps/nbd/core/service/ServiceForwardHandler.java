package com.seeyon.apps.nbd.core.service;

import com.seeyon.apps.nbd.core.vo.CommonDataVo;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeanUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by liuwenping on 2018/8/21.
 */
public class ServiceForwardHandler {


    public NbdResponseEntity receive(CommonParameter parameter, HttpServletRequest request, HttpServletResponse response){

        NbdResponseEntity entity = new NbdResponseEntity();
        entity.setResult(true);
        ServicePlugin sp = preHandle(parameter,entity);
        if(!entity.isResult()){
            return entity;
        }
        CommonDataVo data =  sp.receiveAffair(parameter);
        BeanUtils.copyProperties(data,entity);
        return entity;
    }
    public NbdResponseEntity find(CommonParameter parameter, HttpServletRequest request, HttpServletResponse response){

        NbdResponseEntity entity = new NbdResponseEntity();
        entity.setResult(true);
        ServicePlugin sp = preHandle(parameter,entity);
        if(!entity.isResult()){
            return entity;
        }
        CommonDataVo data =  sp.getAffair(parameter);
        BeanUtils.copyProperties(data,entity);
        return entity;
    }
    public NbdResponseEntity delete(CommonParameter parameter, HttpServletRequest request, HttpServletResponse response){

        NbdResponseEntity entity = new NbdResponseEntity();
        entity.setResult(true);
        ServicePlugin sp = preHandle(parameter,entity);
        if(!entity.isResult()){
            return entity;
        }
        CommonDataVo data =  sp.deleteAffair(parameter);
        BeanUtils.copyProperties(data,entity);
        return entity;
    }

    private ServicePlugin preHandle(CommonParameter parameter,NbdResponseEntity entity){
        String affairType = parameter.$("affairType");
        if(StringUtils.isEmpty(affairType)){
            entity.setResult(false);
            entity.setMsg("affairType不能为空");
        }else{

            entity.setResult(true);
        }
        ServicePlugin sp = ServiceHolder.getService(affairType);
        if(sp == null){
            entity.setResult(false);
            entity.setMsg("不支持的事务类型");
        }
        return sp;
    }


}
