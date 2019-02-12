package com.seeyon.apps.kdXdtzXc.section;

import java.util.Map;

import org.jgroups.util.UUID;

import com.seeyon.ctp.portal.section.BaseSectionImpl;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.IframeTemplete;

/**
 * Created by tap-pcng43 on 2017-9-19.
 */
public class YiBanShiXian extends BaseSectionImpl {

    @Override
    public String getId() {
        return "yibanshixian";
    }

    @Override
    public String getName(Map<String, String> map) {
        return "已办事项";
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
    	iframeTemplete.setHeight("350");
        iframeTemplete.setUrl("/seeyon/shiXianAllController.do?method=shiXianYiBanListAll&radmon="+UUID.randomUUID().toString());
        iframeTemplete.addBottomButton("common_more_label", "/portalAffair/portalAffairController.do?method=moreDone&fragmentId=-8752775514857846211&ordinal=0&rowStr=subject,createDate,receiveTime,sendUser,deadline,category&columnsName=%E5%B7%B2%E5%8A%9E%E4%BA%8B%E9%A1%B9&isGroupBy=false");
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
