/**
 * 太原市睿思特科技有限公司  张力 2013/09/22
 */
package com.seeyon.apps.czexchange.manager;

import com.seeyon.apps.czexchange.bo.Elecdocument;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.oainterface.common.OAInterfaceException;
import com.seeyon.v3x.exchange.domain.EdocRecieveRecord;
import com.seeyon.v3x.exchange.domain.EdocSendRecord;



public interface CzDocExchangeManager {

	/**
	 * 发文
	 * @return 公文交换记录ID
	 */
	public String receiveEdoc(Elecdocument elecdocument) throws BusinessException, OAInterfaceException;
	/**
	 * 第三方系统签收！
	 * @param edocid
	 * @throws Exception
	 */
	public void updateEdocState(long edocSendId, String accountId, String accountName,
			int state) throws OAInterfaceException;
	public void autoReceiveEdoc(Long edocid) throws Exception;
	public void autoSign(EdocSendRecord edocSendRecord);


}