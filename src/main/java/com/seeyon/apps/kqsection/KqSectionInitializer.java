package com.seeyon.apps.kqsection;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AbstractSystemInitializer;


public class KqSectionInitializer extends AbstractSystemInitializer {
	private static Log log = LogFactory.getLog(KqSectionInitializer.class);
	public void destroy() {
        System.out.println("销毁kqsection模块");
        log.info("销毁kqsection模块");
    }

    public void initialize() {
        System.out.println("初始化kqsection模块");
        log.info("初始化kqsection模块");
		
    }
}
