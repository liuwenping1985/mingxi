package com.seeyon.apps.kdXdtzXc;

import com.seeyon.apps.kdXdtzXc.base.bean.BaseProp;
import com.seeyon.apps.kdXdtzXc.base.manager.FormTableService;
import com.seeyon.apps.kdXdtzXc.base.util.SqlUtil;
import com.seeyon.apps.kdXdtzXc.javabean.UrlBean;
import com.seeyon.ctp.common.AppContext;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by taoan on 2017-1-15.
 */
public class KimdeConstant {
    //不进行自动处理的数据
    public static List<String> NOT_PARSE_AUTO = new ArrayList<String>();
    public static final String need_context_str = "/seeyon/";
    public static final String MAPPER_MANAGER = "kimdeMapperManager";
    public static final String FORM_MAIN_TABLE = "kimdeFormMainTable";
    public static final String FORM_TABLE_SERVICE = "kimdeFormTableService";
    public static final String URLBEAN = "urlBean";
    public static FormTableService formTableService = (FormTableService) AppContext.getBean(FORM_TABLE_SERVICE);
    public static UrlBean urlBean = getUrlBean();
    public static BaseProp baseProp = getBaseProp();


    public static UrlBean getUrlBean() {
        return (UrlBean) AppContext.getBean(URLBEAN);
    }

    public static BaseProp getBaseProp() {
        return (BaseProp) AppContext.getBean("baseProp");
    }

    //    是否跳过线程运行

    public static Integer default_int = -2;
    public static String SSO_FROM_NOFORWARD = "KIMDE_SSO_NOFORWARD";
    public static String SSO_FROM_FORWARD = "KIMDE_SSO_FORWARD";

    public static String param_user = "user";
    public static String param_ticket = "code";// 随机数，不是oa真实ticket
    public static String param_viewCode = "viewCode";

    public static Integer default_create_by = 1;
    public static Boolean checkThread = true;
    //    yyyy-MM-dd HH:mm:ss


    public static String NC_USER = "admin";
    public static String NC_PASSWORD = "blf123!@#";

    public static String WS_USERNAME = "service-admin";
    public static String WS_PASSWORD = "Aa123456";

    public static String REST_USERNAME = "";
    public static String REST_PASSWORD = "";
//    public static String NC_URL = "http://10.0.64.30:9080";

    //    public static String NC_URL = "http://10.0.110.132:9080";
    public static String OA_URL = baseProp.getPropMap().get("oa_url");
//    http://10.0.64.30:9080/uapws/service/nc.itf.gl.pub.IBasicFilePub?wsdl


//    http://10.0.110.42/uapws/service/nc.itf.gl.pub.IBasicFilePub?wsdl
//    http://10.0.110.132:9080/uapws/service/nc.itf.gl.pub.IBasicFilePub?wsdl
//    http://oa.corp.bianlifeng.com:9080/uapws/service/nc.itf.gl.pub.IBasicFilePub?wsdl

}
