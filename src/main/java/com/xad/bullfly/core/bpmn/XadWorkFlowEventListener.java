package com.xad.bullfly.core.bpmn;

import com.xad.bullfly.core.bpmn.vo.XadWorkFlow;

/**
 * Created by liuwenping on 2020/9/11.
 */
public interface XadWorkFlowEventListener {

     <T> void onStart(XadWorkFlow<T> flow);
     <T> void onProcess(XadWorkFlow<T> flow);
     <T> void onFinish(XadWorkFlow<T> flow);
     <T> void onBack(XadWorkFlow<T> flow);

}
