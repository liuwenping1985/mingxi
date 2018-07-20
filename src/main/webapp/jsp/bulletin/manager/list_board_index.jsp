<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title>Insert title here</title>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<script type="text/javascript">
 function changeType(typeId){
 	var _url = '${bulDataURL}?method=listMain&spaceType=${spaceType}&bulTypeId='+typeId+'&type=' + typeId +'&showAudit=${showAudit}&spaceId=${param.spaceId}';
 	detailIframe.location.href = _url;
 }
</script>
<style type="text/css">
.right_div_row2>.center_div_row2 {
 top:0px;
}
</style>
</head>
<body class="padding5" scroll="no">
<div class="main_div_row2">
	<div class="right_div_row2">
		<c:if test="${spaceType != 1 && showAudit == true}">
		<div class="top_div_row2">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
					<!-- 首页管理进来，如果有审核2个页签都显示，如果没审核就只有管理页签不显示 -->
					<tr>
						<td valign="bottom" height="26" class="tab-tag">
							<div class="tab-separator"></div>
							<div class="">
								<div class="tab-tag-left-sel"></div>
								<div class="tab-tag-middel-sel cursor-hand" onclick="javascript:location.reload(true)">
									<fmt:message key="bul.data_shortname" /><fmt:message key="oper.manage" />
								</div>
								<div class="tab-tag-right-sel"></div>
								<div class="tab-separator"></div>
								<div class="tab-tag-left"></div>
								<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='${bulDataURL}?method=auditListMain&spaceType=${spaceType}&bulTypeId=${bulTypeId}&from=${from}&spaceId=${param.spaceId}'">
									<fmt:message key="bul.data_shortname" /><fmt:message key="oper.audit" />
								</div>
								<div class="tab-tag-right"></div>
							</div>
							<div class="tab-separator"></div>
						</td>
						<td align="right" class="tab-tag hidden">
						<fmt:message key="bul.board.switch.label" />: <select onchange="changeType(this.value)">
								<c:forEach items="${typeList}" var="bulType">
									<option value="${bulType.id}" ${v3x:outConditionExpression(bulType.id==param.bulTypeId, 'selected', '')}>${v3x:toHTML(bulType.typeName)}</option>
								</c:forEach>
						</select></td>
					</tr>
			</table>
		</div>
		<style type="text/css">
		.right_div_row2>.center_div_row2 {
		 top:35px;
		}
		</style>
		</c:if>
		<div class="center_div_row2" id="scrollListDiv" style="overflow: hidden;">
			<iframe src="${bulDataURL}?method=listMain&spaceType=${spaceType}&type=${param.bulTypeId}&showAudit=${showAudit}&spaceId=${param.spaceId}" frameborder="0" name="detailIframe" style="width: 100%; height: 100%;" scrolling="no"></iframe>
		</div>
	</div>
</div>
</body>
</html>