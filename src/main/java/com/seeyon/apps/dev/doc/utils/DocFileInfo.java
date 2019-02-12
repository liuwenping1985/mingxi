package com.seeyon.apps.dev.doc.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.FileChannel;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.dev.doc.constant.DevConstant;
import com.seeyon.ctp.common.po.BasePO;
import com.seeyon.ctp.util.Strings;

@SuppressWarnings("serial")
public class DocFileInfo extends BasePO{
	private static final Log log = LogFactory.getLog(DocFileInfo.class);
	private Long file_sortId;
	private String ftp_path;
	private File file;
	private String file_fullName;
	private InputStream  file_InputStream;
	private OutputStream  file_OutputStream;
	private String file_name;
	private Long file_size;
	private String file_suffix;
	private String docId;
	private String file_title;
	private boolean success = false;
	private  String ip;
	private  int port;
	private  String userName;
	private  String password;
	// 20161031 liutong 增加了文件类型的属性， 正文， 附件， 底稿
	private String fileType;
	public DocFileInfo() {
		super();
	}

	public DocFileInfo(Long id ,String ftp_path, File local_file, String docId,
			String file_title, String fileType) throws Exception {
		super();
		this.setId(id);
		this.ftp_path = ftp_path;
		if(local_file.exists()&& local_file.isFile()){
			this.file = local_file;
			this.setFile_fullName(file.getAbsolutePath());
			this.file_size = this.file.length();
		}else{
			throw new Exception(local_file.getAbsolutePath()+"不是文件");
		}
		this.docId = docId;
		this.file_title = file_title;
		this.fileType = fileType;
	}
	public DocFileInfo(Long id , String ftp_path, InputStream file_in, Long file_size,String file_fullName,
			String docId, String file_title, String fileType) {
		super();
		this.setId(id);
		this.ftp_path = ftp_path;
		this.file_InputStream = file_in;
		this.file_size = file_size;
		this.setFile_fullName(file_fullName);
		this.docId = docId;
		this.file_title = file_title;
		this.fileType = fileType;
	}
	public DocFileInfo(Long id , String ftp_path, FileInputStream file_in, String file_fullName,
			String docId, String file_title, String fileType) {
		super();
		this.setId(id);
		this.ftp_path = ftp_path;
		this.file_InputStream = file_in;
		if(file_in!=null){
			 FileChannel fc= null;  
			fc= file_in.getChannel();  
			try {
				this.file_size=fc.size();
			} catch (IOException e) {
				log.error("文件"+file_fullName+"读取失败："+e.getMessage());
			}  
		}
		this.setFile_fullName(file_fullName);
		this.docId = docId;
		this.file_title = file_title;
		this.fileType = fileType;
	}
	
	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public Long getFile_sortId() {
		return file_sortId;
	}

	public void setFile_sortId(Long file_sortId) {
		this.file_sortId = file_sortId;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public int getPort() {
		return port;
	}

	public void setPort(int port) {
		this.port = port;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public InputStream getFile_InputStream() {
		return file_InputStream;
	}

	public void setFile_InputStream(InputStream file_InputStream) {
		this.file_InputStream = file_InputStream;
	}

	public OutputStream getFile_OutputStream() {
		return file_OutputStream;
	}

	public void setFile_OutputStream(OutputStream file_OutputStream) {
		this.file_OutputStream = file_OutputStream;
	}

	public void setFile_OutputStream(FileOutputStream file_OutputStream) {
		this.file_OutputStream = file_OutputStream;
	}

	public String getFtp_path() {
		return ftp_path;
	}
	public void setFtp_path(String ftp_path) {
		this.ftp_path = ftp_path;
	}
	public String getFile_fullName() {
		if(Strings.isBlank(this.file_fullName)){
			this.file_fullName = this.getFile_name()+DevConstant.File_dot+this.getFile_suffix();
		}
		return file_fullName;
	}
	public void setFile_fullName(String file_fullName) {
		this.file_fullName = file_fullName;
		if(!Strings.isBlank(file_fullName)){
			if(file_fullName.contains(DevConstant.File_dot)){
				this.file_name = file_fullName.substring(0, file_fullName.lastIndexOf(DevConstant.File_dot));
				this.file_suffix = file_fullName.substring(file_fullName.lastIndexOf(DevConstant.File_dot)+1);
			}
		}
	}
	public String getFile_name() {
		return file_name;
	}
	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}

	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}

	public Long getFile_size() {
		return file_size;
	}

	public void setFile_size(Long file_size) {
		this.file_size = file_size;
	}

	public String getFile_suffix() {
		return file_suffix;
	}
	public void setFile_suffix(String file_suffix) {
		this.file_suffix = file_suffix;
	}
	public String getDocId() {
		return docId;
	}
	public void setDocId(String docId) {
		this.docId = docId;
	}
	public String getFile_title() {
		return file_title;
	}
	public void setFile_title(String file_title) {
		this.file_title = file_title;
	}
	public boolean isSuccess() {
		return success;
	}
	public void setSuccess(boolean success) {
		this.success = success;
	}
	public static void main(String[] args) throws Exception {
		DocFileInfo in = new DocFileInfo();
		in.setFile_fullName("iououou.iouoiuo.9889.doc");
		File file = new File("D:\\test001.txt");
		FileOutputStream out = new FileOutputStream(file);
		out.write(in.getFile_fullName().getBytes("utf-8"));
		out.close();
		System.out.println(file.length());
		System.out.println(in.getFile_fullName().length());
	}
}