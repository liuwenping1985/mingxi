package com.xad.bullfly.web.security.listener;

import org.springframework.context.event.EventListener;
import org.springframework.security.authentication.event.AbstractAuthenticationFailureEvent;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.stereotype.Component;

/**
 * Created by liuwenping on 2020/9/3.
 */
@Component
public class XadAuthenticationEventListener {
    @EventListener
    public void onSuccess(AuthenticationSuccessEvent success) {
        // ...
        System.out.println("----------success--------");
    }

    @EventListener
    public void onFailure(AbstractAuthenticationFailureEvent failures) {
        // 包含多种错误

        System.out.println("fail");
    }

}




