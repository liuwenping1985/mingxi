
package com.seeyon.ctp.common.usermessage;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.TimeZone;

import org.apache.commons.logging.Log;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.config.manager.ConfigManager;
import com.seeyon.ctp.common.constants.CustomizeConstants;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.i18n.LocaleContext;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.usermessage.UserHistoryMessage;
import com.seeyon.ctp.common.timezone.TimeZoneDate;
import com.seeyon.ctp.common.usermessage.pipeline.Message;
import com.seeyon.ctp.common.usermessage.pipeline.MessagePipeline;
import com.seeyon.ctp.common.usermessage.pipeline.MessagePipelineManager;
import com.seeyon.ctp.login.online.OnlineManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.TimeZoneUtil;
/**
 * 系统消息处理组件，该类将被异步任务调度器调度，执行run方法，生成最终系统消息，写入数据库
 * <pre>
 * 短信发送的条件：
 * 
 * 1、具有短信插件
 * 2、应用消息通道管理支持当前应用类型
 * 3、接收者手机号不为空
 * 4、接收者有权限
 * 5、如果当前应用的通道首选为wappush时，则要求wappush是畅通的
 * 6、在线校验
 * </pre>
 * @author <a href="mailto:tanmf@seeyon.com">Tanmf</a>
 * @version 1.0 2007-3-8
 */
//TODO:确认新的任务方式后重构
//public class UserMessageTask implements ExecutableTask {
  public class UserMessageTask {
	private static Log log = CtpLogFactory.getLog(UserMessageTask.class);

	private static OrgManager orgManager;
	private static MessageCategoryToMenu messageCategoryToMenu;
	private static UserMessageFilterConfigManager userMessageFilterConfigManager;
	private static MessagePipelineManager messagePipelineManager;
	private static CustomizeManager customizeManager;
	private static OnlineManager onlineManager;
	private ConfigManager configManager;
	
	public static final int MessageCommitNumber = 1000;
	
	public UserMessageTask(){
		init();
	}
	
	private synchronized void init() {
		if(orgManager == null){
			messagePipelineManager = (MessagePipelineManager) AppContext.getBean("messagePipelineManager");
			orgManager = (OrgManager) AppContext.getBean("orgManager");
			messageCategoryToMenu = (MessageCategoryToMenu) AppContext.getBean("messageCategoryToMenu");
	        userMessageFilterConfigManager = (UserMessageFilterConfigManager)AppContext.getBean("userMessageFilterConfigManager");
	        customizeManager = (CustomizeManager) AppContext.getBean("customizeManager");
			onlineManager = (OnlineManager) AppContext.getBean("onlineManager");
			configManager = (ConfigManager) AppContext.getBean("configManager");
		}
	}
	
	public boolean run(Object msg) {
		if( msg == null){
			log.warn("从队列中得到的消息对象为空");
			return true;
		}
		
		List<MessagePipeline> pipelines = messagePipelineManager.getAllMessagePipeline();
		if(pipelines.isEmpty()){
			log.warn("没有任何消息展现通道");
			return true;
		}
		
		UserMessage userMessage = (UserMessage) msg;

		// 消息国际化
		MessageContent messageContent = userMessage.getContent();
		if(messageContent.getKeys().isEmpty()){
			log.warn("消息没有内容");
			return true;
		}
		
		String resouce = messageContent.getResource();
		List<Object[]> keys = messageContent.getKeys();
		
		if(resouce == null){
			resouce = Constants.DEFAULT_MESSAGE_RESOURCE;
		}
		
		int messageType = userMessage.getType();
		Object[] messageFilterArgs = userMessage.getMessageFilterArgs();
		int category = userMessage.getMessageCategory(); //所属应用
		Date createDate = userMessage.getCreationDate(); //消息产生时间
		int sendType = userMessage.getSendType();//消息发送方式
		Integer importantLevel = messageContent.getImportantLevel();
		
		try {
			//key : {内容, 主题Id} value : 消息接收者
			Collection<MessageReceiver> recivers = userMessage.getReceivers();
			if(recivers == null || recivers.isEmpty()){
			    log.warn("消息接收者不存在[" + recivers + "]将不发送");
				return true;
			}
			
			Long senderId = userMessage.getSenderId();
			V3xOrgMember senderMember = null; //消息接收者
			if(senderId != null && senderId != -1){
				try{
					senderMember = orgManager.getMemberById(senderId);
				}
				catch(Exception e1){
					log.warn("消息发送者不存在[" + senderId + "]将不发送", e1);
				}
			}
			
			UserMessageFilter userMessageFilter = userMessageFilterConfigManager.getUserMessageFilter(category);
			
			List<UserHistoryMessage> userHistoryMessages = new ArrayList<UserHistoryMessage>(MessageCommitNumber);
			
			for (MessageReceiver reciver : recivers) {
				
				long receiverId = reciver.getReceiverId(); //接收者的Id
				
				V3xOrgMember member = null; //消息接收者
				try{
					member = orgManager.getMemberById(receiverId);
				}
				catch(Exception e1){
					log.warn("消息接收者不存在[" + receiverId + "]将不发送", e1);
					continue;
				}
				
				if (member == null || !member.isValid()) {
					continue;
				}
/*				已废弃
				if(!messageCategoryToMenu.isCanSendMsg(receiverId, member.getOrgAccountId(), category)){
					continue;
				}*/
				
		        String pLang = customizeManager.getCustomizeValue(receiverId, CustomizeConstants.LOCALE);
		        TimeZone timeZone = TimeZoneUtil.getCustomerTimeZone(receiverId);
		        pLang = Strings.escapeNULL(pLang, "zh_CN");
		        
		        Locale locale = LocaleContext.parseLocale(pLang);
				
				String content = ""; //消息内容
				StringBuilder contentTmp=new StringBuilder();
				if (messageType == Constants.UserMessage_TYPE.SYSTEM.ordinal()) {// 系统消息。做国际化
					ResourceBundle rb = ResourceBundleUtil.getResourceBundle(resouce, locale);
					for (Object[] keyParam : keys) {
						String key = (String)keyParam[0];
						Object[] parameters0 = (Object[])keyParam[1];
						Object[] parameters = new Object[parameters0.length];
						for(int i=0;i<parameters0.length;i++){
							if(parameters0[i] instanceof TimeZoneDate){
								TimeZoneDate tzd = (TimeZoneDate)parameters0[i];
								Date date = tzd.getDate();
								parameters[i] = Datetimes.parseNoTimeZone(Datetimes.format(date, Datetimes.datetimeStyle,timeZone),Datetimes.datetimeStyle);
							}else{
								parameters[i] = parameters0[i];
							}
						}
						String v = null;
						if(rb == null){
							v = ResourceUtil.getStringByLocaleAndParams(key,locale,parameters);
						}else{
							v = ResourceBundleUtil.getString(rb, key, parameters);
						} 
						
						// 先从旧的资源中取，取不到再取新框架的国际化资源
						if(v==null || v.equals(key)){
//						    v = ResourceUtil.getString(key);
						    v = ResourceUtil.getStringByLocaleAndParams(key,locale,parameters);
						}
						/*
						if (v.startsWith("-2329940225728493295")){
							v = v.replaceAll("-2329940225728493295", "中国信达资产管理股份有限公司");
						}else if (v.startsWith("-1010101010101010101")){
							v = v.replaceAll("-1010101010101010101", "");
						}
						*/
						if (v.startsWith("-1010101010101010101")){
							v = v.replaceAll("-1010101010101010101", "");
						}else{
							// 遍历替换公司名称
							Map<String,String> accounts = orgManager.getAccountIdAndNames();
							for(Map.Entry<String, String> account : accounts.entrySet()){
								if (v.startsWith(account.getKey())){
									v = v.replaceAll(account.getKey(), account.getValue());
									break;
								}
							}
						}
//                        content += v;
                        contentTmp.append(v);
					}
					content=contentTmp.toString();
				}else {
					content = messageContent.getKeys().get(0)[0].toString();
				}
				
				String linkType = reciver.getLinkType();
				String[] linkParams = null;
				boolean isRead = false;
				int openType = reciver.getOpenType();
				
				if(Strings.isNotBlank(linkType)){
					linkParams = reciver.getLinkParam();
				}
				else{
					//isRead = true;
				}
				
				UserHistoryMessage h = new UserHistoryMessage();
				h.setIdIfNew();
				
				if(sendType == 0){ //来自WebIM，不要提示；反之要
	                Message messageInstance = new Message();
	                
	                messageInstance.setUserHistoryMessageId(h.getId()); //这个很关键
					messageInstance.setSenderMember(senderMember);
					messageInstance.setCategory(category);
					messageInstance.setType(messageType);
					messageInstance.setCreateDate(createDate);
					messageInstance.setReceiverMember(member);
					messageInstance.setReferenceId(reciver.getReferenceId());
					messageInstance.setOpenType(reciver.getOpenType());
					messageInstance.setContent(content);
					messageInstance.setBody(messageContent.getBodyContent(), messageContent.getBodyType(), messageContent.getBodyCreateDate());
					messageInstance.setReceiverOnline(onlineManager.isOnline(member.getLoginName()));
					messageInstance.setImportmentLevel(importantLevel);
					messageInstance.setLinkType(linkType);
					messageInstance.setLinkParams(linkParams);
					messageInstance.setIsRead(isRead);
					messageInstance.setForceSMS(reciver.isForceSMS());
					//OA-125118 加这个字段给m3使用
					if(messageFilterArgs!=null){
						messageInstance.setMessageFilterArgs(messageFilterArgs);
					}
				
					Map<String, Set<String>> configItems = userMessageFilterConfigManager.getUserMessageConfig(receiverId, member.getOrgAccountId(), category);
					try {
                        for (MessagePipeline pipeline : pipelines) {
                            String pipelineName = pipeline.getName();
                            if ("Push to Mobile".equalsIgnoreCase(pipelineName)) {
                                messagePipelineManager.invokes(pipelineName, messageInstance);
                            } else if (reciver.isForceSMS() && "sms".equalsIgnoreCase(pipelineName)) {
                                messagePipelineManager.invokes(pipelineName, messageInstance);
                            } else {
                                if ("ucpc".equalsIgnoreCase(pipelineName)) {//如果是ucpc就获取pc的消息通道
                                    pipeline = messagePipelineManager.getMessagePipeline("pc");
                                }
                                if ((userMessageFilter == null && !"pc".equalsIgnoreCase(pipeline.getName()) && !"wechat".equalsIgnoreCase(pipeline.getName())) || (userMessageFilter != null && !userMessageFilter.doFilter(pipeline, category, configItems.get(pipeline.getName()), messageFilterArgs))) {
                                    continue;
                                }
                                messagePipelineManager.invokes(pipelineName, messageInstance);
                            }
                        }
					} catch (Exception e) {
						log.error("", e);
					}
				}
				
				//历史消息，无论什么时候都要写
				//给消息接收者写历史消息
				h.setCreationDate(createDate);
				h.setMessageCategory(category);
				h.setMessageContent(content);
				h.setMessageType(messageType);
				h.setReferenceId(reciver.getReferenceId());
				h.setSenderId(senderId);
				h.setReceiverId(receiverId);
				h.setUserId(receiverId);
				h.setLinkType(linkType);
				h.setLinkParam(linkParams);
				h.setIsRead(isRead);
				h.setOpenType(openType);
				h.setImportantLevel(importantLevel);
				
				userHistoryMessages.add(h);
				
			}
			
			//如果是在线交流，给消息发起者写历史消息，但不管有多少接收者，发起者只写一次
			if(messageType == Constants.UserMessage_TYPE.PERSON.ordinal()){
				MessageReceiver last = recivers.iterator().next();
				UserHistoryMessage h1 = new UserHistoryMessage();
				h1.setIdIfNew();
				h1.setCreationDate(createDate);
				h1.setMessageCategory(category);
				h1.setMessageContent(messageContent.getKeys().get(0)[0].toString());
				h1.setMessageType(messageType);
				h1.setReferenceId(last.getReferenceId());
				h1.setSenderId(senderId);
				h1.setReceiverId(last.getReceiverId());
				h1.setUserId(senderId);
				h1.setImportantLevel(importantLevel);
				
				userHistoryMessages.add(h1);
			}
			
			if(!userHistoryMessages.isEmpty()){
				UserHistoryMessageTask.getInstance().add(userHistoryMessages);
			}
			
			return true;
		}
		catch (Exception e) {
			log.error("系统消息任务器写消息", e);
		}

		return false;
	}

	


}