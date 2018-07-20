<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>form</title>
<script type="text/javascript">
	function configSetting(permissionId,obj) {
		var dialog = $.dialog({
			targetWindow : getCtpTop(),
			id : 'configSetting',
			url : "/seeyon/form/authDesign.do?method=rightSetting&permissionId=" + permissionId,
			width : 350,
			height : 220,
			title : "权限设置", // 另存为个人模板
			buttons : [ {
				text : $.i18n('collaboration.pushMessageToMembers.confirm'), // 确定
				handler : function() {
					var rv = dialog.getReturnValue();
					if (!rv) {
						return;
					}
					$.ajax({
						url : "/seeyon/form/authDesign.do?method=rightSettingAjax&result=" + rv + "&permissionId=" + permissionId,
						success : function(data){
							if(data == "error"){
								alert("操作失败");
								dialog.close();
								return;
							}
							var allData = data.split("@");
							var dataShow;
							if(allData.length > 1){
								if(allData[1] == 'true'){
									if(allData[0]==""){
										dataShow = $.i18n('govdoc.content.show.label');
									}else{
										dataShow = allData[0] + "," +$.i18n('govdoc.content.show.label');
									}
								}else{
									if(allData[0]==""){
										dataShow = $.i18n('govdoc.content.dnot.show.label');
									}else{
										dataShow = allData[0]+ "," +$.i18n('govdoc.content.dnot.show.label');
									}
								}
							}else{
								if(allData[0] == 'true'){
									dataShow = $.i18n('govdoc.content.show.label');
								}else{
									dataShow = $.i18n('govdoc.content.dnot.show.label');
								}
							}
							$(obj).val(dataShow);
							dialog.close();
						}
					});
				}
			}, {
				text : $.i18n('collaboration.pushMessageToMembers.cancel'), // 取消
				handler : function() {
					dialog.close();
				}
			} ]
		});
	}
</script>
</head>
<body class="page_color">
	<div id='layout'>
		<div class="layout_north" id="north">
			<!--向导菜单-->
			<div class="step_menu clearfix margin_tb_5 margin_l_10">
				<%@ include file="top.jsp"%>
			</div>
			<!--向导菜单-->
			<div class="hr_heng"></div>
		</div>
		<div class="layout_center bg_color_white" id="center">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
				<thead>
					<tr>
						<!-- 节点名称 -->
						<th width="10%">${ctp:i18n('form.oper.nodeName.label')}</th>
						<!-- 操作权限名称-->
						<th width="70%">${ctp:i18n('form.bind.operate.label')}</th>
						<!-- 操作绑定-->
						<th width="10%">${ctp:i18n('form.bind.type.label')}</th>
					</tr>
				</thead>

				<tbody id="authBody" isNewCode='1'>
					<c:forEach var="permission" items="${permissionList }" varStatus="status">
						<tr>
							<td>${permission.name }</td>
							<td><input type="text" <c:if test="${permission.code eq 'niwen' || permission.code eq 'dengji' }">disabled="disabled"</c:if> value="<c:if test="${empty permission.relationDesc}"><c:if test="${permission.showContentConfig eq 'true'}">${ctp:i18n('govdoc.content.show.label')}</c:if><c:if test="${permission.showContentConfig eq 'false'}">${ctp:i18n('govdoc.content.dnot.show.label')}</c:if></c:if><c:if test="${not empty permission.relationDesc}">${permission.relationDesc}<c:if test="${permission.showContentConfig eq 'true'}">,${ctp:i18n('govdoc.content.show.label')}</c:if><c:if test="${permission.showContentConfig eq 'false'}">,${ctp:i18n('govdoc.content.dnot.show.label')}</c:if></c:if>" onclick="configSetting('${permission.id}',this)" style="width:100%"/></td>
							<td>${permission.typeName }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<div class="layout_south over_hidden" id="south">

			<%@ include file="bottom.jsp"%>

		</div>
	</div>
	<%@ include file="designRight.js.jsp"%>
</body>
</html>
