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
<textarea id="bizData1" name="bizData1" hasredirect="false">${fn:escapeXml(convertInfo['baseset']) }</textarea>
<textarea id="bizData2" name="bizData2" hasredirect="false">${fn:escapeXml(convertInfo['authset']) }</textarea>
<textarea id="bizData3" name="bizData3" hasredirect="false">${fn:escapeXml(convertInfo['queryset']) }</textarea>
<textarea id="bizData4" name="bizData4" hasredirect="false">${fn:escapeXml(convertInfo['reportset']) }</textarea>
<textarea id="bizData5" name="bizData5" hasredirect="false">${fn:escapeXml(convertInfo['bindset']) }</textarea>
<textarea id="bizData6" name="bizData6" hasredirect="false">${fn:escapeXml(convertInfo['triageset']) }</textarea>
<c:if test="${enu.Enums$FormType.manageInfo == formBean.formType }">
<textarea id="bizData7" name="bizData7" hasredirect="false">${fn:escapeXml(convertInfo['linkageset']) }</textarea>
</c:if>
</div>

<!-- 选项卡 -->
<div id="redirectTab" class="step_menu" style="margin-top: 5px;margin-bottom: 5px;">
<ul id="topUl">
    <!-- 基础设置 -->
    <li style="cursor: pointer;" id="bizDataLi1" class="first_step current" step="nextStep" source="../form/fieldDesign.do?method=baseInfo"><b> </b> <span>${ctp:i18n('form.pagesign.baseinfo.label') }</span></li>
    <c:if test="${enu.Enums$FormType.planForm != formBean.formType }">
    <!-- 操作设置 -->
    <li style="cursor: pointer;" class="" id="bizDataLi2" step="nextStep" source="../form/authDesign.do?method=formDesignAuth"><b> </b> <span>${ctp:i18n('form.pagesign.operconfig.label') }</span></li>
    </c:if>
    <!-- 查询设置 -->
    <li style="cursor: pointer;" class="" id="bizDataLi3" step="nextStep" source="../form/queryDesign.do?method=queryIndex"><b> </b> <span>${ctp:i18n('form.pagesign.queryconfig.label') }</span></li>
    <!-- 统计设置 -->
    <li style="cursor: pointer;" class="" id="bizDataLi4" step="nextStep" source="../report/reportDesign.do?method=index"><b> </b> <span>${ctp:i18n('form.pagesign.statconfig.label') }</span></li>
    <!-- 应用绑定 -->
    <li style="cursor: pointer;" class="" id="bizDataLi5" step="nextStep"  source="../form/bindDesign.do?method=index"><b> </b> <span>${ctp:i18n('form.pagesign.appbind.label') }</span></li>
    <c:if test="${enu.Enums$FormType.planForm != formBean.formType }">
    <!-- 触发设置 -->
    <li style="cursor: pointer;" class="" id="bizDataLi6" step="nextStep" source="../form/triggerDesign.do?method=index"><b> </b> <span>${ctp:i18n('form.pagesign.trigger.label') }</span></li>
    </c:if>
    <c:if test="${enu.Enums$FormType.manageInfo == formBean.formType }">
    <!-- 表单联动 -->
    <li style="cursor: pointer;" class="" id="bizDataLi7" step="nextStep" source="../form/triggerDesign.do?method=linkage"><b> </b> <span>${ctp:i18n('form.pagesign.linkage.label') }</span></li>
    </c:if>
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

function loadingData(){
    window.parentDialogObj['redirectSigleForm'].startLoading();
    window.parentDialogObj['redirectSigleForm'].disabledBtn("next");
}

function endLoadingData(){
    window.parentDialogObj['redirectSigleForm'].endLoading();
    window.parentDialogObj['redirectSigleForm'].enabledBtn("next");
}

//保存每个选项卡临时数据
function saveData(bizObj,complateRedirect){
  if (complateRedirect){
    $("#bizData"+currentRedirectNum).attr("hasredirect",true);
  }
  $("#bizData"+currentRedirectNum).val(bizObj);
}
//获取每个选项卡临时数据
function getData(){
	return $("#bizData"+currentRedirectNum).val();
}
function confirmChangePage(direction){
  var result = redirectPage.window.getResultJSON();
  if (result.complateRedirect){
    changeCurrentPage(direction);
  } else {
    //$.confirm({msg:"当前设置页面存在为完成的重定向，是否继续切换到下一页面？",ok_fn:function(){changeCurrentPage(direction);}});
  }
}
function changeCurrentPage(direction){
    loadingData();
  if (direction){
      //获取重定向后的json
      var result = redirectPage.window.getResultJSON();
      //保存json 到当前页面缓存中
      saveData(result.bizObj,result.complateRedirect);
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
  $("#bizDataLi"+currentRedirectNum).addClass("current");
  $("#redirectPage").prop("src","${path}/form/business.do?method=redirect" + (currentRedirectNum));
}

function allRedirectComplate(){
  var isSuccess = true;
  $("textarea[id^='bizData']").each(function(){
    if ($(this).attr("hasredirect") == 'false'){
      isSuccess = false;
      return false;
    }
  });
  return isSuccess;
}

function OK(param){
  var obj = {};
  obj.isSuccess = false;
  if (currentRedirectNum <= 1 && param.direction == 'last'){
    return obj;
  }
  if (currentRedirectNum >= totalRedirectNum && param.direction == 'next'){
    confirmChangePage(param.direction);
    if (allRedirectComplate()){
      obj.isSuccess = true;
    }
    return obj;
  }
    //saveData(currentRedirectNum,true);
    confirmChangePage(param.direction);
  return obj;
}
</script>
</body>
</html>