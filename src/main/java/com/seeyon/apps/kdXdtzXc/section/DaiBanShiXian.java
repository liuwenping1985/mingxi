package com.seeyon.apps.kdXdtzXc.section;

import java.util.Map;

import org.jgroups.util.UUID;

import com.seeyon.ctp.portal.section.BaseSectionImpl;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.IframeTemplete;

/**
 * Created by tap-pcng43 on 2017-9-19.
 */
public class DaiBanShiXian extends BaseSectionImpl {

	private int count = 8;
	
    @Override
    public String getId() {
        return "daibanshixian";
    }

    @Override
    public String getName(Map<String, String> map) {
        return "待办事项";
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
        iframeTemplete.setHeight("208");
        iframeTemplete.setUrl("/seeyon/shiXianAllController.do?method=shiXianListAll&radmon="+UUID.randomUUID().toString());
        iframeTemplete.addBottomButton("common_more_label", "/collaboration/pending.do?method=morePending&fragmentId=-4477124685541586661&ordinal=0&currentPanel=all&rowStr=subject,receiveTime,sendUser,category&columnsName=%E5%BE%85%E5%8A%9E%E4%BA%8B%E9%A1%B9");
        iframeTemplete.setDataNum(count);
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
