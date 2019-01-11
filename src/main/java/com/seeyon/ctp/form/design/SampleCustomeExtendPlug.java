
package com.seeyon.ctp.form.design;

import com.seeyon.ctp.form.modules.engin.field.FormFieldCustomExtendDesignManager;

public class SampleCustomeExtendPlug extends FormFieldCustomExtendDesignManager {
    @Override
    public String getId() {
        //唯一标识 保证与其它的自定义控件实现类不同  *必填
        return "sample110";
    }

    @Override
    public String getName() {
        //控件名称  *必填
        return "测试表单自定义控件"; //or return "xx.xx.xx.i18n"支持返回国际化key
    }

    @Override
    public String getImage() {
        //控件图片地址  *必填
        return "/seeyon/apps_res/v3xmain/images/personal/pic1.gif";
    }

    @Override
    public String getJsFileURL() {
        //控件地址   *必填
        return "/seeyon/form/extFormPlug.do?method=formToPlug";
    }


    @Override
    public String getOnClickEvent() {
        return null; //预留方法
    }

    @Override
    public String getValueType() {
        return "text"; //预留方法，默认返回text
    }

    @Override
    public int getWindowHeight() {
        //控件高度   *必填
        return 200;
    }

    @Override
    public int getWindowWidth() {
        //控件宽度   *必填
        return 200;
    }

    @Override
    public int getSort() {
        return 0; //预留方法 在选择列表中排序
    }
}