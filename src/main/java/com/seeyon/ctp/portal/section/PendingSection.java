package com.seeyon.ctp.portal.section;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;

import com.itextpdf.text.log.SysoCounter;
import com.seeyon.apps.collaboration.manager.PendingManager;
import com.seeyon.apps.taskcenter.Manager.TaskCenterManager;
import com.seeyon.apps.taskcenter.bo.CenterTaskBO;
import com.seeyon.apps.taskcenter.constant.TaskCenterConstant;
import com.seeyon.apps.taskcenter.webclient.WorkToDoWebServiceServiceStub;
import com.seeyon.apps.taskcenter.webclient.WorkToDoWebServiceServiceStub.GetUserWorkTodoNum;
import com.seeyon.apps.taskcenter.webclient.WorkToDoWebServiceServiceStub.GetUserWorkTodoNumE;
import com.seeyon.apps.taskcenter.webclient.WorkToDoWebServiceServiceStub.GetUserWorkTodoNumResponseE;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.po.template.CtpTemplateCategory;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.IframeTemplete;
import com.seeyon.ctp.portal.section.templete.MultiRowThreeColumnTemplete;
import com.seeyon.ctp.portal.section.templete.MultiRowVariableColumnTemplete;
import com.seeyon.ctp.portal.section.templete.MultiRowVariableColumnTemplete.Row;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.portal.util.PortletPropertyContants.PropertyName;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;

import cn.com.cinda.taskcenter.util.StringUtils;


public class PendingSection extends BaseSectionImpl {
	private static Log LOG = CtpLogFactory.getLog(PendingSection.class);
	private PendingManager pendingManager;
    private TaskCenterManager taskCenterManager;
    private TemplateManager templateManager;

	public void setTemplateManager(TemplateManager templateManager) {
		this.templateManager = templateManager;
	}

	public void setTaskCenterManager(TaskCenterManager taskCenterManager) {
		this.taskCenterManager = taskCenterManager;
	}
	
    public void setPendingManager(PendingManager pendingManager) {
        this.pendingManager = pendingManager;
    }

    @Override
    public void init() {
    	super.init();
    	if (AppContext.hasPlugin("edoc")) {
    		return;
    	}
    	
    	//不展示公文相关配置信息
    	List<SectionProperty> properties = this.getProperties();
    	for (SectionProperty sp : properties) {
    		SectionReference[] references = sp.getReference();
    		for (SectionReference ref : references) {
    			if ("rowList".equals(ref.getName())) {
    				SectionReferenceValueRange[] valueRanges = ref.getValueRanges();
    				List<SectionReferenceValueRange> result = new ArrayList<SectionReferenceValueRange>(); 
    				for (SectionReferenceValueRange val : valueRanges) {
    					if (!"edocMark".equals(val.getValue()) && !"sendUnit".equals(val.getValue())) {
    						result.add(val);
    					}
    				}
    				ref.setValueRanges(result.toArray(new SectionReferenceValueRange[0]));
    			}
    		}
    	}
    }
    
    @Override
	public String getIcon() {
		return null;
	}

	@Override
	public String getId() {
		return "pendingSection";
	}

	@Override
    public String getBaseName(Map<String, String> preference) {
	    String name = preference.get("columnsName");
        if(Strings.isBlank(name)){
            name = ResourceUtil.getString("common.my.pending.title");
        }
        return name;
    }

    @Override
	public String getName(Map<String, String> preference) {
		//栏目显示的名字，必须实现国际化，在栏目属性的“columnsName”中存储
        String name = preference.get("columnsName");
        if(Strings.isBlank(name)){
            return ResourceUtil.getString("common.my.pending.title");//待辦事项
        }else{
            return name;
        }
	}

	@Override
	public Integer getTotal(Map<String, String> preference) { 
		//客开 start
        /*Long memberId = AppContext.currentUserId();
        Long fragmentId = Long.parseLong(preference.get(PropertyName.entityId.name()));
        String ordinal = preference.get(PropertyName.ordinal.name());
        
        Integer total =  this.pendingManager.getPendingCount(memberId, fragmentId, ordinal);
        
        int count = SectionUtils.getSectionCount(8, preference);
        String str = "group1,group2,group3,group4";
		String[] group = str.split(",");
		for(String param:group){
			FlipInfo flipInfo = new FlipInfo(0, count);
			Map<String, String> map = new HashMap<String, String>();
			map.put("gcode", param);
			total+=taskCenterManager.todoList(flipInfo, map).getTotal();
		}
        
        return total;*/
		
		return null;
		//客开 end
	}

	@Override
	public BaseSectionTemplete projection(Map<String, String> preference) {
		//客开 郭雪岩 start
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		LOG.info("获取OA待办开始时间----------1：" + Timestamp.valueOf(dateFormat.format(new Date())));
		MultiRowVariableColumnTemplete c = new MultiRowVariableColumnTemplete();
		try {
			//int count = SectionUtils.getSectionCount(8, preference);
			int count = 6;//客开  gxy 20180514 之前是8所以该栏目比其他栏目高两个数据高度
			User user = AppContext.getCurrentUser();
			String fragmentId=preference.get(PropertyName.entityId.name());
			String ordinal = preference.get(PropertyName.ordinal.name());
			//String countStr = preference.get("count");
			String currentPanel = SectionUtils.getPanel("all", preference);
			String rowStr = "subject,receiveTime,category,sendUser";
			List<CtpAffair> affairs  = this.pendingManager.getPendingList(user.getId(), Long.parseLong(fragmentId), ordinal, count);
			List<PendingRow> rowList = pendingManager.affairList2PendingRowList(affairs, false,false, user, currentPanel, true,rowStr);
			LOG.info("获取OA待办结束时间----------2：" + Timestamp.valueOf(dateFormat.format(new Date())));
			// 第三方待办调用
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
				LOG.error("待办栏目获取第三方代办数据异常",e);
			}
			LOG.info("获取第三方待办结束 时间----------3：" + Timestamp.valueOf(dateFormat.format(new Date())));
			
			MultiRowVariableColumnTemplete.Row rowsub = c.addRow();
			MultiRowVariableColumnTemplete.Cell subrows = rowsub.addCell();
			subrows.setAlt("任务来源");
			subrows.setCellContent("任务来源");
			subrows.setClassName("font_bold");
			subrows.setCellWidth(20);
			
			MultiRowVariableColumnTemplete.Cell subrows1 = rowsub.addCell();
			subrows1.setAlt("标题");
			subrows1.setCellContent("标题");
			subrows1.setClassName("font_bold");
			subrows1.setCellWidth(40);
			
			MultiRowVariableColumnTemplete.Cell subrows2 = rowsub.addCell();
			subrows2.setAlt("接收时间");
			subrows2.setCellContent("接收时间");
			subrows2.setClassName("font_bold");
			subrows2.setCellWidth(20);
			
			MultiRowVariableColumnTemplete.Cell subrows3 = rowsub.addCell();
			//subrows3.setAlt("上一处理人");
			//subrows3.setCellContent("上一处理人");
			subrows3.setAlt("任务环节");//客开 gxy 20180725 “上一处理人”换为“任务环节”
			subrows3.setCellContent("任务环节");//客开 gxy 20180725 “上一处理人”换为“任务环节”
			subrows3.setClassName("font_bold");
			subrows3.setCellWidth(20);
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm");
			int sectionCount = 0;
			for (PendingRow data : rowList) {
				if(sectionCount==count){
					break;
				}				
				MultiRowVariableColumnTemplete.Row row = c.addRow();
				MultiRowVariableColumnTemplete.Cell flowName = row.addCell();
				// 客开  郭雪岩  START
				try {
					CtpTemplateCategory clc = null;
					if(data.getTemplateId()!=null && !"".equals(data.getTemplateId()) && !"null".equals(data.getTemplateId())){
						CtpTemplate ctpTemplate = templateManager.getCtpTemplate(Long.valueOf(data.getTemplateId()));
						clc = templateManager.getCtpTemplateCategory(ctpTemplate.getCategoryId());
						if("发文模版".equals(clc.getName())){
							if("-2066523224662719456".equals(ctpTemplate.getId()+"") ){
	    						flowName.setCellContent("部门发文");
	    						flowName.setAlt("部门发文");
	    					}else{
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
						//客开 2018-07-03 赵培珅 任务来源显示错误 end 
					}else{
						flowName.setCellContent(data.getCategoryLabel());
						flowName.setAlt(data.getCategoryLabel());
					}
				} catch (Exception e) {
					LOG.error("获取任务来源异常",e);
				}
				
				// 客开  END
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
			
			LOG.info("构造待办数据结束 时间----------4：" + Timestamp.valueOf(dateFormat.format(new Date())));
			MultiRowVariableColumnTemplete.Row hrRow = c.addRow();
			MultiRowVariableColumnTemplete.Cell hrName = hrRow.addCell();
			String hrcount = this.getHrCountSizeByClient(user.getLoginName());
			hrName.setAlt("人力资源");
			hrName.setCellContent("人力资源("+hrcount+")");
			hrName.setOpenType(BaseSectionTemplete.OPEN_TYPE.openWorkSpace);
			hrName.setLinkURL("javascript:function openwin(){openCtpWindow({'url':'"+this.getHROpenUrl(user.getLoginName())+"'});return;};openwin();");
			hrName.setCellWidth(20);
			hrRow.addCell();
			hrRow.addCell();
			
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
				LOG.error("待办栏目名转url码异常!",e);
			}
			c.addBottomButton(BaseSectionTemplete.BOTTOM_BUTTON_LABEL_MORE, "/collaboration/pending.do?method=morePending&fragmentId="+preference.get(PropertyName.entityId.name())+"&ordinal="+preference.get(PropertyName.ordinal.name())+"&currentPanel="+currentPanel+"&rowStr="+rowStr+ "&columnsName="+s,null,"sectionMoreIco");
		
			LOG.info("所有待办数据结束 时间----------5：" + Timestamp.valueOf(dateFormat.format(new Date())));
		} catch (Exception e) {
			LOG.error("待办栏目异常!",e);
		}
		return c;
		//客开 end
	}
	/**
	 * 根据设置的显示行数计算iframe的高度
	 */
	private int calculateHeight(int pageSize){
		int heightSize=0;
        heightSize=pageSize*26;
        return heightSize;
	}

	@Override
	public List<Map<String, Object>> getDesignDataForAdmin(){
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		Map<String,Object> data = new HashMap<String, Object>();
		data.put("subject", "待办栏目标题1");
		data.put("createTime", "2015-12-10");
		data.put("sender", "翟锋");
		data.put("type", "协同");
		
		for(int i=0;i<10;i++){
			list.add(data);
		}
		return list;
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
                	 LOG.error("待办数据时间比较异常",e);
                 }
                 return 0;
             }
         });
     }
	
	/***
	 * 获取人力资源待办数量	
	 * @param loginName
	 * @return
	 */
	public String getHrCountSizeByClient(String loginName){
		GetUserWorkTodoNum param = new GetUserWorkTodoNum();
		param.setArg0(loginName);
		GetUserWorkTodoNumE getobj = new GetUserWorkTodoNumE();
		getobj.setGetUserWorkTodoNum(param);
		try {
			WorkToDoWebServiceServiceStub stub = new WorkToDoWebServiceServiceStub(TaskCenterConstant.hrRemoteUrl);
			GetUserWorkTodoNumResponseE res = stub.getUserWorkTodoNum(getobj);
			if(res!=null && res.getGetUserWorkTodoNumResponse()!=null){
				int result = res.getGetUserWorkTodoNumResponse().get_return();
				LOG.info("通过接口获得HR待办数量：count="+result);
				if(result>0){
					
					return result+"";
				}
				
			}
		} catch (Exception e) {
			LOG.error("获取HR待办数量出错！",e);
		}
		return "0";
	}

	/**
	 * 来自countTodolistByGroup.jsp 获得hr待办的url
	 * @param loginName
	 * @return
	 */
	public String getHROpenUrl(String loginName){
		//获取人力资源远程调用URL
		String zcRemoteUrl = TaskCenterConstant.zcRemoteUrl; //UrlHelp.getVal("serverconf","zcRemoteUrl");
		//获取portalUser
		String todayTime = Datetimes.format(new Date(), "yyyy-MM-dd HH:mm:ss");
		String enString = StringUtils.encrypt(loginName + "," + todayTime);
		String url = zcRemoteUrl+"?otherIdp=1&portalUser="+enString+"&type=sso";
		LOG.info("获取人力资源待办URL为："+url);
		return url;
	}
	
	//客开 end
}
