<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<html>
<head>
<title>

</title>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<%@ include file="../include/header.jsp" %>
</head>
<body scroll="no" style="overflow: hidden;" onkeydown="listenerKeyESC()">

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
    <c:if test="${param.needBreak == 'true'}">
	<tr height="8">
			<td  width="100%" height="8" >
				<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
					<tr >
						<td colspan="6" width="100%" height="8">
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
				 <td colspan="6" height="30">
				 <table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-bottom: 1px solid #A4A4A4;">
					 <tr>
					   <td align="center" width="90%" class="titleCss" style="padding: 20px 6px;">${v3x:toHTML(bean.title)}</td>
					  </tr>
					</table>
				 </td>
				</tr>
				<tr style='background-color:#f6f6f6'>
					<td class="font-12px" align="right" width="12%" height="28"><fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
					<td class="font-12px" width="24%">${v3x:toHTML(bean.publishDeptName)}</td>
					<td class="font-12px" align="right" width="12%"><fmt:message key="bul.data.type" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
					<td class="font-12px" width="24%">${v3x:toHTML(bean.type.typeName)}</td>
					<td class="font-12px" align="right" width="12%"><fmt:message key="bul.data.createDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
					<td class="font-12px" width="16%"><fmt:formatDate value="${bean.createDate}" pattern="${datePattern}" /></td>
				</tr>
                <tr>
                    <td width="100%" height="100%" valign="top" colspan="6">
                        <div style="height: 100%;">                               
                            <v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" htmlId="content" />        
                        </div>
                        <style>
                            .contentText p{
                                font-size:14px;
                            }
                        </style>
                    </td>
                </tr>
				<tr id="attachmentTr" style="display: none">
				  <td class="paddingLR" height="30" colspan="6">
				   <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
					<tr>
						<td height="10" valign="top" colspan="6">
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
                <tr id="attachment2Tr" style="display: none">
                  <td class="paddingLR" colspan="6">
                   <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
                    <tr style="padding-bottom: 20px;">
                        <td nowrap="nowrap" width="80" class="font-12px"><b><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:&nbsp;</b></td>
                        <td width="100%" class="font-12px">
                          <v3x:attachmentDefine attachments="${attachments}" />        
                            <script type="text/javascript"> 
                                showAttachment('${bean.id}', 2, 'attachment2Tr', '');   
                            </script>
                        </td>
                     </tr>
                    </table>
                  </td>
                </tr>
			</table>
			
			
				<table border="0" height="80" cellpadding="0" cellspacing="0" class="body-detail" align="center" style="padding: 6px;">
					<tr>
						<td height="20" class="" nowrap="nowrap">
							<b class="div-float"><fmt:message key="bul.data.auditAdvice" /><fmt:message key="label.colon" /></b>
						</td>
					</tr>
                    <tr class="passText" style="background-color: rgb(239, 237, 237)">
                      <td height="20" width="80" nowrap="nowrap"  align="center">
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
                      <td nowrap="nowrap">
                      </td>
                  </tr>
					<tr>
						<td class="padding-30">
							${v3x:toHTML(bean.auditAdvice)}&nbsp;
						</td>
					</tr>
					
				</table>

		</div>	
		</td>
	</tr>
</table>
<iframe name="hiddenIframe" width="0" height="0" frameborder="0"></iframe>
<script>
  bindOnresize('scrollList', 0, 10);
</script>
</body>
</html> 