package com.seeyon.apps.duban.stat;

import com.seeyon.apps.duban.mapping.MappingCodeConstant;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.service.FormCacheManager;

import java.util.Map;

public class FieldName2Field00xxUtils {

    //select * from form_definition where id =1483769518542572937
    private FormCacheManager formCacheManager   = (FormCacheManager) AppContext.getBean("formCacheManager");

    private static FieldName2Field00xxUtils fieldName2Field00xxUtils_db = new FieldName2Field00xxUtils(1483769518542572937l);

    private static FieldName2Field00xxUtils fieldName2Field00xxUtils_feedback = new FieldName2Field00xxUtils(4709913294826982605l);

    private static FieldName2Field00xxUtils fieldName2Field00xxUtils_delay = new FieldName2Field00xxUtils(-3395822722442967599l);

    private static FieldName2Field00xxUtils fieldName2Field00xxUtils_done = new FieldName2Field00xxUtils(-1224511548636184352l);


    private long  formAppId;

    public FieldName2Field00xxUtils(long formAppId) {
        this.formAppId = formAppId;
    }

    public String getField00xx(String displayName) {
        FormBean fapp =  formCacheManager.getForm(formAppId);
        Map<String, String>map =  fapp.getAllFieldDisplayMap();
        return map.get(displayName);
    }

    public static FieldName2Field00xxUtils getInstance_db() {
        return fieldName2Field00xxUtils_db;
    }

    public static FieldName2Field00xxUtils getInstance_feedback() {
        return fieldName2Field00xxUtils_feedback;
    }

    public static FieldName2Field00xxUtils getInstance_delay() {
        return fieldName2Field00xxUtils_delay;
    }

    public static FieldName2Field00xxUtils getInstance_done() {
        return fieldName2Field00xxUtils_done;
    }


    //add by tianxufeng,获某表的某个field00xx
    public static String getfield00xx(String formCode, String displayName) {
        if (formCode.equals(MappingCodeConstant.DUBAN_TASK))//底表
        {
            FieldName2Field00xxUtils fieldTools = FieldName2Field00xxUtils.getInstance_db();
            return fieldTools.getField00xx(displayName);
        } else if (formCode.equals(MappingCodeConstant.DUBAN_TASK_FEEDBACK_AUTO)//反馈表
                || formCode.equals(MappingCodeConstant.DUBAN_TASK_FEEDBACK)) {
            FieldName2Field00xxUtils fieldTools = FieldName2Field00xxUtils.getInstance_feedback();
            return fieldTools.getField00xx(displayName);
        } else if (formCode.equals(MappingCodeConstant.DUBAN_TASK_DELAY_APPLY))//延期
        {
            FieldName2Field00xxUtils fieldTools = FieldName2Field00xxUtils.getInstance_delay();
            return fieldTools.getField00xx(displayName);
        } else if (formCode.equals(MappingCodeConstant.DUBAN_DONE_APPLY))//办结
        {
            FieldName2Field00xxUtils fieldTools = FieldName2Field00xxUtils.getInstance_done();
            return fieldTools.getField00xx(displayName);
        }
        return "";
    }
}
