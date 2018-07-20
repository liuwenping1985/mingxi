<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.createf.title' /></title>
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
	    var oTitle=document.getElementById("title");
	    oTitle.value = oTitle.value.trim();
	    
		if(checkForm(mainForm)){
			var parentId = parent.window.docResId;
			var docLibId = parent.window.docLibId;
			var docLibType = parent.window.docLibType;
			mainForm.action = "${detailURL}?method=createFolder&parentId=" + parentId + "&docLibId=" + docLibId + "&docLibType=" + docLibType ;
			mainForm.submit();
			return true;
		}
		return false;
	}

	function onEnterPress(){
		if(v3x.getEvent().keyCode == 13){
			OK();
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
	window.onload = function() {
		document.getElementById('title').focus();
	};
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<form name="mainForm" id="mainForm" action="" method="post" onsubmit="return false" target="folderIframe" onkeydown="onEnterPress()">
<input type='hidden' name='parentVersionEnabled' id='parentVersionEnabled' value="${v3x:toHTML(param.parentVersionEnabled)}" />
<input type='hidden' name='parentCommentEnabled' id='parentCommentEnabled' value="${v3x:toHTML(param.parentCommentEnabled)}" />
<input type='hidden' name='parentRecommendEnable' id='parentRecommendEnable' value="${v3x:toHTML(param.parentRecommendEnable)}" />
<table width="93%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="right" width="20%" nowrap="nowrap"><font color="red">*</font><fmt:message key="doc.jsp.createf.name" />：</td>
		<td align="left" width="53%"><input type="text" name="title" id="title" value="" style="width:100%" validate="notNull,isWord,notSpecChar" maxSize="80" inputName="<fmt:message key="doc.jsp.createf.name" />" />
        </td>
	</tr>
	<c:if test="${outerSpace=='1'&& own!=true}">
                        <tr id="isPushToOuterSpace">
	                    <td align="right" width="20%" nowrap="nowrap">允许推送到门户:</td>
	                    <td align="left" width="53%">
	                    	<label for="isPushToOuterSpace1">    
	                            <input type="radio" id="isPushToOuterSpace1" name="isPushToOuterSpace" value="1" checked = "checked"
	                            onclick="if(this.checked) {$('#setPushToOuterSpaceBusiness').show();}" />是
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
</table>
</form>
<iframe name="folderIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />
</body>
</html>
