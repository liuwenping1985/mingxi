package com.seeyon.apps.kdXdtzXc.scheduled;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.collaboration.batch.manager.BatchManager;
import com.seeyon.apps.kdXdtzXc.po.SetApprovalEntity;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.organization.manager.OrgManager;

/**
 * 携程提前审批定时器，把数据发到dmz区域
 */
public class XieChengTiQianShenPiScheduled {
    private JdbcTemplate jdbcTemplate;
    private BatchManager batchManager;
    private OrgManager orgManager;


    public JdbcTemplate getJdbcTemplate() {
        return jdbcTemplate;
    }

    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public BatchManager getBatchManager() {
        return batchManager;
    }

    public void setBatchManager(BatchManager batchManager) {
        this.batchManager = batchManager;
    }

    public OrgManager getOrgManager() {
        return orgManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void xieChengTiQianShengPi() {
        try {
            System.out.println("-----携程提前审批定时发送数据开始......start");
            JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
            String sql ="SELECT t.id as id,t.EmployeeID as EmployeeID ,t.ApprovalNumber as ApprovalNumber,t.Status as Status,t.BeginDate as BeginDate,t.EndDate as EndDate,t.PassengerList as PassengerList,t.FromCities as FromCities,t.ToCities as ToCities ,t.HhotelPassengerList as HhotelPassengerList,t.CheckInCities as CheckInCities,t.IsSend as IsSend  from SetApproval t WHERE t.Status =1 and  t.IsSend =0";
             List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(sql);
             for (Map<String, Object> map : queryForList) {
				String id=(String)map.get("id");
				String employeeID =  map.get("EmployeeID") == null ? "" : (String)map.get("EmployeeID");
				String approvalNumber =map.get("ApprovalNumber") ==null ? "" :(String)map.get("ApprovalNumber");
				String status =map.get("Status") ==null ? "" :(String)map.get("Status");
				String beginDate=map.get("BeginDate") ==null ? "" : (String)map.get("BeginDate");
				String endDate=map.get("EndDate") ==null ? "" :(String)map.get("EndDate");
				String passengerList =map.get("PassengerList") ==null ? "" :(String)map.get("PassengerList");
				String fromCities =map.get("FromCities") ==null ? "" :(String)map.get("FromCities");
				String toCities=map.get("ToCities") == null ? "" :(String)map.get("ToCities");
				String hotelPassengerList =map.get("HhotelPassengerList") ==null ? "" :(String)map.get("HhotelPassengerList");
				String checkInCities =map.get("CheckInCities") ==null ? "" :(String)map.get("CheckInCities");
				String isSend =map.get("IsSend") == null ? "" :(String)map.get("IsSend");
				
				SetApprovalEntity tq = new SetApprovalEntity(id,employeeID,approvalNumber,toCities,beginDate,endDate,status,passengerList, fromCities,toCities,hotelPassengerList,checkInCities, isSend);
				
				Map<String,Object> obj = new HashMap<String,Object>();
				obj.put("employeeID",employeeID );
				obj.put("approvalNumber", approvalNumber);
				obj.put("status", status);
				obj.put("beginDate", beginDate);
				obj.put("endDate", endDate);
				obj.put("passengerList",passengerList );
				obj.put("fromCities", fromCities);
				obj.put("toCities", toCities);
				obj.put("hotelPassengerList", hotelPassengerList);
				obj.put("checkInCities",checkInCities );
				String res = HttpClientUtil.post("http://localhost:8080/renren-fastplus/xiecheng/setApprovalentity/sendRequest", obj);
				System.out.println(res);
				if(res.equals("true")){
					String updatesql ="UPDATE SetApproval SET Status =0 ,IsSend =1 WHERE Id= "+tq.getId();
					jdbcTemplate.update(updatesql);
				}
					
				}
              System.out.println("-----携程提前审批定时发送数据结束......over");
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

}
