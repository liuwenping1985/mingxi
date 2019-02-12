package com.cinda.exchange.client;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.cinda.exchange.client.util.ClientUtil;
import com.seeyon.ctp.common.AppContext;

/**
 * 交换中心客户端, 交换中心在 消息到达的通知、回执的通知 的时候， 调用这个 Servlet
 * 
 * @author 周渊
 * 
 */
public class Client {
	// 客户化开发， 增加 OA 日志输出
	private Log log = LogFactory.getLog(Client.class);
	// 交换中心服务器监听端口
	private int port = 9000;
	//Integer.valueOf(AppContext.getSystemProperty("czexchange.HD_EXCHANGE_PORT"));
	// 交换中心服务地址
	private String server = "";
			//AppContext.getSystemProperty("czexchange.HD_EXCHANGE_SERVER");
	// 超时
	private int timeout = 10 * 1000;

	public void setPort(int port) {
		this.port = port;
	}

	public void setServer(String server) {
		this.server = server;
	}

	public void setTimeout(int timeout) {
		this.timeout = timeout;
	}

	private Socket socket;

	private OutputStream out;

	private InputStream in;

	/**
	 * 数据转换
	 * 
	 * @param i
	 * @return
	 */
	private byte[] intToBytes(int i) {
		byte[] bt = new byte[4];
		bt[0] = (byte) (0xff & i);
		bt[1] = (byte) ((0xff00 & i) >> 8);
		bt[2] = (byte) ((0xff0000 & i) >> 16);
		bt[3] = (byte) ((0xff000000 & i) >> 24);
		return bt;
	}

	/**
	 * 数据转换
	 * 
	 * @param bytes
	 * @return
	 */
	private int bytesToInt(byte[] bytes) {
		int num = bytes[0] & 0xFF;
		num |= ((bytes[1] << 8) & 0xFF00);
		num |= ((bytes[2] << 16) & 0xFF0000);
		num |= ((bytes[3] << 24) & 0xFF000000);
		return num;
	}

	/**
	 * 从输入流中得到定长数据
	 * 
	 * @param length
	 * @return
	 * @throws IOException
	 */
	private byte[] getData(int length) throws IOException {
		byte[] data = new byte[length];
		int receiveLength = 0;
		int start = 0;
		while (start < length
				&& (receiveLength = in.read(data, start, length - start)) > -1) {
			start = start + receiveLength;
		}
		return data;
	}

	/**
	 * 返回文件的数据内容
	 * 
	 * @param fileName,文件路径
	 * @return
	 */
	private byte[] getFileDate(String fileName) {
		File file = new File(fileName);
		byte[] data = null;
		if (file.exists()) {
			try {
				FileInputStream fis = new FileInputStream(file);
				data = new byte[fis.available()];
				fis.read(data);
				fis.close();
			} catch (Exception e) {
				log.error("", e);
			}
		}
		return data;
	}

	/**
	 * 保存文件
	 * 
	 * @param dirPath,目录
	 * @param fileName,文件名
	 * @param data,数据
	 */
	private void saveFile(String dirPath, String fileName, byte[] data) {
		File dir = new File(dirPath);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		
		try {
			FileOutputStream out = new FileOutputStream(dirPath +"/"+ fileName);
			out.write(data);
			out.flush();
			out.close();

		} catch (Exception ex) {
			log.error("", ex);
		}
	}

	public Client(String server, int port){
		this.server = server;
		this.port = port;
	}
	/**
	 * 初始建立连接
	 * 
	 * @throws IOException
	 */
	private void init() throws IOException {
		InetSocketAddress address = new InetSocketAddress(server, port);
		socket = new Socket();
		socket.connect(address);
		socket.setSoTimeout(timeout);
		out = socket.getOutputStream();
		in = socket.getInputStream();
	}

	/**
	 * 关闭连接
	 * 
	 * @throws IOException
	 */
	private void destroy() throws IOException {
		socket.close();
	}

	/**
	 * 发送数据
	 * 方法调用时现初始化，方法执行完毕自动执行destroy();
	 * 
	 * @param from
	 * @param to
	 * @param filePath
	 * @return
	 */
	public String[] sendData(String from, String to, String filePath) {
		String[] msgIds = null;
		// 准备数据
		int cmd = 1000;
		byte[] fromByte = from.getBytes();
		byte[] toByte = to.getBytes();
		// byte[] data = getFileDate(filePath);
		File file = new File(filePath);
		if (!file.exists()) {
			log.error("文件(" + filePath + ")不存在");
			return null;
		}

		InputStream is = null;
		try {
			// 初始化
			init();
			// 发送数据
			out.write(intToBytes(cmd));
			out.write(intToBytes(fromByte.length));
			out.write(fromByte);
			out.write(intToBytes(toByte.length));
			out.write(toByte);
			//out.write(intToBytes(data.length));
			//out.write(data);
			//大文件交换处理2016
			is = new FileInputStream(file);
			int fileLen = is.available();
			out.write(intToBytes(fileLen));
			byte[] buffer = new byte[1024 * 5];
			int len = -1;
			while ((len = is.read(buffer)) != -1) {
				// 把缓冲区的字节写入到输出流
				out.write(buffer, 0, len);
				out.flush();
			}
			// 接收数据
			int returnCmd = bytesToInt(getData(4));
			// 交换中心数据处理成功
			if (getData(1)[0] == 0) {
				int msgIdLen = bytesToInt(getData(4));
				String msgId = new String(getData(msgIdLen));
				msgIds = msgId.split(",");
				log.info("发送数据(" + msgId + ")成功");
			}
		} catch (Exception ex) {
			log.error("", ex);
		} finally {
			try {
				destroy();
			} catch (Exception ex) {
				log.error("", ex);
			}
			if (is != null) {
				try {
					is.close();
				} catch (IOException e) {
					log.error("", e);
				}
			}
		}
		return msgIds;
	}

	/**
	 * 接收数据，将文件接收到 path
	 * 方法调用时现初始化，方法执行完毕自动执行destroy();
	 * 
	 * @param msgId
	 * @param path
	 * @return
	 */
	public String[] receiveData(String msgId, String path) {
		String[] value = null;
		// 准备数据
		int cmd = 1002;
		byte[] msgIdByte = msgId.getBytes();
		OutputStream fos = null;
		
		try {
			// 初始化
			init();
			// 发送数据
			out.write(intToBytes(cmd));
			out.write(intToBytes(msgIdByte.length));
			out.write(msgIdByte);
			out.flush();
			// 接收数据
			int returnCmd = bytesToInt(getData(4));
			// 交换中心数据处理成功
			if (getData(1)[0] == 0) {
				int fromLen = bytesToInt(getData(4));
				String from = new String(getData(fromLen));
				int toLen = bytesToInt(getData(4));
				String to = new String(getData(toLen));
				int dataLen = bytesToInt(getData(4));
				//byte[] data = getData(dataLen);
				//大文件交换处理2016
				File dir = new File(path);
				if (!dir.exists()) {
					dir.mkdirs();
				}

				fos = new FileOutputStream(path + File.separator + msgId+".zip");
				byte[] buffer = new byte[1024 * 5];
				int len = -1;
				int count = 0;
				//读入定长数据流
				while (count < dataLen && (len = in.read(buffer)) != -1) {
					count += len;
					// 把缓冲区的字节写入到输出流
					fos.write(buffer, 0, len);
				}
				fos.flush();
				
				//saveFile(path, msgId+".zip", data);
				//value = new String[] { null, from, to, String.valueOf(dataLen) };
				value = new String[] { null, from, to, "" };
				log.info("接收数据(" + msgId + ")成功");
			} else {
				int errorLen = bytesToInt(getData(4));
				String error = new String(getData(errorLen));
				value = new String[] { error, null, null, null };
				log.error("接收数据(" + msgId + ")失败,原因:" + error);
			}
		} catch (Exception ex) {
			log.error("", ex);
		} finally {
			try {
				destroy();
			} catch (Exception ex) {
				log.error("", ex);
			}
			if (fos != null) {
				try {
					fos.close();
				} catch (IOException e) {
					log.error("", e);
				}
			}
		}
		return value;
	}

	/**
	 * 发送回执
	 * 
	 * @param msgId
	 * @param flag
	 * @throws Exception 
	 */
	public void sendFlag(String msgId, String flag) throws Exception {
		// 准备数据
		int cmd = 1004;
		byte[] msgIdByte = msgId.getBytes();
		byte[] flagByte = (flag == null) ? (new byte[0]) : flag.getBytes();
		try {
			// 初始化
			init();
			// 发送数据
			out.write(intToBytes(cmd));
			out.write(intToBytes(msgIdByte.length));
			out.write(msgIdByte);
			out.write(intToBytes(flagByte.length));
			out.write(flagByte);
			out.flush();
			// 接收数据
			int returnCmd = bytesToInt(getData(4));
			// 交换中心数据处理成功
			int getDateRtnCode = 0;
			try{
				getDateRtnCode = getData(1)[0];
			}catch(java.net.SocketException se){
//				if(ClientUtil.isEndStep(msgId)){
//					//已到了，最后一步不需要在取数据
//				}else{
//					log.error("", se);
//				}
			}
			if (getDateRtnCode == 0) {
				log.info("发送回执(" + msgId + ")成功");
			} else {
				int errorLen = bytesToInt(getData(4));
				String error = new String(getData(errorLen));
				log.error("发送回执(" + msgId + ")失败,原因:" + error);
			}
		} catch (Exception ex) {
			log.error("", ex);
			throw ex;
		} finally {
			try {
				destroy();
			} catch (Exception ex) {
				log.error("", ex);
				throw ex;
			}
		}
	}
}
