package com.seeyon.ctp.ext.jixiao;

import com.seeyon.ctp.form.modules.engin.field.FormFieldCustomExtendDesignManager;

public class JiXiaoSelect extends FormFieldCustomExtendDesignManager {


    public String getId() {
        return "jixiao-contain";
    }

    public String getName() {
        return "员工绩效考核表单";
    }

    public String getImage() {
        return "/seeyon/apps_res/v3xmain/images/personal/pic.gif";
    }

    public String getJsFileURL() {
        return "";
    }

    public String getOnClickEvent() {
        return "achievement-process-event";
    }

    public String getValueType() {
        return "text";
    }

    public int getWindowHeight() {
        return 1024;
    }

    public int getWindowWidth() {
        return 768;
    }

    public int getSort() {
        return 0;
    }
}
