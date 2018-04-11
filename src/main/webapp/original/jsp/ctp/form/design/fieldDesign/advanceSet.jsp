<%--
 $Author: dengxj $
 $Rev: 603 $
 $Date:: 2012-11-19
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>计算公式设置</title>
</head>
<body>
<div id="headerDiv">
	<table align="center" width="100%" height="90%" style="table-layout:fixed;">
		<tr id="digitSet" class="font_size12" height="40" valign="middle">
			<td width="100%" align="left" colspan="3">
				<label for="normalSet">
					<input type="radio" id="digitNormalSet" name="normalSet" value="1" /><span id="modelSetText" class="font_size12 margin_5">${ctp:i18n('form.field.formula.nomal.set')}</span>
				</label> &nbsp;&nbsp;&nbsp;&nbsp; 
				<label for="advancedSet"> 
					<input type="radio" id="digitAdvancedSet" name="normalSet" checked="checked" value="2" /><span id="advancedSetText" class="font_size12 margin_5">${ctp:i18n('form.field.formula.advance.set')}</span>
				</label>
			</td>
		</tr>
		<tr  id="digitAdvacedSet">
			<table id="setArea" class="margin_5">
				<tr scope="advancedTextField">
					<td valign="top" width="12%" height="100%" align="right" class=" padding_t_5 padding_r_5">
					<span id="add" onClick="addRow(this);"  class="ico16 repeater_plus_16"></span><br><br>
					<span id="del" onClick="delRow(this);"  class="ico16 repeater_reduce_16"></span>
					</td>
					<td valign="top" width="8%" height="100%" align="right" class="padding_t_5"><span class="font_size12 padding_r_5">&nbsp;${ctp:i18n("form.highAuthDesign.if")}</span> </td>
					<td valign="middle" width="27%" height="100%" align="left" class="padding_t_5">
					<textarea id='ifFormField' name="ifFormField" readonly="true" cols="25" rows="5" class="input-100" onclick="setCondition(this)"></textarea>
					</td>
					<td valign="top" width="10%" height="100%" align="right" class="padding_t_5"><span class="font_size12 padding_r_5">&nbsp;${ctp:i18n("form.field.formula.elseif.set")} </span> </td>
					<td width="43%" valign="middle" align="left" class=" padding_t_5">
					<textarea id="resultFormField" name="resultFormField" readonly="true" cols="25" rows="5" class="input-100" onclick="setResult(this)"></textarea>
					</td>
				</tr>
				<tr scope="advancedTextField">
					<td colspan="2" valign="top" width="20%" height="100%" class="padding_t_5">&nbsp;</td>
					<td valign="top" width="27%" height="100%" class="padding_t_5">
						<textarea id="lastifFormField" name="lastifFormField" cols="25" value="0" rows="5" class="input-100" style="display:none;"></textarea>
					</td>
					<td valign="top" width="10%" height="100%" align="right" class="padding_t_5"><span class="font_size12 padding_r_5">${ctp:i18n('form.field.formula.else.set')}&nbsp;</span></td>
					<td width="43%" valign="middle" align="left" class="padding_t_5">
						<textarea id="lastresultFormField" name="lastresultFormField" readonly="true" cols="25" rows="5" class="input-100" onclick="setResult(this)"></textarea>	
					</td>
				</tr>
			</table>
		</tr>
	</table>
	</div>
	<div id="bottomDiv" class="stadic_layout_footer">
	<table><tr><td><a id="abandon" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('form.trigger.triggerSet.reset.label')}</a></td></tr></table>
	</div>
	<%@ include file="../../common/common.js.jsp" %>
	<%@ include file="advanceSet.js.jsp" %>
</body>
</HTML>