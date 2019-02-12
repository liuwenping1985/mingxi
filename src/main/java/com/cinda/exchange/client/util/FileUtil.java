package com.cinda.exchange.client.util;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.czexchange.common.AuthorUtil;
import com.seeyon.ctp.common.AppContext;

public class FileUtil {

	private static final Log log = LogFactory.getLog(FileUtil.class);
	
	private String oaUrl = AppContext.getSystemProperty("internet.site.url");
	//删除下载的文件
	public static void removeFile(String path) {
		File file=new File(path);
		if (file.isDirectory()) {
			File[] child = file.listFiles();
			//if (child != null && child.length != 0) {
				for (int i = 0; i < child.length; i++) {
					removeFile(child[i].getPath());
					child[i].delete();
				}
			}
		//}
		file.delete();
	}
	
	public static String fileToString(File file){
		InputStream in = null;
		try {
			in = new FileInputStream(file);
		} catch (FileNotFoundException e) {
			log.error("", e);
			return "";
		}
		return inputStream2String(in);
	}
	
	public static void StringToFile(File file, String content){
		FileWriter fwriter = null;
		try {
				fwriter = new FileWriter(file);
				fwriter.write(content);
			 } catch (IOException ex) {
			  	log.error("", ex);
			 } finally {
				 try {
					 fwriter.flush();
					 fwriter.close();
				 	} catch (IOException ex) {
				 		log.error("", ex);
				 	}
			 }
	}
	


	public static String inputStream2String(InputStream is){
	   BufferedReader in = new BufferedReader(new InputStreamReader(is));
	   StringBuffer buffer = new StringBuffer();
	   String line = "";
	   try {
		while ((line = in.readLine()) != null){
		     buffer.append(line);
		   }
		} catch (IOException e) {
			log.error("", e);
		}
	   return buffer.toString();
	}
	
    private Long upLoadFile(byte[] bytes, String fileName) throws Exception{

    	Long fileId = null;

    	URL preUrl = null;
    	URLConnection uc = null;
    	String loginName = AppContext.getSystemProperty("czexchange.meetingExchageUser");
    	//不用管token了，token已经做了处理不需要校验
    	String token = AuthorUtil.getToken();

    	preUrl = new URL(oaUrl+"/seeyon/uploadService.do?method=processUploadService&senderLoginName="+loginName+"&token="+token);
    	uc = preUrl.openConnection();
    	HttpURLConnection hc = (HttpURLConnection) uc;
    	hc.setDoOutput(true);
    	hc.setUseCaches(false);
    	hc.setRequestProperty("contentType", "charset=utf-8");
    	hc.setRequestMethod("POST");

    	//根据文件真实路径获取文件
//    	BufferedInputStream input = new BufferedInputStream(byteStream);


    	String BOUNDARY = "---------------------------7d4a6d158c9"; // 分隔符
    	//真实的文件名称
    	StringBuffer sb = new StringBuffer();
    	sb.append("--");
    	sb.append(BOUNDARY);
    	sb.append("\r\n");
    	sb.append("Content-Disposition: form-data; \r\n name=\"1\"; filename=\""
    			+ fileName + "\"\r\n");
    	sb.append("Content-Type: application/msword\r\n\r\n");
    	hc.setRequestProperty("Content-Type", "multipart/form-data;boundary="
    			+ "---------------------------7d4a6d158c9");
    	byte[] end_data = ("\r\n--" + BOUNDARY + "--\r\n").getBytes();
    	DataOutputStream dos = new DataOutputStream(hc.getOutputStream());
    	dos.write(sb.toString().getBytes("utf-8"));
    	//			int cc = 0;
    	//			while ((cc = input.read()) != -1) {
    	//				
    	//			}
    	dos.write(bytes);
    	dos.write(end_data);
    	dos.flush();
    	dos.close();
//    	input.close();
    	InputStream is = hc.getInputStream();
    	if (is != null) {
    		StringBuilder resultBuffer = new StringBuilder();
    		String line = "";
    		BufferedReader reader = new BufferedReader(new InputStreamReader(is, "utf-8"));
    		while ((line = reader.readLine()) != null) {
    			resultBuffer.append(line);
    		}
    		reader.close();
    		is.close();
    		if(resultBuffer.toString().length() > 0){
    			log.info("fileId : " + resultBuffer.toString());
    			try {
    				fileId = Long.parseLong(resultBuffer.toString());
    			} catch(Exception ex) {
    				log.error(ex);
    			}
    		}
    	}
    	return fileId;
    }



}
