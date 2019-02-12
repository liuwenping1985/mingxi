package com.seeyon.apps.dev.doc.utils;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.oainterface.impl.exportdata.FileDownloadExporter;

public class FileExporter extends Thread{


	private static final Log log = LogFactory.getLog(FileExporter.class);	
	public static String  fileToString(PipedInputStream pis) throws IOException{
//		FileInputStream fps = new FileInputStream("d:\\fujian111.xml");
        BufferedInputStream  input=new BufferedInputStream(pis);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        int cc=0;
        while((cc=input.read())!=-1)
        {
        	out.write(cc);
        }
        byte[]  bytearr = out.toByteArray();
        out.flush();
        out.close();
		BASE64Encoder encoder = new BASE64Encoder();
		String code = encoder.encodeBuffer(bytearr);
		return code;
	}	
	public static String  file2BASE64CodeString(File file) throws IOException{
		FileInputStream fps = new FileInputStream(file);
        BufferedInputStream  input=new BufferedInputStream(fps);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        int cc=0;
        while((cc=input.read())!=-1)
        {
        	out.write(cc);
        }
        byte[]  bytearr = out.toByteArray();
        out.flush();
        out.close();
		BASE64Encoder encoder = new BASE64Encoder();
		String code = encoder.encodeBuffer(bytearr);
		return code;
	}

	public static void StringToFile(String fileStr) throws IOException{
		BASE64Decoder decoder = new BASE64Decoder();
		File file = new File("d:\\fujian123.xml");
		FileOutputStream out = new FileOutputStream(file);
		BufferedOutputStream  ous = new BufferedOutputStream(out);
		byte[] bs = decoder.decodeBuffer(fileStr);
		ous.write(bs);
		ous.flush();
		ous.close();
	}
	public static InputStream downloadFileToOutputStream(final Long fileId) throws Exception{
		PipedInputStream in = new PipedInputStream();  
	    final PipedOutputStream out = new PipedOutputStream(in);  

		try {
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					try {
						FileDownloadExporter exporter = new FileDownloadExporter();
						exporter.processDownload(fileId.toString() + "", out);
						out.close();
					} catch (Exception e) {
						log.error("",e);
					} 
					
				}
			}
		).start();

		} catch (Exception e) {
			log.error("下载文件失败：", e);
			throw e;
		}
	
		return in;
	}
	
	public static void main(String[] args) {
		System.out.println(AppContext.getCfgHome());
	}
}
