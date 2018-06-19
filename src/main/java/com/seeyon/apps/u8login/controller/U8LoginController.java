package com.seeyon.apps.u8login.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.m3.app.vo.AppInfoVO;
import com.seeyon.apps.taskmanage.enums.ImportantLevelEnums;
import com.seeyon.apps.u8login.po.MemberU8Info;
import com.seeyon.apps.u8login.po.U8CtpAffair;
import com.seeyon.apps.u8login.util.UIUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.MemberManager;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

/**
 * Created by liuwenping on 2018/6/15.
 */
public class U8LoginController  extends BaseController {





    @NeedlessCheckLogin
    public ModelAndView syncUserInfo(HttpServletRequest request, HttpServletResponse response){

        Map<String,String> data = new HashMap<String,String>();
        String userCode = request.getParameter("userCode");
        if(userCode==null||"".equals(userCode)){
            data.put("result","false");
            data.put("message","USER_CODE_INVALID");

            UIUtils.responseJSON(data,response);
            return null;

        }
        String password = request.getParameter("password");
        if(password==null||"".equals(password)){
            password = "";

        }

        List<MemberU8Info> list = DBAgent.find("from MemberU8Info where userCode='"+userCode+"'");
        if(list==null||list.isEmpty()){
            MemberU8Info info = new MemberU8Info();
            info.setIdIfNew();
            info.setUserCode(userCode);
            info.setPassword(password);
            DBAgent.save(info);
            data.put("result","true");
            data.put("message","USER_ADD");

        }else{
            MemberU8Info info = list.get(0);
            info.setPassword(password);
            DBAgent.update(info);
            data.put("result","true");
            data.put("message","USER_PASSWORD_CHANGED");

        }
        UIUtils.responseJSON(data,response);
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView postAffair(HttpServletRequest request, HttpServletResponse response){
        Map<String,String> data = new HashMap<String,String>();
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView postAffairList(HttpServletRequest request, HttpServletResponse response) throws BusinessException, IOException {

        String param = null;
        Map<String, String> data = new HashMap<String, String>();
        try {
            param = UIUtils.getPostDataAsString(request);
            Map itemsData = (Map) JSON.parse(param);
            Object obj = itemsData.get("items");
            List<Map> items = null;
            if(obj instanceof List){
                items = (List)itemsData.get("items");
            }else{
                items = (List)JSON.parseArray((String)obj,HashMap.class);
            }
            if(items == null||items.size ()==0){


            }
            Map<String,Long> accountMap = new HashMap<String, Long>();
            Map<String,Long> userPricipalMap = new HashMap<String, Long>();
            List<CtpAffair>list = new ArrayList<CtpAffair>();
            List<U8CtpAffair> appList = new ArrayList<U8CtpAffair>();
            OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
            for(int k=0;k<items.size();k++){
                Map item = items.get(k);
                U8CtpAffair pData=JSON.parseObject(JSON.toJSONString(item),U8CtpAffair.class);
                V3xOrgAccount orgAccount = orgManager.getAccountByName(pData.getOrgName());
                if(orgAccount == null){
                    throw new BusinessException("通过组织名"+pData.getOrgName()+"无法找到组织数据，请确认数据结构是否正确");
                }
                String senderName = pData.getSenderUserId();
                if(senderName==null||"".equals(senderName)){
                    throw new BusinessException("发送者名称为空无法找到用户数据，请确认数据是否正确");
                }
                String receiverName = pData.getReceiverUserId();
                if(receiverName==null||"".equals(receiverName)){
                    throw new BusinessException("接收者名称为空无法找到用户数据，请确认数据是否正确");
                }
                Long senderId =  userPricipalMap.get(pData.getSenderUserId());
                if(senderId==null){
                    List<V3xOrgMember> mems = DBAgent.find("from V3xOrgMember where code='"+senderName+"'") ;
                    if(CollectionUtils.isEmpty(mems)){
                        throw new BusinessException("通过发送者名称【"+pData.getSenderUserId()+"】无法找到用户数据，请确认数据是否正确");
                    }
                    V3xOrgMember mem =  mems.get(0);
                    userPricipalMap.put(senderName,mem.getId());
                }
                Long receiverId = userPricipalMap.get(receiverName);
                if(receiverId==null){
                    List<V3xOrgMember> mems = DBAgent.find("from V3xOrgMember where code='"+receiverName+"'") ;
                    if(CollectionUtils.isEmpty(mems)){
                        throw new BusinessException("通过发送者名称【"+pData.getReceiverUserId()+"】无法找到用户数据，请确认数据是否正确");
                    }
                    V3xOrgMember mem =  mems.get(0);
                    userPricipalMap.put(receiverName,mem.getId());
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
        } catch (IOException e) {
            e.printStackTrace();
            data.put("result","false");
            data.put("reason","无法解析数据，请确认数据结构是否正确");
            UIUtils.responseJSON(data,response);
            return null;

        }
        if (param==null||"".equals(param)) {
            data.put("result","false");
            data.put("reason","无法找到数据，请确认数据结构是否正确");
            UIUtils.responseJSON(data,response);
        }




        return null;
    }

    private CtpAffair genAffair(U8CtpAffair data,Map<String,Long>orgAccountId,Map<String,Long>userPricipalMap){
        CtpAffair affair = new CtpAffair();
        affair.setImportantLevel(ImportantLevelEnums.general.getKey());
        affair.setState(StateEnum.col_pending.key());
        Long accountId =  orgAccountId.get(data.getOrgName());
        if(accountId!=null){
            affair.setOrgAccountId(accountId);
        }
        affair.setApp(AppInfoVO.AppTypeEnums.integration_remote_url.ordinal());
        affair.setAddition(data.getLink());

        affair.putExtraAttr("linkAddress",data.getLink());
        affair.putExtraAttr("outside_affair","YES");
      //  affair.setAutoRun(false);
        affair.setSubject(data.getSubject());
        affair.setCreateDate(new Date());
        affair.setUpdateDate(new Date());
        affair.setReceiveTime(new Date());
        affair.setSenderId(userPricipalMap.get(data.getSenderUserId()));
        affair.setMemberId(userPricipalMap.get(data.getReceiverUserId()));
        affair.setObjectId(0l);
       // affair.setAutoRun(false);
        affair.setActivityId(0l);
        affair.setIdIfNew();

        affair.setIdentifier("u8000000000000000000");

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
}
