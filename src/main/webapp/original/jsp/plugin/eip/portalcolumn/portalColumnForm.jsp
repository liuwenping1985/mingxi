<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
	

</script>
<style type="text/css">
select{
	width: 100%; 
	border: 0px;
}
</style>
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
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>企业门户:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<!-- <input type="text" id="portalName" style="width:100%;" class="validate word_break_all" name="portalName"
									validate="name:'企业门户',notNull:true,minLength:1,maxLength:255"> -->
								<select id="portalName" name="portalName" class="codecfg" style="width: 100%; border: 0px;" 
    							codecfg="codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EnablePortalTypeEnum'" validate="name:'企业门户',notNull:true,minLength:1,maxLength:255" >
								
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>栏目名称:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<!-- <input type="text" id="columnName" style="width:100%;cursor: pointer;" readonly="readonly" class="validate word_break_all" name="columnName"  placeholder="点击选择栏目名称"
									validate="name:'栏目名称',notNull:true,minLength:1,maxLength:255"> -->
								<select id="columnName" name="columnName" class="codecfg" style="width: 100%; border: 0px;" 
    							codecfg="codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalColumnIndustryEnum'" validate="name:'栏目名称',notNull:true,minLength:1,maxLength:255" >
								
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>栏目编码:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="columnCode" style="width:100%;" class="validate word_break_all" name="columnCode"
									validate="name:'栏目编码',notNull:true,minLength:1,maxLength:255,regExp:/^[a-zA-Z0-9_-]*$/,errorMsg:'只允许填写大小写字母、_、-、数字的自由组合！'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>栏目标题:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="columnTitle" style="width:100%;" class="validate word_break_all" name="columnTitle"
									validate="name:'栏目标题',notNull:true,minLength:1,maxLength:255,regExp:/^[a-zA-Z0-9\u4e00-\u9fa5_-]*$/,errorMsg:'只允许填写简体中文、大小写字母、_、-、数字的自由组合！且长度不可超过7！'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><!-- <font color="red">*</font> -->图片规格:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="systemImgSpec" style="width:100%;" class="validate word_break_all" name="systemImgSpec"
									validate="name:'图片规格',notNull:false,minLength:1,maxLength:255,regExp:/^[a-zA-Z0-9\u4e00-\u9fa5_*-]*$/,errorMsg:'只允许填写简体中文、大小写字母、_、-、*、数字的自由组合！'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">更多设置:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="moreSetup" style="width:100%;" class="validate word_break_all" name="moreSetup"
									validate="name:'更多设置',minLength:1,maxLength:255">
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
