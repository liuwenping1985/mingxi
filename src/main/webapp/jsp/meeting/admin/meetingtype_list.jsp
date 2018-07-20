<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title></title>
		<%@ include file="../include/taglib.jsp"%>
		<%@ include file="../include/header.jsp" %> 
		<fmt:setBundle basename="com.seeyon.v3x.office.admin.resources.i18n.AdminResources" var="v3xAdminI18N"/>
		<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
		
		<script type="text/javascript">
		showCtpLocation("F03_meetingDataBase");
			</script>
		 
		<script type="text/javascript">
			function doModify(){
				var id = checkSelectOne(document.listForm);
				
				if(id == ""){
					alert("请选择要修改的会议分类！");
					return false;
				}
				if(id == "false"){
					alert("一次只能修改一条会议分类！");
					return false;
				}
				parent.detailFrame.location = "${mtAdminController}?method=findMeetingType&id="+id;
			}
			function checkSelectOne(formNode){
				var id = "";
				var ns = formNode.getElementsByTagName("input");
				for(var i = 0; i < ns.length; i++){
					if(ns[i].type == "checkbox" && ns[i].name == "id" && ns[i].checked){
						if(id == ""){
							id = ns[i].value;
						}else{
							return "false";
						}
					}
				}
				return id;
			}

			function doDelete(){
				var id = checkSelect(document.listForm);
				var ns = document.getElementsByTagName("input");
				if(id == ""){
					alert("请选择要删除的会议分类");
					return false;
				}
				for(var i = 0; i < ns.length; i++){
					if(ns[i].type == "checkbox" && ns[i].name == "id" && ns[i].checked){
						if(ns[i].state==1){
							alert("启用状态的会议分类不允许删除！");
							return;
						}
					}
				}	
				if(confirm("你确定要删除吗？")){
					document.listForm.action = "${mtAdminController}?method=delMeetingType";
					document.listForm.submit();
				}
			}	

			function checkSelect(formNode){
				var ns = formNode.getElementsByTagName("input");
				for(var i = 0; i < ns.length; i++){
					if(ns[i].type == "checkbox" && ns[i].name == "id" && ns[i].checked){
						return ns[i].value;
					}
				}
				return "";
			}
			
			function showDetail(id){
				parent.detailFrame.location = "${mtAdminController}?method=findMeetingType&id="+id+"&readOnly=true";
			}
			function createFormType(){
				parent.detailFrame.location = "${mtAdminController}?method=findMeetingType";
			}
		</script>
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
	</head>
	<body srcoll="no" style="overflow: hidden" style="padding: 0px" onunload="UnLoad_detailFrameDown()">
	<div class="main_div_row2">
  		<div class="right_div_row2">
    		     <div class="top_div_row2">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   		<tr>
				<td class="webfx-menu-bar">
	   				<script type="text/javascript">
	   					var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
	   					myBar.add(new WebFXMenuButton("create", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>", "createFormType()", [1,1]));
	   					myBar.add(new WebFXMenuButton("edit", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}'/>", "doModify()", [1,2]));
	   					myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>", "doDelete()", [1,3]));
	   					document.write(myBar);
					    document.close();
	   				</script>
	   			</td>
	   			
	        	<td class="webfx-menu-bar">
		           <form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
		           <input type="hidden" value="<c:out value='${param.method}' />" name="method">
		             <div class="div-float-right condition-search-div">
		                 <div class="div-float">
			               <select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
				             <option value="">--<fmt:message key="admin.meetingtype.selectCondition.label" />--</option>
					         <option value="name"><fmt:message key="admin.meetingCategory.name.label" /></option>
					         <%--xiangfan 屏蔽创建人查询条件 GOV-3951
					         <option value="createUser"><fmt:message key="admin.meetingtype.createuser.label" /></option>
					          --%>
					         <option value="state"><fmt:message key="admin.meetingCategory.state.label" /></option>
			               </select>
			             </div>

			             <div id="nameDiv" class="div-float hidden">
				            <input type="text" name="textfield" id="textfield" class="textfield">
			             </div>
						<%--
		                <div id="createUserDiv" class="div-float hidden">
		                 <input type="text" name="textfield" class="textfield">
		               </div>
		              --%>
			             <div id="stateDiv" class="div-float hidden">
			                <select name="textfield" id="textfield" class="textfield">           
					             <option value="1"><fmt:message key="admin.meetingtype.enabled.label" /></option>
					             <option value="0"><fmt:message key="admin.meetingtype.disable.label" /></option>
			                </select>
			             </div>
		             <div onclick="javascript:doSearch()" class="condition-search-button div-float"></div>
		         </div>
		        </form>
		       </td>
	   		</tr>
	   		</table>
             </div>
    <div class="center_div_row2" id="scrollListDiv">
    <form name="listForm" id="listForm" method="post" style="margin: 0px">
    
   <v3x:table htmlId="listTable" data="meetingType" var="bean" pageSize="${pageSize}" size="${size}" showHeader="true" showPager="true" isChangeTRColor="true">  
		<v3x:column width="4%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' value="<c:out value='${bean.id }'/>" state="${bean.state}" />
		</v3x:column>
		<v3x:column width="20%" type="String" label="admin.meetingCategory.name.label" onClick="showDetail('${bean.id }')" 
			className="cursor-hand sort" alt="${bean.name }">
			<c:out value="${bean.name }" />
		</v3x:column>
		<v3x:column width="20%" type="String" label="admin.meetingCategory.state.label" onClick="showDetail('${bean.id }')" 
			className="cursor-hand sort" alt="">
			<c:choose>
				<c:when test="${bean.state==1}">
					<fmt:message key="admin.meetingtype.enabled.label" />                     
				</c:when>
				<c:otherwise>
					<fmt:message key="admin.meetingtype.disable.label" />
				</c:otherwise>
			</c:choose>
			
		</v3x:column>
		<v3x:column width="50%" type="String" label="admin.meetingtype.content.label" onClick="showDetail('${bean.id }')" 
			className="cursor-hand sort" alt="${bean.content }">
			<c:out value="${bean.content }" />
			
		</v3x:column>
	</v3x:table>
	</form>
</div>
  </div>
</div>
	   	 	
<script type="text/javascript">
initIpadScroll("scrollListDiv",550,870);
showDetailPageBaseInfo("detailFrame", "<fmt:message key="mt.mtMeeting.classification.label" />", [2,3], pageQueryMap.get('count'), _("meetingLang.detail_info_meetingType_application"));	
showCondition("${v3x:escapeJavascript(param.condition)}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>

	</body>
</html>