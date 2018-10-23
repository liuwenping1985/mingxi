package com.seeyon.apps.nbd.core.service.impl;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.CoreHook;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.service.MappingServiceManager;
import com.seeyon.apps.nbd.core.service.PluginServiceManager;
import com.seeyon.apps.nbd.core.service.ServicePlugin;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.util.XmlUtils;
import com.seeyon.apps.nbd.plugin.PluginDefinition;
import com.seeyon.apps.nbd.util.StringUtils;
import org.json.JSONException;
import org.json.JSONTokener;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class PluginServiceManagerImpl implements PluginServiceManager {

    private List<PluginDefinition> pluginDefinitionList = new ArrayList<PluginDefinition>();
    private List<FormTableDefinition> formTableDefinitionList = new ArrayList<FormTableDefinition>();
    private List<ServicePlugin> servicePluginList = new ArrayList<ServicePlugin>();
    private MappingServiceManager mappingServiceManager = new MappingServiceManagerImpl();
    public static final String mtId="2019-12:31 00:00:00";
    public PluginServiceManagerImpl() {
        try {

            initMapping();
            initPlugin();
            System.out.println("init----ok");
            //System.out.println(JSON.toJSONString(pluginDefinitionList));
        } catch (IOException e) {
            System.out.println("init--not--ok");
            e.printStackTrace();
        } catch (JSONException e) {
            System.out.println("init--not--ok");
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("init--not--ok");
            e.printStackTrace();
        }catch(Error error){
            System.out.println("init--not--ok");
            error.printStackTrace();
        }
    }

    private FileFilter mapping_filter = new FileFilter() {
        public boolean accept(File pathname) {
            //System.out.println(pathname);
            if (pathname.isDirectory()) {
                return true;
            }
            // System.out.println(pathname);
            if (pathname.getName().toLowerCase().contains("mapping.xml")) {
                return true;
            }
            return false;
        }
    };
    private FileFilter plugin_filter = new FileFilter() {
        public boolean accept(File pathname) {
            if (pathname.isDirectory()) {
                return true;
            }
            if (pathname.getName().toLowerCase().contains(".class")) {
                return true;
            }
            return false;
        }
    };

    private void initPlugin() throws IOException, JSONException {
        String path = PluginDefinition.class.getResource("").getPath();
        File rootFile = new File(path);
        List<File> fList = getFilesByFilter(rootFile, plugin_filter);
        for (File f : fList) {
            String ppp = f.getPath();
            String[] pp = ppp.split("classes");
            String classPath = null;
            if (pp.length == 2) {
                classPath = pp[1];
            }
            if (StringUtils.isEmpty(classPath)) {
                continue;
            }
            if ("/".equals(classPath.subSequence(0, 1)) || "\\".equals(classPath.subSequence(0, 1))) {

                classPath = classPath.substring(1);
            }
            classPath = classPath.replaceAll("\\.class", "");
            classPath = classPath.replaceAll("/", ".");
            classPath = classPath.replaceAll("\\\\", ".");
            try {
                Class cls = Class.forName(classPath);
                if (cls.isInterface()) {
                    continue;
                }
                Class[] clses = cls.getInterfaces();
                boolean isFound = false;
                Class[] superclsInterface = cls.getSuperclass().getInterfaces();
                if (clses != null && clses.length > 0) {
                    for (Class icls : clses) {
                        if (icls == PluginDefinition.class) {
                            PluginDefinition pd = (PluginDefinition) cls.newInstance();
                            pluginDefinitionList.add(pd);
                            isFound = true;
                            break;
                        }
                    }
                }
                if (!isFound && superclsInterface != null && superclsInterface.length > 0) {
                    for (Class icls : superclsInterface) {
                        if (icls == PluginDefinition.class) {
                            PluginDefinition pd = (PluginDefinition) cls.newInstance();
                            pluginDefinitionList.add(pd);
                            break;
                        }
                    }
                }

            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (InstantiationException e) {
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        filledServicePlugins();
    }

    public List<PluginDefinition> getPluginDefinitions() {
        return pluginDefinitionList;
    }


    public List<FormTableDefinition> getFormTableDefinitions() {
        return formTableDefinitionList;
    }

    private void filledServicePlugins() {

        List<PluginDefinition> plugins = this.getPluginDefinitions();
        for (PluginDefinition pde : plugins) {

            ServicePlugin sp = pde.getServicePlugin();
            if (sp != null) {
                List<String> affTypes = sp.getSupportAffairTypes();
                List<FormTableDefinition> ftdList = this.getFormTableDefinitions();
                if(!CommonUtils.isEmpty(affTypes)){
                    if(!CommonUtils.isEmpty(ftdList)){

                        for(String affType:affTypes){
                            if(CommonUtils.isEmpty(affType)){
                                continue;
                            }
                            for(FormTableDefinition ftd:ftdList){
                                if(affType.equals(ftd.getAffairType())){
                                    sp.addFormTableDefinition(ftd);
                                }
                            }
                        }
                    }
                }
                this.getServicePlugins().add(sp);

            }

        }

    }

    private void initMapping() throws IOException, JSONException {
        String path = CoreHook.class.getResource("").getPath();
        path += "/../plugin/";
        System.out.println("path:---------"+path);
        File rootFile = new File(path);
        List<File> fList = getFilesByFilter(rootFile, mapping_filter);
        for (File f : fList) {
            String json = XmlUtils.xml2jsonString(f);
            Map data = (Map) JSON.parse(json);
            FormTableDefinition ftd = mappingServiceManager.parseFormTableMapping(data);
            if (ftd != null) {
                formTableDefinitionList.add(ftd);
            }
        }
        System.out.println("flag111111");
    }

    private List<File> getFilesByFilter(File rootFile, FileFilter filter) {
        List<File> fList = new ArrayList<File>();
        loopFiles(rootFile, filter, fList);
        return fList;
    }


    private void loopFiles(File rootFile, FileFilter filter, List<File> fileContailer) {
        if (!rootFile.isDirectory()) {
            return;
        }
        File[] files = rootFile.listFiles(filter);
        if (files == null) {
            return;
        }
        for (File f : files) {
            if (f.isDirectory()) {
                loopFiles(f, filter, fileContailer);
            } else {
                fileContailer.add(f);
            }
        }

    }

    public static void main(String[] args) {
        PluginServiceManagerImpl impl = new PluginServiceManagerImpl();
        ServicePlugin sp = impl.getServicePluginsByAffairType("HT0001");
       // sp.exportData("HT0001");
        //System.out.println(JSON.toJSONString(impl.getServicePlugins()));
        //System.out.println(JSON.toJSONString(impl.getPluginDefinitions()));
    }

    public ServicePlugin getServicePluginsByAffairType(String affairType) {
        List<ServicePlugin> spList = getServicePlugins();
        if (!CommonUtils.isEmpty(spList)) {
            for (ServicePlugin sp : spList) {
                if (sp.containAffairType(affairType)) {
                    return sp;
                }
            }
        }
        return null;
    }

    public List<ServicePlugin> getServicePlugins() {
        return servicePluginList;
    }
}
