package com.xad.weboffice;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/**
 * Created by liuwenping on 2019/8/27.
 * @Author liuwenping
 */
@SpringBootApplication
@EnableAutoConfiguration
@ComponentScan(basePackages={"com.xad.weboffice"})
@EnableJpaRepositories(basePackages={"com.xad.weboffice"})
@EntityScan(basePackages="com.xad.weboffice")
public class ApplicationStarter {
    private static ConfigurableApplicationContext applicationContext;
    public static void main(String[] args) {
        applicationContext =   new SpringApplicationBuilder().sources(ApplicationStarter.class).run(args);
        // applicationContext =  SpringApplication.run(ApplicationStarter.class, args);


    }

    public static ApplicationContext getApplicationContext(){
        return applicationContext;
    }
}
