package com.seeyon.apps.duban.service;

import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgMember;

import java.util.Map;

public interface DubanScoreManager {

    void calculateDone(String taskId);
    boolean isCengban(V3xOrgMember member,Map dibiao);
    DubanTask getKeGuanScoreByCurrentUser(String taskId);

    void caculateScoreWhenStartOrProcess(String templateCode, ColSummary colSummary, V3xOrgMember member);

    void onFeedBackFinish(String templateCode, ColSummary colSummary, V3xOrgMember member) throws BusinessException;

    void onDoneApplyFinish(String templateCode, ColSummary colSummary, V3xOrgMember member) throws BusinessException;

    void onDelayApplyFinish(String templateCode, ColSummary colSummary, V3xOrgMember member) throws BusinessException;

    void onDoneApplyProcess(String templateCode, ColSummary colSummary, V3xOrgMember member)throws BusinessException;
}
