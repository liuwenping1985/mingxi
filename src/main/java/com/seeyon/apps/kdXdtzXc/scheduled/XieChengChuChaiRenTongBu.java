package com.seeyon.apps.kdXdtzXc.scheduled;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.util.PropertiesUtils;
import com.seeyon.apps.kdXdtzXc.util.httpClient.HttpClientUtil;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.UUIDLong;

/**
 * 携程信息确认通过到携程获取数据更新表
 */
public class XieChengChuChaiRenTongBu {
	private JdbcTemplate jdbcTemplate;

	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}

	/**
	 * 出差人中间表数据同步
	 */
	public void xieChengChuCHaiRen() {
		try {
			String formman = (String) PropertiesUtils.getInstance().get("formman");  			 //主表
			String formshiji = (String) PropertiesUtils.getInstance().get("formsonShijiXinxi");  //实际信息表 
				JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
				String sql ="INSERT INTO "+formshiji+" (id,FORMMAIN_ID,sort,field0040,field0041,field0047) SELECT t.ID,t.formmain_id,t.sort,t.field0038,t.field0039,t.field0041 FROM "+formman+" f LEFT JOIN PRO_FORMSON_3969_temp t ON f.ID=t.formmain_id WHERE t.ID IS not NULL";
				int update = jdbcTemplate.update(sql);
				String sqlDelete="DELETE FROM PRO_FORMSON_3969_temp";
				int update2 = jdbcTemplate.update(sqlDelete);
				String deletenull = "delete from "+formshiji+" where 1=1 and field0041 is null and field0047 is null";
				jdbcTemplate.update(deletenull);
				//分公司
				String formmanFGS = (String) PropertiesUtils.getInstance().get("fGsformman");  			 //主表
				String formshijiFGS = (String) PropertiesUtils.getInstance().get("fGsFormson");  		//实际信息表 
				String sqlFGS ="INSERT INTO "+formshijiFGS+" (id,FORMMAIN_ID,sort,field0040,field0041,field0047) SELECT t.ID,t.formmain_id,t.sort,t.field0038,t.field0039,t.field0041 FROM "+formmanFGS+" f LEFT JOIN PRO_FORMSON_3995_temp t ON f.ID=t.formmain_id WHERE t.ID IS not NULL";
				int updateFGS = jdbcTemplate.update(sqlFGS);
				String sqlDeleteFGS="DELETE FROM PRO_FORMSON_3995_temp";
				int update2FGS = jdbcTemplate.update(sqlDeleteFGS);
				String deletenullFGS = "delete from "+formshijiFGS+" where 1=1 and field0041 is null and field0047 is null";
				jdbcTemplate.update(deletenullFGS);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
	}

}
