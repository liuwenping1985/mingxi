package com.seeyon.apps.kdXdtzXc;

import org.apache.axis2.client.Options;
import org.apache.axis2.rpc.client.RPCServiceClient;

/**
 * Created by tap-pcng43 on 2017-8-18.
 */
public class Test {



    public void sys() throws Exception {

        RPCServiceClient serviceClient = new RPCServiceClient();
        Options options = serviceClient.getOptions();
             String returnMessage = "";

/**
                EndpointReference targetEPR = new EndpointReference("http://10.0.64.30:9080/uapws/service/nc.itf.gl.pub.IBasicFilePub?wsdl");
                options.setTo(targetEPR);
                options.setAction(orgBean.getNameSpaceUrl() + "/" + "OrgParse");
//                if (orgBean.getNeedSoapAction()) { // 是否需要soap action
//
//                }
                serviceClient.setOptions(options); // 设置option
                QName qName = new QName(orgBean.getNameSpaceUrl(), "OrgParse");

                if (needSetRPCParamName) {// 是否RPC调用指定参数名 (档案系统需要)
                    OMFactory factory = OMAbstractFactory.getOMFactory();
                    OMNamespace namespace = factory.createOMNamespace(orgBean.getNameSpaceUrl(), "");
                    OMElement method = factory.createOMElement("OrgParse", namespace);

                    OMElement orgXmlElement = factory.createOMElement("orgXml", namespace);
                    orgXmlElement.setText(String.valueOf(xml));
                    method.addChild(orgXmlElement);

                    OMElement resultElement = serviceClient.sendReceive(method);
                    returnMessage = resultElement.toString();
                } else {
                    Object[] args = new Object[] { xml }; // 指定 方法的参数值
                    Class[] classes = new Class[] { String.class }; // 指定Integer方法返回值的数据类型的Class对象
                    returnMessage = (String) serviceClient.invokeBlocking(qName, args, classes)[0];
                }
                returnMessage = "同步机构处理结果==>" + returnMessage;
                LOGGER.info(returnMessage);
            } catch (Exception e) {
                returnMessage = "同步机构处理出错==>" + e.getMessage();
                LOGGER.error(returnMessage);
            }
            returnMap.put(sysName, returnMessage);**/

    }
}
