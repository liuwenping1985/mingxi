package com.xad.bullfly.core.bpmn.vo;

import com.xad.bullfly.core.bpmn.XadWorkFlowContext;
import com.xad.bullfly.core.bpmn.po.XadWorkFlowNode;
import lombok.Data;

import java.util.List;

/**
 * 工作流的定义，简单为主
 * Created by liuwenping on 2020/9/8.
 */
@Data
public class XadWorkFlow<T> {
    /**
     * 0 创建
     * 1 开始流转
     * 2 流转中
     * 3 流转完成
     */
    private Integer status;

    /**
     * 数据版本，极其重要
     */
    private String dataVersion;
    /**
     * 包含流转所需的上下文
     */
    private XadWorkFlowContext<T> workFlowContext;


    private List<XadWorkFlowNode> getWorkFlowNodeList;





}
