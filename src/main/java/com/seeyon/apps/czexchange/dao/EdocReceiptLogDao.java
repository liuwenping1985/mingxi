package com.seeyon.apps.czexchange.dao;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import com.seeyon.apps.czexchange.po.EdocReceiptLog;

public interface EdocReceiptLogDao {

	public EdocReceiptLog getById(Long id);
	
	public void insert(EdocReceiptLog edocReceiptLog);
	
	public List<EdocReceiptLog> getUnSuccessRecord(Date createTime);
	
	public void update(EdocReceiptLog edocReceiptLog);
	
	public void saveOrUpdate(EdocReceiptLog edocReceiptLog);
	
}
