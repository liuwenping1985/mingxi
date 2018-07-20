<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.createEdoc.title' /></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
function OK(){
    //验证门户栏目是否为空
	var outerSpaceBusiness = $("#outerSpaceBusiness").val();
	var isPushToOuterSpace1 = $("#isPushToOuterSpace1").attr("checked");
	if(isPushToOuterSpace1=="checked"&&(outerSpaceBusiness=="请选择推送门户栏目"||outerSpaceBusiness=="")){
		alert("推送门户栏目不能为空，请选择推送门户栏目!");
		return;
	}
	if(document.getElementById("title").value!="") {
		if(checkForm(mainForm)){ 
	 		var obj = parent; 
			var parentId = obj.window.docResId;
			var docLibId = obj.window.docLibId;
	//		var docLibType = obj.window.docLibType;
			mainForm.action = "${detailURL}?method=doCreateEdocFolder&parentId=" + parentId + "&docLibId=" + docLibId;
			mainForm.submit();
			return true;
		}
		return false;
	}
	else{
		alert(v3x.getMessage("DocLang.doc_jsp_createf_null_failure_alert"));
		document.getElementById("title").focus();
		return false;
	}
}

function outerSpaceChoose(){
	getA8Top().win123 = getA8Top().$.dialog({
		title:"设置推送门户栏目",
		transParams:{'parentWin':window},
	    url: "outerspace/outerspaceController.do?method=showOuterspaces",
	    width : 370,
	    height  : 280,
	    resizable : "no",
	    buttons : [{
            text : "确定",
            handler : function() {
	    	document.getElementById("outerSpaceBusinessId").value=getA8Top().win123.getReturnValue().value;
	    	if(getA8Top().win123.getReturnValue().name==""){
	    	document.getElementById("outerSpaceBusiness").value="请选择推送门户栏目";
	    	}else{
	    	document.getElementById("outerSpaceBusiness").value=getA8Top().win123.getReturnValue().name;
	    	}
            	getA8Top().win123.close();
            }
          }, {
            text : "取消",//取消
            handler : function() {
            	getA8Top().win123.close();
            }
          } ]
	  });
}

</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()" style="overflow:hidden;background-color: white;">
<form name="mainForm" id="mainForm" action="" method="post"
	onsubmit="return (checkForm(this)&& newCreateEdoc('${detailURL}'))" target="folderIframe">
<input type='hidden' name='parentCommentEnabled' id='parentCommentEnabled' value='${param.parentCommentEnabled}' />
<input type='hidden' name='parentRecommendEnable' id='parentRecommendEnable' value='${param.parentRecommendEnable}' />
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="2">
    <tr>
        <td colspan="2" height="25">
        <div>
            <table align="center" width="95%" border="0" class="ellipsis" cellspacing="0" cellpadding="2"  style="word-break:break-all;word-wrap:break-word">
                <td align="right" nowrap="nowrap" width="23%"><font color="red">*</font>
                <fmt:message key="doc.jsp.createEdoc.name" />:</td>
                <td><input type="text" id="title" name="title" value="" size="52" validate="notNull,isWord" maxSize="80" inputName="<fmt:message key="doc.jsp.createEdoc.name" />" /></td>
            </table>
        </div>
    </tr>
    <tr>
        <td colspan="2" valign="top"><div id="propDiv"></div>
        </td>
    </tr>
    <c:if test="${outerSpace=='1'}">
                        <tr id="isPushToOuterSpace">
	                    <td align="right" width="20%" nowrap="nowrap">允许推送到门户:</td>
	                    <td align="left" width="53%">
	                    	<label for="isPushToOuterSpace1">    
	                            <input type="radio" id="isPushToOuterSpace1" name="isPushToOuterSpace" value="1" 
	                            onclick="if(this.checked) {$('#setPushToOuterSpaceBusiness').show();}" checked />是
	                        </label>
	                        <label for="isPushToOuterSpace0">    
	                            <input type="radio" id="isPushToOuterSpace0" name="isPushToOuterSpace" value="0"
	     							onclick="if(this.checked) {$('#outerSpaceBusinessId').val('');$('#outerSpaceBusiness').val('');$('#setPushToOuterSpaceBusiness').hide();}"/>否
	                        </label>
	                       </td>
                	</tr>
                	    <tr id="setPushToOuterSpaceBusiness">
	                    <td align="right" width="20%" nowrap="nowrap"><span>设置推送门户栏目：</span></td>
	                    <td align="left" width="53%">
	                    <input type="hidden" id="outerSpaceBusinessId" name="outerSpaceBusinessId" value=" "/>
                        <input type="text" class="cursor-hand input-100per" id="outerSpaceBusiness" name="outerSpaceBusiness" readonly="true" 
                        value="请选择推送门户栏目" onclick="outerSpaceChoose()"/>
                        </td>
                	</tr>
                          	</c:if>
            <%-- 
	<c:if test="${v3x:getBrowserFlagByRequest('HideButtons', pageContext.request)}">
	<tr>
		<td height="42" align="right" class="bg-advance-bottom"><input
			type="submit" name="b1"
			value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />"
			class="button-default-2">&nbsp; <input type="button"
			name="b2" onclick="window.close();"
			value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />"
			class="button-default-2"></td>
	</tr>
	</c:if>
	--%>
</table>
<table cellspacing=0 cellpadding=0 align=center>
	<tbody>
		<tr>
			<td height="100"></td>
		</tr>
	</tbody>
</table>
</form>
<script type="text/javascript">
		document.getElementById("propDiv").innerHTML = '${propHtml}';
</script>
<iframe name="folderIframe" frameborder="0"
	height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />
</body>
</html>
