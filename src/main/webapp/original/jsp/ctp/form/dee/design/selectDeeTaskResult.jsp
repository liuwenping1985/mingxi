<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="formHeader.jsp"%>
<%@ include file="/WEB-INF/jsp/common/INC/noCache.jsp"%>
<html>
<head>
<base target="_self">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='form.create.input.setting.deetask.resultdata.select.label'/></title>
<base target="_self"/> 
<script type="text/javascript">
function selectTaskResult(){
	var _parent = window.opener;
	if(_parent == null){
		_parent = window.dialogArguments;
	}
   /*  var deeTaskField = _parent.deeTaskFieldMap;
    deeTaskField.clear(); */
    var refField = formListFrame.document.getElementById("refField").value;
    //var fieldName = "${param.fieldName}";
    var refFieldValue = "";
	var deeFieldStr = "";
    var idCheckBox = formListFrame.document.getElementsByName("id");
    var id_checkbox ;
    
	for(var i=0; i<idCheckBox.length; i++){
		if(idCheckBox[i].checked){
			id_checkbox =  idCheckBox[i] ;
		}
	}
	if(id_checkbox != null){
		result = formListFrame.document.getElementsByName(id_checkbox.value);
		if(result.length>0){
			for(var i = 0; i < result.length; i++){
				/* var field = new Array();
				field.push(result[i].value, result[i].value);
				deeTaskField.put("my:"+result[i].field,field); */
				if($(result[i]).attr("field") == refField){
					refFieldValue = result[i].value;
				}
				deeFieldStr+=result[i].value + "#" + $(result[i]).attr("toRelFormField") + "&";
			}
			deeFieldStr = deeFieldStr.substring(0,deeFieldStr.length-1);
		}
		if(deeFieldStr != ""){
			deeFieldStr = deeFieldStr+"@"+refFieldValue;
			window.returnValue = deeFieldStr;	
		}
	}else{
		window.returnValue = "clear";
	}
	
	sureToSubmit=true;
    window.close();
}
function cancel(){
	/* var _parent = window.opener;
	if(_parent == null){
		_parent = window.dialogArguments;
	}
	_parent.deeTask = false; */
    window.close();
}

//var sureToSubmit = false;
//function unload(){
	//if(!sureToSubmit){
		//window.returnValue='exitRelForm';
	//}
//}
function OK() {
  var idCheckBox = formListFrame.document.getElementsByName("id");
  var id_checkbox =null;
  
  for(var i=0; i<idCheckBox.length; i++){
      if(idCheckBox[i].checked){
          id_checkbox =  idCheckBox[i] ;
          break;
      }
  }
  if(id_checkbox==null){
    return "error";
  }
  var result = formListFrame.document.getElementsByName(id_checkbox.value);
  var result1 = formListFrame.document.getElementsByName(id_checkbox.value+"a");
  var s="";

  if (result.length > 0) {
          for ( var i = 0; i < result.length; i++) {
              s +=result1[i].value + ":" + result[i].value + "\r\n";
          }
      }
  return s;
}
</script>
</head>
<body scroll="no" onkeypress="listenerKeyESC()">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"> <fmt:message key="form.create.input.setting.deetask.resultdata.select.label"/></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="relativeDoc padding-5">
					 <c:if test="${ empty param.isFrom}">
			            <iframe src="${pageContext.request.contextPath}/dee/deeDataDesign.do?method=selectDeeTaskResultList&isSearch=${param.isSearch}&refField=${param.refField}&formId=${param.formId}&contentDataId=${param.contentDataId}&fieldName=${param.fieldName}&selectType=a" name="formListFrame" frameborder="0"  height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
			            </c:if>
					 <c:if test="${not empty param.isFrom}">
					   <iframe src="${pageContext.request.contextPath}/dee/deeDataDesign.do?method=selectDeeDeeDataList&isSearch=${param.isSearch}&eventDee=${param.eventDee}&tableName=${param.tableName}&taskParam=${param.taskParam}&formId=${param.formId}&taskField=${param.taskField}&summaryId=${param.summaryId}&selectType=a" name="formListFrame" frameborder="0"  height="100%" width="100%" scrolling="no" marginheight="0" marginwidth="0"></iframe>
					 </c:if>
					</td>
				</tr>
				 <c:if test="${empty param.isFrom}">			
				<tr>
					<td height="42" align="right" class="bg-advance-bottom">
						<c:if test="${param.isSearch!='search'}">
							<input type="button" onclick="selectTaskResult()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">&nbsp;
							<input type="button" onclick="cancel()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
						</c:if>
						<c:if test="${param.isSearch=='search'}">
							<input type="button" onclick="window.close()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
						</c:if>
					</td>					
				</tr>
				</c:if>
			</table>
		</td>
	</tr>
</table>
</body>	
</html>