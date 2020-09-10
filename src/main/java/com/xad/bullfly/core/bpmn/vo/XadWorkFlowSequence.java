package com.xad.bullfly.core.bpmn.vo;

import lombok.Data;

/**
 * Created by liuwenping on 2020/9/9.
 */
@Data
public class XadWorkFlowSequence {
// id="seq1" type="EVENT" link="NEXT-seq2"
    private String id;
    private String type;
    private String link;
    private XadWorkFlowSequenceNode node;
}
