<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>    
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='edoc.form.sysEdocForm'/></title>

<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet"
	href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<script type="text/javascript">

		var isImport=false;

		//导入完成之后执行；
		function importOk()
		{
			isImport=true;
			alert(v3x.getMessage("edocLang.alert_importOk"));
			setRefresh();
			getA8Top().close();
		}
		
		function setRefresh()
		{
		  if(isImport)
		  {
		    parent.window.returnValue=true;
		  }		  
		}

		function downLoadEdocFormA(fileId)
		{			
			var downUrl="/seeyon/fileUpload.do?method=download&comm=byFileId&fileId=";
			var iframeObj=document.createElement("iframe");
			iframeObj.style.width="0px";
			iframeObj.style.heigh="0px";
			document.appendChild(iframeObj);
			iframeObj.src=downUrl+fileId;
		}
		
		function downLoadEdocForm()
		{			
			var downUrl="/seeyon/fileUpload.do?method=download&comm=byFileId&fileId=";
			var checkedIds = document.getElementsByName('id');
			var len = checkedIds.length;
		  	var str = "";
		  	var isSelNum=0;		  	
		  	for(var i = 0; i < len; i++) 
		  	{		  	
		  		var checkedId = checkedIds[i];		  		
				if(checkedId && checkedId.type=="checkbox" && checkedId.checked){
					isSelNum++;					
				}
			}			
			if(isSelNum!=1)
			{
			  alert(_("edocLang.edoc_alertSelOneEdocForm"));
			  return;
			}			
		  	for(var i = 0; i < len; i++) 
		  	{		  	
		  		var checkedId = checkedIds[i];		  				  		
				if(checkedId && checkedId.checked && checkedId.type=="checkbox")
				{					
					var iframeObj=document.createElement("iframe");
					document.appendChild(iframeObj);
					iframeObj.src=downUrl+checkedId.fileId;
				}
			}							
		}
		function importEdocForm()
		{
			var downUrl="${edocForm}?method=importForms&formids=";
			var checkedIds = document.getElementsByName('id');
			var len = checkedIds.length;
		  	var str = "";
		  	var isSelNum=0;		  	
		  	for(var i = 0; i < len; i++) 
		  	{		  	
		  		var checkedId = checkedIds[i];		  		
				if(checkedId && checkedId.type=="checkbox" && checkedId.checked){
					isSelNum++;					
				}
			}			
			if(isSelNum<=0)
			{
			  alert(_("edocLang.edoc_alertSelEdocForm"));
			  return;
			}			
		  	for(var i = 0; i < len; i++) 
		  	{		  	
		  		var checkedId = checkedIds[i];		  				  		
				if(checkedId && checkedId.checked && checkedId.type=="checkbox")
				{					
					if(str!=""){str+=",";}
					str+=checkedId.value;					
				}
			}
			downUrl+=str;
			var iframeObj=document.createElement("iframe");
			iframeObj.style.width="0px";
			iframeObj.style.heigh="0px";
			document.appendChild(iframeObj);
			iframeObj.src=downUrl;						
		}

		function deleteItem() {
		  var checkedIds = document.getElementsByName('id');

		  var len = checkedIds.length;
		  
		  var str = "";
		  
		  for(var i = 0; i < len; i++) {
		  		var checkedId = checkedIds[i];
				
				if(checkedId && checkedId.checked && checkedId.parentNode.parentNode.tagName == "TR"){			
					str += checkedId.value;
					str +=","
				}
			}
			
		 //-- justify is any id has been chose.
		  
		  if(str==null || str==""){
		  	alert("<fmt:message key='edoc.delete.alert.label'/>");
		  	return false;
		  }

		 //-- justification end.	
		 	
			str = str.substring(0,str.length-1);
			
			if(window.confirm("<fmt:message key='edoc.sure.delete.alert'/>")){
			
				document.location.href='${edocForm}?method=delete&id='+str;
			}
		}

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	

	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='edoc.form.import' />", 
			"importEdocForm();", 
			"<c:url value='/common/images/toolbar/import.gif'/>",
			"", 
			null
			)
	);
	/*
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='edoc.form.downloadform'/>", 
			"downLoadEdocForm();", 
			"<c:url value='/common/images/toolbar/delete.gif'/>",
			"", 
			null
			)
	);
	*/
	/*
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.refresh.label' bundle='${v3xCommonI18N}' />",  
			"window.location.reload(true);", 
			"<c:url value='/common/images/toolbar/refresh.gif'/>", 
			"", 
			null
			)
	);
	*/
	
	baseUrl='${edocForm}?method=';
	
	function editPlan(id){

		parent.detailFrame.window.location='${edocForm}?method=edit&id='+id;
}
	function showByStatus(){
		window.document.searchForm.submit();
	}
	
</script>
</head>
<body onunload="setRefresh();">
<table width="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<script type="text/javascript">
				document.write(myBar.toString());	
				document.close();
			</script>
		</td>
	</tr>
</table>
<form>
<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true">
	<v3x:column width="10%" type="String" align="center"
		label="edoc.form.choose" className="cursor-hand sort">
		<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>"  <c:if test="${bean.id==param.id}" >checked</c:if>/>
		<c:if  test="${bean.id==param.id}">
			<script type="text/javascript">
				parent.detailFrame.window.location='${edocForm}?method=edit&id='+'${bean.id}';
		</script>
		</c:if>
	</v3x:column>
	<v3x:column width="20%" type="String" label="edoc.form.sort" className="cursor-hand sort">
		<c:choose>
			<c:when test="${bean.type==0}">
				<fmt:message key="edoc.formstyle.dispatch" />
			</c:when>
			<c:when test="${bean.type==1}">
				<fmt:message key="edoc.formstyle.receipt" />
			</c:when>
			<c:when test="${bean.type==2}">
				<fmt:message key="edoc.formstyle.qianbao" />
			</c:when>
			<c:otherwise>
				<fmt:message key="edoc.formstyle.dispatch" />
			</c:otherwise>
		</c:choose>
	</v3x:column>
	<v3x:column width="20%" type="String" label="edoc.form.name" className="cursor-hand sort">
		${bean.name}
	</v3x:column>
	<v3x:column width="30%" type="String" label="edoc.form.description" className="cursor-hand sort">
		${bean.description}
	</v3x:column>
		<v3x:column width="20%" type="String" label="edoc.form.defaultform" className="cursor-hand sort">
		<c:choose>
			<c:when test="${bean.isDefault==true}">
				<fmt:message key="edoc.form.yes" />
			</c:when>
			<c:when test="${bean.isDefault==false}">
				<fmt:message key="edoc.form.no" />
			</c:when>
			<c:otherwise>
				<fmt:message key="edoc.form.no" />
			</c:otherwise>
		</c:choose>
	</v3x:column>
	<v3x:column width="20%" type="String" label="edoc.form.status" className="cursor-hand sort">
		<c:choose>
 			<c:when test="${bean.status==0}">
 				<fmt:message key="edoc.element.disabled" />	
 			</c:when>
  			<c:when test="${bean.status==1}">
 				<fmt:message key="edoc.element.enabled" />	
 			</c:when>
 			<c:otherwise>
 				 <fmt:message key="edoc.element.disabled" />
 			</c:otherwise>
 		</c:choose>
	</v3x:column>
	<v3x:column width="10%" type="String" label="edoc.form.downloadform" className="cursor-hand sort">
		<div style="cursor:hand" onclick="downLoadEdocFormA('${bean.fileId}');"><fmt:message key='edoc.form.downloadform'/></div>
	</v3x:column>
</v3x:table>
</form>
</body>
</html>