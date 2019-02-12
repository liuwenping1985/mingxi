package com.seeyon.apps.czexchange.manager;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import com.seeyon.apps.czexchange.po.EdocReceiptLog;

public interface EdocReceiptLogManager {

	
	public List<EdocReceiptLog> getUnSuccessRecord(Date createDate);
	public void sendReceiptLog(EdocReceiptLog edocReceiptLog);
}
