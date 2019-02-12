package com.seeyon.apps.cinda.manager;

import com.seeyon.apps.cinda.dao.CindaDao;
import com.seeyon.apps.cinda.po.TMeetingConfig;
import com.seeyon.ctp.util.annotation.AjaxAccess;

/**
 *
 * @author 刘世豪
 * @date 2017年3月4日
 *
 */
public class CindaManagerImpl implements CindaManager {
  private CindaDao cindaDao;

  public CindaDao getCindaDao() {
    return cindaDao;
  }

  public void setCindaDao(CindaDao cindaDao) {
    this.cindaDao = cindaDao;
  }

  @AjaxAccess
  @Override
  public String[] getCfgArray() {
    TMeetingConfig cfg = getCfg();
    if (cfg != null) {
      return new String[] {cfg.getStartTime(), cfg.getEndTime(), String.valueOf(cfg.getDays())};
    }
    return null;
  }

  @AjaxAccess
  @Override
  public TMeetingConfig getCfg() {
    return cindaDao.getCfg();
  }

  @AjaxAccess
  @Override
  public TMeetingConfig insertCfg(TMeetingConfig cfg) {
    cindaDao.insertCfg(cfg);
    return getCfg();
  }

}
