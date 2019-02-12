package com.seeyon.ctp.portal.controller;

import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.collaboration.bo.TrackAjaxTranObj;
import com.seeyon.apps.collaboration.enums.CollaborationEnum;
import com.seeyon.apps.collaboration.event.CollaborationCancelEvent;
import com.seeyon.apps.collaboration.manager.PendingManager;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.index.manager.IndexManager;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.ctpenumnew.EnumNameEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.office.HandWriteManager;
import com.seeyon.ctp.common.office.OfficeLockManager;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.supervise.manager.SuperviseManager;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.common.track.manager.CtpTrackMemberManager;
import com.seeyon.ctp.common.web.util.WebUtil;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.ReqUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.edoc.constants.EdocNavigationEnum;
import com.seeyon.v3x.edoc.controller.EdocController;
import com.seeyon.v3x.edoc.domain.EdocOpinion;
import com.seeyon.v3x.edoc.domain.EdocRegister;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.manager.EdocHelper;
import com.seeyon.v3x.edoc.manager.EdocManager;
import com.seeyon.v3x.edoc.manager.EdocRegisterManager;
import com.seeyon.v3x.edoc.manager.EdocSummaryManager;
import com.seeyon.v3x.edoc.util.EdocUtil;
import com.seeyon.v3x.exchange.domain.EdocRecieveRecord;
import com.seeyon.v3x.exchange.manager.RecieveEdocManager;

import net.joinwork.bpm.engine.wapi.WorkflowBpmContext;
import com.seeyon.ctp.workflow.wapi.WorkflowApiManager;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;

public class PortalAffairController extends BaseController {
	private static final Logger LOGGER = Logger.getLogger(EdocController.class);
	private EnumManager enumManagerNew;

    private PendingManager pendingManager;
    
    private AffairManager affairManager;
    
    private CtpTrackMemberManager trackManager;
    
    private WorkflowApiManager wapi;
    
    private HandWriteManager handWriteManager;
    
    private EdocSummaryManager edocSummaryManager;
    
    
    private TemplateManager templeteManager;
    private EdocRegisterManager edocRegisterManager;
    private RecieveEdocManager recieveEdocManager;
    private IndexManager indexManager;
	public void setTempleteManager(TemplateManager templeteManager) {
		this.templeteManager = templeteManager;
	}

	public void setEdocRegisterManager(EdocRegisterManager edocRegisterManager) {
		this.edocRegisterManager = edocRegisterManager;
	}

	public void setRecieveEdocManager(RecieveEdocManager recieveEdocManager) {
		this.recieveEdocManager = recieveEdocManager;
	}

	public void setIndexManager(IndexManager indexManager) {
		this.indexManager = indexManager;
	}

	public void setSuperviseManager(SuperviseManager superviseManager) {
		this.superviseManager = superviseManager;
	}

	public void setOfficeLockManager(OfficeLockManager officeLockManager) {
		this.officeLockManager = officeLockManager;
	}

	private SuperviseManager superviseManager;
	private OfficeLockManager officeLockManager;
    
    public void setEdocSummaryManager(EdocSummaryManager edocSummaryManager) {
		this.edocSummaryManager = edocSummaryManager;
	}

	public void setEdocManager(EdocManager edocManager) {
		this.edocManager = edocManager;
	}

	private EdocManager edocManager;
    
    public void setHandWriteManager(HandWriteManager handWriteManager) {
    	this.handWriteManager = handWriteManager;
    }

    
    
	public WorkflowApiManager getWapi() {
		return wapi;
	}

	public void setWapi(WorkflowApiManager wapi) {
		this.wapi = wapi;
	}

    
	public void setAffairManager(AffairManager affairManager) {
		this.affairManager = affairManager;
	}
	public void setTrackManager(CtpTrackMemberManager trackManager) {
		this.trackManager = trackManager;
	}
	public void setPendingManager(PendingManager pendingManager) {
		this.pendingManager = pendingManager;
	}
	public void setEnumManagerNew(EnumManager enumManager) {
		this.enumManagerNew = enumManager;
	}
	/**
     * 流程分类
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView showPortalCatagory(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("apps/collaboration/showPortalCatagory");
        request.setAttribute("openFrom", request.getParameter("openFrom"));
        String category = ReqUtil.getString(request, "category", "");
        if (Strings.isNotBlank((category))) {
            mav = new ModelAndView("apps/collaboration/showPortalCatagory4MyTemplate");
        }
        return mav;
    }
    /**
     * portal显示重要程度的页面
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView showPortalImportLevel(HttpServletRequest request,HttpServletResponse response) throws Exception{
        ModelAndView mav = new ModelAndView("apps/collaboration/showPortalImportLevel");
        List<CtpEnumItem> secretLevelItems =  enumManagerNew.getEnumItems(EnumNameEnum.edoc_urgent_level);
        ColUtil.putImportantI18n2Session();
        mav.addObject("hasEdoc", AppContext.hasPlugin("edoc"));
        mav.addObject("itemCount", secretLevelItems.size());
        return mav;
    }
    
    /**
     * 已发事项 栏目 【更多】
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView moreSent(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/moreSent");
        FlipInfo fi = new FlipInfo();
        String fragmentId = request.getParameter("fragmentId");
        String ordinal = request.getParameter("ordinal");
        String columnsName = ReqUtil.getString(request, "columnsName");
        Map<String,Object> query = new HashMap<String,Object>();
        query.put("fragmentId", fragmentId);
        query.put("ordinal", ordinal);
        query.put("state", StateEnum.col_sent.key());
        query.put("isTrack", false);
        query.put("isFromMore", true);
        
        ColUtil.putImportantI18n2Session();
        
        
        this.pendingManager.getMoreList4SectionContion(fi, query);
        request.setAttribute("ffmoreList", fi);
        modelAndView.addObject("total", fi.getTotal());
        fi.setParams(query);
        modelAndView.addObject("params", query);
        modelAndView.addObject("columnsName", columnsName);
        return modelAndView;
    }
    /**
     * 已办事项 栏目 【更多】
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView moreDone(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/moreDone");
        FlipInfo fi = new FlipInfo();
        String fragmentId = request.getParameter("fragmentId");
        String ordinal = request.getParameter("ordinal");
        String rowStr = request.getParameter("rowStr");
        String columnsName = ReqUtil.getString(request, "columnsName");
        String isGroupBy = request.getParameter("isGroupBy");
        if (Strings.isBlank(isGroupBy)) {
            isGroupBy = "false";
        }
        String section = "doneSection";
        Map<String,Object> query = new HashMap<String,Object>();
        query.put("fragmentId", fragmentId);
        query.put("ordinal", ordinal);
        query.put("state", StateEnum.col_done.key());
        query.put("isTrack", false);
        query.put("section", section);
        query.put("isGroupBy", isGroupBy);
        query.put("isFromMore", true);
        
        ColUtil.putImportantI18n2Session();
        
        this.pendingManager.getMoreList4SectionContion(fi, query);
        modelAndView.addObject("total", fi.getTotal());
        request.setAttribute("ffmoreList", fi);
        fi.setParams(query);
        modelAndView.addObject("section", section);
        modelAndView.addObject("params", query);
        modelAndView.addObject("rowStr", rowStr);
        modelAndView.addObject("columnsName", columnsName);
        modelAndView.addObject("isGroupBy",isGroupBy);
        
        return modelAndView;
    }
    /**
     * 待发事项 栏目 【更多】
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
  public ModelAndView moreWaitSend(HttpServletRequest request, HttpServletResponse response) throws Exception {
      //客开 赵培珅 2018-5-3 页面路径修改 start
	  ModelAndView modelAndView = new ModelAndView("apps/collaboration/moreWaitSend");
	  //客开 赵培珅 2018-5-3 页面路径修改 end
        FlipInfo fi = new FlipInfo();
        String fragmentId = request.getParameter("fragmentId");
        String ordinal = request.getParameter("ordinal");
        String rowStr = request.getParameter("rowStr");
        String columnsName = ReqUtil.getString(request, "columnsName");
        Map<String,Object> query = new HashMap<String,Object>();
        query.put("fragmentId", fragmentId);
        query.put("ordinal", ordinal);
        query.put("state", StateEnum.col_waitSend.key());
        query.put("isTrack", false);
        query.put("isFromMore", true);
        
        ColUtil.putImportantI18n2Session();
        
        
        this.pendingManager.getMoreList4SectionContion(fi, query);
        modelAndView.addObject("total", fi.getTotal());
        modelAndView.addObject("rowStr", rowStr);
        request.setAttribute("ffmoreList", fi);
        fi.setParams(query);
        modelAndView.addObject("params", query);
        modelAndView.addObject("columnsName", columnsName);
        return modelAndView;
    }


    /**
     * 跟踪事项 栏目 【更多】
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView moreTrack(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/collaboration/moreTrack");
        FlipInfo fi = new FlipInfo();
        String rowStr = request.getParameter("rowStr");
        String fragmentId = request.getParameter("fragmentId");
        String ordinal = request.getParameter("ordinal");
        String columnsName = ResourceUtil.getString("collaboration.protal.track.label");
        modelAndView.addObject("columnsName", columnsName);
        Map<String,Object> query = new HashMap<String,Object>();
        query.put("fragmentId", fragmentId);
        query.put("ordinal", ordinal);
        query.put("isTrack", true);
        query.put("isFromMore", true);
        query.put("showCurNodesInfo",true);
        
        ColUtil.putImportantI18n2Session();
        
        
        this.pendingManager.getMoreList4SectionContion(fi, query);
        request.setAttribute("ffmoreList", fi);
        fi.setParams(query);
        modelAndView.addObject("params", query);
        modelAndView.addObject("total", fi.getTotal());
        modelAndView.addObject("rowStr", rowStr);
        return modelAndView;
    }

    /**
     * 取消跟踪事项 栏目 【更多】
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView cancelTrack(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map args = ParamUtil.getJsonParams();
        String affairId = (String) args.get("affairId");
        TrackAjaxTranObj obj = new TrackAjaxTranObj();
        obj.setAffairId(affairId);
        this.transCancelTrack(obj);
        String fragmentId = (String) args.get("fragmentId");
        String ordinal = (String) args.get("ordinal");
        String rowStr = request.getParameter("rowStr");
        String columnsName = request.getParameter("columnsName");
        String s = URLEncoder.encode(columnsName);
        return this.redirectModelAndView("/portalAffair/portalAffairController.do?method=moreTrack&fragmentId="+fragmentId+"&ordinal="+ordinal+"&rowStr="+rowStr+"&columnsName=" + s);
    }
    
    private void transCancelTrack(TrackAjaxTranObj obj) throws BusinessException {
        Object obj1 = obj.getAffairId();
        Map<String,Object> map = new HashMap<String,Object>();
        if(obj1 != null){
            String[] affairIds = obj1.toString().split("[,]");
            for(int i=0;i<affairIds.length;i++){
                Map<String,Object> columnValue = new HashMap<String,Object>();
                columnValue.put("track", 0);
                //更新affair事项表状态
                Long affairId = Long.parseLong(affairIds[i]);
                this.affairManager.update(affairId, columnValue);
                map.put("affairId", affairId);
                trackManager.deleteTrackMembers(null, affairId);
            }
        }
    }

	/**
	 * 解锁，公文提交或者暂存待办的时候进行解锁,与Ajax解锁一起，构成两次解锁，避免解锁失败，节点无法修改的问题出现
	 * 
	 * @param userId
	 * @param summaryId
	 */
  //客开 赵培珅 2018-4-28 start
    private void unLock(Long userId, EdocSummary summary) {
    	if (summary == null)
    		return;
    	String bodyType = summary.getFirstBody().getContentType();
    	long summaryId = summary.getId();

    	if (Constants.EDITOR_TYPE_OFFICE_EXCEL.equals(bodyType) || Constants.EDITOR_TYPE_OFFICE_WORD.equals(bodyType)
    			|| Constants.EDITOR_TYPE_WPS_EXCEL.equals(bodyType)
    			|| Constants.EDITOR_TYPE_WPS_WORD.equals(bodyType)) {
    		// 1、解锁office正文
    		try {
    			String contentId = summary.getFirstBody().getContent();

    			handWriteManager.deleteUpdateObj(contentId);
    		} catch (Exception e) {
    			LOGGER.error("解锁office正文失败 userId:" + userId + " summaryId:" + summary.getId(), e);
    		}
    	} else {
    		// 2、解锁html正文
    		try {
    			handWriteManager.deleteUpdateObj(String.valueOf(summaryId));
    		} catch (Exception e) {
    			LOGGER.error("解锁html正文失败 userId:" + userId + " summaryId:" + summaryId, e);
    		}
    	}
    	// 3、解锁公文单
    	try {
    		edocSummaryManager.deleteUpdateObj(String.valueOf(summaryId), String.valueOf(userId));
    	} catch (Exception e) {
    		LOGGER.error("解锁公文单失败 userId:" + userId + " summaryId:" + summaryId, e);
    	}
    }
    
//公文取回
public ModelAndView takeBack(HttpServletRequest request, HttpServletResponse response) throws Exception {		
	
	String[] affairIds = request.getParameterValues("affairId");
	String[] summaryIds = request.getParameterValues("summaryId");
	boolean isRelieveLock = true;
	String processId = "";
	List<EdocSummary> summaryList = new ArrayList<EdocSummary>();
	try {
		StringBuilder info = new StringBuilder();
		// StringBuilder info1 = new StringBuilder();
		StringBuilder info2 = new StringBuilder();
		if (affairIds != null) {
			int i = 0;
			for (String affairId : affairIds) {
				Long _affairId = Long.valueOf(affairId);
				Long summaryId = Long.parseLong(summaryIds[i]);

				CtpAffair affair = affairManager.get(_affairId);
				boolean ok = edocManager.takeBack(_affairId);
				if (ok == false) {
					if (affair != null) {
						info.append("《").append(affair.getSubject()).append("》").append("\n");
					}
				}
				i++;
				EdocSummary summary = edocManager.getEdocSummaryById(summaryId, false);
				processId = summary.getProcessId();
				// 取回后，更新当前待办人
				summary.setFinished(false);// 被取回设置结束为false
				summary.setCompleteTime(null);
				EdocHelper.updateCurrentNodesInfo(summary, true);

				summaryList.add(summary);
			}
		}
		if (info.length() > 0) {
			WebUtil.saveAlert(ResourceBundleUtil.getString(
					"com.seeyon.v3x.collaboration.resources.i18n.CollaborationResource", "takeBack.not.label",
					info.toString()));
		}
		if (info2.length() > 0) {
			WebUtil.saveAlert(ResourceBundleUtil.getString("com.seeyon.v3x.edoc.resources.i18n.EdocResource",
					"edoc.state.end.takeback.archivealert", info2.toString()));
		}
		//return new ModelAndView("apps/collaboration/refreshWindow").addObject("windowObj", "parent");
	} catch (Exception e) {
		LOGGER.error("公文取回时抛出异常：", e);
	} finally {
		// 目前
		if (isRelieveLock) {
			// 解锁正文文单
			wapi.releaseWorkFlowProcessLock(processId, String.valueOf(AppContext.currentUserId()));
			for (int i = 0; i < summaryIds.length; i++) {
				wapi.releaseWorkFlowProcessLock(summaryIds[i], String.valueOf(AppContext.currentUserId()));
			}
			try {
				User user = AppContext.getCurrentUser();
				if (Strings.isNotEmpty(summaryList)) {
					for (EdocSummary summary : summaryList) {
						// 解锁正文文单
						unLock(user.getId(), summary);
					}
				}
			} catch (Exception e) {
				LOGGER.error("解锁正文文单抛出异常：", e);
			}
		}
	}
	return super.refreshWorkspace();
	
}
//客开 赵培珅 2018-4-28 end
}