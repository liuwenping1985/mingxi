package com.seeyon.apps.cinda.dao;

import com.seeyon.apps.cinda.po.TMeetingConfig;

/**
 *
 * @author 刘世豪
 * @date 2017年3月4日
 *
 */
public interface CindaDao {
  TMeetingConfig getCfg();

  void insertCfg(TMeetingConfig cfg);

  void deleteCfg();
}
