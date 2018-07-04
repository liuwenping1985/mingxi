<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
	<form name="addForm" id="addForm" method="post">
	<input type="hidden" id="appId" name="appId" value="${param.appId}">
	<input type="hidden" id="registerId" name="registerId" value="${param.registerId}">
	<div class="form_area" >
		<div class="one_row">
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>应用上传:</label></th>
						<td width="400">
						<div class="comp" comp="type:'fileupload',applicationCategory:'39',canDeleteOriginalAtts:false,originalAttsNeedClone:false,maxSize:10485760*5,attachmentTrId:'att',quantity:1,firstSave:true,callMethod:'uploadCallBack',takeOver:false,extensions:'zip',delCallMethod:'deleteCallBack'"></div>
						<a href="javascript:void(0)" onclick="isCallBack()" class="common_button common_button_icon"><em class="ico16 affix_16"></em>上传 </a>
						<input type="hidden" id="appFile" name="appFile" value=""/>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>版本说明:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="releaseNote" name="releaseNote" class="w100b validate" validate="notNull:true,name:'版本说明',maxLength:100">
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		</div>
	</form>
</body>
</html>