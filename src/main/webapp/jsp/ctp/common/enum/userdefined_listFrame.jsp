<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="header.jsp"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/> 
<script type="text/javascript">

	
	<%--校验名称是否重复的数组--%>
	var existMetadataNamesArray = [];
	<c:forEach items="${metadataItemsList}" var="m">
		existMetadataNamesArray[existMetadataNamesArray.length] = "${v3x:escapeJavascript(v3x:messageFromResource(metadata.resourceBundle, m.label))}";
	</c:forEach>
	
	<%--新建--%>
	
	<c:if test="${v3x:getSysFlagByName('sys_isGovVer')!='true'}">
	function newdataItem(){
	/*	
		var selItemStr="";
		try{
		selItemStr = parent.treeFrame.root.getSelected().businessId;

	 	 }catch(e)
	  	{}
	  if(selItemStr=="" || selItemStr==null)
	  {	    
	    return ;
	  }

	  var metadataId=selItemStr.substr(5);
	  	  */
	  	  var metadataId = document.getElementById("categoryId");
	  	  if(metadataId && metadataId.value != ""){
			parent.detailFrame.location.href = metadataURL+"?method=userDefinedednewMetadataItem&metadataId="+metadataId.value;
		}
	}
	</c:if>
	
	<%--取得所选ID--%>	
	function getCheckedId(){
		var metadataItemIds = document.getElementsByName('metadataItemIds');
		for(var i=0; i<metadataItemIds.length; i++){
			var idCheckBox = metadataItemIds[i];
			if(idCheckBox.checked){
				return idCheckBox.value;
			}
		}
	}
	
		<%--查看--%>
	function viewData(id, categoryId){		
		parent.detailFrame.location.href = metadataURL+"?method=editUserDefinedItem&itemId=" + id + "&metadataId=" + categoryId + "&disabled=true";
	}

<%-- 双击修改 --%>
	function dbClickEditdata(id, categoryId,type,userType,parentId,pType)
	{
	  if( userType == 'SystemAdmin' && type.length == '0')
		parent.detailFrame.location.href = metadataURL+"?method=editUserDefinedItem&itemId=" + id + "&metadataId=" + categoryId + "&disabled=false&selectType="+pType+"&parentId="+parentId;
		else if(userType == 'user' && type.length != '0'){
		 parent.detailFrame.location.href = metadataURL+"?method=editUserDefinedItem&itemId=" + id + "&metadataId=" + categoryId + "&disabled=false&selectType="+pType+"&parentId="+parentId;
		}

	}
	
	<%--修改--%>
	function editdata(){
		var count = validateCheckbox("metadataItemIds");
		switch(count){
			case 0:
					alert(v3x.getMessage("sysMgrLang.system_choice_one_sign")); 
					return false;
					break;
			case 1:
					var metadataItemId = getCheckedId();
					parent.detailFrame.location.href = metadataURL + "?method=editUserDefinedItem&itemId=" + metadataItemId + "&metadataId=${metadata.id}";
					break;
			default:
					alert(v3x.getMessage("sysMgrLang.choose_one_only"));
					return false;
		}
	}

	
	<%--删除--%>
	function deldata(metaId){

		var count = validateCheckbox("metadataItemIds");
		if(count <= 0){
			alert(v3x.getMessage("sysMgrLang.system_partition_delete")); 
			return false;
		}
		else{

	var items = document.getElementsByName("metadataItemIds");
	if(!items){
		return false;
	}
	var len = items.length;
	for(var i=0;i<len;i++){
		if(items[i].checked){
		try{
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkItemIsRef", false);
    	requestCaller.addParameter(1, "String", metaId);
		requestCaller.addParameter(2, "String", items[i].value);
    	var ds = requestCaller.serviceRequest();
		if(ds=="true"){
			alert("所选项被引用,不能删除!");
			return false;
		}
    }catch(e){
    }			
		}
	}

			if(confirm(v3x.getMessage("sysMgrLang.delete_sure"))){ 
				disableButton("newdata");
				disableButton("editdata");
				disableButton("deldata");
				document.forms["deleteForm"].action = "${metadataMgrURL}?method=deleteUserDefinedItem";
				document.forms["deleteForm"].submit();
			}
			else{
				return false;
			}
		}
	}
	
	
	function addMetadataOver(addId)
	{
	  parent.treeFrame.location.href=parent.treeFrame.location.href;
	}

</script>
</head>
<body>

<c:if test="${v3x:getSysFlagByName('sys_isGovVer')=='true' && param.edocTree == 'true'}">
   	<table width="100%" height="24px" cellpadding="0" cellspacing="0" >
		<tr class="${from == 'metadata'?'hidden':'show'}" id="metadataToolbar">
			<td>
				<script type="text/javascript">
				var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");	
				 myBar.add(new WebFXMenuButton("newdata", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>", "newdataItem();", [1,1],"", null));
				 myBar.add(new WebFXMenuButton("editdata", "<fmt:message key='common.toolbar.update.label'  bundle='${v3xCommonI18N}' />", "editdataItem()", [1,2], "", null));
				 myBar.add(new WebFXMenuButton("deldata", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>", "deldatadataItem();", [1,3], "", null));
				 document.write(myBar);
				 document.close() ;
				</script>
			</td>
		</tr>
	</table>
   </c:if>


<form name="deleteForm" method="post" action="" target="deleteHelpIFrame">
<input type="hidden" name="categoryId" value="${metadata.id}">
	<%--branches_a8_v350sp1_r_gov 常屹 修改 GOV-4518  公文管理-基础数据-枚举管理中的单位枚举列表丢失翻页功能（枚举值列表也丢失翻页功能） --%>
	<v3x:table data="${metadataItemsList}" var="item" showHeader="true" showPager="true" subHeight="30">
	<c:choose>
	<c:when test="${org_account_id != null && !v3x:currentUser().systemAdmin}">
	<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"metadataItemIds\")'/>">
		<input type='checkbox' name='metadataItemIds' value="<c:out value="${item.id}"/>" userName="<c:out value="${item.name}" />" />
	</v3x:column>
	</c:when>
	<c:when test="${org_account_id == null && v3x:currentUser().systemAdmin}">
	<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"metadataItemIds\")'/>">
		<input type='checkbox' name='metadataItemIds' value="<c:out value="${item.id}"/>" userName="<c:out value="${item.name}" />" />
	</v3x:column>
	</c:when>
	</c:choose>	
	
	<c:set var="click" value="viewData('${item.id}','${metadata.id}')"/>
	<c:set var="dbclick" value="dbClickEditdata('${item.id}','${metadata.id}','${metadata.org_account_id }','${userType }','${parentId }','${parentType }')"/>
	<v3x:column  width="40%" type="String" label="metadata.manager.displayname" value="${v3x:messageFromResource(metadata.resourceBundle, item.label)}" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"
		  alt="${v3x:messageFromResource(metadata.resourceBundle, item.label)}" widthFixed="true">
	</v3x:column>
	<v3x:column  width="10%" type="String" label="metadata.manager.value" value="${item.value}" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"
		 alt="${item.value}">
	</v3x:column>
	<v3x:column  width="13%" type="String" label="metadata.manager.isref" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"  alt="">
	<c:choose>
	<c:when test="${item.isRef == '0'}">
		<fmt:message key="common.true" bundle="${v3xCommonI18N}"/>
	</c:when>
	<c:when test="${item.isRef == '1'}">
		<fmt:message key="common.no" bundle="${v3xCommonI18N}"/>
	</c:when>
	<c:otherwise>
		<fmt:message key="common.no" bundle="${v3xCommonI18N}"/>
	</c:otherwise>
	</c:choose>
	</v3x:column>
	<v3x:column  width="10%" type="String" label="metadata.manager.sort" value="${item.sort}" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"  alt="${item.sort }">
	</v3x:column>
	<v3x:column  width="10%" type="String" label="metadata.button.inputSwitch" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"  alt="">
		<c:choose>
			<c:when test="${item.state == '1'}">
				<fmt:message key="common.state.normal.label" bundle="${v3xCommonI18N}"/>
			</c:when>
			<c:when test="${item.state == '0'}">
				<fmt:message key="common.state.invalidation.label" bundle="${v3xCommonI18N}"/>
			</c:when>
			<c:otherwise>
				<fmt:message key="common.state.normal.label" bundle="${v3xCommonI18N}"/>
			</c:otherwise>
		</c:choose>
	</v3x:column>
	<v3x:column  width="10%" type="String" label="metadata.button.outputSwitch" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"  alt="">
		<c:choose>
			<c:when test="${item.outputSwitch == '1'}">
				<fmt:message key="common.state.normal.label" bundle="${v3xCommonI18N}"/>
			</c:when>
			<c:when test="${item.outputSwitch == '0'}">
				<fmt:message key="common.state.invalidation.label" bundle="${v3xCommonI18N}"/>
			</c:when>
			<c:otherwise>
				<fmt:message key="common.state.normal.label" bundle="${v3xCommonI18N}"/>
			</c:otherwise>
		</c:choose>
	</v3x:column>
</v3x:table>
</form>
<form name="addMetadata" method="post" action="${metadataMgrURL}?method=userDefinededaddMetadata" target="deleteHelpIFrame">
<input type="hidden" name="app" value="">
<input type="hidden" name="metadataName" value="">
<input type="hidden" name="sort" value="">
<input type="hidden" name="description" value="">
</form>
<iframe id="deleteHelpIFrame" name="deleteHelpIFrame" frameborder="0" width="0" height="0"></iframe>
<script>
var accountid = '${org_account_id}' ;
var isShow = parent.detailFrame.showOrgDetail;
if(typeof(isShow) == "undefined"||isShow||isShow == 'true'){ 
	if(accountid == '') {
		showDetailPageBaseInfo("detailFrame", "<fmt:message key='metadata.manager.metadatamgr' />", [3,5], pageQueryMap.get('count'), _("sysMgrLang.detail_info_1706"));
	}else {
	   	showDetailPageBaseInfo("detailFrame", "<fmt:message key='metadata.manager.metadatamgr' />", [3,5], pageQueryMap.get('count'), _("sysMgrLang.detail_info_1707"));
	}
}else {
  parent.detailFrame.location.href= "${metadataMgrURL}?method=userDefinedednewMetadataItem&parentType=${parentType}&parentId=${parentId}" ;
}


</script>
</body>
</html>