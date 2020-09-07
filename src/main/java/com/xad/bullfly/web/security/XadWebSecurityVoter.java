package com.xad.bullfly.web.security;

import org.springframework.security.access.AccessDecisionVoter;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.FilterInvocation;

import java.util.Collection;

/**
 * Created by liuwenping on 2020/9/2.
 */
public class XadWebSecurityVoter implements AccessDecisionVoter<FilterInvocation> {
    private WebSecurityChopper chopper  = new WebSecurityChopper();
    //拦截全部
    @Override
    public boolean supports(ConfigAttribute configAttribute) {
        return true;
    }

    @Override
    public boolean supports(Class<?> aClass) {
        return true;
    }

    @Override
    public int vote(Authentication authentication, FilterInvocation filterInvocation, Collection<ConfigAttribute> collection) {
        //啥也没有 毙掉
        if(authentication == null) {
            return ACCESS_DENIED;
        }
        if(!chopper.access(authentication,filterInvocation.getRequest())){
            return ACCESS_DENIED;
        }
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        String requestUrl = filterInvocation.getRequestUrl();
//        if(requestUrl!=null){
//            if("api".equals())
//        }

        return ACCESS_GRANTED;
    }
}
