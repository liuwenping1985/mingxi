package com.seeyon.ctp.portal.portlet;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.collaboration.api.CollaborationApi;
import com.seeyon.apps.collaboration.enums.ColQueryCondition;
import com.seeyon.apps.collaboration.manager.PendingManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.supervise.manager.SuperviseManager;
import com.seeyon.ctp.portal.portlet.PortletConstants.PortletCategory;
import com.seeyon.ctp.portal.portlet.PortletConstants.PortletSize;
import com.seeyon.ctp.portal.portlet.PortletConstants.UrlType;
import com.seeyon.ctp.util.FlipInfo;

public class CollaborationPortlet implements BasePortlet {
    
    private static final Log log = LogFactory.getLog(CollaborationPortlet.class);
    
    private SuperviseManager superviseManager;
    private PendingManager pendingManager;
    private CollaborationApi collaborationApi;
    
    public void setCollaborationApi(CollaborationApi collaborationApi) {
		this.collaborationApi = collaborationApi;
	}
    public void setPendingManager(PendingManager pendingManager) {
        this.pendingManager = pendingManager;
    }

    public void setSuperviseManager(SuperviseManager superviseManager) {
        this.superviseManager = superviseManager;
    }

    @Override
	public String getId() {
		return "collaborationPortlet";
	}

	@Override
	public List<ImagePortletLayout> getData() {
		List<ImagePortletLayout> layouts = new ArrayList<ImagePortletLayout>();
		layouts.add(this.getWaitSendPortlet());
        layouts.add(this.getPendingPortlet());
        layouts.add(this.getSupervisePortlet());
        layouts.add(this.getTrackPortlet());
        
        layouts.add(this.getColPortlet());
        layouts.add(this.formTemplate());
        
        layouts.add(this.getSystemManagerPortlet());// 客开
        layouts.add(this.getDeviceInfoPortlet());// 客开
		return layouts;
	}

	@Override
	public ImagePortletLayout getPortlet(String portletId) {
	    List<ImagePortletLayout> layouts = this.getData();
        if(CollectionUtils.isNotEmpty(layouts)){
            for(ImagePortletLayout layout : layouts){
                if(portletId.equals(layout.getPortletId())){
                    return layout;
                }
            }
        }
        return null;
	}

	@Override
	public int getDataCount(String portletId) {
	    int dateCount = -1;
	    Map<String, String> query = new HashMap<String, String>();
        Map<String, Object> query1 = new HashMap<String, Object>();
	    User user = AppContext.getCurrentUser();
        query.put(ColQueryCondition.currentUser.name(), String.valueOf(user.getId()));
        try {
    	    if ("waitSendPortlet".equals(portletId)) {
    	        query.put(ColQueryCondition.state.name(), String.valueOf(StateEnum.col_waitSend.key()));
    	        dateCount = this.collaborationApi.getColAffairsCountByCondition(query);
    	    } else if ("pendingPortlet".equals(portletId)) {
	            query.put(ColQueryCondition.state.name(), String.valueOf(StateEnum.col_pending.key()));
	            //需要查询代理时，加上该参数
	            query.put("hasNeedAgent", "true");
                dateCount = this.collaborationApi.getColAffairsCountByCondition(query);
    	    } else if ("supervisePortlet".equals(portletId)) {
    	        query1.put("app",ApplicationCategoryEnum.collaboration.getKey());
    	        FlipInfo a = superviseManager.getSuperviseList4App(new FlipInfo(), query1);
    	        dateCount = a.getTotal();
            } else if ("trackPortlet".equals(portletId)) {
                query1.put("ordinal", "2");
                query1.put("isTrack", true);
                FlipInfo a = pendingManager.getMoreList4SectionContion(new FlipInfo(), query1);
                dateCount = a.getTotal();
            }
        } catch (Exception e) {
            log.error("首页工作桌面",e);
        }
		return dateCount;
	}

    @Override
    public boolean isAllowDataUsed(String portletId) {
        if ("waitSendPortlet".equals(portletId) && AppContext.getCurrentUser().hasResourceCode("F01_listWaitSend")) {
            return true;
        } else if ("pendingPortlet".equals(portletId) && AppContext.getCurrentUser().hasResourceCode("F01_listPending")) {
            return true;
        } else if ("supervisePortlet".equals(portletId) && AppContext.getCurrentUser().hasResourceCode("F01_supervise")) {
            return true;
        } else if ("trackPortlet".equals(portletId)
                && (AppContext.hasPlugin(PortletCategory.collaboration.name()) || AppContext.hasPlugin(PortletCategory.edoc.name()) || AppContext.hasPlugin(PortletCategory.formbizconfigs.name()))) {
            return true;
        } else if ("colPortlet".equals(portletId)) {
            return AppContext.getCurrentUser().hasResourceCode("F01_listPending") || AppContext.getCurrentUser().hasResourceCode("F01_listDone")
                    || AppContext.getCurrentUser().hasResourceCode("F01_listWaitSend") || AppContext.getCurrentUser().hasResourceCode("F01_listSent");
        } else if ("formTemplate".equals(portletId)) {
            return true;
        } else if ("systemManagerPortlet".equals(portletId)){//客开
        	return true;
        } else if ("deviceInfoPortlet".equals(portletId)){
        	return true;
        }
        
        return false;
    }

	@Override
	public boolean isAllowUsed() {
	    
		return true;
	}
	
	/**
	 * 待发事项
	 * @return
	 */
    private ImagePortletLayout getWaitSendPortlet() {
	    ImagePortletLayout layout = new ImagePortletLayout();
	    layout.setResourceCode("F01_listWaitSend");
        layout.setPluginId("collaboration");
        layout.setCategory(PortletCategory.collaboration.name());
        layout.setDisplayName("system.menuname.UnsentEvent");
        layout.setOrder(2);
        layout.setPortletId("waitSendPortlet");
        layout.setPortletName("待发事项");
        layout.setSpaceTypes("personal,personal_custom,leader,outer,custom,department,corporation,public_custom,group,public_custom_group,cooperation_work,objective_manage,edoc_manage,meeting_manage,performance_analysis,form_application,related_project_space,vjoinpc,vjoinmobile,m3mobile,weixinmobile");
        layout.setPortletUrl("/collaboration/collaboration.do?method=listWaitSend");
        layout.setPortletUrlType(UrlType.workspace.name());
        layout.setSize(PortletSize.middle.ordinal());
        List<ImageLayout> ims = new ArrayList<ImageLayout>();

        ImageLayout image1 = new ImageLayout();
        image1.setImageTitle("system.menuname.UnsentEvent");
        image1.setSummary("");
        image1.setImageUrl("d_unsentevent.png");
        ims.add(image1);
        layout.setImageLayouts(ims);
	    return layout;
	}
	
	/**
	 * 待办事项
	 * @return
	 */
	private ImagePortletLayout getPendingPortlet() {
	    ImagePortletLayout layout = new ImagePortletLayout();
        layout.setResourceCode("F01_listPending");
        layout.setPluginId("collaboration");
        layout.setCategory(PortletCategory.collaboration.name());
        layout.setDisplayName("system.menuname.TODOEvent");
        layout.setOrder(4);
        layout.setPortletId("pendingPortlet");
        layout.setPortletName("待办事项");
        layout.setSpaceTypes("personal,personal_custom,leader,outer,custom,department,corporation,public_custom,group,public_custom_group,cooperation_work,objective_manage,edoc_manage,meeting_manage,performance_analysis,form_application,related_project_space,vjoinpc,vjoinmobile,m3mobile,weixinmobile");
        layout.setPortletUrl("/collaboration/collaboration.do?method=listPending");
        layout.setPortletUrlType(UrlType.workspace.name());
        layout.setSize(PortletSize.middle.ordinal());
        List<ImageLayout> ims = new ArrayList<ImageLayout>();

        ImageLayout image1 = new ImageLayout();
        image1.setImageTitle("system.menuname.TODOEvent");
        image1.setSummary("");
        image1.setImageUrl("d_todoevent.png");
        ims.add(image1);
        layout.setImageLayouts(ims);
        return layout;
	}
	
	/**
     * 督办事项
     * @return
     */
    private ImagePortletLayout getSupervisePortlet() {
        ImagePortletLayout layout = new ImagePortletLayout();
        layout.setResourceCode("F01_supervise");
        layout.setPluginId("collaboration");
        layout.setCategory(PortletCategory.collaboration.name());
        layout.setDisplayName(ResourceUtil.getString("system.menuname.SupervisoryEvent"));
        layout.setOrder(7);
        layout.setPortletId("supervisePortlet");
        layout.setPortletName("督办事项");
        layout.setPortletUrl("/supervise/supervise.do?method=listSupervise&app=1");
        layout.setPortletUrlType(UrlType.workspace.name());
        layout.setSize(PortletSize.middle.ordinal());
        List<ImageLayout> ims = new ArrayList<ImageLayout>();

        ImageLayout image1 = new ImageLayout();
        image1.setImageTitle(ResourceUtil.getString("system.menuname.SupervisoryEvent"));
        image1.setSummary("");
        image1.setImageUrl("d_supervisoryevent.png");
        ims.add(image1);
        layout.setImageLayouts(ims);
        return layout;
    }
    
    /**
     * 跟踪事项
     * @return
     */
    private ImagePortletLayout getTrackPortlet() {
        ImagePortletLayout layout = new ImagePortletLayout();
        layout.setPluginId("collaboration");
        layout.setCategory(PortletCategory.collaboration.name());
        layout.setDisplayName("collaboration.protal.track.label");
        layout.setOrder(6);
        layout.setPortletId("trackPortlet");
        layout.setPortletName("跟踪事项");
        layout.setPortletUrl("/portalAffair/portalAffairController.do?method=moreTrack&ordinal=2&currentPanel=all&rowStr=subject,receiveTime,sendUser,deadline,category");
        layout.setPortletUrlType(UrlType.workspace.name());
        layout.setSize(PortletSize.middle.ordinal());
        List<ImageLayout> ims = new ArrayList<ImageLayout>();

        ImageLayout image1 = new ImageLayout();
        image1.setImageTitle("collaboration.protal.track.label");
        image1.setSummary("");
        image1.setImageUrl("d_trackevent.png");
        ims.add(image1);
        layout.setImageLayouts(ims);
        return layout;
    }
    
    /**
     * 协同
     * @return
     */
    private ImagePortletLayout getColPortlet() {
        ImagePortletLayout layout = new ImagePortletLayout();
        layout.setPluginId("collaboration");
        layout.setCategory(PortletCategory.collaboration.name());
        layout.setOrder(0);
        layout.setPortletId("colPortlet");
        layout.setPortletName("协同");
        layout.setDisplayName("pending.collaboration.label");
        layout.setSpaceTypes("m3mobile,weixinmobile");
        layout.setPortletUrl("");
        layout.setPortletUrlType(UrlType.workspace.name());
        layout.setSize(PortletSize.middle.ordinal());
        List<ImageLayout> ims = new ArrayList<ImageLayout>();
        
        ImageLayout image1 = new ImageLayout();
        image1.setImageTitle("pending.collaboration.label");
        image1.setSummary("");
        image1.setImageUrl("d_collaborationthemespace.png");
        ims.add(image1);
        layout.setImageLayouts(ims);
        return layout;
    }
    
    /**
     * 表单模版
     * @return
     */
    private ImagePortletLayout formTemplate() {
        ImagePortletLayout layout = new ImagePortletLayout();
        layout.setPluginId("collaboration");
        layout.setCategory(PortletCategory.common.name());
        layout.setOrder(1);
        layout.setPortletId("formTemplate");
        layout.setPortletName("表单模版");
        layout.setDisplayName("system.weixin.FormTemplete");
        layout.setSpaceTypes("m3mobile,weixinmobile");
        layout.setPortletUrl("");
        layout.setPortletUrlType(UrlType.workspace.name());
        layout.setSize(PortletSize.middle.ordinal());
        List<ImageLayout> ims = new ArrayList<ImageLayout>();
        
        ImageLayout image1 = new ImageLayout();
        image1.setImageTitle("system.weixin.FormTemplete");
        image1.setSummary("");
        image1.setImageUrl("d_formtemplate.png");
        ims.add(image1);
        layout.setImageLayouts(ims);
        return layout;
    }

    // 客开 系统管理 START
    /**
     * 系统管理
     * @return
     */
    private ImagePortletLayout getSystemManagerPortlet() {
        ImagePortletLayout layout = new ImagePortletLayout();
        layout.setPluginId("collaboration");
        layout.setCategory(PortletCategory.collaboration.name());
        layout.setDisplayName("系统管理");
        layout.setOrder(6);
        layout.setPortletId("systemManagerPortlet");
        layout.setPortletName("系统管理");
        layout.setPortletUrl("/proSenderUrlController.do?method=moreTemplate&sId=systemSettingsSection&columnsName=menu.system.manage");
        layout.setPortletUrlType(UrlType.workspace.name());
        layout.setSize(PortletSize.middle.ordinal());
        List<ImageLayout> ims = new ArrayList<ImageLayout>();

        ImageLayout image1 = new ImageLayout();
        image1.setImageTitle("系统管理");
        image1.setSummary("");
        image1.setImageUrl("d_related.png");
        ims.add(image1);
        layout.setImageLayouts(ims);
        return layout;
    }
    
    /**
     * 设备信息
     * @return
     */
    private ImagePortletLayout getDeviceInfoPortlet() {
        ImagePortletLayout layout = new ImagePortletLayout();
        layout.setPluginId("collaboration");
        layout.setCategory(PortletCategory.collaboration.name());
        layout.setDisplayName("设备信息");
        layout.setOrder(6);
        layout.setPortletId("deviceInfoPortlet");
        layout.setPortletName("设备信息");
        layout.setPortletUrl("http://portal01.zc.cinda.ccb/um/userAction.do?operate=viewMoreHardware&&type=view&&isSingle=true");
        layout.setPortletUrlType(UrlType.link.name());
        layout.setSize(PortletSize.middle.ordinal());
        List<ImageLayout> ims = new ArrayList<ImageLayout>();

        ImageLayout image1 = new ImageLayout();
        image1.setImageTitle("设备信息");
        image1.setSummary("");
        image1.setImageUrl("d_onlineRecord.png");
        ims.add(image1);
        layout.setImageLayouts(ims);
        return layout;
    }
    
    
 // 客开 系统管理 END
}
