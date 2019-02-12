package com.seeyon.ctp.common.encrypt;

import java.io.InputStream;
import java.io.OutputStream;

import org.apache.commons.logging.Log;

import com.seeyon.ctp.common.log.CtpLogFactory;

import www.seeyon.docencode.TCoderUtils;

public class TV01Coder implements ICoder {

  private String key;
  
  private static final Log log = CtpLogFactory.getLog(TV01Coder.class);

  public TV01Coder() {
  }

  public void initKey(String key){
    this.key = key;
  }

  public void encode(InputStream in,OutputStream out) throws CoderException{
	 
    TCoderUtils utils = new TCoderUtils(this.key);
    try{
      byte[] temp = V01_TEXT.getBytes("ISO-8859-1");
      out.write(temp,0,temp.length);
      out.flush();
      utils.encodeStream(in, out);
      in.close();   
    }catch(Throwable e){
    	log.error("使用v01加密算法时出现错误", e);
      throw new CoderException("使用v01加密算法时出现错误",e);
    }
  }

  public void decode(InputStream in,OutputStream out) throws CoderException{
   TCoderUtils utils = new TCoderUtils(this.key);
   try{
     utils.decodeStream(in,out);
   }catch(Throwable e){
	   if(e.getCause() != null && !"ClientAbortException".equals(e.getCause().getClass().getSimpleName())){
		   log.error("使用v01解密算法时出现错误",e);
		   throw new CoderException("使用v01解密算法时出现错误",e);
	   }
   }
  }
  
  public String decodeStr(byte[] buffer) throws CoderException {
	  TCoderUtils utils = new TCoderUtils(this.key);
	  try {
		  return utils.decodeString(buffer);
	  }catch(Throwable e) {
		  log.error("使用v01解密算法时出现错误", e);
		  throw new CoderException("使用v01解密算法时出现错误",e);
	  }
  }
}
