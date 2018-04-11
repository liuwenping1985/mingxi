<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务重定向</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager,bizDataManager"></script>
</head>
<body style="overflow: hidden;padding-left: 5px;">
<!-- 业务数据缓存 -->
<div id="bizData" class="hidden">
    <c:forEach items="${managers}" var="manager" varStatus="status">
        <textarea id="bizData${status.index + 1}" name="bizData${status.index + 1}" moduleType="${manager.id}" hasredirect="false">${fn:escapeXml(convertInfo[manager.id]) }</textarea>
    </c:forEach>
</div>

<!-- 选项卡 -->
<div id="redirectTab" class="step_menu" style="margin-top: 5px;margin-bottom: 5px;">
    <ul id="topUl">
        <c:forEach items="${managers}" var="manager" varStatus="status">
            <li style="cursor: default;" class="${status.first ? 'first_step current' : ''} ${isNewForm?'':'step_complate' } ${status.last ? 'last_step' : ''}" id="bizDataLi${status.index + 1}" step="nextStep" source="/seeyon/${manager.url}">
                    ${status.last ? '' : '<b> </b>'}
                <span>${manager.moduleName }</span>
            </li>
        </c:forEach>
    </ul>
</div>

<!-- 重定向具体页面 -->
<iframe id = "redirectPage"  name= "redirectPage" style="width: 895px;height: 450px"  frameborder="0" ></iframe>

<!-- 工具方法 -->
<script>
var bizDataManager = new bizDataManager();
var currentRedirectNum = 1;
var totalRedirectNum = 1;
$(document).ready(function() {
    totalRedirectNum = $("li", "#topUl").size();
    $("li:last", "#topUl").removeClass("last_step").addClass("last_step");
    $("li:last b", "#topUl").remove();
    changeCurrentPage();
});

//重定向的页签是否加载完成
var inited = false;

function loadingData(){
    inited = false;
    window.parentDialogObj['redirectSingleForm'].startLoading();
    window.parentDialogObj['redirectSingleForm'].disabledBtn("next");
}

function endLoadingData(){
    window.parentDialogObj['redirectSingleForm'].endLoading();
    window.parentDialogObj['redirectSingleForm'].enabledBtn("next");
    inited = true;
}

//保存每个选项卡临时数据
function saveData(bizObj,completeRedirect){
    if (completeRedirect){
        $("#bizData"+currentRedirectNum).attr("hasredirect",true);
    }
    $("#bizData"+currentRedirectNum).val(bizObj);
}
//获取每个选项卡临时数据
function getData(){
	return $("#bizData"+currentRedirectNum).val();
}
function confirmChangePage(direction){
    if(!inited){
        $.alert("${ctp:i18n('form.biz.import.load.data.flag.label')}");
        return;
    }
    var result = redirectPage.window.getResultJSON();
    if (result.completeRedirect){
        changeCurrentPage(direction);
    }
}
function changeCurrentPage(direction){
    loadingData();
    if (direction){
        //获取重定向后的json
        var result = redirectPage.window.getResultJSON();
        //保存json 到当前页面缓存中
        saveData(result.bizObj,result.completeRedirect);
        //如果重定向 json 为空时，不更新后台缓存
        if (result.bizObj){
          bizDataManager.saveFormBeanSet4Cache(currentRedirectNum+"",result.bizObj);
        }
        if (direction == 'last') {
            if (currentRedirectNum > 0){
                    currentRedirectNum --;
            }
        } else {
            if (currentRedirectNum < totalRedirectNum){
                currentRedirectNum ++;
            }
        }
    }
    $("li[id^='bizDataLi']").each(function(){
        $(this).removeClass("current");
    });
    //循环查找下一个需要重定向的页签
    findNotEmptyTab();
    if(currentRedirectNum <= totalRedirectNum){
        $("#bizDataLi"+currentRedirectNum).addClass("current");
        var moduleType = $("#bizData"+currentRedirectNum).attr("moduleType");
        $("#redirectPage").prop("src","${path}/form/business.do?method=" + moduleType);
    }
}

//循环查找需要重定向的页签
function findNotEmptyTab(){
    var redirectData = $("#bizData"+currentRedirectNum);
    if(isEmpty(redirectData) && currentRedirectNum <= totalRedirectNum){
        currentRedirectNum ++;
        redirectData.attr("hasredirect",true);
        findNotEmptyTab();
    }
}

//判断某个页签是否有需要重定向的内容
function isEmpty(obj){
    var data = $(obj).val();
    var currentJson = $.parseJSON(data);
    if(currentJson == undefined || currentJson.length == 0){
        return true;
    }
    return false;
}

/**
 * 判断所有页签是否都已经重定向完毕
 * @returns {boolean}
 */
function allRedirectComplete(){
    var isSuccess = true;
    $("textarea[id^='bizData']").each(function(){
        if ($(this).attr("hasredirect") == 'false'){
          isSuccess = false;
          return false;
        }
    });
    return isSuccess;
}

//点下一步执行的逻辑
function OK(param){
    var obj = {};
    obj.isSuccess = false;
    if (currentRedirectNum <= 1 && param.direction == 'last'){
        return obj;
    }
    // 点击下一步的时候，先保存当前页重定向的内容
    // 并找到下一个需要重定向的页签，如果没有，那么直接完成当前表单的重定向
    if(currentRedirectNum <= totalRedirectNum && param.direction == 'next'){
        confirmChangePage(param.direction);
    }
    if (currentRedirectNum >= totalRedirectNum && param.direction == 'next'){
        if (allRedirectComplete()){
            obj.isSuccess = true;
        }
    }
    return obj;
}
</script>
</body>
</html>