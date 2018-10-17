package com.seeyon.apps.nbd.core.form.entity;

import com.seeyon.apps.nbd.core.util.CommonUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class FormTableDefinition {
    private String affairType;
    private boolean is_push;
    private String modes;
    private FormTable formTable;

    public String getAffairType() {
        return affairType;
    }

    public void setAffairType(String affairType) {
        this.affairType = affairType;
    }

    public String getModes() {
        return modes;
    }

    public void setModes(String modes) {
        this.modes = modes;
    }

    public boolean isIs_push() {
        return is_push;
    }

    public void setIs_push(boolean is_push) {
        this.is_push = is_push;
    }

    public FormTable getFormTable() {
        return formTable;
    }

    public void setFormTable(FormTable formTable) {
        this.formTable = formTable;
    }

    public String genAllQuery() {
        return genAllQuery(this.getFormTable());
    }
    public static String genAllQuery(FormTable formTable) {

        // String table
        String tableName = formTable.getName();
        List<FormField> formFields = formTable.getFormFieldList();

        StringBuilder stb = new StringBuilder();
        if (CommonUtils.isEmpty(formFields)) {
            return null;
        }
        stb.append("select ");
        int tag = 0;
        for (FormField field : formFields) {
            if (tag == 0) {
                stb.append("t.").append(field.getName());

            } else {
                stb.append(",t.").append(field.getName());
            }

            tag++;

        }
        stb.append(" from ").append(tableName).append(" t");

        return stb.toString();


    }
    public static String genRawAllQuery(FormTable formTable) {

        // String table
        StringBuilder stb = new StringBuilder();
        String tableName = formTable.getName();
        stb.append("select *");
        stb.append(" from ").append(tableName);
        return stb.toString();


    }
    public List<List<SimpleFormField>> filledValue(List<Map> values) {
        List<FormField> formFields = this.getFormTable().getFormFieldList();
        List<List<SimpleFormField>> dataList = new ArrayList<List<SimpleFormField>>();
        if (CommonUtils.isEmpty(formFields)) {
            return dataList;
        }
        if (CommonUtils.isEmpty(values)) {
            return dataList;
        }
        for (Map objs : values) {
            if (CommonUtils.isEmpty(objs)) {
                continue;
            }

            List<SimpleFormField> sffList = new ArrayList<SimpleFormField>();
            for(FormField ff:formFields){
                SimpleFormField sff= new SimpleFormField();
                sff.setDisplay(ff.getDisplay());
                sff.setName(ff.getName());
                sff.setClassName(ff.getClassname());
                sff.setValue(objs.get(ff.getName()));
                sffList.add(sff);
            }
            int tag=0;
            List<FormTable> slaveTables = this.getFormTable().getSlaveTableList();
            if(!CommonUtils.isEmpty(slaveTables)){

                for(FormTable stable:slaveTables){
                    List<FormField> fList = stable.getFormFieldList();
                    Map<String,String> fieldNameMap = new HashMap<String, String>();
                    for(FormField f1:fList){
                        fieldNameMap.put(f1.getName(),f1.getDisplay());
                    }
                    List<Map> sDatas = (List<Map>)objs.get(stable.getDisplay());
                    SimpleFormField sf = new SimpleFormField();
                    sf.setDisplay(stable.getDisplay());
                    sf.setClassName("");
                    sf.setName(stable.getName());
                    if(!CommonUtils.isEmpty(sDatas)){
                        if(tag == 0){
                            System.out.println("filled Value");
                            System.out.println(sDatas);
                            System.out.println(" end of filled Value");
                            tag++;
                        }

                        List<Map> retData = new ArrayList<Map>();
                        for(Map data:sDatas){
                            Map ret = new HashMap();
                            for(Object key:data.keySet()){
                                String dispaly = fieldNameMap.get(String.valueOf(key));
                                if(!CommonUtils.isEmpty(dispaly)){
                                    ret.put(dispaly,data.get(key));
                                }

                            }
                            retData.add(ret);
                        }
                        sf.setValue(retData);
                        sffList.add(sf);
                    }


                }
            }

            dataList.add(sffList);
        }
        return dataList;

    }

    public String genInsertSQL() {


        return null;

    }
}
