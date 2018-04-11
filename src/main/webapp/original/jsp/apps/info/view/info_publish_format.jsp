<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>${v3x:toHTML(bean.subject)}</title>
<style>
	.padding-30 {
		padding: 15px;
	}
	
	.padding355 {
		padding: 0;
		padding-top: 56px;
	}
	
	.contentText {
		margin: 35px;
		margin-top: 0;
	}
	
	
	
	html,body {
		height: 100%;
	}
	
	.CollTable {
		background: #fff;
	}
	
</style>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css"/>
<link type="text/css" rel="stylesheet" href="<c:url value="/common/skin/default4GOV/skin.css${v3x:resSuffix()}" />">
</head>
<body scroll='true'  onkeydown="listenerKeyESC()" style="margin: 0px; padding: 0px;overflow:auto;background: #bcbcbc">
<table border="0" cellpadding="0"  cellspacing="0" width="700" style="margin:0 auto;" class="CollTable" height="90%" align="center" style="padding: 0px;background: #fff;">
	<tr>
		<td class="body-bgcolor-audit" width="100%" height="100%">
			
			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
			
	        <%-- 期刊版式 --%>
			<c:if test="${formatType == 2}">
				
				<%-- 期刊版式一 --%>
				<c:if test="${detailType==1}">
				
					<%------------------------- 期刊名-----------------------%>
					<tr>
						 <td colspan="4" height="30">
							 <table border="0" cellpadding="0" cellspacing="0" width="100%" >
								 <tr>
								   	<td align="center" width="100%" class="titleCss2" style="padding: 20px 6px;font-size:16">${v3x:toHTML(infoMagazine.subject)}</td>									   
								 </tr>
							 </table>
						 </td>
					</tr>
					
					<tr class="col_content_toolbar2">
						<td class="font-12px" align="right" width="18%" height="28"><fmt:message key="info.report.dept" />&nbsp;:&nbsp;&nbsp;</td>
						<td class="font-12px" width="35%">${bean.reportUnit}${bean.reportDept}</td>
						<td class="font-12px" align="right" width="12%"><fmt:message key="info.publish.date" />&nbsp;:&nbsp;&nbsp;</td>
						<td class="font-12px" width="35%"><fmt:formatDate value="${infoPublishDetail.publishLastTime}"  pattern="yyyy年MM月dd日"/></td>
					</tr>					
					
					<tr>
						<td align="center" colspan="4" style="border-top:0.5px dotted;">
							<br /><br />
						</td>
					</tr>
					
					<%------------------------- 信息名-----------------------%>
					<tr>
						 <td colspan="4" height="30">
							 <table border="0" cellpadding="0" cellspacing="0" width="100%" >
								 <tr>
								   	<td align="center" width="100%" class="titleCss" style="padding: 20px 6px;font-size:16">${v3x:toHTML(bean.subject)}</td>									   
								 </tr>
							 </table>
						 </td>
					</tr>
					
					<tr>
						<td width="100%"  height="400px" valign="top" colspan="6">
							<div>								
					           	<v3x:showContent content="${lastBody.content }" type="${lastBody.contentType }" createDate="${lastBody.createTime}" htmlId="content" contentName="${lastBody.contentName}" viewMode="edit"/>		
							</div>
						</td>
					</tr>
									
				</c:if>
				
				<%-- 期刊版式二 --%>
				<c:if test="${detailType==2}">
				
					<%------------------------- 期刊名-----------------------%>
					<tr>
						 <td colspan="4" height="30">
							 <table border="0" cellpadding="0" cellspacing="0" width="100%" >
								 <tr>
								   	<td align="center" width="100%" class="titleCss2" style="padding: 20px 6px;font-size:16">${v3x:toHTML(infoMagazine.subject)}</td>								   
								 </tr>
							 </table>
						 </td>
					</tr>
					
					<tr>
						<td align="center" colspan="4" height="20" style="border-top:0.5px dotted;">
							<br /><br />
						</td>
					</tr>
					
					<%------------------------- 信息名-----------------------%>
					<tr>
						 <td colspan="4" height="30">
							 <table border="0" cellpadding="0" cellspacing="0" width="100%" >
								 <tr>
								   	<td align="center" width="100%" class="titleCss" style="padding: 20px 6px;font-size:16">${v3x:toHTML(bean.subject)}</td>									   
								 </tr>
							 </table>
						 </td>
					</tr>
					
					<tr>
						<td width="100%" height="400px" valign="top" colspan="6">
							<div>								
					           	<v3x:showContent content="${lastBody.content }" type="${lastBody.contentType }" createDate="${lastBody.createTime}" htmlId="content" contentName="${lastBody.contentName}" viewMode="edit"/>		
							</div>
						</td>
					</tr>
					
				 	<tr class="col_content_toolbar2">
						<td class="font-12px" align="right" width="18%" height="28"><fmt:message key="info.publish.unit" />&nbsp;:&nbsp;&nbsp;</td>
						<%-- <td class="font-12px" width="35%">${v3x:getAccount(infoPublishDetail.domainId).name}</td> --%>
						<td class="font-12px" width="35%">${v3x:toHTML(publishAccountName)}</td>
						<td class="font-12px" align="right" width="12%"><fmt:message key="info.element.report.unit" />&nbsp;:&nbsp;&nbsp;</td>
						<td class="font-12px" width="35%">${bean.reportUnit}</td>
					</tr>

			 		<tr class="col_content_toolbar">
						<td class="font-12px" align="right" width="18%" height="28"><fmt:message key="info.publish.date" />&nbsp;:&nbsp;&nbsp;</td>
						<td class="font-12px" width="35%"><fmt:formatDate value="${infoPublishDetail.publishLastTime}"  pattern="yyyy年MM月dd日"/></td>
						<td class="font-12px" align="right" width="12%"><fmt:message key="info.report.date" />&nbsp;:&nbsp;&nbsp;</td>
						<td class="font-12px" width="35%"><fmt:formatDate value="${bean.reportDate}"  pattern="yyyy年MM月dd日"/></td>
					</tr>
				 	
			 	</c:if>
			</c:if>
	     		        
				
			<c:set value="${fn:length(attachments)}" var="attLen"></c:set>
			<c:if test="${attLen > 0}">
				<tr>
					<td height="10" valign="top" colspan="6">
						<hr size="1" class="newsBorder">
					</td>
				</tr>
			</c:if>
				
				
			<tr id="attachmentTr" style="display: none">
			  <td class="paddingLR" colspan="6" height="40">
			   <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
			    <tr style="padding-bottom: 20px;">
					<td nowrap="nowrap" width="50" class="font-12px"><b><fmt:message key="label.attachments"/>:&nbsp;</b></td>
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
			  <td class="paddingLR" colspan="6"  height="40">
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
			
			</table>	
		</td>
	</tr>
</table>
<iframe name="hiddenIframe" style="display:none;" width="0" height="0" frameborder="0"></iframe>
</body>
</html> 