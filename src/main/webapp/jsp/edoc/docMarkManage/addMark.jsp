<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@ include file="../edocHeader.jsp"%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/selectbox.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var flag = "edit";
var once = 1;

function setPeopleFields(elements){
	if(elements){
		var obj1 = getNamesString(elements);
		var obj2 = getIdsString(elements,false);
		document.getElementById("depart").value = getNamesString(elements);
		document.getElementById("grantedDepartId").value = getIdsString(elements,true);
	}
}
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
</script>
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<style>
	input,select {
		height: 22px;
	}
</style>
</head>
<v3x:selectPeople id="grantedDepartId" panels="Department" minSize="0" selectType="Account,Department" jsFunction="setPeopleFields(elements)" originalElements="" />
<body class="over_hidden" onload="streamChoose_small();">

<div class="newDiv">

<form name="detailForm" id="detailForm" method="post">
<input type="hidden" id="appName" name="appName" value="<%=ApplicationCategoryEnum.edoc.getKey()%>">
<input type="hidden" id ="orgAccountId" name="orgAccountId" value="${v3x:currentUser().loginAccount}">
<input type="hidden" id="yearNo" name="yearNo" value="${yearNo}">

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
				<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="edoc.docmark.new" /></td>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space">&nbsp;</td>
			</tr>
		</table>
	</td>
</tr>

<tr>
	<td id="categorySetTd" class="categorySet-head">
		<div id="categorySetBody" class="categorySet-body overflow_auto" style="padding:0;border-bottom:1px solid #a0a0a0;">
			<table width="850" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td width="100%" valign="middle">
						<table width="96%" border="0" cellspacing="5" cellpadding="0" align="center">
							<%-- 文号类型选择--%>
							<tr>
								<td height="26px" class="label" align="right" width="20%">
									<div class="padding_r_5"><font color="red">*</font><fmt:message key="edoc.element.wordno.type" />:</div>
								</td>
								<td class="new-column" nowrap="nowrap">
									<select style="width:150px;" name="markType" id="markType" onchange="validate2Year(this.value);" >
										<option value="0"><fmt:message key="edoc.element.wordno.label" /></option>
										<option value="1"><fmt:message key="edoc.element.wordinno.label" /></option>
										<option value="2"><fmt:message key="exchange.edoc.signingNo" bundle='${exchangeI18N}' /></option>
									</select>&nbsp;&nbsp;
								</td>
							</tr>	
							<tr>
								<td height="26px" class="label" align="right" width="20%">
									<div class="padding_r_5"><fmt:message key="edoc.docmark.organizationCode" />:</div>
								</td>
								<td class="new-column" nowrap="nowrap">
									<input id="wordNo" name="wordNo" type="text" 
									   value="" class="input-20per" maxSize="30" 
									   maxLength="30"
									   inputName = '<fmt:message key="edoc.docmark.wordNo" />'
									   validate="maxLength"  onkeyup="previewMark();" onchange="previewMark();"/>
								</td>
							</tr>	
							<tr>
								<td height="26px" class="label" align="right" width="20%">
									<div class="padding_r_5">
										<font color="red" id="redDisplay"></font>排序号:
									</div>
								</td>
								<td class="new-column" nowrap="nowrap">
									<input id="sortNo" name="sortNo" type="text"  onkeypress="var k=event.keyCode; return k>=48&&k<=57" 
									   value="" class="input-20per" maxSize="9" 	ondragenter="return false" style="ime-mode:Disabled" 
									   maxLength="9"	 onpaste="return !clipboardData.getData('text').match(/\D/)"
									   validate="maxLength"/>
								</td>
							</tr>		
							<tr>
								<td height="26px" class="label" align="right">
									<div class="padding_r_5"><font color="red">*</font><fmt:message key="edoc.docmark.codeMode" />:</div>
								</td>
								<td class="new-column" nowrap="nowrap">		
								<label for="flowNoType1">		
									<input type="radio" name="flowNoType" id="flowNoType1" value="0" onclick="streamChoose_small(1);" checked><fmt:message key="edoc.docmark.smallstream" />
								</label>
								<label for="flowNoType2">
									<input type="radio" name="flowNoType" id="flowNoType2" value="1" onclick="streamChoose_big();"><fmt:message key="edoc.docmark.bigstream" />				
								</label>
								</td>
							</tr>			
							<tr>
								<td height="26px" class="label" align="right">
									<div class="padding_r_5"><font color="red">*</font><fmt:message key="edoc.docmark.flowNo" />:</div>
								</td>
								<td>
									<table border="0" width="100%" cellpadding="0" cellspacing="0">
										<tr id="bigStream" style="display:none">
											<td height="26px" colspan="6" class="new-column" nowrap="nowrap">
												<select style="width:150px;" name="categoryId" id="categoryId" onchange="changeBigStream();">
													<option value="0"><fmt:message key="edoc.docmark.selectbigstream"/></option>
												<c:forEach items="${categories}" var="category">	
													<option value="${category.id}" temp_minNo="${category.minNo}" temp_maxNo="${category.maxNo}" temp_curNo="${category.currentNo}" temp_yearEnabled="${category.yearEnabled}" temp_readonly="${category.readonly}" >${category.categoryName}</option>
												</c:forEach>
												</select>&nbsp;&nbsp;<input type="button" value="<fmt:message key="edoc.docmark.createandedit" />" onclick="manageBigStreamPage();">
											</td>
										</tr>
										<tr id="hiddentr1">
											<td height="26px" width="8%" align="center">
												<fmt:message key="edoc.docmark.minNo" />
											</td>
											<td width="7%" align="center">
												<input id="minNo" name="minNo" type="text" size="5" maxlength="9" value="1" 
													onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
				 									ondragenter="return false" style="ime-mode:Disabled" onkeyup="previewMark();">
											</td>
											<td width="8%" align="center">
												<fmt:message key="edoc.docmark.maxNo" />
											</td>
											<td width="8%" align="center">
												<input id="maxNo" name="maxNo" type="text" size="9" maxlength="9" value="1000" 
													onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
						 							ondragenter="return false" style="ime-mode:Disabled" onkeyup="previewMark();">
											</td>
											<td width="8%" align="center">
												<fmt:message key="edoc.docmark.currentNo" />
											</td>
											<td width="7%" align="center">
												<input id="currentNo" name="currentNo" type="text" size="9" maxlength="9" value="1" 
													onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
						 							ondragenter="return false" style="ime-mode:Disabled" onkeyup="previewMark();">
											</td>
											<td>
												<label for="yearEnabled">
													&nbsp;&nbsp;<input type="checkbox" id="yearEnabled" name="yearEnabled" value="1" checked onclick="previewMark('yearEnabled');"><fmt:message key="edoc.docmark.sortbyyear"/>
												</label>
											</td>
											<td>
												<label for="ssss">
													&nbsp;&nbsp;<input type="checkbox" id="twoYear" name="twoYear" value="0" />可跨前后一年
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
												<input id="format_a" inputName='<fmt:message key="edoc.docmark.doctype" />' name="format_a" type="text" size="5" maxLength="9" onkeyup="previewMark();" maxSize="9" validate="maxLength" value="〔" />
											</td>
											<td id="yearNo_a" name="yearNo_a" width="14%" align="center"></td>
											<td width="10%" align="center">
												<input id="format_b" inputName='<fmt:message key="edoc.docmark.doctype" />' name="format_b" type="text" size="5" maxLength="9" onkeyup="previewMark();" maxSize="9" validate="maxLength" value="〕"/>
											</td>
											<td width="14%" id="flowNo_a" name="flowNo_a" align="center"></td>
											<td class="new-column" nowrap="nowrap" width="10%">
												<input id="format_c" inputName='<fmt:message key="edoc.docmark.doctype" />' name="format_c" type="text" size="5" maxLength="9" onkeyup="previewMark();"  maxSize="9" validate="maxLength" value="<fmt:message key="edoc.docmark.No2" />"/>
											</td>
											<td>
												<label for="fixedLength">
													&nbsp;&nbsp;<input type="checkbox" id="fixedLength" name="fixedLength" value="1" checked onclick="setFixedLength();"><fmt:message key="edoc.docmark.fixedlength" />
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
								<td height="26px" class="label" align="right">
									<div class="padding_r_5"><fmt:message key="edoc.docmark.grantto" />:</div>
								</td>
								<td>
									<textarea id="depart" class="new-column cursor-hand" name="depart" readonly style="width:100%" onclick ="selectPeopleFun_grantedDepartId();"></textarea>
									<div type="hidden"><input type="hidden" id="grantedDepartId" name="grantedDepartId" value="${grantedDepartId}" /></div>
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
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize" onclick="createMarkDef();">
			&nbsp;&nbsp; 
			<input type="button" onclick="window.location.href='<c:url value="/common/detail.jsp" />'" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>

</form>

</div>

</body>
</html>