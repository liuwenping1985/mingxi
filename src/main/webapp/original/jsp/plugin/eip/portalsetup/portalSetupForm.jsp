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
					<input type="hidden" id="templateId" name="templateId" value="">
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>门户编码:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="portalCode" style="width:100%;" class="validate word_break_all" name="portalCode"
									validate="name:'门户编码',notNull:true,minLength:1,maxLength:255,regExp:/^[a-zA-Z0-9_-]*$/,errorMsg:'只允许填写大小写字母、_、-、数字的自由组合！'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>门户名称:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="portalName" style="width:100%;" class="validate word_break_all" name="portalName"
									validate="name:'门户名称',notNull:true,minLength:1,maxLength:255,regExp:/^[a-zA-Z0-9\u4e00-\u9fa5_-]*$/,errorMsg:'只允许填写简体中文、大小写字母、_、-、数字的自由组合！'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>门户模板:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="templateCode" readonly="readonly" style="width:100%;cursor: pointer;" class="validate word_break_all" name="templateCode" placeholder="点击选择门户模板"
									validate="name:'门户模板',notNull:true,minLength:1,maxLength:255,regExp:/^[a-zA-Z0-9_-]*$/">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>授权:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="empowerIds" name="empowerIds" readonly="readonly" class="comp" style="width:100%;cursor: pointer;" placeholder="点击授权"
     						comp="name:'授权',type:'selectPeople',notNull:true,mode:'open',panels: 'Account,Department,Team,Post,Level,Outworker',selectType: 'Account,Team,Post,Level,Outworker,Department,Member',
     						value:'',text:''"/>
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
					
				</tbody>
			</table>
		</div>
		</div>
	</form>


</body>
</html>