<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="common.toolbar.order.label" bundle='${v3xCommonI18N}'/></title>
<script type="text/javascript">
<!--
function up(){
	var pageObj = document.getElementById("pageObj");
  	for(var i = 0; i < pageObj.options.length; i ++){
    	if(pageObj.options[i].selected == true){
		  	if(i == 0){
			  	return;
			}
			
		  	var optValue = pageObj.options[i-1].value;
		  	var optTxt = pageObj.options[i-1].text;
		  	pageObj.options[i-1].value = pageObj.options[i].value;
		  	pageObj.options[i-1].text = pageObj.options[i].text;
		  	pageObj.options[i].value = optValue;
		  	pageObj.options[i].text = optTxt;
		  	pageObj.options[i].selected = false;
		  	pageObj.options[i-1].selected = true;
		}
	}
}

function down(){
	var pageObj = document.getElementById("pageObj");
  	for(var i = pageObj.options.length - 1; i >= 0; i --){
    	if(pageObj.options[i].selected == true){
		  	if(i == (pageObj.options.length - 1)){
			  	return;
			}
			
		  	var optValue = pageObj.options[i+1].value;
		  	var optTxt = pageObj.options[i+1].text;
		  	pageObj.options[i+1].value = pageObj.options[i].value;
		  	pageObj.options[i+1].text = pageObj.options[i].text;
		  	pageObj.options[i].value = optValue;
		  	pageObj.options[i].text = optTxt;
		  	pageObj.options[i].selected = false;
		  	pageObj.options[i+1].selected = true;
		}
	}
}

function savePageOrder(){
	var pageObj = document.getElementById("pageObj");
	 if(!pageObj) return false;
	 var ids = [];
	 for(var i = 0; i < pageObj.options.length; i ++){
		 ids[i] = pageObj.options[i].value;
     }
	 transParams.parentWin.pageOrderCollBack(ids);
}
//-->
</script>
</head>
<body scroll='no'>
<form name="formOrder" method="post">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="popupTitleRight">
		<tr>
			<td class="PopupTitle" height="20">
				<label for="modelName"><fmt:message key="hr.userDefined.page.belonged.label" bundle="${v3xHRI18N}" />:</label>
				<select name="modelName" id="modelName" disabled>
					<option value="staff"><fmt:message key="menu.hr.staffinfoMgr" bundle="${v3xMainI18N}"/></option>
					<option value="salary" selected><fmt:message key="menu.hr.laborageMgr" bundle="${v3xMainI18N}" /></option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="categorySet-head2">
				<table width="100%" height="100%" border="0">
					<tr>
						<td width="37%">&nbsp;</td>
						<td rowspan="5">
							<select id="pageObj" name="pageObj" size="12" multiple style="width: 250px">
								<c:forEach var="page" items="${pages}">
									<option value="${page.id}">${v3x:toHTML(page.pageName)}</option>
								</c:forEach>
							</select>
						</td>
						<td width="37%">&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<p><img src="<c:url value="/common/SelectPeople/images/arrow_u.gif"/>" alt='<fmt:message key="selectPeople.alt.up" bundle='${v3xMainI18N}'/>' width="24" height="24" class="cursor-hand" onclick="up()"></p>
						</td>
					</tr>
					<tr>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<p><img src="<c:url value="/common/SelectPeople/images/arrow_d.gif"/>" alt='<fmt:message key="selectPeople.alt.down" bundle='${v3xMainI18N}'/>' width="24" height="24" class="cursor-hand" onclick="down()"></p>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="4" align="center" class="bg-advance-bottom">
							<input type="button" name="b1" onclick="savePageOrder();" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default-2" />&nbsp;
							<input type="button" name="b2" onclick="getA8Top().hrUserDefinedOrderWin.close();" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
</body>
</html>