<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums,com.seeyon.ctp.form.util.*"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>设置关联表单</title>
	<script type="text/javascript" src="${path}/common/form/relation/relationDetailView.js${ctp:resSuffix()}"></script>
	<script>
		var srcFormId = "${srcFormId}";
		var tarFormId = "${tarFormId}";
		var filterOrLink = "${filterOrLink}";
		$(function () {
			$("#btnmodify").click(function () {
				relationEdit(null, srcFormId);
			});
		});

		/**
		 * 数据过滤
		 * @param index
		 */
		function showDataFilterDetail(index){
			var srcFormFildId = $("#srcFormFildId" + index).val();
			messageDataFilter(srcFormId, null, null, null, "relation", null, null, srcFormFildId, null);
		}
	</script>
</head>
<body scroll="no" style="overflow: hidden;">

<div>
<div class="layout clearfix code_list padding_t_5 padding_lr_10" style="height:440px;overflow-y: auto;">
		<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0" class="popupTitleRight font_size12 margin_t_10">
	<tr>
		<td>
			<c:forEach items="${result}" var="relation" varStatus="status">
				<fieldset class="form_area" id="fieldsetArea">
					<legend style="font-size: 14px">&nbsp;&nbsp; ${ctp:i18n('form.trigger.associated.settings')} &nbsp;</legend>
			<table cellSpacing="2" cellPadding="2" width="95%" border="0" id="rtable">
				<%-- 字段名称 --%>
				<tr>
					<td align="right" width="10px" class="padding_t_10">&nbsp;</td>
					<td width="90px" align="right" class="padding_t_10" nowrap="nowrap">${ctp:i18n('form.relation.field.names')}：</td>
					<td width="300px" class="padding_t_10">
						<input type="hidden" id="srcFormFildId${status.index}" value="${relation.srcFormFildId}">
						${relation.relationField}
					</td>
				</tr>


				<%-- 关联表单 --%>
				<tr>
					<td align="right" width="10px" class="padding_t_10">&nbsp;</td>
					<td width="90px" align="right" class="padding_t_10">${ctp:i18n('form.create.input.relation.label') }：</td>
					<td width="300px" class="padding_t_10" style=" white-space:nowrap;overflow:hidden;text-overflow: ellipsis;display: block; " title="${relation.relationForm}">
							${relation.relationForm}
					</td>
					<td width="50px"></td>
				</tr>

				<%-- 关联属性 --%>
				<tr class="relationAttr">
					<td align="right" width="10px" class="padding_t_10">&nbsp;</td>
					<td align="right" class="padding_t_10" title="${ctp:i18n('form.create.input.relation.att.label')}">${ctp:getLimitLengthString(ctp:i18n('form.create.input.relation.att.label'), 14, '...')}：</td>
					<td width="300px" class="padding_t_10">
						${relation.relationAttrbute}
					</td>
				</tr>

				<c:if test="${relation.relationChoiceType eq 'system'}">
				<%-- 关联条件 --%>
				<tr class="relationAttr">
					<td align="right" width="10px" class="padding_t_10">&nbsp;</td>
					<td align="right" class="padding_t_10" title="${ctp:i18n('form.relation.condition.label')}">${ctp:getLimitLengthString(ctp:i18n('form.relation.condition.label'), 14, '...')}：</td>

					<td width="300px" class="padding_t_10">
						<div>
							<a onclick="setRelationFormView(srcFormId,tarFormId,null,null,'relation',null,'link','${relation.srcFormFildId}',null)">[${ctp:i18n('form.data.refresh.fail.detail.label')}]</a>
						</div>
					</td>
				</tr>
				</c:if>

				<%--数据过滤,要判断用户选择才判断--%>
				<c:if test="${relation.relationChoiceType eq 'use'}">
				<tr id="setDataFilterTr">
					<td align="right" width="10" class="padding_t_10">&nbsp;</td>
					<td align="right" class="padding_t_10">${ctp:i18n('form.operhigh.dataarea.label')}：</td>
					<td class="padding_t_10">
						<c:if test="${relation.hasDataFilter == true}">
						[<a id="setDataFilterBtn" href="javascript:void(0)" onclick="showDataFilterDetail(${status.index})">${ctp:i18n('form.data.refresh.fail.detail.label')}</a>]
						</c:if>
						<c:if test="${relation.hasDataFilter == false}"><span>[${ctp:i18n('form.format.flowprocessoption.none')}]</span></c:if>
					</td>
					<td></td>
				</tr>
				</c:if>

			</table>
				</fieldset>
				<br>
			</c:forEach>
		</td>
	</tr>
</TABLE>
</div>
</div>
</BODY>

<script type="text/javascript" src="${path}/common/form/design/designBaseInfo.js${ctp:resSuffix()}"></script>
</HTML>