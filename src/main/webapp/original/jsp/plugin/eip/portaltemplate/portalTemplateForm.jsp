<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
	

</script>
</head>
<body>

	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
	<div class="form_area" >
	
		<div class="one_row" >
			<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}</p>
			<br>
			<br>
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>					
					<input type="hidden" name="id" id="id" value="" />
					<input type="hidden" id="columnIds" name="columnIds" value="">
					
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>模板编号:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="templateCode" style="width:100%;" class="validate word_break_all" name="templateCode"
									validate="name:'模板编号',notNull:true,minLength:1,maxLength:50,regExp:/^[a-zA-Z0-9_-]*$/,errorMsg:'只允许填写大小写字母、_、-、数字的自由组合！'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>模板名称:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="templateName" style="width:100%;" class="validate word_break_all" name="templateName"
									validate="name:'模板名称',notNull:true,minLength:1,maxLength:55,regExp:/^[a-zA-Z0-9\u4e00-\u9fa5_-]*$/,errorMsg:'只允许填写简体中文、大小写字母、_、-、数字的自由组合！'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>行业分类:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<select id="industrySort" name="industrySort" class="codecfg" style="width: 100%; border: 0px;"
    							codecfg="codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalTemplateIndustryEnum'">
    								<!-- <option value="0">请选择</option> -->
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>模板布局样式:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="templateLayout" readonly="readonly" style="width:100%;cursor: pointer;" class="validate word_break_all" name="templateLayout"  placeholder="上传模板布局样式"
									validate="name:'模板布局样式',notNull:true,minLength:1">
								 <input id="templateLayout0" name="templateLayout0" type="text" class="comp" 
									comp="attachmentTrId:'1', type:'fileupload', applicationCategory:'39',  extensions:'zip', isEncrypt:false,quantity:1,maxSize: 10485760,
									 canDeleteOriginalAtts:true, originalAttsNeedClone:false, firstSave:true,callMethod:'templateLayoutUploadCallback'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>模板Js:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="templateJs" readonly="readonly" style="width:100%;cursor: pointer;" class="validate word_break_all" name="templateJs"  placeholder="上传模板Js"
									validate="name:'模板Js',notNull:true,minLength:1">
								 <input id="templateJs0" name="templateJs0" type="text" class="comp" 
									comp="attachmentTrId:'4', type:'fileupload', applicationCategory:'39',  extensions:'zip', isEncrypt:false,quantity:1,maxSize: 10485760,
									 canDeleteOriginalAtts:true, originalAttsNeedClone:false, firstSave:true,callMethod:'templateJsUploadCallback'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>模板样式:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="templateCss" readonly="readonly" style="width:100%;cursor: pointer;" class="validate word_break_all" name="templateCss" placeholder="上传模板样式"
									validate="name:'模板样式',notNull:true,minLength:1">
								<input id="templateCss0" name="templateCss0" type="text" class="comp" 
									comp="attachmentTrId:'2', type:'fileupload', applicationCategory:'39',  extensions:'zip', isEncrypt:false,quantity:1,maxSize: 10485760,
									 canDeleteOriginalAtts:true, originalAttsNeedClone:false, firstSave:true,callMethod:'templateCssUploadCallback'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>模板图标:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="templateIco" readonly="readonly" style="width:100%;cursor: pointer;" class="validate word_break_all" name="templateIco" placeholder="上传模板图标"
									validate="name:'模板图标',notNull:true,minLength:1">
								<input id="templateIco0" name="templateIco0" type="text" class="comp"
									comp="attachmentTrId:'3', type:'fileupload', applicationCategory:'39',  extensions:'zip', isEncrypt:false,quantity:1,maxSize: 10485760,
									 canDeleteOriginalAtts:true, originalAttsNeedClone:false, firstSave:true,callMethod:'templateIcoUploadCallback'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>模板栏目:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="columnCodes" style="width:100%;cursor: pointer;" readonly="readonly" class="validate word_break_all" name="columnCodes" placeholder="点击选择模板栏目"
									validate="name:'模板栏目',notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>状态:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<select id="isEnable" name="isEnable" class="codecfg" style="width: 100%; border: 0px;" 
    							codecfg="codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnableColumnTypeEnum'">
    								<!-- <option value="">请选择</option> -->
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">备注:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="backUpValue" style="width:100%;" class="validate word_break_all" name="backUpValue"
									validate="notNull:false,minLength:1,maxLength:255,name:'备注',regExp:/^[a-zA-Z0-9\u4e00-\u9fa5_-]*$/,errorMsg:'只允许填写简体中文、大小写字母、_、-、数字的自由组合！且长度不可超过255！'">
							</div>
						</td>
					</tr>
					<%-- <tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.staffname.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap" style="width:179px;">
								<input type="text" id="orgMemberId"  name="orgMemberId" class="comp validate" comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:'1',showMe:false,returnValueNeedType:false,callback:memberCallBack"
                                                validate="type:'string',name:'${ctp:i18n('voucher.plugin.cfg.staffname.label')}',notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="red">*</font>${ctp:i18n('voucher.plugin.cfg.erpstaffname.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap" style="width:179px;">
								<input type="text" id="erpPersonName" class="validate word_break_all" readonly="readonly" name="${ctp:i18n('voucher.plugin.cfg.erpstaffname.label')}"
									validate="notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.staffcode.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="memberCode" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('voucher.plugin.cfg.staffcode.label')}"
									validate="notNull:false,minLength:1,maxLength:50">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('voucher.plugin.cfg.erpstaffcode.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="erpPersonCode" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('voucher.plugin.cfg.erpstaffcode.label')}"
									validate="notNull:false,minLength:1,maxLength:50">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.dept.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="deptName" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('voucher.plugin.cfg.dept.label')}"
									validate="notNull:false,minLength:1,maxLength:255">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('voucher.plugin.cfg.erpdept.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="erpDeptName" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('voucher.plugin.cfg.erpdept.label')}"
									validate="notNull:false,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('voucher.plugin.cfg.unit.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="unitName" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('voucher.plugin.cfg.unit.label')}"
									validate="notNull:false,minLength:1,maxLength:255">
							</div>
						</td>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('voucher.plugin.cfg.erpunit.label')}:</label></th>
						<td width="45%">
							<div class="common_txtbox_wrap">
								<input type="text" id="erpUnitName" class="validate word_break_all" disabled="disabled" name="${ctp:i18n('voucher.plugin.cfg.erpunit.label')}"
									validate="notNull:false,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<td align="right"></td>
					</tr> --%>
				</tbody>
			</table>
		</div>
		</div>
	</form>


</body>

<input id="load" name="load" type="text" class="comp" 
comp="attachmentTrId:'5', type:'fileupload', applicationCategory:'39',  extensions:'pm', isEncrypt:false,quantity:1,maxSize: 10485760,
canDeleteOriginalAtts:true, originalAttsNeedClone:false, firstSave:true,callMethod:'loadUploadCallback'">
					
</html>