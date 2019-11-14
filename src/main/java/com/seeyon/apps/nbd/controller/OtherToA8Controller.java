package com.seeyon.apps.nbd.controller;

import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.service.NbdService;
import com.seeyon.apps.duban.util.UIUtils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 数据主要用本地oa连接
 * Created by liuwenping on 2018/12/3.
 */
public class OtherToA8Controller extends BaseController {

    private NbdService nbdService;

    public NbdService getNbdService() {
        return nbdService;
    }

    public void setNbdService(NbdService nbdService) {
        this.nbdService = nbdService;
    }

    @NeedlessCheckLogin
    public ModelAndView receive(HttpServletRequest request, HttpServletResponse response) {
        CommonUtils.processCrossOriginResponse(response);
        CommonParameter parameter = CommonParameter.parseParameter(request);
        try {
            NbdResponseEntity entity = getNbdService().lanch(parameter);
            UIUtils.responseJSON(entity, response);
        } catch (Exception e) {
            UIUtils.responseJSON("ERROR", response);
            e.printStackTrace();
        }catch(Error error){
            error.printStackTrace();
        }

        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) {
        return receive(request, response);
    }
}
