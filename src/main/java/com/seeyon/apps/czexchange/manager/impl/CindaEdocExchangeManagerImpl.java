package com.seeyon.apps.czexchange.manager.impl;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.czexchange.manager.CzDocExchangeManager;
import com.seeyon.apps.sursenexchange.api.SendToSursenParam;
import com.seeyon.apps.sursenexchange.api.SursenExchangeApi;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.edoc.domain.EdocSummary;
import com.seeyon.v3x.edoc.manager.EdocSummaryManager;
import com.seeyon.v3x.exchange.domain.EdocSendDetail;
import com.seeyon.v3x.exchange.domain.EdocSendRecord;
import com.seeyon.v3x.exchange.enums.EdocExchangeMode;
import com.seeyon.v3x.exchange.enums.EdocExchangeMode.EdocExchangeModeEnum;
import com.seeyon.v3x.exchange.manager.EdocExchangeManagerImpl;
import com.seeyon.v3x.exchange.manager.ExchangeAccountManager;
import com.seeyon.v3x.exchange.util.ExchangeUtil;

public class CindaEdocExchangeManagerImpl extends EdocExchangeManagerImpl {
	
	private static final Log log = LogFactory.getLog(CindaEdocExchangeManagerImpl.class);
	private static String changeAccountRoot = SystemProperties.getInstance().getProperty("czexchange.defaultsAccount");
	private static ExchangeAccountManager exchangeAccountManager = (ExchangeAccountManager) AppContext.getBean("exchangeAccountManager");
	private static SursenExchangeApi czsursenExchangeApi ;
	private static AppLogManager appLogManager = (AppLogManager) AppContext.getBean("appLogManager");


	public void setCzsursenExchangeApi(SursenExchangeApi czsursenExchangeApi) {
		this.czsursenExchangeApi = czsursenExchangeApi;
	}
	  protected void rendJavaScript(HttpServletResponse response, String jsContent)
			    throws IOException
			  {
			    response.setContentType("text/html;charset=UTF-8");
			    PrintWriter out = response.getWriter();
			    out.println("<script type=\"text/javascript\">");
			    out.println(jsContent);
			    out.println("</script>");
			    out.close();
			  }
	  protected void infoCloseOrFresh(HttpServletRequest request, HttpServletResponse response, String infoMsg)
			    throws Exception
			  {
			    PrintWriter out = response.getWriter();
			    out.println("<script>");
			    out.println("alert(\"" + StringEscapeUtils.escapeJavaScript(infoMsg) + "\")");
			    out.println("if(window.dialogArguments){");
			    out.println("  window.returnValue = \"true\";");
			    out.println("  window.close();");
			    out.println("}else{");
			    out.println("  parent.getA8Top().reFlesh();");
			    out.println("}");
			    out.println("");
			    out.println("</script>");
			  }	  
	private String needSendEdoc(EdocSendRecord edocSendRecord) throws BusinessException{
		StringBuffer toId = new StringBuffer();
		String sends = edocSendRecord.getSendedNames();
		String[] sendsList = sends.split("、");
		String[] changeUnitList = changeAccountRoot.split("@");
		for (String sendUnit : sendsList) {
			
			for(String changeUnit : changeUnitList){
				String[] changeNameAndId=changeUnit.split(",");
				if(changeNameAndId.length>1 && changeNameAndId[0].equalsIgnoreCase(sendUnit)){
					if(toId.length() > 0){
						toId.append(",");
					}
					toId.append(changeNameAndId[1]);
				}
			}
		}
		
		return toId.toString();
	}
	@Override
	/**
	 * 交换-发送公文（签发）
	 */
	public Map<String,String> sendEdoc(EdocSendRecord edocSendRecord, long sendUserId,String sender,Long agentToId, boolean reSend,String[] exchangeModeValues) throws Exception {
		//EdocSendRecord edocSendRecord = sendEdocManager.getEdocSendRecord(id);
		String sendKey = "exchange.sent";  
		if (!ExchangeUtil.isEdocExchangeToSendRecord(edocSendRecord.getStatus()) && (reSend == false)) {
			return null;
		}

		User user = AppContext.getCurrentUser();
//		
//		Set<EdocSendDetail> sendDetails = (Set<EdocSendDetail>) edocSendRecord
//				.getSendDetails();
		
		Map<String,String> map = new HashMap<String,String>();
		EdocSummary summary = super.getEdocSummaryManager().findById(edocSendRecord.getEdocId());
		try {
			String toIds = needSendEdoc(edocSendRecord);
			if(toIds == null || toIds.equals("")){
				Map<String,String> result = super.sendEdoc(edocSendRecord, sendUserId, sender, agentToId, reSend, exchangeModeValues);
				try {
					CzDocExchangeManager czDocExchangeManager = (CzDocExchangeManager) AppContext.getBean("czDocExchangeManager");
					czDocExchangeManager.autoSign(edocSendRecord);
				} catch (Exception e) {
					log.error("自动签收出错！",e);
				}
				return result;
			}
		} catch (BusinessException e) {
//			rendJavaScript(AppContext.getRawResponse(), "alert('"+e.getMessage()+"');window.getA8Top().close();");
			infoCloseOrFresh(AppContext.getRawRequest(), AppContext.getRawResponse(), e.getMessage());
			log.error("",e);
			return null;
		}
//		boolean hasPlugin = AppContext.hasPlugin("sursenExchange");
//		String  internalExchange = "";
//		String  sursenExchange = "";
//		if(exchangeModeValues != null){
//			for(String exchangeModeValue :exchangeModeValues){
//				if(String.valueOf(EdocExchangeModeEnum.internal.getKey()).equals(exchangeModeValue)){
//					internalExchange = String.valueOf(EdocExchangeModeEnum.internal.getKey());
//				}else if(String.valueOf(EdocExchangeModeEnum.sursen.getKey()).equals(exchangeModeValue)){
//					sursenExchange = String.valueOf(EdocExchangeModeEnum.sursen.getKey());
//				}
//			}
//		}
		// 1 不安装该插件走原来的逻辑  2在安装该插件情况给待签收发送数据，（1）内部（致远）交换和书生交换一起被选中  （2）只有内部（致远）交换选中 。
//		if((!hasPlugin || (hasPlugin && String.valueOf(EdocExchangeModeEnum.internal.getKey()).equals(internalExchange))) && sendDetails != null && sendDetails.size() > 0){
//			
//			Iterator it = sendDetails.iterator();
//			int type = edocSendRecord.getExchangeType();
//			//待发送时，选择的发送单位要记录到接收记录里面，用于显示
//			String[] aRecUnit = new String[3];
//			aRecUnit[0] = edocSendRecord.getSendEntityNames();
//				while (it.hasNext()) {
//					EdocSendDetail sendDetail = (EdocSendDetail) it.next();
//					String exchangeOrgId = sendDetail.getRecOrgId();
//					int exchangeOrgType = sendDetail.getRecOrgType();
//					long replyId = sendDetail.getId();	
//					
//						String recieveId = super.getRecieveEdocManager().create(edocSendRecord, Long
//								.valueOf(exchangeOrgId), exchangeOrgType, replyId,
//								aRecUnit,sender,agentToId,summary);
//						map.put(sendDetail.getRecOrgId(), recieveId);
//				}
//				
//		}
		// 插件是提前  选择书生交换或者 书生交换和内部交换
		String accountName = "";
//		if(hasPlugin && String.valueOf(EdocExchangeModeEnum.sursen.getKey()).equals(sursenExchange)){
			StringBuffer sb  = new StringBuffer();
			String data[]=null;
			String accountNames = "";
			String sendedTypeIds = edocSendRecord.getSendedTypeIds();
			String[] items = sendedTypeIds.split(V3xOrgEntity.ORG_ID_DELIMITER);
			
			for(int x =0;x<items.length;x++){
				String item = items[x];
				data = item.split("[|]");
				if(data.length>0){
					if("Account".equals(data[0])){
						 accountNames=getOrgManager().getAccountById(Long.valueOf(data[1])).getName();
						 sb.append(accountNames + ";");
					}else if("Department".equals(data[0])){
						 accountNames=getOrgManager().getDepartmentById(Long.valueOf(data[1])).getName();
						 sb.append(accountNames + ";");
					}else if("ExchangeAccount".equals(data[0])){
						// 外部人员接口
						accountNames = exchangeAccountManager.getExchangeAccount(Long.valueOf(data[1])).getName();
						sb.append(accountNames + ";");
					}
				}
				
			}
			accountName=sb.toString();
			if(Strings.isNotBlank(accountName)){
				accountName = accountName.substring(0, accountName.length()-1);
			}
//		}	
		
	
		// 当内部（致远）交换和书生交换一起被选中，并且有该插件，如果只是选中书生交换，下面直接更新状态
//		if(hasPlugin && ( String.valueOf(EdocExchangeModeEnum.internal.getKey()).equals(internalExchange) && String.valueOf(EdocExchangeModeEnum.sursen.getKey()).equals(sursenExchange))){
//				
//				EdocSendRecord  record = new EdocSendRecord(); 
//				record.setIdIfNew();
//				record.setSubject(edocSendRecord.getSubject());
//				record.setDocType(edocSendRecord.getDocType());
//				record.setDocMark(edocSendRecord.getDocMark());
//				record.setSecretLevel(edocSendRecord.getSecretLevel());
//				record.setUrgentLevel(edocSendRecord.getUrgentLevel());
//				record.setSendUnit(edocSendRecord.getSendUnit());
//				record.setIssuer(edocSendRecord.getIssuer());
//				record.setIssueDate(edocSendRecord.getIssueDate());
//				record.setCopies(edocSendRecord.getCopies());
//				record.setEdocId(edocSendRecord.getEdocId());
//				record.setExchangeOrgId(edocSendRecord.getExchangeOrgId());
//				record.setExchangeAccountId(edocSendRecord.getExchangeAccountId());
//				record.setExchangeType(edocSendRecord.getExchangeType());
//				record.setSendUserId(agentToId == null ? sendUserId : agentToId );
//				long l = System.currentTimeMillis();
//				record.setSendTime(new Timestamp(l));
//				record.setCreateTime(new Timestamp(l));
//				record.setContentNo(edocSendRecord.getContentNo());
//				record.setSendedTypeIds(edocSendRecord.getSendedTypeIds());
//				record.setStepBackInfo(edocSendRecord.getStepBackInfo());
//				record.setAssignType(edocSendRecord.getAssignType());
//				record.setIsBase(edocSendRecord.getIsBase());
//				record.setIsTurnRec(edocSendRecord.getIsTurnRec());
//				record.setSendNames(edocSendRecord.getSendNames());
//				boolean sendToSursen = sursenSendManager.sendToSursen(summary,record,accountName);
//				String sendFailed = "failed";
//				// 如果发生成功，更改该状态并保存
//				if(sendToSursen){
//					record.setStatus(EdocSendRecord.Exchange_iStatus_Sent);
//					//同时内部交换和书生交换都设置成非原发，发文登记簿过滤重复，这里取巧了，修改请注意相关
//					record.setIsBase(EdocSendRecord.Exchange_Base_NO);
//					record.setExchangeMode(EdocExchangeModeEnum.sursen.getKey());
//					edocSendDetailDao.save(record);
//					appLogManager.insertLog(user, 342,user.getName(),record.getSubject());
//				}else{
//					record.setExchangeMode(EdocExchangeModeEnum.internal.getKey());
//					record.setStatus(EdocSendRecord.Exchange_iStatus_Tosend);
//					edocSendDetailDao.save(record);
//					appLogManager.insertLog(user, 343,user.getName(),record.getSubject());
//					map.put("sendFailed", sendFailed);
//				}
//				
//			}
			// 更新内部交换数据和书生交换数据，当选书生交换时，直接更新该状态，不单独创建新对象
			edocSendRecord.setSendUserId(agentToId == null ? sendUserId : agentToId );
			long l = System.currentTimeMillis();
			edocSendRecord.setSendTime(new Timestamp(l));
			edocSendRecord.setStatus(EdocSendRecord.Exchange_iStatus_Sent);
			// 如果只是选中书生交换，设置exchangeMode，更改状态
//			if(hasPlugin  && String.valueOf(EdocExchangeModeEnum.sursen.getKey()).equals(sursenExchange) &&  !String.valueOf(EdocExchangeModeEnum.internal.getKey()).equals(internalExchange)){
			      SendToSursenParam param = generateSursenParam(summary, edocSendRecord, accountName);
			      boolean sendToSursen = czsursenExchangeApi.sendToSursen(param);
				String sendFailed = "failed";
				
				if(sendToSursen){
					edocSendRecord.setExchangeMode(EdocExchangeModeEnum.sursen.getKey());
					appLogManager.insertLog(user, 342,user.getName(),edocSendRecord.getSubject());
				}else{
					edocSendRecord.setExchangeMode(EdocExchangeModeEnum.internal.getKey());
					edocSendRecord.setStatus(EdocSendRecord.Exchange_iStatus_Tosend);
					appLogManager.insertLog(user, 343,user.getName(),edocSendRecord.getSubject());
					map.put("sendFailed", sendFailed);
				}
//			}
			
			if(reSend){
				getSendEdocManager().reSend(edocSendRecord, summary);
				sendKey = "exchange.resend";
			}else{
				getSendEdocManager().update(edocSendRecord);
			}
	
			
		
		return map;
	}
	  public Map<String, String> sendEdoc2(EdocSendRecord edocSendRecord, long sendUserId, String sender, Long agentToId, boolean reSend, String[] exchangeModeValues)
			    throws Exception
			  {
			    if ((!ExchangeUtil.isEdocExchangeToSendRecord(edocSendRecord.getStatus())) && (!reSend)) {
			      return null;
			    }
			    User user = AppContext.getCurrentUser();
			    

			    Set<EdocSendDetail> sendDetails = edocSendRecord.getSendDetails();
			    
			    Map<String, String> map = new HashMap();
			    EdocSummary summary = getEdocSummaryManager().findById(edocSendRecord.getEdocId());
			    
//			    boolean hasPlugin = AppContext.hasPlugin("sursenExchange");
			    String internalExchange = "";
			    String sursenExchange = "";
			    if (exchangeModeValues != null) {
			      for (String exchangeModeValue : exchangeModeValues) {
			        if (String.valueOf(EdocExchangeMode.EdocExchangeModeEnum.internal.getKey()).equals(exchangeModeValue)) {
			          internalExchange = String.valueOf(EdocExchangeMode.EdocExchangeModeEnum.internal.getKey());
			        } else if (String.valueOf(EdocExchangeMode.EdocExchangeModeEnum.sursen.getKey()).equals(exchangeModeValue)) {
			          sursenExchange = String.valueOf(EdocExchangeMode.EdocExchangeModeEnum.sursen.getKey());
			        }
			      }
			    }
//			    if (((!hasPlugin) || ((hasPlugin) && (String.valueOf(EdocExchangeMode.EdocExchangeModeEnum.internal.getKey()).equals(internalExchange)))) && (sendDetails != null) && (sendDetails.size() > 0))
//			    {
//			      Object it = sendDetails.iterator();
//			      
//			      String[] aRecUnit = new String[3];
//			      aRecUnit[0] = edocSendRecord.getSendEntityNames();
//			      while (((Iterator)it).hasNext())
//			      {
//			        EdocSendDetail sendDetail = (EdocSendDetail)((Iterator)it).next();
//			        String exchangeOrgId = sendDetail.getRecOrgId();
//			        int exchangeOrgType = sendDetail.getRecOrgType();
//			        long replyId = sendDetail.getId().longValue();
//			        
//			        String recieveId = getRecieveEdocManager().create(edocSendRecord, 
//			          Long.valueOf(exchangeOrgId).longValue(), exchangeOrgType, Long.valueOf(replyId), aRecUnit, sender, agentToId, summary);
//			        
//			        map.put(sendDetail.getRecOrgId(), recieveId);
//			      }
//			    }
			    String accountName = "";
//			    if ((hasPlugin) && (String.valueOf(EdocExchangeMode.EdocExchangeModeEnum.sursen.getKey()).equals(sursenExchange)))
//			    {
			      StringBuffer sb = new StringBuffer();
			      String[] data = null;
			      String accountNames = "";
			      String sendedTypeIds = edocSendRecord.getSendedTypeIds();
			      String[] items = sendedTypeIds.split(",");
			      for (int x = 0; x < items.length; x++)
			      {
			        String item = items[x];
			        data = item.split("[|]");
			        if (data.length > 0) {
			          if ("Account".equals(data[0]))
			          {
			            accountNames = getOrgManager().getAccountById(Long.valueOf(data[1])).getName();
			            sb.append(accountNames + ";");
			          }
			          else if ("Department".equals(data[0]))
			          {
			            accountNames = getOrgManager().getDepartmentById(Long.valueOf(data[1])).getName();
			            sb.append(accountNames + ";");
			          }
			          else if ("ExchangeAccount".equals(data[0]))
			          {
			            accountNames = exchangeAccountManager.getExchangeAccount(Long.valueOf(data[1]).longValue()).getName();
			            sb.append(accountNames + ";");
			          }
			        }
			      }
			      accountName = sb.toString();
			      if (Strings.isNotBlank(accountName)) {
			        accountName = accountName.substring(0, accountName.length() - 1);
			      }
//			    }
//			    if ((hasPlugin) && (String.valueOf(EdocExchangeMode.EdocExchangeModeEnum.internal.getKey()).equals(internalExchange)) && (String.valueOf(EdocExchangeMode.EdocExchangeModeEnum.sursen.getKey()).equals(sursenExchange)))
//			    {
//			      EdocSendRecord record = new EdocSendRecord();
//			      record.setIdIfNew();
//			      record.setSubject(edocSendRecord.getSubject());
//			      record.setDocType(edocSendRecord.getDocType());
//			      record.setDocMark(edocSendRecord.getDocMark());
//			      record.setSecretLevel(edocSendRecord.getSecretLevel());
//			      record.setUrgentLevel(edocSendRecord.getUrgentLevel());
//			      record.setSendUnit(edocSendRecord.getSendUnit());
//			      record.setIssuer(edocSendRecord.getIssuer());
//			      record.setIssueDate(edocSendRecord.getIssueDate());
//			      record.setCopies(edocSendRecord.getCopies());
//			      record.setEdocId(edocSendRecord.getEdocId());
//			      record.setExchangeOrgId(edocSendRecord.getExchangeOrgId());
//			      record.setExchangeAccountId(edocSendRecord.getExchangeAccountId());
//			      record.setExchangeType(edocSendRecord.getExchangeType());
//			      record.setSendUserId(agentToId == null ? sendUserId : agentToId.longValue());
//			      long l = System.currentTimeMillis();
//			      record.setSendTime(new Timestamp(l));
//			      record.setCreateTime(new Timestamp(l));
//			      record.setContentNo(edocSendRecord.getContentNo());
//			      record.setSendedTypeIds(edocSendRecord.getSendedTypeIds());
//			      record.setStepBackInfo(edocSendRecord.getStepBackInfo());
//			      record.setAssignType(edocSendRecord.getAssignType());
//			      record.setIsBase(edocSendRecord.getIsBase());
//			      record.setIsTurnRec(edocSendRecord.getIsTurnRec());
//			      record.setSendNames(edocSendRecord.getSendNames());
//			      
//
//
//			      SendToSursenParam param = generateSursenParam(summary, edocSendRecord, accountName);
//			      boolean sendToSursen = czsursenExchangeApi.sendToSursen(param);
//			      
//			      String sendFailed = "failed";
//			      if (sendToSursen)
//			      {
//			        record.setStatus(1);
//			        
//			        record.setIsBase(Integer.valueOf(0));
//			        record.setExchangeMode(Integer.valueOf(EdocExchangeMode.EdocExchangeModeEnum.sursen.getKey()));
//			        getEdocSendDetailDao().save(record);
//			        appLogManager.insertLog(user, Integer.valueOf(342), new String[] { user.getName(), record.getSubject() });
//			      }
//			      else
//			      {
//			        record.setExchangeMode(Integer.valueOf(EdocExchangeMode.EdocExchangeModeEnum.internal.getKey()));
//			        record.setStatus(0);
//			        getEdocSendDetailDao().save(record);
//			        appLogManager.insertLog(user, Integer.valueOf(343), new String[] { user.getName(), record.getSubject() });
//			        map.put("sendFailed", sendFailed);
//			      }
//			    }
			    edocSendRecord.setSendUserId(agentToId == null ? sendUserId : agentToId.longValue());
			    long l = System.currentTimeMillis();
			    edocSendRecord.setSendTime(new Timestamp(l));
			    edocSendRecord.setStatus(1);
//			    if ((hasPlugin) && (String.valueOf(EdocExchangeMode.EdocExchangeModeEnum.sursen.getKey()).equals(sursenExchange)) && (!String.valueOf(EdocExchangeMode.EdocExchangeModeEnum.internal.getKey()).equals(internalExchange)))
//			    {
			      SendToSursenParam param = generateSursenParam(summary, edocSendRecord, accountName);
			      boolean sendToSursen = czsursenExchangeApi.sendToSursen(param);
			      
			      String sendFailed = "failed";
			      if (sendToSursen)
			      {
			        edocSendRecord.setExchangeMode(Integer.valueOf(EdocExchangeMode.EdocExchangeModeEnum.sursen.getKey()));
			        appLogManager.insertLog(user, Integer.valueOf(342), new String[] { user.getName(), edocSendRecord.getSubject() });
			      }
			      else
			      {
			        edocSendRecord.setExchangeMode(Integer.valueOf(EdocExchangeMode.EdocExchangeModeEnum.internal.getKey()));
			        edocSendRecord.setStatus(0);
			        appLogManager.insertLog(user, Integer.valueOf(343), new String[] { user.getName(), edocSendRecord.getSubject() });
			        map.put("sendFailed", sendFailed);
			      }
//			    }
			    if (reSend) {
			    	getSendEdocManager().reSend(edocSendRecord, summary);
			    } else {
			    	getSendEdocManager().update(edocSendRecord);
			    }
			    return map;
			  }
	  private SendToSursenParam generateSursenParam(EdocSummary edocSummary, EdocSendRecord edocSendRecord, String accountName){
		  Class supercClass = this.getClass().getSuperclass();
		  SendToSursenParam param = (SendToSursenParam) this.invokeMethod(supercClass, "generateSursenParam", this, new Class[]{EdocSummary.class,EdocSendRecord.class,String.class}, new Object[]{edocSummary,edocSendRecord,accountName});
		return param;
		  
	  }
	  public Object invokeMethod(Class<?> c, String methodName, Object obj, Class<?>[] argsTypes, Object[] argsValue)
	  {
	    Object returnObj = null;
	    try
	    {
	      Method mainMethod = c.getDeclaredMethod(methodName, argsTypes);
	      
	      mainMethod.setAccessible(true);
	      returnObj = mainMethod.invoke(obj, argsValue);
	    }
	    catch (Exception e)
	    {
	      log.error("",e);
	    }
	    return returnObj;
	  }
}
