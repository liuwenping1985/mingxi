<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="../edocHeader.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<c:if test="${v3x:hasPlugin('edoc')}">
<c:set var="hasPlugin" value="true" />
</c:if>
<script type="text/javascript">

<!--
	//getDetailPageBreak();

	var _status = "${status}";
	var _yearEnabled = "${markDef.yearEnabled}";
	var _expression = "${markDef.expression}";
	var _length = "${markDef.length}";
	var _yearEnabled1 = "${sendMarkDef.yearEnabled}";
	var _yearEnabled2 = "${recieveMarkDef.yearEnabled}";
	var _yearEnabled3 = "${signReportMarkDef.yearEnabled}";
	var _expression1 = "${sendMarkDef.expression}";
	var _expression2 = "${recieveMarkDef.expression}";
	var _expression3 = "${signReportMarkDef.expression}";
	var _length1 = "${sendMarkDef.length}";
	var _length2 = "${recieveMarkDef.length}";
	var _length3 = "${signReportMarkDef.length}";
	function back(){
		parent.location.href="<html:link renderURL='/edocController.do' />?method=sysCompanyMain";
	}
//-->
</script>
<body scroll="no" onload="initInnerMark('${hasPlugin}');"> 
<form name="myform" method="post">
<input type="hidden" id="yearNo" name="yearNo" value="${yearNo}">
<input type="hidden" name="status" value="${status}">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	
	<tr>
		<td class="" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
		<table width="100%" height="100%" border="0" cellspacing="0"
			cellpadding="0">
			<tr>
				<td class="categorySet-1" width="4"></td>
				<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="edoc.docmark.inner.title" /></td>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space" align="right">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>

	<tr>
		<td class="categorySet-head">
		<div class="categorySet-body">
		
<table width="100%" height="60%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr valign="middle">

		<td width="10%" valign="top">
			<table width="95%" border="0" cellspacing="0" cellpadding="3" align="center">
				<tr><td nowrap><label for="type1"><input type="radio" value="1" name="type" id="type1" onclick="changeInnerMarkType('${hasPlugin}');" <c:if test="${status >= 2}">checked</c:if>> <fmt:message key="edoc.docmark.inner.separate" /></label> </td></tr>	
				<tr><td nowrap><label for="type0"> <input type="radio" value="0" name="type" id="type0" onclick="changeInnerMarkType('${hasPlugin}');" <c:if test="${status < 2}">checked</c:if>> <fmt:message key="edoc.docmark.inner.unification" /></label> </td></tr>					
			</table>
		</td>

		<td width="90%" valign="middle">
		<div id="unification_div">
		<fieldset style="width:85%" align="center"><legend><strong><fmt:message key="edoc.docmark.inner.unification" /></strong></legend>
		<table width="85%" border="0" cellspacing="5" cellpadding="0"
			align="center">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td class="label" align="right" width="20%"><font color="red">*</font><fmt:message key="edoc.docmark.inner.prefix" />:</td>
				<td class="new-column" nowrap="nowrap" width="80%">
				<input type="text" id="wordNo" name="wordNo" value="${markDef.wordNo}" class="input-20per" validate="notNull" onkeyup="previewInnerMark('');"/>					
					<label for="yearEnabled">
					<input type="checkbox" id="yearEnabled" name="yearEnabled" value="1" checked="true" onclick="previewInnerMark('');"><fmt:message key="edoc.docmark.sortbyyear" />
					</label>
				</td>
			</tr>
			<tr>
				<td class="label" align="right"><font color="red">*</font><fmt:message key="edoc.docmark.flowNo" />:</td>
				<td>
					<table border="0" width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="16%" align="center" nowrap><fmt:message key="edoc.docmark.minNo" />
							</td>
							<td width="10%" align="center" nowrap>
							<input type="text" id="minNo" name="minNo" size="5" maxlength="9" value="${markDef.minNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" onkeyup="previewInnerMark('');">
							</td>
							<td width="15%" align="center" nowrap><fmt:message key="edoc.docmark.maxNo" />
							</td>
							<td width="10%" align="center" nowrap>
							<input type="text" id="maxNo" name="maxNo" size="9" maxlength="9" value="${markDef.maxNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" onkeyup="previewInnerMark('');">
							</td>
							<td width="15%" align="center" nowrap><fmt:message key="edoc.docmark.currentNo" />
							</td>
							<td width="10%" align="center">
							<input type="text" id="currentNo" name="currentNo" size="9" maxlength="9" value="${markDef.currentNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" onkeyup="previewInnerMark('');">
							</td>
							<td nowrap>
							<label for="fixedLength">
							<input type="checkbox" id="fixedLength" name="fixedLength" checked onclick="setFixedLength2('');"><fmt:message key="edoc.docmark.fixedlength" />
							</label>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="label" align="right"><fmt:message key="edoc.docmark.doctype" />:</td>
				<td>
					<table border="0" width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="16%" align="center" id="wordNo_a" name="wordNo_a">
							</td>
							<td width="10%" align="center">
							<input type="text" id="format_a" name="format_a" size="5" onkeyup="previewInnerMark('');"/>
							</td>
							<td id="yearNo_a" name="yearNo_a" width="15%" align="center">
							</td>
							<td width="10%" align="center">
							<input type="text" id="format_b" name="format_b" size="5" onkeyup="previewInnerMark('');"/>
							</td>
							<td width="15%" id="flowNo_a" name="flowNo_a" align="center">
							</td>
							<td class="new-column" nowrap="nowrap" width="10%">
							<input type="text" id="format_c" name="format_c" size="5" onkeyup="previewInnerMark('');"/>
							</td>
						</tr>
					</table>				
				</td>
			</tr>
			<tr>
				<td class="label" align="right"><fmt:message key="edoc.docmark.preview" />:</td>
				<td id="wordNoPreview" name="wordNoPreview" >&nbsp;
				</td>
				<input type="hidden" name="markNo" id="markNo">
				<input type="hidden" name="length" id="length">
				<input type="hidden" name="expression" id="expression">				
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		</fieldset>
		</div>

		<div id="separate_div">
		<c:if test="${v3x:hasPlugin('edoc')}">
		<fieldset style="width:85%" align="center"><legend><strong><fmt:message key="edoc.docmark.inner.send" /></strong></legend>
		<table width="85%" border="0" cellspacing="5" cellpadding="0"
			align="center">
			<tr>
				<td class="label" align="right" width="20%"><font color="red">*</font><fmt:message key="edoc.docmark.inner.prefix" />:</td>
				<td class="new-column" nowrap="nowrap" width="80%">
				<input type="text" id="send_wordNo" name="send_wordNo" value="${sendMarkDef.wordNo}" class="input-20per" onkeyup="previewInnerMark('send_');"/>
				<label for="send_yearEnabled">
				<input type="checkbox" name="send_yearEnabled" checked id="send_yearEnabled" onclick="previewInnerMark('send_');"><fmt:message key="edoc.docmark.sortbyyear" />
				</label>
				</td>
			</tr>
			<tr>
				<td class="label" align="right"><font color="red">*</font><fmt:message key="edoc.docmark.flowNo" />:</td>
				<td>
				<table border="0" width="100%" cellpadding="0" cellspacing="0">
					<tr>
					<td width="16%" align="center" nowrap><fmt:message key="edoc.docmark.minNo" />
					</td>
					<td width="10%" align="center" nowrap>
					<input type="text" id="send_minNo" name="send_minNo" size="5" maxlength="9" value="${sendMarkDef.minNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" onkeyup="previewInnerMark('send_');">
					</td>
					<td width="15%" align="center" nowrap><fmt:message key="edoc.docmark.maxNo" />
					</td>
					<td width="10%" align="center" nowrap>
					<input type="text" id="send_maxNo" name="send_maxNo" size="9" maxlength="9" value="${sendMarkDef.maxNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" onkeyup="previewInnerMark('send_');">
					</td>
					<td width="15%" align="center" nowrap><fmt:message key="edoc.docmark.currentNo" />
					</td>
					<td width="10%" align="center" nowrap>
					<input type="text" id="send_currentNo" name="send_currentNo" size="9" maxlength="9" value="${sendMarkDef.currentNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" onkeyup="previewInnerMark('send_');">
					</td>
					<td nowrap>
					<label for="send_fixedLength">
					<input type="checkbox" name="send_fixedLength" id="send_fixedLength" checked onclick="setFixedLength2('send_');"><fmt:message key="edoc.docmark.fixedlength" />
					</label>
					</td>
					</tr>
					</table>				
				</td>
			</tr>
			<tr>
				<td class="label" align="right"><fmt:message key="edoc.docmark.doctype" />:</td>
				<td>
					<table border="0" width="100%" cellpadding="0" cellspacing="0">
					<tr>
					<td width="16%" align="center" id="send_wordNo_a" name="send_wordNo_a">
					</td>
					<td width="10%" align="center">
					<input type="text" id="send_format_a" name="send_format_a" size="5" onkeyup="previewInnerMark('send_');"/>
					</td>
					<td id="send_yearNo_a" name="send_yearNo_a" width="15%" align="center">
					</td>
					<td width="10%" align="center">
					<input type="text" id="send_format_b" name="send_format_b" size="5" onkeyup="previewInnerMark('send_');"/>
					</td>
					<td width="15%" id="send_flowNo_a" name="send_flowNo_a" align="center">
					</td>
					<td class="new-column" nowrap="nowrap" width="10%">
					<input type="text" id="send_format_c" name="send_format_c" size="5" onkeyup="previewInnerMark('send_');"/>
					</td>					
					</tr>
					</table>				
				</td>
			</tr>
			<tr>
				<td class="label" align="right"><fmt:message key="edoc.docmark.preview" />:</td>
				<td id="send_wordNoPreview" name="send_wordNoPreview" >&nbsp;
				</td>
				<input type="hidden" name="send_markNo" id="send_markNo">
				<input type="hidden" name="send_length" id="send_length">				
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>		
		</fieldset>
		</p>

		<fieldSet style="width:85%" align="center"><legend><strong><fmt:message key="edoc.docmark.inner.receive" /></strong></legend>
		<table width="85%" border="0" cellspacing="5" cellpadding="0"
			align="center">
			<tr>
				<td class="label" align="right" width="20%"><font color="red">*</font><fmt:message key="edoc.docmark.inner.prefix" />:</td>
				<td class="new-column" nowrap="nowrap" width="80%">
				<input type="text" id="receive_wordNo" name="receive_wordNo" value="${recieveMarkDef.wordNo}" class="input-20per" onkeyup="previewInnerMark('receive_');"/>
				<label for="receive_yearEnabled">
				<input type="checkbox" id="receive_yearEnabled" name="receive_yearEnabled" onclick="previewInnerMark('receive_');" checked><fmt:message key="edoc.docmark.sortbyyear" />
				</label>
				</td>
			</tr>
			<tr>
				<td class="label" align="right"><font color="red">*</font><fmt:message key="edoc.docmark.flowNo" />:</td>
				<td>
					<table border="0" width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="16%" align="center" nowrap><fmt:message key="edoc.docmark.minNo" />
							</td>
							<td width="10%" align="center" nowrap>
							<input type="text" id="receive_minNo" name="receive_minNo" size="5" maxlength="9" value="${recieveMarkDef.minNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" style="ime-mode:Disabled" onkeyup="previewInnerMark('receive_');">
							</td>
							<td width="15%" align="center" nowrap><fmt:message key="edoc.docmark.maxNo" />
							</td>
							<td width="10%" align="center" nowrap>
							<input type="text" id="receive_maxNo" name="receive_maxNo" size="5" maxlength="9" value="${recieveMarkDef.maxNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" style="ime-mode:Disabled" onkeyup="previewInnerMark('receive_');">
							</td>
							<td width="15%" align="center"><fmt:message key="edoc.docmark.currentNo" />
							</td>
							<td width="10%" align="center" nowrap>
							<input type="text" id="receive_currentNo" name="receive_currentNo" size="5" maxlength="9" value="${recieveMarkDef.currentNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" style="ime-mode:Disabled" onkeyup="previewInnerMark('receive_');">
							</td>
							<td nowrap>
							<label for="receive_fixedLength">
							<input type="checkbox" name="receive_fixedLength" id="receive_fixedLength" checked onclick="setFixedLength2('receive_');"><fmt:message key="edoc.docmark.fixedlength" />
							</label>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="label" align="right"><fmt:message key="edoc.docmark.doctype" />:</td>
				<td>
					<table border="0" width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="16%" align="center" id="receive_wordNo_a" name="receive_wordNo_a">
							</td>
							<td width="10%" align="center">
							<input type="text" id="receive_format_a" name="receive_format_a" size="5" onkeyup="previewInnerMark('receive_');"/>
							</td>
							<td id="receive_yearNo_a" name="receive_yearNo_a" width="15%" align="center">
							</td>
							<td width="10%" align="center">
							<input type="text" id="receive_format_b" name="receive_format_b" size="5" onkeyup="previewInnerMark('receive_');"/>
							</td>
							<td width="15%" id="receive_flowNo_a" name="receive_flowNo_a" align="center">
							</td>
							<td class="new-column" nowrap="nowrap" width="10%">
							<input type="text" id="receive_format_c" name="receive_format_c" size="5" onkeyup="previewInnerMark('receive_');"/>
							</td>
						</tr>
					</table>				
				</td>
			</tr>
			<tr>
				<td class="label" align="right"><fmt:message key="edoc.docmark.preview" />:</td>
				<td id="receive_wordNoPreview" name="receive_wordNoPreview" >&nbsp;
				</td>
				<input type="hidden" value="" name="receive_markNo" id="receive_markNo">
				<input type="hidden" value="" name="receive_length" id="receive_length">				
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		</fieldSet>
		</p>
	</c:if>
		<fieldset style="width:85%" align="center"><legend><strong><fmt:message key="edoc.docmark.inner.signandreport" /></strong></legend>
		<table width="85%" border="0" cellspacing="5" cellpadding="0"
			align="center">
			<tr>
				<td class="label" align="right" width="20%"><font color="red">*</font><fmt:message key="edoc.docmark.inner.prefix" />:</td>
				<td class="new-column" nowrap="nowrap" width="80%">
				<input type="text" id="sign_report_wordNo" name="sign_report_wordNo" value="${signReportMarkDef.wordNo}" class="input-20per" onkeyup="previewInnerMark('sign_report_');"/>
				<label for="sign_report_yearEnabled">
				<input type="checkbox" name="sign_report_yearEnabled" id="sign_report_yearEnabled" onclick="previewInnerMark('sign_report_');" checked><fmt:message key="edoc.docmark.sortbyyear" />
				</label>
				</td>
			</tr>
			<tr>
				<td class="label" align="right"><font color="red">*</font><fmt:message key="edoc.docmark.flowNo" />:</td>
				<td>
					<table border="0" width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="16%" align="center" nowrap><fmt:message key="edoc.docmark.minNo" />
							</td>
							<td width="10%" align="center" nowrap>
							<input type="text" id="sign_report_minNo" name="sign_report_minNo" size="5" maxlength="9" value="${signReportMarkDef.minNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" onkeyup="previewInnerMark('sign_report_');">
							</td>
							<td width="15%" align="center" nowrap><fmt:message key="edoc.docmark.maxNo" />
							</td>
							<td width="10%" align="center" nowrap>
							<input type="text" id="sign_report_maxNo" name="sign_report_maxNo" size="9" maxlength="9" value="${signReportMarkDef.maxNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" onkeyup="previewInnerMark('sign_report_');">
							</td>
							<td width="15%" align="center" nowrap><fmt:message key="edoc.docmark.currentNo" />
							</td>
							<td width="10%" align="center" nowrap>
							<input type="text" id="sign_report_currentNo" name="sign_report_currentNo" size="9" maxlength="9" value="${signReportMarkDef.currentNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" onkeyup="previewInnerMark('sign_report_');">
							</td>
							<td nowrap>
							<label for="sign_report_fixedLength">
							<input type="checkbox" name="sign_report_fixedLength" id="sign_report_fixedLength" checked onclick="setFixedLength2('sign_report_');"><fmt:message key="edoc.docmark.fixedlength" />
							</label>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="label" align="right"><fmt:message key="edoc.docmark.doctype" />:</td>
				<td>
					<table border="0" width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="16%" align="center" id="sign_report_wordNo_a" name="sign_report_wordNo_a">
							</td>
							<td width="10%" align="center">
							<input type="text" id="sign_report_format_a" name="sign_report_format_a" size="5" onkeyup="previewInnerMark('sign_report_');"/>
							</td>
							<td id="sign_report_yearNo_a" name="sign_report_yearNo_a" width="15%" align="center">
							</td>
							<td width="10%" align="center">
							<input type="text" id="sign_report_format_b" name="sign_report_format_b" size="5" onkeyup="previewInnerMark('sign_report_');"/>
							</td>
							<td width="15%" id="sign_report_flowNo_a" name="sign_report_flowNo_a" align="center">
							</td>
							<td class="new-column" nowrap="nowrap" width="10%">
							<input type="text" id="sign_report_format_c" name="sign_report_format_c" size="5" onkeyup="previewInnerMark('sign_report_');"/>
							</td>
						</tr>
					</table>				
				</td>
			</tr>
			<tr>
				<td class="label" align="right"><fmt:message key="edoc.docmark.preview" />:</td>
				<td id="sign_report_wordNoPreview" name="sign_report_wordNoPreview" >&nbsp;
				</td>
				<input type="hidden" name="send_markNo" id="send_markNo">
				<input type="hidden" name="send_length" id="send_length">	
				<input type="hidden" name="receive_markNo" id="receive_markNo">
				<input type="hidden" name="receive_length" id="receive_length">	
				<input type="hidden" name="sign_report_markNo" id="sign_report_markNo">
				<input type="hidden" value="" name="sign_report_length" id="sign_report_length">	
				<input type="hidden" value="" name="send_expression" id="send_expression">	
				<input type="hidden" value="" name="receive_expression" id="receive_expression">	
				<input type="hidden" value="" name="sign_report_expression" id="sign_report_expression">
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		</fieldset>
		</div>
		</td>
	</tr>	
</table>
		</div>
		</td>
	</tr>

	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" 		class="button-default_emphasize" onclick="saveInnerMarkDef();">&nbsp;&nbsp;			
			<input type="button" onclick="back()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2"></td>
	</tr>
</table>
</form>

</body>
</html>