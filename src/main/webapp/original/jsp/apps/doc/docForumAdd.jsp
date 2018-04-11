<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.forum.add.title'/></title>
<script> 
<!--
	// 添加文档评论 后刷新页面 应返回添加后的id,服务器时间
	function addForum(id,curDate) {
		var commentIframe = window.dialogArguments.document.getElementById("docOpenBodyFrame").contentWindow;
		if(!commentIframe){
			commentIframe = window.opener.document.getElementById("docOpenBodyFrame").contentWindow;
		}
		var content = document.getElementById("content").value;
		var curUserName = "${v3x:currentUser().name}";
		var comment = "<div id='forums"+id+"'><div  class=\"div-float-clear open-doc-border\" style=\"width: 100%;\"><div class=\"optionWriterName\">"
					+"<div class=\"div-float font-12px\" style=\"color: #335186;\"><b>"+curUserName+"</b> "+curDate
					+"</div><div class=\"div-float-right\"><a href=\"javascript:reply('"+id+"');\" class=\"font-12px\"><fmt:message key='doc.jsp.open.body.reply'/></a>&nbsp;"
					+"<a href=\"javascript:deleteForum('"+id+"','true');\" class=\"font-12px\"><fmt:message key='doc.jsp.open.body.delete'/></a></div></div>"
					+"<div class=\"optionContents wordbreak\">"+content.escapeHTML()+"</div><div id=\"replyForum"+id+"\"></div>"
					+"<div class=\"comment-div div-float\" style=\"display: none\" id=\"replyDiv"+id+"\"></div>"
					+"</div><div class=\"clear-both\" style=\"height: 5px; clear: both;\"></div></div>";
		var signOpinion = commentIframe.document.getElementById("signOpinion");
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
			 "forumOneTime", false);
		requestCaller.addParameter(1, "Long", '${param.docResId}');
		requestCaller.serviceRequest();	
		var items = commentIframe.document.getElementById("items");
		items.innerText = parseInt(items.innerText,10)+1;
		signOpinion.innerHTML = signOpinion.innerHTML+comment;
		var commentCount = window.dialogArguments.parent.docOpenLabelFrame.document.getElementById("commentCount");
		if(commentCount!=null) commentCount.innerText = items.innerText;
		window.close();
	}
//-->
</script>
</head>
<body bgColor="#f6f6f6" scroll="no" onkeydown="listenerKeyESC()">
<form name="mainForm" id="mainForm" action="${detailURL }?method=docForumAdd&docResId=${param.docResId}&docLibType=${param.docLibType}&all=${param.all}" method="post" target="folderIframe" onsubmit="return checkForm(this);">
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" class="PopupTitle"><fmt:message key='doc.jsp.forum.add.title'/></td>
		</tr>
		<tr>
			<td class="bg-advance-middel">
				<textarea name="content" id="content" style="width:100%" rows="5" 
				 inputName="<fmt:message key='doc.jsp.forum.add.title'/>" maxSize="1200" validate="notNull"></textarea>			
			</td>
		</tr>
		<tr>
			<td height="42" align="right" class="bg-advance-bottom">
				<input type="submit" name="b1" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
				<input type="button" name="b2" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
	<TABLE cellSpacing=0 cellPadding=0 align=center>
		<TBODY>
			<tr>
				<td height="100"></td>
			</tr>
		</TBODY>
	</TABLE>
</form>
<iframe name="folderIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"/>
</body>
</html>