<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<html>
	<head>
	
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<c:set var="titleKey" value="${param.singleMany!='2' ? 'inquiry.look.review.label' : 'inquiry.look.answer.label'}" />
		<title><fmt:message key="${titleKey}" /></title>
		
		<script type="text/javascript">
		<!--
			//删除评论   支持批量删除
			function delDis(){
			
				var ids=document.getElementsByName('id');
				var id='';
				for(var i=0;i<ids.length;i++){
					var idCheckBox=ids[i];
					if(idCheckBox.checked){
						id=id+idCheckBox.value+',';
					}
				}
				if(id==''){
					alert(v3x.getMessage("InquiryLang.inquiry_choose_item_from_list"));
					return;
				}
				//isInquiry_createUser是发起人标志
				mainForm.action="${basicURL}?method=discuss_delete&tid=${param.tid}&bid=${param.bid}&qid=${param.qid}&did="+id+"&isInquiry_createUser=true&qname="+encodeURIComponent('${v3x:escapeJavascript(param.qname)}');
				mainForm.submit();
				
			}
		
			function returnResult(){
				location.replace("${basicURL}?method=survey_result&tid=${param.tid}&bid=${param.bid}&manager_ID=${v3x:escapeJavascript(param.manager_ID)}&isInquiry_createUser=${isInquiry_createUser}");
			}
		  
			//var myBar = new WebFXMenuBar;
			//myBar.add(new WebFXMenuButton("return", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />", "javascript:returnResult();", "<c:url value='/common/images/toolbar/back.gif'/>", "", null));
			//document.write(myBar);
			function closeAndRefreshParent(){
				parent.opener.document.location.herf = parent.opener.document.location;
				getA8Top().close();
			}
		//-->
		</script>
	
	</head>

	<body scroll='no' >
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">		
			<tr class="page2-header-line">
				<td colspan="2">
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="CollTable">
						<tr class="page2-header-line" height="45">
							<td class="page2-header-bg" width="380"><fmt:message key="${titleKey}" /></td>
							<td class="page2-header-line padding-right" align="right"></td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="padding5" height="100%" valign="top">
				<div class="scrollList">
					<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="">
					
						<tr>
							<td height="22" class="webfx-menu-bar page2-list-header">
								<b><fmt:message key="inquiry.now.question" /> : &nbsp;<span title="${v3x:toHTML(param.qname)}">${v3x:getLimitLengthString(param.qname,50,"...")}</span></b>
							</td>
						</tr>
						
						<tr>
							<td valign="top" height="10%" class="border-top">
								<form action="" name="mainForm" id="mainForm" method="post">
									<c:set value="${param.singleMany!='2' ? 'inquiry.review.context.label' : 'inquiry.answer.context.label'}" var="column1Key" />
									<c:set value="${param.singleMany!='2' ? 'inquiry.review.people.label' : 'inquiry.answer.people.label'}" var="column2Key" />
									<c:set value="${param.singleMany!='2' ? 'inquiry.review.time.label' : 'inquiry.answer.time.label'}" var="column3Key" />
												
						            <v3x:table data="${dlist}" var="sub" htmlId="as" isChangeTRColor="true" showHeader="true" showPager="true" pageSize="0" leastSize="0" dragable="false">
								   		<c:if test="${manager=='inquiry_manager'}">
									   		<v3x:column width="20" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
									   		<input type='checkbox' name='id' value="${sub.dcs.id}" />
										    </v3x:column>
								   		</c:if>
										<v3x:column label="${column1Key}" type="String" value="${sub.dcs.discussContent}" maxLength="50" alt="${sub.dcs.discussContent}" symbol="..." width="229"></v3x:column>
											<c:if test="${param.cryptonym == '0'}">
									    		<v3x:column label="${column2Key}" type="String" value="${sub.user.name}"  width="229"></v3x:column>
									    	</c:if>
									    <v3x:column width="229" label="${column3Key}" type="Date"  align="left"><fmt:formatDate value="${sub.dcs.discussDate}" pattern="${ datetimePattern }"/></v3x:column>
								  	
								  	</v3x:table>
								</form>
							</td>
						</tr>
						
						
						<tr>
							<td valign="top" class="page2-list-header">
								<c:if test="${manager=='inquiry_manager'}">
									<fmt:message key="common.toolbar.delete.label" bundle='${v3xCommonI18N}' var="delete"/>
									<input type="button" class="button-default-2" value="${delete}" onClick="delDis()"/>
								</c:if>
							</td>
						</tr>
						
					</table>
					</div>
				</td>
			</tr>
			
			<tr>
				<td class="bg-advance-bottom" align="right">
					<input type="button" class="button-default-2" onClick="closeAndRefreshParent()" value="<fmt:message key='common.button.close.label' bundle='${v3xCommonI18N}'/>" name="B3">&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
		</table>
	</body>
</html>
