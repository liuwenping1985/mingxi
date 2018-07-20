<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="../header.jsp"%>

<html>
<head>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<script type="text/javascript">
</script>
<script type="text/javascript">
	var	spaceTypeMap = new Properties();
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	
	function createFamily(){		
		fm.target="detailFrame";
		fm.action="${detailURL}?method=listFavoritesAdd";
		fm.submit();
	}
	
	function modifyFamily(id, flag){
		var viewFlag = true;
		if(flag)
			viewFlag = false;
		fm.target="detailFrame";
		fm.action="${detailURL}?method=listFavoritesModify&id="+id+"&viewFlag="+viewFlag;
		fm.submit();		
	}
	
	function editFamily()
	{		
		var chkid = self.document.getElementsByName("id");
		var count = 0;
		var theId = '';

		for(var i = 0; i < chkid.length; i++){
			if(chkid[i].checked){
				count += 1;
				theId = chkid[i].value;
				if(count > 1) {
					alert(v3x.getMessage("DocLang.doc_alert_admin_select_one_alert"))
					return;
				}				

			}
		}
		if(count == 0) {
			alert(v3x.getMessage("DocLang.doc_alert_admin_select_alert"))
			return;
		}

					
		fm.target="detailFrame";
		fm.action="${detailURL}?method=listFavoritesModify&id="+theId+"&viewFlag=false";
		fm.submit();

	}
	
	
	function deleteFamily(baseUrl){
		var ids=document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){

				if(idCheckBox.getAttribute("total") > 0){
					alert(v3x.getMessage("BlogLang.blog_family_has_data", idCheckBox.getAttribute("beanName")));
					return ;
				}
			
				if(idCheckBox=="default"){
					//alert("default??????????????!");
					continue;
				}
				id=id+idCheckBox.value+',';
			}
		}
		if(id==''){
			alert(alertDelete);
			//alert(v3x.getMessage(alertDelete));
			return;
		}
		if(confirm(deleteConfirm))
			parent.location.href=baseUrl+'&id='+id;
	}
</script>
	
<script type="text/javascript">

	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	<c:if test="${flagStart != '0' }">
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key="blog.family.label.new" />", 
			"parent.detailFrame.location.href='${detailURL}?method=listFavoritesAdd';", 
			"<c:url value='/apps_res/blog/images/newColl.gif'/>", 
			"", 
			null
			)
	);
	
	myBar.add(
		new WebFXMenuButton(
			"editBtn", 
			"<fmt:message key="blog.family.label.edit" />", 
			"editFamily();", 
			"<c:url value='/apps_res/doc/images/edit.gif'/>", 
			"", 
			null
			)
	);
	
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key="blog.family.label.delete" />", 
			"deleteFamily('${detailURL}?method=delFavorites');", 
			"<c:url value='/common/images/toolbar/delete.gif'/>", 
			"", 
			null
			)
	);
	</c:if>
	myBar.add(
		new WebFXMenuButton(
			"refBtn", 
			"<fmt:message key="common.toolbar.refresh.label" bundle="${v3xCommonI18N}" />",
			"parent.location.reload();", 
			"<c:url value='/common/images/toolbar/refresh.gif'/>", 
			"", 
			null
			)
	);
	
	baseUrl='${detailURL}?method=';
	
</script>
<style type="text/css">
.mxtgrid div.bDiv td div {
    overflow: visible;
}
</style>
</head>
<body>
<form name="fm" method="post" action="" onsubmit="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
<tr class="page2-header-line">
	<td width="100%" valign="top" class="page-list-border-LRD">
		<table width="100%" height="100%" cellpadding="0" cellspacing="0" align="left" border="0" class="border_b">
			<tr class="page2-header-line">
				<td width="45" class="page2-header-img"><div class="bulltenIndex"></div></td>
				<td class="page2-header-bg">&nbsp;<fmt:message key="blog.family.favorites.setup"/></td>
				<td class="page2-header-line padding-right" align="right">
					<div>
					<a href="${detailURL}?method=listAllFavoritesArticle" class="hyper_link2" target="_parent">
							[<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]
					</a>&nbsp;&nbsp;
					</div>
				</td>
			  </tr>
		</table>
				
	</td>
</tr>
<tr>
	<td height="25">
		<script type="text/javascript">
			document.write(myBar);	
		</script>
	</td>
	<td class="webfx-menu-bar">
	</td>
</tr>
<tr>
	<td height="100%" colspan="2">
	<div class="scrollList">
	<v3x:table htmlId="listTable" data="list" var="bean" >
		<v3x:column width="5%" align="center"
			label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' beanName="${v3x:toHTML(bean.nameFamily)}"
			total="${bean.total}" value="<c:out value="${bean.id}"/>" <c:if test="${bean.id==param.id}" >checked</c:if> />
		</v3x:column>
		<v3x:column width="40%" type="String" onClick="modifyFamily('${bean.id}');"  onDblClick="modifyFamily('${bean.id}', 'edit');"
			label="common.name.label" className="cursor-hand sort" 
			property="nameFamily" alt="${v3x:toHTML(bean.nameFamily)}" maxLength="30">		
		</v3x:column>
		<v3x:column width="45%" type="String" onClick="modifyFamily('${bean.id}');" onDblClick="modifyFamily('${bean.id}', 'edit');"
			label="common.description.label" className="cursor-hand sort"
			 alt="${bean.remark}" maxLength="30"> 
             <c:out value="${v3x:getLimitLengthString(bean.remark, 72,'...')}" escapeXml="true"/>
		</v3x:column>
	</v3x:table>
	</div>
	</td>
</tr>
</table>
</form>
</body>
</html>
<script type="text/javascript">
<!--
var tout;
window.onload = function(){tout=setTimeout("init()",200);}
function init(){
   //判断页面是否加载完成
   if(document.readyState=='complete')
   {
        //停止定时器
       clearTimeout(tout);
        //你要做的事
       var bDivlistTablet=document.getElementById("bDivlistTable");
       if(bDivlistTable){
           bDivlistTable.style.height=bDivlistTable.clientHeight-60;
       } 
    }
}
//-->
</script>
