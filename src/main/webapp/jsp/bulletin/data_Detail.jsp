<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./include/taglib.jsp" %>
<%@ include file="./include/header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
<fmt:message key="bul.preview.label"/>
</title>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<script type="text/javascript" >
	//获取前一页面传来的对象
	var bulletinObj = window.opener;
	//公告标题
	var titleObj = bulletinObj.document.getElementById("title");
	var title = titleObj.value.escapeHTML();
	var defaultTitle = getDefaultValue(titleObj).escapeHTML();
	if(title == defaultTitle){
		title = "";
	}
	//发布部门
	var deptName = bulletinObj.document.getElementById('publishDepartmentName').value;
	//部门公告板块和单位的板块区分（能直接取到值的是部门公告板块，不能直接取到值的是单位的板块）
	var typeName = bulletinObj.document.getElementById('typeName').value;
	// 预览页面是否出现打印按钮
	var printButtons = false;
	if(bulletinObj.document.getElementById('b').checked) {
		printButtons = true;
	}
	var publishScopeNames = bulletinObj.document.getElementById("publishScopeNames");
	var _createDate = bulletinObj.document.getElementById("_createDate").value;
	var publishScope = publishScopeNames.value;
	var defaultPublishScope = getDefaultValue(publishScopeNames);
	if(publishScope == defaultPublishScope){
		publishScope = "";
	}
	var showPublishUserFlag =  bulletinObj.document.getElementById('showPublishUserFlag').checked;
	//附件
	var attNumber = bulletinObj.getFileAttachmentNumber(0);
	var author = "${(v3x:currentUser()).name}";
    var att = "";
	if(attNumber != 0){
		att = "<table width='100%'><tr><td valign='top' width='40' nowrap='nowrap'>" + 
			"<div class='div-float' style='font-weight: bolder; font-size: 12px;'>"
			+ '<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />' + "：</div></td>" + 
			"<td valign='top' style='color: #335186;' nowrap='nowrap'>" + bulletinObj.getFileAttachmentName(0) + "</td></tr></table>";
	}

	//关联文档
    var att2Number = bulletinObj.getFileAttachmentNumber(2);
    var attFile = "";
	if(att2Number != 0){
		attFile = "<table width='100%'><tr><td valign='top' width='60' nowrap='nowrap'>" + 
			"<div class='div-float' style='font-weight: bolder; font-size: 12px;'>"
			+ '<fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />' + "：</div></td>" + 
			"<td valign='top' style='color: #335186;' nowrap='nowrap'>" + bulletinObj.getFileAttachmentName(2) + "</td></tr></table>";
	}
	
	if(typeName==null || typeName==''){//取不倒值是单位的板块
		//单位公告板块
		var typeOptions = bulletinObj.document.getElementById("typeId").options;
		var bullType = "";
		if(typeOptions){
			for(var i = 0 ; i < typeOptions.length ; i++ ){
				if(typeOptions[i].selected){
					bullType = typeOptions[i].text;
				}
			}
		}
	}else{
		var bullType = typeName;
	}
	//正文内容
   var content;
   if(v3x.useFckEditor){
     var oEditorFCK=bulletinObj.FCKeditorAPI.GetInstance('content');  
     content = oEditorFCK.EditingArea.Document.body.innerHTML;
   }else{
     content = bulletinObj.CKEDITOR.instances['content'].getData(); 
   }
       	 
	function printResult(){
         var mergeButtons  = document.getElementsByName("mergeButton");
         for(var s= 0;s<mergeButtons.length;s++){
            var mergeButton = mergeButtons[s]; 
            mergeButton.style.display="none";
         }
         var p = document.getElementById("printThis");
         var aa= "";
         var mm = p.innerHTML;
         var list1 = new PrintFragment(aa,mm);
         var tlist = new ArrayList();
         tlist.add(list1);
         var cssList=new ArrayList();
   		 cssList.add(v3x.baseURL + "/common/RTE/editor/css/fck_editorarea4Show.css")
   		 cssList.add(v3x.baseURL + "/apps_res/bulletin/css/default.css")
         printList(tlist,cssList);
         for(var s= 0;s<mergeButtons.length;s++){
             var mergeButton = mergeButtons[s];
             mergeButton.style.display="";
         }
	}
	function init(){
		try{
			document.getElementById("preView").style.height = window.innerHeight+"px";
			var attach = bulletinObj.document.getElementById('attachmentNumberDiv').innerHTML;
			var attachFile = bulletinObj.document.getElementById('attachment2NumberDiv').innerHTML;
			if(attach=='' || attach=='0'){
				document.getElementById('attachTr').style.display="none";
			}else{
				document.getElementById('attachTr').style.display="block";
			}
			if(attachFile=='' || attachFile=='0'){
				document.getElementById('attachFileTr').style.display="none";
			}else{
				document.getElementById('attachFileTr').style.display="block";
			}		
		}catch(e){}	
	}
	function addAttachment(){}
</script>
</head>
<body onkeydown="listenerKeyESC()" style="margin: 0px; padding: 0px;" onload="init()">
<c:if test="${param.ext1=='0'}">
	<%@include file="./include/bulStyle_preview_standard.jsp" %>
</c:if>
<c:if test="${param.ext1=='1'}">
	<%@include file="./include/bulStyle_preview_formal_1.jsp" %>
</c:if>
<c:if test="${param.ext1=='2'}">
	<%@include file="./include/bulStyle_preview_formal_2.jsp" %>
</c:if>
</body>
</html> 