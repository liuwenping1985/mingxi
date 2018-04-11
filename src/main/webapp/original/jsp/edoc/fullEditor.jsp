<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.ctp.common.constants.Constants" %>
<!DOCTYPE html>
<HTML>
<HEAD>
<%@ include file="edocHeader.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/isignaturehtml/js/isignaturehtml.js" />"></script>
<TITLE>
<%
	//html专业签章需要，这里复制出一份，如果采用v5框架就不需要定义这些变量了
	String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + request.getServerName() + ":"
        + request.getServerPort() + ctxPath;
%>
<%-- GOV-4516 【公文管理】-【发文管理】-【拟文】，公文起草时正文类型选择标准正文，编辑正文时IE标题栏还是显示的'致远A8-M协同管理软件' --%>
<c:choose>
<c:when test="${flag == true}">
	${title }
</c:when>
<c:otherwise>
	<fmt:message key="common.page.title${v3x:suffix() }" bundle="${v3xCommonI18N}" />
</c:otherwise>
</c:choose>
</TITLE>
<META NAME="Generator" CONTENT="EditPlus">
<META NAME="Author" CONTENT="">
<META NAME="Keywords" CONTENT="">	
<META NAME="Description" CONTENT="">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<SCRIPT language=javascript for=SignatureControl  event=EventOnSign(DocumentId,SignSn,KeySn,Extparam,EventId,Ext1)>
<%-- 作用：重新获取签章位置--%>
  if(SignatureControl && EventId == 4 ){
    CalculatePosition();
    SignatureControl.EventResult = true;
  }
</SCRIPT>
<script>
var editorStartupFocus = true;
var editorAssociates = '4,3';//toolbar中，关联文档需要显示的模块页签
var testUrl="${testURL}";
var canEdit=${ctp:escapeJavascript(param.canEdit)};
var canPrint="${ctp:escapeJavascript(param.canPrint)}";
var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';

function initEdit()
{

  if (v3x && v3x.useFckEditor) {
    // 保证Fck就绪
    var isHas = typeof (FCKeditorAPI.GetInstance(oFCKeditor.InstanceName).EditorWindow) == "undefined";
    if (isHas) {
      window.setTimeout("initEdit();", 10);
      return;
    }
  }else{
    if(typeof (CKEDITOR.instances['content']) == "undefined"){
      window.setTimeout("initEdit();", 10);
      return;
    }
  }
  loadSignatures("${ctp:escapeJavascript(param.summaryId)}",false,false,false,3);
  window.onbeforeunload = function(){}
  var parentWin=parent;
  parentWin=transParams.parentWin;
  //debugger;
  var content = parentWin.getHtmlContent();

  if (v3x && v3x.useFckEditor) {
    var oEditorFCK = FCKeditorAPI.GetInstance(oFCKeditor.InstanceName).EditorWindow.parent.FCK;
    oFCKeditor.SetContent(content); 
  }else{
    var oEditorFCK = CKEDITOR.instances['content'];
    oEditorFCK.setData(content);
  }
   window.setTimeout(setObjEditState,10);
  try{
	if(canEdit!=true){myBar.disabled("save");}
  }catch(e){}
}

  function setObjEditState() {
    if (v3x && v3x.useFckEditor) {
      var isHas = typeof (FCKeditorAPI.GetInstance(oFCKeditor.InstanceName).EditorWindow) == "undefined";
      if (isHas) {
        window.setTimeout(setObjEditState, 10);
        return;
      }
      var oEditorFCK = FCKeditorAPI.GetInstance(oFCKeditor.InstanceName).EditorWindow.parent.FCK;
      //debugger;
      if (canEdit == false) {
        oEditorFCK.EditingArea.MakeEditState(canEdit);
        oEditorFCK.ToolbarSet.Disable();
      }

      if (canPrint != "false") {
        if (oEditorFCK.ToolbarSet.Items[21])
          oEditorFCK.ToolbarSet.Items[21].Enable();
      } else {
        if (oEditorFCK.ToolbarSet.Items[21])
          oEditorFCK.ToolbarSet.Items[21].Disable();
      }

      oEditorFCK.ToolbarSet.Items[1].Disable()
      oEditorFCK.ToolbarSet.Items[14].Disable()
      oEditorFCK.ToolbarSet.Items[15].Disable()
      oEditorFCK.ToolbarSet.Items[16].Disable()
      oEditorFCK.ToolbarSet.Items[17].Disable()
      oEditorFCK.ToolbarSet.Items[0].Disable()
      //window.setTimeout("setObjEditState();",10);
    } else {
      var oEditorFCK = CKEDITOR.instances['content'];
      if (canEdit == false) {
        if(!oEditorFCK.readOnly){
          CKEDITOR.on('instanceReady', function(e){
            oEditorFCK.setReadOnly(true);
            });
        }
      }
    }
  }
  
  function initContent() {
    //alert("run");
    //oFCKeditor.changeContent("111");
  }

  function editSubmit() {
    /*
     editForm.action=testUrl;
     editForm.target="submitIframe";
     editForm.submit();  
     var editAreaObj=document.getElementById("content");
     window.returnValue=editAreaObj.value;
     */
    window.onunload = "";
    try {

      if (v3x && v3x.useFckEditor) {
        var oEditorFCK = FCKeditorAPI.GetInstance(oFCKeditor.InstanceName).EditorWindow.parent.FCK;
        window.returnValue = oEditorFCK.EditingArea.Document.body.innerHTML;
      } else {
          transParams.parentWin.popupContentWinCallback(CKEDITOR.instances['content'].getData());
      }
    } catch (e) {
    }
  }
  function ok() {
    editSubmit();
    isFormSumit = true;
    transParams.parentWin.popupContentEditWin.close();
  }
  function cancelEdit() {
    window.onunload = "";
    transParams.parentWin.popupContentEditWin.close();
  }
  window.onresize = function (){
      moveISignatureOnResize();
  }
  window.onbeforeunload=cbfun;
  function cbfun(){
      try{htmlContentIframe.releaseISignatureHtmlObj();}catch(e){}
      if(typeof(beforeCloseCheck) =='function'){
         return beforeCloseCheck();
      }
  }
</script>
</HEAD>

<BODY onload="initEdit();" onkeypress="listenerKeyESC()" scroll="no" style="overflow: hidden" onunload="editSubmit()">
<div id="inputPosition" style="width: 0px; height: 0px; position: absolute;"></div>
<div id="newInputPosition" style="width: 0px; height: 0px; position: absolute;"></div>
<form name="editForm" id="editForm" method="post">
<table border="0px" style="width:100%;height:100%" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22" valign="top">
		<script type="text/javascript">
		var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
		
		myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", "javascript:ok()", "<c:url value='/common/images/toolbar/save.gif'/>", "", null));    	
		myBar.add(new WebFXMenuButton("cancel", "<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />", "javascript:cancelEdit()", "<c:url value='/common/images/toolbar/cancel.gif'/>", "", null));
		
		document.write(myBar.toString());
		document.close();
		</script>
		</td>
	</tr>
<tr valign="top"><td>
<c:choose>
  <c:when test="${hasInsertDocumentPermission eq 'true'}">
    <v3x:editor htmlId="content" content="" type="HTML" category="4" />
  </c:when>
  <c:otherwise>
    <v3x:editor barType="BasicAdmin" htmlId="content" content="" type="HTML" category="4" />
  </c:otherwise>
</c:choose>
</td></tr></table>
</form>
</BODY>
</HTML>
<script>
  if(v3x.isMSIE6){
    document.getElementById("qqq").style.height=window.document.body.clientHeight-40+"px";
  }
</script>