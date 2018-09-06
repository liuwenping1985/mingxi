package com.seeyon.apps.nbd.core.service;

import com.seeyon.apps.nbd.core.entity.ServiceAffairs;
import com.seeyon.apps.nbd.core.vo.CommonDataVo;
import com.seeyon.apps.nbd.core.vo.CommonParameter;

import java.util.List;

/**
 * Created by liuwenping on 2018/8/20.
 */
public interface ServicePlugin {

    public CommonDataVo receiveAffair(CommonParameter parameter);
    public CommonDataVo getAffair(CommonParameter parameter);
    public CommonDataVo deleteAffair(CommonParameter parameter);
    public CommonDataVo processAffair(CommonParameter parameter);
    public List<String> getServiceTypes(CommonParameter parameter);
    public ServiceAffairs getServiceAffairs(String affairType);
    public boolean containAffairType(String affairType);

}
