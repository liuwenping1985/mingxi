//package com.seeyon.apps.datakit.controller;
//
//import java.util.List;
//import java.util.Map;
//
//import org.apache.commons.logging.Log;
//import org.apache.commons.logging.LogFactory;
//
//import com.seeyon.apps.zbkgTodo.bo.ZbkgFinancialSharedTodoBO;
//import com.seeyon.apps.zbkgTodo.constant.ZbkgTodoConstant;
//import com.seeyon.apps.zbkgTodo.manager.ZbkgTodoManager;
//import com.seeyon.apps.zbkgTodo.util.DesUtil;
//import com.seeyon.ctp.common.AppContext;
//import com.seeyon.ctp.common.authenticate.domain.User;
//import com.seeyon.ctp.portal.section.BaseSectionImpl;
//import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
//import com.seeyon.ctp.portal.section.templete.MultiRowVariableColumnTemplete;
//import com.seeyon.ctp.portal.section.util.SectionUtils;
//import com.seeyon.ctp.util.FlipInfo;
//import com.seeyon.ctp.util.Strings;
//
//public class ZbkgFinancialSharedTodoSection extends BaseSectionImpl{
//	private static final Log log = LogFactory.getLog(ZbkgFinancialSharedTodoSection.class);
//	private int count = 8;
//	private int totalSize = 0;
//	private String sectionName = "财务共享平台待办";
//
//
//	@Override
//	public String getIcon() {
//		// TODO Auto-generated method stub
//		return null;
//	}
//
//	@Override
//	public String getId() {
//		return "zbkgFinancialSharedTodoSection";
//	}
//	@Override
//	public String getName(Map<String, String> preference) {
//	    String name = (String)preference.get("columnsName");
//	    if (Strings.isBlank(name)) {
//	      name = "财务共享平台待办";
//	    }
//	    this.sectionName = name;
//	    return name;
//	}
//	@Override
//	public Integer getTotal(Map<String, String> arg0) {
//
//		User user = AppContext.getCurrentUser();
//		String userId = user.getId().toString();
//		ZbkgTodoManager zbkgTodoManager = (ZbkgTodoManager)AppContext.getBean("zbkgTodoManager");
//		List<ZbkgFinancialSharedTodoBO> todoList = zbkgTodoManager.financialSharedTodolistByUserId(userId);
//		totalSize = todoList.size();
//
//		return totalSize;
//	}
//	@Override
//	public BaseSectionTemplete projection(Map<String, String> preference)
//	  {
//
//		User user = AppContext.getCurrentUser();
//		String userId = user.getId().toString();
//		MultiRowVariableColumnTemplete c = new MultiRowVariableColumnTemplete();
//	    try {
//	    	//String employee_code = DesUtil.encode("dtfsckey",userId);
//	    	count = SectionUtils.getSectionCount(count, preference);
//	    	FlipInfo flipInfo = new FlipInfo(0,count);
//
//			ZbkgTodoManager zbkgTodoManager = (ZbkgTodoManager)AppContext.getBean("zbkgTodoManager");
//			List<ZbkgFinancialSharedTodoBO> todoList = zbkgTodoManager.financialSharedTodolistByUserId(userId);
//			totalSize = todoList.size();
//
//			flipInfo = zbkgTodoManager.memoryPagingFinancialSharedTodoList(flipInfo, todoList);
//			List<ZbkgFinancialSharedTodoBO> todoCountList = flipInfo.getData();
//			for (ZbkgFinancialSharedTodoBO data : todoCountList) {
//
//				MultiRowVariableColumnTemplete.Row row = c.addRow();
//
//				// 单据编号
//				MultiRowVariableColumnTemplete.Cell subjectCell = row.addCell();
//				subjectCell.setAlt(data.getDocumentNumber().trim());
//				subjectCell.setCellContent(data.getDocumentNumber().trim());
//				subjectCell.setCellWidth(60);
//				subjectCell.setClassName("channel_title color_black left hand font_bold");
//				subjectCell.setOpenType(BaseSectionTemplete.OPEN_TYPE.href);
//				String linkPath = data.getLinkPath();
//				subjectCell.setLinkURL("javascript:function openwin(){openCtpWindow({'url':'"+linkPath+"'});return;};openwin();");
//
//				// 单据发起人
//				MultiRowVariableColumnTemplete.Cell flowName = row.addCell();
//				flowName.setCellContent(data.getEmployeeName().trim());
//				flowName.setAlt(data.getEmployeeName().trim());
////				flowName.setClassName("comm");
//
//			    // 单据类型
//				MultiRowVariableColumnTemplete.Cell flowTypeDesc = row.addCell();
//				flowTypeDesc.setAlt(data.getOrderTypeDesc().trim());
//				flowTypeDesc.setCellContent(data.getOrderTypeDesc().trim());
////				flowTypeDesc.setClassName("comm");
//
//				// 单据金额
//				MultiRowVariableColumnTemplete.Cell amount = row.addCell();
//				amount.setAlt(data.getInstanceAmount().trim());
//				amount.setCellContent(data.getInstanceAmount().trim());
////				amount.setClassName("comm");
//
//				//单据申请时间
//				MultiRowVariableColumnTemplete.Cell createTime = row.addCell();
//				createTime.setAlt(data.getCreationDate().trim());
//				createTime.setCellContent(data.getCreationDate().trim());
////				createTime.setClassName("comm");
//
//			}
//
//			String url = String.format("%s&total=%d&columnsName=%s", ZbkgTodoConstant.finanilShareMoreTodoUrl,totalSize,this.sectionName);
//
//			c.addBottomButton(BaseSectionTemplete.BOTTOM_BUTTON_LABEL_MORE, "javascript:window.location.href='" + url +"'");
//			c.setDataNum(count);
//		} catch (Exception e) {
//			log.error("读取集成待办出错！",e);
//		}
//		return c;
//
//	  }
//}
