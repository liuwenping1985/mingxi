<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="webmailheader.jsp" %>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.ctp.common.constants.Constants" %>
<%@page import="com.seeyon.v3x.organization.domain.V3xOrgEntity" %>	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>邮件转协同</title>
<script type="text/javascript">
	function isSelected()
		{
			var ids = document.getElementsByName("userId");
			var selectCount = 0;
			for(var i = 0; i < ids.length; i++){
				if(ids[i].checked){
					selectCount++;
				}
			}
			return selectCount;
		}
		
	function sendCol(){
	   
	   var count = isSelected();
			if(count == 0){
				alert("请选择要发给的人！");
				return false;
			}
	   var flowType1=document.getElementById("flowType1");
	   var flowType2=document.getElementById("flowType2");
	   if(((flowType1.checked)==false)&&((flowType2.checked)==false)){
	    alert("请选择发送模式！");
	    return false;
	    }
	   //alert("OK here submit!");
	   var form = document.getElementById("listForm");
	  // form.target="_parent";
	   var url = "<html:link renderURL='//collaboration.do?method=autoSend' />";
				//url += "?folderType=1";
	   form.action = url;
				//alert(url);
	   saveAttachment();
	   form.submit();
	}
	

</script>
</head>
<body scroll="no">

<v3x:attachmentDefine attachments="${attachments}" />

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
	  <form name="listForm" id="listForm" method="post" style="margin: 0px">
	<tr>
		<td height="10" class="detail-summary">
		
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
				<tr>
					<td height="22" nowrap class="bg-gray">协同发起人: </td>
					<td><c:out value='${from}' /></td>
				</tr>
				<tr>
					<td width="90" height="28" nowrap class="bg-gray detail-subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /> : </td>
					<td class="detail-subject"><input type="text" name="subject" value=${subject} id="subject" size="15"/></td>
				</tr>
				
				
				
				<tr id="attachmentTR" class="bg-summary" style="display:none;">
                  <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /></td>
                  <td colspan="8" valign="top"><div class="div-float">(<span id="attachmentNumberDiv"></span>个)</div>
		          <v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" originalAttsNeedClone="${cloneOriginalAtts}" />
                  </td>
                </tr>
                
				<tr>
					<td height="22" nowrap class="bg-gray">协同流程信息: </td>
					<td>
					<label for="flowType1">
					<input type="radio" id="flowType1" name="flowType" value="0"/>串发 
					</label>
					<label for="flowType2">
					<input type="radio" id="flowType2" name="flowType" value="1"/>并发
					</label>
					</td>
				</tr>
				<tr>
					<td><input type="button" value="发送协同" onclick="sendCol()"/></td>
				</tr>
				<tr>
					
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	<td height="100">
	<div class="scrollList">
                  
                    <v3x:table htmlId="listTable" data="list" var="bean" pageSize="${pageSize}" size="${size}" showHeader="false" showPager="false" isChangeTRColor="true">
		             <v3x:column width="7%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
		                <input type='checkbox' name='userId' value="<c:out value="${bean.id}"/>;<c:out value="${bean.name}"/>;<c:out value="${bean.type}"/>" />

		             </v3x:column>
		             <v3x:column width="40%" type="String" onDblClick="" onClick="" label="label.head.subject" className="cursor-hand sort" alt="${bean.name}">
			            <c:out value="${bean.name}" />
		             </v3x:column>
		             <v3x:column width="53%" type="String" onDblClick="" onClick="" label="label.head.from" className="cursor-hand sort" alt="${bean.description}">
			            
			            <c:if test="${bean.type=='1'}">
	           				成员
	  					</c:if>
		             </v3x:column>
					</v3x:table>
					
	</div>
	</td>
	</tr>
    <tr>
		<td height="5" class="detail-summary-separator"></td>
	</tr>
	<tr>
		<td valign="top">
			<%-- TODO 修改SRC --%>
			<v3x:editor htmlId="content" content="${content}" type="${bodyType}" createDate="${createDate}" originalNeedClone="${cloneOriginalAtts}" category="<%=ApplicationCategoryEnum.collaboration.getKey()%>" />
		 </td>
	</tr>
	</form>
</table>
</body>
</html>