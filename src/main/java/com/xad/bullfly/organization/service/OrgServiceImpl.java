package com.xad.bullfly.organization.service;

import com.alibaba.fastjson.JSON;

import com.xad.bullfly.core.common.annotation.MicroServiceProvider;
import com.xad.bullfly.core.common.service.AbstractMicroService;
import com.xad.bullfly.core.manager.ServiceProviderManager;
import com.xad.bullfly.core.service.OrgService;
import com.xad.bullfly.organization.domain.UserDomain;
import com.xad.bullfly.organization.repository.UserDomainRepository;
import com.xad.bullfly.organization.vo.UserVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * Created by liuwenping on 2019/8/29.
 */
@Component
@MicroServiceProvider(name="orgService")
@Order(10)
public class OrgServiceImpl extends AbstractMicroService implements OrgService {

    @Autowired
    private ServiceProviderManager serviceProviderManager;

    @Autowired
    private UserDomainRepository userDomainRepository;

    public OrgServiceImpl(){
        super();
    }

    @Override
    public ServiceProviderManager getServiceProviderManager() {
        return serviceProviderManager;
    }

    @Override
    public String getServiceName() {
        return "orgService";
    }

    @Override
    public List<UserVo> getUserVoList() {


        List<UserDomain> userDomainList = userDomainRepository.findAll();

        List<UserVo> userVoList = new ArrayList<>();

        for(UserDomain domain:userDomainList){
            UserVo vo = JSON.parseObject(JSON.toJSONString(domain),UserVo.class);
            userVoList.add(vo);
        }
        return userVoList;
    }
}
