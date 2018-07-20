<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
<title>

</title>
<%@ include file="../include/header.jsp" %>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
</head>
<body scroll="no" style="overflow: hidden;" onkeydown="listenerKeyESC()">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
    <c:if test="${param.needBreak == 'true'}">
	<tr height="8">
			<td  width="100%" height="8" >
				<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
					<tr >
						<td width="100%" height="8">
							<script type="text/javascript">
								getDetailPageBreak();
							</script>
						</td>
					</tr>
				  </table>  
			</td>
	</tr>
    </c:if>
	<tr>
		<td class="body-bgcolor-audit" width="100%" height="100%" >
		<div class="scrollList" id="scrollList">
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="body-detail">
		<tr>
			 <td height="30">
			 	<table border="0" cellpadding="0" cellspacing="0" width="100%">
				 <tr>
				 	<td width="35">&nbsp;</td>
				   <td align="center" width="90%" class="titleCss" style="padding: 20px 0px 10px 0px;">${bean.title}</td>
				   <td width="35">&nbsp;</td>
				  </tr>
				</table>
			 </td>
			</tr>
		<tr>
			<td colspan="3" align="center" class="paddingLR font-12px" height="40" valign="top">
				<fmt:formatDate value="${bean.createDate}" pattern="${datePattern}" /> 
				&nbsp;&nbsp;&nbsp;&nbsp;
				${bean.publishDepartmentName}
				&nbsp;&nbsp;&nbsp;&nbsp;
				${bean.createUserName}
				&nbsp;&nbsp;&nbsp;&nbsp;
				<fmt:message key="label.readCount" />: ${bean.readCount}
			</td>
		</tr>

		<c:if test="${bean.showKeywordsArea == true || bean.showBriefArea == true}">
		<tr style='background-color:#d9ecff;'>
			<td height="${bean.showBriefArea == true? '60':'28'}">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<c:if test="${bean.showKeywordsArea == true}"> 
				<tr>
					<td class="font-12px" align="right" width="60" height="24"><b><fmt:message key="news.data.keywords" />:</b></td>
					<td style="padding: 0 12px;" class="font-12px">
						${bean.keywords}
					</td>
				</tr>
				</c:if>
				<c:if test="${bean.showBriefArea == true}">
				<tr>
					<td valign="top" height="40" align="right" class="font-12px"><b><fmt:message key="news.data.brief"/>:</b></td>
					<td valign="top" style="padding: 0 6px;" class="font-12px">&nbsp;&nbsp;${bean.brief}</td>
				</tr>
				</c:if>
				</table>
			</td>	
		</tr>
		</c:if>
		<tr>
			<td width="100%" height="100%" style="padding-bottom: 6px;" valign="top">
				<div style="height:100%;width: 100%;overflow: auto;" id="contentDiv">	
	            <v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" htmlId="content" />	
				</div>
                <style>
                    .contentText p{
                        font-size:14px;
                    }
                </style>
			</td>
		</tr>
		<!-- 关联文档显示内容-->
		<tr id="attachment2Tr" style="display: none">
		  <td class="paddingLR" height="30" colspan="6">
		   <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
				<tr>
					<td height="10" valign="top" colspan="6">
						<hr size="1" class="newsBorder">
					</td>
				</tr>
				
			    <tr style="padding-bottom: 20px;">
					<td nowrap="nowrap" width="70" class="font-12px" valign="top"><b><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:&nbsp;</b></td>
					<td width="100%" class="font-12px" style="padding-bottom: 20px;">
					  <v3x:attachmentDefine	attachments="${attachments}" />	
						<script type="text/javascript">		
							showAttachment('${bean.id}', 2, 'attachment2Tr', '');		
						</script>
					</td>
				 </tr>
			</table>
		  </td>
		</tr>
		<!-- end -->
		<!-- 本地文件显示 -->
		<tr id="attachmentTr" style="display: none;">
			<td class="paddingLR" height="50" valign="top">
				<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td height="10" valign="top" colspan="2">
							<hr size="1" class="newsBorder">
						</td>
					</tr>
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
		</table>
		<table width="100%" height="30" border="0" id="table1" cellpadding="0" cellspacing="0" class="body-detail">
			<tr>
				<td height="30" class="font-12px" style="text-align: left;" colspan="4">
				<fmt:message key="bul.data.auditAdvice"  bundle="${bulI18N}"  /><fmt:message key="label.colon" />
				</td>
			</tr>
            <tr class="passText" style="background-color: rgb(239, 237, 237)">
                <td height="20" width="80" nowrap="nowrap"  align="center">
                  <a style="font-size: 12;font-weight: bold;color:#318ed9;" onclick="showV3XMemberCard('${bean.auditUserId}',getA8Top());">
                  ${v3x:showMemberName(bean.auditUserId)}</a>
                </td>
                <td width="100" align="left" nowrap="nowrap" style="font-size: 12;font-weight: bold; color:#111;">    
                  <c:if test="${bean.state==20}">
    				<fmt:message key="label.accept" />
    				</c:if>
    				<c:if test="${bean.state==30}">
    				<fmt:message key="label.accept2" />
    				</c:if>
    				<c:if test="${bean.state==40}">
    				<fmt:message key="label.noaccept" />
				  </c:if>             
                </td>
                <td nowrap="nowrap" style="color: #a3a3a3;font-size: 12">
                  <fmt:formatDate value="${bean.auditDate}" pattern="yyyy-MM-dd HH:mm" />
                </td>
                <td nowrap="nowrap">
                </td>
            </tr>
		</table>	
		<table width="100%" height="30" border="0" cellpadding="0" cellspacing="0" class="body-detail">
			<tr>	
				<td class="padding-30" colspan="6">
                    ${v3x:toHTML(bean.auditAdvice)}&nbsp;
                </td>
			</tr>
		</table>
		</div>	
		</td>
	</tr>
	</table>
<iframe id="hiddenIframe" name="hiddenIframe" width="0" height="0" frameborder="0"></iframe>
<script>
  bindOnresize('scrollList', 0, 10);
</script>
</body>
</html> 