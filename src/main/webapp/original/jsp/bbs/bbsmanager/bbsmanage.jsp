<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript">
	//删除标识板块下含有帖子的不允许删除
	var delBsMap = new Properties();
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
</script>
<style>
.webfx-menu-bar-gray{
	background: none;
}
</style>
</head>
<body>
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22" colspan="2" class="webfx-menu-bar-gray" style="height:38px; background:#fafafa;">
			<script type="text/javascript">
				var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
				
				myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", "createBoard()", [1,1],"", null));
				myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "editBoard()", [1,2],"", null));
				myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteBoard()", [1,3],"", null));
				
				myBar.add(
					new WebFXMenuButton(
					"orderBtn",
					"<fmt:message key='common.toolbar.order.label' bundle='${v3xCommonI18N}' />",
					"bbsBoardOrders();",
					[8,9],
					"",
					null
					)
				);
				document.write(myBar);
		    	document.close();
	    	</script>
    	</td>
	</tr>
	<tr>
		<td colspan="2" style="vertical-align: top;">
			<div class="scrollList">
			<form name="fm" method="post" action="" onsubmit="">
			<c:set value="0" var="delBsLoop" />
			<fmt:message key="bul.template.description" bundle="${bulI18N}" var="description"/>
			<fmt:message key="bul.type.typeName" bundle="${bulI18N}" var="plateName"/>			
				<v3x:table data="${list}" var="con" htmlId="list" isChangeTRColor="true" showPager="true" showHeader="true" subHeight="38">
					
					<c:set var="click" value="modifyBoard('${con.id}')"/>
					<c:set var="onDbclick" value="dbModifyBoard('${con.id}')" />
					<c:set var="admin" value="${v3x:showOrgEntitiesOfIds(v3x:joinDirectWithSpecialSeparator(con.admins, ','), 'Member', pageContext)}" />
					
					<v3x:column width="5%" maxLength="10" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
						<input type='checkbox' name='id' value="${con.id}" />
						<script type="text/javascript">
							delBsMap.put('${con.id}','${delBsList[delBsLoop]}');
						</script>
						<c:set var="delBsLoop" value="${delBsLoop+1}" />
					</v3x:column>
					<v3x:column width="25%" label="${plateName}"
						value="${con.name}" type="String" onClick="${click}" onDblClick="${onDbclick}" symbol="..." className="cursor-hand sort" />
						
					<v3x:column width="25%" type="String" label="bbs.admin.label"
						value="${admin}" onClick="${click}" onDblClick="${onDbclick}" className="cursor-hand sort"
						maxLength="28" symbol="..." alt="${admin}" />
					<v3x:column  width="45%" type="String" label="${description}"
						value="${con.description}" onClick="${click}" onDblClick="${onDbclick}" className="cursor-hand sort"
						maxLength="50" symbol="..." alt="${con.description}" />
				</v3x:table>
			
			</form>
			</div>
		</td>
	</tr>
</table>
<input type="hidden" id="_spaceId" value="${param.spaceId}"/>
<input type="hidden" id="_spaceType" value="${param.spaceType}"/>
<script type="text/javascript">
var bbsBoardOrdersItems = {};
function bbsBoardOrders(){
	var spaceId = document.getElementById("_spaceId").value;
	var spaceType = document.getElementById("_spaceType").value;
	bbsBoardOrdersItems.spaceId = spaceId;
	bbsBoardOrdersItems.spaceType = spaceType;
	getA8Top().bbsBoardOrdersWin = getA8Top().$.dialog({
        title:' ',
        transParams:{'parentWin':window},
        url: detailURL + "?method=orderBbsBoard&spaceType="+spaceType+"&spaceId="+spaceId,
        width: 290,
        height: 310,
        isDrag:false
	});
}

function bbsBoardOrdersCollBack (returnValue) {
	getA8Top().bbsBoardOrdersWin.close();
	if(returnValue != null && returnValue != undefined){
		var theForm = document.forms[0];
		for(var i=0; i<returnValue.length; i++){
		   var element = document.createElement("input");
		   element.setAttribute('type','hidden');
		   element.setAttribute('name','projects');
		   element.setAttribute('value',returnValue[i]);
		   theForm.appendChild(element);
		}
		theForm.action = detailURL + "?method=saveOrder&spaceType="+bbsBoardOrdersItems.spaceType+"&spaceId="+bbsBoardOrdersItems.spaceId;
		theForm.target = "_self";
		theForm.method = "post";
	    theForm.submit();
	}
}
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.account.bbs.set' bundle='${v3xMainI18N}'/>", "/common/images/detailBannner/32.gif", pageQueryMap.get('count'),v3x.getMessage("BBSLang.detail_info_bbs_setup"));	
</script>
</body>
</html>