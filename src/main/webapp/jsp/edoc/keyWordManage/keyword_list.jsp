<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<%@include file="../edocHeader.jsp" %>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript">
			function showDetail(id,readonly){
				parent.detailFrame.window.location='${edocKeyWordUrl}?method=editKeyword&readOnly='+readonly+'&id='+id;
			}
		</script>
	</head>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
	<body>
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2 webfx-menu-bar" style="border-top:0;">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<script type="text/javascript">
				<!--
				//记录当前焦点是在左边（分类）还是右边（模板），用于删除和修改
				var currentSelected = null; 
				var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","${param.from=='TM'?'':'gray'}");
				myBar.add(new WebFXMenuButton("create", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", "add()", [1,2]));
				myBar.add(new WebFXMenuButton("update", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "modify()", [1,2]));
				myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "remove()", [1,3]));
				document.write(myBar);
				document.close();
		
				function add(){
					var parentId =0;
					if(parent.treeFrame.root.getSelected() && parent.treeFrame.root.getSelected().businessId!="root"){
						parentId = parent.treeFrame.root.getSelected().businessId;
					}
					parent.detailFrame.location.href="${edocKeyWordUrl}?method=addKeyword&parentId="+parentId;	
				}
				<%--修改--%>
				function modify(){
					var id = getSelectIds(parent.listFrame);
					if(id != ""){
						var ids = id.split(",");
						if(ids.length == 1){
						    parent.detailFrame.location.href='${edocKeyWordUrl}?method=editKeyword&readOnly=false&id='+ids[0];
						}else{
							alert(v3x.getMessage("edocLang.doc_keyword_alter_select_one"));
							return false;				
						}
					}else{
						alert("<fmt:message key="edoc.keyword.chosce.modify"/>");
						return false;
					}
				}
				<%--删除--%>
				function remove(){
					var ids = '';
					var checkBoxList = parent.listFrame.document.getElementsByName('id');
					for(var i = 0; i < checkBoxList.length; i++){
						var idCheckBox = checkBoxList[i];
						if(idCheckBox.checked){
							if(idCheckBox.hasChild == "true"){
								alert(v3x.getMessage("edocLang.doc_keyword_alter_hasChild"));
								return false;
							}else{
								if(ids == ''){
									ids = idCheckBox.value;
								}else{				
									ids += ','+idCheckBox.value;
								}
							}
						}
					}
		
					if(ids != "" && ids.length != 0){
						if(!confirm(v3x.getMessage("edocLang.edoc_confirmDeleteKeyword"))){
							return false;
						}
						//getA8Top().startProc(''); 
						var form1 = parent.listFrame.document.getElementById("mainForm");
						form1.action = "${edocKeyWordUrl}?method=delete&ids="+ids;
						form1.submit();
					}else{
						alert("<fmt:message key='edoc.keyword.delete'/>");
						return false;
					}
				}
				//-->
				</script>
		    </td>		
			</tr>   
		</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form name="mainForm" id="mainForm" method="post">
							<v3x:table data="keywordList" var="bean" htmlId="listTable" showHeader="true" showPager="true">
								<v3x:column width="7%" align="center" label="<input type='checkbox' onclick='selectAllValues(this, \"id\")'/>" className="cursor-hand sort">
									<input type='checkbox' id='id' name='id' hasChild ="${bean.hasChild}" value="<c:out value="${bean.id}"/>"  <c:if test="${bean.id==param.id}" >checked</c:if> />
								</v3x:column>
								<v3x:column width="10%" type="String" onClick="showDetail('${bean.id}', true);" onDblClick="showDetail('${bean.id}', false);" label="edoc.keyword.sortNum" className="cursor-hand sort">
									${bean.sortNum}
								</v3x:column>
								<v3x:column width="50%" type="String" onClick="showDetail('${bean.id}', true);" onDblClick="showDetail('${bean.id}', false);" label="edoc.keyword.name" className="cursor-hand sort mxtgrid_black" maxLength="30" symbol="..." alt="${bean.name}">
									${v3x:toHTML(bean.name) }
								</v3x:column>
								<v3x:column width="20%" type="String" onClick="showDetail('${bean.id}', true);" onDblClick="showDetail('${bean.id}', false);" label="edoc.keyword.createTime" className="cursor-hand sort"  maxLength="50" symbol="..." alt="${bean.createTime}">
									<span title="<fmt:formatDate value="${bean.createTime}"  pattern="${datePattern}"/>"><fmt:formatDate value="${bean.createTime}"  pattern="${datePattern}"/></span>&nbsp;
								</v3x:column>
								<v3x:column width="14%" type="String" onClick="showDetail('${bean.id}', true);" onDblClick="showDetail('${bean.id}', false);" label="edoc.keyword.createUserName" className="cursor-hand sort">
									<c:choose>
										<c:when test="${bean.createUserId == -1 || bean.createUserId == 0}">
											<span title="<fmt:message key='edoc.form.systemCreate' />"><fmt:message key="edoc.form.systemCreate" /></span>&nbsp;
										</c:when>
										<c:otherwise>
											<c:set var="createUserName" value="${v3x:showMemberName(bean.createUserId)}"></c:set>
											<span title="${createUserName}">${createUserName}</span>&nbsp;
										</c:otherwise>
									</c:choose>
								</v3x:column>
							</v3x:table>
		</form>
		    </div>
  </div>
</div>
		<script type="text/javascript">
			var isShow = parent.detailFrame.showDetail;
			if(typeof(isShow) == "undefined" || isShow || isShow == 'true'){	
				showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.edoc.keyword' bundle="${v3xMainI18N}"/>", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_4008"));
			}	
		</script>
	</body>
</html>

