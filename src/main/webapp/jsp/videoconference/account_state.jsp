<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="head.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>autoInfoList.jsp</title>
	</head>
	<body topmargin="0" leftmargin="0" scroll="no">
		<form name="listForm" id="listForm" method="post" style="margin: 0px"
			action="${videoconfURL}?method=saveAccountState">
			<table width="100%" border="0" height="100%" cellspacing="0"
				cellpadding="0">

				<tr>
					<td>
						<div class="scrollList" width="100%">
							<v3x:table htmlId="listTable" data="accountlist" var="bean"
								width="100%" showHeader="true" showPager="false"
								isChangeTRColor="true">
								<v3x:column width="4%" align="center"
									label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>" >
										<c:choose>
										<c:when test="${selectIdFlag==0}">
											<input type='checkbox' name='id'
												value="<c:out value='${bean.a8Id}'/>" checked="checked" />
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${bean.synState==0}">
													<input type='checkbox' name='id'
														value="<c:out value='${bean.a8Id}'/>" checked="checked" />
												</c:when>
												<c:otherwise>
													<input type='checkbox' name='id'
														value="<c:out value='${bean.a8Id}'/>" />
												</c:otherwise>
											</c:choose>
										</c:otherwise>

									</c:choose>
									
									</v3x:column>
								<v3x:column width="20%" type="String"
									label="org.synchron.organization.name"
									className="cursor-hand sort">
									<c:out value="${bean.entityName}" />
								</v3x:column>
								<v3x:column width="20%" type="String"
									label="org.synchron.organization.type"
									className="cursor-hand sort">
									<c:choose>
										<c:when test="${bean.type==0}">
				        [<fmt:message key='org.synchron.account' />] 
				</c:when>
										<c:otherwise>
				       [<fmt:message key='org.synchron.dept' />] 
				</c:otherwise>
									</c:choose>
								</v3x:column>
								<v3x:column width="20%" type="String"
									label="org.synchron.organization.synset"
									className="cursor-hand sort">
									<c:choose>
										<c:when test="${bean.synState==0}">
				      [<fmt:message key='org.synchron.synlisthas' />] 
				</c:when>
										<c:otherwise>
				        [<fmt:message key='org.synchron.synlistnot' />] 
				</c:otherwise>
									</c:choose>
								</v3x:column>
								<v3x:column width="20%" type="String"
									label="org.synchron.organization.synstate"
									className="cursor-hand sort">
									<c:choose>
										<c:when test="${bean.isSynedState==0}">
				         [<fmt:message key='org.synchron.synedhas' />]
				</c:when>
										<c:otherwise>
				       [<fmt:message key='org.synchron.synednot' />]
				</c:otherwise>
									</c:choose>
								</v3x:column>
							</v3x:table>

						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" height="10%">
					<!-- radishlee add 2012-2-11 一期全部同步 
						<div align="center">
							<input type="submit"
								value="<fmt:message key='org.synchron.saveset'/>" align="center">
						</div>
	                 -->
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>