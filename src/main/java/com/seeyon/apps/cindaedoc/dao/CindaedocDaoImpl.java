package com.seeyon.apps.cindaedoc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Types;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.cindaedoc.po.EdocDetailMsgid;
import com.seeyon.apps.cindaedoc.po.EdocFileInfo;
import com.seeyon.ctp.common.dao.BaseHibernateDao;
import com.seeyon.ctp.util.DBAgent;

public class CindaedocDaoImpl extends BaseHibernateDao<Object> implements CindaedocDao {
	
	public EdocFileInfo getEdocFileInfoByEdocId(Long edocId) {
		String hsql = "from EdocFileInfo where edocId = :edocId";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("edocId", edocId);
		List<EdocFileInfo> list = (List<EdocFileInfo>)DBAgent.find(hsql, params);
		if (list != null && list.size() > 0) {
			return list.get(0);
		} else {
			return null;
		}
	}
	
	public void saveObject(Object entity) {
		DBAgent.save(entity);
	}
	
	public List<String[]> getDataBySql(String sql, Connection conn, int length, Object[] param) {
		List<String[]> lst = new ArrayList<String[]>();
		
		PreparedStatement sta = null;
		ResultSet rs = null;
		try {
			sta = conn.prepareStatement(sql);
			
			if (param != null && param.length > 0) {
				int k = 1;
				for (Object p : param) {
					sta.setObject(k, p);
					k++;
				}
			}
			
			rs = sta.executeQuery();
			if (rs != null) {
				ResultSetMetaData md = rs.getMetaData();
				int clct = md.getColumnCount();
				while (rs.next()) {
					String[] tt = new String[clct];
					for (int i = 0; i < clct; i++) {
						tt[i] = getColumn(md.getColumnType(i + 1), rs, i+1, length);
					}
					lst.add(tt);
				}
			}
		} catch (Exception e) {
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (sta != null) {
					sta.close();
				}
			} catch (Exception e) {
			}
		}
		
		return lst;
	}
	
	private String getColumn(int tp, ResultSet res, int index, int length) {
		try {
			NumberFormat nf = NumberFormat.getNumberInstance();
			nf.setMaximumFractionDigits(length);
			nf.setMinimumFractionDigits(length);
			
			if(res.getObject(index) == null) {
				return "";
			}
			switch (tp) {
			case Types.BIGINT:
				return String.valueOf(res.getLong(index));
			case Types.BOOLEAN:
				return String.valueOf(res.getBoolean(index));
			case Types.CHAR:
				return res.getString(index).trim();
			case Types.DATE:
				SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
				return date.format(res.getDate(index));
			case Types.DECIMAL:
				return nf.format(res.getBigDecimal(index)).replaceAll(",", "");
			case Types.DOUBLE:
				return nf.format(res.getDouble(index)).replaceAll(",", "");
			case Types.FLOAT:
				return nf.format(res.getFloat(index)).replaceAll(",", "");
			case Types.INTEGER:
				return String.valueOf(res.getInt(index));
			case Types.NULL:
				return "";
			case Types.TIME:
			case Types.TIMESTAMP:
				SimpleDateFormat time = new SimpleDateFormat("yyyy-MM-dd");
				return time.format(res.getTimestamp(index));
			case Types.VARCHAR:
				return res.getString(index).trim();
			default:
				return res.getString(index).trim();
			}
		} catch (Exception e) {
			return "";
		}
	}
	
	public void updateBySql(String sql, Connection connOA, Object[] param) {
		PreparedStatement sta = null;
		try {
			sta = connOA.prepareStatement(sql);
			
			if (param != null && param.length > 0) {
				int i = 1;
				for (Object p : param) {
					sta.setObject(i, p);
					i++;
				}
			}
			
			sta.executeUpdate();
		} catch (Exception e) {
		} finally {
			try {
				if (sta != null) {
					sta.close();
				}
			} catch (Exception e) {
			}
		}
	}
	
	public EdocDetailMsgid getMsgIdByDetailId(Long detailId) {
		String hsql = "from EdocDetailMsgid where detailId = :detailId";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("detailId", detailId);
		List<EdocDetailMsgid> list = (List<EdocDetailMsgid>)DBAgent.find(hsql, params);
		if (list != null && list.size() > 0) {
			return list.get(0);
		} else {
			return null;
		}
	}
	
	public EdocDetailMsgid getDetailIdByMsgId(String msgId) {
		String hsql = "from EdocDetailMsgid where msgId = :msgId";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("msgId", msgId);
		List<EdocDetailMsgid> list = (List<EdocDetailMsgid>)DBAgent.find(hsql, params);
		if (list != null && list.size() > 0) {
			return list.get(0);
		} else {
			return null;
		}
	}
}