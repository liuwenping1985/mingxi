package com.seeyon.apps.kdXdtzXc.dao;

import com.seeyon.apps.kdXdtzXc.po.TravelExpenseXinChengDetail;
import com.seeyon.apps.kdXdtzXc.po.TravelExpenseXinChengDetail;
import com.seeyon.ctp.common.dao.BaseHibernateDao;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public class TravelExpenseXinChengDetailDaoImpl  extends BaseHibernateDao<TravelExpenseXinChengDetail>  implements TravelExpenseXinChengDetailDao {
    @Override
    public void save(TravelExpenseXinChengDetail travelExpenseXinChengDetail) {
        this.getHibernateTemplate().saveOrUpdate(travelExpenseXinChengDetail);
    }

    @Override
    public void delete(Long id) {
        super.delete(id);
    }

    @Override
    public TravelExpenseXinChengDetail getTravelExpenseXinChengDetail(Long id) {
        return super.get(id);
    }


}
