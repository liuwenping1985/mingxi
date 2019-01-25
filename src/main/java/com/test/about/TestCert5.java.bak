//package com.test.about;
//
//import com.test.uitl.CommonUtil;
//import net.sf.json.JSONObject;
//import org.apache.commons.httpclient.HttpStatus;
//import org.apache.http.HttpResponse;
//import org.apache.http.client.methods.HttpPost;
//import org.apache.http.entity.StringEntity;
//import org.apache.http.impl.client.DefaultHttpClient;
//import org.apache.http.util.EntityUtils;
//
///**
// * 申请证书
// * @author fengxiangzi
// *
// */
//public class TestCert5 {
//
//	public static void main(String[] args) {
//		String url="http://testyqt.easysign.cn:8028/APIService/MuCA/ApplyCertOrServlet";
//
////		Log4jLoader.loadLog4j();
//
//		/**TestCert.java
//		 * JSON请求
//		 */
//		httpostJson(url);
//	}
//
//
//
//
//	/**
//	 * JSON 数据请求
//	 */
//	public  static String httpostJson(String url){
//		  String json=showReqJson_geren();
////		  String json=showReqJson_qiye();
//		  JSONObject obj = JSONObject.fromObject(json);
//		  String result=doPost(url, obj);
//
//		  return result;
//	}
//
//	/**
//	 * JSON 数据源
//	 * @return
//	 */
//	public static String showReqJson_qiye(){
//		String certType="0";//1个人  0企业
//		String certModel="0";//0短期证书  1长期证书
//		String custName=CommonUtil.base64EncodeString("中科联中科", "UTF-8");
//		String identType="8";
//		String identNo="73346586-X";
//		String validity="1";
//		String keyAlg="rsa";
//		String certPass="123456";
//		String projectID="9Z+XL9zdU7eZz9BEILR9Fg==";
//		String username="";
//		String password="";
//		String versions="1.0";
//		String authenticate="1";
//		String email="378631288@qq.com";
//		String telphone="15211005868";
//		String address="";
//		String org=CommonUtil.base64EncodeString("中联重科", "UTF-8");
//		String unit="";
//		String country="";
//		String province="";
//		String city="";
//		String postcode="";
//		String str=getJsonData(certType, certModel, custName, identType, identNo,
//				validity, keyAlg, certPass, projectID,
//				username, password, versions, authenticate,
//				email, telphone, address, org, unit, country,
//				province, city, postcode);
//		return str;
//
//	}
//
//	/**
//	 * JSON 个人证书申请
//	 * @return
//	 */
//	public static String showReqJson_geren(){
//		String certType="1";//1个人  0企业
//		String certModel="0";//0短期证书  1长期证书
//		String custName=CommonUtil.base64EncodeString("张秦", "UTF-8");
//		String identType="0";
//		String identNo="421232198902260156";
//		String validity="1";
//		String keyAlg="rsa";
//		String certPass="123456";
//		String projectID="";
//		String username="UnIDEttdMDkY";
//		String password="cdb2748027bd0997b07d1a02a568e0f8";
//		String versions="1.0";
//		String authenticate="1";
//		String email="378631288@qq.com";
//		String telphone="15211005868";
//		String address="";
//		String org="";
//		String unit="";
//		String country="";
//		String province="";
//		String city="";
//		String postcode="";
//		String str=getJsonData(certType, certModel, custName, identType, identNo,
//				validity, keyAlg, certPass, projectID,
//				username, password, versions, authenticate,
//				email, telphone, address, org, unit, country,
//				province, city, postcode);
//		return str;
//
//	}
//
//	  /**
//     * JSON post请求
//     * @param url
//     * @param json
//     * @return
//     */
//    public static String doPost(String url,JSONObject json){
//      DefaultHttpClient client = new DefaultHttpClient();
//      HttpPost post = new HttpPost(url);
//      String result="";
//      try {
//        StringEntity s = new StringEntity(json.toString(),"UTF-8");// 中文乱码在此解决
//        s.setContentEncoding("UTF-8");
//        s.setContentType("application/json");//发送json数据需要设置contentType
//        post.setEntity(s);
//        HttpResponse res = client.execute(post);
//        System.out.println(res.getStatusLine().getStatusCode());
//        if(res.getStatusLine().getStatusCode() == HttpStatus.SC_OK){
//          result = EntityUtils.toString(res.getEntity());// 返回json格式：
//        }
//      } catch (Exception e) {
//        throw new RuntimeException(e);
//      }
//      System.out.println("responseString:"+result);
//      return result;
//    }
//
//
//	/**
//	 * 拼接JSON数据
//	 * @param certType
//	 * @param certModel
//	 * @param custName
//	 * @param identType
//	 * @param identNo
//	 * @param validity
//	 * @param keyAlg
//	 * @param certPass
//	 * @param projectID
//	 * @param username
//	 * @param password
//	 * @param versions
//	 * @param authenticate
//	 * @param email
//	 * @param telphone
//	 * @param address
//	 * @param org
//	 * @param unit
//	 * @param country
//	 * @param province
//	 * @param city
//	 * @param postcode
//	 * @return
//	 */
//	public static String getJsonData(String certType,String certModel,String
//			custName,String identType,String identNo,String validity,String keyAlg,String certPass
//			,String projectID,String username,String password,String versions,String authenticate
//			,String email,String telphone,String address,String org,String unit,String country,String province,
//			String city,String postcode){
//		String query =
//				"{\"required\": "
//				    + " [{\"certType\": \""+certType+"\","
//				    + "\"certModel\": \""+certModel+"\","
//				    + "\"custName\": \""+custName+"\","
//				    + "\"identType\": \""+identType+"\","
//				    + "\"identNo\": \""+identNo+"\","
//				    + "\"validity\": \""+validity+"\","
//				    + "\"keyAlg\": \""+keyAlg+"\","
//				    + "\"certPass\": \""+certPass+"\","
//				    + "\"projectID\": \""+projectID+"\","
//				    + "\"username\": \""+username+"\","
//				    + "\"password\": \""+password+"\","
//				    + "\"versions\": \""+versions+"\","
//				    + "\"authenticate\": \""+authenticate+"\" }],"
//			   + "\"optional\": [{\"email\": \""+email+"\","
//			   		+ "\"telphone\": \""+telphone+"\","
//			   		+ "\"address\":  \""+address+"\","
//			   		+ "\"org\": \""+org+"\","
//			   		+ "\"unit\": \""+unit+"\","
//			   		+ "\"country\": \""+country+"\","
//			   		+ "\"province\": \""+province+"\","
//			   		+ "\"city\": \""+city+"\","
//			   		+ "\"postcode\": \""+postcode+"\"}]}";
//
//			return query;
//
//	}
//
//}
