<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html class="h100b over_hidden">
<head>
 	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>${template.subject}</title>
	<script type="text/javascript" charset="UTF-8" src="${path}/common/workflow/simulation/js/simulationMain.js${ctp:resSuffix()}"></script>
	<script type="text/javascript">
		var templateId = "${param.templateId}";
		var openNew = "${param.openNew}";
	</script>
	<link rel="stylesheet" href="${path}/common/workflow/simulation/css/simulation.css${ctp:resSuffix()}">
	<style>
       .stadic_layout_body{top:0;width:100%; bottom:0px;  verflow: auto;position: absolute;}
       .stadic_layout_footer{left:0;width:100%;buttom:10px;height:60px;position: absolute;}
</style>
</head>
<body class="h100b">
<!-- 正在执行遮罩样式 -->
<div id="runningBar" class="runningBar display_none" >
    	<div class="runningImg">
    	</div>
    	<div id="6645093_mask" class="runningMask absolute"></div>
</div>
<!--页面头部-->
 <div class="stadic_layout_body stadic_body_top_bottom">
    <div id="header">
        <div class="container">
            <div class="subject text_overflow" style="width : 850px;" title="${template.subject}">${template.subject}</div>
            <div class="workflow">
            	<a href="javascript:void(0);" id="showWorkflow">${ctp:i18n('simulation.page.label.showWorkflow.js')}</a>
            	 <input type="hidden" id="processId" name="processId" value="${template.workflowId}"/>
	             <input type="hidden" id="templateId" name="templateId" value="${template.id}"/>
	             <input type="hidden" id="selectSimulationId" name="selectSimulationId"/>
	             <input type="hidden" id="recentStateVal" name="recentStateVal"/>
	             <input type="hidden" id="templateSubject" name="templateSubject" value="${template.subject}"/>
            </div>
            
        </div>
    </div>
<!--页面主体-->
    <div id="section">
        <!--页面主体下的导航条-->
        <div id="nav">
            <div class="under">
                <img src="${path}/common/workflow/simulation/img/under.png" alt="">
            </div>
            <div class="uper1">
                <a href="#"><img src="${path}/common/workflow/simulation/img/uper1_b.png" alt=""></a>
                <div class="font">${ctp:i18n("simulation.page.label.caseList") }</div>
            </div>
            <div class="uper2">
                <a href="#"><img src="${path}/common/workflow/simulation/img/uper2_g.png" alt=""></a>
                <div class="font">${ctp:i18n("simulation.page.label.caseDetail") }</div>
            </div>
            <div class="uper3">
                <a href="#"><img src="${path}/common/workflow/simulation/img/uper3_g.png" alt=""></a>
                <div class="font">${ctp:i18n("simulation.page.label.reportDetail") }</div>
            </div>
        </div>
        <!--页面主体下的用例列表-->
        <div id="main">
            <!--第一页内容 start-->
            <div class="caseList">
               <iframe id="simulationList" name='simulationList' width="100%" height="410px" frameborder="0" src="${path}/workflow/simulation.do?method=list&templateId=${template.id}" class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
            </div>
            <!--第一页内容 end-->
            <!--第二页内容 start-->
            <div class="caseDetail" style="display:none">
          		<iframe id="simulationDetail" name='simulationDetail' width="100%" height="800px" frameborder="0"  class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
            </div>
            <!--第二页内容 end-->
            <!--第三页内容 start-->
            <div class="reportDetail" style="display:none">
                <iframe id="reportDetail" name='reportDetail' width="100%" height="800px" frameborder="0" src="${path}/workflow/simulation.do?method=reportDetail&templateId=${template.id}" class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
            </div>
            <!--第三页内容 end-->
        </div>
 </div> 
</div>       
         <div class="stadic_layout_footer stadic_footer_height" id="footerBar" style="display:none">
	        <div class="footer_bar" id="simulationDetailButton">
                    <input class="fb_input_size active" type="button" id="test_confirm_button" value="${ctp:i18n('simulation.page.label.run.js')}">
                    <input class="fb_input_size" type="button" id="edit_confirm_button" value="${ctp:i18n('simulation.page.inform.save.js')}">
                    <input class="fb_input_size" type="button" id="edit_cancel_button" value="${ctp:i18n('simulation.page.label.cancel.js')}">
                    <input class="fb_input_size1" type="button" id="edit_copy_button" value="${ctp:i18n('simulation.page.label.copyAndCreat')}">
            </div>
            <div id="reportDetailButton" class="sim_main_container sim_align_center" style="display: none" >
            	<div class="controlBar">
                    <div class="cb_first">
                        <input id="editWorkflowBtn" type="button" class="display_none active" style="width:120px;" value='${ctp:i18n("simulation.page.editWf") }'><!-- 节点查找与替换-->
                       	<input class="active" type="button" id="saveRefer" name="saveRefer" style="display: none"  value='${ctp:i18n("simulation.page.label.saveRefer") }'>
                        <input type="button" id="complate" name="complate" style="display: none"  value='${ctp:i18n("simulation.page.label.complate") }'>
                        
                    </div>
                </div>
            </div>
    </div>
</body>
</html>