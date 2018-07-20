<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>autoInfoList.jsp</title>
<%@ include file="head.jsp" %>

</head>
    <script type="text/javascript">
    
       	   function doModify(){
				parent.detailFrame.document.location.href = "${imoURL}?method=toAutoSynchron&editContent="+1;
    	}
    	
 
    </script>
<body scroll="no">
<c:if test="${notconnection==null}">
	<table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td class="webfx-menu-bar-gray">
		<div style="width:100%;">
			<script type="text/javascript">
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
    	myBar.add(new WebFXMenuButton("modify", "<fmt:message key='common.button.modify.label' bundle='${v3xCommonI18N}'/>", "doModify()", "<c:url value='/common/images/toolbar/update.gif'/>", "", null));
    	document.write(myBar);
    	document.close();
			</script>
			</div>
		</td>
	</tr>
		  <tr>
			<td>	 
	 <div class="scrollList">
  <form name="listForm" id="listForm" method="post">    	  
		    <v3x:table htmlId="listTable" data="list" var="bean"  width="100%" showHeader="true" showPager="true" isChangeTRColor="true" 
		    	>
		<v3x:column width="20%" type="String"  
			label="org.synchron.organization.name" className="cursor-hand sort">
			<c:out value="${bean.entityName}" />
		</v3x:column>
		
		<v3x:column width="20%" type="String"  label="org.synchron.organization.type" className="cursor-hand sort">
					<c:choose>
				<c:when test="${bean.type==0 }"><fmt:message key='org.synchron.account'/></c:when>
				<c:when test="${bean.type==1 }"><fmt:message key='org.synchron.dept'/></c:when>
				<c:otherwise></c:otherwise>
			</c:choose>
		</v3x:column>
<v3x:column width="20%" type="String"  label="org.synchron.organization.synstate" className="cursor-hand sort">
				<c:choose>
				<c:when test="${bean.isSynedState==0 }"><fmt:message key='org.synchron.synedhas'/></c:when>
				<c:when test="${bean.isSynedState==1 }"><fmt:message key='org.synchron.synednot'/></c:when>
				<c:otherwise></c:otherwise>
			</c:choose>
		</v3x:column>
		  </v3x:table>		
		  </form>
		  </div>
		</td></tr>
	</table>
	</c:if>
${notconnection}	
</body>
</html>