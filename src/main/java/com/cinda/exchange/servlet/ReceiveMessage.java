package com.cinda.exchange.servlet;

import com.cinda.exchange.client.Client;
import com.cinda.exchange.client.util.ClientUtil;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

public class ReceiveMessage extends BaseController
{
  private static final Log log = LogFactory.getLog(ReceiveMessage.class);

  @NeedlessCheckLogin
  public ModelAndView index(HttpServletRequest request, HttpServletResponse response) {
    try { doPost(request, response);
    } catch (Exception e) {
      log.error("", e);
    }
    return null;
  }

  public void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException
  {
    String msg = receiveMsg(request);
    log.info("收到交换服务器请求：msg=" + msg);
    if ((msg == null) || (msg.indexOf("TYPE") == -1)) {
      log.info("无效消息，不进行处理。");
      response.getOutputStream().write("error=no type".getBytes());
      return;
    }

    String[] arr = msg.split(";");
    String type = arr[0].split("=")[1].trim();

    Client client = new Client(ClientUtil.jianhuanServer, ClientUtil.jianhuanPort);
    client.setTimeout(15000);

    if (type.equals("FILE")) {
      String ids = arr[1].split("=")[1];
      ids = ids.substring(1, ids.length() - 1);
      String[] msgId = ids.split(",");

      log.info("开始接收数据");

      String isok = "";

      for (int i = 0; i < msgId.length; i++) {
        boolean value = false;
        try {
          value = ClientUtil.receiveEdoc(client, msgId[i]);
        } catch (Exception e) {
          value = false;
          log.error("", e);
          throw new IOException(e);
        }
        if (value) {
          try {
            client.sendFlag(msgId[i], "OK");
          } catch (Exception e) {
            log.error("", e);
          }
        }
        isok = isok + value;
      }

      if ((!isok.contains("false")) && (!isok.equals("")))
        response.getOutputStream().write("TYPE=FILE;MSG=OK;".getBytes());
      else {
        response.getOutputStream().write("TYPE=FILE;MSG=fail;".getBytes());
      }

      log.info("接收数据完毕");
    }
    else if (type.equals("FLAG")) {
      String ids = arr[1].substring(1, arr[1].length() - 1);
      String[] msgInfos = ids.split(",");
      String tmp = "";
      for (int i = 0; i < msgInfos.length; i++) {
        String info = msgInfos[i];
        String key = info.split("=")[0];
        String value = info.split("=")[1];
        if ("OK".equals(value)) {
          ClientUtil.receiveReceipt(key);
          tmp = tmp + "," + key;
        }
        log.info("key==" + key + " ,value==" + value);
      }
      if (tmp.length() > 1) {
        tmp = tmp.substring(1);
      }
      String ret = "TYPE=FLAG;MSGID={" + tmp + "}";
      response.getOutputStream().write(ret.getBytes());

      log.info("接收回执完毕");
    }
  }

  private String receiveMsg(HttpServletRequest request)
    throws IOException
  {
    InputStreamReader bsr = null;
    BufferedReader br = null;

    StringBuffer buffer = new StringBuffer();
    try {
      InputStream in = request.getInputStream();
      log.info("接收到交换中心的调用：in.size=" + in.available());
      bsr = new InputStreamReader(in);
      br = new BufferedReader(bsr);

      String valueLine = null;
      while ((valueLine = br.readLine()) != null)
        buffer.append(valueLine);
    }
    catch (Exception ex) {
      log.error("", ex);
      throw new IOException(ex);
    } finally {
      if (br != null)
        try {
          br.close();
        }
        catch (Exception localException1) {
        }
      if (bsr != null)
        try {
          bsr.close();
        }
        catch (Exception localException2)
        {
        }
    }
    return buffer.toString();
  }
}
