/**
 * 
 */
package com.seeyon.ctp.common.usermessage;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.seeyon.ctp.common.usermessage.pipeline.Message;
import org.apache.commons.logging.Log;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.common.po.usermessage.UserHistoryMessage;
import com.seeyon.ctp.common.usermessage.dao.UserMessageDAO;

/**
 *
 * @author <a href="mailto:tanmf@seeyon.com">Tanmf</a>
 * @version 1.0 2011-5-18
 */
public class UserHistoryMessageTask {
	private static final Log log = CtpLogFactory.getLog(UserHistoryMessageTask.class);

	private static UserHistoryMessageTask instance = new UserHistoryMessageTask();

	private List<UserHistoryMessage> message = null;

	private Set<Long> messageIdSet = null;

	private UserHistoryMessageThread userHistoryMessageThread = null;
	
	private Object lock = new Object();
	
	private static UserMessageDAO userMessageDAO;

	private UserHistoryMessageTask() {
		userHistoryMessageThread = new UserHistoryMessageThread();
		message = new ArrayList<UserHistoryMessage>(100);
		messageIdSet = new HashSet();
		userMessageDAO = (UserMessageDAO)AppContext.getBean("userMessageDAO");
	}

	public static UserHistoryMessageTask getInstance() {
		return instance;
	}
	
	public void start(){
		userHistoryMessageThread.start();
	}
	
	public void stop(){
		try {
			userHistoryMessageThread.interrupt();
		}
		catch (Exception e) {
		}
		userHistoryMessageThread.running = false;
	}

	public void add(List<UserHistoryMessage> msgs) {
		if(userHistoryMessageThread.running){
			synchronized (lock) {
				message.addAll(msgs);
				for(UserHistoryMessage msg : msgs) {
					messageIdSet.add(msg.getId());
				}

			}
		}
	}
	
	/*
	 * 获取等待入库的队列长度
	 */
    public int getQueueLength(){
       return message.size();
    }

	/**
	 *
	 * @param msgs 消息列表
	 * @return 参数包括的消息是否已经持久化
	 */
	public boolean hasPersistedMessage(Message[] msgs){
		for(Message msg : msgs){
			if(messageIdSet.contains(msg.getUserHistoryMessageId())){
				return false;
			}
		}
		return true;
	}

    public synchronized void batchSaveUserHistoryMessage(){
		if (!message.isEmpty()) {
			List<UserHistoryMessage> msg = message;
			message = new ArrayList<UserHistoryMessage>(100);
			userMessageDAO.savePatchHistory(msg);
			messageIdSet.clear();
			MessageState.getInstance().setHistoryTimestamp(msg);//更新时间戳
		}
	}
    
	class UserHistoryMessageThread extends Thread {
		boolean running = true;
		
		public UserHistoryMessageThread(){
			super.setName("UserHistoryMessageThread");
		}
		
		public synchronized void start() {
			super.start();
			log.info("异步历史消息守护进程启动");
		}

		public void run() {
			while (running) {
				try{
					UserHistoryMessageTask.getInstance().batchSaveUserHistoryMessage();
				}
				catch(Exception e){
					log.error("", e);
				}

				try {
					Thread.sleep(15 * 1000L);
				}
				catch (Exception e) {
				    log.error("", e);
				}
			}
		}
	}
}
