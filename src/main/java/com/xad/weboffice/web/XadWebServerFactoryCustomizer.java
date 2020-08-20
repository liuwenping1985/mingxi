package com.xad.weboffice.web;

import com.xad.weboffice.web.middleware.undertow.XadUndertowWebServerCustomizer;
import org.springframework.boot.web.embedded.undertow.UndertowServletWebServerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

/**
 * Created by liuwenping on 2020/8/14.
 */
@Component
public class XadWebServerFactoryCustomizer extends XadUndertowWebServerCustomizer {

    @Override
    public void customize(UndertowServletWebServerFactory undertowFactory) {
        System.out.println("XadWebServerFactoryCustomizer started");
    }

    @Bean
    public UndertowServletWebServerFactory servletWebServerFactory(){
        UndertowServletWebServerFactory factory = new UndertowServletWebServerFactory();
//        factory.addBuilderCustomizers((Builder builder)->{builder.});
        return factory;
    }

}
