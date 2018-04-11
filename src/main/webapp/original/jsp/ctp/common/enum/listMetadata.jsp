<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="header.jsp"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>	
<script type="text/javascript">
	getA8Top().showLocation(5101, "<fmt:message key='metadata.manager.account' bundle='${v3xMainI18N}'/>");
	
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
	
//	function disabledButton(){
  //		parent.listFrame.myBar.disabled("newdata");
  	//	parent.listFrame.myBar.disabled("deldata");
	//}

</script>
</head>
<body onload="disabledButton();">
<form name="deleteForm" method="post" action="${metadataMgrURL}" target="deleteHelpIFrame">
<input type="hidden" name="categoryId" value="${metadata.id}">
	<form>
		<v3x:table data="${metadatasList}" var="item" showHeader="true" showPager="true" >
		<c:if test="${v3x:currentUser().administrator}">
		<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"metadataId\")'/>">
			<input type='checkbox' name='metadataId' value="<c:out value="${item.id}"/>" userName="<c:out value="${item.name}" />" />
		</v3x:column>
		</c:if>
		<v3x:column  width="20%" type="String" label="metadata.enumname.label" value="${v3x:messageFromResource(item.resourceBundle, item.label)}" onClick="viewData('${item.id}');"  className="cursor-hand sort"
			 maxLength="20" symbol="..." alt="${v3x:messageFromResource(item.resourceBundle, item.label)}">
		</v3x:column>
		<v3x:column  width="12%" type="String" label="metadata.manager.isref" onClick="viewData('${item.id}');"  className="cursor-hand sort"
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
		<v3x:column  width="12%" type="String" label="metadata.manager.sort" value="${item.sort}" onClick="viewData('${item.id}');"  className="cursor-hand sort"
			symbol="..." alt="${item.sort }">
		</v3x:column>
		<v3x:column  width="15%" type="String" label="metadata.enum.description.label" value="${item.description}" onClick="viewData('${item.id}');"  className="cursor-hand sort"
			symbol="..." alt="${item.description }" maxLength="20">
		</v3x:column>
		</v3x:table>
	</form>
</form>
<form name="addMetadata" method="post" action="${metadataMgrURL}?method=userDefinededaddMetadata" target="deleteHelpIFrame">
<input type="hidden" name="app" value="">
<input type="hidden" name="metadataName" value="">
<input type="hidden" name="sort" value="">
<input type="hidden" name="description" value="">
</form>
<iframe id="deleteHelpIFrame" name="deleteHelpIFrame" frameborder="0" width="0" height="0"></iframe>
<script>
    var systemFlag = '${systemFlag}' ;
    if(systemFlag == 'ORG') {
    showDetailPageBaseInfo("detailFrame", "<fmt:message key='metadata.manager.account' />", [3,5], pageQueryMap.get('count'), _("sysMgrLang.detail_info_1705_org"));
    }else {
       showDetailPageBaseInfo("detailFrame", "<fmt:message key='metadata.manager.account' />", [3,5], pageQueryMap.get('count'), _("sysMgrLang.detail_info_1705"));
    }
	
</script>
</body>
</html>