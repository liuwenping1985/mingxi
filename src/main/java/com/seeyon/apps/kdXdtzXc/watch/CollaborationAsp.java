package com.seeyon.apps.kdXdtzXc.watch;

import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by tap-pcng43 on 2017-6-13.
 */
@Aspect
public class CollaborationAsp {

    @Pointcut("execution(* com.seeyon.apps.collaboration.controller.CollaborationController.stepStop(..))")
    public void doStepStopAsp() {
    }

    @AfterReturning("doStepStopAsp() && args( request,response,..)")
    public void doStepStopAfterAsp(HttpServletRequest request, HttpServletResponse response) {
    }

    @Pointcut("execution(* com.seeyon.apps.collaboration.controller.CollaborationController.stepBack(..))")
    public void doStepBackAsp() {
    }

    @AfterReturning("doStepBackAsp() && args( request,response,..)")
    public void doStepBackAfterAsp(HttpServletRequest request, HttpServletResponse response) {
    }


    @Pointcut("execution(* com.seeyon.apps.collaboration.controller.CollaborationController.doForward(..))")
    public void doForwardAsp() {
    }

    @AfterReturning("doForwardAsp() && args( request,response,..)")
    public void doForwardAfterAsp(HttpServletRequest request, HttpServletResponse response) {

    }


    @Pointcut("execution(* com.seeyon.apps.collaboration.controller.CollaborationController.finishWorkItem(..))")
    public void finishWorkItemAsp() {
    }

    @AfterReturning("finishWorkItemAsp() && args( request,response,..)")
    public void finishWorkItemAfterAsp(HttpServletRequest request, HttpServletResponse response) {

    }



}
