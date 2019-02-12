package com.seeyon.apps.kdXdtzXc.section;

import java.util.Map;

import org.jgroups.util.UUID;

import com.seeyon.ctp.portal.section.BaseSectionImpl;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.IframeTemplete;

/**
 * Created by tap-pcng43 on 2017-9-19.
 */
public class ZhuanTiSection extends BaseSectionImpl {

    @Override
    public String getId() {
        return "zhuanti";
    }

    @Override
    public String getName(Map<String, String> map) {
        return "专题";
    }

    @Override
    public Integer getTotal(Map<String, String> map) {
        return null;
    }

    @Override
    public String getIcon() {
        return null;
    }

    public BaseSectionTemplete projection(Map<String, String> preference) {
        IframeTemplete iframeTemplete=new IframeTemplete();
    	iframeTemplete.setHeight("80");
        iframeTemplete.setUrl("/seeyon/lingDaoDaiBanController.do?method=zhuanTiImg&radmon="+UUID.randomUUID().toString());
        //iframeTemplete.addBottomButton("common_more_label", "/collaboration/pending.do?method=morePending&fragmentId=2238048215821668302&ordinal=0&currentPanel=all&rowStr=subject,receiveTime,category,policy&columnsName=待办工作");
    	return iframeTemplete;
    }

    
    public boolean isAllowUsed() {
        
        return true;
        //User user = CurrentUser.get();
        //orgManager.hasSpecificRole(memberId,loginAccountId,"公文导出审批");
        //return user("F07_recDJSearch") || user.isAdmin() || user.isGroupAdmin();
    }

    public boolean isAllowUsed(String spaceType) {
        return this.isAllowUsed();
    }

    public boolean isAllowUserUsed(String singleBoardId) {
        return this.isAllowUsed();
    }

}
