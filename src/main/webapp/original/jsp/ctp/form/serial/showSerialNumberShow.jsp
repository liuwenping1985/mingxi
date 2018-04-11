<%--
 $Author:dengxj$
 $Rev:$
 $Date:: $:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="height: 100%;">
    <head>
        <title>Insert title here</title>
        <style type="text/css">
            .input_div{
		        width: 260px;
		        margin-top: 3px;
		        text-align: left;
		    }
            .input_div input{
		        width: 260px;
		    }
		    .div_style{
		        margin-top:3px;
		        line-height: 20px;
		    }
        </style>
    </head>
    <body style="height: 100%;">
        <div class="stadic_layout">
            <div class="stadic_layout_head   font_size12" style="height: 25px;">
                <div style="padding-top: 5px;padding-left: 5px;">
                <c:choose>
	                <c:when test="${param.type eq 'view' }">
	                   <label class="margin_r_10 left padding_l_5" for="text">${ctp:i18n('form.serailNumber.config.label.view') }</label>
	                </c:when>
	                <c:when test="${param.type eq 'edit' }" >
			            <span>
			             <label class="margin_r_10 left padding_l_5" for="text">${ctp:i18n('form.serailNumber.config.label.modify') }</label>
			             </span>
	                </c:when>
	                <c:when test="${param.type eq 'create' }">
	            <span>
	            <label class="margin_r_10 left padding_l_5" for="text">${ctp:i18n('form.serailNumber.config.label.create') }</label></span>
	                </c:when>
	            </c:choose>
                </div>
            </div>
            <div class="stadic_layout_body form_area" style="top: 25px;overflow-x:hidden;${param.type eq 'view' ? 'bottom: 0px;' : 'bottom: 35px;' }">
                <form id="myfrm" name="form4" method="post" action="serialNumber.do?method=saveSerialNumberInfo" >
                        <div style="width: 100%;text-align: center;">
                        <div style="width: 600px;text-align: center;margin: auto;">
                            <input type="hidden" id="id" name="id" value=""/>
                            <div class="clearfix div_style" style="">
                                <div class="left" style="width: 100px;text-align: right;">
                                    <font color="red">*</font></label><label class="margin_r_10" for="text">${ctp:i18n('form.serailNumber.name')}:</label>
                                </div>
                                <div class="left">
                                    <div class="common_txtbox_wrap input_div left" >
                                        <input type="text" id="variableName" class="validate" name='variableName' validate="avoidChar:'\\/|<>:*?\'&%$#',notNull:true,type:'string', maxLength:255,china3char:true,minLength:1,notNullWithoutTrim:true,name:'${ctp:i18n('form.serailNumber.name')}'" />
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix div_style" >
                                <div class="left" style="width: 100px;text-align: right;">
                                    <input type="checkbox" id="checkprefix"/><label class="margin_r_10 margin_l_5" for="text">${ctp:i18n('form.serailNumberprefix.label')}:</label>
                                </div>
                                <div class="left">
                                    <div class="common_txtbox_wrap input_div left" >
                                        <input type="text" id="prefix" class="validate" name="prefix" validate="type:'string',notNull:false,minLength:1,maxLength:255,china3char:true,name:'${ctp:i18n('form.serailNumberprefix.label')}'" onBlur="preview()" />
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix div_style" >
                                <div class="left" style="width: 100px;text-align: right;">
                                    <label class="margin_r_10" for="text">${ctp:i18n('form.serailNumberTime.label')}:</label>
                                </div>
                                <div class="left" style="width: 270px;text-align: left;">
                                    <div class="common_radio_box clearfix">
                                        <label for="radio1" class="margin_r_10 hand"><input type="radio" value=0 id="radio1" name="timeDate" class="radio_com" onclick="preview()"/>${ctp:i18n('form.timeData.none.lable')}</label>
                                        <label for="radio2" class="margin_r_10 hand"><input type="radio" value=1 id="radio2" name="timeDate" class="radio_com" onclick="preview()"/>${ctp:i18n('form.timeData.year.lable')}</label>
                                        <label for="radio3" class="margin_r_10 hand"><input type="radio" value=2 id="radio3" name="timeDate" class="radio_com" onclick="preview()"/>${ctp:i18n('form.timeData.month.lable')}</label>
                                        <label for="radio4" class="margin_r_10 hand"><input type="radio" value=3 id="radio4" name="timeDate" class="radio_com" onclick="preview()"/>${ctp:i18n('form.timeData.data.lable')}</label>
                                    </div>
                                </div>
                                <div class="left" style="width: 80px;text-align: right;">
                                    <label class="margin_r_10" for="text">${ctp:i18n('form.timedata.end.lable')}:</label>
                                </div>
                                <div class="left">
                                    <div class="common_txtbox_wrap input_div left" style="width: 80px;">
                                        <input type="text" id="textTimeBehind" name="textTimeBehind" class="validate" validate="name:'${ctp:i18n('form.timedata.end.lable')}',notNull:false,type:'string', china3char:true,maxValue:255,minValue:0" onBlur="preview()"></input>
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix div_style" >
                                <div class="left" style="width: 100px;text-align: right;">
                                    <label><font color="red">*</font></label><label class="margin_r_10" for="text">${ctp:i18n('form.value.min.lable')}:</label>
                                </div>
                                <div class="left" style="width: 200px;text-align: left;;">
                                    <div class="common_txtbox_wrap " >
                                        <input type="text" id="minValue"  class="validate" name='minValue' validate="name:'${ctp:i18n('form.value.min.lable')}',notNull:true,isInteger:true,minValue:0" value="1"></input>
                                    </div>
                                </div>
                                <div class="left" style="width: 60px;text-align: right;">
                                    <label><font color="red">*</font></label><label class="margin_r_10" for="text">${ctp:i18n('form.serailNumberLength.label')}:</label>
                                </div>
                                <div class="left">
                                    <div class="common_txtbox_wrap  left"  style="width: 60px;">
                                        <input type="text" id="digit" name='digit' class="validate" validate="name:'${ctp:i18n('form.serailNumberLength.label')}',notNull:true,isInteger:true,maxValue:10, maxLength:5,minLength:1" value="5"></input>
                                    </div>
                                </div>
                                <div class="left" style="width: 120px;text-align: right;">
                                    <input type="checkbox" id="fixLenShow" checked="checked"/> <label class="margin_r_10" for="text">${ctp:i18n('form.serialNumber.fixlengthshow.label')}</label>
                                </div>
                            </div>
                            <div class="clearfix div_style" >
                                <div class="left" style="width: 100px;text-align: right;">
                                    <div><input type="checkbox" id="checksuffix"/><label class="margin_r_10  margin_l_5" for="text">${ctp:i18n('form.serailNumberSuffix.label')}:</label></div>
                                </div>
                                <div class="left">
                                    <div class="common_txtbox_wrap input_div left" >
                                        <input type="text" id="suffix" class="validate" name="suffix" validate="name:'${ctp:i18n('form.serailNumberSuffix.label')}',type:'string',notNull:false,minLength:1,china3char:true,maxLength:255" onBlur="preview()"/>
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix div_style" >
                                <div class="left" style="width: 100px;text-align: right;">
                                    <label class="margin_r_10" for="text">${ctp:i18n('form.checkboxSelectRuleReset.label')}:</label>
                                </div>
                                <div class="left">
                                    <div class="common_radio_box clearfix left" id="ruleResetDiv">
                                        <label for="radio5" class="margin_r_10 hand"><input type="radio" value=0 id="radio5" name="ruleReset" class="radio_com"/>${ctp:i18n('form.rulereset.false')}</label>
                                        <label for="radio6" class="margin_r_10 hand"><input type="radio" value=1 id="radio6" name="ruleReset" class="radio_com"/>${ctp:i18n('form.rulereset.year')}</label>
                                        <label for="radio7" class="margin_r_10 hand"><input type="radio" value=2 id="radio7" name="ruleReset" class="radio_com"/>${ctp:i18n('form.rulereset.month')}</label>
                                        <label for="radio8" class="margin_r_10 hand"><input type="radio" value=3 id="radio8" name="ruleReset" class="radio_com"/>${ctp:i18n('form.rulereset.day')}</label>
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix div_style" >
                                <div class="left" style="width: 50px;text-align: right;">&nbsp;
                                </div>
                                <div class="left">
                                    <fieldset>
                                        <legend>${ctp:i18n('form.query.preview.label')}</legend>
                                        <div class="common_txtbox_wrap input_div" style="width: 500px;">
                                            <input type="text" id="dispvalue" name='dispvalue' readonly style="border-style:none;width: 500px;" />
                                        </div>
                                    </fieldset>
                                </div>
                            </div>
                            <div class="clearfix div_style" >
                                <div class="left">
                                    <div style="color: green;text-align: left;">${ctp:i18n('form.checkboxSelectRuleReset.remark.label')}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <c:if test = "${param.type ne 'view'}">
            <div class="stadic_layout_footer  page_color bg_color w100b hr_heng" style="height: 35px;text-align: center;">
                <div id="button_area" align="center" class="padding_tb_5">
                    <a id="enter" class="common_button common_button_emphasize margin_r_5">${ctp:i18n('common.button.ok.label')}</a>
                    <a id="cancel" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                </div>
            </div>
            </c:if>
     	</div>
 		<%@ include file="showSerialNumberShow.js.jsp" %>
		<script type="text/javascript" src="${path}/ajax.do?managerName=serialNumberManager"></script>
	</body>
</html>