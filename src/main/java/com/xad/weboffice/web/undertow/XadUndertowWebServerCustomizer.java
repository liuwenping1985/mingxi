package com.xad.weboffice.web.undertow;

import org.springframework.boot.web.embedded.undertow.UndertowServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;

/**
 * Created by liuwenping on 2020/8/14.
 */
public abstract class XadUndertowWebServerCustomizer implements WebServerFactoryCustomizer<UndertowServletWebServerFactory> {
    @Override
    public abstract void customize(UndertowServletWebServerFactory undertowServletWebServerFactory);
}
