<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="docHeader.jsp"%>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<script>
<!--
	function reply(opinionId) {
		var obj = document.getElementById("replyDiv" + opinionId);
		if(obj){
			obj.innerHTML = document.getElementById("replyCommentHTML").innerHTML;
			obj.style.display = "block";
			document.getElementById("opinionId").value=opinionId;
		}
	}

	function doReply() {
		if(!checkForm(document.getElementById("repform")))
			return;

		var opinionId=document.getElementById("opinionId").value;
		var content=document.getElementById("content").value;
		var the_content=encodeURI(content);
	
		self.location.href=jsURL + "?method=docForumReply&docResId=${param.docResId}&docLibType=${param.docLibType}&all=${param.all}&forumId=" + opinionId+"&content="+the_content;
/**			var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
			 "forumOneTime", false);
		requestCaller.addParameter(1, "Long", '${param.docResId}');

		requestCaller.serviceRequest();


			parent.docOpenLabelFrame.location.href = jsURL + "?method=docOpenLabel&docResId=${param.docResId}&docLibId=${param.docLibId}&docLibType=${param.docLibType}";  **/
	}

	function cancelReply() {
		var opinionId=document.getElementById("opinionId").value;
		var obj = document.getElementById("replyDiv" + opinionId);
		obj.style.display = "none";
	}

	function deleteForum(id, flag) {

	/**	var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
			 "deleteForumOneTime", false);
		requestCaller.addParameter(1, "Long", '${param.docResId}');

		requestCaller.serviceRequest();	   **/

		parent.docOpenForumFrame.location.href = jsURL + "?method=deleteDocForum&docResId=${param.docResId}&docLibType=${param.docLibType}&all=${param.all}&forumId=" + id + "&flag=" + flag;
	/**	parent.docOpenLabelFrame.location.href = jsURL + "?method=docOpenLabel&docResId=${param.docResId}&docLibId=${param.docLibId}&docLibType=${param.docLibType}";  **/
	}

	function docDownLoad(fileId,fileName,theDate) {
		document.getElementById("emptyIframe").src="/seeyon/fileUpload.do?method=download&fileId="+fileId+"&createDate="+theDate+"&filename="+encodeURI(fileName);

		//self.document.location.reload(true);
	}

	window.onload = function(){
	showProcDiv();
}
	function showProcDiv(){
		var width = 240;
		var height = 100;

		var left = (document.body.scrollWidth - width) / 8 * 5;
		var top = (document.body.scrollHeight - height) / 3;

		var str = "";
			str += '<div id="procDIV" style="position:absolute;left:'+left+'px;top:'+top+'px;width:'+width+'px;height:'+height+'px;z-index:50;border:solid 2px #DBDBDB;">';
			str += "<table width=\"100%\" height=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" bgcolor='#F6F6F6'>";
			str += "  <tr>";
			str += "    <td align='center' id='procText' style='font-size:12px' height='40' valign='bottom'>&nbsp;</td>";
			str += "  </tr>";
			str += "  <tr>";
			str += "    <td align='center'><span class='process'>&nbsp;</span></td>";
			str += "  </tr>";
			str += "</table>";
			str += "</div>";

		document.getElementById("procDiv1").innerHTML = str;
		document.close();
	}

	function startProc(title){
		//title = title || v3x.getMessage("V3XLang.common_process_label");

		var procTextE = document.getElementById("procText");
		if(procTextE){
			procTextE.innerText = title;
		}

		var divE = document.getElementById("procDiv1");
		if(divE){
			divE.style.display = "";
		}
	}
	function endProc(){
		var divE = document.getElementById("procDiv1");
		if(divE){
			divE.style.display = "none";
		}
	}
	var docOpenUpFrameUpConstants = {
		status_0 : "0,*",
		status_1 : "50%,*"
	}
	var docOpenUpFrameDownConstants = {
		status_0 : "*,12",
		status_1 : "50%,*"
	}
	var docOpenUpFrameMiddleConstants = {
		status_0 : "50%,*",
		status_1 : "50%,*"
	}
	function previewFrame(direction){
		if(!direction) return;
		var obj = parent.parent.document.all.docOpenUpFrame;
		if(obj == null){
			obj = parent.document.all.docOpenUpFrame;
		}
		
		if(obj == null){
			return;
		}
		
		if(indexFlag > 1){
			indexFlag = 0;
		}
			
		var status = eval("docOpenUpFrame" + direction + "Constants.status_" + indexFlag);
		obj.rows = status;
		
		if(direction != "Middle"){
			indexFlag++;
		}
	}
//-->
</script>
</head>
<body>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
	<tr>
		<td height="8">
			<script type="text/javascript">
				getDetailPageBreak(true);
			</script>
		</td>
	</tr>
	<tr><td height="40">
		<div id="docTitle">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" height="20" align="center">
				<tr>
					<td height="10" class="detail-summary">
						<div class="body-detail-su"><fmt:message key='doc.jsp.open.body.comment'/>:</div>
					</td>
				</tr>
			    <tr>
					<td height="5" class="detail-summary-separator"></td>
				</tr>
			</table>
	</div>
	</td></tr>
	<tr>
		<td>
			<div id="divScroll" class="scrollList">
				<c:if test="${vo.docResource.commentCount!=0}">
				<div class="doc-body-line-sp"></div>
				<div id="docReply">
				<table height="100" border="0" cellspacing="0" cellpadding="0"  width="100%" align="center">
				  <tr valign="top">
				  <td width="5%"></td>
				    <td class="" id="signOpinion" align="left">
						<c:forEach items="${vo.forums}" var="forum">
						<div class="div-float-clear open-doc-border" style="width: 100%;">
							<div class="optionWriterName">
								<div class="div-float font-12px">
									<b>${forum.name}</b>
									<fmt:formatDate value='${forum.time}' pattern='${datetimePattern}' />
								</div>
								<div class="div-float-right">
								 <c:if test="${vo.docResource.commentEnabled == true}">
									<a href="javascript:reply('${forum.forum.id}');" class="font-12px"><fmt:message key='doc.jsp.open.body.reply'/></a>&nbsp;
									</c:if>
									<c:if test="${param.all == true}"><a href="javascript:deleteForum('${forum.forum.id}','true');" class="font-12px"><fmt:message key='doc.jsp.open.body.delete'/></a></c:if>
								</div>
							</div>
				
				
									<div class="optionContent wordbreak">${v3x:toHTML(forum.body)}</div>
				
							<c:forEach items="${forum.replys}" var="reply">
								<div style="padding: 0px 10px 0px 10px"><hr color="#CCCCCC" size="1" noshade="noshade"></div>
								<div class="comment-div">
									${reply.name} <fmt:formatDate value='${reply.time}' pattern='${datetimePattern}'/>&nbsp;&nbsp;&nbsp;&nbsp;<c:if test="${param.all == true}"><a href="javascript:deleteForum('${reply.forum.id}','false');" class="font-12px"><fmt:message key='doc.jsp.open.body.delete'/></a></c:if>
								</div>
								<div class="comment-content wordbreak">
									${v3x:toHTML(reply.body)}
								</div>
						    </c:forEach>
				
							<div class="comment-div div-float" style="display: none" id="replyDiv${forum.forum.id}"></div>
				
						</div>
						<div class="clear-both" style="height: 5px; clear: both;"></div>
						</c:forEach>
				
					</td>
					<td width="5%"></td>
				  </tr>
				</table>
				
				<div class="doc-body-line-sp"></div>
				
				</div>
				</c:if>
				<div style="display:none" id="replyCommentHTML">
					<form name="repform" id="repform" method="post" action="" style="margin: 0px;">
					<div class="div-float" style="width: 100%;">
						<textarea name="content" cols="" rows="" style="width: 100%;height: 100px"
						class="font-12px" inputName="<fmt:message key='doc.jsp.open.body.reply'/>"
						validate="notNull" maxSize="1200"></textarea>
						<div class="div-float-right font-12px">
							<input type="hidden" name="opinionId" id="opinionId" value="">
							<input type="hidden" name="isNoteAddOrReply" value="reply">
							<input type="button" name="b12" class="button-default_emphasize" onclick="doReply();" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>">&nbsp;
							<input type="button" name="b13" class="button-default-2" onclick="cancelReply();" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>">
						</div>
					</div>
					</form>
				</div>
			</div>
			<div id="procDiv1" style="display:none;"></div>
		</td>
	</tr>
</table>
<iframe id="emptyIframe" name="emptyIframe" frameborder="0"	height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />
</body>
</html>