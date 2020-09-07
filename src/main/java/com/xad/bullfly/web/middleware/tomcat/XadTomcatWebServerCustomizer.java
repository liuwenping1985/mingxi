package com.xad.bullfly.web.middleware.tomcat;

import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;

/**
 * Created by liuwenping on 2020/8/14.
 */
public abstract class XadTomcatWebServerCustomizer implements WebServerFactoryCustomizer<TomcatServletWebServerFactory> {
    @Override
    public abstract void customize(TomcatServletWebServerFactory tomcatServletWebServerFactory);
}
