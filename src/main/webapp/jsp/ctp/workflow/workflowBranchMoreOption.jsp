<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${branchDescTitle}</title>
</head>
<script language="javascript">
var dialogParentTransParams= window.dialogArguments;
var conditionDesc= "";
if(dialogParentTransParams.conditionDesc && dialogParentTransParams.conditionDesc!="null"){
  conditionDesc= dialogParentTransParams.conditionDesc;
}
$().ready(function() {
  $("#info").attr("value",conditionDesc);
});
function OK(){
  var vresult= $("#selectPolicyForm").validate();
  if(!vresult){
    return false;
  }else{
    var rArray= new Array();
    rArray.push($("#info").attr("value"));
    return rArray;
  }
}
</script>
<body class="over_hidden">
<form action="" name="selectPolicyForm" id ="selectPolicyForm">
<div class="form_area align_center">
<div class="common_txtbox_wrap">
<textarea ${readonly==true?"readonly":"" } id="info" style="height: 180px;width: 100%"
<%-- 分支描述 --%>
 class="font_size12 validate border_no" validate="isWord:true,maxLength:100,name:&quot;${ctp:i18n('workflow.designer.linemenuitem.moreoption')} &quot;"></textarea>
</div>
</div>
</form>
</body>
</html>