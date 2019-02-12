package com.seeyon.apps.kdXdtzXc.event;

//import com.seeyon.apps.kdXdtzXc.manager.TravelExpenseManager;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.workflow.event.AbstractWorkflowEvent;
import com.seeyon.ctp.workflow.event.WorkflowEventData;
import com.seeyon.ctp.workflow.event.WorkflowEventResult;

/**
 * 填充子表数据
 */
public class XieChengTiQianShengPiEvent extends AbstractWorkflowEvent {

	private static final Log log = LogFactory.getLog(XieChengTiQianShengPiEvent.class);

	@Override
	public String getId() {
		// TODO Auto-generated method stub
		return "XieChengTiQianShengPiEvent";
	}

	@Override
	public String getLabel() {
		// TODO Auto-generated method stub
		return "携程-提前审批(信达)";
	}

	@Override
	public WorkflowEventResult onBeforeCancel(WorkflowEventData data) {
		// TODO Auto-generated method stub
		System.out.println("onBeforeCancel");
		return super.onBeforeCancel(data);
	}

	@Override
	public WorkflowEventResult onBeforeFinishWorkitem(WorkflowEventData data) {
		// TODO Auto-generated method stub
		System.out.println("onBeforeFinishWorkitem");
		return super.onBeforeFinishWorkitem(data);
	}

	@Override
	public WorkflowEventResult onBeforeStart(WorkflowEventData data) {
		// TODO Auto-generated method stub
		System.out.println("onBeforeStart");
		return super.onBeforeStart(data);
	}

	@Override
	public WorkflowEventResult onBeforeStepBack(WorkflowEventData event) {
		// TODO Auto-generated method stub
		System.out.println("onBeforeStepBack");

		return super.onBeforeStepBack(event);
	}

	@Override
	public WorkflowEventResult onBeforeStop(WorkflowEventData data) {
		// TODO Auto-generated method stub
		System.out.println("onBeforeStop");
		return super.onBeforeStop(data);
	}

	@Override
	public WorkflowEventResult onBeforeTakeBack(WorkflowEventData data) {
		// TODO Auto-generated method stub
		System.out.println("onBeforeTakeBack");
		return super.onBeforeTakeBack(data);
	}

	@Override
	public void onCancel(WorkflowEventData data) {
		// TODO Auto-generated method stub
		System.out.println("onCancel");
		super.onCancel(data);
	}

	@Override
	public void onFinishWorkitem(WorkflowEventData event) {
		try {
			System.out.println("携程-提前审批(信达)");
			super.onFinishWorkitem(event);
			ColSummary colSummary = (ColSummary) event.getSummaryObj();
			Long formrecid = colSummary.getFormRecordid();
			JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			
			String formman = (String) PropertiesUtils.getInstance().get("formman");
			
			String proCode = "";   		//审批单上项目编码
			String depart = "";     		//审批单上受益部门编码
			String code = "";     		//出差审批单申请人编码
			String fromCities = ""; 	//出发城市
			String toCity = "";			//到达城市
			String hotelToCities ="";	//入住城市
			String beginDate = ""; 		//预计出差时间
			String endDate = ""; 		//预计返回时间
			String employeeID = "";
			String approvalNumber = "";
			Long shenqinren=null;
			String memberList = "";
			
			
			
			//  主表：申请人(field0003),申请单编号(field0002),项目编号(field0019), 受益部门(field0020),出差人(field0006 **** field0016),英文名称(field0007)
			//出发地(field0008), 目的地(field0030  field0049) 入住城市(field0050),预计出差时间(field0010),预计返回时间(field0051),出差性质(field0011,field0012,field0013)
			String sql = "SELECT field0002,field0003,field0019,field0020,field0006,field0007," +
					"field0008,field0049,field0050,field0010,field0016,field0051,field0011,field0012,field0013 FROM "+formman+" where id="+ formrecid;
			List<Map<String, Object>> Listsql = jdbcTemplate.queryForList(sql);
			for (Map<String, Object> map : Listsql) {
				shenqinren = Long.valueOf(map.get("field0003")+""); // 申请人id
				approvalNumber = map.get("field0002") == null ? "" : (String)map.get("field0002");		//审批单号 
				String passengerList = map.get("field0006") == null ? "" :(String)map.get("field0006"); //出差人    申请人 统一订票
				String dinpiaoren = map.get("field0016") == null ? "" :(String)map.get("field0016"); // 订票
				String passengerListEn = map.get("field0007") == null ? "" :(String)map.get("field0007"); //出差人英文名称
				fromCities =  map.get("field0008") == null ? "" : map.get("field0008").toString();		//出发地
				toCity = map.get("field0049") == null ? "" : map.get("field0049").toString();			//目的地
				hotelToCities = map.get("field0050") == null ? "" : map.get("field0050").toString();	//入住城市 field0050
				proCode = map.get("field0019") == null ? "" : (String)map.get("field0019");		  		//项目编号
				depart = map.get("field0020") == null ? "" : (String)map.get("field0020"); 		  		//受益部门
				beginDate = format.format((Date)map.get("field0010"));                            		//预计出发时间
				endDate = format.format((Date)map.get("field0051"));							  		//预计返回时间 field0051
				
				
				
				//======================拼接出差人信息开始======================
				memberList += "[";
				if(passengerList != null && !passengerList.equals("")){
					String[] memberAry = passengerList.split(","); 											
					if(memberAry != null && memberAry.length > 0){
						for (int i = 0;i < memberAry.length;i++) {
							if(i != 0)
								memberList += ",";
							Long memberId = Long.valueOf(memberAry[i]);
							String memberInfosql ="select m.name as name,p.login_name as loginname from org_member m LEFT JOIN org_principal p on p.member_Id = m.id where m.id="+memberId;
							log.info("*********"+memberInfosql);
							List<Map<String, Object>> memberLists = jdbcTemplate.queryForList(memberInfosql);
							if(memberLists != null &&memberLists.size() > 0){
								for (int j = 0;j < memberLists.size();j++) {
									Map<String, Object> memberMap = memberLists.get(j);
									String name = (String)memberMap.get("name");
									memberList += "{\"Name\"" +":"+ "\""+name+"\"}";
									//employeeID +=memberMap.get("loginname")+",";
								}
							}
						}
					}
				}
				if(passengerListEn != null && !passengerListEn.equals("")){
					String[] memberEnAry = passengerListEn.split(",");	
					if(memberEnAry != null && memberEnAry.length > 0){
						memberList += ",";
						for (int i = 0;i < memberEnAry.length;i++) {
							if(i != 0)
								memberList += ",";
							Long memberId = Long.valueOf(memberEnAry[i]);
							String memberInfosql ="select m.name as name,p.login_name as loginname from org_member m LEFT JOIN org_principal p on p.member_Id = m.id where m.id="+memberId;
							List<Map<String, Object>> memberLists = jdbcTemplate.queryForList(memberInfosql);
							if(memberLists != null &&memberLists.size() > 0){
								for (int j = 0;j < memberLists.size();j++) {
									Map<String, Object> memberMap = memberLists.get(j);
									String name = (String)memberMap.get("name");
									memberList += "{\"Name\"" +":"+ "\""+name+"\"}";
								}
							}
						}
					}		
				}
				memberList += "]";
				//======================拼接出差人信息结束======================
				if(dinpiaoren != null && !dinpiaoren.equals("")){
					String[] dinpiaomemberAry = dinpiaoren.split(","); 											
					if(dinpiaomemberAry != null && dinpiaomemberAry.length > 0){
						for (int i = 0;i < dinpiaomemberAry.length;i++) {
				String memberInfosql ="select LOGIN_NAME from org_principal  where MEMBER_ID="+dinpiaomemberAry[i];
				List<Map<String, Object>> memberid = jdbcTemplate.queryForList(memberInfosql);
								employeeID +=memberid.get(0).get("LOGIN_NAME")+",";
							}
						}
					}
				
			}
			/*String memberInfosql ="select LOGIN_NAME from org_principal  where MEMBER_ID="+dinpiaoren;
			List<Map<String, Object>> memberid = jdbcTemplate.queryForList(memberInfosql);
			employeeID+=memberid.get(0).get("LOGIN_NAME");*/
			//employeeID =employeeID.substring(0, employeeID.length()-1);
			StringBuilder build = new StringBuilder();
			build.append("{");
			build.append("\"ApprovalNumber\":\""+approvalNumber+"\",");    //OA审批单号
			build.append("\"EmployeeID\":\""+employeeID+"\",");    //
			build.append("\"Status\":\"1\",");				 			 //审批状态
			build.append("\"FromCities\":\""+fromCities+"\",");			 //出发地
			build.append("\"ToCities\":\""+toCity+"\",");			 		 //目的地
			build.append("\"HotelToCities\" : \""+hotelToCities+"\",");      //入住城市
			build.append("\"ToDate\"" +":"+ "\""+beginDate+"\","); 			 //预计出发时间
			build.append("\"ReturnDate\"" +":"+ "\""+endDate+"\","); 		 //预计返回时间
			build.append("\"PassengerList\" : "+memberList);		 		 //出差人员信息 
			build.append("}");
			
			Map<String, Object> SetApprovalJSON = new HashMap<String, Object>();
			SetApprovalJSON.put("SetApprovalJSON", build.toString());
			System.out.println(build.toString());
			String sendTiqianShenpi = (String) PropertiesUtils.getInstance().get("sendTiqianShenpi");
			String res = HttpClientUtil.post(sendTiqianShenpi,SetApprovalJSON);
			//System.out.println("["+approvalNumber+"]提前审批发送完毕："+res);
			log.info("["+approvalNumber+"]提前审批发送完毕："+res+build.toString());
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void onProcessFinished(WorkflowEventData data) {
		// TODO Auto-generated method stub
		System.out.println("onProcessFinished");
		super.onProcessFinished(data);
	}

	@Override
	public void onStart(WorkflowEventData data) {
		// TODO Auto-generated method stub
		System.out.println("onStart");
		super.onStart(data);
	}

	@Override
	public void onStepBack(WorkflowEventData event) {
		// TODO Auto-generated method stub

		System.out.println("onStart");
		super.onStepBack(event);

	}

	@Override
	public void onStop(WorkflowEventData data) {
		// TODO Auto-generated method stub
		System.out.println("onStop");
		super.onStop(data);
	}

	@Override
	public void onTakeBack(WorkflowEventData data) {
		// TODO Auto-generated method stub
		System.out.println("onTakeBack");
		super.onTakeBack(data);
	}
	
	/**
	 * 功能：根据枚举变量查询枚举显示值ctp_enum_item
	 * @return
	 */
	public String getEnumShowNameById(JdbcTemplate jdbcTemplate,String id){
		if(jdbcTemplate == null || id.equals("") || id == null)
			return "";
		
		Map<String, Object> map  = new HashMap<String, Object>();
		try {
			String sql = "select t.showvalue as showvalue from ctp_enum_item t where t.id = " + Long.valueOf(id);
			List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(sql);
			map = queryForList.get(0);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map.get("showvalue") == null ? "" : (String) map.get("showvalue");
	}

}
