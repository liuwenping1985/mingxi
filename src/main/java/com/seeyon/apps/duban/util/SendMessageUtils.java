package com.seeyon.apps.duban.util;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.seeyon.client.CTPRestClient;
import com.seeyon.client.CTPServiceClientManager;


public class SendMessageUtils {

    // 指定协议、IP和端口，获取ClientManager
    CTPServiceClientManager clientManager = CTPServiceClientManager.getInstance("http://127.0.0.1/");

    // 取得REST动态客户机实例
    CTPRestClient client = clientManager.getRestClient();

    //http://ip:port/seeyon/rest/message/userId

//	{
//		  "userIds": [11111,22222],/***接受人ID**/
//		  "sendUserId" : "3333",/***发起人用户ID;V5.6增加发起者登录名参数【senderLoginName】**/
//		  "content" : 我是消息内容,/***消息内容**/
//		  "url" : [],/***消息连接**/
//		}

    public static void sendMessage(long senderId,List<Long> userIds,String content,String url)
    {
        CTPServiceClientManager clientManager = CTPServiceClientManager.getInstance("http://127.0.0.1:80");
        //取得REST动态客户机。
        // client = clientManager.getRestClient();
        CTPRestClient client = clientManager.getRestClient();
        //登录校验,成功返回true,失败返回false,此过程并会把验证通过获取的token保存在缓存中
        //再请求访问其他资源时会自动把token放入请求header中。
        boolean isok = client.authenticate("dbuser", "123456");

        if (isok)
        {
            System.out.println("ok");
        }
        else
        {
            System.out.println("error");
        }


        Map params = new HashMap();
//        List<Long> aa = new ArrayList();
//        aa.add(userId);
        List<String> bb = new ArrayList();
        //bb.add("http://"+url+"&userid="+userId);
        params.put("userIds",userIds);

        //params.put("sendUserId", "-4795392682740790988");
        params.put("sendUserId", senderId+"");
        params.put("content",content);
        params.put("url",bb);
        //params.put("username", "txf");
        //params.put("password", "123456");
        String result = client.post("message/userId",params, String.class);

        System.out.println(result);
    }


//	public static void main(String[] args)
//	{
//		// 指定协议、IP和端口，获取ClientManager
//		CTPServiceClientManager clientManager = CTPServiceClientManager.getInstance("http://10.97.85.72:80");
//
//		// 取得REST动态客户机实例
//		CTPRestClient client = clientManager.getRestClient();
//		 Map params = new HashMap();
////		  params.put("userIds","-4795392682740790988");
////		  params.put("sendUserId", "-4795392682740790988");
////		  params.put("content","测试");
////		  params.put("url","");
//		 params.put("username", "txf");
//		 params.put("password", "123456");
//		  String result = client.post("rest/token",params, String.class);
//		  System.out.println(result);
//	}




//    public static void main(String[] args){
//        //取得指定服务主机的客户端管理器。
//        //参数为服务主机地址，包含{协议}{Ip}:{端口}，如http://127.0.0.1:8088
//        CTPServiceClientManager clientManager = CTPServiceClientManager.getInstance("http://10.97.85.72:80");
//      //取得REST动态客户机。
//       // client = clientManager.getRestClient();
//        CTPRestClient client = clientManager.getRestClient();
//        //登录校验,成功返回true,失败返回false,此过程并会把验证通过获取的token保存在缓存中
//        //再请求访问其他资源时会自动把token放入请求header中。
//        boolean isok = client.authenticate("txf", "123456");
//
//        if (isok)
//        {
//        	System.out.println("ok");
//        }
//        else
//        {
//        	System.out.println("error");
//        }
//
//
//        Map params = new HashMap();
//        List<Long> aa = new ArrayList();
//        aa.add(-4795392682740790988l);
//        List<String> bb = new ArrayList();
//        bb.add("www.sina.com");
//	  params.put("userIds",aa);
//	  params.put("sendUserId", "-4795392682740790988");
//	  params.put("content","档案系统测试");
//	  params.put("url",bb);
//	 //params.put("username", "txf");
//	 //params.put("password", "123456");
//	  String result = client.post("message/userId",params, String.class);
//
//	  System.out.println(result);
//  }

    public static void main(String[] args){
        //sendMessage(Long.valueOf("-4795392682740790988"),"22222");
    }
}




