<%--
 $Author: weijh $
 $Rev: 509 $
 $Date:: 2012-07-21 00:08:40#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>基础数据和信息管理页面</title>
</head>
<body scrolling="no" class="h100b overflow_hidden page_color">
<c:if test="${formType=='2' }">
<div class="comp" comp="type:'breadcrumb',code:'T05_unflowInfoData'"></div>
</c:if>
<c:if test="${formType=='3' }">
<div class="comp" comp="type:'breadcrumb',code:'T05_unflowBasicData'"></div>
</c:if>
    <div class="comp" comp="type:'layout'" id="layout1">
        <%-- 左侧树组件 --%>
        <div class="layout_west border_tb border_r" style="background: #fff;">
		        <div class="condition_box form_area margin_l_5 margin_r_5 margin_b_5" id="condition_box" style="float:none;">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="30%">
								<div class=" common_selectbox_wrap">
									<select id="condition" name="condition" class="margin_l_5 font_size12" style="width: 85px;height:22px" onChange="showNextSpecialCondition(this)">
										<option value="">--${ctp:i18n('form.query.chooseCondition')}--</option>
										<option value="bindName">${ctp:i18n('form.trigger.triggerSet.templateName.label')}</option>
                                        <c:if test="${empty param.templateCategoryId}">
										<option value="categoryName">${ctp:i18n('formsection.config.template.category')}</option>
                                        </c:if>
									</select>
								</div>
							</td>
							<td class="hidden" id="editTr" style="width: 55px">
									<input type="text" name="${ctp:i18n('form.query.label.condition')}" id="data" value="" style="width: 55px" class="validate" validate="type:'string',avoidChar:'&&quot;&lt;&gt;'"/>
							</td>
							<td>
								<div class="left margin_l_5"  id="searchBtn"><EM class="ico16 search_16"></EM></div>
							</td>
						</tr>
					</table>
				</div>
	            <div id="tree"></div>
        </div>
        <%-- 中间部分为一个新的布局 --%>
        <div class="layout_center" style="overflow: hidden;">
            	<div class="color_gray margin_l_20">
	                <c:if test="${formType=='2' }">
	                    <div id=titleDiv class="clearfix margin_t_20 margin_b_10"">
	                        <h2 class="left margin_0">${ctp:i18n('form.base.formtype.message')}</h2>
	                        <div class="font_size12 left margin_l_10">
	                            <div class="margin_t_10 font_size12">${ctp:i18n('form.helpinfo.total')} <span id="count" class="font_bold color_black">${size }</span> ${ctp:i18n('formsection.infocenter.num')}</div>
	                        </div>
	                    </div>
	                    <div id="Layer1" class="line_height160 font_size12">
	                        <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.info.default.page.label')}</p>
	                    </div>
	                </c:if>
	                <c:if test="${formType=='3' }">
	                    <div id=titleDiv class="clearfix margin_t_20 margin_b_10"">
	                        <h2 class="left margin_0">${ctp:i18n('form.base.formtype.basedata')}</h2>
	                        <div class="font_size12 left margin_l_10">
	                            <div class="margin_t_10 font_size12">${ctp:i18n('form.helpinfo.total')} <span id="count" class="font_bold color_black">${size }</span> ${ctp:i18n('formsection.infocenter.num')}</div>
	                        </div>
	                    </div>
	                    <div id="Layer1" class="line_height160 font_size12">
	                        <p><span class="font_size12">●</span> ${ctp:i18n('form.helpinfo.base.default.page.label')}</p>
	                    </div>
	                </c:if>
                </div>
            <iframe id="masterDataListFrame" width="99%" height="100%" frameBorder="no" scrolling="no"></iframe>
        </div>
    </div>
    <script type="text/javascript" src="${path}/common/form/common/unflowForm.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
        var formType = ${formType};
        var templateCategoryId = "${param.templateCategoryId}";
        $(document).ready(function() {
             //manageInfo("2","信息管理"),
             //baseInfo("3","基础数据");
             getQueryParam();
             refleshTree("tree");
             $("#searchBtn").click(function() {
             	searchCategry();
             });
             $("#data").keyup(function(e){
                 if(e.keyCode ==13){
                 	searchCategry();
                 }
             });
             if($.browser.msie && ($.browser.version=="7.0")){
             	$("#layout1").find(".layout_west").css("height","100%");
             }
             $("#layout1").find(".layout_center").css("height","100%");
         });

    </script>
    
</body>
</html>