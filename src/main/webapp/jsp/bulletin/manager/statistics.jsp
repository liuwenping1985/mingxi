<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ page import="com.seeyon.v3x.bulletin.util.*" %>
<html>
<head>
<title>
	<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}' />
</title>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
	
<script type="text/javascript">
	function listenerKeyPress(){
		if(event.keyCode == 27){
			window.close();
		}
	}
	function changeType(type){
	    document.getElementById('type').value=type;
	    document.getElementById('typeForm').submit();	
	}
	
	detailBaseUrl='${bulDataURL}?method=detail&listIframe=listiframe';
	
	window.onload = function(){
		var conditionObj = document.getElementById("condition");
		var oc = '${param.type}';
		if('byWrite' != oc && 'byPublishDate' != oc && 'byState' != oc && 'byRead' != oc){
			changeType('byRead');
		}else{
			selectUtil(conditionObj, oc);
		}
			
	}
/**
 * 根据后端的值，将下拉按钮对应的项置于选中状态
 */
function selectUtil(selectObj, selectedValue) {
    if (!selectObj) {
        return false;
    }

    var ops = selectObj.options;

    for (var i = ops.length - 1; i >= 0; i--) {
        if (ops[i].value == selectedValue) {
            selectObj.selectedIndex = i;
        }
    }

}
</script>
<style type="text/css">
.border_lr{
  border-left: 1px solid #b6b6b6;
  border-right: 1px solid #b6b6b6;
}
</style>
</head>
<body onkeydown="listenerKeyPress()" class=" border_lr">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="popupTitleRight">
<tr><td height="42" class="PopupTitle" valign="middle" align="left">
<div style="display:none">
	<form action="${bulDataURL}" id="typeForm" method="post" target="detailIframe">
		<input type="hidden" id="method" name="method" value="statistics" />
		<input type="hidden" id="type" name="type" value="${param.type}" />
		<input type="hidden" id="listIframe" name="listIframe" value="listIframe" />
		<input type="hidden" id="bulTypeId" name="bulTypeId" value="${param.bulTypeId}" />
		<input type="hidden" id="spaceId" name="spaceId" value="${param.spaceId}" />
	</form>
</div>
&nbsp;&nbsp;&nbsp;<fmt:message key="bul.data_shortname"/><fmt:message key="bul.statistics.label"/>:
<select name="condition" id="condition" onChange="changeType(this.value)" class="condition">
	<option value="<%=com.seeyon.v3x.bulletin.util.Constants.Statistic_By_Read_Count%>"><fmt:message key="label.stat.byRead" /></option>
	<option value="<%=com.seeyon.v3x.bulletin.util.Constants.Statistic_By_Publish_User%>"><fmt:message key="label.stat.byWrite" /></option>
	<option value="<%=com.seeyon.v3x.bulletin.util.Constants.Statistic_By_Publish_Month%>"><fmt:message key="label.stat.byPublishDate" /></option>
	<option value="<%=com.seeyon.v3x.bulletin.util.Constants.Statistic_By_Status%>"><fmt:message key="label.stat.byState" /></option>
</select>
</td></tr>
<tr height="1"><td class="separatorDIV" height="1"></td></tr>
<tr><td>
<iframe src="${bulDataURL}?method=statistics&type=${param.type}&bulTypeId=${param.bulTypeId}&listIframe=listIframe&spaceId=${param.spaceId}" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px" frameborder="0" scrolling="no"></iframe>		
</td></tr>
</table>
</body>
</html>