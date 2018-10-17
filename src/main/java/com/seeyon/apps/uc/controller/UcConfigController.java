//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.apps.uc.controller;

import com.seeyon.apps.uc.manager.S2SManager;
import com.seeyon.apps.uc.manager.UCConfigManager;
import com.seeyon.apps.uc.po.UcConfig;
import com.seeyon.apps.uc.service.S2sService;
import com.seeyon.apps.uc.util.S2SConfig;
import com.seeyon.apps.uc.util.S2SUtil;
import com.seeyon.apps.uc.util.UcUtils;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.config.manager.ConfigManager;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.po.config.ConfigItem;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import com.seeyon.ctp.util.json.JSONUtil;
import java.io.PrintWriter;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;

public class UcConfigController extends BaseController {
    private UCConfigManager ucConfigManager;
    private ConfigManager configManager;
    private S2SManager s2sManager;
    private S2sService s2sService;
    private S2SUtil s2sUtil;
    private static final Log log = LogFactory.getLog(UcConfigController.class);

    public UcConfigController() {
    }

    public S2SUtil getS2sUtil() {
        return this.s2sUtil;
    }

    public void setS2sUtil(S2SUtil s2sUtil) {
        this.s2sUtil = s2sUtil;
    }

    public S2SManager getS2sManager() {
        return this.s2sManager;
    }

    public void setS2sManager(S2SManager s2sManager) {
        this.s2sManager = s2sManager;
    }

    public ConfigManager getConfigManager() {
        return this.configManager;
    }

    public void setConfigManager(ConfigManager configManager) {
        this.configManager = configManager;
    }

    public UCConfigManager getUcConfigManager() {
        return this.ucConfigManager;
    }

    public void setUcConfigManager(UCConfigManager ucConfigManager) {
        this.ucConfigManager = ucConfigManager;
    }

    @CheckRoleAccess(
            roleTypes = {Role_NAME.SystemAdmin}
    )
    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        String uc_channel = this.s2sService.getUcRongCacheValue("uc_Channel");
//        if("rong".equals(uc_channel)) {
//            String ucRongServiceHost = "";
//            String ucRongAppKey = "";
//            String ucRongAppSecret = "";
//            String uc_deployment = this.s2sService.getUcRongCacheValue("uc_deployment");
//            if("private".equals(uc_deployment)) {
//                ucRongServiceHost = this.s2sService.getUcRongCacheValue("uc_rongservice_ip");
//            }
//
//            ucRongAppKey = this.s2sService.getUcRongCacheValue("uc_rongAppKey");
//            ucRongAppSecret = this.s2sService.getUcRongCacheValue("uc_rongAppSecret");
//            return (new ModelAndView("apps/uc/conf/rong_config")).addObject("ucRongAppKey", ucRongAppKey).addObject("ucRongAppSecret", ucRongAppSecret).addObject("ucRongServiceHost", ucRongServiceHost);
//        } else {
//            return (new ModelAndView("apps/uc/conf/index")).addObject("type", "show").addObject("mxVersion", SystemEnvironment.getMxVersion());
//        }
        return (new ModelAndView("apps/uc/conf/index")).addObject("type", "show").addObject("mxVersion", SystemEnvironment.getMxVersion());
    }

    @NeedlessCheckLogin
    @CheckRoleAccess(
            roleTypes = {Role_NAME.SystemAdmin}
    )
    public ModelAndView queryConfig(HttpServletRequest request, HttpServletResponse response) throws Exception {
        UcConfig queryConfig = null;
        ConfigItem firstConfigItem = this.configManager.getConfigItem("uc_switch", "uc_config_first");
        ConfigItem configItem_M1_S2S_HOST = this.configManager.getConfigItem("uc_switch", "m1_s2s_host");
        ConfigItem configItem_M1_S2S_PORT = this.configManager.getConfigItem("uc_switch", "m1_s2s_port");
        ConfigItem configItem_UC_S2S_PORT = this.configManager.getConfigItem("uc_switch", "uc_s2s_port");
        ConfigItem configItem_UC_S2S_HOST = this.configManager.getConfigItem("uc_switch", "uc_s2s_host");
        ConfigItem configItem_A8_S2S_HOST = this.configManager.getConfigItem("uc_switch", "a8_s2s_host");
        ConfigItem configItem_A8_S2S_PORT = this.configManager.getConfigItem("uc_switch", "a8_s2s_port");
        ConfigItem configItem_deploymentmode = this.configManager.getConfigItem("uc_switch", "uc_config_deploymentmode");
        boolean s2sIsStart = S2SConfig.s2sIsStart();
        boolean notConfig = false;
        String m1ServerIp;
        if(firstConfigItem == null) {
            queryConfig = new UcConfig();
            queryConfig.setFirstTime("1");
            queryConfig.setUcC2sPort("5222");
            queryConfig.setUcFileTransferPort("7777");
            queryConfig.setUcWebPort("5280");
            queryConfig.setIsReadingConfig("1");
        } else {
            queryConfig = this.ucConfigManager.queryConfigAxis();
            if(queryConfig != null) {
                if(Strings.isBlank(queryConfig.getA8ServerIp())) {
                    notConfig = true;
                }

                queryConfig.setIsReadingConfig("1");
                queryConfig.setUcRuningState(this.ucConfigManager.starorStoptUcServiceAxis("3"));
                ConfigItem synTimeItem = this.configManager.getConfigItem("uc_switch", "uc_syn_time");
                if(synTimeItem != null) {
                    String synTime = synTimeItem.getConfigValue();
                    queryConfig.setSynTime(synTime);
                } else {
                    queryConfig.setSynTime("未同步");
                }
            } else {
                queryConfig = new UcConfig();
                queryConfig.setIsReadingConfig("0");
                queryConfig.setUcC2sPort("5222");
                queryConfig.setUcFileTransferPort("7777");
                queryConfig.setUcWebPort("5280");
            }

            m1ServerIp = firstConfigItem.getConfigValue();
            if(!"2".equals(m1ServerIp) && !notConfig) {
                queryConfig.setFirstTime("0");
            } else {
                queryConfig.setFirstTime("1");
                queryConfig.setnFileSize("50");
                queryConfig.setSzUCOuterIP(queryConfig.getSzUCInIp());
                queryConfig.setSzUCInIp("");
            }
        }

        queryConfig.setM1MessagePort(configItem_M1_S2S_PORT != null?configItem_M1_S2S_PORT.getConfigValue():S2SConfig.M1_S2S_PORT_VALUE);
        m1ServerIp = configItem_M1_S2S_PORT != null?configItem_M1_S2S_HOST.getConfigValue():S2SConfig.M1_S2S_HOST_VALUE;
        if("M1".equals(SystemEnvironment.getMxVersion())) {
            if(m1ServerIp.indexOf("http://") == 0) {
                m1ServerIp = m1ServerIp.substring(7);
            } else if(m1ServerIp.indexOf("https://") == 0) {
                m1ServerIp = m1ServerIp.substring(8);
            }
        }

        queryConfig.setM1ServerIp(m1ServerIp);
        queryConfig.setUcS2sPort(configItem_UC_S2S_PORT != null?configItem_UC_S2S_PORT.getConfigValue():S2SConfig.UC_S2S_PORT_VALUE);
        queryConfig.setUcS2SIp(configItem_UC_S2S_HOST != null?configItem_UC_S2S_HOST.getConfigValue():S2SConfig.UC_S2S_HOST_VALUE);
        queryConfig.setA8S2sPort(configItem_A8_S2S_PORT != null?configItem_A8_S2S_PORT.getConfigValue():S2SConfig.A8_S2S_PORT_VALUE);
        queryConfig.setA8ServerIp(configItem_A8_S2S_HOST != null?configItem_A8_S2S_HOST.getConfigValue():S2SConfig.A8_S2S_HOST_VALUE);
        queryConfig.setDeploymentMode(configItem_deploymentmode != null?configItem_deploymentmode.getConfigValue():S2SConfig.DEPLOYMENTMODE);
        queryConfig.setS2sIsRuning(s2sIsStart?"1":"0");
        queryConfig.setHashM1Plug(SystemEnvironment.hasPlugin("m1")?"1":"0");
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        String queryConfigString = JSONUtil.toJSONString(queryConfig);
        jsonObject.put("res", queryConfigString);
        jsonArray.put(jsonObject);
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        out.write(jsonArray.toString());
        if(firstConfigItem != null && this.s2sUtil.getConn()) {
            int serverPort = request.getServerPort();
            this.s2sManager.setSeverIpOrPort(String.valueOf(serverPort));
        }

        return null;
    }

    @CheckRoleAccess(
            roleTypes = {Role_NAME.SystemAdmin}
    )
    public ModelAndView setChannel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("apps/uc/conf/config");
    }

    @CheckRoleAccess(
            roleTypes = {Role_NAME.SystemAdmin}
    )
    public ModelAndView saveChannel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        UcConfig bean = new UcConfig();
        this.bind(request, bean);
        String returnFlag = "false";
        if(!Strings.isBlank(bean.getUcDeploymentChannel())) {
            this.ucConfigManager.saveOrUpdateConfigItem("uc_deploymentChannel", bean.getUcDeploymentChannel());
            returnFlag = "true";
        }

        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("res", returnFlag);
        jsonArray.put(jsonObject);
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        out.write(jsonArray.toString());
        return null;
    }

    @CheckRoleAccess(
            roleTypes = {Role_NAME.SystemAdmin}
    )
    public ModelAndView saveConfig(HttpServletRequest request, HttpServletResponse response) throws Exception {
        UcConfig bean = new UcConfig();
        this.bind(request, bean);
        bean.setA8WebPort(String.valueOf(request.getServerPort()));
        bean.setFirstTime("0");
        bean.setUcRuningState("0");
        String secretKey = "";
        String mxVersion = SystemEnvironment.getMxVersion().toLowerCase();
        ConfigItem configItem_UC_SECRET_KEY = this.configManager.getConfigItem("uc_switch", "Secret_Key");
        if(this.configManager.getConfigItem("uc_switch", "Secret_Key") == null) {
            secretKey = UcUtils.getHattedCode8();
        } else {
            secretKey = configItem_UC_SECRET_KEY.getConfigValue();
        }

        boolean saveConfig = this.ucConfigManager.saveConfigAxis(bean, secretKey, mxVersion);
        String returnFlag = "false";
        if(saveConfig) {
            this.ucConfigManager.saveOrUpdateConfigItem("uc_config_first", "0");
            this.ucConfigManager.saveOrUpdateConfigItem("uc_server_inip", bean.getSzUCInIp());
            this.ucConfigManager.saveOrUpdateConfigItem("uc_server_outip", bean.getSzUCOuterIP());
            this.ucConfigManager.saveOrUpdateConfigItem("uc_s2s_host", bean.getUcS2SIp());
            this.ucConfigManager.saveOrUpdateConfigItem("uc_s2s_port", bean.getUcS2sPort());
            this.ucConfigManager.saveOrUpdateConfigItem("a8_s2s_host", bean.getA8ServerIp());
            this.ucConfigManager.saveOrUpdateConfigItem("a8_s2s_port", bean.getA8S2sPort());
            this.ucConfigManager.saveOrUpdateConfigItem("uc_c2s_port", bean.getUcC2sPort());
            this.ucConfigManager.saveOrUpdateConfigItem("uc_config_deploymentmode", bean.getDeploymentMode());
            this.ucConfigManager.saveOrUpdateConfigItem("uc_file_size", bean.getnFileSize());
            this.ucConfigManager.saveOrUpdateConfigItem("m1_s2s_host", bean.getM1ServerIp());
            this.ucConfigManager.saveOrUpdateConfigItem("m1_s2s_port", bean.getM1MessagePort());
            this.ucConfigManager.saveOrUpdateConfigItem("uc_web_port", bean.getUcWebPort());
            this.ucConfigManager.saveOrUpdateConfigItem("uc_file_port", bean.getUcFileTransferPort());
            this.ucConfigManager.saveOrUpdateConfigItem("uc_mx_version", mxVersion);
            this.ucConfigManager.saveOrUpdateConfigItem("Secret_Key", secretKey);
            if(bean.getA8ServerStyle().equals("1")) {
                this.ucConfigManager.saveOrUpdateConfigItem("a8_server_style", "https");
            } else {
                this.ucConfigManager.saveOrUpdateConfigItem("a8_server_style", "http");
            }

            returnFlag = "true";
        }

        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("res", returnFlag);
        jsonArray.put(jsonObject);
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        out.write(jsonArray.toString());
        return null;
    }

    public ModelAndView ajaxCheckPort(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String port = request.getParameter("port");
        String from = request.getParameter("from");
        String ucServerIp = request.getParameter("ucServerIp");
        String returnValue = "";
        if(Strings.isNotBlank(port)) {
            if("uc".equals(from)) {
                returnValue = this.ucConfigManager.checkUCportAxis(port, ucServerIp);
            } else {
                returnValue = S2SConfig.checkPort(Integer.parseInt(port));
            }
        }

        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("res", returnValue);
        jsonArray.put(jsonObject);
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        out.write(jsonArray.toString());
        return null;
    }

    public ModelAndView ajaxCheckFilePath(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String path = request.getParameter("path");
        String checkFilePath = this.ucConfigManager.checkFilePathAxis(path);
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("res", checkFilePath);
        jsonArray.put(jsonObject);
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        out.write(jsonArray.toString());
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView start(HttpServletRequest request, HttpServletResponse response) throws Exception {
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        String state = this.ucConfigManager.starorStoptUcServiceAxis("1");
        if("0".equals(state)) {
            this.s2sManager.intConfigCache();
        }

        jsonObject.put("res", state);
        jsonArray.put(jsonObject);
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        out.write(jsonArray.toString());
        return null;
    }

    public ModelAndView querySynTime(HttpServletRequest request, HttpServletResponse response) throws Exception {
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        String synTime = "";
        ConfigItem synTimeItem = this.configManager.getConfigItem("uc_switch", "uc_syn_time");
        if(synTimeItem != null) {
            synTime = synTimeItem.getConfigValue();
        }

        jsonObject.put("synTime", synTime);
        jsonArray.put(jsonObject);
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        out.write(jsonArray.toString());
        return null;
    }

    public ModelAndView connectS2STest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        String synTime = this.s2sManager.getTestS2STime();
        if(synTime == null) {
            for(int j = 1; j < 3; ++j) {
                synTime = this.s2sManager.getTestS2STime();
                if(synTime != null) {
                    j = 3;
                    log.info("测试连接成功!");
                    this.s2sUtil.setConn("1");
                }
            }

            if(synTime == null) {
                log.info("尝试3次测试连接后依然失败.");
                this.s2sUtil.setConn("-1");
                this.s2sUtil.setSynSwitch("0");
            }
        }

        jsonObject.put("synTime", synTime);
        jsonObject.put("testTime", Datetimes.formatDatetime(new Date()));
        jsonArray.put(jsonObject);
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        out.write(jsonArray.toString());
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView stop(HttpServletRequest request, HttpServletResponse response) throws Exception {
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        String state = this.ucConfigManager.starorStoptUcServiceAxis("2");
        jsonObject.put("res", state);
        jsonArray.put(jsonObject);
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        out.write(jsonArray.toString());
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView status(HttpServletRequest request, HttpServletResponse response) throws Exception {
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        String state = this.ucConfigManager.starorStoptUcServiceAxis("3");
        jsonObject.put("res", state);
        jsonArray.put(jsonObject);
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        out.write(jsonArray.toString());
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView saveNextConfig1(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String ucServerIp = request.getParameter("ucServerIp");
        ConfigItem configItem_UC_S2S_HOST = this.configManager.getConfigItem("uc_switch", "uc_s2s_host");
        if(null != configItem_UC_S2S_HOST) {
            configItem_UC_S2S_HOST.setConfigValue(ucServerIp);
            this.configManager.updateConfigItem(configItem_UC_S2S_HOST);
        }

        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView checkIpUrl(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String ucServerIp = request.getParameter("ucServerIp");
        String seeyonnServerIp = request.getParameter("seeyonnServerIp");
        String seeyonnServerPort = request.getParameter("seeyonnServerPort");
        String flag = request.getParameter("flag");
        String state = "";
        String writeState = "0";
        if("UC".equals(flag)) {
            state = this.ucConfigManager.checkUcIpUrlAxis("http://" + ucServerIp);
        }

        if("A8".equals(flag)) {
            state = this.ucConfigManager.checkA8IpUrl(seeyonnServerIp, seeyonnServerPort);
        }

        PrintWriter out = response.getWriter();
        if("UC".equals(flag)) {
            if(!"500".equals(state) && !"320".equals(state)) {
                writeState = writeState + "," + state;
            } else {
                writeState = "1";
            }
        } else if(!"200".equals(state)) {
            writeState = "1";
        }

        out.write(writeState);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView checkServerIpByUc(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String ucServerIp = request.getParameter("ip");
        String flag = request.getParameter("flag");
        String state = "";
        if("UC".equals(flag)) {
            state = this.ucConfigManager.checkServerIpByUc(ucServerIp);
        }

        PrintWriter out = response.getWriter();
        out.write(state);
        return null;
    }

    public ModelAndView checkSeesionOk(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        out.write("seesionOK");
        return null;
    }

    public S2sService getS2sService() {
        return this.s2sService;
    }

    public void setS2sService(S2sService s2sService) {
        this.s2sService = s2sService;
    }
}
