package com.seeyon.apps.duban.util;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.apache.commons.io.IOUtils;
import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.json.JSONException;
import org.json.XML;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

/**
 * Created by liuwenping on 2018/8/21.
 */
public class XmlUtils {

    public static String xml2jsonString(String file) throws IOException {
        InputStream in = new FileInputStream(file);
        try {

            String xml = IOUtils.toString(in, "utf-8");
            return xmlString2jsonString(xml);
        } catch (IOException e) {
            throw new IOException(e);
        } finally {
            try {
                in.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    }

    public static String xml2jsonString(InputStream ins) throws IOException {

        String xml = IOUtils.toString(ins, "utf-8");
        return xmlString2jsonString(xml);
        // JSONObject xmlJSONObj = JSON.parseObject(xml);
        //  ProductInfo info;

    }

    public static String xml2jsonString(File f) throws IOException {
        FileInputStream ins = new FileInputStream(f);
        String xml = IOUtils.toString(ins, "UTF-8");

        try {
            String xmlJSONObj = xmlString2jsonString(xml);
            return xmlJSONObj;
        } catch (Exception e) {
            String jsonPath = f.getPath().split("mapping.xml")[0] + "json";
            String jsonString = IOUtils.toString(new FileInputStream(jsonPath), "UTF-8");
            //System.out.println(CommonUtils.unicodeEncoding(jsonString));
            return jsonString;
        } finally {
            try {
                ins.close();
            } catch (Exception e) {

            }
        }
    }

    public static String xmlString2jsonString(String xml) throws IOException {

        try {


            if (!xml.startsWith("<xml>")) {
                xml = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>" + xml;
            }

            Document document = DocumentHelper.parseText(xml);
            JSONObject xmlJSONObj = elementToJSONObject(document.getRootElement());
            return xmlJSONObj.toString();
        } catch (Exception e) {
            e.printStackTrace();
            try {
                org.json.JSONObject xmlJSONObj2 = XML.toJSONObject(xml);
                return xmlJSONObj2.toString();
            } catch (JSONException e1) {
                e1.printStackTrace();
            }
        }
        return null;
    }

    public static JSONObject elementToJSONObject(Element node) {
        JSONObject result = new JSONObject();
        // 当前节点的名称、文本内容和属性
        List<Attribute> listAttr = node.attributes();// 当前节点的所有属性的list
        for (Attribute attr : listAttr) {// 遍历当前节点的所有属性
            result.put(attr.getName(), attr.getValue());
        }
        // 递归遍历当前节点所有的子节点
        List<Element> listElement = node.elements();// 所有一级子节点的list
        if (!listElement.isEmpty()) {
            for (Element e : listElement) {// 遍历所有一级子节点
                if (e.attributes().isEmpty() && e.elements().isEmpty()) // 判断一级节点是否有属性和子节点
                    result.put(e.getName(), e.getTextTrim());// 沒有则将当前节点作为上级节点的属性对待
                else {
                    if (!result.containsKey(e.getName())) // 判断父节点是否存在该一级节点名称的属性
                        result.put(e.getName(), new JSONArray());// 没有则创建
                    ((JSONArray) result.get(e.getName())).add(elementToJSONObject(e));// 将该一级节点放入该节点名称的属性对应的值中
                }
            }
        }
        return result;
    }

    public static void main(String[] args){

        String okkkk="<TableList>\n" +
                "  <Table id=\"5554112918501740061\" name=\"formmain_0019\" display=\"formmain_0019\" tabletype=\"master\" onwertable=\"\" onwerfield=\"\">\n" +
                "      <FieldList>\n" +
                "          <Field id=\"-1712431140999116959\" name=\"id\" display=\"id\" fieldtype=\"long\" fieldlength=\"20\" is_null=\"true\" is_primary=\"true\" classname=\"\"/>\n" +
                "          <Field id=\"6023245774948551645\" name=\"state\" display=\"审核状态\" fieldtype=\"int\" fieldlength=\"10\" is_null=\"true\" is_primary=\"false\" classname=\"\"/> \n" +
                "          <Field id=\"966513741284331425\" name=\"start_member_id\" display=\"发起人\" fieldtype=\"long\" fieldlength=\"20\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-3602744034126640568\" name=\"start_date\" display=\"发起时间\" fieldtype=\"DATETIME\" fieldlength=\"\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"3194509924598826938\" name=\"approve_member_id\" display=\"审核人\" fieldtype=\"long\" fieldlength=\"20\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"396830507602235086\" name=\"approve_date\" display=\"审核时间\" fieldtype=\"DATETIME\" fieldlength=\"\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-676984960791261232\" name=\"finishedflag\" display=\"流程状态\" fieldtype=\"int\" fieldlength=\"10\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"6884667872870551025\" name=\"ratifyflag\" display=\"核定状态\" fieldtype=\"int\" fieldlength=\"10\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"5630301962049964435\" name=\"ratify_member_id\" display=\"核定人\" fieldtype=\"long\" fieldlength=\"20\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-9067971215433711219\" name=\"ratify_date\" display=\"核定时间\" fieldtype=\"DATETIME\" fieldlength=\"\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                "          \n" +
                "          \n" +
                "          <Field id=\"5479141484875499388\" name=\"field0002\" display=\"任务ID\" fieldtype=\"VARCHAR\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"4716701594930466540\" name=\"field0003\" display=\"任务来源\" fieldtype=\"VARCHAR\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"6068339337607333405\" name=\"field0004\" display=\"任务分级\" fieldtype=\"VARCHAR\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"6067078568363640656\" name=\"field0005\" display=\"标题\" fieldtype=\"VARCHAR\" fieldlength=\"4000,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"5999366037928693006\" name=\"field0006\" display=\"办理要求\" fieldtype=\"VARCHAR\" fieldlength=\"4000,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"8850999688703854807\" name=\"field0007\" display=\"任务附件\" fieldtype=\"VARCHAR\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-2848739088027007490\" name=\"field0008\" display=\"办理时限\" fieldtype=\"TIMESTAMP\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"2473538289671424505\" name=\"field0009\" display=\"督办周期\" fieldtype=\"VARCHAR\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-5803083144017985044\" name=\"field0010\" display=\"督办周期补充\" fieldtype=\"VARCHAR\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"7872166115798895630\" name=\"field0011\" display=\"责任领导\" fieldtype=\"VARCHAR\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-7608918241102838230\" name=\"field0013\" display=\"督办员\" fieldtype=\"VARCHAR\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-4309202922925110913\" name=\"field0014\" display=\"完成率\" fieldtype=\"DECIMAL\" fieldlength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-6045270961425726387\" name=\"field0015\" display=\"汇报内容\" fieldtype=\"VARCHAR\" fieldlength=\"4000,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"5230030545537615829\" name=\"field0016\" display=\"汇报人\" fieldtype=\"VARCHAR\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"484557050152373272\" name=\"field0017\" display=\"汇报日期\" fieldtype=\"TIMESTAMP\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"109655695240414572\" name=\"field0018\" display=\"申请事由\" fieldtype=\"VARCHAR\" fieldlength=\"4000,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-859521818270940527\" name=\"field0019\" display=\"办结日期\" fieldtype=\"TIMESTAMP\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"8607193627566294639\" name=\"field0020\" display=\"领导意见\" fieldtype=\"LONGTEXT\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"1358001321477489738\" name=\"field0001\" display=\"申请办结\" fieldtype=\"VARCHAR\" fieldlength=\"5,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"3268203037208496872\" name=\"field0012\" display=\"权重\" fieldtype=\"DECIMAL\" fieldlength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-7895761139554169686\" name=\"field0025\" display=\"承办部门\" fieldtype=\"VARCHAR\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"6695056222540090536\" name=\"field0026\" display=\"上次完成率\" fieldtype=\"DECIMAL\" fieldlength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"7809437617553556961\" name=\"field0027\" display=\"承办负责人\" fieldtype=\"VARCHAR\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"606566718902258680\" name=\"field0028\" display=\"汇报分\" fieldtype=\"DECIMAL\" fieldlength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"4686726114650637141\" name=\"field0029\" display=\"综合分-停用\" fieldtype=\"DECIMAL\" fieldlength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"6896876719047134508\" name=\"field0030\" display=\"任务量\" fieldtype=\"DECIMAL\" fieldlength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "      </FieldList>\n" +
                "      <IndexList>\n" +
                "      </IndexList>\n" +
                "  </Table>\n" +
                "  <Table id=\"-7219191875736418184\" name=\"formson_0020\" display=\"group2\" tabletype=\"slave\" onwertable=\"formmain_0019\" onwerfield=\"formmain_id\">\n" +
                "      <FieldList>\n" +
                "          <Field id=\"7448624023205006182\" name=\"field0021\" display=\"序号\" fieldtype=\"DECIMAL\" fieldlength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-1269489251419992562\" name=\"field0022\" display=\"节点任务\" fieldtype=\"VARCHAR\" fieldlength=\"4000,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-7057446201676509248\" name=\"field0023\" display=\"要求完成时间\" fieldtype=\"TIMESTAMP\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "          <Field id=\"-7780298532008345133\" name=\"field0024\" display=\"备注\" fieldtype=\"VARCHAR\" fieldlength=\"4000,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                "      </FieldList>\n" +
                "      <IndexList>\n" +
                "      </IndexList>\n" +
                "  </Table>\n" +
                "</TableList>\n";

            String  k2 = "<TableList>\n" +
                    "  <Table id=\"5554112918501740061\" name=\"formmain_0019\" display=\"formmain_0019\" tabletype=\"master\" o\n" +
                    "nwertable=\"\" onwerfield=\"\">\n" +
                    "      <FieldList>\n" +
                    "          <Field id=\"-1712431140999116959\" name=\"id\" display=\"id\" fieldtype=\"long\" fieldlength=\"20\"\n" +
                    " is_null=\"true\" is_primary=\"true\" classname=\"\"/>\n" +
                    "          <Field id=\"6023245774948551645\" name=\"state\" display=\"���״̬\" fieldtype=\"int\" fieldlength=\"\n" +
                    "10\" is_null=\"true\" is_primary=\"false\" classname=\"\"/> \n" +
                    "          <Field id=\"966513741284331425\" name=\"start_member_id\" display=\"������\" fieldtype=\"long\" f\n" +
                    "ieldlength=\"20\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-3602744034126640568\" name=\"start_date\" display=\"����ʱ��\" fieldtype=\"DATETIME\"\n" +
                    " fieldlength=\"\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"3194509924598826938\" name=\"approve_member_id\" display=\"�����\" fieldtype=\"long\"\n" +
                    " fieldlength=\"20\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"396830507602235086\" name=\"approve_date\" display=\"���ʱ��\" fieldtype=\"DATETIME\" \n" +
                    "fieldlength=\"\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-676984960791261232\" name=\"finishedflag\" display=\"���״̬\" fieldtype=\"int\" fieldl\n" +
                    "ength=\"10\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"6884667872870551025\" name=\"ratifyflag\" display=\"�˶�״̬\" fieldtype=\"int\" fieldlen\n" +
                    "gth=\"10\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"5630301962049964435\" name=\"ratify_member_id\" display=\"�˶���\" fieldtype=\"long\" \n" +
                    "fieldlength=\"20\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-9067971215433711219\" name=\"ratify_date\" display=\"�˶�ʱ��\" fieldtype=\"DATETIME\"\n" +
                    " fieldlength=\"\" is_null=\"true\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          \n" +
                    "          \n" +
                    "          <Field id=\"5479141484875499388\" name=\"field0002\" display=\"����ID\" fieldtype=\"VARCHAR\" fie\n" +
                    "ldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"4716701594930466540\" name=\"field0003\" display=\"������Դ\" fieldtype=\"VARCHAR\" fi\n" +
                    "eldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"6068339337607333405\" name=\"field0004\" display=\"����ּ�\" fieldtype=\"VARCHAR\" fiel\n" +
                    "dlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"6067078568363640656\" name=\"field0005\" display=\"����\" fieldtype=\"VARCHAR\" field\n" +
                    "length=\"4000,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"5999366037928693006\" name=\"field0006\" display=\"����Ҫ��\" fieldtype=\"VARCHAR\" fi\n" +
                    "eldlength=\"4000,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"8850999688703854807\" name=\"field0007\" display=\"���\uD9A3\uDF7C�\" fieldtype=\"VARCHAR\" fiel\n" +
                    "dlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-2848739088027007490\" name=\"field0008\" display=\"����ʱ��\" fieldtype=\"TIMESTAMP\"\n" +
                    " fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"2473538289671424505\" name=\"field0009\" display=\"��������\" fieldtype=\"VARCHAR\" f\n" +
                    "ieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-5803083144017985044\" name=\"field0010\" display=\"�������ڲ���\" fieldtype=\"VARCHA\n" +
                    "R\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"7872166115798895630\" name=\"field0011\" display=\"�����쵼\" fieldtype=\"VARCHAR\" fi\n" +
                    "eldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-7608918241102838230\" name=\"field0013\" display=\"����Ա\" fieldtype=\"VARCHAR\" fie\n" +
                    "ldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-4309202922925110913\" name=\"field0014\" display=\"�����\" fieldtype=\"DECIMAL\" fie\n" +
                    "ldlength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-6045270961425726387\" name=\"field0015\" display=\"�㱨����\" fieldtype=\"VARCHAR\" f\n" +
                    "ieldlength=\"4000,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"5230030545537615829\" name=\"field0016\" display=\"�㱨��\" fieldtype=\"VARCHAR\" fiel\n" +
                    "dlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"484557050152373272\" name=\"field0017\" display=\"�㱨����\" fieldtype=\"TIMESTAMP\" f\n" +
                    "ieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"109655695240414572\" name=\"field0018\" display=\"��������\" fieldtype=\"VARCHAR\" fi\n" +
                    "eldlength=\"4000,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-859521818270940527\" name=\"field0019\" display=\"�������\" fieldtype=\"TIMESTAMP\" \n" +
                    "fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"8607193627566294639\" name=\"field0020\" display=\"�쵼���\" fieldtype=\"LONGTEXT\" fi\n" +
                    "eldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"1358001321477489738\" name=\"field0001\" display=\"������\" fieldtype=\"VARCHAR\" fie\n" +
                    "ldlength=\"5,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"3268203037208496872\" name=\"field0012\" display=\"Ȩ��\" fieldtype=\"DECIMAL\" fieldl\n" +
                    "ength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-7895761139554169686\" name=\"field0025\" display=\"�а첿��\" fieldtype=\"VARCHAR\" fi\n" +
                    "eldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"6695056222540090536\" name=\"field0026\" display=\"�ϴ������\" fieldtype=\"DECIMAL\" f\n" +
                    "ieldlength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"7809437617553556961\" name=\"field0027\" display=\"�а츺����\" fieldtype=\"VARCHAR\" f\n" +
                    "ieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"606566718902258680\" name=\"field0028\" display=\"�㱨��\" fieldtype=\"DECIMAL\" field\n" +
                    "length=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"4686726114650637141\" name=\"field0029\" display=\"�ۺϷ�-ͣ��\" fieldtype=\"DECIMAL\" fi\n" +
                    "eldlength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"6896876719047134508\" name=\"field0030\" display=\"������\" fieldtype=\"DECIMAL\" fie\n" +
                    "ldlength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "      </FieldList>\n" +
                    "      <IndexList>\n" +
                    "      </IndexList>\n" +
                    "  </Table>\n" +
                    "  <Table id=\"-7219191875736418184\" name=\"formson_0020\" display=\"group2\" tabletype=\"slave\" onwertabl\n" +
                    "e=\"formmain_0019\" onwerfield=\"formmain_id\">\n" +
                    "      <FieldList>\n" +
                    "          <Field id=\"7448624023205006182\" name=\"field0021\" display=\"���\" fieldtype=\"DECIMAL\" fieldl\n" +
                    "ength=\"20,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-1269489251419992562\" name=\"field0022\" display=\"�ڵ�����\" fieldtype=\"VARCHAR\" f\n" +
                    "ieldlength=\"4000,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-7057446201676509248\" name=\"field0023\" display=\"Ҫ�����ʱ��\" fieldtype=\"TIMESTAM\n" +
                    "P\" fieldlength=\"255,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "          <Field id=\"-7780298532008345133\" name=\"field0024\" display=\"��ע\" fieldtype=\"VARCHAR\" field\n" +
                    "length=\"4000,0\" is_null=\"false\" is_primary=\"false\" classname=\"\"/>\n" +
                    "      </FieldList>\n" +
                    "      <IndexList>\n" +
                    "      </IndexList>\n" +
                    "  </Table>\n" +
                    "</TableList>";


        System.out.println(k2.replaceAll("play=\"\\s+\\S+\" fieldtype","play=\"\" fieldtype"));



    }


}

