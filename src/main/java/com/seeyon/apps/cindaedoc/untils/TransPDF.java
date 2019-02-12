package com.seeyon.apps.cindaedoc.untils;

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
	}

	/**
	 * 服务端口测试
	 * 
	 * @return
	 */
	public boolean connectServerTest() {
		try {
			// 端口测试
			Socket server = new Socket();
			InetSocketAddress address = new InetSocketAddress(InetAddress
					.getByName(serverIP), serverPort);
			server.connect(address, 1000);
			server.close();
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
			// 发送命令
			String cmd = "UPLOAD DOC NO\n";
			output.write(cmd.getBytes());

			// 发送文件流
			fis = new FileInputStream(fileName);
			copy(fis, output);

			// 接收文件id
			byte[] data = copyToByteArray(input);
			String uid = new String(data);
			uid = uid.replaceAll("\r\n", "");

			return uid;
		} catch (Exception ex) {
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

			// 发送命令
			String cmd = "DOWNLOAD " + fileId + " NO\n";
			output.write(cmd.getBytes());

			fos = new FileOutputStream(desFileName);
			// 接收文件
			copy(input, fos);

		} catch (Exception ex) {
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

			// 发送命令
			String cmd = "QUERY " + fileId + " AAAAAAAAAAAAAAAAAAAAAAAAAA\n";
			output.write(cmd.getBytes());

			// 接收文件
			byte[] data = copyToByteArray(input);
			String ret = new String(data);
			ret = ret.replaceAll("\r\n", "");

			if (ret.equals("true")) {
				return true;
			} else {
				return false;
			}
		} catch (Exception ex) {
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
			// 发送文件
			String fileId = sendFileBytes(fileName, "doc");
			Thread.sleep(1000);

			boolean flag = false;
			int retry = 0;
			while (retry++ < 20) {
				if (isConvertFinish(fileId)) {
					flag = true;
					break;
				}
				Thread.sleep(6000);
			}

			if (flag) {
				reciveFileBytes(fileId, desFileName);
			} else {
				log.info("接收文件【" + desFileName + "】失败.");
			}
		} catch (Exception ex) {
			throw new IOException(ex);
		}

		return true;
	}
}
