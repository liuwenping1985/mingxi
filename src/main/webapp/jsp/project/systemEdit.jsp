<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="projectHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	
	var nameList = new Array();

  	<c:forEach var="tname" items="${projectList}">  	
       	 nameList.push('${tname.name}');
   	</c:forEach>
	
	function isSameName(){
	       var theNewName = document.getElementById("name");
	       for(var j = 0;j<nameList.length;j++ ){
	           if(theNewName.value.trim() == nameList[j].trim()){
	              alert(v3x.getMessage("ProjectLang.type_name_repeat"));
	              theNewName.focus();
	              return false;
	           }
	       }
	 } 
	
	
	function reSet(){
		document.location.href = '<c:url value="/common/detail.jsp" />';
	}
	function nameLength(){
		var memo=document.projectTypeForm.memo.value.length;
		var name=document.projectTypeForm.name.value.length;
		  if(name>65){          //该字段后台存储长度是255，此处按照l/3截取
		        alert(v3x.getMessage("ProjectLang.project_sort_notexcess"));
			    return false;
		    }else if(memo>85) {
		    	alert(v3x.getMessage("ProjectLang.project_remark_notexcess"));
		   	    return false;
		    } 
		  return true;  
	}
	
</script>

</head>
<body scroll="no" style="overflow: no">
<form name="projectTypeForm" action="${basicURL}?method=saveProjectType" onsubmit="return (checkForm(this) && nameLength() &&  isSameName())" method="post">
<input type="hidden" name="id" value="${pType.id}">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak();  
			//document.write("<img src=\"/seeyon/common/images/button.preview.up.gif\" height=\"8\" onclick=\"previewFrame('Up')\" class=\"cursor-hand\">");
			//document.write("<img src=\"/seeyon/common/images/button.preview.down.gif\" height=\"8\" onclick=\"previewFrame('Down')\" class=\"cursor-hand\">");
			//document.close();
		</script>
		</td>
	</tr>
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<c:if test="${systemEumitosis==1 }">
						<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key='project.sort.add'/></td>
					</c:if>
					<c:if test="${systemEumitosis==2 }">
						<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key='project.sort.modify'/></td>
					</c:if>
					<c:if test="${systemEumitosis==3 }">
						<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key='project.sort.edit'/></td>
					</c:if>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;<font color="red"><fmt:message key='project.sort.fill'/></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head">
			<div class="categorySet-body">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<c:set var="ro" value="${v3x:outConditionExpression(readOnly, 'readonly', '')}" />
				<c:set var="dis" value="${v3x:outConditionExpression(readOnly, 'disabled', '')}" />
					<tr><td><p>&nbsp;</p></td></tr>
					<tr><td><p>&nbsp;</p></td></tr>
					<tr><td><p>&nbsp;</p></td></tr>
				
  					<tr align="center">
   		 				<td width="50%">
    						<fieldset style="width:50%;border:0px;" align="center">
								<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
							  <!-- 
							  <tr>
								<td class="bg-gray" nowrap="nowrap">
									 <div class="hr-blue-font">
									 <strong>
	    						<c:if test="${systemEumitosis==1 }"><fmt:message key='project.style.add'/></c:if>
	    						<c:if test="${systemEumitosis==2 }"><fmt:message key='project.style.modify'/></c:if>
	    						<c:if test="${systemEumitosis==3 }"><fmt:message key='project.style.edit'/></c:if>									 
									 </strong></div>
								</td>
								<td>&nbsp;</td>
							  </tr>	
							   -->								
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="name"><font color="red">*&nbsp;</font><fmt:message key='project.style.name'/>:</label></td>
										<td class="new-column" width="90%">
											<input ${dis} type="text" class="input-100per" name="name" id="name" value="${pType.name }" validate="notNull" inputName="<fmt:message key='project.style.name'/>" />
										</td>
									</tr>
									<tr>
										<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memo"><fmt:message key='project.style.describe'/>:</label></td>
										<td class="new-column" width="90%">
										<textarea  ${dis} class="input-100per" name="memo" style="resize: none;" id="memo" rows="6"  cols="">${pType.memo}</textarea>
										</td>
									</tr>
								</table>
							</fieldset>
							<p></p>
    					</td>
  					</tr>  					
				</table>
			</div>		
		</td>
	</tr>
	<c:if test="${!readOnly}">
		<tr>
	
			<td height="42" align="center" class="bg-advance-bottom">
				<input type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
				<input type="button" onclick="reSet()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
	
		</tr>
	</c:if>
</table>
</form>
</body>
</html>