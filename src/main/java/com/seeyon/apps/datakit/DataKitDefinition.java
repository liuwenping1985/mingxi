package com.seeyon.apps.datakit;

import com.seeyon.ctp.common.AbstractSystemInitializer;

public class DataKitDefinition extends AbstractSystemInitializer
{
    public void destroy()
    {
        System.out.println("===data kit destroy====");
    }

    public void initialize()
    {
        System.out.println("====data kit started!====");
    }
}