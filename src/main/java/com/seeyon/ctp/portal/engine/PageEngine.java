/**
 * 
 */
package com.seeyon.ctp.portal.engine;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.json.JSONArray;
import org.json.JSONObject;
import org.jsoup.Jsoup;

import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.portal.engine.model.PageLayout;
import com.seeyon.ctp.portal.engine.model.PageLayoutBox;
import com.seeyon.ctp.portal.engine.model.PageLayoutContainer;
import com.seeyon.ctp.portal.engine.model.PageLayoutSpace;
import com.seeyon.ctp.portal.engine.model.PageLayoutSpaceLink;
import com.seeyon.ctp.portal.engine.render.PageLayoutBoxRender;
import com.seeyon.ctp.portal.engine.render.PageRenderResult;
import com.seeyon.ctp.portal.engine.render.RenderResult;
import com.seeyon.ctp.portal.engine.templete.PageLayoutTemplete;
import com.seeyon.ctp.portal.engine.templete.PortalTempleteEngine;
import com.seeyon.ctp.portal.engine.templete.PrefabricatedPageInit;
import com.seeyon.ctp.portal.engine.util.ComponentFactory;
import com.seeyon.ctp.portal.engine.util.PageLayoutUtil;
import com.seeyon.ctp.portal.engine.util.SpaceLayoutUtil;
import com.seeyon.ctp.util.Strings;

/**
 * 页面引擎
 * @author wangchw
 *
 */
public class PageEngine {
	
	private final static Log LOGGER = LogFactory.getLog(PageEngine.class);
	
	private static boolean isDebugger= false;
	
	public static boolean isDebuuger(){
		return isDebugger;
	}
	
	/**
	 * @param args
	 * @throws Throwable 
	 */
	public static void main(String[] args) throws Throwable {
		String pagePath= "D:\\V5NewWorkSpace\\ctp-designer\\src\\main\\webapp\\data\\page001.xml";
		String destionationPath= "D:\\V5NewWorkSpace\\ctp-designer\\src\\main\\webapp\\data";
		//初始化缓存元件Bean定义
		String path = "D:\\V5NewWorkSpace\\ctp-designer/src/main/resources/spring-component.xml";
		
		String contextPath= "/seeyon";
		
		//浏览器宽度
		int clientWidth= 1024;
		//浏览器高度
		int clientHeight= 768;
		
		ComponentFactory.initComponent(path);
		//初始化缓存空间配置
		SpaceLayoutUtil.initSpaces(destionationPath);
		
		LOGGER.info("pagePath:="+pagePath);
		Document document= null;
		SAXReader reader= new SAXReader();
		InputStream ifile = new FileInputStream(pagePath);
		InputStreamReader isr = new InputStreamReader(ifile, "UTF-8");
		document= reader.read(isr);
		
		PageLayout page= getPageLayout(document);
		PageRenderResult htmlContent= generatePageHtml(-1l,contextPath,page,null, null);
		String htmlFile= destionationPath+File.separator+"1.html";
		FileUtils.writeStringToFile(new File(htmlFile), htmlContent.getBodyHtml());
		LOGGER.info("htmlFile:="+htmlFile);
	}
	
	/**
	 * 
	 * @param xmlContent
	 * @return
	 * @throws Throwable
	 */
	public static PageLayout parseXmlToPageLayout(String xmlContent) throws Exception{
		Document document= DocumentHelper.parseText(xmlContent); 
		PageLayout page= getPageLayout(document);
		return page;
	}

	private static PageRenderResult generatePageHtml(Long templateId,String contextPath,PageLayout page,Map<String,Object> dataMap, String theme) throws Exception {
		if(LOGGER.isDebugEnabled()){
		    LOGGER.debug("***********Portal Engine Start****************");
		    LOGGER.debug("id:="+page.getId());
		    LOGGER.debug("name:="+page.getName());
		    LOGGER.debug("description:="+page.getDescription());
		    LOGGER.debug("layoutTempleteId:="+page.getLayoutTempleteId());
		}
		
		if(Strings.isBlank(page.getLayoutTempleteId())){
			throw new Exception("页面渲染异常!");
		}
		PageRenderResult pageRenderResult= new PageRenderResult();
		
		PageLayoutTemplete pageLayoutTemplete= PrefabricatedPageInit.getPageLayoutTempleteById(page.getLayoutTempleteId());
		String htmlPath= pageLayoutTemplete.getHtmlPath();
		String cssPath= pageLayoutTemplete.getCssPath();
		String jsPath= pageLayoutTemplete.getJsPath();
		String defaultSkin= pageLayoutTemplete.getDefaultSkin();
		String layoutSimpleTplName= pageLayoutTemplete.getLayoutSimpleTplName();
		//String layoutSimpleHtmlContent= getLayoutSimpleHtmlContent(templateId,layoutSimpleTplName);
		pageRenderResult.setLayoutSimpleHtmlContent(""); 
		if(Strings.isNotBlank(theme)){
			defaultSkin= theme;
		}
		
		String defaultLayoutCssPath= contextPath+cssPath;
		Map<String,String> skinMap= pageLayoutTemplete.getSystemSkinList().get(defaultSkin);
		String skinPath= skinMap.get("path");
		String defaultSkinCssPath= contextPath + skinPath;
		String customJS= contextPath + jsPath;
		
		pageRenderResult.setCurrentTheme(defaultSkin);
		pageRenderResult.setDefaultLayoutCssPath(defaultLayoutCssPath);
		pageRenderResult.setDefaultSkinCssPath(defaultSkinCssPath);
		pageRenderResult.setCustomJS(customJS);
		//样式
		StringBuilder cssStringBuffer = new StringBuilder("");
		//获得所有容器
		List<PageLayoutContainer> pageData = page.getPageData();
		for (PageLayoutContainer pageLayoutContainer : pageData) {
			String containerId = pageLayoutContainer.getId();
			Map<String,List<PageLayoutBox>> boxes = pageLayoutContainer.getBoxes();
			RenderResult boxesResult = PageLayoutBoxRender.render(contextPath,boxes,page.getSpaceLinks(),page.getSpaceStyle(),dataMap);
			//取得容器对象
			if(boxesResult != null){
				pageRenderResult.putBodyHtmlData(containerId, boxesResult.getHtmlContent());
				if(Strings.isNotBlank(boxesResult.getCssContent())){
					cssStringBuffer.append(boxesResult.getCssContent()).append("\r\n");
				}
			}
		}
		pageRenderResult.setCustomCss(cssStringBuffer.toString());
		pageRenderResult.setBodyHtml(htmlPath);
		return pageRenderResult;
	}

	/**
	 * 获得布局样例html内容
	 * @param layoutSimpleTplName
	 * @return
	 */
	private static String getLayoutSimpleHtmlContent(Long templateId,String layoutSimpleTplName) {
		Map<String,Object> dataMap= new HashMap<String, Object>();
		dataMap.put("templateId", templateId);
		dataMap.put("portal_skin_head", ResourceUtil.getString("portal.skin.head"));
		dataMap.put("portal_skin_bgImg", ResourceUtil.getString("portal.skin.bgImg"));
		dataMap.put("portal_skin_color", ResourceUtil.getString("portal.skin.color"));
		dataMap.put("portal_skin_modify", ResourceUtil.getString("portal.skin.modify"));
		dataMap.put("portal_skin_menu", ResourceUtil.getString("portal.skin.menu"));
		dataMap.put("portal_skin_breadFontColor", ResourceUtil.getString("portal.skin.breadFontColor"));
		dataMap.put("portal_skin_sectionHeadingColor", ResourceUtil.getString("portal.skin.sectionHeadingColor"));
		dataMap.put("portal_skin_sectionContentColor", ResourceUtil.getString("portal.skin.sectionContentColor"));
		dataMap.put("portal_skin_pageBgImg", ResourceUtil.getString("portal.skin.pageBgImg"));
		dataMap.put("portal_skin_bgColor", ResourceUtil.getString("portal.skin.bgColor"));
		String htmlContent= PortalTempleteEngine.getComponentPropertyHtmlContent(layoutSimpleTplName, dataMap);
		return htmlContent;
	}

	/**
	 * 解析page.xml文件
	 * @param pagePath
	 */
	private static PageLayout getPageLayout(Document document) throws Exception {
		
		
		Element page = document.getRootElement(); 
		
		String id= page.element("id").getTextTrim();
		String name= page.element("name").getTextTrim();
		String description= page.element("description").getTextTrim();
		String spaceStyle= page.element("spaceStyle").getTextTrim();
		String layoutTempleteId= page.element("layoutTempleteId").getTextTrim();
		
		List<PageLayoutContainer> pageData= PageLayoutUtil.getPageData(page);
		
		List<PageLayoutSpaceLink> spaceLinks= PageLayoutUtil.getSpaceLinks(page);
			
		PageLayout pageLayout= new PageLayout();
		pageLayout.setId(id);
		pageLayout.setName(name);
		pageLayout.setDescription(description);
		pageLayout.setLayoutTempleteId(layoutTempleteId);
		pageLayout.setPageData(pageData);
		pageLayout.setSpaceLinks(spaceLinks);
		pageLayout.setSpaceStyle(spaceStyle);
		
		return pageLayout;
	}

	/**
	 * 预览解析方法
	 * @param layoutId 布局ID
	 * @param designedJsonData 设计数据
	 * @return
	 * @throws Throwable
	 */
	public PageRenderResult parseDesignedJsonData(String contextPath,String templeteId,String id, String pageCode, String pageName,String description,
			String designedJsonData,Map<String,String> propertiesMap,String theme) throws Exception {
		LOGGER.info("designedJsonData:="+designedJsonData);
		String pageXml= parseDesignedJsonToXml(templeteId,id, pageCode, pageName, description, designedJsonData,propertiesMap,theme);
		return geneareteHtmlFromXml(-1l,"",contextPath,pageXml,null);
	}
	
	public PageRenderResult geneareteHtmlFromXml(Long templateId,String skinId,String contextPath, String pageXml, Map<String,Object> dataMap) throws Exception{
	    PageLayout page= parseXmlToPageLayout(pageXml);
	    return geneareteHtmlFromXml(templateId, skinId, contextPath, page, dataMap);
	}
	
	/**
	 * 
	 * @param pageXml
	 * @return
	 * @throws Throwable
	 */
	public PageRenderResult geneareteHtmlFromXml(Long templateId,String skinId,String contextPath, PageLayout page, Map<String,Object> dataMap) throws Exception{
		PageRenderResult pageRenderResult= generatePageHtml(templateId,contextPath,page,dataMap, skinId);
		return pageRenderResult;
	}

	/**
	 * 解析成xml结构的字符串
	 * @param designedJsonData
	 * @return
	 */
	public String parseDesignedJsonToXml(String layoutTempleteId,String pageid,String pageCode,String pageName,String description
			,String designedJsonData,Map<String,String> propertiesMap,String theme) {
		try{
			Document doc = DocumentHelper.createDocument();
			Element rootElement = doc.addElement("page");
			rootElement.addElement("id").setText(pageid);
			rootElement.addElement("code").setText(pageCode);
			rootElement.addElement("name").setText(pageName);
//			rootElement.addElement("theme").setText(theme);
			rootElement.addElement("description").setText(description);
			rootElement.addElement("spaceStyle").setText("default");
			
			Element htmlElement= rootElement.addElement("layoutTempleteId");
			htmlElement.setText(layoutTempleteId);
			
			Element dataElement= rootElement.addElement("data");
			
			JSONObject designedPageObj= new JSONObject(designedJsonData);
			JSONArray containers= designedPageObj.getJSONArray("containers");
			int containerLength= containers.length();
			for(int i=0;i<containerLength;i++){
				JSONObject container= containers.getJSONObject(i);
				LOGGER.info("cotainer:="+container);
				
				JSONArray widgets_ul= container.getJSONArray("widgets_ul");
				int rowSize= widgets_ul.length();
				String id= container.getString("id");
				
				Element containerEle= dataElement.addElement("container");
				containerEle.addElement("id").setText(id);
				containerEle.addElement("name").setText(""); 
				Element boxesEle= containerEle.addElement("boxes");
				
				LOGGER.info("id:="+id);
				if(rowSize>0){
					for(int j=0;j<rowSize;j++){
						JSONArray rowObj= widgets_ul.getJSONArray(j);
						int boxSize= rowObj.length();
						for(int k=0;k< boxSize;k++){
							JSONObject boxObj= rowObj.getJSONObject(k);
							String bid= boxObj.getString("id");
							String col= boxObj.getString("col");
							String row= boxObj.getString("row");
							boolean isNotExist= boxObj.isNull("cid");
							String cid= "";
							String scid= "";
							String cname= "";
							String cbeanid= "";
							String ctplname= "";
							String cstyle= "";
							if(!isNotExist){//只要有元件时才获取下面的属性
								cid= boxObj.getString("cid"); 
								scid= boxObj.getString("scid"); 
								cname= boxObj.getString("cname");
								cbeanid= boxObj.getString("cbeanid");
								ctplname= boxObj.getString("ctplname");
								cstyle= boxObj.getString("cstyle");
							}
							String height= boxObj.getString("height");
							String width= boxObj.getString("width");
							String type= boxObj.getString("type");
							LOGGER.info("row:="+row+";col:="+col+";scid:="+scid+"cid:="+cid+";cname:="+cname+";cbeanid:="+cbeanid+";height:="+height+";width:="+width+";type:="+type);
							Element boxEle= boxesEle.addElement("box");
							boxEle.addElement("id").setText(bid);
							boxEle.addElement("row").setText(row);
							boxEle.addElement("col").setText(col);
							boxEle.addElement("height").setText(height);
							boxEle.addElement("width").setText(width);
							boxEle.addElement("heightUnit").setText(type);
							boxEle.addElement("widthUnit").setText(type);
							if(!isNotExist){//只要有元件时才获取下面的属性
								Element componentEle= boxEle.addElement("component");
								componentEle.addElement("scid").setText(scid);
								componentEle.addElement("cid").setText(cid);
								componentEle.addElement("name").setText(cname);
								componentEle.addElement("beanId").setText(cbeanid);
								componentEle.addElement("ctplname").setText(ctplname);
								componentEle.addElement("cstyle").setText(cstyle);
								Element propertiesElement= componentEle.addElement("properties");
								if(null!=propertiesMap && !propertiesMap.isEmpty()){
									Set<String> keys= propertiesMap.keySet();
									for (String propertyKey : keys) {
										if(propertyKey.startsWith(cid)){
											String propertyValue= propertiesMap.get(propertyKey);
											Element propertyElement= propertiesElement.addElement("property");
											propertyElement.addAttribute("name", propertyKey);
											propertyElement.addCDATA(propertyValue);
										}
									}
								}
							}
						}
					}
				}
			}
			String xmlData= doc.asXML().trim();//xmlToString(rootElement);
			int firstPosition= xmlData.indexOf("<");
			int lastPosition= xmlData.lastIndexOf(">")+1;
			xmlData= xmlData.substring(firstPosition, lastPosition);
			LOGGER.info("xmlData:="+xmlData);
			return xmlData;
		}catch(Throwable e){
			LOGGER.error("", e);
		}
		return "";
	}
}
