package com.xad.weboffice.troubleshoot;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.BeanFactoryAware;
import org.springframework.boot.diagnostics.AbstractFailureAnalyzer;
import org.springframework.boot.diagnostics.FailureAnalysis;

/**
 * Created by liuwenping on 2020/8/14.
 */
public class XadWebOfficeFailureAnalyzer extends AbstractFailureAnalyzer implements BeanFactoryAware {

    private BeanFactory beanFactory;

    @Override
    protected FailureAnalysis analyze(Throwable throwable, Throwable throwable2) {
        if (throwable instanceof NullPointerException) {
            FailureAnalysis analysis = new FailureAnalysis("最严重的错误-》空指针", "CONTINUE", throwable);
            return analysis;
        }
        return null;
    }

    @Override
    public void setBeanFactory(BeanFactory beanFactory) throws BeansException {
        this.beanFactory = beanFactory;
    }
}
