<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../docHeader.jsp" %>
<%@include file="../../../common/INC/noCache.jsp" %>
<title>
<c:choose>
<c:when test="${param.isLib == 'true'}">
<fmt:message key='doc.jsp.log.title.lib'/>
</c:when>
<c:when test="${param.isFolder == 'true'}">
<fmt:message key='doc.jsp.log.title.folder'/>
</c:when>
<c:otherwise>
<fmt:message key='doc.jsp.log.title'/>
</c:otherwise>
</c:choose>
:${docLibName}
</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-debug.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" href="<c:url value="/skin/default/skin.css"/>">
<style>
.checkBox{
            display: inline-block;
            width: 17px;
            height: 17px;
            border: 1px solid #dfdfdf;
            position: relative;
            top: 5px;
            margin-right: 5px;
        }
.checked{
	border: 0;
    width: 19px;
    height: 19px;
    background: url(/seeyon/apps_res/doc/css/newCss/images/choosed.png);
}
</style>
</head>
<body scroll="no">
		<input type="hidden" id="docLibId" value="">
		<input type="hidden" id="docResId" value="">
		<table width="100%" height="auto" border="0" cellspacing="0" cellpadding="0" class="">
			<tr>
				<td>
					<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="22">
								<input type = "hidden" id = "docLibType" name = "docLibType"  value = "${param.docLibType}"/>
								<input type="hidden" id="docName" name="docName" value="${param.name}" />
								<script type="text/javascript">
									var docResId = '${docResId}';
									var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
									if(v3x.getBrowserFlag("hideMenu") == true){
									myBar.add(new WebFXMenuButton("print", "<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />", "printFileLog();", [1,8]));
									if(${search == true}){
										myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "exportExcelNew('file','"+docResId+"','${param.name}','${param.isGroupLib}',true);", [2,6]));
									}else{
										if(${isFolder ==true}){
											myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "exportExcelNew('folder','"+docResId+"', '${v3x:escapeJavascript(theDocName)}','${isGroupLib}',false);", [2,6]));
										}else{
											myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "exportExcelNew('file','"+docResId+"','${param.name}','${param.isGroupLib}',false);", [2,6]));
										}
									}
									myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}'/>",  "top.close();", [7,4]));
									}
									document.write(myBar);				
								</script>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<c:if test="${search == true}">
					<%@ include file="docLogSearch.jsp"%>
				</c:if>
			</tr>
			<tr>
				<td>
					<iframe name="docIframe" id="docIframe" frameborder="0" height="auto" width="100%" scrolling="no"></iframe>
				</td>
			</tr>
			<tr>
				<td>
					<iframe id="theLogIframe" name="theLogIframe" frameborder="0" marginheight="0" marginwidth="0" height="0"></iframe>
				</td>
			</tr>
		</table>
<script>
	var folder = "${param.isFolder == 'true'}";
	var search = "${search}";
	var name = "${v3x:escapeJavascript(param.name)}";
	document.getElementById("docLibId").value = "${docLibId}";
	document.getElementById("docResId").value = "${param.docResId}";
	if(search=="true"){
		docIframe.window.location.href = "${detailURL}?method=docLogsView&docLibId=${param.docLibId }&docResId=${param.docResId }";
	}else{
		if(folder == 'true'){
			docIframe.window.location.href = "${detailURL}?method=folderLogView&docResId=${param.docResId }&docLibId=${param.docLibId }&isGroupLib=${param.isGroupLib}&isFolder=true&name=" + encodeURI(name);
		}
		else{
			docIframe.window.location.href = "${detailURL}?method=docLogView&docResId=${param.docResId}&isGroupLib=${isGroupLib}&docLibId=${param.docLibId }&isFolder=false&name=" + encodeURI(name);
		}
	}
	window.onload = function(){
		var h = document.body.clientHeight - 37;
		if(v3x.isMSIE8 || v3x.isMSIE9 || v3x.isMSIE10){
			h = document.documentElement.clientHeight - 37;
		}
		if(search=="true"){
		    h -= 120;
		}
        h += "px";
		$("#docIframe").attr("height",h);
	}
	
</script>
</body>
</html>