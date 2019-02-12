/**
 * 
 */
package com.seeyon.ctp.portal.designer.manager;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.io.SAXReader;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.authenticate.domain.UserCustomizeCache;
import com.seeyon.ctp.common.config.IConfigPublicKey;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.constants.ProductEditionEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.login.bo.MenuBO;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.designer.vo.SkinStyleAndCustomChoose;
import com.seeyon.ctp.portal.engine.PageEngine;
import com.seeyon.ctp.portal.engine.model.PageLayout;
import com.seeyon.ctp.portal.engine.model.PageLayoutBox;
import com.seeyon.ctp.portal.engine.model.PageLayoutComponent;
import com.seeyon.ctp.portal.engine.model.PageLayoutContainer;
import com.seeyon.ctp.portal.engine.po.PageLayoutDetailPO;
import com.seeyon.ctp.portal.engine.po.PageLayoutPO;
import com.seeyon.ctp.portal.engine.render.PageRenderResult;
import com.seeyon.ctp.portal.engine.templete.PageComponent;
import com.seeyon.ctp.portal.engine.templete.PageComponentProperty;
import com.seeyon.ctp.portal.engine.templete.PageComponentPropertyGroup;
import com.seeyon.ctp.portal.engine.templete.PageLayoutTemplete;
import com.seeyon.ctp.portal.engine.templete.PortalTempleteEngine;
import com.seeyon.ctp.portal.engine.templete.PrefabricatedPageInit;
import com.seeyon.ctp.portal.manager.PortalCacheManager;
import com.seeyon.ctp.portal.po.PortalHotspot;
import com.seeyon.ctp.portal.po.PortalSkinChoice;
import com.seeyon.ctp.portal.po.PortalSpacePage;
import com.seeyon.ctp.portal.po.PortalTemplate;
import com.seeyon.ctp.portal.portaltemplate.manager.PortalSkinChoiceManager;
import com.seeyon.ctp.portal.portaltemplate.manager.PortalTemplateManager;
import com.seeyon.ctp.portal.section.SectionManager;
import com.seeyon.ctp.portal.space.manager.PageManager;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.portal.util.Constants;
import com.seeyon.ctp.privilege.bo.PrivMenuBO;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.ZipUtil;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.v3x.common.web.login.CurrentUser;

/**
 * @author wangchw
 *
 */
public class PortalDesignerManagerImpl implements PortalDesignerManager {
	private PageLayoutManager pageLayoutManager;
	private FileManager fileManager;
	private AttachmentManager attachmentManager;
	private PortalCacheManager portalCacheManager;
	private PortalTemplateManager portalTemplateManager;
	private OrgManager orgManager;
	private SpaceManager   spaceManager;
	private static Map<String,String> adminPageLayoutMap= null;
	private SectionManager sectionManager;
	private PortalSkinChoiceManager portalSkinChoiceManager;
	private SystemConfig       systemConfig;
	
	public void setSystemConfig(SystemConfig systemConfig) {
		this.systemConfig = systemConfig;
	}

	public void setPortalSkinChoiceManager(PortalSkinChoiceManager portalSkinChoiceManager) {
		this.portalSkinChoiceManager = portalSkinChoiceManager;
	}
	
	public void setSectionManager(SectionManager sectionManager) {
		this.sectionManager = sectionManager;
	}

	static{
		if(adminPageLayoutMap==null){
			adminPageLayoutMap= new HashMap<String, String>();
			adminPageLayoutMap.put("7027426280743061268", "7027426280743061268");//56布局
			adminPageLayoutMap.put("5944355475318852694", "7027426280743061268");//简约A
			adminPageLayoutMap.put("7059914041343166950", "7027426280743061268");//极简版
			adminPageLayoutMap.put("-7632631074413524785", "-7632631074413524785");//51布局
			adminPageLayoutMap.put("7300734764521704320", "-7632631074413524785");//简约B
			adminPageLayoutMap.put("-1654125097880696520", "-7632631074413524785");//时尚A
			adminPageLayoutMap.put("5229646370380926247", "-7632631074413524785");//时尚B
		}
	}

	public void setSpaceManager(SpaceManager spaceManager) {
		this.spaceManager = spaceManager;
	}
	private final static Log LOGGER = LogFactory.getLog(PortalDesignerManagerImpl.class);
	
	/**
	 * 空间个数
	 */
	private int spacesNavNum= 3;
	
	/**
	 * 空间链接宽度
	 */
	private int spacesLinkWidth= 400;
	/**
	 * 空间链接高度
	 */
	private int spacesLinkHieght= 400;
	
	/**
	 * 菜单个数
	 */
	private int menusNum= 4;
	/**
	 * 菜单显示宽度
	 */
	private int menusWidth= 400;
	
	private int menusHeight= 400;
	
	private int v5bodyHeight= 400;

	private static final String pageLayoutRootPath= SystemEnvironment.getApplicationFolder();
	
	public PageLayoutManager getPageLayoutManager() {
		return pageLayoutManager;
	}

	public void setPageLayoutManager(PageLayoutManager pageLayoutManager) {
		this.pageLayoutManager = pageLayoutManager;
	}
	
	@Override
	public PageRenderResult generateHtmlPage(User user,String contextPath,Map<String, Object> dataMap) throws Exception {
		List<PortalTemplate> protalTemplateList= portalCacheManager.getTemplates(user);
		PortalTemplate protalTemplate= protalTemplateList.get(0);
		
		String hotSpotsJson= getTemplateHotspotsJson(protalTemplate);
		
		PortalHotspot layoutIdHotspot= protalTemplate.getPortalHotspotsMap().get("layoutId");
		String layoutId= "";
		if(null!=layoutIdHotspot){
			layoutId= layoutIdHotspot.getHotspotvalue();
		}else{
			if(protalTemplate.getId()==141322537970846464l){
				layoutId= "-7632631074413524785";
			}else if(protalTemplate.getId()==8950558293947007546l){
				layoutId= "7027426280743061268";
			}
		}
		String skinId= protalTemplate.getPortalHotspots().get(0).getExt10();
		if(user.isAdmin()){
			layoutId= adminPageLayoutMap.get(layoutId);
		}
		
		PageLayout pageLayout = portalCacheManager.getPortalPageLayoutXml(user,layoutId);
		
		Map<String, PortalHotspot> portalHotspotMap= protalTemplate.getPortalHotspotsMap();
		//Map<String, PortalHotspot> portalHotspotMap= portalTemplateManager.getPortalHotspotMap(protalTemplate.getId(), skinId);
		
		Long templateId= protalTemplate.getId();
		PageEngine pageEngine= new PageEngine();
		initCommonDataMap(contextPath, templateId.toString(), user, dataMap, false,null,null,null,portalHotspotMap);
		PageRenderResult pageRenderResult = pageEngine.geneareteHtmlFromXml(templateId,skinId,contextPath, pageLayout, dataMap);
		
		pageRenderResult.setHostSpotsJson(hotSpotsJson);
		return pageRenderResult;
	}

	private String getTemplateHotspotsJson(PortalTemplate pt) {
		List<Map<String, Object>> tl = new ArrayList<Map<String, Object>>();
		Map<String, Object> m= new HashMap<String, Object>();
		 m = new HashMap<String, Object>();
         m.put("id", pt.getId().toString());
         m.put("name", pt.getName());
         m.put("portalHotspots", pt.getPortalHotspots());
         tl.add(m);
        return JSONUtil.toJSONString(tl);
	}

	@Override
	public String savePageDesignedData(String isSetDefault,String templateId,String layoutTemplateId,String pageId,String pageCode,String pageName,String description,
			String designedData,Map<String,String> propertiesMap,String contextPath,String theme) throws Throwable {
		User currentUser= CurrentUser.get();
		Long loginAccountId= currentUser.getLoginAccount();
		long currentUserId= currentUser.getId();
		
		String imageName= propertiesMap.get("personHeadImgPath");
		String Cvalue= Strings.isNotBlank(imageName) ? imageName : "";
        UserCustomizeCache.setCustomize("avatar", Cvalue);
        propertiesMap.remove("personHeadImgPath");
        String layoutId= pageId;
        
		if(Strings.isBlank(pageId)){//新增
			Long id= UUIDLong.longUUID();
			Long detailId = UUIDLong.longUUID();
			layoutId= String.valueOf(id);
			PageLayoutPO pageLayoutPO = this.getPageLayoutPO(id, layoutTemplateId, pageName, pageCode, 0,theme,loginAccountId,currentUserId);
			pageLayoutPO.setSystemDefault(0);
			pageLayoutPO.setSystemInitialization(0);
			
			PageEngine pageEngine= new PageEngine();
			String xmlContent= pageEngine.parseDesignedJsonToXml(layoutTemplateId,detailId.toString(), pageCode, pageName, 
					description, designedData,propertiesMap,theme);
			
			PageRenderResult pageRenderResult= pageEngine.geneareteHtmlFromXml(-1l,"",contextPath,xmlContent,null);//html内容，根据templateId从模板中获取
			
			PageLayoutDetailPO pageLayoutDetailPO = this.getPageLayoutDetailPO(detailId,pageLayoutPO.getId(),pageRenderResult, theme, xmlContent);
			
			pageLayoutManager.saveSpacePageLayout(pageLayoutPO);
			pageLayoutManager.saveSpacePageLayoutDetail(pageLayoutDetailPO);
		}else{//修改
			if(Strings.isNotBlank(templateId)){//获取这个模板的热点数据
				PageLayoutPO pageLayoutPo= this.getPageLayoutById(layoutId);
				String templeteCode= pageLayoutPo.getTemplateCode();
				PageLayoutTemplete pageLayoutTemplete= this.getPageLayoutTempleteById(templeteCode);
				Map<String, Map<String, String>> skinList= pageLayoutTemplete.getSystemSkinList();
				Set<String> skinNameSet= skinList.keySet();
				for (String skinName : skinNameSet) {
					Map<String,PortalHotspot> portalHotspotsMap= portalTemplateManager.getPortalHotspotMap(Long.parseLong(templateId), skinName);
					if(null!= propertiesMap){
						Set<String> keys= propertiesMap.keySet();
						for (String key : keys) {
							int position= key.lastIndexOf("_")+1;
							String propertyName= key.substring(position);
							String value= propertiesMap.get(key);
							if("isNotShowLogo".equals(propertyName) && Strings.isNotBlank(value)){
								//if(skinName.equals(theme)){//当前正在修改的那套皮肤
									PortalHotspot logImgHotspot= portalHotspotsMap.get("logoImg");
									if("true".equals(value)){
										logImgHotspot.setDisplay(0);
									}else{
										logImgHotspot.setDisplay(1);
									}
								//}
							}else if("isNotShowGroup".equals(propertyName) && Strings.isNotBlank(value)){
								//if(skinName.equals(theme)){//当前正在修改的那套皮肤
									PortalHotspot groupNameHotspot= portalHotspotsMap.get("groupName");
									if(null!=groupNameHotspot){
										if("true".equals(value)){
											groupNameHotspot.setDisplay(0);
										}else{
											groupNameHotspot.setDisplay(1);
										}
									}
								//}
							}else if("isNotShowAccount".equals(propertyName) && Strings.isNotBlank(value)){
								//if(skinName.equals(theme)){//当前正在修改的那套皮肤
									PortalHotspot accountNameHotspot= portalHotspotsMap.get("accountName");
									if("true".equals(value)){
										accountNameHotspot.setDisplay(0);
									}else{
										accountNameHotspot.setDisplay(1);
									}
								//}
							}else if( "spaceNav".equals(propertyName) 
									  || "topHeight".equals(propertyName)
									  || "forwardBtn".equals(propertyName)
									  || "backBtn".equals(propertyName)
									  || "refreshBtn".equals(propertyName)
									){
								if("topHeight".equals(propertyName)){
									if(Strings.isBlank(value)){
										value= "50";
									}
									try{
										int topHeight= Integer.parseInt(value);
									}catch(Throwable e){
										LOGGER.error(""+value,e);
										throw new Exception("头部高度值不正确，请检查!");
									}
								}else{
									if(Strings.isBlank(value)){
										value= "true"; 
									}
								}
								PortalHotspot spaceNavHotspot= portalHotspotsMap.get(propertyName);
								if(null==spaceNavHotspot){//兼容处理
									PortalHotspot groupNameHotspot= portalHotspotsMap.get("accountName");
									spaceNavHotspot= (PortalHotspot) BeanUtils.cloneBean(groupNameHotspot);
									spaceNavHotspot.setId(UUIDLong.longUUID());
									spaceNavHotspot.setHotspotkey(propertyName);
									spaceNavHotspot.setName("hotspot.name."+propertyName);
									spaceNavHotspot.setEntityLevel("Group,Account,Member");
									spaceNavHotspot.setDisplay(0);
									spaceNavHotspot.setExt1("0");
									spaceNavHotspot.setExt2("0");
									spaceNavHotspot.setExt3("0");
									//spaceNavHotspot.setExt4("0");
									spaceNavHotspot.setExt5("0");
									spaceNavHotspot.setExt6("0");
									spaceNavHotspot.setExt7("0");
									spaceNavHotspot.setExt8("0");
								}
								spaceNavHotspot.setHotspotvalue(value);
								if(skinName.equals(theme)){//当前正在修改的那套皮肤
									portalHotspotsMap.put(propertyName,spaceNavHotspot);
								}else{
									if("topHeight".equals(propertyName)){
										portalHotspotsMap.put(propertyName,spaceNavHotspot);
									}
								}
							}else if(
									( "topBgColor".equals(propertyName)
											|| "lBgColor".equals(propertyName)
											|| "cBgColor".equals(propertyName)
											|| "mainBgColor".equals(propertyName)
											|| "breadFontColor".equals(propertyName)
											|| "sectionContentColor".equals(propertyName)
											|| "topFontColor".equals(propertyName) 
											|| "lFontColor".equals(propertyName) 
											|| "sectionHeadBgColor".equals(propertyName)
											|| "sectionHeadFontColor".equals(propertyName)
									) && Strings.isNotBlank(value)
							){//新增
								if(skinName.equals(theme)){//当前正在修改的那套皮肤
									JSONObject jsonObj= JSONObject.parseObject(value);
									String color= jsonObj.getString("color");
									String colorOpacity= jsonObj.getString("colorOpacity");
									String colorList= jsonObj.getString("colorList");
									String colorIndex= jsonObj.getString("colorIndex");
									if(Strings.isBlank(colorOpacity)){
										colorOpacity= "100";
									}
									
									PortalHotspot topFontColorHotspot= portalHotspotsMap.get(propertyName);
									if(null==topFontColorHotspot){//兼容处理
										PortalHotspot groupNameHotspot= portalHotspotsMap.get("mainBgColor");
										topFontColorHotspot= (PortalHotspot) BeanUtils.cloneBean(groupNameHotspot);
										topFontColorHotspot.setId(UUIDLong.longUUID());
										topFontColorHotspot.setHotspotkey(propertyName);
										topFontColorHotspot.setName("hotspot.name."+propertyName);
										topFontColorHotspot.setEntityLevel("Group,Account,Member");
									}
									topFontColorHotspot.setHotspotvalue(color);
									topFontColorHotspot.setExt5(colorOpacity);
									topFontColorHotspot.setExt7(colorList);
									topFontColorHotspot.setExt8(colorIndex);
								
									portalHotspotsMap.put(propertyName,topFontColorHotspot);
								}
							}else if("logoImg".equals(propertyName) && Strings.isNotBlank(value)){ 
								PortalHotspot logoImgHotspot= portalHotspotsMap.get("logoImg");
								logoImgHotspot.setHotspotvalue(value);
							}else if("topBgImg".equals(propertyName) || "mainBgImg".equals(propertyName)){
								if(skinName.equals(theme)){//当前正在修改的那套皮肤
									PortalHotspot logoImgHotspot= portalHotspotsMap.get(propertyName);
									logoImgHotspot.setHotspotvalue(value);
								}
							}
						}
					}
					LOGGER.info("propertiesMap:="+propertiesMap); 
					PortalHotspot layoutIdHotspot= portalHotspotsMap.get("layoutId");
					if(null==layoutIdHotspot){//兼容处理
						PortalHotspot groupNameHotspot= portalHotspotsMap.get("accountName");
						layoutIdHotspot= (PortalHotspot) BeanUtils.cloneBean(groupNameHotspot);
						layoutIdHotspot.setId(UUIDLong.longUUID());
						layoutIdHotspot.setHotspotkey("layoutId");
						layoutIdHotspot.setName("hotspot.name.layoutId");
						layoutIdHotspot.setEntityLevel("Group,Account,Member");
						layoutIdHotspot.setDisplay(0);
						layoutIdHotspot.setExt1("0");
						layoutIdHotspot.setExt2("0");
						layoutIdHotspot.setExt3("0");
						//spaceNavHotspot.setExt4("0");
						layoutIdHotspot.setExt5("0");
						layoutIdHotspot.setExt6("0");
						layoutIdHotspot.setExt7("0");
						layoutIdHotspot.setExt8("0");
					}
					layoutIdHotspot.setHotspotvalue(layoutId);
					portalHotspotsMap.put("layoutId", layoutIdHotspot);
					if("true".equals(isSetDefault)){
						if(skinName.equals(theme)){//当前正在修改的那套皮肤
							portalTemplateManager.updateHotSpots(true,portalHotspotsMap);
						}else{
							portalTemplateManager.updateHotSpots(false,portalHotspotsMap);
						}
					}else{
						portalTemplateManager.updateHotSpots(false,portalHotspotsMap);
					}
				}
			}
		}
		return layoutId;
	}

	private PageLayoutPO getPageLayoutPO(Long id,String templateId,String name,String code,Integer type,String theme,Long accountId,Long currentUserId){
		PageLayoutPO pageLayoutPO = new PageLayoutPO();
		pageLayoutPO.setId(id);
		pageLayoutPO.setCode(code);
		pageLayoutPO.setName(name);
		pageLayoutPO.setCreateDate(new Date());
		pageLayoutPO.setCreateUser(currentUserId);
		pageLayoutPO.setState(1);//启用
		pageLayoutPO.setTemplateCode(templateId); 
		pageLayoutPO.setTemplateType(type);
		pageLayoutPO.setTheme(theme);
		pageLayoutPO.setAccountId(accountId);
		pageLayoutPO.setSort(1);//默认排序号为1
		return pageLayoutPO;
	}
	
	private PageLayoutDetailPO getPageLayoutDetailPO(Long id,Long pMainId,PageRenderResult pageRenderResult,String theme,String xmlContent){
		PageLayoutDetailPO pageLayoutDetailPO= new PageLayoutDetailPO();
		pageLayoutDetailPO.setId(id);
		pageLayoutDetailPO.setLayoutId(pMainId);
		String layoutCssPath= pageRenderResult.getDefaultLayoutCssPath();
		String skinCssPath= pageRenderResult.getDefaultSkinCssPath();
		String customJs= pageRenderResult.getCustomJS();
		pageLayoutDetailPO.setLayoutCssPath(layoutCssPath);
		pageLayoutDetailPO.setSkinCssPath(skinCssPath);
		pageLayoutDetailPO.setCustomJsPath(customJs);
		pageLayoutDetailPO.setXmlContent(xmlContent);
		return pageLayoutDetailPO;
	}

	@Override
	public PageComponent getPageComponentById(String cid,String scid,String contextPath,String templateId,String skinStyle) throws BusinessException {
		PageComponent pageComponent= PrefabricatedPageInit.getPageComponentById(scid);
		Map<String, Object> dataMap= new HashMap<String, Object>();
		User user= CurrentUser.get();
		Map<String, PortalHotspot> portalHotspotMap= portalTemplateManager.getPortalHotspotMap(Long.parseLong(templateId), skinStyle);
		initCommonDataMap(contextPath, templateId, user, dataMap, true,null,null,null,portalHotspotMap); 
		dataMap.put(INSTANCE_COMPONENT_ID, cid);
		boolean isAllowUpdateAvatarEnable = true;
        String isAllowUpdateAvatar = systemConfig.get(IConfigPublicKey.ALLOW_UPDATE_AVATAR);
        if (isAllowUpdateAvatar != null && "disable".equals(isAllowUpdateAvatar)) {
            isAllowUpdateAvatarEnable = false;
        }
        dataMap.put("isAllowUpdateAvatarEnable", isAllowUpdateAvatarEnable);
		List<PageComponentPropertyGroup> propertygroups= pageComponent.getPropertygroups();
		if(null!=propertygroups){
			for (PageComponentPropertyGroup pageComponentPropertyGroup : propertygroups) {
				List<PageComponentProperty> properties= pageComponentPropertyGroup.getProperties();
				if(null!=properties){
					for (PageComponentProperty pageComponentProperty : properties) {
						String inputType= pageComponentProperty.getInputType();
						if("html".equals(inputType)){
							String propertyTplName= pageComponentProperty.getPropertyTplName();
							String htmlContent= PortalTempleteEngine.getComponentPropertyHtmlContent(propertyTplName, dataMap);
							htmlContent.replace("", "");
							pageComponentProperty.setDisplayHtmlContent(htmlContent);
						}
					}
				}
			}
		}
		return pageComponent;
	}
	
	@Override
	public String getPageComponentHtmlContentById(
			boolean isDesign,
			String cName,
			String tplBeanId,
			String tplName,
			String defaultStyle,
			String componentInstanceId,
			String contextPath,
			String templateId,
			String skinStyle,
			Map<String,Object> dataMap) throws BusinessException {
		String preHtml= PortalTempleteEngine.getComponentHtml(defaultStyle, tplName, dataMap);
		StringBuilder divBuilder= new StringBuilder();
		divBuilder.append("<div id=\"").append(componentInstanceId).append("\">");
		if(Strings.isNotBlank(preHtml)){
			divBuilder.append(preHtml);
		}
		divBuilder.append("</div>");
		return divBuilder.toString();  
	}

	/**
	 * 
	 * @param contextPath
	 * @param templateId
	 * @param user
	 * @param dataMap
	 * @param isDesign
	 * @param totalDisplayWidth
	 * @param totalDisplayHeight
	 * @throws BusinessException
	 */
	public void initCommonDataMap(String contextPath,String templateId,User user, Map<String, Object> dataMap,
			boolean isDesign,String layoutTempleteId,Integer totalDisplayWidth,Integer totalDisplayHeight,Map<String,PortalHotspot> portalHotspotMap) throws  BusinessException{
		boolean isShowUC= AppContext.hasPlugin("uc");
		boolean isShowSearch= AppContext.hasPlugin("index");
		
		dataMap.put("isShowUC", String.valueOf(isShowUC)); 
		dataMap.put("isShowSearch", String.valueOf(isShowSearch)); 
		V3xOrgAccount orgGroup= orgManager.getAccountById(OrgConstants.GROUPID); 
		V3xOrgAccount orgAccount= orgManager.getAccountById(AppContext.currentAccountId());
		String version=Functions.getSystemProperty("portal.porletSelectorFlag");
		if("A8".equals(version)){
			version="a8";
		}else if("A6".equals(version)||"A6s".equals(version)){
			version="a6";
		}else{//暂不考虑其他版本,统一给A8的标
			version="a8"; 
		}
		if(ProductEditionEnum.isU8OEM()){
			version = "a8u8";
		}
		String groupShortName = "";
		String groupSecondName = "";
		if( null!= orgGroup ){
			groupShortName = orgGroup.getShortName();
	        if(groupShortName == null){
	        	groupShortName= "";
	        } else {
	        	groupShortName= Strings.toHTML(groupShortName);
	        }
	        groupSecondName = orgGroup.getSecondName();
	        if(groupSecondName == null){
	        	groupSecondName= "";
	        } else {
	        	groupSecondName= Strings.toHTML(groupSecondName);
	        }
		}
		boolean isGroupVer = (Boolean)(SysFlag.sys_isGroupVer.getFlag());
		if(!isGroupVer){
			orgAccount= orgManager.getAccountById(OrgConstants.ACCOUNTID);
		}
		
        String accountName= orgAccount.getName();
		if(accountName == null){
			accountName= "";
        } else {
        	accountName= Strings.toHTML(accountName);
        }
		String accountSecondName= orgAccount.getSecondName();
		if(accountSecondName == null){
			accountSecondName= "";
        } else {
        	accountSecondName= Strings.toHTML(accountSecondName);
        }
		String forwardBtnDisplay= "true";
		String backBtnDisplay= "true";
		String refreshBtnDisplay= "true";
		String logoImgPath= "";
		String groupNameDisplayChecked= "";
		String showGroupName= "true";
		String accountNameDisplayChecked= "";
		String showAccountName= "true";
		String logoDisplayChecked= "";
		String showLogoImg= "true";
		int topHeight= 50;
		if(null!=portalHotspotMap){
			PortalHotspot forwardBtnHotspot= portalHotspotMap.get("forwardBtn");
			PortalHotspot backBtnHotspot= portalHotspotMap.get("backBtn");
			PortalHotspot refreshBtnHotspot= portalHotspotMap.get("refreshBtn");
			
			PortalHotspot logoImgHotspot= portalHotspotMap.get("logoImg");
			PortalHotspot groupNameHotspot= portalHotspotMap.get("groupName");
			PortalHotspot accountNameHotspot= portalHotspotMap.get("accountName");
			PortalHotspot topHeightHotspot= portalHotspotMap.get("topHeight");
			
			if(null!=topHeightHotspot && Strings.isNotBlank(topHeightHotspot.getHotspotvalue())){
				try{
					Double double1= Double.parseDouble(topHeightHotspot.getHotspotvalue());
					topHeight = double1.intValue();
				}catch(Throwable e){
					LOGGER.warn("", e);
				}
			}
			
			if(null!=forwardBtnHotspot){
				forwardBtnDisplay= forwardBtnHotspot.getHotspotvalue();
			}
			if(null!=backBtnHotspot){
				backBtnDisplay= backBtnHotspot.getHotspotvalue();
			}
			if(null!=refreshBtnHotspot){
				refreshBtnDisplay= refreshBtnHotspot.getHotspotvalue();
			}
			logoImgPath= logoImgHotspot.getHotspotvalue();
			int display=1;
			if(null!=groupNameHotspot){
				display= groupNameHotspot.getDisplay();
			}
			if(display == 1){
				showGroupName= "false";
			}else{
				groupNameDisplayChecked= "checked";
				showGroupName= "true";
			}
			int display1=1 ;
			if(null!=accountNameHotspot){
				display1= accountNameHotspot.getDisplay();
			} 
			if(display1 == 1){
				showAccountName= "false";
			}else{
				showAccountName= "true";
				accountNameDisplayChecked= "checked";
			}
			int display2= logoImgHotspot.getDisplay();
			if(display2 == 1){
				showLogoImg= "false";
			}else{
				showLogoImg= "true";
				logoDisplayChecked= "checked";
			}
		}
		String spaceUrl= "";
		String spaceName= ResourceUtil.getString("space.default.personal.label");
		String isCanEditSpace= "false";
		List<String[]> spaces= new ArrayList<String[]>();
		int companyLogoWidth= 400;
		if(isDesign){
			if(!user.isAdmin()){
				List<String[]> spaces1= portalCacheManager.getSpaces(user,Constants.SpaceCategory.pc.name());
				spaceUrl= contextPath + "/portal/homePageDesigner.do?method=simpleSpace";
				if(null!= spaces1 && !spaces1.isEmpty()){
					String spaceType= spaces1.get(0)[6];
					spaceUrl= spaces1.get(0)[2]; 
					spaceName= Strings.escapeJavascript(spaces1.get(0)[3]);
					if(!spaceUrl.startsWith("/seeyon/")){ 
						spaceUrl = "/seeyon"+spaceUrl;
					}
					boolean isThisSpaceExist=  sectionManager.isThisSpaceExist(spaceUrl);
	//				if( isThisSpaceExist && ("0".equals(spaceType) || "5".equals(spaceType) || "15".equals(spaceType)
	//						|| "16".equals(spaceType) || "14".equals(spaceType)  || "9".equals(spaceType) || "10".equals(spaceType)) ){//个人类型、外部人员空间和领导类型的空间才可以编辑
					if(isThisSpaceExist){
						isCanEditSpace= "true";
					}
				}
				for (String[] spaceInfo : spaces1) {
					String[] newSpaceInfo= new String[spaceInfo.length];
					if(null!=spaceInfo && spaceInfo.length>0){
						for (int i = 0; i < spaceInfo.length; i++) {
							String spaceInfoTemp = spaceInfo[i]; 
							if(i==3){
								if(spaceInfoTemp.length()>6){
									spaceInfoTemp= spaceInfoTemp.substring(0,6);
								}
							}
							newSpaceInfo[i]= StringEscapeUtils.escapeHtml(spaceInfoTemp); 
						}
					}
					spaces.add(newSpaceInfo); 
				}
			}else{
				String[] personalSpace= new String[]{"1","","",ResourceUtil.getString("seeyon.top.personal.space.label"),"",""};//个人空间
				String[] accountSpace= new String[]{"2","","",ResourceUtil.getString("seeyon.top.public_.space.label"),"",""};//单位空间
				String[] groupSpace= new String[]{"3","","",ResourceUtil.getString("seeyon.top.public_.space.label.group"),"",""};//集团空间
				spaces.add(personalSpace); 
				spaces.add(accountSpace);
				spaces.add(groupSpace);
			}
			
			if(null!=totalDisplayWidth && null!=totalDisplayHeight){
				if("layout001".equals(layoutTempleteId)){//layout001 经典-A
					spacesLinkWidth= totalDisplayWidth - totalOtherWidth - a01_header_CompanyLogo_Width - a01_header_OperateButton_Width;
					spacesLinkWidth= spacesLinkWidth-30;
					spacesNavNum= spacesLinkWidth / 122;
					menusWidth= totalDisplayWidth - totalOtherWidth- a01_nav_PersonHead_Width - a01_nav_ShortCut_Width;
					menusNum= menusWidth/100;
					menusWidth= menusWidth - 3;
					v5bodyHeight= totalDisplayHeight;// - totalOtherHeight - a01_header_Height - a01_nav_Height - a01_spaceNav_Height;
				}else if("layout002".equals(layoutTempleteId)){//layout002 经典-B
					spacesLinkWidth= totalDisplayWidth - totalOtherWidth - b01_header_CompanyLogo_Width - b01_header_OperateButton_Width;
					spacesLinkWidth= spacesLinkWidth-30;
					spacesNavNum= spacesLinkWidth / 122;
					//菜单高度
					menusHeight= totalDisplayHeight - totalOtherHeight - topHeight -  b01_nav_PersonHead_Height - b01_nav_ShortCut_Height;
					menusNum= menusHeight/50;
					v5bodyHeight= totalDisplayHeight;// - totalOtherHeight - b01_header_Height - b01_spaceNav_Height;
				}else if("layout003".equals(layoutTempleteId)){//layout003 时尚-A
					spacesLinkHieght= totalDisplayHeight - totalOtherHeight - c01_nav_PersonHead_Height - c01_nav_ShortCut_Height;
					spacesNavNum= spacesLinkHieght / 50;
					if(spaces.size()>spacesNavNum){
						spacesNavNum= (spacesLinkHieght-50)/50;
					}
					
					//菜单宽度
					menusWidth= totalDisplayWidth - totalOtherWidth- c01_nav_Width;
					menusNum= menusWidth/100;
					menusWidth= menusWidth - 3;
					
					v5bodyHeight= totalDisplayHeight;// - totalOtherHeight - c01_header_Height - c01_spaceNav_Height;
					
					companyLogoWidth = totalDisplayWidth - totalOtherWidth- c01_nav_Width - c01_header_OperateButton_Width;
				}else if("layout004".equals(layoutTempleteId)){//layout004 简约-A
					companyLogoWidth = totalDisplayWidth - totalOtherWidth- a02_header_OperateButton_Width;
					
					spacesLinkWidth= totalDisplayWidth - totalOtherWidth - a02_nav_PersonHead_Width - a02_nav_ShortCut_Width;
					spacesLinkWidth= spacesLinkWidth-63;
					spacesNavNum= spacesLinkWidth / 96;
					
					v5bodyHeight= totalDisplayHeight;// - totalOtherHeight - a02_header_Height - a02_nav_Height - a02_spaceNav_Height;
				}else if("layout005".equals(layoutTempleteId)){//layout005 简约-B
					companyLogoWidth = totalDisplayWidth - totalOtherWidth- b02_header_OperateButton_Width;
					
					spacesLinkHieght= totalDisplayHeight - totalOtherHeight - topHeight - b02_nav_PersonHead_Height - b02_nav_ShortCut_Height;
					spacesNavNum= spacesLinkHieght / 50;
					if(spaces.size()>spacesNavNum){
						spacesNavNum= (spacesLinkHieght-50)/50;
					}
					
					v5bodyHeight= totalDisplayHeight;// - totalOtherHeight - b02_header_Height - b02_spaceNav_Height;
				}else if("layout006".equals(layoutTempleteId)){//layout006 时尚-B
					spacesLinkHieght= totalDisplayHeight - totalOtherHeight - c02_nav_PersonHead_Height - c02_nav_ShortCut_Height;
					spacesNavNum= spacesLinkHieght / 50;
					if(spaces.size()>spacesNavNum){
						spacesNavNum= (spacesLinkHieght-50)/50;
					}
					
					v5bodyHeight= totalDisplayHeight;// - totalOtherHeight - c02_header_Height - c02_spaceNav_Height;
					
					companyLogoWidth = totalDisplayWidth - totalOtherWidth- c02_nav_Width - c02_header_OperateButton_Width;
					
				}else if("layout007".equals(layoutTempleteId)){//layout007 极简版
					spacesLinkWidth= totalDisplayWidth - totalOtherWidth - a03_header_CompanyLogo_Width - a03_header_OperateButton_Width;
					spacesLinkWidth= spacesLinkWidth-30;
					spacesNavNum= spacesLinkWidth / 122;
					
					v5bodyHeight= totalDisplayHeight;// - totalOtherHeight - a03_header_Height - a03_spaceNav_Height;
				} 
			}
		}
		boolean isGroupAdmin= user.isGroupAdmin();
		boolean isAdmin= user.isAdmin();
		boolean isSystemAdmin= user.isSystemAdmin();
		boolean isAdministrator= user.isAdministrator();
		boolean isCommonUser= !user.isAdmin();
		boolean isSuperAdmin= user.isSuperAdmin();
		boolean isAuditAdmin= user.isAuditAdmin();
		String systemProductId= SystemProperties.getInstance().getProperty("system.ProductId");
		String productVersion= SystemProperties.getInstance().getProperty("portal.porletSelectorFlag");
		String fontnotshow= ResourceUtil.getString("template.portal.fontnotshow");
		String groupLabelName= "";
		String accountLabelName= ResourceUtil.getString("hotspot.name.accountName");
		if("G6".equals(productVersion)){//G6产品
			groupLabelName = ResourceUtil.getString("hotspot.name.orgName");
        } else {
        	groupLabelName = ResourceUtil.getString("hotspot.name.groupName");
        }
		//获取是否允许修改皮肤风格的权限控制信息
		int parentAllowCustomize = 1;
		int parentAllowChooseSkin = 1;
		int selfAllowChooseSkin = 1;
		int selfAllowCustomize = 1;
		String allowHotSpotCustomizeDisabled = "";
		Long memberId= user.getId();
		List<MenuBO> menuList= null;
		int menuSize= 0;
		if(isDesign){
			if(Strings.isNotBlank(templateId)){
				SkinStyleAndCustomChoose skinStyleAndCustomChoose= portalTemplateManager.getAllowSkinStyleAndCustomChooseInfo(Long.parseLong(templateId));
				//获取当前人员是否被上一层级允许选择风格,以及当前人员对下一层级的设置
				parentAllowChooseSkin = skinStyleAndCustomChoose.getParentAllowChooseSkin();
				selfAllowChooseSkin = skinStyleAndCustomChoose.getSelfAllowChooseSkin();
				//获取当前人员是否被上一层级允许自定义热点,以及当前人员对下一层级的设置
				parentAllowCustomize = skinStyleAndCustomChoose.getParentAllowCustomize();
				selfAllowCustomize = skinStyleAndCustomChoose.getSelfAllowCustomize();
			}
			if(user.isAdministrator()){//单位管理员
		        allowHotSpotCustomizeDisabled = parentAllowCustomize == 0 ? "disabled='disabled'" : "";  
			}
			if(!user.isAdmin()){
				menuList= spaceManager.getCustomizeMenusOfMember(user, null);
			}else{
				menuList= new ArrayList<MenuBO>();
				
				PrivMenuBO privMenu1= new PrivMenuBO();
				privMenu1.setName(ResourceUtil.getString("menu.collaboration"));//协同工作
				MenuBO menu1= new MenuBO(privMenu1);
				
				PrivMenuBO privMenu2= new PrivMenuBO();
				privMenu2.setName(ResourceUtil.getString("menu.form"));//表单应用
				MenuBO menu2= new MenuBO(privMenu2);
				
				PrivMenuBO privMenu3= new PrivMenuBO();
				privMenu3.setName(ResourceUtil.getString("system.menuname.CultureConstruction"));//文化建设
				MenuBO menu3= new MenuBO(privMenu3);
				
				PrivMenuBO privMenu4= new PrivMenuBO();
				privMenu4.setName(ResourceUtil.getString("menu.meeting.manage"));//会议管理
				MenuBO menu4= new MenuBO(privMenu4);
				
				PrivMenuBO privMenu5= new PrivMenuBO();
				privMenu5.setName(ResourceUtil.getString("menu.edoc.edocManager"));//公文管理
				MenuBO menu5= new MenuBO(privMenu5);
				
				menuList.add(menu1);
				menuList.add(menu2);
				menuList.add(menu3);
				menuList.add(menu4);
				menuList.add(menu5);
			}
		}
		String imagePathValue= "";
		if(!user.isAdmin() || isDesign){
			imagePathValue= OrgHelper.getAvatarImageUrl(memberId, contextPath);
		}
		dataMap.put(HEADER_LOGO_SHOW, showLogoImg);
		dataMap.put(HEADER_LOGO_CHECKED, logoDisplayChecked);
		dataMap.put(HEADER_ACCOUNT_SHOW, showAccountName);
		dataMap.put(HEADER_ACCOUNTNAME_CHECKED, accountNameDisplayChecked);
		dataMap.put(HEADER_GROUP_SHOW, showGroupName);
		dataMap.put(HEADER_GROUPNAME_CHECKED, groupNameDisplayChecked);
		dataMap.put(HEADER_SHOW_FORWARD_BTN, forwardBtnDisplay);
		dataMap.put(HEADER_SHOW_BACK_BTN, backBtnDisplay);
		dataMap.put(HEADER_SHOW_REFRESH_BTN, refreshBtnDisplay);
		dataMap.put(HEADER_LOGO_IMAGE_PATH,logoImgPath);
		dataMap.put(HEADER_GROUP_SHORTNAME,groupShortName);
		dataMap.put(HEADER_GROUP_SECONDNAME,groupSecondName);
		dataMap.put(HEADER_ACCOUNT_SHORTNAME,accountName);
		dataMap.put(HEADER_ACCOUNT_SECONDNAME,accountSecondName);
		dataMap.put(v5bodyHeight_Name, v5bodyHeight);
		dataMap.put(spacesNum_Name, spacesNavNum);
		dataMap.put(menusNum_Name, menusNum);
		dataMap.put(menusWidth_Name, menusWidth);
		dataMap.put(menusHeight_Name,menusHeight);
		dataMap.put(spacesLinkWidth_Name, spacesLinkWidth);
		dataMap.put(spacesLinkHieght_Name,spacesLinkHieght);
		dataMap.put(companyLogoWidth_Name,companyLogoWidth);
		dataMap.put(IS_ADMIN_KEY, String.valueOf(isAdmin)); 
		dataMap.put(IS_SYSTEMADMIN_KEY, String.valueOf(isSystemAdmin)); 
		dataMap.put(IS_DESIGNER_KEY, String.valueOf(isDesign));
		dataMap.put(IS_ADMINISTRATOR, String.valueOf(isAdministrator));
		dataMap.put(IS_COMMON_USER, String.valueOf(isCommonUser));
		dataMap.put(IS_SUPERADMIN_KEY, String.valueOf(isSuperAdmin));
		dataMap.put(IS_AUDITADMIN_KEY, String.valueOf(isAuditAdmin));
		dataMap.put(IS_GROUPADMIN_KEY, String.valueOf(isGroupAdmin));
		dataMap.put(CONTEXT_PATH, contextPath);
		dataMap.put(SYSTEM_PRODUCT_ID, systemProductId); 
		dataMap.put(I18N_FONT_NOT_SHOW, fontnotshow);
		dataMap.put(I18N_GROUP_LABEL_NAME, groupLabelName);
		dataMap.put(I18N_ACCOUNT_LABEL_NAME, accountLabelName);
		dataMap.put(CONTEXT_PATH, contextPath);
		dataMap.put("menu_personal_agent_label", ResourceUtil.getString("menu.personal.agent.label"));
		dataMap.put("portal_onlineNum_label", ResourceUtil.getString("portal.onlineNum.label"));
		dataMap.put("menu_hr_personal_attendance_manager", ResourceUtil.getString("menu.hr.personal.attendance.manager"));
		dataMap.put("portal_onlineState_label1", ResourceUtil.getString("portal.onlineState.label1"));
		dataMap.put("portal_onlineState_label2", ResourceUtil.getString("portal.onlineState.label2"));
		dataMap.put("portal_onlineState_label3", ResourceUtil.getString("portal.onlineState.label3"));
		dataMap.put("portal_onlineState_label4", ResourceUtil.getString("portal.onlineState.label4"));
		dataMap.put("portal_menu_shortcut_label", ResourceUtil.getString("portal.menu.shortcut.label"));
		
		dataMap.put("appCenterName", ResourceUtil.getString("menu.workDesktop.label"));
		dataMap.put("searchName", ResourceUtil.getString("index.search.button"));
		dataMap.put("backName", ResourceUtil.getString("seeyon.top.back.alt"));
		dataMap.put("forwardName", ResourceUtil.getString("seeyon.top.forward.alt"));
		dataMap.put("refreshName", ResourceUtil.getString("common.toolbar.refresh.label"));
		boolean isHasUc = AppContext.hasPlugin("zx");//判断是否有致信
		dataMap.put("isHasUc", isHasUc);
		dataMap.put("zhixinName", ResourceUtil.getString("menu.ucMsg.label"));
		dataMap.put("aboutName", ResourceUtil.getString("menu.tools.about"));
		dataMap.put("settingName", ResourceUtil.getString("menu.setting.label"));
		
		dataMap.put("currenthead", ResourceUtil.getString("portal.design.currenthead"));
		dataMap.put("edithead", ResourceUtil.getString("portal.design.edithead"));
		dataMap.put("headheight", ResourceUtil.getString("portal.design.home.headheight"));
		
		dataMap.put("version", version);//控制关于按钮图标		
		
		dataMap.put("allowHotSpotCustomizeDisabled", allowHotSpotCustomizeDisabled);
		dataMap.put(spaceLinks, spaces);
		dataMap.put(totalSpacesNum, spaces.size());
		dataMap.put(PERSON_HEAD_IMAGE_PATH, imagePathValue);
		dataMap.put(PERSONAL_SPACE_NAME, spaceName);
		Object realNumObj= dataMap.get(HEADER_ONLINE_NUM);
		if(null==realNumObj){
			dataMap.put(HEADER_ONLINE_NUM, 0);
		}
		dataMap.put(PERSONAL_SPACE_URL, spaceUrl);
		dataMap.put(PERSONAL_SPACE_NAME, spaceName);
		dataMap.put(IS_CAN_EDIT_SPACE, isCanEditSpace);
		dataMap.put(menusData, menuList); 
		if(null!=menuList){
			menuSize= menuList.size();
		}
		dataMap.put(totalMenusNum, menuSize); 
	}

	@Override
	public String getPageComponentHtmlContentById(String componentInstanceId,String componentId,String contextPath) throws BusinessException {
		PageComponent pageComponent= PrefabricatedPageInit.getPageComponentById(componentId);
		String cName= pageComponent.getName();
		String tplBeanId= pageComponent.getTplBeanId();
		String defaultStyle= pageComponent.getDefaultStyle();
		String tplName= pageComponent.getTplName();
		String htmlContent= this.getPageComponentHtmlContentById(true, cName, tplBeanId, tplName,defaultStyle,
				componentInstanceId,contextPath,"","",null);
		return htmlContent;
	}

	@Override
	public PageLayoutTemplete getPageLayoutTempleteById(String currentPageLayoutId) throws BusinessException {
		PageLayoutTemplete pageLayoutTemplete= PrefabricatedPageInit.getPageLayoutTempleteById(currentPageLayoutId);
		String applicationFolder= SystemEnvironment.getApplicationFolder();
		String pageLayoutHtmlPath= applicationFolder + File.separator + pageLayoutTemplete.getDesignerHtmlPath();
		File htmlFile= new File(pageLayoutHtmlPath);
		String htmlContent= "";
		try {
			htmlContent = FileUtils.readFileToString(htmlFile, "utf-8");
			Document document= Jsoup.parse(htmlContent);
			Element bodyElement= document.getElementsByTag("body").get(0);
			htmlContent= bodyElement.html(); 
		} catch (IOException e) {
			LOGGER.error("首页布局模板读取异常",e);
		}
		pageLayoutTemplete.setHtmlContent(htmlContent);
		return pageLayoutTemplete;
	}

	@Override
	public PageLayoutTemplete uploadPageLayoutAttachment(String attchmentIdStr,String createDate,String fileUrl) throws BusinessException {
		try{
			String rootPath= fileManager.getFolder(Datetimes.parse(createDate,"yyyy-MM-dd"), false);
			String filePath= rootPath + File.separator+ fileUrl;
			File zipFile= new File(filePath);
			
			String pageLayoutId= String.valueOf(UUIDLong.longUUID());
			
			String relativePath= File.separator+"common/designer/pageLayout"+File.separator+pageLayoutId+File.separator;
			String uploadPageLayoutPath= pageLayoutRootPath+relativePath;
			File unzipDirectory= new File(uploadPageLayoutPath);
			
			ZipUtil.unzip(zipFile, unzipDirectory);
			
			String layoutDescriptionXml= uploadPageLayoutPath+File.separator+ "layout.xml";
			
			//解析上传的布局文件
			SAXReader reader = new SAXReader();
			InputStream ifile = new FileInputStream(layoutDescriptionXml);
			InputStreamReader isr = new InputStreamReader(ifile, "UTF-8");
			org.dom4j.Document document = reader.read(isr);

			org.dom4j.Element root = document.getRootElement();
			String name= root.elementTextTrim("name");
			String preImage= root.elementTextTrim("preImage");
			
			String designerHtmlPath= root.elementTextTrim("designerHtmlPath");
			String designerCssPath= root.elementTextTrim("designerCssPath");
			String designerJsPath= root.elementTextTrim("designerJsPath");
			
			String htmlPath= root.elementTextTrim("htmlPath");
			String cssPath= root.elementTextTrim("cssPath");
			String jsPath= root.elementTextTrim("jsPath");
			
			String defaultSkin= root.elementTextTrim("defaultSkin");
			
			PageLayoutTemplete pageLayoutTemplete= new PageLayoutTemplete();
			pageLayoutTemplete.setId(pageLayoutId);
			pageLayoutTemplete.setName(name);
			
			pageLayoutTemplete.setDesignerHtmlPath(relativePath+designerHtmlPath);
			pageLayoutTemplete.setDesignerCssPath(relativePath+designerCssPath);
			pageLayoutTemplete.setDesignerJsPath(relativePath+designerJsPath);
			
			pageLayoutTemplete.setHtmlPath(relativePath+htmlPath);
			pageLayoutTemplete.setCssPath(relativePath+cssPath);
			pageLayoutTemplete.setJsPath(relativePath+jsPath);
			
			pageLayoutTemplete.setDefaultSkin(defaultSkin);
			
			org.dom4j.Element skinsElement= root.element("skins");
			LinkedHashMap<String,Map<String,String>> allSkinMap= new LinkedHashMap<String,Map<String,String>>();
			List<org.dom4j.Element> skinsListElement= skinsElement.elements("skin");
			for (org.dom4j.Element skinElement : skinsListElement) {
				String skin_id= skinElement.attributeValue("id");
				String skin_name= skinElement.attributeValue("name");
				String skin_imagesrc= skinElement.attributeValue("imagesrc");
				String skin_path= skinElement.getTextTrim();
				Map<String,String> skinMap= new HashMap<String,String>();
				skinMap.put("id", skin_id);
				skinMap.put("name", skin_name);
				skinMap.put("path", skin_path);
				skinMap.put("imagesrc", skin_imagesrc);
				allSkinMap.put(skin_id, skinMap);
			}
			
			String defaultThemeCssPath= allSkinMap.get(defaultSkin).get("path");
			pageLayoutTemplete.setDefaultThemeCssPath(defaultThemeCssPath);
			
			pageLayoutTemplete.setSkinList(allSkinMap);

			
			PrefabricatedPageInit.putPageLayoutTemplete(pageLayoutId,pageLayoutTemplete);
			
			//删除file
			Long fileId= Long.parseLong(fileUrl);
			fileManager.deleteFile(fileId, true);
			
			//删除attchment
			Long attachmentId= Long.parseLong(attchmentIdStr);
			attachmentManager.deleteById(attachmentId);
			return pageLayoutTemplete;
		}catch(Throwable e){
			LOGGER.error("布局文件上传异常",e);
			throw new BusinessException(e);
		}
	}

	public FileManager getFileManager() {
		return fileManager;
	}

	public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}

	public AttachmentManager getAttachmentManager() {
		return attachmentManager;
	}

	public void setAttachmentManager(AttachmentManager attachmentManager) {
		this.attachmentManager = attachmentManager;
	}

	@Override
	public PageLayoutPO getPageLayoutById(String pageId) throws BusinessException {
		PageLayoutPO po= pageLayoutManager.getPageLayoutById(pageId);
		return po;
	}

	@Override
	public PageLayoutDetailPO getPageLayoutDetailByLayoutId(String pageId) throws BusinessException {
		PageLayoutDetailPO po= pageLayoutManager.getPageLayoutDetailByLayoutId(pageId);
		return po;
	}

	@Override
	public Map<String, PageLayoutComponent> getPageComponentsMapByXml(boolean isDesigner,PageLayout pageLayout,String contextPath
			,String templateId,String skinStyle,Map<String,Object> dataMap) throws BusinessException {
		Map<String,PageLayoutComponent> componentsMap= new HashMap<String,PageLayoutComponent>();
		try{
			List<PageLayoutContainer> pageLayoutContainers= pageLayout.getPageData();
			if(null!=pageLayoutContainers){
				for (PageLayoutContainer pageLayoutContainer : pageLayoutContainers) {
					Map<String,List<PageLayoutBox>> boxes = pageLayoutContainer.getBoxes();
					Set<String> keySet= boxes.keySet();
					for (String rowNum : keySet) {
						List<PageLayoutBox> boxesList= boxes.get(rowNum);
						int boxsize= boxesList.size();
						for (int i=0;i< boxsize;i++) {
							PageLayoutBox pageLayoutBox= boxesList.get(i);
							String id = pageLayoutBox.getId();
							
							PageLayoutComponent component = pageLayoutBox.getComponent();
							if(null != component){
								String cid= component.getId();
								String scid= component.getScid();
								String cname= component.getName();
								String tplBeanId = component.getBeanId();
								String tplName= component.getTplName();
								String defaultStyle= component.getDefaultStyle();
								PageComponent pageComponent= PrefabricatedPageInit.getPageComponentById(scid);
								
								String cHtmlContent= this.getPageComponentHtmlContentById(isDesigner, cname, tplBeanId, tplName, defaultStyle,
											cid, contextPath,templateId,skinStyle,dataMap);
								String htmlContent = StringEscapeUtils.escapeJavaScript(cHtmlContent);
								
								PageLayoutComponent pageComponent2= new PageLayoutComponent();
								pageComponent2.setId(cid);
								pageComponent2.setHtmlContent(htmlContent);
								pageComponent2.setDefaultStyle(defaultStyle);
								pageComponent2.setName(pageComponent.getName());
								pageComponent2.setBeanId(tplBeanId);
								pageComponent2.setTplName(tplName);
								pageComponent2.setScid(scid);
								
								componentsMap.put(id,pageComponent2);
							}
						}
					}
				}
			}
			return componentsMap;
		}catch(Throwable e){
			throw new BusinessException("",e);
		}
	}

	public void setPortalTemplateManager(PortalTemplateManager portalTemplateManager) {
		this.portalTemplateManager = portalTemplateManager;
	}

	public void setPortalCacheManager(PortalCacheManager portalCacheManager) {
		this.portalCacheManager = portalCacheManager;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

	@Override
	public String getPersonalSpaceDecorator(String personalSpaceUrl) {
		PortalSpacePage page = pageManager.getPage(personalSpaceUrl);
        if (page != null) {
            return page.getDefaultLayoutDecorator();
        }
        return "";
	}
	
	private PageManager             pageManager;
	
	public void setPageManager(PageManager pageManager) {
        this.pageManager = pageManager;
    }

	@Override
	public PortalSkinChoice getPortalSkinChoiceBy(String templateId, User user) throws Exception {
		boolean isGroupVer = (Boolean)(SysFlag.sys_isGroupVer.getFlag());
        long currentUserId = user.getId();
        long currentAccountId =  user.getLoginAccount();
        String entityType = "member";
        if(user.isGroupAdmin() || (!isGroupVer && (user.isAdministrator() || user.isSystemAdmin()))){
        	currentUserId = OrgConstants.GROUPID.longValue();
        	currentAccountId =  OrgConstants.GROUPID.longValue();
        	entityType = "group";
        } else if(user.isAdministrator()){
        	currentUserId = user.getLoginAccount().longValue();
        	currentAccountId =  user.getLoginAccount().longValue();
        	entityType = "account";
        }
		PortalSkinChoice skinChoice = portalSkinChoiceManager.getPortalSkinChoiceBy(Long.parseLong(templateId), currentUserId, currentAccountId);
		
		return skinChoice;
	}

	@Override
	public String getCurrentSkinPath(User user, Long templateId, String skinStyle) {
		try{
			List<PortalTemplate> protalTemplateList= portalCacheManager.getTemplates(user);
			PortalTemplate protalTemplate= protalTemplateList.get(0);
			
			PortalHotspot layoutIdHotspot= protalTemplate.getPortalHotspotsMap().get("layoutId");
			String layoutId= "";
			if(null!=layoutIdHotspot){
				layoutId= layoutIdHotspot.getHotspotvalue();
			}else{
				if(protalTemplate.getId()==141322537970846464l){
					layoutId= "-7632631074413524785";
				}else if(protalTemplate.getId()==8950558293947007546l){
					layoutId= "7027426280743061268";
				}
			}
			if(user.isAdmin()){
				layoutId= adminPageLayoutMap.get(layoutId);
			}
			PageLayout pageLayout = portalCacheManager.getPortalPageLayoutXml(user,layoutId);
			PageLayoutTemplete pageLayoutTemplete= PrefabricatedPageInit.getPageLayoutTempleteById(pageLayout.getLayoutTempleteId());
			Map<String,String> skinMap= pageLayoutTemplete.getSystemSkinList().get(skinStyle);
			String skinPath= skinMap.get("path");
			String defaultSkinCssPath= "/seeyon" + skinPath;
			return defaultSkinCssPath;
		}catch(Throwable e){
			LOGGER.error("", e);
		}
		return null;
	}
}
