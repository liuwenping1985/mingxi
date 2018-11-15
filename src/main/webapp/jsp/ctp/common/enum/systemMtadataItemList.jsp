<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="header.jsp"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript">

	//branches_a8_v350_r_gov GOV-2236 常屹 修改 公文管理-基础数据-枚举管理，当前位置显示不对 
	<c:choose>
	<c:when test ="${(v3x:getSysFlagByName('sys_isGovVer')=='true')}">
		//getA8Top().showLocation(208, "<fmt:message key='metadata.manager.metadatamgr' bundle='${v3xSysI18N}'/>");
	</c:when>
	<c:otherwise>
	//getA8Top().showLocation(5101, "<fmt:message key='menu.system.enumerate' bundle='${v3xMainI18N}'/>");
	</c:otherwise>
	</c:choose>
		


	
	
	<%--校验名称是否重复的数组--%>
	var existMetadataNamesArray = [];
	<c:forEach items="${metadataItemsList}" var="m">
		existMetadataNamesArray[existMetadataNamesArray.length] = "${v3x:escapeJavascript(v3x:messageFromResource(metadata.resourceBundle, m.label))}";
	</c:forEach>
	
	<%--新建--%>
	function newdata(){
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
		parent.detailFrame.location.href = metadataURL+"?method=editMetadataItem&categoryId="+metadataId+"&function=add";
	}
	
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
		parent.detailFrame.location.href = metadataURL+"?method=editMetadataItem&id=" + id + "&categoryId=" + categoryId + "&disabled=true";
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
					parent.detailFrame.location.href = metadataURL + "?method=editMetadataItem&id=" + metadataItemId + "&categoryId=${metadata.id}&disabled=false";
					break;
			default:
					alert(v3x.getMessage("sysMgrLang.choose_one_only"));
					return false;
		}
	}
	function dbClickEditdata(metadataItemId)
	{
		parent.detailFrame.location.href = metadataURL + "?method=editMetadataItem&id=" + metadataItemId + "&categoryId=${metadata.id}&disabled=false";
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
		if(items[i].isSystem == '1'){
			alert("不允许对系统元数据项进行删除操作！");
			return false;
		}
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
				//修复bug  GOV-2579 系统管理员登录，系统枚举-党委公文类型-删除、政府公文类型-删除，不能正常删除
				//修改点:增加参数categoryId
				var selItemStr = parent.treeFrame.root.getSelected().businessId;
				var metadataId=selItemStr.substr(5);
				document.forms["deleteForm"].action = "${metadataMgrURL}?method=deleteMetadataItem&categoryId="+metadataId;
				document.forms["deleteForm"].submit();
			}
			else{
				return false;
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
	  var inData= v3x.openWindow({url:metadataURL + "?method=editMetadata&app=" + app,height: 280,width: 450});
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

	function querySystmeMetadataItemByNameLike() {
		var textfield = document.getElementById("textfield").value;
		window.location.href = metadataURL+"?method=querySystmeMetadataItemByNameLike&textfield="+encodeURI(textfield)+"&metadataId=${metadata.id }";
	}
	
</script>
</head>
<body>
<form name="deleteForm" method="post" action="" target="deleteHelpIFrame">
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22" class="webfx-menu-bar">
			<script>

			var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
		
			myBar.add(new WebFXMenuButton("newdata", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>", "newdata('${metadata.id}')", "<c:url value='/common/images/toolbar/new.gif'/>","", null));

	        myBar.add(new WebFXMenuButton("editdata", "<fmt:message key='common.toolbar.update.label'  bundle='${v3xCommonI18N}' />", "editdata()", "<c:url value='/common/images/toolbar/transmit.gif'/>", "", null));

			myBar.add(new WebFXMenuButton("deldata", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>", "deldata('${metadata.id}')", "<c:url value='/common/images/toolbar/delete.gif'/>", "", null));

			document.write(myBar);

			if(${metadata==null} || ${v3x:isRole("AccountEdocAdmin", v3x:currentUser())}){
				//myBar.disabled("newdata");
				myBar.disabled("newdata");
				myBar.disabled("editdata");
				myBar.disabled("deldata");
			}
			</script>
		</td>
		<td class="webfx-menu-bar">
		<div class="div-float-right condition-search-div">
				<div class="div-float" style="text-align: right;">
	    			<fmt:message key="metadata.value.enumname.select.label" bundle='${v3xCommonI18N}'/>
    		</div>
		  	<div id="nameDiv" class="div-float">
		  		<input type="hidden" name="metadataId" value="${metadata.id}" />
				<input type="text" id="textfield" name="textfield" value="${textfield }" class="textfield-search" onkeydown="">
		  	</div>
		  	<div id="grayButton" onclick="querySystmeMetadataItemByNameLike()" class="div-float condition-search-button" style=" margin-top: 4px;"></div>
		</div>
		</td>
	</tr>	
	<tr>
		<td colspan="2">
			<div class="scrollList">
				<v3x:table data="${metadataItemsList}" var="item" showHeader="true" showPager="true" subHeight="30">
				<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"metadataItemIds\")'/>">
					<input type='checkbox' name='metadataItemIds' isSystem="${item.i18n}" value="<c:out value="${item.id}"/>" userName="<c:out value="${item.name}" />" />
				</v3x:column>
				<c:set var="click" value="viewData('${item.id}','${metadata.id}')"/>
				<c:choose>
					<c:when test="${v3x:isRole('AccountEdocAdmin', v3x:currentUser())}">
						<c:set var="dbclick" value="viewData('${item.id}','${metadata.id}')"/>
					</c:when>
					<c:otherwise>
						<c:set var="dbclick" value="dbClickEditdata('${item.id}')"/>
					</c:otherwise>
				</c:choose>
				<v3x:column  width="30%" type="String" label="metadata.manager.displayname" value="${v3x:messageFromResource(EnumI18N, item.label)}" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"
					 maxLength="30" symbol="..." alt="${v3x:messageFromResource(EnumI18N, item.label)}">
				</v3x:column>
				<v3x:column  width="10%" type="String" label="metadata.manager.value" value="${item.value}" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"
					symbol="..." alt="${item.value}" maxLength="30">
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
				<v3x:column  width="15%" type="String" label="metadata.button.inputSwitch" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"
					symbol="..." alt="">
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
				<v3x:column  width="10%" type="String" label="metadata.button.outputSwitch" onClick="${click}" onDblClick="${dbclick}" className="cursor-hand sort"
					symbol="..." alt="">
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
			</div>
		</td>
	</tr>
</table>
</form>
<form name="addMetadata" method="post" action="${metadataMgrURL}?method=addMetadata" target="deleteHelpIFrame">
<input type="hidden" name="app" value="">
<input type="hidden" name="metadataName" value="">
<input type="hidden" name="sort" value="">
<input type="hidden" name="description" value="">
</form>
<iframe id="deleteHelpIFrame" name="deleteHelpIFrame" frameborder="0" width="0" height="0"></iframe>
<script>
var isShow = parent.detailFrame.showOrgDetail;
if(typeof(isShow) == "undefined"||isShow||isShow == 'true'){
  showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.system.enumerate' bundle='${v3xMainI18N}'/>", [3,5], pageQueryMap.get('count'), _("sysMgrLang.detail_info_1706"));
}else {
  parent.detailFrame.location.href= metadataURL+"?method=editMetadataItem&categoryId=${metadata.id}&function=add";
}
	
</script>
</body>
</html>