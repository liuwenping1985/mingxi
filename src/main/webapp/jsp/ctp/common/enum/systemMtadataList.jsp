<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="header.jsp"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript">
	//是否是单位公文管理员
	var isAccountAdmin = ${v3x:isRole("AccountEdocAdmin", v3x:currentUser())};
	if(!isAccountAdmin){
		//getA8Top().showLocation(5101, "<fmt:message key='menu.system.enumerate' bundle='${v3xMainI18N}'/>");
	}
	
	<%--校验名称是否重复的数组--%>
	var existMetadataNamesArray = [];
	<c:forEach items="${metadataItemsList}" var="m">
		existMetadataNamesArray[existMetadataNamesArray.length] = "${v3x:messageFromResource(metadata.resourceBundle, m.label)}";
	</c:forEach>
	
	<%--查看--%>
	function viewData(metadataId){		
		parent.detailFrame.location.href = metadataURL + "?method=editMetadata&metadataId=" + metadataId+"&disabled=true";
	}
	
	function editData(metadataId){		
		parent.detailFrame.location.href = metadataURL + "?method=editMetadata&metadataId=" + metadataId;
	}
	
	<%--新建--%>
function showItemList(metadataId){
	parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataItemList&id="+metadataId;
}
	
	<%--取得所选ID--%>	
	function getCheckedId(){
		var metadataIds = document.getElementsByName('metadataId');
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
		//var metas = document.getElementsByName("metadataIds");
		//document.deleteForm.action = "${metadataMgrURL}&metadataIds="+ metas;
		document.deleteForm.action = "${metadataMgrURL}";
		document.deleteForm.submit();
		
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
	
	function editMetadata(){
	
		var count = validateCheckbox("metadataId");
		switch(count){
			case 0:
					alert(v3x.getMessage("sysMgrLang.system_choice_one_sign")); 
					return false;
					break;
			case 1:
					var metadataId = getCheckedId();
					parent.detailFrame.location.href = metadataURL + "?method=editMetadata&metadataId=" + metadataId;
					break;
			default:
					alert(v3x.getMessage("sysMgrLang.choose_one_only"));
					return false;
		}
	}
	
	function disabledButton(){
  		parent.listFrame.myBar.disabled("newdata");
  		parent.listFrame.myBar.disabled("deldata");
	}
	
	function querySystmeMetadataByNameLike() {
		var textfield = document.getElementById("textfield").value;
		window.location.href = metadataURL+"?method=querySystmeMetadataByNameLike&textfield="+encodeURI(textfield);
	}

</script>
</head>
<body onload="disabledButton();">
<form name="deleteForm" method="post" action="${metadataMgrURL}" target="deleteHelpIFrame">
<input type="hidden" name="categoryId" value="${metadata.id}">
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22" class="webfx-menu-bar">
			<script>

			var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
		
			myBar.add(new WebFXMenuButton("newdata", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>", "newUserDefinedata();", [1,1],"", null));

	        myBar.add(new WebFXMenuButton("editdata", "<fmt:message key='common.toolbar.update.label'  bundle='${v3xCommonI18N}' />", "editMetadata()", [1,2], "", null));

			myBar.add(new WebFXMenuButton("deldata", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>", "deldata();", [1,3], "", null));

			document.write(myBar);
			
			myBar.disabled("newdata");
			//myBar.disabled("editdata");
			myBar.disabled("deldata");
			//是否是单位公文管理员
			if(${v3x:isRole("AccountEdocAdmin", v3x:currentUser())}){
				myBar.disabled("editdata");
			}
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
	<tr>
		<td colspan="2">
			<div class="scrollList">
			<form>
				<v3x:table data="${metadatasList}" var="item" showHeader="true" showPager="true" subHeight="30">
				<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"metadataId\")'/>">
					<input type='checkbox' name='metadataId' value="<c:out value="${item.id}"/>" userName="<c:out value="${item.name}" />" />
				</v3x:column>
				<c:set var="click" value="viewData('${item.id}')"/>
				<c:choose>
					<c:when test="${v3x:isRole('AccountEdocAdmin', v3x:currentUser())}">
						<c:set var="dbclick" value="viewData('${item.id}')"/>
					</c:when>
					<c:otherwise>
						<c:set var="dbclick" value="editData('${item.id}')"/>
					</c:otherwise>
				</c:choose>
				<v3x:column  width="50%" type="String" label="metadata.enumname.label" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"
					 maxLength="20" symbol="..." alt="${v3x:messageFromResource(EnumI18N, item.label)}" value="${v3x:messageFromResource(EnumI18N, item.label)}">
				</v3x:column>
				<v3x:column  width="15%" type="String" label="metadata.manager.isref" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"
					symbol="..." alt="">
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
				<v3x:column  width="15%" type="String" label="metadata.manager.sort" value="${item.sort}" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"
					symbol="..." alt="${item.sort }">
				</v3x:column>
				<v3x:column  width="15%" type="String" label="metadata.enum.description.label" value="${item.description}" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"
					symbol="..." alt="${item.description }" maxLength="20">
				</v3x:column>
				</v3x:table>
				</form>
			</div>
		</td>
	</tr>
</table>
</form>
<form name="addMetadata" method="post" action="${metadataMgrURL}?method=userDefinededaddMetadata" target="deleteHelpIFrame">
<input type="hidden" name="app" value="">
<input type="hidden" name="metadataName" value="">
<input type="hidden" name="sort" value="">
<input type="hidden" name="description" value="">
</form>
<iframe id="deleteHelpIFrame" name="deleteHelpIFrame" frameborder="0" width="0" height="0"></iframe>
<script>
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.system.enumerate' bundle='${v3xMainI18N}'/>", [3,5], pageQueryMap.get('count'), _("sysMgrLang.detail_info_1706"));
</script>
</body>
</html>