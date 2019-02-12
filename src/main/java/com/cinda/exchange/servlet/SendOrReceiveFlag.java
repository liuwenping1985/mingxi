package com.cinda.exchange.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.cinda.exchange.client.Client;
import com.cinda.exchange.client.util.ClientUtil;




public class SendOrReceiveFlag extends HttpServlet {
	private static final Log log = LogFactory.getLog(SendOrReceiveFlag.class);
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 读取消息
		String msg = receiveMsg(request);
		log.info("msg="+msg);
		if (msg == null || msg.indexOf("TYPE") == -1) {// 无效消息，不进行处理
			log.info("无效消息，不进行处理。");
			response.getOutputStream().write("error=no type".getBytes());
			return;
		}

		// 数据消息格式：TYPE=FILE;MSGID={XXXX,XXXX,XXX};
		// 返回：TYPE=FILE;MSG=OK
		//
		// 回执消息格式：TYPE=FLAG;{XXXXX=OK,XXXXX=REDO,XXX=ER}
		// 返回：TYPE=FLAG;MSGID={XXXX,XXXX,XXX};
		String[] arr = msg.split(";");
		String type = arr[0].split("=")[1].trim();

		// 初始化交换中心客户端
		Client client = new Client(ClientUtil.jianhuanServer,ClientUtil.jianhuanPort);
		client.setTimeout(15 * 1000);

		if (type.equals("FILE")) {// 消息到达，接收数据成功后，返回 TYPE=FILE;MSG=OK
			String ids = arr[1].split("=")[1];
			ids = ids.substring(1, ids.length() - 1);
			String[] msgId = ids.split(",");
			String isok = "";

			for (int i = 0; i < msgId.length; i++) {
				boolean value = false;
				try {
					value = ClientUtil.receiveEdoc(client, msgId[i]);
				} catch (Exception e) {
					value = false;
					log.error("接收数据 [" + msgId[i] +"] 失败：",e);
				}
				
				try {
					if(value){
						client.sendFlag(msgId[i], "OK");
						log.info("接收数据 [" + msgId[i] +"] 成功。");
					}else{
						client.sendFlag(msgId[i], "FAIL");
						log.error("接收数据 [" + msgId[i] +"] 失败。");
					}
				} catch (Exception e) {
					log.error("返回接收状态错误：",e);
				} // 发送回执

				isok +=value;
			}
			
			if(!isok.contains("false") && !isok.equals("")){
				response.getOutputStream().write("TYPE=FILE;MSG=OK;".getBytes());
			}else{
				response.getOutputStream().write("TYPE=FILE;MSG=fail;".getBytes());
			}

			log.info("接收数据完毕");

		} else if (type.equals("FLAG")) {// 接收回执
			log.info("接收回执.................");
			String ids = arr[1].substring(1, arr[1].length() - 1);
			String[] msgInfos = ids.split(",");
			String tmp = "";
			for (int i = 0; i < msgInfos.length; i++) {
				String info = msgInfos[i];
				String key = info.split("=")[0];
				String value = info.split("=")[1];
				if ("OK".equalsIgnoreCase(value)) {// 回执成功
					ClientUtil.receiveReceipt(key);
					tmp += "," + key;
				}
			}
			if (tmp.length() > 1) {
				tmp = tmp.substring(1);
			}
			String ret = "TYPE=FLAG;MSGID={" + tmp + "}";
			log.info("接收回执完毕,返回消息:" + ret);
			response.getOutputStream().write(ret.getBytes());

			log.info("接收回执完毕");
		}

	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}
	

	private String receiveMsg(HttpServletRequest request) throws IOException {
		InputStreamReader bsr = null;
		BufferedReader br = null;

		StringBuffer buffer = new StringBuffer();
		try {
			bsr = new InputStreamReader(request.getInputStream());
			br = new BufferedReader(bsr);

			String valueLine = null;
			while ((valueLine = br.readLine()) != null) {
				buffer.append(valueLine);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new IOException(ex);
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (Exception ex) {
				}
			}
			if (bsr != null) {
				try {
					bsr.close();
				} catch (Exception ex) {
				}
			}
		}

		return buffer.toString();
	}

}
