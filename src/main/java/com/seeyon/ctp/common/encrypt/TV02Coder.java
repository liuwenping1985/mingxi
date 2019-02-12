package com.seeyon.ctp.common.encrypt;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class TV02Coder implements ICoder {
  private String key;
  
  private static final Log log = LogFactory.getLog(TV02Coder.class);
  private static String TV02LITE = "Tv02Lite00000000";
  public TV02Coder() {
  }

  public void initKey(String key) {
    this.key = key;
  }

  public void encode(InputStream in, OutputStream out) throws CoderException {
    byte[] temp1;
    int count = 0;
    try{
      temp1 = (V02_TEXT + TV02LITE).getBytes("ISO-8859-1");
      out.write(temp1,0,temp1.length);
      out.flush();
      this.xorStream(in,out,true);
    }catch(Throwable e){
    	log.error("使用v02加密算法时出现错误", e);
      throw new CoderException("使用v02加密算法时出现错误",e);
    }
  }

  public void decode(InputStream in, OutputStream out) throws CoderException {
    try{
      this.xorStream(in,out,false);
    }catch(Exception e){
    	if(!"ClientAbortException".equals(e.getClass().getSimpleName())){
    		log.error("使用v02解密算法时出现错误", e);
    		throw new CoderException("使用v02解密算法时出现错误",e);
    	}
    }
  }

  private void xorStream(InputStream in,OutputStream out,boolean isEncode) throws IOException{
    BufferedInputStream bis = new BufferedInputStream(in);
    BufferedOutputStream bos = new BufferedOutputStream(out);
    boolean isNewVersion = true;
    byte[] temp = new byte[BUFFER_LEN];
    byte[] temp1;    
    temp1 = key.getBytes("ISO-8859-1");
    int len = temp1.length;    
    int times = 0;
    int count = 0;    
    // 解密要读文件头
    byte[] t = new byte[TV02LITE.getBytes("ISO-8859-1").length];
    if(!isEncode){
	    in.read(t);
	    String head = new String(t);
	    count = t.length;
	    // 补偿，否则丢弃
	    if(!TV02LITE.equals(head)){
	        for (int i = 0; i < count; i++) {
		          t[i] = (byte) (t[i] ^ temp1[i%len]);
		    }
	        isNewVersion = false;
	        bos.write(t, 0, count);	  
	    }
    }
    while (count >= 0) {
      count = bis.read(temp);
      if (count > 0) {
		times++;
		// 新版只加密100个缓冲区大小(8192*100)
		if ( (times < 100) || !isNewVersion) {
			for (int i = 0; i < count; i++) {
				temp[i] = (byte) (temp[i] ^ temp1[i % len]);
			}
		}
		bos.write(temp, 0, count);
      }
    }
    bis.close();
    bos.close();
  }
  
	public String decodeStr(byte[] buffer) throws CoderException {
		if (buffer == null || buffer.length == 0)
			return "";
		boolean isNewVersion = true;
		try {
			if (buffer.length > 16) {
				byte[] bytes = TV02LITE.getBytes("ISO-8859-1");
				for (int i = 0; i < bytes.length; i++) {
					if (bytes[i] != buffer[i]) {
						isNewVersion = false;
						break;
					}
				}
			}
		} catch (Exception e) {
			log.error("使用v02解密算法时出现错误", e);
			throw new CoderException("使用v02解密算法时出现错误", e);
		}
		
		if (!isNewVersion) {
			return decodeStr1(buffer);
		} else {
			ByteArrayInputStream in = new ByteArrayInputStream(buffer);
			ByteArrayOutputStream out = new ByteArrayOutputStream();
			String result = "";
			try {
				this.xorStream(in, out, false);
				result = out.toString();
				in.close();
				out.close();

			} catch (Exception e) {
				log.error("使用v02解密算法时出现错误", e);
				throw new CoderException("使用v02解密算法时出现错误", e);
			}
			return result;
		}
	}
  private String decodeStr1(byte[] buffer) throws CoderException{
	  if(buffer == null || buffer.length == 0)
		  return "";
	  byte[] temp = new byte[buffer.length];
	  try {
		  byte[] temp1 = key.getBytes("ISO-8859-1");
		  int len = temp1.length;
		  for (int i=0;i<buffer.length;i++) {
		      temp[i] = (byte) (buffer[i] ^ temp1[i%len]);
		  }
		  return new String(temp);
	  }catch(Throwable e) {
		  log.error("使用v02解密算法时出现错误",e);
		  throw new CoderException("使用v02解密算法时出现错误",e);
	  }
  }	
}
