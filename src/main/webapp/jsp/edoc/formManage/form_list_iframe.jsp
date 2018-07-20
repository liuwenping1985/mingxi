<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>    
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>

<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet"
	href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<script type="text/javascript">

	var isAccountAdmin=${isAccountAdmin};
	
		function deleteItem() {
		  var checkedIds = document.getElementsByName('id');

		  var len = checkedIds.length;
		  
		  var str = "";
		  var templateNames = "";
		  //不能删除的系统文单
		  var unDelCheckIds4Sys = new Array();
		  //不能删除文单，因为被使用
		  var unDelCheckIds4Reference = new Array();
		  //外单位授权的公文单不能删除
		  var unDelCheckIds4IsOuterAcl = new Array();
		  //模板绑定的文单不能删除
		  var unDelCheckIds4TemplateReference = new Array();
		  for(var i = 0; i < len; i++) {
		  		var checkedId = checkedIds[i];
				
				if(checkedId && checkedId.checked && checkedId.parentNode.parentNode.tagName == "TD"){			
					var checkedName = checkedId.getAttribute("formName");
					if(checkedId.getAttribute("isSystem") == 'true' || checkedId.getAttribute("isSystem") == true){
						unDelCheckIds4Sys.push(checkedId);
					}
					
			  		try{
			    		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocFormManager", "ajaxIsReferenced", false);
			    		requestCaller.addParameter(1, "String", checkedId.value);
			    		var ds = requestCaller.serviceRequest();
			    		if(ds == "TRUE"){
							unDelCheckIds4Reference.push(checkedId);
			    		}
			    	}catch(e){
			    	}
			    	try{
			    		var requestCaller = new XMLHttpRequestCaller(this, "templateManager", "getCtpTemplateBySummary", false);
			    		requestCaller.addParameter(1, "String", checkedId.value);
			    		var ds = requestCaller.serviceRequest();
			    		if(ds && ds.length>0){
			    			templateNames = templateNames + _("edocLang.form_reference_by_template",checkedName) + "\n";
			    			for(var j=0;j<ds.length;j++){
			    				templateNames = templateNames + ds[j] + "\n"; 
			    			}
			    			unDelCheckIds4TemplateReference.push(checkedId);
			    		}
			    	}catch(e){
			    		
			    	}
					if(checkedId.getAttribute("isOuterAcl") == 'true'  || checkedId.getAttribute("isOuterAcl") == true){
						unDelCheckIds4IsOuterAcl.push(checkedId);
					}
					str += checkedId.value;
					str +=","
				}
			}
		
			if(unDelCheckIds4Sys.length>0){
				alert(_("edocLang.edoc_form_system_change_forbidden"));
				for(var j=0;j<unDelCheckIds4Sys.length;j++){
					var tempCheckedId = unDelCheckIds4Sys[j];
					tempCheckedId.checked = false;
				}
				return;
			}
			else if(unDelCheckIds4Reference.length>0){
				alert(_("edocLang.edoc_form_referenced"));
				for(var m=0;m<unDelCheckIds4Reference.length;m++){
					var tempCheckedId = unDelCheckIds4Reference[m];
					tempCheckedId.checked = false;
				}
    			return;
			}else if(unDelCheckIds4TemplateReference.length>0){
				alert(templateNames);
				for(var m=0;m<unDelCheckIds4TemplateReference.length;m++){
					var tempCheckedId = unDelCheckIds4TemplateReference[m];
					tempCheckedId.checked = false;
				}
				return;
			}else if(unDelCheckIds4IsOuterAcl.length>0){
				alert(_("edocLang.edoc_form_outeracl"));
				for(var m=0;m<unDelCheckIds4IsOuterAcl.length;m++){
					var tempCheckedId = unDelCheckIds4IsOuterAcl[m];
					tempCheckedId.checked = false;
				}
    			return;
			}
			
		 //-- justify is any id has been chose.
		  
		  if(str==null || str==""){
		  	alert(_("edocLang.edoc_alertSelOneEdocForm"));
		  	return false;
		  }

		 //-- justification end.	
		 	
			str = str.substring(0,str.length-1);
			
			if(window.confirm(_("edocLang.edoc_form_deleteAlert"))){
			
				document.location.href='${edocForm}?method=delete&id='+str;
			}
		}

	function newForm(type){
		parent.detailFrame.window.location.href='${edocForm}?method=newForm&type='+type;
	}

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
	

	var formTypeMenu = new WebFXMenu;
		<c:if test="${v3x:hasPlugin('edoc')}">
			formTypeMenu.add(new WebFXMenuItem("sendType", "<fmt:message key='edoc.formstyle.dispatch' />", "newForm('0');"));
			formTypeMenu.add(new WebFXMenuItem("recType", "<fmt:message key='edoc.formstyle.receipt' />", "newForm('1');"));
		</c:if>
		formTypeMenu.add(new WebFXMenuItem("signType", "<fmt:message key='edoc.formstyle.qianbao' />", "newForm('2');"));

	myBar.add(
		new WebFXMenuButton(
			"formTypeMenu", 
			"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />",  
			null, 
			[1,1],
			"", 
			formTypeMenu
			)
	);
	
		myBar.add(new WebFXMenuButton("edit", 
		"<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", 
		"editOneLine();", [1,2], 
		"", null));
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
			"deleteItem();", 
			[1,3],
			"", 
			null
			)
	);
		<c:if test ="${isGroupVer}">
				myBar.add(
					new WebFXMenuButton(
						"auth", 
						"<fmt:message key='common.toolbar.auth.label' bundle='${v3xCommonI18N}' />",
						"authEdocForm();",
						[2,2],
						"",
						null)
				 );
	 	</c:if>
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='edoc.form.defaultform.set' />", 
			"setToDefault();", 
			[2,3],
			"", 
			null
			)
	);
	
	baseUrl='${edocForm}?method=';
	
	function editPlan(id,isSystem){
		//if(isSystem == true || isSystem == 'true'){
		//		alert(_("edocLang.edoc_form_system_change_forbidden"));
		//		return;			
		//}
		parent.detailFrame.window.location='${edocForm}?method=edit&id='+id;
}
	function showByStatus(){
		window.document.searchForm.submit();
	}
	
	function editOneLine(){
		var chkid = document.getElementsByName('id');
		var count = 0;
		var id = "";
		var isSystem;
		for(var i = 0; i < chkid.length; i++){
			if(chkid[i].checked){
				if(chkid[i].getAttribute("isSystem") == true || chkid[i].getAttribute("isSystem") == 'true'){
					//alert(_("edocLang.edoc_form_system_change_forbidden"));
					//return;
					isSystem = true;
				}
				count++;
				id = chkid[i].value;			
				
			}
		}
		
	
	if(count == 0){
		alert(v3x.getMessage('edocLang.edoc_alertSelOneEdocForm'));
		return false;
	}else if(count > 1){
		alert(v3x.getMessage('edocLang.edoc_alertSelOneEdocForm_Only'));
		return false;
	}
	if(isSystem){
		parent.detailFrame.window.location='${edocForm}?method=edit&id='+id+'&isSystem=true';	
	}
	else{
		parent.detailFrame.window.location='${edocForm}?method=edit&id='+id;
	}

}

	function singleClick(id){

		parent.detailFrame.window.location='${edocForm}?method=edit&flag=readonly&id='+id;
	}

//设置默认公文单
function setToDefault(){
	var chkid = document.getElementsByName('id');
	var count = 0;
	var statusId ="";
	for(var i = 0; i < chkid.length; i++){
		if(chkid[i].checked){
			count++;
			statusId = chkid[i].getAttribute("statusId");			
		}
	}
	
	if(count == 0){
		alert(v3x.getMessage('edocLang.edoc_alertSelOneEdocForm'));
		return false;
	}else if(count > 1){
		alert(v3x.getMessage('edocLang.edoc_alertSelOneEdocForm_Only'));
		return false;
	}
	try{
   		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocFormManager", "ajaxCheckFormIsIdealy", false);
   		requestCaller.addParameter(1, "String", statusId);
   		requestCaller.addParameter(2, "String", "");
   		requestCaller.addParameter(3, "String", "param2");    		    		
   		var ds = requestCaller.serviceRequest();
   		if(ds == "false"){
   			alert(v3x.getMessage("edocLang.edoc_document_enabled"));
   			return;
   		}
   	}catch(e){
		//...
   	}
	parent.detailFrame.window.location='${edocForm}?method=setDefaultForm&statusId='+statusId;			
}
function submitAuth(elements){
	if(elements){
		document.getElementById("auth").value = getIdsString(elements);
		var listForm = document.getElementsByName("listForm")[0];
		if(listForm){
			listForm.action ="${edocForm}?method=doAuthEdocForm&auth="+getIdsString(elements);
			listForm.method = "post";
			listForm.target = "_self";
			listForm.submit();
		}
	}
}

function authEdocForm(){
	var ids = document.getElementsByName("id");
	var hasSelected = false;
	var hasSelectedSystem =false;
	var hasOuterAcl = false; //选中的公文单中是否有外单位授权的公文单
	var authIds = "";	
	if(ids) {
		var idChecked = [];
		var k = 0;
		for(var i=0; i<ids.length ; i++){
			if(ids[i].checked){
				hasSelected = true;	
				if(ids[i].getAttribute("isSystem") == 'true'){
					hasSelectedSystem = true;
				}	
				if(ids[i].getAttribute("isOuterAcl") == 'true'){
					hasOuterAcl = true;
				}
				idChecked[k++] = ids[i];
			}
		}
		if(idChecked.length == 1) {//当选择一个公文单时，授权单位回填
			authIds = idChecked[0].getAttribute("authIds");
			if(authIds != "") {
				elements_auth = parseElements(authIds);
			}
		} else {
			elements_auth = new Array();
		}	
	}
	if(hasSelectedSystem){
		for(var i=0; i<ids.length ; i++){
			if(ids[i].getAttribute("isSystem") == 'true'){
				ids[i].checked = false;
			}
		}
		alert(_("edocLang.edoc_alertNotModifySystemAuth"));
		return false;
	}

	if(hasOuterAcl){
		var count = 0 ;
		for(var i=0; i<ids.length ; i++){
			if(ids[i].getAttribute("isOuterAcl") == 'true'){
				ids[i].checked = false;
			}else if(ids[i].checked == true){
				count++;
			}
		}
		if(count>0){
			if(!confirm(_("edocLang.edoc_confirmAuthOtherForm")) )
				return false ;
		}else{
			alert(_("edocLang.edoc_alertNotModifyOuter"));
			return false;
		}
		
	}
	if(!hasSelected){
		alert(_("edocLang.edoc_alertSelectEdocForm"));
		return false;
	}
	selectPeopleFun_auth();
}
</script>
</head>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<body >
<v3x:selectPeople id="auth" panels="Account" selectType="Account" jsFunction="submitAuth(elements)" minSize="0"/>

<input type="hidden" name=auth id="auth" value="">
<div class="main_div_row2">
  <div class="right_div_row2">
    
    <div class="top_div_row2 webfx-menu-bar">
		<table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
			<script type="text/javascript">
				document.write(myBar);	
				document.close();
			</script>
			
				</td>
				
				<td><form action="" name="searchForm" id="searchForm" onkeypress="doSearchEnter()" method="get" onsubmit="return false">
				<input type="hidden" value="<c:out value='${param.method}' />" name="method">
				<div class="div-float-right">
						<div class="div-float">
							<select name="condition" id="condition" onChange="showNextSpecialCondition(this)" class="condition" style="width:90px">
						    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							    
							    <option value="name"><fmt:message key="edoc.form.name" /></option>
							    <option value="sort"><fmt:message key="edoc.form.sort" /></option>
							    <option value="status"><fmt:message key="edoc.form.status" /></option>
						  	</select>
					  	</div>
					  	
					  	<div id="nameDiv" class="div-float hidden"><input type="text" name="textfield" style="height:14px;" class="textfield"></div>
					  	<div id="sortDiv" class="div-float hidden">
					  	<select name="textfield" class="condition" style="width:90px">
							<option value="0"><fmt:message key="edoc.formstyle.dispatch" />	</option>
				  			<option value="1"><fmt:message key="edoc.formstyle.receipt" />	</option>	
				  			<option value="2"><fmt:message key="edoc.formstyle.qianbao" />	</option>	
				  		</select>		
					  	
					  	</div>
						<div id="statusDiv" class="div-float hidden">
						<select name="textfield" class="condition" style="width:90px">
							<option value="1"><fmt:message key="edoc.element.enabled" />	</option>
				  			<option value="0"><fmt:message key="edoc.element.disabled" />	</option>	
				  		</select>			
						
						</div>
						<div onclick="javascript:doSearch()" class=" div-float condition-search-button"></div>
				</div>
				</form>
				</td>
				
			</tr>
		</table>
    
    </div>
    <div class="center_div_row2" id="scrollListDiv">
<form name="listForm">
<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true" className="sort ellipsis">
	<c:set value="${v3x:showOrgEntitiesOfIds(bean.aclIds, 'Account',  pageContext)}" var="authinfo"/>
	<c:set value="${v3x:parseElementsOfIds(bean.aclIds, 'Account')}" var="authIds"/>
	<v3x:column width="5%" align="center"
		label="<input type='checkbox' onclick='selectAllValues(this, \"id\")'/>" className="cursor-hand sort">
		<input type='checkbox' name='id' isOuterAcl="${bean.isOuterAcl}" formName="${v3x:toHTML(bean.name)}" statusId="${bean.statusId}" isSystem='${bean.isSystem}' authIds="${authIds }" value="<c:out value="${bean.id}"/>"  <c:if test="${bean.id==param.id}" >checked</c:if> />
	</v3x:column>
	<v3x:column width="24%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}','${bean.isSystem}');"
		label="edoc.form.name" className="cursor-hand sort mxtgrid_black">
		${v3x:toHTML(bean.name)}
	</v3x:column>	
	<v3x:column width="15%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}','${bean.isSystem}');"
		label="edoc.form.sort" className="cursor-hand sort">
		<c:choose>
			<c:when test="${bean.type==0}">
				<fmt:message key="edoc.formstyle.dispatch" />
			</c:when>
			<c:when test="${bean.type==1}">
				<fmt:message key="edoc.formstyle.receipt" />
			</c:when>
			<c:when test="${bean.type==2}">
				<fmt:message key="edoc.formstyle.qianbao" />
			</c:when>
			<c:otherwise>
				<fmt:message key="edoc.formstyle.dispatch" />
			</c:otherwise>
		</c:choose>
	</v3x:column>

		<v3x:column width="15%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}','${bean.isSystem}');"
		label="edoc.form.defaultform" className="cursor-hand sort">
		<c:choose>
			<c:when test="${bean.isDefault==true}">
				<fmt:message key="edoc.form.yes" />
			</c:when>
			<c:when test="${bean.isDefault==false}">
				<fmt:message key="edoc.form.no" />
			</c:when>
			<c:otherwise>
				<fmt:message key="edoc.form.no" />
			</c:otherwise>
		</c:choose>
	</v3x:column>
	<c:if test="${v3x:getSystemProperty('edoc.hasEdocCategory')!='false'}">
	<v3x:column width="13%" type="String"  onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}','${bean.isSystem}');"
		label="edoc.category.send" className="cursor-hand sort" value="${bean.subTypeName}"/>
	</c:if>
	<%--不是企业版本才显示授权 --%>
	<c:if test ="${ctp:getSystemProperty('system.ProductId')!=0 &&ctp:getSystemProperty('system.ProductId')!=1 && ctp:getSystemProperty('system.ProductId') != 3 &&ctp:getSystemProperty('system.ProductId')!=7}">
	<v3x:column width="20%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}','${bean.isSystem}');"
		label="edoc.doctemplate.grant" className="cursor-hand sort" value="${authinfo}" />
	</c:if>
	<v3x:column width="8%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}','${bean.isSystem}');"
		label="edoc.form.status" className="cursor-hand sort">
		<c:choose>
 			<c:when test="${bean.status==0}">
 				<fmt:message key="edoc.element.disabled" />	
 			</c:when>
  			<c:when test="${bean.status==1}">
 				<fmt:message key="edoc.element.enabled" />	
 			</c:when>
 			<c:otherwise>
 				 <fmt:message key="edoc.element.disabled" />
 			</c:otherwise>
 		</c:choose>
	</v3x:column>
	<c:set value="" var="systemCreate"/>
	<v3x:column width="12%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}','${bean.isSystem}');"
		label="edoc.form.createaccount" className="cursor-hand sort">
		<c:choose>
			<c:when test="${bean.isSystem}"> 
				<fmt:message key="edoc.form.systemCreate" />
			</c:when>
			<c:otherwise>
				${bean.domainName}			
			</c:otherwise>
		</c:choose>
	</v3x:column>
</v3x:table>
</form>
</div>
  </div>
</div>

<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.edoc.doc.Form' bundle="${v3xMainI18N}"/>", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_4004"));	
initIpadScroll("scrollListDiv",550,870);
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>
</body>
</html>