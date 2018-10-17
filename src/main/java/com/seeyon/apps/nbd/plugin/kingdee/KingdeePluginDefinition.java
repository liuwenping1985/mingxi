package com.seeyon.apps.nbd.plugin.kingdee;

import com.seeyon.apps.nbd.core.service.ServicePlugin;
import com.seeyon.apps.nbd.platform.plugin.constant.EnumPluginType;
import com.seeyon.apps.nbd.plugin.PluginDefinition;
import com.seeyon.apps.nbd.plugin.als.service.impl.AlsServicePluginImpl;
import com.seeyon.apps.nbd.plugin.kingdee.service.KingdeeWsService;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by liuwenping on 2018/10/17.
 */
public class KingdeePluginDefinition implements PluginDefinition {

    private static List<String> AFFAIR_TYPE_LIST = new ArrayList<String>();

    static{
        AFFAIR_TYPE_LIST.add("HTFKSQD1");
        AFFAIR_TYPE_LIST.add("HTFKSQD2");
        AFFAIR_TYPE_LIST.add("HTFKSQD_GLFY");
        AFFAIR_TYPE_LIST.add("HTFKSQD_YXFY");
        AFFAIR_TYPE_LIST.add("HTFKSQD_GZFY");
        AFFAIR_TYPE_LIST.add("KJLHTFKSQD_GLFY1");
        AFFAIR_TYPE_LIST.add("KJLHTFKSQD_GLFY2");
        AFFAIR_TYPE_LIST.add("KJLHTFKSQD_YXFY");
        AFFAIR_TYPE_LIST.add("HTFKSQB_FGCL");
        AFFAIR_TYPE_LIST.add("FKSQB_FHTL");
        AFFAIR_TYPE_LIST.add("GLFYBXD1");
        AFFAIR_TYPE_LIST.add("GLFYBXD2");
        AFFAIR_TYPE_LIST.add("FYBXD1");
        AFFAIR_TYPE_LIST.add("FYBXD2");
        AFFAIR_TYPE_LIST.add("YXFYBXD1");
        AFFAIR_TYPE_LIST.add("YXFYBXD2");
        AFFAIR_TYPE_LIST.add("YXFYBXD3");

        AFFAIR_TYPE_LIST.add("GDZCFYBXD1");
        AFFAIR_TYPE_LIST.add("GDZCFYBXD2");
        AFFAIR_TYPE_LIST.add("JKSPD1");
        AFFAIR_TYPE_LIST.add("JKSPD2");
        AFFAIR_TYPE_LIST.add("CLFBXD1");
        AFFAIR_TYPE_LIST.add("CLFBXD2");
        AFFAIR_TYPE_LIST.add("YXCLFBXD1");
        AFFAIR_TYPE_LIST.add("YXCLFBXD2");

    }
    public String getPluginName() {
        return "金蝶付款单导入";
    }
    public  KingdeePluginDefinition(){
        service = new KingdeeWsService(this);
    }
    private KingdeeWsService service;
    public String getPluginId() {
        return "king_dee_bill_import";
    }

    public List<String> getSupportAffairTypes() {
        List<String> list = new ArrayList<String>();
        list.addAll(AFFAIR_TYPE_LIST);
        return list;
    }

    public boolean containAffairType(String affairType) {
        return AFFAIR_TYPE_LIST.contains(affairType);
    }

    public ServicePlugin getServicePlugin() {
        return service;
    }
    private static List<EnumPluginType> list = new ArrayList<EnumPluginType>();
    static{

        list.add(EnumPluginType.EXPORT_WS);
    }
    public List<EnumPluginType> getPluginType() {

        return list;
    }
}
