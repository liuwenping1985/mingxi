package com.xad.bullfly.core.bpmn.vo;

import com.xad.bullfly.core.bpmn.vo.XadWorkFlowDataView;
import com.xad.bullfly.core.bpmn.po.XadWorkFlowNode;
import lombok.Data;

import java.util.List;

/**
 * Created by liuwenping on 2020/9/8.
 */
@Data
public class XadWorkFlowContext<T> {

    private T bindObject;

    /**
     * 当前节点
     */
    private XadWorkFlowSequence currentSequence;

    /**
     * 数据视图
     */
    private XadWorkFlowDataView dataView;
    private XadWorkFlowTemplate template;
    private List<XadWorkFlowSequence> currentFlowSequenceList;
    private List<XadWorkFlowSequence> historySequenceList;
    private List<XadWorkFlowSequence> templateSequenceList;
    private XadWorkFlowSequence prevFlowSequence;
    private boolean onSingleSequence;
    private boolean onGatewaySequence;


}
