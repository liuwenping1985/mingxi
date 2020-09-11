package com.xad.bullfly.core.bpmn;

import com.xad.bullfly.core.bpmn.constant.XadEventType;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlow;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by liuwenping on 2020/9/11.
 */
@Service("xadWorkFlowEventPublisher")
public class XadWorkFlowEventPublisher {

    private ExecutorService cachedThreadPool = Executors.newFixedThreadPool(3);

    private List<XadWorkFlowEventListener> listeners = new ArrayList<>();

    public void registListener(XadWorkFlowEventListener listener) {
        listeners.add(listener);
    }

    public void removeListener(XadWorkFlowEventListener listener) {
        listeners.remove(listener);
    }

    public void receiveEvent(XadEventType type, XadWorkFlow flow) {
        if(listeners.size()==0){
            return ;
        }
        switch (type) {
            case START: {
                listeners.stream().forEach((listener)-> cachedThreadPool.execute(()->listener.onStart(flow)));
                break;
            }
            case FINISH:{
                listeners.stream().forEach((listener)-> cachedThreadPool.execute(()->listener.onFinish(flow)));
                break;
            }
            case PROCESS:{
                listeners.stream().forEach((listener)-> cachedThreadPool.execute(()->listener.onProcess(flow)));
                break;
            }
            case BACK:{
                listeners.stream().forEach((listener)-> cachedThreadPool.execute(()->listener.onBack(flow)));
                break;
            }
            default:
        }
    }


}
