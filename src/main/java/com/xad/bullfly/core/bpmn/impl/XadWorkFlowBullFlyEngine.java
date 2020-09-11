package com.xad.bullfly.core.bpmn.impl;

import com.alibaba.fastjson.JSON;
import com.xad.bullfly.core.bpmn.XadBpmnException;
import com.xad.bullfly.core.bpmn.XadWorkFlowEventPublisher;
import com.xad.bullfly.core.bpmn.constant.EnumWorkFlowNodeType;
import com.xad.bullfly.core.bpmn.constant.EnumWorkFlowStatus;
import com.xad.bullfly.core.bpmn.constant.XadEventType;
import com.xad.bullfly.core.bpmn.vo.*;
import com.xad.bullfly.core.bpmn.XadWorkFlowEngine;
import com.xad.bullfly.core.bpmn.po.XadWorkFlowNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * 有限状态机
 * Created by liuwenping on 2020/9/8.
 */
@Component("xadWorkFlowEngine")
public class XadWorkFlowBullFlyEngine implements XadWorkFlowEngine {

    @Autowired
    private XadWorkFlowEventPublisher xadWorkFlowEventPublisher;

    @Override
    public XadWorkFlow buildNewWorkFlowByTemplate(XadWorkFlowTemplate template, Object bindObject) {

        XadWorkFlow workFlow = new XadWorkFlow();
        workFlow.setTemplateContent(JSON.toJSONString(template));
        XadWorkFlowContext context = new XadWorkFlowContext();
        context.setBindObject(bindObject);
        workFlow.setWorkFlowContext(context);
        List<XadWorkFlowSequence> sequenceList = template.getFlowSequences();
        workFlow.setMoId(UUID.randomUUID().toString());
        workFlow.setMoReference(template.getId());
        workFlow.setDataVersion(template.getVersion());
        workFlow.setStatus(EnumWorkFlowStatus.START);
        context.setTemplateSequenceList(sequenceList);
        for (XadWorkFlowSequence sq : sequenceList) {
            if (EnumWorkFlowNodeType.START.name().equalsIgnoreCase(sq.getType())) {
                context.setCurrentSequence(sq);
                context.setOnSingleSequence(true);
                context.setOnGatewaySequence(false);
                List<XadWorkFlowSequence> nodeList = new ArrayList<>();
                nodeList.add(context.getCurrentSequence());
                context.setCurrentFlowSequenceList(nodeList);
            }
        }
        return workFlow;
    }

    @Override
    public String getVersion(XadWorkFlow flow) {
        return flow.getDataVersion();
    }

    @Override
    public void process(XadWorkFlow flow) throws XadBpmnException {

        XadWorkFlowSequence seq = flow.getWorkFlowContext().getCurrentSequence();
        String link = seq.getLink();
        //TODO:这里需要扩展，现在都是往下走
        if (link.startsWith("NEXT-")) {
            toNext(flow);
        }

    }

    private void toNext(XadWorkFlow flow) throws XadBpmnException {

        XadWorkFlowSequence currentSequence = flow.getWorkFlowContext().getCurrentSequence();
        //寻找下一个节点
        List<XadWorkFlowSequence> templateSeqs = flow.getWorkFlowContext().getTemplateSequenceList();
        String next = currentSequence.getLink();
        XadWorkFlowSequence nextSeq = getNextSequence(next, templateSeqs);
        String nextSeqType = nextSeq.getType();
        if ("NODE_TEMPLATE_PARALLEL".equals(nextSeqType)) {
            XadWorkFlowSequenceNode node = nextSeq.getNode();
            String injection = node.getInjection();


        } else if ("EVENT".equals(nextSeqType) || "COMMON".equals(nextSeqType)) {


        } else if ("APPROVAL".equals(nextSeqType)) {

        }

    }

    private XadWorkFlowSequence getNextSequence(String link, List<XadWorkFlowSequence> templateSeqs) throws XadBpmnException {

        for (XadWorkFlowSequence seq : templateSeqs) {
            String key = "NEXT-" + seq.getId();
            if (link.equalsIgnoreCase(key)) {
                return seq;
            }

        }
        throw new XadBpmnException("找不到下一节点");
    }

    @Override
    public void start(XadWorkFlow flow) throws XadBpmnException {
        if (!EnumWorkFlowStatus.START.equals(flow.getStatus())) {
            throw new XadBpmnException("流程状态不处于开始状态");
        } else {
            xadWorkFlowEventPublisher.receiveEvent(XadEventType.START, flow);
        }
        process(flow);

    }

    @Override
    public void unlockWhen(XadWorkFlowCondition condition) {

    }

    @Override
    public void lockWhen(XadWorkFlowCondition condition) {

    }

    @Override
    public void backToPrevNode(XadWorkFlow flow, boolean deleteTrail) {

    }

    @Override
    public void addNewNode(XadWorkFlow flow) {

    }

    @Override
    public void jumpNextNode(XadWorkFlow flow) {

    }

    @Override
    public XadWorkFlow joinWorkFlow(XadWorkFlow flowOne, XadWorkFlow flowTwo) {
        return null;
    }

    @Override
    public XadWorkFlow loadXadWorkFlow(String workFlowId) {
        return null;
    }

    @Override
    public XadWorkFlowNode genNextNode(XadWorkFlowNode current) {
        return null;
    }
}
