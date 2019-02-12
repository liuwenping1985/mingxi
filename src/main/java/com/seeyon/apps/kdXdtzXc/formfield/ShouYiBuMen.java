package com.seeyon.apps.kdXdtzXc.formfield;

import com.seeyon.ctp.form.modules.engin.field.FormFieldCustomExtendDesignManager;

/**
 * Created by tap-pcng43 on 2017-10-2.
 */
public class ShouYiBuMen extends FormFieldCustomExtendDesignManager {

    /**
     * //唯一标识 保证与其它的自定义控件实现类不同  *必填
     * 城市列表 城市列表选择
     *
     * @return
     */
    @Override
    public String getId() {
        return "ShouYiBuMeng";
    }

    /**
     * //控件名称  *必填
     *
     * @return
     */
    @Override
    public String getName() {
        return "财务受益部门选择"; //or return "xx.xx.xx.i18n"支持返回国际化key;
    }

    /**
     * //控件图片地址  *必填
     *
     * @return
     */
    @Override
    public String getImage() {
        return "/seeyon/apps_res/kdXdtzXc/img/city.png";
    }

    @Override
    public String getJsFileURL() {
        //控件地址   *必填
        return "/seeyon/biaoDanKongJian.do?method=getShouyiBuMen";
    }

    @Override
    public String getOnClickEvent() {
        return "";
    }

    @Override
    public String getValueType() {
        return "text"; //预留方法，默认返回text
    }

    @Override
    public int getWindowHeight() {
        //控件高度   *必填
        return 500;
    }

    @Override
    public int getWindowWidth() {
        //控件宽度   *必填
        return 500;
    }

    @Override
    public int getSort() {
        return 0;//预留方法 在选择列表中排序
    }

}
