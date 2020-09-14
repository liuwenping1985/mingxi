package com.xad.bullfly.apps.hhsd.service;

import com.xad.bullfly.core.bpmn.XadWorkFlowMemberProvider;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlow;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlowSequence;
import com.xad.bullfly.organization.domain.UserDomain;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by liuwenping on 2020/9/11.
 */
@Service("hhsdWorkFlowRuleProvider")
public class HhsdWorkFlowRuleProvider implements XadWorkFlowMemberProvider {
    @Override
    public List<UserDomain> getMultiUsers(String ruleName, XadWorkFlow flow, XadWorkFlowSequence sequence) {
        return null;
    }

    @Override
    public UserDomain getSingleUser(String ruleName, XadWorkFlow flow, XadWorkFlowSequence sequence) {
        return null;
    }

}
