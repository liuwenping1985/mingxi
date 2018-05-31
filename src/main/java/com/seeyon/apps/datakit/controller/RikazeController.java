package com.seeyon.apps.datakit.controller;

import com.seeyon.apps.datakit.service.RikazeService;
import com.seeyon.ctp.common.controller.BaseController;

/**
 * Created by liuwenping on 2018/5/31.
 */
public class RikazeController extends BaseController {

    private RikazeService rikazeService;

    public RikazeService getRikazeService() {
        return rikazeService;
    }

    public void setRikazeService(RikazeService rikazeService) {
        this.rikazeService = rikazeService;
    }




}
