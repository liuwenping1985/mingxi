package com.seeyon.apps.kdXdtzXc.vo;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.Text;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by tap-pcng43 on 2017-10-1.
 */
public class XmlResult implements Serializable {
    private Boolean result;
    private String message;
    private String oa_id;

    public XmlResult() {
    }

    public XmlResult(Boolean result, String message, String oa_id) {
        this.result = result;
        this.message = message;
        this.oa_id = oa_id;
    }

    public static String toXML(List<XmlResult> list) {
        try {
            Document doc = new Document();


            Element root = new Element("ROOT");
            doc.setRootElement(root);
            Element items = new Element("ITEMS");

            root.addContent(items);
            for (XmlResult xmlResult : list) {

                Element item = new Element("ITEM");
                items.addContent(item);

                Element result = new Element("RESULT");
                Text result_text = new Text((xmlResult.getResult()+""));
                result.addContent(result_text);
                item.addContent(result);


                Element message = new Element("MESSAGE");
                Text message_text = new Text((xmlResult.getMessage()));
                message.addContent(message_text);
                item.addContent(message);

                Element oaId = new Element("OA_ID");
                Text oaId_text = new Text((xmlResult.getOa_id()));
                oaId.addContent(oaId_text);
                item.addContent(oaId);


            }
            XMLOutputter outputter = null;
            Format format = Format.getCompactFormat();
            format.setEncoding("UTF-8");
            format.setIndent("    ");

            outputter = new XMLOutputter(format);
            String outxml = outputter.outputString(doc);
//            System.out.println(outxml);
            return outxml;
//                  outputter.output(doc, new FileOutputStream("C:\\a.xml"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Boolean getResult() {
        return result;
    }

    public void setResult(Boolean result) {
        this.result = result;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getOa_id() {
        return oa_id;
    }

    public void setOa_id(String oa_id) {
        this.oa_id = oa_id;
    }
}
