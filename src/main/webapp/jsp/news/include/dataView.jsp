<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
		<tr>
			<td height="10" class="label"><fmt:message key="news.data.title" /><fmt:message key="label.colon" /></td>
			<td>
				${bean.title}
			</td>
		</tr>
		<tr>
			<td height="10" class="label"><fmt:message key="news.data.type" /><fmt:message key="label.colon" /></td>
			<td>
				${bean.type.typeName}
			</td>
		</tr>
		<c:if test="${bean.id!=null}">
		<tr>
			<td height="10" class="label"><fmt:message key="news.data.createUser" /><fmt:message key="label.colon" /></td>
			<td>${bean.createUserName} (<fmt:formatDate value="${bean.createDate}" pattern="${datePattern}"/>)</td>
		</tr>
		</c:if>
		<tr id="attachmentTR" style="display:none;">
			<td height="10" class="label"><fmt:message key="label.attachments" /><fmt:message key="label.colon" /></td>
			<td>
				<v3x:attachmentDefine attachments="${attachments}" />
						<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
						<script type="text/javascript">
							<!--
							showAttachment('${bean.id}', 0, 'attachmentTr', 'attachmentNumberDiv');
							//-->
						</script>
			</td>
		</tr>
		<tr>
			<td colspan="2" height="5" class="detail-summary-separator"></td>
		</tr>
		<tr>
			<td colspan="2">
		

					
			<c:if test="${bean.dataFormat == 'HTML'}">
				<v3x:showContent content="${bean.content}" type="${bean.dataFormat}" 
				createDate="${bean.createDate}" htmlId="content" />
            </c:if>
           	<c:if test="${bean.dataFormat != 'HTML'}">
			<v3x:editor htmlId="content" content="${bean.content}" type="${bean.dataFormat}" 
					createDate="${bean.createDate}" category="6" editType = "0,0"
					/>
            </c:if>
			
			</td>
		</tr>
	</table>