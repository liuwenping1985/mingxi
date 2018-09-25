<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../WEB-INF/jsp/news/include/taglib.jsp" %>
<%@ include file="../../WEB-INF/jsp/news/include/header.jsp" %>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/apps_res/news/css/news.css" />">
<html>
<head>
<title><fmt:message key="news.preview.label" /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" >
	//var newsObj = window.dialogArguments;
	var newsObj = window.opener;
	var title = newsObj.document.all.title.value;
	var deptName = newsObj.document.all.publishDepartmentName.value;
	var keywords = newsObj.document.all.keywords.value;
	var brief = newsObj.document.all.brief.value;
	
	var att = newsObj.document.all.attachment.innerHTML;
	
		var typeOptions = newsObj.document.all.typeId.options;	
		var newsType = "";
		for(var i = 0 ; i < typeOptions.length ; i++ ){
			if(typeOptions[i].selected){
				newsType = typeOptions[i].text;
			}
		}
 	 var oEditorFCK=newsObj.FCKeditorAPI.GetInstance('content');  
 	 var content = oEditorFCK.EditingArea.Document.body.innerHTML;
 	 
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
</script>

</head>
<body scroll='no' onkeydown="listenerKeyESC()">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="body-bgcolor">
	<tr>
		<td width="100%">
		<div class="scrollList">
			<div id="printThis">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="body-detail">
			<tr>
				<td height="60">
					<table width="100%" border="0"  cellspacing="0" cellpadding="0" align="center" class="page2-header-line">
						<tr>
							<td width="80" height="60"><span class="inquiry_img"></span></td>
							<td class="page2-header-bg" width="380"><fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' /></td>
							<td>&nbsp;</td>
							<td class="page2-header-line padding-right" align="right"></td>
						</tr>
					</table>
					<div id="noprint" style="visibility:visible" align="right">    
					   <input type="button" name="mergeButton" onclick="printResult()" class="button-default-2" value="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" />	
			   		</div>	
				</td>
			</tr>
			<tr>
				<td align="center" colspan="3" class="paddingLR newsTitle"	height="30" valign="top">
					<font style="font-size:20px"><script type="text/javascript">
							document.write(title);
					</script></font>
				</td>
			</tr>
			
			<tr>
				<td height="40">
					<table width="100%" border="0"  cellspacing="0" cellpadding="0" style='background-color:#f6f6f6; font-size: 10px;'>
						<tr>
							<td align="right"><fmt:message key="news.data.publishDepartmentId" />:</td><td><script type="text/javascript">document.write(deptName);</script></td>
							<td align="right"><fmt:message key="news.data.type" />:</td><td><script type="text/javascript">document.write(newsType);</script></td>
							<td align="right"><fmt:message key="news.data.keywords" />:</td><td><script type="text/javascript">document.write(keywords);</script>&nbsp;</td>
						</tr>
						<tr>
							<td align="right"><fmt:message key="news.data.brief"/>:</td>
							<td colspan="5"><script type="text/javascript">document.write(brief);</script></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="3" class="paddingLR" valign="top">					
					<script type="text/javascript">
						document.write(content);
					</script>
				</td>
			</tr>
			<tr>
				<td colspan="3" height="20" class="border-top padding5"><script type="text/javascript">document.write(att);</script></td>
			</tr>
		</table>
			</div>

		</div>
		</td>
	</tr>
</table>
</body>
</html>