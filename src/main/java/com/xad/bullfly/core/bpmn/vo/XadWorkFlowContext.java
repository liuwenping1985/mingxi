package com.xad.bullfly.core.bpmn;

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
    private XadWorkFlowNode currentNode;

    /**
     * 数据视图
     */
    private XadWorkFlowDataView dataView;

    private List<XadWorkFlowNode> currentFlowNodeList;
    private XadWorkFlowNode currentFlowNode;
    private List<XadWorkFlowNode> historyNodeList;
    private XadWorkFlowNode prevFlowNode;
    private boolean onSingleNode;
    private boolean onGatewayNode;


}
