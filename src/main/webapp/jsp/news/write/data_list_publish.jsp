<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<script type="text/javascript">
	//板块是否需要审核
	var typeAuditFlag = "${newsType.auditFlag}";

	baseUrl='${newsDataURL}?method=';
	
	var managerName = "ajaxNewsDataManager";
	//TODO
	/* try {
	    //TODO yangwulin 2012-10-29 getA8Top().endProc();
	}
	catch(e) {
	}
	if('${v3x:escapeJavascript(param.spaceType)}' == '1') {
		if("${v3x:getSysFlagByName('sys_isGroupVer')}"=="true")
		  //TODO yangwulin 2012-10-29 getA8Top().showLocation(7041, "${v3x:escapeJavascript(newsType.typeName)}");
		else
		  //TODO yangwulin 2012-10-29 getA8Top().showLocation(714, "${v3x:escapeJavascript(newsType.typeName)}");
	} else if('${v3x:escapeJavascript(param.spaceType)}' == '0'){
	  //TODO yangwulin 2012-10-29 getA8Top().showLocation(7042, "${v3x:escapeJavascript(newsType.typeName)}");
 	} */
 	function newBtnEvent(){
 		var flag = validTypeExist('${param.newsTypeId}', 'ajaxNewsDataManager');
 		
 		if(flag == 'false'){
 			alert(v3x.getMessage("bulletin.type_deleted"));
 			getA8Top().document.getElementById('main').src = '${newsDataURL}?method=index&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${param.spaceId}';
 		}else{
 		    openCtpWindow({'url':'${newsDataURL}?method=create&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${param.spaceId}&newsTypeId=${param.newsTypeId}&custom=${custom}'});
 		}
 	}

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	if(v3x.getBrowserFlag("hideMenu") == true){
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" />", 
			"newBtnEvent();", 
			[1,1], 
			"",
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"editBtn", 
			"<fmt:message key='common.toolbar.update.label' bundle="${v3xCommonI18N}" />", 
			"editNewsData();", 
			[1,2], 
			"", 
			null
			)
	);
	}
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
			"deleteRecord('${newsDataURL}?method=writeDelete&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${param.spaceId}&newsTypeId=${param.newsTypeId}&custom=${custom}');", 
			[1,3], 
			"", 
			null
			)
	);
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.oper.publish.label' bundle='${v3xCommonI18N}'/>", 
			"publishNews();", 
			[5,7], 
			"", 
			null
			)
	);
  function showPageByMethod(id,method){
      var state = document.getElementById(id+"_state");
      if(state.value == '30'){
          parent.detailFrame.location.href=baseUrl+"userView"+'&id='+id+'&from=list&spaceId=${param.spaceId}';
      }else{
          parent.detailFrame.location.href=baseUrl+method+'&id='+id+'&from=list&spaceId=${param.spaceId}';
      }
  }
</script>
<style type="">
.my_border_lr{
  border-left: 1px solid #b6b6b6;
  border-right: 1px solid #b6b6b6;
  width:99.6%;
}
</style>
</head>
<body class="listPadding">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="25" width="100%" class="webfx-menu-bar">
			<div style="width:500px;float:left;">
				<script type="text/javascript">
				   //TODO yangwulin 2012-10-26<%-- <v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/> --%>
					document.write(myBar);
				</script>
				<form id="submitForm" name="submitForm" method="post" style="display:none;">
				<span id="upload">
				<div id="attachment5Area"></div>
				<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" />
				</span>
				</form>
			</div>

		</td>
	</tr>
	<tr>
		<td>
		    <div class="scrollList my_border_lr" style="overflow-x:hidden;">
				<c:set scope="request" var="onDblClick" value="editNewsDataLine" />
				<c:set scope="request" var="detailMethod" value="writeDetail" />
				
<form>
<v3x:table htmlId="listTable" data="list" var="bean" subHeight="30">
	<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>" >
		<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" 
							dataState='${bean.state}' auditFlag='${bean.type.auditFlag}' imageId='${bean.imageId }'
		/>
	</v3x:column>
	<c:set var="dbClick" value="editNewsData('${bean.id}');"/>
	
    <v3x:column width="65%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');" onDblClick="${dbClick }"
        label="news.biaoti.label" className="cursor-hand sort"
        hasAttachments="${bean.attachmentsFlag}"
        bodyType="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}"
        alt="${bean.title}"
        >  
         <c:if test="${bean.focusNews==true}">
             <font color='red'>[<fmt:message key="news.focus" />]</font>
         </c:if>
        ${v3x:toHTML(bean.title)}
    </v3x:column>
	<v3x:column width="20%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');" onDblClick="${dbClick }"
		label="news.data.createUser" className="cursor-hand sort"
		>
		${bean.createUserName}
	</v3x:column>
	<v3x:column width="10%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');" onDblClick="${dbClick }"
		label="news.data.state" className="cursor-hand sort">
		<fmt:message key="news.data.state.${bean.state}" />
		<input type="hidden" id="${bean.id}_state" value="${bean.state}" />
		<input type="hidden" id="_custom" value="${custom}" />
		<input type="hidden" id="spaceId" value="${param.spaceId}"/>
	</v3x:column>

</v3x:table>
</form>				
			</div>	
		</td>
	</tr>
	<tr>
		<td height="1">
			<jsp:include page="../include/deal_exception.jsp" />
		</td>
	</tr>
</table>
<iframe id="submitFrame" frameborder="0" height="0" width="0" marginheight="0" marginwidth="0" name="submitFrame"></iframe>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key="news.data_shortname" /><fmt:message key="oper.publish" />", [2,1], pageQueryMap.get('count'), _("NEWSLang.detail_info_2006"));
</script>
</body>
</html>