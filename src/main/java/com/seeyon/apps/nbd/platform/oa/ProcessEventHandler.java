package com.seeyon.apps.nbd.platform.oa;

import com.seeyon.apps.collaboration.event.CollaborationFinishEvent;
import com.seeyon.apps.nbd.core.service.ServiceForwardHandler;
import com.seeyon.ctp.util.annotation.ListenEvent;

/**
 * Created by liuwenping on 2018/8/20.
 */
public class ProcessEventHandler {
  //  private ServiceForwardHandler handler = new ServiceForwardHandler();

    @ListenEvent(event = CollaborationFinishEvent.class,async = true)
    public void onFinish(CollaborationFinishEvent event) {


        System.out.println("-----TEST----");



    }
}
