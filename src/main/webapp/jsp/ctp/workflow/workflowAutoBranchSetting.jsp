<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path}/common/workflow/workflowDesigner_ajax.js${ctp:resSuffix()}"></script>
<title>自动分支条件设置</title>
</head>
<script type="text/javascript">
var wfAjax= new WFAjax();
var validateResult = true;
var UUID_seqence = 0;
var isNew = "${ctp:escapeJavascript(isNew)}";
var dialogParentTransParams= window.dialogArguments;
var conditionId= "";
var formCondition= "";
var conditionTitle= "";
var conditionType= "";
var isForce= "";
var conditionBase= "currentNode";
var conditionDesc= "";

if(dialogParentTransParams.conditionId && dialogParentTransParams.conditionId!="null"){
  conditionId= dialogParentTransParams.conditionId;
}
if(dialogParentTransParams.formCondition && dialogParentTransParams.formCondition!="null"){
  formCondition= dialogParentTransParams.formCondition;
}
if(dialogParentTransParams.conditionTitle && dialogParentTransParams.conditionTitle!="null"){
  conditionTitle= dialogParentTransParams.conditionTitle;
}
if(dialogParentTransParams.conditionType && dialogParentTransParams.conditionType!="null"){
  conditionType= dialogParentTransParams.conditionType;
}
if(dialogParentTransParams.isForce && dialogParentTransParams.isForce!="null"){
  isForce= dialogParentTransParams.isForce;
}
if(dialogParentTransParams.conditionBase && dialogParentTransParams.conditionBase!="null"){
  conditionBase= dialogParentTransParams.conditionBase;
}
if(dialogParentTransParams.conditionDesc && dialogParentTransParams.conditionDesc!="null"){
  conditionDesc= dialogParentTransParams.conditionDesc;
}
/**
 * 产生UUID，返回类型是String
 */
function getUUID(){
    var UUIDConstants_Time = new Date().getTime() + "" + (UUID_seqence++);
    if(UUID_seqence >= 100000){
        UUID_seqence = 0;
    }    
    return UUIDConstants_Time;
}

$().ready(function() {
  /*if($.browser.msie){
    $("#creatcode").attr("rows","12");
  }*/
  if(formCondition.search(/field\d+/)>-1){
    var result = wfAjax.conditionToFieldDisplay("${formApp}",formCondition);
    if(result!=null && result.success){
        $("#creatcode").attr("value",result.result);
    }else{
        $("#creatcode").attr("value",formCondition);
    }
  }else{
    $("#creatcode").attr("value",formCondition);
  }
  if(isForce=="1"){
    $("#isForce").attr("checked","checked");
  }else{
    $("#isForce").removeAttr("checked");
  }
  if(formCondition=="" || $.trim(formCondition)==""){
    $("#isForce").prop("checked", true);
  }
  $("#conditionBase").attr("value",conditionBase);
  $("#orgBranchBtn").click(function() {
  	$("#branchArea").prop("height",265);
    $("#editMode").click();
    $("#org_form_branch_iframe").attr("src","<c:url value='/workflow/designer.do?method=showWorkflowOrgBranchSettingPage'/>&appName=${ctp:escapeJavascript(appName)}&conditionBase="+conditionBase);
    var domObj = $("#formBranchBtn");
    if(domObj!=null && domObj.size()>0){
    	domObj.parent().removeClass("current");
    }
    domObj = $("#edocBranchBtn");
    if(domObj!=null && domObj.size()>0){
    	domObj.parent().removeClass("current");
    }
    domObj = $("#officeBranchBtn");
    if(domObj!=null && domObj.size()>0){
    	domObj.parent().removeClass("current");
    }
    domObj = null;
    $("#orgBranchBtn").parent().addClass("current");
  });
  <c:choose>
    <c:when test="${appName=='form' }">
    $("#formBranchBtn").click(function() {
      $("#branchArea").prop("height",380);
      $("#editMode").click();
      $("#org_form_branch_iframe").attr("src","<c:url value='/workflow/designer.do?method=showWorkflowFormBranchSettingPage'/>&appName=${ctp:escapeJavascript(appName)}&formApp=${formApp}");
      $("#orgBranchBtn").parent().removeClass("current");
      $("#formBranchBtn").parent().addClass("current");
    }).keydown(function(e){
        if(e.keyCode=='8'){
            e.preventDefault();
        }
      });
    </c:when>
    <c:when test="${appName=='edoc' || appName=='edocSend' || appName=='recEdoc' || appName=='signReport' || appName=='sendEdoc'}">
      $("#edocBranchBtn").click(function() {
      	$("#branchArea").prop("height",265);
        $("#editMode").click();
        $("#org_form_branch_iframe").attr("src","<c:url value='/workflow/designer.do?method=showWorkflowEdocBranchSettingPage'/>&wendanId=${wendanId}&appName=${ctp:escapeJavascript(appName)}");
        $("#orgBranchBtn").parent().removeClass("current");
        $("#edocBranchBtn").parent().addClass("current");
      }).keydown(function(e){
        if(e.keyCode=='8'){
            e.preventDefault();
        }
      });
    </c:when>
    <c:otherwise>
       <c:if test="${isShowBranchTab==true}">
         $("#officeBranchBtn").click(function() {
      	   $("#branchArea").prop("height",265);
           $("#editMode").click();
           $("#org_form_branch_iframe").attr("src","<c:url value='${branchTabUrl}'/>");
           $("#orgBranchBtn").parent().removeClass("current");
           $("#officeBranchBtn").parent().addClass("current");
         }).keydown(function(e){
           if(e.keyCode=='8'){
             e.preventDefault();
           }
         });
       </c:if>
    </c:otherwise>
  </c:choose>
  $("#btnreset").click(function(){
    resetFunction();
  });
  $("#openCloseTranslateResult").click(function(){
    var obj = $("#creatcodeReadOnlyTR");
    var display = obj.css("display");
    if(display=="none"){
        obj.css("display", "");
        //$("#creatcode").prop("rows",5);
        translateBranchInfo();
    }else{
        //$("#creatcode").prop("rows",10);
        obj.css("display", "none");
    }
  });
  translateBranchInfo();
});
function resetFunction(){
    $("#creatcode").attr("value","");
    $("#creatcodeReadOnlyArea").val("");
    $("#conditionBase").attr("value","currentNode");
    conditionBase= "currentNode";
    $("#isForce").attr("checked","checked");
    $("#org_form_branch_iframe").contents().find("#conditionBase1").attr("checked","checked").prop("checked", true).end()
    .find("#conditionBase2").removeAttr("checked").prop("checked", false);
    translateBranchInfo();
}
/**
 * 同步转换分支条件
 */
function translateBranchInfo(){ 
  var result= wfAjax.branchTranslateBranchExpression("${ctp:escapeJavascript(appName)}","${formApp}",$("#creatcode").attr("value").replace(/[\r\n]+/g,''));
  if(result!=null){
    $("#creatcodeReadOnlyArea").html(result[1]);
    if(result[0]=='true'){//转换成功
        $("#creatcodeReadOnlyArea").removeClass("border_red");
        validateResult = true;
    }else{
        validateResult = false;
        $("#creatcodeReadOnlyArea").addClass("border_red");
        $("#creatcodeReadOnlyTR").css("display","");
        //$("#creatcode").prop("rows",5);
    }
  }
}

function OK(jsonArgs){
  if(jsonArgs.reset){
    resetFunction();
    return;
  }
  translateBranchInfo();
  var innerButtonId= jsonArgs.innerButtonId;
  if(innerButtonId=='ok'){
    var creatcodeValue= $("#creatcode").val().replace(/[\r\n]+/g,'');
    if(creatcodeValue==""){
      $.alert("${ctp:i18n('workflow.branch.condition.mustset')}");
      return false;
    }else if(creatcodeValue.length>8000){
      $.alert("${ctp:i18n('workflow.condition.lengthError')}"+creatcodeValue.length+"！");
      return false;
    }else{
      var id = "";
      if(isNew=="1"){
          id = "" + getUUID();
      }else{
          id = "" + conditionId;
      }
      var tempCondition = creatcodeValue;
      if(tempCondition.search(/{[^{}]+}/)>-1){
          var result = wfAjax.conditionToFieldName("${formApp}",tempCondition);
          if(result!=null && result.success){
              tempCondition = result.result;
          }
      }
      var arr = new Array();
      arr[0] = id;//conditionId
      arr[1] = tempCondition;//分支表达式formCondition
      arr[2] = $("#creatcodeReadOnlyArea").text();//分支表达式标题conditionTitle
      arr[3] = $("#conditionBase").attr("value");//从子页面获得conditionBase
      arr[4] = $("#isForce")[0].checked?"1":"";//isForce
      arr[5] = validateResult;
      //alert(arr);
      return $.toJSON(arr);
    }
  }
}
var tempLightFlag = null;
function lightSelectFunction(obj,start,end){
	if(tempLightFlag!=null){
		window.clearTimeout(tempLightFlag);
	}
	$(obj).css({
		background:"yellow",
		cursor:"hand"
	});
	tempLightFlag = window.setTimeout(function(){
		selectTextAreaValue($("#creatcode")[0],start,end);
		tempLightFlag = null;
	},2000);
}
function notLightSelectFunction(obj,start,end){
	$(obj).css({
		background:"white",
		cursor:"block"
	});
	if(tempLightFlag!=null){
		window.clearTimeout(tempLightFlag);
		tempLightFlag = null;
		return;
	}
	setTextAreaPosition($("#creatcode")[0],end);
}
<%@ include file="/WEB-INF/jsp/ctp/workflow/operateTextAreaApi.jsp"%>
</script>
<body class="padding_5">
<form name="branchSetForm" id="branchSetForm" action="#">
<input type="hidden" name="conditionBase" id="conditionBase" value="currentNode">
<table width="100%" height="100%" border="0" align="center">
    <tr>
        <td colspan="2">
            <textarea class="common_txtbox w100b margin_b_5 font_size12" id="creatcode" name="creatcode" cols="65" rows="10"
                onkeyup="translateBranchInfo();" 
                onfocus="translateBranchInfo();"></textarea>
        </td colspan="2">
    </tr>
    <tr>
        <td colspan="2" class="align_right">
            <a id="openCloseTranslateResult" class="" href="javascript:void(0);">
                <span class="font_size12 color_blue align_right">${ctp:i18n('workflow.condition.openclose.label')}</span>
            </a>
        </td>
    </tr>
    <tr id="creatcodeReadOnlyTR" style="display:none;">
        <td colspan="2">
        <div id="creatcodeReadOnlyArea" style="border:1px solid #CCC;height:100px;width:530px;word-wrap:break-word;font-size:12px;overflow:auto;" >
        </td>
    </tr>
    <tr>
       <td>
            <div class="common_tabs clearfix">
              <ul class="left">
                  <li class="current"><a id="orgBranchBtn" class="border_b last_tab" href="javascript:void(0);"><span>${ctp:i18n('workflow.condition.auto.label')}</span></a></li>
                  <c:choose>
                    <c:when test="${appName=='form' }">
                        <li><a id="formBranchBtn" href="javascript:void(0);" class='border_b last_tab'><span>${ctp:i18n('workflow.condition.form.label')}</span></a></li>
                    </c:when>
                    <c:when test="${appName=='edoc' || appName=='edocSend' || appName=='recEdoc' || appName=='signReport' || appName=='sendEdoc'}">
                        <li><a id="edocBranchBtn" href="javascript:void(0);" class='border_b last_tab'><span>${ctp:i18n('workflow.condition.edoc.label')}</span></a></li>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${isShowBranchTab==true }">
                            <li><a id="officeBranchBtn" href="javascript:void(0);" class='border_b last_tab' style="max-width: none;"><span>${branchTabName}</span></a></li>
                        </c:if>
                    </c:otherwise>
                  </c:choose>
              </ul>
            </div>
       </td>
        <td>
          <div class="common_checkbox_box clearfix align_right common_tabs">
            <label class="margin_r_10 hand" for="radio18">
            <input id="isForce" class="radio_com" name="isForce" value="0" type="checkbox">${ctp:i18n('workflow.branch.isforce.label')}
            </label>
          </div>
        </td>
    </tr>
    <tr>
       <td id="branchArea" height="265" colspan="2">
          <iframe id="org_form_branch_iframe" border="0" src="<c:url value='/workflow/designer.do?method=showWorkflowOrgBranchSettingPage'/>&conditionBase=${ctp:toHTML(conditionBase)}&appName=${ctp:toHTML(appName)}" frameBorder="no" width="100%" scrolling="no" height="100%"></iframe>
       </td>
    </tr>
</table>
</form>
</body>
</html>