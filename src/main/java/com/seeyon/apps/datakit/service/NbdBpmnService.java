package com.seeyon.apps.datakit.service;

import com.kg.commons.utils.CollectionUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.comment.CommentManager;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.bean.FormTableBean;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.manager.OrgManagerDirect;
import com.seeyon.ctp.services.CTPLocator;
import com.seeyon.ctp.util.json.JSONUtil;
import com.seeyon.oainterface.common.PropertyList;
import com.seeyon.v3x.edoc.dao.EdocOpinionDao;
import com.seeyon.v3x.services.document.DocumentFactory;
import com.seeyon.v3x.services.flow.FlowFactory;
import com.seeyon.v3x.services.flow.FlowService;
import com.seeyon.v3x.services.flow.FlowUtil;
import com.seeyon.v3x.services.flow.log.FlowLog;
import com.seeyon.v3x.services.flow.log.FlowLogFactory;
import com.seeyon.v3x.services.form.FormUtils;
import com.seeyon.v3x.services.form.bean.DefinitionExport;
import com.seeyon.v3x.services.form.bean.FormExport;
import com.seeyon.v3x.services.form.bean.SubordinateFormExport;
import com.seeyon.v3x.services.util.SaveFormToXml;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.tree.BaseElement;

import java.io.IOException;
import java.io.StringWriter;
import java.net.URLDecoder;
import java.util.*;

/**
 * Created by liuwenping on 2018/12/17.
 */
public class NbdBpmnService {

    private FlowLogFactory flowLog = FlowLogFactory.getInstance(NbdBpmnService.class);
    private static Log log = LogFactory.getLog(NbdBpmnService.class);
    private FlowFactory flowFactory;
    private FormManager formManager;
    private DocumentFactory documentFactory;
    private FlowService flowService;
    private TemplateManager templateManager;
    private EdocOpinionDao edocOpinionDao;
    private AffairManager affairManager;
    private OrgManager orgManager;
    private OrgManagerDirect orgManagerDirect;
    private CommentManager commentManager;
    //private WorkflowSuperNodeApi api;


    public long sendCollaboration(String templateCode, Map<String, Object> param) throws  Exception, BusinessException {
        String transfertype = "xml";
        transfertype = (String) param.get("transfertype");
        Map<String, Object> mapError = new HashMap();
        if ("json".equals(transfertype)) {
            param = this.jsonValueToXml(param, templateCode);
            System.out.println(param);
            if (param == null) {
                //com.seeyon.ctp.workflow.supernode.
                mapError.put("success", Boolean.valueOf(false));
                mapError.put("msg", "转换JSON失败！");
                throw new RuntimeException("转换JSON失败！");
            }
        }
        if (this.flowFactory == null) {
            this.flowFactory = (FlowFactory) AppContext.getBean("flowFactory");
        }

        if (this.templateManager == null) {
            this.templateManager = (TemplateManager) AppContext.getBean("templateManager");
        }

        if (this.formManager == null) {
            this.formManager = (FormManager) AppContext.getBean("formManager");
        }
        //TemplateManagerImpl impl;
        Object bodyContent = null;
        CtpTemplate template = this.templateManager.getTempleteByTemplateNumber(templateCode);
        if (template != null && template.getWorkflowId() != null) {
            String senderLoginName = (String) param.get("senderLoginName");
            String subject = URLDecoder.decode((String) param.get("subject"), "UTF-8");
            String state = (String) param.get("param");
            String data = (String) param.get("data");


            Map<String, Object> relevantParam = new HashMap();
            if (param.get("accountCode") != null) {
                List<V3xOrgEntity> listEntity = this.getOrgManagerDirect().getEntityNoRelationDirect("V3xOrgAccount", "code", (String) param.get("accountCode"), (Boolean) null, (Long) null);
                if (listEntity.size() > 0) {
                    relevantParam.put("accountId", ((V3xOrgEntity) listEntity.get(0)).getId());
                }
            }

            Long[] attachments;
            if (param.get("formContentAtt") != null) {
                attachments = this.list2LongArray((List) param.get("formContentAtt"));
                relevantParam.put("formContentAtt", attachments);
            }

            attachments = this.list2LongArray((List) param.get("attachments"));
            boolean isForm = template.getModuleType().intValue() == 1 && Integer.valueOf(template.getBodyType()).intValue() == 20;
            FormExport formExportData = null;
            data = this.enumValueToId(data, templateCode);
            if (isForm) {
                if (FormUtils.getXmlVersion(data) == 2.0D) {
                    formExportData = FormUtils.xmlTransformFormExport(data);
                } else {
                    formExportData = new FormExport();
                    PropertyList propertyList = new PropertyList("FormExport", 1);
                    propertyList.loadFromXml(data);
                    formExportData.loadFromPropertyList(propertyList);
                }
            }

            long summaryId = -1L;
            if (relevantParam.size() > 0) {
                summaryId = this.flowFactory.sendCollaboration(senderLoginName, templateCode, subject, formExportData, attachments, state, (String) null);
            } else {
                summaryId = this.flowFactory.sendCollaboration(senderLoginName, templateCode, subject, formExportData, attachments, state, (String) null);
            }
            FlowLog l = new FlowLog();
            l.setSubject(subject);
            l.setData(data);
            l.setSenderLoginName(senderLoginName);
            l.setTemplateCode(templateCode);
            this.flowLog.info(l);

            return summaryId;
        } else {
            throw new Exception( "模板编号不存在:" + templateCode);
        }
    }

    public OrgManagerDirect getOrgManagerDirect() {
        if (this.orgManagerDirect == null) {
            this.orgManagerDirect = (OrgManagerDirect) AppContext.getBean("orgManagerDirect");
        }

        return this.orgManagerDirect;
    }

    private Long[] list2LongArray(List list) {
        if (list == null) {
            return new Long[0];
        } else {
            int size = list.size();
            Long[] array = new Long[size];

            for (int i = 0; i < size; ++i) {
                Object o = list.get(i);
                if (o == null) {
                    continue;
                }
                array[i] = Long.valueOf(((Number) o).longValue());
            }

            return array;
        }
    }

    private String enumValueToId(String data, String templateCode) {
        CtpTemplate template = this.templateManager.getTempleteByTemplateNumber(templateCode);
        if (template == null) {
            return data;
        } else {
            try {
                boolean isForm = template.getModuleType().intValue() == 1 && Integer.valueOf(template.getBodyType()).intValue() == 20;
                if (isForm) {
                    FormBean formBean = this.formManager.getFormByFormCode(template);
                    List<FormFieldBean> allFields = formBean.getAllFieldBeans();
                    Map<String, FormFieldBean> columnMap = new LinkedHashMap();
                    Map<String, FormFieldBean> parentFieldMap = new LinkedHashMap();
                    Map<String, String> enumFieldValueMap = new LinkedHashMap();
                    Iterator var10 = allFields.iterator();

                    while (true) {
                        FormFieldBean field;
                        Iterator var12;
                        do {
                            if (!var10.hasNext()) {
                                Document document = DocumentHelper.parseText(data);
                                Element formExportEle = (Element) document.selectSingleNode("/formExport");
                                var12 = columnMap.keySet().iterator();

                                while (true) {
                                    Element subEle;
                                    String columnName;
                                    List subordinateFormExportList;
                                    do {
                                        do {
                                            if (!var12.hasNext()) {
                                                return document.asXML();
                                            }

                                            columnName = (String) var12.next();
                                            List<Element> valueExportList = formExportEle.selectNodes("./values/column[@name='" + columnName + "']");
                                            if (valueExportList != null && valueExportList.size() > 0) {
                                                Iterator var15 = valueExportList.iterator();

                                                while (var15.hasNext()) {
                                                    Element ele = (Element) var15.next();
                                                    subEle = ele.element("value");
                                                    String value = (String) subEle.getData();
                                                    if (StringUtils.isNotEmpty(value)) {
                                                        String enumValue = this.getEnumValue((FormFieldBean) columnMap.get(columnName), value, parentFieldMap, enumFieldValueMap);
                                                        enumFieldValueMap.put(columnName, enumValue);
                                                        subEle.setText(enumValue);
                                                    }
                                                }
                                            }

                                            subordinateFormExportList = formExportEle.selectNodes("./subForms/subForm");
                                        } while (subordinateFormExportList == null);
                                    } while (subordinateFormExportList.size() <= 0);

                                    Iterator var30 = subordinateFormExportList.iterator();

                                    while (var30.hasNext()) {
                                        subEle = (Element) var30.next();
                                        List<Element> recordExportList = subEle.selectNodes("./values/row");
                                        Iterator var32 = recordExportList.iterator();

                                        while (var32.hasNext()) {
                                            Element recordEle = (Element) var32.next();
                                            Element ele = (Element) recordEle.selectSingleNode("column[@name='" + columnName + "']");
                                            if (ele != null) {
                                                Element valueEle = ele.element("value");
                                                String value = (String) valueEle.getData();
                                                if (StringUtils.isNotEmpty(value)) {
                                                    String enumValue = this.getEnumValue((FormFieldBean) columnMap.get(columnName), value, parentFieldMap, enumFieldValueMap);
                                                    enumFieldValueMap.put(columnName, enumValue);
                                                    valueEle.setText(enumValue);
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            field = (FormFieldBean) var10.next();
                        } while (field.getEnumId() == 0L);

                        if (StringUtils.isNotEmpty(field.getEnumParent())) {
                            var12 = allFields.iterator();

                            while (var12.hasNext()) {
                                FormFieldBean bean = (FormFieldBean) var12.next();
                                if (field.getEnumParent().equals(bean.getName())) {
                                    parentFieldMap.put(field.getDisplay(), bean);
                                    break;
                                }
                            }
                        }

                        columnMap.put(field.getDisplay(), field);
                    }
                }
            } catch (Exception var25) {
                log.error(var25);
            }

            return data;
        }
    }


    private String getEnumValue(FormFieldBean fieldBean, String value, Map<String, FormFieldBean> parentFieldMap, Map<String, String> enumValueMap) {
        EnumManager enumManager = null;

        try {
            enumManager = (EnumManager) CTPLocator.getInstance().lookup(EnumManager.class);
            List<CtpEnumItem> enumValues = enumManager.getEmumItemByEmumId(Long.valueOf(fieldBean.getEnumId()));
            int level = fieldBean.getEnumLevel();
            Iterator var8 = enumValues.iterator();

            label37:
            while (true) {
                CtpEnumItem item;
                do {
                    if (!var8.hasNext()) {
                        break label37;
                    }

                    item = (CtpEnumItem) var8.next();
                } while (!value.equals(item.getEnumvalue()) && !value.equals(item.getId()));

                if (level == item.getLevelNum().intValue()) {
                    FormFieldBean parentFildBean = (FormFieldBean) parentFieldMap.get(fieldBean.getDisplay());
                    if (parentFildBean == null) {
                        return String.valueOf(item.getId());
                    }

                    String strParentId = String.valueOf(item.getParentId());
                    if (strParentId.equals(enumValueMap.get(parentFildBean.getDisplay()))) {
                        return String.valueOf(item.getId());
                    }
                }
            }
        } catch (Exception var12) {
            var12.printStackTrace();
        }

        log.error("请检查oa系统的枚举值是否存在 value=" + value + "字段：" + fieldBean.getDisplay());
        return value;
    }

    public FlowLogFactory getFlowLog() {
        return flowLog;
    }

    public void setFlowLog(FlowLogFactory flowLog) {
        this.flowLog = flowLog;
    }

    public FlowFactory getFlowFactory() {
        if (this.flowFactory == null) {
            this.flowFactory = (FlowFactory) AppContext.getBean("flowFactory");
        }
        return flowFactory;
    }

    public void setFlowFactory(FlowFactory flowFactory) {
        this.flowFactory = flowFactory;
    }

    public FormManager getFormManager() {
        return formManager;
    }

    public void setFormManager(FormManager formManager) {
        this.formManager = formManager;
    }

    public DocumentFactory getDocumentFactory() {
        if (this.documentFactory == null) {
            this.documentFactory = (DocumentFactory) AppContext.getBean("documentFactory");
        }
        return documentFactory;
    }

    public void setDocumentFactory(DocumentFactory documentFactory) {
        this.documentFactory = documentFactory;
    }

    public FlowService getFlowService() {
        return flowService;
    }

    public void setFlowService(FlowService flowService) {
        this.flowService = flowService;
    }

    public TemplateManager getTemplateManager() {
        return templateManager;
    }

    public void setTemplateManager(TemplateManager templateManager) {
        this.templateManager = templateManager;
    }

    public EdocOpinionDao getEdocOpinionDao() {
        return edocOpinionDao;
    }

    public void setEdocOpinionDao(EdocOpinionDao edocOpinionDao) {
        this.edocOpinionDao = edocOpinionDao;
    }

    public AffairManager getAffairManager() {
        return affairManager;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    public OrgManager getOrgManager() {
        return orgManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setOrgManagerDirect(OrgManagerDirect orgManagerDirect) {
        this.orgManagerDirect = orgManagerDirect;
    }

    public CommentManager getCommentManager() {
        return commentManager;
    }

    public void setCommentManager(CommentManager commentManager) {
        this.commentManager = commentManager;
    }

//    public WorkflowSuperNodeApi getApi() {
//        return api;
//    }
//
//    public void setApi(WorkflowSuperNodeApi api) {
//        this.api = api;
//    }


    private Map<String, Object> jsonValueToXml(Map<String, Object> param, String templateCode) {
        if (this.templateManager == null) {
            this.templateManager = (TemplateManager) AppContext.getBean("templateManager");
        }

        if (this.formManager == null) {
            this.formManager = (FormManager) AppContext.getBean("formManager");
        }

        String templateXml = "";
        List<FormFieldBean> mainFields = new ArrayList();
        ArrayList subFields = new ArrayList();

        try {
            templateXml = this.getFlowFactory().getTemplateXml(templateCode);
        } catch (Exception var28) {
            var28.printStackTrace();
        }

        String data = (String) param.get("data");
        CtpTemplate template = this.templateManager.getTempleteByTemplateNumber(templateCode);
        if (template != null && templateXml.length() != 0 && !"".equals(templateXml)) {
            try {
                Document document = DocumentHelper.parseText(templateXml);
                Element priceTmp = document.getRootElement().element("subForms").element("subForm");
                List<Element> subDellist = document.selectNodes("//subForms/subForm");

                for (int i = 0; i < subDellist.size(); ++i) {
                    Element delSub = (Element) subDellist.get(i);
                    delSub.getParent().remove(delSub);
                }

                templateXml = document.asXML();
                Map jsonObject = (Map) JSONUtil.parseJSONString(data);
                List sub = (List) jsonObject.get("sub");
                boolean isForm = template.getModuleType().intValue() == 1 && Integer.valueOf(template.getBodyType()).intValue() == 20;
                if (isForm) {
                    FormBean formBean = this.formManager.getFormByFormCode(template);
                    List<FormFieldBean> allFields = formBean.getAllFieldBeans();
                    Iterator var16 = allFields.iterator();

                    while (var16.hasNext()) {
                        FormFieldBean field = (FormFieldBean) var16.next();
                        if (field.isMasterField()) {
                            mainFields.add(field);
                        } else {
                            subFields.add(field);
                        }
                    }

                    document = DocumentHelper.parseText(templateXml);
                    Element formExportEle = (Element) document.selectSingleNode("/formExport");
                    Iterator var33 = mainFields.iterator();

                    while (true) {
                        FormFieldBean field;
                        List valueExportList;
                        Element ele;
                        Element row;
                        do {
                            do {
                                if (!var33.hasNext()) {
                                    Element subForms = document.getRootElement().element("subForms");
                                    List subFormslist = subForms.elements();
                                    if (sub != null && sub.size() > 0) {
                                        for (int i = 0; i < sub.size(); ++i) {
                                            Element subForm = new BaseElement("subForm");

                                            Map jsonSub = (Map) JSONUtil.parseJSONString(sub.get(i).toString());
                                            if ("YES".equals(jsonSub.get("multi"))) {
                                               // System.out.println("0000000009999999");
                                                List list = (List) jsonSub.get("data");
                                                //System.out.println("0000000009999999：" + list.size());
                                                if (!CollectionUtils.isEmpty(list)) {
                                                    ele = subForm.addElement("values");
                                                    for (int o = 0; o < list.size(); o++) {
                                                        Map jsonSubSub = (Map) list.get(o);

                                                        row = ele.addElement("row");
                                                        //System.out.println("jsonSubSub0000000009999999：" + jsonSubSub);
                                                        Iterator var23 = subFields.iterator();

                                                        while (var23.hasNext()) {
                                                            field = (FormFieldBean) var23.next();
                                                            if (jsonSubSub.get(field.getName()) != null) {
                                                                Element column = row.addElement("column");
                                                                column.addAttribute("name", field.getDisplay());
                                                                // System.out.println("<<<<-----jsonSub----->>>>" + jsonSub);
                                                                Element value = column.addElement("value");
                                                                value.setText(jsonSubSub.get(field.getName()).toString());
                                                            }

                                                        }
                                                    }

                                                }

                                            } else {
                                                ele = subForm.addElement("values");
                                                row = ele.addElement("row");
                                                Iterator var23 = subFields.iterator();

                                                while (var23.hasNext()) {
                                                    field = (FormFieldBean) var23.next();

                                                    //System.out.println("jsonSub----->>>>" + jsonSub);
                                                    if (jsonSub.get(field.getName()) != null) {
                                                        Element column = row.addElement("column");
                                                        column.addAttribute("name", field.getDisplay());
                                                        System.out.println("<<<<-----jsonSub----->>>>" + jsonSub);
                                                        Element value = column.addElement("value");
                                                        value.setText(jsonSub.get(field.getName()).toString());
                                                    }
                                                }
                                            }
                                            subFormslist.add(i, subForm);
                                        }
                                    }

                                    param.put("data", document.asXML());
                                    return param;
                                }

                                field = (FormFieldBean) var33.next();
                                valueExportList = formExportEle.selectNodes("./values/column[@name='" + field.getDisplay() + "']");
                            } while (valueExportList == null);
                        } while (valueExportList.size() <= 0);

                        Iterator var20 = valueExportList.iterator();

                        while (var20.hasNext()) {
                            ele = (Element) var20.next();
                            row = ele.element("value");

                            if (jsonObject.get(field.getName()) != null) {
                                row.setText(jsonObject.get(field.getName()).toString());
                            }
                        }
                    }
                }
            } catch (Exception var29) {
                log.error(var29);
            }

            return null;
        } else {
            return null;
        }
    }

    public String getTemplateXml(String templateCode) throws Exception {
        CtpTemplate template = this.getTemplateManager().getTempleteByTemplateNumber(templateCode);
        String result = "";
        if(template != null && template.getWorkflowId() != null) {
            String bodyType = template.getBodyType();
            if(bodyType.equals(String.valueOf(MainbodyType.FORM.getKey()))) {
                FormExport export = new FormExport();

                FormBean formBean;
                try {
                    formBean = this.getFormManager().getFormByFormCode(template);
                } catch (BusinessException var19) {
                    throw new Exception(var19.getLocalizedMessage());
                }

                List<DefinitionExport> define = new ArrayList();
                List<SubordinateFormExport> subordinateFormExport = new ArrayList();
                export.setSubordinateForms(subordinateFormExport);
                FormTableBean masterTableBean = formBean.getMasterTableBean();
                export.setFormName(masterTableBean.getTableName());
                export.setDefinitions(define);
                List<FormFieldBean> fieldBean = masterTableBean.getFields();
                Iterator var11 = fieldBean.iterator();

                while(var11.hasNext()) {
                    FormFieldBean field = (FormFieldBean)var11.next();
                    FlowUtil.getDefinition(field, define);
                    //logger.debug(field.getDisplay() + " " + field.getFieldType() + " ");
                }

                List<FormTableBean> subtalbes = formBean.getSubTableBean();
                Iterator var21 = subtalbes.iterator();

                while(var21.hasNext()) {
                    FormTableBean formTableBean = (FormTableBean)var21.next();
                    SubordinateFormExport sub = new SubordinateFormExport();
                    List<DefinitionExport> subDefine = new ArrayList();
                    sub.setDefinitions(subDefine);
                    subordinateFormExport.add(sub);
                    List<FormFieldBean> subfieldBeans = formTableBean.getFields();
                    Iterator var17 = subfieldBeans.iterator();

                    while(var17.hasNext()) {
                        FormFieldBean subFieldValue = (FormFieldBean)var17.next();
                        FlowUtil.getDefinition(subFieldValue, subDefine);
                        //logger.debug(subFieldValue.getDisplay() + " " + subFieldValue.getFieldType() + " ");
                    }
                }

                result = this.toXml(export);
            }

            return result;
        } else {
            throw new Exception("模板id不存在:" + templateCode);
        }
    }

    private String toXml(FormExport export) {
        StringWriter writer = new StringWriter();

        try {
            SaveFormToXml.getInstance().saveXMLToStream(writer, export);
        } catch (IOException var4) {
            var4.printStackTrace();
        }

        return writer.toString();
    }
}
