/**
 * 
 */
package com.seeyon.ctp.portal.engine.templete;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.lilystudio.smarty4j.Context;
import org.lilystudio.smarty4j.Engine;
import org.lilystudio.smarty4j.Template;
import org.lilystudio.smarty4j.TemplateException;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.util.Strings;

/**
 * smarty4j模板引擎
 * @author wangchw
 *
 */
public class PortalTempleteEngine {
	
	private final static Log LOGGER = LogFactory.getLog(PortalTempleteEngine.class);
	
	private PortalTempleteEngine(){}
	
	private static Engine engine= null;
	
	private static Map<String,Template> pageComponentMap= new HashMap<String,Template>();
	
	public static void init() throws IOException, TemplateException{
		if(null==engine){
			Map<String, String> config = new HashMap<String, String>();
			String templetePath=  AppContext.getCfgHome() + File.separator + "plugin"+File.separator+"designer"+File.separator+"templetes" + File.separator;
			config.put("template.path", templetePath);
			config.put("encoding", "UTF-8");
			engine = new Engine(config);
			
			File rootDir= new File(templetePath);
			File[] files= rootDir.listFiles(new FilenameFilter() {
				@Override
				public boolean accept(File dir, String name) {
					if(name.endsWith(".tpl")){
						return true;
					}
					return false;
				}
			});
			if(null!=files){
				for (File file : files) {
					//LOGGER.info("find a tpl:"+file.getName());
					Template template = engine.getTemplate(file.getName());
					pageComponentMap.put(file.getName(), template);
				}
			}
		}	
	}
	
	/**
	 * 获得页面元件模板实例
	 * @param theme
	 * @param templeteName
	 * @param dataMap
	 * @return
	 * @throws Throwable
	 */
	public static String getComponentHtml(String theme,String templeteName,Map<String, Object> dataMap){
		String fileName= templeteName+"_"+theme+".tpl";
		Template template = pageComponentMap.get(fileName);
		if(null==template){
			LOGGER.warn("It's not found "+fileName+",please check it!");
			return "";
		}
		Writer writer = new StringWriter();
		Context ctx = new Context();
		ctx.putAll(dataMap);
		template.merge(ctx, writer);
		String htmlContent= writer.toString();
		return htmlContent;
	}

	/**
	 * 测试方法
	 * @param args 
	 * @throws BusinessException 
	 * @throws TemplateException 
	 * @throws IOException 
	 */
	public static void main(String[] args) throws BusinessException, IOException, TemplateException{
		String templateFile= "spaceLinks_default";//模板文件名称
		Map<String, String> config = new HashMap<String, String>();
		String path= "D:/workspace/V560/60/MAIN/v60/ctp_designer/src/main/webapp/WEB-INF/cfgHome/plugin/designer/templetes/";
		config.put("template.path", path);
		config.put("encoding", "UTF-8");
		Engine engine = new Engine(config);
		Template template = engine.getTemplate(templateFile + ".tpl"); //若无法找到模板将抛出模板无法找到异常
		Writer writer = new StringWriter();
		try {
			Map<String, Object> map= new HashMap<String, Object>();
			map.put("imagePath", "c:/1.png");
			map.put("accountNameCN", "致远软件");
			map.put("accountNameEN", "SEEYON");
			map.put("isShowCenter", "1");
			map.put("appCenterName", "应用中心");
			map.put("isShowSearch", "1");
			map.put("searchName", "搜索");
			map.put("isShowBack", "1");
			map.put("backName", "回退");
			map.put("isShowForward", "1");
			map.put("forwardName", "前进");
			map.put("isShowRefresh", "1");
			map.put("refreshName", "刷新");
			map.put("isShowZhixin", "1");
			map.put("zhixinName", "致信");
			map.put("isShowAbout", "1");
			map.put("aboutName", "关于");
			map.put("isShowSetting", "1");
			map.put("settingName", "设置");
			Context ctx = new Context();
			ctx.putAll(map);
			template.merge(ctx, writer);
		} catch (Exception e) {
			throw new BusinessException(e);
		}
	}

	/**
	 * 将html字符串模板渲染成html内容
	 * @param templateHtmlContent
	 * @param dataMap
	 * @return
	 */
	public static String getComponentPropertyHtmlContent(String propertyTplName, Map<String, Object> dataMap) {
		//LOGGER.info("propertyTplName:="+propertyTplName);
		String fileName= propertyTplName+".tpl";
		Template template = pageComponentMap.get(fileName);
		if(null==template){
			LOGGER.warn("It's not found "+fileName+",please check it!");
			return "";
		}
		Writer writer = new StringWriter();
		Context ctx = new Context();
		ctx.putAll(dataMap);
		template.merge(ctx, writer);
		String htmlContent= writer.toString();
		if(Strings.isBlank(htmlContent)){
			htmlContent= "";
		}
		//LOGGER.info("propertyHtmlContent:="+htmlContent);
		return htmlContent;
	}
}
