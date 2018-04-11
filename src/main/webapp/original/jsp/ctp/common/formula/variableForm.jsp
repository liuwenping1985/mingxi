<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script>
function checkVariableName(){
	var reg= /^[0-9A-Z_]*$/g;
	var a =	reg.test($("#addForm #formulaName").val());
	return a;
}
</script>
</head>
<body>
    <form name="addForm" id="addForm" method="post" target="" class="validate">
	<input type="hidden" id="id" name="id" value="">
	<input type="hidden" id="formulaType" name="formulaType" value="1">
    <div class="form_area" >
	
		<div class="one_row">
		
			<table border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">* </font>${ctp:i18n('ctp.formulas.varAlias')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="formulaAlias" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('ctp.formulas.varAlias')}',notNullWithoutTrim:true,minLength:1,maxLength:20,avoidChar:'-!@#$%><^&amp;*()\'&quot_+'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">* </font>${ctp:i18n('ctp.formulas.varName')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="formulaName" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('ctp.formulas.varName')}',notNull:true,minLength:1,maxLength:40,func:checkVariableName,errorMsg:'${ctp:i18n('ctp.formulas.checkVariableName')}'">
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('ctp.formulas.description')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="description" class="validate word_break_all"
									validate="type:'string',name:'${ctp:i18n('ctp.formulas.description')}'">
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">* </font>${ctp:i18n('ctp.formulas.dataType')}:</label></th>
						
						<td width="100%">
							<div>
								<select id="dataType" name="dataType" class="codecfg"
									codecfg="codeType:'java',codeId:'com.seeyon.ctp.common.formula.enums.DataType',defaultValue:''">
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">* </font>${ctp:i18n('ctp.formulas.formulaExpression')}:</label></th>
						<td>
							<div class="common_txtbox  clearfix">
								<textarea rows="5" class="w100b validate word_break_all" id="formulaExpression" validate="type:'string',name:'${ctp:i18n('ctp.formulas.formulaExpression')}',notNull:true,maxLength:1000"></textarea>
							</div>
						</td>
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