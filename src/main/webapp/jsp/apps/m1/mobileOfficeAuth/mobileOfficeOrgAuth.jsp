<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../../../common/common.jsp"%>
<%@ include file="./mobileOfficeOrgAuth_js.jsp"%>
<link type="text/css" rel="stylesheet"  href="<c:url value='/apps_res/m1/css/orgAuth.css${v3x:resSuffix()}' />">
</head>
<body height="100%">
<div id='layout' class="comp" comp="type:'layout'">
	<div class="comp" comp="type:'breadcrumb',code:'M1_mobileOfficeOrgAuth'"></div> 
    <div class="layout_north" layout="height:30,sprit:false,border:false">
         <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:true" id="center">
		
		<div class="stadic_layout form_area" id='form_area' style="overflow: auto;height:94%">
			<form id="auth_form" method="post" action="<c:url value='/m1/mobileOfficeAuth.do' />?method=saveOrgAuthList">
			<table border="0" bordercolor="black" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
				<tr><td><div style="padding-left: 6%;padding-top: 20px;">
					<fieldset>
				<table>
					<tr class="trstyle">
			   			<td class="bg-gray"  nowrap="nowrap" align="right">${ctp:i18n('m1.mobileOfficeAuth.seriesNumber')}:</td>
						<td class="new-column" ><font id ="seriesNumber">${seriesNumber}</font> </td>
					</tr>
					<tr class="trstyle">
			   			<td class="bg-gray"  nowrap="nowrap" align="right">${ctp:i18n('m1.mobileOfficeAuth.maxAuthNumberLabel')}:</td>
						<td class="new-column" ><font id = "maxAuthNumberLabel">${maxAuthNumber}</font></td>
					</tr>
					<tr class="trstyle">
			   			<td class="bg-gray"  nowrap="nowrap" align="right">${ctp:i18n('m1.mobileOfficeAuth.userdAuthNumberLabel')}:</td>
						<td class="new-column" ><font id = "userdAuthNumberLabel"> ${userdAuthNumber}</font></td>
					</tr>
					<tr class="trstyle">
			   			<td class="bg-gray"  nowrap="nowrap" align="right">${ctp:i18n('m1.mobileOfficeAuth.remainAuthNumberLabel')}:</td>
						<td class="new-column" ><font id = "remainAuthNumberLabel">${remainAuthNumber}</font></td>
					</tr>
				</table>
				</fieldset>
				</div></td></tr>
				<tr style="width: 100%;text-align: center;"><td><div style="padding-left: 6%;padding-top: 20px; padding: 0 auto;"><fieldset>
					<table >
						<tr class="trstyle">
							<th class="bg-gray"  nowrap="nowrap" align="right">
								<span >${ctp:i18n('m1.mobileOfficeAuth.accountName')}</span>
							</th>
							<td class="bg-gray"  nowrap="nowrap" align="center">
								<span >${ctp:i18n('m1.mobileOfficeAuth.mobileOfficeCount')}</span>
							</td>
							<td class="bg-gray"  nowrap="nowrap" align="left">
								<span >${ctp:i18n('m1.mobileOfficeAuth.userdAuthNumberLabel')}</span>
							</td>
						</tr>
						<c:forEach var ="vo" items="${voList }">
							<tr class="trstyle">
								<th class="bg-gray"  nowrap="nowrap" align="right">
									<span title="${vo.fullName }">${vo.fullName}</span>
								</th>
								<td class="bg-gray"  nowrap="nowrap" align="center">
									<input  class="number validate"  id = "number" name = "${vo.orgID }" value="${vo.number }" style="width: 20px;" onchange="inputCheck(this)" disabled="disabled"  validate="isInteger:true,name:'${vo.name}'"/>
								</td>
								<td class="bg-gray"  nowrap="nowrap" align="left">
									<input id ="userdNumber" name = "userdNumber" value = "${vo.userNumber}" disabled="disabled" style="width: 20px;"/>
								</td>
					
							</tr>
						</c:forEach>
					</table></fieldset>
				</div></td></tr>
			</table>
			</form>
		</div>
	
	<div class="stadic_layout_footer stadic_footer_height">
        	<div id="button_area" align="center" class="page_color button_container">
			<a id="btnsubmit" 
				class="common_button common_button_gray margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
				&nbsp; 
			<a id="btncancel" 
			class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
		</div>
	</div>
	</div>
</div>
</body>
</html>