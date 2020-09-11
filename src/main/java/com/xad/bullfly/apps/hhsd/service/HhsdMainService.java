package com.xad.bullfly.apps.hhsd.service;

import com.xad.bullfly.apps.hhsd.po.HhsdDubanTask;
import com.xad.bullfly.apps.hhsd.repository.HhsdDubanTaskRepository;
import com.xad.bullfly.core.bpmn.XadBpmnException;
import com.xad.bullfly.core.bpmn.XadWorkFlowEngine;
import com.xad.bullfly.core.bpmn.XadWorkFlowTemplateLoader;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlow;
import com.xad.bullfly.core.bpmn.vo.XadWorkFlowTemplate;
import com.xad.bullfly.web.common.vo.WebJsonResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

/**
 * Created by liuwenping on 2020/9/8.
 */
@Service
public class HhsdMainService {



    @Autowired
    private HhsdDubanTaskRepository hhsdDubanTaskRepository;


    @Autowired
    private XadWorkFlowEngine xadWorkFlowEngine;

    @Autowired
    private XadWorkFlowTemplateLoader xadWorkFlowTemplateLoader;

    @Autowired
    private RemoteUserService remoteUserService;


    public WebJsonResponse startDubantask(String userId){
        HhsdDubanTask task = new HhsdDubanTask();
        XadWorkFlowTemplate template =xadWorkFlowTemplateLoader.loadByTemplateId("DUBAN_TASK");
        XadWorkFlow flow =  xadWorkFlowEngine.buildNewWorkFlowByTemplate(template,task);
        try {
            flow.getWorkFlowContext().getCurrentSequence().getNode().setOutput(userId);
            xadWorkFlowEngine.start(flow);
            return WebJsonResponse.success("开始成功");
        } catch (Exception e) {
            e.printStackTrace();
          return  WebJsonResponse.fail(e.getMessage());
        }
    }

}
