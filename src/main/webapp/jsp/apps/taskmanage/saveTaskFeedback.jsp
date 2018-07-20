<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2012-12-19 19:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html id="feedBackHtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n("taskmanage.feedback.oper")}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/saveTaskFeedbackEvent.js${v3x:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/taskmanage/js/saveTaskFeedback.js${v3x:resSuffix()}"></script>
<script type="text/javascript">
    $(document).ready(function() {
        initSubmitUrl();
        initBtnEvent();
        checkPage();
        $("#content").height("75");
        fnGetDialog(118);
        var attmentDivheight = 0;
        $("#attmentDiv").resize(function(e){
            //当只是单独的弹出框时，就不调节高宽了
            if(parent.$("#feadbackList").length<=0){
                return;
              }
        	var htmlHeight = $("#feedBackHtml").height();
        	if(attmentDivheight != $("#attmentDiv").height()&&htmlHeight>120){
            	//-50  fnGetDialog 是因为fnGetDialog方法加了50
        		fnGetDialog(parent.$("#task_feedback_iframe").height() + ($("#attmentDiv").height() - attmentDivheight)-50);
        		attmentDivheight = $("#attmentDiv").height();
        	}else if($("#topEm").hasClass("arrow_2_b")){
        		fnGetDialog(118);
            }
        	
        });
    });
</script>
</head>
<body class="h100b" style="background:transparent;">
    <input type="hidden" id="isEidt" value="${param.isEidt}"/>
    <input type="hidden" id="isDialog" value="${param.isDialog}"/>
    <input type="hidden" id="isPortal" value="${param.isPortal}"/>
    <div class="form_area">
        <form id="task_feedback_form" action="">
		<div id="domain_task_feedback">
			<input type="hidden" id="task_feedback_id" name="task_feedback_id" value=""/>
            <input type="hidden" id="task_id" name="task_id" value="${param.taskId}"/>
            <input type="hidden" id="old_status" name="old_status" value="0"/>
            <input type="hidden" id="style_value" name="style_value" value="0"/>
            <input type="hidden" id="canhandwrite" name="canhandwrite" value="0"/>
			<input type="hidden" id="taskInfoAutoFinishRate" name="taskInfoAutoFinishRate" value="0"/>
			<input type="hidden" id="taskInfoAutoActualTaskTime" name="taskInfoAutoActualTaskTime" value="0"/>
			<div class="hidden"><input id="canwrite" name="canwrite" type="checkbox" onclick="yesido()"></div>
            
	    <table  align="center" class="font_size14 color_gray2" style="margin-top:24px;width:510px" border="0" cellpadding="0" cellspacing="0">
	        <tr>
	            <td width="" class="padding_b_5" ><label style="color:#414141">${ctp:i18n("taskmanage.status")}</label></td>
	            <td colspan="2" class="padding_b_5"><label style="color:#414141">${ctp:i18n("taskmanage.finishrate")}</label><label  id="autofinishrate" class="margin_r_5 margin_l_10 color_gray hidden" for="text"></label></td>
	        </tr>
	        <tr>
	            <td width="220px" id="statusTd" class="padding_r_30 padding_t_5">
	                <div class="common_selectbox_wrap">
	                        <select id="status" name="status" style="height:23px;width:220px;" class="codecfg"
                        	codecfg="codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.StatusEnums'"></select>
	                </div>
	            </td>
	            <td id="finishrateTd" class="padding_t_5" width="220px" nowrap="nowrap">
	                <div class="common_txtbox_wrap">
	                    	<input type="text" id="finishrate_text" name="finishrate_text" value="0" class="validate" style="height:23px;width:210px;"
                        				validate='name:"${ctp:i18n("taskmanage.finishrate")}",isInteger:true, maxValue:100,minValue:0,errorMsg:"${ctp:i18n("taskmanage.finishrate.error")}"'/>
	                </div>
	            </td>
	            <td width="35" id="bfTd" class="padding_l_5">%</td>
	        </tr>
	        <tr>
	            <td colspan="3" class="padding_t_15"><div onclick="fnToggleDialog();" class="w20b">${ctp:i18n("message.header.more.alt")}<em id="topEm" class="ico16 rolling_btn_b padding_b_5 margin_l_5"></em></div></td>
	        </tr>
	        <tr class="extendClass hidden" style="">
	            <td class="padding_b_10 padding_t_10" width="220px" ><label style="color:#414141">${ctp:i18n("taskmanage.risk")}</label></td>
	            <td colspan="2" class="padding_t_10 padding_b_10" ><label style="color:#414141">${ctp:i18n("taskmanage.currentTime")}</label><label  id="autoActualTaskTime"  class="margin_r_5 margin_l_10 color_gray hidden" for="text"></label></td>
	        </tr>
	        <tr class="extendClass hidden">
	            <td class="padding_r_30" id="selectriskTd" width="220px">
	                <div class="common_selectbox_wrap">
	                    	<select id="select_risk" style="height:23px;width:220px;" name="select_risk" class="codecfg"
                        	codecfg="codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.RiskEnums'"></select>
	                </div>
	            </td>
	            <td  id="elapsedTd" width="220px" nowrap="nowrap">
	                <div class="common_txtbox_wrap">
	                    <input type="text" name="elapsed_time_text" id="elapsed_time_text" value="" class="validate" style="height:23px;width:210px;"
        								validate='name:"${ctp:i18n("taskmanage.currentTime")}",func:validateCurrentTime,errorMsg:"${ctp:i18n("taskmanage.currentTime.error")}"'/>
	                </div>
	            </td>
	            <td width="35" id="timeTd" class="padding_l_5" nowrap="nowrap">${ctp:i18n("common.time.hour")}</td>
	        </tr>
	        <tr class="extendClass hidden">
	            <td colspan="3" class="padding_t_15 padding_b_5">${ctp:i18n("taskmanage.explain.label")}</td>
	        </tr>
	        <tr class="extendClass hidden">
	            <td colspan="2">
	                <div class="projectTask_reply" id="projectTask_reply">
	                    <div class="common_txtbox left clearfix">
			    			<textarea style="width:462px;" class="w100b color_gray" id="content" name="content" onfocus="doFeebackDesc(0)">${ctp:i18n("taskmanage.feedback.input.content")}(${ctp:i18n("taskmanage.feeback.range_500")})</textarea>
	                    </div>
	                    <div id="attmentDiv" class="left clearfix w100b font_size12">
	                        <div class="clearfix" id="attachmentTR"></div>
                			<div class="comp clearfix" comp="type:'fileupload',applicationCategory:'30',canDeleteOriginalAtts:true,originalAttsNeedClone:false,canFavourite:false" attsdata='${ attachmentsJSON}'></div>
                			<div class="comp clearfix" comp="type:'assdoc',applicationCategory:'30',canDeleteOriginalAtts:true,attachmentTrId:'position1', modids:'1,3,6'" attsdata='${ attachmentsJSON}'></div>
	                    </div>
	                    <div class="left clearfix w100b">
	                        <div class="padding_lr_10 border_r left" style="height:32px" onclick="insertAttachment();"><em class="ico16 affix_16 margin_t_5"></em></div>
	                        <div class="padding_lr_10 left" style="height:32px" onclick="quoteDocument('position1');"><em class="ico16 associated_document_16 margin_t_5"></em></div>
	                    </div>
	                </div>
	            </td>
	            <td width="35"></td>
	        </tr>
	    </table>
          </div>
        </form>
    </div>
    <div class="align_right margin_t_5 <c:if test='${param.isDialog eq 1 or param.isPortal eq 1}'>display_none</c:if>" id="btn_area" style="margin-right:58px;">
        <c:if test="${isView == true}">
        	<a id="btn_ok" class="common_button common_button_emphasize common_button_big right margin_r_10" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a>
        </c:if>
       <!-- <a id="btn_cancel" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>-->
    </div>
</body>
</html>
