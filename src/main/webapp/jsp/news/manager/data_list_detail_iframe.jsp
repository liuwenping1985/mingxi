<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<html>
<head>
<%@ include file="../include/header.jsp" %>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
</head>
<body >
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center"  class="">
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
	<tr>
		<td class="body-bgcolor-audit" width="100%" height="100%" >
		<div class="scrollList">
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="body-detail">
	    <tr>
			 <td height="30">
			 	<table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-bottom: 1px solid #A4A4A4;">
				 <tr>
				   <td align="center" width="100%" class="titleCss" style="padding: 20px 6px;">${bean.title}</td>
				 </tr>
				</table>
			</td>
		</tr>
		<tr style='background-color:#f6f6f6'>
			<td align="center" class="paddingLR font-12px" height="30">
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
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="word-break:break-all;word-wrap:break-word">
				<c:if test="${bean.showKeywordsArea == true}"> 
				<tr>
					<td class="font-12px" align="right" width="60" height="24"><b><fmt:message key="news.data.keywords" />:</b></td>
					<td class="font-12px" style="padding: 0 12px;">
						${bean.keywords}
					</td>
				</tr>
				</c:if>
				<c:if test="${bean.showBriefArea == true}">
				<tr>
					<td class="font-12px" valign="top" height="40" align="right"><b><fmt:message key="news.data.brief"/>:</b></td>
					<td class="font-12px" valign="top" style="padding: 0 6px;">&nbsp;&nbsp;${bean.brief}</td>
				</tr>
				</c:if>
				</table>
			</td>	
		</tr>
		</c:if>
		<tr>
			<td width="100%" height="100%" style="padding-bottom: 6px;" valign="top">
				<div>	
	            <v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" htmlId="content" />	
				</div>
                <style>
                    .contentText p{
                        font-size:14px;
                    }
                </style>
			</td>
		</tr>
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
		<table width="100%" height="80" border="0" cellpadding="0" cellspacing="0" class="body-detail">
		    <tr>
		    	<td height="20" class="passText" nowrap="nowrap">
		    		<fmt:message key="bul.data.auditAdvice"  bundle="${bulI18N}"  /><fmt:message key="label.colon" />
		    	</td>
		    </tr>
            <tr class="passText" style="background-color: rgb(239, 237, 237)">
                <td height="20" width="80" nowrap="nowrap"  align="center">
                  <a style="font-size: 12;font-weight: bold;color:#318ed9;" onclick="showV3XMemberCard('${bean.auditUserId}',getA8Top());">
                  ${v3x:showMemberName(bean.auditUserId)}</a>
                </td>
                <td width="100" align="left" nowrap="nowrap" style="font-size: 12;font-weight: bold; color:#111;">    
    				<c:if test="${bean.ext3 == '1'}">
    					<fmt:message key="label.audit" bundle="${bulI18N}" /><fmt:message key="label.accept" bundle="${bulI18N}"/>
    				</c:if>
    				<c:if test="${bean.ext3 == '2'}">
    					<fmt:message key="label.accept2" bundle="${bulI18N}"/>
    				</c:if>
    				<%-- 鏃х増鏈腑鐨勫唴瀹逛粛鍏煎涓轰竴寰嬫樉绀�"鐩存帴鍙戝竷",鍚﹀垯鏃х増鍐呭灏嗘樉绀轰负绌� --%>
    				<c:if test="${bean.ext3!=1 && bean.ext3!=2}">
    					<fmt:message key="label.accept2" bundle="${bulI18N}"/>
    				</c:if>
                </td>
                <td nowrap="nowrap" style="color: #a3a3a3;font-size: 12">
                  <fmt:formatDate value="${bean.auditDate}" pattern="yyyy-MM-dd HH:mm" />
                </td>
                <td nowrap="nowrap">
                </td>
            </tr>
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
</body>
</html>