<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>	
<%@ include file="../include/taglib.jsp"%>
<v3x:attachmentDefine attachments="${attachments}" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
	<tr>
		<td height="10" class="detail-summary">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
				<tr>
					<td width="20%" height="28" nowrap class="bg-gray" align="right"><fmt:message key="bul.data.title" /><fmt:message key="label.colon" /></td>
					<td width="30%">${bean.title}</td>
					<td width="10%" height="22" nowrap class="bg-gray"><fmt:message key="bul.data.type" /><fmt:message key="label.colon" /></td>
					<td width="40%">${bean.type.typeName}</td>
				</tr>
				<tr>
					<td height="22" nowrap class="bg-gray"><fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" /></td>
					<td>
						<c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeStr" />
				    	<div title="${v3x:toHTML(publishScopeStr)}">${v3x:getLimitLengthString(publishScopeStr, 30, "...")}</div>
					</td>
		            <c:if test="${bean.id!=null}">
			        <td height="10" nowrap class="bg-gray"><fmt:message key="bul.data.createUser" /><fmt:message key="label.colon" /></td>
			        <td>${v3x:showMemberName(bean.createUser)} (<fmt:formatDate value="${bean.createDate}" pattern="${datePattern}"/>)</td>
			        </c:if>
		        </tr>		        
				<tr id="attachmentTr" style="display: none">
					<td height="18" nowrap class="bg-gray" valign="top"><fmt:message key="label.attachments" /><fmt:message key="label.colon" /></td>
					<td>
						<div class="attachment-single div-float" onmouseover="exportAttachment(this)">
							<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
							<script type="text/javascript">
							<!--
							showAttachment('${bean.id}', 0, 'attachmentTr', 'attachmentNumberDiv');
							//-->
							</script>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
		<td height="5" class="detail-summary-separator"></td>
	</tr>
	<tr>	    
		<td>
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
          <tr height="5%"></tr>
          <tr>
            <td class="body-left">&nbsp;</td>
            <td valign="top">
            <c:if test="${bean.dataFormat == 'HTML'}">
            <v3x:showContent content="${bean.content}" type="${bean.dataFormat}" 
            	createDate="${bean.createDate}" htmlId="content" contentName="${bean.contentName}" />
            </c:if>
           	<c:if test="${bean.dataFormat != 'HTML'}">
                        <v3x:editor htmlId="content" content="${bean.content}" type="${bean.dataFormat}" 
					createDate="${bean.createDate}" category="7" 
					editType = "0,0"
					/>	
            </c:if>

            </td>
            <td class="body-right">&nbsp;</td>
          </tr>
        </table>			
        </td>
	</tr>
</table>