package com.seeyon.ctp.common.encrypt;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.io.IOUtils;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.config.IConfigPublicKey;
import com.seeyon.ctp.common.config.SystemConfig;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.util.Strings;


public class CoderFactory {
  private final String KEY = "62C20D8F29A243D3";
  private final static CoderFactory factory = new CoderFactory();

  private CoderFactory() {
  }

  public static CoderFactory getInstance(){
    return factory;
  }
  
	/**
	 * 加密深度  
	 * 
	 * @return 轻度加密：{@link ICoder#VERSON01}；深度加密：{@link ICoder#VERSON02}；不加密：<code>no</code>
	 */
	public String getEncryptVersion() {
		String encryptVersion = null;
		
		SystemConfig systemConfig = (SystemConfig) AppContext.getBean("systemConfig");
		String configItem = systemConfig.get(IConfigPublicKey.ATTACH_ENCRYPT);

		if (configItem != null && !IConfigPublicKey.NO.equals(configItem)) {
			if (IConfigPublicKey.MIDDLE.equals(configItem)) {
				encryptVersion = ICoder.VERSON02;
			}
			else {
				encryptVersion = ICoder.VERSON01;
			}
		}
		else {
			encryptVersion = "no";
		}

		return encryptVersion;
	}

  public void download(InputStream in,OutputStream out) throws Exception{
    byte[] temp = new byte[ICoder.V01_TEXT.getBytes("ISO-8859-1").length];
    int count = in.read(temp);
    String head = new String(temp);
    if(ICoder.V01_TEXT.equals(head)){
      ICoder code = new TV01Coder();
      code.initKey(KEY);
      code.decode(in,out);
    }else if(ICoder.V02_TEXT.equals(head)){
      ICoder code = new TV02Coder();
      code.initKey(KEY);
      code.decode(in,out);
    }else{
	  if(count>0){
		out.write(temp);
	  }
      this.directOutput(in,out);
    }
  }
  
  public String download(byte[] buffer) throws Exception{
	  byte[] temp = new byte[ICoder.V01_TEXT.getBytes("ISO-8859-1").length];
		if (buffer.length - temp.length > 0) {
			byte[] temp1 = new byte[buffer.length - temp.length];
			System.arraycopy(buffer, 0, temp, 0, temp.length);
			System.arraycopy(buffer, temp.length, temp1, 0, temp1.length);
			String head = new String(temp);
			if (ICoder.V01_TEXT.equals(head)) {
				ICoder code = new TV01Coder();
				code.initKey(KEY);
				return code.decodeStr(temp1);
			}
			else if (ICoder.V02_TEXT.equals(head)) {
				ICoder code = new TV02Coder();
				code.initKey(KEY);
				return code.decodeStr(temp1);
			}
		}
		return new String(buffer);
  }

  public void upload(InputStream in,OutputStream out,String version) throws Exception {
    Class coderClass = Class.forName("com.seeyon.ctp.common.encrypt.T"+version.toUpperCase()+"Coder");
    ICoder coder = (ICoder)coderClass.newInstance();
    coder.initKey(KEY);
    coder.encode(in,out);
  }

  public String getFileToString(String realPath) throws Exception{
    FileInputStream fis = new FileInputStream(realPath);
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    this.download(fis,baos);
    fis.close();
    ByteArrayInputStream bis = new ByteArrayInputStream(baos.toByteArray());
    String encoding = com.seeyon.ctp.util.FileUtil.detectEncoding(bis);
    if(encoding!=null){        
        if ("KOI8-R".equalsIgnoreCase(encoding) || "WINDOWS-1252".equals(encoding) || "IBM855".equals(encoding)) {
            return baos.toString("GB18030");
        }
        return baos.toString(encoding);
    }else{
        return baos.toString();
    }
  }

  private void directOutput(InputStream in,OutputStream out) throws Exception {
    int count = 0;
    byte[] temp = new byte[ICoder.BUFFER_LEN];
    while(count>=0){
      count = in.read(temp);
      if(count>0)
        out.write(temp,0,count);
    }
    in.close();
    out.close();
  }

  

	/**
	 * 把系统文件解密到临时文件夹
	 * 
	 * @param srcFile
	 *            要解密的文件绝对路径
	 * @return 解密后的文件绝对路径，注意：如果改文件没有加密，直接返回原文件路径
	 * @throws Exception
	 */
	public String decryptFileToTemp(String srcFilePath) throws Exception {
	    return decryptFileToTemp(new File(srcFilePath)).getAbsolutePath();
	}
	
	//key: 文件路径
	private Map<String, Object> fileLocks = new ConcurrentHashMap<String, Object>();
	private Object dLock = new Object();
    public File decryptFileToTemp(File srcFile) throws Exception {
	    if(!srcFile.exists()){
	        return srcFile;
	    }

        String dectFilePath;
        Long fileId;
        V3XFile file = null;
        FileManager fileManager=(FileManager) AppContext.getBean("fileManager");
        if (srcFile.getName().indexOf("D") != -1) {
            String fileName = srcFile.getName().substring(0, srcFile.getName().indexOf("D"));
            dectFilePath = SystemEnvironment.getSystemTempFolder() + File.separator + srcFile.getName() + "D" + srcFile.lastModified();
            if(Strings.isDigits(srcFile.getName())){
            	fileId = Long.parseLong(fileName);
            	file = fileManager.getV3XFile(fileId);
            }
        } else {
            dectFilePath = SystemEnvironment.getSystemTempFolder() + File.separator + srcFile.getName() + "D" + srcFile.lastModified();
            if(Strings.isDigits(srcFile.getName())){
            	fileId = Long.parseLong(srcFile.getName());
            	file = fileManager.getV3XFile(fileId);
            }
        }

		if(file!=null){
			if(file.getFilename()!=null&&
					file.getFilename().toLowerCase().endsWith(".doc")
							||file.getFilename().toLowerCase().endsWith(".docx")){
				dectFilePath+=".doc";
			}
		}
		File dectFile = new File(dectFilePath);
        if(dectFile.exists()){
            return dectFile;
        }
        
		Object fileLock = null;
		synchronized (dLock) {
    		fileLock = fileLocks.get(dectFilePath);
    		if(fileLock == null){
    		    fileLock = new Object();
    		    fileLocks.put(dectFilePath, fileLock);
    		}
		}
		
		synchronized (fileLock) {
    		if(dectFile.exists()){
    		    return dectFile;
    		}
    		
    		InputStream in = null;
    		OutputStream out = null;
    		try {
    			in = new FileInputStream(srcFile);
    			byte[] temp = new byte[ICoder.V01_TEXT.getBytes("ISO-8859-1").length];
    			in.read(temp);
    			String head = new String(temp);
    			if (ICoder.V01_TEXT.equals(head)) {
    
    				out = new FileOutputStream(dectFile);
    
    				ICoder code = new TV01Coder();
    				code.initKey(KEY);
    				code.decode(in, out);
    
    				return dectFile;
    			}
    			else if (ICoder.V02_TEXT.equals(head)) {
    
    				out = new FileOutputStream(dectFile);
    
    				ICoder code = new TV02Coder();
    				code.initKey(KEY);
    				code.decode(in, out);
    
    				return dectFile;
    			}
    			else { //没有加密，直接返回源文件
    				//永中插件要求.doc和.docx的文件要做特殊处理
    				if(file!=null){
    					if(file.getFilename()!=null&&
    							file.getFilename().toLowerCase().endsWith(".doc")
    									||file.getFilename().toLowerCase().endsWith(".docx")){
    						dectFilePath+=".doc";
    						File fileex=new File(dectFilePath);
				   	        FileOutputStream fop = new FileOutputStream(fileex); 
				            FileInputStream fin=new FileInputStream(srcFile);
				            CoderFactory.getInstance().download(fin, fop);
				            fop.flush();
				            fop.close();
				            return fileex;
    					}else{
    						return srcFile;
    					}
					}else{
						return srcFile;
					}
    			}
    		}
    		catch (Exception e) {
    			throw e;
    		}
    		finally {
    		    fileLocks.remove(dectFilePath);
    		    
    			IOUtils.closeQuietly(in);
    			IOUtils.closeQuietly(out);
    		}
		}
	}

	/**
	 * 将指定文件加密后放在指定的地方
	 * 
	 * @param srcFile 要加密的文件
	 * @param dectFile 加密后新文件存放路径
	 * @throws Exception
	 */
	public void encryptFile(String srcFile, String dectFile) throws Exception {
		InputStream in = null;
		OutputStream out = null;
		try {
			in = new FileInputStream(srcFile);
			out = new FileOutputStream(dectFile);

			String encryptVersion = getEncryptVersion();
			
			if("no".equals(encryptVersion)){ //不需要加密
				IOUtils.copy(in, out);
			}
			else{
				this.upload(in, out, encryptVersion);
			}
		}
		catch (Exception e) {
			throw e;
		}
		finally {
			IOUtils.closeQuietly(in);
			IOUtils.closeQuietly(out);
		}
	}
}
