package com.seeyon.apps.u8login.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.u8login.po.MemberU8Info;
import com.seeyon.apps.u8login.po.U8CtpAffair;
import com.seeyon.apps.u8login.util.UIUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.apache.commons.lang.StringUtils;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/6/15.
 */
public class U8LoginController  extends BaseController {





    @NeedlessCheckLogin
    public ModelAndView syncUserInfo(HttpServletRequest request, HttpServletResponse response){

        Map<String,String> data = new HashMap<String,String>();
        String userCode = request.getParameter("userCode");
        if(StringUtils.isEmpty(userCode)){
            data.put("result","false");
            data.put("message","USER_CODE_INVALID");
            UIUtils.responseJSON(data,response);
            return null;

        }
        String password = request.getParameter("password");
        if(StringUtils.isEmpty(password)){
            password = "";

        }
        List<MemberU8Info> list = DBAgent.find("from MemberU8Info where userCode='"+userCode+"'");
        if(CollectionUtils.isEmpty(list)){
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
    public ModelAndView postAffairList(HttpServletRequest request, HttpServletResponse response) throws BusinessException {

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
            List<AppsPendingData> appList = new ArrayList<AppsPendingData>();
            OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
            for(int k=0;k<items.size();k++){
                Map item = items.get(k);
                U8CtpAffair pData=JSON.parseObject(JSON.toJSONString(item),U8CtpAffair.class);
                V3xOrgAccount orgAccount = orgManager.getAccountByName(pData.getOrgName());
                if(orgAccount == null){
                    throw new BusinessException("通过组织名"+pData.getOrgName()+"无法找到组织数据，请确认数据结构是否正确");
                }
                String senderName = pData.getSenderUserId();
                if(StringUtils.isEmpty(senderName)){
                    throw new BusinessException("发送者名称为空无法找到用户数据，请确认数据是否正确");
                }
                String receiverName = pData.getReceiverUserId();
                if(StringUtils.isEmpty(receiverName)){
                    throw new BusinessException("接收者名称为空无法找到用户数据，请确认数据是否正确");
                }
                Long senderId =  userPricipalMap.get(pData.getSenderUserId());
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
        } catch (IOException e) {
            e.printStackTrace();
            data.put("result","false");
            data.put("reason","无法解析数据，请确认数据结构是否正确");
            UIUtils.responseJSON(data,response);
            return null;

        } catch (IOException e) {
            e.printStackTrace();
        }
        if (StringUtils.isEmpty(param)) {
            data.put("result","false");
            data.put("reason","无法找到数据，请确认数据结构是否正确");
            UIUtils.responseJSON(data,response);
        }




        return null;
    }
}
