package com.seeyon.apps.kdXdtzXc.section;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.collaboration.manager.PendingManager;
import com.seeyon.apps.custom.manager.CustomManager;
import com.seeyon.apps.taskcenter.Manager.TaskCenterManager;
import com.seeyon.apps.taskcenter.bo.CenterTaskBO;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.po.template.CtpTemplateCategory;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.portal.section.BaseSectionImpl;
import com.seeyon.ctp.portal.section.PendingRow;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.MultiRowVariableColumnTemplete;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.portal.util.PortletPropertyContants.PropertyName;
import com.seeyon.v3x.common.web.login.CurrentUser;

/**
 * Created by tap-pcng43 on 2017-9-19.
 */
public class LingdaoDaiBan extends BaseSectionImpl {
	
	private static final Log log = LogFactory.getLog(LingdaoDaiBan.class);

    @Override
    public String getId() {
        return "jichengyingyong";
    }

    @Override
    public String getName(Map<String, String> map) {
        return "领导待办";
    }

    @Override
    public Integer getTotal(Map<String, String> map) {
        return null;
    }

    @Override
    public String getIcon() {
        return null;
    }

    public BaseSectionTemplete projection(Map<String, String> preference) {
        /*IframeTemplete iframeTemplete=new IframeTemplete();
    	iframeTemplete.setHeight("208");
        iframeTemplete.setUrl("/seeyon/lingDaoDaiBanController.do?method=listXdtzLindao&radmon="+UUID.randomUUID().toString());
        iframeTemplete.addBottomButton("common_more_label", "/lingDaoDaiBanController.do?method=listallaffair");
    	return iframeTemplete;*/
    	

		//客开 start
		MultiRowVariableColumnTemplete c = new MultiRowVariableColumnTemplete();
		try {
			//int count = SectionUtils.getSectionCount(8, preference);
			int count = 7;
			User user=  AppContext.getCurrentUser();
			String fragmentId=preference.get(PropertyName.entityId.name());
			String ordinal = preference.get(PropertyName.ordinal.name());
			String currentPanel = SectionUtils.getPanel("all", preference);
			String rowStr = "subject,receiveTime,category,sendUser";
			PendingManager pendingManager = (PendingManager) AppContext.getBean("pendingManager");
			TaskCenterManager taskCenterManager = (TaskCenterManager) AppContext.getBean("taskCenterManager");
			
			List<CtpAffair> affairs = new ArrayList<CtpAffair>();
			
			Map<String, Object> map = new HashMap<String, Object>();
	        CustomManager customManager = (CustomManager) AppContext.getBean("customManager");
	        map = customManager.isSecretary();
	        //boolean fff = Boolean.valueOf(map.get("flag")+"");
	        if(map.get("leaderID")!=null && !"".equals(map.get("leaderID"))){
	        	List<CtpAffair> aff = pendingManager.getPendingList(Long.valueOf(map.get("leaderID")+""), Long.parseLong(fragmentId), ordinal, count);
				affairs.addAll(aff);            
			}
	        
			
			/*Connection conn = null;
	    	PreparedStatement ps = null;
	    	ResultSet rs = null;
	    	try {
	    		DBService dbService = DBService.getInstence();
	     		conn = dbService.connectDatabase();
	     		ps = conn.prepareStatement("select field0001 from formmain_2859 where field0002 = '"+user.getId()+"'");
	     		rs = ps.executeQuery();
	     		while (rs.next()) { 
	     			//if(user.getId()==rs.getLong(1)){
	     				List<CtpAffair> aff = pendingManager.getPendingList(rs.getLong(1), Long.parseLong(fragmentId), ordinal, count);
						affairs.addAll(aff); 
	     			//}
	            }
			} catch (Exception e) {
				log.error("获取数据异常",e);
			}finally {
				try {
					rs.close();
					ps.close();
		            conn.close();
				} catch (SQLException e) {
					log.error("连接关闭异常",e);
				}
			}*/

			//affairs  = pendingManager.getPendingList(user.getId(), Long.parseLong(fragmentId), ordinal, count);
			List<PendingRow> rowList = pendingManager.affairList2PendingRowList(affairs, false,false, user, currentPanel, true,rowStr);
			
			for(PendingRow pr:rowList){
				pr.setLink(pr.getLink().replace("Pending", "Done"));
			}
			
			
			try {
				//String str = "group1,group2,group3,group4";
				//String[] group = str.split(",");
				//for(String param:group){
					List<CenterTaskBO> tslist = taskCenterManager.newjasonTodolist(user.getLoginName(), "");
					for(CenterTaskBO ttb:tslist){
						PendingRow pr = new PendingRow();
						pr.setSubject(ttb.getSubject());
						pr.setCategoryLabel(ttb.getFlowName());
						pr.setReceiveTimeAll(ttb.getAssignerTime());
						pr.setPolicyName(ttb.getFlowNode());//客开 gxy 20180725 添加“任务环节”
						pr.setLink("javascript:function openwin(){openCtpWindow({'url':'"+ttb.getLinkPath()+"'});return;};openwin();");
						rowList.add(pr);
					}
				//}
				ListSort(rowList);
			} catch (Exception e) {
				log.error("待办栏目获取第三方代办数据异常",e);
			}
			

			MultiRowVariableColumnTemplete.Row rowsub = c.addRow();
			MultiRowVariableColumnTemplete.Cell subrows = rowsub.addCell();
			subrows.setAlt("任务来源");
			subrows.setCellContent("任务来源");
			subrows.setCellWidth(20);
			
			MultiRowVariableColumnTemplete.Cell subrows1 = rowsub.addCell();
			subrows1.setAlt("标题");
			subrows1.setCellContent("标题");
			subrows1.setCellWidth(40);
			
			MultiRowVariableColumnTemplete.Cell subrows2 = rowsub.addCell();
			subrows2.setAlt("接受时间");
			subrows2.setCellContent("接受时间");
			subrows2.setCellWidth(20);
			
			MultiRowVariableColumnTemplete.Cell subrows3 = rowsub.addCell();
			//subrows3.setAlt("上一处理人");
			//subrows3.setCellContent("上一处理人");
			subrows3.setAlt("任务环节");//客开 gxy 20180725 “上一处理人”换为“任务环节”
			subrows3.setCellContent("任务环节");//客开 gxy 20180725 “上一处理人”换为“任务环节”
			subrows3.setClassName("font_bold");
			subrows3.setCellWidth(20);
			
			int sectionCount = 0;
			for (PendingRow data : rowList) {
				if(sectionCount==count){
					break;
				}
				
				MultiRowVariableColumnTemplete.Row row = c.addRow();

				
				MultiRowVariableColumnTemplete.Cell flowName = row.addCell();
				
				try {
					CtpTemplateCategory clc = null;
					if(data.getTemplateId()!=null && !"".equals(data.getTemplateId()) && !"null".equals(data.getTemplateId())){
						TemplateManager templateManager = (TemplateManager) AppContext.getBean("templateManager");
						CtpTemplate ctpTemplate = templateManager.getCtpTemplate(Long.valueOf(data.getTemplateId()));
						clc = templateManager.getCtpTemplateCategory(ctpTemplate.getCategoryId());
						if("发文模版".equals(clc.getName())){
							if("2070909567281088475".equals(ctpTemplate.getId()+"") ){
	    						flowName.setCellContent("公司发文");
	    						flowName.setAlt("公司发文");
	    					}else if("-2066523224662719456".equals(ctpTemplate.getId()+"") ){
	    						flowName.setCellContent("部门发文");
	    						flowName.setAlt("部门发文");
	    					}else {
	    						flowName.setCellContent("公司发文");
	    						flowName.setAlt("公司发文");
	    					}
						//客开 2018-07-03 赵培珅 任务来源显示错误 start 	
						}else if("收文模版".equals(clc.getName())){
								flowName.setCellContent("收文处理");
								flowName.setAlt("收文处理");
    					}else{
    						flowName.setCellContent(clc.getName());
    						flowName.setAlt(clc.getName());
    					}
						
						if("2135462982126750833".equals(ctpTemplate.getId()+"") ){
							flowName.setCellContent("签报");
    						flowName.setAlt("签报");
    					}
						//客开 2018-07-03 赵培珅 任务来源 显示错误 end 
					}else{
						flowName.setCellContent(data.getCategoryLabel());
						flowName.setAlt(data.getCategoryLabel());
					}
					
				} catch (Exception e) {
					log.error("获取任务来源异常",e);
				}
				
				
				flowName.setOpenType(BaseSectionTemplete.OPEN_TYPE.openWorkSpace);
				flowName.setLinkURL(data.getLink());
				flowName.setCellWidth(20);
				
				MultiRowVariableColumnTemplete.Cell flowNode = row.addCell();
				flowNode.setAlt(data.getSubject());
				flowNode.setCellContent(data.getSubject());
				flowNode.setOpenType(BaseSectionTemplete.OPEN_TYPE.openWorkSpace);
				flowNode.setLinkURL(data.getLink());
				flowNode.setCellWidth(40);
								
				MultiRowVariableColumnTemplete.Cell submitTime = row.addCell();
				submitTime.setAlt(data.getReceiveTimeAll().substring(0, 16));
				submitTime.setCellContent(data.getReceiveTimeAll().substring(0, 16));
				submitTime.setOpenType(BaseSectionTemplete.OPEN_TYPE.openWorkSpace);
				submitTime.setLinkURL(data.getLink());
				submitTime.setCellWidth(20);
				
				MultiRowVariableColumnTemplete.Cell doneuser = row.addCell();
				/*doneuser.setAlt(data.getPreApproverName());
				doneuser.setCellContent(data.getPreApproverName());*/
				doneuser.setAlt(data.getPolicyName());//客开 gxy 20180725 “上一处理人”换为“任务环节”
				doneuser.setCellContent(data.getPolicyName());//客开 gxy 20180725 “上一处理人”换为“任务环节”
				doneuser.setOpenType(BaseSectionTemplete.OPEN_TYPE.openWorkSpace);
				doneuser.setLinkURL(data.getLink());
				doneuser.setCellWidth(20);
					
				sectionCount++;
			}
			
			for (int i = 0; i < (count-rowList.size()); i++) {
				MultiRowVariableColumnTemplete.Row row = c.addRow();
				row.addCell();
				row.addCell();
				row.addCell();
			}
			String s="";
			try {
				s = URLEncoder.encode(this.getName(preference),"utf-8");
			} catch (UnsupportedEncodingException e) {
				log.error("待办栏目名转url码异常!",e);
			}
			c.addBottomButton(BaseSectionTemplete.BOTTOM_BUTTON_LABEL_MORE,"/lingDaoDaiBanController.do?method=listallaffair",null,"sectionMoreIco");
		} catch (Exception e) {
			log.error("待办栏目异常!",e);
		}
		return c;
		//客开 end
	
    }

    public boolean isAllowUsed() {
    	/*Connection conn = null;
    	PreparedStatement ps = null;
    	ResultSet rs = null;
    	boolean useFlag = false;
    	try {
    		User user = CurrentUser.get();
    		DBService dbService = DBService.getInstence();
     		conn = dbService.connectDatabase();
     		ps = conn.prepareStatement("select field0002 from formmain_2859");
     		rs = ps.executeQuery();
     		while (rs.next()) { 
     			if(user.getId()==rs.getLong(1)){
     				useFlag = true;
     				break;
     			}
            }
     		
            return useFlag;
		} catch (Exception e) {
			log.error("获取数据异常",e);
		}finally {
			try {
				rs.close();
				ps.close();
	            conn.close();
			} catch (SQLException e) {
				log.error("连接关闭异常",e);
			}
		}*/
    	boolean useFlag = false;
    	User user = CurrentUser.get();
    	CustomManager customManager = (CustomManager) AppContext.getBean("customManager");
        List<Long> secretary = customManager.queryallSecretary();
        for(long l:secretary){
        	if(user.getId()==l){
        		useFlag = true;
 				break;
 			}
        }
        return useFlag || user.isAdmin();
        //User user = CurrentUser.get();
        //orgManager.hasSpecificRole(memberId,loginAccountId,"公文导出审批");
        //return user("F07_recDJSearch") || user.isAdmin() || user.isGroupAdmin();
    }

    public boolean isAllowUsed(String spaceType) {
        return this.isAllowUsed();
    }

    public boolean isAllowUserUsed(String singleBoardId) {
        return this.isAllowUsed();
    }
    
    
  //客开 start
  	public  void ListSort(List<PendingRow> list) {
           Collections.sort(list, new Comparator<PendingRow>() {
               public int compare(PendingRow o1, PendingRow o2) {
               SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
               try {
              	 	 Date dt1 = null;
              	 	 if(o1.getReceiveTimeAll().contains("今日")){
              	 		 dt1 = new Date();
              	 	 }else{
              	 		 dt1 = format.parse(o1.getReceiveTimeAll());
              	 	 }
                       
                       Date dt2 = null;
                       
                       if(o2.getReceiveTimeAll().contains("今日")){
                      	 dt2 = new Date();
              	 	 }else{
              	 		 dt2 = format.parse(o2.getReceiveTimeAll());
              	 	 }
                       if (dt1.getTime() < dt2.getTime()) {
                           return 1;
                       } else if (dt1.getTime() > dt2.getTime()) {
                           return -1;
                       } else {
                           return 0;
                       }
                   } catch (Exception e) {
                  	 log.error("待办数据时间比较异常",e);
                   }
                   return 0;
               }
           });
       }

}
