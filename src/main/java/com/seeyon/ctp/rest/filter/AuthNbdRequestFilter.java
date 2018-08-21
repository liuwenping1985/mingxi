package com.seeyon.ctp.rest.filter;

import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerRequestFilter;
import javax.ws.rs.container.PreMatching;
import javax.ws.rs.core.Response;
import java.io.IOException;
import java.util.Iterator;

/**
 * Created by liuwenping on 2018/8/20.
 */
@PreMatching
public class AuthNbdRequestFilter extends AbstractAuthorizationRequestFilter implements ContainerRequestFilter {

    public AuthNbdRequestFilter() {

    }
    public void filter(ContainerRequestContext req) throws IOException {
        this.process(req, req.getUriInfo().getPath());
    }

    void unauthorized(Object req, String message) {
        ((ContainerRequestContext)req).abortWith(this.error(Response.Status.UNAUTHORIZED, message));
    }
    protected boolean isIgnoreToken(String path) {

        boolean isIgnore = super.isIgnoreToken(path);
//        if(!isIgnore){
//
//        }


        return true;
    }
}
