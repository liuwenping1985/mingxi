package com.seeyon.apps.kdXdtzXc.section;

import java.util.Map;

import org.jgroups.util.UUID;

import com.seeyon.ctp.portal.section.BaseSectionImpl;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.IframeTemplete;

/**
 * Created by tap-pcng43 on 2017-9-19.
 */
public class YiFaShiXian extends BaseSectionImpl {

    @Override
    public String getId() {
        return "yifashixian";
    }

    @Override
    public String getName(Map<String, String> map) {
        return "已发事项";
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
        iframeTemplete.setUrl("/seeyon/shiXianAllController.do?method=shiXianYiFaListAll&radmon="+UUID.randomUUID().toString());
        iframeTemplete.addBottomButton("common_more_label", "/portalAffair/portalAffairController.do?method=moreSent&fragmentId=-1530841295887119204&ordinal=0&rowStr=subject,publishDate,category&columnsName=%E5%B7%B2%E5%8F%91%E4%BA%8B%E9%A1%B9");
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
