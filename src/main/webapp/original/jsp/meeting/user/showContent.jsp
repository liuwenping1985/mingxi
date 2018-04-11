<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html style="height:100%;">
<head>
<%@ include file="../include/header.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>">
<style type="text/css">
	div,table{font-family: SimSun, Arial, Helvetica, sans-serif;}
	.button-default-2{*padding-left:3px; *padding-right:3px;}
	.w100b { width: 100%;}
	.h500px { height: 500px;}
	/* 页签的title */
	.body-detail-su{height: 31px;font-size:14px;border-top: solid 2px; color: #666;padding: 13px 0px 0px 15px;margin-bottom: 10px;}
	.meeting-title-feedback{border-color: #3399da;background: #e0ebf0;}
	.meeting-title-record{border-color: #d9a334;background: #fef8d9;}
	.meeting-title-task{border-color: #5ebc21;background: #f2feed;}
	/** 会议任务样式 */
	.meeting-task{margin: 20px auto 30px;text-align: center;}
	.meeting-task>a{display: inline-block;font-size: 18px;color: #666;text-decoration: none;margin-left: 30px; }
	.meeting-task>a.task-status-all{margin-left: 0px;}
	.meeting-task>a>span{margin-top: 12px;display: inherit;}
	.meeting-task>a>div{border: solid 1px; height: 86px;width: 86px;border-radius:44px;background: #fff;text-decoration: none;}
	.meeting-task>a>div:hover{color:#fff;}
	.meeting-task>a>div>span{margin-top: 24px;font-size: 26px;display: inherit;}
	.task-status-all>div{border-color:#5698df ;color:#5698df;}
	.task-status-all>div:HOVER{background: #5698df;}
	.task-status-unfinished>div{border-color:#f09b2f;color:#f09b2f;}
	.task-status-unfinished>div:HOVER{background: #f09b2f;}
	.task-status-overdue>div{border-color:#ee4930;color:#ee4930;}
	.task-status-overdue>div:HOVER{background: #ee4930;}
	.task-status-finished>div{border-color:#4da741;color:#4da741;}
	.task-status-finished>div:HOVER{background: #4da741;}
	.task-status-canceled>div{border-color:#7b7b7b;color:#7b7b7b;}
	.task-status-canceled>div:HOVER{background: #7b7b7b;}
</style>

<c:set value="${v3x:currentUser().id}" var="currentUserId"/>
<c:set value="${v3x:showMemberName(currentUserId)}" var="currentUserName"/>
<c:set value="${v3x:getMyAgentId(1)}" var="agentToId"/>
<fmt:message key="common.opinion.been.hidden.label" bundle="${v3xCommonI18N}" var="opinionHidden" />
<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" var="attachmentLabel" />
<fmt:message key="common.toolbar.insert.mydocument.label" bundle="${v3xCommonI18N}" var="mydocumentLabel" />

<c:if test="${v3x:hasPlugin('collaboration')}">
	<script type="text/javascript" src="<c:url value="/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"/>"></script>
</c:if>

<v3x:attachmentDefine attachments="${attachments}" />

<script type="text/javascript">
var currentUserId = '${currentUserId}';
var currentUserName = '${v3x:toHTML(currentUserName)}';
var opinionHidden = "${v3x:escapeJavascript(opinionHidden)}";
var attachmentLabel = "${v3x:escapeJavascript(attachmentLabel)}";
var mydocumentLabel = "${v3x:escapeJavascript(mydocumentLabel)}";
	    
//会议总结转发协同
function summaryToCol(app){
    var url = "";
	var parentObj = window.dialogArguments;
	if(parentObj == undefined){
	    parentObj = parent.window.dialogArguments;
	}
	if(parentObj == undefined){
              parentObj = parent.parent.window.dialogArguments;
          }
          if(parentObj == undefined){
              parentObj = parent.parent.parent.window.dialogArguments;
          }

          if(app == 'edoc'){
          	url = "edocController.do?method=entryManager&entry=sendManager&toFrom=newEdoc&meetingSummaryId=${summary.id}";
          }

	//判断会议总结是否存在   做防护
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxMtSummaryTemplateManager", "isMeetingSummaryExist", false);
	requestCaller.addParameter(1, "Long", '${bean.id}');
	var ds = requestCaller.serviceRequest();
	if(ds=='false'){
		alert(v3x.getMessage("meetingLang.meeting_has_delete"));
		return;
	}

	//转协同，调用接口
	if(app == 'coll'){
		
		if(!window.getCtpTop){
			
			window.getCtpTop = function(){
				
				var _a8TopWin = null;
	            
	            if(parent.parent.parent.meeting_report_main_frame_flag === "true"){//绩效这块写死，组件dialog无法传值过来，OA-80459
	                
	                _a8TopWin = parent.parent.parent.parent.getA8Top();
	            
	            }else if(parentObj){
	                if(parentObj.pwindow){//首页栏目入口
	                    _a8TopWin = parentObj.pwindow.getA8Top();
	                }else{//系统消息，模态框入口
	                    if(parentObj.top && parentObj.getA8Top().main){
	                        _a8TopWin = parentObj.getA8Top();
	                    }else if(parentObj.top == null || parentObj.top == "undefined"){
	                        if(parentObj.window.main){//时间线打开
	                            _a8TopWin = parentObj.window;
	                        }else if(parentObj.window.parent.main){//从时间视图入口 -OA-48049
	                            _a8TopWin = parentObj.window.parent;
	                        }else {//从日程入口
	                        	_a8TopWin = parentObj.window.parent.window.parent.getA8Top();
	                        }
	                    }else {
	                    }
	                
	                    //window.close();
	                }
	                
	            }else if(typeof(parent.window.opener) != 'undefined' && parent.window.opener != null ){//文档中心跳转
	            	_a8TopWin = parent.window.opener.parent.parent.getA8Top();
	            } else{//列表入口
	                
	                if(parent.parent.parent.parent.fromPage == "isearch"){
	                    //全文检索，综合查询查看详情
	                    _a8TopWin = parent.parent.parent.parent.getA8Top();
	                }else{
	                    if(parent.parent.parent.parent.parent){//跳转到协同框架层OA-42945
	                        _a8TopWin = parent.parent.parent.parent.parent.parent.getA8Top();
	                    } else{
	                        _a8TopWin = parent.parent.parent.parent.parent.getA8Top();
	                    }
	                }
	            }
	            
	            return _a8TopWin;
			}
		}
		
		collaborationApi.newColl({
	        manual : "true",//后台进行数据设置
	        from : 'meeting_summary',
	        handlerName : 'meeting',
	        sourceId : '${summary.id}',
	        ext : ''
	    });
		return;
          }
	
    if(parent.parent.parent.meeting_report_main_frame_flag === "true"){//绩效这块写死，组件dialog无法传值过来，OA-80459
        
    	parent.parent.parent.parent.getA8Top().main.location.href = url;
    
    }else if(parentObj){
		//var a8Top = parentObj.getA8Top().window.dialogArguments;
		if(parentObj.pwindow){//首页栏目入口
			//a8Top.parent.parent.location.href=url;
			parentObj.pwindow.getA8Top().main.location.href = url;
		}else{//系统消息，模态框入口
			if(parentObj.top && parentObj.getA8Top().main){
				parentObj.getA8Top().main.location.href=url;
			}else if(parentObj.top == null || parentObj.top == "undefined"){
		        if(parentObj.window.main){//时间线打开
		          parentObj.window.main.location.href = url
		        }else if(parentObj.window.parent.main){//从时间视图入口 -OA-48049
		          parentObj.window.parent.main.location.href=url;
		        }else {//从日程入口
		          parentObj.window.parent.location.href=url;
		        }
			}else {
				var params = [];
				params[0] = "summaryToCollOrEdoc";
				params[1] = url;
				window.returnValue = params;
			}
		
			//parentObj.close();
               window.close();
		}
		
	}else if(typeof(parent.window.opener) != 'undefined' && parent.window.opener != null ){//文档中心跳转
		parent.window.opener.parent.location.href = url;
		parent.window.close();
	}else if((app=='coll' || app == 'edoc') && typeof(getA8Top)!='undefined' && typeof(getA8Top().isCtpTop) == 'undefined'){//多窗口打开会议，转协同、转公文需要在主窗口新建公文
		if(parent.parent.parent.parent.openFromUC=="ucpc"){
			parent.parent.parent.parent.location.href = url+"&openFromUC=ucpc";
		}else{
		    var pWin = getA8Top().window.opener.getA8Top();
		    var tempWin = pWin.main;
		    var mSummaryWin = null;//会议纪要页面
		    if(!tempWin){
		        mSummaryWin = pWin;
		        pWin = mSummaryWin.window.opener.getA8Top();
		        tempWin = pWin.main;
		    }
		    tempWin.location.href=url;
		    //getA8Top().window.opener.getA8Top().main.location.href=url;
			getA8Top().close();
			if(mSummaryWin){
			    mSummaryWin.close(); 
			}
		}
	}else{//列表入口
	    
	    if(parent.parent.parent.parent.fromPage == "isearch"){
	        //全文检索，综合查询查看详情
	        parent.parent.parent.parent.getA8Top().main.location.href = url;
	    }else{
	        if(parent.parent.parent.parent.parent)//跳转到协同框架层OA-42945
                   parent.parent.parent.parent.parent.location.href=url;
               else
                   parent.parent.parent.parent.location.href=url;
	    }
	}
}
		
function init(){
  	//downloadURL = "<html:link renderURL='/fileUpload.do?type=0&applicationCategory=6&extensions=&maxSize=&isEncrypt=true&popupTitleKey=&isA8geniusAdded=false&quantity=255'/>";
	if(parent.parent.parent.parent.openFromUC=="ucpc"){
		var summaryToColHref = document.getElementById("summaryToColHref");
		var summaryToEdocHref = document.getElementById("summaryToEdocHref");
		if(typeof(summaryToColHref)!='undefined' && summaryToColHref != null){
			summaryToColHref.style.display = "none";
		}
		if(typeof(summaryToEdocHref)!='undefined' && summaryToEdocHref != null){
			summaryToEdocHref.style.display = "none";
		}
	}
	try{
		if(!window.trans2Html){
		    var _viewOrgSrcObj = parent.window.document.getElementById("viewOrgSrc");
		    if(_viewOrgSrcObj){
		        _viewOrgSrcObj.style.display = "none";
		    }
		}else{
		  //HTML正文，进行转换后的正文高度计算
		  resetTransOfficeHeight("officeContentTd", "officeContentTable");
		}
	}catch(e){}
}

function setSelectPeople(elements){
    var names = getNamesString(elements);
    var ids = getIdsString(elements,false);
    var showToId = document.getElementById("showToId");
    var showToIdInput = document.getElementById("showToIdInput");
    if(showToId){
        showToId.value = ids;
    }
    if(showToIdInput){
        showToIdInput.value = names;
        showToIdInput.title = names;
    }
}
//isValid 人员是否是有效的，换句话说就是是否已经离职，离职不允许弹出人员卡片
function displayPeopleCard(memberId, isValid){
	if(!isValid || isValid == "false"){
		return ;
  	}
  	var windowObj = parent.window.detailMainFrame;//上下结构打开的方式赋null，通过getA8Top()来获得窗口句柄
	if(typeof windowObj == 'undefined') {
	    windowObj =  parent.parent.window.detailMainFrame;
   	}
	if(typeof windowObj == 'undefined') {
	    windowObj = parent.parent.parent.window.detailMainFrame;
          }
  	showV3XMemberCardWithOutButton(memberId, windowObj);
}


//会议任务
function openMeetingTaskDetail(meetingId ,status) {
	var url = "taskmanage/taskinfo.do?method=meetingTaskList&meetingId="+meetingId+"&status="+status;
	v3x.openWindow({
		  workSpace:true,
		  url : url,
		  dialogType : "open",
		  resizable:"yes"
	  });
}
</script>

</head>
<body class="body-bgcolor" style="overflow:auto; height:100%;" onload="init()">

<c:choose>
	<c:when test="${bean.dataFormat eq 'HTML'}">
		<v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" htmlId="col-contentText" />
	</c:when>
	<c:otherwise>
		<table id="officeContentTable" align="center" border="0" cellspacing="0" cellpadding="0" class="w100b body-detail">
			<tr>
				<td class="h500px" id="officeContentTd">
					    <v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" htmlId="col-contentText" />
				</td>
			</tr>
		</table>
	</c:otherwise>
</c:choose>


<div class="body-line-sp"></div>


<c:if test="${param.from != 'temp'}">
<c:set var="num" value="0"/>

<table align="center" border="0" cellspacing="0" cellpadding="0" class="body-detail">

<tr valign="top">

<td class="body-detail-border" width="100%">
	<div class="body-detail-su meeting-title-feedback" style="padding-left: 15px;">
		<fmt:message key="mt.mtReply.feedback1">
			<fmt:param value="${replySize}" />
		</fmt:message>
	</div>
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0" style="padding-left: 15px; padding-right: 15px;">
		<c:forEach var="mtReply" items="${replyList}">
			<c:if test="${mtReply.feedbackFlag!='-100'}">
				<tr>
					<td width="100%" >
						
					<div class="div-clear" style="width: 100%;">
					<div class="optionWriterName">
					
						<div class="div-float font-12px" style="padding-left: 20px; padding-bottom: 2px; color: #335186;">
	                        <span class="cursor-hand" id="replySpan${mtReply.id }" replyUserId="${mtReply.userId}" onclick="displayPeopleCard('${mtReply.userId}', '${mtReply.validByUser}')">
								<b><c:out value="${mtReply.userName}" /></b>
							</span>
							
							<c:if test="${mtReply.ext1=='1'}">
							<font color="red">
								(<fmt:message key="mt.agent.label1"><fmt:param>${mtReply.ext2}</fmt:param></fmt:message>) 
							</font>
							</c:if>
							
							&nbsp;<b>
														
							<c:if test="${!isImpart && mtReply.feedbackFlag !=3 }">
							<fmt:message key="mt.mtReply.feedback_flag.${mtReply.feedbackFlag }" />
							</c:if>
							
							</b> &nbsp;&nbsp;
														
							<fmt:formatDate value="${mtReply.readDate}" pattern="${datePattern}" />
						</div><!--  div-float -->
													
						<c:if test="${(meetingState eq 10 || meetingState eq 20) && param.isQuote!='true'}">
						<div class="div-float-right" style="padding-right: 20px;">
							<span class="like-a" onclick="opinion_reply('${mtReply.id}','${mtReply.userId}','${v3x:toHTML(mtReply.userName)}');">
                            	<font size="2"><fmt:message key="topic.reply.label"/></font>
                           	</span>
						</div>
						</c:if>
									
					</div><!-- optionWriterName -->
						
					<div class="optionContents" style="width:678px;padding: 2px 20px 2px 20px; word-break:normal;word-wrap:normal;">
						${v3x:toHTMLWithoutSpace(mtReply.feedback)}&nbsp;
					</div>
						
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
						<tr>
							<c:choose>
							<c:when test="${language eq 'en'}">
						 		<td class="align_right" width="110" style="display:none;" id="attachment1Tr${mtReply.id}">
						 	</c:when>
                            <c:otherwise>
                            	<td class="align_right" width="80" style="display:none;" id="attachment1Tr${mtReply.id}">
                            </c:otherwise>
                        	</c:choose>
						 		<div class="atts-label" style="width:100%;" align="right">
						 			${attachmentLabel}:(<span class="font-12px" id="replyAttachmentNumberDiv${mtReply.id}"></span>)
						 		</div>
						 	</td>
						 	<td>
						 		<div class="div-float" style="float:none;">
								<script type="text/javascript">
									showAttachment('${mtReply.id}', 0, 'attsDiv${mtReply.id}');
								</script>
								</div>
						 	</td>
						</tr>
					</table>
									
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
						<tr>
							<c:choose>
							<c:when test="${language eq 'en'}">
							 	<td class="align_right" width="110"  style="display:none;" id="attachment2Tr${mtReply.id}">
							 </c:when>
	                         <c:otherwise>
	                            <td class="align_right" width="80"  style="display:none;" id="attachment2Tr${mtReply.id}">
	                         </c:otherwise>
							 </c:choose>
								<div class="atts-label"  style="width:100%;" align="right">
									${mydocumentLabel}:(<span class="font-12px" id="replyDocachmentNumberDiv${mtReply.id}"></span>)
								</div>
							</td>
							<td>
								<div class="div-float"  style="float:none;">
									<script type="text/javascript">
										showAttachment('${mtReply.id}',  2, 'attsDiv${mtReply.id}');
									</script>
								</div>
							</td>
						</tr>
					</table>
					
					<div class="clearfix color_gray" style="font-size:12px;padding-left:10px;">
						${mtReply.m1Info}
                  	</div>
                  	
                  	<div class="comment-div-mercury ${empty comments[mtReply.id]? 'hidden':''}" id="opinDiv${mtReply.id}" style="padding-bottom: 10px;padding: 20px;${empty comments[mtReply.id]? 'none':'display:inline-block'}">
						<div class="comment-fieldset-mercury">
                        	<div class="comment2-div-mercury align_left" style="padding: 5px;"><fmt:message key="mt.opinion.revert"/></div>
							
							<div id="replyCommentDiv${mtReply.id}">
                            	
                            	<c:forEach items="${comments[mtReply.id]}" var="comment">
                                <div class="reply_message_con">
									<div class="comment4-div-mercury" id="Anchor${comment.id}" title="${v3x:toHTML(v3x:showMemberName(comment.createUserId))}">
                                    	<c:choose>
                                        <c:when test="${!empty comment.proxyId}">
                                        <span id="smember${num}"  class="reply_member" name="opinion${comment.createUserId}" onclick="displayPeopleCard('${comment.proxyId}','${comment.validByUser}')" class="reply_member">${v3x:toHTML(v3x:showMemberName(comment.proxyId))}
                                        	<font color="red" style="font-weight: lighter;">(<fmt:message key="mt.agent.label1"><fmt:param value="${v3x:toHTML(v3x:showMemberName(comment.createUserId))}" /></fmt:message>)</font>:
                                        </c:when>
                                        <c:otherwise>
                                        <span id="smember${num}"  class="reply_member" name="opinion${comment.createUserId}" onclick="displayPeopleCard('${comment.createUserId}','${comment.validByUser}')" class="reply_member">${v3x:toHTML(v3x:showMemberName(comment.createUserId))}:
                                        </c:otherwise>
                                        </c:choose>
										</span>
                                            
										<c:set var="num" value="${num+1}"/>
                                        
                                        <span class="reply_data">
                                        	<fmt:formatDate value="${comment.createDate}" pattern="${datePattern}"/>
                                        </span>
									</div><!-- comment4-div-mercury -->
									
									<div class="comment-content-cols clearFloat" style="width: 678px; word-break: normal; word-wrap: normal;">
                                    	<c:set value="${empty comment.showToId ? '' :comment.showToId}" var="commentShowToId"/>
                                        <c:set value="${empty comment.proxyId ? '' :comment.proxyId}" var="commentProxyId"/>
                                        <c:choose>
										<c:when test="${comment.isHidden
                                                        	&& currentUserId!=comment.createUserId
                                                           	&& currentUserId!=mtReply.userId
                                                           	&& currentUserId!=commentProxyId
                                                           	&& agentToId!=mtReply.userId
                                                           	&& !fn:contains(commentShowToId,currentUserId)}">
											<div class="commentContent-hidden">[${opinionHidden}]</div>
                                        </c:when>
                                        <c:otherwise>
                                        
											<c:if test="${comment.isHidden == true}">
	                                        <span class="commentContent-hidden">[${opinionHidden}]</span>
	                                        </c:if>
											
											${v3x:toHTMLWithoutSpace(comment.content)}
	                                        
											<div class="wordbreak"></div>
											
	                                        <%--对自己的意见回复插入的附件和关联文档--%>
	                                        <div class="div-float attsContent" style="width:100%;display:none" id="attachment1Tr${comment.id}" >
	                                            <div class="atts-label">${attachmentLabel} :(<span class="font-12px" id="replyAttachmentNumberDiv${comment.id}"></span>)&nbsp;&nbsp;</div>
	                                            <div class="div-float" id="attach1Area${comment.id}"></div>
	                                        </div>
	                                                    
	                                        <div class="clearFloat"></div>
	                                                    
											<div class="div-float attsContent" style="width:100%; display:none" id="attachment2Tr${comment.id}" >
	                                        	<div class="atts-label">${mydocumentLabel} :(<span class="font-12px" id="replyDocachmentNumberDiv${comment.id}"></span>)&nbsp;&nbsp;</div>
	                                            <div class="div-float" id="attach2Area${comment.id}"></div>
	                                      	</div>
	                                        
	                                        <div class="clearFloat"></div>
										</c:otherwise>
                                        </c:choose>
                                        
                                        <div class="clearfix color_gray" style="font-size:12px;">
                                			${comment.m1Info}
                           				</div>
                                 	</div><!-- comment-content-cols -->
                                </div><!-- reply_message_con -->
                               	</c:forEach>
					
							</div><!-- replyCommentDiv${mtReply.id} -->
					
						</div><!-- comment-fieldset-mercury -->
					
					</div><!-- comment-div-mercury -->

                    <%-- 意见回复框位置 --%>
                    <div class="comment-div div-float" align="center" style="display: none;" id="replyDiv_${mtReply.id}"></div>
                    
					</div><!-- div-clear -->
					</td>
				
				</tr>
			</c:if>
		</c:forEach>
	</table>
</td>
</tr>
</table>

<script type="text/javascript">

function showAttachments(type){
   	if(theToShowAttachments.isEmpty()){
     	return;
   	}
   	var subReference2Atts = new Properties();
   	for(var i = 0; i < theToShowAttachments.size(); i++) {
     	var att  = theToShowAttachments.get(i);
     	if(att.type == type){
         	var docs = subReference2Atts.get(att.subReference);
         	if(docs == null){
           		docs = new ArrayList();
           		subReference2Atts.put(att.subReference,docs);
         	}
         	docs.add(att);
     	}
   	}
    var opnionIds = subReference2Atts.keys();
    for(var i = 0; i < opnionIds.size(); i++){
       	var opnionId = opnionIds.get(i);
       	var atts = subReference2Atts.get(opnionId);
       	var str = new StringBuffer();
        for(var j = 0; j < atts.size(); j++){
           str.append(atts.get(j).toString(true, false));
        }
       	if(type==0){type = 1;}
       	var attachmentTr = document.getElementById("attachment" + type + "Tr" + opnionId);
       	var attachDiv = document.getElementById("attach" + type + "Area" + opnionId);
       	var attachNumber = null;
       	if(type==1){
         	attachNumber = document.getElementById("replyAttachmentNumberDiv" + opnionId);
       	}else{
         	attachNumber = document.getElementById("replyDocachmentNumberDiv" + opnionId);
       	}	
       	if(attachmentTr){attachmentTr.style.display = ''}
       	if(attachDiv){
         	attachDiv.innerHTML = str;
       	}
       	if(attachNumber){
         	attachNumber.innerHTML = atts.size();
       	}
	}
}

showAttachments(0);
showAttachments(2);

</script>

<%-- 意见回复框 --%>
<div class="hidden" id="replyCommentHTML">

<form name="repform" method="post" target="replyCommentIframe" action="${mtMeetingURL}?method=doComment&meetingId=${param.id}&proxyId=${proxyId}" onsubmit="return doReplay(this);" style="margin: 0px auto;">
<input type="hidden" name="replyId" value="">

<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" id="reply-table" style="margin: auto;font-family:'宋体'">
<tr>
   	<td colspan="2">
      	<textarea name="content" cols="" rows="" style="width: 100%;height: 80px" class="font-12px" inputName="回复意见" validate="notNull" maxSize="500"></textarea>
   	</td>
</tr>

<tr>
	<td align="right" colspan="2" height="25" style="white-space:nowrap;">
		<div style="float: left;margin-top:3px;*margin-top:5px;" class="description-lable font-12px"><fmt:message key="common.charactor.limit.label" bundle="${v3xCommonI18N}"><fmt:param value="500" /></fmt:message>
		</div>
		
       	<span class="like-a font-12px" onclick="insertAttachment()"><fmt:message key="common.toolbar.insertAttachment.label" bundle="${v3xCommonI18N}" /></span>
		<span class="like-a font-12px" id="myDocumentSpan" onclick="quoteDocument()"><fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' /></span>
		<label for="isHidden" id="isHiddenDiv" style="display: inline" class="font-12px">
			<input name="isHidden" type="checkbox" value="1" onclick="showMoreHiddenOption(this,'moreHiddenOption')">
            <fmt:message key="common.opinion.hidden.label" bundle="${v3xCommonI18N}" />
		</label>
		
		<span id="moreHiddenOption" class="font-12px" style="display: none">
			<fmt:message key="mt.comment.not.include" />&nbsp;
			<c:set value="${v3x:parseElementsOfIds(MtCreateUserId, 'Member')}" var="senderids"/>
            <c:set value="${(proxyId==-1||proxyId==''||proxyId==null) ? CurrentUser.id : proxyId }" var="memberId" />
            <c:set value="${v3x:parseElementsOfIds(memberId, 'Member')}" var="replyMember"/>
            <input id="showToIdInput" type="text" readonly="readonly" size=15 style="height: 21px" value="${v3x:toHTML(v3x:showMemberNameOnly(MtCreateUserId))}" name="showToIdInput" onclick="selectPeopleFun_commentHidden()">
            <input id="showToId" type="hidden" value="${MtCreateUserId}" name="showToId"/>
            <v3x:selectPeople panels="Department,Team,Post,Outworker,RelatePeople"
                 jsFunction="setSelectPeople(elements)"
                 selectType="Member"
                 originalElements="${senderids},${replyMember }"
                 id="commentHidden" minSize="1" />
                 &nbsp;
		</span>
		
		<%-- 消息推送 --%>
		<label for="sendMsg" id="sendMsgDiv" style="display:inline" class="font-12px">
           	<input type="checkbox" name="sendMsg" value="1" checked="checked" onclick="showMoreHiddenOption(this,'moreHiddenMessage')"><fmt:message key="common.message.push.label"/>
		</label>
           
		<span id="moreHiddenMessage" class="font-12px" style="display: inline-block">
			&nbsp;
            <input type="text" readonly="readonly" size=15 style="height: 21px" value="" id="messageReceiverName" onclick="showMessager(this,'${param.id}','${MtCreateUserId}')">
            <input type="hidden" name="messageReceiver" id="messageReceiver"/>
            &nbsp;
		</span>
		
		&nbsp;&nbsp;
           
        <input type="submit" name="b11" class="button-default_emphasize"  value="<fmt:message key='common.button.submit.label' bundle="${v3xCommonI18N}" />">
        <input type="button" name="b12" class="button-default-2"  value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" onclick='hiddenReplyDiv()'>
	</td>
</tr>
           
<tr id="attachmentTR" style="display: none; width: 98%">
   <td nowrap="nowrap" width="10%" height="25" valign="top" class="font-12px" align="right">${attachmentLabel}:</td>
   <td valign="top"><div class="div-float font-12px"">(<span class="font-12px" id="attachmentNumberDiv"></span>)</div>
     <v3x:fileUpload applicationCategory="6" />
   </td>
</tr>
<tr id="attachment2TR" style="display: none; width: 98%">
   <td nowrap="nowrap" width="10%" height="25" valign="top" class="font-12px" align="right">${mydocumentLabel}: </td>
   <td valign="top"><div class="div-float font-12px"">(<span class="font-12px" id="attachment2NumberDiv"></span>)</div>
   <div></div>
   <div id="attachment2Area" style="overflow: auto;"></div></td>
</tr>
</table>

</form>

</div><!-- replyCommentHTML -->

</c:if><!-- param.from != 'temp -->

<iframe name="replyCommentIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>

<div class="body-line-sp"></div>
	
<c:if test="${!isImpart }">
<%-- 会议纪要start --%>
<table align="center" border="0" cellspacing="0" cellpadding="0" class="body-detail">
<tr>
	<td height="30" width="10%" align="">
		<div class="body-detail-su meeting-title-record" style="padding-left: 15px;"><fmt:message key="mt.meetingrecord"/>
		<c:if test="${((summary != null) && (bean.recorderId==CurrentUser.id || (bean.recorderId=='-1' && bean.emceeId==CurrentUser.id))) && param.isQuote!='true' && param.fromPigeonhole!='true'}">
			<c:if test="${v3x:hasPlugin('collaboration') && hasNewCollMenu}">
			    <a id="summaryToColHref" href="javascript:summaryToCol('coll');" style="padding-left: 20px; font-size: 12px;font-weight:normal;"><fmt:message key="summary.transferTo.coll" /></a>
		    </c:if>
		    <c:if test="${hasEdocPlugin && hasSendEdocMenu && isEdocCreateRole}">
                  	<a id="summaryToEdocHref" href="javascript:summaryToCol('edoc');" style="padding-left: 20px; font-size: 12px;font-weight:normal;"><fmt:message key="summary.transferTo.edoc" /></a>
                  </c:if>
		</c:if>
		</div>
	</td>
</tr>

<!-- 添加纪要附件和关联文档 -->
<tr >
	<td class="bg-gray" >
		<div id="attachment2Tr_record" style="display: none;margin-left:15px">
			<table border="0" cellspacing="0" cellpadding="0" width="100%" class="line_height180">
				<tr id="attList">
                	<td class="align_right" valign="top" width="90" nowrap="nowrap">
						<span class="margin_t_5 font-12px" ><b><fmt:message key="common.toolbar.insert.mydocument.label" bundle="${v3xCommonI18N}" /> </b>:(<span id="attachment2NumberDiv_record" class="font-12px"></span>)</span>
					</td>
                    <td class="align_left">
						<script type="text/javascript">
							showAttachment('${summary.id}', 2, 'attachment2Tr_record', 'attachment2NumberDiv_record');
						</script>
					</td>
				</tr>
			</table>
		</div>
	</td>
</tr>

<tr>
	<td class="bg-gray" >
		<div id="attachmentTr_record" style="display: none;margin-left:15px">
			<table border="0" cellspacing="0" cellpadding="0" width="100%" class="line_height180">
				<tr id="attList">
                	<td class="align_right" valign="top" width="90" nowrap="nowrap">
                    	<span class="margin_t_5 font-12px" ><b><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /></b>&nbsp;:(<span id="attachmentNumberDiv_record" class="font-12px"></span>)</span>
                   	</td>
                    <td class="align_left">
                    	<script type="text/javascript">
							showAttachment('${summary.id}', 0, 'attachmentTr_record', 'attachmentNumberDiv_record');
						</script>
					</td>
				</tr>
			</table>
		</div>
	</td>
</tr>

<c:if test="${summary!=null && summary.dataFormat eq 'HTML'}">
<tr valign="middle">
	<td>
   		<v3x:showContent content="${summary.content}" type="${summary.dataFormat}" createDate="${summary.createDate}" htmlId="summary-contentText" />
	</td>
</tr>
</c:if>

</table>

<c:if test="${summary!=null && summary.dataFormat ne 'HTML'}">
<table id="summaryContentIframeTable" align="center" border="0" cellspacing="0" cellpadding="0" class="w100b body-detail">
	<tr valign="middle">
		<td class="h500px" id="summaryContentIframeTD">
			<iframe id="summaryContentIframe" style="width:100%;height:100%" src="meeting.do?method=showContentOfSummaryOffice&summaryId=${summary.id }" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
		</td>
	</tr>
</table>
</c:if>
<%-- 会议纪要end --%>

<%-- 会议任务start --%>
<c:if test="${showMeetingTask }">
<table align="center" border="0" cellspacing="0" cellpadding="0" class="body-detail" style="margin: 20px auto;">
	<tr>
		<td height="30" width="10%" align="">
			<div class="body-detail-su meeting-title-task"><fmt:message key="mt.task.label"/></div>
		</td>
	</tr>
	<tr valign="middle">
		<td>
			<div class="meeting-task">
		   		<a  href="javascript:openMeetingTaskDetail('${bean.id}','-1');" class="task-status-all">
		   			<div>
		   				<span>${task_all}</span>
		   			</div>
		   			<span><fmt:message key="mt.task.status.all"/></span>
		   		</a>
		   		<a href="javascript:openMeetingTaskDetail('${bean.id}','-2');"  class="task-status-unfinished">
		   			<div>
		   				<span>${task_unfinished}</span>
		   			</div>
		   			<span><fmt:message key="mt.task.status.unfinished"/></span>
		   		</a>
		   		<a href="javascript:openMeetingTaskDetail('${bean.id}','6');"   class="task-status-overdue">
		   			<div>
		   				<span>${task_overdue}</span>
		   			</div>
		   			<span><fmt:message key="mt.task.status.overdue"/></span>
		   		</a>
		   		<a href="javascript:openMeetingTaskDetail('${bean.id}','4');"   class="task-status-finished">
		   			<div>
		   				<span>${task_finished}</span>
		   			</div>
		   			<span><fmt:message key="mt.task.status.finished"/></span>
		   		</a>
		   		<a href="javascript:openMeetingTaskDetail('${bean.id}','5');"  class="task-status-canceled">
		   			<div>
		   				<span>${task_canceled}</span>
		   			</div>
		   			<span><fmt:message key="mt.task.status.canceled"/></span>
		   		</a>
			</div>
		</td>
	</tr>
</table>
</c:if>
<%-- 会议任务end --%>

</c:if><!-- isImpart -->

</body>
</html>