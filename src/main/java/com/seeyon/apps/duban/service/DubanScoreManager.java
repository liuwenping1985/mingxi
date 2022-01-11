package com.seeyon.apps.duban.service;

import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.duban.po.DubanTask;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgMember;

import java.util.Map;
<<<<<<< HEAD

public interface DubanScoreManager {

=======

public interface DubanScoreManager {
    public void onApprovingFinish(String formRecordId);
>>>>>>> 63ad5d083d5a37ffc7d3ef8c9ec5cd4624c76cc4
    void calculateDone(String taskId);
    boolean isCengban(V3xOrgMember member,Map dibiao);
    DubanTask getKeGuanScoreByCurrentUser(String taskId);

    void caculateScoreWhenStartOrProcess(String templateCode, ColSummary colSummary, V3xOrgMember member);

    void onFeedBackFinish(String templateCode, ColSummary colSummary, V3xOrgMember member) throws BusinessException;

    void onDoneApplyFinish(String templateCode, ColSummary colSummary, V3xOrgMember member) throws BusinessException;

    void onDelayApplyFinish(String templateCode, ColSummary colSummary, V3xOrgMember member) throws BusinessException;

    void onDoneApplyProcess(String templateCode, ColSummary colSummary, V3xOrgMember member)throws BusinessException;
}
