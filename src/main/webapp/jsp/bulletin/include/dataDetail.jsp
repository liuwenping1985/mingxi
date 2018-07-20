<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="../include/taglib.jsp" %>
<html>
<head>
<title>
</title>
<style>.padding-30{padding: 15px;}</style>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<%@ include file="../include/header.jsp" %>
</head>
<body scroll='no'  onkeydown="listenerKeyESC()" style="margin: 0px; padding: 0px;">
<input type="hidden" id="subject" name="subject" value="${v3x:toHTML(bean.title)}" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" class="body-bgcolor" align="center" style="padding: 0px;">
	<tr>
		<td class="body-bgcolor-audit" width="100%" height="100%">
		<div>
			<div id="printThis" style="background:#efefef;">
			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="body-detail">
			 <%-- 标准格式 --%>
			 <c:if test="${ext1=='0'}">				 	
			    <tr>
					 <td colspan="6" height="30">
						 <table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-bottom: 1px solid #A4A4A4;">
							 <tr>
							   <td align="center" width="100%" class="titleCss" style="padding: 20px 6px;">${v3x:toHTML(bean.title)}</td>									   
							 </tr>
						 </table>
					 </td>
				</tr>
				<tr style='background-color:#f6f6f6'>
					<td class="font-12px" align="right" width="120" height="28"><fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
					<td class="font-12px" width="280">${v3x:toHTML(bean.publishDeptName)}</td>
					<td class="font-12px" align="right" width="80"><fmt:message key="bul.data.type" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
					<td class="font-12px" width="200">${v3x:toHTML(bean.type.typeName)}</td>
					<td class="font-12px" align="right" width="80"><fmt:message key="bul.data.publishDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
					<td class="font-12px" width="130"><fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}" /></td>
				</tr>
	        </c:if>
	     		        
				<tr>
					<td width="100%" id="contentTD" height="${(bean.dataFormat!='HTML' && bean.dataFormat!='FORM') ? '500px' : '100%'}" valign="top" colspan="6">
						<div style="height:100%;">								
			            	<v3x:showContent content="${empty bean.ext5 ? bean.content : bean.ext5}" type="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" createDate="${bean.createDate}" htmlId="content" contentName="${bean.contentName}" viewMode="edit"/>		
						</div>
                        <style>
                        .padding355{ 
                            padding: 35px 30px 35px 30px;
                        }
                        .contentText p{
                            font-size:16px;
                        }
                    </style>
					</td>
				</tr>
				
				<c:if test="${bean.attachmentsFlag}">
					<tr>
						<td height="10" valign="top" colspan="6">
							<hr size="1" class="newsBorder">
						</td>
					</tr>
				</c:if>
				
				
				<tr id="attachmentTr" style="display: none">
				  <td class="paddingLR" colspan="6">
				   <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
				    <tr style="padding-bottom: 20px;">
						<td nowrap="nowrap" width="50" class="font-12px"><b><fmt:message key="label.attachments" />:&nbsp;</b></td>
						<td width="100%" class="font-12px">
						  <v3x:attachmentDefine	attachments="${attachments}" />		   
							<script type="text/javascript">					
								showAttachment('${bean.id}', 0, 'attachmentTr', '');					
							</script>
						</td>
					 </tr>
					</table>						
				  </td>
				</tr>
				
				<tr id="attachment2Tr" style="display: none">
				  <td class="paddingLR" colspan="6">
				   <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
				    <tr style="padding-bottom: 20px;">
						<td nowrap="nowrap" width="80" class="font-12px"><b><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:&nbsp;</b></td>
						<td width="100%" class="font-12px">
						  <v3x:attachmentDefine	attachments="${attachments}" />		   
							<script type="text/javascript">	
								showAttachment('${bean.id}', 2, 'attachment2Tr', '');	
							</script>
						</td>
					 </tr>
					</table>
				  </td>
				</tr>
			
			<%-- 正式格式2 --%>
			<c:if test="${ext1=='2'}">
			</table>
			
			<table border="0" height="80" cellpadding="0" cellspacing="0" class="body-detail" align="center" style="padding: 6px;">
				<tr><td height="10"></td></tr>

				<tr>
					<td colspan="6" class="paddingLR" height="40">							
					  	<table class="appendInfo" cellspacing="0" cellpadding="0" width="100%" height="100%" style="border-bottom-width: 1px;border-bottom-color: #c5cad2;">
							<tr class="sort">
								<td class="font-12px sort rightBorder" title="${bean.title }" width="50%">&nbsp;&nbsp;
									<fmt:message key="bul.data.title" /><fmt:message key="label.colon" />&nbsp;&nbsp;
									${v3x:toHTML(v3x:getLimitLengthString(bean.title, 30, "..."))}
								</td>
								<c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeStr" />
								<td class="font-12px sort" title="${publishScopeStr }" width="50%">&nbsp;&nbsp;
									<fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" />&nbsp;&nbsp;
	    							${v3x:getLimitLengthString(publishScopeStr, 30, "...")}
								</td>
							</tr>
							
							<tr class="sort">
								<td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;
									&nbsp;
								</td>
								<td class="font-12px sort" width="50%">&nbsp;&nbsp;
									<fmt:message key="bul.data.createDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
									<fmt:formatDate value="${bean.createDate}" pattern="${datePattern}" />
								</td>
							</tr>
							
							<tr class="sort">
								<td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;
									<fmt:message key="bul.data.auditUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;
									${v3x:showOrgEntitiesOfIds(bean.auditUserId, 'Member', pageContext)}
								</td>
								<td class="font-12px sort" width="50%">&nbsp;&nbsp;
									<fmt:message key="bul.data.auditDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
									<fmt:formatDate value="${bean.auditDate}" pattern="${datePattern}" />
								</td>
							</tr>
							
							<tr class="sort">
								<td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;
									<fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;
									${v3x:toHTML(bean.publishDeptName)}
								</td>
								<td class="font-12px sort" width="50%">&nbsp;&nbsp;
									<fmt:message key="label.readCount"/><fmt:message key="label.colon" />&nbsp;&nbsp;
									${bean.readCount}
								</td>
							</tr>
						</table>
						</td>
				</tr>
				<tr><td height="5"></td></tr>
			</table>
			</c:if>
			
			<%-- 正式格式1 --%>
			<c:if test="${ext1=='1'}">
				<tr>
					<td colspan="6" class="paddingLR" height="40">
					  	<table class="appendInfo" cellspacing="0" cellpadding="0" width="100%" height="100%" style="border-bottom-width: 1px;border-bottom-color: #c5cad2;">
							<tr class="sort">
								<td class="font-12px sort rightBorder" title="${bean.title }" width="50%">&nbsp;&nbsp;
									<fmt:message key="bul.data.title" /><fmt:message key="label.colon" />&nbsp;&nbsp;
									${v3x:toHTML(v3x:getLimitLengthString(bean.title, 30, "..."))}
								</td>
								<c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeStr" />
								<td class="font-12px sort" title="${publishScopeStr }" width="50%">&nbsp;&nbsp;
									<fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" />&nbsp;&nbsp;
	    							${v3x:getLimitLengthString(publishScopeStr, 30, "...")}
								</td>
							</tr>
							
							<tr class="sort">
								<td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;
									<fmt:message key="bul.data.createUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;
									${v3x:showMemberName(bean.createUser)}
								</td>
								<td class="font-12px sort" width="50%">&nbsp;&nbsp;
									<fmt:message key="bul.data.createDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
									<fmt:formatDate value="${bean.createDate}" pattern="${datePattern}" />
								</td>
							</tr>
							
							<tr class="sort">
								<td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;
									<fmt:message key="bul.data.auditUser"/><fmt:message key="label.colon" />&nbsp;&nbsp;
									${v3x:showOrgEntitiesOfIds(bean.auditUserId, 'Member', pageContext)}
								</td>
								<td class="font-12px sort" width="50%">&nbsp;&nbsp;
									<fmt:message key="bul.data.auditDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;
									<fmt:formatDate value="${bean.auditDate}" pattern="${datePattern}" />
								</td>
							</tr>
							
							<tr class="sort">
								<td class="font-12px sort rightBorder" width="50%">&nbsp;&nbsp;
									<fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;
									${v3x:toHTML(bean.publishDeptName)}
								</td>
								<td class="font-12px sort" width="50%">&nbsp;&nbsp;
									<fmt:message key="label.readCount"/><fmt:message key="label.colon" />&nbsp;&nbsp;
									${bean.readCount}
								</td>
							</tr>
						</table>
						</td>
					</tr>
					<tr><td height="5"></td></tr>
			
			</c:if>				
		</div>
				
		<c:if test="${bean.type.auditFlag == true}">
			<c:if test="${bean.state!=0 && bean.state!=10}">					
					<tr>
						<td height="20" class="padding_b_5" nowrap="nowrap" colspan="6">
							<b class="div-float"><fmt:message key="bul.data.auditAdvice" /><fmt:message key="label.colon" /></b>
							<c:if test="${bean.state==20}">
							<form action="${bulDataURL}?method=publishIt" target="hiddenIframe" method="post" name="publishForm" id="publishForm">
								<input type="submit" name="b1" id="b1" 
								value="<fmt:message key="common.toolbar.oper.publish.label" bundle="${v3xCommonI18N}" />"
								class="button-default-2 div-float-right">
								<input type="hidden" name="from" value="creater">
								<input type="hidden" name="id" id="publishId" value="${bean.id}">
							</form>
							</c:if>
						</td>
					</tr>
                    <tr align="left"><td align="left" colspan="6">
                    <table style="margin-left: 10px;">
                    <tr>
                      <td height="20" nowrap="nowrap"  align="left" colspan="1">
                        <a style="font-size: 12;font-weight: bold;color:#318ed9;" onclick="showV3XMemberCard('${bean.auditUserId}',getA8Top());">
                        ${v3x:showMemberName(bean.auditUserId)}</a>
                      </td>
                      <td width="100" align="left" nowrap="nowrap" style="font-size: 12;font-weight: bold; color:#111;">    
                       <c:if test="${bean.state==20}">
					       <fmt:message key="label.audit" /><fmt:message key="label.accept" />
						</c:if>
						<c:if test="${bean.state==30 && bean.ext3==1}">
							<fmt:message key="label.audit" /><fmt:message key="label.accept" />
						</c:if>
						<c:if test="${bean.state==30 && bean.ext3!=1}">
							<fmt:message key="label.accept2" />
						</c:if>
						<c:if test="${bean.state==40}">
							<fmt:message key="label.noaccept" />
						</c:if>             
                      </td>
                      <td nowrap="nowrap" style="color: #a3a3a3;font-size: 12">
                        <fmt:formatDate value="${bean.auditDate}" pattern="yyyy-MM-dd HH:mm" />
                      </td>
                    </tr>
                    </table>
                    </td>
                    </tr>
					<tr>
						<td class="padding-30" colspan="6">
							${v3x:toHTML(bean.auditAdvice)}&nbsp;
						</td>
					</tr>
				</table>
			</c:if>
		</c:if>	
			
		<c:if test="${bean.state==20}">
			<script>
				function publishIt(id){
					document.getElementById("b1").disabled=true;
					document.getElementById("publishId").value = id;
					document.getElementById("publishForm").submit();
				}
			</script>	
		</c:if>	
		</div>	
		</td>
	</tr>
</table>
<iframe name="hiddenIframe" width="0" height="0" frameborder="0"></iframe>
</body>
<script type="text/javascript">
window.onresize = function () { 
	try{
	    if (document.getElementById('contentTD').height > 0) {
	        document.getElementById('contentTD').style.height = document.body.clientHeight + "px";
	    }
	}catch(e){}
}
try{
	if (document.getElementById('contentTD').height > 0) {
		document.getElementById('contentTD').style.height = document.body.clientHeight + "px";
	}
}catch(e){}
</script>
</html> 