package com.xad.bullfly.web.security;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

/**
 * 简单粗暴 断路器
 * Created by liuwenping on 2020/9/2.
 */
@Component("webSecurityChopper")
public class WebSecurityChopper {

    public boolean access(Authentication auth, HttpServletRequest request){

        String name = auth.getName();
        //auth.getCredentials()
        System.out.println("name:"+name);
        return true;
    }
}
