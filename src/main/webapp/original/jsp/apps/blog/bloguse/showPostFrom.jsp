<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<%@ include file="../../../common/INC/noCache.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<title>${name}</title>
<script type="text/javascript">
var from='${param.from}';
//alert(from);

   // var flag = "${canFavoritesFlag}";
//	alert(flag);
	 function exist(){
	 
	 var exist = '${dataExist}';
		
		if('false' == exist){	
			alert(v3x.getMessage("BlogLang.blog_data_delete_alert"));
	
				window.close();
		     window.dialogArguments.location.reload();

	     }
	
       }



	showAttachment('<c:out value="${article.id}" />', 0, '', '');

	function showAddReply(useReplyFlag,useReplyId){		
		if (useReplyFlag == 0 || useReplyFlag == 3){
			$("#useReplyFlag").val(useReplyFlag);
		}
		
		$("#useReplyId").val(useReplyId);
		$("#addReply").show();
		$("#content").focus();
		return true;
	}

	function hiddenAddReply(){
		$("#addReply").hide();
		articleRefresh();
	}

	function replyPost(){
		if(!checkForm(postForm))
			return;
	
		saveAttachment();
		document.postForm.action = "${detailURL}?method=createReplyArticle";
		document.postForm.target = "blogIframe";
		document.postForm.submit();
	}
	function reloadPage() {
		window.location.href=genericURL+"?method=showPostPro&articleId=${article.id}&resourceMethod=${resourceMethod}&familyId=&from=section&t=" + getUUID() + "&v=${v}";
		window.location.reload(true);
	}
	function openTheWindow(){
		v3x.openWindow({
			url : "${detailURL}?method=blogFavorites&&articleId=${article.id}&&familyid=${familyId}&&resourceMethod=showPost",
			width : "380",
			height : "200",
			resizable : "true",
			scrollbars : "true"
		});
		window.location.href = window.location.href;
	}
	var srcMethod = '${resourceMethod}';
	var docHomepage = (srcMethod == 'docHomepage');
	var windowUrl = window.location.href;
	var state = '${article.state}';
	function articleDel(){
		if(!confirm('<fmt:message key='delete.article.notice.label'/>'))
			return;
			
		var url_ = '${detailURL}?method=deleteArticle&&affairId=${article.id}&&familyid=${familyId}&&resourceMethod=${resourceMethod}';
		
		if(from == "section"){
		    document.postForm.action = url_+"&section=section";
		    document.postForm.target = "blogIframe";
		    document.postForm.submit();
		    
		    $("#blogIframe").load(function(){
		    	articleBack();
		    });
			/*if(parent.window.dialogArguments){
			    if(parent.window.dialogArguments.callbackOfPendingSection){
			        parent.window.dialogArguments.callbackOfPendingSection(parent.window.dialogArguments.sectionId);
			    }
			}*/
		}
	}
	
	function refreshSection(){
	    /*if(parent.window.dialogArguments){
            if(parent.window.dialogArguments.callbackOfPendingSection){
                parent.window.dialogArguments.callbackOfPendingSection(parent.window.dialogArguments.sectionId);
            }
        }*/
	    window.dialogArguments.getA8Top().reFlesh();
	    articleBack();
	}
	
	function articleRefresh(){
       var requestCaller = new XMLHttpRequestCaller(this, "ajaxBlogArticleManager", "getArticleFlag", false);
       requestCaller.addParameter(1, "long", '${article.id}');
	 
      flag = requestCaller.serviceRequest();
	  if (flag == 0){
		 alert(v3x.getMessage("BlogLang.blog_alert_source_deleted_article"));
		 articleBack();
	  }
	  window.location.href = windowUrl;
	}
	
	function articleBack(){		
		if(v3x.isFirefox||v3x.isSafari||v3x.isChrome){
			top.close();
		}else{
			window.close();
		}	
		
		if(parent.window.parentDialogObj){
		    var dialogDealColl = parent.window.parentDialogObj["dialogDealColl"];
	        if(dialogDealColl){//从首页打开
	            dialogDealColl.close();
	        }
		}
	}
	 
	function modifyShare(){
       var requestCaller = new XMLHttpRequestCaller(this, "ajaxBlogArticleManager", "modifyShareState", false);
	       requestCaller.addParameter(1, "long", '${article.id}');
		 
	     flag = requestCaller.serviceRequest();
	      //	alert(flag);
	  
		
			 // window.location.href = windowUrl;
			    window.location.href = window.location.href + "&t=" + getUUID();
	
	 }
	/** var requestCaller = new XMLHttpRequestCaller(�ص����, AJAX Service Name, ������, �Ƿ��첽, ���ݷ�ʽ) 
��Ӳ���requestCaller.addParameter(˳���, ����, ֵ) 
��������requestCaller.serviceRequest(); 
�ó��� ---http://128.2.2.122/portal/_ns:YTd8YzB8ZDB8ZV9zcGFnZT0xPS9ibG9nLmRv/seeyon/default-page.psml?method=showPost&articleId=-6796134224484482003&familyId=3637461752692951198&resourceMethod=docHomepage
*/


</script>

<script>
//alert(${canShareFlag});
//alert(${canDeleteArticleFlag});

</script>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
</head>
<body scroll="auto" style="margin: 0px; overflow: auto;" onload = "exist()">

<form name="postForm" id="postForm" method="post"  style="margin:0px">
<input type="hidden" id="articleId"name="articleId" value="${article.id}">
<input type="hidden" id="replyUserId" name="replyUserId" value="${replyUserId}">
<input type="hidden" id="resourceMethod"name="resourceMethod" value="${resourceMethod}">
<input type="hidden" id="familyId"name="familyId" value="${familyId}">
<input type="hidden" id="useReplyFlag" name="useReplyFlag" value="0">
<input type="hidden" id="useReplyId" name="useReplyId" value="${replyPost.id}">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="blue" style="word-break:break-all;word-wrap:break-word">		
	<tr class="page2-header-line">
		<td>
			<table width="100%"  border="0" cellpadding="0" cellspacing="0">
			     <tr class="page2-header-line">
	                <td width="45"><div class="notepager"/></td>
			        <td class="page2-header-bg"><fmt:message key="blog.label" /></td>
			        <td class="page2-header-line page2-header-link" align="right">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center" colspan="3" class="paddingLR blogViewTitle" height="30" valign="bottom">
			${article.subject}
		</td>
	</tr>
		<tr>
		<td align="right" colspan="3" height="24" valign="bottom" class="paddingLR ">
			<a   href="javascript:articleRefresh()" class="font-12px hyper_link2"> 
				[<fmt:message key="common.toolbar.refresh.label" bundle="${v3xCommonI18N}" />]
			</a>&nbsp; 
			
         <c:if test="${canShareFlag == 1}">
                  <c:if test="${article.state == 0}">
			      <a  href="javascript:modifyShare()" class="font-12px hyper_link2">
				    [<fmt:message key="blog.cancelshare.label"/>]
					</a>&nbsp;&nbsp;
			      </c:if>
			      <c:if test="${article.state == 1}">
			      <a  href="javascript:modifyShare()" class="font-12px hyper_link2">
				 [<fmt:message key="blog.setshare.label"/>]
				 		</a>&nbsp;&nbsp;
			     </c:if>
	      </c:if>			
			
						<!--Favoriteղ� -->
			<c:if test = "${canShareFlag!= 1}">

		         <c:if test="${canFavoritesFlag == 1}">
						<a   href="javascript:openTheWindow()" class="font-12px hyper_link2">
						[<fmt:message key="blog.family.favorites.label" />]
						</a> &nbsp; 
					</c:if>
					<c:if test="${canFavoritesFlag == 0}">
					<font  class="font-12px hyper_link2">
					<fmt:message key="blog.family.favorites.done" />
					</font> &nbsp; 
					</c:if>
		    </c:if>
						
	<!--       <c:if test="${isAdmin != true}">    
			 <c:if test="${canReplyFlag == 1}">  -->
		
		<!--		<c:if test="${canDeleteArticleFlag != 1}">  -->
				
			<!--  	<c:if test="${canFavoritesFlag == 1}">
						<a   href="javascript:openTheWindow()" class="font-12px hyper_link2">
						[<fmt:message key="blog.family.favorites.label" />]
						</a> &nbsp; 
					</c:if>
					<c:if test="${canFavoritesFlag == 0}">
					<font  class="font-12px hyper_link2">
					<fmt:message key="blog.family.favorites.done" />
					</font> &nbsp; 
					</c:if>
			<!--	</c:if> 
			  </c:if> 
		</c:if> 

			  
         <c:if test= "${isAdmin == true}"> 
               <c:if test="${canFavoritesFlag == 1}"> 

			  <a   href="javascript:openTheWindow()" class="font-12px hyper_link2"> 
						[<fmt:message key="blog.family.favorites.label" />] 
						</a> &nbsp;  
			   </c:if> 
               <c:if test="${canFavoritesFlag == 0}"> 
			   <font  class="font-12px hyper_link2"> 
					<fmt:message key="blog.family.favorites.done" /> 
					</font> &nbsp;  
			    </c:if> 
		</c:if>     -->



			<!-- ɾ�� --> 
			<c:if test="${canDeleteArticleFlag == 1}"> 
					<a   
						href="javascript:articleDel()" class="font-12px hyper_link2"> 
				[<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />]</a>&nbsp; 
			</c:if> 
			<!-- ˢ�� --> 

			<!-- ���� -->
 			<a  href="javascript:articleBack()" class="font-12px hyper_link2">
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

<div class="contentText">${article.content}</div>

		</td>
	</tr>
	<tr>
		<td colspan="3" class="paddingLR" height="10" valign="top">
			<hr size="0" class="blogBorder">
		</td>
	</tr>


		<tr id="attachmentTr" style="display: none">
		<td colspan="3" class="paddingLR" height="30">
			<%-- ������ʾ --%>
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
		<c:if test="${article.state == 0}">	
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr height="30">
					<td class="font-12px" ><b><fmt:message key="blog.reply.label"/></b></td>
					<td align="right"><a  class="font-12px hyper_link2" onclick="javascript:showAddReply(0,-1)" href="#buttom"><fmt:message key="blog.reply.action"/></a>&nbsp;&nbsp;</td>
				</tr>
			</table>
		</c:if>
		</td>
	</tr>
		<tr>
		<td colspan="3" class="paddingLR" height="30">	
		<c:if test="${article.state == 0}">	
						<!-- ����8 -->
				<c:forEach items="${replyModelList}" var="replyPost">
					<div class="font-12px">
							<div class="div-float font-12px">
							<!-- ������ -->
								<b>${replyPost.replyUserName}</b>
								<span class="topic-attitude"><fmt:message key="blog.reply.at.label" /></span>
								<fmt:formatDate value="${replyPost.issueTime}" pattern="${dataPattern}"/>
							</div>				
								<c:if test="${replyPost.canBeDeleteFlag == 1}">
									<a class="font-12px hyper_link2"  onclick="return confirm('<fmt:message key='delete.reply.post.notice.label'/>')" href="${detailURL}?method=deleteReplyPost&&from=${param.from}&&postId=${replyPost.id}&&articleId=${article.id}&&resourceMethod=${resourceMethod}" class="hyper_link2">
									<fmt:message key="delete.label"/></a>&nbsp;
								</c:if>
								<a  class="font-12px hyper_link2" onclick="javascript:showAddReply(3,'${replyPost.id}')" href="#buttom"><fmt:message key="blog.reply.post.label"/></a>
								<input type="hidden" name="replyId" value="${replyPost.id}">
						
						<!-- ������� -->
							<!-- �������� -->
							<div class="optionContent wordbreak">
							${replyPost.content}
							<!-- <v3x:showContent content="${replyPost.content}" type="HTML"/>&nbsp; -->
							<!-- ���� -->
							<div class="div-float attsContent" style="display: none" id="attsDiv${replyPost.id}">
								<div class="atts-label">
								<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}"/> :&nbsp;&nbsp;</div>
								<v3x:attachmentDefine attachments="${replyPost.attachment}" />
								<script type="text/javascript">showAttachment('${replyPost.id}', 0, 'attsDiv${replyPost.id}');</script>
							</div>
							</div>
						
						<!-- �ظ���� -->
							
						<!-- �ظ������� -->
						<c:if test="${replyPost.useReplyFlag == 3 }">
							<c:forEach items="${refPostReplyModelList}" var="refReplyPost">
							<c:if test="${refReplyPost.parentId == replyPost.id }">
								<!-- �ظ��� -->
								<div style="padding: 0px 50px 0px 50px"><hr color="#CCCCCC" size="0" noshade="noshade"></div>
									<div class="comment-div cursor-hand">
									<b>${refReplyPost.replyUserName}</b>
									<fmt:message key="blog.reply.at.label" />
									<fmt:formatDate value="${refReplyPost.issueTime}" pattern="${dataPattern}"/>
									
									<!-- ɾ�� -->
									<!-- <div class="div-float-right"> -->
										<c:if test="${replyPost.canBeDeleteFlag == 1}">
												<a  class="font-12px hyper_link2" onclick="return confirm('<fmt:message key='delete.reply.post.notice.label'/>')" href="${detailURL}?method=deleteReplyPost&&postId=${refReplyPost.id}&&articleId=${article.id}&&resourceMethod=${resourceMethod}" class="hyper_link2">
											<fmt:message key="delete.label"/></a>&nbsp;&nbsp;&nbsp;&nbsp;
										</c:if>
										</div>
									<!-- �ظ����� -->
										<div class="comment-content wordbreak">
										${refReplyPost.content}
										<!-- <v3x:showContent content="${refReplyPost.content}" type="HTML"/>&nbsp; -->
										<!-- ���� -->
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
						<!-- �ظ������۽��� -->
					</c:forEach>
			<!-- ���������� -->
			</c:if>
		</td>
	</tr>
		<tr>
		<td colspan="3" class="paddingLR" align="center" >	
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
						RE:${v3x:getLimitLengthString(article.subject,70,"...")}
						<input type="hidden" name="subject"  value="RE:${article.subject}">
					</td>
				</tr>
			
				<tr id="attachmentTR" style="display:none;">
					<td nowrap height="26" class="font-12px" valign="middle" align="right">
						<fmt:message key="common.attachment.label"   bundle="${v3xCommonI18N}"/>:&nbsp;&nbsp;
					</td>
					<td valign="top" height="26" class="font-12px">
						<div class="div-float">(<span id="attachmentNumberDiv"></span>��)</div>
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
<iframe name="blogIframe" id="blogIframe" frameborder="0"	height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />
</body>
</html>


















