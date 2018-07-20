<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html>
<head>
<%@include file="logHeader.jsp" %>
<script type="text/javascript" src="${path}/common/js/jquery-debug.js"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript">
//getA8Top().showLocation(2403);

function doIt(){
	var form1 = document.getElementById("form1") ;
	var startDay = document.getElementById("startDay").value;
	var endDay = document.getElementById("endDay").value;
	//var accountName = document.getElementById("accountName").value;
	form1.isExprotExcel.value = "false" ;
	if(startDay != "" && endDay != ""){
		if(compareDate(startDay,endDay)>0){
			alert(v3x.getMessage("LogLang.log_search_overtime"))		
			return false;
		}
	}
	form1.submit();
}

function export2Excel(){
	/*
  var formObj = document.getElementById("form1") ;
  if(formObj){
    formObj.target = "targetFrame";
  	formObj.isExprotExcel.value = "true" ;
  	//formObj.action = "${logonLog}?method=exportCountLogExcel";
  	formObj.submit();
  	//formObj.action = "${logonLog}?method=countlogSearch";
  }*/
  //var f = document.createElement("form");
  var s = document.getElementById("startDay").value;
  var e = document.getElementById("endDay").value;
  var name = document.getElementById("accountName");
  var a="";
  if(name != null){
	  a = name.value;
  }
  
  //f.action = "${logonLog}?method=countlogSearch&startDay="+s+"&endDay="+e+"&accountName="+a;
  //f.submit();
  window.location.href = "${logonLog}?method=exportCountLogExcel&startDay="+s+"&endDay="+e+"&accountName="+a;
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body scroll="no" class="padding5" topmargin="0" leftmargin="0">
<%@include file="labelPage.jsp"%>
<tr>
	<td height="20" style="border-right: solid 1px #A4A4A4;">
		<script>	
			var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "gray");
			myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "javascript:export2Excel()", [2,6], "", null));
			//myBar.add(new WebFXMenuButton("print", "<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />", "javascript:doPrint()", [1,8], "", null));
			document.write(myBar);
			document.close();

			function showDetail(userId,accountName){
				var startDay = document.getElementById("startDay").value;
				var endDay = document.getElementById("endDay").value;
				var checkAccountId = document.getElementById("checkAccountId").value;
				v3x.openWindow({
			        url: logonLog + "?method=countDetailListMain&userId=" + userId + "&startDay=" + startDay + "&endDay=" + endDay + "&accountName=" + encodeURI(encodeURI(accountName))+"&checkAccountId="+encodeURI(encodeURI(checkAccountId)),
			        height: 400,
			        width: 780,
			        resizable:'no'
			    });
			}
			function setPeopleFields(elements){
				if(elements){
					var obj1 = getNamesString(elements);
					var obj2 = getIdsString(elements,false);
					document.getElementById("accountName").value = getNamesString(elements);
					document.getElementById("accountId").value = obj2;
				}
			}
		</script>
	</td>
</tr>

<tr>
	<td class="page-list-border-LRD" valign="top">
    <v3x:selectPeople id="grantedDepartId" panels="Account" selectType="Account" minSize="0" maxSize="1" jsFunction="setPeopleFields(elements)" />
	<table width="100%" height="100%" border="0" cellspacing="0"
		cellpadding="0">
		<tr>
			<td width="100%" height="40" align="center"
				class="lest-shadow">
			<form method="post" id="form1" action="${logonLog}?method=countlogSearch">
			<input type="hidden" name="isExprotExcel" id="isExprotExcel" value="">
			<b><fmt:message key="logon.templete.branch.search.label" /></b>
                <fmt:message key="logon.search.selectTime"/>:
				<input type="text" name="startDay" id="startDay" class="cursor-hand" value="${startDay }" onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);" readonly="true">
				<fmt:message key="logon.search.to"/>
				<input type="text" class="cursor-hand" name="endDay" id="endDay" value="${endDay }" onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);" readonly="true">
				<c:if test="${isGroup }">
				单位名称：
				<input type="text" class="cursor-hand" name="accountName" id="accountName" readonly="readonly" value="${accountName }">
				<input type="hidden"  name="accountId" id="accountId" value="${accountId }">
				<input type="button" value="选择" class="button-default-2" onclick="selectPeopleFun_grantedDepartId()">
				</c:if>
				<input type="hidden"  name="checkAccountId" id="checkAccountId" value="${accountId }">
				<input type="button" value="<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}"/>" class="button-default-2" onclick="doIt()">
			</form>
			</td>
		</tr>
		<tr height="24">
			<td class="webfx-menu-bar-gray border-top">&nbsp;&nbsp;&nbsp;<fmt:message key="label.mail.search" bundle="${v3xMailI18N}" /></td>
		</tr>
		<tr>
			<td height="100%" valign="top">
			<div class="scrollList" id="dataList">
			<form>
			<v3x:table data="${results}" var="result" htmlId="aaa" isChangeTRColor="true" showHeader="true" showPager="true"  pageSize="20" subHeight="130">
			  
			 
			 				
 			<v3x:column width="25%" label="单位名称" type="String" maxLength="40">
 			<span class="link-blue font-12px" onclick="showDetail('${result[4]}','${result[0]}')">${result[0] } </span>		
 			</v3x:column> 
			  
			  <v3x:column width="25%" label="用户数量" type="Number" maxLength="40" value="${result[1] }" />
			  
			  <v3x:column width="25%" label="已登录人员" type="Number" maxLength="40" value="${result[2] }" />
			  
			  <v3x:column width="25%" label="登录率(%)" type="Number" maxLength="40" value="${result[3] }" />
			</v3x:table>
			</form>
			</div>
			</td>
		</tr>
	</table>
	</td>
	</tr>
</table>
<iframe id="targetFrame" name="targetFrame" width="0" height="0"></iframe>
</body>
</html>