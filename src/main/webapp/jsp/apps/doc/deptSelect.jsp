<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="doc.jsp.deptSelect.title" /></title>
<script type="text/javascript">
	var deptIds = new Properties();
	function choose(ele){
		//alert(ele.checked)
		if(ele.checked)
			deptIds.put(ele.value, "");
		else
			deptIds.remove(ele.value);
		//alert(deptIds)
	}
	function save(){
		var ids = "";
		var keys = deptIds.keys();
		//alert(keys)
		for(var i = 0; i < keys.size(); i++){
			ids += "," + keys.get(i);
		}
		if(ids.length > 0)
			ids = ids.substring(1, ids.length);
		//alert(ids)
		transParams.parentWin.sendToDeptDocCollBack(ids,transParams.type);
	}
</script>

</head>
<body bgColor="#f6f6f6" scroll="no" onkeydown="listenerKeyESC()">
<form name="mainForm" id="mainForm" action="" method="post"  target="empty">
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" 
		style="word-break:break-all;word-wrap:break-word">
	<tr>
		<td height="20" class="PopupTitle" nowrap="nowrap"><fmt:message key="doc.jsp.deptSelect.title" />:&nbsp;&nbsp;</td>
	</tr>
	<tr height="15"><td></td></tr>
	<tr><td><div class="doc-label-scrollList">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="word-break:break-all;word-wrap:break-word">
			<c:forEach items="${depts}" var="dept">
				<tr height="25"><td width="10%"></td><td>
					<label for="${dept.id}">
						<input type="checkbox" name="${dept.id}" id="${dept.id}" 
						value="${dept.id}" onclick="choose(this)" >&nbsp;&nbsp;&nbsp;${v3x:toHTML(dept.name)}				
					</label>
				</td></tr>
			</c:forEach>
		</table></div>
	</td></tr>
	<tr height="42">
		<td align="right" class="bg-advance-bottom">
			<input type="button" name="b1" onclick="save()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			<input type="button" name="b2" onclick="getA8Top().selectDeptWin.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>	
	</table>
	
</form>

<iframe name="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"/>

</body>
</html>