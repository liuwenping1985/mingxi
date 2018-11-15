<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="header.jsp"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
<script type="text/javascript">
//branches_a8_v350_r_gov GOV-2962 常屹 修改 
//GOV-2962 【公文管理】-【基础数据】-【枚举管理】，点击单位枚举下的枚举类型或者枚举后，当前位置和左导航就变成'表单管理-枚举管理-单位枚举'了

<c:if test="${v3x:getSysFlagByName('sys_isGovVer')!='true' || ( v3x:getSysFlagByName('sys_isGovVer')=='true' && param.edocTree != 'true')}">
<c:choose>
			<c:when test="${userType == 'accountAdmin' }">
				getA8Top().showLocation(1605, "<fmt:message key='metadata.manager.account' bundle='${v3xMainI18N}'/>");
			</c:when>		
			<c:otherwise>
				getA8Top().showLocation(305, "<fmt:message key='metadata.manager.account' bundle='${v3xMainI18N}'/>");
			</c:otherwise>
</c:choose>
</c:if>

	<%--校验名称是否重复的数组--%>
	var existMetadataNamesArray = [];
	<c:forEach items="${allmetadatasList}" var="m">
		existMetadataNamesArray[existMetadataNamesArray.length] = "${v3x:escapeJavascript(m.label)}";
	</c:forEach>
	
	<%--查看--%>
	
	function viewData(metadataId){		
		parent.detailFrame.location.href = metadataURL + "?method=editUserDefinedMetadata&metadataId=" + metadataId+"&disabled=true";
	}
	
	function editData(metadataId){		
		parent.detailFrame.location.href = metadataURL + "?method=editUserDefinedMetadata&metadataId=" + metadataId;
	}	
	
	<%--新建--%>
function showItemList(metadataId){
	parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataItemList&id="+metadataId;
}
	
	<%--取得所选ID--%>	
	function getCheckedId(){
		var metadataIds = document.getElementsByName('metadataIds');
		for(var i=0; i<metadataIds.length; i++){
			var idCheckBox = metadataIds[i];
			if(idCheckBox.checked){
				return idCheckBox.value;
			}
		}
	}
	
function showItemList(metadataId){
	parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataItemList&id="+metadataId;
}
	
	<%--删除--%>
	function deldata(){

		var count = validateCheckbox("metadataIds");

		if(count <= 0){
			alert(v3x.getMessage("sysMgrLang.system_partition_delete")); 
			return false;
		}
		else{
		if(window.confirm("确认删除枚举吗,该操作不可撤销")){
		var metadataIds = document.getElementsByName('metadataIds');
		for(var i=0; i<metadataIds.length; i++){
			var idCheckBox = metadataIds[i];
			if(idCheckBox.checked){
				try{
    				var requestCaller1 = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkMetaIsRef", false);
    					requestCaller1.addParameter(1, "String", idCheckBox.value);
    					var ds1 = requestCaller1.serviceRequest();
						if(ds1=="true"){
							alert("枚举已被引用,不能删除!");
							return false;
						}				
					
    				var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkMetacontainChild", false);
    					requestCaller.addParameter(1, "String", idCheckBox.value);
    					var ds = requestCaller.serviceRequest();
						if(ds=="true"){
							alert("枚举包含子枚举项,不能删除!");
							return false;
						}
   					}catch(e){}	
			}
		}
			document.deleteForm.action = "${metadataMgrURL}?method=deleteUserDefinedMetadata";
			document.deleteForm.submit();
		}
		}
	}
	
	
	function newUserMetadata()
	{
	  var selItemStr="";
	  try{
	  	  selItemStr=parent.treeFrame.root.getSelected().businessId;
	  }catch(e)
	  {}
	  if(selItemStr=="" || selItemStr==null)
	  {	    
	    return ;
	  }
	  var app=selItemStr.substr(5);
	  var inData= v3x.openWindow({url:metadataURL + "?method=userDefinedededitMetadata&app=" + app,height: 280,width: 450});
	  if(inData==null){return;}
	  document.addMetadata.app.value=app;
	  document.addMetadata.metadataName.value=inData[0];
	  document.addMetadata.sort.value=inData[1];
	  document.addMetadata.description.value=inData[2];
	  document.addMetadata.submit();
	}
	//添加枚举成功后调用函数
	function addMetadataOver(addId)
	{
	  parent.treeFrame.location.href=parent.treeFrame.location.href;
	}
	
	function newUserDefinedata(){
	  parent.detailFrame.location.href = metadataURL+"?method=newUserDefinededMetadata";
	}
	
	function getSelectdCount(){
	  var count = validateCheckbox("metadataIds");
	  return count ;
	}
	
	function editUserDefinedata(){
		var count = validateCheckbox("metadataIds");
		switch(count){
			case 0:
					alert(v3x.getMessage("sysMgrLang.system_choice_one_sign")); 
					return false;
					break;
			case 1:
					var metadataId = getCheckedId();
					parent.detailFrame.location.href = metadataURL + "?method=editUserDefinedMetadata&metadataId=" + metadataId;
					break;
			default:
					alert(v3x.getMessage("sysMgrLang.choose_one_only"));
					return false;
		}
	}

</script>
</head>
<body  >


<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<c:if test="${v3x:getSysFlagByName('sys_isGovVer')=='true' && param.edocTree == 'true'}">
	<tr>
		<td height="22" class="webfx-menu-bar">
			<script type="text/javascript">			  	 
				//var myBar = new WebFXMenuBar("/seeyon","gray");	
				var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
				myBar.add(new WebFXMenuButton("newdata", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>", "createnewMdata('${metadataMgrURL}');", [1,1],"", null));
		    	myBar.add(new WebFXMenuButton("pigeonhole", "<fmt:message key='common.toolbar.update.label'  bundle='${v3xCommonI18N}' />", "javascript:editMetadataFolder('${metadataMgrURL}')", [1,2], "", null));
		    	myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>", "javascript:deleetMetadataFolder()", [1,3], "", null));    	
		    	myBar.add(new WebFXMenuButton("refresh", "<fmt:message key='doc.menu.move.label' bundle='${docResource}'/>", "javascript:moveToFolder()", "<c:url value='/common/images/toolbar/move.gif'/>", "", null));
		
		    	document.write(myBar);
		    	document.close();
			</script>
		</td>
		
		<td id="grayTd" class="webfx-menu-bar">
			<div class="div-float-right condition-search-div">
	    		<div class="div-float" style="text-align: right;">
	    			<fmt:message key="metadata.enumname.select.label" bundle='${v3xCommonI18N}'/>
	    		</div>
			  	<div id="nameDiv" class="div-float">
					<input type="text" id="textfield" name="textfield" value="${textfield }" class="textfield-search" onkeydown="">
			  	</div>
			  	<div id="grayButton" onclick="querySystmeMetadataByNameLike()" class="div-float condition-search-button"></div>
			  	
			</div>
	    </td>
	</tr>
	</c:if>
	<tr>
		<td colspan="2" valign="top">
			<div class="scrollList">    
				<form >
				<input type="hidden" name="categoryId" value="${metadata.id}">
				<%--branches_a8_v350sp1_r_gov 常屹 修改 GOV-4518  公文管理-基础数据-枚举管理中的单位枚举列表丢失翻页功能（枚举值列表也丢失翻页功能） --%>
				<v3x:table data="${metadatasList}" var="item" showHeader="true" showPager="true" subHeight="30" htmlId="T">
				<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"metadataIds\")'/>">
					<input type='checkbox' name='metadataIds' value="<c:out value="${item.id}"/>" userName="<c:out value="${item.name}" />" />
				</v3x:column>
				<v3x:column  width="30%" type="String" label="metadata.enumname.label" value="${v3x:messageFromResource(metadata.resourceBundle, item.label)}" onClick="viewData('${item.id}');" onDblClick="editData('${item.id}');" className="cursor-hand sort"
					 alt="${v3x:messageFromResource(metadata.resourceBundle, item.label)}">
				</v3x:column>
				<v3x:column  width="15%" type="String" label="metadata.manager.isref" onClick="viewData('${item.id}');" onDblClick="editData('${item.id}');" className="cursor-hand sort" alt="">
				<c:choose>
				<c:when test="${item.isRef == '0'}">
					<fmt:message key="common.true" bundle="${v3xCommonI18N}"/>
				</c:when>
				<c:when test="{item.isRef == '1'}">
					<fmt:message key="common.no" bundle="${v3xCommonI18N}"/>
				</c:when>
				<c:otherwise>
					<fmt:message key="common.no" bundle="${v3xCommonI18N}"/>
				</c:otherwise>
				</c:choose>
				</v3x:column>
				<v3x:column  width="15%" type="String" label="metadata.manager.sort" value="${item.sort}" onClick="viewData('${item.id}');" onDblClick="editData('${item.id}');" className="cursor-hand sort"
					 alt="${item.sort }">
				</v3x:column>
				<v3x:column  width="35%" type="String" label="metadata.enum.description.label" value="${item.description}" onClick="viewData('${item.id}');" onDblClick="editData('${item.id}');" className="cursor-hand sort"
					 alt="${item.description }">
				</v3x:column>
				</v3x:table>
				</form>
			</div>
		</td>
	</tr>
</table>			
	    	

<form name="addMetadata" method="post" action="${metadataMgrURL}?method=userDefinededaddMetadata" target="deleteHelpIFrame">
<input type="hidden" name="app" value="">
<input type="hidden" name="metadataName" value="">
<input type="hidden" name="sort" value="">
<input type="hidden" name="description" value="">
</form>
<iframe id="deleteHelpIFrame" name="deleteHelpIFrame" frameborder="0" width="0" height="0"></iframe>
<script>
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='metadata.manager.account' />", [3,5], pageQueryMap.get('count'), _("sysMgrLang.detail_info_1707"));
</script>
</body>
</html>