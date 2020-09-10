package com.xad.bullfly.core.bpmn;

import com.alibaba.fastjson.JSON;
import com.xad.bullfly.core.bpmn.constant.EnumWorkFlowNodeType;
import com.xad.bullfly.core.bpmn.constant.XadBPMNXMLElements;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlowSequence;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlowSequenceNode;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlowTemplate;
import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.springframework.util.StringUtils;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Created by liuwenping on 2020/9/8.
 */
public final class XadBpmnUtil {


    public static XadWorkFlowTemplate parseXadWorkFlowTemplateByFilePath(String content) {


        return null;

    }

    public static XadWorkFlowTemplate parseXadWorkFlowTemplateByFile(File file) throws XadBpmnException {
        XadWorkFlowTemplate template = new XadWorkFlowTemplate();
        SAXReader reader = new SAXReader();
        Document document = null;
        try {
            document = reader.read(file);
            Element root = document.getRootElement();
            String name = root.getName();
            if (!XadBPMNXMLElements.XAD_BPMN.equalsIgnoreCase(name)) {
                throw new XadBpmnException("不是合法的bpmn文件");
            }
            parseProcessAttribute(root, template);
            parseFlowSequences(root,template);
        } catch (DocumentException e) {
            e.printStackTrace();
        }
        return template;

    }

    private static void parseFlowSequences(Element root, XadWorkFlowTemplate template) {
        Element flowSequences = getSingleSpecificElementByName(XadBPMNXMLElements.FLOW_SEQUENCES, root);
        List<Element> sequencesList = getSpecificElementsByName(XadBPMNXMLElements.SEQUENCE, flowSequences);
        System.out.println(sequencesList.size());
        List<XadWorkFlowSequence> sequenceList = new ArrayList<>();
        for (Element ele : sequencesList) {
            XadWorkFlowSequence xadWorkFlowSequence = new XadWorkFlowSequence();
            parseFlowSequence(ele, xadWorkFlowSequence);
            sequenceList.add(xadWorkFlowSequence);
        }
        template.setFlowSequences(sequenceList);

    }

    private static void parseFlowSequence(Element sequenceElement, XadWorkFlowSequence sequence) {
        Attribute attributeId = sequenceElement.attribute("id");
        if (attributeId != null) {
            sequence.setId(attributeId.getValue());
        }
        //id="seq1" type="EVENT" link="NEXT-seq2"
        Attribute attributeType = sequenceElement.attribute("type");
        if (attributeType != null) {
            sequence.setType(attributeType.getValue());
        }
        Attribute attributeLink = sequenceElement.attribute("link");
        if (attributeLink != null) {
            sequence.setLink(attributeLink.getValue());
        }
        parseFlowSequenceNode(sequenceElement, sequence);
    }

    private static void parseFlowSequenceNode(Element sequenceElement, XadWorkFlowSequence sequence) {
        // name="督办员发起者填东西" type="COMMON" member-rule="SET" member-mode="single"  injection="NONE" output=""
        Element nodeElement = getSingleSpecificElementByName(XadBPMNXMLElements.SEQUENCE_NODE, sequenceElement);
        XadWorkFlowSequenceNode node = new XadWorkFlowSequenceNode();
        sequence.setNode(node);
        Attribute attribute = nodeElement.attribute("id");
        if (attribute != null) {
            node.setId(attribute.getValue());
        }
        attribute = nodeElement.attribute("name");
        if (attribute != null) {
            node.setName(attribute.getValue());
        }
        attribute = nodeElement.attribute("type");
        if (attribute != null) {
            node.setType(attribute.getValue());
        }
        attribute = nodeElement.attribute("member-rule");
        if (attribute != null) {
            node.setMemberRule(attribute.getValue());
        }
        attribute = nodeElement.attribute("member-mode");
        if (attribute != null) {
            node.setMemberMode(attribute.getValue());
        }
        attribute = nodeElement.attribute("injection");
        if (attribute != null) {
            node.setInjection(attribute.getValue());
        }
        attribute = nodeElement.attribute("output");
        if (attribute != null) {
            node.setOutput(attribute.getValue());
        }

    }

    private static void parseProcessAttribute(Element root, XadWorkFlowTemplate template) {
        Element process = getSingleSpecificElementByName(XadBPMNXMLElements.PROCESS, root);
        Attribute attributeId = process.attribute("id");
        if (attributeId != null) {
            template.setId(attributeId.getValue());
        }
        Attribute attributeName = process.attribute("name");
        if (attributeName != null) {
            template.setName(attributeName.getValue());
        }
    }

    public static XadWorkFlowTemplate parseXadWorkFlowTemplateByXmlContent(String content) {


        return null;

    }

    private static List<Element> getSpecificElementsByName(String eleName, Element parent) {

        List<Element> elementList = new ArrayList<>();
        if (StringUtils.isEmpty(eleName) || StringUtils.isEmpty(eleName.trim()) || parent == null) {
            return elementList;
        }
        String name = parent.getName();
        if (eleName.equals(name)) {
            elementList.add(parent);
        }
        travelElementsNode(eleName, parent, elementList);
        return elementList;

    }

    private static Element getSingleSpecificElementByName(String eleName, Element parent) {

        if (StringUtils.isEmpty(eleName) || StringUtils.isEmpty(eleName.trim()) || parent == null) {
            return null;
        }

        String name = parent.getName();
        if (eleName.equalsIgnoreCase(name)) {
            return parent;
        }
        return fetchSingleElementNode(eleName, parent);
    }

    private static void travelElementsNode(String nodeName, Element element, List<Element> nodeList) {
        if (element == null) {
            return;
        }
        Iterator<Element> iterator = element.elementIterator();
        while (iterator.hasNext()) {
            Element ele = iterator.next();
            if (nodeName.equalsIgnoreCase(ele.getName())) {
                nodeList.add(ele);
            } else {
                travelElementsNode(nodeName, ele, nodeList);
            }
        }

    }

    public static Element fetchSingleElementNode(String nodeName, Element element) {
        if (element == null) {
            return null;
        }

        Iterator<Element> iterator = element.elementIterator();
        while (iterator.hasNext()) {
            Element now = iterator.next();
            if (nodeName.equalsIgnoreCase(now.getName())) {
                return now;
            } else {
                Element child = fetchSingleElementNode(nodeName, now);
                if (child != null) {
                    return child;
                }
            }
        }
        return null;


    }

    public static void main(String[] args) {

        File file = new File(XadBpmnUtil.class.getResource("DemoWorkFlow.xml").getPath());

        try {
            XadWorkFlowTemplate xadWorkFlowTemplate = parseXadWorkFlowTemplateByFile(file);
            System.out.println(JSON.toJSONString(xadWorkFlowTemplate));
            System.out.println(EnumWorkFlowNodeType.START.name());
        } catch (XadBpmnException e) {
            e.printStackTrace();
        }

    }


}
