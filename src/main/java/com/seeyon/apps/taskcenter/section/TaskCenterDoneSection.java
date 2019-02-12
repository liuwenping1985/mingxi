package com.seeyon.apps.taskcenter.section;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.taskcenter.Manager.TaskCenterManager;
import com.seeyon.apps.taskcenter.bo.CenterTaskBO;
import com.seeyon.apps.taskcenter.constant.TaskCenterConstant;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.portal.section.BaseSectionImpl;
import com.seeyon.ctp.portal.section.DoneSection;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.MultiRowThreeColumnTemplete;
import com.seeyon.ctp.portal.section.templete.MultiRowVariableColumnTemplete;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;

public class TaskCenterDoneSection extends BaseSectionImpl{
	private static final Log log = LogFactory.getLog(TaskCenterDoneSection.class);
	private int count = 8;
	private static TaskCenterManager taskCenterManager = (TaskCenterManager) AppContext.getBean("taskCenterManager");
	@Override
	public String getIcon() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getId() {
		return "taskCenterDoneSection";
	}
	@Override
	public String getName(Map<String, String> preference) {
	    String name = (String)preference.get("columnsName");
	    if (Strings.isBlank(name)) {
	      return "已办集成";
	    }
	    return name;
	}
	@Override
	public Integer getTotal(Map<String, String> arg0) {
		Integer size = 0;
		try {
			User user = AppContext.getCurrentUser();
			FlipInfo flipInfo = new FlipInfo(0, count);
			FlipInfo fi= taskCenterManager.listmydoneTask(flipInfo, null);
			size = fi.getTotal();
		} catch (Exception e) {
			log.error("获得总数出错",e);
		}
		return size;
	}
	@Override
	public BaseSectionTemplete projection(Map<String, String> preference)
	  {

//		MultiRowThreeColumnTemplete c1 = new MultiRowThreeColumnTemplete();
		MultiRowVariableColumnTemplete c = new MultiRowVariableColumnTemplete();
	    try {
	    	count = SectionUtils.getSectionCount(count, preference);
			FlipInfo flipInfo = new FlipInfo(0, count);
			FlipInfo fi= taskCenterManager.listmydoneTask(flipInfo, null);
			List<CenterTaskBO> list = fi.getData();
			for (CenterTaskBO data : list) {
//				MultiRowThreeColumnTemplete.Row row1 = c1.addRow();
				MultiRowVariableColumnTemplete.Row row = c.addRow();
//				DoneSection
//		         {header:'任务来源',width:75,sortable:true,dataIndex:'flowName'},
//		         {header:'任务所办环节', width:81,sortable:true,dataIndex:'flowNode'},
//		         {header:'任务主题', width:77,sortable:true,dataIndex:'subject'},
//		         {header:'任务所处环节',width:77,sortable:true,dataIndex:'batchName'},
//		         {header:'分配时间',width:77,sortable:true,dataIndex:'submitTime'},
				MultiRowVariableColumnTemplete.Cell subjectCell = row.addCell();
				subjectCell.setAlt(data.getSubject().trim());
				subjectCell.setCellContent(data.getSubject().trim());
//				subjectCell.setClassName("comm");
				subjectCell.setOpenType(BaseSectionTemplete.OPEN_TYPE.href);
				String linkPath = data.getLinkPath();
				subjectCell.setLinkURL("javascript:function openwin(){openCtpWindow({'url':'"+linkPath+"'});return;};openwin();");
				
				MultiRowVariableColumnTemplete.Cell flowName = row.addCell();
				flowName.setCellContent(data.getFlowName());
				flowName.setAlt(data.getFlowName());
//				flowName.setClassName("comm");
				flowName.setOpenType(BaseSectionTemplete.OPEN_TYPE.href);
				flowName.setLinkURL("javascript:function openwin(){openCtpWindow({'url':'"+linkPath+"'});return;};openwin();");
				
				MultiRowVariableColumnTemplete.Cell flowNode = row.addCell();
				flowNode.setAlt(data.getFlowNode());
				flowNode.setCellContent(data.getFlowNode());
//				flowNode.setClassName("comm");
				flowNode.setOpenType(BaseSectionTemplete.OPEN_TYPE.href);
				flowNode.setLinkURL("javascript:function openwin(){openCtpWindow({'url':'"+linkPath+"'});return;};openwin();");
				
				String detailPath = data.getDetailPath();
				
				MultiRowVariableColumnTemplete.Cell submitTime = row.addCell();
				submitTime.setAlt(data.getSubmitTime());
				submitTime.setCellContent(data.getSubmitTime());
//				submitTime.setClassName("comm");
				submitTime.setOpenType(BaseSectionTemplete.OPEN_TYPE.href);
				submitTime.setLinkURL("javascript:function openwin(){openCtpWindow({'url':'"+detailPath+"'});return;};openwin();");
				
				MultiRowVariableColumnTemplete.Cell batchName = row.addCell();
				batchName.setAlt(data.getBatchName());
				batchName.setCellContent(data.getBatchName());
//				batchName.setClassName("comm");
				batchName.setOpenType(BaseSectionTemplete.OPEN_TYPE.href);
				batchName.setLinkURL("javascript:function openwin(){openCtpWindow({'url':'"+detailPath+"'});return;};openwin();");
			}
			if(list.size()>count){
				for (int i = 0; i < (count-list.size()); i++) {
					MultiRowVariableColumnTemplete.Row row = c.addRow();
				}
			}
			c.addBottomButton("更多", "javascript:window.location.href='"+TaskCenterConstant.taskdoneListurl+"mydone'");
		} catch (Exception e) {
			log.error("读取集成代办出错！",e);
		}
		return c;
	    
	  }
public static void main(String[] args) {
	System.out.println("http://23453.234234324.234324".indexOf("http"));
}
}
