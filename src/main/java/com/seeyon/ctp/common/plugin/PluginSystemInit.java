//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.common.plugin;

import com.seeyon.ctp.cluster.ClusterConfigBean;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.cache.CacheAccessable;
import com.seeyon.ctp.common.cache.CacheFactory;
import com.seeyon.ctp.common.cache.CacheObject;
import com.seeyon.ctp.common.config.PropertiesLoader;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.content.ContentConfig;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.init.DirOnlyFilter;
import com.seeyon.ctp.common.init.MclclzUtil;
import com.seeyon.ctp.product.PlugInList;
import java.io.File;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

public final class PluginSystemInit {
    private static final Logger LOGGER = Logger.getLogger(PluginSystemInit.class);
    public static final String INIT_PLUGIN_PATH_DEFAULT = "/plugin";
    public static final String INIT_PLUGIN_PROPERTIES = "/base/conf/plugin.properties";
    public static final String INIT_INDEX_PROPERTIES = "/base/index/indexConfig.properties";
    private static PluginSystemInit instance = null;
    private final Map<String, Boolean> pluginIds4Map = new HashMap();
    private final List<PluginDefinition> pluginDefinitions = new ArrayList();
    private final List<PluginDefinition> allPluginDefinitions = new ArrayList();
    private final Map<Integer, PluginDefinition> category2PluginDefinition = new HashMap();
    private static final Class<?> c1 = MclclzUtil.ioiekc("com.seeyon.ctp.product.ProductInfo");
    private static final Class<?> c3 = MclclzUtil.ioiekc("com.seeyon.ctp.permission.bo.LicensePerInfo");

    public static final PluginSystemInit getInstance() {
        if(instance == null) {
            instance = new PluginSystemInit();
        }

        return instance;
    }

    private PluginSystemInit() {
    }

    public final void init() {
        long startTime = System.currentTimeMillis();
        File pluginHome = new File(AppContext.getCfgHome(), "/plugin");
        if(pluginHome.exists() && pluginHome.isDirectory()) {
            LOGGER.debug("系统插件定义文件路径：" + pluginHome.getAbsolutePath());
            boolean isCluster = ClusterConfigBean.getInstance().isClusterEnabled();
            boolean isClusterSlave = isCluster && !ClusterConfigBean.getInstance().isClusterMain();
            CacheAccessable factory = CacheFactory.getInstance(SystemProperties.class);
            String cacheName = "masterProperties";
            Properties masterProperties;
            if(isClusterSlave) {
                CacheObject<Properties> cache = factory.getObject("masterProperties");
                masterProperties = (Properties)cache.get();
            } else {
                masterProperties = new Properties();
            }

            File[] plugins = pluginHome.listFiles(new DirOnlyFilter());
            String userProps = System.getProperty("SEEYON_HOME");
            if(userProps == null) {
                userProps = AppContext.getCfgHome() + "/../../../../../";
                LOGGER.warn("未配置SEEYON_HOME环境变量，使用默认路径：" + userProps);
            }

            Properties pluginCustomProps = null;
            if((new File(userProps, "/base/conf/plugin.properties")).exists()) {
                pluginCustomProps = PropertiesLoader.load(new File(userProps, "/base/conf/plugin.properties"));
            } else {
                LOGGER.warn((new File(userProps, "/base/conf/plugin.properties")).getAbsolutePath() + " 文件不存在，使用插件默认配置！");
            }

            Set<String> disabledPlugins = Utils.getDisabledPlugins();
            this.preLoadPluginProperties(plugins, isClusterSlave, masterProperties, pluginCustomProps);
            File[] var16 = plugins;
            int var15 = plugins.length;

            for(int var14 = 0; var14 < var15; ++var14) {
                File plugin = var16[var14];
                File pluginCfg = new File(plugin, "pluginCfg.xml");
                if(pluginCfg.exists() && pluginCfg.isFile()) {
                    Properties props = PropertiesLoader.load(pluginCfg);
                    String id = props.getProperty("id");
                    String name = props.getProperty("name");
                    if(StringUtils.isBlank(id)) {
                        LOGGER.error("Plugin not loaded, 'id' missing: " + pluginCfg.getAbsolutePath());
                    } else if(!plugin.getAbsolutePath().endsWith(id)) {
                        LOGGER.error("Plugin not loaded, plugin folder name should be '" + id + "': " + pluginCfg.getAbsolutePath());
                    } else if(StringUtils.isBlank(name)) {
                        LOGGER.error("Plugin not loaded, 'name' missing: " + pluginCfg.getAbsolutePath());
                    } else {
                        ModuleType moduleType = ModuleType.getEnumByName(id);
                        int category;
                        if(moduleType != null) {
                            category = moduleType.getKey();
                        } else {
                            String categoryStr = props.getProperty("category");
                            if(StringUtils.isBlank(categoryStr)) {
                                LOGGER.error("Plugin not loaded, 'category' misssing: " + pluginCfg.getAbsolutePath());
                                continue;
                            }

                            try {
                                category = Integer.parseInt(categoryStr);
                            } catch (Exception var32) {
                                LOGGER.error("Plugin not loaded, 'category' format error: " + pluginCfg.getAbsolutePath());
                                continue;
                            }
                        }

                        this.pluginIds4Map.put(id, Boolean.valueOf(false));
                        if(!disabledPlugins.contains(id)) {
                            PluginDefinition d = new PluginDefinition();
                            d.setId(id);
                            d.setName(name);
                            d.setCategory(category);
                            d.setPluginFoler(plugin);
                            String isSupportClusterStr = props.getProperty("isSupportCluster");
                            if(!StringUtils.isBlank(isSupportClusterStr)) {
                                d.setSupportCluster(Boolean.valueOf(isSupportClusterStr).booleanValue());
                            }

                            File pluginPropFile = new File(plugin, "pluginProperties.xml");
                            if(!pluginPropFile.exists() || !pluginPropFile.isFile()) {
                                pluginPropFile = new File(plugin, "pluginProperties.properties");
                            }

                            Properties pluginProps = null;
                            if(pluginPropFile.exists() && pluginPropFile.isFile()) {
                                pluginProps = PropertiesLoader.load(pluginPropFile);
                                this.checkIndexPlugin(id, userProps, pluginProps);
                                if(pluginProps != null && !pluginProps.isEmpty()) {
                                    d.setPluginProperties(pluginProps);
                                    Object o;
                                    Iterator var28;
                                    String key;
                                    if(isClusterSlave) {
                                        var28 = pluginProps.keySet().iterator();

                                        while(var28.hasNext()) {
                                            o = var28.next();
                                            key = (String)o;
                                            if(masterProperties.containsKey(key)) {
                                                pluginProps.put(key, masterProperties.get(key));
                                            }
                                        }
                                    }

                                    if(pluginCustomProps != null) {
                                        var28 = pluginCustomProps.keySet().iterator();

                                        while(var28.hasNext()) {
                                            o = var28.next();
                                            key = (String)o;
                                            if(key.startsWith(id)) {
                                                pluginProps.put(key, pluginCustomProps.get(key));
                                                LOGGER.debug("Plugin custom config: " + key + "=" + pluginCustomProps.get(key));
                                            }
                                        }
                                    }
                                }
                            }

                            this.allPluginDefinitions.add(d);
                            this.loadContentConfig(plugin);
                            String isK="formBiz+formBizModify";
                            if(PlugInList.getAllPluginList4ProductLine().containsKey(id)) {
                                Boolean o = (Boolean)MclclzUtil.invoke(c1, "hasPlugin", new Class[]{String.class}, (Object)null, new Object[]{d.getId()});
                                if(isK.contains(d.getId())){
                                    System.out.println("[我曹是系统插件哦-禁止丫的]"+d.getName()+"【"+d.getId()+"】");

                                    continue;
                                }
                                if(!o.booleanValue()) {
                                    LOGGER.debug("加密狗中不存在插件[" + d + "]，跳过。");
                                    continue;
                                }
                            }

                            if(((Boolean)this.pluginIds4Map.get(d.getId())).booleanValue()) {
                                LOGGER.warn("插件[" + d + "]已经存在");
                            } else {
                                int cat = d.getCategory();
                                if(cat != -1) {
                                    if(cat < 0) {
                                        LOGGER.warn("插件[" + d + "]的category属性值不能小于0；插件将不被启动.");
                                        continue;
                                    }

                                    PluginDefinition d1 = (PluginDefinition)this.category2PluginDefinition.get(Integer.valueOf(cat));
                                    if(d1 != null) {
                                        LOGGER.warn("插件[" + d + "]的category已经被[" + d1 + "]使用,插件将不被启动.");
                                        continue;
                                    }

                                    this.category2PluginDefinition.put(Integer.valueOf(d.getCategory()), d);
                                }

                                if(this.initInitializer(d, props)) {
                                    this.pluginDefinitions.add(d);
                                    this.pluginIds4Map.put(id, Boolean.valueOf(true));
                                    if(pluginProps != null && !pluginProps.isEmpty()) {
                                        List<String> removeList = new ArrayList();
                                        Enumeration enus = pluginProps.keys();

                                        String k;
                                        while(enus.hasMoreElements()) {
                                            k = (String)enus.nextElement();
                                            if(!k.startsWith(id)) {
                                                removeList.add(k);
                                                LOGGER.warn("Illegal plugin properties key '" + k + "' for '" + id + "', discarded.");
                                            }
                                        }

                                        Iterator var31 = removeList.iterator();

                                        while(var31.hasNext()) {
                                            k = (String)var31.next();
                                            pluginProps.remove(k);
                                        }

                                        SystemProperties.getInstance().putAll(pluginProps);
                                        LOGGER.debug("Loading properties for plugin: " + id);
                                        SystemProperties.getInstance().printAll(pluginProps);
                                    }

                                    LOGGER.info("加载插件 : " + d);
                                }
                            }
                        }
                    }
                } else {
                    LOGGER.error("Plugin file not exists:" + pluginCfg.getAbsoluteFile());
                }
            }

            SystemEnvironment.initPluginIds(this.pluginIds4Map);
            LOGGER.info("扫描插件定义文件完毕. 耗时：" + (System.currentTimeMillis() - startTime) + " MS");
        } else {
            LOGGER.warn("系统插件定义文件路径不存在：" + pluginHome.getAbsolutePath());
        }
    }

    private void checkIndexPlugin(String id, String userProps, Properties pluginProps) {
        if("index".equals(id) && pluginProps.getProperty("index.localRegMaxNumber") != null) {
            try {
                int localRegMaxNumber = Integer.parseInt(pluginProps.getProperty("index.localRegMaxNumber"));
                int regNumber = 0;
                File indexProFile = new File(userProps, "/base/index/indexConfig.properties");
                if(indexProFile.exists() && "local".equals(PropertiesLoader.load(indexProFile).getProperty("modelName"))) {
                    try {
                        regNumber = Integer.parseInt(String.valueOf(MclclzUtil.invoke(c3, "getTotalservernum", (Class[])null, MclclzUtil.invoke(c3, "getInstance", new Class[]{String.class}, (Object)null, new Object[]{""}), (Object[])null)));
                    } catch (Exception var8) {
                        LOGGER.warn("获取并发数错误！");
                    }
                }

                if(regNumber > localRegMaxNumber) {
                    LOGGER.warn("因并发数超过" + localRegMaxNumber + "必须分离部署全文检索。");
                }
            } catch (Exception var9) {
                LOGGER.warn("全文检索插件本地注册最大数拼写错误！");
            }
        }

    }

    private void preLoadPluginProperties(File[] plugins, boolean isClusterSlave, Properties masterProperties, Properties pluginCustomProps) {
        File[] var8 = plugins;
        int var7 = plugins.length;

        for(int var6 = 0; var6 < var7; ++var6) {
            File plugin = var8[var6];
            File pluginPropFile = new File(plugin, "pluginProperties.xml");
            if(!pluginPropFile.exists() || !pluginPropFile.isFile()) {
                pluginPropFile = new File(plugin, "pluginProperties.properties");
            }

            Properties pluginProps = null;
            if(pluginPropFile.exists() && pluginPropFile.isFile()) {
                pluginProps = PropertiesLoader.load(pluginPropFile);
                if(pluginProps != null && !pluginProps.isEmpty()) {
                    Object o;
                    Iterator var12;
                    String key;
                    if(isClusterSlave) {
                        var12 = pluginProps.keySet().iterator();

                        while(var12.hasNext()) {
                            o = var12.next();
                            key = (String)o;
                            if(masterProperties.containsKey(key)) {
                                pluginProps.put(key, masterProperties.get(key));
                            }
                        }
                    }

                    if(pluginCustomProps != null) {
                        var12 = pluginCustomProps.keySet().iterator();

                        while(var12.hasNext()) {
                            o = var12.next();
                            key = (String)o;
                            pluginProps.put(key, pluginCustomProps.get(key));
                        }
                    }

                    SystemProperties.getInstance().init(pluginProps);
                }
            }
        }

    }

    private boolean initInitializer(PluginDefinition d, Properties props) {
        String initializer = props.getProperty("initializer");
        if(initializer != null && !"".equals(initializer)) {
            try {
                PluginInitializer pi = (PluginInitializer)Class.forName(initializer).newInstance();
                d.setInitializer(pi);
                if(!pi.isAllowStartup(d, LOGGER)) {
                    LOGGER.warn("插件[" + d + "]的initializer[" + initializer + "]禁止了此插件的启动.");
                    return false;
                }
            } catch (Throwable var5) {
                LOGGER.warn("插件[" + d + "]的initializer[" + initializer + "]初始化失败.", var5);
                return false;
            }
        }

        return true;
    }

    private void loadContentConfig(File plugin) {
        File contentConfigFile = new File(plugin, "contentCfg.xml");
        if(contentConfigFile.exists() && contentConfigFile.isFile()) {
            Properties contentProps = PropertiesLoader.load(contentConfigFile);
            ContentConfig.initConfig(contentProps);
        }

    }

    public String getPluginApplicationCategoryName(int applicationCategory) {
        PluginDefinition p = (PluginDefinition)this.category2PluginDefinition.get(Integer.valueOf(applicationCategory));
        if(p == null) {
            return null;
        } else {
            String key = "application." + p.getCategory() + ".label";
            String label = ResourceBundleUtil.getString("", key, new Object[0]);
            if(label == null || key.equals(label)) {
                label = p.getName();
            }

            return label;
        }
    }

    public List<String> getPluginIds() {
        return new ArrayList(this.pluginIds4Map.keySet());
    }

    public Map<Integer, PluginDefinition> getPluginDefinitionMap() {
        return this.category2PluginDefinition;
    }

    public List<PluginDefinition> getPluginDefinitions() {
        return this.pluginDefinitions;
    }

    public List<PluginDefinition> getAllPluginDefinitions() {
        return this.allPluginDefinitions;
    }
}
