package com.seeyon.apps.cindafundform.init;

import java.rmi.RemoteException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import javax.xml.rpc.ServiceException;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.alibaba.fastjson.JSONObject;
import com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportService;
import com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportServiceImplServiceLocator;
import com.iss.itreasury.wsService.approvalinfoimport.ApprovalImportServiceImplServiceSoapBindingStub;
import com.iss.itreasury.wsService.approvalinfoimport.Exception;
import com.seeyon.apps.cindafundform.po.CindaFundFormErrorInfo;
import com.seeyon.apps.cindafundform.utils.DBConnectionPool;
import com.seeyon.apps.cindafundform.utils.XmlExercise;
import com.seeyon.ctp.common.AbstractSystemInitializer;
import com.seeyon.ctp.common.AppContext;

/**
 * 信达资金系统失败重新发送定时任务
 *
 * @author 范晓雷
 * @date 2017年07月18日
 *
 */
public class CindaFundFormInitializer extends AbstractSystemInitializer {
  private static final Log log = LogFactory.getLog(CindaFundFormInitializer.class);
  private DBConnectionPool dbconnectionPool = new DBConnectionPool();

  public void destroy() {
    log.info("中国信达资金系统对接模块 - destroy");
  }

  public void initialize() {
    log.info("初始化中国信达资金系统对接模块");
    String delay = AppContext.getSystemProperty("cindafundform.delay");
    String period = AppContext.getSystemProperty("cindafundform.period");
    Timer timer = new Timer();
    timer.schedule(new TimerTask() {
      @Override
      public void run() {
        log.info("中国信达资金系统对接失败信息再次发送。-start");
        sentData2FundSystem();
        log.info("中国信达资金系统对接失败信息再次发送。-end");
      }
    }, Long.valueOf(delay) * 1000, Long.valueOf(period) * 1000);
  }

  /**
   * 发送到资金系统，如果返回成功，删除数据库中的对应记录
   */
  private void sentData2FundSystem() {
    log.info("sentData2FundSystem method-in");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
      conn = dbconnectionPool.getConnection();
      pstmt = conn.prepareStatement("select * from CINDA_FUND_FORM_ERRORINFO");
      rs = pstmt.executeQuery();
      ResultSetMetaData rData = rs.getMetaData();
      List<CindaFundFormErrorInfo> list = new ArrayList<CindaFundFormErrorInfo>();
      while (rs.next()) {
    	  CindaFundFormErrorInfo obj = new CindaFundFormErrorInfo();
          for (int i = 1; i <= rData.getColumnCount(); i++) {
        	  if ("id".equals(rData.getColumnName(i).toLowerCase()))
        	  {
        		  obj.setId(Long.valueOf(String.valueOf((rs.getObject(i)))));
        	  }
        	  if ("idnum".equals(rData.getColumnName(i).toLowerCase()))
        	  {
        		  obj.setIdnum((String)rs.getObject(i));
        	  }
        	  if ("xmldata".equals(rData.getColumnName(i).toLowerCase()))
        	  {
        		  obj.setXmlData((String)rs.getObject(i));
        	  }
          }
          list.add(obj);
      }
      log.info("需要发送的数据条数：" + list.size());
      if (CollectionUtils.isNotEmpty(list)) {
        for (CindaFundFormErrorInfo errorInfo : list) {
        	
			ApprovalImportServiceImplServiceLocator service = new ApprovalImportServiceImplServiceLocator();
			ApprovalImportServiceImplServiceSoapBindingStub stub = (ApprovalImportServiceImplServiceSoapBindingStub) service.getApprovalImportServiceImplPort();
			log.info("调用资金系统webService接口- start");
			String result = stub.importApprovalService(errorInfo.getXmlData());
			log.info("调用资金系统webService接口- end: " + result);
			
			result = XmlExercise.xml2json(result);
 	        JSONObject resultStr = JSONObject.parseObject(result);
 	        if ("1".equals(resultStr.get("RACSTATE")))
 	        {
 	            pstmt = conn.prepareStatement("delete CINDA_FUND_FORM_ERRORINFO where ID = " + errorInfo.getId());
 	            rs = pstmt.executeQuery();
 	        } else {
 	        	log.warn("调用资金系统webService接口 未返回预期值！");
 	        }
        }
      }
    } catch (Exception e) {
      log.error("中国信达资金系统对接-定时发送异常");
      log.error(e);
      e.printStackTrace();
    } catch (RemoteException e) {
        e.printStackTrace();
    } catch (ServiceException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
      dbconnectionPool.closeConnection(rs, pstmt, conn);
    }
    log.info("sentData2FundSystem method-out");
  }
}
