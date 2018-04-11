<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

</head>
<body>

	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
		<div class="form_area">

			<div class="one_row">
				<input type="hidden" name="id" id="memberID" /> <br />
				<table style="width:100%">

					<tbody>

						<tr class="talbe1_tr">
							<th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('m3.xiaozhi.member.name') }:</label></th>
							<td colspan="3">
								<textarea id="userName" rows="2" cols="60" readonly="readonly" style="color:gray;overflow-y:auto" disabled="disabled" ></textarea>

							</td>
							
						</tr>
						<tr>
							<th nowrap="nowrap"><font color="red">*</font><label class="margin_r_10" for="text">${ctp:i18n('m3.xiaozhi.client.type') }:</label></th>
							<td id = "androidtd">
								<div>
									<input type="checkbox" id="android_type" value="android"> android
								</div>

							</td>
							<td style="float:right" ><p id ="android_select_tr"><font color="red">*</font>${ctp:i18n('m3.xiaozhi.auth.android.count')}:<select id="android_count"></select></p></td>
							<td ><p id = "android_select_lebel"><font color="red" >${ctp:i18n('m3.xiaozhi.form.label.0')}:<font id ="form_androidResidue">${orgAuthInfo.androidResidue }</font></font></p></td>
						</tr>
						<tr>
							<th></th>
							<td id = "iphonetd">
								<div>
									<input type="checkbox" id="iphone_type" value="iphone"> iPhone
									
								</div>
							</td>
							<td style="float:right" id = "iphone_select_tr"><p id = "iphone_select_tr"><font color="red">*</font>${ctp:i18n('m3.xiaozhi.auth.iphone.count')}:<select id="iphone_count"></select></p></td>
							<td ><p id = "iphone_select_lebel"><font color="red">${ctp:i18n('m3.xiaozhi.form.label.1')}:<font id = "form_iphoneResidue">${orgAuthInfo.iphoneResidue }</font></font></p></td>
						</tr>
						<tr>
							<td align="right"></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</form>


</body>
</html>