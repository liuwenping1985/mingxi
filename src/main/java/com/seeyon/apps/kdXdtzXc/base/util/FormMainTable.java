package com.seeyon.apps.kdXdtzXc.base.util;

import com.seeyon.apps.kdXdtzXc.base.manager.FormTableService;
import com.seeyon.apps.kdXdtzXc.base.model.Field;
import com.seeyon.apps.kdXdtzXc.base.model.Table;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.jdom.xpath.XPath;

import java.io.StringReader;
import java.util.*;

/**
 * Created by taoanping on 2014/11/24.
 */
public class FormMainTable {


    private List<TableInfoImpl> tableInfos = new ArrayList<TableInfoImpl>();
    private FormTableService formTableService;
    private List<Table> tables = new ArrayList<Table>();

    private Map<String, String> modelsClassTableNameMap = new HashMap<String, String>();
    private Map<String, Table> classNameTablesMap = new HashMap<String, Table>();

    public void setTableInfos(List<TableInfoImpl> tableInfos) {
        this.tableInfos = tableInfos;
    }
//


    public void setFormTableService(FormTableService formTableService) {
        this.formTableService = formTableService;
    }

    public Map<String, String> getModelsClassTableNameMap() {
        Set<Map.Entry<String, String>> set = modelsClassTableNameMap.entrySet();
        return modelsClassTableNameMap;
    }

    public Map<String, Table> getClassNameTablesMap() {
        return classNameTablesMap;
    }

    public FormMainTable() {

    }

    public void init() {
        try {
            System.out.println("初始化开始---------------");
            initTable();
            System.out.println("初始化结束---------------");

            initModelsClassTableNameMap();
            initClassNameTablesMap();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void initModelsClassTableNameMap() {
        for (Table t : tables) {
            String tableName = t.getName();
            String className = t.getClassName();
            System.out.println("获取表、类对应关系：className,tableName [" + className + "," + tableName + "]");
            modelsClassTableNameMap.put(className, tableName);
        }
        initClassNameTablesMap();
    }

    private void initClassNameTablesMap() {
        for (Table t : tables) {
            String className = t.getClassName();
            System.out.println("初始化类Model映射===" + className + "");
            classNameTablesMap.put(className, t);
        }
    }

    /**
     * 根据xml得到所有table对象
     * //
     */
//    private Map<String, Table> classTablesMap = null;
    public void initTable() throws Exception {

        for (TableInfoImpl tf : tableInfos) {
            int index = tf.getIndex();
            String name = tf.getName();
            String classname = tf.getClassname();
            Boolean bool = tf.getBreakCheck();
            Map<String, Object> formmainMap = formTableService.getFormAppMainDataByAppName(name);

            if (formmainMap == null) {
                if (bool != null) {
                    if (!bool) {
                        throw new RuntimeException("classname=" + classname + ",name=" + name + "在数据库中未找到其对应的表结构记录！");
                    } else {
                        System.out.println("严重警告,此错误必须解决！ classname=" + classname + ",name=" + name + "在数据库中未找到其对应的表结构记录！");
                    }
                }
            } else {

                String field_info = (String) formmainMap.get("field_info");
//            System.out.println("初始化xml信息：" + index + "," + name + "," + classname + "," + field_info + "\n");

                Table table = getTableFromXml(field_info, index);
                table.setFormName(name.trim());
                table.setClassName(classname.trim());
                table.setTableId(formmainMap.get("id") + "");
                tables.add(table);
            }
        }

        initModelsClassTableNameMap();
    }


    public static Table getTableFromXml(String xml, int postion) throws Exception {
        Document document = FormMainTable.string2Document(xml);//获得文档对象
        Element root = document.getRootElement();//获得根节点
        List<Element> list = XPath.selectNodes(root, "/TableList/Table[" + postion + "]");
        if (list == null || list.size() == 0) {
            throw new Exception("获取TableList/Table[" + postion + "]信息出错，未找到相应节点！");
        }

        Element e = list.get(0);
        String id = e.getAttributeValue("id");
        String name = e.getAttributeValue("name");
        String display = e.getAttributeValue("display");
        String tabletype = e.getAttributeValue("tabletype");
        String onwertable = e.getAttributeValue("onwertable");
        String onwerfield = e.getAttributeValue("onwerfield");

        if (StringUtils.isNullOrNone(name)) {
            throw new RuntimeException("未得到表單名稱,請查看數據庫：" + "     id=" + id + ",name=" + name + ",display=" + display + ",tabletype=" + tabletype);
        }
        Table table = new Table(id, name, display, tabletype, onwertable, onwerfield);
        System.out.println("     id=" + id + ",name=" + name + ",display=" + display + ",tabletype=" + tabletype);
        List<Element> listfield = XPath.selectNodes(root, "/TableList/Table[" + postion + "]/FieldList/Field");
//            /TableList/Table[1]/FieldList/Field
        if (listfield == null || listfield.size() == 0) {
            throw new Exception("获取TableList/Table[" + postion + "]/FieldList/Field信息出错，节点数不能为0！");
        }


        for (Element ef : listfield) {
            String id_f = ef.getAttributeValue("id");
            String name_f = ef.getAttributeValue("name");
            String display_f = ef.getAttributeValue("display");
            String fieldtype_f = ef.getAttributeValue("fieldtype");
            String fieldlength_f = ef.getAttributeValue("fieldlength");
            String is_null_f = ef.getAttributeValue("is_null");
            String is_primary_f = ef.getAttributeValue("is_primary");
            String classname_f = ef.getAttributeValue("classname");
//            System.out.println("\n            id=" + id_f + ",name=" + name_f + ",display=" + display_f + ",fieldtype=" + fieldtype_f);

            Field field = new Field(id_f, name_f, display_f, fieldtype_f, fieldlength_f, is_null_f, is_primary_f, classname_f);
            table.add(field);
        }
        return table;


    }


    public static Document string2Document(String xmlStr) throws Exception {
        java.io.Reader in = new StringReader(xmlStr);
        return (new SAXBuilder()).build(in);
    }

}
