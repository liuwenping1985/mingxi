<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
</head>
<script type="text/javascript">
	function closeView(){
		window.location.href = "${basicURL}?method=get_template&bid={bid}&delete=delete&surveytypeid=${surveytypeid}&view=view&group=${group}";
	}
</script>
<body scroll = 'auto'>
<form action="" method="get">
<table width="100%"  border="0" cellspacing="0"
	cellpadding="0" align="center">
	<tr>
		<td class="bbs-title-bar , bbs-td-center" colspan="2" height="26"
			align="left"><font style="font-size:14px"><c:out
			value="${param.surveyname}" /></font></td>
	</tr>
	<tr>
		<td>
		<a name="top" id="top"></a>
		<table width="100%" border="0" cellspacing="0" cellpadding="0"
			align="center">
			<tr>
				<td>
				<table width="100%" height="100%" border="0" cellspacing="0"
					cellpadding="0" class="bbs-table2">
					<tr>
						<td width="30%" class="tbCell2 , bbs-bg , bbs-tb-bottom"
							valign="top">
						<table width="100%" border="0">
						   
							<tr>
								<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.creater.label" />:</td>
						    </tr>
							<tr>
							   <td  width="2%">&nbsp;</td>
							   <td  width="98%"><c:out value="${sessionScope['com.seeyon.current_user'].name}" /></td>
							</tr>
							<tr>
								<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.send.department.label" />:</td>
						    </tr>
							<tr>
							   <td  width="2%">&nbsp;</td>
							   <td  width="98%"><c:out value="${param.deptname}" /> </td>
							</tr>
							<tr height="2px">
							   <td colspan="3" height="2px"><div class="line"><sub></sub></div></td>
							</tr>
							<tr>
								<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.category.label" />:</td>
						    </tr>
						    <tr>
							   <td  width="2%">&nbsp;</td>
							   <td  width="98%"><c:out value="${param.cname}" /></td>
							</tr>
							<tr height="2px">
							   <td colspan="3" height="2px"><div class="line"><sub></sub></div></td>
							</tr>
							<tr>
								<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.date.rane.label" />:</td>
						    </tr>
							<tr>
							  <td  width="2%">&nbsp;</td>
							   <td  colspan="2">
							   <fmt:formatDate value="${sendtime}" pattern="${ datetimePattern }" var="sendsj"/>
							   <c:choose>
							      <c:when test="${param.send_date ==''}">
							         <c:out value="${sendsj}" /> 
							      </c:when>
							      <c:otherwise>
							           <c:out value="${param.send_date}" />
							      </c:otherwise>
							   </c:choose>
							    &nbsp;&nbsp;<fmt:message key="inquiry.to.label" /></td>   
							</tr>
							<tr>
							   <td  width="2%">&nbsp;</td>
							   <td  colspan="2">
							   <c:choose>
							       <c:when test="${ param.close_date == '' }">
							             <fmt:message key="inquiry.no.limit" />
							       </c:when>
							       <c:otherwise>
							       		${param.close_date}
							       </c:otherwise>
							   
							   </c:choose>
							   </td>   
							</tr>
							<tr height="2px">
							   <td colspan="3" height="2px"><div class="line"><sub></sub></div></td>
							</tr>
							
							<tr>
							  <tr>
								   <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="common.issueScope.label" bundle="${v3xCommonI18N}" />:</td>
						       </tr>
								 <tr>
									<td  width="2%">&nbsp;</td>
									<td colspan="2"><c:out value="${param.obj}" /></td>
							   </tr>
						</table>
						</td>

						<td width="65%" valign='top' class="bbs-tb-bottom">
						
						<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td valign="top" style="padding-top: 4px">
									<fmt:message key="inquiry.discription"/>: ${descInquiry}
								</td>
							</tr>
							<tr>
								<td valign="top">
								<%
									String qarr[] = request.getParameterValues("questionSort");
									if (qarr.length > 0) {
										for (int i = 0; i < qarr.length; i++) {
											String title = request.getParameter("question" + i + "Title");
											String som = request.getParameter("question" + i + "SingleOrMany");
											String other = request.getParameter("question" + i + "OtherItem");
											String diss = request.getParameter("question" + i + "Discuss");
											String desc = request.getParameter("question" + i + "Desc");
											String itemarr[] = request.getParameterValues("question" + i + "Item");
								%>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><%=i + 1%>.<%=title%>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<%
													if (itemarr != null && itemarr.length > 0) {
													for (int j = 0; j < itemarr.length; j++) {
														String sitem = itemarr[j];
												%>
												<tr>
													<td height="20">
													<label for="som1">
														<%
														if ("0".equals(som)) {
														%> <input type="radio" id="som1" disabled="disabled"> <%
														}
														if ("1".equals(som)) {
														%> <input type="checkbox" id="som1" disabled="disabled"> <%
														}
														%> <%=sitem%></label>
													</td>
												</tr>
												<%
															}
															}
	
															if ("0".equals(other)) {
												%>
												<tr>
													<td height="20">
													<label for="som2">
													<%
													if ("0".equals(som)) {
													%> <input type="radio" id="som2" disabled="disabled"> <%
	 		}
	 		if ("1".equals(som)) {
	 %> <input type="checkbox" id="som2" disabled="disabled"> <%
	 }
	 %> <fmt:message key="inquiry.question.otherItem.label" /></label><input
														type="text" readonly="readonly"></td>
												</tr>
												<%
															}
															if ("0".equals(diss)) {
												%>
												<tr>
													<td><fmt:message key="inquiry.add.review.label" /><br>
													<textarea cols="120" rows="5"
														style="border:1px solid #d8d8d8" readonly="readonly"></textarea>
													</td>
												</tr>
												<%
												}
												%>
											</table>
											</td>
										</tr>
									</table>
								<%
									}
									}
								%>
								
								</td>
							</tr>
							<c:if test="${showLoad == 1}">
									<tr id="attachmentTR" class="bg-summary" style="display:none;">
										<td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message
											key="common.attachment.label" bundle="${v3xCommonI18N}" />:&nbsp;
										</td>
										<td colspan="8" valign="top">
										<div class="div-float">(<span id="attachmentNumberDiv"></span>个)</div>
										<v3x:fileUpload attachments="${attachments}" originalAttsNeedClone="true" /></td>
									</tr>
							</c:if>
							<input type="hidden" name="loadFile" value="${attachments}">
						</table>
						</td>
					</tr>
				</table>
				</td>
			</tr>

			<tr>
				<td colspan="2" height="24" align="center">
					<input type="button" name="b2" onclick="closeView()" value="<fmt:message key='common.toolbar.back.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
				</td>
			</tr>
			<a name="buttom" id="buttom"></a>
		</table>
		</td>
		</tr>
		</table>
	
 </form>
</body>
</html>
