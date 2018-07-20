<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="include/form_taglib.jsp"%>
<%@ include file="include/form_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>信息类型</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=govformManager"></script>
<script type="text/javascript" src="${path}/apps_res/gov/govform/js/operation_choose.js${ctp:resSuffix()}"></script>
<style>
.stadic_body_top_bottom{
    top: 0px;
    bottom: 40px;
}
.stadic_footer_height{
    height:40px;
}
</style>	
<script>

var flowpermName = "${flowpermName}";
var processName = "${processName}";

$(document).ready(function () {
	showNode2('${flowpermName}', '${processName}');
	$("#edit_confirm_button").click(function() {
		transformValue();
	});
	$("#edit_cancel_button").click(function() {
		arg.choosePermissionDialog.close();
	});
});

</script>
<title>节点权限绑定</title>
</head>
<body class="h100b over_hidden page_color">

<form name="form1">

<div class="stadic_layout_body stadic_body_top_bottom clearfix" style="overflow:hidden">
	<!-- 
	<div class="padding_t_10 padding_l_5" style="font-size:14px;font-weight:bold;"><label>${ctp:i18n('govform.label.nodeBindPermission')}节点权限绑定</label></div>
	 -->
	<table class="padding_t_10 padding_l_5 w100b h100b">
		<tr>
			<td width="40%"><label style="font-size:12px;">${ctp:i18n('govform.label.permission.candidate')}<!-- 候选权限 --></label></td>
			<td width="10%">&nbsp;</td>
			<td width="40%"><label style="font-size:12px;">${ctp:i18n('govform.label.permission.selected')}<!-- 已选权限 --></label></td>
			<td width="10%">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td id="Area1" class="iframe" width="40%" valign="top">
				<select id="reserve" name="reserve"	ondblclick="moveLtoR(form1.reserve,form1.selected);"	multiple="multiple"  size="22"  style="width:130px;">
						<c:forEach var="flowPerm" items="${permissionList}">
							<option value="${flowPerm.label}">
							<c:if test="${flowPerm.type == 0}">${flowPerm.name}</c:if>
							<c:if test="${flowPerm.type == 1}">${flowPerm.name}</c:if>
							</option>
						</c:forEach>
				</select>
				<select id="reserve2" name="reserve2" style="display:none">
					<c:forEach var="flowPerm2" items="${permissionList}">
						<option value="${flowPerm2.name}">
							${flowPerm2.label}
						</option>
					</c:forEach>
				</select>
			</td>
			<td width="10%" valign="middle"  align="center">
				<div><span class="ico16 select_selected" onClick="moveLtoR(form1.reserve,form1.selected);"></span></div>
				<div><span class="ico16 select_unselect" onClick="moveRtoL(form1.selected,form1.reserve);"></span></div>
			</td>
			<td id="Area1" class="iframe"  width="40%" valign="top">
				<select id="selected" name="selected" ondblclick="moveRtoL(form1.selected,form1.reserve);"
					multiple="multiple"  size="22"  style="width:130px;" >
				</select>
			</td>
				<td width="10%" valign="middle"  align="center">
					<div><span class="ico16 sort_up" onClick="up(form1.selected)"></span></div>
					<div><span class="ico16 sort_down" onClick="down(form1.selected)"></span></div>
			</td>
		</tr>
	</table>
		
</div>
	
<div class="stadic_layout_footer stadic_footer_height">
	<div class="common_checkbox_box align_center clearfix padding_t_5 border_t">
	   <a href="javascript:void(0)" class="common_button common_button_gray" id="edit_confirm_button">${ctp:i18n('permission.confirm')}</a>&nbsp;<%--确定 --%>
	   <a href="javascript:void(0)" class="common_button common_button_gray" id="edit_cancel_button">${ctp:i18n('permission.cancel')}</a><%--取消 --%>
	</div>
</div><!-- stadic_layout_footer -->
	
</form>

</body>
</html>
