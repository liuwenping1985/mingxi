<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>    
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>

<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<c:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="${path}/skin/${CurrentUser.skin}/skin.css">
</c:if>
<c:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="${path}/skin/default/skin.css">
</c:if>
<script type="text/javascript">
		function deleteItem() {
		
		  var checkedIds = document.getElementsByName('id');

		  var len = checkedIds.length;
		  
		  var str = "";
		  
		  for(var i = 0; i < len; i++) {
		  		var checkedId = checkedIds[i];
				
				if(checkedId && checkedId.checked && checkedId.parentNode.parentNode.tagName == "TD"){			
					str += checkedId.value;
					str +=","
				}
			}
			
			if(str==null || str==""){
		  	alert(_("edocLang.templete_alertSelectTemplete"));
		  	return false;
		  }
			str = str.substring(0,str.length-1);
			
		if(window.confirm(_("edocLang.templete_confirmDeleteTemplete"))){
			
				document.location.href='${edocDocTemplate}?method=delete&id='+str;
			
			}
		}
		
		
	function download() {
		if('${fileId}' == '' || '${fileId}' == null){
			alert(v3x.getMessage("edocLang.edoc_file_noExist"));
			return;
		}
		var name = encodeURI('${fileName}');
		//lijl注销,OA-42477.开发---server安全
		//var downloadUrl ="/seeyon/fileUpload.do?method=download&fileId=${fileId}&isSystemRedTemplete=true&createDate=${createDate}&filename="+ name;
		var downloadUrl ="/seeyon/fileDownload.do?method=download&fileId=${fileId}&v=${ctp:digest_1(fileId)}&isSystemRedTemplete=true&createDate=${createDate}&filename="+ name;
		//var downloadUrl ="/seeyon/fileUpload.do?method=download&fileId=-6001972826857714844&createDate=2007-11-7&filename="+encodeURI('公文示例套红模板.rar');
		//self.document.location=downloadUrl;
			mainForm.action = downloadUrl;
			mainForm.target = "temp_frame";
			//mainForm.method = "post";
			mainForm.submit();
			mainForm.action = "";
	
		//self.document.location.reload(true);
}

	function newTemplate(type){
		parent.detailFrame.location.href='${edocDocTemplate}?method=newTemplate&flag2=new&type='+type;
	}

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");

		var templateTypeMenu = new WebFXMenu;
		templateTypeMenu.add(new WebFXMenuItem("textType", "<fmt:message key='edoc.doctemplate.text.title' />", "newTemplate('0');"));
		templateTypeMenu.add(new WebFXMenuItem("wendanType", "<fmt:message key='edoc.doctemplate.wendan.title' />", "newTemplate('1');"));

	myBar.add(
		new WebFXMenuButton(
			"templateTypeMenu", 
			"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />",  
			null,
			[1,1], 
			"", 
			templateTypeMenu
			)
	);
	myBar.add(new WebFXMenuButton("edit", 
		"<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", 
		"editOneLine();", [1,2], 
		"", null));
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />",  
			"deleteItem();", 
			[1,3],
			"", 
			null
			)
	);

	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='edoc.doctemplate.download' />", 
			"download();", 
			[6,4], 
			"", 
			null
			)
	);

	baseUrl='${edocDocTemplate}?method=';
	
	function editPlan(id){

		parent.detailFrame.window.location='${edocDocTemplate}?method=edit&id='+id;
}
	function singleClick(id){

		parent.detailFrame.window.location='${edocDocTemplate}?method=edit&flag=readonly&id='+id;
}
function editOneLine(){
		var chkid = document.getElementsByName('id');
	var count = 0;
	var id = "";
	for(var i = 0; i < chkid.length; i++){
		if(chkid[i].checked){
			count++;
			id = chkid[i].value;
		}
	}
	
	if(count == 0){
		alert(v3x.getMessage('edocLang.templete_alertSelectTemplete'));
		return false;
	}else if(count > 1){
		alert(v3x.getMessage('edocLang.docTemplate_alter_select_one'));
		return false;
	}
	
	parent.detailFrame.window.location='${edocDocTemplate}?method=edit&id='+id;	

}

	function showByStatus(){
		window.document.searchForm.submit();
	}
	
</script>
</head>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<body >

<v3x:selectPeople id="auth" panels="Account" selectType="Account" jsFunction="submitAuth(elements)" originalElements="" minSize="0"/>

<input type="hidden" name=auth id="auth" value="">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
    <div class="top_div_row2 webfx-menu-bar">
		<table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
			<form name="mainForm" id="mainForm" method="post">
			<script type="text/javascript">
				document.write(myBar);	
				document.close();
			</script>
			</form>
				</td>
				
				<td><form action="" name="searchForm" id="searchForm" method="get" onkeypress="doSearchEnter()" onsubmit="return false">
				<input type="hidden" value="<c:out value='${param.method}' />" name="method">
				<div class="div-float-right">
						<div class="div-float">
							<select name="condition" id="condition" onChange="showNextSpecialCondition(this)" class="condition" style="width:90px">
						    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							    
							    <option value="name"><fmt:message key="edoc.form.name" /></option>
							    <option value="status"><fmt:message key="edoc.form.status" /></option>
							    <option value="sort"><fmt:message key="edoc.doctemplate.type" /></option>
						  	</select>
					  	</div>
					  	
					  	<div id="nameDiv" class="div-float hidden"><input type="text" name="textfield" style="height:14px;" class="textfield"></div>
						<div id="statusDiv" class="div-float hidden">
						<select name="textfield" class="condition" style="width:90px">
							<option value="1"><fmt:message key="edoc.element.enabled" />	</option>
				  			<option value="0"><fmt:message key="edoc.element.disabled" />	</option>	
				  		</select>			
						
						</div>
						<div id="sortDiv" class="div-float hidden">
					  	<select name="textfield" class="condition" style="width:90px">
							<option value="0"><fmt:message key="edoc.doctemplate.text" />	</option>
				  			<option value="1"><fmt:message key="edoc.doctemplate.wendan" />	</option>
				  		</select>		
					  	
					  	</div>
						<div onclick="javascript:doSearch()" class=" div-float condition-search-button"></div>
				</div>
				</form>
				</td>
				
			</tr>
		</table>
    </div>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
<form name="listForm">
<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true">
	<v3x:column width="5%" align="center"
		label="<input type='checkbox' onclick='selectAllValues(this, \"id\")'/>" className="cursor-hand sort">
		<input type='checkbox' id='id' name='id' value="<c:out value="${bean.id}"/>"  <c:if test="${bean.id==param.id}" >checked</c:if> />
	</v3x:column>
	<v3x:column width="10%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}');"
		label="edoc.doctemplate.type" className="cursor-hand sort">
		<c:choose>
			<c:when test="${bean.type==0}">
				<fmt:message key="edoc.doctemplate.text" />
			</c:when>
			<c:when test="${bean.type==1}">
				<fmt:message key="edoc.doctemplate.wendan" />
			</c:when>
			<c:otherwise>
				<fmt:message key="edoc.doctemplate.text" />
			</c:otherwise>
		</c:choose>
	</v3x:column>
	<v3x:column width="34%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}');"
		label="edoc.doctemplate.name" className="cursor-hand sort  mxtgrid_black" maxLength="30" symbol="..." alt="${bean.name}">
		${v3x:toHTML(bean.name)}
		<c:if test="${bean.textType == 'officeword' }">
		<span class="ico16 doc_16"></span>
		</c:if>
		<c:if test="${bean.textType == 'wpsword' }">
		<span class="ico16 wps_16"></span> 
		</c:if>
	</v3x:column>
	<v3x:column width="40%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}');"
		label="edoc.doctemplate.grant" className="cursor-hand sort" value="${v3x:showOrgEntities(bean.aclEntity, 'id', 'entityType', pageContext)}" maxLength="50" symbol="..." alt="${v3x:showOrgEntities(bean.aclEntity, 'id', 'entityType', pageContext)}">
	</v3x:column>
	<v3x:column width="10%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}');"
		label="edoc.form.status" className="cursor-hand sort">
		<c:choose>
 			<c:when test="${bean.status == 1}">
 				<fmt:message key="edoc.element.enabled" />	
 			</c:when>
 			<c:otherwise>
 				 <fmt:message key="edoc.element.disabled" />
 			</c:otherwise>
 		</c:choose>
	</v3x:column>
</v3x:table>
</form>
</div>
  </div>
</div>
<iframe id="temp_frame" name="temp_frame">&nbsp;</iframe>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.edoc.edocdoctemplate' bundle="${v3xMainI18N}"/>", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_4001"));	
initIpadScroll("scrollListDiv",550,870);
showCondition("${v3x:escapeJavascript(param.condition)}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>
</body>
</html>
