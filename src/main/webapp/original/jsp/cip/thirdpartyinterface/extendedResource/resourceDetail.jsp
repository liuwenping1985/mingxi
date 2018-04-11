<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
	<form name="addForm" id="addForm" method="post" target=""
		class="validate">
		<div class="form_area">
			<div class="one_row" style="width: 50%;">
				<input type="hidden" id="masterId"> 
				<input type="hidden" id="productIdDet"> 
				<input type="hidden" id="productVersionId">
				<input type="hidden" id="fileName1"> 
				<input type="hidden" id="fileId1">
				<table>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.base.interface.detail.product')}:</label></th>
						<td width="100%"><input type="text" id="productFlag"
							class="w100b validate"
							validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.product')}'"
							disabled="disabled"></input></td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.extendedresource.lab.resourceno')}:</label></th>
						<td width="100%"><input type="text" id="resourceCodeDet"
							class="w100b validate"
							validate="type:'string',name:'${ctp:i18n('cip.extendedresource.lab.resourceno')}'"
							disabled="disabled"></input></td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.extendedresource.lab.resourcename')}:</label></th>
						<td width="100%"><input type="text" id="resourceNameDet"
							class="w100b validate"
							validate="type:'string',name:'${ctp:i18n('cip.extendedresource.lab.resourcename')}',notNull:true,maxLength:80" />
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.extendedresource.lab.resourcebag')}:</label></th>
						<td width="100%">
							<div class="common_txtbox_wrap">
								<span id="tab1"></span>
								<div style="float: right;" id="d1">
									<div class="comp"
										comp="type:'fileupload',applicationCategory:'39',quantity:1,maxSize:52428800,firstSave:true,canDeleteOriginalAtts:false,originalAttsNeedClone:false,extensions:'zip,rar',callMethod:'fillUpCallBk'"></div>
									<a id="a1" href="javascript:void(0)"
										onclick="insertAttachment()"
										class="common_button common_button_gray">${ctp:i18n('cip.base.interface.register.upfile')}</a>
									<a id="a2" href="javascript:void(0)" onclick="downFile();"
										class="common_button common_button_gray">${ctp:i18n('cip.base.interface.register.downfile')}</a>
									<input type="hidden" id="fileName1"> <input
										type="hidden" id="fileId1">
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.extendedresource.lab.resourcelist')}:</label></th>
						<td width="100%">
							<div class="common_txtbox clearfix">
								<textarea id="resourceListDet" cols='2' class="validate"
									style="width: 100%; height: 80px;"
									validate="type:'string',name:'${ctp:i18n('cip.extendedresource.lab.resourcelist')}',notNull:true,maxLength:300">
								</textarea>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.extendedresource.lab.resourcedeploy')}:</label></th>
						<td width="100%">
							<div class="common_txtbox clearfix">
								<textarea id="resourceDeployDet" cols='2' class="validate"
									style="width: 100%; height: 80px;"
									validate="type:'string',name:'${ctp:i18n('cip.extendedresource.lab.resourcedeploy')}',notNull:true,maxLength:300">
								</textarea>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.extendedresource.lab.resourcedependent')}:</label></th>
						<td width="100%">
							<div class="common_txtbox clearfix">
								<textarea id="resourceDependentDet" cols='2' class="validate"
									style="width: 100%; height: 80px;"
									validate="type:'string',name:'${ctp:i18n('cip.extendedresource.lab.resourcedependent')}',notNull:true,maxLength:300">
								</textarea>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.extendedresource.lab.resourcememo')}:</label></th>
						<td width="100%"><input type="text" id="resourceMemoDet"
							class="w100b validate"
							validate="type:'string',name:'${ctp:i18n('cip.extendedresource.lab.resourcememo')}',maxLength:80" />
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</body>
</html>