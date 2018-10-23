//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.common.plugin;

import java.io.File;
import java.util.Properties;

public class PluginDefinition {
    private Properties pluginProperties = new Properties();
    private String id;
    private String name;
    private int category = -1;
    private File pluginFoler;
    private PluginInitializer initializer;
    private boolean isSupportCluster = true;

    public PluginDefinition() {
    }

    public File getPluginFoler() {
        return this.pluginFoler;
    }

    public void setPluginFoler(File pluginFoler) {
        this.pluginFoler = pluginFoler;
    }

    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String toString() {
        return this.getCategory() + ", " + this.getId() + ", " + this.getName();
    }

    public int getCategory() {
        return this.category;
    }

    public void setCategory(int applicationCategory) {
        this.category = applicationCategory;
    }

    public final String getPluginProperty(String key) {
        return this.pluginProperties.getProperty(key);
    }

    public final void setPluginProperties(Properties props) {
        this.pluginProperties = props;
    }
    public Properties getAll(){
        return this.pluginProperties;
    }

    public PluginInitializer getInitializer() {
        return this.initializer;
    }

    public void setInitializer(PluginInitializer initializer) {
        this.initializer = initializer;
    }

    public boolean isSupportCluster() {
        return this.isSupportCluster;
    }

    public void setSupportCluster(boolean isSupportCluster) {
        this.isSupportCluster = isSupportCluster;
    }
}
