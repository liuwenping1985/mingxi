package com.xad.bullfly.core.bpmn.vo;

import lombok.Data;

import java.util.Date;

/**
 * Created by liuwenping on 2020/9/8.
 */
@Data
public class XadWorkFlowTemplate {
    private Long id;
    private String name;
    private String content;
    private Date createDate;
    private Date updateDate;

}
