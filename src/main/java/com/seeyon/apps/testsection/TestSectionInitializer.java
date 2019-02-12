package com.seeyon.apps.testsection;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AbstractSystemInitializer;


public class TestSectionInitializer extends AbstractSystemInitializer {
	private static Log log = LogFactory.getLog(TestSectionInitializer.class);
	public void destroy() {
        System.out.println("销毁testsection模块");
        log.info("销毁testsection模块");
    }

    public void initialize() {
        System.out.println("初始化testsection模块");
        log.info("初始化testsection模块");
		
    }
}
