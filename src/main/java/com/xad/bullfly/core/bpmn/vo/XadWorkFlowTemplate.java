package com.xad.bullfly.core.bpmn.vo;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * Created by liuwenping on 2020/9/8.
 */
@Data
public class XadWorkFlowTemplate {
    private String id;
    private String name;
    private String version;
    private List<XadWorkFlowSequence> flowSequences;

}
