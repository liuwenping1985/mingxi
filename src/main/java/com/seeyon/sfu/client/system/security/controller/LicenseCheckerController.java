////
//// Source code recreated from a .class file by IntelliJ IDEA
//// (powered by Fernflower decompiler)
////
//
//package com.seeyon.sfu.client.system.security.controller;
//
//import com.seeyon.sfu.client.apps.dataclear.controller.IndexController;
//import com.seeyon.sfu.client.apps.index.enums.LinkConfigEnums;
//import com.seeyon.sfu.client.apps.index.manager.SettingCenterManagerImpl;
//import com.seeyon.sfu.client.apps.login.manager.LoginManagerImpl;
//import com.seeyon.sfu.client.common.BaseController;
//import com.seeyon.sfu.client.system.security.enums.Modules;
//import com.seeyon.sfu.client.system.security.manager.ClientSecurityValidateManager;
//import com.seeyon.sfu.client.system.security.manager.ClientSecurityValidateManagerImpl;
//import com.seeyon.sfu.client.system.security.po.UserInfo;
//import com.seeyon.sfu.client.system.security.util.SFUBussinessException;
//import com.seeyon.sfu.client.system.security.util.SystemUtil;
//import com.seeyon.sfu.common.utils.MD5Util;
//import java.io.UnsupportedEncodingException;
//import java.net.URLEncoder;
//import java.util.Date;
//
//import org.apache.commons.lang.StringUtils;
//import org.apache.commons.logging.Log;
//import org.apache.commons.logging.LogFactory;
//
//public class LicenseCheckerController extends BaseController {
//    private static final Log LOG = LogFactory.getLog(LicenseCheckerController.class);
//    private static final String JS_ROOT = "top.home_body.license.";
//    private static LicenseCheckerController instance;
//    private ClientSecurityValidateManager validateManager = new ClientSecurityValidateManagerImpl();
//
//    private LicenseCheckerController() {
//
//    }
//
//    public static synchronized LicenseCheckerController getInstance() {
//        if (instance == null) {
//            instance = new LicenseCheckerController();
//        }
//
//        return instance;
//    }
//
//    public void validate(String module) throws SFUBussinessException {
//        UserInfo info = this.validateManager.getUserInfo(module);
//        this.validateManager.validate(info);
//    }
//
//    public void check(String module) {
//        try {
//            this.validate(module);
//            this.executeScriptAsync("top.home_body.license.isChecked['" + module + "'] = true");
//            this.executeScriptAsync("top.home_body.license.clearLoadingAction('" + module + "')");
//            this.executeScriptAsync(Modules.valueOf(module).getTrigger());
//        } catch (SFUBussinessException var3) {
////            this.executeScriptAsync("top.home_body.license.clearLoadingAction('" + module + "')");
//////            this.sendMessage(var3);
//            this.executeScriptAsync("top.home_body.license.isChecked['" + module + "'] = true");
//            this.executeScriptAsync("top.home_body.license.clearLoadingAction('" + module + "')");
//            this.executeScriptAsync(Modules.valueOf(module).getTrigger());
//
//        }
//        String str = "isOk";
//
//    }
//
//    public void validateModule(String callBack, String module) {
//        this.executeScriptAsync("validateModulePwd('" + callBack + "','" + module + "','')");
//    }
//
//    public void enhanceValidateModule(String callBack, String module, String password) {
//
//        String md5 = "daac5112c562682ca29b87676bba8c80";
//
//        if(md5.equals(password)){
//            this.executeScriptAsync(callBack + "(true,'')");
//        }else{
//            this.executeScriptAsync(callBack + "(false,'密码输入错误请重新输入！')");
//        }
//
////        String pwd = "";
////        if (SystemUtil.isOffLine()) {
////            pwd = MD5Util.getMD5(SettingCenterManagerImpl.getInstance().getConfig(LinkConfigEnums.DataClearDBPassword.getValue()));
////        } else {
////            pwd = (String)LoginManagerImpl.getInstance().getBasicInfo().get("pwd");
////        }
////
////        try {
////            this.validate(module);
////            if (StringUtils.isNotEmpty(password)) {
////                if (password.equals(pwd)) {
////                    this.executeScriptAsync(callBack + "(true,'')");
////                } else {
////                    this.executeScriptAsync(callBack + "(false,'密码输入错误请重新输入！')");
////                }
////            } else {
////                this.executeScriptAsync(callBack + "(false,'密码输入错误请重新输入！')");
////            }
////        } catch (SFUBussinessException var6) {
////            this.sendMessage(var6);
////        }
//
//    }
//
//    public void sendMessage(SFUBussinessException e) {
//        if (StringUtils.isNotBlank(e.getMallURL())) {
//            String url = null;
//
//            try {
//                url = "http://home.seeyon.com/portal.php?m=user&a=loginTokenS1&request_token=" + LoginManagerImpl.getInstance().getLoginToken() + "&back_url=" + URLEncoder.encode(e.getMallURL(), "UTF-8");
//            } catch (UnsupportedEncodingException var4) {
//                LOG.error("到商城的链接地址获取错误!", var4);
//            }
//
//            this.executeScriptAsync("sendMessage('" + IndexController.validateString(e.getMessage(), "'") + "', 2, null, null, '去购买', null, 'top.home_body.license.openLink(\\'" + url + "\\')')");
//        } else {
//            this.executeScriptAsync("sendMessage('" + IndexController.validateString(e.getMessage(), "'") + "', 5)");
//        }
//
//    }
//}
