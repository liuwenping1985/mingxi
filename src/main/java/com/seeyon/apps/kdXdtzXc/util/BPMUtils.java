package com.seeyon.apps.kdXdtzXc.util;


import com.seeyon.apps.kdXdtzXc.oawsclient.BPMServiceStub;
import com.seeyon.oainterface.common.PropertyList;
import com.seeyon.oainterface.exportData.form.FormExport;
import com.seeyon.oainterface.exportData.form.ValueExport;


import java.io.StringWriter;

/**
 * 流程表单发送类
 */
public class BPMUtils {
    /**
     * 表单元素变成xml字符串
     *
     * @param export
     * @return
     * @throws Exception
     */
    public String toString(FormExport export)
            throws Exception {
        StringWriter writer = new StringWriter();
        PropertyList plist = export.saveToPropertyList();
        plist.saveXMLToStream(writer);
        return writer.toString();
    }

    /**
     * 封装元素
     *
     * @param name
     * @param value
     * @return
     */
    public static ValueExport wapperValueExport(String name, String value) {
        ValueExport ve = new ValueExport();
        ve.setDisplayName(name);
        ve.setValue(value);
        return ve;
    }


    public FormExport xmlTOFormExport(String xml) throws Exception {
        FormExport export = new FormExport();
        PropertyList property = new PropertyList("FromExport", 1);
        property.loadFromXml(xml);
        export.loadFromPropertyList(property);
        return export;
    }

    public FormExport xmlFromFormExport(String xml) throws Exception {
        FormExport export = new FormExport();
        PropertyList property = new PropertyList("FromExport", -1);
        property.loadFromXml(xml);
        export.loadFromPropertyList(property);
        return export;
    }

    public String getTemplateDefinition(String templateCode) throws Exception {
        BPMServiceStub stub = new BPMServiceStub(Axis2ConfigurationContextUtil.getConfigurationContext());

        BPMServiceStub.GetTemplateDefinition gt = new BPMServiceStub.GetTemplateDefinition();
        gt.setToken(OaWebServiceUtil.getTokenId());
        gt.setTemplateCode(templateCode);

        BPMServiceStub.GetTemplateDefinitionResponse res = stub.getTemplateDefinition(gt);

        String[] export = res.get_return();
        return export[1];
    }


    /**
     * 发送协同表单
     *
     * @param token
     * @param subject
     * @param senderLoginName
     * @param templateCode
     * @param data
     * @param param
     * @return
     * @throws Exception
     */
    public BPMServiceStub.ServiceResponse lauchFormCollaboration(String token, String subject, String senderLoginName, String templateCode, String data, String param) throws Exception {
        BPMServiceStub stub = new BPMServiceStub(Axis2ConfigurationContextUtil.getConfigurationContext());
        BPMServiceStub.LaunchFormCollaboration bl = new BPMServiceStub.LaunchFormCollaboration();
        bl.setToken(token);
        bl.setData(data);
        bl.setParam(param);
        bl.setSenderLoginName(senderLoginName);
        bl.setSubject(subject);
        bl.setTemplateCode(templateCode);
        bl.setAttachments(null);
        BPMServiceStub.LaunchFormCollaborationResponse res = stub.launchFormCollaboration(bl);
        BPMServiceStub.ServiceResponse response = res.get_return();
        return response;

    }


    public long getFlowState(String token, long flowId) throws Exception {
        BPMServiceStub stub = new BPMServiceStub(Axis2ConfigurationContextUtil.getConfigurationContext());
        BPMServiceStub.GetFlowState bl = new BPMServiceStub.GetFlowState();
        bl.setToken(token);
        bl.setFlowId(flowId);
        BPMServiceStub.GetFlowStateResponse res = stub.getFlowState(bl);
        return res.get_return();
        //        return response;
    }


}