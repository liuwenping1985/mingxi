package com.seeyon.apps.kdXdtzXc.util;


import com.seeyon.apps.kdXdtzXc.KimdeConstant;
import com.seeyon.apps.kdXdtzXc.oawsclient.AuthorityServiceStub;

/**
 * Created by taoan on 2016-11-12.
 */
public class OaWebServiceUtil {



    /**
     * 获得认证信息
     *
     * @return
     * @throws Exception
     */
    public static String getTokenId() throws Exception {
        AuthorityServiceStub stub = new AuthorityServiceStub(Axis2ConfigurationContextUtil.getConfigurationContext());

        AuthorityServiceStub.Authenticate au = new AuthorityServiceStub.Authenticate();
        au.setUserName(KimdeConstant.WS_USERNAME);
        au.setPassword(KimdeConstant.WS_PASSWORD);
        AuthorityServiceStub.AuthenticateResponse resp = stub.authenticate(au);

        AuthorityServiceStub.UserToken token = resp.get_return();
        stub.cleanup();
        return token.getId();
    }
}
