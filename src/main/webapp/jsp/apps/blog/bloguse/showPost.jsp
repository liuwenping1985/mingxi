<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<%@ include file="../../../common/INC/noCache.jsp"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<title>${v3x:toHTML(name)}</title>
<script type="text/javascript">
var from='${param.from}';
  var fromFlag ="${param.fromFlag}";
	function setCenterDiv(){
		try{
			var oWidth = parseInt(document.body.clientWidth)-80;
			var center_div = document.getElementById('scrollDiv');
			if(center_div){
				center_div.style.width = oWidth+"px";
			}
		}catch(e){}
	}
	function addResize(){
		if(document.all){
	        window.attachEvent("onresize",setCenterDiv);
	        window.attachEvent("onfocus",setCenterDiv);
	    }else{
	    	window.addEventListener("resize",setCenterDiv,false);
	    	window.addEventListener("focus",setCenterDiv,false);
		}
		setCenterDiv();
	}
	 function exist(){
		 addResize();
	 var exist = '${dataExist}';
		
		if('false' == exist){	
			alert(v3x.getMessage("BlogLang.blog_data_delete_alert"));
			if(fromFlag == "share") {
		
				window.location.href=genericURL+"?method=listAllFavoritesArticle&resourceMethod=${resourceMethod}&t="+ new Date();
			
			}else{
				closePage();
		     //window.dialogArguments.location.reload();
		     }
	     }
	     
	   }

	 showAttachment('<c:out value="${article.id}" />', 0, '', '');
	
	function showAddReply(useReplyFlag,useReplyId){
		
		if (useReplyFlag == 0 ){
			document.getElementById("useReplyFlag").value = 0;
		}
		if (useReplyFlag == 3 ){
			document.getElementById("useReplyFlag").value = 3;
		}
		document.getElementById("useReplyId").value = useReplyId;
		document.getElementById("addReply").style.display="";
		document.getElementById("content").focus();
		
		return true;
	}

	function hiddenAddReply(){
		document.getElementById("addReply").style.display="none";
		articleRefresh();
	}

	function replyPost(){
		var postForm = document.getElementById('postForm');
		if(!checkForm(postForm))
			return;
	
		saveAttachment();
		postForm.setAttribute('action','${detailURL}?method=createReplyArticle');
		postForm.setAttribute('target','blogIframe');
		postForm.submit();
	}

	function openTheWindow(){
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxBlogArticleManager", "getState", false);
	     requestCaller.addParameter(1, "long", '${article.id}');
	     flag = requestCaller.serviceRequest();
		if(flag=="true"){
      		getA8Top().openTheWindows = getA8Top().$.dialog({
      	          title:' ',
      	          transParams:{'parentWin':window},
      	          url:  "${detailURL}?method=blogFavorites&&articleId=${article.id}&&familyid=${familyId}&&resourceMethod=showPost",
      	          width: 380,
      	          height: 200,
      	          isDrag:false
      	    });
		}else{
			alert(v3x.getMessage("BlogLang.blog_alert_article_not_share"));
			articleRefresh();
		}
	}
	
	function openTheWindowCallBackFun (returnValue) {
		getA8Top().openTheWindows.close();
		 if(returnValue!= null){
             articleRefresh();
           }
	}
	 
	var srcMethod = '${resourceMethod}';
	var docHomepage = (srcMethod == 'docHomepage');
	var windowUrl = window.location.href;
	var state = '${article.state}';
	var fromFlag="${fromFlag}";
	function articleDel(){
		var postForm = document.getElementById('postForm');
		if(!confirm('<fmt:message key='delete.article.notice.label'/>'))
			return;
			
		var url_ = '${detailURL}?method=deleteArticle&&affairId=${article.id}&&familyId=${familyId}&&resourceMethod=${resourceMethod}';
		if(from == "section"){
			postForm.action = url_;
			postForm.target = "blogIframe";
			postForm.submit();
			closePage();
		}else if(docHomepage){
			postForm.action = url_;
			postForm.target = "blogIframe";
			postForm.submit();
			closePage();
		}else{
			window.location.href = url_;
		}
	}
	
		function articleRefresh(){
         var requestCaller = new XMLHttpRequestCaller(this, "ajaxBlogArticleManager", "getArticleFlag", false);
	       requestCaller.addParameter(1, "long", '${article.id}');
		 
	        flag = requestCaller.serviceRequest();
	  if (flag == 0){

		 alert(v3x.getMessage("BlogLang.blog_alert_source_deleted_article"));
		 closePage();
	  }
		window.location.href = windowUrl;
	}
	
	 
	function editBlog(){
		window.location.href = genericURL+ "?method=updateBlog&blogId=${article.id}&familyId=${article.familyId}&resourceMethod=docHomepage";
		//window.location.href = genericURL+"?method=showPostIframe&articleId=${article.id}&familyId=${article.familyId}&resourceMethod=blogHome&flag=update&v=${ctp:digest_4(article.id,article.familyId,'blogHome','update')}";
	}	
	function articleBack(){

		if(from == "section") {
			window.close();
		}
			else if(fromFlag == "share"){
		
			var _url = '${detailURL}?method=${resourceMethod}&resourceMethod=${resourceMethod}&id=${article.familyId}&userId=${article.employeeId}';
			window.location.href = _url;
		}else if(docHomepage){
			if (typeof(parent.window.transParams) != 'undefined' && parent.window.transParams != null) {
			    parent.window.transParams.parentWin.openBlogDetailCallBack('false');
			} else if (typeof(parent.parent.window.transParams) != 'undefined' && parent.parent.window.transParams != null){
			    parent.parent.window.transParams.parentWin.openBlogDetailCallBack('false');
			} else if (typeof(parent.parent.parent.window.transParams) != 'undefined' && parent.parent.parent.window.transParams != null){
				parent.parent.parent.window.transParams.parentWin.openBlogDetailCallBack('false');
			} else {
				parent.parent.parent.parent.window.transParams.parentWin.openBlogDetailCallBack('false');
			}
		 } else {
		 var _url = '${detailURL}?method=${resourceMethod}&resourceMethod=${resourceMethod}&id=${article.familyId}&userId=${article.employeeId}';
		 var _url = '${detailURL}?method=${resourceMethod}&resourceMethod=${resourceMethod}&id=${article.familyId}&userId=${article.employeeId}';
			window.location.href = _url;
		 }

	}
	 
	function modifyShare(){
       var requestCaller = new XMLHttpRequestCaller(this, "ajaxBlogArticleManager", "modifyShareState", false);
	       requestCaller.addParameter(1, "long", '${article.id}');
		 
	     flag = requestCaller.serviceRequest();
			  window.location.href = window.location.href + "&t=" + new Date();
	
	 }
	 function reloadPage(){
		 window.location.href = genericURL + "?method=showPost&articleId=${article.id}&familyId=${familyId}&resourceMethod=${resourceMethod}&where=${param.where}&t=" + new Date() + "&v=${v}";
	 }
	 function closePage(){
		 if (typeof(parent.window.transParams) != 'undefined' && parent.window.transParams != null) {
             parent.window.transParams.parentWin.openBlogDetailCallBack('false');
         } else if (typeof(parent.parent.window.transParams) != 'undefined' && parent.parent.window.transParams != null){
             parent.parent.window.transParams.parentWin.openBlogDetailCallBack('false');
         } else {
             parent.parent.parent.window.transParams.parentWin.openBlogDetailCallBack('false');
         }
	 }

//-->
</script>

<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
</head>
<body scroll="auto" style="margin: 0px; overflow: auto;" onload = "exist()"  >

<form name="postForm" id="postForm" method="post"  style="margin:0px">
<input type="hidden" name="articleId" value="${article.id}">
<input type="hidden" name="replyUserId" id="replyUserId" value="${replyUserId}">
<input type="hidden" name="resourceMethod" value="${resourceMethod}">
<input type="hidden" name="familyId" value="${familyId}">
<input type="hidden" name="useReplyFlag" id="useReplyFlag" value="0">
<input type="hidden" name="useReplyId" id="useReplyId" value="${replyPost.id}">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="blue" style="word-break:break-all;word-wrap:break-word">		
	
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="page-list-border-LRD">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		       			<td width="45"><div class="notepager"></div></td>
						<td id="notepagerTitle1" class="page2-header-bg">&nbsp;<fmt:message key="blog.label" /></td>
						<td class="page2-header-line padding-right" align="right" id="back">&nbsp; </td>
			        </tr>
			 </table>
		</td>
	</tr>
	
	<tr>
		<td align="center" colspan="3" class="paddingLR blogViewTitle" height="30" valign="bottom">
			${v3x:toHTML(article.subject)}
		
		</td>
	</tr>
		<tr>
		<td align="right" colspan="3" height="24" valign="bottom" class="paddingLR ">
						<!-- 收藏 -->
						
						<c:if test = "${canShareFlag!= 1}">

		         <c:if test="${canFavoritesFlag == 1}">
						<a   href="javascript:openTheWindow()" class="font-12px hyper_link2 cursor-hand">
						[<fmt:message key="blog.family.favorites.label" />]
						</a> &nbsp; 
					</c:if>
					<c:if test="${canFavoritesFlag == 0}">
					<font  class="font-12px ">
					<fmt:message key="blog.family.favorites.done" />
					</font> &nbsp; 
					</c:if>
		    </c:if>
			<!-- 刷新 --> 
			<a   href="javascript:articleRefresh()" class="font-12px hyper_link2 cursor-hand"> 
				[<fmt:message key="common.toolbar.refresh.label" bundle="${v3xCommonI18N}" />]
			</a>&nbsp; 
			
			 <c:if test="${canShareFlag == 1}">
                  <c:if test="${article.state == 0}">
			      <a  href="javascript:modifyShare()" class="font-12px hyper_link2 cursor-hand">
				    [<fmt:message key="blog.cancelshare.label"/>]
				    </a>&nbsp;&nbsp;
			      </c:if>
			      <c:if test="${article.state == 1}">
			      <a  href="javascript:modifyShare()" class="font-12px hyper_link2 cursor-hand">
				 [<fmt:message key="blog.setshare.label"/>]
				 </a>&nbsp;&nbsp;
			     </c:if>
	      </c:if>

		
			<!--编辑 -->
			<c:if test="${canEditeArticleFlag == 1}"> 
			<a   href="javascript:editBlog()" class="font-12px hyper_link2 cursor-hand"> 
				[<fmt:message key="common.toolbar.update.label" bundle="${v3xCommonI18N}" />]
			</a>&nbsp;
			</c:if> 
			
			<!-- 删除 --> 
			<c:if test="${canDeleteArticleFlag == 1}"> 
					<a   
						href="javascript:articleDel()" class="font-12px hyper_link2 cursor-hand"> 
				[<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />]</a>&nbsp; 
			</c:if> 		
			
			<!-- 返回 -->
 			<a  href="javascript:articleBack()" class="font-12px hyper_link2 cursor-hand">
				[<fmt:message key="common.button.close.label" bundle="${v3xCommonI18N}" />]
			</a>&nbsp;
       
		

			
			<hr size="0" class="blogBorder">
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center" class="paddingLR font-12px" height="40" valign="top">
	
			<fmt:formatDate value="${article.issueTime}" pattern="${dataPattern}"/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			${issueUserName}
			&nbsp;&nbsp;&nbsp;&nbsp;
			<fmt:message key="blog.clicknumber.label"/>:${article.clickNumber}
			&nbsp;&nbsp;&nbsp;&nbsp;
			<fmt:message key="blog.replynumber.label"/>:${article.replyNumber}
            &nbsp;&nbsp;&nbsp;&nbsp;
			<c:if test="${article.state == 0}">
			<fmt:message key="blog.isshare.label"/>
			</c:if>
			<c:if test="${article.state == 1}">
			<fmt:message key="blog.personal.label"/>
			
			</c:if>



		</td>
	</tr>

	<tr>
		<td colspan="3" class="paddingLR" valign="top" height="100%">

<div class="contentText" id="scrollDiv">${article.content}</div>

		</td>
	</tr>
	<tr>
		<td colspan="3" class="paddingLR" height="10" valign="top">
			<hr size="0" class="blogBorder">
		</td>
	</tr>


		<tr id="attachmentTr" style="display: none">
		<td colspan="3" class="paddingLR" height="30">
			<%-- 附件显示 --%>
			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="50" nowrap="nowrap" class="font-12px"><b><fmt:message key="common.attachment.label"  bundle="${v3xCommonI18N}" /></b>:&nbsp;</td>
					<td width="100%" class="font-12px ">
						<v3x:attachmentDefine attachments="${attachments}" />
						<%-- 
						(<span id="attachmentNumberDiv"></span>)
						--%>
						<script type="text/javascript">
							showAttachment('${article.id}', 0, 'attachmentTr', '');
						</script>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3" class="paddingLR" height="30">
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr height="30">
					<td class="font-12px" ><b><fmt:message key="blog.reply.label"/></b></td>
					<td align="right"><a  class="font-12px hyper_link2" onclick="javascript:showAddReply(0,-1)" href="#buttom"><fmt:message key="blog.reply.action"/></a>&nbsp;&nbsp;</td>
				</tr>
			</table>
		
		</td>
	</tr>
		<tr>
		<td colspan="3" class="paddingLR" height="30">
		
						<!-- 评论栏 -->
				<c:forEach items="${replyModelList}" var="replyPost">
					<div class="font-12px">
							<div class="div-float font-12px">
							<!-- 评论于 -->
								<b>${replyPost.replyUserName}</b>
								<span class="topic-attitude"><fmt:message key="blog.reply.at.label" /></span>
								<fmt:formatDate value="${replyPost.issueTime}" pattern="${dataPattern}"/>
							</div>				
								<c:if test="${replyPost.canBeDeleteFlag == 1}">
									<a class="font-12px hyper_link2"  onclick="return confirm('<fmt:message key='delete.reply.post.notice.label'/>')" href="${detailURL}?method=deleteReplyPost&&postId=${replyPost.id}&&articleId=${article.id}&&familyId=${familyId}&&resourceMethod=${resourceMethod}" class="hyper_link2">
									<fmt:message key="delete.label"/></a>&nbsp;
								</c:if>
								<a  class="font-12px hyper_link2" onclick="javascript:showAddReply(3,'${replyPost.id}')" href="#buttom"><fmt:message key="blog.reply.post.label"/></a>
								<input type="hidden" name="replyId" value="${replyPost.id}">
						
						<!-- 评论意见 -->
							<!-- 评论内容 -->
							<div class="optionContent wordbreak" style="height: auto;">
							${replyPost.content}
							<!-- <v3x:showContent content="${replyPost.content}" type="HTML"/>&nbsp; -->
							<!-- 附件 -->
							<div class="div-float attsContent" style="display: none" id="attsDiv${replyPost.id}">
								<div class="atts-label">
								<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}"/> :&nbsp;&nbsp;</div>
								<v3x:attachmentDefine attachments="${replyPost.attachment}" />
								<script type="text/javascript">showAttachment('${replyPost.id}', 0, 'attsDiv${replyPost.id}');</script>
							</div>
							</div>
						
						<!-- 回复意见 -->
							
						<!-- 回复的评论 -->
						<c:if test="${replyPost.useReplyFlag == 3 }">
							<c:forEach items="${refPostReplyModelList}" var="refReplyPost">
							<c:if test="${refReplyPost.parentId == replyPost.id }">
								<!-- 回复于 -->
								<div style="padding: 0px 50px 0px 50px"><hr color="#CCCCCC" size="0" noshade="noshade"></div>
									<div class="comment-div cursor-hand">
									<b>${refReplyPost.replyUserName}</b>
									<fmt:message key="blog.reply.at.label" />
									<fmt:formatDate value="${refReplyPost.issueTime}" pattern="${dataPattern}"/>
									
									<!-- 删除 -->
									<!-- <div class="div-float-right"> -->
										<c:if test="${replyPost.canBeDeleteFlag == 1}">
												<a  class="font-12px hyper_link2" onclick="return confirm('<fmt:message key='delete.reply.post.notice.label'/>')" href="${detailURL}?method=deleteReplyPost&&postId=${refReplyPost.id}&&articleId=${article.id}&&familyId=${familyId}&&resourceMethod=${resourceMethod}" class="hyper_link2">
											<fmt:message key="delete.label"/></a>&nbsp;&nbsp;&nbsp;&nbsp;
										</c:if>
										</div>
									<!-- 回复内容 -->
										<div class="comment-content wordbreak">
										${refReplyPost.content}
										<!-- <v3x:showContent content="${refReplyPost.content}" type="HTML"/>&nbsp; -->
										<!-- 附件 -->
										<div class="div-float attsContent" style="display: none" id="attsDiv${refReplyPost.id}">
											<div class="atts-label">
											<fmt:message key="common.attachment.label"   bundle="${v3xCommonI18N}"/> :&nbsp;&nbsp;</div>
											<v3x:attachmentDefine attachments="${refReplyPost.attachment}" />
											<script type="text/javascript">showAttachment('${refReplyPost.id}', 0, 'attsDiv${refReplyPost.id}');</script>
										</div>
										</div>
							</c:if>
							</c:forEach>
						</c:if>
						</div>
						<!-- 回复的评论结束 -->
					</c:forEach>

		</td>
	</tr>
		<tr>
		<td colspan="3" class="paddingLR" align="center">	
					<div id="addReply" style="display:none;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="body-detail">
				<tr>
					<td class="blog-title-bar" colspan="2" height="26" valign="middle">
						<div class="blog-div-float-left"><fmt:message
						key="blog.reply.action" /></div></td>
				</tr>
						
				<tr>
					<td width="20%" height="24" align="right" class="font-12px">
						<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />:&nbsp;&nbsp;
					</td>
					<td width="80%" height="24" class="font-12px">
						RE：${v3x:toHTML(v3x:getLimitLengthString(article.subject,70,"..."))}
						<input type="hidden" name="subject"  value="RE：${v3x:toHTML(article.subject)}">
					</td>
				</tr>
			
				<tr id="attachmentTR" style="display:none;">
					<td nowrap height="26" class="font-12px" valign="middle" align="right">
						<fmt:message key="common.attachment.label"   bundle="${v3xCommonI18N}"/>:&nbsp;&nbsp;
					</td>
					<td valign="top" height="26" class="font-12px">
						<div class="div-float">(<span id="attachmentNumberDiv"></span>个)</div>
						<v3x:fileUpload/>
					</td>
				</tr>  
						
				<tr>
					<td align="right" class="font-12px">
						<fmt:message key="blog.content.label"/>:&nbsp;&nbsp;
					</td>
					<td class="font-12px">
						<textarea  rows="5" name="content" id="content" style="width: 87%"
						maxSize="120" validate="notNull" inputName="<fmt:message key="blog.content.label"/>"
						></textarea>
					</td>
				</tr>

				<tr>
					<td>&nbsp;</td>
					<td class="font-12px">
						<input type="button" name="reply" value="<fmt:message key='common.button.submit.label' bundle='${v3xCommonI18N}'/>" onclick="replyPost()" class="button-default-2"> 
						<input type="button" onclick="javascript:hiddenAddReply()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
					</td>
				</tr>
			</table>
		</div>
		</td>
	</tr>
		<tr>
		<td colspan="3" class="paddingLR" height="30">&nbsp;
		</td>
	</tr>
	
</table>

<a name="buttom" id="buttom"></a>
</form>
<iframe name="blogIframe" id="blogIframe" frameborder="0"
	height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />

</body>
</html>