package com.seeyon.v3x.services.cindafundform.utils;

import java.io.IOException;
import java.io.InputStream;
import javax.servlet.http.HttpServletResponse;
public interface FtpUtilInterface 
{


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
	public void connectServer(String path) throws IOException;

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
	public long upload(InputStream fileInput, String newname,String fileName) throws Exception;

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
	public void download(String downloadFileName, String showName,HttpServletResponse response) throws Exception;
	
	/** 
	 *  download 
	 *  从ftp下载文件到本地 
	 * @throws java.lang.Exception 
	 * @return  
	 * @param reportFtpClient FTP连接对象
	 * @param ftpFilename ftp上保存的文件名 
	 * @param newfilename 下载到服务器上的文件名 
	 */
	public long downloadReport(String ftpFilename, String newfilename) throws Exception;
	
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
	public void delete(String downloadFileName) throws Exception; 

	/**
	 * closeServer 断开与ftp服务器的链接
	 * 
	 * @throws java.io.IOException
	 */
	public void closeServer() throws IOException;

}
