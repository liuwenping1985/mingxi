<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Set</title>
</head>
<script type="text/javascript">

$(document).ready(function() {
  $("#formFieldsBtn").click(function() {
    $("#org_form_branch_iframe").attr("src","<c:url value='/custom/function.do?method=showFormFileds'/>&appName=${ctp:escapeJavascript(appName)}&formAppId=${formAppId}&fieldType=${ fieldType}&tableType=${tableType}");
    $("#systemVariablesBtn").parent().removeClass("current");
    $("#formFieldsBtn").parent().addClass("current");
  }).keydown(function(e){
      if(e.keyCode=='8'){
          e.preventDefault();
      }
  });
  
  $("#systemVariablesBtn").click(function() {
      $("#org_form_branch_iframe").attr("src","<c:url value='/custom/function.do?method=showSystemVariables'/>&appName=${ctp:escapeJavascript(appName)}&formAppId=${formAppId}&fieldType=${ fieldType}&tableType=${tableType}");
      $("#formFieldsBtn").parent().removeClass("current");
      $("#systemVariablesBtn").parent().addClass("current");
  }).keydown(function(e){
        if(e.keyCode=='8'){
            e.preventDefault();
        }
    });
});

function OK(){
	document.getElementById("org_form_branch_iframe").contentWindow.showFormfieldExpresion();
  var fieldDbName= $("#fieldDbName").attr("value");
  var fieldDisplayName= $("#fieldDisplayName").attr("value");
  if(fieldDbName=="" || fieldDisplayName==""){
	  return null;
  }
  var result= new Object();
  result["fieldDbName"]= fieldDbName;
  result["fieldDisplayName"]= fieldDisplayName;
  return result;
}
</script>
<body class="padding_5">
<form name="branchSetForm" id="branchSetForm" action="#">
<input type="hidden" name="fieldDbName" id="fieldDbName" value="">
<input type="hidden" name="fieldDisplayName" id="fieldDisplayName" value="">
<table width="99%" height="100%" border="0" align="center">
    <tr>
       <td>
            <div class="common_tabs clearfix">
              <ul class="left">
              	  <c:if test="${ showFormVariables!='false' }">
                  <li class="current"><a id="formFieldsBtn" class="border_b last_tab" href="javascript:void(0);" ><span title ="${ctp:i18n('workflow.customFunction.formfield.label')}"><%--单据字段--%>${ctp:i18n('workflow.customFunction.formfield.label')}</span></a></li>
                  </c:if>
                  <c:if test="${showSystemVariables=='true' }">
                  <li><a id="systemVariablesBtn" href="javascript:void(0);" class='border_b last_tab' ><span title ="${ctp:i18n('form.operhigh.systemvar.label')}">${ctp:i18n('form.operhigh.systemvar.label')}</span></a></li> <%--系统变量 --%>
              	  </c:if>
              </ul>
            </div>
       </td>
    </tr>
    <tr>
       <td>
       <c:choose>
       	<c:when test="${ showFormVariables!='false' }">
          <iframe id="org_form_branch_iframe" border="0" src="<c:url value='/custom/function.do?method=showFormFileds'/>&appName=${ appName}&formAppId=${formAppId }&fieldType=${ fieldType}&tableType=${tableType}" frameBorder="no" width="100%" scrolling="no" height="445px"></iframe>
        </c:when>
        <c:when test="${ showSystemVariables=='true' }">
          <iframe id="org_form_branch_iframe" border="0" src="<c:url value='/custom/function.do?method=showSystemVariables'/>&appName=${ appName}&formAppId=${formAppId }&fieldType=${ fieldType}&tableType=${tableType}" frameBorder="no" width="100%" scrolling="no" height="445px"></iframe>
        </c:when>
       </c:choose>
       </td>
    </tr>
</table>
</form>
</body>
</html>