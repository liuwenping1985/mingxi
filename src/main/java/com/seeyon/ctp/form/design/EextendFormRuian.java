package com.seeyon.ctp.form.design;

import com.seeyon.ctp.form.modules.engin.field.FormFieldCustomExtendDesignManager;

/**
 * Created by liuwenping on 2019/1/7.
 */
public class EextendFormRuian extends FormFieldCustomExtendDesignManager {


    public String getId() {
        return "efruian";
    }

    public String getName() {
        return "瑞安发票去重控件";
    }

    public String getImage() {
        return "/seeyon/apps_res/ruian/images/RuianSelectSubject.png";
    }

    public String getJsFileURL() {
        return "/seeyon/efruian.do?method=index";
    }

    public String getOnClickEvent() {
        return null;
    }

    public String getValueType() {
        return "text";
    }

    public int getWindowHeight() {
        return 800;
    }

    public int getWindowWidth() {
        return 1000;
    }

    public int getSort() {
        return 1;
    }


}
