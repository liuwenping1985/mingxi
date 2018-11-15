<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>设置所属人</title>
	<script>
	var moduleFlag = "${moduleFlag}";
	var param = window.dialogArguments;
	var bizConfigIds = param.bizConfigIds.join(",");
	var isBaseInfo = param.isBaseInfo;
	var selected = -1;
	$().ready(function(){
			getIds();
			<c:if test="${moduleFlag eq 'form'}" >
			$("#accessableAccounts4Tree").tree({
				idKey   : "id",
				pIdKey  : "superior",
				nameKey : "name",
				onClick : onClick
			});
			</c:if>
			if(isBaseInfo && isBaseInfo == true) {
				initSelected();
			}
			$("#select_ico").click(function (){
				addOptions();
			});
			$("#unselect_ico").click(function (){
				delOptions();
			});
			/*var searchobj = $.searchCondition({
                top:10,
              right:10,
                searchHandler: function(){
                    var choose = $('#'+searchobj.p.id).find("option:selected").val();
                    var value = "";
                    if(choose === 'subject'){
                        value =  $('#names').val();
                    }
                    $("#unselect").empty();
                    $("#unselectforsearch").children("option").each(function(){
	                    if (value == "") {
	                    	$("#unselect").append($(this).clone());
	                    } else {
	                    	if ($(this).text().indexOf(value) != -1){
	                    	$("#unselect").append($(this).clone());
	                    	}
	                    }
                    });
                },
                conditions: [{
                    id: 'names',
                    name: 'names',
                    type: 'input',
                    text: '${ctp:i18n('form.base.setformaffiliatedperson.search')}',//标题
                    value: 'subject'
                }]
            });*/
		$("#searchbtn").click(function(){
			search();
		});
		$("#searchValue").keyup(function(event) {
			if (event.keyCode == 13) {
				search();
			}
		});
		queryFormAdmin("${currentAccountId}");
		});

	function getIds() {
		var bizManager = new businessManager();
		bizManager.getFormNames(bizConfigIds,moduleFlag,{
			success: function(data){
				$("#bizConfigNames").val(data);
			}
		});
	}

	function search() {
		var	value =  $('#searchValue').val();
		$("#unselect").empty();
		$("#unselectforsearch").children("option").each(function(){
			if (value == "") {
				$("#unselect").append($(this).clone());
			} else {
				if ($(this).text().indexOf(value) != -1){
					$("#unselect").append($(this).clone());
				}
			}
		});
	}
		//添加
		function addOptions(){
			if($("#unselect").find("option:selected").length == 0){
				$.alert("${ctp:i18n('form.formlist.pleasechooseone')}");
			}else if($("#selected").find("option").length > 0){
		    	$.alert("${ctp:i18n('form.formlist.owneronlyone')}");
			}else if($("#unselect").find("option:selected").length > 1){
				$.alert("${ctp:i18n('form.formlist.owneronlyone')}");
			}else{
				$("#selected").append("<option value='"+$("#unselect").val()+"' >"+$("#unselect").find("option:selected").text()+"</option>");
				selected = 1;
			}
		}
		//删除
		function delOptions(){
			if($("#selected").find("option:selected").length == 0){
				$.alert("${ctp:i18n('form.formlist.pleasechooseone')}");
				return false;
			}
			$("#selected").empty();
		}
		//初始化选中框
		function initSelected(){
			if($("#ownerName",param.win.document).val() != null && $("#ownerName",param.win.document).val() != "") {
				$("#selected").append("<option value='"+$("#ownerId",param.win.document).val()+"' >"+$("#ownerName",param.win.document).val()+"</option>");
			}
		}

		function OK(){
	    	if($("#selected").find("option").length == 0){
				$.alert("${ctp:i18n('form.formlist.pleasechooseone')}");
				return false;
			}
			if($("#selected").find("option").length >1){
			    $.alert("${ctp:i18n('form.formlist.owneronlyone')}");
			    return false;
			}

			//var accountId = $("#accountSelect option:selected").val();
			var accountId = $("#currentAccountId").val();
			if('${moduleFlag}' == "form") {
				if (!validateFormName(accountId)) {
					return false;
				}
			}
			if(isBaseInfo && isBaseInfo == true) {
				$("#ownerId",param.win.document).val($("#selected option:first").val());
				$("#ownerName",param.win.document).val($("#selected option:first").text());
				if(selected > 0) {
					$("#ownerAccountId",param.win.document).val(accountId);
				}
				return true;
			}else {
				var bizManager = new businessManager();
				var result = bizManager.updatePeopleBelongBatch(bizConfigIds, $("#selected option:first").val(), $("#selected option:first").text(), '${moduleFlag}', accountId == null || accountId == "" ? null : accountId);
				if(result && result.success) {
					return result;
				} else {
					if (result && result.msg) {
						$.alert(result.msg);
					} else {
						$.alert("${ctp:i18n('form.data.edit.failure.causes.label')}");
					}
				}
			}
            return false;
		}

		function validateFormName(accountId) {
			var bizManager = new businessManager();
			var bizConfigName = $("#bizConfigNames").val();
			var msg = bizManager.validateFormName(bizConfigIds,bizConfigName,accountId);
			if(msg!="" && msg != null){
				$.alert(msg);
				return false;
			}
			return true;
		}

		function queryFormAdmin(accountId) {
			var bizManager = new businessManager();
			var orgMember = bizManager.getMembersByRole(accountId,"FormAdmin");
			$("#unselect").empty();
			$("#unselectforsearch").empty();
			for(var i = 0; i<orgMember.length; i ++) {
				$("#unselect").append("<option type='unselect' title='"+orgMember[i].name+"' value='"+orgMember[i].id+"'>"+orgMember[i].name+"</option>");
				$("#unselectforsearch").append("<option type='unselect' title='"+orgMember[i].name+"' value='"+orgMember[i].id+"'>"+orgMember[i].name+"</option>");
			}
		}

		function showMenu() {
			var selectDisabled = $('#select_input_div').attr("disabled");
			if(selectDisabled == true || selectDisabled == "true" || selectDisabled == "disabled"){
				return;
			}
			var accountObj = $("#select_input_div");
			var accountOffset = accountObj.offset();
			$("#accountContent").css({left:accountOffset.left - 1 + "px", top:accountOffset.top + accountObj.outerHeight() + "px"}).show();
			$("#accountContentIframe").css({left:accountOffset.left - 1 + "px", top:accountOffset.top + accountObj.outerHeight() + "px"}).show();

			var treeObj = $.fn.zTree.getZTreeObj("accessableAccounts4Tree");
			var node = treeObj.getNodeByParam("id", "${currentAccountId}", null);
			if(node){
				treeObj.expandNode(node, true);
				treeObj.selectNode(node);
			}

			$("body").bind("mousedown", onBodyDown);
		}

		function hideMenu() {
			$("#accountContent").hide();
			$("#accountContentIframe").hide();
			$("body").unbind("mousedown", onBodyDown);
		}

		function onBodyDown(event) {
			if (!(event.target.id == "accountContent" || $(event.target).parents("#accountContent").length > 0)) {
				hideMenu();
			}
		}

	function onClick(e, treeId, treeNode) {
		var nodes = $("#accessableAccounts4Tree").treeObj().getSelectedNodes();
		if(nodes[0].isParent == true && nodes[0].isFirstNode == true && nodes[0].level == 0) {
			return;
		}
		var aId = nodes[0].id;
		var aName = nodes[0].name || "";

		$("#currentAccountName").val(aName.getLimitLength(22));
		$("#currentAccountName").attr("title", aName);
		$("#currentAccountId").val(aId);

		hideMenu();
		queryFormAdmin(aId);
	}
	</script>
</head>
<body>
	<c:if test="${isAdmin != true || moduleFlag != 'form'}" ><div style="height: 40px;">&nbsp;</div></c:if>
	<div id="searchArea1" style="margin-top: <c:if test="${isAdmin != true || moduleFlag != 'form'}" >-25px;</c:if><c:if test="${moduleFlag eq 'form' && isAdmin eq true}" >5px;</c:if>">
		<ul class="common_search" style="float: right;margin-right: 30px">
			<li id="inputBorder1" class="common_search_input">
				${ctp:i18n('form.base.setformaffiliatedperson.search')}：<input id="searchValue" class="search_input" type="text" style="width:120px;">
			</li>
			<li>
				<a id="searchbtn" class="common_button search_buttonHand" href="javascript:void(0)">
					<em></em>
				</a>
			</li>
		</ul>
	</div>
	<c:if test="${moduleFlag eq 'form'}" ><!-- && isAdmin eq true-->
	<div id="accountContent" style="display:none; position:absolute;background: #ffffff; width:259px; height:330px;;z-index: 10;" class="border_all">
		<div style="margin-top:0px; width:259px; height: 330px; display: block; overflow: auto">
			<ul id="accessableAccounts4Tree" class="ztree"></ul>
		</div>
	</div>
	<iframe id="accountContentIframe" height="330px" width="259" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display:none; position:absolute;background: #ffffff; width:259px; height:330px;z-index: 9"></iframe>
	<div id="select_input_div" class="border_all padding_l_5 padding_r_5 bg_color_white"  style="width: 248px;margin-left: 17px;" onClick="showMenu(); return false;">
		<input name="currentAccountName" id="currentAccountName" type="text" class="select_input_width arrow_6_b hand" style="height: 24px; border: 0px;width: 225px;margin-left: 25px;" readonly="readonly" value="${currAccountName}" title="${currAccountName}" />
	</div>
	</c:if>
	<input type="hidden" name="currentAccountId" id="currentAccountId" value="${currentAccountId}" />
	<input type="hidden" name="bizConfigNames" id="bizConfigNames" value="" />
	<table class="margin_t_5 margin_l_5 font_size12" align="center" width="380" height="70%" style="table-layout:fixed;float:left;margin-left: 15px;">
		<tr height="310">
			<td valign="top" width="260" height="100%">
				<p align="left" class="margin_b_5">${ctp:i18n("form.business.owner.set.alternative.label")}</p>
				<select class="w100b" style="width:260px;height: 300px;" size="20" multiple id="unselect" ondblClick="addOptions()">
					<c:forEach items="${formAdminList}" var="formAdmin" varStatus="status">
						<option value="${formAdmin.id}" type="unselect">${formAdmin.name}</option>
					</c:forEach>
				</select>
			</td>
			<td width="30" valign="middle" align="center">
				<span class="select_selected hand" id="select_ico"> </span><br><br>
				<span class="select_unselect hand" id="unselect_ico"> </span>
			</td>
			<td valign="top" width="260" height="70%">
				<p align="left" class="margin_b_5 w100b">${ctp:i18n("form.business.owner.set.selected.label")}</p>
				<select class="w100b selected_area" style="height: 300px;width:260px;;" multiple size="20" id="selected" ondblClick="delOptions()">
				</select>
			</td>
		</tr>
	</table>
	<select class="w100b" style="width:260px;height: 300px;display: none;" size="20" multiple id="unselectforsearch">
		<c:forEach items="${formAdminList}" var="formAdmin" varStatus="status">
			<option value="${formAdmin.id}" type="unselect">${formAdmin.name}</option>
		</c:forEach>
	</select>
</body>
</HTML>