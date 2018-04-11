
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums,com.seeyon.ctp.form.util.*"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title></title>
</head>
<body scroll="no" style="overflow: hidden;">
<Table cellSpacing="0" cellPadding="0"  width="100%" border="0"
	   height="100%" class="popupTitleRight font_size12 margin_t_10">
	<tr height="15">
		<td>&nbsp</td>
	</tr>
	<tr>
		<td>
			<fieldset  style="margin-left:32px;margin-right:30px" class="form_area padding_5 margin_t_5">
				<legend>&nbsp;
					<c:if test="${actionType eq 'message'}">${ctp:i18n('form.trigger.triggerset.message.content')} </c:if>
					<c:if test="${actionType eq 'calculate'}">${ctp:i18n('form.query.label.condition')}</c:if>
					&nbsp;
				</legend>
			<div style="height: 370px;overflow: auto;">
				<table id="setDataFilterTr" border="0" cellspacing="0" cellpadding="0" width="430" style="overflow: auto;" disabled="disabled">
					<tr  height="22" style="margin-top: 5px;">
						<td width="40%" class="target" style="margin-top: 5px;">
							<div>
								<table>
									<tr>
										<td align="center" width="20" class="padding_t_10">&nbsp;</td>
										<td width="400" class="padding_t_10">
											<div class="common_txtbox clearfix">
												<div  class="w100b" style="border-style: none;white-space:pre-wrap " readonly="readonly" disabled="disabled">${rowCondition}</div>
											</div>
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
				</table>
			</div>
			</fieldset>
		</td>
	</tr>
</TABLE>
</BODY>
</HTML>