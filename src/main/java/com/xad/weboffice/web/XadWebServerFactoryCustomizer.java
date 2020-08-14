package com.xad.weboffice.web;

import com.xad.weboffice.web.undertow.XadUndertowWebServerCustomizer;
import org.springframework.boot.web.embedded.undertow.UndertowServletWebServerFactory;
import org.springframework.stereotype.Component;

/**
 * Created by liuwenping on 2020/8/14.
 */
@Component
public class XadWebServerFactoryCustomizer extends XadUndertowWebServerCustomizer {


    @Override
    public void customize(UndertowServletWebServerFactory undertowServletWebServerFactory) {

    }

}
