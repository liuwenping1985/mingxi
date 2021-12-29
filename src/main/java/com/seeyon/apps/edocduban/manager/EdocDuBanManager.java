package com.seeyon.apps.edocduban.manager;

import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.annotation.AjaxAccess;

import java.util.Map;

public interface EdocDuBanManager {
    @AjaxAccess
    FlipInfo findedocSummaryList(FlipInfo fi, Map<String, Object> params);

    boolean saveOrUpdateEdocDuban(String summaryIds, String type);

    void sendOversee(Long edocId, String memberIds);

    boolean isDubanAdminSection(User user);

    String findoptionsById(Long valueOf);

    boolean rollbackEdocDuban(String summaryIds, String type);

    void deleteDuban(Long id);
}
