package com.seeyon.apps.syncorg.log.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.oadev.advsearch.AdvSearchBean;
import com.seeyon.apps.oadev.advsearch.CzSimpleObjectBean;
import com.seeyon.apps.oadev.advsearch.TableNameEnum;
import com.seeyon.apps.oadev.advsearch.manager.CzComponentManager;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.po.DataContainer;

public class CzSyncLogController extends BaseController {
	private static final Log log = LogFactory.getLog(CzSyncLogController.class);
	
	private Map<String, String> extNameMap = new HashMap();
	
	private CzComponentManager czComponentManager;

	public CzComponentManager getCzComponentManager() {
		return czComponentManager;
	}



	public void setCzComponentManager(CzComponentManager czComponentManager) {
		this.czComponentManager = czComponentManager;
	}



	public ModelAndView listLog(HttpServletRequest request, HttpServletResponse response)
	  {
		  ModelAndView modelAndView = new ModelAndView("plugin/syncorg/listLog");
			AddSearchPanel(modelAndView, TableNameEnum.SyncLog,  AdvSearchBean.getMoveLogSearchMap(), AdvSearchBean.getMoveLogCommonSearchMap());

		  return modelAndView;
	  }
	
	  

		private void AddSearchPanel(ModelAndView modelAndView, TableNameEnum tableNameEnum, LinkedHashMap mapAdv, LinkedHashMap mapCommon){
			
			// 处理高级查询
			List<CzSimpleObjectBean> searchFields = new ArrayList();
			if(mapAdv!=null&&mapAdv.size()>0){
				for (Object obj : mapAdv.values()) {
					CzSimpleObjectBean bean = (CzSimpleObjectBean) obj;
					searchFields.add(bean);
				}
			}

			modelAndView.addObject("searchFields", AdvSearchBean.getSearchField(searchFields));

			// 处理普通查询
			List<CzSimpleObjectBean> commonSearchFields = new ArrayList();
			if(mapCommon!=null && mapCommon.size()>0){
				for (Object obj : mapCommon.values()) {
					CzSimpleObjectBean bean = (CzSimpleObjectBean) obj;
					commonSearchFields.add(bean);
				}
			}

			List<DataContainer> commonSearchFields_dc = new ArrayList();
			if (commonSearchFields.size() > 0) {
				for (CzSimpleObjectBean fieldBean : commonSearchFields) {
					DataContainer o = new DataContainer();
					commonSearchFields_dc.add(o);
					o.put("id", fieldBean.getName());
					o.put("name", fieldBean.getName());
					o.put("value", fieldBean.getName());
					o.put("text", fieldBean.getDisplay());
					o.put("type", "datemulti");
					o.put("fieldType", fieldBean.getType());
					// 全部按照自定义的类型处理
					o.put("type", "custom");
					List<String[]> htmls = null;
					htmls = czComponentManager
								.getFormConditionHTML(tableNameEnum.getKey(),
										Arrays.asList(new String[] { fieldBean
												.getName() }), null, null);
					
					String op = ((String[]) htmls.get(0))[0].replace("<select",
							"<select style='display:none;' ");
					String html = ((String[]) htmls.get(0))[1];
					o.put("customHtml", op + html);
				}
			}

			DataContainer dc = new DataContainer();
			dc.add("commonSearchFields", commonSearchFields_dc);
			modelAndView.addObject("commonSearchFields", dc.getJson());

			modelAndView.addObject("tableName", tableNameEnum.getKey());


		}
		
		public static void main(String [] args){
			Date date = new Date();
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(1470557700000l);
			System.out.println(cal.getTime());
			

		}

	  
}
