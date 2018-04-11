<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>${ctp:i18n('form.mobile.designer.title')}</title>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!-- form css start-->
    <link rel="stylesheet" type="text/css" href="${path}/common/form/lightFormDesigner/css/public.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/common/form/lightFormDesigner/css/jquery.bigcolorpicker.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/common/form/lightFormDesigner/css/icons.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/common/form/lightFormDesigner/css/setFormIphone5s.css"/>
    <style type="text/css"> 
    #displayPro{
        z-index: 10000;width:180px;min-height: 102px;word-break: break-all;
		box-sizing:border-box;
		position: absolute;
        background-color: #fff;
        padding: 5px 5px 5px 10px;
        color: #000000;
        border: 1px solid #CCFFFF;
        box-shadow: 2px 2px 10px #ccc;
        -moz-box-shadow: 2px 2px 10px #ccc;
        -webkit-box-shadow: 2px 2px 10px #ccc;
		border:1px solid #3D9CFF;
		/*border-left:none;*/
		margin-left:-1px;
		border-radius:0 10px 10px 0; opacity:1;
		/*overflow:hidden;*/
    }
    .form_center.adaptive_box_flex{
        height: 100% !important;

    }
    .iphone5s_pic{
        margin: 10px auto !important;
        height: calc(100% - 20px) !important;
    }

    .iphone_content.model_type.form_area{
        height: calc(100% - 20px) !important;
        border: none !important;
    }

    .contents_show.formContent{
        height: calc(100% - 123px) !important;
    }

	#displayPro p{ font-size:12px; padding:5px 0 0;}
	#displayPro p b{ color:#216ABA;}
</style>
    <!-- form css end--> 
    
    <!-- form css biz start--> 
    
    <!-- form css biz end--> 
    
    
    
    
	<!-- common js start--> 
	<script type="text/javascript" >
		// jsp上下文 必须在 jsclazz.js引入前执行
		var contextPath= '..';
	</script>
	<script type="text/javascript" src="${path}/common/form/lightFormDesigner/statics/js/3rd/jquery/jquery-1.7.2.js"></script>
	<script type="text/javascript" src="${path}/common/form/lightFormDesigner/statics/js/system/jsclazz.js"></script>
    <!--  引入独立国际化js -->
    <c:choose>
        <c:when test="${language == 'en'}">
            <script type="text/javascript" src="${path}/common/form/lightFormDesigner/i18n/MobileDesigner_en.js"></script>
        </c:when>
        <c:when test="${language == 'zh_TW'}">
            <script type="text/javascript" src="${path}/common/form/lightFormDesigner/i18n/MobileDesigner_zh_TW.js"></script>
        </c:when>
        <c:otherwise>
            <script type="text/javascript" src="${path}/common/form/lightFormDesigner/i18n/MobileDesigner_zh_CN.js"></script>
        </c:otherwise>
    </c:choose>
    <script type="text/javascript">
	com.Tool.debug = true;//调试模式配置
	com.Tool.PACKAGE_PREFIX = "com.seeyon.lightform"; //构建包以该值为前缀，多个以英文逗号个隔开
	com.Tool.AJAX_ACTION ="";//配置默认的ajax action处理url
	</script>
	<script type="text/javascript" src="${path}/common/form/lightFormDesigner/statics/js/system/biz-ext.js"></script>
	<script type="text/javascript" src="${path}/common/form/lightFormDesigner/statics/js/system/biz-ext-json.js"></script>
	<script type="text/javascript" src="${path}/common/form/lightFormDesigner/statics/js/system/pache.js"></script>
	<script>
		biz.Tool.ThirdResPath ="lightFormDesigner/statics/js/"; //配置第三方资源目录
		var seeyon = {Tool:biz.Tool };//业务组件创建
		
	</script>
	<!-- common js end-->
    
    
</head>
<body>
<div class="flexible_box form_layout w100b h100b">
    <div class="form_left">
    
    	<p class="contents_type plan_model border_box"><span class="ico16 hole_trigon hole_trigon_spread"></span>基础控件</p>
        <div class="contents_content ">
        	<p class="comblockshow" inputType = "text">
                <label class="icon54 text_54">文本框</label>
                <input type="text" />
                <span class="hint_bar_delete"></span>
                <span class="hint_bar_copy"></span>
                <span class="hint_bar_hide"></span>
            </p>
            <p class="alone_show" inputType ="textarea">
                <label class="icon54 textarea_54">文本域</label>
                <textarea name="" ></textarea>
                <span class="hint_bar_delete"></span>
                <span class="hint_bar_copy"></span>
                <span class="hint_bar_hide"></span>
            </p>
            <p class="checkbox_case_layout" inputType ="checkbox">
                <label class="icon54 checkbox_54" >复选框</label>
                <span class="checkbox_default_show"></span>
                <span class="hint_bar_delete"></span>
                <span class="hint_bar_copy"></span>
                <span class="hint_bar_hide"></span>
            </p>
            <p class="radio_endwise_layout radio_alone_show" inputType ="radio" canDragToDetail="false">
                <label class="icon54 radio_54" >单选按钮</label>
                <span class="radio_default_show">选项一</span>
                <span class="radio_default_show radio_checked_show">选项二</span>
                <span class="radio_default_show">选项三</span>
                <span class="hint_bar_delete"></span>
                <span class="hint_bar_copy"></span>
                <span class="hint_bar_hide"></span>
            </p>
            <p class="comblockshow" inputType ="select">
                <label class="icon54 select_54">下拉框</label>
                <span class="select_default_show">请选择</span>
                <span class="hint_bar_delete"></span>
                <span class="hint_bar_copy"></span>
                <span class="hint_bar_hide"></span>
            </p>
            <p class="comblockshow" inputType = "text">
                <label class="icon54 date_54">日期</label>
                <input type="text" value="系统日期" />
                <span class="hint_bar_delete"></span>
                <span class="hint_bar_copy"></span>
                <span class="hint_bar_hide"></span>
            </p>
            <p class="comblockshow" inputType = "text">
                <label class="icon54 datetime_54">日期时间</label>
                <input type="text" value="系统时间" />
                <span class="hint_bar_delete"></span>
                <span class="hint_bar_copy"></span>
                <span class="hint_bar_hide"></span>
            </p>
            <p class="comblockshow" inputType = "text">
               <label class="icon54 lable_54">标签</label>
               <input type="text" value="标签" />
                <span class="hint_bar_delete"></span>
                <span class="hint_bar_copy"></span>
            </p>
            <p class="comblockshow" inputType = "text">
            	<label class="icon54 handwrite_54">签章</label>
                <input type="text" value="签章"  />
                <span class="hint_bar_delete"></span>
                <span class="hint_bar_copy"></span>
                <span class="hint_bar_hide"></span>
            </p>
            <p class="comblockshow" inputType ="textarea" canDragToDetail="false">
                <label class="icon54 flowdealoption_54">流程意见</label>
                <textarea name="" ></textarea>
                <span class="hint_bar_delete"></span>
                <span class="hint_bar_copy"></span>
                <span class="hint_bar_hide"></span>
            </p>
        </div>
    
    </div>
    <div class="form_center adaptive_box_flex">
        <div class="iphone5s_pic">
            <div class="iphone_content model_type form_area">
                <p id="formHead" class="form_title" clickSourceFun="showRightAttrsByTrigger">
                    <!-- <img src="" class="form_logo"/> -->
                    <span class="formName" title="">表单标题</span>
                </p>
                <div class="contents_show formContent"></div>
                <div class="form_footer">
                    <div id="formFooterButtons">
                        <input type="button" value="保存" id="saveButton"/>
                        <!--<input type="button" value="保存" >-->
                        <input type="button" value="删除本视图" id="cancelButton"/>
                    </div>
                </div>
            </div>
         </div>
    </div>
    
    <div id="formRightDiv" class="form_area form_right">
        <p id="baseCfgP" class="contents_type plan_model border_box"><span class="ico16 hole_trigon hole_trigon_spread"></span>${ctp:i18n('form.mobile.designer.form.setting')}</p>
        <div id="baseCfgDiv" class="contents_content form_area">
        	<fieldset class="contents_content_layout">
                <legend>${ctp:i18n('form.mobile.designer.recommended.color')}</legend>
                <ul class="clearFlow suggest_color" >
                    <li><span class="suggest_color_1" colorValue="#DEDEDE;#FFFFFF;#000000;#757575" clickSourceFun="com.seeyon.lightform.FormEvents.suggestColor"></span></li>
                    <li><span class="suggest_color_2" colorValue="#EFEFF4;#FF3D33;#FFFFFF;#FF3D33" clickSourceFun="suggestColor"></span></li>
                    <li><span class="suggest_color_3" colorValue="#EDE8E2;#EEAE19;#FFFFFF;#EEAE19" clickSourceFun="suggestColor"></span></li>
                </ul>
                <ul class="clearFlow suggest_color">
                    <li><span class="suggest_color_4" colorValue="#EDECD6;#88B82E;#FFFFFF;#88B82E" clickSourceFun="suggestColor"></span></li>
                    <li><span class="suggest_color_5" colorValue="#F0F0F0;#117ACB;#FFFFFF;#117ACB" clickSourceFun="suggestColor"></span></li>
                    <li><span class="suggest_color_6" colorValue="#E6E5E8;#AB58AA;#FFFFFF;#AB58AA" clickSourceFun="suggestColor"></span></li>
                </ul>
            </fieldset>
			
			<fieldset class="contents_content_layout">
                <legend>${ctp:i18n('form.mobile.designer.header.setting')}</legend>
                <!--<div class="attribute_com">
                	<span class="attribute_com_lspan">控件描述</span><div class="attribute_com_set">
                        <input type="text" class="single_text" />input、textarea二选一
                        <textarea class="textarea_mutiple"></textarea>
                    </div>
                </div>-->
                <div class="attribute_set" style="margin-top:5px;">
                	<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.header.name')}</span><div class="fon_color_set">
                        <input type="text" id="formName" inputChangeSourceFun="setFormName" blurSourceFun="blur4checkFormName" class="form_head validate" />
                    </div>
                </div>
                <div class="attribute_set base_attribute_set display_none">
                    <span class="attribute_set_lspan">表头字体</span><select id="set_fontFamily0" changeSourceFun="changeFormheadFontFamily" class="widget_style_select">
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
                    </select>
                </div>
                <div class="attribute_set">
                    <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_fontSize0"><a href="javascript:;" class="icon24 ColumnNumDecreasing" clickSourceFun="decreasingFormHeadFontSize" title="${ctp:i18n('form.mobile.designer.decline')}"></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetFormFontSize" value="18px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" clickSourceFun="creasingFormHeadFontSize" title="${ctp:i18n('form.mobile.designer.increasing')}"></a></span> <span class="font_bold_set" id="setFontbold0" clickSourceFun="changeFormheadFontbold">B</span>
                </div>
                <div class="attribute_set fon_color_set_div">
                    <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="fon_color_set0" colorChangeSourceFun="changeFormHeadFontColor"></span></div>
                </div>
                <div class="attribute_set fon_color_set_div">
                    <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.header.background')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="fon_background_set0" colorChangeSourceFun="changeFormHeadBgColor"></span></div>
                </div>
            </fieldset>
			<fieldset class="contents_content_layout">
                <legend>${ctp:i18n('form.mobile.designer.control.setting')}</legend>
                <div class="attribute_set base_attribute_set">
                    <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.display.mode')}</span><select id="set_control_text_showStyle"  changeSourceFun="changeControlTitleDisplay" class="common_selectbox_wrap">
                        <option value="0">${ctp:i18n('form.mobile.designer.display.value1')}</option>
                        <option value="1" selected="selected">${ctp:i18n('form.mobile.designer.display.value2')}</option>
                        <option value="2">${ctp:i18n('form.mobile.designer.display.value3')}</option>
                    </select>
                </div>
                <div class="attribute_set base_attribute_set display_none">
                    <span class="attribute_set_lspan">控件字体</span><select id="set_control_fontFamily" changeSourceFun="changeControlFontFamily" class="widget_style_select">
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
                    </select>
                </div>
                <div class="attribute_set">
                    <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_control_fontSize"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun="decreasingControlFontSize"></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetControlFontSize" value="16px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}" clickSourceFun="creasingControlFontSize"></a></span> <span class="font_bold_set" id="set_control_Fontbold" clickSourceFun="changeControlFontbold">B</span>
                </div>
                <div class="attribute_set fon_color_set_div">
                    <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="set_control_fontColor" colorChangeSourceFun="changeControlFontColor"></span></div>
                </div>
                <div class="attribute_set fon_color_set_div">
                    <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.background')}</span><div class="fon_color_set"><input type="text" readonly value="#FFFFFF" class="color_value fon_color_set_value"> <span id="set_control_bgColor" colorChangeSourceFun="changeControlBgColor"></span></div>
                </div>
                
            </fieldset>
			<fieldset class="contents_content_layout">
                <legend>${ctp:i18n('form.mobile.designer.other.setting')}</legend>
                <div class="attribute_set fon_color_set_div" style="margin-bottom:10px;">
                    <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.form.background')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="set_fieldBgColor" colorChangeSourceFun="changeShowbgColor" ></span></div>
                </div>
                <div class="attribute_set">
                    <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.spacing')}</span><span class="ColumnNum" id="set_spacing"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun="decreasingFormSetingSpacing"></a><input class="spacingNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetFormSetingSpacing" value="0px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" clickSourceFun="creasingFormSetingSpacing" title="${ctp:i18n('form.mobile.designer.increasing')}"></a></span>
                </div>
                <!-- <div class="attribute_set bg_pic_set">
               		<input type="checkbox" id="showLogo" value="true" clickSourceFun="showLogo"/><span class="attribute_set_lspan">显示表头logo</span>
                </div> -->
                <!-- <div class="attribute_set bg_pic_set">
               		<input type="checkbox" id="showCutLine" checked value="true" clickSourceFun="showCutLine"/><span class="attribute_set_lspan">显示控件分隔线</span>
                </div>
                <div class="attribute_set fon_color_set_div">
                    <span class="attribute_set_lspan">分隔线颜色</span><div class="fon_color_set"><input type="text" readonly value="#CCCCCC" class="color_value fon_color_set_value"> <span id="set_control_borderColor" colorChangeSourceFun="changeControlBorderColor"></span></div>
                </div> -->
                <div class="attribute_set base_attribute_set">
                    <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.border')}</span><select id="set_controlFieldBorder" changeSourceFun="changeControlFieldBorder" class="widget_style_select">
                		  <option value="0">${ctp:i18n('form.mobile.designer.border.value1')}</option>
                		  <option value="1">${ctp:i18n('form.mobile.designer.border.value2')}</option>
                		  <!-- <option value="2" selected>无边框</option> -->
                    </select>

                </div>
                <div class="attribute_set base_attribute_set">
                    <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.border.color')}</span><div class="fon_color_set"><input type="text" readonly value="#CCCCCC" class="color_value fon_color_set_value"> <span id="set_controlField_borderColor" colorChangeSourceFun="changeControlFieldBorderColor" ></span></div>
                </div><br>
                
            </fieldset>
 <!--            <fieldset class="contents_content_layout">
                <legend>表头设置</legend>
                <p class="red_star">标题
                    <input type="text" id="formName" class="form_head validate" maxlength="20" />
                    <input type="hidden" id="logoUrl" value=""/>
                </p>
            </fieldset>
            <fieldset class="contents_content_layout">
                <legend>推荐配色</legend>
                <ul class="clearFlow suggest_color">
                    <li><span class="suggest_color_1" colorValue="#DEDEDE;#FFFFFF;#000000;#757575"></span></li>
                    <li><span class="suggest_color_2" colorValue="#EFEFF4;#FF3D33;#FFFFFF;#FF3D33"></span></li>
                    <li><span class="suggest_color_3" colorValue="#EDE8E2;#EEAE19;#FFFFFF;#EEAE19"></span></li>
                </ul>
                <ul class="clearFlow suggest_color">
                    <li><span class="suggest_color_4" colorValue="#EDECD6;#88B82E;#FFFFFF;#88B82E"></span></li>
                    <li><span class="suggest_color_5" colorValue="#F0F0F0;#117ACB;#FFFFFF;#117ACB"></span></li>
                    <li><span class="suggest_color_6" colorValue="#E6E5E8;#AB58AA;#FFFFFF;#AB58AA"></span></li>
                </ul>
                <h3>点击更改颜色</h3>
                <ul class="clearFlow model_color_change">
                    <li>
                        <p class="model_color_bg form_content_bg" model_name="3"></p>
                        <input type="hidden" id="fieldBgColor" value="" class="color_value"/>
                    </li>
                    <li>
                        <p class="model_color_bg form_header_bg" model_name="2"></p>
                        <input type="hidden" id="headBgColor" value="" class="color_value"/>
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
                        <label for="formNameSize">表单名称</label>
                        <select name="form_name"  class="form_name" id="formNameSize">
                            <option>12px</option>
                            <option>14px</option>
                            <option selected="selected">18px</option>
                            <option>20px</option>
                            <option>24px</option>
                        </select>
                        <span class="formNameBolder" mode_value="1">B</span>
                        <input type="hidden" id="formNameBolder" value="normal">
                    </li>
                    <li>
                        <label for="">重复表头文字</label>
                        <select name="repeat_form_header" id="detailFormHeadSize">
                            <option>12px</option>
                            <option>14px</option>
                            <option selected="selected">18px</option>
                            <option>20px</option>
                            <option>24px</option>
                        </select>
                        <span class="detailNameBolder" mode_value="3">B</span>
                        <input type="hidden" id="detailNameBolder" value="normal">
                    </li>
                </ul>
            </fieldset>
            <fieldset class="contents_content_layout">
                <legend>其他设置</legend>
                <br>
                <div class="attribute_set">
                    <span class="attribute_set_lspan">控件间距</span><span class="ColumnNum" id="set_spacing"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="递减"></a><input class="spacingNumValue" readonly value="10px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="递增"></a></span>
                </div>
                <div class="attribute_set bg_pic_set">
               		<input type="checkbox" id="showLogo" value="true"/><span class="attribute_set_lspan">表头logo</span>
                </div>
                <div class="attribute_set bg_pic_set">
               		<input type="checkbox" id="showCutLine" checked value="true"/><span class="attribute_set_lspan">显示控件分隔线</span>
                </div>
                <div class="attribute_set bg_pic_set">
               		<input type="checkbox" id="showBorderLine" checked value="true"/><span class="attribute_set_lspan">显示控件值边框</span>
                </div>
            </fieldset> -->
			
			
        </div>
        <p id="fieldCfgP" class="contents_type plan_model position_map border_box"><span class="ico16 hole_trigon"></span>${ctp:i18n('form.mobile.designer.control.setting')}</p>
        <div class="contents_content contents_attribute form_area">
        	
            

          
            
            
        </div>
        
    </div>
</div>


<script type="text/html" id="lableAttrTemplate"> 

<div class="baseSet">
	<div class="attribute_set fon_color_set_div set_ControlBgColor">
		<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.background')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="set_this_control_bgColor" colorChangeSourceFun="changeCurrControllBgColor"></span></div>
	</div>
	<fieldset class="contents_content_layout">
		<legend>${ctp:i18n('form.mobile.designer.control.title')}</legend>
		<div class="attribute_set" style="margin-top:5px;">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.name')}</span><div class="fon_color_set">
				<input type="text" id="text_fieldName" inputChangeSourceFun="changeTitleText"  blurSourceFun="blur4changeTitleText"  class="single_text" />
			</div>
		</div>
		<div class="attribute_set base_attribute_set">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.display.mode')}</span><select id="text_showStyle"  changeSourceFun="changeTitleDisplay" class="common_selectbox_wrap">
				<option value="0">${ctp:i18n('form.mobile.designer.display.value1')}</option>
				<option value="1">${ctp:i18n('form.mobile.designer.display.value2')}</option>
                <option value="2">${ctp:i18n('form.mobile.designer.display.value3')}</option>
			</select>
		</div>
		<div class="attribute_set base_attribute_set display_none">
			<span class="attribute_set_lspan">标题字体</span><select id="set_fontFamily1" changeSourceFun="changeCurrFontFamily" class="widget_style_select">
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
			</select>
		</div>
		<div class="attribute_set">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_fontSize1"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun="decreasingCurrControlFontSize"></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrControlFontSize" value="16px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}" clickSourceFun="creasingCurrControlFontSize"></a></span> <span class="font_bold_set" id="setFontbold1" clickSourceFun="changeCurrTitleFontBold">B</span>
		</div>
		<div class="attribute_set fon_color_set_div">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="fon_color_set1" colorChangeSourceFun="changeCurrTitleColor"></span></div>
		</div>

	</fieldset>
	<div class="baseIn">
	<fieldset class="contents_content_layout">
		<legend>${ctp:i18n('form.mobile.designer.control.value')}</legend>
		<div class="attribute_set base_attribute_set display_none">
			<span class="attribute_set_lspan">标题字体</span><select id="set_fontFamily2" changeSourceFun="changeCurrFieldFontFamily" class="widget_style_select" >
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
			</select>
		</div>
		<div class="attribute_set">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_fontSize2"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun="decreasingCurrControlFieldFontSize" ></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrControlFieldFontSize" value="16px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}"  clickSourceFun="creasingCurrControlFieldFontSize"></a></span> <span class="font_bold_set" id="setFontbold2" clickSourceFun="changeCurrFieldFontBold">B</span>
		</div>
		<div class="attribute_set fon_color_set_div">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#101010" class="color_value fon_color_set_value"> <span id="fon_color_set2" colorChangeSourceFun="changeCurrFieldColor"></span></div>
		</div>
		<div class="attribute_set" style="margin-top:5px;">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.box.height')}</span><span class="ColumnNum" id="set_control_height"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun ="decreasingCurrFieldHeight"></a><input class="heightValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrFieldHeight" value="0px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}" clickSourceFun ="creasingCurrFieldHeight"></a></span>
		</div>
	</fieldset>
	</div>
		

</div>
			
</script>
	
<script type="text/html" id="textfieldAttrTemplate"> 

<div class="baseSet">
	<div class="attribute_set fon_color_set_div set_ControlBgColor">
		<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.background')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="set_this_control_bgColor"  colorChangeSourceFun="changeCurrControllBgColor"></span></div>
	</div>
	<fieldset class="contents_content_layout">
		<legend>${ctp:i18n('form.mobile.designer.control.title')}</legend>
		<div class="attribute_set" style="margin-top:5px;">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.name')}</span><div class="fon_color_set">
				<input type="text" id="text_fieldName" inputChangeSourceFun="changeTitleText"  blurSourceFun="blur4changeTitleText"  class="single_text" />
			</div>
		</div>
		<div class="attribute_com">
			<span class="attribute_com_lspan">${ctp:i18n('form.mobile.designer.control.description')}</span><div class="attribute_com_set">
				<input type="text" id="text_field_placeholder" inputChangeSourceFun="changeFieldDescription" class="single_text" />
			</div>
		</div>
		<div class="attribute_set base_attribute_set">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.display.mode')}</span><select id="text_showStyle" changeSourceFun="changeTitleDisplay" class="common_selectbox_wrap">
				<option value="0">${ctp:i18n('form.mobile.designer.display.value1')}</option>
				<option value="1">${ctp:i18n('form.mobile.designer.display.value2')}</option>
				<option value="2">${ctp:i18n('form.mobile.designer.display.value3')}</option>
			</select>
		</div>
		
		<div class="attribute_set base_attribute_set display_none">
			<span class="attribute_set_lspan">标题字体</span><select id="set_fontFamily1" changeSourceFun="changeCurrFontFamily" class="widget_style_select">
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
			</select>
		</div>
		<div class="attribute_set">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_fontSize1"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun="decreasingCurrControlFontSize"></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrControlFontSize" value="16px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}" clickSourceFun="creasingCurrControlFontSize"></a></span> <span class="font_bold_set" id="setFontbold1" clickSourceFun="changeCurrTitleFontBold">B</span>
		</div>
		<div class="attribute_set fon_color_set_div">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="fon_color_set1" colorChangeSourceFun="changeCurrTitleColor"></span></div>
		</div>

	</fieldset>
	<div class="baseIn">
	<fieldset class="contents_content_layout">
		<legend>${ctp:i18n('form.mobile.designer.control.value')}</legend>
		<div class="attribute_set base_attribute_set display_none">
			<span class="attribute_set_lspan">标题字体</span><select id="set_fontFamily2" changeSourceFun="changeCurrFieldFontFamily" class="widget_style_select" >
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
			</select>
		</div>
		<div class="attribute_set">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_fontSize2"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}"  clickSourceFun="decreasingCurrControlFieldFontSize"></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrControlFieldFontSize" value="16px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}"  clickSourceFun="creasingCurrControlFieldFontSize"></a></span> <span class="font_bold_set" id="setFontbold2" clickSourceFun="changeCurrFieldFontBold">B</span>
		</div>
		<div class="attribute_set fon_color_set_div">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#101010" class="color_value fon_color_set_value"> <span id="fon_color_set2" colorChangeSourceFun="changeCurrFieldColor"></span></div>
		</div>
		<div class="attribute_set" style="margin-top:5px;">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.box.height')}</span><span class="ColumnNum" id="set_control_height"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun ="decreasingCurrFieldHeight"></a><input class="heightValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrFieldHeight" value="0px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}" clickSourceFun ="creasingCurrFieldHeight"></a></span>
		</div>
	</fieldset>
	</div>
		

</div>
			
</script>

	
<script type="text/html" id="radioAttrTemplate"> 
<div class="baseSet">
	<div class="attribute_set fon_color_set_div set_ControlBgColor">
		<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.background')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="set_this_control_bgColor"  colorChangeSourceFun="changeCurrControllBgColor"></span></div>
	</div>
	<fieldset class="contents_content_layout">
		<legend>${ctp:i18n('form.mobile.designer.control.title')}</legend>
		<div class="attribute_set" style="margin-top:5px;">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.name')}</span><div class="fon_color_set">
				<input type="text" id="text_fieldName" inputChangeSourceFun="changeTitleText"  blurSourceFun="blur4changeTitleText"  class="single_text" />
			</div>
		</div>
		<div class="attribute_set base_attribute_set">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.display.mode')}</span><select id="text_showStyle"  changeSourceFun="changeTitleDisplay" class="common_selectbox_wrap">
                <option value="0">${ctp:i18n('form.mobile.designer.display.value1')}</option>
                <option value="1">${ctp:i18n('form.mobile.designer.display.value2')}</option>
                <option value="2">${ctp:i18n('form.mobile.designer.display.value3')}</option>
            </select>
		</div>
		<div class="attribute_set base_attribute_set display_none">
			<span class="attribute_set_lspan">标题字体</span><select id="set_fontFamily1" changeSourceFun="changeCurrFontFamily" class="widget_style_select">
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
			</select>
		</div>

		<div class="attribute_set">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_fontSize1"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun="decreasingCurrControlFontSize"></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrControlFontSize" value="16px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}" clickSourceFun="creasingCurrControlFontSize"></a></span> <span class="font_bold_set" id="setFontbold1" clickSourceFun="changeCurrTitleFontBold">B</span>
		</div>
		<div class="attribute_set fon_color_set_div">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="fon_color_set1" colorChangeSourceFun="changeCurrTitleColor"></span></div>
		</div>

	</fieldset>
	<div class="baseIn">
	<fieldset class="contents_content_layout">
		<legend>${ctp:i18n('form.mobile.designer.control.value')}</legend>
		<div class="attribute_set base_attribute_set display_none">
			<span class="attribute_set_lspan">标题字体</span><select id="set_fontFamily2" changeSourceFun="changeCurrFieldFontFamily" class="widget_style_select"  >
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
			</select>
		</div>
		<div class="attribute_set">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_fontSize2"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}"  clickSourceFun="decreasingCurrControlFieldFontSize"></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrControlFieldFontSize" value="16px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}"  clickSourceFun="creasingCurrControlFieldFontSize"></a></span> <span class="font_bold_set" id="setFontbold2" clickSourceFun="changeCurrFieldFontBold">B</span>
		</div>
		<div class="attribute_set fon_color_set_div">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#101010" class="color_value fon_color_set_value"> <span id="fon_color_set2" colorChangeSourceFun="changeCurrFieldColor"></span></div>
		</div>
	</fieldset>
	</div>
		

</div>
 
<div class="checkbox_or_radio_Set" style="margin-top:10px;">
	<div class="attribute_set clearFlow" id="set_display">
		<span class="select_style select_style_active hover" model_display="0" clickSourceFun="changeRadioDisplay">${ctp:i18n("form.mobile.designer.control.horizontal")}</span>
		<span class="select_style hover" model_display="1" clickSourceFun="changeRadioDisplay">${ctp:i18n("form.mobile.designer.control.vertical")}</span>
	</div>
</div> 
</script>


<script type="text/html" id="checkboxAttrTemplate"> 
<div class="baseSet">
	<div class="attribute_set fon_color_set_div set_ControlBgColor">
		<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.background')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="set_this_control_bgColor"  colorChangeSourceFun="changeCurrControllBgColor"></span></div>
	</div>
	<fieldset class="contents_content_layout">
		<legend>${ctp:i18n('form.mobile.designer.control.title')}</legend>
		<div class="attribute_set" style="margin-top:5px;">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.name')}</span><div class="fon_color_set">
				<input type="text" id="text_fieldName" inputChangeSourceFun="changeTitleText"  blurSourceFun="blur4changeTitleText"  class="single_text" />
			</div>
		</div>
        <div class="attribute_set base_attribute_set">
            <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.display.mode')}</span><select id="text_showStyle"  changeSourceFun="changeTitleDisplay" class="common_selectbox_wrap">
                <option value="0">${ctp:i18n('form.mobile.designer.display.value1')}</option>
                <option value="1">${ctp:i18n('form.mobile.designer.display.value2')}</option>
                <option value="2">${ctp:i18n('form.mobile.designer.display.value3')}</option>
            </select>
        </div>
		<div class="attribute_set base_attribute_set display_none">
			<span class="attribute_set_lspan">标题字体</span><select id="set_fontFamily1" changeSourceFun="changeCurrFontFamily" class="widget_style_select">
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
			</select>
		</div>
		<div class="attribute_set">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_fontSize1"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun="decreasingCurrControlFontSize"></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrControlFontSize" value="16px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}"  clickSourceFun="creasingCurrControlFontSize"></a></span> <span class="font_bold_set" id="setFontbold1" clickSourceFun="changeCurrTitleFontBold">B</span>
		</div>
		<div class="attribute_set fon_color_set_div">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="fon_color_set1" colorChangeSourceFun="changeCurrTitleColor"></span></div>
		</div>

	</fieldset>
		

</div>
</script>


<script type="text/html" id="linespaceAttrTemplate"> 

<div class="attribute_set fon_color_set_div set_ControlBgColor">
	<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.background')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="set_this_control_bgColor"  colorChangeSourceFun="changeCurrControllBgColor"></span></div>
</div>
<div class="linespace_Set">
<div class="attribute_set height_set clearFlow">
	<p>
		<input type="radio" name="height_set" clickSourceFun ="changeLineSpaceHeight" id="height_set_1" value="7px">
		<label for="height_set_1">1/4行高</label>
	</p>
	<p>
		<input type="radio" name="height_set" clickSourceFun ="changeLineSpaceHeight" id="height_set_2" value="10px">
		<label for="height_set_2">1/3行高</label>
	</p>
	<p>
		<input type="radio" name="height_set" clickSourceFun ="changeLineSpaceHeight" id="height_set_3" value="15px">
		<label for="height_set_3">1/2行高</label>
	</p>
	<p>
		<input type="radio" name="height_set" clickSourceFun ="changeLineSpaceHeight" id="height_set_4" value="30px">
		<label for="height_set_4">单倍行高</label>
	</p>
	<p>
		<input type="radio" name="height_set" clickSourceFun ="changeLineSpaceHeight" id="height_set_5" value="60px">
		<label for="height_set_5">双倍行高</label>
	</p>
</div>
</div>
</script>
	

<script type="text/html" id="detailformAttrTemplate"> 
<div class="baseSet">
	<div class="attribute_set fon_color_set_div set_ControlBgColor">
		<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.background')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="set_this_control_bgColor"  colorChangeSourceFun="changeCurrControllBgColor"></span></div>
	</div>
	<fieldset class="contents_content_layout">
		<legend>${ctp:i18n('form.mobile.designer.control.title')}</legend>
		<div class="attribute_set" style="margin-top:5px;">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.name')}</span><div class="fon_color_set">
				<input type="text" id="text_fieldName" inputChangeSourceFun="changeTitleText" blurSourceFun="blur4changeTitleText"  class="single_text" />
			</div>
		</div>
		<div class="attribute_set base_attribute_set display_none">
			<span class="attribute_set_lspan">标题字体</span><select id="set_fontFamily1" changeSourceFun="changeCurrFontFamily" class="widget_style_select">
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
			</select>
		</div>
		<div class="attribute_set">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_fontSize1"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun="decreasingCurrControlFontSize"></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrControlFontSize" value="16px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}" clickSourceFun="creasingCurrControlFontSize"></a></span> <span class="font_bold_set" id="setFontbold1" clickSourceFun="changeCurrTitleFontBold">B</span>
		</div>
		<div class="attribute_set fon_color_set_div">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="fon_color_set1" colorChangeSourceFun="changeCurrTitleColor"></span></div>
		</div>
        <div class="attribute_set bg_pic_set">
            <input type="checkbox" id="repeatShow" clickSourceFun="changeCurrRepeatShow" value="true"/><span class="attribute_set_lspan">重复表默认收起</span>
        </div>
	</fieldset>
		

</div>
</script>	


<script type="text/html" id="fileAttrTemplate">
<div class="baseSet">
	<div class="attribute_set fon_color_set_div set_ControlBgColor">
		<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.background')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="set_this_control_bgColor"  colorChangeSourceFun="changeCurrControllBgColor"></span></div>
	</div>
	<fieldset class="contents_content_layout">
		<legend>${ctp:i18n('form.mobile.designer.control.title')}</legend>
		<div class="attribute_set" style="margin-top:5px;">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.name')}</span><div class="fon_color_set">
				<input type="text" id="text_fieldName" inputChangeSourceFun="changeTitleText" blurSourceFun="blur4changeTitleText"  class="single_text" />
			</div>
		</div>
        <div class="attribute_set base_attribute_set">
            <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.display.mode')}</span><select id="text_showStyle"  changeSourceFun="changeTitleDisplay" class="common_selectbox_wrap">
                <option value="0">${ctp:i18n('form.mobile.designer.display.value1')}</option>
                <option value="1">${ctp:i18n('form.mobile.designer.display.value2')}</option>
                <option value="2">${ctp:i18n('form.mobile.designer.display.value3')}</option>
            </select>
        </div>
		<div class="attribute_set base_attribute_set display_none">
			<span class="attribute_set_lspan">标题字体</span><select id="set_fontFamily1" changeSourceFun="changeCurrFontFamily" class="widget_style_select">
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
			</select>
		</div>
		<div class="attribute_set">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_fontSize1"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun="decreasingCurrControlFontSize"></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrControlFontSize" value="16px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}" clickSourceFun="creasingCurrControlFontSize"></a></span> <span class="font_bold_set" id="setFontbold1" clickSourceFun="changeCurrTitleFontBold">B</span>
		</div>
		<div class="attribute_set fon_color_set_div">
			<span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="fon_color_set1" colorChangeSourceFun="changeCurrTitleColor"></span></div>
		</div>

	</fieldset>
		

</div>
</script>	


<script type="text/html" id="newfileAttrTemplate">

<div class="baseSet">
    <div class="attribute_set fon_color_set_div set_ControlBgColor">
        <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.background')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="set_this_control_bgColor"  colorChangeSourceFun="changeCurrControllBgColor"></span></div>
    </div>
    <fieldset class="contents_content_layout">
        <legend>${ctp:i18n('form.mobile.designer.control.title')}</legend>
        <div class="attribute_set" style="margin-top:5px;">
            <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.control.name')}</span><div class="fon_color_set">
                <input type="text" id="text_fieldName" inputChangeSourceFun="changeTitleText"  blurSourceFun="blur4changeTitleText"  class="single_text" />
            </div>
        </div>
        <div class="attribute_set base_attribute_set">
            <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.display.mode')}</span><select id="text_showStyle" changeSourceFun="changeTitleDisplay" class="common_selectbox_wrap">
                <option value="0">${ctp:i18n('form.mobile.designer.display.value1')}</option>
                <option value="1">${ctp:i18n('form.mobile.designer.display.value2')}</option>
                <option value="2">${ctp:i18n('form.mobile.designer.display.value3')}</option>
            </select>
        </div>
        
        <div class="attribute_set base_attribute_set display_none">
            <span class="attribute_set_lspan">标题字体</span><select id="set_fontFamily1" changeSourceFun="changeCurrFontFamily" class="widget_style_select">
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
            </select>
        </div>
        <div class="attribute_set">
            <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_fontSize1"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun="decreasingCurrControlFontSize"></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrControlFontSize" value="16px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}" clickSourceFun="creasingCurrControlFontSize"></a></span> <span class="font_bold_set" id="setFontbold1" clickSourceFun="changeCurrTitleFontBold">B</span>
        </div>
        <div class="attribute_set fon_color_set_div">
            <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#000000" class="color_value fon_color_set_value"> <span id="fon_color_set1" colorChangeSourceFun="changeCurrTitleColor"></span></div>
        </div>

    </fieldset>
    <div class="baseIn">
    <fieldset class="contents_content_layout">
        <legend>${ctp:i18n('form.mobile.designer.control.value')}</legend>
        <div class="attribute_set base_attribute_set display_none">
            <span class="attribute_set_lspan">标题字体</span><select id="set_fontFamily2" changeSourceFun="changeCurrFieldFontFamily" class="widget_style_select" >
                        <option value="Microsoft YaHei">微软雅黑</option>
                        <option value="STXihei">华文细黑</option>
                        <option value="SimSun">宋体</option>
                        <option value="FangSong">仿宋</option>
                        <option value="KaiTi">楷体</option>
                        <option value="SimHei">黑体</option>
            </select>
        </div>
        <div class="attribute_set">
            <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontsize')}</span><span class="ColumnNum" id="set_fontSize2"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}"  clickSourceFun="decreasingCurrControlFieldFontSize"></a><input class="ColumnNumValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrControlFieldFontSize" value="16px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}"  clickSourceFun="creasingCurrControlFieldFontSize"></a></span> <span class="font_bold_set" id="setFontbold2" clickSourceFun="changeCurrFieldFontBold">B</span>
        </div>
        <div class="attribute_set fon_color_set_div">
            <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.fontcolor')}</span><div class="fon_color_set"><input type="text" readonly value="#101010" class="color_value fon_color_set_value"> <span id="fon_color_set2" colorChangeSourceFun="changeCurrFieldColor"></span></div>
        </div>
        <div class="attribute_set" style="margin-top:5px;">
            <span class="attribute_set_lspan">${ctp:i18n('form.mobile.designer.box.height')}</span><span class="ColumnNum" id="set_control_height"><a href="javascript:;" class="icon24 ColumnNumDecreasing" title="${ctp:i18n('form.mobile.designer.decline')}" clickSourceFun ="decreasingCurrFieldHeight"></a><input class="heightValue" clickSourceFun="updateFontSize" blursourcefun="blurSetCurrFieldHeight" value="0px" type="text"><a href="javascript:;" class="icon24 ColumnNumIncreasing" title="${ctp:i18n('form.mobile.designer.increasing')}" clickSourceFun ="creasingCurrFieldHeight"></a></span>
        </div>
    </fieldset>
    </div>
        

</div>
</script>

<script type="text/html" id="formButtonsTemplate"> 
{{each jsonData as item index}}
	 <input type="button" value="{{item.name}}" class="{{item.cls}}" id="form_button_{{index}}" clickRule="{{item.clickRule}}" dbClickRule="{{item.dbClickRule}}"></input>
{{/each}}
</script>	
<!-- 左侧控件列表的共用模板 -->

<!-- 不转义 则为 {{=item.html}}-->
<script type="text/html" id="leftControllTemplate"> 
{{each jsonData as item index}}
{{if item.isRoot == true}} 
<p class="contents_type plan_model border_box" {{if item.inputStatus=='get'}} tableName="{{item.name}}" {{/if}}><span class="ico16 hole_trigon {{if index == 0}}hole_trigon_spread{{/if}}"></span>{{item.fieldTitle}}</p>
<div class="contents_content">
{{/if}}

{{if item.isRoot ==false}}

	<p class="{{item.cls}}" inputType = "{{item.inputType}}" name="{{item.name}}"
		{{if item.canDelete ===false || item.canDelete ==="false" }} canDelete="false" {{/if}}
		{{if item.canUpdateFieldTitle ===false || item.canUpdateFieldTitle ==="false" }} canUpdateFieldTitle="false" {{/if}}
		{{if typeof item.canDragToDetail !='undefined' &&( item.canDragToDetail ===false || item.canDragToDetail ==="false") }}canDragToDetail="false"{{/if}} >
		<label>{{item.fieldTitle}}</label>
        <span class="icon54 {{item.inputType}}_54 controlType">{{if item.inputStatus=='get'}} {{item.fieldType}} {{/if}}</span>
        {{=item.html}}
		{{if item.inputStatus !='get'}}  <span class="hint_bar_copy"></span> {{/if}}
		{{if !(item.canDelete ===false || item.canDelete ==="false" )}} <span class="hint_bar_delete"></span> {{/if}}
		{{if item.inputStatus!='get'}}
			 {{if item.inputType != 'detailform'}}
        	<span class="hint_bar_hide"></span>
        	{{/if}}
   		{{/if}}
   </p>
{{/if}}

{{if item.isEnd ==true && (item.isRoot ==false || item.isRoot=='false')}}
	</div>
{{/if}}	
{{/each}} 
</script>	


 
 <!-- 不转义 则为 {{=item.html}} 解析输入的对象中的design-->
<!--
 2015 6 27  重复表不需要显隐控制
 {{if item.inputStatus!='get'}}
    {{if item.showType !='6'}}<span class="hint_bar_hide"></span>{{/if}}
    {{if item.showType =='6'}}<span class="hint_bar_show"></span>{{/if}}
{{/if}}
 -->
<script type="text/html" id="contentControllTemplate"> 
{{each jsonData as item index}}
{{if item.inputType=='detailform'}}
	<div class="detial_form" style="{{item.controllStyle}}" controllId="{{item.controllId}}"
		name="{{item.name}}"
		{{if item.canDelete ===false || item.canDelete ==="false" }} canDelete="false" {{/if}}
		{{if item.canUpdateFieldTitle ===false || item.canUpdateFieldTitle ==="false" }} canUpdateFieldTitle="false" {{/if}}
		inputType = "{{item.inputType}}" {{if item.canDragToDetail ===false || item.canDragToDetail ==="false" }} canDragToDetail="false" {{/if}} >
		<p class="detail_spread detail_spread_2" style="{{item.fieldTitleStyle}}">{{item.fieldTitle}}</p>
		<div class="contents_show detail_contents_show ui-sortable">$details</div>
		 
		
		{{if !item.isUpdateAndReadOnly}}
		
			{{if item.inputStatus !='get'}}  <span class="hint_bar_copy"></span> {{/if}}
			{{if !(item.canDelete ===false || item.canDelete ==="false" )}} <span class="hint_bar_delete"></span> {{/if}}
			
		{{/if}}
		
	</div>
{{/if}}	

{{if item.inputType!='detailform'}}
	
	<p class="{{item.cls}}"  style="{{item.controllStyle}}" controllId="{{item.controllId}}" name="{{item.name}}"
		{{if item.canDelete ===false || item.canDelete ==="false" }} canDelete="false" {{/if}}
		{{if item.canUpdateFieldTitle ===false || item.canUpdateFieldTitle ==="false" }} canUpdateFieldTitle="false" {{/if}}
		inputType = "{{item.inputType}}" {{if item.canDragToDetail ===false || item.canDragToDetail ==="false" }} canDragToDetail="false" {{/if}} >
		<label style="{{item.fieldTitleStyle}}">{{item.fieldTitle}}</label> 
        {{=item.designHtml}} 
		
		{{if !item.isUpdateAndReadOnly}}

			{{if item.inputStatus !='get'}}  <span class="hint_bar_copy"></span> {{/if}}
			{{if !(item.canDelete ===false || item.canDelete ==="false" )}} <span class="hint_bar_delete"></span> {{/if}}
			{{if item.inputStatus!='get'}}
				{{if item.showType !='6'}}<span class="hint_bar_hide"></span>{{/if}}
	   			{{if item.showType =='6'}}<span class="hint_bar_show"></span>{{/if}}
			{{/if}}
		{{/if}}
   </p>  
{{/if}}	
{{/each}} 
</script>	
	<!-- form js start--> 
    <script type="text/javascript" src="${path}/common/form/lightFormDesigner/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="${path}/common/form/lightFormDesigner/js/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript" src="${path}/common/form/lightFormDesigner/js/jquery.bigcolorpicker.js"></script>
    <script type="text/javascript" src="${path}/common/form/lightFormDesigner/statics/js/3rd/template/template_debug_3_0_0.js"></script>
    <!-- form js end-->   
  
    
    <!-- form js biz load start--> 
    
    <script type="text/javascript">
    var d1= new Date(); 
	/* 
* Author: JaiHo 
*/  
seeyon.Tool.load({
	/* logic:[ //配置 servlet 或者Controller Action
		//"com.zyp.frame.JSONServlet"
  	], */
  	manager:[
  		//"com.zyp.frame.LogicBiz.method",
  		//"com.zyp.frame.LogicBiz.method2" 
  	],
	system:[
		//"lightFormDesigner/statics/js/3rd/template/template_debug_3_0_0.js"
	], //system js
	biz:[
		//controlls start
		/*
		"lightFormDesigner/js/formbiz/controlls/CheckBox.js",
		"lightFormDesigner/js/formbiz/controlls/Controll.js",
		"lightFormDesigner/js/formbiz/controlls/DetailForm.js",
		"lightFormDesigner/js/formbiz/controlls/File.js",
		"lightFormDesigner/js/formbiz/controlls/LineSpace.js",
		"lightFormDesigner/js/formbiz/controlls/Radio.js",
		"lightFormDesigner/js/formbiz/controlls/Select.js",
		"lightFormDesigner/js/formbiz/controlls/TextArea.js",
		"lightFormDesigner/js/formbiz/controlls/TextField.js",*/
		//controlls end
	 	//"lightFormDesigner/js/formbiz/cfgs/ControllCfg.js",//controll cfg
		//"lightFormDesigner/js/formbiz/FormBiz.js"
		 //, //FormBiz
		 //FormUi
		
		//,
		//"form/js/plugin_v1/Design.js" //plugins
		//"form/js/plugin_v2/Design.js" //plugnis 
		
	], // biz cur []
	callback:function(){
		var d2 = new Date();
		$(document).ready(function(){ //默认进入页面只渲染页面节点
			//com.seeyon.lightform.FormBiz.init($);
			//com.seeyon.lightform.ControllCfg.init($); //渲染页面
			//FormUi.init($);	
			var d3 = new Date();
			//alert(d2-d1);
		});
	}
  });
  seeyon.Tool.require([
  	"common/form/lightFormDesigner/js/formbiz/v_2_0/cfgs/ControllCfg.js",//controll cfg
	"common/form/lightFormDesigner/js/formbiz/v_2_0/FormBiz.js"
  ],function(){
	  	var d2 = new Date();
	  	com.seeyon.lightform.FormBiz.init($);
		com.seeyon.lightform.ControllCfg.init($); //渲染页面
  });
    </script>
    <!-- form js biz load end--> 
    
</body>
</html>