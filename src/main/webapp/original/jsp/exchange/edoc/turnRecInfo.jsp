<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="../exchangeHeader.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${path}/skin/default/skin.css" />

</head>
<script>
function closeDialog(){
	//top.window.edocDetailIframe.detailMainFrame.turnRecInfoDialog.close();
	p_getCtpTop().turnRecInfoDialog.close();
}
</script>
<body>

<form id="detailForm" name="detailForm" action="exchangeEdoc.do?method=turnRecExcute" method="post">
<table width="400" style="margin-left:6px;" cellspacing="0" cellpadding="0">
	<c:if test="${hasSupOpinion == 'true' }">
	<tr>
		<td height="30" class="td_bottom bg_color"><strong>&nbsp;<fmt:message key="edoc.turnrec.sup.account.opinion"  bundle="${edocI18N }"/></strong></td>
	</tr>
	<tr>
		<td>
		<div style='border:0px;padding:3px;padding-bottom-width:1px;  width:460px; height:auto; LINE-HEIGHT: 20px; OVERFLOW: auto;overflow-x:visible; word-break:break-all;'>
			${v3x:toHTML(supOpinion) }
		</div>
			<div class="hr_heng margin_t_10" />
		</td>
	</tr>
	</c:if>
	<c:if test="${hasToSubOpinion == 'true' }">
	<tr>
		<td height="30" class="td_bottom bg_color">&nbsp;<strong>${createTurnRecUserName}&nbsp;<fmt:message key='permission.operation.TurnRecEdoc' bundle='${edocI18N}'/></strong></td>
	</tr>
	<tr>
		<td height="25" class="td_bottom">&nbsp;<strong><fmt:message key="edoc.turnrec.date"  bundle="${edocI18N }"/></strong>	<div class="hr_heng margin_t_10" /></td>
	</tr>
		<tr>
		<td height="30" class="td_bottom"  valign="top">&nbsp;<fmt:formatDate value="${createTime}" pattern="yyyy-MM-dd HH:mm"/>
				<div class="hr_heng margin_t_10" /></td>
	</tr>
	<tr>
		<td height="25" class="td_bottom">&nbsp;<strong><fmt:message key='exchange.edoc.sendToNames'/></strong>	<div class="hr_heng margin_t_10" /></td>
	</tr>
	<tr>
		<td height="30" class="td_bottom" valign="top">&nbsp;${sendUnitNames }
				<div class="hr_heng margin_t_10" /></td>
	</tr>
	
	<tr>
		<td height="25" class="td_bottom">&nbsp;<strong><fmt:message key="edoc.deal.opinion"  bundle="${edocI18N }"/></strong><div class="hr_heng margin_t_10" /></td>
	</tr>
	<tr>
		<td  valign="top" height="250">
		&nbsp;<div style="border:0px;padding:0px; PADDING:0px; width:480px; height:100%; LINE-HEIGHT: 20px; OVERFLOW: auto;overflow-x:visible; word-break:break-all;">
		${v3x:toHTML(opinion)}
		</div>
		</td>
	</tr>
	</c:if>
</table>
</form>  
</body>
</html>