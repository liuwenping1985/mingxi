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
	$().ready(function(){
		initSelected();
		$("#select_ico").click(function (){
			addOptions();
		});
		$("#unselect_ico").click(function (){
			delOptions();
		});
			
		$("#searchbtn").click(function(){
			search();
		});
		$("#searchValue").keyup(function(event) {
			if (event.keyCode == 13) {
				search();
			}
		});
	});


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
			if($("#ownerName",window.dialogArguments.window.document).val() != null && $("#ownerName",window.dialogArguments.window.document).val() != "") {
				$("#selected").append("<option value='"+$("#ownerId",window.dialogArguments.window.document).val()+"' >"+$("#ownerName",window.dialogArguments.window.document).val()+"</option>");
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
			$("#ownerId",window.dialogArguments.window.document).val($("#selected option:first").val());
			$("#ownerName",window.dialogArguments.window.document).val($("#selected option:first").text());
			return true;
		}
	</script>
</head>
<body>
	<div style="height: 40px;">&nbsp;</div>
	<div id="searchArea1" style="margin-top: <c:if test="${isAdmin != true || moduleFlag != 'form'}" >-25px;</c:if><c:if test="${moduleFlag eq 'form' && isAdmin eq true}" >5px;</c:if>">
		<ul class="common_search" style="float: left;margin-left: 10px">
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
	<table class="margin_t_5 margin_l_5 font_size12" align="center" width="380" height="70%" style="table-layout:fixed;">
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