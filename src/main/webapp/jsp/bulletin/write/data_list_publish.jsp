<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>	
<html>
<head>
<%@ include file="../include/taglib.jsp"%>

<%@ include file="../include/header.jsp"%>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
<script type="text/javascript">
<!--
	//板块是否需要审核
	var typeAuditFlag = "${bulType.auditFlag}";
	if('1'=='${bulType.spaceType}'){
	  var theHtml=toHtml("${v3x:toHTML(bulType.typeName)}",'<fmt:message key="bul.issue.log"/>');
	  showCtpLocation("",{html:theHtml});
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
			"editData();", 
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
			"deleteRecord('${bulDataURL}?method=writeDelete&spaceType=${v3x:escapeJavascript(param.spaceType)}&bulTypeId=${param.bulTypeId}&spaceId=${v3x:escapeJavascript(param.spaceId)}');", 
			[1,3], 
			"", 
			null
			)
	);
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.oper.publish.label' bundle='${v3xCommonI18N}'/>", 
			"publishData();", 
			[5,7], 
			"", 
			null
			)
	);

	function newBtnEvent(){
        openCtpWindow({'url':'${bulDataURL}?method=create&spaceType=${v3x:escapeJavascript(param.spaceType)}&bulTypeId=${param.bulTypeId}&spaceId=${v3x:escapeJavascript(param.spaceId)}'});
    }
	
	baseUrl='${bulDataURL}?method=';
	var managerName = "ajaxBulDataManager";
	function showPageByMethod(id,method){
		var state = document.getElementById(id+"_state");
		if(state.value == '30'){
			parent.detailFrame.location.href=baseUrl+"userView"+'&id='+id+'&from=list&spaceId=${v3x:escapeJavascript(param.spaceId)}';
		}else{
			parent.detailFrame.location.href=baseUrl+method+'&id='+id+'&from=list&spaceId=${v3x:escapeJavascript(param.spaceId)}';
		}
	}
//-->
</script>
</head>
<body class="padding5">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2" >
        <table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td  height="22" valign="top" class="webfx-menu-bar">
                    <div style="width:500px;float:left;">
                        <script type="text/javascript">
                            //TODO zhangxw 2012-10-26 v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
                            document.write(myBar);	
                        </script>
                    </div>
        
                </td>
            </tr>
           </table>
   </div>
   <div class="center_div_row2" id="scrollListDiv">
        <c:set scope="request" var="onDblClick" value="editDataLine" />
        <c:set scope="request" var="detailMethod" value="writeDetail" />
        
				
<form>
<v3x:table htmlId="listTable" data="list" var="bean" className="sort ellipsis">
	<v3x:column width="5%" align="center"
		label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
		<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" 
			dataState='${bean.state}' dataTopOrder='${bean.topOrder}'  auditFlag='${bulType.auditFlag}'
		/>
	</v3x:column>
	<c:set var="topStr" value="" />
	
	<v3x:column width="55%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');" onDblClick="editData();"
		label="bul.biaoti.label" className="cursor-hand sort"
		hasAttachments="${bean.attachmentsFlag}"
		bodyType="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}"
		alt="${bean.title}"
		>
	   <c:if test="${bean.topOrder>0}">
              <font color='red'>[<fmt:message key="label.top" />]</font>
          </c:if>
		${v3x:toHTML(bean.title)}
	</v3x:column>
	
	<v3x:column width="10%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');" onDblClick="editData();"
		label="bul.data.createUser" className="cursor-hand sort" value="${bean.publishMemberName}">
	</v3x:column>
	<v3x:column width="20%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');" onDblClick="editData();"
		label="common.issueScope.label" className="cursor-hand sort" value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" />

	<v3x:column width="10%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');" onDblClick="editData();"
		label="bul.data.state" className="cursor-hand sort">
		<fmt:message key="bul.data.state.${bean.state}" />
		<input type="hidden" id="${bean.id}_state" value="${bean.state}" />
		<input type="hidden" id="spaceId" value="${param.spaceId}"/>
	</v3x:column>

</v3x:table>
</form>				
			</div>	
		
		<div height="1">
			<jsp:include page="../include/deal_exception.jsp" />
		</div>
</div></div></div>
<script type="text/javascript">
<!--
showDetailPageBaseInfo("detailFrame", "<fmt:message key='oper.publish' /><fmt:message key='bul.data_shortname' />", "/common/images/detailBannner/605.gif", pageQueryMap.get('count'), _("bulletin.detail_info_608"));
//-->
</script>
</body>
</html>