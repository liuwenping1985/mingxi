package com.xad.bullfly.core.bpmn;

import com.xad.bullfly.core.bpmn.vo.XadWorkFlowSequenceNode;

/**
 * Created by liuwenping on 2020/9/11.
 */
public interface XadWorkFlowEventListener {

    void onStart(XadWorkFlowSequenceNode node);

    void onProcess(XadWorkFlowSequenceNode node);

    void onFinish(XadWorkFlowSequenceNode node);

    void onBack(XadWorkFlowSequenceNode node);

}
