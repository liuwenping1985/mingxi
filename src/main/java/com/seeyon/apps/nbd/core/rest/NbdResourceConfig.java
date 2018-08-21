package com.seeyon.apps.nbd.core.rest;

import com.fasterxml.jackson.jaxrs.annotation.JacksonFeatures;
import com.seeyon.ctp.rest.filter.AuthNbdRequestFilter;
import com.seeyon.ctp.rest.filter.AuthorizationRequestFilter;
import com.seeyon.ctp.rest.filter.ResponseFilter;
import org.glassfish.jersey.media.multipart.MultiPartFeature;
import org.glassfish.jersey.server.ResourceConfig;

import javax.ws.rs.ApplicationPath;

/**
 * Created by liuwenping on 2018/8/20.
 */

@ApplicationPath("/gateway/*")
public class NbdResourceConfig extends ResourceConfig {
    public NbdResourceConfig() {
        this.packages(new String[]{"com.seeyon.apps.nbd.core.resource"});
        this.packages(new String[]{"com.fasterxml.jackson.jaxrs"});
        this.register(AuthNbdRequestFilter.class);
        this.register(ResponseFilter.class);
        this.register(JacksonFeatures.class);
        this.register(MultiPartFeature.class);
    }
}