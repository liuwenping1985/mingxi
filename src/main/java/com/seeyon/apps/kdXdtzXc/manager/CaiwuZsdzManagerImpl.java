package com.seeyon.apps.kdXdtzXc.manager;

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
import org.springframework.jdbc.core.JdbcTemplate;

import com.seeyon.apps.kdXdtzXc.dao.CaiwuZsdzDao;
import com.seeyon.apps.kdXdtzXc.po.CaiwuJtdz;
import com.seeyon.apps.kdXdtzXc.po.CaiwuZsdz;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
public class CaiwuZsdzManagerImpl implements CaiwuZsdzManager {

	private static final Log LOGGER = LogFactory.getLog(CaiwuZsdzManagerImpl.class);
	
	private CaiwuZsdzDao caiwuZsdzDao;
	
	public CaiwuZsdzDao getCaiwuZsdzDao() {
		return caiwuZsdzDao;
	}

	public void setCaiwuZsdzDao(CaiwuZsdzDao caiwuZsdzDao) {
		this.caiwuZsdzDao = caiwuZsdzDao;
	}

	
	public List<CaiwuZsdz> getAll() throws BusinessException {
		return caiwuZsdzDao.getAll();
	}

	public List<CaiwuZsdz> getDataByIds(Long[] ids) {
		return caiwuZsdzDao.getDataByIds(ids);
	}

	public CaiwuZsdz getDataById(Long id) throws BusinessException {
		return caiwuZsdzDao.getDataById(id);
	}

	public void add(CaiwuZsdz caiwuZsdz) throws BusinessException {
		caiwuZsdzDao.add(caiwuZsdz);
	}

	public void update(CaiwuZsdz caiwuZsdz) throws BusinessException {
		caiwuZsdzDao.update(caiwuZsdz);
	}
	
	public void deleteAll(Long[] ids) throws BusinessException {
		caiwuZsdzDao.deleteAll(ids);
	}

	public void deleteById(Long id) throws BusinessException {
		caiwuZsdzDao.deleteById(id);
	}
	
	public FlipInfo getListCaiwuZsdzData(FlipInfo fi, Map<String, Object> params) throws BusinessException {
		String hql = "from CaiwuZsdz as caiwuZsdz ";
		List<CaiwuZsdz> dataList = DBAgent.find(hql, params, fi);
		fi.setData(dataList);
		return fi;
	}
	
	public FlipInfo getListCaiwuZsdzDialog(FlipInfo fi, Map<String, Object> params) throws BusinessException, ParseException {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String beginStr = params.get("bigdate")+"";
        String texValue = params.get("texValue")+""; //文本框
        String val = params.get("val")+""; //选择框
        Date beginTo;
        Date endTo;
        SimpleDateFormat dateFormat2 = new SimpleDateFormat("yyyyMMdd");
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(dateFormat.parse(beginStr));
		calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
		beginTo = calendar.getTime();
		User user = AppContext.getCurrentUser();
        Long account = user.getAccountId();
        String accountId = String.valueOf(account);
            calendar.setTime(dateFormat.parse(beginStr));
            calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
            endTo = calendar.getTime();
            
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
            
            String hql = "from CaiwuZsdz as caiwuZsdz where caiwuZsdz.accCheckBatchNo = :accCheckBatchNo order by NLSSORT(caiwuZsdz.passengerName,'NLS_SORT=SCHINESE_PINYIN_M')";
            String beg=dateFormat.format(beginTo);
            String end=dateFormat.format(endTo);
            Map<String, Object>map=new HashMap<String, Object>();
            /*map.put("createTime", beg);
            map.put("createTime1", end);*/
            map.put("accCheckBatchNo", accCheckBatchNo);
            if(!StringUtils.isEmpty(val) && "yzrxm".equals(val)){//人员姓名
            	hql+=" and caiwuZsdz.clientName like :clientName";
            	map.put("clientName", texValue+"%");
            }
            if(!StringUtils.isEmpty(val) && "bm".equals(val)){//部门
            	hql+=" and caiwuZsdz.dept like :dept";
            	map.put("dept", texValue+"%");
            }
            if(!StringUtils.isEmpty(val) && "hgjy".equals(val)){//合规校验
            	if("未合规".equals(texValue)){
            		hql+=" and caiwuZsdz.sDhgjy != :hgjx";
                	map.put("hgjx", "合规");
            	}else{
            	hql+=" and caiwuZsdz.sDhgjy like :sDhgjy";
            	map.put("sDhgjy", texValue+"%");
            	}
            }
            if(!StringUtils.isEmpty(val) && "ygxcqr".equals(val)){//员工行程确认
            	hql+=" and caiwuZsdz.ygxcQr like :ygxcQr";
            	map.put("ygxcQr", texValue+"%");
            }
            if(!StringUtils.isEmpty(val) && "jdlx".equals(val)){//房型
            	hql+=" and caiwuZsdz.roomName like :roomName";
            	map.put("roomName", texValue+"%");
            }
            if(!StringUtils.isEmpty(val) && "zfQr".equals(val)){//房型
            	hql+=" and caiwuZsdz.zfQr = :zfQr";
            	map.put("zfQr", texValue);
            }
            hql+=" ORDER BY caiwuZsdz.journeyId DESC";
            
    		List<CaiwuJtdz> dataList = DBAgent.find(hql,map,fi);
    		fi.setData(dataList);
		
		
		return fi;
	}
	
	public List<CaiwuZsdz> getPoiZs(String dateState){
		try {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			 	Date beginTo;
			    Date endTo;
			    SimpleDateFormat dateFormat2 = new SimpleDateFormat("yyyyMMdd");
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(dateFormat.parse(dateState));
				calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
				beginTo = calendar.getTime();
				
		        calendar.setTime(dateFormat.parse(dateState));
		        calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
		        endTo = calendar.getTime();
		        User user = AppContext.getCurrentUser();
		        Long account = user.getAccountId();
	            String accountId = String.valueOf(account);
	            
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
	            
			        
		        String hql = "from CaiwuZsdz as caiwuZsdz where caiwuZsdz.accCheckBatchNo = :accCheckBatchNo order by NLSSORT(caiwuZsdz.passengerName,'NLS_SORT=SCHINESE_PINYIN_M')";
		        String beg=dateFormat.format(beginTo);
		        String end=dateFormat.format(endTo);
		        Map<String, Object>map=new HashMap<String, Object>();
		        /*map.put("createTime", beg);
		        map.put("createTime1", end);*/
		        map.put("accCheckBatchNo", accCheckBatchNo);
			List<CaiwuZsdz> dataList = DBAgent.find(hql,map);
			return dataList;
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public void updateZhifu(Long id) throws BusinessException {
		String sql = "update CAIWU_ZSDZ  set CAIWU_ZSDZ.ZF_QR = '支付' where CAIWU_ZSDZ.ID ="+id;	
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		jdbcTemplate.update(sql);
		
	}

	@Override
	public void updateHeguiZS(Long id) {
		String updateSql="UPDATE CAIWU_ZSDZ SET SDHGJY='合规' WHERE ID="+id;
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		jdbcTemplate.update(updateSql);
		
	}

	@Override 
	public String getZsSum(String bigDate) throws ParseException {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
		Date beginTo;
        Date endTo;
        SimpleDateFormat dateFormat2 = new SimpleDateFormat("yyyyMMdd");
		
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(dateFormat.parse(bigDate));
		calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
		beginTo = calendar.getTime();
		
            calendar.setTime(dateFormat.parse(bigDate));
            calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
            endTo = calendar.getTime();
            
            User user = AppContext.getCurrentUser();
            Long account = user.getAccountId();
            String accountId = String.valueOf(account);
            
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
            
            
            String sql="SELECT NVL(SUM(AMOUNT), 0) as AMOUNTCWZS FROM CAIWU_ZSDZ WHERE ZF_QR ='支付' AND accCheckBatchNo = '"+accCheckBatchNo+"' ORDER BY NLSSORT(CLIENT_NAME,'NLS_SORT=SCHINESE_PINYIN_M')";
            List<Map<String, Object>> Listcwjt = jdbcTemplate.queryForList(sql);
            if(Listcwjt != null && Listcwjt.size() >0){
            	String sum=Listcwjt.get(0).get("AMOUNTCWZS")+"";
            	return sum;
            }
            return null;
	}

}
