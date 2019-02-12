package com.seeyon.apps.docexport.util;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;

import org.apache.log4j.Logger;

/**
 * 将word文件转换成pdf文件，包括文件是否转换完成查询方法
 * 
 * @author tcy
 * 
 */
public class TransPDF {

	private String serverIP = "";

	private int serverPort = 80;

	private static Logger log = Logger.getLogger(TransPDF.class);

	public TransPDF(String serverIP, int serverPort) {
		this.serverIP = serverIP;
		this.serverPort = serverPort;

		log.info("pdf server info[" + serverIP + ":" + serverPort + "]");
	}

	/**
	 * 服务端口测试
	 * 
	 * @return
	 */
	public boolean connectServerTest() {
		try {
			log.debug("探测PDF转换服务地址=" + serverIP + ":" + serverPort);

			// 端口测试
			Socket server = new Socket();
			InetSocketAddress address = new InetSocketAddress(InetAddress
					.getByName(serverIP), serverPort);
			server.connect(address, 1000);
			server.close();

			log.debug("PDF转换服务探测ok.");

			return true;
		} catch (Exception ex) {
			ex.printStackTrace();
			return false;
		}
	}

	/**
	 * 
	 * 将word文件发送到PDF打印机
	 * 
	 * @param inBytes
	 *            待转换的word字节流
	 * @param extName
	 *            扩展名称，保留参数
	 * @return 转换完成的PDF文件id
	 * @throws Exception
	 */
	public String sendFileBytes(String fileName, String extName)
			throws Exception {
		Socket socket = null;
		FileInputStream fis = null;
		OutputStream output = null;
		InputStream input = null;

		try {
			socket = new Socket(InetAddress.getByName(serverIP), serverPort);
			output = socket.getOutputStream();
			input = socket.getInputStream();

			log.info("发送转换命令...");
			// 发送命令
			String cmd = "UPLOAD DOC NO\n";
			output.write(cmd.getBytes());

			log.info("发送文件流...");
			// 发送文件流
			fis = new FileInputStream(fileName);
			copy(fis, output);

			log.info("接收转换后的文件id...");
			// 接收文件id
			byte[] data = copyToByteArray(input);
			String uid = new String(data);
			uid = uid.replaceAll("\r\n", "");

			log.info("接收到转换后的文件id：[" + uid + "]");

			return uid;
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new Exception(ex);
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			if (output != null) {
				try {
					output.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			if (socket != null) {
				try {
					socket.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
		}
	}

	/**
	 * 通过文件id，获得转换后的文件
	 * 
	 * @param fileId
	 * @param desFileName
	 *            返回后存储的文件路径和名称
	 * @return
	 * @throws Exception
	 */
	public void reciveFileBytes(String fileId, String desFileName)
			throws Exception {
		Socket socket = null;
		OutputStream output = null;
		InputStream input = null;
		FileOutputStream fos = null;

		try {
			socket = new Socket(InetAddress.getByName(serverIP), serverPort);
			output = socket.getOutputStream();
			input = socket.getInputStream();

			log.info("发送接收命令...");
			// 发送命令
			String cmd = "DOWNLOAD " + fileId + " NO\n";
			output.write(cmd.getBytes());

			log.info("接收转换后的文件...");
			fos = new FileOutputStream(desFileName);
			// 接收文件
			copy(input, fos);

			log.info("接收到转换后的文件ok.");

		} catch (Exception ex) {
			ex.printStackTrace();
			throw new Exception(ex);
		} finally {
			if (fos != null) {
				try {
					fos.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			if (input != null) {
				try {
					input.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			if (output != null) {
				try {
					output.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			if (socket != null) {
				try {
					socket.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
		}
	}

	/**
	 * 查询文件是否转换完成
	 * 
	 * @param fileId
	 *            文件id
	 * @return boolean true表示完成，false表示未完成
	 * @throws Exception
	 */
	public boolean isConvertFinish(String fileId) throws Exception {
		Socket socket = null;
		OutputStream output = null;
		InputStream input = null;

		try {
			socket = new Socket(InetAddress.getByName(serverIP), serverPort);
			output = socket.getOutputStream();
			input = socket.getInputStream();

			log.info("发送查询命令...");
			// 发送命令
			String cmd = "QUERY " + fileId + " AAAAAAAAAAAAAAAAAAAAAAAAAA\n";
			output.write(cmd.getBytes());

			log.info("接收查询结果...");
			// 接收文件
			byte[] data = copyToByteArray(input);
			String ret = new String(data);
			ret = ret.replaceAll("\r\n", "");

			log.info("接收到查询结果：[" + ret + "]");

			if (ret.equals("true")) {
				return true;
			} else {
				return false;
			}

		} catch (Exception ex) {
			ex.printStackTrace();
			throw new Exception(ex);
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			if (output != null) {
				try {
					output.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			if (socket != null) {
				try {
					socket.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
		}
	}

	/**
	 * 输入输出流拷贝，注意输入输出都不要关闭，在调用方法外关闭
	 * 
	 * @param in
	 * @param out
	 * @return
	 * @throws IOException
	 */
	public int copy(InputStream in, OutputStream out) throws IOException {
		int i;
		try {
			int byteCount = 0;
			byte[] buffer = new byte[4096];
			int bytesRead = -1;
			while ((bytesRead = in.read(buffer)) != -1) {
				out.write(buffer, 0, bytesRead);
				byteCount += bytesRead;
			}
			out.flush();
			i = byteCount;
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new IOException(ex);
		}

		return i;
	}

	public byte[] copyToByteArray(InputStream in) throws IOException {
		ByteArrayOutputStream out = new ByteArrayOutputStream(4096);
		copy(in, out);
		byte[] data = out.toByteArray();
		try {
			out.close();
		} catch (IOException ex) {
			ex.printStackTrace();
			throw new IOException(ex);
		}
		return data;
	}

	/**
	 * 转换文件到pdf
	 * 
	 * @param fileName
	 * @return
	 */
	public boolean transFile(String fileName, String desFileName)
			throws Exception {
		try {
			log.info("开始发送文件...");

			// 发送文件
			String fileId = sendFileBytes(fileName, "doc");

			Thread.sleep(1000);

			log.info("等待接收文件...");
			boolean flag = false;
			int retry = 0;
			while (retry++ < 300) {
				if (isConvertFinish(fileId)) {
					flag = true;
					break;
				}

				Thread.sleep(6000);
			}

			// 接收文件
			if (flag) {
				log.info("开始接收文件...");
				log.info("path=" + desFileName);
				reciveFileBytes(fileId, desFileName);

				log.info("接收文件ok.");
			} else {
				log.info("接收文件失败.");
			}

		} catch (Exception ex) {
			ex.printStackTrace();
			throw new IOException(ex);
		}

		return true;
	}

	public static void main(String[] args) {
		try {
			TransPDF trans = new TransPDF("80.46.8.69", 5801);

			log.info("开始发送文件...");
			// 发送文件
			String fileId = trans.sendFileBytes("/Users/mac/Documents/项目源码/2017year_code/中信信达/公文归档/5025347548177712210D1490065623000.doc.doc", "html");

			Thread.sleep(3000);

			log.info("等待接收文件...");
			// 等待转换完成
			boolean flag = false;
			int retry = 0;
			while (retry++ < 300) {
				if (trans.isConvertFinish(fileId)) {
					flag = true;
					break;
				}

				Thread.sleep(6000);
			}

			// 接收文件
			if (flag) {
				log.info("开始接收文件...");
				trans.reciveFileBytes(fileId, "/Users/mac/Downloads/newtest.pdf");
				log.info("接收文件ok.");
			} else {
				log.info("接收文件失败.");
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

}
