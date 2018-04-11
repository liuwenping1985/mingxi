<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../docHeader.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript">
<!--
	showCtpLocation('F04_docLibIndex');
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
	
	function queryDocTypeByCondition() {
		var docTypeForm = document.getElementById("docTypeForm");
		docTypeForm.action="${managerURL}?method=queryDocTypeByCondition";
		docTypeForm.submit();
	}
	
	function init() {
		var nameDiv = document.getElementById("nameDiv");
		var typeDiv = document.getElementById("typeDiv");
		var statusDiv = document.getElementById("statusDiv");
		if ("${condition }" == "name") {
			nameDiv.style.display = "block";
			typeDiv.style.display = "none";
			statusDiv.style.display = "none";
		} else if ("${condition }" == "type") {
			nameDiv.style.display = "none";
			typeDiv.style.display = "block";
			statusDiv.style.display = "none";
		} else if ("${condition }" == "status") {
			nameDiv.style.display = "none";
			typeDiv.style.display = "none";
			statusDiv.style.display = "block";
		} else if ("${condition}" == "choice") {
			nameDiv.style.display = "none";
			typeDiv.style.display = "none";
			statusDiv.style.display = "none";
		}
	}
	
	
	function pressKey(){
		if(event.keyCode == 13){
			queryDocTypeByCondition();
		}
	}
//-->
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
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}" />"></script>
<body scroll="no" onload="init();" class='with-header  border-button'> 
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" class="tab-tag" colspan="2" height="28" style="height:28px; background:#fff;">
		<c:set value="" var="flagGroup" />
		<c:if test="${v3x:currentUser().groupAdmin}">
		<c:set value="group" var="flagGroup" />
		</c:if>
			<div class="div-float">
			<div class="tab-separator"></div>
			<div class="tab-tag-left"></div>
			<div class="tab-tag-middel"><a href="${managerURL}?method=docLibIndex&flag=${flagGroup}" target="_parent" class=""><fmt:message key="doc.menu.admin.libs" /></a></div>
			<div class="tab-tag-right"></div>
			<div class="tab-separator"></div>
			
			<div class="tab-tag-left-sel"></div>
			<div class="tab-tag-middel-sel"><a href="${managerURL}?method=docTypeIndex&flag=${flagGroup}" target="_parent" class=""><fmt:message key="doc.menu.admin.types" /></a></div>
			<div class="tab-tag-right-sel"></div>
			<div class="tab-separator"></div>
			
			<div class="tab-tag-left"></div>
			<div class="tab-tag-middel"><a href="${managerURL}?method=docPropertyIndex&flag=${flagGroup}" target="_parent" class=""><fmt:message key="doc.menu.admin.properties" /></a></div>
			<div class="tab-tag-right"></div>
			<div class="tab-separator"></div><%-- 
			<c:if test="${(isGroupAdmin == true && rssEnabled == true) || showRssTagOnAccountAdmin == true}">
			<div class="tab-tag-left"></div>
			<div class="tab-tag-middel"><a href="<html:link renderURL='/rssManager.do?method=index&flag=${param.flag}' />" target="_parent" class="non-a"><fmt:message key="doc.menu.admin.rss" /></a></div>
			<div class="tab-tag-right"></div>
			<div class="tab-separator"></div>
			</c:if>
			<c:if test="${isGroupAdmin != true}">
			<div class="tab-tag-left"></div>
			<div class="tab-tag-middel"><a href="<html:link renderURL='/blog.do?method=organizationFrame&from=Member&flag=${param.flag}' />" target="_parent" class="non-a"><fmt:message key="doc.menu.admin.blog" /></a></div>
			<div class="tab-tag-right"></div>
			<div class="tab-separator"></div>
			</c:if>	--%>
			</div>
		</td>
	</tr>

	<tr>
		<td id="toolbar-top-border" style="height:38px; background:#fafafa;">
            <c:if test="${v3x:getSystemProperty('system.ProductId') != '7'}">
    			<script type="text/javascript">
    				var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","");
    				myBar.add(new WebFXMenuButton("add", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />" , "createDocType();", [1,1], "<fmt:message key='doc.menu.new.label'/>", null));
    				myBar.add(new WebFXMenuButton("modify", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />" , "editDocType('undefined','edit');", [1,2], "", null));
    				myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteDocType();", [1,3], "", null));
    				document.write(myBar);
    			</script>
            </c:if>
		</td>
		<td class="webfx-menu-bar-gray" style="height:38px; background:#fafafa;">
			<form action="" id="docTypeForm" name="docTypeForm" method="post">
	    	<div class="div-float-right" style="vertical-align:middle;">
	    		<div class="div-float">
					<select name="condition" id="condition" onChange="showNextSpecialCondition(this)" class="">
				    	<option value="choice" ><fmt:message key="member.list.find"/></option>
					    <option value="name" <c:if test="${condition == 'name' }">selected</c:if>><fmt:message key="doc.select.name"/></option>
					    <option value="type" <c:if test="${condition == 'type' }">selected</c:if>><fmt:message key="doc.select.type" /></option>
					    <option value="status" <c:if test="${condition == 'status' }">selected</c:if>><fmt:message key="doc.select.state" /></option>
				  	</select>
			  	</div>
			  	<!-- 由于后台名字是国际化，此处先注销掉，实现起来有些困难 -->
			  	<div id="nameDiv" class="div-float hidden">
					<input type="text" name="textfield" value="${v3x:toHTML(textfield)}" class="textfield-search" onkeydown="pressKey();" >
			  	</div>
			  	<div id="typeDiv" class="div-float hidden">
					<select id="type" name="type" style="width: 100px;">
                        <c:if test="${!onlyA6s}">
						  <option value="self" <c:if test="${type == 'self' }">selected</c:if>><fmt:message key="doc.select.custom.type" /></option>
                        </c:if>
						<option value="system" <c:if test="${type == 'system' }">selected</c:if>><fmt:message key="doc.select.system.type" /></option>
					</select>
				</div>
			  	<div id="statusDiv" class="div-float hidden">
					<select id="status" name="status" style="width: 100px;">
						<option value="used" <c:if test="${status == 'used' }">selected</c:if>><fmt:message key="doc.select.already.in.used" /></option>
						<option value="unused" <c:if test="${status == 'unused' }">selected</c:if>><fmt:message key="doc.select.unused" /></option>
					</select>
				</div>
			  	<div id="grayButton" onclick="queryDocTypeByCondition()" class="div-float condition-search-button"></div>
	    	</div>
	    	</form>
		</td>
	</tr>
</table>	
    </div>
    <div class="center_div_row2" id="scrollListDiv">
			<form action="" name="mainForm" id="mainForm" method="post">
			<v3x:table data="${docTypes}" var="docTypeVo" isChangeTRColor="true" showHeader="true" pageSize="20" htmlId="ddd">
				<v3x:column width="5%" align="center"
					label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' name='id' id="id"
						value="${docTypeVo.docType.id}"
						
						${v3x:outConditionExpression(docTypeVo.createdByCurrentAccount=='false', 'disabled', '')}
						usedFlag = '${docTypeVo.used}'
						/>
				</v3x:column>
				<v3x:column label="common.name.label" width="45%"
					value="${v3x:_(pageContext, docTypeVo.docType.name)}"
					alt="${v3x:_(pageContext, docTypeVo.docType.name)}" maxLength="50" symbol="..."
					onClick="editDocType('${docTypeVo.docType.id}','view')"
					onDblClick="editDocType('${docTypeVo.docType.id}','edit','${docTypeVo.createdByCurrentAccount}','${docTypeVo.docType.isSystem}','${docTypeVo.used}')" type="String"></v3x:column>
				<v3x:column label="common.type.label" width="20%" value="${v3x:_(pageContext, docTypeVo.theDocType)}"
					onClick="editDocType('${docTypeVo.docType.id}','view')"
					onDblClick="editDocType('${docTypeVo.docType.id}','edit','${docTypeVo.createdByCurrentAccount}','${docTypeVo.docType.isSystem}','${docTypeVo.used}')"
					type="String"></v3x:column>
               
				
				<v3x:column label="common.state.label" width="20%" 
					onClick="editDocType('${docTypeVo.docType.id}','view')"
					onDblClick="editDocType('${docTypeVo.docType.id}','edit','${docTypeVo.createdByCurrentAccount}','${docTypeVo.docType.isSystem}','${docTypeVo.used}')"
					type="String">
					<c:if test="${docTypeVo.docType.isSystem=='0'}"><fmt:message key="doc.type.status.${docTypeVo.docType.status}" /></c:if>

				<v3x:column label="common.create.org.label" width="10%" value="${docTypeVo.orgName}" onDblClick="editDocType('${docTypeVo.docType.id}','edit','${docTypeVo.createdByCurrentAccount}','${docTypeVo.docType.isSystem}','${docTypeVo.used}')" type="string"></v3x:column>
					
					</v3x:column>
				
			</v3x:table>
			<div id="docTypeIds"></div>
			</form>
    </div>
  </div>
</div>
<script type="text/javascript">
showDetailPageBaseInfo("bottom", "<fmt:message key="doc.menu.admin.types" />", [3,1], pageQueryMap.get('count'), _("DocLang.detail_info_7001"));	
</script> 
</body>
</html>
