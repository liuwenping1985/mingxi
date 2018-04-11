<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="head.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title>autoInfoList.jsp</title>
<style type="text/css">
.mxtgrid div.bDiv {
	border: 1px solid #dadada;
	border-top: 0px;
	border-bottom: 0px;
	background: #fff;
	overflow: auto;
	position: relative;
}
</style>
</head>
<body topmargin="0" leftmargin="0" scroll="no">
<div class="main_div_center">
  <div class="right_div_center">
    <div class="center_div_center" id="scrollListDiv">
		<form name="listForm" id="listForm" method="post" style="margin: 0px" action="${gkeURL}?method=saveAccountState">
			<v3x:table htmlId="listTable" data="accountlist" var="bean" width="100%" showHeader="true" showPager="false" isChangeTRColor="true">
				<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>" >
					<c:choose>
						<c:when test="${selectIdFlag==0}">
							<input type='checkbox' name='id' value="<c:out value='${bean.a8Id}'/>" checked="checked" />
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${bean.synState==0}">
									<input type='checkbox' name='id' value="<c:out value='${bean.a8Id}'/>" checked="checked" />
								</c:when>
								<c:otherwise>
									<input type='checkbox' name='id' value="<c:out value='${bean.a8Id}'/>" />
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column width="35%" type="String" label="org.synchron.organization.name" className="cursor-hand sort">
					<c:out value="${bean.entityName}" />
				</v3x:column>
				<v3x:column width="20%" type="String" label="org.synchron.organization.type" className="cursor-hand sort">
					<c:choose>
						<c:when test="${bean.type==0}">
				        	[<fmt:message key='org.synchron.account' />] 
						</c:when>
						<c:otherwise>
				       		[<fmt:message key='org.synchron.dept' />] 
						</c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column width="20%" type="String" label="org.synchron.organization.synset" className="cursor-hand sort">
					<c:choose>
						<c:when test="${bean.synState==0}">
				      		[<fmt:message key='org.synchron.synlisthas' />] 
						</c:when>
						<c:otherwise>
				        	[<fmt:message key='org.synchron.synlistnot' />] 
						</c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column width="20%" type="String" label="org.synchron.organization.synstate" className="cursor-hand sort">
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
			<table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0">
				<tr>
					<td height="10%">
						<div align="center">
						<input type="submit" class="button-default-2" value="<fmt:message key='org.synchron.saveset'/>">
						</div>
					</td>
				</tr>
			</table>
	</form>
    </div>
  </div>
</div>
</body>
</html>