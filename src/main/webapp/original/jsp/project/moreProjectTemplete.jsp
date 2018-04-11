<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@include file="projectHeader.jsp"%> 

<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
.ico16{
	display:inline-block;
	vertical-align:middle;
	height:16px;
	width:16px;
	line-height:16px;
	background:url(/seeyon/skin/default/images/icon16.png?v=5_1_6_04) no-repeat;
	background-position:0 0;
	cursor:pointer;
	_overflow:hidden;
	_background:url(/seeyon/skin/default/images/icon16.gif?v=5_1_6_04) no-repeat;
}
</style>
<script type="text/javascript">
//TODO wanguangdong 2012-12-04 getA8Top().hiddenNavigationFrameset();//隐藏当前位置


window.onload = function() {
   showCtpLocation("F02_projectPersonPage");
}

function newColl(templeteId,projectId){
	var requestCaller = new XMLHttpRequestCaller(this, "templateManager", "checkTemplete", false); 
	requestCaller.addParameter(1, "Long", templeteId); 
	requestCaller.addParameter(2, "Long", "${currentUser.id}"); 
	var flag = requestCaller.serviceRequest(); 
	if(flag == false ||flag == "false"){ 
		alert("${ctp:i18n('collaboration.send.fromSend.templeteDelete')}"); 
		return; 
	} 
	var result = v3x.openWindow({
	      url: "${colURL}?method=newColl&templateId="+templeteId+"&projectId="+projectId+"&from=relateProject",
	      dialogType: "open",
	      workSpace: 'yes'
   	});
}
</script>
<c:set value="${currentUser.loginAccount}" var="loginAccountId" />
</head>
<body scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >
	  <%@ include file="moreProjectBanner.jsp"%> 
	<tr>
		<td valign="top" class="padding5"><input type="hidden" id="managerFlag" value="${param.managerFlag }" />
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page2-list-border">
			 	<tr>
			 		<td class="webfx-menu-bar padding_l_5" style="border-top:#aeaeae 1px solid"><b><fmt:message key="project.body.templates.label"/></b></td>
			 	</tr>
			 	<tr>
					<td valign="top" style="padding-left: 8px; padding-right: 8px;">
					   	<div class="scrollList">
					   		<c:if test="${fn:length(templeteList) != 0}">
						   		<table border="0" width="100%" cellpadding="0" cellspacing="0">
							   		<tr>
								   		<c:forEach items="${templeteList}" var="templete" varStatus="ordinal">
										   	<td class="text-indent-1em sorts"  width="25%"> 
												<c:set var="templeteName" value="${v3x:escapeJavascript(templete.subject)}"/>
												<c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,22,'...')}"/>
												<a title="${templeteName}" class='defaultlinkcss' onClick="newColl('${templete.id}','${projectCompose.projectSummary.id}')"><span class="ico16  margin_r_5" style="background-position:${templeteIcon[templete.id]};"></span>
											    	&nbsp;${templeteShowName }
											    </a>
											</td>
										   	${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
											<c:set value="${(ordinal.index + 1) % 4}" var="i" />
									   	</c:forEach>
									   	<c:if test="${i != 0}">					
											<c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
												<td width="25%" class="sorts">&nbsp;</td>
											</c:forTokens>
										</c:if>
							   		</tr>
						   		</table>
					   		</c:if>
					    </div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
