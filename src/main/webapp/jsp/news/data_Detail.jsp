<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./include/taglib.jsp" %>
<%@ include file="./include/header.jsp" %>
<html>
<head>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/news/css/news.css${v3x:resSuffix()}" />">
<title><fmt:message key="news.preview.label" /></title>
<script type="text/javascript">

<!--
	//获取前一页面传来的对象
	var newsObj = window.opener;
	//新闻标题
	var title = newsObj.document.getElementById("title").value.escapeHTML();
	var defaultTitle = getDefaultValue(newsObj.document.getElementById("title")).escapeHTML();
	
	if(title == defaultTitle){
		title = "";
	}
	//发布部门
	var deptName = newsObj.document.getElementById("publishDepartmentName").value.escapeHTML();
	//关键字
	var keywords = newsObj.document.getElementById("keywords").value.escapeHTML();
	//摘要
	var brief = newsObj.document.getElementById("brief").value.escapeHTML();
	var author = "";
	var showPublishUserFlag =  newsObj.document.getElementById('showPublishUserFlag').checked;
	//作者
	if (showPublishUserFlag) {
		author = "${(v3x:currentUser()).name}";
	}
//附件
  var attNumber = newsObj.getFileAttachmentNumber(0);
  var att = "";
  if(attNumber != 0){
      att = "<table><tr><td valign='top' nowrap='nowrap'>" + 
          "<div class='div-float' style='font-weight: bolder; font-size: 12px;'>"
          + '<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />' + "：</div></td>" + 
          "<td valign='top' style='color: #335186;'>" + newsObj.getFileAttachmentName(0) + "</td></tr></table>";
  }

  //关联文档
  var att2Number = newsObj.getFileAttachmentNumber(2);
  var attFile = "";
  if(att2Number != 0){
      attFile = "<table><tr><td valign='top' nowrap='nowrap'>" + 
          "<div class='div-float' style='font-weight: bolder; font-size: 12px;'>"
          + '<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />' + "：</div></td>" + 
          "<td valign='top' style='color: #335186;'>" + newsObj.getFileAttachmentName(2) + "</td></tr></table>";
  }
		//单位新闻板块
		var typeOptions = newsObj.document.getElementById("typeId").options;	
		var newsType = "";
		if(typeOptions){
			for(var i = 0 ; i < typeOptions.length ; i++ ){
				if(typeOptions[i].selected){
					newsType = typeOptions[i].text;
				}
			}
		}
		
	//正文内容
	var content;
 	 if(v3x.useFckEditor){
 	   var oEditorFCK=newsObj.FCKeditorAPI.GetInstance('content');  
 	   content = oEditorFCK.EditingArea.Document.body.innerHTML;
 	 }else{
 	   content = newsObj.CKEDITOR.instances['content'].getData(); 
 	 }
 	 	 
 	 //打印--------------------
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
        printList(tlist,new ArrayList());
        for(var s= 0;s<mergeButtons.length;s++){
            var mergeButton = mergeButtons[s];
            mergeButton.style.display="";
        }
	}
	
	function init(){
		try{
			if(document.getElementById('attachmentNumberDiv').innerHTML==''){
				document.getElementById('attachTr').style.display="none";
			}else{
				document.getElementById('attachTr').style.display="block";
			}
		}catch(e){}	
	}
	
	function addAttachment(){}
//-->
</script>

</head>
<body scroll='yes' style="overflow: auto;" onkeydown="listenerKeyESC()" onload="init()">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td width="100%" height="100%" class="body-bgcolor" valign="top" style="padding-bottom: 8px;" align="center">
		<div class="scrollList">
			<div id="printThis">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="body-detail margin-auto">
			<tr class="page2-header-line-old">
				<td height="60">
					<table width="100%" border="0"  cellspacing="0" cellpadding="0" align="center" class="CollTable">
						<tr class="page2-header-line-old" height="60">
							<td width="80" height="60"><span class="inquiry_img"></span></td>
							<td class="page2-header-bg-old" width="380"><fmt:message key='application.8.label' bundle='${v3xCommonI18N}' /></td>
							<td class="page2-header-line-old page2-header-link" align="right">&nbsp;</td>
							<td class="page2-header-line-old page2-header-link" align="right">
							<div id="noprint" style="visibility:visible" align="right" class="padding5">    
							   <input type="button" name="mergeButton" onclick="printResult()" class="button-default-2" value="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" />	
					   		</div>	
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="3" class="paddingLR newsTitle"	height="30" valign="top">
					<font style="font-size:20px"><script type="text/javascript">
					 if (typeof(title) != "undefined") {
							document.write(title);
					 }
					</script></font>
				</td>
			</tr>
			
			<tr>
				<td height="40" class="padding35">
					<table width="100%" border="0"  cellspacing="0" cellpadding="0" class="">
						<tr>
							<td class="font-12px" align="center" height="28"  colspan="2">
							<script type="text/javascript">document.write((new Date()).format('yyyy-MM-dd HH:mm'));</script>
							&nbsp;&nbsp;&nbsp;&nbsp;<script type="text/javascript">
							if (typeof(content) != "undefined") { 
							  document.write(deptName);
							}
							</script>
							&nbsp;&nbsp;&nbsp;&nbsp;<script type="text/javascript">
							if (typeof(content) != "undefined") { 
						    document.write(author);
							}
							</script>
							&nbsp;&nbsp;&nbsp;&nbsp;
					<fmt:message key="label.readCount" />:0
							</td>
						<tr >
							<td>
								<table align="left">
									<tr>
										<td class="font-12px" align="right" width="60" height="24"><b><fmt:message key="news.data.keywords" />:</b></td>
										<td class="font-12px" style="padding: 0 12px;"><script type="text/javascript"> 
										if (typeof(content) != "undefined") {
										  document.write(keywords);
										}
										</script>&nbsp;</td>
									</tr>
									<tr>
										<td class="font-12px" align="right" width="60" height="24" ><b><fmt:message key="news.data.brief"/>:</b></td>
										<td colspan="5" class="font-12px" style="padding: 0 12px;"><script type="text/javascript">
										if (typeof(content) != "undefined") {
										  document.write(brief);
										}
										</script></td>
									</tr>
								</table>
							</td>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="3" class="padding35 contentText" valign="top">	<br>				
					<table align="center" style="width: 710;">
						<tr>
							<td><script type="text/javascript">
							 if (typeof(content) != "undefined") {
							    document.write(content);
							 }
						</script></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr id="attachTr">
				<td colspan="3" height="20" class="border-top padding5" nowrap="nowrap"><script type="text/javascript">
				 if (typeof(content) != "undefined") {
				    	document.write(att);
				 }
				</script></td>
			</tr>
			<tr id="attachTr2">
                <td colspan="3" height="20" class="border-top padding5" nowrap="nowrap"><script type="text/javascript">
                if (typeof(content) != "undefined") {
                  document.write(attFile);
                }
                </script></td>
            </tr>
		</table>
			</div>

		</div>
		</td>
	</tr>
</table>
</body>
<script language='javascript'>
var attachmentArea = document.getElementById("attachmentArea");
if(attachmentArea){
	var arr = attachmentArea.getElementsByTagName("img");
	for(var i=0;i<arr.length;i++){
		if(arr[i].title=="删除"){
			arr[i].style.display = "none";
		}
	}
}
</script>
</html>