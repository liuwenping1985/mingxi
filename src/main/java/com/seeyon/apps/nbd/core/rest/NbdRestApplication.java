package com.seeyon.apps.nbd.core.rest;

import com.seeyon.apps.nbd.core.resource.NbdAffairResource;
import com.seeyon.apps.nbd.core.resource.NbdSSOResource;
import com.seeyon.ctp.rest.CTPResourceConfig;
import com.seeyon.ctp.rest.CTPRestApplication;
import org.apache.log4j.Logger;

import javax.ws.rs.core.Application;
import java.util.HashSet;
import java.util.Set;

/**
 * Created by liuwenping on 2018/8/20.
 */
public class NbdRestApplication  extends Application {
    private static final Logger logger = Logger.getLogger(NbdRestApplication.class);

    private static Set<Class<?>> classes = new HashSet();

    public NbdRestApplication() {
    }

    private static void add(Class clazz) {
        try {

            classes.add(clazz);
        } catch (Throwable var2) {
            logger.error(var2.getLocalizedMessage(), var2);
        }

    }

    public Set<Class<?>> getClasses() {
        return classes;
    }

    static{

        add(NbdAffairResource.class);

        add(NbdSSOResource.class);

    }
}
