<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="logHeader.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>	
<title>Insert title here</title>
</head>
<style>
.link-blue{
	color:#1039b2;
	cursor: pointer;
	text-decoration:none;
}
</style>
<script>
function showDetail(userId){
	v3x.openWindow({
        url: logonLog + "?method=detailListMain&userId=" + userId + "&startDay=${param.startDay}&endDay=${param.endDay}",
        height: 400,
        width: 780,
        resizable:'no'
    });
}
</script>
<body scroll="no">
		<div  id="dataList">	
			<form>
			<v3x:table data="${totalOnlineTime}" var="result"
				htmlId="aa" isChangeTRColor="true" showHeader="true" showPager="true"
				pageSize="20" formMethod="post">
				<v3x:column width="20%" label="logon.stat.person" maxLength="40" type="String">
				<c:choose>
					<c:when test="${result[0]=='null' }">
						v3x:showMemberName(1)
					</c:when>
					<c:otherwise>
						<c:set var="logMember" value="${v3x:getOrgEntity('Member', result[0]) }"/>
						<c:choose>
							<c:when test="${logMember == null }">
								${v3x:showMemberNameOnly(result[0])}
							</c:when>
							<c:when test="${logMember.isDeleted}">
								<font color="gray"><s>${v3x:showMemberNameOnly(result[0])}</s></font>
							</c:when>
							<c:otherwise>
								${v3x:showMemberNameOnly(result[0])}
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>				
				</v3x:column>
			  <c:if test="${v3x:getSysFlagByName('sys_isGroupVer')=='true'}">
			  
			  <v3x:column width="20%" label="log.toolbar.title.account" maxLength="40" type="String" value="${ v3x:showOrgAccountNameByMemberid(result[0])}"/>
			  </c:if>				
 				 <v3x:column width="20%" label="logon.org.post" type="String" maxLength="25" symbol="..." value="${v3x:showOrgPostNameByMemberid(result[0]) }" /> 
				
				<v3x:column width="15%" label="logon.stat.onlineTime" maxLength="40"
					value="${result[1] }" type="String"/>
				<v3x:column width="25%" label="logon.stat.viewDetail" maxLength="40"	
					className="cursor-hand sort"  type="String">
					<a class="link-blue font-12px" onclick="showDetail('${result[0]=='null'?'1':result[0] }')">${v3x:_(pageContext,'logon.stat.detail.label') } </a>									
					</v3x:column>
			</v3x:table>
			</form>
		</div>
</body>
</html>
