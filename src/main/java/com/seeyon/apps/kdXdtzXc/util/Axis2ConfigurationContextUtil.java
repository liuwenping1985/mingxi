package com.seeyon.apps.kdXdtzXc.util;

import org.apache.axis2.AxisFault;
import org.apache.axis2.context.ConfigurationContext;
import org.apache.axis2.context.ConfigurationContextFactory;

/**
 * Created by taoan on 2016-11-24.
 */
public class Axis2ConfigurationContextUtil {
    private static ConfigurationContext configurationContext;


    public static ConfigurationContext getConfigurationContext() {
        if (configurationContext == null) {
            try {
                configurationContext = ConfigurationContextFactory
                        .createConfigurationContextFromFileSystem(null, null);
            } catch (AxisFault axisFault) {
                axisFault.printStackTrace();
            }
        }
        return configurationContext;
    }
}
