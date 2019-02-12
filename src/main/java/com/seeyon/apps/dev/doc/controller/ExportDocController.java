package com.seeyon.apps.dev.doc.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.dev.doc.constant.DevConstant;
import com.seeyon.apps.dev.doc.manager.ExportDocManager;
import com.seeyon.apps.dev.doc.utils.ExportMap;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.content.mainbody.CtpContentAllBean;
import com.seeyon.ctp.common.content.mainbody.MainbodyManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.portal.portaltemplate.manager.PortalTemplateManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.v3x.common.web.login.CurrentUser;
import com.seeyon.v3x.services.ServiceException;


public class ExportDocController extends BaseController {
	private final static Log log = LogFactory.getLog(ExportDocController.class);
	private ExportDocManager exportDocManager;
	private MainbodyManager ctpMainbodyManager;
	private PortalTemplateManager portalTemplateManager;
	
	public void setPortalTemplateManager(PortalTemplateManager portalTemplateManager) {
		this.portalTemplateManager = portalTemplateManager;
	}
	public void setCtpMainbodyManager(MainbodyManager ctpMainbodyManager) {
		this.ctpMainbodyManager = ctpMainbodyManager;
	}
	public void setExportDocManager(ExportDocManager exportDocManager) {
		this.exportDocManager = exportDocManager;
	}
	/*
	 * 页面点击归档， 转项提示信息页面
	 */
	public ModelAndView arcInterface(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		String thirdMenuIds= request.getParameter("thirdMenuIds");
		ModelAndView mav = new ModelAndView("plugin/exportdoc/arcInterface");
		mav.addObject("thirdMenuIds", thirdMenuIds);
		return mav;
	}
	/*
	 * 判断是否重复归档
	 */
	public ModelAndView createArchive(HttpServletRequest request,
			HttpServletResponse response) {
		String thirdMenuIds = request.getParameter("thirdMenuIds");
		ModelAndView mav = new ModelAndView("plugin/exportdoc/createArchive");
		ExportMap map = new ExportMap();
		String ids[] = thirdMenuIds.split(",");
//		ExportHelper.excutePageMethod(controller, request, response, pageMethodParameterName);
			try {
				map = this.exportDocManager.getExportEdocIds(ids, true);
				AppContext.putSessionContext(DevConstant.EXPORT_DOC_KEY, map);
				mav.addObject("thirdMenuIds", map.toIdString());
				mav.addObject("Third_hasPingHole", map.containsState(true));
			} catch (ServiceException e) {
				log.error("获取文件列表失败",e);
			}
		// 从这里判断是否有已经归档的文档。
		mav.addObject("userId", CurrentUser.get().getId());
		return mav;
	}
	/*     */   public ModelAndView exportHtml(HttpServletRequest request, HttpServletResponse response)
			/*     */     throws BusinessException
			/*     */   {
			/*  45 */     ModelAndView content = null;
			/*     */     try {
			/*  47 */       Map params = request.getParameterMap();
			/*  48 */       String isNew = ParamUtil.getString(params, "isNew", false);
			/*     */       
			/*  50 */       long moduleId = ParamUtil.getLong(params, "moduleId", Long.valueOf(-1L), true).longValue();
			/*     */       
			/*  52 */       int moduleType = ParamUtil.getInt(params, "moduleType", true).intValue();
			/*  53 */       String openFrom = ParamUtil.getString(params, "openFrom", false);
			/*  54 */       AppContext.putThreadContext("openFrom", openFrom);
			/*  55 */       String contentDataId = ParamUtil.getString(params, "contentDataId", "");
			/*  56 */       AppContext.putThreadContext("contentDataId", contentDataId);
			/*     */       
			/*  58 */       String isFromFrReport = ParamUtil.getString(params, "isFromFrReport", false);
			/*  59 */       if (isFromFrReport != null) {
			/*  60 */         Map p = new HashMap();
			/*  61 */         p.put("contentDataId", Long.valueOf(moduleId));
			/*  62 */         List<CtpContentAll> contentList = DBAgent.findByNamedQuery("ctp_common_content_findByContentDataId", p);
			/*  63 */         if ((contentList == null) || (contentList.size() <= 0)) {
			/*  64 */           throw new BusinessException("帆软报表穿透失败，未找到内容，内容ID：" + moduleId);
			/*     */         }
			/*  66 */         CtpContentAll tempContent = (CtpContentAll)contentList.get(0);
			/*  67 */         moduleId = tempContent.getModuleId().longValue();
			/*  68 */         moduleType = tempContent.getModuleType().intValue();
			/*     */       }
			/*     */       
			/*     */ 
			/*     */ 
			/*  73 */       String style = ParamUtil.getString(params, "style");
			/*  74 */       AppContext.putThreadContext("style", style);
			/*     */       
			/*     */ 
			/*  77 */       ModuleType mType = ModuleType.getEnumByKey(moduleType);
			/*  78 */       if (mType == null) {
			/*  79 */         throw new BusinessException("moduleType is not validate!");
			/*     */       }
			/*     */       
			/*  82 */       String rightId = ParamUtil.getString(params, "rightId", "", false);
			/*     */       
			/*     */ 
			/*  85 */       Integer indexParam = ParamUtil.getInt(params, "indexParam", 0);
			/*     */       
			/*     */ 
			/*  88 */       int viewState = ParamUtil.getInt(params, "viewState", 2).intValue();
			/*     */       
			/*     */ 
			/*  91 */       Long fromCopy = ParamUtil.getLong(params, "fromCopy", Long.valueOf(-1L), false);
			/*     */       
			/*  93 */       List<CtpContentAllBean> contentList = null;
			/*  94 */       CtpContentAllBean contentAll = null;
			/*     */       
			/*  96 */       if ((isNew == null) || ("false".equals(isNew.trim()))) {
			/*  97 */         contentList = this.ctpMainbodyManager.transContentViewResponse(mType, Long.valueOf(moduleId), Integer.valueOf(viewState), rightId, indexParam, fromCopy);
			/*  98 */         if ((contentList == null) || (contentList.size() == 0)) {
			/*  99 */           throw new BusinessException("该正文不存在,moduleId=" + moduleId);
			/*     */         }
			/* 101 */         contentAll = (CtpContentAllBean)contentList.get(0);
			/*     */       }
			/*     */       else {
			/* 104 */         int contentType = ParamUtil.getInt(params, "contentType", true).intValue();
			/* 105 */         MainbodyType cType = MainbodyType.getEnumByKey(contentType);
			/* 106 */         if (cType == null) {
			/* 107 */           throw new BusinessException("contentType is not validate!");
			/*     */         }
			/* 109 */         contentAll = this.ctpMainbodyManager.transContentNewResponse(mType, Long.valueOf(moduleId), cType, rightId);
			/* 110 */         contentList = new ArrayList();
			/* 111 */         contentList.add(contentAll);
			/*     */       }
			/*     */       
			/*     */ 
			/* 115 */       style = (String)AppContext.getThreadContext("style");
			/* 116 */       if (("3".equals(style)) || ("4".equals(style))) {
			/* 117 */         content = new ModelAndView("common/content/lightContent");
			/*     */       } else {
			/* 119 */         content = new ModelAndView("common/content/content");
			/*     */       }
			/* 121 */       if (StringUtil.checkNull(style)) {
			/* 122 */         style = "1";
			/*     */       }
			/*     */       
			/*     */ 
			/* 126 */       content.addObject("openFrom", openFrom);
			/* 127 */       content.addObject("viewState", Integer.valueOf(viewState));
			/* 128 */       content.addObject("contentList", contentList);
			/* 129 */       content.addObject("formJson", contentAll.getExtraMap().get("formJson"));
			/* 130 */       content.addObject("indexParam", indexParam);
			/* 131 */       content.addObject("isNew", isNew);
			/* 132 */       content.addObject("style", style);
			/* 133 */       content.addObject("styleName", "4".equals(style) ? "phone" : "pc");
			/* 134 */       content.addObject("logoIcon", this.portalTemplateManager.getAccountLogo(Long.valueOf(AppContext.currentAccountId())));
			/*     */       
			/* 136 */       Map<String, String> map = (Map)AppContext.getCurrentUser().getCustomizeJson("form_stype", Map.class);
			/* 137 */       String rememberStyle = null;
			/* 138 */       if (map != null) {
			/* 139 */         rememberStyle = (String)map.get(String.valueOf(((CtpContentAllBean)contentList.get(0)).getContentTemplateId()));
			/*     */       }
			/* 141 */       content.addObject("rememberStyle", Boolean.valueOf(rememberStyle != null));
			/*     */     } catch (BusinessException be) {
			/* 143 */       log.error(be.getMessage(), be);
			/* 144 */       throw be;
			/*     */     }
			/* 146 */     return content;
			/*     */   }
}
