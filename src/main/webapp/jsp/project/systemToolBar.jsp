<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="projectHeader.jsp"%>

<script type="text/javascript">
<!--
function NewHTTPCall()
{
   var xmlhttp;
   try{
     xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
     return xmlhttp;
   }
   catch (e)
   {
     return null;
   }
}

function init(aUrl)
{
  var httpCall = NewHTTPCall();
  var nowresult;
  if (httpCall ==  null){
    alert(v3x.getMessage("ProjectLang.formdisplay_nonsupportXMLHttp"));
    return null;
  }
	httpCall.open('GET', aUrl + "&" + Math.random(), false);  
	httpCall.onreadystatechange = function() {
  	if (httpCall.readyState != 4)
       
    	return;
  	nowresult = httpCall.responseText;
  	if (nowresult == "")
  		throw ""+v3x.getMessage("ProjectLang.formdisplay_loaderror")+"";	  				   
  };
  httpCall.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
  httpCall.send(null);
  return nowresult;
	
}

function endDeleteCategory(flag){
	if(flag == true){
		parent.systemTreeFrame.tree.getSelected().remove();		
	}
	else{
		alert(_("ProjectLang.project_nodelete_confirm"));
	}
}


function doAction(atctionType){
	var selected = parent.systemTreeFrame.tree.getSelected();
	
	var selectId = "";
	var selectName = "";
	
	if(selected){
		selectId = selected.businessId;
		selectName = selected.text;
	}
	else{
		parent.systemTreeFrame.tree.select();
		selectName = parent.templeteTreeFrame.tree.getSelected().text;
	}
	var ht = 240;
	if ($.browser.msie) {
		if (navigator.appVersion.indexOf("MSIE 8.0") > 0 ||
			navigator.appVersion.indexOf("MSIE 7.0") > 0) {
			ht = 270;
		}
	}
	if(atctionType == 'new'){
		var result = v3x.openWindow({
			url : "${basicURL}?method=doActionProjectType",
			width : 450,
			height : ht
		});
	if(result){
		//注释掉的都是错代码，一直有问题，现在直接强制刷新就可以了。
		//var id =result[0];
		//var name = result[1].escapeHTML();
		//var newParent = parent.systemTreeFrame.webFXTreeHandler.all[parent.systemTreeFrame.webFXTreeHandler.getIdByBusinessId(id)];
		//if(newParent){
				//newParent.addWebFXTreeItem(id, name);
				//parent.detaliFrame.location.href = "${basicURL}?method=showDetali" ;
		//	}
		//	else{
		parent.detaliFrame.location.href = "${basicURL}?method=showDetali" ;
		parent.systemTreeFrame.location.reload();
		//	}
		}
	}else  if(atctionType == 'modify'){
		if(selectId==""){
			 alert((v3x.getMessage("ProjectLang.project_type_modify")));
		  	return;
		}
		var result = v3x.openWindow({
			url : "${basicURL}?method=doActionProjectType&id="+selectId,
			width : 450,
			height : ht
		});
		if(result){
			parent.systemTreeFrame.location.reload();
			parent.detaliFrame.location.reload();
			parent.disabledMyBar("modify");
			parent.disabledMyBar("delete");
			parent.disabledMyBar("modifyLeader");
		}
		
	}else if(atctionType == 'delete'){
		if(selectId==""){
			 alert((v3x.getMessage("ProjectLang.project_type_delete")));
		  	return;
		}
		 var dataUrl = v3x.baseURL + encodeURI(encodeURI("/project.do?method=judgeProjectTypeIsContainProjectSummary&id=" + selectId));
		 var str = init(dataUrl);
		 
		   if(str == "true"){
			  alert(v3x.getMessage("ProjectLang.project_nodelete_confirm")); 
			  return;
		  }	   	
		 else{
			if(window.confirm(_("ProjectLang.project_delete_confirm"))){
			    var deleteurl = v3x.baseURL + encodeURI(encodeURI("/project.do?method=deleteProjectType&id=" + selectId));
			    var str = init(deleteurl);
				parent.systemTreeFrame.location.reload();
				parent.disabledMyBar("modify");
				parent.disabledMyBar("delete");
				parent.disabledMyBar("modifyLeader");
			}  		  
		 }
		 
	}
	}
	
	 function modifyLeader(){
		var ownerid = document.all("ownerid");
	    ownerid.value="";
		try{
			selectId = parent.detaliFrame.listFrame.document.getElementsByName("projectTypeId");
		}catch(e){}
		if(selectId != '0'){
			var count = 0;
			var formappids = "";
			var ElementsObject= parent.detaliFrame.listFrame.document.getElementsByName("id");
			if(ElementsObject){
				for(var j = 0;j<ElementsObject.length;j++){
			    if (ElementsObject[j].checked == true){
		              id = ElementsObject[j].value;
		              formappids += id+","; 
		              count++;                
		          }
				}
			}		
		}else{
			alert(v3x.getMessage("ProjectLang.please_choose_one_data"));
	   		return;		
		}

		if(count==0){
			alert(v3x.getMessage("ProjectLang.please_choose_one_data"));
	   		return;
		}
		if(count>1) {
			alert(v3x.getMessage("ProjectLang.please_choose_one_data"));
	   		return;		   
		}
		if(parent.detaliFrame.listFrame.stateMap.get(id)==2||parent.detaliFrame.listFrame.stateMap.get(id)==3){
			alert(v3x.getMessage("ProjectLang.project_can_not_edit"));
			return;
		}
		 parent.disabledMyBar("new");
		 parent.disabledMyBar("modify");
		 parent.disabledMyBar("delete");
		 parent.detaliFrame.detailFrame.location.href = "${basicURL}?method=getProject&projectId="+id+"&readonly=0";
		
		}
//-->
</script>
<script type="text/javascript">
	onlyLoginAccount_projectManager = true;

	function doSearch(){
		if(!!!parent.systemTreeFrame.tree){
			return;
		}
		var selected = parent.systemTreeFrame.tree.getSelected();
		if(selected && selected.businessId != '0'){
			var condition = $("#condition").val();
			var textfield = "";
			var textfield1 = "";
			if(condition == "projectName"){
				textfield = $("#projectName").val();
			}else if(condition == "projectNumber"){
                textfield = $("#projectNumber").val();
            }else if(condition == "projectManager"){
				textfield = $("#projectManagerName").val();
			}else if(condition == "projectDate"){
				textfield = $("#begintime").val();
				textfield1 = $("#closetime").val();
				var beginTimeStrs = textfield.split("-");
				var beginTimeDate = new Date();
				beginTimeDate.setFullYear(beginTimeStrs[0],beginTimeStrs[1]-1,beginTimeStrs[2]);
				var endTimeStrs = textfield1.split("-");
				var endTimeDate = new Date();
				endTimeDate.setFullYear(endTimeStrs[0],endTimeStrs[1]-1,endTimeStrs[2]);
				if(endTimeDate<beginTimeDate){
					window.alert(v3x.getMessage("ProjectLang.startdate_cannot_late_than_enddate"));
					$("#closetime").val(textfield);
					return;
				}
			}else if(condition == "projectState"){
				textfield = $("#projectState").val();
			}
			parent.detaliFrame.location.href = "${basicURL}?method=showListFrame&typeName=" + encodeURIComponent(selected.text) + "&projectTypeId=" + selected.businessId + "&condition=" + condition + "&textfield=" + textfield + "&textfield1=" + textfield1;
		}else{
			return;
		}
	}

	function doSearchEnter(){
		if(event.keyCode == 13){
	    	doSearch();
	    }
	}
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<input type="hidden" name="ownerid">
		<td height="22">
			<script type="text/javascript">
				var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","");
				myBar.add(new WebFXMenuButton("new","<fmt:message key="project.toolbar.newtype.label"/>","doAction('new')",[1,1], "<fmt:message key="project.toolbar.newtype.label"/>",null));
				myBar.add(new WebFXMenuButton("modify","<fmt:message key="project.toolbar.modifytype.label" />","doAction('modify')",[1,2],"<fmt:message key="project.toolbar.modifytype.label" />", null));
				myBar.add(new WebFXMenuButton("delete","<fmt:message key="project.toolbar.deletetype.label" />","doAction('delete')",[1,3],"<fmt:message key="project.toolbar.deletetype.label" />", null));
				myBar.add(new WebFXMenuButton("modifyLeader","<fmt:message key="project.toolbar.modifyprojectleader.label" />","modifyLeader()",[1,4],"<fmt:message key="project.toolbar.modifyprojectleader.label" />", null));
				
				document.write(myBar);
				document.close();
				parent.toolbar = myBar;
				parent.disabledMyBar("modify");
				parent.disabledMyBar("delete");
				parent.disabledMyBar("modifyLeader");
			</script>
		</td>
		<td height="22" class="webfx-menu-bar">
			<form action="" name="searchForm" id="searchForm" method="post" style="margin: 0px" onkeydown="doSearchEnter()">
				<div class="div-float-right">
					<div class="div-float">
						<select id="condition" name="condition" onChange="showNextCondition(this)" class="condition">
					    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						    <option value="projectName"><fmt:message key="project.body.projectName.label" /></option>
                            <option value="projectNumber"><fmt:message key="project.body.projectNum.label" /></option>
							<option value="projectManager"><fmt:message key="project.body.responsible.label" /></option>
							<option value="projectDate"><fmt:message key="project.body.search.projecttime" /></option>
							<option value="projectState"><fmt:message key="project.body.state.label" /></option>
					  	</select>
				  	</div>
				  	
				  	<div id="projectNameDiv" class="div-float hidden"><input type="text" id="projectName" name="textfield" class="textfield" maxlength="100"></div>
				  	
                    <div id="projectNumberDiv" class="div-float hidden">
                        <input type="text" id="projectNumber" name="textfield" class="textfield" maxlength="50"/>
                    </div>
                    
				  	<div id="projectManagerDiv" class="div-float hidden">
						<input type="text" name="textfield" id="projectManagerName" class="textfield" />
					</div>
					
				  	<div id="projectDateDiv" class="div-float hidden">
				  		<input type="text" name="textfield" id="begintime" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
				  		-
				  		<input type="text" name="textfield1" id="closetime" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
				  	</div>
				  	
				  	<div id="projectStateDiv" class="div-float hidden">
				  		<select id="projectState" name="textfield" class="textfield">
				  			<option value="0"><fmt:message key="project.body.projectstate.0" /></option>
				  			<option value="2"><fmt:message key="project.body.projectstate.2" /></option>
				  		</select>	
				  	</div>
					
					<div onclick="javascript:doSearch()" class="div-float condition-search-button"></div>
				</div>
			</form>
		</td>
	</tr>
</table>
</body>
</html>