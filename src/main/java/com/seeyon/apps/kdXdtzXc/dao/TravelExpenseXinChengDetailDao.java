package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.po.TravelExpenseXinChengDetail;
import com.seeyon.ctp.common.dao.support.CriteriaSetup;
import com.seeyon.ctp.common.dao.support.page.Page;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.news.domain.NewsBody;
import com.seeyon.v3x.news.domain.NewsReply;

import java.util.*;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public interface TravelExpenseXinChengDetailDao {

    void save(TravelExpenseXinChengDetail travelExpenseXinChengDetail);

    void delete(Long id);

    TravelExpenseXinChengDetail getTravelExpenseXinChengDetail(Long id);
}
