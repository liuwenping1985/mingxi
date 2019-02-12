package com.seeyon.apps.cinda.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.cinda.manager.CindaManager;
import com.seeyon.ctp.common.controller.BaseController;

/**
 * 会议室申请时间设置界面控制器
 * @author 刘世豪
 * @date 2017年3月4日
 *
 */
public class CindaController extends BaseController {
  private final static Log log = LogFactory.getLog(CindaController.class);

  private CindaManager cindaManager;

  public CindaManager getCindaManager() {
    return cindaManager;
  }

  public void setCindaManager(CindaManager cindaManager) {
    this.cindaManager = cindaManager;
  }

  public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception {
    ModelAndView mv = new ModelAndView("plugin/cinda/index");
    mv.addObject("config", cindaManager.getCfg());
    return mv;
  }

}
