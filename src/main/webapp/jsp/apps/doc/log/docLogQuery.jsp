<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../docHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title></title>
<script type="text/javascript">

	function docSelectAll(allButton, targetName){
		var objects = document.getElementsByName(targetName);
		
		if(objects != null){
			for(var i = 0; i < objects.length; i++){
				objects[i].checked = allButton.checked;
			}
		}
	}
	function cancleAllButton(cancledSelected){
		var allBtn = document.getElementById("allBtn");
		if(cancledSelected.checked == false){
			allBtn.checked = false;
		}
	}
		

</script>
</head>

<body scroll="no">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="22">
					<input type = "hidden" id = "docLibType" name = "docLibType"  value = "${param.docLibType}"/>
				  	<input type="hidden" id="docName" name="docName" value="${param.name}" />
				    <script type="text/javascript">
				    	var docResId = '${docResourceId}';
						var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
						if(v3x.getBrowserFlag("hideMenu") == true){
						myBar.add(new WebFXMenuButton("print", "<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />", "printFileLog();", [1,8]));
						myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "exportExcelNew('file',docResId,'${param.name}','${param.isGroupLib}');", [2,6]));
						myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}'/>",  "top.close();", [7,4]));
						}
						document.write(myBar);				
					</script>
				</td>
			</tr>
		</table>	
    
    </div>
    <div class="center_div_row2" id="scrollListDiv">
       <form name="logView" id="logView"  method="post" action="">
	  	<v3x:table data="${docLogVeiw}" var="log" className="ellipsis sort" showHeader="true" htmlId="docLogQury" width="100%">			
			<input type="hidden" name='id' value="${log.operationLog.id}"/>
			
			<v3x:column label="doc.jsp.log.user.label" width="10%" value="${log.member.name}"  type="String" ></v3x:column>
		   <c:if test="${param.isGroupLib == true}">
    		<v3x:column label="doc.jsp.log.account.label" width="20%" value="${log.account.shortName}"  type="String"></v3x:column>
			<v3x:column label="doc.jsp.log.action.label" width="10%" type="String">
				<fmt:message key="${log.operationLog.actionType}"/>
			</v3x:column>	
			</c:if>	 
		   <c:if test="${param.isGroupLib != true}">
			<v3x:column label="doc.jsp.log.action.label" width="20%" type="String">
				<fmt:message key="${log.operationLog.actionType}"/>
			</v3x:column>	
			</c:if>	 
	  		<v3x:column label="doc.jsp.log.date.label" width="15%" align="left" type="Date"><fmt:formatDate value="${log.operationLog.actionTime}" pattern="${datetimePattern}"/></v3x:column>
	  		
	  		<c:set value="${(param.isGroupLib == true)?'35%':'45%'}" var="width"/>
	  		
	  		<v3x:column label="doc.jsp.log.description.label" width="${width}" type="String" value="${v3x:messageOfParameterXML(pageContext, log.operationLog.contentLabel, log.operationLog.contentParameters)}" alt="${v3x:messageOfParameterXML(pageContext, log.operationLog.contentLabel, log.operationLog.contentParameters)}"></v3x:column>
			<v3x:column label="doc.jsp.log.address.label" width="10%" type="String" value="${log.operationLog.remoteIp}"></v3x:column>
	  	</v3x:table>
       </form>
	  <iframe id="theLogIframe" name="theLogIframe" frameborder="0" marginheight="0" marginwidth="0" ></iframe>
    </div>
  </div>
</div>
</body>
</html>