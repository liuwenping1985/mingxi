package com.seeyon.ctp.common.encrypt;

import java.io.InputStream;
import java.io.OutputStream;

public interface ICoder {
  final String V01_TEXT = "seeyon attachment encrypt v01";
  final String V02_TEXT = "seeyon attachment encrypt v02";
  final String VERSON01 = "V01";
  final String VERSON02 = "V02";
  int BUFFER_LEN = 8192;

  public void initKey(String key);
  public void encode(InputStream in,OutputStream out) throws CoderException;
  public void decode(InputStream in,OutputStream out) throws CoderException;
  public String decodeStr(byte[] buffer) throws CoderException;
}