package com.xad.bullfly.core.bpmn;

import com.xad.bullfly.ApplicationStarter;
import com.xad.bullfly.core.bpmn.po.XadWorkFlowNode;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlow;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlowContext;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlowSequence;
import com.xad.bullfly.organization.domain.UserDomain;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Created by liuwenping on 2020/9/8.
 */
@Component("xadWorkFlowRuleProvider")
public class XadWorkFlowRuleProvider implements XadWorkFlowMemberProvider{

    @Override
    public List<UserDomain> getMultiUsers(String ruleName, XadWorkFlow flow, XadWorkFlowSequence sequence) {
        return null;
    }

    @Override
    public UserDomain getSingleUser(String ruleName, XadWorkFlow flow, XadWorkFlowSequence sequence) {
        return null;
    }
}
