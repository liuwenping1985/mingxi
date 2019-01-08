package com.seeyon.apps.datakit.service;

import com.seeyon.apps.datakit.po.DataLink;

/**
 * Created by liuwenping on 2019/1/8.
 */
public class ConfigService {


    public static DataLink getA8DefaultDataLink(){

        DataLink dl = new DataLink();
        dl.setLinkType("default");

        return dl;


    }
}
