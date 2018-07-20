<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@include file="header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.personalaffair.resources.i18n.PersonalAffairResources" var="personalAffairI18N"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
<script>
<%--function param--%>
var pathMyTemplate = "${urlMyTemplate}";
var paramType = "${v3x:escapeJavascript(type)}";
<%--toolbar--%>
var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
myBar.add(new WebFXMenuButton("rename", "<fmt:message key='common.toolbar.rename.label' bundle='${v3xCommonI18N}'/>", "rename()", [1,2]));
myBar.add(new WebFXMenuButton("del", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "del()", [1,3], "", null));
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/myTemplate.js${v3x:resSuffix()}"/>"></script>
<body scroll="no" style="overflow: hidden" class="">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="page-list-border">
			<tr>
				<td height="25" class="webfx-menu-bar">
					<script type="text/javascript">
						document.write(myBar);	
						document.close();
					</script>
				</td>
				<td class="webfx-menu-bar">
					<form action="" name="listForm" id="listForm" method="post"
						onsubmit="return false" style="margin: 0px">
						<input type="hidden" value="" name="selectedValue" />
						<div class="div-float-right">
							<select name="type" id="type" onChange="changedType();">
							<c:choose>
							    <c:when test="${param.type=='col'  || param.type==''}">
							    <c:if test="${v3x:hasPlugin('collaboration')}"> 
							    	<option value="col" selected><fmt:message key='mytemplate.type.col'/></option>
							    	</c:if>
                                    <c:if test="${v3x:hasPlugin('meeting')}">
									<option value="meeting"><fmt:message key="mytemplate.type.meeting" /></option>
									</c:if>
                                    <c:if test="${v3x:hasPlugin('inquiry')}">
									<option value="inquiry"><fmt:message key="mytemplate.type.inquiry" /></option>
									</c:if>
									<%--branches_a8_v350_r_gov GOV-2814 于荒津增加公文个人模版分类查询 start --%>
									<c:if test="${v3x:hasPlugin('edoc')}">
										<option value="edoc"><fmt:message key="mytemplate.type.edoc" bundle="${personalAffairI18N}"  /></option>
									</c:if>
									<c:if test="${v3x:hasPlugin('infosend')}">
										<option value="info"><fmt:message key="mytemplate.type.info"  /></option>
									</c:if>
									<%--branches_a8_v350_r_gov GOV-2814 于荒津增加公文个人模版分类查询 end --%>		
								</c:when>
								<c:when test="${param.type=='meeting'}">	
								<c:if test="${v3x:hasPlugin('collaboration')}"> 
									<option value="col"><fmt:message key='mytemplate.type.col'/></option>
									</c:if>
                                    <c:if test="${v3x:hasPlugin('meeting')}">
									<option value="meeting" selected><fmt:message key="mytemplate.type.meeting"  /></option>
									</c:if>
                                    <c:if test="${v3x:hasPlugin('inquiry')}">
									<option value="inquiry"><fmt:message key="mytemplate.type.inquiry" /></option>
									</c:if>
                        
									<%--branches_a8_v350_r_gov GOV-2814 于荒津增加公文个人模版分类查询 start --%>
									<c:if test="${v3x:hasPlugin('edoc')}">
										<option value="edoc"><fmt:message key="mytemplate.type.edoc" bundle="${personalAffairI18N}" /></option>
									</c:if>
									<%--branches_a8_v350_r_gov GOV-2814 于荒津增加公文个人模版分类查询 end --%>		
									<c:if test="${v3x:hasPlugin('infosend')}">
										<option value="info"><fmt:message key="mytemplate.type.info"  /></option>
									</c:if>
								</c:when>	
								<c:when test="${param.type=='inquiry'}">
								    <c:if test="${v3x:hasPlugin('collaboration')}">	
									<option value="col"><fmt:message key='mytemplate.type.col'/></option>
									</c:if>
                                    <c:if test="${v3x:hasPlugin('meeting')}">
									<option value="meeting"><fmt:message key="mytemplate.type.meeting"  /></option>
									</c:if>
                                    <c:if test="${v3x:hasPlugin('inquiry')}">
									<option value="inquiry" selected><fmt:message key="mytemplate.type.inquiry" /></option>
									</c:if>
									<%--branches_a8_v350_r_gov GOV-2814 于荒津增加公文个人模版分类查询 start --%>
									<c:if test="${v3x:hasPlugin('edoc')}">
										<option value="edoc"><fmt:message key="mytemplate.type.edoc" bundle="${personalAffairI18N}" /></option>
									</c:if>
									<c:if test="${v3x:hasPlugin('infosend')}">
										<option value="info"><fmt:message key="mytemplate.type.info"  /></option>
									</c:if>
								</c:when>			
								<c:when test="${param.type=='edoc'}">	
							   	 <c:if test="${v3x:hasPlugin('collaboration')}">
									<option value="col"><fmt:message key='mytemplate.type.col'/></option>
									</c:if>
                                    <c:if test="${v3x:hasPlugin('meeting')}">
									<option value="meeting"><fmt:message key="mytemplate.type.meeting"  /></option>
									</c:if>
                                    <c:if test="${v3x:hasPlugin('inquiry')}">
									<option value="inquiry"><fmt:message key="mytemplate.type.inquiry" /></option>
									</c:if>
                                    <c:if test="${v3x:hasPlugin('edoc')}">
									<option value="edoc" selected><fmt:message key="mytemplate.type.edoc" bundle="${personalAffairI18N}" /></option>
									</c:if>
									<c:if test="${v3x:hasPlugin('infosend')}">
										<option value="info"><fmt:message key="mytemplate.type.info"  /></option>
									</c:if>
								</c:when>
								<c:when test="${param.type=='info'}">	
									<option value="col"><fmt:message key='mytemplate.type.col'/></option>
									<option value="edoc"><fmt:message key="mytemplate.type.meeting"  /></option>
									<option value="inquiry"><fmt:message key="mytemplate.type.inquiry" /></option>
									<option value="edoc"><fmt:message key="mytemplate.type.edoc" bundle="${personalAffairI18N}" /></option>
									<c:if test="${v3x:hasPlugin('infosend')}">
										<option value="info" selected><fmt:message key="mytemplate.type.info"  /></option>
									</c:if>
								</c:when>
								<%--branches_a8_v350_r_gov GOV-2814 于荒津增加公文个人模版分类查询 end --%>			
								<c:otherwise>
								    <c:if test="${v3x:hasPlugin('collaboration')}">
									<option value="col" selected><fmt:message key='mytemplate.type.col'/></option>
									</c:if>
									<c:if test="${v3x:hasPlugin('meeting')}">
									<option value="meeting"><fmt:message key="mytemplate.type.meeting" /></option>
									</c:if>
									<c:if test="${v3x:hasPlugin('inquiry')}">
									<option value="inquiry"><fmt:message key="mytemplate.type.inquiry"  /></option>
									</c:if>
									<c:if test="${v3x:hasPlugin('edoc')}">
									<option value="edoc"><fmt:message key="mytemplate.type.edoc" bundle="${personalAffairI18N}" /></option>
									</c:if>
									<c:if test="${v3x:hasPlugin('infosend')}">
										<option value="info"><fmt:message key="mytemplate.type.info"  /></option>
									</c:if>
								</c:otherwise>
							</c:choose>
							</select>&nbsp;&nbsp;
						</div>
					</form>
				</td>
			</tr>
		</table>
    </div>
    <div>
      <form id="renameForm" name='renameForm' action='' method='post' style='margin:0px;padding:0px'>
            <input type='hidden' name='type' id="type" value=''>
            <input type='hidden' name='id' id="id" value=''>
            <input type='hidden' name='newName' id="newName" value=''>
      </form>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<c:set var="currentUser" value="${v3x:currentUser() }"/>
		<form>
			<v3x:table htmlId="pending" data="${templateList}" var="col" showPager="true" >
				<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"ids\")'/>">
					<%-- && col.categoryType == null --%>
					<c:if test="${param.type=='col' || param.type==''}">
					  <input type='checkbox' name='ids' value="<c:out value="${col.id}"/>" affairId="<c:out value="${col.id}" />" />
					</c:if>	
				    <c:if test="${param.type=='meeting' }">
					  <input type='checkbox' name='ids' value="<c:out value="${col.id}"/>" affairId="<c:out value="${col.id}" />" />
					</c:if>	
				    <c:if test="${param.type=='inquiry' }">
					  <input type='checkbox' name='ids' value="<c:out value="${col.id}"/>" affairId="<c:out value="${col.id}" />" />
					</c:if>	
					<c:if test="${param.type=='edoc' || param.type=='info'}">
					  <input type='checkbox' name='ids' value="<c:out value="${col.id}"/>" affairId="<c:out value="${col.id}" />" />
					</c:if>		
				</v3x:column>
				<v3x:column width="20%" type="String" label="mytemplate.body.type.label" className="sort">
				    <c:if test="${param.type=='col'  || param.type==''}">
				     	<c:choose>
					        <c:when test="${col.type=='template'}">
					          <fmt:message key="templete.category.type.0" />
					        </c:when>
					        <c:otherwise>
					          <fmt:message key="templete.${col.type}.label" />
					        </c:otherwise>
				        </c:choose>
					</c:if>
				    <c:if test="${param.type=='meeting' }">
					  <fmt:message key='mytemplate.type.meeting' />
					</c:if>	
				    <c:if test="${param.type=='inquiry' }">
					  <fmt:message key='mytemplate.type.inquiry' />
					</c:if>		
					<c:if test="${param.type == 'edoc'}">
						<fmt:message key="edoc.templete.category.type.${col.moduleType}" bundle="${edocResourceI18N}"/>
					</c:if>
                    <c:if test="${param.type == 'info'}">
                        <fmt:message key="mytemplate.type.info"  />
                    </c:if>
				</v3x:column>
				<c:choose>
					<c:when test="${param.type=='meeting' }">
						<c:set var="colAccount" value="${col.accountId }"/>
					</c:when>
					<c:when test="${param.type=='inquiry' }">
						<c:set var="colAccount" value="${accountId }"/>
					</c:when>
					<c:otherwise>
						<c:set var="colAccount" value="${col.orgAccountId }"/>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${colAccount != currentUser.loginAccount}">
						<c:set var="theAccount" value="${v3x:getAccount(colAccount)}"/>
						<c:if test="${param.type=='col' || param.type=='edoc' || param.type=='info'  || param.type==''}">
							<c:set var="subject" value="${v3x:toHTML(col.subject)}"/>
						</c:if>
						<c:if test="${param.type=='meeting'}">
							<c:set var="subject" value="${v3x:toHTML(col.title)}"/>
						</c:if>
						<c:if test="${param.type=='inquiry' }">
							<c:set var="subject" value="${v3x:toHTML(col.surveyName)}"/>
						</c:if>
					</c:when>
					<c:otherwise>
						<c:if test="${param.type=='col'  || param.type=='edoc' || param.type=='info'  || param.type==''}">
							<c:set var="subject" value="${v3x:toHTML(col.subject)}"/>
						</c:if>
						<c:if test="${param.type=='meeting'}">
							<c:set var="subject" value="${v3x:toHTML(col.title)}"/>
						</c:if>
						<c:if test="${param.type=='inquiry' }">
							<c:set var="subject" value="${v3x:toHTML(col.surveyName)}"/>
						</c:if>
					</c:otherwise>
				</c:choose>
				<v3x:column width="55%" type="String" label="mytemplate.body.name.label" className="sort">
				    <c:if test="${param.type=='col'  || param.type=='edoc' || param.type=='info'   || param.type==''}">
						<span title="${subject}">${v3x:getLimitLengthString(subject,90,"...")}</span>
					</c:if>	
				    <c:if test="${param.type=='meeting'}">
					  <span title="${subject}">${v3x:getLimitLengthString(subject,90,"...")}</span>
					</c:if>	
				    <c:if test="${param.type=='inquiry' }">
				    	<span title="${subject}">${v3x:getLimitLengthString(subject,90,"...")}</span>	
					</c:if>					
				</v3x:column>
			    <c:if test="${param.type=='col'  || param.type=='edoc' || param.type=='info'   || param.type==''}">	
				    <v3x:column width="10%" type="String" label="common.state.label" className="sort"> 
	                         <fmt:message key="common.state.${col.state=='1'?'invalidation':'normal'}.label" bundle="${v3xCommonI18N}"/>               
	                </v3x:column>
				</c:if>
			</v3x:table>
		</form>
    </div>
  </div>
</div>			
</body>