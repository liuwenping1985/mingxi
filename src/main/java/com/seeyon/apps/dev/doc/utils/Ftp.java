package com.seeyon.apps.dev.doc.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;

import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.TextEncoder;


public class Ftp
{
	private static final Log log = LogFactory.getLog(Ftp.class);
	private FTPClient ftpClient = null;
	private boolean soucess = false;
	private static String rootPath = SystemProperties.getInstance().getProperty("exportdoc.ftp.rootpath", File.separator);
	private static String ip = SystemProperties.getInstance().getProperty("exportdoc.ftp.ip", "192.168.18.243");
	private static int port = Integer.valueOf(SystemProperties.getInstance().getProperty("exportdoc.ftp.port", "21"));
	private static String userName = SystemProperties.getInstance().getProperty("exportdoc.ftp.userName", "test");
	private static String password = TextEncoder.decode(SystemProperties.getInstance().getProperty("exportdoc.ftp.password", "test")); 
    
	   public static Ftp getInstance(){
		   return new Ftp();
	   }
	   private Ftp(){
		   	ftpClient  = new FTPClient();
			ftpClient.setControlEncoding("iso-8859-1"); 
			try {
				ftpClient.connect(ip, port);//连接FTP服务器
				ftpClient.login(userName, password);//登录
				int reply = ftpClient.getReplyCode();
				if (!FTPReply.isPositiveCompletion(reply)) {
					ftpClient.disconnect();
					return;
				}
				ftpClient.enterLocalPassiveMode();              
				ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
				this.soucess = this.changeWorkingDirectory(rootPath);
			} catch (IOException e) {
				log.error("ftp建立连接失败"+e.getMessage());
				close();
			}
	   }
    private  boolean changeWorkingDirectory(String path){
		try{
			if(Strings.isNotBlank(path)) {
				
				if (!ftpClient.changeWorkingDirectory(path)){
					if(ftpClient.makeDirectory(path)){
						return  ftpClient.changeWorkingDirectory(path);
					}else{
						return false;
					}
				}else{
					
					return true;
				}
				
			}
		}
		catch(Exception ex) {
			log.error("切换ftp目录出错",ex);
		}
		return false;
    }

    public void close(){
        	if(ftpClient !=null && ftpClient.isConnected()){
        		try {
					ftpClient.logout();
				} catch (IOException e) {
					log.error("ftp登出错误",e);
				}
        		try {
					ftpClient.disconnect();
				} catch (IOException e) {
					log.error("ftp退出错误",e);
				}
        		ftpClient = null;
        	}
    }
    public FtpInfo upload(FtpInfo info) throws Exception{
    	if(info.getFile_InputStream()!=null){
    		info.setSuccess(upload(info.getFile_InputStream(), info.getFile_fullName(), info.getFtp_path()));
    	}else if(info.getFile()!=null){
    		info.setSuccess(upload(info.getFile(), info.getFile_fullName(), info.getFtp_path()));
    	}else{
    		throw new Exception(info.getFile_fullName()+"没有出入有效的文件路径");
    	}
    	info.setIp(ip);
    	info.setUserName(userName);
    	info.setPassword(password);
    	info.setPort(port);
		return info;
    }

    /**
     * 上传附件
     * @param InputStream  in 文件流
     * @param fileName   文件名
     * @throws Exception
     */
    public boolean upload(InputStream in, String fileName,String uploadPath){
    		boolean flag = false;
    	if(this.soucess && in!=null && changeWorkingDirectory(uploadPath)){
    		try{
    			fileName = new String(fileName.getBytes("GBK"),"iso-8859-1");
    			flag = ftpClient.storeFile(fileName, in);
    	 	}catch(Exception ex){
    			log.error("上传文件失败，fileName="+fileName, ex);
    		}finally{
    			try {
					in.close();
				} catch (Exception e) {
					log.error("",e);
				}
    			this.close();
    		}
    	}
		return flag;
    }
    /**
     * ftp上传文件
     * @param file
     * @param uploadPath
     * @return
     * @throws Exception
     */
    public boolean upload(File file,String fileName,String uploadPath){
    	boolean flag = false;
    	if(file!=null){
    		if(Strings.isBlank(fileName)){
    			
    			fileName = file.getName();
    		}
			try {
				InputStream in = new FileInputStream(file);
				flag = this.upload(in, fileName, uploadPath);
			} catch (FileNotFoundException e) {
				log.error("读取文件失败：",e);
			}
    	}
		return flag;
    }
	/**
	 * ftp上传文件
	 * @param filePathName
	 * @param uploadPath
	 * @return
	 * @throws Exception
	 */
    public boolean upload(String filePathName,String fileName,String uploadPath){
    	boolean flag = false;
    	if(Strings.isNotBlank(filePathName)){
    		flag = this.upload(new File(filePathName),fileName, uploadPath);
    	}
		return flag;
    }
    public static String showPathString(String... uploadPath){
    	String path = getRootPath();
    	for (int i = 0; i < uploadPath.length; i++) {
    		if(uploadPath[i].equals(File.separator))continue;
			if(!path.endsWith(File.separator) && !uploadPath[i].startsWith(File.separator)){
				uploadPath[i]=File.separator+uploadPath[i];
			}
			path+=uploadPath[i];
		}
    	if(!path.endsWith(File.separator)){
    		path+=File.separator;
    	}
		if(path.contains("/")){
			path =path.replaceAll("/", "\\\\");
		}
    	return path;
    	
    }
    public String[] listfileNames(String pathName){
    	if(this.ftpClient!=null && this.ftpClient.isConnected()){
    		try {
    			if(Strings.isBlank(pathName)){
    				return this.ftpClient.listNames();
    			}
    			return this.ftpClient.listNames(pathName);
			} catch (IOException e) {
				log.error("获取文件列表失败",e);
			}
    	}
		return null;
    }
    public FTPFile[] listfile(String pathName){
    	if(this.ftpClient!=null && this.ftpClient.isConnected()){
    		try {
    			if(Strings.isBlank(pathName)){
    				FTPFile[] files =  this.ftpClient.listFiles();
    			}
    			return this.ftpClient.listFiles(pathName);
    		} catch (IOException e) {
    			log.error("获取ftp文件列表异常",e);
    		}
    	}
		return null;
    }
    /** 
     * 
     * 下载FTP文件 
     * 当你需要下载FTP文件的时候，调用此方法 
     * 根据<b>获取的文件名，本地地址，远程地址</b>进行下载 
     * 
     * @param ftpFile 
     * @param relativeLocalPath 
     * @param relativeRemotePath 
     */ 
    public  void downloadFile(FTPFile ftpFile, String relativeLocalPath,String relativeRemotePath) { 
        if (ftpFile.isFile()) {
            if (ftpFile.getName().indexOf("?") == -1) { 
                OutputStream outputStream = null; 
                try { 
                    File locaFile= new File(relativeLocalPath+ ftpFile.getName()); 
                    //判断文件是否存在，存在则返回 
                    if(locaFile.exists()){ 
                        return; 
                    }else{ 
                        outputStream = new FileOutputStream(relativeLocalPath+ ftpFile.getName()); 
                        this.ftpClient.retrieveFile(ftpFile.getName(), outputStream); 
                        outputStream.flush(); 
                        outputStream.close(); 
                    } 
                } catch (Exception e) { 
                    log.error(e);
                } finally { 
                    try { 
                        if (outputStream != null){ 
                            outputStream.close(); 
                        }
                    } catch (IOException e) { 
                       log.error("输出文件流异常"); 
                    } 
                } 
            } 
        } else { 
            String newlocalRelatePath = relativeLocalPath + ftpFile.getName(); 
            String newRemote = new String(relativeRemotePath+ ftpFile.getName().toString()); 
            File fl = new File(newlocalRelatePath); 
            if (!fl.exists()) { 
                fl.mkdirs(); 
            } 
            try { 
                newlocalRelatePath = newlocalRelatePath + '/'; 
                newRemote = newRemote + "/"; 
                String currentWorkDir = ftpFile.getName().toString(); 
                boolean changedir = ftpClient.changeWorkingDirectory(currentWorkDir); 
                if (changedir) { 
                    FTPFile[] files = null; 
                    files = ftpClient.listFiles(); 
                    for (int i = 0; i < files.length; i++) { 
                        downloadFile(files[i], newlocalRelatePath, newRemote); 
                    } 
                } 
                if (changedir){
                    ftpClient.changeToParentDirectory(); 
                } 
            } catch (Exception e) { 
                log.error(e);
            } 
        } 
    } 

    public static String getRootPath(){
    	if(rootPath.contains("/")){
    		rootPath =rootPath.replaceAll("/", "\\\\");
    	}
    	return rootPath;
    }

    public static void main(String[] args) {
		String pathName =showPathString("weqwewqe","qweqweqw","5555","eeeee");
		System.out.println(pathName);
	}
}
