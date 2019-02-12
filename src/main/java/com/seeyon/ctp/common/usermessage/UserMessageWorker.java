/**
 * 
 */
package com.seeyon.ctp.common.usermessage;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.commons.logging.Log;

import com.seeyon.ctp.common.log.CtpLogFactory;

/**
 * 
 * @author <a href="mailto:tanmf@seeyon.com">Tanmf</a>
 * @version 1.0 2008-6-28
 */
public class UserMessageWorker {
	private static final Log log = CtpLogFactory.getLog(UserMessageWorker.class);

	private static UserMessageWorker instance = new UserMessageWorker();

	private List<UserMessage> message = null;

	private UserMessageThread userMessageThread = null;

	private UserMessageWorker() {
		userMessageThread = new UserMessageThread();
		message = Collections.synchronizedList(new ArrayList<UserMessage>(100));
	}

	public static UserMessageWorker getInstance() {
		return instance;
	}
	
	public void start(){
		userMessageThread.start();
		UserHistoryMessageTask.getInstance().start();
	}
	
	public void stop(){
		UserHistoryMessageTask.getInstance().stop();
		try {
			userMessageThread.interrupt();
		}
		catch (Exception e) {
		}
		userMessageThread.running = false;
	}

	public void addMessage(UserMessage msg) {
		if(userMessageThread.running){
			message.add(msg);
		}
	}

	/**
	 *  获取等待解析的队列长度
	 * @author leigf
	 */
	public int getQueueLengh(){
	    return message.size();
	}
	
	class UserMessageThread extends Thread {
		private UserMessageTask task = new UserMessageTask();

		private int counter = 0;
		
		boolean running = true;
		
		public UserMessageThread(){
			super.setName("UserMessageWorker");
		}
		
		public synchronized void start() {
			super.start();
			log.info("异步消息守护进程启动");
		}

		
		public void run() {
			while (running) {
				try{
					if (!message.isEmpty()) {
						UserMessage msg = message.remove(0);
						try {
							task.run(msg);
						}
						catch (Exception e) {
							log.error("", e);
						}
						
						counter = 0;
					}
					else {
						counter++;
					}
				}
				catch(Exception e){
					log.error("", e);
				}

				long millis = 500L;
				if (counter > 3) {
					millis = 8 * 1000L;
				}

				if(counter > 0){
					try {
						Thread.sleep(millis);
					}
					catch (Exception e) {
					    log.error("", e);
					}
				}
			}
		}
	}

}
