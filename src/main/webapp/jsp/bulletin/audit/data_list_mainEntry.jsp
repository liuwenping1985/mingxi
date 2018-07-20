<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
 function changeTypeAudit(typeId){
 	var _url = '${bulDataURL}?method=listMain&spaceId=${v3x:escapeJavascript(param.spaceId)}&type=' + typeId;
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
		<c:if test="${noManagerLabel == false}"> <!-- 说明没有管理板块的权限，只有审核权限 -->
		<div class="top_div_row2">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="bottom" height="26" class="tab-tag">
						<div class="tab-separator"></div>
						<div class="">
							<c:choose>
								<c:when test="${bulTypeId !=null }">
									<div class="tab-tag-left"></div>
									<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='${bulDataURL}?method=listBoardIndex&spaceType=${v3x:toHTML(param.spaceType)}&bulTypeId=${bulTypeId}&from=${from}&spaceId=${v3x:toHTML(param.spaceId)}'"><fmt:message key="bul.data_shortname" /><fmt:message key="oper.manage" /></div>
									<div class="tab-tag-right"></div>	
									<div class="tab-separator"></div>
								</c:when>
								<c:otherwise>
									<div class="tab-tag-left"></div>
									<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='${bulDataURL}?method=listBoard&spaceType=${v3x:toHTML(param.spaceType)}&bulTypeId=${bulTypeId}&from=${from}&spaceId=${v3x:toHTML(param.spaceId)}'"><fmt:message key="bul.data_shortname" /><fmt:message key="oper.manage" /></div>
									<div class="tab-tag-right"></div>	
									<div class="tab-separator"></div>
								</c:otherwise>
							</c:choose>
							<div class="tab-tag-left-sel"></div>
							<div class="tab-tag-middel-sel cursor-hand" onclick="javascript:location.reload(true);">
								<fmt:message key="bul.data_shortname" /><fmt:message key="oper.audit" />
							</div>
							<div class="tab-tag-right-sel"></div>
						</div>
						<div class="tab-separator"></div>
					</td>
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
			<iframe src="${bulDataURL}?method=entry&spaceType=${v3x:toHTML(param.spaceType)}&from=${from}&showAudit=${noManagerLabel}&spaceId=${v3x:toHTML(param.spaceId)}&bulTypeId=${bulTypeId}" frameborder="0" id="detailIframe" name="detailIframe" style="width: 100%; height: 100%;" scrolling="no"></iframe>
		</div>
	</div>
</div>
</body>
</html>

