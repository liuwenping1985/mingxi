package com.seeyon.apps.nbd.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.section.SectionManagerImpl;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/11/19.
 */
public class PortalDataController extends BaseController {


    private OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");

    private List wrapperCtpAffairList(List<CtpAffair> affairList){

        List retList = new ArrayList();


        if(CommonUtils.isEmpty(affairList)){
            return retList;
        }
        for(CtpAffair ctpAffair:affairList){
            String jsonMap = JSON.toJSONString(ctpAffair);
            Map data = JSON.parseObject(jsonMap,HashMap.class);
            try {
                V3xOrgMember member = orgManager.getMemberById(ctpAffair.getSenderId());
                if(member!=null){

                    data.put("senderName",member.getName());

                }
                retList.add(data);

            } catch (BusinessException e) {
                e.printStackTrace();
            }
        }

        return retList;

    }


}
