////
//// Source code recreated from a .class file by IntelliJ IDEA
//// (powered by Fernflower decompiler)
////
//
//package com.seeyon.sfu.client.system.security.manager;
//
//import com.seeyon.sfu.client.apps.dataclear.controller.SetController;
//import com.seeyon.sfu.client.apps.dataclear.dao.common.CollDBChecker;
//import com.seeyon.sfu.client.apps.index.enums.LinkConfigEnums;
//import com.seeyon.sfu.client.apps.index.manager.SettingCenterManager;
//import com.seeyon.sfu.client.apps.index.manager.SettingCenterManagerImpl;
//import com.seeyon.sfu.client.apps.login.manager.LoginManagerImpl;
//import com.seeyon.sfu.client.common.BaseController;
//import com.seeyon.sfu.client.system.security.common.LocalData;
//import com.seeyon.sfu.client.system.security.common.UserFactory;
//import com.seeyon.sfu.client.system.security.controller.LicenseCheckerController;
//import com.seeyon.sfu.client.system.security.enums.Modules;
//import com.seeyon.sfu.client.system.security.po.UserInfo;
//import com.seeyon.sfu.client.system.security.util.DesUtil;
//import com.seeyon.sfu.client.system.security.util.SFUBussinessException;
//import com.seeyon.sfu.client.system.security.util.SecurityUtil;
//import com.seeyon.sfu.util.base.StringUtils;
//import com.seeyon.sfu.util.encrypt.LightWeightEncoder;
//import java.io.UnsupportedEncodingException;
//import java.net.URLEncoder;
//import java.util.Map;
//import org.apache.commons.logging.Log;
//import org.apache.commons.logging.LogFactory;
//
//public class ClientSecurityValidateManagerImpl extends BaseController implements ClientSecurityValidateManager {
//    private static final Log LOG = LogFactory.getLog(LicenseCheckerController.class);
//
//    public ClientSecurityValidateManagerImpl() {
//    }
//
//    public void validate(UserInfo userInfo) throws SFUBussinessException {
////        UserFactory.getInstance().getUser(userInfo.getUserType()).getDogInfo(userInfo);
////        String userBuInfo = this.request2server("security.do", (new LocalData()).structure(userInfo), userInfo.getTimeout(), userInfo.getErrorCallback(), "false");
////        if (this.getEx() != null) {
////            throw new SFUBussinessException("网络异常,请检查网络连接！", "");
////        } else if (StringUtils.isBlank(userBuInfo)) {
////            throw new SFUBussinessException("您的登录已失效，请重新登录！", "");
////        } else {
////            SecurityUtil.getUserInfo(userBuInfo, DesUtil.generateKey(userInfo.getSessionID()), userInfo);
////        }
//    }
//
//    public void updateState(String module) {
//        UserInfo userInfo = this.getUserInfo(module);
//        String decodeParams = "";
//
//        try {
//            decodeParams = "method=updateState&dataType=json&sign=" + Math.random() + "&sessionid=" + userInfo.getSessionID() + "&version=" + "V1.9.2" + "&data=" + LightWeightEncoder.encodeString(URLEncoder.encode(userInfo.toString(), "UTF-8"));
//        } catch (UnsupportedEncodingException var5) {
//            LOG.error("", var5);
//        }
//
//        this.request2server("security.do", decodeParams, userInfo.getTimeout(), "", "false");
//    }
//
//    public String getCompanyName(String module) {
//        boolean control = true;
//        String companyName = "";
//        if (!Modules.appoint_data_clean.equals(Modules.valueOf(module)) && !Modules.edoc_data_clean.equals(Modules.valueOf(module)) && !Modules.data_clean.equals(Modules.valueOf(module))) {
//            control = false;
//            companyName = (String)LoginManagerImpl.getInstance().getBasicInfo().get("compname");
//        } else {
//            control = true;
//        }
//
//        if (control) {
//            String result = SetController.getInstance().checkDbConfigOk("");
//            if (StringUtils.isBlank(result)) {
//                companyName = CollDBChecker.getCompanyName();
//                LOG.info("本地库中的公司名: " + companyName);
//                if (StringUtils.isBlank(companyName)) {
//                    companyName = String.valueOf(Math.random());
//                }
//            }
//        }
//
//        return companyName;
//    }
//
//    public UserInfo getUserInfo(String module) {
//        UserInfo info = new UserInfo();
//        Map<String, String> basicInfo = LoginManagerImpl.getInstance().getBasicInfo();
//        info.setSessionID(LoginManagerImpl.getCookie());
//        info.setVersion("V1.9.2");
//        info.setModule(module);
//        info.setTimeout("30000");
//        info.setErrorCallback("top.sendNetErrorMsg()");
//        info.setUserID((String)basicInfo.get("userId"));
//        info.setMallID((String)basicInfo.get("mallId"));
//        info.setUserName((String)basicInfo.get("username"));
//        info.setCompanyName(this.getCompanyName(module));
//        Integer type = Integer.valueOf((String)basicInfo.get("userType"));
//        Integer typeInt = Integer.valueOf((String)basicInfo.get("userTypeInt"));
//        info.setUserType(type);
//        if (type == 3 && typeInt == -1) {
//            info.setUserType(typeInt);
//        }
//
//        SettingCenterManager settingCenterManager = SettingCenterManagerImpl.getInstance();
//        String oaAddress = settingCenterManager.getConfig(LinkConfigEnums.HelperOAScheme.getValue()) + "://" + settingCenterManager.getConfig(LinkConfigEnums.HelperOAIp.getValue()) + ":" + settingCenterManager.getConfig(LinkConfigEnums.HelperOAPort.getValue());
//        info.setRestName((String)basicInfo.get("restName"));
//        info.setRestPwd((String)basicInfo.get("restPwd"));
//        info.setOaVersion(CollDBChecker.getVersion());
//        info.setOaAddress(oaAddress);
//        return info;
//    }
//}
