/**
 * 
 */
package com.seeyon.ctp.portal.engine.render;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.portal.designer.manager.PortalDesignerManager;
import com.seeyon.ctp.portal.engine.PageEngine;
import com.seeyon.ctp.portal.engine.model.PageLayoutBox;
import com.seeyon.ctp.portal.engine.model.PageLayoutComponent;
import com.seeyon.ctp.portal.engine.model.PageLayoutSpaceLink;
import com.seeyon.ctp.portal.engine.templete.PageComponent;
import com.seeyon.ctp.portal.engine.templete.PortalTplVar;
import com.seeyon.ctp.portal.engine.templete.PrefabricatedPageInit;
import com.seeyon.ctp.util.Strings;

import www.seeyon.com.utils.UUIDUtil;

/**
 * @author wangchw
 *
 */
public class PageLayoutBoxRender extends BaseRender {
	
	private final static Log LOGGER = LogFactory.getLog(PageLayoutBoxRender.class);

	public static RenderResult render(String contextPath,Map<String,List<PageLayoutBox>> boxes,
			List<PageLayoutSpaceLink> spaceLinks,String spaceStyle,Map<String,Object> dataMap) {
		RenderResult renderResult = new RenderResult();
		//静态HTML
		StringBuilder boxHtml = new StringBuilder();
		//CSS 样式
		StringBuilder boxCss = new StringBuilder();
				
		Set<String> keySet= boxes.keySet();
		int rowSize= keySet.size();
		String debuggerCss= "";
		if(PageEngine.isDebuuger()){//调试模式
			debuggerCss= "border:1px dashed blue;";
		}
		for (String rowNum : keySet) {
			
			List<PageLayoutBox> boxesList= boxes.get(rowNum);
			int boxsize= boxesList.size();
			if(boxsize==1){
				boxHtml.append("<div style='width:100%;' id='row_").append(rowNum).append("'>"); 
				PageLayoutBox pageLayoutBox= boxesList.get(0);
				String id = pageLayoutBox.getId();
				String className = id+"_" + UUIDUtil.getUUIDLong() + "_class";
				
				boxCss.append("\n\r.").append(className).append("{");
				boxCss.append(debuggerCss); 
				boxCss.append("}");
				boxHtml.append("<div id='").append(id).append("' class='").append(className).append("'>"); 
				PageLayoutComponent component = pageLayoutBox.getComponent();
				String cHtmlContent= getPageLayoutComponentHtml(component,contextPath,dataMap);
				if(Strings.isNotBlank(cHtmlContent)){
					boxHtml.append(cHtmlContent);
				}
				boxHtml.append("</div>");
				boxHtml.append("</div>");
			}else if(boxsize>1){
				boxHtml.append("<div style='float:left;width:100%;' id='row_").append(rowNum).append("'>"); 
				PageLayoutBox pageLayoutBox= boxesList.get(0);
				String id = pageLayoutBox.getId();
				String className = id+"_" + UUIDUtil.getUUIDLong() + "_class";
				String height = "100%";
				String align= "center";
				String floatValue= "left";
				
				boxCss.append("\n\r.").append(className).append("{");
				boxCss.append("text-align:"+align+";");
				boxCss.append("float:"+floatValue+";");
				boxCss.append("height:").append(height).append(";");
				boxCss.append(debuggerCss); 
				boxCss.append("}");
				boxHtml.append("<div id='").append(id).append("' class='").append(className).append("'>"); 
				PageLayoutComponent component = pageLayoutBox.getComponent();
				String cHtmlContent= getPageLayoutComponentHtml(component,contextPath,dataMap);
				if(Strings.isNotBlank(cHtmlContent)){
					boxHtml.append(cHtmlContent);
				}
				boxHtml.append("</div>");
				
				for (int i=boxsize-1;i>=1;i--) {
					PageLayoutBox pageLayoutBoxRight= boxesList.get(i);
					String id_right = pageLayoutBoxRight.getId();
					String className_right = id_right+"_" + UUIDUtil.getUUIDLong() + "_class";
					String height_right = "100%";
					String align_right= "center";
					String floatValue_right= "right";
					
					boxCss.append("\n\r.").append(className_right).append("{");
					boxCss.append("text-align:"+align_right+";");
					boxCss.append("float:"+floatValue_right+";");
					boxCss.append("height:").append(height_right).append(";");
					boxCss.append(debuggerCss); 
					boxCss.append("}");
					boxHtml.append("<div id='").append(id_right).append("' class='").append(className_right).append("'>"); 
					
					PageLayoutComponent component_right = pageLayoutBoxRight.getComponent();
					String cHtmlContent_right= getPageLayoutComponentHtml(component_right,contextPath,dataMap);
					if(Strings.isNotBlank(cHtmlContent_right)){
						boxHtml.append(cHtmlContent_right);
					}
					boxHtml.append("</div>");
				}
				boxHtml.append("</div>");
			}
		}
		boxHtml.append("<div style=\"clear:both\"></div>"); 
		//LOGGER.info("htmlSb:="+boxHtml.toString());
		//LOGGER.info("cssSb:="+boxCss.toString());
		renderResult.setHtmlContent(boxHtml.toString());
		renderResult.setCssContent(boxCss.toString());
		return renderResult;
	}

	/**
	 * 获得元件html内容
	 * @param component
	 * @param contextPath
	 * @return
	 */
	private static String getPageLayoutComponentHtml(PageLayoutComponent component,String contextPath,Map<String,Object> dataMap) {
		String cHtmlContent= "";
		if(null != component){
			String cid= component.getId();
			String cname= component.getName();
			String tplBeanId = component.getBeanId();
			String tplName= component.getTplName();
			String defaultStyle= component.getDefaultStyle();
			
			PortalDesignerManager portalDesignerManager= (PortalDesignerManager)AppContext.getBean("portalDesignerManager");
			
			try {
				cHtmlContent = portalDesignerManager.getPageComponentHtmlContentById(false, cname, tplBeanId, tplName, defaultStyle,
						cid, contextPath,"","",dataMap);
				
			} catch (BusinessException e) {
				LOGGER.error("", e);
			}
		}
		return cHtmlContent;
	}

}
