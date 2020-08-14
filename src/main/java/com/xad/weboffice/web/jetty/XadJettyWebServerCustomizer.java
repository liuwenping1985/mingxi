package com.xad.weboffice.web.jetty;

import org.springframework.boot.web.embedded.jetty.JettyServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;

/**
 * Created by liuwenping on 2020/8/14.
 */
public abstract class XadJettyWebServerCustomizer implements WebServerFactoryCustomizer<JettyServletWebServerFactory> {
    @Override
    public abstract void customize(JettyServletWebServerFactory jettyServletWebServerFactory);
}
