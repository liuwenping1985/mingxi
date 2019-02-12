package com.seeyon.apps.taskcenter.section;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import cn.com.cinda.taskcenter.util.StringUtils;

import com.seeyon.apps.taskcenter.Manager.TaskCenterManager;
import com.seeyon.apps.taskcenter.Manager.TaskCenterOAManager;
import com.seeyon.apps.taskcenter.bo.TaskCenterResource;
import com.seeyon.apps.taskcenter.po.ProSenderUrl;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.portal.section.BaseSectionImpl;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.ChessboardTemplete;
import com.seeyon.ctp.portal.section.templete.MultiRowThreeColumnTemplete;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.portal.util.PortletPropertyContants;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.common.web.login.CurrentUser;

public class ProSenderUrlSection extends BaseSectionImpl{
	private static final Log log = LogFactory.getLog(ProSenderUrlSection.class);
	
	  private Map<Integer, Integer> newLine2Column = new HashMap();
	  
	  private TaskCenterOAManager taskCenterOAManager;
	  public TaskCenterOAManager getTaskCenterOAManager() {
		return taskCenterOAManager;
	}
	public void setTaskCenterOAManager(TaskCenterOAManager taskCenterOAManager) {
		this.taskCenterOAManager = taskCenterOAManager;
	}
	public void setNewLine2Column(Map<String, String> newLine2Column)
	  {
	    this.newLine2Column.put(Integer.valueOf(2), Integer.valueOf(16));
	    this.newLine2Column.put(Integer.valueOf(3), Integer.valueOf(16));
	    this.newLine2Column.put(Integer.valueOf(4), Integer.valueOf(16));
	    this.newLine2Column.put(Integer.valueOf(5), Integer.valueOf(16));
	    this.newLine2Column.put(Integer.valueOf(6), Integer.valueOf(16));
	    this.newLine2Column.put(Integer.valueOf(7), Integer.valueOf(16));
	    this.newLine2Column.put(Integer.valueOf(10), Integer.valueOf(16));
	  }
	@Override
	public String getIcon() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getId() {
		return "ProSenderUrlSection";
	}

	@Override
	public String getName(Map<String, String> arg0) {
		// TODO Auto-generated method stub
		return "华科常用链接";
	}

	@Override
	public Integer getTotal(Map<String, String> arg0) {
		Integer size = 0;
		try {
			User user = AppContext.getCurrentUser();
			// 在这里增加总数

		} catch (Exception e) {
			log.error("获得总数出错",e);
		}
		return null;
	}
	@Override
	public BaseSectionTemplete projection(Map<String, String> preference)
	  {
	    ChessboardTemplete c = new ChessboardTemplete();
	    
	    String category = "1,2";
	    setNewLine2Column(null);
	    
	    int newLine = 2;
//	    int width = Integer.parseInt((String)preference.get(PortletPropertyContants.PropertyName.width.name()));
//	    Integer newLineStr = (Integer)newLine2Column.get(Integer.valueOf(width));
//	    if (newLineStr != null) {
//	      newLine = newLineStr.intValue();
//	    }
	    c.setLayout(8, newLine);
	    int count = SectionUtils.getSectionCount(16, preference);
	    // 总得行数获得的结果好像不正确， 临时设置 count= 8
//	    count= 8;
//	    int recent = 10;
//	    if (!Strings.isBlank((String)preference.get("recent"))) {
//	      recent = Integer.parseInt((String)preference.get("recent"));
//	      if (recent > count)
//	        recent = count;
//	    }
	    c.setDataNum(count);

        List<TaskCenterResource> templates = queryTemplate(CurrentUser.get().getId(), count);
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
	        	url = ("http://portal.zc.cinda.ccb"+ctpTemplate.getUrl());
	          }
	          url =  this.taskCenterOAManager.replaceUrlParams(url, user.getLoginName(), hkdepartId);
        	  item.setLink("javascript:function opencindaurl(){openCtpWindow({'url':'"+url+"'});return;};opencindaurl();");
//	          item.setLink("javascript:openCtpWindow({'url':'"+url+"'})");
	          item.setName(ctpTemplate.getName());
	          item.setTitle(ctpTemplate.getName());
	        }
	      }
	    }
	  
	  private List<TaskCenterResource> queryTemplate(Long userId, int count){
		  List<TaskCenterResource> retval = new ArrayList();
		  retval = taskCenterOAManager.getTaskList4Section(AppContext.getCurrentUser(), count);
		  return retval;
	  }
	  }

