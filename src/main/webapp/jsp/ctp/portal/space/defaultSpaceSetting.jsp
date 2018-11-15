<%--
 $Author: zhout $
 $Rev: 33650 $
 $Date:: 2014-03-07 16:43:47#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title></title>
<script type="text/javascript">
var spaceManager = RemoteJsonService.extend({
	jsonGateway : "${path}/ajax.do?method=ajaxAction&managerName=spaceManager",
	getDefaultSpaceSettingForGroup: function(){
		return this.ajaxCall(arguments, "getDefaultSpaceSettingForGroup");
	},
	getDefaultSpaceSettingForAccount: function(){
		return this.ajaxCall(arguments, "getDefaultSpaceSettingForAccount");
	},
	transSetDefaultSpace: function(){
		return this.ajaxCall(arguments, "transSetDefaultSpace");
	},
	getPortalSpaceFixByType: function(){
		return this.ajaxCall(arguments, "getPortalSpaceFixByType");
	},
	selectSpaceById: function(){
		return this.ajaxCall(arguments, "selectSpaceById");
	}
});

var spaceManagerObject = new spaceManager();

<%-- 点击确定按钮 --%>
function OK() {
	if(getCtpTop().isCurrentUserAdministrator == "true"){
		var settingForGroup = spaceManagerObject.getDefaultSpaceSettingForGroup();
		if(settingForGroup.allowChangeDefaultSpace == "0"){
			if(settingForGroup.defaultSpace.length > 0){
				var spaceAndPage = spaceManagerObject.selectSpaceById(settingForGroup.defaultSpace);
				getCtpTop().$.alert($.i18n("space.defaultSpace.groupNotAllow.prompt", ($.i18n(spaceAndPage.spacename) || spaceAndPage.spacename)));
				return;
			} else {
				var spaceName = null;
				if(settingForGroup.spaceType == "5_0_14_16_9_10"){
					spaceName = "${ctp:i18n("space.default.personal.label")}";
				} else if(settingForGroup.spaceType == "2"){
					spaceName = "${ctp:i18n("space.default.corporation.label")}";
				} else {
					<c:if test="${ctp:getSystemProperty('system.ProductId') == 2}">
					spaceName = "${ctp:i18n("space.default.group.label")}";
					</c:if>
					<c:if test="${ctp:getSystemProperty('system.ProductId') == 4}">
					spaceName = "${ctp:i18n("seeyon.top.group.space.label.GOV")}";
					</c:if>
				}
				getCtpTop().$.alert($.i18n("space.defaultSpace.groupNotAllow.prompt", spaceName));
				return;
			}
		}
	}
	var setting = new Object();
	setting.allowChangeDefaultSpace = $("#allowCustom").attr("checked") == "checked"?"1":"0";
	setting.userId = $.ctx.CurrentUser.loginAccount;
	if(getCtpTop().isCurrentUserGroupAdmin == "true"){
		if($("#personalSpaceRadio").attr("checked") == "checked"){
			setting.spaceType = "5_0_14_16_9_10";
			setting.defaultSpace = "";
		} else if($("#corporationSpaceRadio").attr("checked") == "checked"){
			setting.spaceType = "2";
			setting.defaultSpace = "";
		} else {
			setting.spaceType = $("#groupSpaceSelect").find("option:selected").attr("spaceType");
			setting.defaultSpace = $("#groupSpaceSelect").val();
		}
	} else {
		if($("#personalSpaceRadio").attr("checked") == "checked"){
			setting.spaceType = $("#personalSpaceSelect").find("option:selected").attr("spaceType");
			setting.defaultSpace = $("#personalSpaceSelect").val();
		} else if($("#corporationSpaceRadio").attr("checked") == "checked"){
			setting.spaceType = $("#corporationSpaceSelect").find("option:selected").attr("spaceType");
			setting.defaultSpace = $("#corporationSpaceSelect").val();
		} else {
			setting.spaceType = "3";
			setting.defaultSpace = "";
		}
	}
	spaceManagerObject.transSetDefaultSpace(setting);
	return null;
}

<%-- 填充界面元素的值 --%>
function fillUIValue(setting, bool){
	if($("#personalSpaceRadio").val().indexOf(setting.spaceType) != -1){
		$("#personalSpaceRadio").attr("checked", true);
		$("#personalSpaceSelect").val(setting.defaultSpace);
	} else if($("#corporationSpaceRadio").val().indexOf(setting.spaceType) != -1){
		$("#corporationSpaceRadio").attr("checked", true);
		$("#corporationSpaceSelect").val(setting.defaultSpace);
	} else {
		$("#groupSpaceRadio").attr("checked", true);
		$("#groupSpaceSelect").val(setting.defaultSpace);
	}
	$("#allowCustom").attr("checked", bool);
}

$(document).ready(function() {
	<%-- 获取当前人的默认空间设置 --%>
	spaceManagerObject.getDefaultSpaceSettingForGroup({
		success : function(settingForGroup){
			if(getCtpTop().isCurrentUserGroupAdmin == "true"){
				<%-- 集团管理员 --%>
				$("#corporationSpaceDiv").show();
				var groupSpaceTypes = [3, 18];
				spaceManagerObject.getPortalSpaceFixByType(groupSpaceTypes, null, {
					success : function(spaceFixs){
						if(spaceFixs != null && spaceFixs.length > 0){
							for(var i = 0; i < spaceFixs.length; i++){
								var spaceFix = spaceFixs[i];
								var spacename = escapeStringToHTML(spaceFix.spacename + "", false);
								spacename = $.i18n(spacename) || spacename;
								$("#groupSpaceSelect").append("<option title='" + spacename + "' value='" + spaceFix.id + "' spaceType='" + spaceFix.type + "'>" + spacename + "</option>");
							}
							$("#groupSpaceDiv").show();
							$("#groupSpaceSelect").show();
						} else {
							$("#groupSpaceDiv").hide();
							$("#groupSpaceSelect").hide();
						}
						fillUIValue(settingForGroup, settingForGroup.allowChangeDefaultSpace == "1");
					}
				});
			} else {
				<%-- 单位管理员 --%>
				$("#groupSpaceDiv").show();
				spaceManagerObject.getDefaultSpaceSettingForAccount($.ctx.CurrentUser.loginAccount, {
					success : function(settingForAccount){
						$("#personalSpaceSelect").append("<option title='${ctp:i18n("space.default.personal.label")}' value=\"\" spaceType=\"5_0_14_16_9_10\">${ctp:i18n("space.default.personal.label")}</option>");
						var personalSpaceTypes = [15];
						var spaceFixs = spaceManagerObject.getPortalSpaceFixByType(personalSpaceTypes, $.ctx.CurrentUser.loginAccount);
						if(spaceFixs != null && spaceFixs.length > 0){
							for(var i = 0; i < spaceFixs.length; i++){
								var spaceFix = spaceFixs[i];
								var spacename = escapeStringToHTML(spaceFix.spacename + "", false);
								spacename = $.i18n(spacename) || spacename;
								$("#personalSpaceSelect").append("<option title='" + spacename + "' value='" + spaceFix.id + "' spaceType='" + spaceFix.type + "'>" + spacename + "</option>");
							}
							$("#personalSpaceSelect").show();
						}
						var corporationSpaceTypes = [2, 17];
						spaceFixs = spaceManagerObject.getPortalSpaceFixByType(corporationSpaceTypes, $.ctx.CurrentUser.loginAccount);
						if(spaceFixs != null && spaceFixs.length > 0){
							for(var i = 0; i < spaceFixs.length; i++){
								var spaceFix = spaceFixs[i];
								var spacename = escapeStringToHTML(spaceFix.spacename + "", false);
								spacename = $.i18n(spacename) || spacename;
								$("#corporationSpaceSelect").append("<option title='" + spacename + "' value='" + spaceFix.id + "' spaceType='" + spaceFix.type + "'>" + spacename + "</option>");
							}
							$("#corporationSpaceSelect").show();
							$("#corporationSpaceDiv").show();
						} else {
							$("#corporationSpaceDiv").hide("");
						}
						fillUIValue(settingForAccount, (settingForGroup.allowChangeDefaultSpace == "1" && settingForAccount.allowChangeDefaultSpace == "1"));
					}
				});				
			}			
		}
	});
});
</script>
</head>
<body style="font-size: 14px; overflow: hidden;">
    <div style="margin-left: 40px; margin-top: 20px; ">${ctp:i18n("space.setDefaultSpace.label")}</div>
	<div class="common_radio_box clearfix" style="margin-left: 55px; margin-top: 10px; margin-bottom: 15px;">
		<div>
			<label class="margin_t_5 hand" for="personalSpaceRadio">
				<input id="personalSpaceRadio" class="radio_com" name="spaceOption" value="5_0_14_16_9_10_15" type="radio" />${ctp:i18n("space.default.personal.label")}
			</label>&nbsp;&nbsp;<select id="personalSpaceSelect" style="width: 170px; display: none" ></select>
		</div>
		<div id="corporationSpaceDiv" style="display: none; margin-top:10px">
			<label id="corporationLabel" class="margin_t_5 hand" for="corporationSpaceRadio">
				<input id="corporationSpaceRadio" class="radio_com" name="spaceOption" value="2_17" type="radio" />${ctp:i18n("space.default.corporation.label")}
			</label>&nbsp;&nbsp;<select id="corporationSpaceSelect" style="width: 170px; display: none" ></select>
		</div>
		<div id="groupSpaceDiv" style="display: none; margin-top:10px">
			<c:if test="${ctp:getSystemProperty('system.ProductId') == 2 || ctp:getSystemProperty('system.ProductId') == 4}">
			<%-- 集团版 --%>
			<label id="groupSpaceLabel" class="margin_t_5 hand" for="groupSpaceRadio">
				<input id="groupSpaceRadio" class="radio_com" name="spaceOption" value="3_18" type="radio" /><c:if test="${ctp:getSystemProperty('system.ProductId') == 2}">${ctp:i18n("space.default.group.label")}</c:if><c:if test="${ctp:getSystemProperty('system.ProductId') == 4}">${ctp:i18n("seeyon.top.group.space.label.GOV")}</c:if>
			</label>&nbsp;&nbsp;<select id="groupSpaceSelect" style="width: 170px; display: none" ></select>
			</c:if>
		</div>
	</div>
	<div class="common_checkbox_box clearfix" style="margin-left: 40px; margin-top: 20px; margin-bottom: 20px;">
		<label class="margin_r_10 hand" for="allowCustom"><input id="allowCustom" class="radio_com" name="allowOption" value="0" type="checkbox"><c:if test="${CurrentUser.groupAdmin}">${ctp:i18n("space.defaultSpace.allowCorporationCustom.label")}</c:if><c:if test="${CurrentUser.administrator}">${ctp:i18n("space.defaultSpace.allowPersonCustom.label")}</c:if></label>
	</div>
</body>
</html>