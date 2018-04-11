<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="w100b h100b">
<head>
<script type="text/javascript">
//单据id
var formDefId = "${formDefId}";
</script>
<script type="text/javascript" src="${path}/common/workflow/dynamicform/flowDynamicFormSet.js${ctp:resSuffix()}"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body class="page_color font_size12 w100b h100b">
<div id="flowFormDataId" style="overflow:auto; padding-bottom:10px;">
	<c:forEach var="fbvo" varStatus="status" items="${fv}">
		<div class="dynamicFormDiv" name="dynamicFormDiv">
		<span class='ico16 outIcon repeater_reduce_16' name="deleteBlock" onclick="deleteBlock(this);"></span>
		<span class='ico16 outIcon repeater_plus_16' name="addBlock" onclick="addBlock(this);"></span>
		<fieldset>
		<table width="95%" border="0">
			<tr height="20"> 
				<td class="bg-gray font_size14" width="90" nowrap="nowrap" align ="left">${ctp:i18n('common.detail.label.dynamicForm.form')}</td>
				<td class="bg-gray " width="210" nowrap="nowrap" align ="left">
					<input type="text" class="font_size14" style="width:200px" name="dynamicFormName" readonly="readonly" value="${fbvo.dFname }" /> 
					<input type="hidden" name="dynamicFormId" value="${fbvo.dFid }" /> 
				</td>
				<td class="bg-gray" nowrap="nowrap" align ="left">
					<input type="button" value="${ctp:i18n('common.detail.label.button.choose')}"  class="common_button common_button_emphasize hand" onclick="chooseDynamicDateForm(this);"></input>
				</td>
			</tr>	
			<tr height="25">
				<td class="bg-gray font_size14" colspan="3" align ="left">${ctp:i18n('common.detail.label.dynamicForm.customcondition')}</td>
			</tr>	
		</table>
		<div style="overflow-y:auto">
		<table id="fieldAreaContent" width="95%" name="fieldAreaContent"  cellspacing="0" cellpadding="0">
			<tr height="35">
				<td colspan="2" class="font_bold font_size14" align ="left">${ctp:i18n('common.detail.label.dynamicForm.form.data')}</td>
				<td colspan="2" class="font_bold font_size14" align ="left">${ctp:i18n('common.detail.label.dynamicForm.cur.data')}</td>
				<td width="100">&nbsp;</td>
			</tr>
			<c:forEach var="svo" varStatus="status" items="${fbvo.dFcurOption}">
			<tr height="30">
				<td width="200">
					<select class="w100b"  name="dynamicField" onchange="filterCurFormFiled(this);">
						<option value='' >${ctp:i18n('common.pleaseSelect.label')}</option>
						<c:forEach var="eachoption" varStatus="status" items="${fbvo.dynamicFormAlloption}">
						<option <c:if test="${svo.optionValue eq eachoption.optionValue }">selected</c:if> value="${eachoption.optionValue }" displayName="${eachoption.optionDisplay }">${eachoption.optionDisplay}</option>
						</c:forEach>
					</select>
				</td>
				<td width="50" align="center">=</td>
				<td width="200">
					<input class="w100b" type="text" value="${svo.curFormDisplay}" name='curFormFieldshow' onclick="bindFormField(this);" readonly="readonly" />
					<input type="hidden" name='curFormField' value="${svo.curFormValue}" />
				</td>
				<td width="80" align="center">
					<input  class="w50b align_center" type="text" readonly value="and" />
				</td>
				<td>
					<span class='ico16 repeater_reduce_16' name="delField" onclick="deleteTr(this);"></span><span class='ico16 repeater_plus_16' name="addField" onclick="insertTr(this);"></span>
	         	</td>
			</tr>
			</c:forEach>		
	    </table>
		</div>
		</fieldset>	
		</div>
	</c:forEach>
	<c:if test="${empty fv }">
	<div class="dynamicFormDiv"  name="dynamicFormDiv">
		<span class='ico16 outIcon repeater_reduce_16' name="deleteBlock" onclick="deleteBlock(this);"></span>
		<span class='ico16 outIcon repeater_plus_16' name="addBlock" onclick="addBlock(this);"></span>
		<fieldset>
		<table width="95%" border="0">
			<tr height="35">
				<td class="bg-gray font_size14" width="90" nowrap="nowrap" align ="left">${ctp:i18n('common.detail.label.dynamicForm.form')}</td>
				<td class="bg-gray " width="210" nowrap="nowrap" align ="left">
					<input type="text" class="font_size14" style="width:200px" readonly="readonly" name="dynamicFormName" />
				</td>
				<td class="bg-gray" nowrap="nowrap" align ="left">
					<input type="button" value="${ctp:i18n('system.phrase.chosce')}" class="common_button common_button_emphasize hand" onclick="chooseDynamicDateForm(this);"></input>
				</td>
			</tr>	
			<tr height="25">
				<td class="bg-gray font_size14" colspan="3" align ="left">${ctp:i18n('common.detail.label.dynamicForm.customcondition')}</td>
			</tr>		
		</table>
		<div style="overflow-y:auto">
		<table id="fieldAreaContent" width="95%" name="fieldAreaContent"  cellspacing="0" cellpadding="0">
			<tr height="35">
				<td colspan="2" class="font_bold font_size14" align ="left">${ctp:i18n('common.detail.label.dynamicForm.form.data')}</td>
				<td colspan="2" class="font_bold font_size14" align ="left">${ctp:i18n('common.detail.label.dynamicForm.cur.data')}</td>
				<td width="100">&nbsp;</td>
			</tr>
			<tr height="30">
				<td width="200">
					<select class="w100b"  name="dynamicField" onchange="filterCurFormFiled(this);">
						<option value='' displayName=''>${ctp:i18n('common.pleaseSelect.label')}</option>
					</select>
				</td>
				<td width="50" align="center">=</td>
				<td width="200">
					<input class="w100b" type="text" name='curFormFieldshow' onclick="bindFormField(this);" readonly="readonly" />
					<input type="hidden" name='curFormField' />
				</td>
				<td width="80" align="center">
					<input  class="w50b align_center" type="text" readonly value="and" />
				</td>
				<td>
					<span class='ico16 repeater_reduce_16' name="delField" onclick="deleteTr(this);"></span><span class='ico16 repeater_plus_16' name="addField" onclick="insertTr(this);"></span>
	         	</td>
			</tr>		
	    </table>
		</div>
		</fieldset>	
		</div>
	</c:if>
</div>
<p style="color:red; line-height:28px; text-align:center;">${ctp:i18n('common.detail.label.dynamicForm.notice')}</p>
</body>
</html>