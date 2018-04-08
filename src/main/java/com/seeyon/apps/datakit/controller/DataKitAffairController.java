package com.seeyon.apps.datakit.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.datakit.service.DataKitAffairService;
import com.seeyon.apps.datakit.util.DataKitSupporter;
import com.seeyon.apps.datakit.vo.AppsPendingData;
import com.seeyon.apps.m3.app.vo.AppInfoVO;
import com.seeyon.apps.taskmanage.enums.ImportantLevelEnums;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.detaillog.vo.CtpAffairVO;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.MemberManager;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.section.PendingController;
import com.seeyon.ctp.rest.util.CtpAffairUntil;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.*;

/**
 * Created by liuwenping on 2018/4/4.
 */
public class DataKitAffairController  extends BaseController {

    private DataKitAffairService dataKitAffairService;

    private OrgManager orgManager;
    private MemberManager memberManager;

    @NeedlessCheckLogin
    public ModelAndView postAffair(HttpServletRequest request, HttpServletResponse response) throws IOException, BusinessException {
        CtpAffair affair = new CtpAffair();
        String param = DataKitSupporter.getPostDataAsString(request);
        Map data = (Map)JSON.parse(param);
        List<Map> items = (List)data.get("items");
        if(items == null||items.size()==0){
            throw new BusinessException("无法找到数据，请确认数据结构是否正确");
        }

        List<CtpAffair>list = new ArrayList<CtpAffair>();
        for(int k=0;k<items.size();k++){
            Map item = items.get(k);
            AppsPendingData pData=JSON.parseObject(JSON.toJSONString(item),AppsPendingData.class);

        }

        //V3xOrgAccount orgAccount =  orgManager.getAccountByName("");
        //orgAccount.getName()
       // data = (Map)JSON.parse(wholeStr);
        //DataKitSupporter.responseJSON(data,response);
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView delImport(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        dataKitAffairService.deleteImportAffair();
        DataKitSupporter.responseJSON("ok",response);
        return null;
    }
    private CtpAffair genAffair(AppsPendingData data,Map<String,Long>orgAccountId){
        CtpAffair affair = new CtpAffair();
        affair.setImportantLevel(ImportantLevelEnums.general.ordinal());
        affair.setState(StateEnum.col_pending.ordinal());
        Long accountId =  orgAccountId.get(data.getOrgName());
        if(accountId!=null){
            affair.setOrgAccountId(accountId);
        }
        affair.setApp(AppInfoVO.AppTypeEnums.integration_remote_url.ordinal());
        affair.setAddition(data.getLinkAddress());
        affair.putExtraAttr("linkAddress",data.getLinkAddress());
        affair.setAutoRun(false);
        affair.setCreateDate(new Date());
        affair.setUpdateDate(new Date());
        affair.setReceiveTime(new Date());
       String userLoginName =  data.getUserLoginName();
      //  affair.setMemberId();
       // affair.setOrgAccountId();
        return affair;
    }

    public ModelAndView link2Out(){


        return null;
    }
    public List<V3xOrgAccount> listAccount(){
       // Ctp
        return null;
    }

    public MemberManager getMemberManager() {
        return memberManager;
    }

    public void setMemberManager(MemberManager memberManager) {
        this.memberManager = memberManager;
    }

    public DataKitAffairService getDataKitAffairService() {
        return dataKitAffairService;
    }

    public void setDataKitAffairService(DataKitAffairService dataKitAffairService) {
        this.dataKitAffairService = dataKitAffairService;
    }

    public OrgManager getOrgManager() {
        return orgManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }
}
