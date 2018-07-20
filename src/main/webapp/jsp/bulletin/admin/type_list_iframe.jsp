<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<fmt:setBundle basename="com.seeyon.v3x.inquiry.resources.i18n.InquiryResources" var="surveyI18N"/>
<script type="text/javascript">
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", 
			"parent.detailFrame.location.href='${bulTypeURL}?method=create&spaceType=${param.spaceType}&spaceId=${param.spaceId}';", 
			[1,1], 
			"", 
			null
			)
	);
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn",
			"<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", 
			"editType();", 
			[1,2], 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />",
			"deleteBulTypeRecord('${bulTypeURL}?method=delete&spaceType=${param.spaceType}&spaceId=${param.spaceId}');", 
			[1,3], 
			"", 
			null
			)
	);
	
	myBar.add(
		new WebFXMenuButton(
		"orderBtn",
		"<fmt:message key='common.toolbar.order.label' bundle='${v3xCommonI18N}' />",
		"bulTypeOrder();",
		[8,9],
		"",
		null
		)
	);

	baseUrl='${bulTypeURL}?method=';
	
	function deleteBulTypeRecord(baseUrl){
		var ids=document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=id+idCheckBox.value+',';
			}
		}
		if(id==''){
			alert(v3x.getMessage("bulletin.select_delete_record"));
			return;
		}
		if(confirm(v3x.getMessage("bulletin.bulletin_type_AlreadyUsed"))){
			parent.window.location.href=baseUrl+'&id='+id;
		}
	}
	
	//公告排序方法
	function bulTypeOrder(){
		getA8Top().bulTypeOrderWin = getA8Top().$.dialog({
	        title:' ',
	        transParams:{'parentWin':window},
	        url: "${bulTypeURL}?method=orderBulType&spaceType=${param.spaceType}&spaceId=${param.spaceId}",
	        width: 290,
	        height: 310,
	        isDrag:false
		});
	}
	
	function bulTypeOrderCollBack(returnValue) {
		getA8Top().bulTypeOrderWin.close();
		if(returnValue != null && returnValue != undefined){
			var theForm = document.forms[1];
			for(var i=0; i<returnValue.length; i++){
			   var element = document.createElement("input");
			   element.setAttribute('type','hidden');
			   element.setAttribute('name','projects');
			   element.setAttribute('value',returnValue[i]);
			   theForm.appendChild(element);
			}
			theForm.action = "${bulTypeURL}?method=saveOrder&spaceId=${param.spaceId}";
			theForm.target = "_self";
			theForm.method = "post";
		    theForm.submit();
		}
	}
</script>
</head>
<body>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr class="hidden">
		<td valign="bottom" height="26" class="tab-tag  ">
			<div class="div-float">
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel"><a href="#" class="non-a"><fmt:message key="bul.type" /></a></div>
				<div class="tab-tag-right-sel"></div>
						
	  			<div class="tab-separator"></div>
				
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a target="_parent" href="${bulTemplateURL}?method=listMain" class="non-a"><fmt:message key="bul.template" /></a></div>
				<div class="tab-tag-right"></div>
		
			</div>
		</td>
	</tr>

	<tr>
		<td height="25" class="webfx-menu-bar-gray   ">
			<div style="width:450px;float:left;">
			<script type="text/javascript">
				document.write(myBar);
			</script>
			</div>
			<%-- 搜索功能暂时屏蔽掉 --%>
			<div  class="hidden">
			<form action="" name="searchForm" id="searchForm" method="post"
				onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="<c:out value='${param.method}' />" name="method">
				<div class="div-float-right">
					<div class="div-float">
						<select name="condition"  id="condition" onChange="showNextCondition(this)" class="condition">
							<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							<option value="typeName"><fmt:message key="bul.type.typeName" /></option>
							<option value="auditFlag"><fmt:message key="bul.type.auditFlag" /></option>
							<option value="description"><fmt:message key='common.description.label' bundle="${v3xCommonI18N}" /></option>
						</select>
					</div>
			
					<div id="" class="div-float hidden">
						<input type="text" name="" class="textfield">
					</div>
					<div id="typeNameDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield">
					</div>
					<div id="auditFlagDiv" class="div-float hidden">
						<select name="textfield" class="textfield">
							<option value="1"><fmt:message key="label.audit" /></option>
							<option value="0"><fmt:message key="label.noaudit" /></option>
						</select>
					</div>	
					<div id="descriptionDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield">
					</div>
					
					<div onclick="javascript:doSearch()" class="condition-search-button"></div>
				</div>
			</form>
			</div>
		</td>
	</tr>

	<tr>
		<td height="100%" valign="top" colspan="1">
			<div class="scrollList">
			<form>
			<v3x:table htmlId="listTable" data="list" var="bean" leastSize="0" subHeight="30">
			<c:set var="admin" value="${v3x:showOrgEntitiesOfIds(bean.managerUserIds, 'Member', pageContext)}" />
			<c:set var="auditor" value="${v3x:getMember(bean.auditUser)}" />
				<v3x:column width="5%" align="center"
					label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" />
				</v3x:column>	
				
				<v3x:column width="25%" type="String" onClick="editTypeLine('${bean.id}');" onDblClick="editDbTypeLine('${bean.id}')"
					label="bul.type.typeName" className="cursor-hand sort" property="typeName" maxLength="30" alt="${bean.typeName}" />
					
				
				<v3x:column width="20%" type="String" onClick="editTypeLine('${bean.id}');" onDblClick="editDbTypeLine('${bean.id}')"
					label="bul.type.managerUsers" className="cursor-hand sort" value="${admin}"
					alt="${admin}" />
				
				<v3x:column width="10%" type="String" onDblClick="editDBTypeLine('${bean.id}');"  onClick="editTypeLine('${bean.id}');"  
					label="bul.type.auditFlag" className="cursor-hand sort" maxLength="7" symbol="...">
					<c:if test="${bean.auditFlag==false }">
						<fmt:message key="common.false" bundle="${v3xCommonI18N}"/>
					</c:if>
					<c:if test="${bean.auditFlag==true }">
						<fmt:message key="common.true" bundle="${v3xCommonI18N}"/>
					</c:if>
				</v3x:column>
				
				<v3x:column width="10%" type="String" onDblClick="editDBTypeLine('${bean.id}');"  onClick="editTypeLine('${bean.id}');"  
					label="bul.type.auditUser" className="cursor-hand sort" maxLength="12" symbol="..." >
					<c:if test="${bean.auditFlag==true && bean.auditUser!=0 && bean.auditUser!=1 && bean.auditUser!=-1}">
						<c:choose>
							<c:when test="${!auditor.enabled || auditor.isDeleted}">
								<font color='gray'>${v3x:showMemberName(bean.auditUser)}</font>
							</c:when>
							<c:otherwise>
								${v3x:showMemberName(bean.auditUser)}
							</c:otherwise>
						</c:choose>
					</c:if>
				</v3x:column>
				
				<v3x:column width="30%" type="String" onClick="editTypeLine('${bean.id}');" onDblClick="editDbTypeLine('${bean.id}')"
					label="bul.template.description" className="cursor-hand sort"
					value="${bean.description}" alt="${bean.description}" maxLength="28" symbol="..."
					>		
				</v3x:column>
			</v3x:table>
			</form>
			</div>
		</td>
	</tr>
</table>
<input type="hidden" id="_spaceId" value="${param.spaceId}" >
<input type="hidden" id="_spaceType" value="${param.spaceType}" >
<jsp:include page="../include/deal_exception.jsp" />
<script type="text/javascript">
if("${isGroup}"=="true") {
	showCtpLocation('F05_bulTypeGroup');
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.group.bulletin.set${v3x:suffix()}' bundle="${v3xMainI18N}"/>", "/common/images/detailBannner/2006_1.gif", pageQueryMap.get('count'),_("bulletin.detail_info_2006_1"));
} else {
	showCtpLocation('F05_bulTypeAccount');
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.account.bulletin.set' bundle="${v3xMainI18N}"/>", "/common/images/detailBannner/32.gif", pageQueryMap.get('count'), _("bulletin.detail_info_605"));	
}

if('18'=='${spaceType}'||'17'=='${spaceType}'){
  var theHtml=toHtml("${v3x:toHTML(spaceName)}",'<fmt:message key="bul.type_shortname" /><fmt:message key="oper.manage" />');
  showCtpLocation("",{html:theHtml});
}

showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>
</body>
</html>