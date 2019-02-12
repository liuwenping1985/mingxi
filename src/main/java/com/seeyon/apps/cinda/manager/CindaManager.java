package com.seeyon.apps.cinda.manager;

import com.seeyon.apps.cinda.po.TMeetingConfig;

/**
 *
 * @author 刘世豪
 * @date 2017年3月4日
 *
 */
public interface CindaManager {

  String[] getCfgArray();

  TMeetingConfig getCfg();

  TMeetingConfig insertCfg(TMeetingConfig cfg);
}
