package com.seeyon.ctp.ext.extform;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
import com.seeyon.client.CTPRestClient;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.event.EventTriggerMode;
import com.seeyon.ctp.ext.extform.util.UIUtils;
import com.seeyon.ctp.ext.extform.vo.Formson1527;
import com.seeyon.ctp.organization.principal.NoSuchPrincipalException;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.ListenEvent;
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
    private CTPRestClient client ;

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
         * product:4369223031188048854
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
         * product:-4679650058905172061,-3220873770960730919,-640281432140132614
         */
        String linkTplId = request.getParameter("linkTplIds");

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
       // Long outLinkTplId = Long.parseLong(linkTplId);
        linkTplId="("+linkTplId+")";
        Long memberId = principalManager.getMemberIdByLoginName(oaLoginName);
        List<CtpAffair> afList =  DBAgent.find("from CtpAffair where templeteId in "+linkTplId+" and senderId="+memberId+"and state=3");
        if(!CollectionUtils.isEmpty(afList)){
            if(afList.size()>0){
                CtpAffair affair = afList.get(0);
                data.put("affair", JSON.toJSONString(affair));
                data.put("affairId", String.valueOf(affair.getId()));
                data.put("templateId", String.valueOf(affair.getTempleteId()));
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
//    @ListenEvent(event= CollaborationFinishEvent.class,mode=EventTriggerMode.afterCommit,async = true)//协同发起成功提交事务后执行，异步模式。
    public void onCollaborationEnd(CollaborationFinishEvent event) throws NoSuchPrincipalException {
       // 7255984374117713477 event.getAffairId(); w
        Long affairId = event.getAffairId();
        List<CtpAffair> list = DBAgent.find("from CtpAffair where id="+affairId);
        if(CollectionUtils.isEmpty(list)){
            return;
        }
        CtpAffair affair = list.get(0);
        Long targetTemplateId = 7255984374117713477L;
        if(targetTemplateId.equals(affair.getTempleteId())){
            //trigger
            List<Formson1527> sonlist = DBAgent.find("from formson_1527 where formmainId="+affair.getFormRecordid());
            List<Long> memberIdList = new ArrayList<Long>();
            for(Formson1527 son:sonlist){
                Long memberId = principalManager.getMemberIdByLoginName(son.getField0009());
                memberIdList.add(memberId);
            }
            StringBuilder stb= new StringBuilder();
            String atpStr = "";
            int index =0;
            for(Long mId:memberIdList){
                if(index == 0){
                    stb.append(String.valueOf(mId));
                    index++;
                }else{
                    stb.append(","+String.valueOf(mId));
                    index++;
                }
            }
            List<CtpAffair> afList =  DBAgent.find("from CtpAffair where templeteId=8703799250809407701 and senderId in("+stb.toString()+")and state=3");
            for(CtpAffair affairNode:afList){


            }

        }

    }

}
