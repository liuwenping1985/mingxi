package com.seeyon.apps.kdXdtzXc.util;

import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.xpath.XPath;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Created by tap-pcng43 on 2017-10-1.
 */
public class XMLUtil {
    private static Logger logger = LoggerFactory.getLogger(XMLUtil.class);

    /**
     * DOCUMENT格式化输出保存为XML
     *
     * @param doc      JDOM的Document
     * @param filePath 输出文件路径
     * @throws Exception
     */
    public static void doc2XML(Document doc, String filePath) throws Exception {
        Format format = Format.getCompactFormat();
        format.setEncoding("UTF-8"); //设置XML文件的字符为UTF-8
        format.setIndent("     ");//设置缩进

        XMLOutputter outputter = new XMLOutputter(format);//定义输出 ,在元素后换行，每一层元素缩排四格
        FileWriter writer = new FileWriter(filePath);//输出流
        outputter.output(doc, writer);
        writer.close();
    }

    /**
     * 字符串转换为DOCUMENT
     *
     * @param xmlStr 字符串
     * @return doc JDOM的Document
     * @throws Exception
     */
    public static Document string2Doc(String xmlStr) throws Exception {
        java.io.Reader in = new StringReader(xmlStr);
        Document doc = (new SAXBuilder()).build(in);
        return doc;
    }



    /**
     * Document 转换为字符串
     *
     * @param doc Document
     * @return xmlStr 字符串
     * @throws Exception
     */
    public static String doc2String(Document doc) throws Exception {
        Format format = Format.getPrettyFormat();
        format.setEncoding("UTF-8");// 设置xml文件的字符为UTF-8，解决中文问题
        XMLOutputter xmlout = new XMLOutputter(format);
        ByteArrayOutputStream bo = new ByteArrayOutputStream();
        xmlout.output(doc, bo);
        return bo.toString();
    }

    /**
     * XML转换为Document
     *
     * @param xmlFilePath XML文件路径
     * @return doc Document对象
     * @throws Exception
     */
    public static Document xml2Doc(String xmlFilePath) throws Exception {
        File file = new File(xmlFilePath);
        return (new SAXBuilder()).build(file);
    }

    public static void main(String[] args) {
        try {
            String xml="" +
                    "" +
                    "<?xml version=\"1.0\" encoding=\"GBK\"?>" +
                    "<ROOT xmlns:asx=\"http://www.sap.com/abapxml\">" +
                    "<ZDATA>" +
                    "<HEADER>" +
                    "<HEADER_KEY>HR_HRMS-RPAATTP2HJFPAATTPTOdoH7bSQPAATTP3HJDPAATTP[HJSJ]djh</HEADER_KEY>" +
                    "<HEAD_TYPE>CREATE_TASK</HEAD_TYPE>" +
                    "</HEADER>" +
                    "<ITEM>" +
                    "<ITEM_KEY>1</ITEM_KEY>" +
                    "<APPNAME>HR</APPNAME>" +
                    "<MODELNAME>人事异动</MODELNAME>" +
                    "<MODELID>HRMS-RPAATTP2HJFPAATTPTOdoH7bSQPAATTP3HJDPAATTP[HJSJ]djh</MODELID>" +
                    "<SUBJECT>聘用人员审批表(刘莉  2017-09-22 10:14,共1人)已申请,请审批。</SUBJECT>" +
                    "<LINK></LINK>" +
                    "<SENDER>liuli</SENDER>" +
                    "<SENDERNAME>刘莉</SENDERNAME>" +
                    "<RECEIVER>djh</RECEIVER>" +
                    "<RECEIVERNAME>戴建华</RECEIVERNAME>" +
                    "<CREATETIME>2017-09-22 10:14:43</CREATETIME>" +
                    "</ITEM>" +
                    "</ZDATA>" +
                    "</ROOT>";
            string2Doc(xml);


        } catch (Exception e) {
            e.printStackTrace();
        }

    }




    public static List<?> getItemObjs(Class<?> classItem, String XMLSTRING) throws Exception {
        List resultList = new ArrayList();
        Document document = XMLUtil.string2Doc(XMLSTRING);
        Element root = document.getRootElement();

        XPath xpath = XPath.newInstance("/ROOT/ITEMS");
        List<?> list = xpath.selectNodes(root);//得到多个zdata
        Element zdata = (Element) list.get(0);//只处理第一个zdata


        List<Element> items = zdata.getChildren("ITEM");
        for (Element item : items) {
            Object resultObj = classItem.newInstance();
            List<Element> item_children = item.getChildren();//得到item的子对象
            for (Element item_child : item_children) {
                String name = item_child.getName();
                String text = item_child.getText();
                String entityField = EntityUtil.getEntityField(classItem, name);//model 中java字段
                try {
                    ToolkitUtil.setFiledValue(entityField, resultObj, text);
                } catch (Exception e) {
                    logger.error("实体类：" + classItem + ",中未找到，XML对应的元素=" + name + ",entityField=" + entityField + ",XML对应的值=" + text + ",items=" + items, e);
                }
            }
            resultList.add(resultObj);
        }
        return resultList;
    }
}
