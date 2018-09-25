//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.apps.u8login.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.taskmanage.enums.ImportantLevelEnums;
import com.seeyon.apps.u8login.po.MemberU8Info;
import com.seeyon.apps.u8login.po.OAMember;
import com.seeyon.apps.u8login.po.U8CtpAffair;
import com.seeyon.apps.u8login.util.UIUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class U8LoginController extends BaseController {
    private static SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public U8LoginController() {
    }

    @NeedlessCheckLogin
    public ModelAndView syncUserInfo(HttpServletRequest request, HttpServletResponse response) {
        Map<String, String> data = new HashMap();
        String userCode = request.getParameter("userCode");
        if(userCode != null && !"".equals(userCode)) {
            String password = request.getParameter("password");
            if(password == null || "".equals(password)) {
                password = "";
            }

            List<MemberU8Info> list = DBAgent.find("from MemberU8Info where userCode='" + userCode + "'");
            MemberU8Info info;
            if(list != null && !list.isEmpty()) {
                info = (MemberU8Info)list.get(0);
                info.setPassword(password);
                DBAgent.update(info);
                data.put("result", "true");
                data.put("message", "USER_PASSWORD_CHANGED");
            } else {
                info = new MemberU8Info();
                info.setIdIfNew();
                info.setUserCode(userCode);
                info.setPassword(password);
                DBAgent.save(info);
                data.put("result", "true");
                data.put("message", "USER_ADD");
            }

            UIUtils.responseJSON(new HashMap(), response);
            return null;
        } else {
            data.put("result", "false");
            data.put("message", "USER_CODE_INVALID");
            UIUtils.responseJSON(data, response);
            return null;
        }
    }

    public ModelAndView openPending(HttpServletRequest req, HttpServletResponse response) {
        ModelAndView view = new ModelAndView("apps/u8login/redirect");
        String affid = req.getParameter("affId");
        String url = req.getParameter("url");
        view.addObject("affid", affid);
        String sql ="from CtpAffair where id ="+affid;
        List<CtpAffair> affairs = DBAgent.find(sql);
        if(affairs!=null&&affairs.size()>0){
            CtpAffair affd = affairs.get(0);
            affd.setState(Integer.valueOf(StateEnum.col_done.key()));
            DBAgent.update(affd);
        }

        view.addObject("url", url);
        return view;
    }

    @NeedlessCheckLogin
    public ModelAndView postAffair(HttpServletRequest request, HttpServletResponse response) {
        Map<String, String> data = new HashMap();
        String param = null;

        try {
                param = UIUtils.getPostDataAsString(request);
                System.out.println("【param】" + param);
                Map itemsData = (Map)JSON.parse(param);
                String context = (String)itemsData.get("context");
                String[] pContext = context.split("\\|\\|");
                U8CtpAffair pData = new U8CtpAffair();
                pData.setId(pContext[0]);
                pData.setSubject(pContext[1]);
                pData.setSenderUserId(pContext[2]);
                pData.setReceiverUserId(pContext[3]);

                try {
                    Date dt = format.parse(pContext[5]);
                    pData.setCreateDate(Long.valueOf(dt.getTime()));
                } catch (ParseException var16) {
                    pData.setCreateDate(Long.valueOf((new Date()).getTime()));
                }

                pData.setLink(pContext[6]);
                pData.setStatus(Integer.valueOf(Integer.parseInt(pContext[7])));
                String senderName = pData.getSenderUserId();
                String receiverName = pData.getReceiverUserId();
                if(receiverName!=null&&!"".equals(receiverName)){

                    String[] reveivers = receiverName.split(",");
                    StringBuilder stb = new StringBuilder();
                    int tag = 0;

                    for(String rev:reveivers){
                        if(rev==null||"".equals(rev)){
                            continue;
                        }
                        if(tag==0){
                            stb.append("'"+rev+"'");
                        }else{
                            stb.append(",'"+rev+"'");
                        }
                        tag++;

                    }
                    List<OAMember> mems = DBAgent.find("from OAMember where code in (" + stb.toString() + ")");
                    if(mems!=null&&mems.size()!=0){
                       Map<Long,OAMember> oaMemberMap = new HashMap<Long, OAMember>();
                       pData.setSubject("您有U8考勤待办事项，请审批");
                       for(OAMember mem:mems){
                           if(mem.getIsDelete().intValue() != 1){
                               oaMemberMap.put(mem.getId(),mem);
                           }
                       }
                      // List<CtpAffair>affs = new ArrayList<CtpAffair>();
                        Map<Long,CtpAffair> tobeSavedCtp = new HashMap<Long, CtpAffair>();
                       for(OAMember mem2:oaMemberMap.values()){
                           CtpAffair affairItem = this.genAffair(pData, mem2, mem2);
                           tobeSavedCtp.put(mem2.getId(),affairItem);
                        //   affs.add(affairItem);
                       }

                        /**
                         * 把之前的干掉
                         */
                        List<CtpAffair> updatedList = new ArrayList<CtpAffair>();
                        List<CtpAffair> affairList = DBAgent.find("from CtpAffair where identifier='U8_FOR_TDHL' and state="+Integer.valueOf(StateEnum.col_pending.key()));
                        if(affairList!=null&&affairList.size()>0){
                            for(CtpAffair afd:affairList){
                                //如果新的代办中没有 就变成已经办理，如果有就什么都不动，并且从新加的列表中删除
                                if(tobeSavedCtp.remove(afd.getMemberId())==null){
                                    afd.setState(Integer.valueOf(StateEnum.col_done.key()));
                                    updatedList.add(afd);
                                }
                            }
                        }
                        List list = new ArrayList(tobeSavedCtp.values());
                        if(list.size()>0){
                            DBAgent.saveAll(list);
                        }
                        if(updatedList.size()>0){
                            DBAgent.updateAll(updatedList);
                        }

                   }
                    data.put("result", "true");
                    data.put("msg", "提交待办成功");
                    UIUtils.responseJSON(data, response);
                    return null;
                }
                data.put("result", "false");
                data.put("msg", "发送者或接受者名称为空无法找到用户数据，请确认数据是否正确");
                UIUtils.responseJSON(data, response);
                return null;

        } catch (IOException var17) {
            data.put("result", "false");
            data.put("msg", "【解析参数错误】---》》》param:" + param);
            var17.printStackTrace();
            UIUtils.responseJSON(new HashMap(), response);
        } catch (Exception var18) {
            var18.printStackTrace();
            data.put("result", "false");
            data.put("msg", "【---Eeception---】");
            UIUtils.responseJSON(new HashMap(), response);
            return null;
        }

        data.put("result", "true");
        data.put("msg", "提交待办成功");
        UIUtils.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView affairDone(HttpServletRequest request, HttpServletResponse response) {
        Map<String, String> data = new HashMap();
        String param = null;

        try {
            param = UIUtils.getPostDataAsString(request);
            System.out.println("【param】" + param);
            Map itemsData = (Map)JSON.parse(param);
            String context = (String)itemsData.get("context");
            String[] pContext = context.split("\\|\\|");
            U8CtpAffair pData = new U8CtpAffair();
            pData.setId(pContext[0]);
            List<CtpAffair> affairList = DBAgent.find("from CtpAffair where identifier='U8+" + pData.getId() + "'");
            if(affairList.size() == 0) {
                data.put("result", "false");
                data.put("msg", "找不到待办");
                UIUtils.responseJSON(data, response);
                return null;
            }

            Iterator var11 = affairList.iterator();

            while(true) {
                if(!var11.hasNext()) {
                    DBAgent.updateAll(affairList);
                    break;
                }

                CtpAffair affair = (CtpAffair)var11.next();
                affair.setState(Integer.valueOf(StateEnum.col_done.key()));
            }
        } catch (IOException var13) {
            data.put("result", "false");
            data.put("msg", "处理参数错误");
            UIUtils.responseJSON(data, response);
            return null;
        } catch (Exception var14) {
            var14.printStackTrace();
            data.put("result", "false");
            data.put("msg", "【---Eeception---】");
            UIUtils.responseJSON(new HashMap(), response);
            return null;
        }

        data.put("result", "true");
        data.put("msg", "成功");
        UIUtils.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView postAffairList(HttpServletRequest request, HttpServletResponse response) throws BusinessException, IOException {
        String param = null;
        HashMap data = new HashMap();

        try {
            param = UIUtils.getPostDataAsString(request);
            Map itemsData = (Map)JSON.parse(param);
            Object obj = itemsData.get("items");
            List<Map> items = null;
            if(obj instanceof List) {
                items = (List)itemsData.get("items");
            } else {
                //JSON.parseArray()
               // items = JSON.parseArray((String)obj, HashMap.class);
            }

            if(items != null && items.size() == 0) {
                ;
            }

            Map<String, Long> accountMap = new HashMap();
            Map<String, Long> userPricipalMap = new HashMap();
            List<CtpAffair> list = new ArrayList();
            List<U8CtpAffair> appList = new ArrayList();
            OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
            int i = 0;

            while(true) {
                if(i < items.size()) {
                    Map item = (Map)items.get(i);
                    U8CtpAffair pData = (U8CtpAffair)JSON.parseObject(JSON.toJSONString(item), U8CtpAffair.class);
                    V3xOrgAccount orgAccount = orgManager.getAccountByName(pData.getOrgName());
                    if(orgAccount == null) {
                        throw new BusinessException("通过组织名" + pData.getOrgName() + "无法找到组织数据，请确认数据结构是否正确");
                    }

                    String senderName = pData.getSenderUserId();
                    if(senderName != null && !"".equals(senderName)) {
                        String receiverName = pData.getReceiverUserId();
                        if(receiverName != null && !"".equals(receiverName)) {
                            Long senderId = (Long)userPricipalMap.get(pData.getSenderUserId());
                            if(senderId == null) {
                                List<V3xOrgMember> mems = DBAgent.find("from V3xOrgMember where code='" + senderName + "'");
                                if(CollectionUtils.isEmpty(mems)) {
                                    throw new BusinessException("通过发送者名称【" + pData.getSenderUserId() + "】无法找到用户数据，请确认数据是否正确");
                                }

                                V3xOrgMember mem = (V3xOrgMember)mems.get(0);
                                userPricipalMap.put(senderName, mem.getId());
                            }

                            Long receiverId = (Long)userPricipalMap.get(receiverName);
                            if(receiverId == null) {
                                List<V3xOrgMember> mems = DBAgent.find("from V3xOrgMember where code='" + receiverName + "'");
                                if(CollectionUtils.isEmpty(mems)) {
                                    throw new BusinessException("通过发送者名称【" + pData.getReceiverUserId() + "】无法找到用户数据，请确认数据是否正确");
                                }

                                V3xOrgMember mem = (V3xOrgMember)mems.get(0);
                                userPricipalMap.put(receiverName, mem.getId());
                            }

                            accountMap.put(orgAccount.getName(), orgAccount.getId());
                            appList.add(pData);
                            ++i;
                            continue;
                        }

                        throw new BusinessException("接收者名称为空无法找到用户数据，请确认数据是否正确");
                    }

                    throw new BusinessException("发送者名称为空无法找到用户数据，请确认数据是否正确");
                }

                if(appList.size() > 0) {
                    for(i = 0; i < appList.size(); ++i) {
                        CtpAffair affairItem = this.genAffair((U8CtpAffair)appList.get(i), (Map)accountMap, (Map)userPricipalMap);
                        list.add(affairItem);
                    }
                }

                DBAgent.saveAll(list);
                break;
            }
        } catch (IOException var23) {
            var23.printStackTrace();
            data.put("result", "false");
            data.put("reason", "无法解析数据，请确认数据结构是否正确");
            UIUtils.responseJSON(data, response);
            return null;
        }

        if(param == null || "".equals(param)) {
            data.put("result", "false");
            data.put("reason", "无法找到数据，请确认数据结构是否正确");
            UIUtils.responseJSON(data, response);
        }

        return null;
    }

    private CtpAffair genAffair(U8CtpAffair data, OAMember sender, OAMember receiver) {
        CtpAffair affair = new CtpAffair();
        affair.setImportantLevel(Integer.valueOf(ImportantLevelEnums.general.getKey()));
        affair.setState(Integer.valueOf(StateEnum.col_pending.key()));
        Long accountId = sender.getAccountId();
        if(accountId != null) {
            affair.setOrgAccountId(accountId);
        }

        affair.setApp(Integer.valueOf(ApplicationCategoryEnum.collaboration.ordinal()));
        affair.setAddition(data.getLink());
        affair.putExtraAttr("linkAddress", data.getLink());
        affair.putExtraAttr("outside_affair", "YES");
        affair.setSubject(data.getSubject());
        affair.setCreateDate(new Date());
        affair.setUpdateDate(new Date());
        affair.setReceiveTime(new Date());
        affair.setSubState(11);
        //affair.setSenderId(sender.getId());
        affair.setSenderId(-884316703172445L);
        affair.setMemberId(receiver.getId());
        affair.setObjectId(Long.valueOf(0L));
        affair.setActivityId(Long.valueOf(0L));
        affair.setIdIfNew();
        affair.setIdentifier("U8_FOR_TDHL");
        affair.setNodePolicy("collaboration");
        affair.setBodyType("20");
        affair.setTrack(Integer.valueOf(0));
        affair.setDealTermType(Integer.valueOf(0));
        affair.setDealTermUserid(Long.valueOf(-1L));
        affair.setSubApp(Integer.valueOf(0));
        return affair;
    }

    private CtpAffair genAffair(U8CtpAffair data, Map<String, Long> orgAccountId, Map<String, Long> userPricipalMap) {
        CtpAffair affair = new CtpAffair();
        affair.setImportantLevel(Integer.valueOf(ImportantLevelEnums.general.getKey()));
        affair.setState(Integer.valueOf(StateEnum.col_pending.key()));
        Long accountId = (Long)orgAccountId.get(data.getOrgName());
        if(accountId != null) {
            affair.setOrgAccountId(accountId);
        }

        affair.setAddition(data.getLink());
        affair.putExtraAttr("linkAddress", data.getLink());
        affair.putExtraAttr("outside_affair", "YES");
        affair.setSubject(data.getSubject());
        affair.setCreateDate(new Date());
        affair.setUpdateDate(new Date());
        affair.setReceiveTime(new Date());
        affair.setSenderId((Long)userPricipalMap.get(data.getSenderUserId()));
        affair.setMemberId((Long)userPricipalMap.get(data.getReceiverUserId()));
        affair.setObjectId(Long.valueOf(0L));
        affair.setActivityId(Long.valueOf(0L));
        affair.setIdIfNew();
        affair.setIdentifier("u8000000000000000000");
        affair.setNodePolicy("collaboration");
        affair.setBodyType("20");
        affair.setTrack(Integer.valueOf(0));
        affair.setDealTermType(Integer.valueOf(0));
        affair.setDealTermUserid(Long.valueOf(-1L));
        affair.setSubApp(Integer.valueOf(0));
        return affair;
    }
}
