package com.seeyon.apps.collaboration.batch.manager;

import com.seeyon.apps.collaboration.batch.BatchResult;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;

import java.util.Map;

/**
 * Created by tap-pcng43 on 2017-11-16.
 */
public interface BatchManager {
    BatchResult[] checkPreBatch(Map var1);
    BatchResult[] checkPreBatch(Map var1,User user);

    public Object transDoBatch(Map<String, String> var1) throws BusinessException;
    
    // 客开 SZP
    public Object transDoBatch1(Map<String, String> param);
 }
