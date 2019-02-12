package com.seeyon.apps.kdXdtzXc.manager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.po.CwBuzhuDateModel;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.DBAgent;

public class ShiJiChuCaiXinXiManageImpl implements ShiJiChuCaiXinXiManage {
    JdbcTemplate kimdeJdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");

	
    /**
	 * 功能：财务系统获取补助信息表数据
	 * @param kbigingDate
	 * @return
	 */
    @Override
	public List<CwBuzhuDateModel> getBuZhuXinXi(String kbigingDate){
		List<CwBuzhuDateModel> cwBuzhuDateModelList = new ArrayList<CwBuzhuDateModel>();
		if(kbigingDate != null && !kbigingDate.equals("")){
			try {
				if(kbigingDate.length() < 7)
					throw new BusinessException("日期格式不正确！");
				
				kbigingDate =  kbigingDate.substring(0,7);
				String hql="FROM CwBuzhuDateModel x WHERE x.createDate like :createDate";
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("createDate", kbigingDate+"%");
				cwBuzhuDateModelList = DBAgent.find(hql,map);
			} catch (BusinessException e) {
				e.printStackTrace();
			}
		}
		return cwBuzhuDateModelList;
	}
	
	/**
	 * 功能：得到数据库数据
	 * @param date 日期
	 * @return
	 * @throws Exception
	 */
	public String getBuzhuData(String date)throws Exception{
		List<CwBuzhuDateModel> cwBuzhuDateModelList = getBuZhuXinXi(date);
		String retunxml = "";
		if(cwBuzhuDateModelList != null && cwBuzhuDateModelList.size() > 0){
			for (CwBuzhuDateModel cwBuzhuDateModel : cwBuzhuDateModelList) {
	    		retunxml += "		<item>\n" ;
	    		retunxml += "            <SOURCE>"+cwBuzhuDateModel.getSource()+"</SOURCE>\n" ;
	    		retunxml += "            <APPL_ORDER_CODE>"+cwBuzhuDateModel.getApplOrderCode()+"</APPL_ORDER_CODE>\n" ;
	            retunxml += "            <APPL_USER_CODE>"+cwBuzhuDateModel.getApplUserCode()+"</APPL_USER_CODE>\n" ;
	            retunxml += "            <EMPLOYEE_CODE>"+cwBuzhuDateModel.getEmployeeCode()+"</EMPLOYEE_CODE>\n" ;
	            retunxml += "            <COM_CODE>"+cwBuzhuDateModel.getComCode()+"</COM_CODE>\n" ;
	            retunxml += "            <DEPT_CODE>"+cwBuzhuDateModel.getDeptCode()+"</DEPT_CODE>\n" ;
	            retunxml += "            <COST_CENTER>"+cwBuzhuDateModel.getCostCenter()+"</COST_CENTER>\n" ;
	            retunxml += "            <PROJECT_CODE>"+cwBuzhuDateModel.getProjectCode()+"</PROJECT_CODE>\n" ;
	            retunxml += "            <DATE_FROM>"+cwBuzhuDateModel.getDateFrom()+"</DATE_FROM>\n" ;
	            retunxml += "            <DATE_TO>"+cwBuzhuDateModel.getDateTo()+"</DATE_TO>\n" ;
	            retunxml += "            <LEAVE_NUM>"+cwBuzhuDateModel.getLeaveNum()+"</LEAVE_NUM>\n" ;
	            retunxml += "            <ALLOW_NUM>"+cwBuzhuDateModel.getAllowNum()+"</ALLOW_NUM>\n" ;
	            retunxml += "            <NON_ALLOW_NUM>"+cwBuzhuDateModel.getNonAllowNum()+"</NON_ALLOW_NUM>\n" ;
	            retunxml += "            <LEAVE_SITE>"+cwBuzhuDateModel.getLeaveSite()+"</LEAVE_SITE>\n" ;
	            retunxml += "            <LOCATION_TYPE>"+cwBuzhuDateModel.getLocationType()+"</LOCATION_TYPE>\n" ;
	            retunxml += "            <CURRENCY>"+cwBuzhuDateModel.getCurrency()+"</CURRENCY>\n" ;
	            retunxml += "            <LEAVE_SITE_2>"+cwBuzhuDateModel.getLeaveSite2()+"</LEAVE_SITE_2>\n" ;
	            retunxml += "            <DS_FLAG>"+cwBuzhuDateModel.getDsFlag()+"</DS_FLAG>\n" ;
	            retunxml += "            <OA_KEY>"+cwBuzhuDateModel.getOaKey()+"</OA_KEY>\n" ;
	            retunxml += "            <TRAVEL_DESCRIPTION>"+cwBuzhuDateModel.getTraveldescription()+"</TRAVEL_DESCRIPTION>\n" ;
	            retunxml += "            <ATTRIBUTE1>"+cwBuzhuDateModel.getAttribute1()+"</ATTRIBUTE1>\n" ;
	            retunxml += "            <ATTRIBUTE2>"+cwBuzhuDateModel.getAttribute2()+"</ATTRIBUTE2>\n" ;
	            retunxml += "            <ATTRIBUTE3>"+cwBuzhuDateModel.getAttribute3()+"</ATTRIBUTE3>\n" ;
	            retunxml += "            <ATTRIBUTE4>"+cwBuzhuDateModel.getAttribute4()+"</ATTRIBUTE4>\n" ;
	            retunxml += "            <ATTRIBUTE5>"+cwBuzhuDateModel.getAttribute5()+"</ATTRIBUTE5>\n" ;
	            retunxml += "            <ATTRIBUTE6>"+cwBuzhuDateModel.getAttribute6()+"</ATTRIBUTE6>\n" ;
	            retunxml += "        </item>\n" ;
			}
		}
		return retunxml;
	}
	
	@Override
	public String getBuZhuXinXis(String kbigingDate) {
		boolean success = true;
		String message = "";
		String info = "";
		String returnxml = "";
		try {
			returnxml =  getBuzhuData(kbigingDate);
			message = "获取补助信息数据成功";
		} catch (Exception e) {
			message = "获取补助信息数据失败";
			success = false;
			info = e.getMessage();
			e.printStackTrace();
		}
		
		String resultxml = "";
		//拼装xml格式数据
		resultxml += "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
		resultxml += "<root>\n";
		resultxml += "	<success>"+success+"</success>\n";			//<!-- 是否成功 -->
		resultxml += "	<message>"+message+"</message>\n";	//<!-- 消息 -->
		resultxml += "	<info>"+info+"</info>\n";					//<!-- 额外信息包括错误消息-->
		resultxml += "	<items>\n" ;
		resultxml += returnxml;
		resultxml += "	</items>\n";
		resultxml += "</root>";
		return resultxml;
	}
	
}
