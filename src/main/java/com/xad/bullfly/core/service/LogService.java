package com.xad.bullfly.core.service;

import com.xad.bullfly.core.common.service.MicroService;

/**
 * Created by liuwenping on 2019/8/21.
 */
public interface LogService extends MicroService {

    void error(String msg, Throwable t);
    void error(String msg);
    void info(String msg, Throwable t);
    void info(String msg);
    void debug(String msg, Throwable t);
    void debug(String msg);


}
