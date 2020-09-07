package com.xad.bullfly.core.service;

import com.xad.bullfly.core.common.service.MicroService;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by liuwenping on 2019/8/19.
 */
public interface AuthService extends MicroService {


    /**
     * 验证
     * @param request
     * @return
     */
     boolean auth(HttpServletRequest request);

    /**
     *
     * @return
     */
     boolean sso(String token);

}
