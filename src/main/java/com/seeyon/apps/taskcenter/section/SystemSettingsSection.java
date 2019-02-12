package com.seeyon.apps.taskcenter.section;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.taskcenter.Manager.TaskCenterOAManager;
import com.seeyon.apps.taskcenter.bo.TaskCenterResource;
import com.seeyon.apps.taskcenter.constant.TaskCenterConstant;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.portal.section.BaseSectionImpl;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.ChessboardTemplete;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.portal.util.PortletPropertyContants;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.common.web.login.CurrentUser;

public class SystemSettingsSection extends BaseSectionImpl{
	private static final Log log = LogFactory.getLog(SystemSettingsSection.class);
	
	  private Map<Integer, Integer> newLine2Column = new HashMap();
	  private int defcount = 8;
	  
	  public int getDefcount() {
		return defcount;
	}
	public void setDefcount(int defcount) {
		this.defcount = defcount;
	}
	private TaskCenterOAManager taskCenterOAManager;
	  public TaskCenterOAManager getTaskCenterOAManager() {
		return taskCenterOAManager;
	}
	public void setTaskCenterOAManager(TaskCenterOAManager taskCenterOAManager) {
		this.taskCenterOAManager = taskCenterOAManager;
	}
	public void setNewLine2Column(Map<String, String> newLine2Column)
	  {
	    this.newLine2Column.put(Integer.valueOf(2), Integer.valueOf(2));
	    this.newLine2Column.put(Integer.valueOf(3), Integer.valueOf(2));
	    this.newLine2Column.put(Integer.valueOf(4), Integer.valueOf(2));
	    this.newLine2Column.put(Integer.valueOf(5), Integer.valueOf(2));
	    this.newLine2Column.put(Integer.valueOf(6), Integer.valueOf(2));
	    this.newLine2Column.put(Integer.valueOf(7), Integer.valueOf(2));
	    this.newLine2Column.put(Integer.valueOf(10), Integer.valueOf(4));
	  }
	@Override
	public String getIcon() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getId() {
		return "systemSettingsSection";
	}

	@Override
	public String getName(Map<String, String> preference) {
	    String name = (String)preference.get("columnsName");
	    if (Strings.isBlank(name)) {
	      return "系统设置";
	    }
	    return name;
	}

	@Override
	public Integer getTotal(Map<String, String> arg0) {

		return null;
	}
	@Override
	public BaseSectionTemplete projection(Map<String, String> preference)
	  {
	    ChessboardTemplete c = new ChessboardTemplete();
	    String category = "1,2";
	    setNewLine2Column(null);
	    
	    int newLine = 2;
	    int count = SectionUtils.getSectionCount(8, preference);
	    
	    int width = Integer.parseInt((String)preference.get(PortletPropertyContants.PropertyName.width.name()));
	    Integer newLineStr = (Integer)newLine2Column.get(Integer.valueOf(width));
	    if (newLineStr != null) {
	      newLine = newLineStr.intValue();
	    }
	    c.setLayout(count, newLine);
	    c.setDataNum(count*newLine);

        List<TaskCenterResource> templates = taskCenterOAManager.getTaskList4Section(CurrentUser.get(), count*newLine);
	    addItems(c, templates, "<span class=\"ico16 lately_text_type_template_16 margin_r_5\"></span>");
	    c.addBottomButton("common_more_label", "/proSenderUrlController.do?method=moreTemplate&sId="+this.getId()+"&columnsName="+getName(preference));
	    return c;
	    
	  }
	  private void addItems(ChessboardTemplete c, List<TaskCenterResource> templates, String icon)
	  {
	    ChessboardTemplete.Item item;
	    User user = AppContext.getCurrentUser();
	    String hkdepartId = this.taskCenterOAManager.getjtUserDeptId(user.getLoginName());
	    if (templates != null) {
	      item = null;
	      for (TaskCenterResource ctpTemplate : templates) {
	        long templeteId = ctpTemplate.getId().longValue();
	        
	        StringBuilder templeteIconMapping = new StringBuilder();
	          if (Strings.isNotBlank(icon)) {
	            templeteIconMapping.append(icon);
	          } else {
	            templeteIconMapping.append("<span class=\"ico16 form_temp_16 margin_r_5\"></span>");
	          }

	          item = c.addItem();
	          String url =  ctpTemplate.getUrl();
	          if(url.startsWith("http")){
	        	  url = ctpTemplate.getUrl();
	          }else{
	        	  url = (TaskCenterConstant.portolurl+ctpTemplate.getUrl());
	          }
	          url = this.taskCenterOAManager.replaceUrlParams(url, user.getLoginName(), hkdepartId);
        	  item.setLink("javascript:function opencindaurl(){openCtpWindow({'url':'"+url+"'});return;};opencindaurl();");
//	          item.setLink("javascript:openCtpWindow({'url':'"+url+"'})");
	          item.setName(ctpTemplate.getName());
	          item.setTitle(ctpTemplate.getName());
	        }
	      if(templates.size()<c.getDataNum()){
	    	  for (int i = 0; i < (c.getDataNum()-templates.size()); i++) {
	    		  c.addItem();
			}
	      }
	      }
	    }
	  

	  }

