<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
<title>
	<c:if test="${bean.id!=null}"><fmt:message key='common.toolbar.edit.label' bundle="${v3xCommonI18N}" /></c:if><c:if test="${bean.id==null}"><fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /></c:if><fmt:message key="news.title" />
</title>
<%@ include file="../include/header.jsp" %>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
</head>
<input type="hidden" id="createDate" name="createDate" value="${bean.createDate}" />
<input type="hidden" id="imageId" name="imageId" value="${bean.imageId}" />
<body scroll="no" class="body-bgcolor"  onkeydown="listenerKeyESC()">
<input type="hidden" id="subject" name="subject" value="${v3x:toHTML(bean.title)}">
<div style="width:100%;height:100%;overflow:scroll">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
		<tr>
			<td width="100%" height="100%" style="padding-bottom: 8px;">

	<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
		<tr>
		<td width="100%" height="100%" align="center">
		<div><a name="aaa"></a>
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="${bean.dataFormat=='HTML'?'body-detail':'body-detail-office'}">
			<tr>
			 <td height="30">
			 	<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr class="page2-header-line-old" height="30">
					<td align="right" class="padding5">
						<c:if test="${bean.imageNews==true}">
						 <input type="button" class="button-default-2"  onclick="look()" value="<fmt:message key='new.lookImage' />" />&nbsp;&nbsp;&nbsp;&nbsp;
						</c:if>
					</td>
				</tr>
				<tr>
				   <td align="center" width="90%" class="titleCss padding5">${v3x:toHTML(bean.title)}</td>
				</tr>
				</table>
			 </td>
			</tr>
			<tr>
				<td class="font-12px" align="center" height="28">
					<fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}" /> 
					&nbsp;&nbsp;&nbsp;&nbsp;
					${bean.publishDepartmentName}
					&nbsp;&nbsp;&nbsp;&nbsp;
					${ bean.createUserName}
					&nbsp;&nbsp;&nbsp;&nbsp;
					<fmt:message key="label.readCount" />: ${bean.readCount}
				</td>
			</tr>
			<c:if test="${bean.showKeywordsArea == true || bean.showBriefArea == true}">
			<tr style='background-color:#d9ecff;'>
				<td height="${bean.showBriefArea == true? '50':'25'}">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<c:if test="${bean.showKeywordsArea == true}"> 
					<tr>
						<td class="font-12px" align="right" width="60" height="24"><b><fmt:message key="news.data.keywords" />:</b></td>
						<td class="font-12px" style="padding: 0 12px;" align="left">
							${v3x:toHTML(bean.keywords)}
						</td>
					</tr>
					</c:if>
					<c:if test="${bean.showBriefArea == true}">
					<tr>
						<td class="font-12px" valign="top" height="24" align="right"><b><fmt:message key="news.data.brief"/>:</b></td>
						<td class="font-12px" valign="top" style="padding: 0 6px;" align="left">&nbsp;&nbsp;${v3x:toHTML(bean.brief)}</td>
					</tr>
					</c:if>
					</table>
				</td>	
			</tr>
			</c:if>
			<tr>
				<td width="100%" align="left" height="${(bean.dataFormat!='HTML' && bean.dataFormat!='FORM') ? '768px' : '100%'}" style="padding-bottom: 6px;" valign="top">
					<div style="height:100%">	
		            <v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" htmlId="content" />	
					</div>
                    <style>
                        .contentText p{
                            font-size:14px;
                        }
                   </style>
				</td>
			</tr>
		</table>
		
		</td>
		</tr>
	</table>
<iframe id="hiddenIframe" name="hiddenIframe" width="0" height="0" frameborder="0"></iframe>
</td>
</tr>
</table>
</div>
</body>
</html> 

