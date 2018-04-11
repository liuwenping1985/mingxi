<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>

<script type="text/javascript"
	src="${path}/ajax.do?managerName=xcSynManager"></script>
<script type="text/javascript">
	$(function() {
		var check = document.getElementById("Password").value;
		if (check != "") {
			document.getElementById("changeBut").value = "${ctp:i18n('xc.button.change')}";
		}
		if (check == null || check == "") {
			$('#UserID').attr('disabled', false);//${ctp:i18n('xc.button.change')}
			$('#Password').attr('disabled', false);
			$('#CorporationID').attr('disabled', false);
			$("#iscreate").attr('disabled', false);
		}
		var iscreate = $("#iscreate").val();//1 可以创建，0 不可创建
		if ($('#sys_isGroup').val() == "true") {
			createChild();
		} else {
			$("#isdisplay").hide();
			createChild();
			if (iscreate == "0") {
				//默认单位管理员不可以修改时，不允许编辑
				$('#UserID').attr('disabled', true);
				$('#Password').attr('disabled', true);
				$('#CorporationID').attr('disabled', true);
				$("#button").hide();
			}
		}

		function createChild() {
			//显示是否可创建判断方式
			if (iscreate == "1") {
				$("#iscreate").attr("checked", true);
				$("#iscreate").val("1");
			} else {
				$("#iscreate").attr("checked", false);
				$("#iscreate").val("0");
			}
		}
		$("#iscreate").click(function() {
			var iscreateval = $("#iscreate").val();
			if (iscreateval == "0") {
				$("#iscreate").val("1");
			} else {
				$("#iscreate").val("0");
			}
		});
	});
	function change() {

		$('#UserID').attr('disabled', false);//${ctp:i18n('xc.button.change')}
		$('#Password').attr('disabled', false);
		$('#CorporationID').attr('disabled', false);
		$("#iscreate").attr('disabled', false);
		var b = document.getElementById("changeBut").value;
		if (b == '确定') {
			saveData();
			return;
		}
		document.getElementById("subBut").style.display = "";
		document.getElementById("subBut").style.visibility = 'visible';
		document.getElementById("changeBut").style.display = "none";
		document.getElementById("cancleBut").style.display = "";
		document.getElementById("cancleBut").style.visibility = 'visible';

	}
	function saveData() {
		var id = $("#id").val();
		var userId = $("#UserID").val();
		var password = $("#Password").val();
		var corporationId = $("#CorporationID").val();
		var iscreate = $("#iscreate").val();
		if (userId == '' || password == '' || corporationId == '') {
			$.alert("${ctp:i18n('xc.syn.return.4.js')}");
			return;
		}
		var xcSyn = new xcSynManager();
		xcSyn.saveXCParameter(id, userId, password, corporationId, iscreate);
		$.infor($.i18n('xc.syn.return.7.js'));
		document.getElementById("subBut").style.display = "none";
		document.getElementById("changeBut").style.display = "";
		document.getElementById("cancleBut").style.display = "none";
		document.getElementById("changeBut").value = "${ctp:i18n('xc.button.change')}";
		$('#UserID').attr('disabled', true);
		$('#Password').attr('disabled', true);
		$('#CorporationID').attr('disabled', true);
		$("#iscreate").attr('disabled', true);
	}
	function cancle() {
		history.go(0);
		return false;
	}
</script>

</head>
<body>
	<div class="comp"
		comp="type:'breadcrumb',comptype:'location',code:'xc001'"></div>
	<div class="comp"
		comp="type:'breadcrumb',comptype:'location',code:'xc006'"></div>
	<div id='layout' class="comp" comp="type:'layout'">
		<input type="hidden" id="sys_isGroup" value="${sys_isGroup}" />
		<form id="xcSetParameterForm" name="xcSetParameterForm">
			<div class="form_area">
				<div class="one_row"
					style="width: 60%; margin-top: 40px; padding: 0px; height: 360px; background-color: #F4F4F4;">
					<div style="float: left; width: 40%; height: 100%;">
						<img src="/seeyon/common/images/accountinfor.jpg" width="100%"
							height="100%">
					</div>
					<input type="hidden" id="id" name="id" value="${id}">
					<div
						style="width: 55%; float: right; height: 100%; margin-top: 5px;">
						<br> <br>
						<div
							style="width: 90%; border-bottom: solid 1px #C7C7C7; padding-bottom: 5px;">
							<span style="border-bottom: solid 2px; padding-bottom: 5px;"><font
								size="4t">${ctp:i18n('xc.menu.100101')}</font></span>
						</div>
						<table width="100%" height="100%" border="0" cellspacing="0"
							cellpadding="0">
							<tbody>
								<tr>
									<th nowrap="nowrap" height="30%"><label for="text"><span
											style=""><font color="red">*</font>${ctp:i18n('xc.account.userid')}：</span></label></th>
									<td width="100%">
										<div style="width: 85%;" class="common_txtbox_wrap">
											<input type="text" class="validate" id="UserID"
												style="width: 100%; height: 25px;" maxlength="50"
												name="UserID"
												validate="notNull,name:'${ctp:i18n('xc.account.userid')}',maxLength:255,type:'string'"
												value="${UserID}" disabled="true">
										</div>
									</td>
								</tr>
								<tr>
									<th nowrap="nowrap" height="30%"><label for="text"><font
											color="red">*</font>${ctp:i18n('xc.account.password')}：</label></th>
									<td width="50%">
										<div style="width: 85%;" class="common_txtbox_wrap">
											<input type="password" class="validate" id="Password"
												maxlength="50" name="Password"
												validate="notNull,name:'${ctp:i18n('xc.account.password')}',type:'string'"
												value="${Password}" disabled="true">
										</div>
									</td>
								</tr>
								<tr>
									<th nowrap="nowrap" height="40%"><label for="text"><font
											color="red">*</font>${ctp:i18n('xc.account.corporationid')}：</label></th>
									<td width="100%">
										<div style="width: 85%;" class="common_txtbox_wrap">
											<input type="text" class="input-date" id="CorporationID"
												style="width: 100%; height: 25px;" maxlength="50"
												class="validate word_break_all" name="CorporationID"
												validate="notNull,name:'${ctp:i18n('xc.account.corporationid')}',minLength:1,maxLength:255,type:'string'"
												value="${CorporationID}" disabled="true">
										</div>
									</td>
								</tr>
								<tr>
									<th nowrap="nowrap" height="40%"><label> </label></th>
									<td width="100%">
										<div id="isdisplay" style="width: 100%; margin-bottom: 60px;">
											<input type="checkbox" id="iscreate" name="iscreate"
												value="${iscreate}" class="radio_com"
												style="margin-left: 25px;" disabled="true">${ctp:i18n('xc.menu.ctrip.iscreate')}
										</div>
									</td>
								</tr>
								<tr>
									<th nowrap="nowrap" height="40%"><label for="text"></font></label></th>
									<td width="100%">
										<div style="width: 80%;"></div>
									</td>
								</tr>
								<br>
								<br>

							</tbody>

						</table>
					</div>
				</div>

			</div>

		</form>
	</div>
	</div>
	<div class="stadic_layout_footer stadic_footer_height"
		style="height: 50px;">
		<div id="button" align="center" class="page_color button_container">
			<div
				class="common_checkbox_box clearfix  stadic_footer_height padding_t border_t"
				style="background-color: #F4F4F4;">

				<input type="button"
					style="height: 50px; width: 80px; visibility: hidden;" id="subBut"
					onclick="saveData()" value="${ctp:i18n('xc.button.save')}"
					class="common_button common_button_emphasize"> <input
					type="button" style="height: 50px; width: 80px;" id="changeBut"
					onclick="change()" value="${ctp:i18n('common.button.ok.label')}"
					class="common_button common_button_emphasize"> <input
					type="button"
					style="height: 50px; width: 80px; visibility: hidden;"
					id="cancleBut" onclick="cancle()"
					value="${ctp:i18n('xc.button.cancle')}"
					class="common_button common_button_emphasize">

			</div>
		</div>
</body>
</html>