<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="edocHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${summarySubject}</title>
<script>
//ie以外的浏览器关闭窗口时不能从内关闭外面的窗口
function closeWindow(){
	if(window.dialogArguments){
		window.returnValue = "true";
		window.close();
	}else if(window.opener){
		window.opener.location.reload();
		window.close();
	}else{
		try{
			parent.parent.location.reload(true);
		}catch(e){
			parent.getA8Top().reFlesh();
		}
	}
}
</script>

</head>
<body class="over_hidden h100b">
  <c:set value="${(from=='supervise' || !empty from) ? from : param.from}" var="f"/>
  <c:set value="${(empty param.affairId || isEdocRecDistribute) ? affairId : param.affairId}" var="affId"/>
	<iframe width="100%" height="100%" src="${detailURL}?method=summary&summaryId=${summaryId}&affairId=${affId}&from=${f}&docResId=${param.docResId}&openFrom=${openFrom}&lenPotent=${lenPotent}&docId=${docId}&isLibOwner=${isLibOwner}&docResId=${param.docResId }&bodyType=${bodyType}&recType=${recType}&relSends=${relSends}&relRecs=${relRecs}&sendSummaryId=${sendSummaryId}&recEdocId=${recEdocId}&forwardType=${forwardType}&archiveModifyId=${archiveModifyId}" name="detailMainFrame" id="detailMainFrame" scrolling="no" frameBorder="0">
	</iframe>
</body>
</html>