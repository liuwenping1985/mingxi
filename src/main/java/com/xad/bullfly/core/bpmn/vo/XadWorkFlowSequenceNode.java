package com.xad.bullfly.core.bpmn.vo;

import lombok.Data;

/**
 * Created by liuwenping on 2020/9/9.
 */
@Data
public class XadWorkFlowSequenceNode {
// name="督办员领导审批" type="APPROVAL" member-rule="SET" member-mode="single"  injection="NONE" output=""
    private String name;
    private String type;
    private String memberRule;
    private String memberMode;
    private String injection;
    private String output;
    private String id;
    private String flowId;
    private Object bindObject;
}
