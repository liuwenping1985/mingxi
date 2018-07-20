<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}"/>
<c:set value="${v3x:currentUser().loginAccount}" var="loginAccountId" />
<script>
function resize(){ 
if(navigator.userAgent.indexOf("MSIE")>0){
	var maxWidth;
	var parentLayout = parent.document.getElementById("layout");
	if(window.screen.width <= 1024)
		maxWidth = 275;
	else
		maxWidth = 440;
	if(document.body.clientWidth > maxWidth)   
		parentLayout.cols = maxWidth + ",*";
	
	if(document.body.clientWidth < 140)   
		parentLayout.cols = "140,*";
} else {
	
}  
} 
 function onkeydown(){
	if(window.event.keyCode==8)    
	{
	window.event.keyCode=0;  
	window.event.returnValue=false;  
	}  
 }
 function setTreeList(){
	var treeList = document.getElementById('treeList');
	try{
		if(treeList){
			treeList.style.height = (parseInt(document.body.offsetHeight)- 35) + "px";
		}
	}catch(e){}
 }
</script>
</head>
<body scroll="no" style="height:100%;overflow:hidden;border-bottom:1px #c7c7c7 solid;border-right: 0px #c7c7c7 solid; " onload="setTreeList()">  
<div id="treeList" style="overflow:auto; width:100%;">
<div  style="width: 80%;  padding-top: 10px;padding-left: 10px;">
<script type="text/javascript">
function libcfg(flag) {
	var theParent=parent.document.getElementById('rightFrame').contentWindow;
 	theParent.document.location.href = "${detailURL}?method=docLibsConfig&flag=" + flag;
}

function libsList() {
	var theParent=parent.document.getElementById('rightFrame').contentWindow;
	//if(parent.rightFrame.rightFrameSet){
	//	parent.rightFrame.rightFrameSet.rows = "24,0,*";
	 	theParent.document.location.href = "${detailURL}?method=docLibsList";
 	//}

}

webFXTreeConfig.openRootIcon = "<c:url value='/apps_res/doc/images/docIcon/root.gif'/>";
webFXTreeConfig.defaultText = "<fmt:message key='doc.center.lable'/>";
var libroot = new WebFXTree();
libroot.text = "<fmt:message key='doc.tree.struct.lib.lable'/>";
libroot.action = "javascript:libcfg()";
libroot.icon = "<c:url value='/apps_res/doc/images/docIcon/lib_cfg.gif'/>";
libroot.openIcon = "<c:url value='/apps_res/doc/images/docIcon/lib_cfg.gif'/>";
var root = new WebFXTree();
root.action = "javascript:libsList()";
<c:set value="" var="flag"/>
<c:forEach items="${roots}" var="root">
	<c:if test="${root.docResource.docLibId == docLibId }">
		<c:set value="${root.docResource.id}" var="flag" />
	</c:if>
	<c:choose>
		<c:when test="${root.otherAccountId!=0}" >
			<c:set value="(${v3x:toHTML(v3x:getAccount(root.otherAccountId).shortName)})" var="otherAccountShortName" />
		</c:when>
		<c:otherwise>
			<c:set value="" var="otherAccountShortName" />
		</c:otherwise>
	</c:choose>
	var tree_${root.docResource.id} = new WebFXLoadTreeItem("${root.docResource.id}", "${v3x:toHTML(root.frName)}${otherAccountShortName}", null, null, null, null, "<c:url value='/apps_res/doc/images/docIcon/${root.closeIcon}'/>", "<c:url value='/apps_res/doc/images/docIcon/${root.openIcon}'/>");	
	tree_${root.docResource.id}.src = "<c:url value='/doc.do?method=xmlJsp&resId=${root.docResource.id}&frType=${root.docResource.frType}&isShareAndBorrowRoot=${root.isBorrowOrShare}'/>";
	tree_${root.docResource.id}.fileIcon = "<c:url value='/apps_res/doc/images/docIcon/${root.closeIcon}'/>";
	tree_${root.docResource.id}.action = "javascript:showSrcAndAction('${root.docResource.id}','${root.docResource.frType}','${root.docResource.docLibId}','${root.docLibType}','${root.isBorrowOrShare}','${root.allAcl}','${root.editAcl}','${root.addAcl}','${root.readOnlyAcl}','${root.browseAcl}','${root.listAcl}','${root.v}')";
	
	root.add(tree_${root.docResource.id});
	
</c:forEach>
//document.write(libroot);
document.write(root);
//tree_${flag}.expand();

</script>
</div>
</div>

</body>
</html>