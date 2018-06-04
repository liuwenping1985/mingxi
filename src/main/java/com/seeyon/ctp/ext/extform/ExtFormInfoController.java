package com.seeyon.ctp.ext.extform;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.collaboration.event.CollaborationStartEvent;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.ctp.ext.extform.util.UIUtils;
import com.seeyon.ctp.organization.principal.NoSuchPrincipalException;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.util.DBAgent;
import org.apache.axis.utils.StringUtils;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.InternalResourceView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ExtFormInfoController extends BaseController {

    private  PrincipalManager  principalManager;

    public PrincipalManager getPrincipalManager() {
        return principalManager;
    }

    public void setPrincipalManager(PrincipalManager principalManager) {
        this.principalManager = principalManager;
    }
    public ModelAndView checkFormIsOk2(HttpServletRequest request, HttpServletResponse response) throws Exception {
        //formmain 1397
        return new ModelAndView(new InternalResourceView("/WEB-INF/jsp/ext/formcomponent/extform.jsp"));
    }
    public ModelAndView checkFormIsOk(HttpServletRequest request, HttpServletResponse response) throws Exception {
        //formmain 1397

        String affairId = request.getParameter("affairId");
        /**
         * test :7255984374117713477
         * product:
         */
        String templateId = request.getParameter("tplId");
        Map<String,Object> data = new HashMap<String,Object>();
        if(StringUtils.isEmpty(affairId)){
            data.put("result",false);
            data.put("reason","AFFAIR_ID_NOT_FOUND");
            UIUtils.responseJSON(data,response);
            return null;
        }
        if(StringUtils.isEmpty(templateId)){
            data.put("result",false);
            data.put("reason","TEMPLATE_NOT_FOUND");
            UIUtils.responseJSON(data,response);
            return null;
        }
        List<CtpAffair> affairList = new ArrayList<CtpAffair>(0);
        try {
            affairList = DBAgent.find("from CtpAffair where id=" + affairId);
            if (CollectionUtils.isEmpty(affairList)) {
                data.put("result", false);
                data.put("reason", "AFFAIR_NOT_FOUND");
                UIUtils.responseJSON(data,response);
                return null;
            }
        }catch(Exception e){
            e.printStackTrace();
            data.put("result", false);
            data.put("reason", "AFFAIR_NOT_FOUND");
            UIUtils.responseJSON(data,response);
        }
        CtpAffair affair = affairList.get(0);
        Long tplId = affair.getTempleteId();
        if(tplId==null){
            data.put("result",false);
            data.put("reason","AFFAIR_INNER_TPL_ID_NOT_FOUND");
            UIUtils.responseJSON(data,response);
            return null;
        }
        if(String.valueOf(tplId).equals(templateId)){
            data.put("result",true);
            UIUtils.responseJSON(data,response);
        }else{
            data.put("result",false);
            data.put("reason","NOT_MATCH");
            UIUtils.responseJSON(data,response);
        }
        return null;
    }

    public ModelAndView openPersonAffairLink(HttpServletRequest request, HttpServletResponse response) throws NoSuchPrincipalException {

        /**
         * test :8703799250809407701
         * product:
         */
        String linkTplId = request.getParameter("linkTplId");

        String oaLoginName = request.getParameter("oaLoginName");

        Map<String,Object> data = new HashMap<String,Object>();

        if(StringUtils.isEmpty(linkTplId)){
            data.put("result", false);
            data.put("reason","OUT_TEMPLATE_NOT_FOUND");
            UIUtils.responseJSON(data,response);
            return null;
        }
        if(StringUtils.isEmpty(oaLoginName)){
            data.put("result",false);
            data.put("reason","LOGIN_NAME_NOT_FOUND");
            UIUtils.responseJSON(data,response);
            return null;
        }
        Long outLinkTplId = Long.parseLong(linkTplId);
        Long memberId = principalManager.getMemberIdByLoginName(oaLoginName);
        List<CtpAffair> afList =  DBAgent.find("from CtpAffair where templeteId="+outLinkTplId+" and senderId="+memberId+"and state=3");
        if(!CollectionUtils.isEmpty(afList)){
            if(afList.size()>0){
                CtpAffair affair = afList.get(0);
                data.put("affair", JSON.toJSONString(affair));
                data.put("affairId", String.valueOf(affair.getId()));
                if(afList.size()>1) {
                    data.put("warning", "AFFAIR_MULTI_FOUND");
                }
            }
            data.put("result",true);
            UIUtils.responseJSON(data,response);
        }else{
            data.put("result",false);
            data.put("reason","AFFAIR_NOT_FOUND");
            UIUtils.responseJSON(data,response);
            return null;
        }


        UIUtils.responseJSON(data,response);
        return null;

    }
    @listenEvent(event= CollaborationStartEvent.class,mode=EventTriggerMode.afterCommit)//协同发起成功提交事务后执行，异步模式。
    public void onCollaborationStart3(CollaborationStartEvent event){
        //event.getSummartId()
    }

}
