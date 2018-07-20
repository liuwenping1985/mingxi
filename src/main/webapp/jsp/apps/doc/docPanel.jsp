<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="header4DocPanel.jsp"%>
<%@include file="../../common/INC/noCache.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="channel.title" bundle="${v3xMainI18N}"/></title>
<script type="text/javascript">
function selectOne(){
	try{
		var s = document.getElementById("sections");
		if(s.options.length >= 1){
			alert(_("sysMgrLang.choose_one_only"));
			return;
		}
		
		if(treeFrame.root.getSelected()){
			var nodeName = treeFrame.root.getSelected().text;
			var nodeId = treeFrame.root.getSelected().businessId;
			if(nodeId){
				var flag = true;
				for(var i = 0; i < s.options.length; i++){
					if(s.options[i].value == nodeId){
						flag = false;
						break;
					}
				}
				if(flag){
					var o = new Option(nodeName, nodeId);
					s.options.add(o);
					o.title=nodeName;
				}
			}
		}
	}catch(e){}	
}

function removeOne(){
	var s1 = document.getElementById("sections");
	for(var i = 0; i < s1.length; i++) {
		var item = s1.item(i);
		if(item.selected){
			s1.removeChild(s1.options[i]);
			i--;
		}
	}
}

function OK(){
	var s1  = document.getElementById("sections");
	var ids = [];
	var names =[];
	for(var i = 0; i < s1.length; i++) {
		var item = s1.item(i);
		ids[ids.length] = item.value;
		names[names.length] = item.text;
	}
	return [ids, names];
}

window.onload = function (){
	var values = parent.paramValue;
	var s1 = document.getElementById("sections");
	if(s1 && values){
		try{
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "getNameById", false);
			requestCaller.addParameter(1, "Long", values);
			var rv = requestCaller.serviceRequest();
			if(rv != null){
				var t = _("MainLang.${section[1]}") || "${section[1]}";
				var o = new Option(rv, values);
				s1.options.add(o);
			}
		}catch(e){
		}
	}
}
</script>
</head>
<body scroll="no" style="overflow: hidden" onkeydown="listenerKeyESC()">
  <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle" colspan="4"><fmt:message key="channel.select.folder" bundle="${v3xMainI18N}"/></td>
	</tr>
	<tr>
		<td>
			<div class="scrollList">
				<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="2" style="padding-left:6px;"><fmt:message key="channel.optional.label" bundle="${v3xMainI18N}" /></td>
						<td colspan="2" style="padding-left:6px;"><fmt:message key="channel.selected.label" bundle="${v3xMainI18N}" /></td>
					</tr>
					<tr>
						<td style="padding: 6px;" valign="top">
						<table width="100%" height="292px" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="page-list-border-all padding5">
								<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="background: white">
									<tr style="height: 290px;">					
										<td class="padding-T" width="100%" height="100%" valign="top">
										<iframe name="treeFrame" width="100%" height="100%" frameborder="0" src="<html:link renderURL='/doc.do' />?method=docQuoteTree&isrightworkspace=quote&spaceType=${param.spaceType}"></iframe>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						</table>
						</td>
						<td width="8%" align="center"  valign="middle">
							<p><img src="<c:url value="/common/SelectPeople/images/arrow_a.gif"/>" width="24" height="24" class="cursor-hand" onClick="selectOne()"></p>
							<p><img src="<c:url value="/common/SelectPeople/images/arrow_del.gif"/>" width="24" height="24" class="cursor-hand" onClick="removeOne()"></p>
						</td>
						<td width="40%" style="padding: 6px;" valign="top">
							<table width="100%" height="290px" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="padding5">
									<select id="sections" multiple="multiple" class="input-100per padding-T" ondblclick="removeOne()"  style="height: 100%;"></select>
								</td>
							</tr>
							</table>
						</td>
						<td width="10%" align="center" valign="middle">
							<p><img src="<c:url value="/common/SelectPeople/images/arrow_u.gif"/>" width="24" height="24" class="cursor-hand" onClick="exchangeList3Item('up')"></p>
							<p><img src="<c:url value="/common/SelectPeople/images/arrow_d.gif"/>" width="24" height="24" class="cursor-hand" onClick="exchangeList3Item('down')"></p>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
</body>
</html>