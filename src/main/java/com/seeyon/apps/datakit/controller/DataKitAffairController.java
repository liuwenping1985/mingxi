package com.seeyon.apps.datakit.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.datakit.service.DataKitAffairService;
import com.seeyon.apps.datakit.util.DataKitSupporter;
import com.seeyon.apps.datakit.vo.AppsPendingData;
import com.seeyon.apps.m3.app.vo.AppInfoVO;
import com.seeyon.apps.taskmanage.enums.ImportantLevelEnums;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.manager.MemberManager;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.principal.NoSuchPrincipalException;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.portal.section.PendingController;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

/**
 * Created by liuwenping on 2018/4/4.
 */
public class DataKitAffairController  extends BaseController {

    private DataKitAffairService dataKitAffairService;

    private OrgManager orgManager;
    private MemberManager memberManager;
    private PrincipalManager principalManager;

    public ModelAndView openPending(HttpServletRequest req, HttpServletResponse response){
        ModelAndView view = new ModelAndView("apps/datakit/redirect");
        String affid =  req.getParameter("affId");
        String url =  req.getParameter("url");
        view.addObject("affid", affid);
        view.addObject("url", url);
        return view;
    }
    @NeedlessCheckLogin
    public ModelAndView affairDone(HttpServletRequest req, HttpServletResponse response) throws BusinessException {

        String bizId =  req.getParameter("bizId");
        String affid =  req.getParameter("affairId");
        if(!StringUtils.isEmpty(affid)){
            CtpAffair ctpAffair = dataKitAffairService.getCtpAffairById(Long.parseLong(affid));
            if(ctpAffair!=null){
                DBAgent.delete(ctpAffair);
                DataKitSupporter.responseJSON(ctpAffair,response);
                return null;
            }
        }
        if(!StringUtils.isEmpty(bizId)){
            CtpAffair ctpAffair = dataKitAffairService.getCtpAffairByBizId(bizId);
            if(ctpAffair!=null){
                DBAgent.delete(ctpAffair);
                DataKitSupporter.responseJSON(ctpAffair,response);
                return null;
            }
        }
        throw new BusinessException("无法找到待办，请确认参数是否正确");
    }
    @NeedlessCheckLogin
    public ModelAndView postAffair(HttpServletRequest request, HttpServletResponse response) throws IOException, BusinessException, NoSuchPrincipalException {
       response.setHeader("Access-Control-Allow-Origin", "*");
        String param = DataKitSupporter.getPostDataAsString(request);
        if(StringUtils.isEmpty(param)){
            throw new BusinessException("无法找到数据，请确认数据结构是否正确");
        }
        Map data = (Map)JSON.parse(param);
        Object obj = data.get("items");
        List<Map> items = null;
        if(obj instanceof List){
            items = (List)data.get("items");
        }else{
            items = (List)JSON.parseArray((String)obj,HashMap.class);
        }
        if(items == null||items.size()==0){
            throw new BusinessException("无法找到数据，请确认数据结构是否正确");
        }
        Map<String,Long> accountMap = new HashMap<String, Long>();
        Map<String,Long> userPricipalMap = new HashMap<String, Long>();
        List<CtpAffair>list = new ArrayList<CtpAffair>();
        List<AppsPendingData> appList = new ArrayList<AppsPendingData>();
        for(int k=0;k<items.size();k++){
            Map item = items.get(k);
            AppsPendingData pData=JSON.parseObject(JSON.toJSONString(item),AppsPendingData.class);
            V3xOrgAccount orgAccount = orgManager.getAccountByName(pData.getOrgName());
            if(orgAccount == null){
                throw new BusinessException("通过组织名"+pData.getOrgName()+"无法找到组织数据，请确认数据结构是否正确");
            }
            String senderName = pData.getSenderName();
            if(StringUtils.isEmpty(senderName)){
                throw new BusinessException("发送者名称为空无法找到用户数据，请确认数据是否正确");
            }
            String receiverName = pData.getReceiverName();
            if(StringUtils.isEmpty(receiverName)){
                throw new BusinessException("接收者名称为空无法找到用户数据，请确认数据是否正确");
            }
           Long senderId =  userPricipalMap.get(pData.getSenderName());
            if(senderId==null){
                senderId = principalManager.getMemberIdByLoginName(pData.getSenderName());
                if(senderId == null){
                    throw new BusinessException("通过发送者名称【"+pData.getReceiverName()+"】无法找到用户数据，请确认数据是否正确");
                }
                userPricipalMap.put(senderName,senderId);
            }
            Long receiverId = userPricipalMap.get(receiverName);
            if(receiverId==null){
                receiverId = principalManager.getMemberIdByLoginName(receiverName);
                if(receiverId == null){
                    throw new BusinessException("通过接收者名称【"+pData.getReceiverName()+"】无法找到用户数据，请确认数据是否正确");
                }
                userPricipalMap.put(receiverName,receiverId);
            }
            //com.seeyon.apps.collaboration.controller.CollaborationController.class;
            accountMap.put(orgAccount.getName(),orgAccount.getId());
            appList.add(pData);
        }
        if(appList.size()>0){
            for(int i=0;i<appList.size();i++){
                CtpAffair affairItem = genAffair(appList.get(i),accountMap,userPricipalMap);
                list.add(affairItem);
            }
        }
        DBAgent.saveAll(list);
        //AppsPendingData pData=JSON.parseObject(JSON.toJSONString(item),AppsPendingData.class);
        //V3xOrgAccount orgAccount =  orgManager.getAccountByName("");
        //orgAccount.getName()
       // data = (Map)JSON.parse(wholeStr);
        DataKitSupporter.responseJSON(list,response);
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView delImport(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        dataKitAffairService.deleteImportAffair();
        DataKitSupporter.responseJSON("ok",response);
        return null;
    }
    private CtpAffair genAffair(AppsPendingData data,Map<String,Long>orgAccountId,Map<String,Long>userPricipalMap){
        CtpAffair affair = new CtpAffair();
        affair.setImportantLevel(ImportantLevelEnums.general.getKey());
        affair.setState(StateEnum.col_pending.key());
        Long accountId =  orgAccountId.get(data.getOrgName());
        if(accountId!=null){
            affair.setOrgAccountId(accountId);
        }
        affair.setApp(AppInfoVO.AppTypeEnums.integration_remote_url.ordinal());
        affair.setAddition(data.getLinkAddress());

        affair.putExtraAttr("linkAddress",data.getLinkAddress());
        affair.putExtraAttr("outside_affair","YES");
        affair.setAutoRun(false);
        affair.setSubject(data.getSubject());
        affair.setCreateDate(new Date());
        affair.setUpdateDate(new Date());
        affair.setReceiveTime(new Date());
        affair.setSenderId(userPricipalMap.get(data.getSenderName()));
        affair.setMemberId(userPricipalMap.get(data.getReceiverName()));
        affair.setAddition(data.getLinkAddress());
        affair.setObjectId(0l);
        affair.setAutoRun(false);
        affair.setActivityId(0l);
        affair.setIdIfNew();
        if(data.getExtParam()!=null&&data.getExtParam().size()>0){
            String bizId = (String)data.getExtParam().get("bizId");
            if (StringUtils.isEmpty(bizId)) {
                bizId="00000000000000000000";
            }
            affair.setIdentifier(bizId);
        }else{
            affair.setIdentifier("00000000000000000000");
        }
        affair.setNodePolicy("collaboration");
        affair.setBodyType("10");
        affair.setTrack(0);
        affair.setDealTermType(0);
        affair.setDealTermUserid(-1L);
        affair.setSubApp(0);

       // affair.setState();
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

    public PrincipalManager getPrincipalManager() {
        return principalManager;
    }

    public void setPrincipalManager(PrincipalManager principalManager) {
        this.principalManager = principalManager;
    }
}
