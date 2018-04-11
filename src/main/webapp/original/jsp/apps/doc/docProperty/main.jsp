<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../docHeader.jsp" %>
<title></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript">
<!--
	showCtpLocation('F04_docLibIndex');
	function getLimitLength(str, len){
		try{
			if(str.length > len){
				var newStr = str.substring(0, len);
				//newStr += '...';
				return newStr;
			}else{
				return str;
			}
		}catch(e){
			return str;
		}
	}
	
	function showNextSpecialCondition(conditionObject) {
	    var options = conditionObject.options;
	
	    for (var i = 0; i < options.length; i++) {
	        var d = document.getElementById(options[i].value + "Div");
	        if (d) {
	            d.style.display = "none";
	        }
	    }
		if(document.getElementById(conditionObject.value + "Div") == null) return;
	    document.getElementById(conditionObject.value + "Div").style.display = "block";
	}

	function queryDocPropertyByCondition() {
		var searchForm = document.getElementById("searchForm");
		searchForm.action = "${managerURL}?method=queryDocPropertyByCondition";
		searchForm.submit();
		//window.location.href = "${managerURL}?method=docPropertyTopFrame&category="+encodeURI(getLimitLength(category, 30));
	}
	
	function init() {
		
		var typeDiv = document.getElementById("typeDiv");
		var categoryDiv = document.getElementById("categoryDiv");
		var dataTypeDiv = document.getElementById("dataTypeDiv");
		var nameDiv = document.getElementById("nameDiv");
		if ("${condition }" == "type") {
			nameDiv.style.display = "none";
			typeDiv.style.display = "block";
			categoryDiv.style.display = "none";
			dataTypeDiv.style.display = "none";
		} else if ("${condition}" == "name") {
			nameDiv.style.display = "block";
			typeDiv.style.display = "none";
			categoryDiv.style.display = "none";
			dataTypeDiv.style.display = "none";
		} else if ("${condition }" == "category") {
			nameDiv.style.display = "none";
			typeDiv.style.display = "none";
			categoryDiv.style.display = "block";
			dataTypeDiv.style.display = "none";
		} else if ("${condition}" == "dataType") {
			nameDiv.style.display = "none";
			typeDiv.style.display = "none";
			categoryDiv.style.display = "none";
			dataTypeDiv.style.display = "block";
		} else if ("${condition}" == "choice") {
			nameDiv.style.display = "none";
			typeDiv.style.display = "none";
			categoryDiv.style.display = "none";
			dataTypeDiv.style.display = "none";
		}
	}
	
	function pressKey(){
		if(event.keyCode == 13){
			queryDocPropertyByCondition();
		}
	}
	
-->
</script>
<style type="text/css">
.webfx-menu-bar{ 
	background: none;
}
.tab-tag-middel,.tab-disabled-middle{
    border-bottom:0px #b6b6b6 solid;
}
</style>
</head>
<body scroll="no" onload="init();" class='with-header  border-button'>

<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
    
		<c:set value="" var="flagGroup" />
		<c:if test="${v3x:currentUser().groupAdmin}">
		<c:set value="group" var="flagGroup" />
		</c:if>
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="main-bg"> 
			<tr>
				<td valign="bottom"  class="tab-tag" colspan="2" height="28" style="height:28px; background:#fff;">
					<div class="div-float">
					<div class="tab-separator"></div>
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="${managerURL}?method=docLibIndex&flag=${flagGroup}" target="_parent" class=""><fmt:message key="doc.menu.admin.libs" /></a></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
					
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="${managerURL}?method=docTypeIndex&flag=${flagGroup}" target="_parent" class=""><fmt:message key="doc.menu.admin.types" /></a></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
					
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel"><a href="${managerURL}?method=docPropertyIndex&flag=${flagGroup}" target="_parent" class=""><fmt:message key="doc.menu.admin.properties" /></a></div>
					<div class="tab-tag-right-sel"></div>
					<div class="tab-separator"></div>
					</div>
				</td>
		
			</tr>
		
			<tr>
				<td  width="50%"  style="height:38px; background:#fafafa;">
                  <c:if test="${v3x:getSystemProperty('system.ProductId') != '7'}">
					<script type="text/javascript">
						var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","");
						myBar.add(new WebFXMenuButton("add", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />",  "createDocProperty();", [1,1], "", null));
						myBar.add(new WebFXMenuButton("modify", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />" , "editDocProperty('undefined','edit')", [1,2], "", null));
						myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteDocProperty();" , [1,3], "", null));
						document.write(myBar);
					</script>
                  </c:if>
				</td>	
				<td align="right" style="height:38px; background:#fafafa;">
					<form action="" id="searchForm" method="post">
					<div class="div-float-right" style="vertical-align:middle;">
						<div class="div-float">
							<select name="condition" id="condition" onChange="showNextSpecialCondition(this)" class="">
								<option value="choice" <c:if test="${condition == 'choice'}">selected</c:if>><fmt:message key="member.list.find"/></option>
						    	<!-- 按名称查询有国际化问题，待定   <option value="name" >名称</option>  -->
						    	<option value="name" <c:if test="${condition == 'name'}">selected</c:if>><fmt:message key="doc.select.label.name"/></option>
							    <option value="type" <c:if test="${condition == 'type'}">selected</c:if>><fmt:message key="doc.select.type"/></option>
							    <option value="category" <c:if test="${condition == 'category'}">selected</c:if>><fmt:message key="doc.select.category"/></option>
							    <option value="dataType" <c:if test="${condition == 'dataType'}">selected</c:if>><fmt:message key="doc.select.data.type"/></option>
						  	</select>
					  	</div>
					  	<div id="nameDiv" class="div-float hidden">
							<input type="text" name="name" value="${v3x:toHTML(name)}" class="textfield-search" onkeydown="pressKey();" >
					  	</div>
					  	<div id="typeDiv" class="div-float hidden">
							<select id="type" name="type" style="width: 100px;">
								<option value="system" <c:if test="${type == 'system'}">selected</c:if>><fmt:message key="doc.select.system.properties"/></option>
                                <c:if test="${!onlyA6s}">
								  <option value="self" <c:if test="${type == 'self'}">selected</c:if>><fmt:message key="doc.select.custom.properties"/></option>
                                </c:if>
							</select>
						</div>
						<div id="categoryDiv" class="div-float hidden">
							<select id="category" name="category" style="width: 100px;">
								<c:forEach items="${metaCategory}" var="the_category">
									<option value="${the_category}" <c:if test="${the_category == category }">selected</c:if>>${v3x:getLimitLengthString(v3x:_(pageContext, the_category), 18,'...')} </option>
								</c:forEach>
							</select> 
						</div>
						<div id="dataTypeDiv" class="div-float hidden">
							<select id="dataType" name="dataType" style="width: 100px;">
								<c:forEach items="${metadata_type}" var="the_type">
									<option value='${the_type.value}' <c:if test="${the_type.value == dataType }">selected</c:if>><fmt:message key="${the_type.key}"/> </option>
								</c:forEach>
							</select>
						</div>		
					  	<div id="grayButton" onclick="queryDocPropertyByCondition()" class="div-float condition-search-button"></div>
					</div>
					</form>
				</td>		
			</tr>
		</table>	
	
    
    </div>
    <div class="center_div_row2" id="scrollListDiv">
      
			<form name="mainForm" id="mainForm" method="post">
			<v3x:table data="${metadataList}" var="metadata" isChangeTRColor="true" showHeader="true" pageSize="20" className="sort ellipsis" htmlId="sss" >
				<v3x:column width="5%" align="center"
						label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
						<input type='checkbox' name='id' id="id" value="${metadata.metadataDef.id}" 
							isSystem="${metadata.metadataDef.isSystem}" 
							${v3x:outConditionExpression(metadata.metadataDef.isSystem=='true', 'disabled', '')}
							${v3x:outConditionExpression(metadata.metadataDef.isSystem=='false' && metadata.creater=='false', 'disabled', '')}
							usedFlag = '${metadata.used}'
							/>
					</v3x:column>
					<v3x:column label="common.name.label" width="25%" value="${metadata.name}" alt="${metadata.name}" maxLength="50" symbol="..." onClick="editDocProperty('${metadata.metadataDef.id }','view')" onDblClick="editDocProperty('${metadata.metadataDef.id }','edit','${metadata.metadataDef.isSystem}','${metadata.creater}','${metadata.used}')" type="string"></v3x:column>
				<c:if test = "${ metadata.metadataDef.isSystem == 'true'}">
					<v3x:column label="common.propertytype.label" width="25%"  onClick="editDocProperty('${metadata.metadataDef.id }','view')" onDblClick="editDocProperty('${metadata.metadataDef.id }','edit','${metadata.metadataDef.isSystem}','${metadata.creater}','${metadata.used}')" type="string"><fmt:message key='common.system.property' bundle='${v3xCommonI18N}' /></v3x:column>

				</c:if>
				<c:if test= "${ metadata.metadataDef.isSystem != 'true'}">
					<v3x:column label="common.propertytype.label" width="25%"  onClick="editDocProperty('${metadata.metadataDef.id }','view')" onDblClick="editDocProperty('${metadata.metadataDef.id }','edit','${metadata.metadataDef.isSystem}','${metadata.creater}','${metadata.used}')" type="string"><fmt:message key='common.app.property' bundle='${v3xCommonI18N}' /></v3x:column>
                </c:if>
					
					<v3x:column label="common.category.label" width="15%" alt="${v3x:_(pageContext, metadata.metadataDef.category)}" value="${v3x:getLimitLengthString(v3x:_(pageContext, metadata.metadataDef.category), 18,'...')}" onClick="editDocProperty('${metadata.metadataDef.id }','view')" onDblClick="editDocProperty('${metadata.metadataDef.id }','edit','${metadata.metadataDef.isSystem}','${metadata.creater}','${metadata.used}')" type="string"></v3x:column>
					<v3x:column label="common.datatype.label" width="15%" value="${v3x:_(pageContext, metadata.key)}" onClick="editDocProperty('${metadata.metadataDef.id }','view')" onDblClick="editDocProperty('${metadata.metadataDef.id }','edit','${metadata.metadataDef.isSystem}','${metadata.creater}','${metadata.used}')" type="string"></v3x:column>
					<v3x:column label="common.create.org.label" width="15%" value="${metadata.orgName}" onClick="editDocProperty('${metadata.metadataDef.id }','view')" onDblClick="editDocProperty('${metadata.metadataDef.id }','edit','${metadata.metadataDef.isSystem}','${metadata.creater}','${metadata.used}')" type="string"></v3x:column>
			</v3x:table>
			</form>


    </div>
  </div>
</div>
<div id="docTypeIds"></div>
<iframe name="mainFrame" id="mainFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<script type="text/javascript">
showDetailPageBaseInfo("bottom", "<fmt:message key="doc.menu.admin.properties" />", [3,1], pageQueryMap.get('count'), _("DocLang.detail_info_7003"));	
</script> 
</body>
</html>