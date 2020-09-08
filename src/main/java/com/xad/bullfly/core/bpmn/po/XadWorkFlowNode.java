package com.xad.bullfly.core.bpmn.po;

import com.xad.bullfly.core.bpmn.constant.EnumWorkFlowNodeType;
import com.xad.bullfly.core.common.base.domain.BaseDomain;
import com.xad.bullfly.core.common.base.domain.mo.ManagedObject;
import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * 其实就是个有向图
 * Created by liuwenping on 2020/9/8.
 */
@Data
@Entity
@Table(name = "xad_work_flow_node")
public class XadWorkFlowNode extends BaseDomain<Long> implements ManagedObject<Long> {

    @Column(name = "node_name")
    private String nodeName;

    @Column(name = "node_id")
    private Long nodeId;

    @Column(name = "next_node")
    private Long nextNode;

    @Column(name = "prev_node")
    private Long prevNode;

    /**
     * 组概念，组的前边和后边一定是网关节点
     */
    @Column(name = "sibling_node_group")
    private Long siblingNodeGroup;

    @Column(name = "using_flag")
    private Integer usingFlag;


    @Column(name = "work_flow_id")
    private Long workFlowId;

    @Column(name = "node_type")
    private EnumWorkFlowNodeType nodeType;

    @Column(name = "bind_object")
    private String bindObject;

    @Column(name = "rule_name")
    private String ruleName;


    @Override
    public String getMoId() {
        return String.valueOf(getId());
    }

    @Override
    public String getMoReference() {
        return bindObject;
    }


}
