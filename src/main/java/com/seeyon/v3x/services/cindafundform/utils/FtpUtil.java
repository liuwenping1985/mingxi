package com.seeyon.v3x.services.cindafundform.utils;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.net.ftp.FTPClient;

import com.seeyon.ctp.common.AppContext;

/**
 * ftp 实现类
 * 
 * @author gelb
 *
 */
public class FtpUtil implements FtpUtilInterface {

	private int maxBufferSize = 2 * (1024 * 1024);

	private FTPClient ftpClient = null;

	/**
	 * connectServer 连接ftp服务器
	 * 
	 * @throws java.io.IOException
	 * @param path
	 *            文件夹，空代表根目录
	 * @param password
	 *            密码
	 * @param user
	 *            登陆用户
	 * @param server
	 *            服务器地址
	 */
	public void connectServer(String path) throws IOException {
		// server：FTP服务器的IP地址；user:登录FTP服务器的用户名
		// password：登录FTP服务器的用户名的口令；path：FTP服务器上的路径
		ftpClient = new FTPClient();

		String ftpIP = AppContext.getSystemProperty("cindafundform.ftpIP");
		if (StringUtils.isEmpty(ftpIP)) {
			ftpIP = "80.44.72.135";
		}

		Integer ftpPort = new Integer(31);
		String ftpPortStr = AppContext.getSystemProperty("cindafundform.ftpPort");
		if (StringUtils.isEmpty(ftpPortStr)) {
			
		} else {
			ftpPort = Integer.parseInt(ftpPortStr);
		}
		

		String ftpUser = AppContext.getSystemProperty("cindafundform.ftpUser");
		if (StringUtils.isEmpty(ftpUser)) {
			ftpUser = "test";
		}
		String ftpPass = AppContext.getSystemProperty("cindafundform.ftpPass");
		if (StringUtils.isEmpty(ftpPass)) {
			ftpPass = "123456-a";
		}
		// ftpClient.openServer(ftpIP);
		// ftpClient.login(ftpUser, ftpPass);
		// ftpClient.cd(path);
		// // 用2进制上传、下载
		// ftpClient.binary();
		ftpClient.setControlEncoding("GBK");
		ftpClient.connect(ftpIP, ftpPort);
		ftpClient.login(ftpUser, ftpPass);
		ftpClient.enterLocalPassiveMode();
		ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);
		ftpClient.changeWorkingDirectory("/");

	}

	/**
	 * upload 上传文件
	 * 
	 * @throws java.lang.Exception
	 * @return -1 文件不存在 -2 文件内容为空 >0 成功上传，返回文件的大小
	 * @param fileInput
	 *            上传的文件流
	 * @param filename
	 *            上传的文件
	 */
	public long upload(InputStream fileInput, String newname, String fileName) throws Exception {
		long result = 0;
		OutputStream os = null;
		try {
			// 遇到FTP接收数据异常可使用被动模式ftpClient.enterLocalPassiveMode();
			os = ftpClient.storeFileStream(newname);
			if (os == null) {
				System.out.println(("ReplyCode:" + ftpClient.getReplyCode()));
				throw new Exception("上传文件出错,检查目录是否有写入权限。FTP错误代码：" + ftpClient.getReplyCode());
			}
			byte[] bytes = new byte[maxBufferSize];
			int c;
			while ((c = fileInput.read(bytes)) != -1) {
				os.write(bytes, 0, c);
			}
		} finally {
			if (fileInput != null) {
				fileInput.close();
			}
			if (os != null) {
				os.close();
				// apache的ftpClient每次建立输入流输出流后都要关闭流并且执行ftpClient.completePendingCommand()才能继续执行下一个操作
				ftpClient.completePendingCommand();
			}
		}

		return result;
	}

	/**
	 * download 从ftp下载文件到本地
	 * 
	 * @throws java.lang.Exception
	 * @return
	 * @param newfilename
	 *            本地生成的文件名
	 * @param filename
	 *            服务器上的文件名
	 */
	public void download(String downloadFileName, String showName, HttpServletResponse response) throws Exception {
		InputStream is = null;
		OutputStream out = null;
		try {
			// 遇到FTP接收数据异常可使用被动模式ftpClient.enterLocalPassiveMode();
			is = ftpClient.retrieveFileStream(downloadFileName);

			response.reset();
			response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(showName, "UTF-8"));
			// 得到向客户端输出二进制数据的对象
			out = new BufferedOutputStream(response.getOutputStream());

			if (showName.toUpperCase().indexOf(".DOC") > -1) {
				response.setContentType("application/msword");
			} else {
				// 设置返回的文件类型
				response.setContentType("application/octet-stream");
			}
			byte[] bytes = new byte[maxBufferSize];
			int c;
			long result = 0;
			while ((c = is.read(bytes)) != -1) {
				out.write(bytes, 0, c);
				result = result + c;
			}

			response.addHeader("Content-Length", "" + result);
			out.flush();

		} finally {
			try {
				if (is != null) {
					is.close();
					// apache的ftpClient每次建立输入流输出流后都要关闭流并且执行ftpClient.completePendingCommand()才能继续执行下一个操作
					ftpClient.completePendingCommand();
				}

				if (out != null) {
					out.close();
				}
			} catch (Exception e) {
				throw e;
			}
		}
	}

	/**
	 * download 从ftp下载文件到本地
	 * 
	 * @throws java.lang.Exception
	 * @return
	 * @param reportFtpClient
	 *            FTP连接对象
	 * @param ftpFilename
	 *            ftp上保存的文件名
	 * @param newfilename
	 *            下载到服务器上的文件名
	 */
	public long downloadReport(String ftpFilename, String newfilename) throws Exception {
		long result = 0;
		InputStream is = null;
		FileOutputStream os = null;
		try {
			// 遇到FTP接收数据异常可使用被动模式ftpClient.enterLocalPassiveMode();
			is = ftpClient.retrieveFileStream(ftpFilename);
			File outfile = new File(newfilename);
			os = new FileOutputStream(outfile);
			byte[] bytes = new byte[1024];
			int c;
			while ((c = is.read(bytes)) != -1) {
				os.write(bytes, 0, c);
				result = result + c;
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (is != null) {
				is.close();
				// apache的ftpClient每次建立输入流输出流后都要关闭流并且执行ftpClient.completePendingCommand()才能继续执行下一个操作
				ftpClient.completePendingCommand();
			}
			if (os != null) {
				os.close();
			}
		}
		return result;
	}

	/**
	 * delete ftp上的文件
	 * 
	 * @throws java.lang.Exception
	 * @return
	 * @param newfilename
	 *            本地生成的文件名
	 * @param filename
	 *            服务器上的文件名
	 */
	public void delete(String downloadFileName) throws Exception {
		ftpClient.dele(downloadFileName);
	}

	/**
	 * closeServer 断开与ftp服务器的链接
	 * 
	 * @throws java.io.IOException
	 */
	public void closeServer() throws IOException {
		if (ftpClient != null) {
			ftpClient.logout();
			ftpClient.disconnect();
		}
	}
}