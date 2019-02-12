/**
 *
 */
package com.seeyon.ctp.portal.manager;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import javax.imageio.ImageIO;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AbstractSystemInitializer;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.cache.CacheAccessable;
import com.seeyon.ctp.common.cache.CacheFactory;
import com.seeyon.ctp.common.cache.CacheMap;
import com.seeyon.ctp.common.cache.CacheObject;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.init.MclclzUtil;
import com.seeyon.ctp.common.po.customize.CtpCustomize;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.login.bo.MenuBO;
import com.seeyon.ctp.organization.OrgConstants;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.designer.manager.PageLayoutManager;
import com.seeyon.ctp.portal.designer.manager.PortalDesignerManager;
import com.seeyon.ctp.portal.engine.PageEngine;
import com.seeyon.ctp.portal.engine.model.PageLayout;
import com.seeyon.ctp.portal.engine.po.PageLayoutDetailPO;
import com.seeyon.ctp.portal.engine.po.PageLayoutPO;
import com.seeyon.ctp.portal.engine.render.PageRenderResult;
import com.seeyon.ctp.portal.hotspot.manager.PortalHotSpotManager;
import com.seeyon.ctp.portal.po.PortalHotspot;
import com.seeyon.ctp.portal.po.PortalLoginTemplate;
import com.seeyon.ctp.portal.po.PortalPagePortlet;
import com.seeyon.ctp.portal.po.PortalPortletProperty;
import com.seeyon.ctp.portal.po.PortalSkinChoice;
import com.seeyon.ctp.portal.po.PortalSpaceFix;
import com.seeyon.ctp.portal.po.PortalSpaceMenu;
import com.seeyon.ctp.portal.po.PortalSpacePage;
import com.seeyon.ctp.portal.po.PortalTemplate;
import com.seeyon.ctp.portal.po.PortalTemplateSetting;
import com.seeyon.ctp.portal.portaltemplate.manager.PortalSkinChoiceManager;
import com.seeyon.ctp.portal.portaltemplate.manager.PortalTemplateSettingManager;
import com.seeyon.ctp.portal.section.manager.BaseSectionSelector;
import com.seeyon.ctp.portal.space.bo.MenuTreeNode;
import com.seeyon.ctp.portal.space.dao.PageManagerDao;
import com.seeyon.ctp.portal.space.dao.PortalPortletPropertyDao;
import com.seeyon.ctp.portal.space.dao.SpaceDao;
import com.seeyon.ctp.portal.space.manager.SpaceManager;
import com.seeyon.ctp.portal.util.Constants;
import com.seeyon.ctp.portal.util.SpaceFixUtil;
import com.seeyon.ctp.portal.util.Constants.SectionType;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.After;

/**
 * 把每个人的“空间导航、快捷、皮肤”信息缓存起来
 *
 * @author <a href="tanmf@seeyon.com">Tanmf</a>
 * @date 2015-4-7
 */
public class PortalCacheManagerImpl implements PortalCacheManager {
	private final static Log logger= LogFactory.getLog(PortalCacheManagerImpl.class);
    private static final CacheAccessable cacheFactory = CacheFactory.getInstance(PortalCacheManager.class);

    private SpaceManager                     spaceManager;
    private PortalHotSpotManager             portalHotSpotManager;
    private PortalTemplateSettingManager     portalTemplateSettingManager;
    private PortalSkinChoiceManager          portalSkinChoiceManager;
    private OrgManager                       orgManager;
    private PageLayoutManager                pageLayoutManager;
    private PortalDesignerManager            portalDesignerManager;
    private PageManagerDao 					 pageManagerDao;
    private PortalPortletPropertyDao 		 portalPortletPropertyDao;
    private SpaceDao                     	 spaceDao;
    private FileManager                		 fileManager;
    
    private CustomizeManager 				 customizeManager;
    
    public void setCustomizeManager(CustomizeManager customizeManager) {
        this.customizeManager = customizeManager;
    }
    public void setPortalDesignerManager(PortalDesignerManager portalDesignerManager) {
		this.portalDesignerManager = portalDesignerManager;
	}

    public void setSpaceManager(SpaceManager spaceManager) {
        this.spaceManager = spaceManager;
    }

    public void setPortalHotSpotManager(PortalHotSpotManager portalHotSpotManager) {
        this.portalHotSpotManager = portalHotSpotManager;
    }

    public void setPortalTemplateSettingManager(PortalTemplateSettingManager portalTemplateSettingManager) {
        this.portalTemplateSettingManager = portalTemplateSettingManager;
    }

    public void setPortalSkinChoiceManager(PortalSkinChoiceManager portalSkinChoiceManager) {
        this.portalSkinChoiceManager = portalSkinChoiceManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }
    
    public void setPageManagerDao(PageManagerDao pageManagerDao) {
		this.pageManagerDao = pageManagerDao;
	}
	
	public void setPortalPortletPropertyDao(PortalPortletPropertyDao portalPortletPropertyDao) {
        this.portalPortletPropertyDao = portalPortletPropertyDao;
    }
	
	public void setSpaceDao(SpaceDao spaceDao) {
	    this.spaceDao = spaceDao;
	}
	
	public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }
    /**720迁移缓存开始,包括缓存变量,缓存创建,提供缓存的get,set方法,私有初始化方法**/
    /**---------------------------------------------------缓存定义区---------------------------------------------------**/
    //原SpaceOwnerMenuFactory
    private Map<String,ArrayList<SpaceOwnerMenuSelector>> spaceOwnerMenuSelectors;
    //原BaseSelectorFactory
    private static Map<String,ArrayList<BaseSectionSelector>> sectionSelectors;
    //原PageManagerImpl
    /*
	 * key: pagePath
	 */
	private CacheMap<String, PortalSpacePage> pageCache;
	/**
     * key:memberId
     * value:("editKeyId",editKeyId),("spaceId",spaceId)
     */
    private CacheMap<Long,HashMap<String,Long>> editSpaceKeyMap;
    /**
     * Key:memberId
     */
    private CacheMap<Long,ArrayList<PortalPagePortlet>> cacheSaveFragment;
    /**
     * Key:memberId
     */
    private CacheMap<Long,ArrayList<PortalPagePortlet>> cacheRemoveFragment;
    //原PortletEntityPropertyManagerImpl中cache
    private CacheMap<Long, HashMap<String, String>> portletcache;
    //原SpaceManagerImpl
    /*
   	 * key: pagePath
   	 */
   	private CacheMap<String, PortalSpaceFix> pageFixPathCache;
   	private CacheMap<Long, PortalSpaceFix> pageFixIdCache;
   	private CacheMap<Long,ArrayList<PortalSpaceMenu>> portalSpaceMenuCache;
   	//portal专用菜单缓存
   	private Map<String, List<MenuBO>> portalMenuCache;
   	//用户语言区域选择
   	private Map<String,Locale> userLocalCache;
    /**---------------------------------------------------缓存定义区---------------------------------------------------**/
    
    /**---------------------------------------------------get,set区---------------------------------------------------**/
    public CacheMap<String, PortalSpacePage> getPageCache(){
    	return pageCache;
    }
    public PortalSpacePage getPageCacheByKey(String key){
    	return pageCache.get(key);
    }
    public void putPageCache(String key,PortalSpacePage value){
    	pageCache.put(key, value);
    }
    public void removePageCache(String key){
    	pageCache.remove(key);
    }
    
    public CacheMap<Long,HashMap<String,Long>> getEditSpaceKeyMap(){
    	return editSpaceKeyMap;
    }
    public HashMap<String,Long> getEditSpaceKeyMapByKey(long key){
    	return editSpaceKeyMap.get(key);
    }
    public void putEditSpaceKeyMap(long key,HashMap<String,Long> value){
    	editSpaceKeyMap.put(key, value);
    }
    public void removeEditSpaceKeyMap(long key){
    	editSpaceKeyMap.remove(key);
    }
   
    public CacheMap<Long,ArrayList<PortalPagePortlet>> getCacheSaveFragment(){
    	return cacheSaveFragment;
    }
    public ArrayList<PortalPagePortlet> getCacheSaveFragmentByKey(long key){
    	return cacheSaveFragment.get(key);
    }
    public void putCacheSaveFragment(long key,ArrayList<PortalPagePortlet> value){
    	cacheSaveFragment.put(key, value);
    }
    public void removeCacheSaveFragment(long key){
    	cacheSaveFragment.remove(key);
    }
    
    public CacheMap<Long,ArrayList<PortalPagePortlet>> getCacheRemoveFragment(){
    	return cacheRemoveFragment;
    }
    public ArrayList<PortalPagePortlet> getCacheRemoveFragmentByKey(long key){
    	return cacheRemoveFragment.get(key);
    }
    public void putCacheRemoveFragment(long key,ArrayList<PortalPagePortlet> value){
    	cacheRemoveFragment.put(key, value);
    }
    public void removeCacheRemoveFragment(long key){
    	cacheRemoveFragment.remove(key);
    }
    
    public CacheMap<Long, HashMap<String, String>> getPortletcache(){
    	return portletcache;
    }
    public HashMap<String, String> getPortletcacheByKey(long key){
    	return portletcache.get(key);
    }
    public void putPortletcache(long key,HashMap<String, String> value){
    	portletcache.put(key, value);
    }
    public void removePortletcache(long key){
    	portletcache.remove(key);
    }
    
    public CacheMap<String, PortalSpaceFix> getPageFixPathCache(){
    	return pageFixPathCache;
    }
    public PortalSpaceFix getPageFixPathCacheByKey(String key){
    	return pageFixPathCache.get(key);
    }
    public void putPageFixPathCache(String key,PortalSpaceFix value){
    	pageFixPathCache.put(key, value);
    }
    public void removePageFixPathCache(String key){
    	pageFixPathCache.remove(key);
    }
    
    public CacheMap<Long, PortalSpaceFix> getPageFixIdCache(){
    	return pageFixIdCache;
    }
    public PortalSpaceFix getPageFixIdCacheByKey(long key){
    	return pageFixIdCache.get(key);
    }
    public void putPageFixIdCache(long key,PortalSpaceFix value){
    	pageFixIdCache.put(key, value);
    }
    public void removePageFixIdCache(long key){
    	pageFixIdCache.remove(key);
    }
    
    public CacheMap<Long,ArrayList<PortalSpaceMenu>> getPortalSpaceMenuCache(){
    	return portalSpaceMenuCache;
    }
    public ArrayList<PortalSpaceMenu> getPortalSpaceMenuCacheByKey(long key){
    	return portalSpaceMenuCache.get(key);
    }
    public void putPortalSpaceMenuCache(long key,ArrayList<PortalSpaceMenu> value){
    	portalSpaceMenuCache.put(key, value);
    }
    public void removePortalSpaceMenuCache(long key){
    	portalSpaceMenuCache.remove(key);
    }
    /**---------------------------------------------------get,set区---------------------------------------------------**/
    
    /**---------------------------------------------------初始化方法区---------------------------------------------------**/
    private void initSpaceOwnerMenuSelectors(){
    	spaceOwnerMenuSelectors.clear();
        Map<String,SpaceOwnerMenuSelector> manager = AppContext.getBeansOfType(SpaceOwnerMenuSelector.class);
        if(manager!=null){
            Set<Entry<String, SpaceOwnerMenuSelector>> enities = manager.entrySet();
            
            for (Map.Entry<String, SpaceOwnerMenuSelector> entry : enities) {
                SpaceOwnerMenuSelector selector = entry.getValue();
                String[] spaceTypes = selector.getSpaceType();
                if (spaceTypes == null){
                    spaceTypes = new String[1];
                    spaceTypes[0] = SpaceType.custom.name();
                }
                for(String spaceType : spaceTypes){
                    ArrayList<SpaceOwnerMenuSelector> selectorList = spaceOwnerMenuSelectors.get(spaceType);
                    if(selectorList == null){
                        selectorList = new ArrayList<SpaceOwnerMenuSelector>();
                    }
                    if(!selectorList.contains(selector)){
                        selectorList.add(selector);
                    }
                    spaceOwnerMenuSelectors.put(spaceType, selectorList);
                }
            }
        }
    }
    private void initSectionSelectors(){
    	sectionSelectors.clear();
        Map<String,BaseSectionSelector> selectors = AppContext.getBeansOfType(BaseSectionSelector.class);
        if(selectors!=null){
            Set<Entry<String, BaseSectionSelector>> enities = selectors.entrySet();
            
            for (Map.Entry<String, BaseSectionSelector> entry : enities) {
                BaseSectionSelector sectionSelector = entry.getValue();
                String sectionType = sectionSelector.getSectionType();
                if (Strings.isBlank(sectionType)){
                    sectionType = SectionType.common.name();
                }
                ArrayList<BaseSectionSelector> selectorList = sectionSelectors.get(sectionType);
                if(selectorList == null){
                    selectorList = new ArrayList<BaseSectionSelector>();
                }
                if(!selectorList.contains(sectionSelector)){
                    selectorList.add(sectionSelector);
                }
                sectionSelectors.put(sectionType, selectorList);
            }
        }
    }
    private void initPageCache(){

		List<PortalSpacePage> pages = this.pageManagerDao.selectAllPage();
		List<PortalPagePortlet> pagePortlets = this.pageManagerDao.selectAllPagePortlet();
		
		Map<Long, PortalPagePortlet> tempFragmentId2Fragment = new HashMap<Long, PortalPagePortlet>();
		for (PortalPagePortlet pagePortlet : pagePortlets) {
		    if(pagePortlet.getPageId()!=null){
		        //增加RootPagePortlet和实例Portlet的关联
		        pagePortlet.putExtraAttr("ChildrenPortlets", new ArrayList<PortalPagePortlet>());
		    }
			tempFragmentId2Fragment.put(pagePortlet.getId(), pagePortlet);
		}
		
		Map<Long, PortalSpacePage> tempPageId2Page = new HashMap<Long, PortalSpacePage>();
		Map<String, PortalSpacePage> tempPagePath2Page = new HashMap<String, PortalSpacePage>();
		for (PortalSpacePage page : pages) {
			tempPageId2Page.put(page.getId(), page);
			tempPagePath2Page.put(page.getPath(), page);
		}
		
		for (PortalPagePortlet pagePortlet : pagePortlets) {
			Long pageId = pagePortlet.getPageId();
			Long parentId = pagePortlet.getParentId();
			if(pageId != null){ //layout fragment
			    PortalSpacePage page = tempPageId2Page.get(pageId);
				if(page == null){
					//log.warn("Fragement[" + pagePortlet.getId() + "]的Page[" + pageId + "]不存在");
					continue;
				}
				
				page.putExtraAttr("RootPagePortlet", pagePortlet);
			}
			else if(parentId != null){ //portlet fragment
			    PortalPagePortlet rootPagePortlet = tempFragmentId2Fragment.get(parentId);
				if(rootPagePortlet == null){
					//log.warn("Fragement[" + pagePortlet.getId() + "]的Parent[" + parentId + "]不存在");
					continue;
				}
				
				@SuppressWarnings("unchecked")
                List<PortalPagePortlet> childrenPortlets = (List<PortalPagePortlet>) rootPagePortlet.getExtraAttr("ChildrenPortlets");
				childrenPortlets.add(pagePortlet);
			}
		}
		this.pageCache.putAll(tempPagePath2Page);		
		logger.info("加载Portal Page信息完成，共" + pageCache.size());
    }
    private void initPortletcache(){
    	Map<Long, HashMap<String, String>> map = new HashMap<Long, HashMap<String, String>>();
		List<PortalPortletProperty> all = portalPortletPropertyDao.selectAllPortletProperty();
		for (PortalPortletProperty property : all) {
			Long entityId = Long.parseLong(property.getEntityId());
			
			HashMap<String, String> result = map.get(entityId);
			if(result == null){
				result = new HashMap<String, String>();
//				cache.put(entityId, result);
			}
			String pValue = property.getPropertyValue();
			if(pValue == null){
			    pValue = "";
			}
			result.put(property.getPropertyName(), pValue);
//			cache.notifyUpdate(entityId);
			map.put(entityId, result);
		}
		portletcache.putAll(map);
    }
    private void initSapceCache(){
    	try{
			List<PortalSpaceFix> pageFixs = this.spaceDao.selectAllPageFix();
			if(null!=pageFixs){
				Map<String,PortalSpaceFix> tempPageFixMap= new HashMap<String, PortalSpaceFix>();
				Map<Long,PortalSpaceFix> tempPageFixIdMap= new HashMap<Long, PortalSpaceFix>();
				for (PortalSpaceFix portalSpaceFix : pageFixs) {
					tempPageFixMap.put(portalSpaceFix.getPath(),portalSpaceFix);
					tempPageFixIdMap.put(portalSpaceFix.getId(), portalSpaceFix);
				}
				pageFixPathCache.putAll(tempPageFixMap);
				pageFixIdCache.putAll(tempPageFixIdMap);
			}
			List<PortalSpaceMenu> portalSpaceMenus= this.spaceDao.selectAllPortalSpaceMenu();
			if( null!=portalSpaceMenus && !portalSpaceMenus.isEmpty()){
				Map<Long,ArrayList<PortalSpaceMenu>> map= new HashMap<Long, ArrayList<PortalSpaceMenu>>();
				for (PortalSpaceMenu portalSpaceMenu : portalSpaceMenus) {
					ArrayList<PortalSpaceMenu> list= map.get(portalSpaceMenu.getSpaceId());
					if(null==list){
						list= new ArrayList<PortalSpaceMenu>();
					}
					list.add(portalSpaceMenu);
					map.put(portalSpaceMenu.getSpaceId(), list);
				}
				portalSpaceMenuCache.putAll(map);
			}
		}catch(Throwable e){
			logger.error("space数据缓存失败",e);
		}
    }
    /**---------------------------------------------------初始化方法区---------------------------------------------------**/
    /**---------------------------------------------------方法区---------------------------------------------------**/
    //原SpaceOwnerMenuFactory,类已删除
    public ArrayList<SpaceOwnerMenuSelector> getSelectorsBySpaceType(String spaceType){
        ArrayList<SpaceOwnerMenuSelector> selectors = spaceOwnerMenuSelectors.get(spaceType);
        ArrayList<SpaceOwnerMenuSelector> new_selectors= null;
        if(CollectionUtils.isNotEmpty(selectors)){
        	//拷贝下，不然会出现线程安全问题 java.util.ConcurrentModificationException
        	new_selectors = new ArrayList<SpaceOwnerMenuSelector>();
        	for (SpaceOwnerMenuSelector spaceOwnerMenuSelector : selectors) {
        		try {
					SpaceOwnerMenuSelector newSelector= (SpaceOwnerMenuSelector)BeanUtils.cloneBean(spaceOwnerMenuSelector);
					new_selectors.add(newSelector);
				} catch (Exception e) {
					logger.warn("", e);
				}
			}
            Comparator<SpaceOwnerMenuSelector> comparator = new Comparator<SpaceOwnerMenuSelector>() {
                @Override
                public int compare(SpaceOwnerMenuSelector o1, SpaceOwnerMenuSelector o2) {
                    Integer sort1 = o1.getSortId();
                    Integer sort2 = o2.getSortId();
                    if(sort1!=null&&sort2!=null){
                        return sort1 - sort2;
                    }else if(sort1 == null && sort2 !=null){
                        return -1;
                    }else if(sort2 == null && sort1 !=null){
                        return 1;
                    }else{
                        return 0;
                    }
                }
            };
            Collections.sort(new_selectors, comparator);
        }
        return new_selectors;
    }
    //原BaseSelectorFactory类,类已删除
    public ArrayList<BaseSectionSelector> getSectionsBySelector(String sectionType){
        ArrayList<BaseSectionSelector> selectors = sectionSelectors.get(sectionType);
        if(CollectionUtils.isNotEmpty(selectors)&&selectors.size()>1){
            Comparator<BaseSectionSelector> comparator = new Comparator<BaseSectionSelector>() {
                @Override
                public int compare(BaseSectionSelector o1, BaseSectionSelector o2) {
                    Integer sort1 = o1.getSortId();
                    Integer sort2 = o2.getSortId();
                    if(sort1!=null&&sort2!=null){
                        return sort1 - sort2;
                    }else if(sort1 == null && sort2 !=null){
                        return -1;
                    }else if(sort2 == null && sort1 !=null){
                        return 1;
                    }else{
                        return 0;
                    }
                }
            };
            Collections.sort(selectors, comparator);
        }
        return selectors;
    }
    /**---------------------------------------------------方法区---------------------------------------------------**/
    /**720迁移缓存结束**/
    
    //--
    private CacheMap<String, String> loginImgSizeCache;//登录页背景图原始宽高缓存
    private void initLoginImgSizeCache(){
    	Map<String,String> map=new HashMap<String,String>();
    	List<PortalHotspot> list=portalHotSpotManager.getChangebgi();
    	for(PortalHotspot p:list){
    		String[] imgs=p.getHotspotvalue().split(",");
    		for(String img:imgs){
    			if(!map.containsKey(img)){
    				String wh="";
    				File f=getImgFile(img);
					if(f!=null){
						wh=getWidthHeight(f);
					}
        			map.put(img, wh);
    			}
    		}
    		
    	}
    	loginImgSizeCache.putAll(map);//格式{main/imgs/123.png:300,400}
    }
    private String getWidthHeight(File f){
    	try {
			BufferedImage bufferedImage = ImageIO.read(f);
			String wh=bufferedImage.getWidth()+","+bufferedImage.getHeight();
			bufferedImage.flush();
			return wh;
		} catch (Exception e) {
			this.logger.error("根据图片路径获取宽高异常!路径:"+f.getAbsolutePath(),e);
			return "2000,1080";
		}
    }
    private File getImgFile(String img){
    	if(img.indexOf("fileId")>-1){
			//上传的图片
			String tmp[]=img.split("=");
			if(tmp.length>1){
				if(tmp[1]!=null&&!"".equals(tmp[1])){
					try {
						return fileManager.getFile(Long.parseLong(tmp[1]));
					}catch (Exception e){
						this.logger.error("根据ID获取图片异常!",e);
					}
				}
				return null;
			}
			return null;
		}else{
			if(img.startsWith("/decorations")){//关联系统里预置是这个路径
				//预置的图片
				String path=SystemEnvironment.getApplicationFolder()+img;
				File imgF=new File(path);
				if(imgF.isFile()){
					return imgF;
				}
			}else{
				//预置的图片
				String path=SystemEnvironment.getApplicationFolder()+"/main/login/"+img;
				File imgF=new File(path);
				if(imgF.isFile()){
					return imgF;
				}
			}
			return null;
		}
    }
    public Map<String,String> getWHByImgId(String imgId){
    	String img="fileId="+imgId;
    	Map<String,String> map=new HashMap<String, String>();
    	map.put(img, getWidthHeight(getImgFile(img)));
    	return map;
    }
    public Map<String,String> getCurrentLoginImgSize(List<PortalHotspot> list){
    	Map<String,String> map=new HashMap<String, String>();
    	for(PortalHotspot p:list){
    		if("changebgi".equals(p.getHotspotkey())){
    			String[] imgs=p.getHotspotvalue().split(",");
	    		for(String img:imgs){
	    			map.put(img, loginImgSizeCache.get(img));
	    		}
    		}
    	}
    	return map;
    }
    private CacheMap<String, String> sapceIconSizeCache;//空间图标
    public String getSpaceIconSizeByCache(String imgUrl){
    	if(imgUrl==null||"".equals(imgUrl)){
    		return "";
    	}
    	String wh=sapceIconSizeCache.get(imgUrl);
    	if(wh==null||"".equals(wh)){
    		if(imgUrl.indexOf("fileId=")>-1){
	    		String s=imgUrl.substring(imgUrl.indexOf("fileId="));
	    		s=s.substring(0, s.indexOf("&"));
	    		File img=getImgFile(s);
	    		if(img==null){
	    			wh="0,0";
	    		}else{
	    			wh=getWidthHeight(img);
	    		}
    		}else{
    			File img=getImgFile(imgUrl);
    			if(img==null){
    				wh="0,0";
    			}else{
    				wh=getWidthHeight(getImgFile(imgUrl));
    			}
    		}
    		sapceIconSizeCache.put(imgUrl, wh);
    	}
    	return wh;
    }
    public void putloginImgSizeCache(List<PortalHotspot> list){
    	for(PortalHotspot p:list){
    		if("changebgi".equals(p.getHotspotkey())){
	    		String[] imgs=p.getHotspotvalue().split(",");
	    		for(String img:imgs){
	    			if(!loginImgSizeCache.contains(img)){
	    				String wh="";
	    				File f=getImgFile(img);
						if(f!=null){
							wh=getWidthHeight(f);
						}
						loginImgSizeCache.put(img, wh);
	    			}
	    		}
    		}
    	}
    }
    
    public void init(){
    	logger.info("Portal缓存加载开始!");long start=System.currentTimeMillis();
    	/**720迁移来的缓存**/
    	spaceOwnerMenuSelectors = new HashMap<String, ArrayList<SpaceOwnerMenuSelector>>();
    	sectionSelectors = new HashMap<String, ArrayList<BaseSectionSelector>>();
    	pageCache = cacheFactory.createMap("Page");
	    editSpaceKeyMap = cacheFactory.createMap("editSpaceKeyMap");
        cacheSaveFragment = cacheFactory.createMap("cacheSaveFragment");
        cacheRemoveFragment = cacheFactory.createMap("cacheRemoveFragment");
        portletcache = cacheFactory.createMap("Portletcache");
        pageFixPathCache = cacheFactory.createMap("PageFixPath");
		pageFixIdCache = cacheFactory.createMap("PageFixId");
		portalSpaceMenuCache= cacheFactory.createMap("portalSpaceMenu");
    	/**720迁移来的缓存**/
    	
    	PortalTemplateLastModity = cacheFactory.createObject("PortalTemplateLastModity");
    	Member2PortalTemplateDate = cacheFactory.createMap("Member2PortalTemplateDate");
    	Member2PortalTemplate = cacheFactory.createMap("Member2PortalTemplate");
    	LoginTemplateLastModity = cacheFactory.createObject("LoginTemplateLastModity");
    	ShortcutLastModity = cacheFactory.createObject("ShortcutLastModity");
    	SpaceLastModity = cacheFactory.createObject("SpaceLastModity");
    	loginImgSizeCache= cacheFactory.createMap("loginImgSizeCache");
    	sapceIconSizeCache= cacheFactory.createMap("sapceIconSizeCache");
        PortalTemplateLastModity.set(System.currentTimeMillis());
        LoginTemplateLastModity.set(System.currentTimeMillis());
        SpaceLastModity.set(System.currentTimeMillis());
        ShortcutLastModity.set(System.currentTimeMillis());
        
        /**720迁移来的缓存初始化**/
        initSpaceOwnerMenuSelectors();
        initSectionSelectors();
        initPageCache();
        initPortletcache();
        initSapceCache();
        /**720迁移来的缓存初始化**/
        /**初始化portal的菜单缓存初始化*/
        portalMenuCache=new ConcurrentHashMap<String, List<MenuBO>>();
        /**初始化portal的菜单缓存初始化*/
        userLocalCache=new ConcurrentHashMap<String, Locale>();
        /**初始化用户语言区域选择缓存初始化*/
        initLoginImgSizeCache();//初始化登录页背景图计算
        logger.info("Portal缓存加载结束!耗时:"+((System.currentTimeMillis()-start)/1000)+"MS");
    }


    /////////////////////////// 皮肤的缓存  ////////////////////////////////
    private CacheObject<Long> PortalTemplateLastModity;
    private CacheMap<String, Long> Member2PortalTemplateDate;
    private CacheMap<String, PortalTemplate> Member2PortalTemplate;
    
    private CacheObject<Long> LoginTemplateLastModity;
    
    private Map<String, Long> Member2LoginTemplateSettingDate = new ConcurrentHashMap<String, Long>();
    private Map<String, PortalTemplateSetting> Member2LoginTemplateSetting = new ConcurrentHashMap<String, PortalTemplateSetting>();
    
    private Map<String, Long> Member2LoginTemplateHotspotsDate = new ConcurrentHashMap<String, Long>();
    private Map<String, List<PortalHotspot>> Member2LoginPortalHotspots = new ConcurrentHashMap<String, List<PortalHotspot>>();
    
    private Map<Long, Long> Member2LoginTemplateDate = new ConcurrentHashMap<Long, Long>();
    private Map<Long, PortalLoginTemplate> Member2LoginTemplate = new ConcurrentHashMap<Long, PortalLoginTemplate>();
    
    /////////////////////////// 首页布局的缓存  ////////////////////////////////
    private Map<String, Long> Member2PortalLayoutXmlDate = new ConcurrentHashMap<String, Long>();
    private Map<String, PageLayout> Member2PortalLayoutXml = new ConcurrentHashMap<String, PageLayout>();

    @After({"portalTemplateManager.transReSetToDefault", 
    	"portalTemplateManager.transSwitchPortalTemplate", 
    	"portalTemplateManager.transSwitchSkinStyle", 
    	"portalTemplateManager.transSaveHotSpots",
    	"portalTemplateManager.transAllowHotSpotCustomize",
    	"portalDesignerManager.savePageDesignedData"})
    public void updatePortalTemplate(){
    	User currentUser= AppContext.getCurrentUser();
        if(currentUser.isAdmin()){
            PortalTemplateLastModity.set(System.currentTimeMillis());
        }
        else{
        	 Long memberId = AppContext.currentUserId();
             Long accountId = AppContext.currentAccountId();

             String key = memberId + "_" + accountId;
             Member2PortalTemplateDate.put(key, System.currentTimeMillis());
             Member2PortalLayoutXmlDate.put(key, System.currentTimeMillis());
        }
    }
    
    //登录页数据更新后通知此方法执行
    @After({"loginTemplateManager.transSaveTemplate","loginTemplateManager.transReSetToDefault"})
    public void updateLoginTemplate(){
        if(AppContext.getCurrentUser().isAdmin()){
        	LoginTemplateLastModity.set(System.currentTimeMillis());
        }
    }

    public void getPortalTemplate(User currentUser) throws BusinessException {
    	// TODO 直接加返回值加密的调用代码不识别，暂时只能这样了
    	getTemplates(currentUser);
    }

    public List<PortalTemplate> getTemplates(User currentUser) throws BusinessException {
        boolean isGroupVer = (Boolean)(SysFlag.sys_isGroupVer.getFlag());
        long entityId = currentUser.getId();
        long accountId =  currentUser.getLoginAccount();
        if(currentUser.isGroupAdmin() || (!isGroupVer && (currentUser.isAdministrator() || currentUser.isSystemAdmin()))){
            entityId = OrgConstants.GROUPID.longValue();
            accountId =  OrgConstants.GROUPID.longValue();
        } else if(currentUser.isAdministrator()){
            entityId = currentUser.getLoginAccount().longValue();
            accountId =  currentUser.getLoginAccount().longValue();
        }
        String key = entityId + "_" + accountId;

        long portalTemplateLastModity = this.PortalTemplateLastModity.get();

        if(!Strings.equals(Member2PortalTemplateDate.get(key), portalTemplateLastModity)){
            PortalTemplate p = getPortalTemplate0(entityId, accountId); 
            Member2PortalTemplate.put(key, p);
            Member2PortalTemplateDate.put(key, portalTemplateLastModity);
        }

        PortalTemplate pt = Member2PortalTemplate.get(key);

        List<PortalTemplate> templates = new ArrayList<PortalTemplate>();
        templates.add(pt);

        currentUser.setMainFrame(pt.getPath()); 
        return templates;
    }

    private PortalTemplate getPortalTemplate0(Long entityId, Long accountId) throws BusinessException {
        PortalTemplateSetting setting = portalTemplateSettingManager.getPortalSettingBy(entityId, accountId);
        Long portalTemplateId = setting.getTemplateId();
        PortalTemplate pt = DBAgent.get(PortalTemplate.class, portalTemplateId);

        PortalSkinChoice skinChoice = portalSkinChoiceManager.getPortalSkinChoiceBy(portalTemplateId, entityId, accountId);
        List<PortalHotspot> hotSpots = portalHotSpotManager.getHotSpotsBy(portalTemplateId, skinChoice.getSkinStyle(), entityId, accountId);
        pt.setPortalHotspots(hotSpots);

        return pt;
    }


    //////////////////////////////// 空间的缓存 ////////////////////////
    private CacheObject<Long> SpaceLastModity;
    private Map<String, List<String[]>> Member2Spaces = new ConcurrentHashMap<String, List<String[]>>();
    private Map<String, Long> Member2SpacesDate = new ConcurrentHashMap<String, Long>();
    private Map<String, Long> Member2SpaceOrgDate = new ConcurrentHashMap<String, Long>();

    @After({"com.seeyon.ctp.portal.space.manager.SpaceManagerImpl.saveSpaceSort", "com.seeyon.ctp.portal.space.manager.SpaceManagerImpl.transSaveSpace", "com.seeyon.ctp.portal.space.manager.SpaceManagerImpl.transSetDefaultSpace", 
        "com.seeyon.ctp.portal.space.controller.SpaceController.updateSpaceByFront",
        "com.seeyon.ctp.portal.space.controller.SpaceController.updateSectionsToFragment",
        "com.seeyon.ctp.portal.space.controller.SpaceController.updateShortcutPortlet",
        "com.seeyon.ctp.portal.space.controller.SpaceController.updateProperty",
        "com.seeyon.ctp.portal.space.controller.SpaceController.deleteFrament", 
        "com.seeyon.apps.project.controller.ProjectController.saveProject", "projectConfigManager.deleteProject", //项目空间
        "linkSystemManager.saveLinkSystem", //关联系统扩展空间
        "ncUserMapperManager.saveUserMapper", "ncUserMapperManager.deleteUserMapper", //NC账号绑定
        "com.seeyon.apps.ntp.manager.NCMultiJCManagerImpl.createNCConf","com.seeyon.apps.ntp.manager.NCMultiJCManagerImpl.deleteNCConf",//集团管理员NC配置管理
        "com.seeyon.apps.ntp.controller.NCUserMapperController.updateUserMapper",
        "com.seeyon.apps.u8.controller.U8UserMapperController.saveU8UserMapper", "com.seeyon.apps.u8.controller.U8UserMapperController.updateUserMapper", //U8账号绑定
        "com.seeyon.apps.neigou.manager.NeigouCorpinforManagerImpl.saveNeigouCorpinfor","com.seeyon.apps.neigou.manager.NeigouCorpinforManagerImpl.modifiedStatuesList",
        "com.seeyon.apps.xc.manager.XCSynManagerImp.saveXCParameter",//携程企业信息验证
        "com.seeyon.apps.cip.portal.manager.PortalConfigManagerImpl.createOrUpdateThirdPortal","com.seeyon.apps.cip.portal.manager.PortalConfigManagerImpl.deletePortal",
        "com.seeyon.apps.vjoin.manager.JoinPortalManagerImpl.saveSpace"
        })
    public void updateSpace(){
        SpaceLastModity.set(System.currentTimeMillis());
    }

    @After({"com.seeyon.ctp.login.controller.MainController.changeLoginAccount"}) //切换兼职单位时
    public void updateSpaceByMember(){
        User currentUser = AppContext.getCurrentUser();
        String key = currentUser.getId() + "_" + currentUser.getLoginAccount() + "_" + currentUser.getLocale();

        Member2SpacesDate.put(key, System.currentTimeMillis());
    }

    public List<String[]> getSpaces(User currentUser,String spaceCategory) throws BusinessException{
        String key = currentUser.getId() + "_" + currentUser.getLoginAccount() + "_" + currentUser.getLocale();
        
        long spaceLastModify = this.SpaceLastModity.get();
        long orgLastModify = this.orgManager.getModifiedTimeStamp(null).getTime();

        if(!Strings.equals(spaceLastModify, Member2SpacesDate.get(key)) || !Strings.equals(orgLastModify, Member2SpaceOrgDate.get(key))){
        	//id,parentId,path,spaceName,state,sort,spaceType,XXXX,icon,AccountId
        	List<String[]> spaces = spaceManager.getSpaceSort(currentUser.getId(), currentUser.getLoginAccount(), currentUser.getLocale(), false, null);
        	List<String[]> mobileSpaces = spaceManager.getMobileSpace(currentUser);
        	if(mobileSpaces!=null){
        		spaces.addAll(mobileSpaces);
        	}
        	
            Member2Spaces.put(key, spaces);
            Member2SpacesDate.put(key, spaceLastModify);
            Member2SpaceOrgDate.put(key, orgLastModify);
        }

        return getSpaceBySpaceCategory(currentUser,Member2Spaces.get(key),spaceCategory);
    }
    /**
     * 筛选空间按空间类别(m3,weixin,pc....)
     * @param spaces
     * @param spaceCategory
     * @return
     */
    private List<String[]> getSpaceBySpaceCategory(User currentUser,List<String[]> spaces,String spaceCategory){
    	List<String[]> m3=new ArrayList<String[]>();
    	List<String[]> weixin=new ArrayList<String[]>();
    	List<String[]> pc=new ArrayList<String[]>();
    	CtpCustomize custom=customizeManager.getCustomizeInfo(currentUser.getId(),spaceCategory+"_leader_space");
    	String[] m3Personal=null;String[] weixinPersonal=null;
    	int hasM3Leader=0;int hasWeixinLeader=0;
        for (String[] space : spaces) {
            if (space != null) {
                int spaceType = Integer.parseInt(space[6]);
                if (spaceType == Constants.SpaceType.m3mobile.ordinal() || spaceType == Constants.SpaceType.m3mobile_custom.ordinal() || spaceType == Constants.SpaceType.m3mobile_leader.ordinal()
                        || spaceType == Constants.SpaceType.m3mobile_leader_custom.ordinal()) {
                	if(custom != null && (spaceType == Constants.SpaceType.m3mobile_leader.ordinal()
                            || spaceType == Constants.SpaceType.m3mobile_leader_custom.ordinal())){
                		m3.add(0,space);//如果推送了领导空间,并且是领导空间则把领导空间放到第一位
                		hasM3Leader=1;
                	}else{
                		m3.add(space);
                	}
                	if(spaceType == Constants.SpaceType.m3mobile.ordinal()){
                		m3Personal=space;
                	}
                } else if (spaceType == Constants.SpaceType.weixinmobile.ordinal() || spaceType == Constants.SpaceType.weixinmobile_custom.ordinal()
                        || spaceType == Constants.SpaceType.weixinmobile_leader.ordinal() || spaceType == Constants.SpaceType.weixinmobile_leader_custom.ordinal()) {
                	if(custom != null && (spaceType == Constants.SpaceType.weixinmobile_leader.ordinal()
                            || spaceType == Constants.SpaceType.weixinmobile_leader_custom.ordinal())){
                		weixin.add(0,space);//如果推送了领导空间,并且是领导空间则把领导空间放到第一位
                		hasWeixinLeader=1;
                	}else{
                		weixin.add(space);
                	}
                	if(spaceType == Constants.SpaceType.weixinmobile.ordinal()){
                		weixinPersonal=space;
                	}
                } else {//以后有新类型再扩展
                    pc.add(space);
                }
            }
        }
    	if(Constants.SpaceCategory.m3.name().equals(spaceCategory)){
    		if(hasM3Leader==1 && m3Personal!=null ){
    			if(isPushLeaderSpace(m3.get(0))){
    				m3.remove(m3Personal);//如果有领导空间则把此人的个人空间弄掉.
    			}
    		}
    		return m3;
    	}else if(Constants.SpaceCategory.weixin.name().equals(spaceCategory)){
    		if(hasWeixinLeader==1 && weixinPersonal!=null){
    			if(isPushLeaderSpace(weixin.get(0))){
    				weixin.remove(weixinPersonal);//如果有领导空间则把此人的个人空间弄掉.
    			}
    		}
    		return weixin;
    	}else{
    		return pc;
    	}
    }
    //判断是否推送了领导空间
    private boolean isPushLeaderSpace(String[] leaderSpace){
    	String leaderSpaceId=leaderSpace[1]==null?leaderSpace[0]:leaderSpace[1];
		PortalSpaceFix fix=pageFixIdCache.get(Long.parseLong(leaderSpaceId));
		SpaceFixUtil fixUtil = new SpaceFixUtil(fix.getExtAttributes());
		return fixUtil.isAllowpushed();
    }
    private Map<String, Long> spacePortletDate = new ConcurrentHashMap<String, Long>();
    private Map<String, Long> spacePortletOrgDate = new ConcurrentHashMap<String, Long>();
    private Map<String, List<String[]>> spacePortlets = new ConcurrentHashMap<String, List<String[]>>();
    public List<String[]> getSpacePortlets(User currentUser) throws BusinessException{
        String key = currentUser.getId() + "_" + currentUser.getLoginAccount() + "_" + currentUser.getLocale();

        long spaceLastModify = this.SpaceLastModity.get();
        long orgLastModify = this.orgManager.getModifiedTimeStamp(null).getTime();

        if(!Strings.equals(spaceLastModify, spacePortletDate.get(key)) || !Strings.equals(orgLastModify, spacePortletOrgDate.get(key))){
            List<String[]> portlets = spaceManager.getAllSpaceSort(currentUser.getId(), currentUser.getLoginAccount(), currentUser.getLocale(), false, null);

            spacePortlets.put(key, portlets);
            spacePortletDate.put(key, spaceLastModify);
            spacePortletOrgDate.put(key, orgLastModify);
        }

        return spacePortlets.get(key);
    }


    //////////////////////////////// 快捷的缓存 ////////////////////////
    private CacheObject<Long> ShortcutLastModity;
    private Map<String, List<MenuTreeNode>> Member2Shortcut = new ConcurrentHashMap<String, List<MenuTreeNode>>();
    private Map<String, Long> Member2ShortcutDate = new ConcurrentHashMap<String, Long>();
    private Map<String, Long> Member2ShortcutOrgDate = new ConcurrentHashMap<String, Long>();
    private Map<String, String> Member2ShortcutLocale = new ConcurrentHashMap<String, String>();

    @After({"spaceManager.saveShortcutsSortOfMember",
    		"roleManager.updateRoleResource",
    		"roleManager.batchRole2Entity"
    	  })
    public void updateShortcut(){
        if(AppContext.getCurrentUser().isAdmin()){
            ShortcutLastModity.set(System.currentTimeMillis());
        }
        else{
            Long memberId = AppContext.currentUserId();
            Long accountId = AppContext.currentAccountId();

            String key = memberId + "_" + accountId;
            Member2ShortcutDate.put(key, System.currentTimeMillis());
        }
    }

    public List<MenuTreeNode> getShortcuts(User currentUser) throws BusinessException{
        boolean isLocalChange= false;
        String myHistoryLocale= Member2ShortcutLocale.get(currentUser.getId().toString());
        String myCurrentLocale= currentUser.getLocale().getLanguage()+"-"+currentUser.getLocale().getCountry();
        if(null== myHistoryLocale){
            Member2ShortcutLocale.put(currentUser.getId().toString(), myCurrentLocale);
            isLocalChange= true;
        }else{
            if(!Strings.equals(myHistoryLocale, myCurrentLocale)){
                isLocalChange= true;
                Member2ShortcutLocale.put(currentUser.getId().toString(), myCurrentLocale);
            }
        }
        String key = currentUser.getId() + "_" + currentUser.getLoginAccount();

        long shortcutLastModify = this.ShortcutLastModity.get();
        long orgLastModify = this.orgManager.getModifiedTimeStamp(null).getTime();

        if(isLocalChange || !Strings.equals(shortcutLastModify, Member2ShortcutDate.get(key)) || !Strings.equals(orgLastModify, Member2ShortcutOrgDate.get(key))){
            List<MenuTreeNode> shortcuts = spaceManager.getCustomizeShortcutsOfMember(currentUser, null);
            if (shortcuts != null) {
            	Member2Shortcut.put(key, shortcuts);
            }
            Member2ShortcutDate.put(key, shortcutLastModify);
            Member2ShortcutOrgDate.put(key, orgLastModify);
        }

        return Member2Shortcut.get(key);
    }

	public PageLayout getPortalPageLayoutXml(User currentUser,String layoutId) throws BusinessException {
        PageLayout pageLayout = Member2PortalLayoutXml.get(layoutId);

        if(pageLayout == null){
			PageLayoutPO pageLayoutPO= pageLayoutManager.getPageLayoutById(layoutId);
			if(null==pageLayoutPO){
				logger.error("登录异常layoutId:="+layoutId);
			}
	        String currentPageId= pageLayoutPO.getId().toString();
			PageLayoutDetailPO pageLayoutDetailPO= pageLayoutManager.getPageLayoutDetailByLayoutId(currentPageId);
			String pageXml= pageLayoutDetailPO.getXmlContent();
			
            try {
                pageLayout = PageEngine.parseXmlToPageLayout(pageXml);
            }
            catch (Exception e) {
                logger.error("", e);
            }
			
			Member2PortalLayoutXml.put(layoutId, pageLayout);
        }
        
        return pageLayout;
	}

	public void setPageLayoutManager(PageLayoutManager pageLayoutManager) {
		this.pageLayoutManager = pageLayoutManager;
	}

	@Override
	public String getAccountLogo(long currentAccountId) throws BusinessException {
		String key = currentAccountId + "_" + currentAccountId;

        long portalTemplateLastModity = this.PortalTemplateLastModity.get();

        if(!Strings.equals(Member2PortalTemplateDate.get(key), portalTemplateLastModity)){
            PortalTemplate p = getPortalTemplate0(currentAccountId, currentAccountId); 
            Member2PortalTemplate.put(key, p);
            Member2PortalTemplateDate.put(key, portalTemplateLastModity);
        }
        PortalTemplate pt = Member2PortalTemplate.get(key);
        if( null!= pt.getPortalHotspotsMap() && null!=pt.getPortalHotspotsMap().get("logoImg") ){
        	return "/" +pt.getPortalHotspotsMap().get("logoImg").getHotspotvalue();
        } 
		return "";
	}

	@Override
	public PortalTemplateSetting getLoginSettingBy(long entityId, long currentAccountId) {
		String key = entityId + "_" + currentAccountId;

        long loginTemplateLastModity = this.LoginTemplateLastModity.get();

        if(!Strings.equals(Member2LoginTemplateSettingDate.get(key), loginTemplateLastModity)){
        	PortalTemplateSetting loginSetting= portalTemplateSettingManager.getLoginSettingBy(entityId, currentAccountId);
            Member2LoginTemplateSetting.put(key, loginSetting);
            Member2LoginTemplateSettingDate.put(key, loginTemplateLastModity);
        }

        PortalTemplateSetting pt = Member2LoginTemplateSetting.get(key);
        
        return pt;
	}

	@Override
	public List<PortalHotspot> getHotSpotsBy(long templateId, String skinStyle, long entityId, long accountId) {
		String key = entityId + "_" + accountId;
		if(Strings.isNotBlank(skinStyle)){
			key +="_"+skinStyle;
		}

        long loginTemplateLastModity = this.LoginTemplateLastModity.get();

        if(!Strings.equals(Member2LoginTemplateHotspotsDate.get(key), loginTemplateLastModity)){
        	List<PortalHotspot> hotSpots = portalHotSpotManager.getHotSpotsBy(templateId, skinStyle, entityId, accountId);
        	Member2LoginPortalHotspots.put(key, hotSpots);
        	Member2LoginTemplateHotspotsDate.put(key, loginTemplateLastModity);
        }

        List<PortalHotspot> hotSpots = Member2LoginPortalHotspots.get(key);
        
        return hotSpots;
	}

	@Override
	public PageRenderResult generateHtmlPage(User user, String contextPath, Map<String, Object> dataMap) throws Exception {
		return portalDesignerManager.generateHtmlPage(user, contextPath, dataMap); 
	}

	@Override
	public PortalLoginTemplate getLoginTemplate(Long templateId) {
		Long key= templateId;
		long loginTemplateLastModity = this.LoginTemplateLastModity.get();

        if(!Strings.equals(Member2LoginTemplateDate.get(key), loginTemplateLastModity)){
        	PortalLoginTemplate plt = DBAgent.get(PortalLoginTemplate.class, templateId);
            Member2LoginTemplate.put(key, plt);
            Member2LoginTemplateDate.put(key, loginTemplateLastModity);
        }

        PortalLoginTemplate pt = Member2LoginTemplate.get(key);
        return pt;
	}

	@Override
	public String getPageTitle() {
		User user = AppContext.getCurrentUser();
        long entityId = user.getId();
        long accountId = user.getLoginAccount();
        boolean isGroupVer = (Boolean) (SysFlag.sys_isGroupVer.getFlag());
        if (user.isGroupAdmin() || (!isGroupVer && (user.isAdministrator() || user.isSystemAdmin()))) {
            entityId = OrgConstants.GROUPID.longValue();
            accountId = OrgConstants.GROUPID.longValue();
        } else if (user.isAdministrator()) {
            entityId = user.getLoginAccount().longValue();
            accountId = user.getLoginAccount().longValue();
        }
        PortalTemplateSetting setting = this.getLoginSettingBy(entityId, accountId);
        List<PortalHotspot> portalHotspots = this.getHotSpotsBy(setting.getTemplateId(), null, entityId, accountId);
        String title = null;
        if (CollectionUtils.isNotEmpty(portalHotspots)) {
            for (PortalHotspot hotspot : portalHotspots) {
                if ("note".equals(hotspot.getHotspotkey())) {
                    String noteName = hotspot.getHotspotvalue();
                    if (noteName == null || noteName.trim().length() == 0 || "null".equals(noteName)) {
                    	//title = ResourceUtil.getString("common.page.title" + Functions.oemSuffix() + Functions.suffix());
                    	title = Functions.getVersion();
                    } else {
                        String suffix = SystemProperties.getInstance().getProperty("portal.loginTitle");
                        title = ResourceUtil.getString(noteName + suffix);// + " " + Functions.getVersion();
                    }
                }
            }
        }

        if (AppContext.getCurrentUser() != null) {
            title += " - " + ResourceUtil.getString("welcome.label", AppContext.getCurrentUser().getName());
        }

        return title;
	}
	@Override
	public List<MenuBO> getPortalMenusByKey(String key){
		if(portalMenuCache==null){
			 portalMenuCache=new HashMap<String, List<MenuBO>>();
			 return null;
		}
		return portalMenuCache.get(key);
		
	}
	@Override
	public void putPortalMenusCache(String key,List<MenuBO> menus){
		if(menus!=null){
			portalMenuCache.put(key, menus);
		}
	}
	@Override
	public void clearPortalMenusCache(){
		if(portalMenuCache==null){
			 portalMenuCache=new HashMap<String, List<MenuBO>>();
		}
		this.portalMenuCache.clear();
	}
	
	@Override
	public Locale getUserLocalByKey(String key){
		if(userLocalCache==null){
			userLocalCache=new HashMap<String, Locale>();
			 return null;
		}
		return userLocalCache.get(key);
		
	}
	@Override
	public void putUserLocalCache(String key,Locale local){
		if(local!=null){
			userLocalCache.put(key, local);
		}
	}
	@Override
	public String getDueRemind(){
		initDueRemind();
		String remind="";
    	if(endService!=null){
        	remind=endService;
        }
    	if(endUse!=null){
    		remind=endUse;
    	}
		return remind;
	}
	private static final Class<?> c2 = MclclzUtil.ioiekc("com.seeyon.ctp.product.ProductInfo");
    private int day=0;
	private String endService=null;
	private String endUse=null;
	private void initDueRemind() {
        Calendar cal=Calendar.getInstance();
        try {
        	if(day==0||day!=cal.get(Calendar.DATE)){
        		day=cal.get(Calendar.DATE);//按天刷新缓存
            	Object useEnd = MclclzUtil.invoke(c2, "getUseEndDate");
                Object serviceEnd = MclclzUtil.invoke(c2, "getServiceEndDate");
                if(serviceEnd!=null){
                	int dayNum=DateUtil.beforeDays(DateUtil.currentDate(),((Date)serviceEnd));
                	if(dayNum<0){
                		endService=ResourceUtil.getString("login.template.dueRemind.text1");
                	}
                }
                if(useEnd!=null){
                	Date useEndDate=DateUtil.parse(useEnd.toString());
                	int dayNum=DateUtil.beforeDays(DateUtil.currentDate(), useEndDate);
                	if(dayNum<=10){
                		endUse=ResourceUtil.getString("login.template.dueRemind.text2",DateUtil.format(useEndDate,DateUtil.YEAR_MONTH_DAY_PATTERN));
                	}
                }
            }
		} catch (Throwable e) {
			logger.error("读取服务到期时间出错!");
		}
	}
}
