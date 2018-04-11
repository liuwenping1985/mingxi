<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html>
<head>
<%@ include file="../header.jsp"%>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
${v3x:skin()}
<script>
<!-- �鿴��Ա���Ĳ������� -->
	function viewArticle(URL){
		parent.location.href = URL;
	}
</script>
<script type="text/javascript">
<!-- 	
	
	function doOneClick(theId,deptId){
		parent.bottom.location.href="${detailURL}?method=getEmployeeModifyAdmin&id="+theId+"&deptId="+deptId+"&dbClick=false";
	}
	function doTwoClick(theId,deptId){
		parent.bottom.location.href="${detailURL}?method=getEmployeeModifyAdmin&id="+theId+"&deptId="+deptId+"&dbClick=true";
	}
//-->	
</script>

</head>
<body scroll="no" class="page_color">
	<form id="memberform" method="post">
		<input name="deptId" type="hidden" value="${deptId}" />
		<v3x:table data="${members}" var="vo" isChangeTRColor="true" showHeader="true" pageSize="20" showPager="true">
			<v3x:column  width="5%" align="center" label="<input type='checkbox' name='id' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${vo.id}" deptId="${deptId}" />
			</v3x:column>

			<v3x:column align="left" width="30%" label="org.member_form.name.label"  type="string" 
			onClick="doOneClick('${vo.id}','${deptId}')" onDblClick="doTwoClick('${vo.id }','${deptId}')">
				&nbsp;${v3x:toHTML(vo.userName)}
			</v3x:column>
			
			<v3x:column align="right" width="20%" label="blog.space.totalsize"  type="Number" 
			onClick="doOneClick('${vo.id}','${deptId}')" onDblClick="doTwoClick('${vo.id }','${deptId}')">
				${vo.blogSpace}&nbsp;
			</v3x:column>

			<v3x:column align="right" width="20%" label="blog.space.usedsize"  type="Number"  
			onClick="doOneClick('${vo.id}','${deptId}')" onDblClick="doTwoClick('${vo.id }','${deptId}')">
				${vo.blogUsedSpace}&nbsp;
			</v3x:column>

			<v3x:column align="left" width="13%" label="blog.space.status"  type="string"  
			onClick="doOneClick('${vo.id}','${deptId}')" onDblClick="doTwoClick('${vo.id }','${deptId}')">
				&nbsp;<fmt:message key="${vo.blogStatus}" bundle="${v3xDocI18N}" />
			</v3x:column>

			<v3x:column align="left" width="10%" label="org.member_form.flagstart"  type="string"   
			onClick="doOneClick('${vo.id}','${deptId}')" onDblClick="doTwoClick('${vo.id }','${deptId}')">&nbsp;
				<c:if test="${vo.flagStart == 1}"><fmt:message key="org.member_form.start.rep" /></c:if>
				<c:if test="${vo.flagStart == 0}"><fmt:message key="org.member_form.end.rep" /></c:if>
			</v3x:column>

		</v3x:table>
	</form>
<script type="text/javascript">
 showDetailPageBaseInfo("bottom", "<fmt:message key='menu.blog.manage' bundle="${v3xMainI18N}"/>", "/common/images/detailBannner/9200.gif", pageQueryMap.get('count'),_("BlogLang.detail_info_9200"));	
</script>
</body>
</html>
