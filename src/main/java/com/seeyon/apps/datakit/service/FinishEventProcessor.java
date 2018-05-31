package com.seeyon.apps.datakit.service;

import com.seeyon.apps.collaboration.event.CollaborationProcessEvent;

public interface FinishEventProcessor {

    public void onProcess(CollaborationProcessEvent event);
}
