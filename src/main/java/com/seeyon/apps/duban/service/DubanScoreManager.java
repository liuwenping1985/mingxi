package com.seeyon.apps.duban.service;

import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.organization.bo.V3xOrgMember;

public interface DubanScoreManager {


    void caculateScoreWhenStartOrProcess(String templateCode, ColSummary colSummary, V3xOrgMember member);

    void onFeedBackFinish(String templateCode, ColSummary colSummary, V3xOrgMember member) throws BusinessException;

    void onDoneApplyFinish(String templateCode, ColSummary colSummary, V3xOrgMember member) throws BusinessException;

    void onDelayApplyFinish(String templateCode, ColSummary colSummary, V3xOrgMember member) throws BusinessException;

    void onDoneApplyProcess(String templateCode, ColSummary colSummary, V3xOrgMember member)throws BusinessException;
}
