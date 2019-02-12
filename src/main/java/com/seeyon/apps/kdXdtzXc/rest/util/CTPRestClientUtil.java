package com.seeyon.apps.kdXdtzXc.rest.util;

 import com.seeyon.apps.kdXdtzXc.KimdeConstant;
 import com.seeyon.client.CTPRestClient;
import com.seeyon.client.CTPServiceClientManager;

/**
 * Created by taoan on 2017-1-15.
 */
public final class CTPRestClientUtil {
    private CTPRestClientUtil() {

    }


    public static CTPRestClient getCTPRestClient() {
        //取得指定服务主机的客户端管理器。
        //参数为服务主机地址，包含{协议}{Ip}:{端口}，如http://127.0.0.1:8088
        CTPServiceClientManager clientManager = CTPServiceClientManager.getInstance(KimdeConstant.OA_URL);
        //取得REST动态客户机。
        CTPRestClient client = clientManager.getRestClient();
        //登录校验,成功返回true,失败返回false,此过程并会把验证通过获取的token保存在缓存中
        //再请求访问其他资源时会自动把token放入请求header中。
        client.authenticate(KimdeConstant.REST_USERNAME, KimdeConstant.REST_PASSWORD);
         return client;
    }



}
