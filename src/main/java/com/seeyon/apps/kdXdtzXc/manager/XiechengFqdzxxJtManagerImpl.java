package com.seeyon.apps.kdXdtzXc.manager;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.dao.XiechengFqdzxxJtDao;
import com.seeyon.apps.kdXdtzXc.po.XiechengFqdzxxJt;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
public class XiechengFqdzxxJtManagerImpl implements XiechengFqdzxxJtManager {

	private static final Log LOGGER = LogFactory.getLog(XiechengFqdzxxJtManagerImpl.class);
	JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
	private XiechengFqdzxxJtDao xiechengFqdzxxJtDao;
	
	public XiechengFqdzxxJtDao getXiechengFqdzxxJtDao() {
		return xiechengFqdzxxJtDao;
	}

	public void setXiechengFqdzxxJtDao(XiechengFqdzxxJtDao xiechengFqdzxxJtDao) {
		this.xiechengFqdzxxJtDao = xiechengFqdzxxJtDao;
	}

	
	public List<XiechengFqdzxxJt> getAll() throws BusinessException {
		return xiechengFqdzxxJtDao.getAll();
	}

	public List<XiechengFqdzxxJt> getDataByIds(Long[] ids) {
		return xiechengFqdzxxJtDao.getDataByIds(ids);
	}

	public XiechengFqdzxxJt getDataById(Long id) throws BusinessException {
		return xiechengFqdzxxJtDao.getDataById(id);
	}

	public void add(XiechengFqdzxxJt xiechengFqdzxxJt) throws BusinessException {
		xiechengFqdzxxJtDao.add(xiechengFqdzxxJt);
	}

	public void update(XiechengFqdzxxJt xiechengFqdzxxJt) throws BusinessException {
		xiechengFqdzxxJtDao.update(xiechengFqdzxxJt);
	}
	
	public void deleteAll(Long[] ids) throws BusinessException {
		xiechengFqdzxxJtDao.deleteAll(ids);
	}

	public void deleteById(Long id) throws BusinessException {
		xiechengFqdzxxJtDao.deleteById(id);
	}
	
	public FlipInfo getListXiechengFqdzxxJtData(FlipInfo fi, Map<String, Object> params) throws BusinessException, ParseException {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String year=params.get("year")+"";
		String month=params.get("month")+"" == "" ? "0" : (String)params.get("month");
		if(!StringUtils.isEmpty(month) && Integer.valueOf(month) < 10){
			month="0"+month;
		}
		Map<String,Object> map=new HashMap<String, Object>();
		String hql = "from XiechengFqdzxxJt as xiechengFqdzxxJt";
		if(!StringUtils.isEmpty(year) && !"null".equals(year)){
			hql+=" where xiechengFqdzxxJt.year = :year";
			map.put("year", year);
		}
		if(!StringUtils.isEmpty(month) && "null".equals(month)){
			hql+=" where xiechengFqdzxxJt.month = :month";
			map.put("month", month);
		}
		if(!StringUtils.isEmpty(year) && !StringUtils.isEmpty(month)){
			hql ="from XiechengFqdzxxJt as xiechengFqdzxxJt where xiechengFqdzxxJt.year = :year and xiechengFqdzxxJt.month = :month";
			map.put("year", year);
			map.put("month", month);
		}
		List<XiechengFqdzxxJt> dataList = DBAgent.find(hql, map, fi);
		if(dataList != null && dataList.size() >0)
		for (XiechengFqdzxxJt xiechengFqdzxxJt : dataList) {
			//String date = xiechengFqdzxxJt.getTqTime();
			String year2 = xiechengFqdzxxJt.getYear();
			String month2 = xiechengFqdzxxJt.getMonth();
			Calendar calendar = Calendar.getInstance(); // 日历对象
			String date2=year2+"-"+month2+"-01";
			/*calendar.setTime(dateFormat.parse(date2));				// 设置当前日期
			calendar.add(Calendar.MONTH, -1);			// 月份减一
			String tqTime = dateFormat.format(calendar.getTime());*/
			  Date beginTo;
		        Date endTo;
		        User user = AppContext.getCurrentUser();
	            Long account = user.getAccountId();
	            String accountId = String.valueOf(account);
	            
				//Calendar calendar = Calendar.getInstance();
				calendar.setTime(dateFormat.parse(date2));
				calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
				beginTo = calendar.getTime();
				SimpleDateFormat dateFormat2 = new SimpleDateFormat("yyyyMMdd");
				String accCheckBatchNo = "";
				if("-1792902092017745579".equals(accountId)){
					accCheckBatchNo="cindaAsset_173907_"+dateFormat2.format(beginTo);
				}else if("2662344410291130278".equals(accountId)){
					accCheckBatchNo="cindaAssetBJ_182465_"+dateFormat2.format(beginTo);
				}if("1755267543710320898".equals(accountId)){
					accCheckBatchNo="cindaAssetHB_179331_"+dateFormat2.format(beginTo);
				}else if("-5358952287431081185".equals(accountId)){
					accCheckBatchNo="cindaAssetJS_179336_"+dateFormat2.format(beginTo);
				}
				
		            calendar.setTime(dateFormat.parse(date2));
		            calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
		            endTo = calendar.getTime();
		            String sqlJt="SELECT NVL(SUM(AMOUNT), 0) as AMOUNTjt FROM XIECHENG_JTDZ WHERE accCheckBatchNo = '"+accCheckBatchNo+"'";
		            String sqlZs="SELECT NVL(SUM(AMOUNT), 0) as AMOUNTzs FROM xiecheng_zsdz  WHERE accCheckBatchNo = '"+accCheckBatchNo+"'";
		            String cwjt1="SELECT NVL(SUM(AMOUNT), 0) as AMOUNTCWJT FROM CAIWU_JTDZ WHERE ZF_QR ='支付' AND accCheckBatchNo = '"+accCheckBatchNo+"'";
		            String cwzs1="SELECT NVL(SUM(AMOUNT), 0) as AMOUNTCWZS FROM CAIWU_ZSDZ WHERE ZF_QR ='支付' AND accCheckBatchNo = '"+accCheckBatchNo+"'";
		            List<Map<String, Object>> ListJt = jdbcTemplate.queryForList(sqlJt);
		            List<Map<String, Object>> ListZs = jdbcTemplate.queryForList(sqlZs);
		            List<Map<String, Object>> Listcwjt = jdbcTemplate.queryForList(cwjt1);
		            List<Map<String, Object>> Listcwzs = jdbcTemplate.queryForList(cwzs1);
		            String xcJT ="";
		            String xcZS ="";
		            String cwJT ="";
		            String cwZS ="";
		            		
		            if(ListJt != null &&ListJt.size() >0){
		            	xcJT = ListJt.get(0).get("AMOUNTjt")+"";
		            	xiechengFqdzxxJt.setXcJT(xcJT);
		            }
		            if(ListZs != null && ListZs.size() >0 && !ListZs.isEmpty()){
		            	xcZS = ListZs.get(0).get("AMOUNTzs")+"";
		            	xiechengFqdzxxJt.setXcZS(xcZS);
		            }
		            
		            if(Listcwjt != null && Listcwjt.size() >0){
		            	cwJT = Listcwjt.get(0).get("AMOUNTCWJT")+"";
		            	xiechengFqdzxxJt.setDzJT(cwJT);
		            }
		            if(Listcwzs != null && Listcwzs.size() >0){
		            	cwZS = Listcwzs.get(0).get("AMOUNTCWZS")+"";
		            	xiechengFqdzxxJt.setDzZS(cwZS);
		            }
		            
		            if(!StringUtils.isEmpty(xcJT) && !StringUtils.isEmpty(xcZS)){
		            	Double xcZJ=Double.valueOf(xcJT)+Double.valueOf(xcZS);
		            	xiechengFqdzxxJt.setXcZJ(String.valueOf(xcZJ));
		            }
		            
		           if(!StringUtils.isEmpty(cwJT) && !StringUtils.isEmpty(cwZS)){
		        	   Double cwZJ=Double.valueOf(cwJT)+Double.valueOf(cwZS);
		        	   xiechengFqdzxxJt.setDzZJ(String.valueOf(cwZJ));
		           }
		           
		}
		fi.setData(dataList);
		return fi;
	}

	@Override
	public List<Map<String, Object>> getByTime(int year, int month) {
		
		return xiechengFqdzxxJtDao.getByTime(year, month);
	}

	@Override
	public void updateById(Long id) throws BusinessException {
		try {
			Timestamp time = new Timestamp(System.currentTimeMillis());//得到当前时间
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String str = sdf.format(time);
			
			User user = AppContext.getCurrentUser();
			Long account = user.getAccountId();
			String accountid = String.valueOf(account);
			String sql ="";
			if(!StringUtils.isEmpty(accountid)){
				if("-1792902092017745579".equals(accountid)){ //总部
					 sql = "UPDATE XIECHENG_FQDZXX_JT  SET XIECHENG_FQDZXX_JT.DZ_TIME = '"+str+"',EXT_ATTR_1 = '已发起' WHERE XIECHENG_FQDZXX_JT.ID="+id;	
				}
				if("2662344410291130278".equals(accountid)){ //北分
					 sql = "UPDATE XIECHENG_FQDZXX_JT  SET XIECHENG_FQDZXX_JT.DZ_TIME = '"+str+"',bfType = '已发起' WHERE XIECHENG_FQDZXX_JT.ID="+id;	
				 }
				if("1755267543710320898".equals(accountid)){//湖北
					 sql = "UPDATE XIECHENG_FQDZXX_JT  SET XIECHENG_FQDZXX_JT.DZ_TIME = '"+str+"',hbType = '已发起' WHERE XIECHENG_FQDZXX_JT.ID="+id;	
				}
				if("-5358952287431081185".equals(accountid)){//江苏
					 sql = "UPDATE XIECHENG_FQDZXX_JT  SET XIECHENG_FQDZXX_JT.DZ_TIME = '"+str+"',jsType = '已发起' WHERE XIECHENG_FQDZXX_JT.ID="+id;	
				}
				
			}
			jdbcTemplate.update(sql);
			System.out.println("id*******************"+id);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
