<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<%@ include file="docHeader.jsp"%>
</head>
<frameset rows="24,24,*" id='sx' cols="*" framespacing="0" frameborder="no" border="0" id="rightFrameSet" name="rightFrameSet">
	<frame frameborder="no" noresize="noresize" name="docNaviFrame" id="docNaviFrame" scrolling="NO">

	<frame frameborder="no" noresize="noresize" name="docMenuFrame" id="docMenuFrame" scrolling="NO">
	<frame frameborder="no" name="docFrame" id="docFrame" scrolling="yes">
		
	<noframes>

	<body topmargin="0" leftmargin="0">

	</body>

	</noframes>
</frameset>

<script type="text/javascript">
	if('${queryFlag}' == 'true'){
	//alert("${detailURL}?method=${param.queryMethod}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&isShareAndBorrowRoot=${param.isShareAndBorrowRoot}&parentId=${param.parentId}")
		docNaviFrame.window.location.href = "${detailURL}?method=navigation&libName=" + encodeURI('${param.libName}') + "&isLibOwner=${param.isLibOwner}";
		var menuUrl = "${detailURL}?method=docMenu&resId=${param.parentId}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&list=${param.list}&depAdminSize=${param.depAdminSize}&isAdministrator=${param.isAdministrator}&isGroupAdmin=${param.isGroupAdmin}&queryFlag=true&isShareAndBorrowRoot=${param.isShareAndBorrowRoot}&libName=" + encodeURI('${param.libName}') + "&isLibOwner=${param.isLibOwner}";
		var docUrl = "${detailURL}?method=${param.queryMethod}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&isShareAndBorrowRoot=${param.isShareAndBorrowRoot}&parentId=${param.parentId}" + "&isLibOwner=${param.isLibOwner}"
			+ "&depAdminSize=${param.depAdminSize}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&list=${param.list}&isAdministrator=${param.isAdministrator}&isGroupAdmin=${param.isGroupAdmin}";
		var paramUrl = "&queryMethod=${param.queryMethod}";
		if('${param.queryMethod}' == 'docQueryByName'){
			paramUrl += "&name=" + encodeURI("${param.name}");
		}else if('${param.queryMethod}' == 'docQueryByType'){
			paramUrl += "&type=${param.type}";
		}else if('${param.queryMethod}' == 'docQueryByCreater'){
			paramUrl += "&creater=" + encodeURI("${param.creater}");
		}else if('${param.queryMethod}' == 'docQueryByCreateTime'){
			paramUrl += "&beginTime=${param.beginTime}&endTime=${param.endTime}";
		}else if('${param.queryMethod}' == 'docQueryByKeywords'){
			paramUrl += "&keywords=" + encodeURI("${param.keywords}");
		}
		
		docMenuFrame.window.location.href = menuUrl + paramUrl;
		docFrame.window.location.href = docUrl + paramUrl;//alert(location.href)
		//alert("${detailURL}?method=navigation&libName=" + encodeURI('${param.libName}') + "&isLibOwner=${isLibOwner}")
	//alert(menuUrl + paramUrl);alert(docUrl + paramUrl);
	}else{
		docNaviFrame.window.location.href = "${detailURL}?method=navigation&libName=" + encodeURI('${libName}') + "&isLibOwner=${isLibOwner}";
		docMenuFrame.window.location.href = "${detailURL}?method=docMenu&resId=${param.resId}&frType=${param.frType}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&list=${param.list}&depAdminSize=${depAdminSize}&isAdministrator=${isAdministrator}&isGroupAdmin=${isGroupAdmin}&isShareAndBorrowRoot=${param.isShareAndBorrowRoot}&libName=" + encodeURI('${libName}') + "&isLibOwner=${isLibOwner}";
		docFrame.window.location.href = "${detailURL}?method=listDocs&resId=${param.resId}&frType=${param.frType}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&isShareAndBorrowRoot=${param.isShareAndBorrowRoot}&depAdminSize=${depAdminSize}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&list=${param.list}&isAdministrator=${isAdministrator}&isGroupAdmin=${isGroupAdmin}" + "&isLibOwner=${isLibOwner}";
		//alert(location.href)
		//alert("${detailURL}?method=navigation&libName=" + encodeURI('${libName}') + "&isLibOwner=${isLibOwner}")
		//alert("${detailURL}?method=docMenu&resId=${param.resId}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&list=${param.list}&depAdminSize=${depAdminSize}&isAdministrator=${isAdministrator}&isGroupAdmin=${isGroupAdmin}&libName=" + encodeURI('${libName}') + "&isLibOwner=${isLibOwner}")
		//alert("${detailURL}?method=listDocs&resId=${param.resId}&frType=${param.frType}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&isShareAndBorrowRoot=${param.isShareAndBorrowRoot}&depAdminSize=${depAdminSize}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&list=${param.list}&isAdministrator=${isAdministrator}&isGroupAdmin=${isGroupAdmin}" + "&isLibOwner=${isLibOwner}")
	}
</script>

</html>