package com.xad.bullfly.core.bpmn;

import com.xad.bullfly.core.bpmn.po.XadWorkFlowNode;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlow;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlowTemplate;

/**
 * Created by liuwenping on 2020/9/8.
 */

public interface XadWorkFlowEngine {


    XadWorkFlow buildNewWorkFlowByTemplate(XadWorkFlowTemplate template);

    String getVersion(XadWorkFlow flow);

    /**
     * 正常流转
     */
    void process(XadWorkFlow flow);

    /**
     * 开启流转，不开启 节点会一直处在START NODE 上
     * @param flow
     */
    void start(XadWorkFlow flow);

    /**
     * 挂起直到。。。。为false
     */
    void lockUntil(XadWorkFlowCondition condition);

    /**
     * 当。。。为true出现后挂起
     */
    void lockWhen(XadWorkFlowCondition condition);

    void backToPrevNode(XadWorkFlow flow,boolean deleteTrail);

    void addNewNode(XadWorkFlow flow);

    void jumpNextNode(XadWorkFlow flow);

    XadWorkFlow joinWorkFlow(XadWorkFlow flowOne, XadWorkFlow flowTwo);

    XadWorkFlow loadXadWorkFlow(Long workFlowId);

    XadWorkFlowNode genNextNode(XadWorkFlowNode current);

}
