package com.xad.bullfly.core.bpmn;

import com.xad.bullfly.core.bpmn.po.XadWorkFlowNode;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlow;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlowCondition;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlowTemplate;

/**
 * 流程引擎接口
 * Created by liuwenping on 2020/9/8.
 */

public interface XadWorkFlowEngine {


    XadWorkFlow buildNewWorkFlowByTemplate(XadWorkFlowTemplate template,Object bindObject);

    String getVersion(XadWorkFlow flow);

    /**
     * 正常流转
     */
    void process(XadWorkFlow flow) throws XadBpmnException;

    /**
     * 开启流转，不开启 节点会一直处在START NODE 上
     * @param flow
     */
    void start(XadWorkFlow flow) throws XadBpmnException;

    /**
     *
     * unlockWhen
     */
    void unlockWhen(XadWorkFlowCondition condition);

    /**
     * 当。。。为true出现后挂起
     */
    void lockWhen(XadWorkFlowCondition condition);

    /**
     *
     * @param flow
     * @param deleteTrail
     */
    void backToPrevNode(XadWorkFlow flow,boolean deleteTrail);

    /**
     *
     * @param flow
     */
    void addNewNode(XadWorkFlow flow);

    /**
     *
     * @param flow
     */
    void jumpNextNode(XadWorkFlow flow);

    /**
     *
     * @param flowOne
     * @param flowTwo
     * @return
     */
    XadWorkFlow joinWorkFlow(XadWorkFlow flowOne, XadWorkFlow flowTwo);

    /**
     *
     * @param workFlowMoId
     * @return
     */
    XadWorkFlow loadXadWorkFlow(String workFlowMoId);

    /**
     *
     * @param current
     * @return
     */
    XadWorkFlowNode genNextNode(XadWorkFlowNode current);

}
