package com.xad.bullfly.core.bpmn;

import com.xad.bullfly.core.bpmn.vo.XadWorkFlowTemplate;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2020/9/10.
 */
@Component
public class XadWorkFlowTemplateLoader {

    private Map<String,XadWorkFlowTemplate> templateHolder = new HashMap<>();
    public XadWorkFlowTemplate loadByTemplateId(String templateId,boolean forcedFromFile){

        if(!forcedFromFile){
            if(templateHolder.containsKey(templateId)){
                return templateHolder.get(templateId);
            }
        }
        if("DUBAN_TASK".equals(templateId)){
            File file = new File(XadBpmnUtil.class.getResource("DubanTaskWorkFlow.xml").getPath());
            try {
                XadWorkFlowTemplate xadWorkFlowTemplate = XadBpmnUtil.parseXadWorkFlowTemplateByFile(file);
                if(xadWorkFlowTemplate!=null){
                    templateHolder.put(templateId,xadWorkFlowTemplate);
                    return xadWorkFlowTemplate;
                }
            } catch (XadBpmnException e) {
                e.printStackTrace();
            }


        }
        return null;

    }
    public XadWorkFlowTemplate loadByTemplateId(String templateId){

        return loadByTemplateId(templateId,false);

    }

}
