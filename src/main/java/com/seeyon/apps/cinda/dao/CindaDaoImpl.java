package com.seeyon.apps.cinda.dao;

import java.util.List;

import com.seeyon.apps.cinda.po.TMeetingConfig;
import com.seeyon.ctp.util.DBAgent;

/**
 *
 * @author 刘世豪
 * @date 2017年3月4日
 *
 */
public class CindaDaoImpl implements CindaDao {

  @Override
  public TMeetingConfig getCfg() {
    List<TMeetingConfig> list = DBAgent.loadAll(TMeetingConfig.class);
    if (list != null && list.size() > 0) {
      return list.get(0);
    }
    return null;
  }

  @Override
  public void insertCfg(TMeetingConfig cfg) {
    cfg.setId(1L);
    deleteCfg();
    DBAgent.save(cfg);
  }

  @Override
  public void deleteCfg() {
    TMeetingConfig entity = getCfg();
    if (null != entity) {
      DBAgent.delete(entity);
    }
  }

}
