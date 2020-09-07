package com.xad.bullfly.web;

import com.xad.bullfly.web.middleware.tomcat.XadTomcatWebServerCustomizer;
import com.xad.bullfly.web.middleware.undertow.XadUndertowWebServerCustomizer;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.embedded.undertow.UndertowServletWebServerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

/**
 * Created by liuwenping on 2020/8/14.
 */
@Component
public class XadWebServerFactoryCustomizer extends XadTomcatWebServerCustomizer {

    @Override
    public void customize(TomcatServletWebServerFactory undertowFactory) {
        System.out.println("TomcatServletWebServerFactory started");
    }

    @Bean
    public TomcatServletWebServerFactory servletWebServerFactory(){
        TomcatServletWebServerFactory factory = new TomcatServletWebServerFactory();
//        factory.addBuilderCustomizers((Builder builder)->{builder.});
        return factory;
    }

}
