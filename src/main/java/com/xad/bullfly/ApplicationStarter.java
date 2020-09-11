package com.xad.bullfly;

import com.xad.bullfly.organization.vo.UserVo;
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
@ComponentScan(basePackages={"com.xad.bullfly"})
@EnableJpaRepositories(basePackages={"com.xad.bullfly"})
@EntityScan(basePackages="com.xad.bullfly")
public class ApplicationStarter {

    private static ConfigurableApplicationContext applicationContext;

    public static void main(String[] args) {
        applicationContext =   new SpringApplicationBuilder().sources(ApplicationStarter.class).run(args);
    }

    public static ApplicationContext getApplicationContext(){
        return applicationContext;
    }

    private static ThreadLocal<UserVo> loginInfos = new ThreadLocal<>();

    public static void setCurrentUser(UserVo vo){
        loginInfos.set(vo);
    }
    public static UserVo getCurrentUser(){
       return  loginInfos.get();
    }
}
