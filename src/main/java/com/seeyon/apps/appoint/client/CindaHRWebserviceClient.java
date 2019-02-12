package com.seeyon.apps.appoint.client;

import com.alibaba.fastjson.JSONObject;
import java.net.URL;
import javax.xml.namespace.QName;
import javax.xml.rpc.ParameterMode;
import javax.xml.rpc.encoding.XMLType;
import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class CindaHRWebserviceClient
{
  public static final Log log = LogFactory.getLog(CindaHRWebserviceClient.class);
  public static final String hrRemoteUrl = "";
  public static final String hrNameSpaceUri = "";

  public static String pushEdoc(Object[] params)
  {
    Object result = null;
    log.info("start call : remoteUrl=,nameSpace=");
    try
    {
      Service service = new Service();
      Call call = (Call)service.createCall();

      call.setTargetEndpointAddress(new URL(""));
      call.setOperationName(new QName("", "getUserWorkTodoNum"));

      QName qn1 = new QName("", "getUserWorkTodoNum");
      call.addParameter("arg0", qn1, ParameterMode.IN);
      call.setReturnType(XMLType.XSD_INT);

      result = (Integer)call.invoke(params);
    }
    catch (Exception e) {
      log.error("调用人力资源接口出错", e);
    }

    log.info("调用人力资源接口返回值为：" + JSONObject.toJSONString(result));

    return JSONObject.toJSONString(result);
  }

  public static void main(String[] args)
  {
  }
}

