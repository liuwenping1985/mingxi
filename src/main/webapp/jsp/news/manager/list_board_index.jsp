<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
	<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}"/>
<script type="text/javascript">
<!--
 function changeType(typeId){
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager",
		 "isManagerOfType", false);
	requestCaller.addParameter(1, "long", typeId);
	requestCaller.addParameter(2, "long", '${current_user_id}');
			
	var flag = requestCaller.serviceRequest();
	
	if('false' == flag){
		alert(v3x.getMessage("bulletin.type_manager_stop_alert"));
		window.location.reload(true);
	}
 
 	var _url = '${newsDataURL}?method=listMain&newsTypeId='+typeId+'&spaceType=${spaceType}&type=' + typeId + '&showAudit=${showAudit}&spaceId=${param.spaceId}';
 	detailIframe.location.href = _url;
 }
//-->
</script>
</head>
<body class="padding5" scroll="no">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<c:if test="${showAudit == true}">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div class="div-float">
					<div class="tab-separator"></div>
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel cursor-hand" onclick="javascript:location.href='${newsDataURL}?method=listBoardIndex&spaceType=${v3x:toHTML(param.spaceType)}&newsTypeId=${param.newsTypeId}&from=${from}&spaceId=${param.spaceId}'"><fmt:message key="news.title" /><fmt:message key="oper.manage" /></div>
					<div class="tab-tag-right-sel"></div>
							
					<div class="tab-separator"></div>
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='${newsDataURL}?method=auditListMain&type=${param.newsTypeId}&spaceType=${spaceType}&from=${from}&spaceId=${param.spaceId}'">
					<fmt:message key="news.title" /><fmt:message key="oper.audit" />
					<%-- (${pending} <fmt:message key="bul.label.items" bundle="${bulI18N}"/>) --%>
					</div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
			</div>
		</td>
		<td align="right" class="tab-tag hidden">
		<fmt:message key="news.board.switch.label" />:
			<select onchange="changeType(this.value)">
				<c:forEach items="${typeList}" var="bulType">
					<option value="${bulType.id}"
					${v3x:outConditionExpression(bulType.id==param.newsTypeId, 'selected', '')}
					>${bulType.typeName}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	</c:if>
	<tr>
		<td colspan="2">
		<div style="height: 100%;">
			<iframe id="detailIframe" src="${newsDataURL}?method=listMain&type=${param.newsTypeId}&spaceType=${spaceType}&showAudit=${showAudit }&custom=${custom}&spaceId=${param.spaceId}" frameborder="0" name="detailIframe" style="width:100%;height: 100%;" scrolling="no"></iframe>
		</div>
		</td>
	</tr>
</table>
</body>
</html>