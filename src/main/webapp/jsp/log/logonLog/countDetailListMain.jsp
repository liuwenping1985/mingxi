<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><html>
<head>
<%@include file="logHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="logon.stat.detail.label" /></title>
</head>
<script type="text/javascript">
<!-- 
	function exportExcel() {
		var searchForm = document.getElementById("searchForm") ;
		var url = "${logonLog}?method=exportExcelSys&userId=${param.userId }&startDay=${param.startDay }&endDay=${param.endDay }";
		searchForm.action = url;
		searchForm.target = "temp_iframe";
		searchForm.submit();
	}
	
	function popprint() {
		var printContentBody = "";
		var cssList = new ArrayList();
		var pl = new ArrayList();
		var contentBody = "" ;
		var contentBodyFrag = "" ;
		
		contentBody = window.frames["myframe"].document.getElementById("print").innerHTML;
		contentBodyFrag = new PrintFragment(printContentBody, contentBody);
		pl.add(contentBodyFrag);
		cssList.add("/seeyon/common/skin/default/skin.css");
		printList(pl,cssList);
	}
//-->
</script>
<body>
<div class="div-float-right" style="width: 100%;height: 100%" >
	<form action="" id="searchForm" method="post">
	<table style="width: 100%;height: 100%;">
		<tr>
		
			<td valign="top" height="26" class="tab-tag" style="border: 0" align="right">
				<div class="div-float-right" style="margin-right: 20px;">
					<center>
					<span>时间：</span><span>${param.startDay }</span>
					<span>至</span><span>${param.endDay }</span>
					<span>单位名称：</span><span id="accountName"></span>
					</center>
					<script type="text/javascript">
			    	//var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			    	//myBar.add(new WebFXMenuButton("ExcportExcel1Div", "<fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' />", "javascript:exportExcel(1)", [2,6], "", null));    	
			    	//myBar.add(new WebFXMenuButton("printButton1Div", "<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />", "javascript:popprint(1)", [1,8], "", null));
			    	//document.write(myBar);
			    	//document.close();
			    	document.getElementById("accountName").innerHTML = decodeURI("${param.accountName }");
			    	</script>
				</div>
			</td>
			
		</tr>
		<tr>
			<td>
				<iframe name="myframe" id="myframe" scrolling="no" frameborder="0" width="100%" height="100%" src="${logonLog}?method=countDetailList&userId=${param.userId }&startDay=${param.startDay }&endDay=${param.endDay }&accountId=${param.checkAccountId }"></iframe>
			</td>
		</tr>
	</table>
	</form>
</div>
<iframe name="temp_iframe" id="temp_iframe" style="display: none;"></iframe>
</body>
</html>