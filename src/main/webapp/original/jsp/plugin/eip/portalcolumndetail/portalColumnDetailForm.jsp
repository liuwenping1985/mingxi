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
					<input type="hidden" name="columnId" id="columnId" value="" />
					<input type="hidden" name="backUpValue0" id="backUpValue0" value="1" /><!-- 自定义数据 -->
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>栏目名称:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<!-- <input type="text" id="columnName" style="width:100%;cursor: pointer;" readonly="readonly" class="validate word_break_all" name="columnName"  placeholder="点击选择栏目名称"
									validate="name:'栏目名称',notNull:true,minLength:1,maxLength:255"> -->
								<select id="columnName" name="columnName" class="codecfg" style="width: 100%; border: 0px;" 
    							codecfg="codeType:'java',codeId:'com.seeyon.apps.cip.eip.enums.EipPortalUserColumnEnum'" validate="name:'栏目名称',notNull:true,minLength:1,maxLength:255" >
								
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>内容标题:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="columnDetailTitle" style="width:100%;" class="validate word_break_all" name="columnDetailTitle"
									validate="name:'内容标题',notNull:true,minLength:1,maxLength:255,regExp:/^[a-zA-Z0-9\u4e00-\u9fa5_-]*$/,errorMsg:'只允许填写简体中文、大小写字母、_、-、数字的自由组合！'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>内容URL:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="columnDetailUrl" style="width:100%;" class="validate word_break_all" name="columnDetailUrl"
									validate="name:'内容URL',notNull:true,minLength:1,maxLength:255">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">更多设置:</label></th>
						<td width="100%" >
							<div class="common_txtbox_wrap">
								<input type="text" id="moreSetup" style="width:100%;" class="validate word_break_all" name="moreSetup"
									validate="name:'更多设置',minLength:1,maxLength:255,regExp:/^(http|https):\/\/[a-zA-Z0-9]+[.]+[a-zA-Z0-9]+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])*$/">
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