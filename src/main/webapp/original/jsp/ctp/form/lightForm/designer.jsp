<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<!DOCTYPE html>
<html>
<head>
    <title>表单设计器</title>
    <meta charset="utf-8"/>
    <link rel="stylesheet" type="text/css" href="${ctp_contextPath}/common/form/lightFormDesigner/css/public.css${ctp:resSuffix()}"/>
    <link rel="stylesheet" type="text/css" href="${ctp_contextPath}/common/form/lightFormDesigner/css/jquery.bigcolorpicker.css${ctp:resSuffix()}"/>
    <link rel="stylesheet" type="text/css" href="${ctp_contextPath}/common/form/lightFormDesigner/css/icons.css${ctp:resSuffix()}"/>
    <link rel="stylesheet" type="text/css" href="${ctp_contextPath}/common/form/lightFormDesigner/css/phone.css${ctp:resSuffix()}"/>
    <script type="text/javascript" src="${ctp_contextPath}/common/form/lightFormDesigner/js/jquery-1.8.3.min.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/form/lightFormDesigner/js/jquery-ui-1.10.4.custom.min.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/form/lightFormDesigner/js/jquery.bigcolorpicker.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/form/lightFormDesigner/js/setForm.js${ctp:resSuffix()}"></script>
</head>
<body style="width:100%;height:100%;overflow:hidden;">
<div class="form_layout">
    <div class="form_top">
        <ul>
            <li class="li_active">"${ctp:i18n('form.lightForm.design.config')}"</li>
        </ul>
    </div>
    <div class="form_left">
        <p>"${ctp:i18n('form.lightForm.design.fields')}"</p>
        <div class="form_left_content">
            <p class="contents_type plan_model">"${ctp:i18n('form.lightForm.format.control')}"</p>
            <div class="contents_content base_widget">
                <p class="single_text" comType="text">
                    <label class="ico24 single_text_24">单行文本</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_2" comType="textarea">
                    <label class="ico24 lines_text_24">多行文本</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_3" comType="checkbox">
                    <label class="ico24 checkbox_24" >复选框</label>
                    <input type="checkbox"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_4" comType="radio">
                    <label class="ico24 radio_24" >单选按钮</label>
                    <input type="radio"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_5"  comType="select">
                    <label class="ico24 select_24">下拉框</label>
                    <select class="select_case">
                        <option></option>
                    </select>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_6" comType="linespace">
                    <label class="ico24 space_24" >间隔行</label>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                </p>
                <p class="single_text_7" single_title="detail_form" comType="detailForm">
                    <label class="ico24 detail_24">明细表</label>
                    <input type="text"/>
                    <span class="hint_bar_set_delete">-</span>
                    <span class="hint_bar_set_copy">+</span>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_8" comType="textlabel">
                    <label class="ico24 text_tag_24">文字标签</label>
                    <textarea class="text_content display_none"></textarea>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                </p>
            </div>
            <p class="contents_type plan_model">功能控件</p>
            <div class="contents_content relate_widget">
                <p class="single_text_11" comType="serialnumber">
                    <label class="ico24 stream_24">流水号</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_12" comType="digital">
                    <label class="ico24 number_mode_24">数字型</label>
                    <em class="money_type ">￥</em>
                    <em class="number_mode_type">-</em>
                    <em class="telephone_number"></em>
                    <input type="text" class="number_mode_text"/>
                    <em class="number_mode_type">+</em>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_13" comType="date">
                    <label class="ico24 date_mode_24">日期型</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_31" comType="datetime">
                    <label class="ico24 date_time_24">日期时间</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_32" comType="flowdealoption">
                    <label class="ico24 flow_opinion_24">流程意见</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_33" comType="attachment">
                    <label class="ico24 accessory_24">附件</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_34" comType="image">
                    <label class="ico24 image_24">图片</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_26" comType="document">
                    <label class="ico24 relate_doc_24">关联文档</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_27" comType="mapmarked">
                    <label class="ico24 map_mark_24">地图标注</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_28" comType="maplocate">
                    <label class="ico24 position_24">位置定位</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_29" comType="topfield">
                    <label class="ico24 select_quarters_24">高级控件</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_12" comType="relation">
                    <label class="ico24 data_relate_24">数据关联</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
            </div>
            <p class="contents_type plan_model plan_model_last">组织控件</p>
            <div class="contents_content organize_widget">
                <p class="single_text_14" comType="member">
                    <label class="ico24 select_person_24">选择人员</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_18" comType="department">
                    <label class="ico24 select_department_24">选择部门</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_20" comType="post">
                    <label class="ico24 select_quarters_24">选择岗位</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_15" comType="multimember">
                    <label class="ico24 select_more_person_24">选择多人</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>

                <p class="single_text_19" comType="multidepartment">
                    <label class="ico24 select_more_department_24">选择多部门</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
                <p class="single_text_21" comType="multipost">
                    <label class="ico24 select_more_quarters_24">选择多岗位</label>
                    <input type="text"/>
                    <span class="hint_bar_selected">√</span>
                    <span class="hint_bar_delete">×</span>
                    <span class="hint_bar_copy">+</span>
                    <span class="hint_bar_hide">隐</span>
                </p>
            </div>
            <p class="contents_type permission_model ele_hide">权限设置</p>
            <div class="contents_content ele_hide">
                <div class="permission_set_control">
                    <span class="set_add"></span>
                    <span class="set_edit"></span>
                    <span class="set_copy"></span>
                    <span class="set_delete"></span>
                    <div class="permission_set_select">
                        <span>新增</span>
                        <span>修改</span>
                        <span>只读</span>
                    </div>
                </div>
                <p class="single_text_27">
                    <label class="single_icon permission_icon_1">新增权限</label>
                </p>
                <p class="single_text_28">
                    <label class="single_icon permission_icon_2">修改权限</label>
                </p>
                <p class="single_text_29">
                    <label class="single_icon permission_icon_3">只读权限</label>
                </p>
                <p class="add_permission">+新的权限</p>
            </div>
            <p class="contents_type apply_model ele_hide">应用绑定</p>
            <div class="contents_content ele_hide">
                <p class="single_text_27">
                    <label class="ico24 apply_icon_1">我要上报需求</label>
                </p>
                <p class="single_text_28">
                    <label class="ico24 apply_icon_2">A8需求处理</label>
                </p>
                <p class="single_text_29">
                    <label class="ico24 apply_icon_3">A6需求处理</label>
                    <label class="copy_apply">+复制应用</label>
                </p>
                <p class="add_apply">+新增应用</p>
            </div>
        </div>
    </div>
    <div class="form_center iphone5s_pic">
        <div class="iphone_content model_type ">
            <p>表单名称</p>
            <div class="contents_show">
                <!--<div class="detial_form p_active">-->
                    <!--<p class="detail_spread detail_spread_2">明细表</p>-->
                    <!--<div class="contents_show detail_contents_show ui-sortable" style="display: block;"></div>-->
                    <!--<span class="hint_bar_delete">×</span><span class="hint_bar_copy">+</span><span class="hint_bar_hide">隐</span>-->
                <!--</div>-->
                <!--<p class="">-->
                <!--<label>文本控件</label>-->
                <!--<input type="text" />-->
                <!--<span>×</span>-->
                <!--</p>-->
                <!--<div class="detial_form">-->
                    <!--<p class="detail_spread detail_spread_2">明细表</p>-->
                    <!--<div class="contents_show detail_contents_show">-->
                    <!--</div>-->
                <!--</div>-->
            </div>
        </div>
        <div class="ipad_content model_type ele_hide">
            <p>表单名称<input type="text"/></p>
            <div class="ipad_content_layout clearFlow">
                <div class="contents_show"></div>
                <div class="contents_show"></div>
                <!--<p class="">-->
                    <!--<label>文本控件</label>-->
                    <!--<input type="text" />-->
                    <!--<span>×</span>-->
                <!--</p>-->
            </div>
        </div>
        <div class="model_type_select">
            <select>
                <option value="iphone">iphone</option>
                <option value="ipad">ipad</option>
                <option value="pc">PC</option>
            </select>
            <ul>
                <li>
                    <span class="model_type_select_3"></span>
                    <p>编辑</p>
                </li>
                <li>
                    <span class="model_type_select_1"></span>
                    <p>浏览</p>
                </li>
                <li>
                    <span class="model_type_select_2"></span>
                    <p>追加</p>
                </li>
                <li>
                    <span class="model_type_select_4">+</span>
                    <p class="padding_tb_5">允许添加明细行</p>
                </li>
                <li>
                    <span class="model_type_select_5">+</span>
                    <p class="padding_tb_5">允许删除明细行</p>
                </li>
            </ul>
        </div>
        <div class="model_power_set">
            <p>控制权限预览</p>
            <div>
                <p>
                    <input type="checkbox"/>全选/不选
                </p>
                <p>
                    <input type="checkbox"/>反选
                </p>
            </div>
        </div>
    </div>
    <div class="form_right">
        <p>控件设置</p>
        <div class="form_right_content">
            <p class="contents_type plan_model">个性化设置</p>
            <div class="contents_content">
                <fieldset class="contents_content_layout">
                    <legend>表头设置</legend>
                    <p class="red_star">标题
                        <input type="text" id="formName" class="form_head validate" validate="type:'string',notNullWithoutTrim:'true',name:'标题',notNull:true,errorMsg:'不能为空',avoidChar:'!@#$%^&\'*+()'" onchange="setFormName();"/>
                        <input type="hidden" id="logoUrl" value=""/>
                    </p>
                </fieldset>
                <fieldset class="contents_content_layout">
                    <legend>推荐配色</legend>
                    <ul class="clearFlow suggest_color">
                        <li><span class="suggest_color_1"></span></li>
                        <li><span class="suggest_color_2"></span></li>
                        <li><span class="suggest_color_3"></span></li>
                    </ul>
                    <ul class="clearFlow suggest_color suggest_color2">
                        <li><span class="suggest_color_1"></span></li>
                        <li><span class="suggest_color_2"></span></li>
                        <li><span class="suggest_color_3"></span></li>
                    </ul>
                    <h3>点击更改颜色</h3>
                    <ul class="clearFlow model_color_change">
                        <li>
                            <p class="model_color_bg form_header_bg" model_name="2"></p>
                            <input type="hidden" id="headBgColor" value="" class="color_value"/>
                        </li>
                        <li>
                            <p class="model_color_bg form_content_bg" model_name="3"></p>
                            <input type="hidden" id="fieldBgColor" value="" class="color_value"/>
                        </li>
                        <li>
                            <p class="model_color_bg form_name_color" model_name="1"></p>
                            <input type="hidden" id="headFontColor" value="" class="color_value"/>
                        </li>
                        <li>
                            <p class="model_color_bg form_widget_title_color" model_name="5"></p>
                            <input type="hidden" id="fieldTitleColor" value="" class="color_value"/>
                        </li>
                    </ul>
                </fieldset>
                <fieldset class="contents_content_layout">
                    <legend>字号设置</legend>
                    <ul class="clearFlow font_set">
                        <li>
                            <label for="form_name">表单名称</label>
                            <select name="form_name" id="form_name">
                                <option>12px</option>
                                <option>14px</option>
                                <option>18px</option>
                                <option>20px</option>
                                <option>24px</option>
                            </select>
                            <span mode_value="1">B</span>
                        </li>
                        <li>
                            <label for="control_text">控件文字</label>
                            <select name="control_text" id="control_text">
                                <option>12px</option>
                                <option>14px</option>
                                <option>18px</option>
                                <option>20px</option>
                                <option>24px</option>
                            </select>
                            <span mode_value="2">B</span>
                        </li>
                        <li>
                            <label for="repeat_form_header">重复表头文字</label>
                            <select name="repeat_form_header" id="repeat_form_header">
                                <option>12px</option>
                                <option>14px</option>
                                <option>18px</option>
                                <option>20px</option>
                                <option>24px</option>
                            </select>
                            <span mode_value="3">B</span>
                        </li>
                    </ul>
                </fieldset>
                <fieldset class="contents_content_layout">
                    <legend>其他设置</legend>
                    <ul class="clearFlow bg_pic_set ul_li_">
                        <li><input type="checkbox" id="showLogo" value="true"/>表头logo</li>
                        <li><input type="checkbox" id="showCutLine" value="true" checked="checked"/> 显示分割线</li>
                        <li><input type="checkbox" id="showBorderLine" value="true"/>显示加边效果</li>
                    </ul>
                </fieldset>
            </div>
            <p class="contents_type plan_model">属性设置</p>
            <div class="contents_content contents_attribute">
                <p class="red_star">标题</p>
                <div class="attribute_set">
                        <input type="text" id="text_fieldName" class="single_text" placeholder="单行文本"/>
                        <select id="text_showStyle" class="common_selectbox_wrap">
                            <option value="0">单独显示</option>
                            <option value="1">并列显示</option>
                            <option value="2">嵌入显示</option>
                        </select>
                </div>
                <p class="red_star">控件值长度</p>
                <div class="attribute_set">
                    <input type="text" class="widget_len" id="text_fieldLength" value="255" />
                </div>
                <p>计算公式<input type="button" value="设置" class="math_set"/></p>
                <div class="attribute_set">
                    <textarea  rows="4" > </textarea>
                </div>
                <p>校验</p>
                <div class="attribute_set">
                    <input type="checkbox" id="text_unique" class="data_unique"/>数据唯一
                </div>
                <p>控件值字体样式</p>
                <div class="attribute_set">
                    <span class="set_widget_font">示例</span>点击设置样式
                </div>
                <p>控件样式</p>
                <div class="attribute_set">
                    <select name="" id="" class="widget_style_select">
                        <option value="">单行文本</option>
                        <option value="">多行文本</option>
                    </select>
                </div>
                <p>选项设置<input type="button" value="设置" class="math_set"/></p>
                <div class="attribute_set border_box province_select_bg">
                    <p class="province_select relative text_indent_15 hover">广东省</p>
                    <div class="province_select_content ele_hide">
                        <p class="text_indent_15">选项一</p>
                        <p class="text_indent_15">选项二</p>
                    </div>
                    <p class="province_select relative text_indent_15 hover">四川省</p>
                    <div class="province_select_content">
                        <p class="text_indent_15">选项一</p>
                        <p class="text_indent_15">选项二</p>
                    </div>

                </div>
                <p>选项样式</p>
                <div class="attribute_set clearFlow">
                    <span class="select_style select_style_active hover">纵向排列</span>
                    <span class="select_style hover">横向排列</span>
                </div>
                <p class="height_set_hint">高度</p>
                <div class="attribute_set height_set clearFlow">
                    <p>
                        <input type="radio" name="height_set" id="height_set_1"/>
                        <label for="height_set_1">1/4行高</label>
                    </p>
                    <p>
                        <input type="radio" name="height_set" id="height_set_2"/>
                        <label for="height_set_2">1/3行高</label>
                    </p>
                    <p>
                        <input type="radio" name="height_set" id="height_set_3"/>
                        <label for="height_set_3">1/2行高</label>
                    </p>
                   <p>
                       <input type="radio" name="height_set" id="height_set_4"/>
                       <label for="height_set_4">单倍行高</label>
                   </p>
                    <p>
                        <input type="radio" name="height_set" id="height_set_5"/>
                        <label for="height_set_5">双倍行高</label>
                    </p>
                </div>
                <p>字体</p>
                <div class="attribute_set">
                    <select name=""  class="widget_style_select">
                        <option value="">微软雅黑</option>
                        <option value="">宋体</option>
                        <option value="">华文细黑</option>
                    </select>
                </div>
                <p>字号</p>
                <div class="attribute_set">
                    <select name=""  class="widget_style_select widget_style_select_2">
                        <option value="">12px</option>
                        <option value="">14px</option>
                        <option value="">16px</option>
                    </select>
                    <span class="font_bold_set hover">B</span>
                </div>
                <p>上传图片</p>
                <div class="attribute_set">
                    <span class="set_widget_font"></span>
                    <p>点击上传图片，建议NpxNpx的JPG或PNG图片</p>
                </div>
                <p>流水号设置</p>
                <div class="attribute_set">
                    <p>自增规则<input type="button" value="设置" class="math_set"/></p>
                     <textarea class="border_box" rows="4">
                         【20140712】00001
                         【20140712】00002
                         【20140712】00003
                     </textarea>
                </div>
                <p>控件值长度</p>
                <div class="attribute_set widget_value_bg">
                    <label>整数位：</label><input type="text"  />
                    <label>小数位：</label><input type="text" />
                </div>
            </div>
            <p class="contents_type plan_model position_map">高级设置</p>
            <div class="contents_content">
                <p>
                    <label>计算式</label>
                    <input type="text"/>
                </p>
                <p>
                    <label>关联对象</label>
                    <input type="text"/>
                </p>

                <p>
                    <label>关联属性</label>
                    <input type="text"/>
                </p>

                <p>
                    <label>显示格式</label>
                    <input type="text"/>
                </p>
            </div>
            <p class="contents_type position_map permission_model ele_hide">控件权限设置</p>
            <div class="contents_content permission_right ele_hide">
                <div>
                    <h3>操作权限</h3>
                    <p><input type="radio" name="permission_set" checked="checked"/>编辑</p>
                    <p><input type="radio" name="permission_set"/>浏览</p>
                    <p><input type="radio" name="permission_set"/>追加</p>
                    <p><input type="radio" name="permission_set"/>隐藏</p>
                </div>
                <div>
                    <h3>明细表权限</h3>
                    <div class="detail_form_power_set">
                        <p>
                            <input type="checkbox"/>明细表一
                        </p>
                        <p>
                            <input type="checkbox"/>明细表二
                        </p>
                    </div>
                    <p>
                        <input type="checkbox"/>允许添加
                        <input type="checkbox" class="margin_lr_10"/>允许删除
                    </p>
                </div>
                <div>
                    <fieldset class="contents_power_set">
                        <legend>单个控件属性设置</legend>
                        <p>初始值</p>
                        <select >
                            <option></option>
                        </select>
                        <p>
                            <input type="checkbox"/>可更新
                        </p>
                        <p>检验</p>
                        <p>
                            <input type="checkbox"/>必填
                        </p>
                    </fieldset>
                </div>
                <!--<div>-->
                    <!--<h3>【快捷设置】</h3>-->
                    <!--<p><input type="button" value="全部单元格编辑权限"/></p>-->
                    <!--<p><input type="button" value="全部单元格浏览权限"/></p>-->
                <!--</div>-->
            </div>
            <p class="contents_type position_map apply_model ele_hide">应用设置</p>
            <div class="contents_content apply_model_right ele_hide">
                <div>
                    <h3>【操作范围设置】<input type="button" value="设置"/></h3>
                    <textarea ></textarea>
                </div>
                <div>
                    <h3>【授权】</h3>
                    <p class="hint_p"><label>(此框适应字数，自动扩展高度)</label></p>
                    <textarea class="hint_textarea"></textarea>
                </div>
                <div>
                    <h3>【菜单按钮权限设置】</h3>
                    <p><input type="checkbox"/>${ctp:i18n('form.bizmap.link.open.new.label')}</p>
                    <p><input type="checkbox"/>${ctp:i18n('form.oper.update.label')}</p>
                    <p><input type="checkbox"/>${ctp:i18n('form.datamatch.del.label')}</p>
                </div>
                <div>
                    <h3>${ctp:i18n('form.lightForm.Menu.rename')}</h3>
                    <p class="apply_set_p">${ctp:i18n('form.bizmap.link.open.new.label')}<input type="text" /></p>
                    <p class="apply_set_p">${ctp:i18n('form.oper.update.label')}<input type="text" /></p>
                </div>
                <div class="apply_font_set">
                    <h3>${ctp:i18n('form.lightForm.field.format')}</h3>
                    <p><input type="button" value="${ctp:i18n('form.lightForm.list.settings')}"/></p>
                    <p><input type="button" value="${ctp:i18n('form.lightForm.Sort.settings')}"/></p>
                    <p><input type="button" value="${ctp:i18n('form.lightForm.Query.settings')}"/></p>
                </div>
                <div class="clearFlow">
                    <input type="button" value="${ctp:i18n('form.forminputchoose.enter')}"/>
                </div>
            </div>
        </div>
    </div>
    <div class="form_footer">
        <div>
            <input type="button" value="${ctp:i18n('form.lightForm.design.save')}"/>
        </div>
    </div>
</div>
</body>
</html>