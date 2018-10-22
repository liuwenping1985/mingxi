//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.product;

import code2.www.seeyon.com.system.auth.SeeyonDog;
import com.seeyon.ctp.cluster.ClusterConfigBean;
import com.seeyon.ctp.cluster.ClusterConfigValidator;
import com.seeyon.ctp.cluster.notification.NotificationManager;
import com.seeyon.ctp.cluster.notification.NotificationType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.constants.ProductEditionEnum;
import com.seeyon.ctp.common.constants.ProductVersionEnum;
import com.seeyon.ctp.common.init.MclclzUtil;
import com.seeyon.ctp.product.dao.ProductInfoDaoImpl;
import com.seeyon.ctp.product.util.GenerateKey;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.HttpClientUtil;
import com.seeyon.ctp.util.PropertiesUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.TextEncoder;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.m1.product.utils.SeeyonJSONUtils;
import com.seeyon.m1.product.utils.SeeyonSecurityUtils;
import com.seeyon.m1.product.utils.SeeyonVSMUtils;
import java.io.File;
import java.math.BigInteger;
import java.net.URL;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.spec.RSAPrivateKeySpec;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;
import java.util.Map.Entry;
import javax.crypto.Cipher;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernet.utils.OutNa;
import sun.misc.BASE64Decoder;
import www.seeyon.com.mocnoyees.CHKUMocnoyees;
import www.seeyon.com.mocnoyees.DogException;
import www.seeyon.com.mocnoyees.LRWMMocnoyees;
import www.seeyon.com.mocnoyees.MSGMocnoyees;
import www.seeyon.com.mocnoyees.VERMocnoyees;
import www.seeyon.com.mocnoyees.Enums.UserTypeEnum;
import www.seeyon.com.utils.SQLUtil;
import www.seeyon.com.utils.StringUtil;

public final class ProductInfo {
    private static final Log logger = LogFactory.getLog(ProductInfo.class);
    private static Set<String> pluginInfos = new HashSet();
    private static int maxOnlineSize = 0;
    private static int maxRegisterSize = 0;
    private static int maxCompanySize = 0;
    private static Map<String, Map<String, Object>> dogBindingMap = new HashMap();
    private static final String fileSeparator;
    private static MSGMocnoyees mocnoyeesA;
    private static VERMocnoyees mocnoyeesVer;
    private static boolean isVerDev;
    private static String productLine;
    private static final String versionFileFullPath;
    private static final String developEditionFileFullPath;
    private static final String productFolder;
    private static final String BaseLicenseFolder;
    private static String lisenceFileFullPath;
    private static final String signatureFileFullPath;
    private static OutNa oldDog;
    private static boolean isOldTG;
    private Connection con = null;
    private static final Class<?> c3;
    private static String ClusterTempHostNo;
    private static boolean ClusterSlaveOK;

    static {
        fileSeparator = File.separator;
        mocnoyeesA = null;
        mocnoyeesVer = null;
        isVerDev = false;
        productLine = null;
        versionFileFullPath = SystemEnvironment.getApplicationFolder() + fileSeparator + "common" + fileSeparator + "js" + fileSeparator + "ui" + fileSeparator + "portaletMenu.js";
        developEditionFileFullPath = SystemEnvironment.getApplicationFolder() + fileSeparator + "common" + fileSeparator + "js" + fileSeparator + "ui" + fileSeparator + "partaletindev.js";
        productFolder = (new File(SystemEnvironment.getApplicationFolder())).getParentFile().getParentFile().getParentFile().getAbsolutePath();
        BaseLicenseFolder = productFolder + fileSeparator + "base" + fileSeparator + "license";
        lisenceFileFullPath = BaseLicenseFolder + fileSeparator;
        signatureFileFullPath = BaseLicenseFolder + fileSeparator + "publicinfomenu.js";
        oldDog = null;
        isOldTG = false;
        c3 = MclclzUtil.ioiekc("com.seeyon.ctp.permission.bo.LicensePerInfo");
        ClusterTempHostNo = String.valueOf(UUID.randomUUID().getMostSignificantBits());
        ClusterSlaveOK = false;
    }

    public ProductInfo() {
    }

    public synchronized void init() {
        try {
            ClusterConfigBean clusterConfigBean = ClusterConfigBean.getInstance();
            ClusterConfigValidator clusterConfigValidator = ClusterConfigValidator.getInstance();
            boolean isLoadDog = true;
            if(clusterConfigBean.isClusterEnabled()) {
                this.initCluster();
                if(!clusterConfigBean.isClusterMain()) {
                    logger.info("当前是从服务器，开始从主服务器同步产品加密信息(最长需要20秒)...");
                    int var4 = 0;

                    while(!ClusterSlaveOK && var4++ < 10) {
                        try {
                            Thread.sleep(2000L);
                        } catch (InterruptedException var14) {
                            ;
                        }
                    }

                    if(!ClusterSlaveOK) {
                        out("不能启动集群/双机的从服务器，请先启动主服务器。[" + clusterConfigBean.toString() + "]");
                        return;
                    }

                    logger.info("从主服务器同步产品加密信息完成.");
                    isLoadDog = false;
                }

                clusterConfigValidator.validate();
            }

            if(isLoadDog) {
                DecryptUtils u = new DecryptUtils();
                int result_util1 = u.n(SystemEnvironment.getApplicationFolder());
                if(result_util1 == 1) {
                    this.initEditionNC();
                } else {
                    try {
                        mocnoyeesVer = new VERMocnoyees(versionFileFullPath);
                    } catch (Throwable var13) {
                        out("验证产品版本文件无效: " + var13.getMessage());
                        return;
                    }

                    try {
                        if(mocnoyeesVer.methoddev(developEditionFileFullPath)) {
                            isVerDev = true;
                        }
                    } catch (Throwable var12) {
                        logger.info("不是开发版");
                    }

                    initEdition();

                    try {
                        oldDog = new OutNa();
                        oldDog.proc1(1);
                        isOldTG = oldDog.proc9();
                    } catch (Throwable var18) {
                        String msg = var18.getMessage();
                        if(msg.contains("3023") || msg.contains("1008") || msg.contains("2021") || msg.contains("2022") || msg.contains("2023")) {
                            out("D-" + msg);
                            return;
                        }
                    }

                    try {
                        Class handlerClass = Class.forName("www.seeyon.com.mocnoyees.VERMocnoyees");
                        ClassLoader cl = handlerClass.getClassLoader();
                        String filepath = ((URL)cl.getResources("www/seeyon/com/mocnoyees/VERMocnoyees.class").nextElement()).toString();
                        if(!filepath.endsWith("/WEB-INF/lib/mocnoyeeswz.jar!/www/seeyon/com/mocnoyees/VERMocnoyees.class")) {
                            out("初始化产品文件的效验码无效, CL:V");
                            return;
                        }

                        if((oldDog == null || !isOldTG) && !isVerDev) {
                            if(isU8OEM()) {
                                mocnoyeesA = new MSGMocnoyees(SeeyonDog.getInstance().getLicense(mocnoyeesVer));
                            } else {
                                LRWMMocnoyees lrwmmocnoyees = null;
                                File licenseFile = new File(lisenceFileFullPath);
                                if(licenseFile != null && licenseFile.exists()) {
                                    lrwmmocnoyees = new LRWMMocnoyees(licenseFile);
                                } else {
                                    lrwmmocnoyees = new LRWMMocnoyees(productLine);
                                }

                                mocnoyeesA = new MSGMocnoyees(lrwmmocnoyees);
                            }

                            if(mocnoyeesA.methodzz("ncbusiness") || mocnoyeesA.methodzz("ncehr") || mocnoyeesA.methodzz("ncsupplychain") || mocnoyeesA.methodzz("ncfinance") || mocnoyeesA.methodzz("ncfdc") || mocnoyeesA.methodzz("u8business")) {
                                mocnoyeesA.methodzi("dee", "1");
                            }

                            if(mocnoyeesA.methodzz("thirdpartReport")) {
                                mocnoyeesA.methodzi("seeyonreport", "1");
                            }

                            try {
                                if(!mocnoyeesA.methoda(productLine).equals(String.valueOf(UserTypeEnum.internal.getKey()))) {
                                    this.checkProductInfo4DogAndProgram();
                                }
                            } catch (Throwable var15) {
                                out("验证版本号和版本匹配情况异常: " + var15.getMessage());
                                return;
                            }

                            this.dataBind();
                            CHKUMocnoyees.checkFile(signatureFileFullPath, productFolder);
                        }
                    } catch (DogException var16) {
                        var16.printStackTrace();
                        out("验证产品加密狗无效: " + var16.getMessage());
                        return;
                    } catch (Throwable var17) {
                        var17.printStackTrace();
                        out("验证产品加密狗无效: " + var17.getMessage());
                        return;
                    }

                    this.initOnlineSize(isVerDev);
                    this.initRegisterSize(isVerDev);
                    this.initCompanySize(isVerDev);
                    this.checkCompnayCount();
                }
            }

            this.checkProductInfoDBAndProgram();
            if(this.con != null) {
                try {
                    this.con.close();
                } catch (SQLException var11) {
                    ;
                }
            }
        } catch (Exception var19) {
            var19.printStackTrace();
        }

    }

    public String getVersionFilePath() {
        return versionFileFullPath;
    }

    private void checkCompnayCount() {
        String sql = "SELECT count(*) FROM org_unit WHERE TYPE = 'Account' AND IS_ENABLE = 1 AND IS_DELETED = 0 AND STATUS = 1 AND IS_GROUP = 0";
        long companyCount = 0L;
        Statement s = null;
        ResultSet rs = null;
        Connection con = null;

        try {
            con = this.getConnection();
            s = con.createStatement();
            rs = s.executeQuery(sql);
            if(rs.next()) {
                companyCount = rs.getLong(1);
            }
        } catch (Exception var11) {
            var11.printStackTrace();
        } finally {
            SQLUtil.close1(rs, s, (Connection)null);
        }

        if(getMaxCompanySize() > 0 && companyCount > (long)getMaxCompanySize()) {
            out("当前注册使用单位数超过系统许可的单位数，请联系致远商务！: " + getMaxCompanySize());
        }

    }

    private void checkRegisterSize() {
        try {
            Object o = MclclzUtil.invoke(c3, "getInstance", new Class[]{String.class}, (Object)null, new Object[]{""});
            Integer serverType = (Integer)MclclzUtil.invoke(c3, "getserverType", (Class[])null, o, (Object[])null);
            boolean licensePerServerValid = ((Boolean)MclclzUtil.invoke(c3, "licensePerServerValid", (Class[])null, o, (Object[])null)).booleanValue();
            if(serverType.intValue() == 1 && !licensePerServerValid) {
                out("系统启动失败，当前系统实际注册用户数超出授权注册用户数限制！" + getMaxRegisterSize());
            }
        } catch (Exception var4) {
            out("系统启动失败，注册数授权验证异常：" + var4.getMessage());
        }

    }

    private String bytes2Hex(byte[] bts) {
        String des = "";
        String tmp = null;

        for(int i = 0; i < bts.length; ++i) {
            tmp = Integer.toHexString(bts[i] & 255);
            if(tmp.length() == 1) {
                des = des + "0";
            }

            des = des + tmp;
        }

        return des;
    }

    private void initEditionNC() {
        String result = null;

        try {
            Properties plugin2NCProductCode = PropertiesUtil.getFromClasspath("com/seeyon/ctp/product/nc-lic.properties");
            Map<String, String> NCProductCodePlugin = new HashMap();
            Iterator iter = plugin2NCProductCode.entrySet().iterator();

            while(iter.hasNext()) {
                Entry<Object, Object> e = (Entry)iter.next();
                String plugin = String.valueOf(e.getKey());
                String code = String.valueOf(e.getValue());
                NCProductCodePlugin.put(code, plugin);
            }

            GenerateKey g = new GenerateKey();
            BigInteger publicExponent = g.getPublicExponent();
            BigInteger modulus = g.getModulus();
            BigInteger privateExponent = g.getPrivateExponent();
            String basePath = SystemEnvironment.getApplicationFolder() + "/../../../base";
            basePath = Strings.getCanonicalPath(basePath);
            Properties ncProperties = PropertiesUtil.getFromAbsolutepath(basePath + File.separator + "conf" + File.separator + "system.properties");
            String prefix = ncProperties.getProperty("nc.server.url.prefix");
            if(prefix != null && !"".equals(prefix)) {
                String url = prefix + "/service/OALicServlet";
                HttpClientUtil h = new HttpClientUtil();

                String re;
                label140: {
                    try {
                        re = join(plugin2NCProductCode.values(), ",");
                        h.open(url, "post");
                        h.addParameter("P", publicExponent.toString());
                        h.addParameter("M", modulus.toString());
                        h.addParameter("C", re);
                        h.addParameter("A", plugin2NCProductCode.getProperty("A8"));
                        h.addParameter("B", plugin2NCProductCode.getProperty("M1"));
                        h.send();
                        result = h.getResponseBodyAsString((String)null);
                        break label140;
                    } catch (Throwable var24) {
                        out("获取NC-OA产品加密信息失败[" + prefix + "]，通路异常: " + var24.getMessage());
                    } finally {
                        h.close();
                    }

                    return;
                }

                re = (String)h.getResponseHeader().get("Re");
                if(!"OK".equalsIgnoreCase(re)) {
                    out("获取NC-OA产品加密信息失败[" + prefix + "]，信息异常: " + re);
                } else if(result == null) {
                    out("获取NC-OA产品加密信息失败[" + prefix + "]，无信息");
                } else {
                    int b = result.indexOf("<Lic>");
                    int e = result.indexOf("</Lic>");
                    if(b > -1 && e > -1) {
                        String text = result.substring(b + 5, e);
                        String lic = decrypt(text, privateExponent, modulus);
                        String[] lics = lic.split("[#]");
                        maxOnlineSize = Integer.parseInt(lics[0]);
                        if(maxOnlineSize > 0) {
                            for(int i = 2; i < lics.length; ++i) {
                                String p = lics[i];
                                pluginInfos.add((String)NCProductCodePlugin.get(p));
                            }

                            pluginInfos.add("ncplugin");
                            pluginInfos.add("edoc");
                            pluginInfos.add("officeOcx");
                            pluginInfos.add("pdf");
                            pluginInfos.add("dee");
                        } else {
                            if(maxOnlineSize != -1) {
                                out("NC-OA产品加密信息无效: " + maxOnlineSize);
                                return;
                            }

                            maxOnlineSize = 5;
                            pluginInfos.add("ncplugin");
                            pluginInfos.add("edoc");
                            pluginInfos.add("officeOcx");
                            pluginInfos.add("pdf");
                            pluginInfos.add("dee");
                        }

                    } else {
                        out("获取NC-OA产品加密信息失败[" + prefix + "]，信息异常: " + result);
                    }
                }
            } else {
                out("验证NC-OA产品加密无效: 请先配置OA相关信息");
            }
        } catch (Throwable var26) {
            out("验证NC-OA产品加密无效e: [" + result + "]" + var26);
        }
    }

    public static Map initDogBinding(String ver, String m1Lic) {
        if(m1Lic != null && !"".equals(m1Lic)) {
            try {
                String licJSON = TextEncoder.decode(m1Lic);
                Map licMap = (Map)JSONUtil.parseJSONString(licJSON, Map.class);
                Map result = checkDog(ver, licMap);
                if("pass".equals(result.get("success"))) {
                    Map<String, Object> curBindMap = new HashMap();
                    dogBindingMap.put(ver, curBindMap);
                    curBindMap.put("MaxOnlineSize", licMap.get(ver + "MaxOnlineSize"));
                    curBindMap.put("MaxRegisterSize", licMap.get(ver + "MaxRegisterSize"));
                    curBindMap.put("VersionName", licMap.get(ver + "VersionName"));
                    curBindMap.put("OverDate", "2050-10-12");
                    ClusterConfigBean bean = ClusterConfigBean.getInstance();
                    Map<String, Object> response = new HashMap();
                    response.put("Action", "Response");
                    response.put("ClusterName", bean.getClusterName());
                    response.put("ProductInfo.DogBindingMap", dogBindingMap);
                    NotificationManager.getInstance().send(NotificationType.ProductInfo, response, true);
                }

                return result;
            } catch (Throwable var8) {
                return new HashMap();
            }
        } else {
            return null;
        }
    }

    private static Map<String, Object> checkDog(String ver, Map data) {
        Map<String, Object> result = new HashMap();
        String msg = "fail";
        String secretKey = null;
        if(data != null) {
            String bindDogNum = (String)data.get(ver + "BindDogNum");
            String dogType = (String)data.get(ver + "DogType");
            String dogNum = getDogNo();
            if(dogNum == null) {
                dogNum = "null";
            }

            if(!bindDogNum.equals(dogNum)) {
                msg = "dogerror";
            } else {
                String overdueDateStr = (String)data.get(ver + "OverDate");
                if(overdueDateStr != null) {
                    boolean b = false;
                    if("-1".equals(overdueDateStr)) {
                        b = true;
                    } else {
                        try {
                            Date overdueDate = DateUtil.parse(overdueDateStr, "yyyy-MM-dd");
                            if(overdueDate != null) {
                                Date today = DateUtil.currentDate();
                                if(today.before(overdueDate)) {
                                    b = true;
                                }
                            }
                        } catch (ParseException var12) {
                            ;
                        }
                    }

                    if(b) {
                        msg = "pass";
                        secretKey = dogNum + bindDogNum + UUID.randomUUID();
                    } else {
                        msg = "overdate";
                    }
                }
            }
        }

        result.put("success", msg);
        result.put("key", secretKey);
        return result;
    }

    public static String getDogNo() {
        if(mocnoyeesA == null) {
            return null;
        } else {
            String dogNo = mocnoyeesA.methodk(productLine);
            dogNo = TextEncoder.encode(dogNo);
            return dogNo;
        }
    }

    public static boolean isTongDog() {
        return isOldTG;
    }

    private void dataBind() throws Exception {
        if(!mocnoyeesA.methoda(productLine).equals(String.valueOf(UserTypeEnum.internal.getKey()))) {
            mocnoyeesA.checkDatabase(this.getConnection());
        }
    }

    private static void initEdition() {
        String mocnoyeesVerEdition = mocnoyeesVer.methode("Ver");
        ProductEditionEnum edition = ProductEditionEnum.valueOfKey(mocnoyeesVerEdition);
        if(edition == null) {
            out("不正确的版本信息：" + mocnoyeesVerEdition);
        } else {
            ProductEditionEnum.initCurrentProductEdition(edition);
            productLine = mocnoyeesVer.methoda("productLine");
            lisenceFileFullPath = lisenceFileFullPath + productLine.toLowerCase() + "." + "seeyonkey";
        }
    }

    private void initOnlineSize(boolean isVerDev) {
        if(isVerDev) {
            maxOnlineSize = 5;
        } else if(isOldTG) {
            maxOnlineSize = 10;
        } else {
            maxOnlineSize = Integer.parseInt(mocnoyeesA.methodj(productLine));
        }

    }

    private void initRegisterSize(boolean isVerDev) {
        if(isVerDev) {
            maxRegisterSize = 0;
        } else if(isOldTG) {
            maxRegisterSize = 0;
        } else {
            maxRegisterSize = Integer.parseInt(mocnoyeesA.methodq(productLine));
        }

    }

    private void initCompanySize(boolean isVerDev) {
        if(isVerDev) {
            maxCompanySize = 0;
        } else if(isOldTG) {
            maxCompanySize = 0;
        } else if(mocnoyeesA.methodz("orgMaxCompany") == null) {
            maxCompanySize = 0;
        } else {
            try {
                maxCompanySize = Integer.parseInt(mocnoyeesA.methodz("orgMaxCompany.orgMaxCompany1"));
            } catch (Exception var3) {
                maxCompanySize = 0;
            }
        }

    }

    private void checkProductInfo4DogAndProgram() throws Exception {
        String mocnoyeesVerVersionNo = mocnoyeesVer.methodc("Ver");
        String mocnoyeesVerEdition = mocnoyeesVer.methode("Ver");
        String mocnoyeesDogVersionNo = mocnoyeesA.methode(productLine);
        String mocnoyeesDogEdition = mocnoyeesA.methodd(productLine);
        if(!StringUtil.isEmpty(mocnoyeesVerVersionNo) && mocnoyeesVerVersionNo.equals(mocnoyeesDogVersionNo)) {
            if(StringUtil.isEmpty(mocnoyeesVerEdition) || !mocnoyeesVerEdition.equals(mocnoyeesDogEdition)) {
                out("版本文件版本[" + mocnoyeesVerEdition + "]和加密狗版本不一致[" + mocnoyeesDogEdition + "].\n说明:A6V5-1:A6企业版, A6V5-2:A6-s版,A8V5-1:企业版, A8V5-2:集团版, G6V5-1:政务版, G6V5-2:政务多组织版, NCV5-1:NC协同OA");
            }
        } else {
            out("版本文件版本号[" + mocnoyeesVerVersionNo + "]和加密狗版本号不一致[" + mocnoyeesDogVersionNo + "].");
        }
    }

    private void checkProductInfoDBAndProgram() {
        ProductEditionEnum currentProductEdition = getCurrentProductEdition();
        ProductInfoDaoImpl productInfoDao = new ProductInfoDaoImpl(this.getConnection());
        Map<String, String> configs = productInfoDao.getProductInfoConfigs();
        ProductVersionEnum currentVersion = ProductVersionEnum.getCurrentVersion();
        String version = (String)configs.get("version");
        if(version != null && currentVersion.getCanonicalVersion().equals(version)) {
            String productEdition = (String)configs.get("productEdition");
            if(productEdition != null && productEdition.equals(String.valueOf(currentProductEdition.getValue()))) {
                logger.info("当前产品版本: " + currentProductEdition + "; " + getEditionA() + "; " + currentVersion.getCanonicalVersion());
            } else {
                out(productLine + "数据表版本[" + productEdition + "]和" + "应用程序版本不一致[" + currentProductEdition.getValue() + "].\n说明:A6V5-1:A6企业,A6V5-2:A6-s版, A8V5-1:企业版, A8V5-2:集团版, G6V5-1:政务版, G6V5-2:政务多组织版, NCV5-1:NC协同OA");
            }
        } else {
            out(productLine + "数据表版本[" + version + "]和" + productLine + "应用程序版本不一致[" + currentVersion.getCanonicalVersion() + "].");
        }
    }

    private static ProductEditionEnum getCurrentProductEdition() {
        return ProductEditionEnum.getCurrentProductEditionEnum();
    }

    public static boolean hasPlugin(String pluginId) {
        return checkPlugin(pluginId);
    }

    private static boolean checkPlugin(String pluginId) {
        if(pluginInfos.contains(pluginId)) {
            return true;
        } else {
            try {
                boolean valid;
                if(isVerDev || isOldTG) {
                    valid = false;
                    if("mm1".equals(pluginId)) {
                        if(getM1MaxOnline() > 0 || getM1MaxRegisterSize() > 0) {
                            valid = true;
                        }
                    } else {
                        valid = true;
                    }

                    if(valid) {
                        pluginInfos.add(pluginId);
                    }

                    return valid;
                }

                if("indexResume".equals(pluginId)) {
                    valid = isValidPlugin("index");
                } else if("mm1".equals(pluginId)) {
                    if(getM1MaxOnline() <= 0 && getM1MaxRegisterSize() <= 0) {
                        valid = false;
                    } else {
                        valid = true;
                    }
                } else {
                    valid = isValidPlugin(pluginId);
                }

                if(valid) {
                    pluginInfos.add(pluginId);
                    return true;
                }
            } catch (Throwable var2) {
                ;
            }

            return false;
        }
    }

    private static boolean isValidPlugin(String pluginId) {
        boolean isValid = mocnoyeesA.methodzz(pluginId);
        if(!isValid) {
            List<Info> pluginInfoList = null;
            if("A8V5".equals(productLine)) {
                pluginInfoList = (new PlugInList()).getA8PluginInfoList();
            } else if("A6V5".equals(productLine)) {
                pluginInfoList = (new PlugInList()).getA6PluginInfoList();
            } else if("G6V5".equals(productLine)) {
                pluginInfoList = (new PlugInList()).getG6PluginInfoList();
            }

            if(pluginInfoList != null) {
                boolean contains = false;
                Iterator var5 = pluginInfoList.iterator();

                while(var5.hasNext()) {
                    Info info = (Info)var5.next();
                    if(info.getKey().equals(pluginId)) {
                        contains = true;
                        if(!info.isDisplay() && info.getValue() == 1) {
                            isValid = true;
                        }
                        break;
                    }
                }

                if(!contains) {
                    isValid = true;
                }
            }
        }

        return isValid;
    }

    public static boolean isExceedMaxLoginNumber(int number, String loginName) {
        return number > maxOnlineSize;
    }

    public static boolean isExceedMaxLoginNumberM1(int number) {
        return number > getM1MaxOnline();
    }

    private Connection getConnection() {
        if(this.con == null) {
            try {
                Context ic = new InitialContext();
                DataSource source = null;

                try {
                    source = (DataSource)ic.lookup("java:comp/env/jdbc/ctpDataSource");
                } catch (Exception var4) {
                    source = (DataSource)ic.lookup("jdbc/ctpDataSource");
                }

                this.con = source.getConnection();
            } catch (NamingException var5) {
                out("数据源查找失败：" + var5.getMessage());
            } catch (SQLException var6) {
                out("获取数据库连接失败：" + var6.getMessage());
            }
        }

        return this.con;
    }

    private static void out(String message) {
        System.out.println("**************************************************************************");
        System.out.println("");
        System.out.println("Exception,Error : " + message);
        System.out.println("");
        System.out.println("**************************************************************************");

        try {
            Thread.sleep(5000L);
        } catch (Throwable var2) {
            ;
        }

        System.exit(-1);
    }

    private static String decrypt(String text, BigInteger privateExponent, BigInteger modulus) {
        try {
            byte[] data = (new BASE64Decoder()).decodeBuffer(text);
            KeyFactory keyFac = KeyFactory.getInstance("RSA");
            RSAPrivateKeySpec priKeySpec = new RSAPrivateKeySpec(modulus, privateExponent);
            PrivateKey privateKey = keyFac.generatePrivate(priKeySpec);
            Cipher cipher = Cipher.getInstance("RSA");
            cipher.init(2, privateKey);
            return new String(cipher.doFinal(data));
        } catch (Exception var8) {
            throw new RuntimeException(var8);
        }
    }

    private static String join(Collection<Object> c, String separator) {
        StringBuilder sb = new StringBuilder();
        int i = 0;

        for(Iterator var5 = c.iterator(); var5.hasNext(); ++i) {
            Object o = var5.next();
            if(i > 0) {
                sb.append(separator);
            }

            sb.append(o);
        }

        return sb.toString();
    }

    private void initCluster() {
        ClusterConfigBean bean = ClusterConfigBean.getInstance();
        ProductInfoProxy proxy = new ProductInfoProxy();
        proxy.setClusterSlaveOK(ClusterSlaveOK, false);
        proxy.setClusterTempHostNo(ClusterTempHostNo, false);
        proxy.setDogBindingMap(dogBindingMap, false);
        proxy.setMaxCompanySize(maxCompanySize, false);
        proxy.setMaxOnlineSize(maxOnlineSize, false);
        proxy.setMaxRegisterSize(maxRegisterSize, false);
        proxy.setPluginInfos(pluginInfos, false);
        NotificationManager.getInstance().register(new ProductNotificationListener(proxy));
        if(!bean.isClusterMain()) {
            Map<String, Object> request = new HashMap();
            request.put("Action", "Request");
            request.put("ClusterName", bean.getClusterName());
            request.put("TempHostNo", ClusterTempHostNo);
            request.put("ClusterHostIndex", bean.getClusterHostIndex());
            NotificationManager.getInstance().send(NotificationType.ProductInfo, request, true);
        }

    }

    public static String m1ProductInfo(String str) {
        String success = "fail";
        String returnValue = "unknow";
        Object checkValue = null;

        String dogNumStr;
        try {
            dogNumStr = getDogNo();
            String dogNum;
            if(dogNumStr != null) {
                dogNum = TextEncoder.decode(dogNumStr);
            } else {
                dogNum = String.valueOf(dogNumStr);
            }

            String dataStr = SeeyonSecurityUtils.decrypt(str, dogNum);
            Map<String, String> data = (Map)SeeyonJSONUtils.readValue(dataStr, Map.class);
            String maxOnlineSize = (String)data.get("concurrentNum");
            String maxRegistSize = (String)data.get("registerNum");
            String versionStr = (String)data.get("m1VersionNum");
            if(versionStr == null) {
                versionStr = "5.0.0";
            }

            String versionName = "V" + versionStr;
            String overDate = (String)data.get("overdueDate");
            String dogType = (String)data.get("dogType");
            String bindDogNo = (String)data.get("bindDogNum");
            if(!"1".equals(dogType) && dogNumStr != null) {
                bindDogNo = TextEncoder.encode(bindDogNo);
            }

            Map<String, String> initM1 = new HashMap();
            initM1.put("M1MaxOnlineSize", maxOnlineSize);
            initM1.put("M1MaxRegisterSize", maxRegistSize);
            initM1.put("M1VersionName", versionName);
            initM1.put("M1OverDate", overDate);
            initM1.put("M1DogType", dogType);
            initM1.put("M1BindDogNum", bindDogNo);
            String temp = SeeyonJSONUtils.writeValueAsString(initM1);
            String initStr = TextEncoder.encode(temp);
            checkValue = initDogBinding("M1", initStr);
            SeeyonVSMUtils.setSecretKey((Map)checkValue);
        } catch (Exception var18) {
            checkValue = new HashMap();
            ((Map)checkValue).put("success", success);
            ((Map)checkValue).put("key", returnValue);
        }

        dogNumStr = SeeyonJSONUtils.writeValueAsString(checkValue);
        return dogNumStr;
    }

    public static String getEditionA() {
        return ProductEditionEnum.getCurrentProductEditionEnum().getName() + (isVerDev?".development":"product");
    }

    public static String getSpVersion() {
        String res = ProductVersionEnum.getCurrentVersion().getSpVersion();
        return res != null?res:"";
    }

    public static String getVersion() {
        String res = ProductVersionEnum.getCurrentVersion().getMainVersion();
        return res != null?res:"";
    }

    public static String getM1Version() {
        Map bindMap = (Map)dogBindingMap.get("M1");
        return bindMap != null?(String)bindMap.get("VersionName"):"";
    }

    public static String getM1OverDate() {
        Map bindMap = (Map)dogBindingMap.get("M1");
        return bindMap != null?(String)bindMap.get("OverDate"):"";
    }

    public static boolean isU8OEM() {
        return mocnoyeesVer != null && mocnoyeesVer.methodg("U8+") != null && mocnoyeesVer.methodg("U8+").equals("U8+");
    }

    public static int getMaxOnline() {
        return maxOnlineSize;
    }

    public static int getMaxRegisterSize() {
        return maxRegisterSize;
    }

    public static int getMaxCompanySize() {
        return maxCompanySize;
    }

    public static int getM1MaxOnline() {
        if(isU8OEM()) {
            return SeeyonDog.getInstance().getM1();
        } else {
            Map bindMap = (Map)dogBindingMap.get("M1");
            return bindMap != null?Integer.parseInt((String)bindMap.get("MaxOnlineSize")):0;
        }
    }

    public static int getM1MaxRegisterSize() {
        Map bindMap = (Map)dogBindingMap.get("M1");
        return bindMap != null?Integer.parseInt((String)bindMap.get("MaxRegisterSize")):0;
    }

    public static void main(String[] args) {
        Class<?> c2 = MclclzUtil.ioiekc("com..ctp.product.ProductInfo");
        MclclzUtil.invoke(c2, "initDogBinding", new Class[]{String.class, String.class}, (Object)null, new Object[]{"M1", "QQ"});
        System.out.println("ok");
    }
}
