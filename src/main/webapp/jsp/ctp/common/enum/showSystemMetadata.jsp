<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
<c:choose>
			<c:when test="${userType == 'accountAdmin' }">
				getA8Top().showLocation(1605, "<fmt:message key='metadata.manager.public' bundle='${v3xMainI18N}'/>");
			</c:when>	
			<c:otherwise>
				  getA8Top().showLocation(305, "<fmt:message key='metadata.manager.public' bundle='${v3xMainI18N}'/>");
			</c:otherwise>
</c:choose>

	//getA8Top().showLocation(1605, "<fmt:message key='metadata.manager.public' bundle='${v3xMainI18N}'/>");
</script>
<script type="text/javascript">
function getObjectById(divObj){
   var returnObj = document.getElementById(divObj) ;
   return returnObj;
}
</script>

</head>
<body scroll="no" class="padding5">
<form action="" name="delectForm" method="post" target="mainIframe" id="deleteForm">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	      <td valign="bottom" height="26" class="tab-tag">
				<div class="div-float">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='${metadataMgrURL}?method=orgShowMetdata'">
						<fmt:message key='metadata.manager.account' bundle="${v3xMainI18N}"/>
					</div>
					<div class="tab-tag-right"></div>
					
					<div class="tab-separator"></div>	
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel cursor-hand" onclick="location.reload();">
					 	<fmt:message key='metadata.manager.public' bundle="${v3xMainI18N}"/>
					</div>
					<div class="tab-tag-right-sel"></div>
				</div>
		  </td>
	  </tr>	

     <tr>
		 <td height="0px;">
		     <iframe width="100%" height="0" frameborder="0" src="${metadataMgrURL}?method=userDefinedtoobar" name="toolbarFram" id="toolbarFram" scrolling="no"></iframe>
		  </td>
	  </tr>
	  	  
	  <tr>
	    <td valign="top" width="100%" height="100%" align="center" class="page-list-border-LRD" style="padding-top:1px;">
		    <iframe width="100%" height="100%" frameborder="0" src="${metadataMgrURL}?method=userDefinedmainIframe&account=account" name="mainIframe" id="mainIframe" />
		</td>
	</tr>
</table>
</form>
 <iframe name="deleteFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>		
</html>