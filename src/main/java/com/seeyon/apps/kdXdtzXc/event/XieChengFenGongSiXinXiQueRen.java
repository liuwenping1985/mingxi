package com.seeyon.apps.kdXdtzXc.event;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.kdXdtzXc.dao.XiechengJiaotongQxDao;
import com.seeyon.apps.kdXdtzXc.manager.GeRenZhiFuXinXi;
import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.workflow.event.AbstractWorkflowEvent;
import com.seeyon.ctp.workflow.event.WorkflowEventData;
import com.seeyon.ctp.workflow.event.WorkflowEventResult;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

/**
 * 填充携程信息确认
 */
public class XieChengFenGongSiXinXiQueRen extends AbstractWorkflowEvent {

	private static final Log log = LogFactory.getLog(XieChengXinXiQueRen.class);
	private GeRenZhiFuXinXi geRenZhiFuXinXi;
	private static JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		
	public GeRenZhiFuXinXi getGeRenZhiFuXinXi() {
		return geRenZhiFuXinXi;
	}

	public void setGeRenZhiFuXinXi(GeRenZhiFuXinXi geRenZhiFuXinXi) {
		this.geRenZhiFuXinXi = geRenZhiFuXinXi;
	}

	@Override
	public String getId() {
		// TODO Auto-generated method stub
		return "XieChengFenGongSiXinXiQueRen";
	}

	@Override
	public String getLabel() {
		// TODO Auto-generated method stub
		return "携程-分公司信息确认(信达)";
	}

	@Override
	public WorkflowEventResult onBeforeCancel(WorkflowEventData data) {
		// TODO Auto-generated method stub
		System.out.println("onBeforeCancel");
		return super.onBeforeCancel(data);
	}

	@Override
	public WorkflowEventResult onBeforeFinishWorkitem(WorkflowEventData event) {
		// TODO Auto-generated method stub
		System.out.println("onBeforeFinishWorkitem");
		return super.onBeforeFinishWorkitem(event);
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

	/**
	 * 功能：申请人出差信息确认后触发订单取数 
	 */
	@Override
	public void onFinishWorkitem(WorkflowEventData event) {
		System.out.println("携程-信息确认(信达)");
		super.onFinishWorkitem(event);
		ColSummary colSummary = (ColSummary) event.getSummaryObj();
		Long formrecid = colSummary.getFormRecordid();
		String formman = (String) PropertiesUtils.getInstance().get("fGsformman");  			 //主表
		String formshiji = (String) PropertiesUtils.getInstance().get("fGsFormson");  //实际信息表 

		// (1)主表： 得到审批单号 (field0002),出差人（field0006）
		String approvalNumberSql = "SELECT id,field0002,field0003,field0006,field0004 FROM "+formman+" where id="+ formrecid;
		List<Map<String, Object>> approvalList = jdbcTemplate.queryForList(approvalNumberSql);
		if (approvalList != null && approvalList.size() > 0) {
			for (Map<String, Object> map : approvalList) {
				Long mainId = Long.valueOf(map.get("id")+"");  												//主表ID
				String approvalNumber = map.get("field0002") == null ? "": (String) map.get("field0002");   //审批单号
				String memberIds = map.get("field0006") == null ? "": (String) map.get("field0006");        //出差人
				String sqr = map.get("field0003") == null ? "": (String) map.get("field0003");        //申请人
				String accountId = map.get("field0004") == null ? "": (String) map.get("field0004");    //机构
				// (2)获取出差人数据
				String[] memberAry = memberIds.split(","); // 出差人
				int members = memberAry.length; // 出差人数
				if (members > 0) {
					// (3)发送订单取数请求，将订单数据插入到DMZ数据库中
					String getOrderAddDMZ = (String) PropertiesUtils.getInstance().get("getOrderAddDMZ");
					Map<String, Object> jsonMap = new HashMap<String, Object>();
					jsonMap.put("ApprovalNumber", approvalNumber);
					jsonMap.put("accountId", accountId);
					String res = HttpClientUtil.post(getOrderAddDMZ, jsonMap);
					JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(res);
					String falg = (String) jsonObject.get("success");
					if (falg.equals("true")) {
						for (int m = 1; m <= memberAry.length; m++) {
							Long memberId = Long.valueOf(memberAry[m - 1] + "");
							if (memberId != null && !memberId.equals("")) {
									//携程详细信息访问地址
									String chuchaixiangqing = (String) PropertiesUtils.getInstance().get("chuchaixiangqing");
									String url = chuchaixiangqing + "&name="+ memberId + "&bianhao=" + approvalNumber;
									
									//主表id（formmain_id）、排序（sort）、序号（field0039）、出差人（field0040）、开始时间（field0028）、结束时间（field0029）、总天数（field0030）、详细信息(field0042)
									String querysql = "select id from "+formshiji+" where 1=1 and formmain_id ="+mainId+" and field0049="+memberId;
									List<Map<String, Object>> shijiList = jdbcTemplate.queryForList(querysql);
									if(shijiList != null && shijiList.size() == 0){
										Long uId=UUIDLong.longUUID();
										//添加实际信息  
										String insertxc = "INSERT INTO PRO_FORMSON_3995_temp (id,formmain_id,sort,field0038,field0039,field0041) " +
												"VALUES ("+uId+","+mainId+","+(m)+","+(m)+","+memberId+",'"+url+"')";
										log.info("sql*****************"+insertxc);
										int update = jdbcTemplate.update(insertxc);
											System.out.println(update);
											//String deletenull = "delete from "+formshiji+" where 1=1 and field0040 is null and field0042 is null";
											//jdbcTemplate.update(deletenull);
								}
							}
						}
					}
				}
			}
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

}
