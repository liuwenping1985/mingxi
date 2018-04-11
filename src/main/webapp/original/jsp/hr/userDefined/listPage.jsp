<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>    
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	//getA8Top().showLocation(1207, "<fmt:message key='hr.userDefined.page.set.label' bundle='${v3xHRI18N}'/>");
</script>
<script type="text/javascript">
var	spaceTypeMap = new Properties();
	function newPage(){
		parent.detailFrame.location.href = "${hrUserDefined}?method=viewPage&settingType=${param.settingType}";
	}
	
	function viewPage(id){
		parent.detailFrame.location.href = "${hrUserDefined}?method=viewPage&page_id="+id+"&settingType=${param.settingType}&readonly=true";
	}
	
	function delPage(){
		if(checkSelectedOne(this)){
			alert(v3x.getMessage("HRLang.hr_userDefined_data_choose_message"));
			return false;
		}
		
		var pIds = getSelectIds(this);

		if(!confirm(v3x.getMessage("HRLang.hr_staffInfo_is_delete"))){
			return false;
		}

		parent.listFrame.location.href = "${hrUserDefined}?method=destroyPage&pIds="+pIds+"&save=0"+"&settingType=${param.settingType}";
	}
	
	function modify(){
		if(checkSelectedId(this)){
			alert(v3x.getMessage("HRLang.hr_userDefined_data_choose_message"));
			return false;
		}
		var id = getSelectIds(this);
		parent.detailFrame.location.href = "${hrUserDefined}?method=viewPage&page_id="+id+"&settingType=${param.settingType}&readonly=false";
	}
	
	function getId(frame){
		var ids=frame.document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=idCheckBox.value;
			}
		}
		return id;
	}
	
	function pageOrder(){
        getA8Top().hrUserDefinedOrderWin = getA8Top().$.dialog({
            title:"<fmt:message key='common.toolbar.order.label' bundle='${v3xCommonI18N}'/>",
            transParams:{'parentWin':window},
            url: "${hrUserDefined}?method=pageOrder&random="+ Math.random(),
            width: 350,
            height: 317,
            isDrag:false
       });
	}
	
	function pageOrderCollBack (rv) {
		getA8Top().hrUserDefinedOrderWin.close();
		if(rv){
            var theForm = document.forms[0];
            var item="";
            for(var i = 0; i < rv.length; i ++){
                item+=rv[i]+"=" ;
            }
            theForm.action = "${hrUserDefined}?method=saveOrder&pageIds="+item;
            theForm.method = "post";
            theForm.target = "_self";
            theForm.submit();
        }
	}
</script>
</head>
<body class="listPadding">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td height="22">
		<script>	
			var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
			
			myBar1.add(new WebFXMenuButton("new", "<fmt:message key='hr.toolbar.salaryinfo.new.label' bundle='${v3xHRI18N}' />",  "newPage()", [1,1]));
			myBar1.add(new WebFXMenuButton("modify", "<fmt:message key='hr.staffInfo.modify.label' bundle='${v3xHRI18N}' />", "modify()", [1,2]), "", null);
			myBar1.add(new WebFXMenuButton("delete", "<fmt:message key='hr.toolbar.salaryinfo.delete.label' bundle='${v3xHRI18N}' />", "delPage()", [1,3]), "",null );

			<c:if test="${v3x:isRole('SalaryAdmin', v3x:currentUser())}">
				myBar1.add(new WebFXMenuButton("order", "<fmt:message key='common.toolbar.order.label' bundle='${v3xCommonI18N}' />", "pageOrder()", [8,9]), "", null);
			</c:if>
			
			document.write(myBar1);
			document.close();
		</script>
	</td></tr>
	<tr>
		<td>
			<div class="scrollList">
				<form id="salaryform" method="post">
					<v3x:table data="${pages}" var="page" leastSize="${leastSize }" htmlId="salarylist" subHeight="30">
						<c:set var="click" value="viewPage('${page.page_id}')"/>
						<c:set var="Dclick" value="modify('${page.page_id}')"/>
						<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
							<input type="checkbox" name="id" value="${page.page_id}">
							<script type="text/javascript">
								spaceTypeMap.put('${page.page_id}','${page.property_id}');					
							</script>
						</v3x:column>
						<v3x:column width="25%" label="hr.userDefined.page.name.label" type="String" onDblClick="${Dclick}" value="${page.pageName}" onClick="${click}" className="cursor-hand sort" symbol="..." alt="${page.pageName}" maxLength="18" />
						<v3x:column width="25%" label="hr.userDefined.name.english.label" type="String" onDblClick="${Dclick}" value="${page.labelName_en}" onClick="${click}" className="cursor-hand sort" symbol="..." alt="${page.labelName_en}" maxLength="18" />
						<v3x:column width="15%" label="hr.userDefined.page.isDisplay.label" type="String" onDblClick="${Dclick}" onClick="${click}" className="cursor-hand sort" symbol="...">
							<fmt:message key="${page.display}"/>
						</v3x:column>
						<v3x:column width="15%" label="hr.userDefined.page.belong.label" type="String" onDblClick="${Dclick}" onClick="${click}" className="cursor-hand sort" symbol="...">
							<fmt:message key="${page.modelName}" bundle="${v3xMainI18N}"/>
						</v3x:column>
						<fmt:message key='common.attribute.isSystem.${page.sysFlag}' bundle='${v3xCommonI18N}' var="attribute_label"/>
						<v3x:column width="15%" label="common.attribute.label" type="String" onDblClick="${Dclick}" value="${attribute_label}" onClick="${click}" className="cursor-hand sort" symbol="..." alt="${attribute_label}" maxLength="90" />
					</v3x:table>
				</form>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
    showDetailPageBaseInfo("detailFrame",  "   "+"<fmt:message key='hr.userDefined.page.set.label' bundle='${v3xHRI18N}'/>", [2,4], pageQueryMap.get('count'),  v3x.getMessage("HRLang.detail_hr_120702"));
</script>
</body>
</html>