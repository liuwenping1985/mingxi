package com.seeyon.apps.taskcenter.section;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import cn.com.cinda.taskcenter.common.UrlHelp;

import com.seeyon.apps.taskcenter.Manager.TaskCenterManager;
import com.seeyon.apps.taskcenter.constant.TaskCenterConstant;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.portal.section.BaseSectionImpl;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.MultiRowFourColumnTemplete;
import com.seeyon.ctp.portal.section.templete.MultiRowThreeColumnTemplete;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.util.Strings;

public class TaskCenterSection extends BaseSectionImpl{
	private static final Log log = LogFactory.getLog(TaskCenterSection.class);
	private static TaskCenterManager taskCenterManager = (TaskCenterManager) AppContext.getBean("taskCenterManager");
	private List<Map<String,String>> list = new ArrayList<Map<String,String>>();
	@Override
	public String getIcon() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getId() {
		return "taskCenterSection";
	}
	@Override
	public String getName(Map<String, String> preference) {
	    String name = (String)preference.get("columnsName");
	    if (Strings.isBlank(name)) {
	      return "集成待办";
	    }
	    return name;
	}
	@Override
	public Integer getTotal(Map<String, String> arg0) {
		Integer size = 0;
		try {
			User user = AppContext.getCurrentUser();
			list = taskCenterManager.count(user.getLoginName());
			for (Map<String,String> map : list) {
				size+=Integer.parseInt(map.get("count"));
			}
		} catch (Exception e) {
			log.error("获得总数出错",e);
		}
		return size;
	}
	@Override
	public BaseSectionTemplete projection(Map<String, String> preference)
	  {
		int count = SectionUtils.getSectionCount(8, preference);
		MultiRowThreeColumnTemplete c1 = new MultiRowThreeColumnTemplete();
	    try {
	    	if(list.size()==0){
	    		list = taskCenterManager.count(AppContext.getCurrentUser().getLoginName());
	    	}
	    	int nullcoll = count-list.size();
			for (Map<String,String> data : list) {
				
				MultiRowThreeColumnTemplete.Row row1 = c1.addRow();
//				row1.setSubject(data.get("subject"));
				row1.setAlt(data.get("subject"));
				row1.setClassName("comm");
				row1.setOpenType(BaseSectionTemplete.OPEN_TYPE.href);
//				row1.setLink("javascript:window.location.href='"+openurl+groups.get(data.get("group"))+"'");
				row1.setLink("javascript:window.location.href='"+data.get("url")+"'");
				row1.setSubjectHTML(data.get("subject"));
			}
			for (int i = 0; i < nullcoll; i++) {
				MultiRowThreeColumnTemplete.Row row1 = c1.addRow();
			}
			c1.addBottomButton("更多", "javascript:window.location.href='"+TaskCenterConstant.taskListurl+"'");
		} catch (Exception e) {
			log.error("读取集成代办出错！",e);
		}
		return c1;
	    
	  }
public static void main(String[] args) {
	System.out.println("http://23453.234234324.234324".indexOf("http"));
}
}
