

/**
 * MessageServiceTest.java
 * <p>
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.4.1  Built on : Aug 13, 2008 (05:03:35 LKT)
 */
package com.seeyon.apps.kdXdtzXc.oawsclient;

    /*
     *  MessageServiceTest Junit test case
    */

import com.seeyon.apps.kdXdtzXc.KimdeConstant;
import com.seeyon.apps.kdXdtzXc.util.Axis2ConfigurationContextUtil;

public class MessageServiceTest {


    /**
     * Auto generated test method
     */
    public void testsendMessageByUserId() throws Exception {

        MessageServiceStub stub =
                new MessageServiceStub();//the default implementation should point to the right endpoint

        MessageServiceStub.SendMessageByUserId sendMessageByUserId8 =
                (MessageServiceStub.SendMessageByUserId) getTestObject(MessageServiceStub.SendMessageByUserId.class);
        // TODO : Fill in the sendMessageByUserId8 here

        stub.sendMessageByUserId(
                sendMessageByUserId8);


    }

    /**
     * Auto generated test method
     */
    public void testStartsendMessageByUserId() throws Exception {
        MessageServiceStub stub = new MessageServiceStub();
        MessageServiceStub.SendMessageByUserId sendMessageByUserId8 =
                (MessageServiceStub.SendMessageByUserId) getTestObject(MessageServiceStub.SendMessageByUserId.class);
        // TODO : Fill in the sendMessageByUserId8 here


        stub.startsendMessageByUserId(
                sendMessageByUserId8,
                new tempCallbackN1000C()
        );


    }

    private class tempCallbackN1000C extends MessageServiceCallbackHandler {
        public tempCallbackN1000C() {
            super(null);
        }

        public void receiveResultsendMessageByUserId(
                MessageServiceStub.SendMessageByUserIdResponse result
        ) {

        }

        public void receiveErrorsendMessageByUserId(Exception e) {

        }

    }

    public static String getTokenId() throws Exception {
        AuthorityServiceStub stub = new AuthorityServiceStub(Axis2ConfigurationContextUtil.getConfigurationContext());

        AuthorityServiceStub.Authenticate au = new AuthorityServiceStub.Authenticate();
        au.setUserName("service-admin");
        au.setPassword("Aa123456");
        AuthorityServiceStub.AuthenticateResponse resp = stub.authenticate(au);

        AuthorityServiceStub.UserToken token = resp.get_return();
        stub.cleanup();
        return token.getId();
    }

    /**
     * Auto generated test method
     */
    public void testsendMessageByLoginName() throws Exception {

        MessageServiceStub stub =
                new MessageServiceStub();

        MessageServiceStub.SendMessageByLoginName sendMessageByLoginName10 =
                (MessageServiceStub.SendMessageByLoginName) getTestObject(MessageServiceStub.SendMessageByLoginName.class);
        String token = getTokenId();
        System.out.println("token==" + token);
        sendMessageByLoginName10.setContent("OOOOOOOOOOOOOO88888");
        sendMessageByLoginName10.setLoginNames(new String[]{"zhangsan"});
        sendMessageByLoginName10.setToken(token);
        sendMessageByLoginName10.setUrl(new String[]{"http://www.baidu.com"});
        MessageServiceStub.SendMessageByLoginNameResponse res= stub.sendMessageByLoginName(
                sendMessageByLoginName10);
       MessageServiceStub.ServiceResponse rest= res.get_return();
        System.out.println(rest.getErrorMessage());
        System.out.println(rest.getErrorNumber());
        System.out.println(rest.getResult());


    }

    public static void main(String[] args) {
        MessageServiceTest m=new MessageServiceTest();
        try {
            m.testsendMessageByLoginName();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Auto generated test method
     */
    public void testStartsendMessageByLoginName() throws Exception {
        MessageServiceStub stub = new MessageServiceStub();
        MessageServiceStub.SendMessageByLoginName sendMessageByLoginName10 =
                (MessageServiceStub.SendMessageByLoginName) getTestObject(MessageServiceStub.SendMessageByLoginName.class);
        // TODO : Fill in the sendMessageByLoginName10 here


        stub.startsendMessageByLoginName(
                sendMessageByLoginName10,
                new tempCallbackN10042()
        );


    }

    private class tempCallbackN10042 extends MessageServiceCallbackHandler {
        public tempCallbackN10042() {
            super(null);
        }

        public void receiveResultsendMessageByLoginName(
                MessageServiceStub.SendMessageByLoginNameResponse result
        ) {

        }

        public void receiveErrorsendMessageByLoginName(Exception e) {

        }

    }

    //Create an ADBBean and provide it as the test object
    public org.apache.axis2.databinding.ADBBean getTestObject(Class type) throws Exception {
        return (org.apache.axis2.databinding.ADBBean) type.newInstance();
    }


}
    