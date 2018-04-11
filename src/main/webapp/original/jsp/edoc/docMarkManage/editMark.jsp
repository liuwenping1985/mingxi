<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@ include file="../edocHeader.jsp"%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/selectbox.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--	

	function setPeopleFields(elements){
		if(elements){
			var obj1 = getNamesString(elements);
			var obj2 = getIdsString(elements,false);
			document.getElementById("depart").value = getNamesString(elements);
			document.getElementById("grantedDepartId").value = getIdsString(elements,true);
		}
	}


	// �������ˮ�Ź������
	function manageBigStreamPage() {
		
		//大流水号新建和编辑窗口
		var bigStreamWin = getA8Top().$.dialog({
	        
	        title:'<fmt:message key="edoc.docmark.title" />',
	        url: edocMarkURL + "?method=manageBigStreamIframe",
	        targetWindow : getA8Top(),
	        width:"650",
	        height:"300",
	        closeParam:{
	            show:true,
	            autoClose:false,
	            handler:function() {
	            	bigStreamWin.close();
	            	var a = detailForm.categoryId.options[detailForm.categoryId.options.selectedIndex].value;
	                $(function(){
	                    var options = {
	                        url: '${mark}?method=changeBigStreamOptions',
	                        params: {},
	                        success: function(json) {
	                            var options = '<option value="0" selected><fmt:message key="edoc.docmark.selectbigstream"/></option>';                  
	                            for (var i = 0; i < json.length; i++) {                     
	                                options += '<option temp_minNo="' + json[i].optionMinNo + '" temp_maxNo="' + json[i].optionMaxNo + '" temp_curNo="' + json[i].optionCurrentNo + '" temp_yearEnabled="' + json[i].optionYearEnabled + '" temp_readonly="' + json[i].optionReadonly + '" value="' + json[i].optionValue + '">' + json[i].optionName + '</option>';
	                            }
	                            $("select#categoryId").html(options);
	                            $("select#categoryId").handle(returnFromBigStreamListPage(a));
	                        }
	                    };
	                    getJetspeedJSON(options);           
	                }); 
	            }
	        }
	    });
	}
	
	$(function(){
		$("#categorySetBody").hide().height($("#categorySetTd").height()).show();
		$(window).resize(function() {
			$("#categorySetBody").hide().height($("#categorySetTd").height()).show();
		})
	})
	
	showAccountShortname_grantedDepartId = "auto";
	var showDepartmentMember4Search_grantedDepartId = true;
	
//-->
</script>
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<style>
	input,select {
		height: 22px;
	}

</style>
</head>
<c:set value="${v3x:showOrgEntities(elements, 'deptId', 'aclType', pageContext)}" var="authStr"/>
<c:set value="${v3x:parseElements(elements, 'deptId', 'aclType')}" var="authIds"/>
<v3x:selectPeople id="grantedDepartId" panels="Department" selectType="Account,Department" minSize="0" jsFunction="setPeopleFields(elements)" originalElements="${authIds}" />
<body class="over_hidden">

<div class="newDiv">

<form name="detailForm" method="post">
<input type="hidden" id="yearNo" name="yearNo" value="${yearNo}">
<input type="hidden" id="id" name="id" value="${markDef.id}">
<input type="hidden" id="appName" name="appName" value="<%=ApplicationCategoryEnum.edoc.getKey()%>">
<input type="hidden" id ="orgAccountId" name="orgAccountId" value="${v3x:currentUser().loginAccount}">
<input type="hidden" id="oldCodeMode" name="oldCodeMode" value="${markDef.edocMarkCategory.codeMode}">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
<tr align="center">
	<td height="8" class="detail-top">
		<script type="text/javascript">
		getDetailPageBreak(); 
	</script>
	</td>
</tr>		

<tr>
	<td class="categorySet-4" height="8"></td>
</tr>

<tr>
	<td class="categorySet-head" height="23">
		<table width="100%" height="100%" border="0" cellspacing="0"
			cellpadding="0">
			<tr>
				<td class="categorySet-1" width="4"></td>
				<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="edoc.docmark.edit" /></td>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space">&nbsp;</td>
			</tr>
		</table>
	</td>
</tr>

<tr>
	<td id="categorySetTd" class="categorySet-head">
		<div id="categorySetBody" class="categorySet-body overflow_auto" style="padding:0;border-bottom:1px solid #a0a0a0;">
			<table width="650" border="0" cellspacing="0" cellpadding="0" align="center" height="70%">
				<tr>
					<td width="100%" valign="middle">
						<table width="96%" border="0" cellspacing="5" cellpadding="0" align="center">
							<tr><td>&nbsp;</td></tr>
							<%-- 文号类型选择--%>
							<tr>
								<td height="26px" class="label" align="right" width="20%">
									<div class="padding_r_5"><font color="red">*</font><fmt:message key="edoc.element.wordno.type" />:</div>
								</td>
								<td class="new-column" nowrap="nowrap">
									<c:choose>
										<c:when test="${markDef.markType==0}">
											<fmt:message key="edoc.element.wordno.label" />
										</c:when>
										<c:when test="${markDef.markType==1}">
											<fmt:message key="edoc.element.wordinno.label" />
										</c:when>
										<c:when test="${markDef.markType==2}">
											<fmt:message key="exchange.edoc.signingNo" bundle='${exchangeI18N}' />
										</c:when>
									</c:choose>
								</td>
							</tr>		
							<tr>
								<td height="26px" class="label" align="right" width="20%">
									<div class="padding_r_5"><font color="red">*</font><fmt:message key="edoc.docmark.organizationCode" />:</div>
								</td>
								<td class="new-column" nowrap="nowrap">
								<input id="wordNo" name="wordNo" type="text" value="${v3x:toHTMLWithoutSpace(markDef.wordNo)}"
									   maxlength="30"
									   class="input-20per" validate="notNull" onkeyup="previewMark();"
									   inputName = '<fmt:message key="edoc.docmark.wordNo" />'
									   maxSize="30" validate="maxLength" />
								</td>
							</tr>		
							<tr>
								<td height="26px" class="label" align="right">
									<div class="padding_r_5"><font color="red">*</font><fmt:message key="edoc.docmark.codeMode" />:</div>
								</td>
								<td class="new-column" nowrap="nowrap">				
								<label for="flowNoType1">
									<input type="radio" name="flowNoType" id="flowNoType1" value="0" onclick="streamChoose_small(1);" <c:if test="${markDef.edocMarkCategory.codeMode==0}">checked</c:if>><fmt:message key="edoc.docmark.smallstream" />
								</label>
								<label for="flowNoType2">
									<input type="radio" name="flowNoType" id="flowNoType2" value="1" onclick="streamChoose_big();" <c:if test="${markDef.edocMarkCategory.codeMode==1}">checked</c:if>><fmt:message key="edoc.docmark.bigstream" />				
								</label>
								</td>
							</tr>			
							<tr>
								<td height="26px" class="label" align="right" valign="top">
									<div class="padding_r_5"><font color="red">*</font><fmt:message key="edoc.docmark.flowNo" />:</div>
								</td>
								<td>
									<table border="0" width="100%" cellpadding="0" cellspacing="0">
										<tr id="bigStream" style="display:none">
											<td height="26px" colspan="6" class="new-column" nowrap="nowrap">
												<select style="width:150px;" name="categoryId" id="categoryId" onchange="changeBigStream();">
													<option value="0"><fmt:message key="edoc.docmark.selectbigstream"/></option>
												<c:forEach items="${categories}" var="category">	
													<option value="${category.id}" temp_minNo="${category.minNo}" temp_maxNo="${category.maxNo}" temp_curNo="${category.currentNo}" temp_yearEnabled="${category.yearEnabled}" temp_readonly="${category.readonly}" <c:if test="${category.id==markDef.edocMarkCategory.id}">selected</c:if>>${category.categoryName}</option>
												</c:forEach>
												</select>&nbsp;&nbsp;<input type="button" id="categoryButton" name="categoryButton" value="<fmt:message key="edoc.docmark.createandedit" />" onclick="manageBigStreamPage();">
											</td>
										</tr>
										<tr id="hiddentr1">
											<td height="26px" width="14%" align="center"><fmt:message key="edoc.docmark.minNo" />
											</td>
											<td width="10%" align="center">
												<input id="minNo" name="minNo" type="text" size="5" maxlength="9" value="${markDef.edocMarkCategory.minNo}" 
												onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
												ondragenter="return false" style="ime-mode:Disabled" onkeyup="previewMark();">
											</td>
											<td width="14%" align="center"><fmt:message key="edoc.docmark.maxNo" />
											</td>
											<td width="10%" align="center">
												<input id="maxNo" name="maxNo" type="text" size="9" maxlength="9" value="${markDef.edocMarkCategory.maxNo}" 
													onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
													ondragenter="return false" style="ime-mode:Disabled" onkeyup="previewMark();">
											</td>
											<td width="14%" align="center"><fmt:message key="edoc.docmark.currentNo" />
											</td>
											<td width="10%" align="center">
												<input id="currentNo" name="currentNo" type="text" size="10" maxlength="10" value="${markDef.edocMarkCategory.currentNo}" 
													onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
													ondragenter="return false" style="ime-mode:Disabled" onkeyup="previewMark();">
											</td>
											<td>
												<label for="yearEnabled">
													&nbsp;&nbsp;<input type="checkbox" id="yearEnabled" name="yearEnabled" value="1" <c:if test="${markDef.edocMarkCategory.yearEnabled == true}">checked</c:if> onclick="previewMark('yearEnabled');"><fmt:message key="edoc.docmark.sortbyyear"/>
												</label>
											</td>
										</tr>
									</table>					
								</td>
							</tr>
							<tr id="hiddentr2">
								<td height="26px" class="label" align="right">
									<div class="padding_r_5"><fmt:message key="edoc.docmark.doctype" />:</div>
								</td>
								<td>
									<table border="0" width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td height="26px" width="14%" align="center" id="wordNo_a" name="wordNo_a"></td>
											<td width="10%" align="center">
											<input id="format_a" inputName='<fmt:message key="edoc.docmark.doctype" />' name="format_a" value="${formatA}" type="text" size="5" maxLength="10" onkeyup="previewMark();" maxSize="10" validate="maxLength" />
											</td>
											<td id="yearNo_a" name="yearNo_a" width="14%" align="center"></td>
											<td width="10%" align="center">
											<input id="format_b" inputName='<fmt:message key="edoc.docmark.doctype" />' name="format_b" value="${formatB}" type="text" size="5" maxLength="10" onkeyup="previewMark();" maxSize="10" validate="maxLength" />
											</td>
											<td width="14%" id="flowNo_a" name="flowNo_a" align="center"></td>
											<td class="new-column" nowrap="nowrap" width="10%">
											<input id="format_c" inputName='<fmt:message key="edoc.docmark.doctype" />' name="format_c" value="${formatC}" type="text" size="5" maxLength="10" onkeyup="previewMark();" maxSize="10" validate="maxLength" />
											</td>
											<td>
											<label for="fixedLength">
												&nbsp;&nbsp;<input type="checkbox" id="fixedLength" name="fixedLength" value="1" <c:if test="${markDef.length > 0}">checked</c:if> onclick="setFixedLength();"><fmt:message key="edoc.docmark.fixedlength" />
											</label>
											</td>
										</tr>
									</table>				
								</td>
							</tr>
							<tr id="hiddentr3">
								<td height="26px" class="label" align="right">
									<div class="padding_r_5"><fmt:message key="edoc.docmark.preview"/>:</div>
								</td>
								<td id="wordNoPreview" name="wordNoPreview" >&nbsp;
								</td>
								<input type="hidden" value="" name="markNo" id="markNo">
								<input type="hidden" value="" name="length" id="length">				
							</tr>
							<tr>			
								<td height="26px" class="label" align="right" valign="top">
									<div class="padding_r_5"><fmt:message key="edoc.docmark.grantto" />:</div>
								</td>
								<td>
									<textarea id="depart" name="depart" readonly style="width:100%" onclick ="selectPeopleFun_grantedDepartId();">${authStr}</textarea>
									<div><input type="hidden" id="grantedDepartId" name="grantedDepartId" value="${authIds}" /></div>
								</td>
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
	</td>
</tr>

<tr id="editButton" style="display:none">
	<td height="42" align="center" class="bg-advance-bottom">
		<input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize" onclick="updateMarkDef();">&nbsp;&nbsp; 
		<input type="button" onclick="window.location.href='<c:url value="/common/detail.jsp" />'" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
	</td>
</tr>
</table>
</form>

</div>

</body>
</html>

<script type="text/javascript">
<!--
	var flag = "${v3x:escapeJavascript(param.flag)}";
	var _wordNo = document.getElementById("wordNo");
	var _flowNoType = document.getElementsByName("flowNoType");
	var _categoryId = document.getElementById("categoryId");
	var _categoryButton = document.getElementById("categoryButton");
	var _minNo = document.getElementById("minNo");
	var _maxNo = document.getElementById("maxNo");
	var _currentNo = document.getElementById("currentNo");
	var _formatA = document.getElementById("format_a");
	var _formatB = document.getElementById("format_b");
	var _formatC = document.getElementById("format_c");
	var _yearEnabled = document.getElementById("yearEnabled");
	var _fixedLength = document.getElementById("fixedLength");
	var _depart = document.getElementById("depart");

	if (_flowNoType[1].checked) {
		streamChoose_big(2);
	}
	else {
		streamChoose_small();
	}	


	if (flag == "edit") {
		editButton.style.display = "block";
	}
	else {
		_wordNo.disabled = true;
		_flowNoType[0].disabled = true;
		_flowNoType[1].disabled = true;
		_minNo.disabled = true;
		_maxNo.disabled = true;
		_currentNo.disabled = true;
		_formatA.disabled = true;
		_formatB.disabled = true;
		_formatC.disabled = true;
		if (_flowNoType[1].checked) {
			_categoryId.disabled = true;
			_categoryButton.disabled = true;
		}
		_yearEnabled.disabled = true;
		_fixedLength.disabled = true;
		_depart.disabled = true;
	}
	

//-->
</script>