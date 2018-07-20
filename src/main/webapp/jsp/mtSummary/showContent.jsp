<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="../meeting/include/taglib.jsp" %>
	<%@ include file="../meeting/include/header.jsp" %>
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>">
	<%-- 注释SeeyonForm.css 修复OA-43413--%>
	<%--<link href="<c:url value="/apps_res/form/css/SeeyonForm.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css"/> --%>
	<script type="text/javascript">
		//会议总结转发协同
		function summaryToCol(){
			var parentObj = getA8Top().window.dialogArguments;
			
			//判断会议总结是否存在   做防护
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxMtSummaryTemplateManager", "isMeetingSummaryExist", false);
			requestCaller.addParameter(1, "Long", '${bean.id}');
			var ds = requestCaller.serviceRequest();
			if(ds=='false'){
				alert(v3x.getMessage("meetingLang.meeting_has_delete"));
				return;
			}
			
			if(parentObj){
				var a8Top = parentObj.getA8Top().window.dialogArguments;
				if(a8Top){
					a8Top.parent.parent.location.href='${mtMeetingURL}?method=summaryToCol&id=${bean.id}';
				}else{
					parentObj.getA8Top().parent.parent.location.href='${mtMeetingURL}?method=summaryToCol&id=${bean.id}';
				}
				parentObj.close();
				window.close();
			}else{
				parent.parent.parent.parent.location.href='${mtMeetingURL}?method=summaryToCol&id=${bean.id}';
			}
		}
		
		function _init_(){
		    try{
	            if(window.trans2Html){
	              //HTML正文，进行转换后的正文高度计算
	                  resetTransOfficeHeight("summaryContentDIV", "summaryContentDIV");
	            }else{
	            		var officeFrameDiv = document.getElementById("officeFrameDiv");
	            		var summaryContentDIV = document.getElementById("summaryContentDIV");
		        	    if(officeFrameDiv && typeof(officeFrameDiv.offsetTop)!="undefined"&&officeFrameDiv.offsetTop!=null){
		        	      try{
		        	        var cHeight = document.documentElement.clientHeight;
		        	        if (cHeight == 0) {
		        	      	  cHeight = document.body.clientHeight;
		        	        }
		        	        var officeFrameDivHeight = cHeight - officeFrameDiv.offsetTop;
		        	        summaryContentDIV.style.height = (officeFrameDivHeight-19) + "px";
		        	      }catch(e){}
		        	    }
		        }
		    }catch(e){}
		}
	</script>

</head>
<body class="body-bgcolor" style="overflow: auto;" onload="_init_()">
<v3x:attachmentDefine attachments="${attachments}" />

<div id="summaryContentDIV" style="width: 100%;height: auto">
    <v3x:showContent content="${mtSummary.content}" type="${mtSummary.dataFormat}" createDate="${mtSummary.createDate}" htmlId="col-contentText" />
</div>
	
	<%-- 关键点3 ： 分隔线 --%>
	<div class="body-line-sp"></div>
	
	<c:if test="${param.from!='temp' && (param.hiddenAuditOpinion!='isYes') && replySize > 0}">
	<table align="center" border="0" cellspacing="0" cellpadding="0" class="body-detail">
		<tr valign="top">
			<td class="body-detail-border" width="100%">
				<div class="body-detail-su" style="padding-left: 15px;">
					<fmt:message key="mt.mtSummary.auditor.reply">
						<fmt:param value="${replySize}" />
					</fmt:message>
				</div>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="padding-left: 15px; padding-right: 15px;">
					<c:forEach var="mtReply" items="${replyList}">
						
							<tr><td width="100%" >
								<div class="div-clear" style="width: 100%;">
									<div class="optionWriterName">
										<div class="div-float font-12px" style="padding-left: 20px; padding-bottom: 2px; color: #335186;">
											<span class="cursor-hand" onclick="showV3XMemberCardWithOutButton('${mtReply.auditorId}')"><b><c:out value="${v3x:showMemberName(mtReply.auditorId)}"/></b></span>
											<c:if test="${mtReply.proxy}">
												<font color="red">
													(<fmt:message key="mt.agent.label1">
													<fmt:param>${v3x:showMemberName(mtReply.proxyId)}</fmt:param>
													</fmt:message>)
												</font>
											</c:if>&nbsp;
											<b><fmt:message key="mt.summary.audit.${mtReply.state }"/></b>
											&nbsp;&nbsp;
											<fmt:formatDate value="${mtReply.auditDate}" pattern="${datePattern}"/>
										</div>
										<div class="div-float-right" style="padding-right: 20px;">
											&nbsp;
										</div>
									</div>
									<div class="optionContents" style="padding: 2px 20px 2px 20px;">
										${v3x:toHTML(mtReply.opinion)}&nbsp;
									</div>
								</div>
							</td></tr>	
						
					</c:forEach>
				</table>
			</td>
	  	</tr>
	</table>
	</c:if>
	
	<%-- 关键点5 ： 分隔线 --%>
	<div class="body-line-sp"></div>
</body>
</html>