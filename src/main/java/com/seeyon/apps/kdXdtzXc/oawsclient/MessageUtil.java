package com.seeyon.apps.kdXdtzXc.oawsclient;

import com.seeyon.apps.kdXdtzXc.util.Axis2ConfigurationContextUtil;

/**
 * Created by tap-pcng43 on 2017-12-18.
 */
public class MessageUtil {
    public static MessageServiceStub.ServiceResponse sendMessage(String loginName, String content, String url, String token) throws Exception {
        MessageServiceStub serviceStub = new MessageServiceStub(Axis2ConfigurationContextUtil.getConfigurationContext());
        MessageServiceStub.SendMessageByLoginName sendMessageByLoginName2 = new MessageServiceStub.SendMessageByLoginName();
        sendMessageByLoginName2.setContent(content);
        sendMessageByLoginName2.setLoginNames(new String[]{loginName});
        sendMessageByLoginName2.setToken(token);
        sendMessageByLoginName2.setUrl(new String[]{url});
        MessageServiceStub.SendMessageByLoginNameResponse res = serviceStub.sendMessageByLoginName(sendMessageByLoginName2);
        MessageServiceStub.ServiceResponse result = res.get_return();
        return result;

    }
}
