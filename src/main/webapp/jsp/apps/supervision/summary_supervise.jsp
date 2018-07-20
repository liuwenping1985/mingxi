<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <%@ include file="/WEB-INF/jsp/common/common.jsp"%>
    <link rel="stylesheet" href="${path}/apps_res/supervision/css/supervisionSummary.css">
    <link rel="stylesheet" href="${path}/apps_res/supervision/css/dialog.css">
    <title>事项详情</title>
    <script type="text/javascript">
    //督查领导角色
 	var isSupervisionLeader="${isSupervisionLeader}";
 	//督查人员角色
 	var isSupervor="${isSupervor}";
 	var rCode="${param.rCode}";
 	//是否分管领导
 	var cantonalLeaderState="${cantonalLeaderState}";
 	var userId="${CurrentUser.id}";
 	//督办人
 	var supervisionStaff="${supervisionStaff}";
    // 为快捷按钮添加点击事件
    var supType="${param.supType}";
    var moduleId="${moduleId}";

    var moduleType="${moduleType}";
    var rightId="${rightId}";
    var viewState="${viewState}";
    var masterDataId="${masterDataId}";
    var schedule="${schedule}";
    var responsible="${responsible}";
    var formId="${formId}";
    // 各重复表数据条数
    var attentionNum=parseInt("${attentionNum}");
	var commentsNum=parseInt("${commentsNum}");
	var changeNum=parseInt("${changeNum}");
	var feedbackNum=parseInt("${feedbackNum}");
	var evaluateNum=parseInt("${evaluateNum}");
	var hastenNum=parseInt("${hastenNum}");
	//是否是当前事项的督办人
	var isSuperviseUser="${isSuperviseUser}";
	//是否是当前事项的承办人
	var isUndertaker="${isUndertaker}";
	//是否分解事项
	var isBreakSupervise="${isBreakSupervise}";
	//获取分管领导
	var cantonalLeaders = "${cantonalLeaders}";
	//上级事项的ID
	var parentId="${parentId}";
	//完成时限
	var complateTime="${complateTime}";
	//变更模板ID
	var templateId="${templateId}";
</script>
<script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionSummary.js"></script>
<script type="text/javascript" src="${path}/apps_res/supervision/js/dialog.js"></script>
</head>
<body class="xl-body" style="background-color: #F5F5F5;overflow-y:hidden;">

<div class="container" style="height:100%;">
	<!-- 事项状态 -->
	<input type="hidden" name="status" id="status" value="${status}">
	<!-- 关注状态 -->
	<input type="hidden" name="isAttention" id="isAttention" value="${isAttention}">
    <!--第一部分：页面顶端部分-->
    <div class="form-header">
        <!--左边部分-->
        <div class="form-header-left">
            <b></b>
            <span>查看</span>
        </div>
        <!--右边部分
        <div class="form-header-right">
            <a href="#"></a>
        </div>-->
    </div>
    <!--第二部分：表单主体部分-->
    <div class="form-main">
        <!--表单页签头部-->
        <div class="xl_toolbar">
        	<ul class="form-thead">
            <li class="bg_click">
                <a href="javascript:void(0)" id="basicInfo" target="table">
                    <p class="basic_msg"></p>
                    基础信息
                </a>
            </li>
            <li>
                <a href="javascript:void(0)" id="hasten,remind"  target="table">
                    <p class="urge"></p>
                    催办
                </a>
                <span id="hastenNum"></span>
            </li>
            <li>
                <a href="javascript:void(0)" id="attention"  target="table">
                    <p class="concern"></p>
                    关注
                </a><span id="attentionNum" ></span>
            </li>
            <li>
                <a href="javascript:void(0)" id="comments"  target="table">
                    <p class="instructions"></p>
                    批示
                </a><span id="commentsNum" ></span>
            </li>
            <li>
                <a href="javascript:void(0)" id="change"  target="table">
                    <p class="change"></p>
                    变更
                </a><span id="changeNum" ></span>
            </li>
            <li>
                <a href="javascript:void(0)" id="feedback,plan" target="table">
                    <p class="feedback"></p>
                    反馈
                </a><span id="feedbackNum" ></span>
            </li>
            <li>
                <a href="javascript:void(0)" id="selfevaluate,othervaluate" target="table">
                    <p class="evaluate"></p>
                    评价
                </a><span id="evaluateNum"></span>
            </li>
        </ul>
        </div>

        <!--表单内容部分-->
        <iframe onload="initField()" width="100%" src="${path}/content/content.do?method=index&isFullPage=true&moduleId=${moduleId}&moduleType=${moduleType}&rightId=${rightId}&contentType=20&viewState=${viewState}" frameborder="0" name="table" id="frametable" scrolling="">
        </iframe>
        <!--快捷弹出按钮-->
        <div class="quick-menu">
            <p class="add"></p>
            <!--位于上方-->
            <div class="xl-menu">
	            <div class="instructionsDiv">
	                <p class="style_menu instructions_menu"></p>
	                <span>批示</span>
	            </div>
	            <div class="concernDiv" id="concernMenu">
	                <p class="style_menu concern_menu"></p>
	                <span>关注</span>
	            </div>
	            <div class="evaluateDiv">
	                <p class="style_menu evaluate_menu"></p>
	                <span>评价</span>
	            </div>
	            <div class="signDiv">
	                <p class="style_menu sign_menu"></p>
	                <span>签收</span>
	            </div>
	            <div class="planDiv">
	                <p class="style_menu plan_menu"></p>
	                <span>计划</span>
	            </div>
	            <div class="self_evaluateDiv">
	                <p class="style_menu self_evaluate_menu"></p>
	                <span>自评</span>
	            </div>
	            <div class="changeDiv">
	                <p class="style_menu change_menu"></p>
	                <span>变更</span>
	            </div>
	            <div class="feedbackDiv">
	                <p class="style_menu feedback_menu"></p>
	                <span>反馈</span>
	            </div>
	            <div class="writeOffDiv">
                    <p class="style_menu write_off_menu"></p>
                    <span>销账</span>
                </div>
                <div class="urgeDiv">
                    <p class="style_menu urge_menu"></p>
                    <span>催办</span>
                </div>
            </div>
        </div>
        <div class="xl-mask">
		</div>       
    </div>
</div>
<!-- 6-9 发送成功 淡入淡出效果 -->
<div class="xl_success_hidden" style="display:none">
    <img src="${path}/apps_res/supervision/img/msg.png">
    <span>发送成功<span>
</div>
</body>
</html>