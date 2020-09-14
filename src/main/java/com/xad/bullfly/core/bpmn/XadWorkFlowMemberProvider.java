package com.xad.bullfly.core.bpmn;

import com.xad.bullfly.core.bpmn.vo.XadWorkFlow;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlowSequence;
import com.xad.bullfly.organization.domain.UserDomain;

import java.util.List;

/**
 * Created by liuwenping on 2020/9/11.
 */
public interface XadWorkFlowMemberProvider {

    List<UserDomain> getMultiUsers(String ruleName,XadWorkFlow flow,XadWorkFlowSequence sequence);

    UserDomain getSingleUser(String ruleName,XadWorkFlow flow,XadWorkFlowSequence sequence);

}
