<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.properties.edit.scope.title'/></title>
<script>
	function doOk(){
		var commentScope = -1;
		var versionScope = -1;
		var recommendScope = -1;
		if(document.getElementById("radio_fce_self")) {
			var value = document.getElementById("radio_fce_self").checked;
			var valuemore = document.getElementById("radio_fce_more").checked;
		    if (value == true) {
		    	commentScope = 1;
		 	}
		  	else if (valuemore == true) {
		  		commentScope = 2;
	   		} else {
	   			commentScope = 3;
	   		}
		}
		if(document.getElementById("radio_fre_self")) {
			var value = document.getElementById("radio_fre_self").checked;
			var valuemore = document.getElementById("radio_fre_more").checked;
		    if (value == true) {
		    	recommendScope = 1;
		 	}
		  	else if (valuemore == true) {
		  		recommendScope = 2;
	   		} else {
	   			recommendScope = 3;
	   		}
			
		}

		if(document.getElementById("radio_fve_self")) {
			versionScope = document.getElementById("radio_fve_self").checked ? 2 : 3;
		}
   		
		var returnValue = [commentScope, versionScope, recommendScope];
		transParams.parentWin.docPropCollBackFun(returnValue);
	}
</script>
</head>
<body  bgColor="#f6f6f6" scroll="no">
<form name="mainForm" id="mainForm" action="" method="post" target="folderIframe">
	<table class="popupTitleRight" width="100%" height="${param.showComment eq 'true' && param.showRecommend eq 'true' && param.showVersion eq 'true' ? '460' : '220'}" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td  height="20" class="PopupTitle" colspan="2" nowrap="nowrap"><fmt:message key='doc.jsp.properties.edit.scope.title'/></td>
		</tr>
	
	<c:if test="${param.showComment eq 'true'}">
		<%-- 评论属性修改范围影响设置 --%>
		<tr>
			<td colspan="2" height="20">
				<b><fmt:message key='doc.jsp.properties.edit.scope.setcomment'/></b>
			</td>
		</tr>
		<tr>
			<td  colspan="2" height="20">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="radio_fce_self">
					<input type="radio" name="radio_fce" id="radio_fce_self" value="1" checked  >
					<fmt:message key='doc.jsp.properties.edit.scope.self'/>
				</label>
			</td>
		</tr>
		<tr >
			<td   colspan="2" height="20">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="radio_fce_more">
					<input type="radio" name="radio_fce" id="radio_fce_more" value="2"   >
					<fmt:message key='doc.jsp.properties.edit.scope.more'/>
				</label>
			</td>
		</tr>
		<tr >
			<td   colspan="2" height="20">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="radio_fce_all">
					<input type="radio" name="radio_fce" id="radio_fce_all" value="3"   >
					<fmt:message key='doc.jsp.properties.edit.scope.all'/>
				</label>
			</td>
		</tr>
	</c:if>
	<c:if test="${param.showRecommend eq 'true'}">
		<%-- 推荐属性修改范围影响设置 --%>
		<tr>
			<td colspan="2" height="20">
				<b><fmt:message key='doc.jsp.properties.edit.scope.setrecommend'/></b>
			</td>
		</tr>
		<tr>
			<td  colspan="2" height="20">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="radio_fre_slef">
					<input type="radio" name="radio_fre" id="radio_fre_self" value="1" checked  >
					<fmt:message key='doc.jsp.properties.edit.scope.self'/>
				</label>
			</td>
		</tr>
		<tr >
			<td   colspan="2" height="20">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="radio_fre_more">
					<input type="radio" name="radio_fre" id="radio_fre_more" value="2"   >
					<fmt:message key='doc.jsp.properties.edit.scope.more'/>
				</label>
			</td>
		</tr>
		<tr >
			<td   colspan="2" height="20">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="radio_fre_all">
					<input type="radio" name="radio_fre" id="radio_fre_all" value="3"   >
					<fmt:message key='doc.jsp.properties.edit.scope.all'/>
				</label>
			</td>
		</tr>
	</c:if>
	<c:if test="${param.showVersion eq 'true'}">
		<%-- 是否启用版本管理属性修改范围影响设置 --%>
		<tr>
			<td colspan="2" height="20">
				<b><fmt:message key='doc.jsp.properties.edit.scope.setversion' /></b>
			</td>
		</tr>
		<tr>
			<td  colspan="2" height="20">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="radio_fve_self">
					<input type="radio" name="radio_fve" id="radio_fve_self" value="1" checked  >
					<fmt:message key='doc.jsp.properties.editversion.scope.self' />
				</label>
			</td>
		</tr>
		<tr >
			<td   colspan="2" height="20">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label for="radio_fve_all">
					<input type="radio" name="radio_fve" id="radio_fve_all" value="3"   >
					<fmt:message key='doc.jsp.properties.editversion.scope.all'/>
				</label>
			</td>
		</tr>
	</c:if>
	</table>
    <table width="100%" height="20" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="right" class="bg-advance-bottom" colspan="2">
				<input type="button" name="b1" onclick="doOk()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			</td>
		</tr>
    </table>
</form>	
<iframe name="folderIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>