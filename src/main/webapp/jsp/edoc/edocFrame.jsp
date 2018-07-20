<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp"%>

<style type="text/css">
html,body{height:100%;width: 100%;border: 0;padding: 0;margin: 0}
</style>

${v3x:showAlert(pageContext)}

<script type="text/javascript">
window.onload = function () {
	if(window.dialogArguments) {
		document.getElementById("treeandlist").cols = "0px,*";
		document.getElementById("treeFrame").noresize = "noresize";
	}
}
/** 打开进度条 */
//try { getA8Top().startProc(); } catch(e) {}
</script>

</head>
<c:set value="${isAgent||!hasEdocLeft?'noresize':'' }" var="noresize" />
<c:set value='${edoc}?method=listLeft&edocType=${edocType}&from=${param.from}&list=${param.list}&listType=${listType }&subType=${ctp:toHTML(param.subType)}&app=${ctp:toHTML(param.app)}&modelType=${ctp:toHTML(param.modelType)}' var="leftUrl" />
<c:set value="${hasEdocLeft?leftUrl:''}" var="leftURL" />

<frameset id="treeandlist" rows="*" cols="${isAgent||!hasEdocLeft?'0':'140' }px,*" frameBorder="0" frameSpacing="0" bordercolor="#ececec" style="height:100%;">
	<frame ${noresize } src="${leftURL }" name="treeFrame" frameborder="0" scrolling="yes"  id="treeFrame"/>

	<frameset rows="*" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
		//签收之后直接进入新建页面  2015年9月22日  xiex start
		<c:if test="${toNewRegister != null && toNewRegister != ''}">
  			<frame frameborder="no" src="/seeyon/edocController.do?method=newEdoc&comm=distribute&recListType=listDistribute&edocType=1&registerId=${toNewRegister}&isFromHome=${isFromHome}&app=${app}&sub_app=${sub_app}" name="listFrame" scrolling="no" id="listFrame" />
  		</c:if>
		<c:if test="${toNewRegister == null || toNewRegister == ''}">
  		<frame frameborder="no" src="${edocNavigationControllerURL}?method=${listMethod }&edocType=${param.edocType}&track=${ctp:toHTML(param.track)}&affairId=${ctp:toHTML(param.affairId)}&condition=${param.condition}&textfield=${param.textfield}&textfield1=${param.textfield1}&templeteId=${ctp:toHTML(param.templeteId)}&listType=${listType}&recListType=${ctp:toHTML(param.recListType)}&sendUnitId=${ctp:toHTML(param.sendUnitId)}&modelType=${ctp:toHTML(param.modelType)}${isFenfa?'&isFenfa=1':''}&id=${ctp:toHTML(param.id)}&meetingSummaryId=${ctp:toHTML(meetingSummaryId)}&comm=${ctp:toHTML(param.comm)}&edocId=${ctp:toHTML(param.edocId)}&checkOption=${ctp:toHTML(param.checkOption)}&newContactReceive=${ctp:toHTML(param.newContactReceive)}&subType=${ctp:toHTML(param.subType)}&exchangeId=${ctp:toHTML(param.exchangeId)}&app=${ctp:toHTML(param.app)}&recieveId=${ctp:toHTML(param.recieveId)}&forwordType=${ctp:toHTML(param.forwordType)}&transmitSendNewEdocId=${ctp:toHTML(param.transmitSendNewEdocId)}&registerId=${ctp:toHTML(param.registerId)}&recAffairId=${ctp:toHTML(param.recAffairId)}&summaryId=${ctp:toHTML(param.summaryId)}&backBoxToEdit=${ctp:toHTML(param.backBoxToEdit)}&canOpenTemplete=${ctp:toHTML(param.canOpenTemplete)}&registerType=${ctp:toHTML(param.registerType)}&openFrom=${ctp:toHTML(param.openFrom)}&isFromHome=${isFromHome}&app=${app}&sub_app=${sub_app}" name="listFrame" scrolling="no" id="listFrame" />
  		</c:if>
		//签收之后直接进入新建页面  2015年9月22日  xiex end
		<%-- 
		<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
		 	<frame frameborder="no" src="<c:url value="/common/detail_edoc.html" />" name="detailFrame" id="detailFrame" scrolling="no" />
		</c:if> 
		--%>
	</frameset>
</frameset>
<noframes>
</noframes>
</html>