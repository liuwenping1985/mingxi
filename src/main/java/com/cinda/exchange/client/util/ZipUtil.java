package com.cinda.exchange.client.util;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

public class ZipUtil {

	/**
	 * 解压接受到的文件
	 * @param zipFile 压缩文件
	 * @param outFilePath  解压到的路径
	 * @return boolean
	 */
	public static boolean unZip(String zipFile,String outFilePath){
		boolean flag = false;
		try{
			File file = new File(zipFile);
			String fileName = file.getName();
			outFilePath += File.separator+fileName.substring(0,fileName.length()-4)+File.separator;
			File tmpFileDir = new File(outFilePath);
			tmpFileDir.mkdirs();
			ZipFile zf = new ZipFile(zipFile);
			FileOutputStream fos;
			byte[] buf = new byte[1024];
			for(Enumeration em = zf.entries(); em.hasMoreElements();){
				ZipEntry ze = (ZipEntry) em.nextElement();
				if(ze.isDirectory()){
					continue;
				}
				DataInputStream dis = new DataInputStream(zf.getInputStream(ze) );
				String currentFileName = ze.getName();
				int dex = currentFileName.lastIndexOf('/');
				String currentoutFilePath = outFilePath;
				if(dex > 0){
					currentoutFilePath += currentFileName.substring(0,dex)+File.separator;
					File currentFileDir = new File(currentoutFilePath);
					currentFileDir.mkdirs();
				}
				fos = new FileOutputStream(outFilePath + ze.getName ( ));
				int readLen = 0;
				while((readLen = dis.read(buf,0,1024)) > 0 )	
				{
					fos.write(buf , 0 ,readLen);
				}
				dis.close();
				fos.close();
			}
			flag = true;
		}catch(Exception e){
			e.printStackTrace();
		}
		return flag;
	}
	
	public static void zipFile(File inFile, ZipOutputStream zos, String dir) throws IOException {
		if (inFile.isDirectory()) {
			File[] files = inFile.listFiles();
			for (File file:files)
				zipFile(file, zos, dir + "\\" + inFile.getName());
		} else {
			String entryName = null;
			if (!"".equals(dir))
				entryName = dir + "\\" + inFile.getName();
			else
				entryName = inFile.getName();
			ZipEntry entry = new ZipEntry(entryName);
			zos.putNextEntry(entry);
			InputStream is = new FileInputStream(inFile);
			int len = 0;
			while ((len = is.read()) != -1)
				zos.write(len);
			is.close();
		}

	}

}
