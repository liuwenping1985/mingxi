package com.seeyon.apps.kdXdtzXc.manager;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.kdXdtzXc.dao.XiechengZhusuQxDao;
import com.seeyon.apps.kdXdtzXc.po.XieChengVipJiuDianPo;
import com.seeyon.apps.kdXdtzXc.po.XieChengXieYiJiuDiangPo;
import com.seeyon.apps.kdXdtzXc.po.XiechengZhusuQx;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.UUIDLong;
public class XiechengZhusuQxManagerImpl implements XiechengZhusuQxManager {

	private static final Log LOGGER = LogFactory.getLog(XiechengZhusuQxManagerImpl.class);
	
	private XiechengZhusuQxDao xiechengZhusuQxDao;
	
	public XiechengZhusuQxDao getXiechengZhusuQxDao() {
		return xiechengZhusuQxDao;
	}

	public void setXiechengZhusuQxDao(XiechengZhusuQxDao xiechengZhusuQxDao) {
		this.xiechengZhusuQxDao = xiechengZhusuQxDao;
	}

	
	public List<XiechengZhusuQx> getAll() throws BusinessException {
		return xiechengZhusuQxDao.getAll();
	}

	public List<XiechengZhusuQx> getDataByIds(Long[] ids) {
		return xiechengZhusuQxDao.getDataByIds(ids);
	}

	public XiechengZhusuQx getDataById(Long id) throws BusinessException {
		return xiechengZhusuQxDao.getDataById(id);
	}

	public void add(XiechengZhusuQx xiechengZhusuQx) throws BusinessException {
		xiechengZhusuQxDao.add(xiechengZhusuQx);
	}

	public void update(XiechengZhusuQx xiechengZhusuQx) throws BusinessException {
		xiechengZhusuQxDao.update(xiechengZhusuQx);
	}
	
	public void deleteAll(Long[] ids) throws BusinessException {
		xiechengZhusuQxDao.deleteAll(ids);
	}

	public void deleteById(Long id) throws BusinessException {
		xiechengZhusuQxDao.deleteById(id);
	}
	/**显示列表数据**/
	public FlipInfo getListXiechengZhusuQxData(FlipInfo fi, Map<String, Object> params) throws BusinessException {
		String hql = "from XiechengZhusuQx as xiechengZhusuQx order by numbers asc";
		List<XiechengZhusuQx> dataList = DBAgent.find(hql, params, fi);
		fi.setData(dataList);
		return fi;
	}

	/**
	 * 新增
	 * 住宿配置及权限 
	 */
	@Override
	public void saveByAdd(HttpServletRequest request) throws BusinessException {
		try {
			String jsonStr = request.getParameter("_json_params") == null ? "{}" : request.getParameter("_json_params");
			Map<String, Object> map = JSONUtilsExt.parseMap(jsonStr);
			XiechengZhusuQx zhusu = new XiechengZhusuQx();
			String number = map.get("numbers")== null ? "0" : map.get("numbers") == "" ? "0" : (String)map.get("numbers");
			String level = (String) map.get("levelName");
			String hotelType = (String) map.get("hotelType");
			String amount = map.get("amount")== null ? "0" : map.get("amount") == "" ? "0" : (String)map.get("amount");
			Timestamp time = new Timestamp(System.currentTimeMillis());//得到当前时间
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        String str = sdf.format(time);
	        Long uuid = UUIDLong.longUUID();
			
	        zhusu.setId(uuid);//id
			zhusu.setNumbers(Long.valueOf(number));//序号
			zhusu.setLevelName(level);//级职
			zhusu.setHotelType(hotelType);//酒店类型
			zhusu.setAmount(Double.valueOf(amount));//费用
			zhusu.setCreateTime(str);//创建时间
			xiechengZhusuQxDao.add(zhusu);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	/**
	 * 修改
	 * 住宿配置及权限 
	 */
	@Override
	public void updateByZhusuQx(HttpServletRequest request) throws BusinessException {
		try {
			String jsonStr = request.getParameter("_json_params") == null ? "{}" : request.getParameter("_json_params");
			Map<String, Object> map = JSONUtilsExt.parseMap(jsonStr);
			XiechengZhusuQx zhusu = new XiechengZhusuQx();
			String id = (String) map.get("id");
			String number = map.get("numbers") == null ? "0" : map.get("numbers") == "" ? "0" :(String) map.get("numbers");
			String level = map.get("levelName") == null ? "" : (String) map.get("levelName");
			String hotelType = map.get("hotelType") == null ? "" : (String) map.get("hotelType");
			String amount = map.get("amount") == null ? "0" : map.get("amount") == "" ? "0" :(String) map.get("amount");
			String createTime = map.get("createTime") == null ? "" : (String) map.get("createTime");
			Timestamp time = new Timestamp(System.currentTimeMillis());//得到当前时间
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        String str = sdf.format(time);
	        if(id == null)
	        	throw new BusinessException("id 参数丢失");
	        
	        zhusu.setId(Long.valueOf(id));//Id
			zhusu.setNumbers(Long.valueOf(number));//序号
			zhusu.setLevelName(level);//级职
			zhusu.setHotelType(hotelType);//酒店类型
			zhusu.setAmount(Double.valueOf(amount));//费用
			zhusu.setCreateTime(createTime);
			zhusu.setUpdateTime(str);//修改时间
			xiechengZhusuQxDao.update(zhusu);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public List<XieChengVipJiuDianPo> gethrGui(String carName, String Type,String bigDate,String endDate) {
		List<XieChengVipJiuDianPo> gethrGui = xiechengZhusuQxDao.gethrGui(carName, Type,bigDate,endDate);
		return gethrGui;
	}

	@Override
	public List<XieChengXieYiJiuDiangPo> gethrGuiXieYi(String carName, String Type,String jiuDianName,String bigDate,String endDate) {
		List<XieChengXieYiJiuDiangPo> gethrGuiXieYi = xiechengZhusuQxDao.gethrGuiXieYi(carName, Type,jiuDianName,bigDate,endDate);
		return gethrGuiXieYi;
	}

}
